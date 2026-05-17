use std::collections::hash_map::DefaultHasher;
use std::collections::{HashMap, VecDeque};
use std::fs;
use std::hash::{Hash, Hasher};
use std::path::Path;
use std::sync::{Mutex, OnceLock};
use std::time::Instant;

use fields::{add, matmul_external, pow7, pow7add, prodadd, Poseidon16, Poseidon2Constants, PrimeField64};
use smallvec::SmallVec;

use crate::{ProofmanError, ProofmanResult};

const MAGIC: &[u8; 8] = b"PIL2RSPD";
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
    pub circom_wasm: Option<NativeCircomWasmRuntime>,
    pub constraints: Vec<NativeRuntimeConstraint>,
    pub custom_gates: Vec<NativeRuntimeCustomGate>,
    solver_index: OnceLock<NativeRuntimeSolverIndex>,
}

#[derive(Debug)]
struct NativeRuntimeSolverIndex {
    dependencies: Vec<NativeRuntimeDependency>,
    boolean_signals: Vec<u64>,
    inverse_protected_signals: Vec<u64>,
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
pub struct NativeCircomWasmRuntime {
    pub wasm: Vec<u8>,
    pub inputs: Vec<NativeCircomWasmInput>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct NativeCircomWasmInput {
    pub hash: u64,
    pub source_offset_words: u64,
    pub word_len: u64,
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
type SignalList = SmallVec<[usize; 8]>;
type GateSignalList = SmallVec<[usize; 256]>;
type UnknownLcTerms<F> = SmallVec<[(usize, F); 4]>;

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
        Self { dependencies, boolean_signals, inverse_protected_signals }
    }

