//! Renders the native Rust STARK verifiers checked in under `pil2-proofman/verifier/src`.
//!
//! Those verifiers hardcode the constraint (`q_verify`) and FRI query (`query_verify`) polynomials
//! of a recursive AIR together with its proof layout, so they are derived here from the setup's
//! STARK info and verifier code and must be regenerated whenever the recursive AIRs change.

use std::fmt::Write as _;

use anyhow::{bail, Context, Result};

use crate::pil_info::binfile::{compact_tmp_ids, IdMaps};
use crate::recursive_circom::{CircomCodeLine, CircomCodeRef, CircomStarkInfo, CircomVerifierInfo};

const GOLDILOCKS_P: i128 = 0xFFFF_FFFF_0000_0001;
const FIELD_EXTENSION: u64 = 3;

/// The stage count `stark_verify` transcribes.
const NATIVE_N_STAGES: usize = 2;
/// The challenges `stark_verify` draws, as (stage, stage id) in transcript order: two for stage 2,
/// one for the quotient stage, the evaluation point and the two FRI challenges.
const NATIVE_CHALLENGES: [(u64, u64); 6] = [(2, 0), (2, 1), (3, 0), (4, 0), (5, 0), (5, 1)];
/// The transcript arity of `stark_verify`'s Poseidon16 transcript.
const NATIVE_TRANSCRIPT_ARITY: u64 = 4;
/// The only zerofier `stark_verify` computes.
const NATIVE_BOUNDARY: &str = "everyRow";

/// Public entry points of a rendered verifier module.
#[derive(Debug, Clone, Copy)]
pub struct RustVerifierEntry {
    /// Name of the entry point that takes a `VadcopFinalProof`.
    pub name: &'static str,
    /// Also emit `<name>_bytes`, which takes a proof already prefixed with its publics.
    pub with_bytes_entry: bool,
}

pub fn render_rust_verifier(
    stark_info: &CircomStarkInfo,
    verifier_info: &CircomVerifierInfo,
    entry: RustVerifierEntry,
) -> Result<String> {
    check_native_shape(stark_info)?;
    let width = stark_info.stark_struct.merkle_tree_arity * 4;
    let mut out = String::new();
    writeln!(out, "use fields::{{Goldilocks, CubicExtensionField, Field, Poseidon{width}}};")?;
    writeln!(out, "use crate::{{Boundary, VerifierInfo, stark_verify}};")?;
    writeln!(out, "use proofman_util::VadcopFinalProof;")?;
    writeln!(out)?;

    writeln!(out, "#[rustfmt::skip]")?;
    writeln!(out, "#[allow(clippy::all)]")?;
    writeln!(out, "fn q_verify(challenges: &[CubicExtensionField<Goldilocks>], evals: &[CubicExtensionField<Goldilocks>], _publics: &[Goldilocks], zi: &[CubicExtensionField<Goldilocks>]) -> CubicExtensionField<Goldilocks> {{")?;
    render_code(&mut out, stark_info, &verifier_info.q_verifier.code)
        .context("failed to render q_verify")?;
    writeln!(out, "}}")?;
    writeln!(out)?;

    writeln!(out, "#[rustfmt::skip]")?;
    writeln!(out, "#[allow(clippy::all)]")?;
    writeln!(out, "fn query_verify(challenges: &[CubicExtensionField<Goldilocks>], evals: &[CubicExtensionField<Goldilocks>], vals: &[Vec<Goldilocks>], xdivxsub: &[CubicExtensionField<Goldilocks>]) -> CubicExtensionField<Goldilocks> {{")?;
    render_code(&mut out, stark_info, &verifier_info.query_verifier.block.code)
        .context("failed to render query_verify")?;
    writeln!(out, "}}")?;
    writeln!(out)?;

    render_verifier_info(&mut out, stark_info)?;
    writeln!(out)?;

    let verify = format!("stark_verify::<Poseidon{width}, {width}>");
    writeln!(out, "pub fn {}(proof: &VadcopFinalProof, vk: &[u8]) -> bool {{", entry.name)?;
    writeln!(
        out,
        "    {verify}(&proof.proof_with_publics(), vk, &verifier_info(), q_verify, query_verify)"
    )?;
    writeln!(out, "}}")?;
    if entry.with_bytes_entry {
        writeln!(out)?;
        writeln!(out, "pub fn {}_bytes(proof: &[u8], vk: &[u8]) -> bool {{", entry.name)?;
        writeln!(out, "    {verify}(proof, vk, &verifier_info(), q_verify, query_verify)")?;
        writeln!(out, "}}")?;
    }
    Ok(out)
}

