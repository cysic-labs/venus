//! Planning for the native constant-tree host cache: selects which setup constant trees are
//! loaded ahead of proving, from environment-configured policy and the run's instance mix.

use std::collections::HashMap;
use std::fmt::Write as FmtWrite;
use std::fs;

use fields::PrimeField64;
use proofman_common::{ProofCtx, ProofType, ProofmanResult, Setup, SetupCtx, SetupsVadcop};
use proofman_starks_lib_c::prewarm_const_tree_host_cache_c;

fn const_tree_host_cache_setup_prewarm_enabled() -> bool {
    std::env::var("VENUS_CONST_TREE_HOST_CACHE_SETUP_PREWARM")
        .map(|value| !value.is_empty() && value != "0")
        .unwrap_or(false)
}

fn const_tree_host_cache_setup_prewarm_capacity() -> u64 {
    std::env::var("VENUS_CONST_TREE_HOST_CACHE_MB")
        .ok()
        .and_then(|value| value.parse::<u64>().ok())
        .unwrap_or(0)
        .saturating_mul(1024 * 1024)
}

fn const_tree_host_cache_setup_prewarm_max_files() -> Option<usize> {
    std::env::var("VENUS_CONST_TREE_HOST_CACHE_SETUP_PREWARM_MAX_FILES")
        .ok()
        .and_then(|value| value.parse::<usize>().ok())
        .filter(|&value| value > 0)
}

fn const_tree_host_cache_prewarm_min_uses() -> usize {
    std::env::var("VENUS_CONST_TREE_HOST_CACHE_PREWARM_MIN_USES")
        .or_else(|_| std::env::var("VENUS_CONST_TREE_HOST_CACHE_MIN_USES"))
        .ok()
        .and_then(|value| value.parse::<usize>().ok())
        .filter(|&value| value > 0)
        .unwrap_or(1)
}

fn const_tree_host_cache_setup_prewarm_types() -> Vec<ProofType> {
    std::env::var("VENUS_CONST_TREE_HOST_CACHE_SETUP_PREWARM_TYPES")
        .ok()
        .map(|value| {
            value.split(',').filter_map(|proof_type| proof_type.trim().parse::<ProofType>().ok()).collect::<Vec<_>>()
        })
        .filter(|proof_types| !proof_types.is_empty())
        .unwrap_or_else(|| vec![ProofType::Recursive1])
}

fn const_tree_host_cache_setup_prewarm_type_priority(proof_type: &ProofType) -> usize {
    match proof_type {
        ProofType::Recursive1 => 0,
        ProofType::Compressor => 1,
        ProofType::Basic => 2,
        ProofType::Recursive2 => 3,
        ProofType::VadcopFinal => 4,
        ProofType::VadcopFinalCompressed => 5,
        ProofType::RecursiveF => 6,
    }
}

fn add_setup_const_tree_host_cache_prewarm_candidate<F: PrimeField64>(
    candidates: &mut Vec<(usize, usize, ProofType, String, u64)>,
    setup: &Setup<F>,
) {
    if setup.preallocate || setup.const_pols_tree_path.is_empty() || setup.const_tree_size == 0 {
        return;
    }

    let size_bytes = (setup.const_tree_size as u64).saturating_mul(std::mem::size_of::<u64>() as u64);
    if size_bytes < 128 * 1024 * 1024 {
        return;
    }

    candidates.push((
        setup.airgroup_id,
        setup.air_id,
        setup.setup_type.clone(),
        setup.const_pols_tree_path.clone(),
        size_bytes,
    ));
}

