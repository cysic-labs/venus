//! Helper types and functions for `pil2circom.rs`.
//!
//! Contains:
//! - `Transcript` for circom Poseidon2 transcript code generation
//! - `StarkVerifierCtx` context for unroll_code references
//! - `get_expression_chunks` for splitting verifier code into chunks
//! - `unroll_code` for expanding verifier code into circom assignments
//! - `compute_gl_root_power` for Goldilocks root of unity powers

use serde_json::Value;
use std::collections::{BTreeMap, HashSet};

/// Precomputed 2^i-th roots of unity in the Goldilocks field.
///
/// `ROOTS[i]` is the primitive `2^i`-th root of unity for the
/// Goldilocks field `p = 2^64 - 2^32 + 1`, matching the JS
/// `roots(i)` function in `stark_verifier.circom.ejs`.
const ROOTS: [u64; 33] = [
    1,
    18446744069414584320,
    281474976710656,
    16777216,
    4096,
    64,
    8,
    2198989700608,
    4404853092538523347,
    6434636298004421797,
    4255134452441852017,
    9113133275150391358,
    4355325209153869931,
    4308460244895131701,
    7126024226993609386,
    1873558160482552414,
    8167150655112846419,
    5718075921287398682,
    3411401055030829696,
    8982441859486529725,
    1971462654193939361,
    6553637399136210105,
    8124823329697072476,
    5936499541590631774,
    2709866199236980323,
    8877499657461974390,
    3757607247483852735,
    4969973714567017225,
    2147253751702802259,
    2530564950562219707,
    1905180297017055339,
    3524815499551269279,
    7277203076849721926,
];

const INV_ROOTS: [u64; 33] = [
    1,
    18446744069414584320,
    18446462594437873665,
    18446742969902956801,
    18442240469788262401,
    18158513693329981441,
    16140901060737761281,
    274873712576,
    9171943329124577373,
    5464760906092500108,
    4088309022520035137,
    6141391951880571024,
    386651765402340522,
    11575992183625933494,
    2841727033376697931,
    8892493137794983311,
    9071788333329385449,
    15139302138664925958,
    14996013474702747840,
    5708508531096855759,
    6451340039662992847,
    5102364342718059185,
    10420286214021487819,
    13945510089405579673,
    17538441494603169704,
    16784649996768716373,
    8974194941257008806,
    16194875529212099076,
    5506647088734794298,
    7731871677141058814,
    16558868196663692994,
    9896756522253134970,
    1644488454024429189,
];

/// The Goldilocks prime `p = 2^64 - 2^32 + 1`.
const GL_P: u128 = 0xFFFF_FFFF_0000_0001;

/// Modular multiplication in Goldilocks.
fn gl_mul(a: u64, b: u64) -> u64 {
    ((a as u128 * b as u128) % GL_P) as u64
}

/// Modular exponentiation in Goldilocks.
fn gl_exp(base: u64, mut exp: u64) -> u64 {
    let mut result: u64 = 1;
    let mut b = base;
    while exp > 0 {
        if exp & 1 == 1 {
            result = gl_mul(result, b);
        }
        b = gl_mul(b, b);
        exp >>= 1;
    }
    result
}

/// Modular inverse in Goldilocks via Fermat's little theorem.
fn gl_inv(a: u64) -> u64 {
    gl_exp(a, GL_P as u64 - 2)
}

/// Compute `w^power` where `w` is the primitive `2^n_bits`-th root of unity.
///
/// This matches the JS pattern `F.exp(F.w[nBits], power)`.
pub fn compute_gl_root_power(n_bits: u64, power: u64) -> u64 {
    let w = ROOTS[n_bits as usize];
    gl_exp(w, power)
}

/// Compute `invroots(i)` - the inverse of the `2^i`-th root of unity.
#[allow(dead_code)]
pub fn invroots(i: usize) -> u64 {
    INV_ROOTS[i]
}

