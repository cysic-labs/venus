//! Convert R1CS constraints (A*B=C) to PLONK gate format.
//!
//! Each PLONK constraint is `[sl, sr, so, qM, qL, qR, qO, qC]` representing:
//!   qM*sl*sr + qL*sl + qR*sr + qO*so + qC = 0
//!
//! Each PLONK addition is `[sl, sr, coef_l, coef_r]` recording that a new
//! variable was introduced equal to `coef_l*sl + coef_r*sr`.
//!
//! Ported from `stark-recurser/src/circom2pil/r1cs2plonk.js`.

use std::collections::HashMap;

use super::r1cs_reader::{CustomGateUse, R1csFile};

/// Goldilocks prime p = 2^64 - 2^32 + 1.
pub const GOLDILOCKS_P: u64 = 0xFFFF_FFFF_0000_0001;

/// A PLONK constraint: [sl, sr, so, qM, qL, qR, qO, qC].
pub type PlonkConstraint = [u64; 8];

/// A PLONK addition: [sl, sr, coef_l, coef_r].
pub type PlonkAddition = [u64; 4];

/// Field modular reduction for u128 values.
#[inline]
fn modp(v: u128) -> u64 {
    (v % GOLDILOCKS_P as u128) as u64
}

/// Field negation: (P - v) mod P.
#[inline]
fn neg(v: u64) -> u64 {
    modp(GOLDILOCKS_P as u128 - v as u128 + GOLDILOCKS_P as u128)
}

/// Field multiplication: (a * b) mod P.
#[inline]
fn mulp(a: u64, b: u64) -> u64 {
    modp(a as u128 * b as u128)
}

/// Field addition: (a + b) mod P.
#[inline]
fn addp(a: u64, b: u64) -> u64 {
    modp(a as u128 + b as u128)
}

/// A linear combination represented as wire_index -> coefficient.
type LC = HashMap<u32, u64>;

/// Compute `k * lc1 - lc2`, producing a new linear combination.
fn join(lc1: &LC, k: u64, lc2: &LC) -> LC {
    let mut res: LC = HashMap::new();

    for (&s, &coeff) in lc1 {
        let val = mulp(k, coeff);
        let entry = res.entry(s).or_insert(0);
        *entry = addp(*entry, val);
    }

    for (&s, &coeff) in lc2 {
        let val = neg(coeff);
        let entry = res.entry(s).or_insert(0);
        *entry = addp(*entry, val);
    }

    normalize(&mut res);
    res
}

/// Remove zero-coefficient entries from a linear combination.
fn normalize(lc: &mut LC) {
    lc.retain(|_, v| *v != 0);
}

/// Result of reducing a linear combination to at most `max_c` non-constant terms.
struct ReducedCoefs {
    k: u64,
    s: Vec<u32>,
    coefs: Vec<u64>,
}

/// Reduce a linear combination to at most `max_c` variables by introducing
/// addition gates for excess terms.
fn reduce_coefs(
    lc: &LC,
    max_c: usize,
    plonk_n_vars: &mut u32,
    plonk_constraints: &mut Vec<PlonkConstraint>,
    plonk_additions: &mut Vec<PlonkAddition>,
) -> ReducedCoefs {
    let mut result_k: u64 = 0;
    let mut cs: Vec<(u32, u64)> = Vec::new();

    for (&s, &coeff) in lc {
        if s == 0 {
            result_k = addp(result_k, coeff);
        } else if coeff != 0 {
            cs.push((s, coeff));
        }
    }

    // Combine excess terms by introducing new variables
    while cs.len() > max_c {
        let c1 = cs.remove(0);
        let c2 = cs.remove(0);

        let sl = c1.0;
        let sr = c2.0;
        let so = *plonk_n_vars;
        *plonk_n_vars += 1;

        let qm: u64 = 0;
        let ql = neg(c1.1);
        let qr = neg(c2.1);
        let qo: u64 = 1;
        let qc: u64 = 0;

        plonk_constraints.push([
            sl as u64, sr as u64, so as u64, qm, ql, qr, qo, qc,
        ]);
        plonk_additions.push([sl as u64, sr as u64, c1.1, c2.1]);
        cs.push((so, 1));
    }

    let mut s_vec = Vec::with_capacity(max_c);
    let mut coefs_vec = Vec::with_capacity(max_c);
    for &(s, c) in &cs {
        s_vec.push(s);
        coefs_vec.push(c);
    }
    // Pad to max_c
    while s_vec.len() < max_c {
        s_vec.push(0);
        coefs_vec.push(0);
    }

    ReducedCoefs {
        k: result_k,
        s: s_vec,
        coefs: coefs_vec,
    }
}

