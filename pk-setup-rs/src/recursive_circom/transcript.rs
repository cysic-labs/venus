//! Fiat-Shamir transcript rendering shared by the verifier templates.

use super::*;

#[allow(dead_code)]
pub fn render_calculate_fri_queries_template(stark_info: &CircomStarkInfo) -> String {
    let name = suffixed_name("calculateFRIQueries", stark_info.airgroup_id);
    let mut out = String::new();
    line(&mut out, format_args!("template {name}() {{"));
    line(&mut out, format_args!("    signal input challengeFRIQueries[3];"));
    if stark_info.stark_struct.pow_bits > 0 {
        line(&mut out, format_args!("    signal input nonce;"));
    }
    line(&mut out, format_args!("    signal input {{binary}} enable;"));
    line(
        &mut out,
        format_args!(
            "    signal output {{binary}} queriesFRI[{}][{}];",
            stark_info.n_queries(),
            stark_info.stark_struct.steps[0].n_bits
        ),
    );
    out.push('\n');
    if stark_info.stark_struct.pow_bits > 0 {
        line(
            &mut out,
            format_args!(
                "    VerifyPoW({})(challengeFRIQueries, nonce, enable);",
                stark_info.stark_struct.pow_bits
            ),
        );
        out.push('\n');
    }
    let mut transcript = TranscriptRenderer::new(stark_info, Some("friQueries".to_string()));
    transcript.put("challengeFRIQueries", Some(3));
    if stark_info.stark_struct.pow_bits > 0 {
        transcript.put("nonce", None);
    }
    transcript.get_permutations(
        "queriesFRI",
        stark_info.n_queries(),
        stark_info.stark_struct.steps[0].n_bits,
    );
    out.push_str(&transcript.take_code());
    line(&mut out, format_args!("}}"));
    out
}