/// Return `roots(i)` - the primitive `2^i`-th root of unity.
#[allow(dead_code)]
pub fn roots(i: usize) -> u64 {
    ROOTS[i]
}

/// Compute `F.inv(F.exp(F.shift, exponent))` where `shift = 7`.
pub fn compute_inv_shift_exp(exponent: u64) -> u64 {
    gl_inv(gl_exp(7, exponent))
}

// ---------------------------------------------------------------------------
// Transcript
// ---------------------------------------------------------------------------

/// A Poseidon2-based transcript code generator for circom.
///
/// Mirrors the `Transcript` class in `stark_verifier.circom.ejs`.
/// Instead of computing actual hashes, it generates circom signal
/// declarations and constraints that perform the transcript protocol.
pub struct Transcript {
    state: Vec<String>,
    pending: Vec<String>,
    out: Vec<String>,
    h_cnt: usize,
    hi_cnt: usize,
    n2b_cnt: usize,
    last_code_printed: usize,
    name: Option<String>,
    arity: u64,
    code: Vec<String>,
}

impl Transcript {
    /// Create a new Transcript.
    ///
    /// - `name`: optional suffix for signal names (e.g., `"friQueries"`)
    /// - `arity`: Merkle tree arity (typically 16)
    pub fn new(name: Option<&str>, arity: u64) -> Self {
        Self {
            state: vec!["0".to_string(); 4],
            pending: Vec::new(),
            out: Vec::new(),
            h_cnt: 0,
            hi_cnt: 0,
            n2b_cnt: 0,
            last_code_printed: 0,
            name: name.map(|s| s.to_string()),
            arity,
            code: Vec::new(),
        }
    }

    /// Get a field element (3 components) from the transcript and assign to `v`.
    pub fn get_field(&mut self, v: &str) {
        let f0 = self.get_fields1();
        let f1 = self.get_fields1();
        let f2 = self.get_fields1();
        self.code
            .push(format!("{} <== [{}, {}, {}];", v, f0, f1, f2));
    }

    /// Get 4 field elements and assign to `v[4]`.
    pub fn get_state(&mut self, v: &str) {
        let f0 = self.get_fields1();
        let f1 = self.get_fields1();
        let f2 = self.get_fields1();
        let f3 = self.get_fields1();
        self.code
            .push(format!("{} <== [{}, {}, {}, {}];", v, f0, f1, f2, f3));
    }

    fn update_state(&mut self) {
        let signal_name = if let Some(ref name) = self.name {
            format!("transcriptHash_{}", name)
        } else {
            "transcriptHash".to_string()
        };

        if self.h_cnt > 0 {
            let first_unused = self.hi_cnt.max(4);
            if first_unused < (4 * self.arity) as usize {
                self.code.push(format!(
                    "for(var i = {}; i < {}; i++){{\n        _ <== {}_{}[i]; // Unused transcript values \n    }}",
                    first_unused,
                    4 * self.arity,
                    signal_name,
                    self.h_cnt - 1
                ));
            }
        }

        // Pad pending to capacity
        let cap = 4 * (self.arity - 1) as usize;
        while self.pending.len() < cap {
            self.pending.push("0".to_string());
        }

        self.code.push(format!(
            "\n    signal {}_{}[{}] <== Poseidon2({}, {})([{}], [{}]);",
            signal_name,
            self.h_cnt,
            4 * self.arity,
            self.arity,
            4 * self.arity,
            self.pending.join(","),
            self.state.join(","),
        ));

        for i in 0..(4 * self.arity as usize) {
            self.out
                .push(format!("{}_{}[{}]", signal_name, self.h_cnt, i));
        }
        for i in 0..4 {
            self.state[i] = format!("{}_{}[{}]", signal_name, self.h_cnt, i);
        }

        self.h_cnt += 1;
        self.pending.clear();
        self.hi_cnt = 0;
    }

    fn get_fields1(&mut self) -> String {
        if self.out.is_empty() {
            let cap = 4 * (self.arity - 1) as usize;
            while self.pending.len() < cap {
                self.pending.push("0".to_string());
            }
            self.update_state();
        }
        let res = self.out.remove(0);
        self.hi_cnt += 1;
        res
    }