fn add_dynamic_const_tree_host_cache_prewarm_candidate<F: PrimeField64>(
    candidates: &mut HashMap<(String, u64), u128>,
    setup: &Setup<F>,
    repeat_count: usize,
) {
    if setup.preallocate || setup.const_pols_tree_path.is_empty() || setup.const_tree_size == 0 {
        return;
    }

    let size_bytes = (setup.const_tree_size as u64).saturating_mul(std::mem::size_of::<u64>() as u64);
    if size_bytes < 128 * 1024 * 1024 {
        return;
    }

    let score = (repeat_count.saturating_sub(1) as u128).saturating_mul(size_bytes as u128);
    candidates
        .entry((setup.const_pols_tree_path.clone(), size_bytes))
        .and_modify(|current_score| *current_score = (*current_score).max(score))
        .or_insert(score);
}

fn collect_dynamic_const_tree_host_cache_prewarm_candidates<F: PrimeField64>(
    pctx: &ProofCtx<F>,
    sctx: &SetupCtx<F>,
    setups: &SetupsVadcop<F>,
    aggregation: bool,
) -> ProofmanResult<Vec<(String, u64)>> {
    if !cfg!(feature = "gpu") {
        return Ok(Vec::new());
    }

    let min_uses = const_tree_host_cache_prewarm_min_uses();
    let capacity = const_tree_host_cache_setup_prewarm_capacity();
    if capacity == 0 {
        return Ok(Vec::new());
    }

    let mut instance_counts: HashMap<(usize, usize), usize> = HashMap::new();
    for instance_id in pctx.dctx_get_process_instances() {
        if pctx.dctx_is_table(instance_id) {
            continue;
        }
        let key = pctx.dctx_get_instance_info(instance_id)?;
        *instance_counts.entry(key).or_insert(0) += 1;
    }

    let mut candidates: HashMap<(String, u64), u128> = HashMap::new();
    for ((airgroup_id, air_id), repeat_count) in instance_counts {
        if repeat_count < min_uses {
            continue;
        }

        let basic_setup = sctx.get_setup(airgroup_id, air_id)?;
        add_dynamic_const_tree_host_cache_prewarm_candidate(&mut candidates, basic_setup, repeat_count);

        if aggregation {
            if pctx.global_info.get_air_has_compressor(airgroup_id, air_id) {
                let compressor_setup = setups.get_setup(airgroup_id, air_id, &ProofType::Compressor)?;
                add_dynamic_const_tree_host_cache_prewarm_candidate(&mut candidates, compressor_setup, repeat_count);
            }

            let recursive1_setup = setups.get_setup(airgroup_id, air_id, &ProofType::Recursive1)?;
            add_dynamic_const_tree_host_cache_prewarm_candidate(&mut candidates, recursive1_setup, repeat_count);
        }
    }

    let mut ranked = candidates.into_iter().collect::<Vec<_>>();
    ranked.sort_by_key(|((_, size), score)| (std::cmp::Reverse(*score), std::cmp::Reverse(*size)));

    let mut selected = Vec::new();
    let mut selected_bytes = 0_u64;
    for ((path, size), _) in ranked {
        if selected_bytes.saturating_add(size) > capacity {
            continue;
        }
        selected_bytes += size;
        selected.push((path, size));
    }

    Ok(selected)
}

pub(crate) fn dump_dynamic_const_tree_host_cache_prewarm_candidates<F: PrimeField64>(
    pctx: &ProofCtx<F>,
    sctx: &SetupCtx<F>,
    setups: &SetupsVadcop<F>,
    aggregation: bool,
) -> ProofmanResult<()> {
    let Some(path) = std::env::var_os("VENUS_CONST_TREE_HOST_CACHE_DYNAMIC_CANDIDATES_FILE") else {
        return Ok(());
    };

    let candidates = collect_dynamic_const_tree_host_cache_prewarm_candidates(pctx, sctx, setups, aggregation)?;
    let mut contents = String::new();
    for (candidate_path, size) in candidates {
        writeln!(contents, "{size} {candidate_path}").unwrap();
    }
    fs::write(path, contents)?;
    Ok(())
}