#[allow(dead_code)]
pub fn render_transcript_template(
    stark_info: &CircomStarkInfo,
    options: StarkVerifierOptions,
) -> String {
    let name = suffixed_name("Transcript", stark_info.airgroup_id);
    let calculate_fri_queries_name = suffixed_name("calculateFRIQueries", stark_info.airgroup_id);
    let q_stage = stark_info.n_stages + 1;
    let mut out = String::new();
    line(&mut out, format_args!("template {name}() {{"));

    if !options.input_challenges {
        if stark_info.n_publics > 0 {
            line(&mut out, format_args!("    signal input publics[{}];", stark_info.n_publics));
        }
        line(&mut out, format_args!("    signal input rootC[4];"));
        line(&mut out, format_args!("    signal input root1[4];"));
    } else {
        line(&mut out, format_args!("    signal input globalChallenge[3]; "));
    }
    out.push('\n');
    if !stark_info.air_values_map.is_empty() {
        line(
            &mut out,
            format_args!("    signal input airValues[{}][3];", stark_info.air_values_map.len()),
        );
        out.push('\n');
    }
    if !stark_info.airgroup_values_map.is_empty() {
        line(
            &mut out,
            format_args!(
                "    signal input airgroupvalues[{}][3];",
                stark_info.airgroup_values_map.len()
            ),
        );
        out.push('\n');
    }
    for stage in 2..=stark_info.n_stages {
        line(&mut out, format_args!("    signal input root{stage}[4];"));
    }
    line(&mut out, format_args!("    signal input root{q_stage}[4];"));
    line(&mut out, format_args!("    signal input evals[{}][3]; ", stark_info.ev_map.len()));
    for step in 1..stark_info.stark_struct.steps.len() {
        line(&mut out, format_args!("    signal input s{step}_root[4];"));
    }
    let last_pol_size =
        1u64 << stark_info.stark_struct.steps.last().map(|step| step.n_bits).unwrap_or(0);
    line(&mut out, format_args!("    signal input finalPol[{last_pol_size}][3];"));
    if stark_info.stark_struct.pow_bits > 0 {
        line(&mut out, format_args!("    signal input nonce;"));
    }
    line(&mut out, format_args!("    signal input {{binary}} enable;"));
    out.push('\n');

    for stage in 1..=stark_info.n_stages {
        let count = stark_info.challenge_count(stage as u64);
        if count > 0 {
            line(&mut out, format_args!("    signal output challengesStage{stage}[{count}][3];"));
        }
    }
    line(&mut out, format_args!("    signal output challengeQ[3];"));
    line(&mut out, format_args!("    signal output challengeXi[3];"));
    line(&mut out, format_args!("    signal output challengesFRI[2][3];"));
    line(
        &mut out,
        format_args!(
            "    signal output challengesFRISteps[{}][3];",
            stark_info.stark_struct.steps.len() + 1
        ),
    );
    line(
        &mut out,
        format_args!(
            "    signal output {{binary}} queriesFRI[{}][{}];",
            stark_info.n_queries(),
            stark_info.stark_struct.steps[0].n_bits
        ),
    );
    out.push('\n');
    if stark_info.stark_struct.hash_commits {
        if stark_info.n_publics > 0 {
            line(&mut out, format_args!("    signal publicsHash[4];"));
        }
        line(&mut out, format_args!("    signal evalsHash[4];"));
        line(&mut out, format_args!("    signal lastPolFRIHash[4];"));
        out.push('\n');
    }

    let mut transcript = TranscriptRenderer::new(stark_info, None);
    if !options.input_challenges {
        transcript.put("rootC", Some(4));
        if stark_info.n_publics > 0 {
            if !stark_info.stark_struct.hash_commits {
                transcript.put("publics", Some(stark_info.n_publics));
            } else {
                out.push_str(&transcript.take_code());
                let mut publics_transcript =
                    TranscriptRenderer::new(stark_info, Some("publics".to_string()));
                publics_transcript.put("publics", Some(stark_info.n_publics));
                publics_transcript.get_state("publicsHash");
                out.push_str(&publics_transcript.take_code());
                transcript.put("publicsHash", Some(4));
            }
        }
        transcript.put("root1", Some(4));
    } else {
        transcript.put("globalChallenge", Some(3));
    }

    for stage in 2..=stark_info.n_stages {
        for challenge_idx in 0..stark_info.challenge_count(stage as u64) {
            transcript.get_field(&format!("challengesStage{stage}[{challenge_idx}]"));
        }
        transcript.put(&format!("root{stage}"), Some(4));
        for (idx, air_value) in stark_info.air_values_map.iter().enumerate() {
            if air_value.stage == stage as u64 {
                transcript.put(&format!("airValues[{idx}]"), Some(3));
            }
        }
        // The airgroup values enter the quotient check, so they are bound right after the
        // stage-2 root and air values, as the provers do. A stage-1 value is a base field
        // element: only its first limb is absorbed and the other two must be zero.
        if stage == 2 {
            for (idx, airgroup_value) in stark_info.airgroup_values_map.iter().enumerate() {
                let value = format!("airgroupvalues[{idx}]");
                if airgroup_value.stage == 1 {
                    transcript.put(&value, Some(1));
                    transcript.code.push(format!("enable * {value}[1] === 0;"));
                    transcript.code.push(format!("enable * {value}[2] === 0;"));
                } else {
                    transcript.put(&value, Some(3));
                }
            }
        }
    }

    transcript.get_field("challengeQ");
    transcript.put(&format!("root{q_stage}"), Some(4));
    transcript.get_field("challengeXi");
    if !stark_info.stark_struct.hash_commits {
        for idx in 0..stark_info.ev_map.len() {
            transcript.put(&format!("evals[{idx}]"), Some(3));
        }
    } else {
        out.push_str(&transcript.take_code());
        let mut evals_transcript = TranscriptRenderer::new(stark_info, Some("evals".to_string()));
        for idx in 0..stark_info.ev_map.len() {
            evals_transcript.put(&format!("evals[{idx}]"), Some(3));
        }
        evals_transcript.get_state("evalsHash");
        out.push_str(&evals_transcript.take_code());
        transcript.put("evalsHash", Some(4));
    }

    transcript.get_field("challengesFRI[0]");
    transcript.get_field("challengesFRI[1]");
    for step_idx in 0..stark_info.stark_struct.steps.len() {
        transcript.get_field(&format!("challengesFRISteps[{step_idx}]"));
        if step_idx < stark_info.stark_struct.steps.len() - 1 {
            transcript.put(&format!("s{}_root", step_idx + 1), Some(4));
        } else if !stark_info.stark_struct.hash_commits {
            for idx in 0..last_pol_size {
                transcript.put(&format!("finalPol[{idx}]"), Some(3));
            }
        } else {
            out.push_str(&transcript.take_code());
            let mut last_pol_transcript =
                TranscriptRenderer::new(stark_info, Some("lastPolFRI".to_string()));
            for idx in 0..last_pol_size {
                last_pol_transcript.put(&format!("finalPol[{idx}]"), Some(3));
            }
            last_pol_transcript.get_state("lastPolFRIHash");
            out.push_str(&last_pol_transcript.take_code());
            transcript.put("lastPolFRIHash", Some(4));
        }
    }
    transcript.get_field(&format!("challengesFRISteps[{}]", stark_info.stark_struct.steps.len()));
    out.push_str(&transcript.take_code());
    out.push('\n');

    if stark_info.stark_struct.pow_bits > 0 {
        line(
            &mut out,
            format_args!(
                "    queriesFRI <== {calculate_fri_queries_name}()(challengesFRISteps[{}], nonce, enable);",
                stark_info.stark_struct.steps.len()
            ),
        );
    } else {
        line(
            &mut out,
            format_args!(
                "    queriesFRI <== {calculate_fri_queries_name}()(challengesFRISteps[{}], enable);",
                stark_info.stark_struct.steps.len()
            ),
        );
    }
    line(&mut out, format_args!("}}"));
    out
}

