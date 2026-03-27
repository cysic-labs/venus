#!/usr/bin/env bash
set -euo pipefail

GOLDEN_DIR="${1:-golden_reference}"
PROVING_KEY="build/provingKey"

if [ ! -d "$PROVING_KEY" ]; then
    echo "ERROR: $PROVING_KEY not found. Run 'make generate-key' first."
    exit 1
fi

rm -rf "$GOLDEN_DIR"
cp -r "$PROVING_KEY" "$GOLDEN_DIR"
echo "Golden reference captured to $GOLDEN_DIR"
echo "Files:"
find "$GOLDEN_DIR" -type f | wc -l
echo "Total size:"
du -sh "$GOLDEN_DIR"