/// Rejects setups `stark_verify` would verify wrongly: it implements a fixed transcript and proof
/// layout rather than reading them from the setup.
fn check_native_shape(stark_info: &CircomStarkInfo) -> Result<()> {
    let stark_struct = &stark_info.stark_struct;
    if stark_struct.verification_hash_type != "GL" {
        bail!(
            "the native verifier only verifies GL proofs, not {}",
            stark_struct.verification_hash_type
        );
    }
    if stark_struct.transcript_arity != NATIVE_TRANSCRIPT_ARITY {
        bail!(
            "the native verifier's transcript has arity {NATIVE_TRANSCRIPT_ARITY}, not {}",
            stark_struct.transcript_arity
        );
    }
    if stark_info.n_stages != NATIVE_N_STAGES {
        bail!(
            "the native verifier transcribes {NATIVE_N_STAGES} stages, not {}",
            stark_info.n_stages
        );
    }
    let challenges =
        stark_info.challenges_map.iter().map(|c| (c.stage, c.stage_id)).collect::<Vec<_>>();
    if challenges != NATIVE_CHALLENGES {
        bail!(
            "the native verifier draws the challenges {NATIVE_CHALLENGES:?} as (stage, stageId), \
             not {challenges:?}"
        );
    }
    if let Some(boundary) = stark_info.boundaries.iter().find(|b| b.name != NATIVE_BOUNDARY) {
        bail!(
            "the native verifier only computes the {NATIVE_BOUNDARY} zerofier, not {}",
            boundary.name
        );
    }
    if !stark_info.custom_commits.is_empty()
        || !stark_info.air_values_map.is_empty()
        || !stark_info.airgroup_values_map.is_empty()
        || !stark_info.proof_values_map.is_empty()
    {
        bail!("the native verifier reads no custom commits, air values, airgroup values or proof values");
    }
    if stark_struct.last_level_verification == 0 {
        bail!("the native verifier requires last-level Merkle verification");
    }
    if !(1..u64::BITS as u64).contains(&stark_struct.pow_bits) {
        bail!("the native verifier requires 1 to 63 grinding bits, not {}", stark_struct.pow_bits);
    }

    // The queries index the extended domain, every fold must shrink it, and the terminal layer must
    // be at least the blowup for the final polynomial to bound a degree.
    let steps = stark_struct.steps.iter().map(|step| step.n_bits).collect::<Vec<_>>();
    let Some(&terminal_bits) = steps.last() else {
        bail!("the native verifier requires FRI steps");
    };
    if steps[0] != stark_struct.n_bits_ext {
        bail!("the first FRI step has {} bits, not nBitsExt {}", steps[0], stark_struct.n_bits_ext);
    }
    if steps.windows(2).any(|pair| pair[1] >= pair[0]) {
        bail!("FRI steps {steps:?} must strictly decrease");
    }
    let blowup_bits = stark_struct
        .n_bits_ext
        .checked_sub(stark_struct.n_bits)
        .context("nBits exceeds nBitsExt")?;
    if terminal_bits < blowup_bits {
        bail!(
            "the FRI terminal layer 2^{terminal_bits} is smaller than the blowup 2^{blowup_bits}"
        );
    }
    Ok(())
}

