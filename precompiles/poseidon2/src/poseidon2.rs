use core::panic;
use std::sync::Arc;

use fields::{
    add, matmul_external, pow7, pow7add, prodadd, Poseidon16, Poseidon2Constants, PrimeField64,
};
use rayon::prelude::*;

use pil_std_lib::Std;
use proofman_common::{AirInstance, FromTrace, ProofmanResult};
use proofman_util::{timer_start_trace, timer_stop_and_log_trace};
#[cfg(not(feature = "packed"))]
use zisk_pil::{Poseidon2Trace, Poseidon2TraceRow};
#[cfg(feature = "packed")]
use zisk_pil::{Poseidon2TracePacked, Poseidon2TraceRowPacked};

#[cfg(feature = "packed")]
type Poseidon2TraceRowType<F> = Poseidon2TraceRowPacked<F>;
#[cfg(feature = "packed")]
type Poseidon2TraceType<F> = Poseidon2TracePacked<F>;

#[cfg(not(feature = "packed"))]
type Poseidon2TraceRowType<F> = Poseidon2TraceRow<F>;
#[cfg(not(feature = "packed"))]
type Poseidon2TraceType<F> = Poseidon2Trace<F>;

use super::Poseidon2Input;

/// The `Poseidon2SM` struct encapsulates the logic of the Poseidon2 State Machine.
pub struct Poseidon2SM<F: PrimeField64> {
    /// Reference to the PIL2 standard library.
    pub std: Arc<Std<F>>,

    /// Number of available poseidon2s in the trace.
    pub num_available_poseidon2s: usize,

    /// Range check ID of the 16-bit state limbs.
    range_id: usize,
}

pub const CLOCKS: usize = 14;

/// Clock whose state is written to memory: its limbs are range checked and canonical.
const OUTPUT_CLOCK: usize = CLOCKS - 1;

/// Largest 32-bit value, the high half that forces a zero low half on a canonical element.
const MASK_32: u64 = 0xFFFF_FFFF;

/// 16-bit limbs of a state element, least-significant first, as laid out in the `chunks` columns.
fn limbs(value: u64) -> [u16; 4] {
    [value as u16, (value >> 16) as u16, (value >> 32) as u16, (value >> 48) as u16]
}

impl<F: PrimeField64> Poseidon2SM<F> {
    /// Creates a new Poseidon2 State Machine instance.
    ///
    /// # Returns
    /// A new `Poseidon2SM` instance.
    pub fn new(std: Arc<Std<F>>) -> Arc<Self> {
        // Compute some useful values
        let num_available_poseidon2s = Poseidon2TraceType::<F>::NUM_ROWS / CLOCKS - 1;

        let range_id = std.get_range_id(0, (1 << 16) - 1, None).expect("Failed to get range ID");

        Arc::new(Self { std, num_available_poseidon2s, range_id })
    }

    /// Processes a slice of operation data, updating the trace and multiplicities.
    ///
    /// # Arguments
    /// * `trace` - A mutable reference to the Poseidon2 trace.
    /// * `input` - The operation data to process.
    /// * `is_active` - Whether the rows belong to a real operation (`in_use` set).
    /// * `range_checks` - Multiplicities of the 16-bit range checks, only checked on the output
    ///   clock of active operations.
    #[inline(always)]
    pub fn process_input(
        &self,
        trace: &mut [Poseidon2TraceRowType<F>],
        input: &Poseidon2Input,
        is_active: bool,
        range_checks: &mut [u32],
    ) {
        // Fill the states
        let mut round_states = [[0u64; 16]; CLOCKS];
        round_states[0] = input.state;

        let mut state = input.state.map(|x| F::from_u64(x));
        matmul_external::<F, 16>(&mut state);
        round_states[1] = state.map(|x| x.as_canonical_u64());

        for r in 0..Poseidon16::HALF_ROUNDS {
            let mut c_slice = [F::ZERO; 16];
            for (i, c) in c_slice.iter_mut().enumerate() {
                *c = F::from_u64(Poseidon16::RC[r * 16 + i]);
            }
            pow7add::<F, 16>(&mut state, &c_slice);
            matmul_external::<F, 16>(&mut state);
            round_states[2 + r] = state.map(|x| x.as_canonical_u64());
        }

        let mut row = 6;
        let mut index = 0;
        for r in 0..Poseidon16::N_PARTIAL_ROUNDS {
            round_states[row][index] = state[0].as_canonical_u64();
            index += 1;

            state[0] += F::from_u64(Poseidon16::RC[Poseidon16::HALF_ROUNDS * 16 + r]);
            state[0] = pow7(state[0]);
            let sum = add::<F, 16>(&state);
            prodadd::<F, 16>(&mut state, Poseidon16::DIAG, sum);
            if r == 10 {
                round_states[7] = state.map(|x| x.as_canonical_u64());
                row = 8;
                index = 0;
            }
        }

        round_states[9] = state.map(|x| x.as_canonical_u64());

        for r in 0..Poseidon16::HALF_ROUNDS {
            let mut c_slice = [F::ZERO; 16];
            for (i, c) in c_slice.iter_mut().enumerate() {
                *c = F::from_u64(
                    Poseidon16::RC
                        [Poseidon16::HALF_ROUNDS * 16 + Poseidon16::N_PARTIAL_ROUNDS + r * 16 + i],
                );
            }
            pow7add::<F, 16>(&mut state, &c_slice);
            matmul_external::<F, 16>(&mut state);
            round_states[10 + r] = state.map(|x| x.as_canonical_u64());
        }

        for r in 0..CLOCKS {
            for (i, &state) in round_states[r].iter().enumerate() {
                for (k, limb) in limbs(state).into_iter().enumerate() {
                    trace[r].set_chunks(i, k, limb);
                }
            }
        }

        if !is_active {
            return;
        }

        // Output row: range check the limbs and set the inverse of MASK_32 - hi used by the
        // canonical encoding check (hi == MASK_32 forces lo == 0, so any value is fine then)
        for (i, &state) in round_states[OUTPUT_CLOCK].iter().enumerate() {
            for limb in limbs(state) {
                range_checks[limb as usize] += 1;
            }
            let t = F::from_u64(MASK_32 - (state >> 32));
            if t != F::ZERO {
                trace[OUTPUT_CLOCK].set_t_inv(i, t.inverse().as_canonical_u64());
            }
        }

        // Fill step and addr
        trace[0].set_step_addr(input.step_main);
        trace[1].set_step_addr(input.addr_main as u64);

        // Fill in_use_clk_0
        trace[0].set_in_use_clk_0(true);

        // Fill in_use
        for item in trace.iter_mut().take(CLOCKS) {
            item.set_in_use(true);
        }
    }

