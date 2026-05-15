use std::collections::BTreeMap;
use std::path::Path;

use anyhow::{bail, Result};

use crate::recursive_setup::r1cs::{
    write_r1cs, CustomGate, CustomGateUse, LinearCombination, R1cs, R1csConstraint, GOLDILOCKS_P,
};

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct Signal(pub u32);

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum SignalKind {
    Output,
    PublicInput,
    PrivateInput,
    Witness,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct CircuitBuilder {
    next_signal: u32,
    n_outputs: u32,
    n_pub_inputs: u32,
    n_prv_inputs: u32,
    constraints: Vec<R1csConstraint>,
    custom_gates: Vec<CustomGate>,
    custom_gate_ids: BTreeMap<(String, Vec<u64>), u32>,
    custom_gate_uses: Vec<CustomGateUse>,
    wire_map: Vec<u64>,
}

impl Default for CircuitBuilder {
    fn default() -> Self {
        Self::new()
    }
}

impl CircuitBuilder {
    pub fn new() -> Self {
        Self {
            next_signal: 1,
            n_outputs: 0,
            n_pub_inputs: 0,
            n_prv_inputs: 0,
            constraints: Vec::new(),
            custom_gates: Vec::new(),
            custom_gate_ids: BTreeMap::new(),
            custom_gate_uses: Vec::new(),
            wire_map: vec![0],
        }
    }

    pub fn one() -> Signal {
        Signal(0)
    }

    pub fn new_output(&mut self) -> Signal {
        self.new_signal(SignalKind::Output)
    }

    pub fn new_public_input(&mut self) -> Signal {
        self.new_signal(SignalKind::PublicInput)
    }

    pub fn new_private_input(&mut self) -> Signal {
        self.new_signal(SignalKind::PrivateInput)
    }

    pub fn new_witness(&mut self) -> Signal {
        self.new_signal(SignalKind::Witness)
    }

    pub fn add_constraint(
        &mut self,
        a: LinearCombination,
        b: LinearCombination,
        c: LinearCombination,
    ) {
        self.constraints.push(R1csConstraint { a: normalize(a), b: normalize(b), c: normalize(c) });
    }

    pub fn assert_zero(&mut self, value: LinearCombination) {
        self.add_constraint(value, lc_signal(Self::one()), LinearCombination::new());
    }

    pub fn assert_equal(&mut self, left: LinearCombination, right: LinearCombination) {
        self.assert_zero(lc_sub(left, right));
    }

    pub fn assign_linear(&mut self, value: LinearCombination) -> Signal {
        let out = self.new_witness();
        self.assert_equal(lc_signal(out), value);
        out
    }

    pub fn mul(&mut self, left: LinearCombination, right: LinearCombination) -> Signal {
        let out = self.new_witness();
        self.add_constraint(left, right, lc_signal(out));
        out
    }

    pub fn add_custom_gate(
        &mut self,
        template_name: impl Into<String>,
        parameters: Vec<u64>,
        signals: impl IntoIterator<Item = Signal>,
    ) -> Result<u32> {
        let template_name = template_name.into();
        let key = (template_name.clone(), parameters.clone());
        let id = if let Some(id) = self.custom_gate_ids.get(&key) {
            *id
        } else {
            let id = self.custom_gates.len() as u32;
            self.custom_gates.push(CustomGate { template_name, parameters });
            self.custom_gate_ids.insert(key, id);
            id
        };

        let signals = signals.into_iter().map(|signal| u64::from(signal.0)).collect::<Vec<_>>();
        if signals.is_empty() {
            bail!("custom gate use must contain at least one signal");
        }
        self.custom_gate_uses.push(CustomGateUse { id, signals });
        Ok(id)
    }

    pub fn into_r1cs(self) -> R1cs {
        let n_vars = self.next_signal;
        R1cs {
            n8: 8,
            prime: GOLDILOCKS_P,
            n_vars,
            n_outputs: self.n_outputs,
            n_pub_inputs: self.n_pub_inputs,
            n_prv_inputs: self.n_prv_inputs,
            n_labels: u64::from(n_vars),
            n_constraints: self.constraints.len() as u32,
            constraints: self.constraints,
            wire_map: self.wire_map,
            custom_gates: self.custom_gates,
            custom_gate_uses: self.custom_gate_uses,
        }
    }

    pub fn write_r1cs(self, path: &Path) -> Result<()> {
        write_r1cs(path, &self.into_r1cs())
    }

    fn new_signal(&mut self, kind: SignalKind) -> Signal {
        let signal = Signal(self.next_signal);
        self.next_signal += 1;
        self.wire_map.push(u64::from(signal.0));
        match kind {
            SignalKind::Output => self.n_outputs += 1,
            SignalKind::PublicInput => self.n_pub_inputs += 1,
            SignalKind::PrivateInput => self.n_prv_inputs += 1,
            SignalKind::Witness => {}
        }
        signal
    }
}

pub fn lc_const(value: u64) -> LinearCombination {
    if value == 0 {
        LinearCombination::new()
    } else {
        lc_term(CircuitBuilder::one(), value)
    }
}

pub fn lc_signal(signal: Signal) -> LinearCombination {
    lc_term(signal, 1)
}

pub fn lc_term(signal: Signal, coeff: u64) -> LinearCombination {
    let mut out = LinearCombination::new();
    let coeff = coeff % GOLDILOCKS_P;
    if coeff != 0 {
        out.insert(signal.0, coeff);
    }
    out
}

pub fn lc_add(mut left: LinearCombination, right: LinearCombination) -> LinearCombination {
    for (signal, coeff) in right {
        add_term(&mut left, signal, coeff);
    }
    normalize(left)
}

pub fn lc_sub(mut left: LinearCombination, right: LinearCombination) -> LinearCombination {
    for (signal, coeff) in right {
        add_term(&mut left, signal, mod_neg(coeff));
    }
    normalize(left)
}

pub fn lc_scale(value: LinearCombination, coeff: u64) -> LinearCombination {
    let coeff = coeff % GOLDILOCKS_P;
    if coeff == 0 {
        return LinearCombination::new();
    }
    value
        .into_iter()
        .filter_map(|(signal, value)| {
            let scaled = mod_mul(value, coeff);
            (scaled != 0).then_some((signal, scaled))
        })
        .collect()
}

fn add_term(lc: &mut LinearCombination, signal: u32, coeff: u64) {
    let next = mod_add(*lc.get(&signal).unwrap_or(&0), coeff);
    if next == 0 {
        lc.remove(&signal);
    } else {
        lc.insert(signal, next);
    }
}

fn normalize(mut lc: LinearCombination) -> LinearCombination {
    lc.retain(|_, coeff| *coeff != 0);
    lc
}

fn mod_add(left: u64, right: u64) -> u64 {
    ((u128::from(left) + u128::from(right)) % u128::from(GOLDILOCKS_P)) as u64
}

fn mod_neg(value: u64) -> u64 {
    let value = value % GOLDILOCKS_P;
    if value == 0 {
        0
    } else {
        GOLDILOCKS_P - value
    }
}

fn mod_mul(left: u64, right: u64) -> u64 {
    ((u128::from(left) * u128::from(right)) % u128::from(GOLDILOCKS_P)) as u64
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::recursive_setup::r1cs::read_r1cs;

    #[test]
    fn builds_basic_r1cs_with_custom_gate() -> Result<()> {
        let mut builder = CircuitBuilder::new();
        let out = builder.new_output();
        let x = builder.new_public_input();
        let y = builder.new_private_input();
        let product = builder.mul(lc_signal(x), lc_signal(y));
        builder.assert_equal(lc_signal(out), lc_signal(product));
        builder.add_custom_gate("CMul", Vec::new(), [x, y, product])?;

        let r1cs = builder.into_r1cs();
        assert_eq!(r1cs.n_vars, 5);
        assert_eq!(r1cs.n_outputs, 1);
        assert_eq!(r1cs.n_pub_inputs, 1);
        assert_eq!(r1cs.n_prv_inputs, 1);
        assert_eq!(r1cs.constraints.len(), 2);
        assert_eq!(r1cs.custom_gates[0].template_name, "CMul");
        assert_eq!(r1cs.custom_gate_uses[0].signals, vec![2, 3, 4]);
        Ok(())
    }

    #[test]
    fn writes_builder_r1cs_roundtrip() -> Result<()> {
        let dir = std::env::temp_dir()
            .join(format!("pk_setup_circuit_builder_test_{}", std::process::id()));
        std::fs::create_dir_all(&dir)?;
        let path = dir.join("builder.r1cs");

        let mut builder = CircuitBuilder::new();
        let out = builder.new_output();
        let x = builder.new_public_input();
        let value = builder.assign_linear(lc_add(lc_signal(x), lc_const(7)));
        builder.assert_equal(lc_signal(out), lc_signal(value));
        builder.write_r1cs(&path)?;

        let r1cs = read_r1cs(&path)?;
        assert_eq!(r1cs.n_outputs, 1);
        assert_eq!(r1cs.n_pub_inputs, 1);
        assert_eq!(r1cs.constraints.len(), 2);
        assert_eq!(r1cs.wire_map, vec![0, 1, 2, 3]);

        std::fs::remove_dir_all(&dir)?;
        Ok(())
    }
}
