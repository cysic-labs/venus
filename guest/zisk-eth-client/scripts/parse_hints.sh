#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./parse_hints_bin.sh /path/to/hints.bin [stop_hint_index]

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 /path/to/hints.bin [stop_hint_index]" >&2
  exit 1
fi

FILE="$1"
STOP_INDEX="${2:-}"

if [[ ! -f "$FILE" ]]; then
  echo "Error: file not found: $FILE" >&2
  exit 1
fi

python3 - "$FILE" "$STOP_INDEX" <<'PY'
import sys, os, struct

path = sys.argv[1]
stop_index = None
if len(sys.argv) > 2 and sys.argv[2] != "":
    stop_index = int(sys.argv[2])

size = os.path.getsize(path)

def pad8(n: int) -> int:
    return (8 - (n & 7)) & 7

with open(path, "rb") as f:
    if size < 8:
        raise SystemExit("File too small (< 8 bytes)")

    # Leer START header (u64 = 0)
    start_bytes = f.read(8)
    start_u64 = struct.unpack("<Q", start_bytes)[0]
    if start_u64 != 0:
        print("WARNING: START header is not 0")

    off = 8
    idx = 1

    while True:
        if stop_index is not None and idx > stop_index:
            break

        if off + 8 > size:
            break

        hdr_bytes = f.read(8)
        if len(hdr_bytes) < 8:
            break

        hdr = struct.unpack("<Q", hdr_bytes)[0]

        # Extraer campos
        hi = (hdr >> 32) & 0xFFFFFFFF
        lo = hdr & 0xFFFFFFFF

        hint_id = hi
        data_len = lo

        pad = pad8(data_len)
        total_len = 8 + data_len + pad

        print(
            f"#{idx}: "
            f"header=0x{hdr:016x}, "
            f"hint_id=0x{hint_id:08x}, "
            f"data_len={data_len}, "
            f"pad={pad}, "
            f"total_len={total_len}"
        )

        off += 8

        if off + data_len + pad > size:
            break

        f.seek(data_len + pad, 1)
        off += data_len + pad

        idx += 1

PY