    fn dependency_range(&self, signal: u64) -> std::ops::Range<usize> {
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
    pub fn from_dat_file(path: &Path) -> ProofmanResult<Self> {
        let bytes = fs::read(path)?;
        if bytes.len() < 64 || &bytes[..8] != MAGIC {
            return Err(ProofmanError::InvalidSetup(format!(
                "{} is not a native recursive runtime descriptor",
                path.display()
            )));
        }

        let version = read_u64(&bytes, 8)?;
        if !(1..=3).contains(&version) {
            return Err(ProofmanError::InvalidSetup(format!(
                "{} has unsupported native recursive runtime descriptor version {version}",
                path.display()
            )));
        }

        let template_id = read_u64(&bytes, 16)?;
        let size_witness_words = read_u64(&bytes, 24)?;
        let n_publics = read_u64(&bytes, 32)?;
        let public_input_offset_words = read_u64(&bytes, 40)?;
        let public_input_copy_words = read_u64(&bytes, 48)?;
        let copy_count = read_u64(&bytes, 56)? as usize;
        let copy_start = 64usize;
        let copy_end = copy_start
            .checked_add(copy_count.checked_mul(8).ok_or_else(|| {
                ProofmanError::InvalidSetup("native runtime copy index table is too large".to_string())
            })?)
            .ok_or_else(|| ProofmanError::InvalidSetup("native runtime copy index table is too large".to_string()))?;
        if copy_end > bytes.len() {
            return Err(ProofmanError::InvalidSetup(format!(
                "{} has a truncated native runtime copy index table",
                path.display()
            )));
        }
        let mut copy_indices = Vec::with_capacity(copy_count);
        for index in 0..copy_count {
            copy_indices.push(read_u64(&bytes, copy_start + index * 8)?);
        }

        let assertion_count = if bytes.len() >= copy_end + 8 { read_u64(&bytes, copy_end)? as usize } else { 0 };
        let assertions_end = copy_end
            .checked_add(8)
            .and_then(|start| start.checked_add(assertion_count.checked_mul(16)?))
            .unwrap_or(bytes.len());
        if assertion_count > 0 && assertions_end > bytes.len() {
            return Err(ProofmanError::InvalidSetup(format!(
                "{} has a truncated native runtime assertion table",
                path.display()
            )));
        }
        let mut source_assertions = Vec::with_capacity(assertion_count);
        for index in 0..assertion_count {
            let offset = copy_end + 8 + index * 16;
            source_assertions.push(NativeRuntimeAssertion {
                source_word: read_u64(&bytes, offset)?,
                expected: read_u64(&bytes, offset + 8)?,
            });
        }
        let source_public_prefix_words =
            if bytes.len() >= assertions_end + 8 { read_u64(&bytes, assertions_end)? } else { n_publics };

        let sections_count_offset = assertions_end + 8;
        let (source_sections, sections_end) = if bytes.len() >= sections_count_offset + 8 {
            let sections_count = read_u64(&bytes, sections_count_offset)? as usize;
            let sections_start = sections_count_offset + 8;
            let sections_end = checked_table_end(path, sections_start, sections_count, 32, "section")?;
            if sections_end > bytes.len() {
                return Err(ProofmanError::InvalidSetup(format!(
                    "{} has a truncated native runtime section table",
                    path.display()
                )));
            }
            let mut sections = Vec::with_capacity(sections_count);
            for index in 0..sections_count {
                let offset = sections_start + index * 32;
                sections.push(NativeRuntimeSection {
                    start_word: read_u64(&bytes, offset)?,
                    word_len: read_u64(&bytes, offset + 8)?,
                    kind: read_u64(&bytes, offset + 16)?,
                    flags: read_u64(&bytes, offset + 24)?,
                });
            }
            (sections, sections_end)
        } else {
            (Vec::new(), sections_count_offset)
        };

        let copy_ops_count_offset = sections_end;
        let (section_copy_ops, copy_ops_end) = if bytes.len() >= copy_ops_count_offset + 8 {
            let copy_ops_count = read_u64(&bytes, copy_ops_count_offset)? as usize;
            let copy_ops_start = copy_ops_count_offset + 8;
            let copy_ops_end = checked_table_end(path, copy_ops_start, copy_ops_count, 32, "section copy op")?;
            if copy_ops_end > bytes.len() {
                return Err(ProofmanError::InvalidSetup(format!(
                    "{} has a truncated native runtime section copy op table",
                    path.display()
                )));
            }
            let mut copy_ops = Vec::with_capacity(copy_ops_count);
            for index in 0..copy_ops_count {
                let offset = copy_ops_start + index * 32;
                copy_ops.push(NativeRuntimeSectionCopyOp {
                    section_index: read_u64(&bytes, offset)?,
                    section_offset_words: read_u64(&bytes, offset + 8)?,
                    word_len: read_u64(&bytes, offset + 16)?,
                    witness_offset_words: read_u64(&bytes, offset + 24)?,
                });
            }
            (copy_ops, copy_ops_end)
        } else {
            (Vec::new(), copy_ops_count_offset)
        };
        let (circom_wasm, runtime_body_end) =
            if version >= 3 { parse_circom_wasm_runtime(path, &bytes, copy_ops_end)? } else { (None, copy_ops_end) };
        let (constraints, constraints_end) = if bytes.len() >= runtime_body_end + 8 {
            parse_constraints(path, &bytes, runtime_body_end)?
        } else {
            (Vec::new(), runtime_body_end)
        };
        let custom_gates = if bytes.len() >= constraints_end + 8 {
            parse_custom_gates(path, &bytes, constraints_end, version)?
        } else {
            Vec::new()
        };

        Ok(Self {
            template_id,
            size_witness_words,
            n_publics,
            public_input_offset_words,
            public_input_copy_words,
            copy_indices,
            source_assertions,
            source_public_prefix_words,
            source_sections,
            section_copy_ops,
            circom_wasm,
            constraints,
            custom_gates,
            solver_index: OnceLock::new(),
        })
    }

    pub fn generate_witness<F: PrimeField64>(
        &self,
        source_words: &[u64],
        total_witness_words: u64,
    ) -> ProofmanResult<Vec<F>> {
        let timing = std::env::var_os("PROOFMAN_DEBUG_NATIVE_TIMING").is_some();
        let total_start = Instant::now();
        self.check_witness_size(total_witness_words)?;
        self.check_source_assertions(source_words)?;

        if std::env::var_os("PROOFMAN_ENABLE_CIRCOM_WASM").is_some() {
            if let Some(circom_wasm) = &self.circom_wasm {
                return self.generate_circom_wasm_witness(circom_wasm, source_words, total_witness_words);
            }
        }

        let mut witness = vec![F::ZERO; total_witness_words as usize];
        let mut known = vec![false; total_witness_words as usize];
        if !witness.is_empty() {
            witness[0] = F::ONE;
            known[0] = true;
        }

        let prefix_words = self
            .source_public_prefix_words
            .min(self.size_witness_words.saturating_sub(1))
            .min(source_words.len() as u64);
        for offset in 0..prefix_words {
            witness[(1 + offset) as usize] = F::from_u64(source_words[offset as usize]);
            known[(1 + offset) as usize] = true;
        }

        if self.copy_indices.is_empty() {
            let copy_words = self
                .public_input_copy_words
                .min(source_words.len() as u64)
                .min(self.size_witness_words.saturating_sub(self.public_input_offset_words));
            for offset in 0..copy_words {
                let dst = self.public_input_offset_words + offset;
                witness[dst as usize] = F::from_u64(source_words[offset as usize]);
                known[dst as usize] = true;
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
                    known[dst as usize] = true;
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
                known[(copy_op.witness_offset_words + offset) as usize] = true;
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
            let unknown_publics = known[1..public_end].iter().filter(|&&is_known| !is_known).count();
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

    fn generate_circom_wasm_witness<F: PrimeField64>(
        &self,
        circom_wasm: &NativeCircomWasmRuntime,
        source_words: &[u64],
        total_witness_words: u64,
    ) -> ProofmanResult<Vec<F>> {
        let (engine, module) = circom_wasmtime_module(&circom_wasm.wasm)?;
        let mut store = wasmtime::Store::new(engine, NativeCircomWasmHost::default());
        let mut linker = <wasmtime::Linker<NativeCircomWasmHost>>::new(engine);
        linker
            .func_wrap(
                "runtime",
                "exceptionHandler",
                |mut caller: wasmtime::Caller<'_, NativeCircomWasmHost>, code: i32| {
                    caller.data_mut().exception = Some(code);
                },
            )
            .map_err(|err| ProofmanError::InvalidSetup(format!("failed to link Circom exception handler: {err}")))?;
        linker
            .func_wrap("runtime", "printErrorMessage", || {})
            .map_err(|err| ProofmanError::InvalidSetup(format!("failed to link Circom print handler: {err}")))?;
        linker
            .func_wrap("runtime", "writeBufferMessage", || {})
            .map_err(|err| ProofmanError::InvalidSetup(format!("failed to link Circom buffer handler: {err}")))?;
        linker
            .func_wrap("runtime", "showSharedRWMemory", || {})
            .map_err(|err| ProofmanError::InvalidSetup(format!("failed to link Circom memory handler: {err}")))?;
        linker
            .func_wrap(
                "runtime",
                "runCustomTemplate",
                |mut caller: wasmtime::Caller<'_, NativeCircomWasmHost>, kind: i32, signal_base: i32| {
                    if let Err(err) = run_circom_custom_template::<F>(&mut caller, kind, signal_base) {
                        caller.data_mut().exception = Some(4);
                        caller.data_mut().message = Some(err);
                    }
                },
            )
            .map_err(|err| {
                ProofmanError::InvalidSetup(format!("failed to link Circom custom template handler: {err}"))
            })?;

        let instance = linker
            .instantiate(&mut store, &module)
            .map_err(|err| ProofmanError::InvalidSetup(format!("failed to instantiate Circom witness WASM: {err}")))?;

        let init = instance
            .get_typed_func::<i32, ()>(&mut store, "init")
            .map_err(|err| ProofmanError::InvalidSetup(format!("Circom witness WASM has no init export: {err}")))?;
        let write_shared =
            instance.get_typed_func::<(i32, i32), ()>(&mut store, "writeSharedRWMemory").map_err(|err| {
                ProofmanError::InvalidSetup(format!("Circom witness WASM has no writeSharedRWMemory export: {err}"))
            })?;
        let set_input =
            instance.get_typed_func::<(i32, i32, i32), ()>(&mut store, "setInputSignal").map_err(|err| {
                ProofmanError::InvalidSetup(format!("Circom witness WASM has no setInputSignal export: {err}"))
            })?;
        let set_input_raw = instance.get_typed_func::<i32, ()>(&mut store, "setInputSignalRaw").ok();
        let run = instance.get_typed_func::<(), ()>(&mut store, "run").ok();
        let get_input_size = instance.get_typed_func::<(), i32>(&mut store, "getInputSize").map_err(|err| {
            ProofmanError::InvalidSetup(format!("Circom witness WASM has no getInputSize export: {err}"))
        })?;
        let get_witness_size = instance.get_typed_func::<(), i32>(&mut store, "getWitnessSize").map_err(|err| {
            ProofmanError::InvalidSetup(format!("Circom witness WASM has no getWitnessSize export: {err}"))
        })?;
        let get_witness = instance.get_typed_func::<i32, ()>(&mut store, "getWitness").map_err(|err| {
            ProofmanError::InvalidSetup(format!("Circom witness WASM has no getWitness export: {err}"))
        })?;
        let get_message_char = instance.get_typed_func::<(), i32>(&mut store, "getMessageChar").map_err(|err| {
            ProofmanError::InvalidSetup(format!("Circom witness WASM has no getMessageChar export: {err}"))
        })?;
        let read_shared = instance.get_typed_func::<i32, i32>(&mut store, "readSharedRWMemory").map_err(|err| {
            ProofmanError::InvalidSetup(format!("Circom witness WASM has no readSharedRWMemory export: {err}"))
        })?;

        init.call(&mut store, 0)
            .map_err(|err| ProofmanError::InvalidProof(format!("Circom witness init failed: {err}")))?;
        check_circom_wasm_exception(&mut store, &get_message_char)?;

        if let (Some(set_input_raw), Some(run)) = (set_input_raw.as_ref(), run.as_ref()) {
            let input_size = get_input_size
                .call(&mut store, ())
                .map_err(|err| ProofmanError::InvalidProof(format!("failed to read Circom input size: {err}")))?
                as u64;
            if input_size > source_words.len() as u64 {
                return Err(ProofmanError::InvalidProof(format!(
                    "Circom WASM raw input needs {input_size} source words but source has {} words",
                    source_words.len()
                )));
            }
            for offset in 0..input_size {
                write_circom_wasm_u64(&mut store, &write_shared, source_words[offset as usize])?;
                set_input_raw
                    .call(&mut store, offset as i32)
                    .map_err(|err| ProofmanError::InvalidProof(format!("failed to set raw Circom input: {err}")))?;
                check_circom_wasm_exception(&mut store, &get_message_char)?;
            }
            run.call(&mut store, ())
                .map_err(|err| ProofmanError::InvalidProof(format!("failed to run Circom witness: {err}")))?;
            check_circom_wasm_exception(&mut store, &get_message_char)?;
        } else {
            for input in &circom_wasm.inputs {
                let source_end = input.source_offset_words.checked_add(input.word_len).ok_or_else(|| {
                    ProofmanError::InvalidSetup("Circom WASM input source range overflows".to_string())
                })?;
                if source_end > source_words.len() as u64 {
                    return Err(ProofmanError::InvalidProof(format!(
                        "Circom WASM input reads source words [{}..{}) but source has {} words",
                        input.source_offset_words,
                        source_end,
                        source_words.len()
                    )));
                }
                let hmsb = (input.hash >> 32) as u32 as i32;
                let hlsb = input.hash as u32 as i32;
                for offset in 0..input.word_len {
                    let value = source_words[(input.source_offset_words + offset) as usize];
                    write_circom_wasm_u64(&mut store, &write_shared, value)?;
                    set_input
                        .call(&mut store, (hmsb, hlsb, offset as i32))
                        .map_err(|err| ProofmanError::InvalidProof(format!("failed to set Circom input: {err}")))?;
                    check_circom_wasm_exception(&mut store, &get_message_char)?;
                }
            }
        }

        let wasm_witness_size = get_witness_size
            .call(&mut store, ())
            .map_err(|err| ProofmanError::InvalidProof(format!("failed to read Circom witness size: {err}")))?
            as u64;
        if wasm_witness_size != self.size_witness_words {
            return Err(ProofmanError::InvalidSetup(format!(
                "Circom witness WASM has witness size {wasm_witness_size}, expected {}",
                self.size_witness_words
            )));
        }

        let mut witness = vec![F::ZERO; total_witness_words as usize];
        for index in 0..self.size_witness_words {
            get_witness
                .call(&mut store, index as i32)
                .map_err(|err| ProofmanError::InvalidProof(format!("failed to read Circom witness {index}: {err}")))?;
            let low = read_shared
                .call(&mut store, 0)
                .map_err(|err| ProofmanError::InvalidProof(format!("failed to read Circom witness low word: {err}")))?
                as u32 as u64;
            let high = read_shared
                .call(&mut store, 1)
                .map_err(|err| ProofmanError::InvalidProof(format!("failed to read Circom witness high word: {err}")))?
                as u32 as u64;
            witness[index as usize] = F::from_u64((high << 32) | low);
        }
        if std::env::var_os("PROOFMAN_VALIDATE_CIRCOM_WASM").is_some() {
            let mut known = vec![true; witness.len()];
            self.solve_constraints(&mut witness, &mut known)?;
        }
        Ok(witness)
    }

    fn solve_constraints<F: PrimeField64>(&self, witness: &mut [F], known: &mut [bool]) -> ProofmanResult<()> {
        if self.constraints.is_empty() && self.custom_gates.is_empty() {
            return Ok(());
        }

        let timing = std::env::var_os("PROOFMAN_DEBUG_NATIVE_TIMING").is_some();
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

        let mut processed_constraints = 0usize;
        let mut processed_gates = 0usize;
        let mut solved_constraints = 0usize;
        let mut solved_gates = 0usize;
        while let Some(code) = queue.pop_front() {
            if code & DEPENDENCY_GATE_FLAG == 0 {
                let constraint_index = code as usize;
                queued_constraints[constraint_index] = false;
                let constraint = &self.constraints[constraint_index];
                processed_constraints += 1;
                let solved_signals =
                    self.try_solve_constraint(constraint_index, constraint, witness, known, solver_index)?;
                if !solved_signals.is_empty() {
                    solved_constraints += 1;
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
                if std::env::var_os("PROOFMAN_VALIDATE_CIRCOM_WASM").is_some() {
                    let a = eval_lc(&constraint.a, witness, known)?;
                    let b = eval_lc(&constraint.b, witness, known)?;
                    let c = eval_lc(&constraint.c, witness, known)?;
                    if a.unknown.is_empty()
                        && b.unknown.is_empty()
                        && c.unknown.is_empty()
                        && a.value * b.value != c.value
                    {
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
            } else {
                let gate_index = (code & !DEPENDENCY_GATE_FLAG) as usize;
                queued_gates[gate_index] = false;
                let gate = &self.custom_gates[gate_index];
                processed_gates += 1;
                let unknown_before = gate
                    .signals
                    .iter()
                    .copied()
                    .filter(|&signal| {
                        usize::try_from(signal)
                            .ok()
                            .and_then(|idx| known.get(idx))
                            .map(|is_known| !*is_known)
                            .unwrap_or(false)
                    })
                    .collect::<SmallVec<[u64; 256]>>();
                if self.try_solve_custom_gate(gate, witness, known, solver_index)? {
                    solved_gates += 1;
                    for signal in unknown_before {
                        if usize::try_from(signal).ok().and_then(|idx| known.get(idx)).copied() != Some(true) {
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
        let solve_elapsed = solve_start.elapsed();

        if std::env::var_os("PROOFMAN_DEBUG_NATIVE_UNRESOLVED").is_some() {
            let unknown_count = known.iter().filter(|&&is_known| !is_known).count();
            let first_unknown = known.iter().position(|&is_known| !is_known);
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
                            .map(|is_known| !*is_known)
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

        let verify_gates_start = Instant::now();
        for gate in &self.custom_gates {
            self.verify_custom_gate(gate, witness, known)?;
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
        if timing {
            tracing::error!(
                "Native recursive solver timing: constraints={} gates={} processed_constraints={} processed_gates={} solved_constraints={} solved_gates={} queue_ms={} verify_gates_ms={} verify_constraints_ms={}",
                self.constraints.len(),
                self.custom_gates.len(),
                processed_constraints,
                processed_gates,
                solved_constraints,
                solved_gates,
                solve_elapsed.as_millis(),
                verify_gates_elapsed.as_millis(),
                verify_constraints_start.elapsed().as_millis()
            );
        }

        Ok(())
    }

    fn try_solve_constraint<F: PrimeField64>(
        &self,
        constraint_index: usize,
        constraint: &NativeRuntimeConstraint,
        witness: &mut [F],
        known: &mut [bool],
        solver_index: &NativeRuntimeSolverIndex,
    ) -> ProofmanResult<SignalList> {
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

    fn try_solve_custom_gate<F: PrimeField64>(
        &self,
        gate: &NativeRuntimeCustomGate,
        witness: &mut [F],
        known: &mut [bool],
        solver_index: &NativeRuntimeSolverIndex,
    ) -> ProofmanResult<bool> {
        match gate.kind {
            NativeRuntimeCustomGateKind::CMul => solve_cmul_gate(gate, witness, known, solver_index),
            NativeRuntimeCustomGateKind::EvPol4 => solve_evpol4_gate(gate, witness, known),
            NativeRuntimeCustomGateKind::TreeSelector4 => solve_tree_selector4_gate(gate, witness, known),
            NativeRuntimeCustomGateKind::SelectValue1 => solve_select_value1_gate(gate, witness, known),
            NativeRuntimeCustomGateKind::FFT4 => solve_fft4_gate(gate, witness, known),
            NativeRuntimeCustomGateKind::Poseidon16 => solve_poseidon16_gate(gate, witness, known, false),
            NativeRuntimeCustomGateKind::CustPoseidon16 => solve_poseidon16_gate(gate, witness, known, true),
        }
    }

    fn verify_custom_gate<F: PrimeField64>(
        &self,
        gate: &NativeRuntimeCustomGate,
        witness: &[F],
        known: &[bool],
    ) -> ProofmanResult<()> {
        match gate.kind {
            NativeRuntimeCustomGateKind::CMul => verify_cmul_gate(gate, witness, known),
            NativeRuntimeCustomGateKind::EvPol4 => verify_evpol4_gate(gate, witness, known),
            NativeRuntimeCustomGateKind::TreeSelector4 => verify_tree_selector4_gate(gate, witness, known),
            NativeRuntimeCustomGateKind::SelectValue1 => verify_select_value1_gate(gate, witness, known),
            NativeRuntimeCustomGateKind::FFT4 => verify_fft4_gate(gate, witness, known),
            NativeRuntimeCustomGateKind::Poseidon16 => verify_poseidon16_gate(gate, witness, known, false),
            NativeRuntimeCustomGateKind::CustPoseidon16 => verify_poseidon16_gate(gate, witness, known, true),
        }
    }
}

#[derive(Debug)]
struct LcEval<F: PrimeField64> {
    value: F,
    unknown: UnknownLcTerms<F>,
}

fn eval_lc<F: PrimeField64>(terms: &[NativeRuntimeLcTerm], witness: &[F], known: &[bool]) -> ProofmanResult<LcEval<F>> {
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
        if known[signal] {
            value += witness[signal] * coeff;
        } else {
            unknown.push((signal, coeff));
        }
    }
    Ok(LcEval { value, unknown })
}

fn format_constraint_failure<F: PrimeField64>(
    reason: &str,
    constraint_index: usize,
    constraint: &NativeRuntimeConstraint,
    a: &LcEval<F>,
    b: &LcEval<F>,
    c: &LcEval<F>,
    witness: &[F],
    known: &[bool],
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

fn format_lc_terms<F: PrimeField64>(terms: &[NativeRuntimeLcTerm], witness: &[F], known: &[bool]) -> String {
    const MAX_TERMS: usize = 8;
    let mut parts = Vec::with_capacity(terms.len().min(MAX_TERMS) + 1);
    for term in terms.iter().take(MAX_TERMS) {
        let value = usize::try_from(term.signal)
            .ok()
            .and_then(|signal| witness.get(signal).zip(known.get(signal)).map(|(value, known)| (value, known)))
            .map(|(value, known)| if *known { value.as_canonical_u64().to_string() } else { "unknown".to_string() })
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
    known: &[bool],
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
    known: &[bool],
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
        if !is_known {
            let is_bit_term =
                solver_index.is_boolean_signal(signal as u64) && coefficient_power_of_two(term.coeff).is_some();
            if !is_bit_term {
                unknown_non_bit += 1;
            }
        }
    }
    Ok(unknown_non_bit)
}

fn build_gate_states(custom_gates: &[NativeRuntimeCustomGate], known: &[bool]) -> ProofmanResult<Vec<GateSolveState>> {
    let mut states = Vec::with_capacity(custom_gates.len());
    for gate in custom_gates {
        states.push(gate_solve_state(gate, known)?);
    }
    Ok(states)
}

fn gate_solve_state(gate: &NativeRuntimeCustomGate, known: &[bool]) -> ProofmanResult<GateSolveState> {
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
    known: &[bool],
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

fn count_unknown_signals(signals: &[usize], known: &[bool]) -> usize {
    signals.iter().filter(|&&signal| !known[signal]).count()
}

fn count_lc_unknown(terms: &[NativeRuntimeLcTerm], known: &[bool]) -> ProofmanResult<usize> {
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
        if !is_known {
            unknown += 1;
        }
    }
    Ok(unknown)
}

fn try_solve_bit_decomposition<F: PrimeField64>(
    constraint: &NativeRuntimeConstraint,
    witness: &mut [F],
    known: &mut [bool],
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
        if known[signal] {
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
        if known[signal] {
            if witness[signal] != value {
                return Err(ProofmanError::InvalidProof(format!(
                    "native recursive bit decomposition solved conflicting value for signal {signal}"
                )));
            }
        } else {
            witness[signal] = value;
            known[signal] = true;
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
    known: &mut [bool],
) -> ProofmanResult<SignalList> {
    if lc.unknown.len() != 1 {
        return Ok(SignalList::new());
    }
    let (signal, coeff) = lc.unknown[0];
    if coeff.is_zero() {
        return Ok(SignalList::new());
    }
    let value = (desired - lc.value) / coeff;
    if known[signal] {
        if witness[signal] != value {
            return Err(ProofmanError::InvalidProof(format!(
                "native recursive R1CS solved conflicting value for signal {signal}"
            )));
        }
        Ok(SignalList::new())
    } else {
        witness[signal] = value;
        known[signal] = true;
        let mut solved = SignalList::new();
        solved.push(signal);
        Ok(solved)
    }
}

fn solve_cmul_gate<F: PrimeField64>(
    gate: &NativeRuntimeCustomGate,
    witness: &mut [F],
    known: &mut [bool],
    solver_index: &NativeRuntimeSolverIndex,
) -> ProofmanResult<bool> {
    if gate.signals.len() != 9 {
        return Err(ProofmanError::InvalidSetup(format!(
            "CMul native runtime gate must have 9 signals, got {}",
            gate.signals.len()
        )));
    }
    let signals = gate_signals(&gate.signals, witness.len())?;
    let a_known = signals[..3].iter().all(|&signal| known[signal]);
    let b_known = signals[3..6].iter().all(|&signal| known[signal]);
    let output_known = signals[6..9].iter().all(|&signal| known[signal]);

    if a_known && b_known {
        let a = [witness[signals[0]], witness[signals[1]], witness[signals[2]]];
        let b = [witness[signals[3]], witness[signals[4]], witness[signals[5]]];
        let result = cmul(a, b);
        return assign_gate_outputs("CMul", &signals[6..9], result, witness, known);
    }

    if a_known && output_known && solver_index.can_inverse_solve(&signals[3..6]) {
        let a = [witness[signals[0]], witness[signals[1]], witness[signals[2]]];
        let output = [witness[signals[6]], witness[signals[7]], witness[signals[8]]];
        if let Some(b) = cdiv(output, a) {
            return assign_gate_outputs("CMul", &signals[3..6], b, witness, known);
        }
    }

    if b_known && output_known && solver_index.can_inverse_solve(&signals[..3]) {
        let b = [witness[signals[3]], witness[signals[4]], witness[signals[5]]];
        let output = [witness[signals[6]], witness[signals[7]], witness[signals[8]]];
        if let Some(a) = cdiv(output, b) {
            return assign_gate_outputs("CMul", &signals[..3], a, witness, known);
        }
    }

    Ok(false)
}

fn verify_cmul_gate<F: PrimeField64>(
    gate: &NativeRuntimeCustomGate,
    witness: &[F],
    known: &[bool],
) -> ProofmanResult<()> {
    if gate.signals.len() != 9 {
        return Err(ProofmanError::InvalidSetup(format!(
            "CMul native runtime gate must have 9 signals, got {}",
            gate.signals.len()
        )));
    }
    let signals = gate_signals(&gate.signals, witness.len())?;
    if signals.iter().any(|&signal| !known[signal]) {
        return Ok(());
    }
    let a = [witness[signals[0]], witness[signals[1]], witness[signals[2]]];
    let b = [witness[signals[3]], witness[signals[4]], witness[signals[5]]];
    let result = cmul(a, b);
    for idx in 0..3 {
        let signal = signals[6 + idx];
        if witness[signal] != result[idx] {
            return Err(ProofmanError::InvalidProof(format!(
                "native recursive CMul gate output mismatch at signal {signal}"
            )));
        }
    }
    Ok(())
}

fn solve_evpol4_gate<F: PrimeField64>(
    gate: &NativeRuntimeCustomGate,
    witness: &mut [F],
    known: &mut [bool],
) -> ProofmanResult<bool> {
    if gate.signals.len() != 21 {
        return Err(ProofmanError::InvalidSetup(format!(
            "EvPol4 native runtime gate must have 21 signals, got {}",
            gate.signals.len()
        )));
    }
    let signals = gate_signals(&gate.signals, witness.len())?;
    if signals[..18].iter().any(|&signal| !known[signal]) {
        return Ok(false);
    }

    let result = evpol4(&signals, witness);
    let mut changed = false;
    for idx in 0..3 {
        let signal = signals[18 + idx];
        if known[signal] {
            if witness[signal] != result[idx] {
                return Err(ProofmanError::InvalidProof(format!(
                    "native recursive EvPol4 gate output mismatch at signal {signal}"
                )));
            }
        } else {
            witness[signal] = result[idx];
            known[signal] = true;
            changed = true;
        }
    }
    Ok(changed)
}

fn verify_evpol4_gate<F: PrimeField64>(
    gate: &NativeRuntimeCustomGate,
    witness: &[F],
    known: &[bool],
) -> ProofmanResult<()> {
    if gate.signals.len() != 21 {
        return Err(ProofmanError::InvalidSetup(format!(
            "EvPol4 native runtime gate must have 21 signals, got {}",
            gate.signals.len()
        )));
    }
    let signals = gate_signals(&gate.signals, witness.len())?;
    if signals.iter().any(|&signal| !known[signal]) {
        return Ok(());
    }
    let result = evpol4(&signals, witness);
    for idx in 0..3 {
        let signal = signals[18 + idx];
        if witness[signal] != result[idx] {
            return Err(ProofmanError::InvalidProof(format!(
                "native recursive EvPol4 gate output mismatch at signal {signal}"
            )));
        }
    }
    Ok(())
}

fn solve_tree_selector4_gate<F: PrimeField64>(
    gate: &NativeRuntimeCustomGate,
    witness: &mut [F],
    known: &mut [bool],
) -> ProofmanResult<bool> {
    if gate.signals.len() != 17 {
        return Err(ProofmanError::InvalidSetup(format!(
            "TreeSelector4 native runtime gate must have 17 signals, got {}",
            gate.signals.len()
        )));
    }
    let signals = gate_signals(&gate.signals, witness.len())?;
    if signals[..14].iter().any(|&signal| !known[signal]) {
        return Ok(false);
    }

    let index = selector_index(witness[signals[12]], witness[signals[13]], "TreeSelector4")?;
    let value_start = index * 3;
    assign_gate_outputs(
        "TreeSelector4",
        &signals[14..17],
        [witness[signals[value_start]], witness[signals[value_start + 1]], witness[signals[value_start + 2]]],
        witness,
        known,
    )
}

fn verify_tree_selector4_gate<F: PrimeField64>(
    gate: &NativeRuntimeCustomGate,
    witness: &[F],
    known: &[bool],
) -> ProofmanResult<()> {
    if gate.signals.len() != 17 {
        return Err(ProofmanError::InvalidSetup(format!(
            "TreeSelector4 native runtime gate must have 17 signals, got {}",
            gate.signals.len()
        )));
    }
    let signals = gate_signals(&gate.signals, witness.len())?;
    if signals.iter().any(|&signal| !known[signal]) {
        return Ok(());
    }
    let index = selector_index(witness[signals[12]], witness[signals[13]], "TreeSelector4")?;
    let value_start = index * 3;
    verify_gate_outputs(
        "TreeSelector4",
        &signals[14..17],
        [witness[signals[value_start]], witness[signals[value_start + 1]], witness[signals[value_start + 2]]],
        witness,
    )
}

fn solve_select_value1_gate<F: PrimeField64>(
    gate: &NativeRuntimeCustomGate,
    witness: &mut [F],
    known: &mut [bool],
) -> ProofmanResult<bool> {
    if gate.signals.len() != 22 {
        return Err(ProofmanError::InvalidSetup(format!(
            "SelectValue1 native runtime gate must have 22 signals, got {}",
            gate.signals.len()
        )));
    }
    let signals = gate_signals(&gate.signals, witness.len())?;
    if signals[..18].iter().any(|&signal| !known[signal]) {
        return Ok(false);
    }

    let index = selector_index(witness[signals[16]], witness[signals[17]], "SelectValue1")?;
    let value_start = index * 4;
    assign_gate_outputs(
        "SelectValue1",
        &signals[18..22],
        [
            witness[signals[value_start]],
            witness[signals[value_start + 1]],
            witness[signals[value_start + 2]],
            witness[signals[value_start + 3]],
        ],
        witness,
        known,
    )
}

fn verify_select_value1_gate<F: PrimeField64>(
    gate: &NativeRuntimeCustomGate,
    witness: &[F],
    known: &[bool],
) -> ProofmanResult<()> {
    if gate.signals.len() != 22 {
        return Err(ProofmanError::InvalidSetup(format!(
            "SelectValue1 native runtime gate must have 22 signals, got {}",
            gate.signals.len()
        )));
    }
    let signals = gate_signals(&gate.signals, witness.len())?;
    if signals.iter().any(|&signal| !known[signal]) {
        return Ok(());
    }
    let index = selector_index(witness[signals[16]], witness[signals[17]], "SelectValue1")?;
    let value_start = index * 4;
    verify_gate_outputs(
        "SelectValue1",
        &signals[18..22],
        [
            witness[signals[value_start]],
            witness[signals[value_start + 1]],
            witness[signals[value_start + 2]],
            witness[signals[value_start + 3]],
        ],
        witness,
    )
}

fn solve_fft4_gate<F: PrimeField64>(
    gate: &NativeRuntimeCustomGate,
    witness: &mut [F],
    known: &mut [bool],
) -> ProofmanResult<bool> {
    if gate.signals.len() != 24 {
        return Err(ProofmanError::InvalidSetup(format!(
            "FFT4 native runtime gate must have 24 signals, got {}",
            gate.signals.len()
        )));
    }
    let signals = gate_signals(&gate.signals, witness.len())?;
    if signals[..12].iter().any(|&signal| !known[signal]) {
        return Ok(false);
    }

    let result = fft4(&gate.parameters, &signals, witness)?;
    assign_gate_outputs("FFT4", &signals[12..24], result, witness, known)
}

fn verify_fft4_gate<F: PrimeField64>(
    gate: &NativeRuntimeCustomGate,
    witness: &[F],
    known: &[bool],
) -> ProofmanResult<()> {
    if gate.signals.len() != 24 {
        return Err(ProofmanError::InvalidSetup(format!(
            "FFT4 native runtime gate must have 24 signals, got {}",
            gate.signals.len()
        )));
    }
    let signals = gate_signals(&gate.signals, witness.len())?;
    if signals.iter().any(|&signal| !known[signal]) {
        return Ok(());
    }
    let result = fft4(&gate.parameters, &signals, witness)?;
    verify_gate_outputs("FFT4", &signals[12..24], result, witness)
}

fn solve_poseidon16_gate<F: PrimeField64>(
    gate: &NativeRuntimeCustomGate,
    witness: &mut [F],
    known: &mut [bool],
    custom: bool,
) -> ProofmanResult<bool> {
    let gate_name = if custom { "CustPoseidon16" } else { "Poseidon16" };
    let expected_len = if custom { 226 } else { 224 };
    if gate.signals.len() != expected_len {
        return Err(ProofmanError::InvalidSetup(format!(
            "{gate_name} native runtime gate must have {expected_len} signals, got {}",
            gate.signals.len()
        )));
    }
    if !gate.parameters.is_empty() {
        return Err(ProofmanError::InvalidSetup(format!("{gate_name} native runtime gate must not have parameters")));
    }
    let signals = gate_signals(&gate.signals, witness.len())?;
    let input_end = if custom { 18 } else { 16 };
    let output_start = input_end;
    if signals[..input_end].iter().any(|&signal| !known[signal]) {
        return Ok(false);
    }

    let input = poseidon16_input(gate_name, custom, &signals, witness)?;
    let result = poseidon16_trace(input);
    assign_gate_outputs(gate_name, &signals[output_start..output_start + 208], result, witness, known)
}

fn verify_poseidon16_gate<F: PrimeField64>(
    gate: &NativeRuntimeCustomGate,
    witness: &[F],
    known: &[bool],
    custom: bool,
) -> ProofmanResult<()> {
    let gate_name = if custom { "CustPoseidon16" } else { "Poseidon16" };
    let expected_len = if custom { 226 } else { 224 };
    if gate.signals.len() != expected_len {
        return Err(ProofmanError::InvalidSetup(format!(
            "{gate_name} native runtime gate must have {expected_len} signals, got {}",
            gate.signals.len()
        )));
    }
    if !gate.parameters.is_empty() {
        return Err(ProofmanError::InvalidSetup(format!("{gate_name} native runtime gate must not have parameters")));
    }
    let signals = gate_signals(&gate.signals, witness.len())?;
    if signals.iter().any(|&signal| !known[signal]) {
        return Ok(());
    }

    let input = poseidon16_input(gate_name, custom, &signals, witness)?;
    let result = poseidon16_trace(input);
    let output_start = if custom { 18 } else { 16 };
    verify_gate_outputs(gate_name, &signals[output_start..output_start + 208], result, witness)
}

fn gate_signals(signals: &[u64], witness_len: usize) -> ProofmanResult<GateSignalList> {
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

fn selector_index<F: PrimeField64>(key0: F, key1: F, gate: &str) -> ProofmanResult<usize> {
    let bit0 = selector_bit(key0, gate)?;
    let bit1 = selector_bit(key1, gate)?;
    Ok(bit0 + bit1 * 2)
}

fn selector_bit<F: PrimeField64>(value: F, gate: &str) -> ProofmanResult<usize> {
    if value == F::ZERO {
        Ok(0)
    } else if value == F::ONE {
        Ok(1)
    } else {
        Err(ProofmanError::InvalidProof(format!("native recursive {gate} gate key must be boolean")))
    }
}

fn assign_gate_outputs<F: PrimeField64, const N: usize>(
    gate: &str,
    output_signals: &[usize],
    expected: [F; N],
    witness: &mut [F],
    known: &mut [bool],
) -> ProofmanResult<bool> {
    let mut changed = false;
    for (idx, &signal) in output_signals.iter().enumerate() {
        if known[signal] {
            if witness[signal] != expected[idx] {
                return Err(ProofmanError::InvalidProof(format!(
                    "native recursive {gate} gate output mismatch at signal {signal}: expected {} got {}",
                    expected[idx].as_canonical_u64(),
                    witness[signal].as_canonical_u64()
                )));
            }
        } else {
            witness[signal] = expected[idx];
            known[signal] = true;
            changed = true;
        }
    }
    Ok(changed)
}

fn verify_gate_outputs<F: PrimeField64, const N: usize>(
    gate: &str,
    output_signals: &[usize],
    expected: [F; N],
    witness: &[F],
) -> ProofmanResult<()> {
    for (idx, &signal) in output_signals.iter().enumerate() {
        if witness[signal] != expected[idx] {
            return Err(ProofmanError::InvalidProof(format!(
                "native recursive {gate} gate output mismatch at signal {signal}"
            )));
        }
    }
    Ok(())
}

fn cmul<F: PrimeField64>(a: [F; 3], b: [F; 3]) -> [F; 3] {
    [
        a[0] * b[0] + a[1] * b[2] + a[2] * b[1],
        a[0] * b[1] + a[1] * b[0] + a[1] * b[2] + a[2] * b[1] + a[2] * b[2],
        a[0] * b[2] + a[2] * b[2] + a[2] * b[0] + a[1] * b[1],
    ]
}

fn cdiv<F: PrimeField64>(output: [F; 3], divisor: [F; 3]) -> Option<[F; 3]> {
    let [d0, d1, d2] = divisor;
    solve_linear3([[d0, d2, d1, output[0]], [d1, d0 + d2, d1 + d2, output[1]], [d2, d1, d0 + d2, output[2]]])
}

fn solve_linear3<F: PrimeField64>(mut rows: [[F; 4]; 3]) -> Option<[F; 3]> {
    let mut pivots = [0usize; 3];
    let mut pivot_count = 0usize;

    for col in 0..3 {
        let pivot = (pivot_count..3).find(|&row| !rows[row][col].is_zero())?;
        rows.swap(pivot_count, pivot);

        let inv_pivot = F::ONE / rows[pivot_count][col];
        for entry in col..4 {
            rows[pivot_count][entry] *= inv_pivot;
        }

        for row in 0..3 {
            if row == pivot_count || rows[row][col].is_zero() {
                continue;
            }
            let factor = rows[row][col];
            for entry in col..4 {
                rows[row][entry] -= factor * rows[pivot_count][entry];
            }
        }

        pivots[pivot_count] = col;
        pivot_count += 1;
    }

    if pivot_count != 3 {
        return None;
    }

    let mut out = [F::ZERO; 3];
    for row in 0..3 {
        out[pivots[row]] = rows[row][3];
    }
    Some(out)
}

fn cmul_add<F: PrimeField64>(a: [F; 3], b: [F; 3], c: [F; 3]) -> [F; 3] {
    let product = cmul(a, b);
    [product[0] + c[0], product[1] + c[1], product[2] + c[2]]
}

fn evpol4<F: PrimeField64>(signals: &[usize], witness: &[F]) -> [F; 3] {
    let coefs = [
        [witness[signals[0]], witness[signals[1]], witness[signals[2]]],
        [witness[signals[3]], witness[signals[4]], witness[signals[5]]],
        [witness[signals[6]], witness[signals[7]], witness[signals[8]]],
        [witness[signals[9]], witness[signals[10]], witness[signals[11]]],
        [witness[signals[12]], witness[signals[13]], witness[signals[14]]],
    ];
    let x = [witness[signals[15]], witness[signals[16]], witness[signals[17]]];
    evpol4_values(coefs, x)
}

fn evpol4_values<F: PrimeField64>(coefs: [[F; 3]; 5], x: [F; 3]) -> [F; 3] {
    let acc = cmul_add(coefs[4], x, coefs[3]);
    let acc = cmul_add(acc, x, coefs[2]);
    let acc = cmul_add(acc, x, coefs[1]);
    cmul_add(acc, x, coefs[0])
}

fn fft4<F: PrimeField64>(parameters: &[u64], signals: &[usize], witness: &[F]) -> ProofmanResult<[F; 12]> {
    if parameters.len() != 4 {
        return Err(ProofmanError::InvalidSetup(format!(
            "FFT4 native runtime gate must have 4 parameters, got {}",
            parameters.len()
        )));
    }
    let first_w = F::from_u64(parameters[0]);
    let inc_w = F::from_u64(parameters[1]);
    let scale = F::from_u64(parameters[2]);
    let fft_type = parameters[3];
    let first_w2 = first_w * first_w;
    let mut c = [F::ZERO; 9];
    if fft_type == 4 {
        c[0] = scale;
        c[1] = scale * first_w2;
        c[2] = scale * first_w;
        c[3] = scale * first_w * first_w2;
        c[4] = scale * first_w * inc_w;
        c[5] = scale * first_w * first_w2 * inc_w;
    } else if fft_type == 2 {
        c[6] = scale;
        c[7] = scale * first_w;
        c[8] = scale * first_w * inc_w;
    } else {
        return Err(ProofmanError::InvalidSetup(format!("FFT4 native runtime gate has invalid type {fft_type}")));
    }

    let mut out = [F::ZERO; 12];
    for e in 0..3 {
        let a0 = witness[signals[e]];
        let a1 = witness[signals[3 + e]];
        let a2 = witness[signals[6 + e]];
        let a3 = witness[signals[9 + e]];
        out[e] = c[0] * a0 + c[1] * a1 + c[2] * a2 + c[3] * a3 + c[6] * a0 + c[7] * a1;
        out[3 + e] = c[0] * a0 - c[1] * a1 + c[4] * a2 - c[5] * a3 + c[6] * a0 - c[7] * a1;
        out[6 + e] = c[0] * a0 + c[1] * a1 - c[2] * a2 - c[3] * a3 + c[6] * a2 + c[8] * a3;
        out[9 + e] = c[0] * a0 - c[1] * a1 - c[4] * a2 + c[5] * a3 + c[6] * a2 - c[8] * a3;
    }
    Ok(out)
}

fn poseidon16_input<F: PrimeField64>(
    gate: &str,
    custom: bool,
    signals: &[usize],
    witness: &[F],
) -> ProofmanResult<[F; 16]> {
    let mut input = [F::ZERO; 16];
    for idx in 0..16 {
        input[idx] = witness[signals[idx]];
    }
    if !custom {
        return Ok(input);
    }

    order_cust_poseidon16_input(gate, input, witness[signals[16]], witness[signals[17]])
}

fn order_cust_poseidon16_input<F: PrimeField64>(
    gate: &str,
    input: [F; 16],
    key0: F,
    key1: F,
) -> ProofmanResult<[F; 16]> {
    let index = selector_index(key0, key1, gate)?;
    let order = match index {
        0 => [0usize, 1, 2, 3],
        1 => [1, 0, 2, 3],
        2 => [1, 2, 0, 3],
        3 => [1, 2, 3, 0],
        _ => unreachable!(),
    };
    let mut ordered = [F::ZERO; 16];
    for (dst_group, src_group) in order.into_iter().enumerate() {
        for idx in 0..4 {
            ordered[dst_group * 4 + idx] = input[src_group * 4 + idx];
        }
    }
    Ok(ordered)
}

fn poseidon16_trace<F: PrimeField64>(input: [F; 16]) -> [F; 208] {
    let mut state = input;
    let mut trace = [F::ZERO; 208];
    let mut row = 0usize;

    matmul_external::<F, 16>(&mut state);
    copy_poseidon_row(&mut trace, row, &state);
    row += 1;

    for r in 0..Poseidon16::HALF_ROUNDS {
        let constants = poseidon_constants::<F>(r * 16);
        pow7add::<F, 16>(&mut state, &constants);
        matmul_external::<F, 16>(&mut state);
        copy_poseidon_row(&mut trace, row, &state);
        row += 1;
    }

    let mut index = 0usize;
    for r in 0..Poseidon16::N_PARTIAL_ROUNDS {
        trace[row * 16 + index] = state[0];
        state[0] += F::from_u64(Poseidon16::RC[Poseidon16::HALF_ROUNDS * 16 + r]);
        state[0] = pow7(state[0]);
        let sum = add::<F, 16>(&state);
        prodadd::<F, 16>(&mut state, Poseidon16::DIAG, sum);
        index += 1;
        if r == Poseidon16::N_PARTIAL_ROUNDS / 2 - 1 || r == Poseidon16::N_PARTIAL_ROUNDS - 1 {
            trace[row * 16 + index] = F::ZERO;
            index = 0;
            row += 1;
            copy_poseidon_row(&mut trace, row, &state);
            row += 1;
        }
    }

    for r in 0..Poseidon16::HALF_ROUNDS {
        let constants = poseidon_constants::<F>(Poseidon16::HALF_ROUNDS * 16 + Poseidon16::N_PARTIAL_ROUNDS + r * 16);
        pow7add::<F, 16>(&mut state, &constants);
        matmul_external::<F, 16>(&mut state);
        if r + 1 == Poseidon16::HALF_ROUNDS {
            trace[192..208].copy_from_slice(&state);
        } else {
            copy_poseidon_row(&mut trace, row, &state);
            row += 1;
        }
    }

    trace
}

fn poseidon_constants<F: PrimeField64>(start: usize) -> [F; 16] {
    let mut out = [F::ZERO; 16];
    for idx in 0..16 {
        out[idx] = F::from_u64(Poseidon16::RC[start + idx]);
    }
    out
}

fn copy_poseidon_row<F: PrimeField64>(trace: &mut [F; 208], row: usize, state: &[F; 16]) {
    trace[row * 16..row * 16 + 16].copy_from_slice(state);
}

fn checked_table_end(path: &Path, start: usize, count: usize, row_len: usize, label: &str) -> ProofmanResult<usize> {
    start
        .checked_add(
            count
                .checked_mul(row_len)
                .ok_or_else(|| ProofmanError::InvalidSetup(format!("native runtime {label} table is too large")))?,
        )
        .ok_or_else(|| {
            ProofmanError::InvalidSetup(format!("{} has an overflowing native runtime {label} table", path.display()))
        })
}

const WASM_FIELD_BYTES: usize = 16;
const WASM_LONG_NORMAL_TAG: u64 = 0x8000_0000_0000_0000;
const CUSTOM_TEMPLATE_POSEIDON16: i32 = 1;
const CUSTOM_TEMPLATE_CUST_POSEIDON16: i32 = 2;
const CUSTOM_TEMPLATE_EVPOL4: i32 = 3;

#[derive(Default)]
struct NativeCircomWasmHost {
    exception: Option<i32>,
    message: Option<String>,
}

fn run_circom_custom_template<F: PrimeField64>(
    caller: &mut wasmtime::Caller<'_, NativeCircomWasmHost>,
    kind: i32,
    signal_base: i32,
) -> Result<(), String> {
    if signal_base < 0 {
        return Err(format!("Circom custom template has negative signal base address {signal_base}"));
    }
    let memory = caller
        .get_export("memory")
        .and_then(|export| export.into_memory())
        .ok_or_else(|| "Circom custom template cannot access WASM memory".to_string())?;
    let base = signal_base as usize;

    match kind {
        CUSTOM_TEMPLATE_POSEIDON16 => run_wasm_poseidon16::<F>(caller, &memory, base, false),
        CUSTOM_TEMPLATE_CUST_POSEIDON16 => run_wasm_poseidon16::<F>(caller, &memory, base, true),
        CUSTOM_TEMPLATE_EVPOL4 => run_wasm_evpol4::<F>(caller, &memory, base),
        _ => Err(format!("unsupported Circom custom template kind {kind}")),
    }
}

fn run_wasm_poseidon16<F: PrimeField64>(
    caller: &mut wasmtime::Caller<'_, NativeCircomWasmHost>,
    memory: &wasmtime::Memory,
    base: usize,
    custom: bool,
) -> Result<(), String> {
    let mut input = [F::ZERO; 16];
    for (idx, slot) in input.iter_mut().enumerate() {
        *slot = read_wasm_field_at(caller, memory, base, 208 + idx)?;
    }
    if custom {
        let key0 = read_wasm_field_at(caller, memory, base, 224)?;
        let key1 = read_wasm_field_at(caller, memory, base, 225)?;
        input = order_cust_poseidon16_input("CustPoseidon16", input, key0, key1).map_err(|err| err.to_string())?;
    }
    let trace = poseidon16_trace(input);
    for (idx, value) in trace.into_iter().enumerate() {
        write_wasm_field_at(caller, memory, base, idx, value)?;
    }
    Ok(())
}

fn run_wasm_evpol4<F: PrimeField64>(
    caller: &mut wasmtime::Caller<'_, NativeCircomWasmHost>,
    memory: &wasmtime::Memory,
    base: usize,
) -> Result<(), String> {
    let mut coefs = [[F::ZERO; 3]; 5];
    for coef_idx in 0..5 {
        for limb in 0..3 {
            coefs[coef_idx][limb] = read_wasm_field_at(caller, memory, base, 3 + coef_idx * 3 + limb)?;
        }
    }
    let x = [
        read_wasm_field_at(caller, memory, base, 18)?,
        read_wasm_field_at(caller, memory, base, 19)?,
        read_wasm_field_at(caller, memory, base, 20)?,
    ];
    let result = evpol4_values(coefs, x);
    for (idx, value) in result.into_iter().enumerate() {
        write_wasm_field_at(caller, memory, base, idx, value)?;
    }
    Ok(())
}

fn read_wasm_field_at<F: PrimeField64>(
    caller: &wasmtime::Caller<'_, NativeCircomWasmHost>,
    memory: &wasmtime::Memory,
    base: usize,
    index: usize,
) -> Result<F, String> {
    let addr = base
        .checked_add(
            index
                .checked_mul(WASM_FIELD_BYTES)
                .ok_or_else(|| "Circom custom template signal offset overflows".to_string())?,
        )
        .ok_or_else(|| "Circom custom template signal address overflows".to_string())?;
    read_wasm_fr(caller, memory, addr)
}

fn write_wasm_field_at<F: PrimeField64>(
    caller: &mut wasmtime::Caller<'_, NativeCircomWasmHost>,
    memory: &wasmtime::Memory,
    base: usize,
    index: usize,
    value: F,
) -> Result<(), String> {
    let addr = base
        .checked_add(
            index
                .checked_mul(WASM_FIELD_BYTES)
                .ok_or_else(|| "Circom custom template signal offset overflows".to_string())?,
        )
        .ok_or_else(|| "Circom custom template signal address overflows".to_string())?;
    write_wasm_fr(caller, memory, addr, value)
}

fn read_wasm_fr<F: PrimeField64>(
    caller: &wasmtime::Caller<'_, NativeCircomWasmHost>,
    memory: &wasmtime::Memory,
    addr: usize,
) -> Result<F, String> {
    let data = memory.data(caller);
    let end = addr.checked_add(WASM_FIELD_BYTES).ok_or_else(|| "Circom field address overflows".to_string())?;
    if end > data.len() {
        return Err(format!(
            "Circom custom template reads field [{addr}..{end}) outside WASM memory size {}",
            data.len()
        ));
    }
    let marker = data[addr + 7];
    if marker & 0x80 == 0 {
        let raw = i32::from_le_bytes(
            data[addr..addr + 4].try_into().map_err(|_| "failed to decode Circom short field".to_string())?,
        );
        if raw >= 0 {
            Ok(F::from_u64(raw as u64))
        } else {
            Ok(-F::from_u64(raw.unsigned_abs() as u64))
        }
    } else {
        if marker & 0x40 != 0 {
            return Err("Circom custom template input was not converted out of Montgomery form".to_string());
        }
        let value = u64::from_le_bytes(
            data[addr + 8..addr + 16].try_into().map_err(|_| "failed to decode Circom long field".to_string())?,
        );
        Ok(F::from_u64(value))
    }
}

fn write_wasm_fr<F: PrimeField64>(
    caller: &mut wasmtime::Caller<'_, NativeCircomWasmHost>,
    memory: &wasmtime::Memory,
    addr: usize,
    value: F,
) -> Result<(), String> {
    let mut bytes = [0u8; WASM_FIELD_BYTES];
    bytes[..8].copy_from_slice(&WASM_LONG_NORMAL_TAG.to_le_bytes());
    bytes[8..].copy_from_slice(&value.as_canonical_u64().to_le_bytes());
    memory
        .write(caller, addr, &bytes)
        .map_err(|err| format!("failed to write Circom custom template output at {addr}: {err}"))
}

fn check_circom_wasm_exception(
    store: &mut wasmtime::Store<NativeCircomWasmHost>,
    get_message_char: &wasmtime::TypedFunc<(), i32>,
) -> ProofmanResult<()> {
    if let Some(code) = store.data().exception {
        let host_message = store.data().message.clone();
        let message = host_message.unwrap_or_else(|| read_circom_wasm_message(store, get_message_char));
        let detail = if message.is_empty() { String::new() } else { format!(": {message}") };
        return Err(ProofmanError::InvalidProof(format!("Circom witness WASM raised exception code {code}{detail}")));
    }
    Ok(())
}

fn read_circom_wasm_message(
    store: &mut wasmtime::Store<NativeCircomWasmHost>,
    get_message_char: &wasmtime::TypedFunc<(), i32>,
) -> String {
    let mut out = Vec::with_capacity(256);
    for _ in 0..256 {
        let Ok(ch) = get_message_char.call(&mut *store, ()) else { break };
        let ch = ch as u8;
        if ch == 0 {
            break;
        }
        out.push(ch);
    }
    String::from_utf8_lossy(&out).trim_end_matches(char::from(0)).to_string()
}

fn write_circom_wasm_u64(
    store: &mut wasmtime::Store<NativeCircomWasmHost>,
    write_shared: &wasmtime::TypedFunc<(i32, i32), ()>,
    value: u64,
) -> ProofmanResult<()> {
    write_shared
        .call(&mut *store, (0, value as u32 as i32))
        .map_err(|err| ProofmanError::InvalidProof(format!("failed to write Circom input low word: {err}")))?;
    write_shared
        .call(&mut *store, (1, (value >> 32) as u32 as i32))
        .map_err(|err| ProofmanError::InvalidProof(format!("failed to write Circom input high word: {err}")))?;
    Ok(())
}

static CIRCOM_WASMTIME_ENGINE: OnceLock<wasmtime::Engine> = OnceLock::new();
static CIRCOM_WASMTIME_MODULES: OnceLock<Mutex<HashMap<(u64, usize), wasmtime::Module>>> = OnceLock::new();

fn circom_wasmtime_module(wasm: &[u8]) -> ProofmanResult<(&'static wasmtime::Engine, wasmtime::Module)> {
    let engine = CIRCOM_WASMTIME_ENGINE.get_or_init(wasmtime::Engine::default);
    let key = (hash_circom_wasm(wasm), wasm.len());
    let cache = CIRCOM_WASMTIME_MODULES.get_or_init(|| Mutex::new(HashMap::new()));
    if let Some(module) = cache
        .lock()
        .map_err(|_| ProofmanError::InvalidSetup("Circom WASM module cache is poisoned".to_string()))?
        .get(&key)
        .cloned()
    {
        return Ok((engine, module));
    }

    let module = wasmtime::Module::new(engine, wasm)
        .map_err(|err| ProofmanError::InvalidSetup(format!("invalid native Circom witness WASM: {err}")))?;
    cache
        .lock()
        .map_err(|_| ProofmanError::InvalidSetup("Circom WASM module cache is poisoned".to_string()))?
        .insert(key, module.clone());
    Ok((engine, module))
}

fn hash_circom_wasm(wasm: &[u8]) -> u64 {
    let mut hasher = DefaultHasher::new();
    wasm.hash(&mut hasher);
    hasher.finish()
}

fn parse_circom_wasm_runtime(
    path: &Path,
    bytes: &[u8],
    offset: usize,
) -> ProofmanResult<(Option<NativeCircomWasmRuntime>, usize)> {
    let tag = read_u64(bytes, offset)?;
    let mut cursor = offset + 8;
    match tag {
        0 => Ok((None, cursor)),
        1 => {
            let wasm_len = usize::try_from(read_u64(bytes, cursor)?).map_err(|_| {
                ProofmanError::InvalidSetup(format!("{} has an oversized Circom WASM runtime", path.display()))
            })?;
            cursor += 8;
            let wasm_end = cursor.checked_add(wasm_len).ok_or_else(|| {
                ProofmanError::InvalidSetup(format!("{} has an overflowing Circom WASM runtime", path.display()))
            })?;
            if wasm_end > bytes.len() {
                return Err(ProofmanError::InvalidSetup(format!(
                    "{} has a truncated Circom WASM runtime",
                    path.display()
                )));
            }
            let wasm = bytes[cursor..wasm_end].to_vec();
            cursor = wasm_end;

            let input_count = usize::try_from(read_u64(bytes, cursor)?).map_err(|_| {
                ProofmanError::InvalidSetup(format!("{} has too many Circom WASM inputs", path.display()))
            })?;
            cursor += 8;
            let inputs_end = checked_table_end(path, cursor, input_count, 24, "Circom WASM input")?;
            if inputs_end > bytes.len() {
                return Err(ProofmanError::InvalidSetup(format!(
                    "{} has a truncated Circom WASM input table",
                    path.display()
                )));
            }
            let mut inputs = Vec::with_capacity(input_count);
            for index in 0..input_count {
                let input_offset = cursor + index * 24;
                inputs.push(NativeCircomWasmInput {
                    hash: read_u64(bytes, input_offset)?,
                    source_offset_words: read_u64(bytes, input_offset + 8)?,
                    word_len: read_u64(bytes, input_offset + 16)?,
                });
            }
            Ok((Some(NativeCircomWasmRuntime { wasm, inputs }), inputs_end))
        }
        other => Err(ProofmanError::InvalidSetup(format!(
            "{} has unsupported Circom WASM runtime tag {other}",
            path.display()
        ))),
    }
}

fn parse_constraints(
    path: &Path,
    bytes: &[u8],
    constraints_offset: usize,
) -> ProofmanResult<(Vec<NativeRuntimeConstraint>, usize)> {
    let count = read_u64(bytes, constraints_offset)? as usize;
    let mut offset = constraints_offset + 8;
    let mut constraints = Vec::with_capacity(count);
    for _ in 0..count {
        let (a, next) = parse_lc(path, bytes, offset)?;
        let (b, next) = parse_lc(path, bytes, next)?;
        let (c, next) = parse_lc(path, bytes, next)?;
        offset = next;
        constraints.push(NativeRuntimeConstraint { a, b, c });
    }
    Ok((constraints, offset))
}

fn parse_lc(path: &Path, bytes: &[u8], offset: usize) -> ProofmanResult<(Vec<NativeRuntimeLcTerm>, usize)> {
    let count = read_u64(bytes, offset)? as usize;
    let terms_start = offset + 8;
    let terms_end = checked_table_end(path, terms_start, count, 16, "R1CS linear-combination")?;
    if terms_end > bytes.len() {
        return Err(ProofmanError::InvalidSetup(format!(
            "{} has a truncated native runtime R1CS linear-combination table",
            path.display()
        )));
    }

    let mut terms = Vec::with_capacity(count);
    for index in 0..count {
        let offset = terms_start + index * 16;
        terms.push(NativeRuntimeLcTerm { signal: read_u64(bytes, offset)?, coeff: read_u64(bytes, offset + 8)? });
    }
    Ok((terms, terms_end))
}

fn parse_custom_gates(
    path: &Path,
    bytes: &[u8],
    custom_gates_offset: usize,
    version: u64,
) -> ProofmanResult<Vec<NativeRuntimeCustomGate>> {
    let count = read_u64(bytes, custom_gates_offset)? as usize;
    let mut offset = custom_gates_offset + 8;
    let mut custom_gates = Vec::with_capacity(count);
    for _ in 0..count {
        let kind_id = read_u64(bytes, offset)?;
        let kind = match kind_id {
            1 => NativeRuntimeCustomGateKind::CMul,
            2 => NativeRuntimeCustomGateKind::EvPol4,
            3 => NativeRuntimeCustomGateKind::TreeSelector4,
            4 => NativeRuntimeCustomGateKind::SelectValue1,
            5 => NativeRuntimeCustomGateKind::FFT4,
            6 => NativeRuntimeCustomGateKind::Poseidon16,
            7 => NativeRuntimeCustomGateKind::CustPoseidon16,
            other => {
                return Err(ProofmanError::InvalidSetup(format!(
                    "{} references unsupported native runtime custom gate kind {other}",
                    path.display()
                )))
            }
        };
        let (parameters, signal_count_offset) = if version >= 2 {
            let parameter_count = read_u64(bytes, offset + 8)? as usize;
            let parameters_start = offset + 16;
            let parameters_end =
                checked_table_end(path, parameters_start, parameter_count, 8, "custom gate parameter")?;
            if parameters_end > bytes.len() {
                return Err(ProofmanError::InvalidSetup(format!(
                    "{} has a truncated native runtime custom gate parameter table",
                    path.display()
                )));
            }
            let mut parameters = Vec::with_capacity(parameter_count);
            for index in 0..parameter_count {
                parameters.push(read_u64(bytes, parameters_start + index * 8)?);
            }
            (parameters, parameters_end)
        } else {
            (Vec::new(), offset + 8)
        };
        let signal_count = read_u64(bytes, signal_count_offset)? as usize;
        let signals_start = signal_count_offset + 8;
        let signals_end = checked_table_end(path, signals_start, signal_count, 8, "custom gate signal")?;
        if signals_end > bytes.len() {
            return Err(ProofmanError::InvalidSetup(format!(
                "{} has a truncated native runtime custom gate signal table",
                path.display()
            )));
        }
        let mut signals = Vec::with_capacity(signal_count);
        for index in 0..signal_count {
            signals.push(read_u64(bytes, signals_start + index * 8)?);
        }
        offset = signals_end;
        custom_gates.push(NativeRuntimeCustomGate { kind, parameters, signals });
    }
    Ok(custom_gates)
}

fn read_u64(bytes: &[u8], offset: usize) -> ProofmanResult<u64> {
    let end = offset + 8;
    let chunk = bytes
        .get(offset..end)
        .ok_or_else(|| ProofmanError::InvalidSetup("native runtime descriptor is truncated".to_string()))?;
    Ok(u64::from_le_bytes(chunk.try_into()?))
}

#[cfg(test)]
mod tests {
    use fields::{Field, Goldilocks};

    use super::*;

    #[test]
    fn parses_native_runtime_descriptor() -> ProofmanResult<()> {
        let dir = std::env::temp_dir().join(format!("proofman_native_runtime_test_{}", std::process::id()));
        std::fs::create_dir_all(&dir)?;
        let path = dir.join("recursive2.dat");

        let mut bytes = Vec::new();
        bytes.extend_from_slice(MAGIC);
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&13u64.to_le_bytes());
        bytes.extend_from_slice(&3u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&3u64.to_le_bytes());
        bytes.extend_from_slice(&2u64.to_le_bytes());
        bytes.extend_from_slice(&4u64.to_le_bytes());
        bytes.extend_from_slice(&2u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&10u64.to_le_bytes());
        bytes.extend_from_slice(&6u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&3u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&0u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&2u64.to_le_bytes());
        bytes.extend_from_slice(&6u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&6u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&7u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&8u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&1u64.to_le_bytes());
        bytes.extend_from_slice(&9u64.to_le_bytes());
        for signal in [1u64, 2, 3, 4, 5, 6, 9, 10, 11] {
            bytes.extend_from_slice(&signal.to_le_bytes());
        }
        std::fs::write(&path, bytes)?;

        let runtime = NativeRecursiveRuntime::from_dat_file(&path)?;
        assert_eq!(runtime.size_witness_words, 13);
        assert_eq!(runtime.copy_indices, vec![4, 2]);
        assert_eq!(runtime.source_assertions.len(), 1);
        assert_eq!(runtime.source_public_prefix_words, 6);
        assert_eq!(runtime.source_sections.len(), 1);
        assert_eq!(runtime.section_copy_ops.len(), 1);
        assert_eq!(runtime.constraints.len(), 1);
        assert_eq!(runtime.custom_gates.len(), 1);

        let witness = runtime.generate_witness::<Goldilocks>(&[10, 20, 30, 40, 50], 13)?;
        assert_eq!(witness[0].as_canonical_u64(), 1);
        assert_eq!(witness[1].as_canonical_u64(), 50);
        assert_eq!(witness[2].as_canonical_u64(), 30);
        assert_eq!(witness[3].as_canonical_u64(), 30);
        assert_eq!(witness[6].as_canonical_u64(), 30);
        assert_eq!(witness[7].as_canonical_u64(), 40);
        assert_eq!(witness[8].as_canonical_u64(), 1200);
        assert_eq!(witness[9].as_canonical_u64(), 4400);
        assert_eq!(witness[10].as_canonical_u64(), 7000);
        assert_eq!(witness[11].as_canonical_u64(), 5100);

        std::fs::remove_dir_all(&dir)?;
        Ok(())
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
            circom_wasm: None,
            constraints,
            custom_gates: Vec::new(),
            solver_index: OnceLock::new(),
        };

        let witness = runtime.generate_witness::<Goldilocks>(&[10], 6)?;
        assert_eq!(witness[2].as_canonical_u64(), 0);
        assert_eq!(witness[3].as_canonical_u64(), 1);
        assert_eq!(witness[4].as_canonical_u64(), 0);
        assert_eq!(witness[5].as_canonical_u64(), 1);
        Ok(())
    }

    #[test]
    fn inverse_solves_unprotected_cmul_input() -> ProofmanResult<()> {
        let a = [Goldilocks::from_u64(2), Goldilocks::from_u64(3), Goldilocks::from_u64(4)];
        let b = [Goldilocks::from_u64(5), Goldilocks::from_u64(7), Goldilocks::from_u64(11)];
        let output = cmul(a, b);
        let runtime = NativeRecursiveRuntime {
            template_id: 0,
            size_witness_words: 10,
            n_publics: 0,
            public_input_offset_words: 0,
            public_input_copy_words: 0,
            copy_indices: Vec::new(),
            source_assertions: Vec::new(),
            source_public_prefix_words: 0,
            source_sections: vec![NativeRuntimeSection { start_word: 0, word_len: 6, kind: 0, flags: 0 }],
            section_copy_ops: vec![
                NativeRuntimeSectionCopyOp {
                    section_index: 0,
                    section_offset_words: 0,
                    word_len: 3,
                    witness_offset_words: 1,
                },
                NativeRuntimeSectionCopyOp {
                    section_index: 0,
                    section_offset_words: 3,
                    word_len: 3,
                    witness_offset_words: 7,
                },
            ],
            circom_wasm: None,
            constraints: Vec::new(),
            custom_gates: vec![NativeRuntimeCustomGate {
                kind: NativeRuntimeCustomGateKind::CMul,
                parameters: Vec::new(),
                signals: (1..=9).collect(),
            }],
            solver_index: OnceLock::new(),
        };
        let source = a.into_iter().chain(output).map(|value| value.as_canonical_u64()).collect::<Vec<_>>();

        let witness = runtime.generate_witness::<Goldilocks>(&source, 10)?;
        assert_eq!(witness[4], b[0]);
        assert_eq!(witness[5], b[1]);
        assert_eq!(witness[6], b[2]);
        Ok(())
    }

    #[test]
    fn does_not_inverse_solve_protected_cmul_input() -> ProofmanResult<()> {
        let a = [Goldilocks::from_u64(2), Goldilocks::from_u64(3), Goldilocks::from_u64(4)];
        let b = [Goldilocks::from_u64(5), Goldilocks::from_u64(7), Goldilocks::from_u64(11)];
        let output = cmul(a, b);
        let runtime = NativeRecursiveRuntime {
            template_id: 0,
            size_witness_words: 14,
            n_publics: 0,
            public_input_offset_words: 0,
            public_input_copy_words: 0,
            copy_indices: Vec::new(),
            source_assertions: Vec::new(),
            source_public_prefix_words: 0,
            source_sections: vec![NativeRuntimeSection { start_word: 0, word_len: 10, kind: 0, flags: 0 }],
            section_copy_ops: vec![
                NativeRuntimeSectionCopyOp {
                    section_index: 0,
                    section_offset_words: 0,
                    word_len: 3,
                    witness_offset_words: 1,
                },
                NativeRuntimeSectionCopyOp {
                    section_index: 0,
                    section_offset_words: 3,
                    word_len: 3,
                    witness_offset_words: 7,
                },
                NativeRuntimeSectionCopyOp {
                    section_index: 0,
                    section_offset_words: 6,
                    word_len: 4,
                    witness_offset_words: 10,
                },
            ],
            circom_wasm: None,
            constraints: vec![
                NativeRuntimeConstraint {
                    a: Vec::new(),
                    b: Vec::new(),
                    c: vec![
                        NativeRuntimeLcTerm { signal: 4, coeff: 1 },
                        NativeRuntimeLcTerm { signal: 10, coeff: 1 },
                        NativeRuntimeLcTerm { signal: 11, coeff: GOLDILOCKS_P_MINUS_ONE },
                    ],
                },
                NativeRuntimeConstraint {
                    a: Vec::new(),
                    b: Vec::new(),
                    c: vec![
                        NativeRuntimeLcTerm { signal: 5, coeff: 1 },
                        NativeRuntimeLcTerm { signal: 10, coeff: 1 },
                        NativeRuntimeLcTerm { signal: 12, coeff: GOLDILOCKS_P_MINUS_ONE },
                    ],
                },
                NativeRuntimeConstraint {
                    a: Vec::new(),
                    b: Vec::new(),
                    c: vec![
                        NativeRuntimeLcTerm { signal: 6, coeff: 1 },
                        NativeRuntimeLcTerm { signal: 10, coeff: 1 },
                        NativeRuntimeLcTerm { signal: 13, coeff: GOLDILOCKS_P_MINUS_ONE },
                    ],
                },
            ],
            custom_gates: vec![NativeRuntimeCustomGate {
                kind: NativeRuntimeCustomGateKind::CMul,
                parameters: Vec::new(),
                signals: (1..=9).collect(),
            }],
            solver_index: OnceLock::new(),
        };
        let two = Goldilocks::from_u64(2);
        let protected_b = [b[0] + two, b[1] + two, b[2] + two];
        let source = a
            .into_iter()
            .chain(output)
            .chain([Goldilocks::ONE, protected_b[0], protected_b[1], protected_b[2]])
            .map(|value| value.as_canonical_u64())
            .collect::<Vec<_>>();

        let err = runtime.generate_witness::<Goldilocks>(&source, 14).unwrap_err();
        assert!(err.to_string().contains("CMul gate output mismatch"));
        Ok(())
    }

    #[test]
    fn solves_evpol4_custom_gate() -> ProofmanResult<()> {
        let runtime = NativeRecursiveRuntime {
            template_id: 0,
            size_witness_words: 22,
            n_publics: 0,
            public_input_offset_words: 1,
            public_input_copy_words: 0,
            copy_indices: Vec::new(),
            source_assertions: Vec::new(),
            source_public_prefix_words: 18,
            source_sections: Vec::new(),
            section_copy_ops: Vec::new(),
            circom_wasm: None,
            constraints: Vec::new(),
            custom_gates: vec![NativeRuntimeCustomGate {
                kind: NativeRuntimeCustomGateKind::EvPol4,
                parameters: Vec::new(),
                signals: (1..=21).collect(),
            }],
            solver_index: OnceLock::new(),
        };
        let mut source = vec![0u64; 18];
        source[0] = 1;
        source[15] = 7;
        source[16] = 11;
        source[17] = 13;

        let witness = runtime.generate_witness::<Goldilocks>(&source, 22)?;
        assert_eq!(witness[19].as_canonical_u64(), 1);
        assert_eq!(witness[20].as_canonical_u64(), 0);
        assert_eq!(witness[21].as_canonical_u64(), 0);
        Ok(())
    }

    #[test]
    fn solves_tree_selector4_custom_gate() -> ProofmanResult<()> {
        let runtime = NativeRecursiveRuntime {
            template_id: 0,
            size_witness_words: 18,
            n_publics: 0,
            public_input_offset_words: 1,
            public_input_copy_words: 0,
            copy_indices: Vec::new(),
            source_assertions: Vec::new(),
            source_public_prefix_words: 14,
            source_sections: Vec::new(),
            section_copy_ops: Vec::new(),
            circom_wasm: None,
            constraints: Vec::new(),
            custom_gates: vec![NativeRuntimeCustomGate {
                kind: NativeRuntimeCustomGateKind::TreeSelector4,
                parameters: Vec::new(),
                signals: (1..=17).collect(),
            }],
            solver_index: OnceLock::new(),
        };
        let source = vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 0, 1];

        let witness = runtime.generate_witness::<Goldilocks>(&source, 18)?;
        assert_eq!(witness[15].as_canonical_u64(), 7);
        assert_eq!(witness[16].as_canonical_u64(), 8);
        assert_eq!(witness[17].as_canonical_u64(), 9);
        Ok(())
    }

    #[test]
    fn solves_select_value1_custom_gate() -> ProofmanResult<()> {
        let runtime = NativeRecursiveRuntime {
            template_id: 0,
            size_witness_words: 23,
            n_publics: 0,
            public_input_offset_words: 1,
            public_input_copy_words: 0,
            copy_indices: Vec::new(),
            source_assertions: Vec::new(),
            source_public_prefix_words: 18,
            source_sections: Vec::new(),
            section_copy_ops: Vec::new(),
            circom_wasm: None,
            constraints: Vec::new(),
            custom_gates: vec![NativeRuntimeCustomGate {
                kind: NativeRuntimeCustomGateKind::SelectValue1,
                parameters: Vec::new(),
                signals: (1..=22).collect(),
            }],
            solver_index: OnceLock::new(),
        };
        let source = vec![1, 2, 3, 4, 11, 12, 13, 14, 21, 22, 23, 24, 31, 32, 33, 34, 1, 1];

        let witness = runtime.generate_witness::<Goldilocks>(&source, 23)?;
        assert_eq!(witness[19].as_canonical_u64(), 31);
        assert_eq!(witness[20].as_canonical_u64(), 32);
        assert_eq!(witness[21].as_canonical_u64(), 33);
        assert_eq!(witness[22].as_canonical_u64(), 34);
        Ok(())
    }

    #[test]
    fn solves_fft4_custom_gate() -> ProofmanResult<()> {
        let runtime = NativeRecursiveRuntime {
            template_id: 0,
            size_witness_words: 25,
            n_publics: 0,
            public_input_offset_words: 1,
            public_input_copy_words: 0,
            copy_indices: Vec::new(),
            source_assertions: Vec::new(),
            source_public_prefix_words: 12,
            source_sections: Vec::new(),
            section_copy_ops: Vec::new(),
            circom_wasm: None,
            constraints: Vec::new(),
            custom_gates: vec![NativeRuntimeCustomGate {
                kind: NativeRuntimeCustomGateKind::FFT4,
                parameters: vec![1, 1, 1, 2],
                signals: (1..=24).collect(),
            }],
            solver_index: OnceLock::new(),
        };
        let source = vec![10, 20, 30, 1, 2, 3, 40, 50, 60, 4, 5, 6];

        let witness = runtime.generate_witness::<Goldilocks>(&source, 25)?;
        let expected = [11, 22, 33, 9, 18, 27, 44, 55, 66, 36, 45, 54];
        for (idx, expected) in expected.into_iter().enumerate() {
            assert_eq!(witness[13 + idx].as_canonical_u64(), expected);
        }
        Ok(())
    }

    #[test]
    fn solves_poseidon16_custom_gate() -> ProofmanResult<()> {
        let runtime = NativeRecursiveRuntime {
            template_id: 0,
            size_witness_words: 225,
            n_publics: 0,
            public_input_offset_words: 1,
            public_input_copy_words: 16,
            copy_indices: Vec::new(),
            source_assertions: Vec::new(),
            source_public_prefix_words: 0,
            source_sections: Vec::new(),
            section_copy_ops: Vec::new(),
            circom_wasm: None,
            constraints: Vec::new(),
            custom_gates: vec![NativeRuntimeCustomGate {
                kind: NativeRuntimeCustomGateKind::Poseidon16,
                parameters: Vec::new(),
                signals: (1..=224).collect(),
            }],
            solver_index: OnceLock::new(),
        };
        let source = (1..=16).collect::<Vec<_>>();

        let witness = runtime.generate_witness::<Goldilocks>(&source, 225)?;
        let mut input = [Goldilocks::ZERO; 16];
        for idx in 0..16 {
            input[idx] = Goldilocks::from_u64(source[idx]);
        }
        let expected = fields::poseidon2_hash::<Goldilocks, Poseidon16, 16>(&input);
        for (idx, expected) in expected.into_iter().enumerate() {
            assert_eq!(witness[209 + idx], expected);
        }
        Ok(())
    }

    #[test]
    fn solves_cust_poseidon16_custom_gate() -> ProofmanResult<()> {
        let runtime = NativeRecursiveRuntime {
            template_id: 0,
            size_witness_words: 227,
            n_publics: 0,
            public_input_offset_words: 1,
            public_input_copy_words: 18,
            copy_indices: Vec::new(),
            source_assertions: Vec::new(),
            source_public_prefix_words: 0,
            source_sections: Vec::new(),
            section_copy_ops: Vec::new(),
            circom_wasm: None,
            constraints: Vec::new(),
            custom_gates: vec![NativeRuntimeCustomGate {
                kind: NativeRuntimeCustomGateKind::CustPoseidon16,
                parameters: Vec::new(),
                signals: (1..=226).collect(),
            }],
            solver_index: OnceLock::new(),
        };
        let mut source = (1..=16).collect::<Vec<_>>();
        source.push(1);
        source.push(1);

        let witness = runtime.generate_witness::<Goldilocks>(&source, 227)?;
        let order = [1usize, 2, 3, 0];
        let mut input = [Goldilocks::ZERO; 16];
        for (dst_group, src_group) in order.into_iter().enumerate() {
            for idx in 0..4 {
                input[dst_group * 4 + idx] = Goldilocks::from_u64(source[src_group * 4 + idx]);
            }
        }
        let expected = fields::poseidon2_hash::<Goldilocks, Poseidon16, 16>(&input);
        for (idx, expected) in expected.into_iter().enumerate() {
            assert_eq!(witness[211 + idx], expected);
        }
        Ok(())
    }
}
