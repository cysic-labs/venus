//! Per-AIR golden diff oracle for the pure-Rust pk-gen pipeline.
//!
//! Walks two `build/provingKey` trees and prints a per-AIR diff
//! table covering the dimensions that drive recursive1
//! `VerifyEvaluations0` and `pil2-stark-setup::im_polynomials`'s
//! greedy intermediate-polynomial selection.
//!
//! Usage:
//!     venus-golden-diff-oracle \
//!         --cur build/provingKey \
//!         --gold temp/golden_references/provingKey \
//!         [--json out.json] \
//!         [--airgroup zisk] [--airgroup-name Zisk]
//!
//! Plain text goes to stdout. When `--json` is supplied, the
//! same data is also written to that path so the round summary
//! can quote it verbatim.
//!
//! Exit status is 0 if every AIR matches gold on every column
//! the oracle inspects, 1 otherwise. CI / round summaries can
//! gate on the exit code.

use std::collections::BTreeMap;
use std::fs;
use std::path::{Path, PathBuf};

use serde::Serialize;
use serde_json::Value as JsonValue;

#[derive(Debug, Clone, Serialize)]
struct AirRow {
    name: String,
    cur_present: bool,
    gold_present: bool,
    c_exp_id_cur: Option<u64>,
    c_exp_id_gold: Option<u64>,
    q_deg_cur: Option<u64>,
    q_deg_gold: Option<u64>,
    n_constraints_cur: Option<u64>,
    n_constraints_gold: Option<u64>,
    cm_pols_stage2_cur: usize,
    cm_pols_stage2_gold: usize,
    impol_count_cur: usize,
    impol_count_gold: usize,
    expressions_code_cur: usize,
    expressions_code_gold: usize,
    verdict: &'static str,
}

#[derive(Debug, Clone, Serialize)]
struct OracleReport {
    cur_root: String,
    gold_root: String,
    airgroup_dir: String,
    airgroup_name: String,
    rows: Vec<AirRow>,
    pass_count: usize,
    fail_count: usize,
    missing_count: usize,
}

fn parse_args() -> Result<Args, String> {
    let mut args_iter = std::env::args().skip(1);
    let mut cur: Option<PathBuf> = None;
    let mut gold: Option<PathBuf> = None;
    let mut json_out: Option<PathBuf> = None;
    let mut airgroup_dir = "zisk".to_string();
    let mut airgroup_name = "Zisk".to_string();
    while let Some(arg) = args_iter.next() {
        match arg.as_str() {
            "--cur" => cur = args_iter.next().map(PathBuf::from),
            "--gold" => gold = args_iter.next().map(PathBuf::from),
            "--json" => json_out = args_iter.next().map(PathBuf::from),
            "--airgroup" => {
                airgroup_dir = args_iter
                    .next()
                    .ok_or_else(|| "--airgroup requires a value".to_string())?;
            }
            "--airgroup-name" => {
                airgroup_name = args_iter
                    .next()
                    .ok_or_else(|| "--airgroup-name requires a value".to_string())?;
            }
            "-h" | "--help" => {
                print_help();
                std::process::exit(0);
            }
            other => return Err(format!("unknown argument: {other}")),
        }
    }
    let cur = cur.ok_or_else(|| "--cur is required".to_string())?;
    let gold = gold.ok_or_else(|| "--gold is required".to_string())?;
    Ok(Args {
        cur,
        gold,
        json_out,
        airgroup_dir,
        airgroup_name,
    })
}

fn print_help() {
    eprintln!(
        "venus-golden-diff-oracle --cur <build/provingKey> --gold <golden/build/provingKey> \
         [--json out.json] [--airgroup zisk] [--airgroup-name Zisk]"
    );
}

struct Args {
    cur: PathBuf,
    gold: PathBuf,
    json_out: Option<PathBuf>,
    airgroup_dir: String,
    airgroup_name: String,
}

fn airs_dir(root: &Path, airgroup_dir: &str, airgroup_name: &str) -> PathBuf {
    root.join(airgroup_dir).join(airgroup_name).join("airs")
}

fn list_airs(dir: &Path) -> Vec<String> {
    let mut out: Vec<String> = Vec::new();
    if let Ok(rd) = fs::read_dir(dir) {
        for entry in rd.flatten() {
            if let Ok(t) = entry.file_type() {
                if t.is_dir() {
                    if let Some(s) = entry.file_name().to_str() {
                        out.push(s.to_string());
                    }
                }
            }
        }
    }
    out.sort();
    out
}

