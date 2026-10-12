mod descriptor;
mod gates;

use std::collections::VecDeque;
use std::sync::{Mutex, OnceLock};
use std::time::Instant;

use fields::PrimeField64;
use smallvec::SmallVec;

use crate::{ProofmanError, ProofmanResult};
use gates::{custom_gate_fully_known_and_satisfied, try_solve_custom_gate, verify_custom_gate};

const GOLDILOCKS_MODULUS: u64 = 0xFFFF_FFFF_0000_0001;
const GOLDILOCKS_P_MINUS_ONE: u64 = GOLDILOCKS_MODULUS - 1;

#[derive(Debug)]
pub struct NativeRecursiveRuntime {
    pub template_id: u64,
    pub size_witness_words: u64,
    pub n_publics: u64,
    pub public_input_offset_words: u64,
    pub public_input_copy_words: u64,
    pub copy_indices: Vec<u64>,
    pub source_assertions: Vec<NativeRuntimeAssertion>,
    pub source_public_prefix_words: u64,
    pub source_sections: Vec<NativeRuntimeSection>,
    pub section_copy_ops: Vec<NativeRuntimeSectionCopyOp>,
    pub source_alias_checks: Vec<NativeRuntimeSourceAliasCheck>,
    pub ignored_source_words: Vec<u64>,
    pub constraints: Vec<NativeRuntimeConstraint>,
    pub custom_gates: Vec<NativeRuntimeCustomGate>,
    solver_index: OnceLock<NativeRuntimeSolverIndex>,
    solve_plan: OnceLock<NativeRuntimeSolvePlan>,
    solve_plan_build_lock: Mutex<()>,
}

#[derive(Debug)]
struct NativeRuntimeSolverIndex {
    dependencies: Vec<NativeRuntimeDependency>,
    dependency_offsets: Option<Vec<u32>>,
    boolean_signals: Vec<u64>,
    inverse_protected_signals: Vec<u64>,
}

#[derive(Debug)]
struct NativeRuntimeSolvePlan {
    witness_len: usize,
    initial_known_count: usize,
    initial_known_fingerprint: u64,
    steps: Vec<NativeRuntimeSolveStep>,
}

#[derive(Debug, Clone, Copy)]
struct NativeRuntimeSolveStep {
    code: u32,
    signal: u32,
}