/// Classify a linear combination: "0" (zero), "k" (constant only), or a count string.
fn get_lc_type(lc: &mut LC) -> String {
    let mut k: u64 = 0;
    let mut n: usize = 0;

    // Normalize and classify
    let keys: Vec<u32> = lc.keys().copied().collect();
    for s in keys {
        let coeff = *lc.get(&s).unwrap();
        if coeff == 0 {
            lc.remove(&s);
        } else if s == 0 {
            k = addp(k, coeff);
        } else {
            n += 1;
        }
    }

    if n > 0 {
        return n.to_string();
    }
    if k != 0 {
        return "k".to_string();
    }
    "0".to_string()
}

/// Convert R1CS constraints to PLONK format.
///
/// Returns `(plonk_constraints, plonk_additions)`.
pub fn r1cs2plonk(r1cs: &R1csFile) -> (Vec<PlonkConstraint>, Vec<PlonkAddition>) {
    let mut plonk_constraints: Vec<PlonkConstraint> = Vec::new();
    let mut plonk_additions: Vec<PlonkAddition> = Vec::new();
    let mut plonk_n_vars = r1cs.header.n_vars;

    for (c_idx, constraint) in r1cs.constraints.iter().enumerate() {
        if c_idx % 100_000 == 0 {
            tracing::debug!(
                "Processing constraints: {}/{}",
                c_idx,
                r1cs.header.n_constraints
            );
        }

        let mut lc_a: LC = constraint
            .a
            .iter()
            .map(|(&k, &v)| (k, v))
            .collect();
        let mut lc_b: LC = constraint
            .b
            .iter()
            .map(|(&k, &v)| (k, v))
            .collect();
        let mut lc_c: LC = constraint
            .c
            .iter()
            .map(|(&k, &v)| (k, v))
            .collect();

        let lct_a = get_lc_type(&mut lc_a);
        let lct_b = get_lc_type(&mut lc_b);

        if lct_a == "0" || lct_b == "0" {
            // A or B is zero => constraint becomes just C = 0
            normalize(&mut lc_c);
            add_constraint_sum(
                &lc_c,
                &mut plonk_n_vars,
                &mut plonk_constraints,
                &mut plonk_additions,
            );
        } else if lct_a == "k" {
            // A is a constant => constraint becomes B * k_A - C = 0
            let k_a = lc_a.get(&0).copied().unwrap_or(0);
            let lc_cc = join(&lc_b, k_a, &lc_c);
            add_constraint_sum(
                &lc_cc,
                &mut plonk_n_vars,
                &mut plonk_constraints,
                &mut plonk_additions,
            );
        } else if lct_b == "k" {
            // B is a constant => constraint becomes A * k_B - C = 0
            let k_b = lc_b.get(&0).copied().unwrap_or(0);
            let lc_cc = join(&lc_a, k_b, &lc_c);
            add_constraint_sum(
                &lc_cc,
                &mut plonk_n_vars,
                &mut plonk_constraints,
                &mut plonk_additions,
            );
        } else {
            // General multiplication constraint
            add_constraint_mul(
                &lc_a,
                &lc_b,
                &lc_c,
                &mut plonk_n_vars,
                &mut plonk_constraints,
                &mut plonk_additions,
            );
        }
    }

    (plonk_constraints, plonk_additions)
}

/// Add a sum constraint from a linear combination (no multiplication).
fn add_constraint_sum(
    lc: &LC,
    plonk_n_vars: &mut u32,
    plonk_constraints: &mut Vec<PlonkConstraint>,
    plonk_additions: &mut Vec<PlonkAddition>,
) {
    let c = reduce_coefs(lc, 3, plonk_n_vars, plonk_constraints, plonk_additions);
    let sl = c.s[0] as u64;
    let sr = c.s[1] as u64;
    let so = c.s[2] as u64;
    let qm: u64 = 0;
    let ql = c.coefs[0];
    let qr = c.coefs[1];
    let qo = c.coefs[2];
    let qc = c.k;
    plonk_constraints.push([sl, sr, so, qm, ql, qr, qo, qc]);
}

