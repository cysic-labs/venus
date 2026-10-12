//! Rendering of verifier expression code into Circom statements and chunked templates.

use super::*;

#[derive(Debug, Clone, PartialEq, Eq)]
#[allow(dead_code)]
pub struct ExpressionChunks {
    pub chunks: Vec<ExpressionChunk>,
    pub tmps: BTreeMap<u64, TmpInfo>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
#[allow(dead_code)]
pub struct ExpressionChunk {
    pub code: Vec<CircomCodeLine>,
    pub inputs: Vec<u64>,
    pub outputs: Vec<u64>,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[allow(dead_code)]
pub struct TmpInfo {
    pub last_pos: usize,
    pub dim: u64,
}

#[allow(dead_code)]
pub fn build_expression_chunks(code: &[CircomCodeLine], min_chunk_size: usize) -> ExpressionChunks {
    let mut tmps = BTreeMap::<u64, TmpInfo>::new();
    for (idx, inst) in code.iter().enumerate() {
        if inst.dest.ref_type == "tmp" {
            if let Some(id) = inst.dest.id {
                tmps.insert(id, TmpInfo { last_pos: idx, dim: inst.dest.dim });
            }
        }
        for src in &inst.src {
            if src.ref_type == "tmp" {
                if let Some(id) = src.id {
                    if let Some(tmp) = tmps.get_mut(&id) {
                        tmp.last_pos = idx;
                    }
                }
            }
        }
    }

    let mut chunks = Vec::new();
    let mut current = Vec::new();
    let mut live_tmps = BTreeSet::<u64>::new();
    let mut previous_live_tmps = BTreeSet::<u64>::new();
    let mut inputs = BTreeSet::<u64>::new();
    let mut outputs = BTreeSet::<u64>::new();

    for (idx, inst) in code.iter().enumerate() {
        current.push(inst.clone());
        if inst.dest.ref_type == "tmp" {
            if let Some(id) = inst.dest.id {
                live_tmps.insert(id);
                outputs.insert(id);
            }
        }
        for src in &inst.src {
            if src.ref_type != "tmp" {
                continue;
            }
            let Some(id) = src.id else {
                continue;
            };
            let is_last = tmps.get(&id).map(|tmp| tmp.last_pos == idx).unwrap_or(false);
            if is_last {
                live_tmps.remove(&id);
                outputs.remove(&id);
            }
            if previous_live_tmps.contains(&id) {
                inputs.insert(id);
                if is_last {
                    previous_live_tmps.remove(&id);
                }
            }
        }

        if current.len() + 1 >= min_chunk_size {
            chunks.push(ExpressionChunk {
                code: std::mem::take(&mut current),
                inputs: inputs.iter().copied().collect(),
                outputs: outputs.iter().copied().collect(),
            });
            previous_live_tmps.extend(live_tmps.iter().copied());
            live_tmps.clear();
            inputs.clear();
            outputs.clear();
        }
    }
    if !current.is_empty() {
        chunks.push(ExpressionChunk {
            code: current,
            inputs: inputs.iter().copied().collect(),
            outputs: outputs.iter().copied().collect(),
        });
    }

    ExpressionChunks { chunks, tmps }
}

#[allow(dead_code)]
pub fn render_unrolled_code(
    stark_info: &CircomStarkInfo,
    code: &[CircomCodeLine],
    initialized: &[u64],
) -> String {
    let initialized = initialized.iter().copied().collect::<BTreeSet<_>>();
    let mut out = String::new();
    for inst in code {
        let dest = render_ref(stark_info, &inst.dest, true, &initialized);
        let lhs = inst.src.first().expect("missing first source");
        let rhs = inst.src.get(1);
        let lhs_dim = ref_dim(lhs);
        let rhs_dim = rhs.map(ref_dim);
        match inst.op.as_str() {
            "add" => render_binary_op(
                &mut out,
                "+",
                &dest,
                stark_info,
                lhs,
                rhs.expect("missing rhs"),
                lhs_dim,
                rhs_dim.unwrap(),
            ),
            "sub" => render_sub(
                &mut out,
                &dest,
                stark_info,
                lhs,
                rhs.expect("missing rhs"),
                lhs_dim,
                rhs_dim.unwrap(),
            ),
            "mul" => render_mul(
                &mut out,
                &dest,
                stark_info,
                lhs,
                rhs.expect("missing rhs"),
                lhs_dim,
                rhs_dim.unwrap(),
            ),
            "copy" => {
                line(
                    &mut out,
                    format_args!(
                        "    {dest} <== {};",
                        render_ref(stark_info, lhs, false, &initialized)
                    ),
                );
            }
            op => panic!("unsupported verifier instruction op {op}"),
        }
    }
    out
}

pub(super) fn render_global_unrolled_code(code: &[CircomCodeLine], initialized: &[u64]) -> String {
    let initialized = initialized.iter().copied().collect::<BTreeSet<_>>();
    let mut out = String::new();
    for inst in code {
        let dest = render_global_ref(&inst.dest, true, &initialized);
        let lhs = inst.src.first().expect("missing first source");
        let rhs = inst.src.get(1);
        let lhs_dim = ref_dim(lhs);
        let rhs_dim = rhs.map(ref_dim);
        match inst.op.as_str() {
            "add" => render_global_binary_op(
                &mut out,
                "+",
                &dest,
                lhs,
                rhs.expect("missing rhs"),
                lhs_dim,
                rhs_dim.unwrap(),
            ),
            "sub" => render_global_sub(
                &mut out,
                &dest,
                lhs,
                rhs.expect("missing rhs"),
                lhs_dim,
                rhs_dim.unwrap(),
            ),
            "mul" => render_global_mul(
                &mut out,
                &dest,
                lhs,
                rhs.expect("missing rhs"),
                lhs_dim,
                rhs_dim.unwrap(),
            ),
            "copy" => {
                line(
                    &mut out,
                    format_args!("    {dest} <== {};", render_global_ref(lhs, false, &initialized)),
                );
            }
            op => panic!("unsupported global constraint instruction op {op}"),
        }
    }
    out
}

pub(super) fn render_tmp_declaration(
    out: &mut String,
    qualifier: &str,
    tmp_id: u64,
    tmps: &BTreeMap<u64, TmpInfo>,
) {
    let dim = tmps.get(&tmp_id).expect("tmp declaration").dim;
    let qualifier = if qualifier.is_empty() { String::new() } else { format!("{qualifier} ") };
    render_tmp_declaration_with_name(out, &qualifier, &format!("tmp_{tmp_id}"), dim);
}

pub(super) fn render_tmp_declaration_with_name(
    out: &mut String,
    qualifier: &str,
    name: &str,
    dim: u64,
) {
    if dim == 1 {
        line(out, format_args!("    signal {qualifier}{name};"));
    } else {
        line(out, format_args!("    signal {qualifier}{name}[3];"));
    }
}

pub(super) fn join_tmp_names(ids: &[u64]) -> String {
    ids.iter().map(|id| format!("tmp_{id}")).collect::<Vec<_>>().join(",")
}

pub(super) fn last_dest_tmp_id(code: &[CircomCodeLine]) -> u64 {
    code.last().and_then(|line| line.dest.id).expect("verifier expression result tmp")
}

pub(super) fn render_global_binary_op(
    out: &mut String,
    op: &str,
    dest: &str,
    lhs: &CircomCodeRef,
    rhs: &CircomCodeRef,
    lhs_dim: u64,
    rhs_dim: u64,
) {
    let lhs_ref = render_global_ref(lhs, false, &BTreeSet::new());
    let rhs_ref = render_global_ref(rhs, false, &BTreeSet::new());
    match (lhs_dim, rhs_dim) {
        (1, 1) => line(out, format_args!("    {dest} <== {lhs_ref} {op} {rhs_ref};")),
        (1, 3) => line(
            out,
            format_args!(
                "    {dest} <== [{lhs_ref} {op} {rhs_ref}[0], {rhs_ref}[1],  {rhs_ref}[2]];"
            ),
        ),
        (3, 1) => line(
            out,
            format_args!(
                "    {dest} <== [{lhs_ref}[0] {op} {rhs_ref}, {lhs_ref}[1], {lhs_ref}[2]];"
            ),
        ),
        (3, 3) => line(
            out,
            format_args!(
                "    {dest} <== [{lhs_ref}[0] {op} {rhs_ref}[0], {lhs_ref}[1] {op} {rhs_ref}[1], {lhs_ref}[2] {op} {rhs_ref}[2]];"
            ),
        ),
        _ => panic!("unsupported global binary op dimensions {lhs_dim}, {rhs_dim}"),
    }
}

pub(super) fn render_global_sub(
    out: &mut String,
    dest: &str,
    lhs: &CircomCodeRef,
    rhs: &CircomCodeRef,
    lhs_dim: u64,
    rhs_dim: u64,
) {
    let lhs_ref = render_global_ref(lhs, false, &BTreeSet::new());
    let rhs_ref = render_global_ref(rhs, false, &BTreeSet::new());
    match (lhs_dim, rhs_dim) {
        (1, 1) => line(out, format_args!("    {dest} <== {lhs_ref} - {rhs_ref};")),
        (1, 3) => line(
            out,
            format_args!("    {dest} <== [{lhs_ref} - {rhs_ref}[0], -{rhs_ref}[1], -{rhs_ref}[2]];"),
        ),
        (3, 1) => line(
            out,
            format_args!("    {dest} <== [{lhs_ref}[0] - {rhs_ref}, {lhs_ref}[1], {lhs_ref}[2]];"),
        ),
        (3, 3) => line(
            out,
            format_args!(
                "    {dest} <== [{lhs_ref}[0] - {rhs_ref}[0], {lhs_ref}[1] - {rhs_ref}[1], {lhs_ref}[2] - {rhs_ref}[2]];"
            ),
        ),
        _ => panic!("unsupported global subtraction dimensions {lhs_dim}, {rhs_dim}"),
    }
}

pub(super) fn render_global_mul(
    out: &mut String,
    dest: &str,
    lhs: &CircomCodeRef,
    rhs: &CircomCodeRef,
    lhs_dim: u64,
    rhs_dim: u64,
) {
    let lhs_ref = render_global_ref(lhs, false, &BTreeSet::new());
    let rhs_ref = render_global_ref(rhs, false, &BTreeSet::new());
    match (lhs_dim, rhs_dim) {
        (1, 1) => line(out, format_args!("    {dest} <== {lhs_ref} * {rhs_ref};")),
        (1, 3) => line(
            out,
            format_args!(
                "    {dest} <== [{lhs_ref} * {rhs_ref}[0], {lhs_ref} * {rhs_ref}[1], {lhs_ref} * {rhs_ref}[2]];"
            ),
        ),
        (3, 1) => line(
            out,
            format_args!(
                "    {dest} <== [{lhs_ref}[0] * {rhs_ref}, {lhs_ref}[1] * {rhs_ref}, {lhs_ref}[2] * {rhs_ref}];"
            ),
        ),
        (3, 3) => line(out, format_args!("    {dest} <== CMul()({lhs_ref}, {rhs_ref});")),
        _ => panic!("unsupported global multiplication dimensions {lhs_dim}, {rhs_dim}"),
    }
}

pub(super) fn render_global_ref(
    reference: &CircomCodeRef,
    dest: bool,
    initialized: &BTreeSet<u64>,
) -> String {
    match reference.ref_type.as_str() {
        "public" => format!("publics[{}]", reference.id.expect("public id")),
        "proofvalue" => {
            if reference.dim == 1 {
                format!("proofValues[{}][0]", reference.id.expect("proofvalue id"))
            } else {
                format!("proofValues[{}]", reference.id.expect("proofvalue id"))
            }
        }
        "tmp" => {
            let id = reference.id.expect("tmp id");
            if dest && !initialized.contains(&id) {
                if reference.dim == 1 {
                    format!("signal tmp_{id}")
                } else {
                    format!("signal tmp_{id}[3]")
                }
            } else {
                format!("tmp_{id}")
            }
        }
        "number" => reference.value.clone().expect("number value"),
        "challenge" => format!("challenges[{}]", reference.id.expect("challenge id")),
        "airgroupvalue" => format!(
            "s{}_airgroupvalues[{}]",
            reference.airgroup_id.unwrap_or(0),
            reference.id.expect("airgroupvalue id")
        ),
        other => panic!("unsupported global constraint reference {other}"),
    }
}

pub(super) fn render_binary_op(
    out: &mut String,
    op: &str,
    dest: &str,
    stark_info: &CircomStarkInfo,
    lhs: &CircomCodeRef,
    rhs: &CircomCodeRef,
    lhs_dim: u64,
    rhs_dim: u64,
) {
    let lhs = render_ref(stark_info, lhs, false, &BTreeSet::new());
    let rhs = render_ref(stark_info, rhs, false, &BTreeSet::new());
    match (lhs_dim, rhs_dim) {
        (1, 1) => line(out, format_args!("    {dest} <== {lhs} {op} {rhs};")),
        (1, 3) if op == "+" => {
            line(out, format_args!("    {dest} <== [{lhs} + {rhs}[0], {rhs}[1],  {rhs}[2]];"))
        }
        (3, 1) if op == "+" => {
            line(out, format_args!("    {dest} <== [{lhs}[0] + {rhs}, {lhs}[1], {lhs}[2]];"))
        }
        (3, 3) => line(
            out,
            format_args!(
                "    {dest} <== [{lhs}[0] {op} {rhs}[0], {lhs}[1] {op} {rhs}[1], {lhs}[2] {op} {rhs}[2]];"
            ),
        ),
        _ => panic!("unsupported dimensions {lhs_dim}, {rhs_dim}"),
    }
}

pub(super) fn render_sub(
    out: &mut String,
    dest: &str,
    stark_info: &CircomStarkInfo,
    lhs: &CircomCodeRef,
    rhs: &CircomCodeRef,
    lhs_dim: u64,
    rhs_dim: u64,
) {
    let lhs_ref = render_ref(stark_info, lhs, false, &BTreeSet::new());
    let rhs_ref = render_ref(stark_info, rhs, false, &BTreeSet::new());
    match (lhs_dim, rhs_dim) {
        (1, 1) => line(out, format_args!("    {dest} <== {lhs_ref} - {rhs_ref};")),
        (1, 3) => line(
            out,
            format_args!("    {dest} <== [{lhs_ref} - {rhs_ref}[0], -{rhs_ref}[1], -{rhs_ref}[2]];"),
        ),
        (3, 1) => line(
            out,
            format_args!("    {dest} <== [{lhs_ref}[0] - {rhs_ref}, {lhs_ref}[1], {lhs_ref}[2]];"),
        ),
        (3, 3) => line(
            out,
            format_args!(
                "    {dest} <== [{lhs_ref}[0] - {rhs_ref}[0], {lhs_ref}[1] - {rhs_ref}[1], {lhs_ref}[2] - {rhs_ref}[2]];"
            ),
        ),
        _ => panic!("unsupported subtraction dimensions {lhs_dim}, {rhs_dim}"),
    }
}

pub(super) fn render_mul(
    out: &mut String,
    dest: &str,
    stark_info: &CircomStarkInfo,
    lhs: &CircomCodeRef,
    rhs: &CircomCodeRef,
    lhs_dim: u64,
    rhs_dim: u64,
) {
    let lhs_ref = render_ref(stark_info, lhs, false, &BTreeSet::new());
    let rhs_ref = render_ref(stark_info, rhs, false, &BTreeSet::new());
    match (lhs_dim, rhs_dim) {
        (1, 1) => line(out, format_args!("    {dest} <== {lhs_ref} * {rhs_ref};")),
        (1, 3) => line(
            out,
            format_args!("    {dest} <== [{lhs_ref} * {rhs_ref}[0], {lhs_ref} * {rhs_ref}[1], {lhs_ref} * {rhs_ref}[2]];"),
        ),
        (3, 1) => line(
            out,
            format_args!("    {dest} <== [{lhs_ref}[0] * {rhs_ref}, {lhs_ref}[1] * {rhs_ref}, {lhs_ref}[2] * {rhs_ref}];"),
        ),
        (3, 3) => line(out, format_args!("    {dest} <== CMul()({lhs_ref}, {rhs_ref});")),
        _ => panic!("unsupported multiplication dimensions {lhs_dim}, {rhs_dim}"),
    }
}

pub(super) fn render_ref(
    stark_info: &CircomStarkInfo,
    reference: &CircomCodeRef,
    dest: bool,
    initialized: &BTreeSet<u64>,
) -> String {
    match reference.ref_type.as_str() {
        "eval" => format!("evals[{}]", reference.id.expect("eval id")),
        "challenge" => {
            let stage = reference.stage.expect("challenge stage");
            let stage_id = reference.stage_id.expect("challenge stageId");
            let q_stage = stark_info.n_stages as u64 + 1;
            let evals_stage = stark_info.n_stages as u64 + 2;
            let fri_stage = stark_info.n_stages as u64 + 3;
            if stage == q_stage {
                "challengeQ".to_string()
            } else if stage == evals_stage {
                "challengeXi".to_string()
            } else if stage == fri_stage {
                format!("challengesFRI[{stage_id}]")
            } else {
                format!("challengesStage{stage}[{stage_id}]")
            }
        }
        "public" => format!("publics[{}]", reference.id.expect("public id")),
        "x" => "challengeXi".to_string(),
        "Zi" => {
            let boundary =
                &stark_info.boundaries[reference.boundary_id.expect("boundary id") as usize];
            match boundary.name.as_str() {
                "everyRow" => "Zh".to_string(),
                "firstRow" => "Zfirst".to_string(),
                "lastRow" => "Zlast".to_string(),
                "everyFrame" => {
                    let offset_min = boundary.offset_min.unwrap_or(0);
                    let offset_max = boundary.offset_max.unwrap_or(0);
                    let boundary_id = stark_info
                        .boundaries
                        .iter()
                        .filter(|boundary| boundary.name == "everyFrame")
                        .position(|candidate| {
                            candidate.offset_min.unwrap_or(0) == offset_min
                                && candidate.offset_max.unwrap_or(0) == offset_max
                        })
                        .expect("frame boundary");
                    format!("Zframe{boundary_id}[{}]", offset_min + offset_max - 1)
                }
                other => panic!("unsupported boundary {other}"),
            }
        }
        "xDivXSubXi" => format!("xDivXSubXi[{}]", reference.id.expect("xDivXSubXi id")),
        "tmp" => {
            let id = reference.id.expect("tmp id");
            if dest && !initialized.contains(&id) {
                if reference.dim == 1 {
                    format!("signal tmp_{id}")
                } else {
                    format!("signal tmp_{id}[3]")
                }
            } else {
                format!("tmp_{id}")
            }
        }
        "cm" => {
            let pol = &stark_info.cm_pols_map[reference.id.expect("cm id") as usize];
            format!("mapValues.cm{}_{}", pol.stage, pol.stage_id.expect("cm stageId"))
        }
        "custom" => {
            let commit_id = reference.commit_id.expect("custom commit id") as usize;
            let pol = &stark_info.custom_commits_map[commit_id]
                [reference.id.expect("custom id") as usize];
            format!(
                "mapValues.custom_{}_{}_{}",
                stark_info.custom_commits[commit_id].name,
                pol.stage,
                pol.stage_id.expect("custom stageId")
            )
        }
        "const" => format!("consts[{}]", reference.id.expect("const id")),
        "number" => reference.value.clone().expect("number value"),
        "airgroupvalue" => format!("airgroupvalues[{}]", reference.id.expect("airgroupvalue id")),
        "airvalue" => {
            if reference.dim == 1 {
                format!("airvalues[{}][0]", reference.id.expect("airvalue id"))
            } else {
                format!("airvalues[{}]", reference.id.expect("airvalue id"))
            }
        }
        "proofvalue" => {
            if reference.dim == 1 {
                format!("proofvalues[{}][0]", reference.id.expect("proofvalue id"))
            } else {
                format!("proofvalues[{}]", reference.id.expect("proofvalue id"))
            }
        }
        other => panic!("unsupported verifier reference {other}"),
    }
}

pub(super) fn ref_dim(reference: &CircomCodeRef) -> u64 {
    if reference.ref_type == "Zi" || reference.ref_type == "airgroupvalue" {
        3
    } else {
        reference.dim
    }
}