#[derive(Debug, Clone)]
#[allow(dead_code)]
pub struct TranscriptRenderer<'a> {
    stark_info: &'a CircomStarkInfo,
    name: Option<String>,
    state: Vec<String>,
    pending: Vec<String>,
    out: Vec<String>,
    h_cnt: usize,
    hi_cnt: usize,
    n2b_cnt: usize,
    last_code_printed: usize,
    pub(super) code: Vec<String>,
}

#[allow(dead_code)]
impl<'a> TranscriptRenderer<'a> {
    pub fn new(stark_info: &'a CircomStarkInfo, name: impl Into<Option<String>>) -> Self {
        Self {
            stark_info,
            name: name.into(),
            state: vec!["0".to_string(), "0".to_string(), "0".to_string(), "0".to_string()],
            pending: Vec::new(),
            out: Vec::new(),
            h_cnt: 0,
            hi_cnt: 0,
            n2b_cnt: 0,
            last_code_printed: 0,
            code: Vec::new(),
        }
    }

    pub fn get_field(&mut self, target: &str) {
        let values = [self.get_fields1(), self.get_fields1(), self.get_fields1()];
        self.code.push(format!("{target} <== [{}, {}, {}];", values[0], values[1], values[2]));
    }

    pub fn get_state(&mut self, target: &str) {
        let values =
            [self.get_fields1(), self.get_fields1(), self.get_fields1(), self.get_fields1()];
        self.code.push(format!(
            "{target} <== [{}, {}, {}, {}];",
            values[0], values[1], values[2], values[3]
        ));
    }

    pub fn put(&mut self, value: &str, len: Option<usize>) {
        if let Some(len) = len {
            for idx in 0..len {
                self.add_one(format!("{value}[{idx}]"));
            }
        } else {
            self.add_one(value.to_string());
        }
    }

