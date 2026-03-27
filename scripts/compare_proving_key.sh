#!/usr/bin/env bash
set -euo pipefail

GOLDEN="${1:?Usage: compare_proving_key.sh <golden_dir> <candidate_dir>}"
CANDIDATE="${2:?Usage: compare_proving_key.sh <golden_dir> <candidate_dir>}"
FAIL=0

while IFS= read -r -d '' gfile; do
    rel="${gfile#$GOLDEN/}"
    cfile="$CANDIDATE/$rel"
    if [ ! -f "$cfile" ]; then
        echo "MISSING: $rel"
        FAIL=1
    elif ! cmp -s "$gfile" "$cfile"; then
        echo "DIFFER: $rel"
        FAIL=1
    fi
done < <(find "$GOLDEN" -type f -print0 | sort -z)

# Check for extra files in candidate
while IFS= read -r -d '' cfile; do
    rel="${cfile#$CANDIDATE/}"
    gfile="$GOLDEN/$rel"
    if [ ! -f "$gfile" ]; then
        echo "EXTRA: $rel"
        FAIL=1
    fi
done < <(find "$CANDIDATE" -type f -print0 | sort -z)

if [ $FAIL -eq 0 ]; then
    echo "OK: All files match byte-for-byte"
else
    echo "FAIL: Differences found"
    exit 1
fi
