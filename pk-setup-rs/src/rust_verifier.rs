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