    /// Computes the witness for a series of inputs and produces an `AirInstance`.
    ///
    /// # Arguments
    /// * `sctx` - The setup context containing the setup data.
    /// * `inputs` - A slice of operations to process.
    ///
    /// # Returns
    /// An `AirInstance` containing the computed witness data.
    pub fn compute_witness(
        &self,
        inputs: &[Vec<Poseidon2Input>],
        trace_buffer: Vec<F>,
    ) -> ProofmanResult<AirInstance<F>> {
        let mut poseidon2_trace = Poseidon2TraceType::new_from_vec_zeroes(trace_buffer)?;
        let num_rows = poseidon2_trace.num_rows();
        let num_available_poseidon2s = self.num_available_poseidon2s;

        // Check that we can fit all the poseidon2s in the trace
        let num_inputs = inputs.iter().map(|v| v.len()).sum::<usize>();
        let num_rows_needed = if num_inputs < num_available_poseidon2s {
            num_inputs * CLOCKS
        } else if num_inputs == num_available_poseidon2s {
            num_rows
        } else {
            panic!(
                "Exceeded available Poseidon2 inputs: requested {}, but only {} are available.",
                num_inputs, self.num_available_poseidon2s
            );
        };

        tracing::debug!(
            "··· Creating Poseidon2 instance [{}{{}} / {} rows filled {:.2}%]",
            num_rows_needed,
            num_rows,
            (num_rows_needed as f64 / num_rows as f64 * 100.0) as usize
        );

        timer_start_trace!(POSEIDON2_TRACE);
        let mut trace_rows = poseidon2_trace.buffer.as_mut_slice();
        let mut par_traces = Vec::new();
        let mut inputs_indexes = Vec::new();
        for (i, inputs) in inputs.iter().enumerate() {
            for (j, _) in inputs.iter().enumerate() {
                let (head, tail) = trace_rows.split_at_mut(CLOCKS);
                par_traces.push(head);
                inputs_indexes.push((i, j));
                trace_rows = tail;
            }
        }

        // Fill the trace and collect the range checks of the output limbs
        let range_checks = par_traces
            .into_par_iter()
            .enumerate()
            .fold(
                || vec![0u32; 1 << 16],
                |mut range_checks, (index, trace)| {
                    let input_index = inputs_indexes[index];
                    let input = &inputs[input_index.0][input_index.1];
                    self.process_input(trace, input, true, &mut range_checks);
                    range_checks
                },
            )
            .reduce(
                || vec![0u32; 1 << 16],
                |mut acc, range_checks| {
                    for (acc, value) in acc.iter_mut().zip(range_checks) {
                        *acc += value;
                    }
                    acc
                },
            );

        self.std.range_checks(self.range_id, range_checks);

        timer_stop_and_log_trace!(POSEIDON2_TRACE);

        timer_start_trace!(POSEIDON2_PADDING);

        // 3] Fill the padding rows with Poseidon2(0)
        let padding_rows_start = num_rows_needed;
        let padding_rows_end: usize =
            padding_rows_start + ((num_available_poseidon2s - num_inputs) * CLOCKS);

        // Split the padding trace into padding chunks
        let padding_trace = &mut poseidon2_trace.buffer[padding_rows_start..padding_rows_end];
        let mut padding_chunks: Vec<_> = padding_trace.chunks_mut(CLOCKS).collect();

        // Process padding in parallel
        if let Some((first, rest)) = padding_chunks.split_first_mut() {
            self.process_input(
                first,
                &Poseidon2Input { state: [0; 16], step_main: 0, addr_main: 0 },
                false,
                &mut [],
            );

            rest.par_iter_mut().for_each(|chunk| {
                chunk.copy_from_slice(first);
            });
        }

        // 4] The non-usable rows should be zeroes, which are already set at initialization

        timer_stop_and_log_trace!(POSEIDON2_PADDING);

        Ok(AirInstance::new_from_trace(FromTrace::new(&mut poseidon2_trace)))
    }
}