    /// Put a signal array into the transcript.
    ///
    /// - If `len > 0`, adds `name[0]` through `name[len-1]`.
    /// - If `len == 0`, adds `name` as a single element.
    pub fn put(&mut self, name: &str, len: u64) {
        if len > 0 {
            for i in 0..len {
                self.add1(format!("{}[{}]", name, i));
            }
        }
    }

    /// Put a single scalar signal into the transcript (no indexing).
    pub fn put_single(&mut self, name: &str) {
        self.add1(name.to_string());
    }

    fn add1(&mut self, a: String) {
        self.out.clear();
        self.pending.push(a);
        let cap = 4 * (self.arity - 1) as usize;
        if self.pending.len() == cap {
            self.update_state();
        }
    }

    /// Generate query permutation signals from transcript.
    pub fn get_permutations(&mut self, v: &str, n: u64, n_bits: u64, n_fields: u64) {
        let signal_name = if let Some(ref name) = self.name {
            format!("transcriptHash_{}", name)
        } else {
            "transcriptHash".to_string()
        };

        let total_bits = n * n_bits;
        let mut n2b = Vec::new();
        for _ in 0..n_fields {
            let f = self.get_fields1();
            let n2b_name = format!("transcriptN2b_{}", self.n2b_cnt);
            self.n2b_cnt += 1;
            self.code.push(format!(
                "signal {{binary}} {}[64] <== Num2Bits_strict()({});",
                n2b_name, f
            ));
            n2b.push(n2b_name);
        }

        if (self.hi_cnt as u64) < 4 * self.arity {
            self.code.push(format!(
                "for(var i = {}; i < {}; i++){{\n        _ <== {}_{}[i]; // Unused transcript values        \n    }}\n",
                self.hi_cnt,
                4 * self.arity,
                signal_name,
                self.h_cnt - 1
            ));
        }

        self.code.push(
            "// From each transcript hash converted to bits, we assign those bits to queriesFRI[q] to define the query positions".to_string(),
        );
        self.code.push("var q = 0; // Query number ".to_string());
        self.code.push("var b = 0; // Bit number ".to_string());

        for (i, n2b_name) in n2b.iter().enumerate() {
            let field_bits = if (i as u64) + 1 == n_fields {
                total_bits - 63 * i as u64
            } else {
                63
            };
            self.code.push(format!(
                "for(var j = 0; j < {}; j++) {{\n        {}[q][b] <== {}[j];\n        b++;\n        if(b == {}) {{\n            b = 0; \n            q++;\n        }}\n    }}",
                field_bits, v, n2b_name, n_bits
            ));
            if field_bits == 63 {
                self.code
                    .push(format!("_ <== {}[63]; // Unused last bit\n", n2b_name));
            } else {
                self.code.push(format!(
                    "for(var j = {}; j < 64; j++) {{\n        _ <== {}[j]; // Unused bits        \n    }}",
                    field_bits, n2b_name
                ));
            }
        }
    }

    /// Return all accumulated code lines since the last call, indented.
    pub fn get_code(&mut self) -> String {
        for i in self.last_code_printed..self.code.len() {
            self.code[i] = format!("    {}", self.code[i]);
        }
        let code = self.code[self.last_code_printed..].join("\n");
        self.last_code_printed = self.code.len();
        code
    }
}

// ---------------------------------------------------------------------------
// StarkVerifierCtx
// ---------------------------------------------------------------------------

/// Context for resolving references inside `unroll_code`.
pub struct StarkVerifierCtx<'a> {
    pub stark_info: &'a Value,
    pub q_stage: u64,
    pub evals_stage: u64,
    pub fri_stage: u64,
    pub cm_pols_map: &'a [Value],
    pub custom_commits: &'a [Value],
    pub custom_commits_map: &'a [Value],
    pub boundaries: &'a [Value],
}

