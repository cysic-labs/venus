#!/bin/bash
# Organize EVM test fixtures by opcode/precompile
# Usage: ./organize-fixtures.sh <fixtures_directory>

set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <input_directory> [output_directory]"
    echo "  input_directory:  Directory containing JSON fixture files"
    echo "  output_directory: Where to place organized files (default: same as input)"
    exit 1
fi

INPUT_DIR="$1"
OUTPUT_DIR="${2:-$INPUT_DIR}"

if [[ ! -d "$INPUT_DIR" ]]; then
    echo "Error: Input directory '$INPUT_DIR' does not exist"
    exit 1
fi

# Create output directory if it doesn't exist
if [[ "$OUTPUT_DIR" != "$INPUT_DIR" ]]; then
    mkdir -p "$OUTPUT_DIR"
fi

# Prague EVM opcodes https://www.evm.codes/?fork=osaka
OPCODES=(
    # Stop and Arithmetic
    "stop" "add" "mul" "sub" "div" "sdiv" "mod" "smod" "addmod" "mulmod" "exp" "signextend"
    # Comparison & Bitwise
    "lt" "gt" "slt" "sgt" "eq" "iszero" "and" "or" "xor" "not" "byte" "shl" "shr" "sar" "clz"
    # Keccak
    "keccak256" "sha3" "keccak"
    # Environmental
    "address" "balance" "origin" "caller" "callvalue" "calldataload" "calldatasize" "calldatacopy"
    "codesize" "codecopy" "gasprice" "extcodesize" "extcodecopy" "returndatasize" "returndatacopy" "extcodehash"
    # Block
    "blockhash" "coinbase" "timestamp" "number" "prevrandao" "gaslimit" "chainid" "selfbalance" "basefee" "blobhash" "blobbasefee"
    # Stack, Memory, Storage, Flow
    "pop" "mload" "mstore" "mstore8" "sload" "ssload" "sstore"
    "jump" "jumps"
    "jumpi" "jumpis"
    "pc" "msize" "gas" 
    "jumpdest" "jumpdests"
    "tload" "tstore" "mcopy"
    # Push
    "push0" "push1" "push2" "push3" "push4" "push5" "push6" "push7" "push8" "push9" "push10"
    "push11" "push12" "push13" "push14" "push15" "push16" "push17" "push18" "push19" "push20"
    "push21" "push22" "push23" "push24" "push25" "push26" "push27" "push28" "push29" "push30" "push31" "push32"
    # Dup
    "dup1" "dup2" "dup3" "dup4" "dup5" "dup6" "dup7" "dup8" "dup9" "dup10" "dup11" "dup12" "dup13" "dup14" "dup15" "dup16"
    # Swap
    "swap1" "swap2" "swap3" "swap4" "swap5" "swap6" "swap7" "swap8" "swap9" "swap10" "swap11" "swap12" "swap13" "swap14" "swap15" "swap16"
    # Log
    "log0" "log1" "log2" "log3" "log4"
    # System
    "create" "call" "callcode" "return" "delegatecall" "create2" "staticcall" "revert" "invalid" "selfdestruct"
)

# Prague EVM precompiles https://www.evm.codes/precompiled?fork=osaka
PRECOMPILES=(
    "ecrecover" "ec_recover"
    "sha256" "sha2" "sha2_256"
    "ripemd160" "ripemd"
    "identity"
    "modexp" "mod_exp" "bigmodexp"
    "ec_add" "ecadd" "bn128_add" "alt_bn128_add" "bn256_add"
    "ec_mul" "ecmul" "bn128_mul" "alt_bn128_mul" "bn256_mul"
    "ec_pairing" "ecpairing" "bn128_pairing" "alt_bn128_pairing" "bn256_pairing" "pairing" "pairings" "bn128_two_pairings"
    "blake2f" "blake2"
    "point_evaluation" "kzg" "kzg_point_evaluation"
    "bls12_g1add" "bls_g1add" "g1add"
    "bls12_g1mul" "bls_g1mul" "g1mul"
    "bls12_g1msm" "bls_g1msm" "g1msm" "g1_msm"
    "bls12_g2add" "bls_g2add" "g2add"
    "bls12_g2mul" "bls_g2mul" "g2mul"
    "bls12_g2msm" "bls_g2msm" "g2msm" "g2_msm"
    "bls12_pairing" "bls_pairing"
    "bls12_map_fp_to_g1" "bls_map_fp_to_g1" "map_fp_to_g1" "bls12_fp_to_g1"
    "bls12_map_fp2_to_g2" "bls_map_fp2_to_g2" "map_fp2_to_g2" "bls12_fp2_to_g2" "bls12_fp_to_g2"
    "p256verify"
)

