use anyhow::Result;

use crate::recursive_setup::circuit::{CircuitBuilder, Signal};

pub fn cmul(builder: &mut CircuitBuilder, a: [Signal; 3], b: [Signal; 3]) -> Result<[Signal; 3]> {
    let out = alloc_array::<3>(builder);
    let mut signals = Vec::with_capacity(9);
    signals.extend(a);
    signals.extend(b);
    signals.extend(out);
    builder.add_custom_gate("CMul", Vec::new(), signals)?;
    Ok(out)
}

pub fn evpol4(
    builder: &mut CircuitBuilder,
    coefs: [[Signal; 3]; 5],
    x: [Signal; 3],
) -> Result<[Signal; 3]> {
    let out = alloc_array::<3>(builder);
    let mut signals = Vec::with_capacity(21);
    for coef in coefs {
        signals.extend(coef);
    }
    signals.extend(x);
    signals.extend(out);
    builder.add_custom_gate("EvPol4", Vec::new(), signals)?;
    Ok(out)
}

pub fn fft4(
    builder: &mut CircuitBuilder,
    input: [[Signal; 3]; 4],
    first_w: u64,
    inc_w: u64,
    scale: u64,
    fft_type: u64,
) -> Result<[[Signal; 3]; 4]> {
    let out = alloc_matrix::<4, 3>(builder);
    let mut signals = Vec::with_capacity(24);
    for row in input {
        signals.extend(row);
    }
    for row in out {
        signals.extend(row);
    }
    builder.add_custom_gate("FFT4", vec![first_w, inc_w, scale, fft_type], signals)?;
    Ok(out)
}

pub fn tree_selector4(
    builder: &mut CircuitBuilder,
    values: [[Signal; 3]; 4],
    key: [Signal; 2],
) -> Result<[Signal; 3]> {
    let out = alloc_array::<3>(builder);
    let mut signals = Vec::with_capacity(17);
    for value in values {
        signals.extend(value);
    }
    signals.extend(key);
    signals.extend(out);
    builder.add_custom_gate("TreeSelector4", Vec::new(), signals)?;
    Ok(out)
}

pub fn select_value1(
    builder: &mut CircuitBuilder,
    values: [[Signal; 4]; 4],
    key: [Signal; 2],
) -> Result<[Signal; 4]> {
    let out = alloc_array::<4>(builder);
    let mut signals = Vec::with_capacity(22);
    for value in values {
        signals.extend(value);
    }
    signals.extend(key);
    signals.extend(out);
    builder.add_custom_gate("SelectValue1", Vec::new(), signals)?;
    Ok(out)
}

pub fn poseidon16(builder: &mut CircuitBuilder, input: [Signal; 16]) -> Result<[Signal; 16]> {
    let im = alloc_matrix::<12, 16>(builder);
    let out = alloc_array::<16>(builder);
    let mut signals = Vec::with_capacity(224);
    signals.extend(input);
    for row in im {
        signals.extend(row);
    }
    signals.extend(out);
    builder.add_custom_gate("Poseidon16", Vec::new(), signals)?;
    Ok(out)
}

pub fn cust_poseidon16(
    builder: &mut CircuitBuilder,
    input: [Signal; 16],
    key: [Signal; 2],
) -> Result<[Signal; 16]> {
    let im = alloc_matrix::<12, 16>(builder);
    let out = alloc_array::<16>(builder);
    let mut signals = Vec::with_capacity(226);
    signals.extend(input);
    signals.extend(key);
    for row in im {
        signals.extend(row);
    }
    signals.extend(out);
    builder.add_custom_gate("CustPoseidon16", Vec::new(), signals)?;
    Ok(out)
}

fn alloc_array<const N: usize>(builder: &mut CircuitBuilder) -> [Signal; N] {
    std::array::from_fn(|_| builder.new_witness())
}

fn alloc_matrix<const R: usize, const C: usize>(builder: &mut CircuitBuilder) -> [[Signal; C]; R] {
    std::array::from_fn(|_| alloc_array::<C>(builder))
}

#[cfg(test)]
mod tests {
    use anyhow::Result;

    use super::*;

    #[test]
    fn registers_poseidon_gate_signal_order() -> Result<()> {
        let mut builder = CircuitBuilder::new();
        let input = std::array::from_fn(|_| builder.new_public_input());
        let out = poseidon16(&mut builder, input)?;
        let r1cs = builder.into_r1cs();

        assert_eq!(r1cs.custom_gates[0].template_name, "Poseidon16");
        assert_eq!(r1cs.custom_gate_uses[0].signals.len(), 224);
        assert_eq!(&r1cs.custom_gate_uses[0].signals[..16], &(1u64..=16).collect::<Vec<_>>());
        assert_eq!(
            &r1cs.custom_gate_uses[0].signals[208..224],
            &out.map(|signal| u64::from(signal.0))
        );
        Ok(())
    }

    #[test]
    fn deduplicates_fft_gate_definitions_by_parameters() -> Result<()> {
        let mut builder = CircuitBuilder::new();
        let input = std::array::from_fn(|_| std::array::from_fn(|_| builder.new_public_input()));
        let _ = fft4(&mut builder, input, 1, 2, 3, 4)?;
        let input = std::array::from_fn(|_| std::array::from_fn(|_| builder.new_public_input()));
        let _ = fft4(&mut builder, input, 1, 2, 3, 4)?;
        let input = std::array::from_fn(|_| std::array::from_fn(|_| builder.new_public_input()));
        let _ = fft4(&mut builder, input, 5, 6, 7, 2)?;

        let r1cs = builder.into_r1cs();
        assert_eq!(r1cs.custom_gates.len(), 2);
        assert_eq!(r1cs.custom_gate_uses.len(), 3);
        assert_eq!(r1cs.custom_gate_uses[0].id, r1cs.custom_gate_uses[1].id);
        assert_ne!(r1cs.custom_gate_uses[1].id, r1cs.custom_gate_uses[2].id);
        Ok(())
    }
}
