#!/usr/bin/env python3
"""
Process benchmark metrics and generate CSV reports and bar charts.

Usage:
    python process_metrics.py <metrics_folder> [--output <output_folder>]

The script will:
1. Read all JSON benchmark result files
2. Group tests by opcode/precompile
3. Perform linear regression on gas vs steps/cost
4. Output CSV files and bar charts
"""

import argparse
import json
import math
import sys
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Optional

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy import stats


@dataclass
class BenchmarkResult:
    opcode: str
    test_name: str
    time: float
    steps: int
    cost: int
    gas_used: Optional[int]    


def extract_opcode_from_path(file_path: Path) -> str:
    """Extract opcode name from the directory structure"""
    # The parent directory should be the opcode name
    return file_path.parent.name


def load_benchmark_results(metrics_folder: Path) -> list[BenchmarkResult]:
    """Load all benchmark JSON files from the metrics folder"""
    results = []
    
    # Walk through all subdirectories (organized by opcode)
    for json_file in metrics_folder.rglob("*.json"):
        try:
            with open(json_file) as f:
                data = json.load(f)
            
            opcode = extract_opcode_from_path(json_file)
            
            result = BenchmarkResult(
                opcode=opcode,
                test_name=data.get("test_name", json_file.stem),
                time=data.get("time", 0.0),
                steps=data.get("metrics", {}).get("steps", 0),
                cost=data.get("metrics", {}).get("cost", 0),
                gas_used=data.get("metrics", {}).get("gas_used"),
            )
            results.append(result)
        except (json.JSONDecodeError, KeyError) as e:
            print(f"Warning: Failed to parse {json_file}: {e}", file=sys.stderr)
    
    return results


def perform_linear_regression(gas_values: list[int], metrics: list[int]) -> dict:
    """Perform linear regression and return slope, intercept, r_squared"""
    if len(gas_values) < 2:
        return {
            "slope": metrics[0] / gas_values[0] if gas_values and gas_values[0] > 0 else 0,
            "intercept": 0,
            "r_squared": 1.0,
            "n_points": len(gas_values),
        }
    
    slope, intercept, r_value, p_value, std_err = stats.linregress(gas_values, metrics)
    return {
        "slope": slope,
        "intercept": intercept,
        "r_squared": r_value ** 2,
        "n_points": len(gas_values),
    }


def analyze_by_opcode(results: list[BenchmarkResult]) -> pd.DataFrame:
    """Group results by opcode and perform linear regression"""
    # Group by opcode
    opcode_data = defaultdict(lambda: {"gas_used": [], "steps": [], "costs": [], "times": []})
    
    for r in results:
        opcode_data[r.opcode]["times"].append(r.time)
        opcode_data[r.opcode]["steps"].append(r.steps)
        opcode_data[r.opcode]["costs"].append(r.cost)
        if r.gas_used is not None:
            # Convert gas to millions of gas (MGas)
            opcode_data[r.opcode]["gas_used"].append(r.gas_used / 1_000_000)
    
    # Perform regression for each opcode
    rows = []
    for opcode, data in sorted(opcode_data.items()):
        if not data["gas_used"]:
            continue
        
        steps_reg = perform_linear_regression(data["gas_used"], data["steps"])
        cost_reg = perform_linear_regression(data["gas_used"], data["costs"])
        
        rows.append({
            "opcode": opcode,
            "n_tests": len(data["gas_used"]),
            # Steps regression (per MGas)
            "steps_per_mgas": math.ceil(steps_reg["slope"]),
            # Cost regression (per MGas)
            "cost_per_mgas": math.ceil(cost_reg["slope"]),
        })
    
    return pd.DataFrame(rows)


def create_bar_chart(df: pd.DataFrame, metric: str, title: str, output_path: Path, threshold: Optional[int] = None):
    """Create a bar chart for the given metric"""
    if df.empty:
        print(f"Warning: No data to plot for {title}")
        return
    
    # Sort by the metric value
    df_sorted = df.sort_values(metric, ascending=True)
    
    fig, ax = plt.subplots(figsize=(12, max(8, len(df_sorted) * 0.3)))
    
    bars = ax.barh(df_sorted["opcode"], df_sorted[metric])
    
    ax.set_xlabel(metric.replace("_", " ").title())
    ax.set_ylabel("Opcode / Precompile")
    ax.set_title(title)
    
    # Format x-axis to avoid scientific notation
    ax.ticklabel_format(style='plain', axis='x')
    ax.xaxis.set_major_formatter(plt.FuncFormatter(lambda x, p: f'{x:,.0f}'))
    
    # Add threshold line if provided
    if threshold is not None:
        ax.axvline(x=threshold, color='red', linestyle='--', linewidth=2, label=f'Threshold: {threshold:,}'.replace(",", "."))
        ax.legend(loc='lower right')
    
    # Add value labels on bars
    for bar, value in zip(bars, df_sorted[metric]):
        width = bar.get_width()
        label = f"{value:,.0f}"
        ax.annotate(label,
                    xy=(width, bar.get_y() + bar.get_height() / 2),
                    xytext=(3, 0),
                    textcoords="offset points",
                    ha="left", va="center", fontsize=8)
    
    plt.tight_layout()
    plt.savefig(output_path, dpi=150, bbox_inches="tight")
    plt.close()


