//! Outer aggregation of recursive2 proofs: registration and verification of worker proofs,
//! and the aggregation pipelines that fold them into the final proof.

use std::path::{Path, PathBuf};
use std::sync::atomic::Ordering;
use std::sync::Arc;
use std::fs;

use crossbeam_channel::{unbounded, Receiver, Sender};
use fields::{ExtensionField, GoldilocksQuinticExtension, PrimeField64};
use proofman_common::{Proof, ProofOptions, ProofType, ProofmanError, ProofmanResult};
use proofman_starks_lib_c::{
    clear_proof_done_callback_c, get_stream_proofs_c, get_stream_proofs_non_blocking_c, launch_callback_c,
    register_proof_done_callback_c,
};
use proofman_util::{timer_start_debug, timer_stop_and_log_debug, VadcopFinalProof};
use proofman_verifier::verify_recursive2;

use crate::challenge_accumulation::{aggregate_contributions, calculate_global_challenge};
use crate::runtime_reset::RECURSIVE_WORKER_STOP_ID;
use crate::{
    add_publics_circom, gen_recursive_proof_size, gen_witness_aggregation, generate_recursive_proof,
    generate_vadcop_final_compressed_proof, generate_vadcop_final_proof, get_accumulated_challenge,
    n_publics_aggregation, total_recursive_proofs, AggProofs, AggProofsRegister, Counter,
    N_RECURSIVE_PROOFS_PER_AGGREGATION,
};

use super::{ContributionsInfo, ProofMan};