/// Resolve a reference in verifier code to a circom expression.
fn code_ref(
    r: &Value,
    is_dest: bool,
    initialized: &HashSet<u64>,
    ctx: &StarkVerifierCtx<'_>,
) -> String {
    let rtype = r.get("type").and_then(|v| v.as_str()).unwrap_or("");
    let id = r.get("id").and_then(|v| v.as_u64()).unwrap_or(0);
    let dim = r.get("dim").and_then(|v| v.as_u64()).unwrap_or(1);

    match rtype {
        "eval" => format!("evals[{}]", id),
        "challenge" => {
            let stage = r.get("stage").and_then(|v| v.as_u64()).unwrap_or(0);
            let stage_id = r.get("stageId").and_then(|v| v.as_u64()).unwrap_or(0);
            if stage == ctx.q_stage {
                "challengeQ".to_string()
            } else if stage == ctx.evals_stage {
                "challengeXi".to_string()
            } else if stage == ctx.fri_stage {
                format!("challengesFRI[{}]", stage_id)
            } else {
                format!("challengesStage{}[{}]", stage, stage_id)
            }
        }
        "public" => format!("publics[{}]", id),
        "x" => "challengeXi".to_string(),
        "Zi" => {
            let boundary_id = r.get("boundaryId").and_then(|v| v.as_u64()).unwrap_or(0) as usize;
            let boundary = &ctx.boundaries[boundary_id];
            let bname = boundary.get("name").and_then(|v| v.as_str()).unwrap_or("");
            match bname {
                "everyRow" => "Zh".to_string(),
                "firstRow" => "Zfirst".to_string(),
                "lastRow" => "Zlast".to_string(),
                "everyFrame" => {
                    let off_min = boundary
                        .get("offsetMin")
                        .and_then(|v| v.as_u64())
                        .unwrap_or(0);
                    let off_max = boundary
                        .get("offsetMax")
                        .and_then(|v| v.as_u64())
                        .unwrap_or(0);
                    // Find the index among everyFrame boundaries
                    let bi = ctx
                        .boundaries
                        .iter()
                        .filter(|b| b.get("name").and_then(|v| v.as_str()) == Some("everyFrame"))
                        .position(|b| {
                            b.get("offsetMin").and_then(|v| v.as_u64()) == Some(off_min)
                                && b.get("offsetMax").and_then(|v| v.as_u64()) == Some(off_max)
                        })
                        .unwrap_or(0);
                    format!("Zframe{}[{}]", bi, off_min + off_max - 1)
                }
                _ => format!("/* unknown boundary {} */", bname),
            }
        }
        "xDivXSubXi" => format!("xDivXSubXi[{}]", id),
        "tmp" => {
            if is_dest && !initialized.contains(&id) {
                if dim == 1 {
                    format!("signal tmp_{}", id)
                } else {
                    format!("signal tmp_{}[3]", id)
                }
            } else {
                format!("tmp_{}", id)
            }
        }
        "cm" => {
            let pol = &ctx.cm_pols_map[id as usize];
            let stage = pol.get("stage").and_then(|v| v.as_u64()).unwrap_or(0);
            let stage_id = pol.get("stageId").and_then(|v| v.as_u64()).unwrap_or(0);
            format!("mapValues.cm{}_{}", stage, stage_id)
        }
        "custom" => {
            let commit_id = r.get("commitId").and_then(|v| v.as_u64()).unwrap_or(0) as usize;
            let cc_map = ctx.custom_commits_map[commit_id]
                .as_array()
                .map(|a| &a[id as usize])
                .unwrap_or(&Value::Null);
            let cc_name = ctx.custom_commits[commit_id]
                .get("name")
                .and_then(|v| v.as_str())
                .unwrap_or("custom");
            let stage = cc_map.get("stage").and_then(|v| v.as_u64()).unwrap_or(0);
            let stage_id = cc_map.get("stageId").and_then(|v| v.as_u64()).unwrap_or(0);
            format!("mapValues.custom_{}_{}_{}", cc_name, stage, stage_id)
        }
        "const" => format!("consts[{}]", id),
        "number" => r
            .get("value")
            .and_then(|v| v.as_str())
            .unwrap_or("0")
            .to_string(),
        "airgroupvalue" => format!("airgroupvalues[{}]", id),
        "airvalue" => {
            if dim == 1 {
                format!("airvalues[{}][0]", id)
            } else {
                format!("airvalues[{}]", id)
            }
        }
        "proofvalue" => {
            if dim == 1 {
                format!("proofvalues[{}][0]", id)
            } else {
                format!("proofvalues[{}]", id)
            }
        }
        _ => format!("/* unknown ref type {} */", rtype),
    }
}