# Canonical names for normalization
declare -A CANONICAL_NAMES=(
    # Opcodes
    ["jumpdests"]="jumpdest"
    ["jumpis"]="jumpi"
    ["jumps"]="jump"
    ["keccak"]="keccak256"
    ["sha3"]="keccak256"
    ["ssload"]="sload"
    # Precompiles
    ["ec_recover"]="ecrecover"
    ["sha2"]="sha256"
    ["sha2_256"]="sha256"
    ["ripemd"]="ripemd160"
    ["datacopy"]="identity"
    ["mod_exp"]="modexp"
    ["bigmodexp"]="modexp"
    ["ecadd"]="ec_add"
    ["bn128_add"]="ec_add"
    ["alt_bn128_add"]="ec_add"
    ["bn256_add"]="ec_add"
    ["ecmul"]="ec_mul"
    ["bn128_mul"]="ec_mul"
    ["alt_bn128_mul"]="ec_mul"
    ["bn256_mul"]="ec_mul"
    ["ecpairing"]="ec_pairing"
    ["bn128_pairing"]="ec_pairing"
    ["alt_bn128_pairing"]="ec_pairing"
    ["bn256_pairing"]="ec_pairing"
    ["pairing"]="ec_pairing"
    ["pairings"]="ec_pairing"
    ["bn128_two_pairings"]="ec_pairing"
    ["blake2"]="blake2f"
    ["kzg"]="point_evaluation"
    ["kzg_point_evaluation"]="point_evaluation"
    ["bls_g1add"]="bls12_g1add"
    ["g1add"]="bls12_g1add"
    ["bls_g1mul"]="bls12_g1mul"
    ["g1mul"]="bls12_g1mul"
    ["bls_g1msm"]="bls12_g1msm"
    ["g1msm"]="bls12_g1msm"
    ["g1_msm"]="bls12_g1msm"
    ["bls_g2add"]="bls12_g2add"
    ["g2add"]="bls12_g2add"
    ["bls_g2mul"]="bls12_g2mul"
    ["g2mul"]="bls12_g2mul"
    ["bls_g2msm"]="bls12_g2msm"
    ["g2msm"]="bls12_g2msm"
    ["g2_msm"]="bls12_g2msm"
    ["bls_pairing"]="bls12_pairing"
    ["bls_map_fp_to_g1"]="bls12_map_fp_to_g1"
    ["map_fp_to_g1"]="bls12_map_fp_to_g1"
    ["bls12_fp_to_g1"]="bls12_map_fp_to_g1"
    ["bls_map_fp2_to_g2"]="bls12_map_fp2_to_g2"
    ["map_fp2_to_g2"]="bls12_map_fp2_to_g2"
    ["bls12_fp2_to_g2"]="bls12_map_fp2_to_g2"
    ["bls12_fp_to_g2"]="bls12_map_fp2_to_g2"
)

is_known_op() {
    local name="${1,,}"  # lowercase
    
    for op in "${OPCODES[@]}"; do
        [[ "$name" == "$op" ]] && return 0
    done
    
    for precompile in "${PRECOMPILES[@]}"; do
        [[ "$name" == "$precompile" ]] && return 0
    done
    
    return 1
}

get_canonical_name() {
    local name="${1,,}"  # lowercase
    
    if [[ -v "CANONICAL_NAMES[$name]" ]]; then
        echo "${CANONICAL_NAMES[$name]}"
    else
        echo "$name"
    fi
}