fn load_starkinfo(root: &Path, airgroup_dir: &str, airgroup_name: &str, air: &str)
    -> Option<JsonValue>
{
    let p = airs_dir(root, airgroup_dir, airgroup_name)
        .join(air)
        .join("air")
        .join(format!("{air}.starkinfo.json"));
    let bytes = fs::read(&p).ok()?;
    serde_json::from_slice(&bytes).ok()
}

fn load_expressionsinfo(root: &Path, airgroup_dir: &str, airgroup_name: &str, air: &str)
    -> Option<JsonValue>
{
    let p = airs_dir(root, airgroup_dir, airgroup_name)
        .join(air)
        .join("air")
        .join(format!("{air}.expressionsinfo.json"));
    let bytes = fs::read(&p).ok()?;
    serde_json::from_slice(&bytes).ok()
}

fn count_stage2_pols(starkinfo: &JsonValue) -> usize {
    starkinfo
        .get("cmPolsMap")
        .and_then(|v| v.as_array())
        .map(|arr| {
            arr.iter()
                .filter(|p| p.get("stage").and_then(JsonValue::as_u64) == Some(2))
                .count()
        })
        .unwrap_or(0)
}

fn count_impols(starkinfo: &JsonValue) -> usize {
    starkinfo
        .get("cmPolsMap")
        .and_then(|v| v.as_array())
        .map(|arr| {
            arr.iter()
                .filter(|p| p.get("imPol").and_then(JsonValue::as_bool) == Some(true))
                .count()
        })
        .unwrap_or(0)
}

fn json_u64(v: &JsonValue, key: &str) -> Option<u64> {
    v.get(key).and_then(JsonValue::as_u64)
}

fn count_expressions_code(ei: &JsonValue) -> usize {
    ei.get("expressionsCode")
        .and_then(|v| v.as_array())
        .map(|a| a.len())
        .unwrap_or(0)
}

fn build_row(
    air: &str,
    cur_root: &Path,
    gold_root: &Path,
    airgroup_dir: &str,
    airgroup_name: &str,
) -> AirRow {
    let cur_si = load_starkinfo(cur_root, airgroup_dir, airgroup_name, air);
    let gold_si = load_starkinfo(gold_root, airgroup_dir, airgroup_name, air);
    let cur_ei = load_expressionsinfo(cur_root, airgroup_dir, airgroup_name, air);
    let gold_ei = load_expressionsinfo(gold_root, airgroup_dir, airgroup_name, air);
    let cur_present = cur_si.is_some();
    let gold_present = gold_si.is_some();
    let c_exp_id_cur = cur_si.as_ref().and_then(|v| json_u64(v, "cExpId"));
    let c_exp_id_gold = gold_si.as_ref().and_then(|v| json_u64(v, "cExpId"));
    let q_deg_cur = cur_si.as_ref().and_then(|v| json_u64(v, "qDeg"));
    let q_deg_gold = gold_si.as_ref().and_then(|v| json_u64(v, "qDeg"));
    let n_cons_cur = cur_si.as_ref().and_then(|v| json_u64(v, "nConstraints"));
    let n_cons_gold = gold_si.as_ref().and_then(|v| json_u64(v, "nConstraints"));
    let cm_stage2_cur = cur_si.as_ref().map(count_stage2_pols).unwrap_or(0);
    let cm_stage2_gold = gold_si.as_ref().map(count_stage2_pols).unwrap_or(0);
    let impol_cur = cur_si.as_ref().map(count_impols).unwrap_or(0);
    let impol_gold = gold_si.as_ref().map(count_impols).unwrap_or(0);
    let exprs_cur = cur_ei.as_ref().map(count_expressions_code).unwrap_or(0);
    let exprs_gold = gold_ei.as_ref().map(count_expressions_code).unwrap_or(0);

    let verdict: &'static str = if !cur_present || !gold_present {
        "MISSING"
    } else if q_deg_cur != q_deg_gold
        || n_cons_cur != n_cons_gold
        || cm_stage2_cur != cm_stage2_gold
        || impol_cur != impol_gold
        || exprs_cur != exprs_gold
    {
        "FAIL"
    } else {
        "PASS"
    };

    AirRow {
        name: air.to_string(),
        cur_present,
        gold_present,
        c_exp_id_cur,
        c_exp_id_gold,
        q_deg_cur,
        q_deg_gold,
        n_constraints_cur: n_cons_cur,
        n_constraints_gold: n_cons_gold,
        cm_pols_stage2_cur: cm_stage2_cur,
        cm_pols_stage2_gold: cm_stage2_gold,
        impol_count_cur: impol_cur,
        impol_count_gold: impol_gold,
        expressions_code_cur: exprs_cur,
        expressions_code_gold: exprs_gold,
        verdict,
    }
}