impl<F: PrimeField64> ProofMan<F>
where
    GoldilocksQuinticExtension: ExtensionField<F>,
{
    pub fn register_aggregated_proofs(&self, agg_proofs: Vec<AggProofsRegister>) -> ProofmanResult<()> {
        let mut received = self.received_agg_proofs.write().unwrap();

        for proof in agg_proofs {
            let airgroup_vec = &mut received[proof.airgroup_id as usize];

            for &worker_idx in &proof.worker_indexes {
                if airgroup_vec.contains(&worker_idx) {
                    let error_message = ProofmanError::InvalidProof(format!(
                        "Received duplicated proof from worker {} for airgroup {}",
                        worker_idx, proof.airgroup_id
                    ));
                    self.cancellation_info.write().unwrap().cancel(Some(error_message));
                    break;
                }
                airgroup_vec.push(worker_idx);
            }
        }

        self.check_cancel(false)?;

        Ok(())
    }

    pub fn receive_aggregated_proofs(
        &self,
        agg_proofs: Vec<AggProofs>,
        last_proof: bool,
        final_proof: bool,
        options: &ProofOptions,
    ) -> ProofmanResult<Option<Vec<AggProofs>>> {
        tracing::info!("Received {:?} aggregated proofs", agg_proofs);
        let output_dir_path = match options.output_dir_path.as_deref() {
            Some(path) => path,
            None => Path::new("tmp"),
        };

        if !output_dir_path.exists() {
            fs::create_dir_all(output_dir_path)?;
        }

        if !agg_proofs.is_empty()
            && !self.cancellation_info.read().unwrap().token.is_cancelled()
            && self.outer_aggregations_handle.lock().unwrap().is_none()
        {
            self.outer_aggregations(output_dir_path, options.save_proofs);
        }

        for proof in agg_proofs {
            {
                let received = self.received_agg_proofs.read().unwrap();
                let airgroup_vec = &received[proof.airgroup_id as usize];

                for &worker_idx in &proof.worker_indexes {
                    if !airgroup_vec.contains(&worker_idx) {
                        self.cancellation_info.write().unwrap().cancel(Some(ProofmanError::InvalidProof(format!(
                            "Received proof from worker {} for airgroup {} was not registered",
                            worker_idx, proof.airgroup_id
                        ))));
                        break;
                    }
                }
            }

            if self.cancellation_info.read().unwrap().token.is_cancelled() {
                break;
            }
            let proof_acc_challenge = get_accumulated_challenge(&self.pctx, &proof.proof);
            let mut stored_contributions = Vec::new();
            for w in &proof.worker_indexes {
                let mut worker_contributions = self.worker_contributions.write().unwrap();
                if let Some(contrib) = worker_contributions.iter_mut().find(|contrib| {
                    contrib.worker_index == *w as u32 && contrib.airgroup_id == proof.airgroup_id as usize
                }) {
                    if contrib.aggregated {
                        self.cancellation_info.write().unwrap().cancel(Some(ProofmanError::InvalidProof(
                            "Proof contribution was already aggregated".into(),
                        )));
                        break;
                    }
                    contrib.aggregated = true;
                    stored_contributions.push(contrib.challenge.iter().map(|&x| F::from_u64(x)).collect());
                } else {
                    self.cancellation_info.write().unwrap().cancel(Some(ProofmanError::ProofmanError(format!(
                        "Missing contribution from worker {} and airgroup id {}",
                        w, proof.airgroup_id
                    ))));
                    break;
                }
            }

            timer_start_debug!(VERIFYING_OUTER_AGGREGATED_PROOF);
            let setup = self.setups.sctx_recursive2.as_ref().unwrap().get_setup(proof.airgroup_id as usize, 0)?;
            let publics_aggregation = n_publics_aggregation(&self.pctx, proof.airgroup_id as usize);
            let (publics, rec_proof) = proof.proof.split_at(publics_aggregation);

            let mut publics_extended = vec![0; setup.stark_info.n_publics as usize];
            publics_extended[0..publics.len()].copy_from_slice(publics);

            add_publics_circom(&mut publics_extended, publics_aggregation, &self.pctx, Some(&setup.verkey));

            let mut recursive2_proof = vec![0; 1 + publics_extended.len() + rec_proof.len()];
            recursive2_proof[0] = publics_extended.len() as u64;
            recursive2_proof[1..1 + publics_extended.len()].copy_from_slice(&publics_extended);
            recursive2_proof[1 + publics_extended.len()..].copy_from_slice(rec_proof);

            let vadcop_proof = VadcopFinalProof::new_from_proof(&recursive2_proof, false).map_err(|e| {
                ProofmanError::InvalidConfiguration(format!("Failed to create VadcopFinalProof: {}", e))
            })?;
            let valid_recursive_proof = verify_recursive2(&vadcop_proof, &setup.get_vk());

            if !valid_recursive_proof {
                self.cancellation_info
                    .write()
                    .unwrap()
                    .cancel(Some(ProofmanError::InvalidProof("Received aggregated proof is invalid!".into())));
                break;
            }
            timer_stop_and_log_debug!(VERIFYING_OUTER_AGGREGATED_PROOF);

            let workers_acc_challenge = aggregate_contributions(&self.pctx, &stored_contributions);
            for (c, value) in workers_acc_challenge.iter().enumerate() {
                if value.as_canonical_u64() != proof_acc_challenge[c] {
                    self.cancellation_info.write().unwrap().cancel(Some(ProofmanError::InvalidProof(
                        "Aggregated proof challenge does not match the expected challenge".into(),
                    )));
                    break;
                }
            }
            let id = {
                let mut rec2_proofs = self.recursive2_proofs_ongoing.write().unwrap();
                let id = rec2_proofs.len();
                let agg_proof = Proof::new(ProofType::Recursive2, proof.airgroup_id as usize, 0, Some(id), proof.proof);
                rec2_proofs.push(Some(agg_proof));
                id
            };

            launch_callback_c(id as u64, ProofType::Recursive2.into());
        }

        if last_proof || self.cancellation_info.read().unwrap().token.is_cancelled() {
            let mut total_proofs_to_be_done = 0;
            let mut total_proofs_received = vec![0; self.received_agg_proofs.read().unwrap().len()];
            if !self.cancellation_info.read().unwrap().token.is_cancelled() {
                for (airgroup_id, worker_indexes) in self.received_agg_proofs.read().unwrap().iter().enumerate() {
                    let n_agg_proofs = worker_indexes.len();
                    if n_agg_proofs == 1 && worker_indexes[0] == self.pctx.get_worker_index()? {
                        continue;
                    }
                    total_proofs_received[airgroup_id] = n_agg_proofs;
                    let n_agg_proofs_to_be_done = total_recursive_proofs(n_agg_proofs);
                    if n_agg_proofs_to_be_done.has_remaining {
                        let setup = self.setups.get_setup(airgroup_id, 0, &ProofType::Recursive2)?;
                        let publics_aggregation = n_publics_aggregation(&self.pctx, airgroup_id);
                        let null_proof_buffer = vec![0; setup.proof_size as usize + publics_aggregation];

                        let id = {
                            let mut rec2_proofs = self.recursive2_proofs_ongoing.write().unwrap();
                            let id = rec2_proofs.len();
                            let null_proof =
                                Proof::new(ProofType::Recursive2, airgroup_id, 0, Some(id), null_proof_buffer);
                            rec2_proofs.push(Some(null_proof));
                            id
                        };

                        launch_callback_c(id as u64, ProofType::Recursive2.into());
                    }
                    total_proofs_to_be_done += n_agg_proofs_to_be_done.n_proofs;
                }
            }

            tracing::info!("Last proof received. {:?} proofs were received and waiting for {} aggregated proofs to be generated...", total_proofs_received, total_proofs_to_be_done);

            self.total_outer_agg_proofs.wait_until_value_and_check_streams(
                total_proofs_to_be_done,
                || get_stream_proofs_non_blocking_c(self.pctx.get_device_buffers_ptr()),
                &self.cancellation_info,
            );
            get_stream_proofs_c(self.pctx.get_device_buffers_ptr());
            if self.outer_aggregations_handle.lock().unwrap().is_some() {
                self.outer_agg_proofs_finished.store(true, Ordering::SeqCst);
                clear_proof_done_callback_c();
                for _ in 0..self.n_streams {
                    self.recursive_tx.send((RECURSIVE_WORKER_STOP_ID, String::new())).unwrap();
                }

                let handles = self.handle_recursives.lock().unwrap().drain(..).collect::<Vec<_>>();
                for handle in handles {
                    handle.join().unwrap();
                }
                let mut outer_aggregations_handle = self.outer_aggregations_handle.lock().unwrap();
                if let Some(handle) = outer_aggregations_handle.take() {
                    handle.join().unwrap();
                }
            }

            self.check_cancel(false)?;

            let agg_proofs_data: Vec<AggProofs> = (0..self.pctx.global_info.air_groups.len())
                .map(|airgroup_id| {
                    let mut lock = self.recursive2_proofs[airgroup_id].write().unwrap();
                    let proof = std::mem::take(&mut lock.first_mut().expect("Expected at least one proof").proof);
                    AggProofs::new(airgroup_id as u64, proof, vec![])
                })
                .collect();

            if !final_proof {
                return Ok(Some(agg_proofs_data));
            } else {
                let worker_contributions = self.worker_contributions.read().unwrap();
                let mut not_received_contributions = Vec::new();
                for contrib in worker_contributions.iter() {
                    if !contrib.aggregated {
                        not_received_contributions.push((contrib.worker_index, contrib.airgroup_id));
                    }
                }

                if !not_received_contributions.is_empty() {
                    let error = format!(
                        "Not received contributions from workers: {:?}",
                        not_received_contributions
                            .iter()
                            .map(|(worker_index, airgroup_id)| format!(
                                "(worker {}, airgroup {})",
                                worker_index, airgroup_id
                            ))
                            .collect::<Vec<_>>()
                    );

                    self.cancellation_info.write().unwrap().cancel(Some(ProofmanError::InvalidProof(error.clone())));
                    return Err(ProofmanError::InvalidProof(error));
                }

                let global_challenge = self.pctx.get_global_challenge().clone();
                let accumulated_challenge = get_accumulated_challenge(&self.pctx, &agg_proofs_data[0].proof);
                let global_challenge_calculated = calculate_global_challenge(
                    &self.pctx,
                    &[ContributionsInfo {
                        challenge: accumulated_challenge.clone(),
                        airgroup_id: 0,
                        worker_index: 0,
                        aggregated: true,
                    }],
                );

                if global_challenge_calculated != *global_challenge {
                    let error =
                        "Global challenge calculated from contributions does not match the global challenge from pctx"
                            .to_string();

                    self.cancellation_info.write().unwrap().cancel(Some(ProofmanError::InvalidProof(error.clone())));
                    return Err(ProofmanError::InvalidProof(error));
                }

                let vadcop_proof_final = generate_vadcop_final_proof(
                    &self.pctx,
                    &self.setups,
                    &agg_proofs_data,
                    &self.prover_buffer_recursive,
                    output_dir_path,
                    &self.const_pols,
                    &self.const_tree,
                    options.save_proofs,
                )?;

                if options.compressed {
                    let vadcop_final_proof_compressed = generate_vadcop_final_compressed_proof(
                        &self.pctx,
                        &self.setups,
                        &vadcop_proof_final.proof,
                        &self.prover_buffer_recursive,
                        output_dir_path,
                        &self.const_pols,
                        &self.const_tree,
                        options.save_proofs,
                    )?;

                    return Ok(Some(vec![AggProofs::new(0, vadcop_final_proof_compressed.proof, vec![])]));
                } else {
                    return Ok(Some(vec![AggProofs::new(0, vadcop_proof_final.proof, vec![])]));
                }
            }
        }

        Ok(None)
    }

    fn outer_aggregations(&self, output_dir_path: &Path, save_proofs: bool) {
        self.outer_agg_proofs_finished.store(false, Ordering::SeqCst);
        register_proof_done_callback_c(self.recursive_tx.clone());

        for _ in 0..self.n_streams {
            let pctx_clone = self.pctx.clone();
            let setups_clone = self.setups.clone();
            let recursive2_proofs_clone = self.recursive2_proofs.clone();
            let recursive2_proofs_ongoing_clone = self.recursive2_proofs_ongoing.clone();
            let rec2_witness_tx_clone = self.rec2_witness_tx.clone();
            let recursive_rx_clone = self.recursive_rx.clone();
            let cancellation_info_clone = self.cancellation_info.clone();
            let output_dir_path = output_dir_path.to_path_buf();
            let handle_recursive = std::thread::spawn(move || {
                while let Ok((id, _)) = recursive_rx_clone.recv() {
                    if id == RECURSIVE_WORKER_STOP_ID {
                        return;
                    }

                    if cancellation_info_clone.read().unwrap().token.is_cancelled() {
                        break;
                    }

                    let proof = recursive2_proofs_ongoing_clone.write().unwrap()[id as usize].take().unwrap();

                    let mut recursive2_airgroup_proofs = recursive2_proofs_clone[proof.airgroup_id].write().unwrap();
                    recursive2_airgroup_proofs.push(proof);

                    if recursive2_airgroup_proofs.len() >= N_RECURSIVE_PROOFS_PER_AGGREGATION {
                        let p1 = recursive2_airgroup_proofs.pop().unwrap();
                        let p2 = recursive2_airgroup_proofs.pop().unwrap();
                        let p3 = recursive2_airgroup_proofs.pop().unwrap();

                        let w = gen_witness_aggregation(&pctx_clone, &setups_clone, &p1, &p2, &p3, &output_dir_path);

                        let witness = match w {
                            Ok(witness) => witness,
                            Err(e) => {
                                tracing::info!("Error generating recursive2 witness from recursive proofs: {}", e);
                                cancellation_info_clone.write().unwrap().cancel(Some(e));
                                break;
                            }
                        };
                        rec2_witness_tx_clone.send(witness).unwrap();
                    }
                }
            });
            self.handle_recursives.lock().unwrap().push(handle_recursive);
        }

        let pctx_clone = self.pctx.clone();
        let setups_clone = self.setups.clone();
        let const_pols_clone = self.const_pols.clone();
        let const_tree_clone = self.const_tree.clone();
        let prover_buffer_recursive = self.prover_buffer_recursive.clone();
        let recursive2_proofs_ongoing_clone = self.recursive2_proofs_ongoing.clone();
        let outer_agg_proofs_finished = self.outer_agg_proofs_finished.clone();
        let rec2_witness_rx = self.rec2_witness_rx.clone();
        let cancellation_info_clone = self.cancellation_info.clone();
        let output_dir_path_clone = output_dir_path.to_path_buf();
        let total_outer_agg_proofs = self.total_outer_agg_proofs.clone();
        let outer_aggregations_handle = std::thread::spawn(move || loop {
            if cancellation_info_clone.read().unwrap().token.is_cancelled() {
                break;
            }
            let witness = rec2_witness_rx.try_recv();
            if witness.is_err() {
                if outer_agg_proofs_finished.load(Ordering::Relaxed) {
                    return;
                }
                std::thread::sleep(std::time::Duration::from_micros(100));
                continue;
            }

            let mut witness = witness.unwrap();

            let id = {
                let mut rec2_proofs = recursive2_proofs_ongoing_clone.write().unwrap();
                let id = rec2_proofs.len();
                rec2_proofs.push(None);
                id
            };

            witness.global_idx = Some(id);

            let new_proof = match gen_recursive_proof_size(&pctx_clone, &setups_clone, &witness) {
                Ok(p) => p,
                Err(e) => {
                    cancellation_info_clone.write().unwrap().cancel(Some(e));
                    break;
                }
            };

            recursive2_proofs_ongoing_clone.write().unwrap()[id] = Some(new_proof);

            let mut recursive2_lock = recursive2_proofs_ongoing_clone.write().unwrap();
            let new_proof_ref = recursive2_lock[id].as_mut().unwrap();

            if let Err(e) = generate_recursive_proof(
                &pctx_clone,
                &setups_clone,
                &witness,
                new_proof_ref,
                &prover_buffer_recursive,
                &output_dir_path_clone,
                &const_tree_clone,
                &const_pols_clone,
                save_proofs,
                false,
            ) {
                cancellation_info_clone.write().unwrap().cancel(Some(e));
                break;
            }

            total_outer_agg_proofs.increment();
            if cfg!(not(feature = "gpu")) {
                launch_callback_c(id as u64, ProofType::Recursive2.into());
            }
        });

        *self.outer_aggregations_handle.lock().unwrap() = Some(outer_aggregations_handle);
    }

    #[allow(clippy::type_complexity)]
    pub(super) fn worker_aggregations_rma(
        &self,
        output_dir_path: PathBuf,
        save_proofs: bool,
        send_proofs: bool,
    ) -> ProofmanResult<()> {
        timer_start_debug!(GENERATING_WORKER_RMA_COMPRESSED_PROOFS);

        let my_rank = self.mpi_ctx.rank as usize;
        let n_processes = self.mpi_ctx.n_processes as usize;

        let (rec2_witness_tx, rec2_witness_rx): (Sender<Proof<F>>, Receiver<Proof<F>>) = unbounded();
        let (recursive_tx, recursive_rx) = unbounded::<(u64, String)>();

        register_proof_done_callback_c(recursive_tx.clone());

        let instances = self.pctx.dctx_get_instances();
        let n_airgroups = self.pctx.global_info.air_groups.len();
        let mut airgroup_instances_alive = vec![vec![0; n_processes]; n_airgroups];
        for global_id in self.pctx.dctx_get_worker_instances().iter() {
            if let Ok(owner) = self.pctx.dctx_get_process_owner_instance(*global_id) {
                airgroup_instances_alive[instances[*global_id].airgroup_id][owner as usize] = 1;
            }
        }
        let mut alives = vec![0; n_airgroups];
        let mut n_proofs_to_be_received = 0;
        for (airgroup, instances) in airgroup_instances_alive.iter().enumerate().take(n_airgroups) {
            for (p, &alive) in instances.iter().enumerate().take(n_processes) {
                alives[airgroup] += alive;
                if p != my_rank {
                    n_proofs_to_be_received += alive;
                }
            }
        }

        let mut total_proofs: usize = 0;
        for (airgroup, &n_proofs) in alives.iter().enumerate() {
            let n_recursive2_proofs = total_recursive_proofs(n_proofs);
            if n_recursive2_proofs.has_remaining {
                let setup = self.setups.get_setup(airgroup, 0, &ProofType::Recursive2)?;
                let publics_aggregation = n_publics_aggregation(&self.pctx, airgroup);
                let null_proof_buffer = vec![0; setup.proof_size as usize + publics_aggregation];
                let null_proof = Proof::new(ProofType::Recursive2, airgroup, 0, None, null_proof_buffer);
                self.recursive2_proofs[airgroup].write().unwrap().push(null_proof);
            }
            total_proofs += n_recursive2_proofs.n_proofs as usize;
        }
        total_proofs += n_proofs_to_be_received;

        let recursive2_done = Arc::new(Counter::new_with_threshold(total_proofs));

        let pctx_clone = self.pctx.clone();
        let setups_clone = self.setups.clone();
        let const_pols_clone = self.const_pols.clone();
        let const_tree_clone = self.const_tree.clone();
        let prover_buffer_recursive = self.prover_buffer_recursive.clone();
        let recursive2_proofs_ongoing_clone = self.recursive2_proofs_ongoing.clone();
        let cancellation_info_clone = self.cancellation_info.clone();
        let output_dir_path_clone = output_dir_path.clone();
        let recursive2_handle = std::thread::spawn(move || {
            while let Ok(mut witness) = rec2_witness_rx.recv() {
                if cancellation_info_clone.read().unwrap().token.is_cancelled() {
                    break;
                }
                let id = {
                    let mut rec2_proofs = recursive2_proofs_ongoing_clone.write().unwrap();
                    let id = rec2_proofs.len();
                    rec2_proofs.push(None);
                    id
                };

                witness.global_idx = Some(id);

                let new_proof = match gen_recursive_proof_size(&pctx_clone, &setups_clone, &witness) {
                    Ok(p) => p,
                    Err(e) => {
                        cancellation_info_clone.write().unwrap().cancel(Some(e));
                        break;
                    }
                };

                let id = new_proof.global_idx.unwrap();
                recursive2_proofs_ongoing_clone.write().unwrap()[id] = Some(new_proof);

                let mut recursive2_lock = recursive2_proofs_ongoing_clone.write().unwrap();
                let new_proof_ref = recursive2_lock[id].as_mut().unwrap();

                if let Err(e) = generate_recursive_proof(
                    &pctx_clone,
                    &setups_clone,
                    &witness,
                    new_proof_ref,
                    &prover_buffer_recursive,
                    &output_dir_path_clone,
                    &const_tree_clone,
                    &const_pols_clone,
                    save_proofs,
                    false,
                ) {
                    cancellation_info_clone.write().unwrap().cancel(Some(e));
                    break;
                };

                if cfg!(not(feature = "gpu")) {
                    launch_callback_c(id as u64, ProofType::Recursive2.into());
                }
            }
        });

        let mut handle_recursives = Vec::new();
        for _ in 0..self.n_streams {
            let pctx_clone = self.pctx.clone();
            let setups_clone = self.setups.clone();
            let recursive2_proofs_clone = self.recursive2_proofs.clone();
            let recursive2_proofs_ongoing_clone = self.recursive2_proofs_ongoing.clone();
            let rec2_witness_tx_clone = rec2_witness_tx.clone();
            let recursive_rx_clone = recursive_rx.clone();
            let recursive2_done_clone = recursive2_done.clone();
            let cancellation_info_clone = self.cancellation_info.clone();
            let output_dir_path = output_dir_path.clone();
            let handle_recursive = std::thread::spawn(move || {
                while let Ok((id, _)) = recursive_rx_clone.recv() {
                    recursive2_done_clone.increment();
                    if id == RECURSIVE_WORKER_STOP_ID {
                        return;
                    }

                    if cancellation_info_clone.read().unwrap().token.is_cancelled() {
                        break;
                    }

                    let proof = recursive2_proofs_ongoing_clone.write().unwrap()[id as usize].take().unwrap();

                    let mut recursive2_airgroup_proofs = recursive2_proofs_clone[proof.airgroup_id].write().unwrap();
                    recursive2_airgroup_proofs.push(proof);

                    if recursive2_airgroup_proofs.len() >= N_RECURSIVE_PROOFS_PER_AGGREGATION {
                        let p1 = recursive2_airgroup_proofs.pop().unwrap();
                        let p2 = recursive2_airgroup_proofs.pop().unwrap();
                        let p3 = recursive2_airgroup_proofs.pop().unwrap();
                        let w = gen_witness_aggregation(&pctx_clone, &setups_clone, &p1, &p2, &p3, &output_dir_path);
                        let witness = match w {
                            Ok(witness) => witness,
                            Err(e) => {
                                tracing::info!("Error generating recursive2 witness from recursive proofs: {}", e);
                                cancellation_info_clone.write().unwrap().cancel(Some(e));
                                break;
                            }
                        };
                        rec2_witness_tx_clone.send(witness).unwrap();
                    }
                }
            });
            handle_recursives.push(handle_recursive);
        }

        while n_proofs_to_be_received > 0 {
            for airgroup_id in 0..n_airgroups {
                let new_proof = self.mpi_ctx.check_incoming_proofs(airgroup_id);
                if let Some(proof) = new_proof {
                    let mut rec2_proofs = self.recursive2_proofs_ongoing.write().unwrap();
                    let id = rec2_proofs.len();
                    let recursive2_proof = Proof::new(ProofType::Recursive2, airgroup_id, 0, Some(id), proof);
                    rec2_proofs.push(Some(recursive2_proof));

                    launch_callback_c(id as u64, ProofType::Recursive2.into());

                    n_proofs_to_be_received -= 1;
                }
            }
        }

        recursive2_done.wait_until_threshold_and_check_streams(
            || get_stream_proofs_non_blocking_c(self.pctx.get_device_buffers_ptr()),
            &self.cancellation_info,
        );
        clear_proof_done_callback_c();
        drop(recursive_tx);
        drop(rec2_witness_tx);

        recursive2_handle.join().unwrap();

        self.check_cancel(false)?;

        if send_proofs {
            self.recursive2_proofs.iter().enumerate().for_each(|(airgroup_id, lock)| {
                let mut write_lock = lock.write().unwrap();
                while let Some(proof) = write_lock.pop() {
                    let proof = proof.proof;
                    self.pctx.mpi_ctx.send_proof_to_rank(&proof, airgroup_id, 0);
                }
            });
        }

        timer_stop_and_log_debug!(GENERATING_WORKER_RMA_COMPRESSED_PROOFS);

        Ok(())
    }
}