    pub fn get_permutations(&mut self, target: &str, n: u64, n_bits: u64) {
        let total_bits = n * n_bits;
        let n_fields = ((total_bits - 1) / 63) + 1;
        let mut n2b = Vec::new();
        for _ in 0..n_fields {
            let field = self.get_fields1();
            let name = format!("transcriptN2b_{}", self.n2b_cnt);
            self.n2b_cnt += 1;
            self.code.push(format!("signal {{binary}} {name}[64] <== Num2Bits_strict()({field});"));
            n2b.push(name);
        }

        let arity_words = self.arity_words();
        if self.hi_cnt < arity_words {
            self.code.push(format!(
                "for(var i = {}; i < {}; i++){{\n        _ <== {}_{}[i]; // Unused transcript values        \n    }}\n",
                self.hi_cnt,
                arity_words,
                self.signal_name(),
                self.h_cnt.saturating_sub(1)
            ));
        }

        self.code.push(
            "// From each transcript hash converted to bits, we assign those bits to queriesFRI[q] to define the query positions".to_string(),
        );
        self.code.push("var q = 0; // Query number ".to_string());
        self.code.push("var b = 0; // Bit number ".to_string());
        for (idx, name) in n2b.iter().enumerate() {
            let bits = if idx + 1 == n2b.len() { total_bits - 63 * idx as u64 } else { 63 };
            self.code.push(format!(
                "for(var j = 0; j < {bits}; j++) {{\n        {target}[q][b] <== {name}[j];\n        b++;\n        if(b == {}) {{\n            b = 0; \n            q++;\n        }}\n    }}",
                self.stark_info.stark_struct.steps[0].n_bits
            ));
            if bits == 63 {
                self.code.push(format!("_ <== {name}[63]; // Unused last bit\n"));
            } else {
                self.code.push(format!(
                    "for(var j = {bits}; j < 64; j++) {{\n        _ <== {name}[j]; // Unused bits        \n    }}"
                ));
            }
        }
    }

    pub fn take_code(&mut self) -> String {
        let mut out = String::new();
        for idx in self.last_code_printed..self.code.len() {
            line(&mut out, format_args!("    {}", self.code[idx]));
        }
        self.last_code_printed = self.code.len();
        out
    }

    pub(super) fn get_fields1(&mut self) -> String {
        if self.out.is_empty() {
            while self.pending.len()
                < 4 * (self.stark_info.stark_struct.merkle_tree_arity as usize - 1)
            {
                self.pending.push("0".to_string());
            }
            self.update_state();
        }
        let value = self.out.remove(0);
        self.hi_cnt += 1;
        value
    }

    fn add_one(&mut self, value: String) {
        self.out.clear();
        self.pending.push(value);
        if self.pending.len() == 4 * (self.stark_info.stark_struct.merkle_tree_arity as usize - 1) {
            self.update_state();
        }
    }

    fn update_state(&mut self) {
        let signal_name = self.signal_name();
        if self.h_cnt > 0 {
            let first_unused = self.hi_cnt.max(4);
            if first_unused < self.arity_words() {
                self.code.push(format!(
                    "for(var i = {first_unused}; i < {}; i++){{\n        _ <== {signal_name}_{}[i]; // Unused transcript values \n    }}",
                    self.arity_words(),
                    self.h_cnt - 1
                ));
            }
        }
        self.code.push(format!(
            "\n    signal {signal_name}_{}[{}] <== Poseidon2({}, {})([{}], [{}]);",
            self.h_cnt,
            self.arity_words(),
            self.stark_info.stark_struct.merkle_tree_arity,
            self.arity_words(),
            self.pending.join(","),
            self.state.join(",")
        ));
        self.out = (0..self.arity_words())
            .map(|idx| format!("{signal_name}_{}[{idx}]", self.h_cnt))
            .collect();
        self.state = (0..4).map(|idx| format!("{signal_name}_{}[{idx}]", self.h_cnt)).collect();
        self.h_cnt += 1;
        self.pending.clear();
        self.hi_cnt = 0;
    }

    fn signal_name(&self) -> String {
        if let Some(name) = &self.name {
            format!("transcriptHash_{name}")
        } else {
            "transcriptHash".to_string()
        }
    }

    fn arity_words(&self) -> usize {
        4 * self.stark_info.stark_struct.merkle_tree_arity as usize
    }
}