fn add_setup_ctx_const_tree_host_cache_prewarm_candidates<F: PrimeField64>(
    candidates: &mut Vec<(usize, usize, ProofType, String, u64)>,
    sctx: &SetupCtx<F>,
) -> ProofmanResult<()> {
    let mut setup_ids = sctx.get_setups_list();
    setup_ids.sort_unstable();
    for (airgroup_id, air_id) in setup_ids {
        add_setup_const_tree_host_cache_prewarm_candidate(candidates, sctx.get_setup(airgroup_id, air_id)?);
    }
    Ok(())
}

pub(crate) fn collect_setup_const_tree_host_cache_prewarm_candidates<F: PrimeField64>(
    pctx: &ProofCtx<F>,
    sctx: &SetupCtx<F>,
    setups: &SetupsVadcop<F>,
    aggregation: bool,
) -> ProofmanResult<Vec<(String, u64)>> {
    if !cfg!(feature = "gpu") || !const_tree_host_cache_setup_prewarm_enabled() {
        return Ok(Vec::new());
    }

    let capacity = const_tree_host_cache_setup_prewarm_capacity();
    if capacity == 0 {
        return Ok(Vec::new());
    }

    if let Some(list_path) = std::env::var_os("VENUS_CONST_TREE_HOST_CACHE_SETUP_PREWARM_LIST") {
        let contents = fs::read_to_string(list_path)?;
        let max_files = const_tree_host_cache_setup_prewarm_max_files();
        let mut selected = Vec::new();
        let mut selected_bytes = 0_u64;
        for line in contents.lines() {
            let line = line.trim();
            if line.is_empty() || line.starts_with('#') {
                continue;
            }
            let Some((size, path)) = line.split_once(' ') else {
                continue;
            };
            let Ok(size) = size.parse::<u64>() else {
                continue;
            };
            if selected_bytes.saturating_add(size) > capacity {
                continue;
            }
            if max_files.is_some_and(|limit| selected.len() >= limit) {
                break;
            }
            let path = path.trim();
            let path = fs::canonicalize(path)
                .map(|path| path.to_string_lossy().into_owned())
                .unwrap_or_else(|_| path.to_string());
            selected_bytes += size;
            selected.push((path, size));
        }
        if !selected.is_empty() {
            tracing::info!(
                "Setup const-tree host-cache prewarm selected {} listed files ({:.1} MiB)",
                selected.len(),
                selected_bytes as f64 / 1048576.0
            );
        }
        return Ok(selected);
    }

    let proof_types = const_tree_host_cache_setup_prewarm_types();
    let mut candidates = Vec::new();

    if proof_types.contains(&ProofType::Basic) {
        add_setup_ctx_const_tree_host_cache_prewarm_candidates(&mut candidates, sctx)?;
    }

    if aggregation {
        if proof_types.contains(&ProofType::Compressor) {
            if let Some(sctx_compressor) = setups.sctx_compressor.as_ref() {
                let mut setup_ids = sctx_compressor.get_setups_list();
                setup_ids.sort_unstable();
                for (airgroup_id, air_id) in setup_ids {
                    if !pctx.global_info.get_air_has_compressor(airgroup_id, air_id) {
                        continue;
                    }
                    add_setup_const_tree_host_cache_prewarm_candidate(
                        &mut candidates,
                        sctx_compressor.get_setup(airgroup_id, air_id)?,
                    );
                }
            }
        }

        if proof_types.contains(&ProofType::Recursive1) {
            if let Some(sctx_recursive1) = setups.sctx_recursive1.as_ref() {
                add_setup_ctx_const_tree_host_cache_prewarm_candidates(&mut candidates, sctx_recursive1)?;
            }
        }

        if proof_types.contains(&ProofType::Recursive2) {
            if let Some(sctx_recursive2) = setups.sctx_recursive2.as_ref() {
                add_setup_ctx_const_tree_host_cache_prewarm_candidates(&mut candidates, sctx_recursive2)?;
            }
        }

        if proof_types.contains(&ProofType::VadcopFinal) {
            if let Some(setup) = setups.setup_vadcop_final.as_ref() {
                add_setup_const_tree_host_cache_prewarm_candidate(&mut candidates, setup);
            }
        }

        if proof_types.contains(&ProofType::VadcopFinalCompressed) {
            if let Some(setup) = setups.setup_vadcop_final_compressed.as_ref() {
                add_setup_const_tree_host_cache_prewarm_candidate(&mut candidates, setup);
            }
        }
    }

    let order = std::env::var("VENUS_CONST_TREE_HOST_CACHE_SETUP_PREWARM_ORDER")
        .unwrap_or_else(|_| "setup".to_string())
        .to_ascii_lowercase();
    if order == "weight" {
        let use_q_ops_order = std::env::var_os("VENUS_WEIGHT_Q_OPS").is_some();
        candidates.sort_by_key(|(airgroup_id, air_id, proof_type, path, size)| {
            let weight = match proof_type {
                ProofType::Basic | ProofType::Compressor | ProofType::Recursive1 | ProofType::Recursive2 => {
                    if use_q_ops_order {
                        pctx.get_q_ops_order_weight(*airgroup_id, *air_id)
                    } else {
                        pctx.get_weight(*airgroup_id, *air_id)
                    }
                }
                _ => 0,
            };
            (
                std::cmp::Reverse((weight as u128).saturating_mul(*size as u128)),
                std::cmp::Reverse(*size),
                const_tree_host_cache_setup_prewarm_type_priority(proof_type),
                *airgroup_id,
                *air_id,
                path.clone(),
            )
        });
    } else {
        candidates.sort_by_key(|(airgroup_id, air_id, proof_type, path, size)| {
            (
                const_tree_host_cache_setup_prewarm_type_priority(proof_type),
                *airgroup_id,
                *air_id,
                std::cmp::Reverse(*size),
                path.clone(),
            )
        });
    }
    candidates.dedup_by(|a, b| a.3 == b.3 && a.4 == b.4);

    let max_files = const_tree_host_cache_setup_prewarm_max_files();
    let mut selected = Vec::new();
    let mut selected_bytes = 0_u64;
    for (_, _, _, path, size) in candidates {
        if selected_bytes.saturating_add(size) > capacity {
            continue;
        }
        if max_files.is_some_and(|limit| selected.len() >= limit) {
            break;
        }
        selected_bytes += size;
        selected.push((path, size));
    }

    if !selected.is_empty() {
        tracing::info!(
            "Setup const-tree host-cache prewarm selected {} files ({:.1} MiB)",
            selected.len(),
            selected_bytes as f64 / 1048576.0
        );
    }
    if let Some(path) = std::env::var_os("VENUS_CONST_TREE_HOST_CACHE_SETUP_CANDIDATES_FILE") {
        let mut contents = String::new();
        for (candidate_path, size) in selected.iter() {
            writeln!(contents, "{size} {candidate_path}").unwrap();
        }
        fs::write(path, contents)?;
    }

    Ok(selected)
}

pub(crate) fn start_setup_const_tree_host_cache_prewarm(candidates: Vec<(String, u64)>) {
    if candidates.is_empty() {
        return;
    }

    let mode = std::env::var("VENUS_CONST_TREE_HOST_CACHE_SETUP_PREWARM_MODE")
        .unwrap_or_else(|_| "sync".to_string())
        .to_ascii_lowercase();
    let run = move || {
        let total = candidates.len();
        let start = std::time::Instant::now();
        let loaded = candidates.into_iter().filter(|(path, size)| prewarm_const_tree_host_cache_c(path, *size)).count();
        tracing::info!(
            "Setup const-tree host-cache prewarm loaded {loaded}/{total} files in {:.2}s",
            start.elapsed().as_secs_f64()
        );
    };

    if mode == "async" {
        std::thread::spawn(run);
    } else {
        run();
    }
}