def create_comparison_chart(df: pd.DataFrame, output_path: Path):
    """Create a comparison chart showing steps vs cost normalized"""
    if df.empty:
        return
    
    # Normalize values for comparison
    df_plot = df.copy()
    df_plot["steps_norm"] = df_plot["steps_per_mgas"] / df_plot["steps_per_mgas"].max()
    df_plot["cost_norm"] = df_plot["cost_per_mgas"] / df_plot["cost_per_mgas"].max()
    
    df_sorted = df_plot.sort_values("cost_per_mgas", ascending=True)
    
    fig, ax = plt.subplots(figsize=(14, max(8, len(df_sorted) * 0.35)))
    
    y = np.arange(len(df_sorted))
    height = 0.35
    
    ax.barh(y - height/2, df_sorted["steps_norm"], height, label="Steps (normalized)", color="steelblue")
    ax.barh(y + height/2, df_sorted["cost_norm"], height, label="Cost (normalized)", color="coral")
    
    ax.set_ylabel("Opcode / Precompile")
    ax.set_xlabel("Normalized Value (0-1)")
    ax.set_title("Steps vs Cost per MGas (Normalized)")
    ax.set_yticks(y)
    ax.set_yticklabels(df_sorted["opcode"])
    ax.legend()
    
    plt.tight_layout()
    plt.savefig(output_path, dpi=150, bbox_inches="tight")
    plt.close()

def format_with_dots(value):
    return f"{value:,}".replace(",", ".")


def main():
    parser = argparse.ArgumentParser(
        description="Process benchmark metrics and generate reports"
    )
    parser.add_argument(
        "metrics_folder",
        type=Path,
        help="Folder containing benchmark JSON results (organized by opcode subdirectories)",
    )
    parser.add_argument(
        "--output", "-o",
        type=Path,
        default=None,
        help="Output folder for CSV and charts (default: metrics_folder/analysis)",
    )
    parser.add_argument(
        "--steps-threshold", "-s",
        type=int,
        default=None,
        help="Threshold for steps per MGas",
    )
    parser.add_argument(
        "--cost-threshold", "-c",
        type=int,
        default=None,
        help="Threshold for cost per MGas",
    )
    
    args = parser.parse_args()
    
    if not args.metrics_folder.exists():
        print(f"Error: Metrics folder not found: {args.metrics_folder}", file=sys.stderr)
        sys.exit(1)
    
    output_folder = args.output or args.metrics_folder / "analysis"
    output_folder.mkdir(parents=True, exist_ok=True)
    
    print(f"Loading benchmark results from: {args.metrics_folder}")
    results = load_benchmark_results(args.metrics_folder)
    print(f"Loaded {len(results)} benchmark results")
    
    if not results:
        print("No benchmark results found!", file=sys.stderr)
        sys.exit(1)
    
    # Analyze by opcode
    df = analyze_by_opcode(results)
    
    if df.empty:
        print("Warning: No valid data for regression analysis")
        sys.exit(0)
    
    # Export summary CSV
    df.to_csv(output_folder / "opcode_summary.csv", index=False, float_format='%.2f')
    
    # Steps per MGas
    create_bar_chart(
        df, "steps_per_mgas",
        "Steps per MGas by Opcode",
        output_folder / "chart_steps_per_mgas.png",
        threshold=args.steps_threshold
    )
    
    # Cost per MGas
    create_bar_chart(
        df, "cost_per_mgas",
        "Cost per MGas by Opcode",
        output_folder / "chart_cost_per_mgas.png",
        threshold=args.cost_threshold
    )
    
    # Comparison chart
    create_comparison_chart(df, output_folder / "chart_steps_vs_cost.png")
    
    print(f"\nAnalysis complete! Results saved to: {output_folder}")
    
    # Print top 10 most expensive opcodes
    print("\n=== Top 10 Most Expensive ===")
    top_cost = df.nlargest(10, "cost_per_mgas")[["opcode", "steps_per_mgas", "cost_per_mgas"]]
    top_cost["cost_per_mgas"] = top_cost["cost_per_mgas"].apply(format_with_dots)
    top_cost["steps_per_mgas"] = top_cost["steps_per_mgas"].apply(format_with_dots)
    print(top_cost.to_string(index=False))


if __name__ == "__main__":
    main()