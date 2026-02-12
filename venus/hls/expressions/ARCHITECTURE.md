# Expression Evaluation HLS Architecture

## Overview

The expression evaluation engine is a **bytecode-driven virtual machine** that evaluates
polynomial constraint expressions over a domain of N (or NExtended) rows.  It is the
computational core of the STARK verifier: every AIR constraint, every FRI composition,
and every Q-polynomial evaluation reduces to running a sequence of field-arithmetic
instructions over trace/constant polynomial data.

Reference implementations:
- GPU: `pil2-proofman/pil2-stark/src/starkpil/expressions_gpu.cu`
- CPU: `pil2-proofman/pil2-stark/src/starkpil/expressions_pack.hpp`

## Bytecode Format

Expressions are pre-compiled into a compact binary representation:

| Array    | Type     | Description                                |
|----------|----------|--------------------------------------------|
| ops[]    | uint8_t  | Opcode per instruction (0, 1, or 2)        |
| args[]   | uint16_t | 8 arguments per instruction                |
| numbers[]| gl64_t   | Constant pool (field element literals)      |

### Opcodes

| Opcode | Meaning                    | Dimensions       |
|--------|----------------------------|-------------------|
| 0      | Base field arithmetic      | dim1 x dim1 -> dim1 |
| 1      | Extension x base           | dim3 x dim1 -> dim3 |
| 2      | Extension x extension      | dim3 x dim3 -> dim3 |

### Argument Layout (8 uint16_t per instruction)

| Index | Field     | Description                          |
|-------|-----------|--------------------------------------|
| 0     | op        | 0=add, 1=sub, 2=mul, 3=rsub(b-a)    |
| 1     | dest_idx  | Destination temp buffer index        |
| 2     | src_a_type| Data source type for operand A       |
| 3     | src_a_idx | Column/element index for A           |
| 4     | src_a_off | Opening point offset index for A     |
| 5     | src_b_type| Data source type for operand B       |
| 6     | src_b_idx | Column/element index for B           |
| 7     | src_b_off | Opening point offset index for B     |

### Data Source Types

The `type` field selects which data buffer an operand is loaded from.
Let `B = bufferCommitSize = 1 + nStages + 3 + nCustomCommits`.

| Type Range      | Source                                   | Stride |
|-----------------|------------------------------------------|--------|
| 0               | Constant polynomials (pConstPols)        | row    |
| 1               | Trace (stage 1)                          | row    |
| 2..nStages+1    | Aux trace (stages 2..nStages+1)          | row    |
| nStages+2       | x / Zi (vanishing polynomial)            | row    |
| nStages+3       | xDivXSubXi                               | row    |
| nStages+4..B-1  | Custom commits                           | row    |
| B               | tmp1 (dim1 temporaries)                  | -      |
| B+1             | tmp3 (dim3 temporaries)                  | -      |
| B+2             | publicInputs                             | const  |
| B+3             | numbers (constant pool)                  | const  |
| B+4             | airValues                                | const  |
| B+5             | proofValues                              | const  |
| B+6             | airgroupValues                           | const  |
| B+7             | challenges                               | const  |
| B+8             | evals                                    | const  |

Row-strided sources use `row + stride[offset]` to compute the logical row,
where stride comes from opening points (for shifted polynomial access like `p(x*g)`).

## Goldilocks Cubic Extension Field (F_p^3)

The extension field uses irreducible polynomial: **x^3 - x - 1** over F_p.

Elements are triples (a0, a1, a2) representing a0 + a1*x + a2*x^2.

- **Add/Sub**: component-wise
- **Multiply**: Karatsuba-style with 6 base-field multiplications
  - A = (a0+a1)(b0+b1), B = (a0+a2)(b0+b2), C = (a1+a2)(b1+b2)
  - D = a0*b0, E = a1*b1, F = a2*b2, G = D - E
  - result[0] = C + G - F
  - result[1] = A + C - 2E - D
  - result[2] = B - G
