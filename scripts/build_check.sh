#!/bin/bash
set -e
cd /data/eric/venus
export CARGO_BUILD_JOBS=1

echo "=== Checking stark-recurser-rust ==="
cargo check -p stark-recurser-rust 2>&1
echo "RESULT: stark-recurser-rust OK"

echo "=== Checking pil2-compiler-rust ==="
cargo check -p pil2-compiler-rust 2>&1
echo "RESULT: pil2-compiler-rust OK"

echo "=== Checking pil2-stark-setup ==="
cargo check -p pil2-stark-setup 2>&1
echo "RESULT: pil2-stark-setup OK"

echo "=== ALL CHECKS PASSED ==="
