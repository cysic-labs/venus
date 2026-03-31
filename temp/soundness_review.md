# Soundness Review: Rust PK Generation vs Golden Reference

Date: 2026-03-31

## Overview

This review compares the Rust-generated proving key (`build/provingKey/`) against
the golden reference (`golden_reference/`) across all 35 AIRs in the Zisk proof
system. The comparison covers 842 total files.

## Full Byte-Level Comparison

The `compare_proving_key.sh` script reports:

```
OK: All files match byte-for-byte
```

All 842 files in the golden reference are present in the candidate build, with
no extra files and no missing files. Every file is byte-identical.

## Per-AIR 7-File Subset Analysis

For each of the 35 AIRs, the following 7 critical files were compared:

| File | Description |
|------|-------------|
| starkinfo.json | STARK parameters, constraints, opening points |
| expressionsinfo.json | Expression definitions for constraint evaluation |
| verifierinfo.json | Verifier circuit parameters |
| bin | Compiled constraint binary |
| verifier.bin | Compiled verifier binary |
| verkey.json | Verification key (JSON) |
| verkey.bin | Verification key (binary) |

**Result: All 35 AIRs show 7/7 files byte-identical (match=7 differ=0 missing=0).**

Complete AIR list:
- Add256, Arith, ArithEq, ArithEq384, Binary, BinaryAdd, BinaryExtension
- Blake2br, Dma, Dma64Aligned, Dma64AlignedInputCpy, Dma64AlignedMem
- Dma64AlignedMemCpy, Dma64AlignedMemSet, DmaInputCpy, DmaMemCpy
- DmaPrePost, DmaPrePostInputCpy, DmaPrePostMemCpy, DmaUnaligned
- InputData, Keccakf, Main, Mem, MemAlign, MemAlignByte
- MemAlignReadByte, MemAlignWriteByte, Poseidon2, Rom, RomData
- Sha256f, SpecifiedRanges, VirtualTable0, VirtualTable1

## Security-Critical Field Comparison (starkinfo.json)

For all 35 AIRs, the following security-critical fields were compared via Python
JSON parsing. Every field matches between Rust output and golden reference:

| Field | Status |
|-------|--------|
| nConstants | MATCH (all 35 AIRs) |
| nConstraints | MATCH (all 35 AIRs) |
| qDeg | MATCH (all 35 AIRs) |
| qDim | MATCH (all 35 AIRs) |
| starkStruct.nBits | MATCH (all 35 AIRs) |
| starkStruct.nBitsExt | MATCH (all 35 AIRs) |
| starkStruct.nQueries | MATCH (all 35 AIRs) |
| starkStruct.powBits | MATCH (all 35 AIRs) |
| starkStruct.merkleTreeArity | MATCH (all 35 AIRs) |
| openingPoints (count + values) | MATCH (all 35 AIRs) |

Since all files are byte-identical, this is a confirmation check rather than
finding differences. The JSON-level comparison confirms the binary-level result.

## Verification Key Analysis

All 35 AIRs have:
- verkey.json: byte-identical to golden reference
- verkey.bin: byte-identical to golden reference
- All verification keys contain non-zero values (confirming they are populated)
- All verification keys are consistent between Rust output and golden reference

## Binary File Size Check

All binary files (.bin, verifier.bin, verkey.bin) have identical sizes between
Rust output and golden reference across all 35 AIRs, as expected given the
byte-level identity.

## Global Files

The three global-level files are also byte-identical:
- pilout.globalConstraints.bin: MATCH
- pilout.globalConstraints.json: MATCH
- pilout.globalInfo.json: MATCH

## Difference Analysis

**There are no differences.** All 842 files across 35 AIRs plus global metadata
are byte-for-byte identical between the Rust-generated proving key and the
golden reference.

Since there are zero differences:
- No serialization/ordering discrepancies exist
- No expression reordering differences exist
- No value changes exist

## Conclusion

### Security-Critical Differences: NONE

There are zero security-critical differences. Every proving key artifact
produced by the Rust implementation is byte-identical to the golden reference.

### Serialization/Ordering Differences: NONE

There are no serialization or ordering differences. The Rust implementation
produces deterministic, reproducible output that exactly matches the golden
reference at the byte level.

### Cryptographic Soundness: PRESERVED

The Rust PK generation fully preserves cryptographic soundness. The evidence is
conclusive:

1. **842/842 files byte-identical** -- no file differs in any way
2. **35/35 AIRs fully match** -- every AIR's critical files (starkinfo,
   expressionsinfo, verifierinfo, bin, verifier.bin, verkey.json, verkey.bin)
   are identical
3. **All security parameters match** -- nConstants, nConstraints, qDeg, qDim,
   nQueries, powBits, merkleTreeArity, and opening points are all identical
4. **Verification keys are non-zero and consistent** -- confirming correct
   key generation
5. **Global constraint files match** -- the system-level constraint
   definitions are preserved

The Rust proving key generation is a faithful, byte-exact reproduction of the
golden reference output.