#[derive(Debug, Default)]
struct NativeRuntimeSolveStats {
    processed_constraints: usize,
    processed_gates: usize,
    solved_constraints: usize,
    solved_gates: usize,
    cached_plan: bool,
    plan_steps: usize,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct NativeRuntimeDependency {
    signal: u64,
    code: u32,
    part: u8,
    bit_term: bool,
}

#[derive(Debug, Clone, Copy)]
struct ConstraintSolveState {
    a_unknown: usize,
    b_unknown: usize,
    c_unknown: usize,
    c_unknown_non_bit: usize,
}

#[derive(Debug, Clone, Copy)]
struct GateSolveState {
    a_unknown: usize,
    b_unknown: usize,
    output_unknown: usize,
    cmul: bool,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct NativeRuntimeAssertion {
    pub source_word: u64,
    pub expected: u64,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct NativeRuntimeSection {
    pub start_word: u64,
    pub word_len: u64,
    pub kind: u64,
    pub flags: u64,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct NativeRuntimeSectionCopyOp {
    pub section_index: u64,
    pub section_offset_words: u64,
    pub word_len: u64,
    pub witness_offset_words: u64,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct NativeRuntimeSourceAliasCheck {
    pub first_source_word: u64,
    pub aliased_source_word: u64,
    pub witness_word: u64,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct NativeRuntimeConstraint {
    pub a: Vec<NativeRuntimeLcTerm>,
    pub b: Vec<NativeRuntimeLcTerm>,
    pub c: Vec<NativeRuntimeLcTerm>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct NativeRuntimeLcTerm {
    pub signal: u64,
    pub coeff: u64,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct NativeRuntimeCustomGate {
    pub kind: NativeRuntimeCustomGateKind,
    pub parameters: Vec<u64>,
    pub signals: Vec<u64>,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum NativeRuntimeCustomGateKind {
    CMul,
    EvPol4,
    TreeSelector4,
    SelectValue1,
    FFT4,
    Poseidon16,
    CustPoseidon16,
}

const DEPENDENCY_GATE_FLAG: u32 = 1 << 31;
const DEP_PART_A: u8 = 0;
const DEP_PART_B: u8 = 1;
const DEP_PART_C: u8 = 2;
const STEP_GENERIC_SIGNAL: u32 = u32::MAX;
type KnownValue = u8;
const UNKNOWN_VALUE: KnownValue = 0;
const KNOWN_VALUE: KnownValue = 1;
type SignalList = SmallVec<[usize; 8]>;
type GateSignalList = SmallVec<[usize; 256]>;
type UnknownLcTerms<F> = SmallVec<[(usize, F); 4]>;

#[inline(always)]
fn known_value(value: KnownValue) -> bool {
    value != UNKNOWN_VALUE
}

#[inline(always)]
fn is_known(known: &[KnownValue], signal: usize) -> bool {
    known_value(known[signal])
}

#[inline(always)]
fn set_known(known: &mut [KnownValue], signal: usize) {
    known[signal] = KNOWN_VALUE;
}

impl NativeRuntimeSolvePlan {
    fn is_compatible(&self, witness_len: usize, initial_known: (usize, u64)) -> bool {
        self.witness_len == witness_len
            && self.initial_known_count == initial_known.0
            && self.initial_known_fingerprint == initial_known.1
    }
}

impl NativeRuntimeSolverIndex {
    fn build(runtime: &NativeRecursiveRuntime) -> Self {
        let mut boolean_signals = Vec::new();
        let mut inverse_protected_signals = Vec::new();

        for constraint in &runtime.constraints {
            if let Some(signal) = boolean_signal(constraint) {
                boolean_signals.push(signal);
            }
            if !direct_signal_equality(constraint) {
                push_lc_signals(&mut inverse_protected_signals, &constraint.a);
                push_lc_signals(&mut inverse_protected_signals, &constraint.b);
                push_lc_signals(&mut inverse_protected_signals, &constraint.c);
            }
        }
        boolean_signals.sort_unstable();
        boolean_signals.dedup();
        inverse_protected_signals.sort_unstable();
        inverse_protected_signals.dedup();

        let mut dependencies = Vec::new();
        for (constraint_index, constraint) in runtime.constraints.iter().enumerate() {
            if constraint_index >= DEPENDENCY_GATE_FLAG as usize {
                break;
            }
            let code = constraint_index as u32;
            push_lc_dependencies(&mut dependencies, &constraint.a, code, DEP_PART_A, &boolean_signals);
            push_lc_dependencies(&mut dependencies, &constraint.b, code, DEP_PART_B, &boolean_signals);
            push_lc_dependencies(&mut dependencies, &constraint.c, code, DEP_PART_C, &boolean_signals);
        }
        for (gate_index, gate) in runtime.custom_gates.iter().enumerate() {
            if gate_index >= DEPENDENCY_GATE_FLAG as usize {
                break;
            }
            let code = DEPENDENCY_GATE_FLAG | gate_index as u32;
            push_gate_dependencies(&mut dependencies, gate, code);
        }
        dependencies.sort_unstable_by_key(|dependency| (dependency.signal, dependency.code, dependency.part));
        let dependency_offsets = build_dependency_offsets(&dependencies);
        Self { dependencies, dependency_offsets, boolean_signals, inverse_protected_signals }
    }

    fn dependency_range(&self, signal: u64) -> std::ops::Range<usize> {
        if let Some(offsets) = &self.dependency_offsets {
            if let Ok(signal) = usize::try_from(signal) {
                if signal + 1 < offsets.len() {
                    return offsets[signal] as usize..offsets[signal + 1] as usize;
                }
            }
            return self.dependencies.len()..self.dependencies.len();
        }
        let start = self.dependencies.partition_point(|dependency| dependency.signal < signal);
        let end = start + self.dependencies[start..].partition_point(|dependency| dependency.signal == signal);
        start..end
    }

    fn is_boolean_signal(&self, signal: u64) -> bool {
        self.boolean_signals.binary_search(&signal).is_ok()
    }

    fn can_inverse_solve(&self, signals: &[usize]) -> bool {
        signals.iter().all(|&signal| self.inverse_protected_signals.binary_search(&(signal as u64)).is_err())
    }
}

fn build_dependency_offsets(dependencies: &[NativeRuntimeDependency]) -> Option<Vec<u32>> {
    if dependencies.len() < 1_000_000 || dependencies.len() > u32::MAX as usize {
        return None;
    }
    let max_signal = usize::try_from(dependencies.last()?.signal).ok()?;
    let len = max_signal.checked_add(2)?;
    if len > dependencies.len() {
        return None;
    }

    let mut offsets = vec![0u32; len];
    let mut current_signal = 0usize;
    for (index, dependency) in dependencies.iter().enumerate() {
        let signal = dependency.signal as usize;
        while current_signal <= signal {
            offsets[current_signal] = index as u32;
            current_signal += 1;
        }
    }
    while current_signal < offsets.len() {
        offsets[current_signal] = dependencies.len() as u32;
        current_signal += 1;
    }
    Some(offsets)
}

fn push_lc_dependencies(
    dependencies: &mut Vec<NativeRuntimeDependency>,
    terms: &[NativeRuntimeLcTerm],
    code: u32,
    part: u8,
    boolean_signals: &[u64],
) {
    for term in terms {
        dependencies.push(NativeRuntimeDependency {
            signal: term.signal,
            code,
            part,
            bit_term: boolean_signals.binary_search(&term.signal).is_ok()
                && coefficient_power_of_two(term.coeff).is_some(),
        });
    }
}

fn push_gate_dependencies(dependencies: &mut Vec<NativeRuntimeDependency>, gate: &NativeRuntimeCustomGate, code: u32) {
    let (a_range, b_range, output_range) = gate_dependency_ranges(gate);
    for signal in gate.signals.get(a_range).unwrap_or_default() {
        dependencies.push(NativeRuntimeDependency { signal: *signal, code, part: DEP_PART_A, bit_term: false });
    }
    for signal in gate.signals.get(b_range).unwrap_or_default() {
        dependencies.push(NativeRuntimeDependency { signal: *signal, code, part: DEP_PART_B, bit_term: false });
    }
    for signal in gate.signals.get(output_range).unwrap_or_default() {
        dependencies.push(NativeRuntimeDependency { signal: *signal, code, part: DEP_PART_C, bit_term: false });
    }
}

fn gate_dependency_ranges(
    gate: &NativeRuntimeCustomGate,
) -> (std::ops::Range<usize>, std::ops::Range<usize>, std::ops::Range<usize>) {
    match gate.kind {
        NativeRuntimeCustomGateKind::CMul => (0..3, 3..6, 6..9),
        NativeRuntimeCustomGateKind::EvPol4 => (0..18, 0..0, 18..21),
        NativeRuntimeCustomGateKind::TreeSelector4 => (0..14, 0..0, 14..17),
        NativeRuntimeCustomGateKind::SelectValue1 => (0..18, 0..0, 18..22),
        NativeRuntimeCustomGateKind::FFT4 => (0..12, 0..0, 12..24),
        NativeRuntimeCustomGateKind::Poseidon16 => (0..16, 0..0, 16..224),
        NativeRuntimeCustomGateKind::CustPoseidon16 => (0..18, 0..0, 18..226),
    }
}

fn push_lc_signals(signals: &mut Vec<u64>, terms: &[NativeRuntimeLcTerm]) {
    for term in terms {
        if term.signal != 0 {
            signals.push(term.signal);
        }
    }
}

fn direct_signal_equality(constraint: &NativeRuntimeConstraint) -> bool {
    if !constraint.a.is_empty() || !constraint.b.is_empty() || constraint.c.len() != 2 {
        return false;
    }
    let left = &constraint.c[0];
    let right = &constraint.c[1];
    if left.signal == 0 || right.signal == 0 {
        return false;
    }
    (left.coeff == 1 && right.coeff == GOLDILOCKS_P_MINUS_ONE)
        || (left.coeff == GOLDILOCKS_P_MINUS_ONE && right.coeff == 1)
}

fn boolean_signal(constraint: &NativeRuntimeConstraint) -> Option<u64> {
    if !constraint.c.is_empty() {
        return None;
    }
    boolean_signal_from_lcs(&constraint.a, &constraint.b)
        .or_else(|| boolean_signal_from_lcs(&constraint.b, &constraint.a))
}

fn boolean_signal_from_lcs(a: &[NativeRuntimeLcTerm], b: &[NativeRuntimeLcTerm]) -> Option<u64> {
    if a.len() != 2 || b.len() != 1 || b[0].coeff != 1 {
        return None;
    }
    let signal = b[0].signal;
    let mut has_signal = false;
    let mut has_minus_one = false;
    for term in a {
        if term.signal == signal && term.coeff == 1 {
            has_signal = true;
        } else if term.signal == 0 && term.coeff == GOLDILOCKS_P_MINUS_ONE {
            has_minus_one = true;
        } else {
            return None;
        }
    }
    (has_signal && has_minus_one).then_some(signal)
}

impl NativeRecursiveRuntime {
    pub fn generate_witness<F: PrimeField64>(
        &self,
        source_words: &[u64],
        total_witness_words: u64,
    ) -> ProofmanResult<Vec<F>> {
        let timing = std::env::var_os("PROOFMAN_DEBUG_NATIVE_TIMING").is_some();
        let total_start = Instant::now();
        self.check_witness_size(total_witness_words)?;
        self.check_source_assertions(source_words)?;
        self.check_source_aliases(source_words)?;

        let mut witness = vec![F::ZERO; total_witness_words as usize];
        let mut known = vec![UNKNOWN_VALUE; total_witness_words as usize];
        if !witness.is_empty() {
            witness[0] = F::ONE;
            known[0] = KNOWN_VALUE;
        }

        let prefix_words = self
            .source_public_prefix_words
            .min(self.size_witness_words.saturating_sub(1))
            .min(source_words.len() as u64);
        for offset in 0..prefix_words {
            witness[(1 + offset) as usize] = F::from_u64(source_words[offset as usize]);
            known[(1 + offset) as usize] = KNOWN_VALUE;
        }

        if self.copy_indices.is_empty() {
            let copy_words = self
                .public_input_copy_words
                .min(source_words.len() as u64)
                .min(self.size_witness_words.saturating_sub(self.public_input_offset_words));
            for offset in 0..copy_words {
                let dst = self.public_input_offset_words + offset;
                witness[dst as usize] = F::from_u64(source_words[offset as usize]);
                known[dst as usize] = KNOWN_VALUE;
            }
        } else {
            for (offset, source_index) in self.copy_indices.iter().enumerate() {
                if offset as u64 >= self.public_input_copy_words {
                    break;
                }
                let dst = self.public_input_offset_words + offset as u64;
                if dst >= self.size_witness_words {
                    break;
                }
                if let Some(value) = source_words.get(*source_index as usize) {
                    witness[dst as usize] = F::from_u64(*value);
                    known[dst as usize] = KNOWN_VALUE;
                }
            }
        }

        for copy_op in &self.section_copy_ops {
            let section = self.source_sections.get(copy_op.section_index as usize).ok_or_else(|| {
                ProofmanError::InvalidSetup(format!(
                    "native recursive section copy references missing section {}",
                    copy_op.section_index
                ))
            })?;
            let section_copy_end = copy_op.section_offset_words.checked_add(copy_op.word_len).ok_or_else(|| {
                ProofmanError::InvalidSetup("native recursive section copy section offset overflow".to_string())
            })?;
            if section_copy_end > section.word_len {
                return Err(ProofmanError::InvalidSetup(
                    "native recursive section copy exceeds section length".to_string(),
                ));
            }
            let source_start = section.start_word.checked_add(copy_op.section_offset_words).ok_or_else(|| {
                ProofmanError::InvalidSetup("native recursive section copy source overflow".to_string())
            })?;
            let source_end = source_start.checked_add(copy_op.word_len).ok_or_else(|| {
                ProofmanError::InvalidSetup("native recursive section copy source overflow".to_string())
            })?;
            let witness_end = copy_op.witness_offset_words.checked_add(copy_op.word_len).ok_or_else(|| {
                ProofmanError::InvalidSetup("native recursive section copy destination overflow".to_string())
            })?;
            if source_end > source_words.len() as u64 || witness_end > self.size_witness_words {
                return Err(ProofmanError::InvalidSetup("native recursive section copy is out of bounds".to_string()));
            }
            for offset in 0..copy_op.word_len {
                witness[(copy_op.witness_offset_words + offset) as usize] =
                    F::from_u64(source_words[(source_start + offset) as usize]);
                known[(copy_op.witness_offset_words + offset) as usize] = KNOWN_VALUE;
            }
        }

        let copy_elapsed = total_start.elapsed();
        self.solve_constraints(&mut witness, &mut known)?;
        if timing {
            tracing::error!(
                "Native recursive witness timing: witness_words={} source_words={} publics={} constraints={} gates={} copy_ops={} copy_ms={} total_ms={}",
                total_witness_words,
                source_words.len(),
                self.n_publics,
                self.constraints.len(),
                self.custom_gates.len(),
                self.section_copy_ops.len(),
                copy_elapsed.as_millis(),
                total_start.elapsed().as_millis()
            );
        }
        if std::env::var_os("PROOFMAN_DEBUG_CHALLENGE").is_some() && self.n_publics > 0 {
            let public_end = (1 + self.n_publics as usize).min(witness.len());
            let unknown_publics = known[1..public_end].iter().filter(|&&value| !known_value(value)).count();
            let prefix_end = (1 + 16usize).min(public_end);
            let prefix = witness[1..prefix_end].iter().map(|value| value.as_canonical_u64()).collect::<Vec<_>>();
            tracing::error!(
                "Native recursive witness publics: n_publics={} unknown_publics={} prefix={:?}",
                self.n_publics,
                unknown_publics,
                prefix
            );
        }

        Ok(witness)
    }

    fn check_witness_size(&self, total_witness_words: u64) -> ProofmanResult<()> {
        if total_witness_words < self.size_witness_words {
            return Err(ProofmanError::InvalidSetup(format!(
                "native recursive witness buffer has {total_witness_words} words but base witness requires {}",
                self.size_witness_words
            )));
        }
        Ok(())
    }

    fn check_source_assertions(&self, source_words: &[u64]) -> ProofmanResult<()> {
        for assertion in &self.source_assertions {
            let actual = source_words.get(assertion.source_word as usize).ok_or_else(|| {
                ProofmanError::InvalidProof(format!(
                    "native recursive source assertion reads missing word {}",
                    assertion.source_word
                ))
            })?;
            if *actual != assertion.expected {
                return Err(ProofmanError::InvalidProof(format!(
                    "native recursive source assertion failed at word {}: expected {}, got {}",
                    assertion.source_word, assertion.expected, actual
                )));
            }
        }
        Ok(())
    }

    fn check_source_aliases(&self, source_words: &[u64]) -> ProofmanResult<()> {
        for check in &self.source_alias_checks {
            let first = source_words.get(check.first_source_word as usize).ok_or_else(|| {
                ProofmanError::InvalidProof(format!(
                    "native recursive source alias reads missing word {}",
                    check.first_source_word
                ))
            })?;
            let aliased = source_words.get(check.aliased_source_word as usize).ok_or_else(|| {
                ProofmanError::InvalidProof(format!(
                    "native recursive source alias reads missing word {}",
                    check.aliased_source_word
                ))
            })?;
            if first != aliased {
                return Err(ProofmanError::InvalidProof(format!(
                    "native recursive source words {} and {} alias witness word {} but differ: {} != {}",
                    check.first_source_word, check.aliased_source_word, check.witness_word, first, aliased
                )));
            }
        }
        Ok(())
    }

    fn solve_constraints<F: PrimeField64>(&self, witness: &mut [F], known: &mut [KnownValue]) -> ProofmanResult<()> {
        if self.constraints.is_empty() && self.custom_gates.is_empty() {
            return Ok(());
        }

        let timing = std::env::var_os("PROOFMAN_DEBUG_NATIVE_TIMING").is_some();
        let initial_known = known_fingerprint(known);
        let index_ready = self.solver_index.get().is_some();
        let index_start = Instant::now();
        let solver_index = self.solver_index.get_or_init(|| NativeRuntimeSolverIndex::build(self));
        if timing && !index_ready {
            tracing::error!(
                "Native recursive solver index built: constraints={} gates={} dependencies={} ms={}",
                self.constraints.len(),
                self.custom_gates.len(),
                solver_index.dependencies.len(),
                index_start.elapsed().as_millis()
            );
        }

        let solve_start = Instant::now();
        let mut plan_to_set = None;
        let mut plan_guard = None;
        let stats = if let Some(plan) = self.compatible_solve_plan(witness.len(), initial_known) {
            self.execute_solve_plan_with_fallback(plan, witness, known, solver_index)?
        } else {
            let guard = self
                .solve_plan_build_lock
                .lock()
                .map_err(|_| ProofmanError::InvalidSetup("native recursive solve plan lock is poisoned".to_string()))?;
            if let Some(plan) = self.compatible_solve_plan(witness.len(), initial_known) {
                drop(guard);
                self.execute_solve_plan_with_fallback(plan, witness, known, solver_index)?
            } else if self.solve_plan.get().is_none() {
                let (stats, steps) = self.solve_constraints_dynamic(witness, known, solver_index, true)?;
                plan_to_set = steps.map(|steps| NativeRuntimeSolvePlan {
                    witness_len: witness.len(),
                    initial_known_count: initial_known.0,
                    initial_known_fingerprint: initial_known.1,
                    steps,
                });
                plan_guard = Some(guard);
                stats
            } else {
                drop(guard);
                self.solve_constraints_dynamic(witness, known, solver_index, false)?.0
            }
        };
        let solve_elapsed = solve_start.elapsed();

        self.log_unresolved_signals(known);
        let (verify_gates_elapsed, verify_constraints_elapsed) =
            if std::env::var_os("VENUS_SKIP_NATIVE_RECURSIVE_VERIFY").is_some() {
                (std::time::Duration::ZERO, std::time::Duration::ZERO)
            } else {
                self.verify_solved_witness(witness, known)?
            };
        if let Some(plan) = plan_to_set {
            let _ = self.solve_plan.set(plan);
        }
        drop(plan_guard);

        if timing {
            tracing::error!(
                "Native recursive solver timing: constraints={} gates={} processed_constraints={} processed_gates={} solved_constraints={} solved_gates={} cached_plan={} plan_steps={} queue_ms={} verify_gates_ms={} verify_constraints_ms={}",
                self.constraints.len(),
                self.custom_gates.len(),
                stats.processed_constraints,
                stats.processed_gates,
                stats.solved_constraints,
                stats.solved_gates,
                stats.cached_plan,
                stats.plan_steps,
                solve_elapsed.as_millis(),
                verify_gates_elapsed.as_millis(),
                verify_constraints_elapsed.as_millis()
            );
        }

        Ok(())
    }

    fn compatible_solve_plan(
        &self,
        witness_len: usize,
        initial_known: (usize, u64),
    ) -> Option<&NativeRuntimeSolvePlan> {
        self.solve_plan.get().filter(|plan| plan.is_compatible(witness_len, initial_known))
    }

    fn solve_constraints_dynamic<F: PrimeField64>(
        &self,
        witness: &mut [F],
        known: &mut [KnownValue],
        solver_index: &NativeRuntimeSolverIndex,
        record_steps: bool,
    ) -> ProofmanResult<(NativeRuntimeSolveStats, Option<Vec<NativeRuntimeSolveStep>>)> {
        let mut constraint_states = build_constraint_states(&self.constraints, known, solver_index)?;
        let mut gate_states = build_gate_states(&self.custom_gates, known)?;
        let mut queue = VecDeque::with_capacity(self.constraints.len() + self.custom_gates.len());
        let mut queued_constraints = vec![false; self.constraints.len()];
        let mut queued_gates = vec![false; self.custom_gates.len()];
        for (constraint_index, constraint) in self.constraints.iter().enumerate() {
            if constraint_state_maybe_ready(constraint, constraint_states[constraint_index]) {
                queued_constraints[constraint_index] = true;
                queue.push_back(constraint_index as u32);
            }
        }
        for (gate_index, _) in self.custom_gates.iter().enumerate() {
            if gate_state_maybe_ready(gate_states[gate_index]) {
                queued_gates[gate_index] = true;
                queue.push_back(DEPENDENCY_GATE_FLAG | gate_index as u32);
            }
        }

        let mut stats = NativeRuntimeSolveStats::default();
        let mut steps = record_steps.then(|| Vec::with_capacity(self.constraints.len() + self.custom_gates.len()));
        while let Some(code) = queue.pop_front() {
            if code & DEPENDENCY_GATE_FLAG == 0 {
                let constraint_index = code as usize;
                queued_constraints[constraint_index] = false;
                let constraint = &self.constraints[constraint_index];
                stats.processed_constraints += 1;
                let solved_signals =
                    self.try_solve_constraint(constraint_index, constraint, witness, known, solver_index)?;
                if !solved_signals.is_empty() {
                    stats.solved_constraints += 1;
                    if let Some(steps) = &mut steps {
                        let signal = if solved_signals.len() == 1 {
                            u32::try_from(solved_signals[0]).unwrap_or(STEP_GENERIC_SIGNAL)
                        } else {
                            STEP_GENERIC_SIGNAL
                        };
                        steps.push(NativeRuntimeSolveStep { code, signal });
                    }
                    for signal in solved_signals {
                        enqueue_dependents(
                            signal as u64,
                            self,
                            solver_index,
                            &mut constraint_states,
                            &mut gate_states,
                            &mut queue,
                            &mut queued_constraints,
                            &mut queued_gates,
                        )?;
                    }
                }
            } else {
                let gate_index = (code & !DEPENDENCY_GATE_FLAG) as usize;
                queued_gates[gate_index] = false;
                let gate = &self.custom_gates[gate_index];
                stats.processed_gates += 1;
                let unknown_before = gate
                    .signals
                    .iter()
                    .copied()
                    .filter(|&signal| {
                        usize::try_from(signal)
                            .ok()
                            .and_then(|idx| known.get(idx))
                            .map(|&value| !known_value(value))
                            .unwrap_or(false)
                    })
                    .collect::<SmallVec<[u64; 256]>>();
                if try_solve_custom_gate(gate, witness, known, solver_index)? {
                    stats.solved_gates += 1;
                    if let Some(steps) = &mut steps {
                        steps.push(NativeRuntimeSolveStep { code, signal: STEP_GENERIC_SIGNAL });
                    }
                    for signal in unknown_before {
                        if usize::try_from(signal).ok().and_then(|idx| known.get(idx)).copied().map(known_value)
                            != Some(true)
                        {
                            continue;
                        }
                        enqueue_dependents(
                            signal,
                            self,
                            solver_index,
                            &mut constraint_states,
                            &mut gate_states,
                            &mut queue,
                            &mut queued_constraints,
                            &mut queued_gates,
                        )?;
                    }
                }
            }
        }
        if let Some(steps) = &steps {
            stats.plan_steps = steps.len();
        }
        Ok((stats, steps))
    }

    fn execute_solve_plan<F: PrimeField64>(
        &self,
        plan: &NativeRuntimeSolvePlan,
        witness: &mut [F],
        known: &mut [KnownValue],
        solver_index: &NativeRuntimeSolverIndex,
    ) -> ProofmanResult<NativeRuntimeSolveStats> {
        let mut stats =
            NativeRuntimeSolveStats { cached_plan: true, plan_steps: plan.steps.len(), ..Default::default() };
        for &step in &plan.steps {
            let code = step.code;
            if code & DEPENDENCY_GATE_FLAG == 0 {
                let constraint_index = code as usize;
                let constraint = &self.constraints[constraint_index];
                stats.processed_constraints += 1;
                let solved = if step.signal == STEP_GENERIC_SIGNAL {
                    !self.try_solve_constraint(constraint_index, constraint, witness, known, solver_index)?.is_empty()
                } else {
                    self.solve_planned_single_constraint(
                        constraint_index,
                        constraint,
                        step.signal as usize,
                        witness,
                        known,
                    )?
                };
                if !solved {
                    if !constraint_fully_known_and_satisfied(constraint_index, constraint, witness, known)? {
                        return Err(ProofmanError::InvalidProof(format!(
                            "native recursive cached solve plan did not solve constraint {constraint_index}"
                        )));
                    }
                } else {
                    stats.solved_constraints += 1;
                }
            } else {
                let gate_index = (code & !DEPENDENCY_GATE_FLAG) as usize;
                let gate = &self.custom_gates[gate_index];
                stats.processed_gates += 1;
                if !try_solve_custom_gate(gate, witness, known, solver_index)? {
                    if !custom_gate_fully_known_and_satisfied(gate, witness, known)? {
                        return Err(ProofmanError::InvalidProof(format!(
                            "native recursive cached solve plan did not solve custom gate {gate_index}"
                        )));
                    }
                } else {
                    stats.solved_gates += 1;
                }
            }
        }
        Ok(stats)
    }

    fn solve_planned_single_constraint<F: PrimeField64>(
        &self,
        constraint_index: usize,
        constraint: &NativeRuntimeConstraint,
        signal: usize,
        witness: &mut [F],
        known: &mut [KnownValue],
    ) -> ProofmanResult<bool> {
        if signal >= witness.len() {
            return Err(ProofmanError::InvalidSetup(format!(
                "native recursive cached solve plan references signal {signal} outside witness size {}",
                witness.len()
            )));
        }
        if is_known(known, signal) {
            return Ok(false);
        }

        let a = eval_lc_except_signal(&constraint.a, signal, witness, known)?;
        let b = eval_lc_except_signal(&constraint.b, signal, witness, known)?;
        let c = eval_lc_except_signal(&constraint.c, signal, witness, known)?;

        let value = if !a.output_coeff.is_zero() {
            if !a.others_known
                || !b.others_known
                || !c.others_known
                || !b.output_coeff.is_zero()
                || !c.output_coeff.is_zero()
            {
                return Ok(false);
            }
            let divisor = a.output_coeff * b.value;
            if divisor.is_zero() {
                return Ok(false);
            }
            (c.value - a.value * b.value) / divisor
        } else if !b.output_coeff.is_zero() {
            if !a.others_known
                || !b.others_known
                || !c.others_known
                || !a.output_coeff.is_zero()
                || !c.output_coeff.is_zero()
            {
                return Ok(false);
            }
            let divisor = b.output_coeff * a.value;
            if divisor.is_zero() {
                return Ok(false);
            }
            (c.value - a.value * b.value) / divisor
        } else if !c.output_coeff.is_zero() {
            if !a.output_coeff.is_zero() || !b.output_coeff.is_zero() {
                return Ok(false);
            }
            if a.others_known && b.others_known {
                (a.value * b.value - c.value) / c.output_coeff
            } else if (a.others_known && a.value.is_zero()) || (b.others_known && b.value.is_zero()) {
                -c.value / c.output_coeff
            } else {
                return Ok(false);
            }
        } else {
            return Ok(false);
        };

        if is_known(known, signal) {
            if witness[signal] != value {
                return Err(ProofmanError::InvalidProof(format!(
                    "native recursive cached solve plan produced conflicting value for signal {signal} in constraint {constraint_index}"
                )));
            }
            Ok(false)
        } else {
            witness[signal] = value;
            set_known(known, signal);
            Ok(true)
        }
    }

    fn execute_solve_plan_with_fallback<F: PrimeField64>(
        &self,
        plan: &NativeRuntimeSolvePlan,
        witness: &mut [F],
        known: &mut [KnownValue],
        solver_index: &NativeRuntimeSolverIndex,
    ) -> ProofmanResult<NativeRuntimeSolveStats> {
        let known_backup = known.to_vec();
        match self.execute_solve_plan(plan, witness, known, solver_index) {
            Ok(stats) => Ok(stats),
            Err(err) => {
                known.copy_from_slice(&known_backup);
                tracing::debug!("Falling back after native recursive solve plan replay miss: {err}");
                self.solve_constraints_dynamic(witness, known, solver_index, false).map(|(stats, _)| stats)
            }
        }
    }

    fn log_unresolved_signals(&self, known: &[KnownValue]) {
        if std::env::var_os("PROOFMAN_DEBUG_NATIVE_UNRESOLVED").is_some() {
            let unknown_count = known.iter().filter(|&&value| !known_value(value)).count();
            let first_unknown = known.iter().position(|&value| !known_value(value));
            tracing::error!(
                "Native recursive unresolved witness signals: unknown_count={} first_unknown={:?} witness_len={}",
                unknown_count,
                first_unknown,
                known.len()
            );
            for (gate_index, gate) in self.custom_gates.iter().enumerate() {
                let unresolved = gate
                    .signals
                    .iter()
                    .copied()
                    .filter(|&signal| {
                        usize::try_from(signal)
                            .ok()
                            .and_then(|idx| known.get(idx))
                            .map(|&value| !known_value(value))
                            .unwrap_or(true)
                    })
                    .take(16)
                    .collect::<Vec<_>>();
                if !unresolved.is_empty() {
                    tracing::error!(
                        "Native recursive first unresolved custom gate: index={} kind={:?} unresolved_prefix={:?} signals_prefix={:?}",
                        gate_index,
                        gate.kind,
                        unresolved,
                        &gate.signals[..gate.signals.len().min(24)]
                    );
                    break;
                }
            }
        }
    }

    fn verify_solved_witness<F: PrimeField64>(
        &self,
        witness: &[F],
        known: &[KnownValue],
    ) -> ProofmanResult<(std::time::Duration, std::time::Duration)> {
        let verify_gates_start = Instant::now();
        for gate in &self.custom_gates {
            verify_custom_gate(gate, witness, known)?;
        }
        let verify_gates_elapsed = verify_gates_start.elapsed();

        let verify_constraints_start = Instant::now();
        for (constraint_index, constraint) in self.constraints.iter().enumerate() {
            let a = eval_lc(&constraint.a, witness, known)?;
            let b = eval_lc(&constraint.b, witness, known)?;
            let c = eval_lc(&constraint.c, witness, known)?;
            if a.unknown.is_empty() && b.unknown.is_empty() && c.unknown.is_empty() && a.value * b.value != c.value {
                return Err(ProofmanError::InvalidProof(format_constraint_failure(
                    "native recursive R1CS witness does not satisfy constraint",
                    constraint_index,
                    constraint,
                    &a,
                    &b,
                    &c,
                    witness,
                    known,
                )));
            }
        }
        Ok((verify_gates_elapsed, verify_constraints_start.elapsed()))
    }

    fn try_solve_constraint<F: PrimeField64>(
        &self,
        constraint_index: usize,
        constraint: &NativeRuntimeConstraint,
        witness: &mut [F],
        known: &mut [KnownValue],
        solver_index: &NativeRuntimeSolverIndex,
    ) -> ProofmanResult<SignalList> {
        if constraint.a.is_empty() && constraint.b.is_empty() {
            if let Some(solved) = try_solve_linear_c_constraint(constraint_index, &constraint.c, witness, known)? {
                return Ok(solved);
            }
        }

        let a = eval_lc(&constraint.a, witness, known)?;
        let b = eval_lc(&constraint.b, witness, known)?;
        let c = eval_lc(&constraint.c, witness, known)?;

        if a.unknown.len() == 1 && b.unknown.is_empty() && c.unknown.is_empty() && !b.value.is_zero() {
            let desired = c.value / b.value;
            return solve_single_unknown(&a, desired, witness, known);
        }
        if b.unknown.len() == 1 && a.unknown.is_empty() && c.unknown.is_empty() && !a.value.is_zero() {
            let desired = c.value / a.value;
            return solve_single_unknown(&b, desired, witness, known);
        }
        if c.unknown.len() == 1 && a.unknown.is_empty() && b.unknown.is_empty() {
            let desired = a.value * b.value;
            return solve_single_unknown(&c, desired, witness, known);
        }
        if c.unknown.len() == 1
            && ((a.unknown.is_empty() && a.value.is_zero()) || (b.unknown.is_empty() && b.value.is_zero()))
        {
            return solve_single_unknown(&c, F::ZERO, witness, known);
        }

        if let Some(signals) = try_solve_bit_decomposition(constraint, witness, known, solver_index)? {
            return Ok(signals);
        }

        if a.unknown.is_empty() && b.unknown.is_empty() && c.unknown.is_empty() && a.value * b.value != c.value {
            return Err(ProofmanError::InvalidProof(format_constraint_failure(
                "native recursive R1CS constraint failed during witness solving",
                constraint_index,
                constraint,
                &a,
                &b,
                &c,
                witness,
                known,
            )));
        }

        Ok(SignalList::new())
    }
}

#[derive(Debug)]
struct LcEval<F: PrimeField64> {
    value: F,
    unknown: UnknownLcTerms<F>,
}

#[derive(Debug)]
struct LcEvalExcept<F: PrimeField64> {
    value: F,
    output_coeff: F,
    others_known: bool,
}

fn known_fingerprint(known: &[KnownValue]) -> (usize, u64) {
    const MIX: u64 = 0x9E37_79B9_7F4A_7C15;
    let mut count = 0usize;
    let mut fingerprint = 0xD6E8_FD9A_8B4C_2F37u64 ^ known.len() as u64;
    let mut chunks = known.chunks_exact(8);
    for (chunk_index, chunk) in chunks.by_ref().enumerate() {
        let word = u64::from_ne_bytes(chunk.try_into().unwrap());
        if word == 0 {
            continue;
        }
        let base = chunk_index * 8;
        for (offset, &value) in chunk.iter().enumerate() {
            if known_value(value) {
                count += 1;
                fingerprint = fingerprint.rotate_left(7) ^ (((base + offset) as u64).wrapping_mul(MIX));
            }
        }
    }
    let base = known.len() - chunks.remainder().len();
    for (offset, &value) in chunks.remainder().iter().enumerate() {
        if known_value(value) {
            count += 1;
            fingerprint = fingerprint.rotate_left(7) ^ (((base + offset) as u64).wrapping_mul(MIX));
        }
    }
    (count, fingerprint)
}

fn eval_lc_except_signal<F: PrimeField64>(
    terms: &[NativeRuntimeLcTerm],
    output_signal: usize,
    witness: &[F],
    known: &[KnownValue],
) -> ProofmanResult<LcEvalExcept<F>> {
    let mut value = F::ZERO;
    let mut output_coeff = F::ZERO;
    for term in terms {
        let signal = usize::try_from(term.signal).map_err(|_| {
            ProofmanError::InvalidSetup(format!("native recursive R1CS signal {} is too large", term.signal))
        })?;
        if signal >= witness.len() {
            return Err(ProofmanError::InvalidSetup(format!(
                "native recursive R1CS signal {signal} is outside witness size {}",
                witness.len()
            )));
        }
        let coeff = F::from_u64(term.coeff);
        if signal == output_signal {
            output_coeff += coeff;
        } else if is_known(known, signal) {
            value += witness[signal] * coeff;
        } else {
            return Ok(LcEvalExcept { value, output_coeff, others_known: false });
        }
    }
    Ok(LcEvalExcept { value, output_coeff, others_known: true })
}

fn eval_lc<F: PrimeField64>(
    terms: &[NativeRuntimeLcTerm],
    witness: &[F],
    known: &[KnownValue],
) -> ProofmanResult<LcEval<F>> {
    let mut value = F::ZERO;
    let mut unknown = UnknownLcTerms::<F>::new();
    for term in terms {
        let signal = usize::try_from(term.signal).map_err(|_| {
            ProofmanError::InvalidSetup(format!("native recursive R1CS signal {} is too large", term.signal))
        })?;
        if signal >= witness.len() {
            return Err(ProofmanError::InvalidSetup(format!(
                "native recursive R1CS signal {signal} is outside witness size {}",
                witness.len()
            )));
        }
        let coeff = F::from_u64(term.coeff);
        if is_known(known, signal) {
            value += witness[signal] * coeff;
        } else {
            unknown.push((signal, coeff));
        }
    }
    Ok(LcEval { value, unknown })
}

fn constraint_fully_known_and_satisfied<F: PrimeField64>(
    constraint_index: usize,
    constraint: &NativeRuntimeConstraint,
    witness: &[F],
    known: &[KnownValue],
) -> ProofmanResult<bool> {
    let a = eval_lc(&constraint.a, witness, known)?;
    let b = eval_lc(&constraint.b, witness, known)?;
    let c = eval_lc(&constraint.c, witness, known)?;
    if !a.unknown.is_empty() || !b.unknown.is_empty() || !c.unknown.is_empty() {
        return Ok(false);
    }
    if a.value * b.value != c.value {
        return Err(ProofmanError::InvalidProof(format_constraint_failure(
            "native recursive cached solve plan found an already-known invalid constraint",
            constraint_index,
            constraint,
            &a,
            &b,
            &c,
            witness,
            known,
        )));
    }
    Ok(true)
}

fn format_constraint_failure<F: PrimeField64>(
    reason: &str,
    constraint_index: usize,
    constraint: &NativeRuntimeConstraint,
    a: &LcEval<F>,
    b: &LcEval<F>,
    c: &LcEval<F>,
    witness: &[F],
    known: &[KnownValue],
) -> String {
    format!(
        "{reason} {constraint_index}: a={} b={} c={} a*b={} A=[{}] B=[{}] C=[{}]",
        a.value.as_canonical_u64(),
        b.value.as_canonical_u64(),
        c.value.as_canonical_u64(),
        (a.value * b.value).as_canonical_u64(),
        format_lc_terms(&constraint.a, witness, known),
        format_lc_terms(&constraint.b, witness, known),
        format_lc_terms(&constraint.c, witness, known)
    )
}

fn format_lc_terms<F: PrimeField64>(terms: &[NativeRuntimeLcTerm], witness: &[F], known: &[KnownValue]) -> String {
    const MAX_TERMS: usize = 8;
    let mut parts = Vec::with_capacity(terms.len().min(MAX_TERMS) + 1);
    for term in terms.iter().take(MAX_TERMS) {
        let value = usize::try_from(term.signal)
            .ok()
            .and_then(|signal| witness.get(signal).zip(known.get(signal)).map(|(value, known)| (value, known)))
            .map(
                |(value, known)| {
                    if known_value(*known) {
                        value.as_canonical_u64().to_string()
                    } else {
                        "unknown".to_string()
                    }
                },
            )
            .unwrap_or_else(|| "out-of-bounds".to_string());
        parts.push(format!("{}*w{}({})", term.coeff, term.signal, value));
    }
    if terms.len() > MAX_TERMS {
        parts.push(format!("...{} more", terms.len() - MAX_TERMS));
    }
    parts.join(", ")
}

fn enqueue_dependents(
    signal: u64,
    runtime: &NativeRecursiveRuntime,
    solver_index: &NativeRuntimeSolverIndex,
    constraint_states: &mut [ConstraintSolveState],
    gate_states: &mut [GateSolveState],
    queue: &mut VecDeque<u32>,
    queued_constraints: &mut [bool],
    queued_gates: &mut [bool],
) -> ProofmanResult<()> {
    let mut touched_constraints = SmallVec::<[usize; 32]>::new();
    let mut touched_gates = SmallVec::<[usize; 32]>::new();
    for dependency_index in solver_index.dependency_range(signal) {
        let dependency = solver_index.dependencies[dependency_index];
        let code = dependency.code;
        if code & DEPENDENCY_GATE_FLAG == 0 {
            let constraint_index = code as usize;
            apply_constraint_dependency(&mut constraint_states[constraint_index], dependency);
            touched_constraints.push(constraint_index);
        } else {
            let gate_index = (code & !DEPENDENCY_GATE_FLAG) as usize;
            apply_gate_dependency(&mut gate_states[gate_index], dependency);
            touched_gates.push(gate_index);
        }
    }

    touched_constraints.sort_unstable();
    touched_constraints.dedup();
    for constraint_index in touched_constraints {
        if !queued_constraints[constraint_index]
            && constraint_state_maybe_ready(&runtime.constraints[constraint_index], constraint_states[constraint_index])
        {
            queued_constraints[constraint_index] = true;
            queue.push_back(constraint_index as u32);
        }
    }

    touched_gates.sort_unstable();
    touched_gates.dedup();
    for gate_index in touched_gates {
        if !queued_gates[gate_index] && gate_state_maybe_ready(gate_states[gate_index]) {
            queued_gates[gate_index] = true;
            queue.push_back(DEPENDENCY_GATE_FLAG | gate_index as u32);
        }
    }
    Ok(())
}

fn apply_constraint_dependency(state: &mut ConstraintSolveState, dependency: NativeRuntimeDependency) {
    match dependency.part {
        DEP_PART_A => decrement_unknown(&mut state.a_unknown),
        DEP_PART_B => decrement_unknown(&mut state.b_unknown),
        DEP_PART_C => {
            decrement_unknown(&mut state.c_unknown);
            if !dependency.bit_term {
                decrement_unknown(&mut state.c_unknown_non_bit);
            }
        }
        _ => {}
    }
}

fn apply_gate_dependency(state: &mut GateSolveState, dependency: NativeRuntimeDependency) {
    match dependency.part {
        DEP_PART_A => decrement_unknown(&mut state.a_unknown),
        DEP_PART_B => decrement_unknown(&mut state.b_unknown),
        DEP_PART_C => decrement_unknown(&mut state.output_unknown),
        _ => {}
    }
}

fn decrement_unknown(count: &mut usize) {
    if *count > 0 {
        *count -= 1;
    }
}

fn constraint_state_maybe_ready(constraint: &NativeRuntimeConstraint, state: ConstraintSolveState) -> bool {
    if state.a_unknown == 1 && state.b_unknown == 0 && state.c_unknown == 0 {
        return true;
    }
    if state.b_unknown == 1 && state.a_unknown == 0 && state.c_unknown == 0 {
        return true;
    }
    if state.c_unknown == 1 && (state.a_unknown == 0 || state.b_unknown == 0) {
        return true;
    }
    if !constraint.a.is_empty() || !constraint.b.is_empty() || constraint.c.is_empty() {
        return false;
    }
    (1..=u64::BITS as usize).contains(&state.c_unknown) && state.c_unknown_non_bit == 0
}

fn build_constraint_states(
    constraints: &[NativeRuntimeConstraint],
    known: &[KnownValue],
    solver_index: &NativeRuntimeSolverIndex,
) -> ProofmanResult<Vec<ConstraintSolveState>> {
    let mut states = Vec::with_capacity(constraints.len());
    for constraint in constraints {
        states.push(ConstraintSolveState {
            a_unknown: count_lc_unknown(&constraint.a, known)?,
            b_unknown: count_lc_unknown(&constraint.b, known)?,
            c_unknown: count_lc_unknown(&constraint.c, known)?,
            c_unknown_non_bit: count_lc_unknown_non_bit(&constraint.c, known, solver_index)?,
        });
    }
    Ok(states)
}

fn count_lc_unknown_non_bit(
    terms: &[NativeRuntimeLcTerm],
    known: &[KnownValue],
    solver_index: &NativeRuntimeSolverIndex,
) -> ProofmanResult<usize> {
    let mut unknown_non_bit = 0usize;
    for term in terms {
        let signal = usize::try_from(term.signal).map_err(|_| {
            ProofmanError::InvalidSetup(format!("native recursive R1CS signal {} is too large", term.signal))
        })?;
        let Some(&is_known) = known.get(signal) else {
            return Err(ProofmanError::InvalidSetup(format!(
                "native recursive R1CS signal {signal} is outside witness size {}",
                known.len()
            )));
        };
        if !known_value(is_known) {
            let is_bit_term =
                solver_index.is_boolean_signal(signal as u64) && coefficient_power_of_two(term.coeff).is_some();
            if !is_bit_term {
                unknown_non_bit += 1;
            }
        }
    }
    Ok(unknown_non_bit)
}

fn build_gate_states(
    custom_gates: &[NativeRuntimeCustomGate],
    known: &[KnownValue],
) -> ProofmanResult<Vec<GateSolveState>> {
    let mut states = Vec::with_capacity(custom_gates.len());
    for gate in custom_gates {
        states.push(gate_solve_state(gate, known)?);
    }
    Ok(states)
}

fn gate_solve_state(gate: &NativeRuntimeCustomGate, known: &[KnownValue]) -> ProofmanResult<GateSolveState> {
    let signals = gate_signal_indices(&gate.signals, known.len())?;
    match gate.kind {
        NativeRuntimeCustomGateKind::CMul => {
            if signals.len() != 9 {
                return Err(ProofmanError::InvalidSetup(format!(
                    "CMul native runtime gate must have 9 signals, got {}",
                    signals.len()
                )));
            }
            Ok(GateSolveState {
                a_unknown: count_unknown_signals(&signals[..3], known),
                b_unknown: count_unknown_signals(&signals[3..6], known),
                output_unknown: count_unknown_signals(&signals[6..9], known),
                cmul: true,
            })
        }
        NativeRuntimeCustomGateKind::EvPol4 => gate_forward_state("EvPol4", &signals, known, 21, 18, 21),
        NativeRuntimeCustomGateKind::TreeSelector4 => gate_forward_state("TreeSelector4", &signals, known, 17, 14, 17),
        NativeRuntimeCustomGateKind::SelectValue1 => gate_forward_state("SelectValue1", &signals, known, 22, 18, 22),
        NativeRuntimeCustomGateKind::FFT4 => gate_forward_state("FFT4", &signals, known, 24, 12, 24),
        NativeRuntimeCustomGateKind::Poseidon16 => gate_forward_state("Poseidon16", &signals, known, 224, 16, 224),
        NativeRuntimeCustomGateKind::CustPoseidon16 => {
            gate_forward_state("CustPoseidon16", &signals, known, 226, 18, 226)
        }
    }
}

fn gate_forward_state(
    gate: &str,
    signals: &[usize],
    known: &[KnownValue],
    expected_len: usize,
    input_len: usize,
    output_end: usize,
) -> ProofmanResult<GateSolveState> {
    if signals.len() != expected_len {
        return Err(ProofmanError::InvalidSetup(format!(
            "{gate} native runtime gate must have {expected_len} signals, got {}",
            signals.len()
        )));
    }
    Ok(GateSolveState {
        a_unknown: count_unknown_signals(&signals[..input_len], known),
        b_unknown: 0,
        output_unknown: count_unknown_signals(&signals[input_len..output_end], known),
        cmul: false,
    })
}

fn gate_state_maybe_ready(state: GateSolveState) -> bool {
    if !state.cmul {
        return state.a_unknown == 0 && state.output_unknown > 0;
    }
    (state.a_unknown == 0 && state.b_unknown == 0 && state.output_unknown > 0)
        || (state.a_unknown == 0 && state.output_unknown == 0 && state.b_unknown > 0)
        || (state.b_unknown == 0 && state.output_unknown == 0 && state.a_unknown > 0)
}

fn gate_signal_indices(signals: &[u64], witness_len: usize) -> ProofmanResult<GateSignalList> {
    let mut out = GateSignalList::with_capacity(signals.len());
    for &signal in signals {
        let signal = usize::try_from(signal).map_err(|_| {
            ProofmanError::InvalidSetup(format!("native recursive custom gate signal {signal} is too large"))
        })?;
        if signal >= witness_len {
            return Err(ProofmanError::InvalidSetup(format!(
                "native recursive custom gate signal {signal} is outside witness size {witness_len}"
            )));
        }
        out.push(signal);
    }
    Ok(out)
}

fn count_unknown_signals(signals: &[usize], known: &[KnownValue]) -> usize {
    signals.iter().filter(|&&signal| !is_known(known, signal)).count()
}

fn count_lc_unknown(terms: &[NativeRuntimeLcTerm], known: &[KnownValue]) -> ProofmanResult<usize> {
    let mut unknown = 0usize;
    for term in terms {
        let signal = usize::try_from(term.signal).map_err(|_| {
            ProofmanError::InvalidSetup(format!("native recursive R1CS signal {} is too large", term.signal))
        })?;
        let Some(&is_known) = known.get(signal) else {
            return Err(ProofmanError::InvalidSetup(format!(
                "native recursive R1CS signal {signal} is outside witness size {}",
                known.len()
            )));
        };
        if !known_value(is_known) {
            unknown += 1;
        }
    }
    Ok(unknown)
}

fn try_solve_bit_decomposition<F: PrimeField64>(
    constraint: &NativeRuntimeConstraint,
    witness: &mut [F],
    known: &mut [KnownValue],
    solver_index: &NativeRuntimeSolverIndex,
) -> ProofmanResult<Option<SignalList>> {
    if !constraint.a.is_empty() || !constraint.b.is_empty() || constraint.c.is_empty() {
        return Ok(None);
    }

    let mut known_value = F::ZERO;
    let mut unknown = SmallVec::<[(usize, u64); 64]>::new();
    for term in &constraint.c {
        let signal = usize::try_from(term.signal).map_err(|_| {
            ProofmanError::InvalidSetup(format!("native recursive R1CS signal {} is too large", term.signal))
        })?;
        if signal >= witness.len() {
            return Err(ProofmanError::InvalidSetup(format!(
                "native recursive R1CS signal {signal} is outside witness size {}",
                witness.len()
            )));
        }
        if is_known(known, signal) {
            known_value += witness[signal] * F::from_u64(term.coeff);
        } else {
            unknown.push((signal, term.coeff));
        }
    }
    if unknown.is_empty() || unknown.len() > u64::BITS as usize {
        return Ok(None);
    }

    let mut sign = None;
    let mut covered_bits = 0u64;
    let mut unknown_with_powers = SmallVec::<[(usize, u64); 64]>::with_capacity(unknown.len());
    for (signal, coeff) in unknown {
        if !solver_index.is_boolean_signal(signal as u64) {
            return Ok(None);
        }
        let Some((term_sign, power)) = coefficient_power_of_two(coeff) else {
            return Ok(None);
        };
        if sign.get_or_insert(term_sign) != &term_sign {
            return Ok(None);
        }
        if covered_bits & power != 0 {
            return Ok(None);
        }
        covered_bits |= power;
        unknown_with_powers.push((signal, power));
    }

    let target = if sign == Some(-1) { known_value } else { -known_value }.as_canonical_u64();
    if target & !covered_bits != 0 {
        return Ok(None);
    }

    let mut solved = SignalList::with_capacity(unknown_with_powers.len());
    for (signal, power) in unknown_with_powers {
        let value = if target & power == 0 { F::ZERO } else { F::ONE };
        if is_known(known, signal) {
            if witness[signal] != value {
                return Err(ProofmanError::InvalidProof(format!(
                    "native recursive bit decomposition solved conflicting value for signal {signal}"
                )));
            }
        } else {
            witness[signal] = value;
            set_known(known, signal);
            solved.push(signal);
        }
    }

    Ok((!solved.is_empty()).then_some(solved))
}

fn coefficient_power_of_two(coeff: u64) -> Option<(i8, u64)> {
    if coeff != 0 && coeff.is_power_of_two() {
        return Some((1, coeff));
    }
    let negative = GOLDILOCKS_MODULUS.checked_sub(coeff)?;
    if negative != 0 && negative.is_power_of_two() {
        return Some((-1, negative));
    }
    None
}

fn solve_single_unknown<F: PrimeField64>(
    lc: &LcEval<F>,
    desired: F,
    witness: &mut [F],
    known: &mut [KnownValue],
) -> ProofmanResult<SignalList> {
    if lc.unknown.len() != 1 {
        return Ok(SignalList::new());
    }
    let (signal, coeff) = lc.unknown[0];
    if coeff.is_zero() {
        return Ok(SignalList::new());
    }
    let value = (desired - lc.value) / coeff;
    if is_known(known, signal) {
        if witness[signal] != value {
            return Err(ProofmanError::InvalidProof(format!(
                "native recursive R1CS solved conflicting value for signal {signal}"
            )));
        }
        Ok(SignalList::new())
    } else {
        witness[signal] = value;
        set_known(known, signal);
        let mut solved = SignalList::new();
        solved.push(signal);
        Ok(solved)
    }
}

fn try_solve_linear_c_constraint<F: PrimeField64>(
    constraint_index: usize,
    terms: &[NativeRuntimeLcTerm],
    witness: &mut [F],
    known: &mut [KnownValue],
) -> ProofmanResult<Option<SignalList>> {
    if terms.is_empty() {
        return Ok(Some(SignalList::new()));
    }

    let mut value = F::ZERO;
    let mut unknown_signal = 0usize;
    let mut unknown_coeff = F::ZERO;
    let mut unknown_count = 0usize;
    for term in terms {
        let signal = usize::try_from(term.signal).map_err(|_| {
            ProofmanError::InvalidSetup(format!("native recursive R1CS signal {} is too large", term.signal))
        })?;
        if signal >= witness.len() {
            return Err(ProofmanError::InvalidSetup(format!(
                "native recursive R1CS signal {signal} is outside witness size {}",
                witness.len()
            )));
        }
        let coeff = F::from_u64(term.coeff);
        if is_known(known, signal) {
            value += witness[signal] * coeff;
        } else {
            unknown_signal = signal;
            unknown_coeff = coeff;
            unknown_count += 1;
            if unknown_count > 1 {
                return Ok(None);
            }
        }
    }

    if unknown_count == 0 {
        if !value.is_zero() {
            return Err(ProofmanError::InvalidProof(format!(
                "native recursive R1CS linear constraint {constraint_index} failed during witness solving"
            )));
        }
        return Ok(Some(SignalList::new()));
    }

    if unknown_coeff.is_zero() {
        return Ok(Some(SignalList::new()));
    }
    let solved_value = if unknown_coeff == F::ONE {
        -value
    } else if unknown_coeff == -F::ONE {
        value
    } else {
        -value / unknown_coeff
    };

    if is_known(known, unknown_signal) {
        if witness[unknown_signal] != solved_value {
            return Err(ProofmanError::InvalidProof(format!(
                "native recursive R1CS solved conflicting value for signal {unknown_signal}"
            )));
        }
        Ok(Some(SignalList::new()))
    } else {
        witness[unknown_signal] = solved_value;
        set_known(known, unknown_signal);
        let mut solved = SignalList::new();
        solved.push(unknown_signal);
        Ok(Some(solved))
    }
}

#[cfg(test)]
mod tests {
    use fields::Goldilocks;

    use super::*;

    #[test]
    fn dependency_offset_ranges_match_sorted_dependencies() {
        let dependencies = vec![
            NativeRuntimeDependency { signal: 1, code: 10, part: DEP_PART_A, bit_term: false },
            NativeRuntimeDependency { signal: 1, code: 11, part: DEP_PART_B, bit_term: false },
            NativeRuntimeDependency { signal: 3, code: 12, part: DEP_PART_C, bit_term: false },
            NativeRuntimeDependency { signal: 5, code: 13, part: DEP_PART_A, bit_term: false },
        ];
        let indexed = NativeRuntimeSolverIndex {
            dependencies: dependencies.clone(),
            dependency_offsets: Some(vec![0, 0, 2, 2, 3, 3, 4]),
            boolean_signals: Vec::new(),
            inverse_protected_signals: Vec::new(),
        };
        let fallback = NativeRuntimeSolverIndex {
            dependencies,
            dependency_offsets: None,
            boolean_signals: Vec::new(),
            inverse_protected_signals: Vec::new(),
        };

        for signal in 0..=6 {
            assert_eq!(indexed.dependency_range(signal), fallback.dependency_range(signal));
        }
    }

    #[test]
    fn solves_bit_decomposition_constraints() -> ProofmanResult<()> {
        let bit_constraints = (2..=5)
            .map(|signal| NativeRuntimeConstraint {
                a: vec![
                    NativeRuntimeLcTerm { signal: 0, coeff: GOLDILOCKS_P_MINUS_ONE },
                    NativeRuntimeLcTerm { signal, coeff: 1 },
                ],
                b: vec![NativeRuntimeLcTerm { signal, coeff: 1 }],
                c: Vec::new(),
            })
            .collect::<Vec<_>>();
        let mut constraints = bit_constraints;
        constraints.push(NativeRuntimeConstraint {
            a: Vec::new(),
            b: Vec::new(),
            c: vec![
                NativeRuntimeLcTerm { signal: 1, coeff: 1 },
                NativeRuntimeLcTerm { signal: 2, coeff: GOLDILOCKS_P_MINUS_ONE },
                NativeRuntimeLcTerm { signal: 3, coeff: GOLDILOCKS_MODULUS - 2 },
                NativeRuntimeLcTerm { signal: 4, coeff: GOLDILOCKS_MODULUS - 4 },
                NativeRuntimeLcTerm { signal: 5, coeff: GOLDILOCKS_MODULUS - 8 },
            ],
        });
        let runtime = NativeRecursiveRuntime {
            template_id: 0,
            size_witness_words: 6,
            n_publics: 0,
            public_input_offset_words: 1,
            public_input_copy_words: 0,
            copy_indices: Vec::new(),
            source_assertions: Vec::new(),
            source_public_prefix_words: 1,
            source_sections: Vec::new(),
            section_copy_ops: Vec::new(),
            source_alias_checks: Vec::new(),
            ignored_source_words: Vec::new(),
            constraints,
            custom_gates: Vec::new(),
            solver_index: OnceLock::new(),
            solve_plan: OnceLock::new(),
            solve_plan_build_lock: Mutex::new(()),
        };

        let witness = runtime.generate_witness::<Goldilocks>(&[10], 6)?;
        assert_eq!(witness[2].as_canonical_u64(), 0);
        assert_eq!(witness[3].as_canonical_u64(), 1);
        assert_eq!(witness[4].as_canonical_u64(), 0);
        assert_eq!(witness[5].as_canonical_u64(), 1);
        Ok(())
    }
}