/// Add a multiplication constraint: A * B = C.
fn add_constraint_mul(
    lc_a: &LC,
    lc_b: &LC,
    lc_c: &LC,
    plonk_n_vars: &mut u32,
    plonk_constraints: &mut Vec<PlonkConstraint>,
    plonk_additions: &mut Vec<PlonkAddition>,
) {
    let a = reduce_coefs(lc_a, 1, plonk_n_vars, plonk_constraints, plonk_additions);
    let b = reduce_coefs(lc_b, 1, plonk_n_vars, plonk_constraints, plonk_additions);
    let c = reduce_coefs(lc_c, 1, plonk_n_vars, plonk_constraints, plonk_additions);

    let sl = a.s[0] as u64;
    let sr = b.s[0] as u64;
    let so = c.s[0] as u64;
    let qm = mulp(a.coefs[0], b.coefs[0]);
    let ql = mulp(a.coefs[0], b.k);
    let qr = mulp(a.k, b.coefs[0]);
    let qo = neg(c.coefs[0]);
    // qc = (A.k * B.k - C.k + P) mod P
    let qc = addp(mulp(a.k, b.k), neg(c.k));
    plonk_constraints.push([sl, sr, so, qm, ql, qr, qo, qc]);
}

/// Information about custom gates present in the R1CS file.
#[derive(Debug, Clone, Default)]
pub struct CustomGatesInfo {
    pub poseidon12_id: u32,
    pub cust_poseidon12_id: u32,
    pub cmul_add_id: u32,
    pub cmul_id: u32,
    pub fft4_parameters: HashMap<u32, Vec<u64>>,
    pub ev_pol4_id: u32,
    pub tree_selector4_id: u32,
    pub select_val1_id: u32,
    pub n_cmul_add: usize,
    pub n_cmul: usize,
    pub n_poseidon12: usize,
    pub n_cust_poseidon12: usize,
    pub n_fft4: usize,
    pub n_ev_pol4: usize,
    pub n_tree_selector4: usize,
    pub n_select_val1: usize,
    /// Number of PLONK-only rows needed (set by constraint calculation).
    pub n_plonk_rows: usize,
}

/// Extract custom gate info from the R1CS file.
pub fn get_custom_gates_info(r1cs: &R1csFile) -> CustomGatesInfo {
    let mut info = CustomGatesInfo::default();

    // Identify custom gate types by template name
    for (i, gate) in r1cs.custom_gates.iter().enumerate() {
        let i = i as u32;
        match gate.template_name.as_str() {
            "CMul" => {
                info.cmul_id = i;
                assert!(
                    gate.parameters.is_empty(),
                    "CMul gate should have no parameters"
                );
            }
            "Poseidon16" => {
                info.poseidon12_id = i;
            }
            "CustPoseidon16" => {
                info.cust_poseidon12_id = i;
            }
            "EvPol4" => {
                info.ev_pol4_id = i;
                assert!(
                    gate.parameters.is_empty(),
                    "EvPol4 gate should have no parameters"
                );
            }
            "TreeSelector4" => {
                info.tree_selector4_id = i;
                assert!(
                    gate.parameters.is_empty(),
                    "TreeSelector4 gate should have no parameters"
                );
            }
            "SelectValue1" => {
                info.select_val1_id = i;
                assert!(
                    gate.parameters.is_empty(),
                    "SelectValue1 gate should have no parameters"
                );
            }
            "FFT4" => {
                info.fft4_parameters
                    .insert(i, gate.parameters.clone());
            }
            other => {
                panic!("Invalid custom gate: {}", other);
            }
        }
    }

    // Count usage of each custom gate type
    for cgu in &r1cs.custom_gates_uses {
        if cgu.id == info.cmul_id {
            info.n_cmul += 1;
        } else if cgu.id == info.poseidon12_id {
            info.n_poseidon12 += 1;
        } else if cgu.id == info.cust_poseidon12_id {
            info.n_cust_poseidon12 += 1;
        } else if info.fft4_parameters.contains_key(&cgu.id) {
            info.n_fft4 += 1;
        } else if cgu.id == info.ev_pol4_id {
            info.n_ev_pol4 += 1;
        } else if cgu.id == info.tree_selector4_id {
            info.n_tree_selector4 += 1;
        } else if cgu.id == info.select_val1_id {
            info.n_select_val1 += 1;
        } else {
            panic!("Custom gate not defined: {}", cgu.id);
        }
    }

    info
}

/// Filter custom gate uses by gate id.
pub fn filter_gate_uses<'a>(
    uses: &'a [CustomGateUse],
    id: u32,
) -> Vec<&'a CustomGateUse> {
    uses.iter().filter(|cgu| cgu.id == id).collect()
}