- **Inverse**: Uses norm computation (expensive: ~18 base muls + 1 base inv)

## HLS Architecture

### Design Philosophy

The GPU version processes `nRowsPack` (128-512) rows in parallel per thread block.
The FPGA version processes **one row per cycle** in a deeply pipelined engine,
iterating over the domain. Key differences from GPU:

1. **No tiled memory layout** - FPGA uses simple row-major addressing
   (GPU's `getBufferOffset` tiling is a coalescing optimization irrelevant for FPGA)
2. **Sequential row processing** with pipeline II=1 on the outer loop
3. **BRAM temporaries** instead of shared memory
4. **Direct constant access** via BRAM ports (no indirection table)

### Memory Map

```
                  AXI-MM (HBM)
           +----------------------+
gmem0 ---->| Polynomial data      |  trace, aux_trace, constPols
           | (row-major, N rows)  |
           +----------------------+
gmem1 ---->| Output buffer        |  dest (result polynomials)
           +----------------------+

           AXI-Lite / BRAM
           +----------------------+
           | ops[]                |  bytecode opcodes
           | args[]               |  bytecode arguments
           | numbers[]            |  constant pool
           | challenges[]         |  verifier challenges
           | evals[]              |  evaluation points
           | publicInputs[]       |  public inputs
           | airValues[]          |  AIR values
           | proofValues[]        |  proof values
           | airgroupValues[]     |  airgroup values
           | openingStrides[]     |  opening point strides
           +----------------------+

           BRAM (on-chip)
           +----------------------+
           | tmp1[MAX_TEMP1]      |  dim1 temporaries
           | tmp3[MAX_TEMP3][3]   |  dim3 temporaries
           +----------------------+
```

### Execution Flow

```
for each row i in [0, domainSize):
    for each param k in dest.params:
        if (no-op: const/cm/number/airvalue):
            load directly into destVals[k]
        else:
            for each instruction kk in [0, nOps):
                fetch ops[kk], args[kk*8..(kk+1)*8-1]
                load operand A from source(type_a, idx_a, off_a, row)
                load operand B from source(type_b, idx_b, off_b, row)
                execute arithmetic op on A, B -> result
                store to tmp buffer or destVals (if last op)
            if inverse: invert destVals[k]
    if 2 params: multiply destVals[0] * destVals[1]
    store to output dest[row]
```

### Simplifications for HLS Test Kernel

The full expression engine is highly parameterized by runtime metadata
(nStages, mapOffsets, mapSectionsN, etc.). For the HLS kernel, we:

1. **Fix the buffer layout** at compile time with template parameters
2. **Flatten the data source lookup** into a simpler switch-case
3. **Bound the bytecode size** with MAX_OPS, MAX_ARGS, MAX_NUMBERS
4. **Bound the temp count** with MAX_TEMP1, MAX_TEMP3
5. **Support single-expression evaluation** (nParams=1) first,
   then optionally two-expression multiply

### Resource Estimates

Per expression evaluation engine:
- **Base field mul (gl64_t)**: 12 DSP48E2 each (64-bit Goldilocks)
- **Cubic mul (6 base muls)**: 72 DSPs
- **Pipeline**: ~5-10 cycles per instruction
- **Temp BRAM**: MAX_TEMP1 * 8B + MAX_TEMP3 * 24B
  - Typical: 128 * 8 + 128 * 24 = ~4 KB per engine
- **Bytecode BRAM**: MAX_OPS * 1B + MAX_ARGS * 2B + MAX_NUMBERS * 8B
  - Typical: 4096 * 1 + 32768 * 2 + 1024 * 8 = ~78 KB

### Performance Model

For a domain of N = 2^20 rows, with typical expressions of ~50 operations:
- Per row: ~50 ops * ~8 cycles/op = ~400 cycles
- Total: 2^20 * 400 = ~419M cycles
- At 300 MHz: ~1.4 seconds per expression evaluation

Multiple expression engines can be instantiated for parallelism,
or the same engine reused for different expressions sequentially.