fn print_table(report: &OracleReport) {
    println!(
        "Per-AIR golden diff: cur={} gold={} airgroup={}/{}",
        report.cur_root, report.gold_root, report.airgroup_dir, report.airgroup_name
    );
    println!(
        "{:<32} {:<7} {:>9} {:>11} {:>11} {:>11} {:>17}",
        "name", "verdict", "qDeg", "nConstraints", "stage2cm", "imPol", "expressionsCode",
    );
    let bar = "-".repeat(32 + 7 + 9 + 11 + 11 + 11 + 17 + 6);
    println!("{bar}");
    let mut counts: BTreeMap<&str, usize> = BTreeMap::new();
    for r in &report.rows {
        *counts.entry(r.verdict).or_insert(0) += 1;
        println!(
            "{:<32} {:<7} {:>4}/{:<4} {:>5}/{:<5} {:>5}/{:<5} {:>5}/{:<5} {:>8}/{:<8}",
            r.name,
            r.verdict,
            r.q_deg_cur.map(|v| v as i64).unwrap_or(-1),
            r.q_deg_gold.map(|v| v as i64).unwrap_or(-1),
            r.n_constraints_cur.map(|v| v as i64).unwrap_or(-1),
            r.n_constraints_gold.map(|v| v as i64).unwrap_or(-1),
            r.cm_pols_stage2_cur,
            r.cm_pols_stage2_gold,
            r.impol_count_cur,
            r.impol_count_gold,
            r.expressions_code_cur,
            r.expressions_code_gold,
        );
    }
    println!("{bar}");
    println!(
        "Totals: PASS={} FAIL={} MISSING={}",
        report.pass_count, report.fail_count, report.missing_count
    );
    println!(
        "(qDeg / nConstraints / stage2cm / imPol / expressionsCode columns: cur/gold)"
    );
}

fn main() {
    let args = match parse_args() {
        Ok(a) => a,
        Err(e) => {
            eprintln!("error: {e}");
            print_help();
            std::process::exit(2);
        }
    };
    let cur_airs = list_airs(&airs_dir(&args.cur, &args.airgroup_dir, &args.airgroup_name));
    let gold_airs = list_airs(&airs_dir(&args.gold, &args.airgroup_dir, &args.airgroup_name));
    let mut all: std::collections::BTreeSet<String> = cur_airs.into_iter().collect();
    all.extend(gold_airs);
    let mut rows: Vec<AirRow> = Vec::new();
    let mut pass_count = 0;
    let mut fail_count = 0;
    let mut missing_count = 0;
    for air in all {
        let row = build_row(
            &air,
            &args.cur,
            &args.gold,
            &args.airgroup_dir,
            &args.airgroup_name,
        );
        match row.verdict {
            "PASS" => pass_count += 1,
            "FAIL" => fail_count += 1,
            "MISSING" => missing_count += 1,
            _ => {}
        }
        rows.push(row);
    }
    let report = OracleReport {
        cur_root: args.cur.display().to_string(),
        gold_root: args.gold.display().to_string(),
        airgroup_dir: args.airgroup_dir,
        airgroup_name: args.airgroup_name,
        rows,
        pass_count,
        fail_count,
        missing_count,
    };
    print_table(&report);
    if let Some(path) = args.json_out {
        if let Some(parent) = path.parent() {
            let _ = fs::create_dir_all(parent);
        }
        match serde_json::to_vec_pretty(&report) {
            Ok(b) => {
                if let Err(e) = fs::write(&path, b) {
                    eprintln!("warn: failed to write {}: {e}", path.display());
                }
            }
            Err(e) => eprintln!("warn: failed to serialize report: {e}"),
        }
    }
    if report.fail_count > 0 || report.missing_count > 0 {
        std::process::exit(1);
    }
}