/// Unroll a verifier code array into circom signal assignments.
///
/// Each instruction has `dest`, `op`, and `src` fields.
/// The `initialized` set tracks which tmp signals have already
/// been declared.
pub fn unroll_code(
    code: &[Value],
    initialized: &HashSet<u64>,
    ctx: &StarkVerifierCtx<'_>,
) -> String {
    let mut out = String::new();
    let mut init = initialized.clone();

    for inst in code {
        let dest = inst.get("dest").unwrap_or(&Value::Null);
        let op = inst.get("op").and_then(|v| v.as_str()).unwrap_or("");
        let src = inst
            .get("src")
            .and_then(|v| v.as_array())
            .cloned()
            .unwrap_or_default();

        // Force dim=3 for Zi and airgroupvalue types
        let mut src0 = src.first().cloned().unwrap_or(Value::Null);
        if let Some(t) = src0.get("type").and_then(|v| v.as_str()) {
            if t == "Zi" || t == "airgroupvalue" {
                src0.as_object_mut()
                    .map(|o| o.insert("dim".to_string(), serde_json::json!(3)));
            }
        }
        let mut src1 = src.get(1).cloned().unwrap_or(Value::Null);
        if let Some(t) = src1.get("type").and_then(|v| v.as_str()) {
            if t == "Zi" || t == "airgroupvalue" {
                src1.as_object_mut()
                    .map(|o| o.insert("dim".to_string(), serde_json::json!(3)));
            }
        }

        let dest_ref = code_ref(dest, true, &init, ctx);
        let src0_ref = code_ref(&src0, false, &init, ctx);

        // Track initialization
        if dest.get("type").and_then(|v| v.as_str()) == Some("tmp") {
            if let Some(id) = dest.get("id").and_then(|v| v.as_u64()) {
                init.insert(id);
            }
        }

        match op {
            "add" => {
                let src1_ref = code_ref(&src1, false, &init, ctx);
                let s0d = src0.get("dim").and_then(|v| v.as_u64()).unwrap_or(1);
                let s1d = src1.get("dim").and_then(|v| v.as_u64()).unwrap_or(1);
                match (s0d, s1d) {
                    (1, 1) => {
                        out.push_str(&format!(
                            "    {} <== {} + {};\n",
                            dest_ref, src0_ref, src1_ref
                        ));
                    }
                    (1, 3) => {
                        out.push_str(&format!(
                            "    {} <== [{} + {}[0], {}[1], {}[2]];\n",
                            dest_ref, src0_ref, src1_ref, src1_ref, src1_ref
                        ));
                    }
                    (3, 1) => {
                        out.push_str(&format!(
                            "    {} <== [{}[0] + {}, {}[1], {}[2]];\n",
                            dest_ref, src0_ref, src1_ref, src0_ref, src0_ref
                        ));
                    }
                    (3, 3) => {
                        out.push_str(&format!(
                            "    {} <== [{}[0] + {}[0], {}[1] + {}[1], {}[2] + {}[2]];\n",
                            dest_ref, src0_ref, src1_ref, src0_ref, src1_ref, src0_ref, src1_ref
                        ));
                    }
                    _ => {
                        out.push_str(&format!(
                            "    {} <== {} + {};\n",
                            dest_ref, src0_ref, src1_ref
                        ));
                    }
                }
            }
            "sub" => {
                let src1_ref = code_ref(&src1, false, &init, ctx);
                let s0d = src0.get("dim").and_then(|v| v.as_u64()).unwrap_or(1);
                let s1d = src1.get("dim").and_then(|v| v.as_u64()).unwrap_or(1);
                match (s0d, s1d) {
                    (1, 1) => {
                        out.push_str(&format!(
                            "    {} <== {} - {};\n",
                            dest_ref, src0_ref, src1_ref
                        ));
                    }
                    (1, 3) => {
                        out.push_str(&format!(
                            "    {} <== [{} - {}[0], -{}[1], -{}[2]];\n",
                            dest_ref, src0_ref, src1_ref, src1_ref, src1_ref
                        ));
                    }
                    (3, 1) => {
                        out.push_str(&format!(
                            "    {} <== [{}[0] - {}, {}[1], {}[2]];\n",
                            dest_ref, src0_ref, src1_ref, src0_ref, src0_ref
                        ));
                    }
                    (3, 3) => {
                        out.push_str(&format!(
                            "    {} <== [{}[0] - {}[0], {}[1] - {}[1], {}[2] - {}[2]];\n",
                            dest_ref, src0_ref, src1_ref, src0_ref, src1_ref, src0_ref, src1_ref
                        ));
                    }
                    _ => {
                        out.push_str(&format!(
                            "    {} <== {} - {};\n",
                            dest_ref, src0_ref, src1_ref
                        ));
                    }
                }
            }
            "mul" => {
                let src1_ref = code_ref(&src1, false, &init, ctx);
                let s0d = src0.get("dim").and_then(|v| v.as_u64()).unwrap_or(1);
                let s1d = src1.get("dim").and_then(|v| v.as_u64()).unwrap_or(1);
                match (s0d, s1d) {
                    (1, 1) => {
                        out.push_str(&format!(
                            "    {} <== {} * {};\n",
                            dest_ref, src0_ref, src1_ref
                        ));
                    }
                    (1, 3) => {
                        out.push_str(&format!(
                            "    {} <== [{} * {}[0], {} * {}[1], {} * {}[2]];\n",
                            dest_ref, src0_ref, src1_ref, src0_ref, src1_ref, src0_ref, src1_ref
                        ));
                    }
                    (3, 1) => {
                        out.push_str(&format!(
                            "    {} <== [{}[0] * {}, {}[1] * {}, {}[2] * {}];\n",
                            dest_ref, src0_ref, src1_ref, src0_ref, src1_ref, src0_ref, src1_ref
                        ));
                    }
                    (3, 3) => {
                        out.push_str(&format!(
                            "    {} <== CMul()({}, {});\n",
                            dest_ref, src0_ref, src1_ref
                        ));
                    }
                    _ => {
                        out.push_str(&format!(
                            "    {} <== {} * {};\n",
                            dest_ref, src0_ref, src1_ref
                        ));
                    }
                }
            }
            "copy" => {
                out.push_str(&format!("    {} <== {};\n", dest_ref, src0_ref));
            }
            _ => {
                out.push_str(&format!("    // unknown op: {}\n", op));
            }
        }
    }

    out
}