extract_op_name() {
    local filename="$1"
    
    # Remove .json or .bin extension and path
    local basename="${filename%.json}"
    basename="${basename%.bin}"
    basename="${basename##*/}"
    
    local best_match=""
    local best_len=0
    
    # FIRST PASS: Match UPPERCASE opcodes (e.g., "opcode_CALL", "opcode_BALANCE")
    for op in "${OPCODES[@]}"; do
        local upper_op="${op^^}"  # Convert to uppercase
        if [[ "$basename" == *"$upper_op"* ]]; then
            if [[ ${#op} -gt $best_len ]]; then
                best_match="$op"
                best_len=${#op}
            fi
        fi
    done
    
    if [[ -n "$best_match" ]]; then
        get_canonical_name "$best_match"
        return 0
    fi
    
    # SECOND PASS: Match precompiles (case-insensitive)
    local lower_basename="${basename,,}"
    
    for precompile in "${PRECOMPILES[@]}"; do
        if [[ "$lower_basename" == *"$precompile"* ]]; then
            if [[ ${#precompile} -gt $best_len ]]; then
                best_match="$precompile"
                best_len=${#precompile}
            fi
        fi
    done
    
    if [[ -n "$best_match" ]]; then
        get_canonical_name "$best_match"
        return 0
    fi
    
    # THIRD PASS: Match lowercase opcodes in test function names (e.g., "test_codecopy_benchmark")
    # Pattern: test_<opcode>[ or test_<opcode>_
    # Sort opcodes by length descending to match longer ones first
    local sorted_ops=($(printf '%s\n' "${OPCODES[@]}" | awk '{ print length, $0 }' | sort -rn | cut -d' ' -f2-))
    
    for op in "${sorted_ops[@]}"; do
        # Match patterns like: test_<opcode>[ or test_<opcode>_ or __test_<opcode>[
        if [[ "$lower_basename" =~ (^|_)test_${op}(\[|_|$) ]]; then
            get_canonical_name "$op"
            return 0
        fi
    done
    
    # Fallback: return "uncategorized"
    echo "uncategorized"
}

# Main organization logic
echo "Organizing fixtures from: ${INPUT_DIR}"
if [[ "$OUTPUT_DIR" != "$INPUT_DIR" ]]; then
    echo "Output directory: ${OUTPUT_DIR}"
fi
echo ""

# Count files before
total_before=$(find "$INPUT_DIR" -maxdepth 1 \( -name "*.json" -o -name "*.bin" \) -type f | wc -l)
echo "Found ${total_before} files to organize"

# Process each json or bin file in input directory
find "$INPUT_DIR" -maxdepth 1 \( -name "*.json" -o -name "*.bin" \) -type f | while read -r filepath; do
    file=$(basename "$filepath")
    
    # Extract opcode/precompile name
    target_dir=$(extract_op_name "$file")
    
    # Create directory if it doesn't exist
    mkdir -p "${OUTPUT_DIR}/${target_dir}"
    
    # Move or copy file to appropriate directory
    if [[ "$OUTPUT_DIR" == "$INPUT_DIR" ]]; then
        mv "$filepath" "${OUTPUT_DIR}/${target_dir}/"
    else
        cp "$filepath" "${OUTPUT_DIR}/${target_dir}/"
    fi
done

# Change to output dir for summary
cd "${OUTPUT_DIR}"

# Clean up empty directories
find . -type d -empty -delete 2>/dev/null || true

opcode_count=0
precompile_count=0
other_count=0
for dir in $(ls -d */ 2>/dev/null | sed 's/\///' | sort); do
    [ -d "$dir" ] || continue
    count=$(find "$dir" -maxdepth 1 \( -name "*.json" -o -name "*.bin" \) | wc -l)
    
    # Determine if it's an opcode or precompile
    is_precompile=false
    for p in "${PRECOMPILES[@]}"; do
        canonical=$(get_canonical_name "$p")
        if [[ "$dir" == "$canonical" ]]; then
            is_precompile=true
            break
        fi
    done
    
    if [[ "$is_precompile" == true ]]; then
        ((precompile_count += count))
    elif [[ "$dir" == "uncategorized" ]]; then
        ((other_count += count))
    else
        ((opcode_count += count))
    fi
done

echo ""
echo "Organization summary:"
echo "  Opcodes:     ${opcode_count} tests"
echo "  Precompiles: ${precompile_count} tests"
echo "  Other:       ${other_count} tests"
echo "  Total:       $((opcode_count + precompile_count + other_count)) tests"