fn render_code(
    out: &mut String,
    stark_info: &CircomStarkInfo,
    code: &[CircomCodeLine],
) -> Result<()> {
    let ids = compact_tmp_ids(code.iter().map(|line| {
        std::iter::once(&line.dest)
            .chain(&line.src)
            .filter(|reference| reference.ref_type == "tmp")
            .map(|reference| Ok((reference.id.context("tmp reference missing id")?, reference.dim)))
            .collect::<Result<Vec<_>>>()
    }))?;
    if ids.count1d > 0 {
        writeln!(out, "    let mut tmp_1 = vec![Goldilocks::ZERO; {}];", ids.count1d)?;
    }
    if ids.count3d > 0 {
        writeln!(out, "    let mut tmp_3 = vec![CubicExtensionField {{ value: [Goldilocks::ZERO, Goldilocks::ZERO, Goldilocks::ZERO] }}; {}];", ids.count3d)?;
    }

    for line in code {
        let dest = operand(stark_info, &ids, &line.dest)?;
        let src = line
            .src
            .iter()
            .map(|reference| operand(stark_info, &ids, reference))
            .collect::<Result<Vec<_>>>()?;
        // Mixed base/extension operations are written with the extension operand on the left.
        let scalar_first =
            line.src.len() == 2 && line.src[0].dim == 1 && line.src[1].dim == FIELD_EXTENSION;
        let value = match (line.op.as_str(), src.as_slice()) {
            ("copy", [value]) => value.clone(),
            ("add", [lhs, rhs]) if scalar_first => format!("{rhs} + {lhs}"),
            ("add", [lhs, rhs]) => format!("{lhs} + {rhs}"),
            ("mul", [lhs, rhs]) if scalar_first => format!("{rhs} * {lhs}"),
            ("mul", [lhs, rhs]) => format!("{lhs} * {rhs}"),
            ("sub", [lhs, rhs]) if scalar_first => format!("{rhs}.sub_from_scalar({lhs})"),
            ("sub", [lhs, rhs]) => format!("{lhs} - {rhs}"),
            (op, _) => bail!("unsupported verifier operation {op} with {} operands", src.len()),
        };
        writeln!(out, "    {dest} = {value};")?;
    }

    let result = &code.last().context("empty verifier code")?.dest;
    if result.ref_type != "tmp" {
        bail!("verifier code must end in a temporary, found {}", result.ref_type);
    }
    writeln!(out, "    return {};", operand(stark_info, &ids, result)?)?;
    Ok(())
}

fn operand(
    stark_info: &CircomStarkInfo,
    ids: &IdMaps,
    reference: &CircomCodeRef,
) -> Result<String> {
    let id =
        || reference.id.with_context(|| format!("{} reference missing id", reference.ref_type));
    Ok(match reference.ref_type.as_str() {
        "tmp" => match reference.dim {
            1 => format!("tmp_1[{}]", ids.id1d[&id()?]),
            FIELD_EXTENSION => format!("tmp_3[{}]", ids.id3d[&id()?]),
            dim => bail!("invalid tmp dimension {dim}"),
        },
        "const" => format!("vals[0][{}]", id()?),
        "cm" => {
            let pol = stark_info
                .cm_pols_map
                .get(id()? as usize)
                .with_context(|| format!("cm reference {} out of range", id().unwrap_or(0)))?;
            let stage_pos = pol.stage_pos.context("committed polynomial missing stagePos")?;
            match reference.dim {
                1 => format!("vals[{}][{stage_pos}]", pol.stage),
                FIELD_EXTENSION => format!(
                    "CubicExtensionField {{ value: [vals[{stage}][{stage_pos}], vals[{stage}][{}], vals[{stage}][{}]] }}",
                    stage_pos + 1,
                    stage_pos + 2,
                    stage = pol.stage
                ),
                dim => bail!("invalid committed polynomial dimension {dim}"),
            }
        }
        "custom" => {
            let commit_id = reference.commit_id.context("custom reference missing commitId")?;
            format!("vals[{}][{}]", stark_info.n_stages as u64 + 1 + commit_id, id()?)
        }
        "public" => format!("_publics[{}]", id()?),
        "eval" => format!("evals[{}]", id()?),
        "challenge" => format!("challenges[{}]", id()?),
        "number" => {
            let value = reference.value.as_deref().context("number reference missing value")?;
            let value: i128 = value.parse().with_context(|| format!("invalid number {value}"))?;
            format!("Goldilocks::new({})", value.rem_euclid(GOLDILOCKS_P))
        }
        "Zi" => {
            format!("zi[{}]", reference.boundary_id.context("Zi reference missing boundaryId")?)
        }
        "xDivXSubXi" => format!("xdivxsub[{}]", id()?),
        other => bail!("{other} references are not supported by the native verifier"),
    })
}

