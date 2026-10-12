use fields::{add, matmul_external, pow7, pow7add, prodadd, Poseidon16, Poseidon2Constants, PrimeField64};

use super::{
    is_known, set_known, GateSignalList, KnownValue, NativeRuntimeCustomGate, NativeRuntimeCustomGateKind,
    NativeRuntimeSolverIndex,
};
use crate::{ProofmanError, ProofmanResult};

pub(super) fn try_solve_custom_gate<F: PrimeField64>(
    gate: &NativeRuntimeCustomGate,
    witness: &mut [F],
    known: &mut [KnownValue],
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

pub(super) fn verify_custom_gate<F: PrimeField64>(
    gate: &NativeRuntimeCustomGate,
    witness: &[F],
    known: &[KnownValue],
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

pub(super) fn custom_gate_fully_known_and_satisfied<F: PrimeField64>(
    gate: &NativeRuntimeCustomGate,
    witness: &[F],
    known: &[KnownValue],
) -> ProofmanResult<bool> {
    let signals = gate_signals(&gate.signals, witness.len())?;
    if signals.iter().any(|&signal| !is_known(known, signal)) {
        return Ok(false);
    }
    verify_custom_gate(gate, witness, known)?;
    Ok(true)
}

fn solve_cmul_gate<F: PrimeField64>(
    gate: &NativeRuntimeCustomGate,
    witness: &mut [F],
    known: &mut [KnownValue],
    solver_index: &NativeRuntimeSolverIndex,
) -> ProofmanResult<bool> {
    if gate.signals.len() != 9 {
        return Err(ProofmanError::InvalidSetup(format!(
            "CMul native runtime gate must have 9 signals, got {}",
            gate.signals.len()
        )));
    }
    let signals = fixed_gate_signals::<9>("CMul", &gate.signals, witness.len())?;
    let a_known = signals[..3].iter().all(|&signal| is_known(known, signal));
    let b_known = signals[3..6].iter().all(|&signal| is_known(known, signal));
    let output_known = signals[6..9].iter().all(|&signal| is_known(known, signal));

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
    known: &[KnownValue],
) -> ProofmanResult<()> {
    if gate.signals.len() != 9 {
        return Err(ProofmanError::InvalidSetup(format!(
            "CMul native runtime gate must have 9 signals, got {}",
            gate.signals.len()
        )));
    }
    let signals = fixed_gate_signals::<9>("CMul", &gate.signals, witness.len())?;
    if signals.iter().any(|&signal| !is_known(known, signal)) {
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
    known: &mut [KnownValue],
) -> ProofmanResult<bool> {
    if gate.signals.len() != 21 {
        return Err(ProofmanError::InvalidSetup(format!(
            "EvPol4 native runtime gate must have 21 signals, got {}",
            gate.signals.len()
        )));
    }
    let signals = gate_signals(&gate.signals, witness.len())?;
    if signals[..18].iter().any(|&signal| !is_known(known, signal)) {
        return Ok(false);
    }

    let result = evpol4(&signals, witness);
    let mut changed = false;
    for idx in 0..3 {
        let signal = signals[18 + idx];
        if is_known(known, signal) {
            if witness[signal] != result[idx] {
                return Err(ProofmanError::InvalidProof(format!(
                    "native recursive EvPol4 gate output mismatch at signal {signal}"
                )));
            }
        } else {
            witness[signal] = result[idx];
            set_known(known, signal);
            changed = true;
        }
    }
    Ok(changed)
}

fn verify_evpol4_gate<F: PrimeField64>(
    gate: &NativeRuntimeCustomGate,
    witness: &[F],
    known: &[KnownValue],
) -> ProofmanResult<()> {
    if gate.signals.len() != 21 {
        return Err(ProofmanError::InvalidSetup(format!(
            "EvPol4 native runtime gate must have 21 signals, got {}",
            gate.signals.len()
        )));
    }
    let signals = gate_signals(&gate.signals, witness.len())?;
    if signals.iter().any(|&signal| !is_known(known, signal)) {
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
    known: &mut [KnownValue],
) -> ProofmanResult<bool> {
    if gate.signals.len() != 17 {
        return Err(ProofmanError::InvalidSetup(format!(
            "TreeSelector4 native runtime gate must have 17 signals, got {}",
            gate.signals.len()
        )));
    }
    let signals = gate_signals(&gate.signals, witness.len())?;
    if signals[..14].iter().any(|&signal| !is_known(known, signal)) {
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
    known: &[KnownValue],
) -> ProofmanResult<()> {
    if gate.signals.len() != 17 {
        return Err(ProofmanError::InvalidSetup(format!(
            "TreeSelector4 native runtime gate must have 17 signals, got {}",
            gate.signals.len()
        )));
    }
    let signals = gate_signals(&gate.signals, witness.len())?;
    if signals.iter().any(|&signal| !is_known(known, signal)) {
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
    known: &mut [KnownValue],
) -> ProofmanResult<bool> {
    if gate.signals.len() != 22 {
        return Err(ProofmanError::InvalidSetup(format!(
            "SelectValue1 native runtime gate must have 22 signals, got {}",
            gate.signals.len()
        )));
    }
    let signals = gate_signals(&gate.signals, witness.len())?;
    if signals[..18].iter().any(|&signal| !is_known(known, signal)) {
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
    known: &[KnownValue],
) -> ProofmanResult<()> {
    if gate.signals.len() != 22 {
        return Err(ProofmanError::InvalidSetup(format!(
            "SelectValue1 native runtime gate must have 22 signals, got {}",
            gate.signals.len()
        )));
    }
    let signals = gate_signals(&gate.signals, witness.len())?;
    if signals.iter().any(|&signal| !is_known(known, signal)) {
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
    known: &mut [KnownValue],
) -> ProofmanResult<bool> {
    if gate.signals.len() != 24 {
        return Err(ProofmanError::InvalidSetup(format!(
            "FFT4 native runtime gate must have 24 signals, got {}",
            gate.signals.len()
        )));
    }
    let signals = gate_signals(&gate.signals, witness.len())?;
    if signals[..12].iter().any(|&signal| !is_known(known, signal)) {
        return Ok(false);
    }

    let result = fft4(&gate.parameters, &signals, witness)?;
    assign_gate_outputs("FFT4", &signals[12..24], result, witness, known)
}

fn verify_fft4_gate<F: PrimeField64>(
    gate: &NativeRuntimeCustomGate,
    witness: &[F],
    known: &[KnownValue],
) -> ProofmanResult<()> {
    if gate.signals.len() != 24 {
        return Err(ProofmanError::InvalidSetup(format!(
            "FFT4 native runtime gate must have 24 signals, got {}",
            gate.signals.len()
        )));
    }
    let signals = gate_signals(&gate.signals, witness.len())?;
    if signals.iter().any(|&signal| !is_known(known, signal)) {
        return Ok(());
    }
    let result = fft4(&gate.parameters, &signals, witness)?;
    verify_gate_outputs("FFT4", &signals[12..24], result, witness)
}

fn solve_poseidon16_gate<F: PrimeField64>(
    gate: &NativeRuntimeCustomGate,
    witness: &mut [F],
    known: &mut [KnownValue],
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
    if signals[..input_end].iter().any(|&signal| !is_known(known, signal)) {
        return Ok(false);
    }

    let input = poseidon16_input(gate_name, custom, &signals, witness)?;
    let result = poseidon16_trace(input);
    assign_gate_outputs(gate_name, &signals[output_start..output_start + 208], result, witness, known)
}

fn verify_poseidon16_gate<F: PrimeField64>(
    gate: &NativeRuntimeCustomGate,
    witness: &[F],
    known: &[KnownValue],
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
    if signals.iter().any(|&signal| !is_known(known, signal)) {
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

fn fixed_gate_signals<const N: usize>(gate: &str, signals: &[u64], witness_len: usize) -> ProofmanResult<[usize; N]> {
    if signals.len() != N {
        return Err(ProofmanError::InvalidSetup(format!(
            "{gate} native runtime gate must have {N} signals, got {}",
            signals.len()
        )));
    }
    let mut out = [0usize; N];
    for (idx, &signal) in signals.iter().enumerate() {
        let signal = usize::try_from(signal).map_err(|_| {
            ProofmanError::InvalidSetup(format!("native recursive custom gate signal {signal} is too large"))
        })?;
        if signal >= witness_len {
            return Err(ProofmanError::InvalidSetup(format!(
                "native recursive custom gate signal {signal} is outside witness size {witness_len}"
            )));
        }
        out[idx] = signal;
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
    known: &mut [KnownValue],
) -> ProofmanResult<bool> {
    let mut changed = false;
    for (idx, &signal) in output_signals.iter().enumerate() {
        if is_known(known, signal) {
            if witness[signal] != expected[idx] {
                return Err(ProofmanError::InvalidProof(format!(
                    "native recursive {gate} gate output mismatch at signal {signal}: expected {} got {}",
                    expected[idx].as_canonical_u64(),
                    witness[signal].as_canonical_u64()
                )));
            }
        } else {
            witness[signal] = expected[idx];
            set_known(known, signal);
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

#[cfg(test)]
mod tests {
    use std::sync::{Mutex, OnceLock};

    use fields::{Field, Goldilocks};

    use super::*;
    use crate::recursive_runtime::{
        NativeRecursiveRuntime, NativeRuntimeConstraint, NativeRuntimeLcTerm, NativeRuntimeSection,
        NativeRuntimeSectionCopyOp, GOLDILOCKS_P_MINUS_ONE,
    };

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
            source_alias_checks: Vec::new(),
            ignored_source_words: Vec::new(),
            constraints: Vec::new(),
            custom_gates: vec![NativeRuntimeCustomGate {
                kind: NativeRuntimeCustomGateKind::CMul,
                parameters: Vec::new(),
                signals: (1..=9).collect(),
            }],
            solver_index: OnceLock::new(),
            solve_plan: OnceLock::new(),
            solve_plan_build_lock: Mutex::new(()),
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
            source_alias_checks: Vec::new(),
            ignored_source_words: Vec::new(),
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
            solve_plan: OnceLock::new(),
            solve_plan_build_lock: Mutex::new(()),
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
            source_alias_checks: Vec::new(),
            ignored_source_words: Vec::new(),
            constraints: Vec::new(),
            custom_gates: vec![NativeRuntimeCustomGate {
                kind: NativeRuntimeCustomGateKind::EvPol4,
                parameters: Vec::new(),
                signals: (1..=21).collect(),
            }],
            solver_index: OnceLock::new(),
            solve_plan: OnceLock::new(),
            solve_plan_build_lock: Mutex::new(()),
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
            source_alias_checks: Vec::new(),
            ignored_source_words: Vec::new(),
            constraints: Vec::new(),
            custom_gates: vec![NativeRuntimeCustomGate {
                kind: NativeRuntimeCustomGateKind::TreeSelector4,
                parameters: Vec::new(),
                signals: (1..=17).collect(),
            }],
            solver_index: OnceLock::new(),
            solve_plan: OnceLock::new(),
            solve_plan_build_lock: Mutex::new(()),
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
            source_alias_checks: Vec::new(),
            ignored_source_words: Vec::new(),
            constraints: Vec::new(),
            custom_gates: vec![NativeRuntimeCustomGate {
                kind: NativeRuntimeCustomGateKind::SelectValue1,
                parameters: Vec::new(),
                signals: (1..=22).collect(),
            }],
            solver_index: OnceLock::new(),
            solve_plan: OnceLock::new(),
            solve_plan_build_lock: Mutex::new(()),
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
            source_alias_checks: Vec::new(),
            ignored_source_words: Vec::new(),
            constraints: Vec::new(),
            custom_gates: vec![NativeRuntimeCustomGate {
                kind: NativeRuntimeCustomGateKind::FFT4,
                parameters: vec![1, 1, 1, 2],
                signals: (1..=24).collect(),
            }],
            solver_index: OnceLock::new(),
            solve_plan: OnceLock::new(),
            solve_plan_build_lock: Mutex::new(()),
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
            source_alias_checks: Vec::new(),
            ignored_source_words: Vec::new(),
            constraints: Vec::new(),
            custom_gates: vec![NativeRuntimeCustomGate {
                kind: NativeRuntimeCustomGateKind::Poseidon16,
                parameters: Vec::new(),
                signals: (1..=224).collect(),
            }],
            solver_index: OnceLock::new(),
            solve_plan: OnceLock::new(),
            solve_plan_build_lock: Mutex::new(()),
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
            source_alias_checks: Vec::new(),
            ignored_source_words: Vec::new(),
            constraints: Vec::new(),
            custom_gates: vec![NativeRuntimeCustomGate {
                kind: NativeRuntimeCustomGateKind::CustPoseidon16,
                parameters: Vec::new(),
                signals: (1..=226).collect(),
            }],
            solver_index: OnceLock::new(),
            solve_plan: OnceLock::new(),
            solve_plan_build_lock: Mutex::new(()),
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
