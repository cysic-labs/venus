use std::collections::{BTreeMap, HashMap};

use anyhow::{bail, Result};

use crate::recursive_setup::r1cs::{CustomGateUse, LinearCombination, R1cs, GOLDILOCKS_P};

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PlonkProgram {
    pub constraints: Vec<PlonkConstraint>,
    pub additions: Vec<PlonkAddition>,
    pub n_vars: u32,
    pub custom_gates_info: CustomGatesInfo,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PlonkConstraint {
    pub sl: u32,
    pub sr: u32,
    pub so: u32,
    pub qm: u64,
    pub ql: u64,
    pub qr: u64,
    pub qo: u64,
    pub qc: u64,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PlonkAddition {
    pub sl: u32,
    pub sr: u32,
    pub ql: u64,
    pub qr: u64,
}

#[derive(Debug, Default, Clone, PartialEq, Eq)]
pub struct CustomGatesInfo {
    pub cmul_id: Option<usize>,
    pub poseidon12_id: Option<usize>,
    pub cust_poseidon12_id: Option<usize>,
    pub ev_pol4_id: Option<usize>,
    pub tree_selector4_id: Option<usize>,
    pub select_val1_id: Option<usize>,
    pub fft4_parameters: HashMap<usize, Vec<u64>>,
    pub n_cmul: usize,
    pub n_poseidon12: usize,
    pub n_cust_poseidon12: usize,
    pub n_fft4: usize,
    pub n_ev_pol4: usize,
    pub n_tree_selector4: usize,
    pub n_select_val1: usize,
    pub n_plonk_rows: usize,
}

pub fn r1cs_to_plonk(r1cs: &R1cs) -> Result<PlonkProgram> {
    let mut converter =
        Converter { constraints: Vec::new(), additions: Vec::new(), next_var: r1cs.n_vars };

    for constraint in &r1cs.constraints {
        converter.process(constraint.a.clone(), constraint.b.clone(), constraint.c.clone())?;
    }

    Ok(PlonkProgram {
        constraints: converter.constraints,
        additions: converter.additions,
        n_vars: converter.next_var,
        custom_gates_info: get_custom_gates_info(r1cs)?,
    })
}

pub fn write_exec_buffer(additions: &[PlonkAddition], signal_map: &[Vec<u32>]) -> Result<Vec<u8>> {
    if signal_map.is_empty() {
        bail!("cannot write exec file for empty signal map");
    }
    let n_rows = signal_map[0].len();
    if signal_map.iter().any(|col| col.len() != n_rows) {
        bail!("all signal-map columns must have the same row count");
    }

    let n_words = 2 + additions.len() * 4 + signal_map.len() * n_rows;
    let mut out = Vec::with_capacity(n_words * 8);
    push_u64(&mut out, additions.len() as u64);
    push_u64(&mut out, n_rows as u64);

    for addition in additions {
        push_u64(&mut out, addition.sl as u64);
        push_u64(&mut out, addition.sr as u64);
        push_u64(&mut out, addition.ql);
        push_u64(&mut out, addition.qr);
    }

    for row in 0..n_rows {
        for col in signal_map {
            push_u64(&mut out, col[row] as u64);
        }
    }

    Ok(out)
}

struct Converter {
    constraints: Vec<PlonkConstraint>,
    additions: Vec<PlonkAddition>,
    next_var: u32,
}

impl Converter {
    fn process(
        &mut self,
        mut a: LinearCombination,
        mut b: LinearCombination,
        mut c: LinearCombination,
    ) -> Result<()> {
        let a_type = lc_type(&mut a);
        let b_type = lc_type(&mut b);
        if a_type == LcType::Zero || b_type == LcType::Zero {
            normalize(&mut c);
            self.add_constraint_sum(&c)?;
        } else if let LcType::Constant(k) = a_type {
            let joined = join(&b, k, &c);
            self.add_constraint_sum(&joined)?;
        } else if let LcType::Constant(k) = b_type {
            let joined = join(&a, k, &c);
            self.add_constraint_sum(&joined)?;
        } else {
            self.add_constraint_mul(&a, &b, &c)?;
        }
        Ok(())
    }

    fn add_constraint_sum(&mut self, lc: &LinearCombination) -> Result<()> {
        let reduced = self.reduce_coefs(lc, 3)?;
        self.constraints.push(PlonkConstraint {
            sl: reduced.signals[0],
            sr: reduced.signals[1],
            so: reduced.signals[2],
            qm: 0,
            ql: reduced.coefs[0],
            qr: reduced.coefs[1],
            qo: reduced.coefs[2],
            qc: reduced.constant,
        });
        Ok(())
    }

    fn add_constraint_mul(
        &mut self,
        a_lc: &LinearCombination,
        b_lc: &LinearCombination,
        c_lc: &LinearCombination,
    ) -> Result<()> {
        let a = self.reduce_coefs(a_lc, 1)?;
        let b = self.reduce_coefs(b_lc, 1)?;
        let c = self.reduce_coefs(c_lc, 1)?;

        let qm = mul_mod(a.coefs[0], b.coefs[0]);
        let ql = mul_mod(a.coefs[0], b.constant);
        let qr = mul_mod(a.constant, b.coefs[0]);
        let qo = neg_mod(c.coefs[0]);
        let qc = sub_mod(mul_mod(a.constant, b.constant), c.constant);

        self.constraints.push(PlonkConstraint {
            sl: a.signals[0],
            sr: b.signals[0],
            so: c.signals[0],
            qm,
            ql,
            qr,
            qo,
            qc,
        });
        Ok(())
    }

    fn reduce_coefs(&mut self, lc: &LinearCombination, max_coefs: usize) -> Result<ReducedCoefs> {
        let mut constant = 0;
        let mut coefs = Vec::new();
        for (&signal, &value) in lc {
            if signal == 0 {
                constant = add_mod(constant, value);
            } else if value != 0 {
                coefs.push((signal, value));
            }
        }

        while coefs.len() > max_coefs {
            let (sl, ql) = coefs.remove(0);
            let (sr, qr) = coefs.remove(0);
            let so = self.next_var;
            self.next_var = self
                .next_var
                .checked_add(1)
                .ok_or_else(|| anyhow::anyhow!("PLONK variable id overflow"))?;

            self.constraints.push(PlonkConstraint {
                sl,
                sr,
                so,
                qm: 0,
                ql: neg_mod(ql),
                qr: neg_mod(qr),
                qo: 1,
                qc: 0,
            });
            self.additions.push(PlonkAddition { sl, sr, ql, qr });
            coefs.push((so, 1));
        }

        let mut signals = Vec::with_capacity(max_coefs);
        let mut reduced_coefs = Vec::with_capacity(max_coefs);
        for (signal, value) in coefs {
            signals.push(signal);
            reduced_coefs.push(value);
        }
        while signals.len() < max_coefs {
            signals.push(0);
            reduced_coefs.push(0);
        }

        Ok(ReducedCoefs { constant, signals, coefs: reduced_coefs })
    }
}

#[derive(Debug)]
struct ReducedCoefs {
    constant: u64,
    signals: Vec<u32>,
    coefs: Vec<u64>,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum LcType {
    Zero,
    Constant(u64),
    Signals,
}

fn lc_type(lc: &mut LinearCombination) -> LcType {
    normalize(lc);
    let constant = lc.get(&0).copied().unwrap_or(0);
    let n_signals = lc.keys().filter(|&&signal| signal != 0).count();
    if n_signals > 0 {
        LcType::Signals
    } else if constant != 0 {
        LcType::Constant(constant)
    } else {
        LcType::Zero
    }
}

fn join(lc1: &LinearCombination, k: u64, lc2: &LinearCombination) -> LinearCombination {
    let mut out = BTreeMap::new();
    for (&signal, &value) in lc1 {
        out.insert(signal, mul_mod(k, value));
    }
    for (&signal, &value) in lc2 {
        let entry = out.entry(signal).or_insert(0);
        *entry = sub_mod(*entry, value);
    }
    normalize(&mut out);
    out
}

fn normalize(lc: &mut LinearCombination) {
    lc.retain(|_, value| *value != 0);
}

pub fn get_custom_gates_info(r1cs: &R1cs) -> Result<CustomGatesInfo> {
    let mut info = CustomGatesInfo::default();
    for (id, gate) in r1cs.custom_gates.iter().enumerate() {
        match gate.template_name.as_str() {
            "CMul" => {
                ensure_no_parameters(&gate.parameters, &gate.template_name)?;
                info.cmul_id = Some(id);
            }
            "Poseidon16" => info.poseidon12_id = Some(id),
            "CustPoseidon16" => info.cust_poseidon12_id = Some(id),
            "EvPol4" => {
                ensure_no_parameters(&gate.parameters, &gate.template_name)?;
                info.ev_pol4_id = Some(id);
            }
            "TreeSelector4" => {
                ensure_no_parameters(&gate.parameters, &gate.template_name)?;
                info.tree_selector4_id = Some(id);
            }
            "SelectValue1" => {
                ensure_no_parameters(&gate.parameters, &gate.template_name)?;
                info.select_val1_id = Some(id);
            }
            "FFT4" => {
                if gate.parameters.len() != 4 {
                    bail!("FFT4 custom gate must have 4 parameters");
                }
                info.fft4_parameters.insert(id, gate.parameters.clone());
            }
            other => bail!("invalid custom gate template {other}"),
        }
    }

    for gate_use in &r1cs.custom_gate_uses {
        count_gate_use(&mut info, gate_use)?;
    }

    Ok(info)
}

fn count_gate_use(info: &mut CustomGatesInfo, gate_use: &CustomGateUse) -> Result<()> {
    let id = gate_use.id as usize;
    if Some(id) == info.cmul_id {
        info.n_cmul += 1;
    } else if Some(id) == info.poseidon12_id {
        info.n_poseidon12 += 1;
    } else if Some(id) == info.cust_poseidon12_id {
        info.n_cust_poseidon12 += 1;
    } else if info.fft4_parameters.contains_key(&id) {
        info.n_fft4 += 1;
    } else if Some(id) == info.ev_pol4_id {
        info.n_ev_pol4 += 1;
    } else if Some(id) == info.tree_selector4_id {
        info.n_tree_selector4 += 1;
    } else if Some(id) == info.select_val1_id {
        info.n_select_val1 += 1;
    } else {
        bail!("custom gate use references undefined gate id {id}");
    }
    Ok(())
}

fn ensure_no_parameters(parameters: &[u64], name: &str) -> Result<()> {
    if !parameters.is_empty() {
        bail!("{name} custom gate must not have parameters");
    }
    Ok(())
}

fn push_u64(out: &mut Vec<u8>, value: u64) {
    out.extend_from_slice(&value.to_le_bytes());
}

fn add_mod(lhs: u64, rhs: u64) -> u64 {
    ((lhs as u128 + rhs as u128) % GOLDILOCKS_P as u128) as u64
}

fn sub_mod(lhs: u64, rhs: u64) -> u64 {
    ((lhs as u128 + GOLDILOCKS_P as u128 - rhs as u128) % GOLDILOCKS_P as u128) as u64
}

fn neg_mod(value: u64) -> u64 {
    if value == 0 {
        0
    } else {
        GOLDILOCKS_P - value
    }
}

fn mul_mod(lhs: u64, rhs: u64) -> u64 {
    ((lhs as u128 * rhs as u128) % GOLDILOCKS_P as u128) as u64
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::recursive_setup::r1cs::{CustomGate, CustomGateUse, R1csConstraint};

    #[test]
    fn converts_sum_and_mul_constraints_like_js_r1cs2plonk() -> Result<()> {
        let mut constraints = Vec::new();
        constraints.push(R1csConstraint {
            a: lc(&[]),
            b: lc(&[(1, 1)]),
            c: lc(&[(1, 3), (2, 5), (3, 7), (4, 11), (0, 13)]),
        });
        constraints.push(R1csConstraint {
            a: lc(&[(1, 2), (0, 3)]),
            b: lc(&[(2, 5), (0, 7)]),
            c: lc(&[(3, 11), (0, 13)]),
        });
        let r1cs = R1cs {
            n8: 8,
            prime: GOLDILOCKS_P,
            n_vars: 5,
            n_outputs: 0,
            n_pub_inputs: 0,
            n_prv_inputs: 0,
            n_labels: 0,
            n_constraints: constraints.len() as u32,
            constraints,
            wire_map: Vec::new(),
            custom_gates: vec![CustomGate {
                template_name: "CMul".to_string(),
                parameters: vec![],
            }],
            custom_gate_uses: vec![CustomGateUse { id: 0, signals: vec![1, 2, 3] }],
        };

        let plonk = r1cs_to_plonk(&r1cs)?;
        assert_eq!(plonk.additions, vec![PlonkAddition { sl: 1, sr: 2, ql: 3, qr: 5 }]);
        assert_eq!(
            plonk.constraints[0],
            PlonkConstraint {
                sl: 1,
                sr: 2,
                so: 5,
                qm: 0,
                ql: neg_mod(3),
                qr: neg_mod(5),
                qo: 1,
                qc: 0,
            }
        );
        assert_eq!(
            plonk.constraints[1],
            PlonkConstraint { sl: 3, sr: 4, so: 5, qm: 0, ql: 7, qr: 11, qo: 1, qc: 13 }
        );
        assert_eq!(
            plonk.constraints[2],
            PlonkConstraint { sl: 1, sr: 2, so: 3, qm: 10, ql: 14, qr: 15, qo: neg_mod(11), qc: 8 }
        );
        assert_eq!(plonk.n_vars, 6);
        assert_eq!(plonk.custom_gates_info.n_cmul, 1);
        Ok(())
    }

    #[test]
    fn writes_exec_buffer_in_row_major_signal_map_order() -> Result<()> {
        let exec = write_exec_buffer(
            &[PlonkAddition { sl: 1, sr: 2, ql: 3, qr: 4 }],
            &[vec![10, 11], vec![20, 21], vec![30, 31]],
        )?;
        let words = exec
            .chunks_exact(8)
            .map(|chunk| u64::from_le_bytes(chunk.try_into().unwrap()))
            .collect::<Vec<_>>();
        assert_eq!(words, vec![1, 2, 1, 2, 3, 4, 10, 20, 30, 11, 21, 31]);
        Ok(())
    }

    fn lc(values: &[(u32, u64)]) -> LinearCombination {
        values.iter().copied().collect()
    }
}