fn render_verifier_info(out: &mut String, stark_info: &CircomStarkInfo) -> Result<()> {
    let stark_struct = &stark_info.stark_struct;
    let n_queries = stark_struct.n_queries.context("starkStruct missing nQueries")?;
    let num_vals = (1..=stark_info.n_stages + 1)
        .map(|stage| {
            stark_info
                .map_sections_n
                .get(&format!("cm{stage}"))
                .copied()
                .with_context(|| format!("mapSectionsN missing cm{stage}"))
        })
        .collect::<Result<Vec<_>>>()?;
    let q_stage = stark_info.n_stages as u64 + 1;
    let q_pol = stark_info
        .cm_pols_map
        .iter()
        .position(|pol| pol.stage == q_stage && pol.stage_id == Some(0))
        .context("q polynomial not found in cmPolsMap")?;
    let q_index = stark_info
        .ev_map
        .iter()
        .position(|ev| ev.ev_type == "cm" && ev.id == q_pol as u64)
        .context("q polynomial evaluation not found in evMap")?;
    // stark_verify reads the quotient pieces as the qDeg evaluations from q_index on.
    for piece in 0..stark_info.q_deg {
        let index = q_index + piece as usize;
        let is_piece = stark_info.ev_map.get(index).is_some_and(|ev| {
            ev.ev_type == "cm"
                && ev.prime == 0
                && stark_info
                    .cm_pols_map
                    .get(ev.id as usize)
                    .is_some_and(|pol| pol.stage == q_stage && pol.stage_id == Some(piece))
        });
        if !is_piece {
            bail!("evaluation {index} is not quotient piece {piece} at the evaluation point");
        }
    }
    let optional = |value: Option<u32>| value.map_or("None".to_string(), |v| format!("Some({v})"));
    let boundaries = stark_info
        .boundaries
        .iter()
        .map(|boundary| {
            format!(
                "Boundary {{ name: \"{}\".to_string(), offset_min: {}, offset_max: {} }}",
                boundary.name,
                optional(boundary.offset_min),
                optional(boundary.offset_max)
            )
        })
        .collect::<Vec<_>>();
    let join = |values: Vec<String>| values.join(", ");

    writeln!(out, "#[rustfmt::skip]")?;
    writeln!(out, "fn verifier_info() -> VerifierInfo {{")?;
    writeln!(out, "    VerifierInfo {{")?;
    writeln!(out, "        n_stages: {},", stark_info.n_stages)?;
    writeln!(out, "        n_publics: {},", stark_info.n_publics)?;
    writeln!(out, "        n_constants: {},", stark_info.n_constants)?;
    writeln!(out, "        n_evals: {},", stark_info.ev_map.len())?;
    writeln!(out, "        n_bits: {},", stark_struct.n_bits)?;
    writeln!(out, "        n_bits_ext: {},", stark_struct.n_bits_ext)?;
    writeln!(out, "        arity: {},", stark_struct.merkle_tree_arity)?;
    writeln!(out, "        n_fri_queries: {n_queries},")?;
    writeln!(out, "        n_fri_steps: {},", stark_struct.steps.len())?;
    writeln!(out, "        n_challenges: {},", stark_info.challenges_map.len())?;
    writeln!(
        out,
        "        n_challenges_total: {},",
        stark_info.challenges_map.len() + stark_struct.steps.len() + 1
    )?;
    writeln!(
        out,
        "        fri_steps: vec![{}],",
        join(stark_struct.steps.iter().map(|step| step.n_bits.to_string()).collect())
    )?;
    writeln!(out, "        hash_commits: {},", stark_struct.hash_commits)?;
    writeln!(out, "        last_level_verification: {},", stark_struct.last_level_verification)?;
    writeln!(out, "        pow_bits: {},", stark_struct.pow_bits)?;
    writeln!(
        out,
        "        num_vals: vec![{}],",
        join(num_vals.iter().map(u64::to_string).collect())
    )?;
    writeln!(
        out,
        "        opening_points: vec![{}],",
        join(stark_info.opening_points.iter().map(i64::to_string).collect())
    )?;
    writeln!(out, "        boundaries: vec![{}],", boundaries.join(", "))?;
    writeln!(out, "        q_deg: {},", stark_info.q_deg)?;
    writeln!(out, "        q_index: {q_index},")?;
    writeln!(out, "    }}")?;
    writeln!(out, "}}")?;
    Ok(())
}