/// Filter FFT4 gate uses (matching any FFT4 parameter set).
pub fn filter_fft4_gate_uses<'a>(
    uses: &'a [CustomGateUse],
    fft4_params: &HashMap<u32, Vec<u64>>,
) -> Vec<&'a CustomGateUse> {
    uses.iter()
        .filter(|cgu| fft4_params.contains_key(&cgu.id))
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::plonk2pil::r1cs_reader::*;
    use std::collections::HashMap;

    fn make_lc(terms: &[(u32, u64)]) -> LinearCombination {
        terms.iter().copied().collect()
    }

    fn make_r1cs(constraints: Vec<R1csConstraint>, n_vars: u32) -> R1csFile {
        R1csFile {
            header: R1csHeader {
                n8: 8,
                prime_bytes: 0xFFFF_FFFF_0000_0001u64.to_le_bytes().to_vec(),
                n_vars,
                n_outputs: 0,
                n_pub_inputs: 0,
                n_prv_inputs: 0,
                n_labels: 0,
                n_constraints: constraints.len() as u32,
                use_custom_gates: false,
            },
            constraints,
            wire_to_label: Vec::new(),
            custom_gates: Vec::new(),
            custom_gates_uses: Vec::new(),
        }
    }

    #[test]
    fn test_simple_mul_constraint() {
        // wire_1 * wire_2 = wire_3
        let constraint = R1csConstraint {
            a: make_lc(&[(1, 1)]),
            b: make_lc(&[(2, 1)]),
            c: make_lc(&[(3, 1)]),
        };
        let r1cs = make_r1cs(vec![constraint], 4);
        let (constraints, additions) = r1cs2plonk(&r1cs);

        assert_eq!(constraints.len(), 1);
        assert_eq!(additions.len(), 0);

        let c = &constraints[0];
        // sl=1, sr=2, so=3, qM=1, qL=0, qR=0, qO=P-1, qC=0
        assert_eq!(c[0], 1); // sl
        assert_eq!(c[1], 2); // sr
        assert_eq!(c[2], 3); // so
        assert_eq!(c[3], 1); // qM = 1*1
        assert_eq!(c[4], 0); // qL = 1*0
        assert_eq!(c[5], 0); // qR = 0*1
        assert_eq!(c[6], GOLDILOCKS_P - 1); // qO = -1
        assert_eq!(c[7], 0); // qC = 0*0 - 0
    }

    #[test]
    fn test_zero_a_becomes_sum() {
        // 0 * wire_1 = wire_2 + wire_3
        // A is zero, so C is added as a sum constraint
        let constraint = R1csConstraint {
            a: HashMap::new(),
            b: make_lc(&[(1, 1)]),
            c: make_lc(&[(2, 1), (3, 1)]),
        };
        let r1cs = make_r1cs(vec![constraint], 4);
        let (constraints, additions) = r1cs2plonk(&r1cs);

        assert_eq!(constraints.len(), 1);
        assert_eq!(additions.len(), 0);
        // qM should be 0 (sum constraint)
        assert_eq!(constraints[0][3], 0);
    }

    #[test]
    fn test_constant_a_becomes_sum() {
        // 5 * wire_1 = wire_2
        // A = constant 5, so this becomes 5*wire_1 - wire_2 = 0
        let constraint = R1csConstraint {
            a: make_lc(&[(0, 5)]),
            b: make_lc(&[(1, 1)]),
            c: make_lc(&[(2, 1)]),
        };
        let r1cs = make_r1cs(vec![constraint], 3);
        let (constraints, additions) = r1cs2plonk(&r1cs);

        assert_eq!(constraints.len(), 1);
        assert_eq!(additions.len(), 0);
        // qM should be 0 (sum constraint from join)
        assert_eq!(constraints[0][3], 0);
    }

    #[test]
    fn test_additions_generated_for_many_terms() {
        // A has 4 terms: wire_1 + wire_2 + wire_3 + wire_4
        // Reducing to 1 term requires 3 addition gates
        let constraint = R1csConstraint {
            a: make_lc(&[(1, 1), (2, 1), (3, 1), (4, 1)]),
            b: make_lc(&[(5, 1)]),
            c: make_lc(&[(6, 1)]),
        };
        let r1cs = make_r1cs(vec![constraint], 7);
        let (constraints, additions) = r1cs2plonk(&r1cs);

        // Should have the final multiplication constraint plus the addition constraints
        assert!(constraints.len() > 1);
        assert!(additions.len() > 0);
    }
}