// ---------------------------------------------------------------------------
// Expression chunks
// ---------------------------------------------------------------------------

/// Information about a temporary variable.
#[derive(Debug, Clone)]
pub struct TmpInfo {
    pub last_pos: usize,
    pub dim: u64,
}

/// A chunk of code with its input/output tmp dependencies.
#[derive(Debug, Clone)]
pub struct CodeChunk {
    pub code: Vec<Value>,
    pub inputs: Vec<u64>,
    pub outputs: Vec<u64>,
}

/// Result of splitting verifier code into chunks.
#[derive(Debug, Clone)]
pub struct ExpressionChunks {
    pub chunks: Vec<CodeChunk>,
    pub tmps: BTreeMap<u64, TmpInfo>,
}

/// Split verifier code into chunks of approximately `min_chunk_size`.
///
/// This mirrors `getExpressionsChunks` in the EJS template.
pub fn get_expression_chunks(code: &[Value], min_chunk_size: usize) -> ExpressionChunks {
    let mut tmps: BTreeMap<u64, TmpInfo> = BTreeMap::new();

    // First pass: record last_pos and dim for each tmp
    for (i, inst) in code.iter().enumerate() {
        let dest = inst.get("dest").unwrap_or(&Value::Null);
        if dest.get("type").and_then(|v| v.as_str()) == Some("tmp") {
            let id = dest.get("id").and_then(|v| v.as_u64()).unwrap_or(0);
            let dim = dest.get("dim").and_then(|v| v.as_u64()).unwrap_or(1);
            tmps.insert(id, TmpInfo { last_pos: i, dim });
        }

        let src = inst
            .get("src")
            .and_then(|v| v.as_array())
            .cloned()
            .unwrap_or_default();
        for s in &src {
            if s.get("type").and_then(|v| v.as_str()) == Some("tmp") {
                let id = s.get("id").and_then(|v| v.as_u64()).unwrap_or(0);
                if let Some(info) = tmps.get_mut(&id) {
                    info.last_pos = i;
                }
            }
        }
    }

    // Second pass: build chunks
    let mut live_tmps: HashSet<u64> = HashSet::new();
    let mut previous_live_tmps: HashSet<u64> = HashSet::new();
    let mut chunks: Vec<CodeChunk> = Vec::new();
    let mut current_chunk: Vec<Value> = Vec::new();
    let mut inputs: HashSet<u64> = HashSet::new();
    let mut outputs: HashSet<u64> = HashSet::new();

    for (i, inst) in code.iter().enumerate() {
        current_chunk.push(inst.clone());

        let dest = inst.get("dest").unwrap_or(&Value::Null);
        if dest.get("type").and_then(|v| v.as_str()) == Some("tmp") {
            let id = dest.get("id").and_then(|v| v.as_u64()).unwrap_or(0);
            live_tmps.insert(id);
            outputs.insert(id);
        }

        let src = inst
            .get("src")
            .and_then(|v| v.as_array())
            .cloned()
            .unwrap_or_default();
        for s in &src {
            if s.get("type").and_then(|v| v.as_str()) == Some("tmp") {
                let id = s.get("id").and_then(|v| v.as_u64()).unwrap_or(0);
                if i == tmps.get(&id).map(|t| t.last_pos).unwrap_or(usize::MAX) {
                    live_tmps.remove(&id);
                    outputs.remove(&id);
                }
                if previous_live_tmps.contains(&id) {
                    inputs.insert(id);
                    if i == tmps.get(&id).map(|t| t.last_pos).unwrap_or(usize::MAX) {
                        previous_live_tmps.remove(&id);
                    }
                }
            }
        }

        if current_chunk.len() + 1 >= min_chunk_size {
            let mut inp_sorted: Vec<u64> = inputs.iter().copied().collect();
            inp_sorted.sort();
            let mut out_sorted: Vec<u64> = outputs.iter().copied().collect();
            out_sorted.sort();
            chunks.push(CodeChunk {
                code: std::mem::take(&mut current_chunk),
                inputs: inp_sorted,
                outputs: out_sorted,
            });
            previous_live_tmps = previous_live_tmps.union(&live_tmps).copied().collect();
            live_tmps.clear();
            outputs.clear();
            inputs.clear();
        }
    }

    if !current_chunk.is_empty() {
        let mut inp_sorted: Vec<u64> = inputs.iter().copied().collect();
        inp_sorted.sort();
        let mut out_sorted: Vec<u64> = outputs.iter().copied().collect();
        out_sorted.sort();
        chunks.push(CodeChunk {
            code: current_chunk,
            inputs: inp_sorted,
            outputs: out_sorted,
        });
    }

    ExpressionChunks { chunks, tmps }
}
