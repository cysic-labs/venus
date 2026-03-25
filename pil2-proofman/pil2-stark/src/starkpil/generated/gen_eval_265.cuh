// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: b2f2c7b9  nOps=206 nTemp1=5 nTemp3=5
#define GENERATED_EVAL_NOPS_b2f2c7b9 206
#define GENERATED_EVAL_NTEMP1_b2f2c7b9 5
#define GENERATED_EVAL_NTEMP3_b2f2c7b9 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_b2f2c7b9(
    const StepsParams* __restrict__ dParams,
    const DeviceArguments* __restrict__ dArgs,
    const ExpsArguments* __restrict__ dExpsArgs,
    Goldilocks::Element **expressions_params,
    uint32_t bufferCommitsSize, uint64_t row)
{
    const uint64_t domainSize = dExpsArgs->domainSize;
    const uint64_t r = row + threadIdx.x;
    const uint64_t chunkBase = row;

    // stride[0] = -2
    const int64_t stride_0 = dExpsArgs->nextStridesExps[0];
    uint64_t logicalRow_0;
    // stride[1] = 0
    const int64_t stride_1 = dExpsArgs->nextStridesExps[1];
    uint64_t logicalRow_1;
    // stride[2] = 2
    const int64_t stride_2 = dExpsArgs->nextStridesExps[2];
    uint64_t logicalRow_2;
    if constexpr (IsCyclic) {
        logicalRow_0 = (r + stride_0) % domainSize;
        logicalRow_1 = (r + stride_1) % domainSize;
        logicalRow_2 = (r + stride_2) % domainSize;
    } else {
        logicalRow_0 = r + stride_0;
        logicalRow_1 = r + stride_1;
        logicalRow_2 = r + stride_2;
    }

    const bool usePack256_0 = false; // stride=-2 != 0
    const bool usePack256_1 = !IsCyclic && blockDim.x == TILE_HEIGHT;
    const bool usePack256_2 = false; // stride=2 != 0

    const uint64_t nCols_0 = dArgs->mapSectionsN[0];
    const uint64_t nCols_1 = dArgs->mapSectionsN[1];
    const uint64_t nCols_2 = dArgs->mapSectionsN[2];

    // Register-resident temporaries: 5 tmp1 + 15 tmp3 slots
    gl64_t tmp1_0 = gl64_t(uint64_t(0));
    gl64_t tmp1_1 = gl64_t(uint64_t(0));
    gl64_t tmp1_2 = gl64_t(uint64_t(0));
    gl64_t tmp1_3 = gl64_t(uint64_t(0));
    gl64_t tmp1_4 = gl64_t(uint64_t(0));
    gl64_t tmp3_0 = gl64_t(uint64_t(0));
    gl64_t tmp3_1 = gl64_t(uint64_t(0));
    gl64_t tmp3_2 = gl64_t(uint64_t(0));
    gl64_t tmp3_3 = gl64_t(uint64_t(0));
    gl64_t tmp3_4 = gl64_t(uint64_t(0));
    gl64_t tmp3_5 = gl64_t(uint64_t(0));
    gl64_t tmp3_6 = gl64_t(uint64_t(0));
    gl64_t tmp3_7 = gl64_t(uint64_t(0));
    gl64_t tmp3_8 = gl64_t(uint64_t(0));
    gl64_t tmp3_9 = gl64_t(uint64_t(0));
    gl64_t tmp3_10 = gl64_t(uint64_t(0));
    gl64_t tmp3_11 = gl64_t(uint64_t(0));
    gl64_t tmp3_12 = gl64_t(uint64_t(0));
    gl64_t tmp3_13 = gl64_t(uint64_t(0));
    gl64_t tmp3_14 = gl64_t(uint64_t(0));

    // Op 0: dim1x1 sub_swap
    gl64_t s0_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_0 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_0 - s0_0;
    // Op 1: dim1x1 mul
    gl64_t s0_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_1 * tmp1_0;
    // Op 2: dim3x1 mul
    gl64_t s0_2_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s0_2_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s0_2_2 = *(gl64_t*)&expressions_params[13][6+2];
    tmp3_0 = s0_2_0 * tmp1_0; tmp3_1 = s0_2_1 * tmp1_0; tmp3_2 = s0_2_2 * tmp1_0;
    // Op 3: dim1x1 sub_swap
    gl64_t s0_3 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_3 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_3 - s0_3;
    // Op 4: dim1x1 mul
    gl64_t s0_4 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_4 * tmp1_0;
    // Op 5: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 6: dim3x3 mul
    gl64_t s1_6_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_6_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_6_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA6 = (tmp3_0 + tmp3_1) * (s1_6_0 + s1_6_1);
    gl64_t kB6 = (tmp3_0 + tmp3_2) * (s1_6_0 + s1_6_2);
    gl64_t kC6 = (tmp3_1 + tmp3_2) * (s1_6_1 + s1_6_2);
    gl64_t kD6 = tmp3_0 * s1_6_0;
    gl64_t kE6 = tmp3_1 * s1_6_1;
    gl64_t kF6 = tmp3_2 * s1_6_2;
    gl64_t kG6 = kD6 - kE6;
    tmp3_0 = (kC6 + kG6) - kF6;
    tmp3_1 = ((((kA6 + kC6) - kE6) - kE6) - kD6);
    tmp3_2 = kB6 - kG6;
    // Op 7: dim1x1 sub_swap
    gl64_t s0_7 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_7 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_7 - s0_7;
    // Op 8: dim1x1 mul
    gl64_t s0_8 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_8 * tmp1_0;
    // Op 9: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 10: dim3x3 mul
    gl64_t s1_10_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_10_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_10_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA10 = (tmp3_0 + tmp3_1) * (s1_10_0 + s1_10_1);
    gl64_t kB10 = (tmp3_0 + tmp3_2) * (s1_10_0 + s1_10_2);
    gl64_t kC10 = (tmp3_1 + tmp3_2) * (s1_10_1 + s1_10_2);
    gl64_t kD10 = tmp3_0 * s1_10_0;
    gl64_t kE10 = tmp3_1 * s1_10_1;
    gl64_t kF10 = tmp3_2 * s1_10_2;
    gl64_t kG10 = kD10 - kE10;
    tmp3_0 = (kC10 + kG10) - kF10;
    tmp3_1 = ((((kA10 + kC10) - kE10) - kE10) - kD10);
    tmp3_2 = kB10 - kG10;
    // Op 11: dim1x1 mul
    gl64_t s0_11 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_11 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_11 * s1_11;
    // Op 12: dim1x1 mul
    gl64_t s0_12 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_2 = s0_12 * tmp1_0;
    // Op 13: dim1x1 mul
    gl64_t s0_13 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_13 = *(gl64_t*)&expressions_params[9][11];
    tmp1_0 = s0_13 * s1_13;
    // Op 14: dim1x1 sub_swap
    gl64_t s0_14 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_14 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s1_14 - s0_14;
    // Op 15: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 16: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_0;
    // Op 17: dim1x1 sub_swap
    gl64_t s0_17 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_17 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_17 - s0_17;
    // Op 18: dim1x1 mul
    gl64_t s1_18 = *(gl64_t*)&expressions_params[9][12];
    tmp1_0 = tmp1_0 * s1_18;
    // Op 19: dim1x1 mul
    gl64_t s0_19 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_19 * tmp1_0;
    // Op 20: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 21: dim1x1 sub_swap
    gl64_t s0_21 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_21 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_21 - s0_21;
    // Op 22: dim1x1 sub_swap
    gl64_t s0_22 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_22 = *(gl64_t*)&expressions_params[9][0];
    tmp1_2 = s1_22 - s0_22;
    // Op 23: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_2;
    // Op 24: dim1x1 add
    tmp1_4 = tmp1_1 + tmp1_0;
    // Op 25: dim1x1 mul
    gl64_t s0_25 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_3 = s0_25 * tmp1_4;
    // Op 26: dim1x1 mul
    gl64_t s0_26 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_26 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_26 * s1_26;
    // Op 27: dim1x1 sub_swap
    gl64_t s0_27 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_27 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s1_27 - s0_27;
    // Op 28: dim1x1 mul
    tmp1_1 = tmp1_0 * tmp1_1;
    // Op 29: dim1x1 mul
    gl64_t s0_29 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_29 = *(gl64_t*)&expressions_params[9][11];
    tmp1_0 = s0_29 * s1_29;
    // Op 30: dim1x1 mul
    gl64_t s0_30 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_30 * tmp1_0;
    // Op 31: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 32: dim1x1 sub_swap
    gl64_t s0_32 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_32 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_32 - s0_32;
    // Op 33: dim1x1 mul
    gl64_t s1_33 = *(gl64_t*)&expressions_params[9][12];
    tmp1_0 = tmp1_0 * s1_33;
    // Op 34: dim1x1 sub_swap
    gl64_t s0_34 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_34 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s1_34 - s0_34;
    // Op 35: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 36: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_0;
    // Op 37: dim1x1 sub_swap
    gl64_t s0_37 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_37 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_37 - s0_37;
    // Op 38: dim1x1 mul
    gl64_t s0_38 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_38 * tmp1_0;
    // Op 39: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_0;
    // Op 40: dim1x1 mul
    gl64_t s0_40 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_40 * tmp1_2;
    // Op 41: dim1x1 add
    tmp1_3 = tmp1_3 + tmp1_0;
    // Op 42: dim1x1 sub_swap
    gl64_t s0_42 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_42 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_42 - s0_42;
    // Op 43: dim1x1 mul
    gl64_t s1_43 = *(gl64_t*)&expressions_params[9][11];
    tmp1_0 = tmp1_0 * s1_43;
    // Op 44: dim1x1 add
    gl64_t s0_44 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_1 = s0_44 + tmp1_0;
    // Op 45: dim1x1 mul
    gl64_t s0_45 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_45 * tmp1_1;
    // Op 46: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_0;
    // Op 47: dim1x1 sub
    gl64_t s0_47 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_47 - tmp1_0;
    // Op 48: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 49: dim3x3 mul
    gl64_t s1_49_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_49_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_49_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA49 = (tmp3_0 + tmp3_1) * (s1_49_0 + s1_49_1);
    gl64_t kB49 = (tmp3_0 + tmp3_2) * (s1_49_0 + s1_49_2);
    gl64_t kC49 = (tmp3_1 + tmp3_2) * (s1_49_1 + s1_49_2);
    gl64_t kD49 = tmp3_0 * s1_49_0;
    gl64_t kE49 = tmp3_1 * s1_49_1;
    gl64_t kF49 = tmp3_2 * s1_49_2;
    gl64_t kG49 = kD49 - kE49;
    tmp3_0 = (kC49 + kG49) - kF49;
    tmp3_1 = ((((kA49 + kC49) - kE49) - kE49) - kD49);
    tmp3_2 = kB49 - kG49;
    // Op 50: dim1x1 mul
    gl64_t s0_50 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_4 = s0_50 * tmp1_4;
    // Op 51: dim1x1 mul
    gl64_t s0_51 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_2 = s0_51 * tmp1_2;
    // Op 52: dim1x1 add
    tmp1_2 = tmp1_4 + tmp1_2;
    // Op 53: dim1x1 mul
    gl64_t s0_53 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_1 = s0_53 * tmp1_1;
    // Op 54: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_1;
    // Op 55: dim1x1 sub
    gl64_t s0_55 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_1 = s0_55 - tmp1_1;
    // Op 56: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 57: dim3x3 mul
    gl64_t s1_57_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_57_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_57_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA57 = (tmp3_0 + tmp3_1) * (s1_57_0 + s1_57_1);
    gl64_t kB57 = (tmp3_0 + tmp3_2) * (s1_57_0 + s1_57_2);
    gl64_t kC57 = (tmp3_1 + tmp3_2) * (s1_57_1 + s1_57_2);
    gl64_t kD57 = tmp3_0 * s1_57_0;
    gl64_t kE57 = tmp3_1 * s1_57_1;
    gl64_t kF57 = tmp3_2 * s1_57_2;
    gl64_t kG57 = kD57 - kE57;
    tmp3_0 = (kC57 + kG57) - kF57;
    tmp3_1 = ((((kA57 + kC57) - kE57) - kE57) - kD57);
    tmp3_2 = kB57 - kG57;
    // Op 58: dim1x1 sub
    gl64_t s0_58 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_58 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_1 = s0_58 - s1_58;
    // Op 59: dim1x1 mul
    gl64_t s0_59 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_1 = s0_59 * tmp1_1;
    // Op 60: dim1x1 add
    gl64_t s0_60 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_1 = s0_60 + tmp1_1;
    // Op 61: dim1x1 sub
    gl64_t s0_61 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_1 = s0_61 - tmp1_1;
    // Op 62: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 63: dim3x3 mul
    gl64_t s1_63_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_63_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_63_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA63 = (tmp3_0 + tmp3_1) * (s1_63_0 + s1_63_1);
    gl64_t kB63 = (tmp3_0 + tmp3_2) * (s1_63_0 + s1_63_2);
    gl64_t kC63 = (tmp3_1 + tmp3_2) * (s1_63_1 + s1_63_2);
    gl64_t kD63 = tmp3_0 * s1_63_0;
    gl64_t kE63 = tmp3_1 * s1_63_1;
    gl64_t kF63 = tmp3_2 * s1_63_2;
    gl64_t kG63 = kD63 - kE63;
    tmp3_0 = (kC63 + kG63) - kF63;
    tmp3_1 = ((((kA63 + kC63) - kE63) - kE63) - kD63);
    tmp3_2 = kB63 - kG63;
    // Op 64: dim1x1 sub
    gl64_t s0_64 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_64 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_1 = s0_64 - s1_64;
    // Op 65: dim1x1 mul
    gl64_t s0_65 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_1 = s0_65 * tmp1_1;
    // Op 66: dim1x1 add
    gl64_t s0_66 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_1 = s0_66 + tmp1_1;
    // Op 67: dim1x1 sub
    gl64_t s0_67 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_1 = s0_67 - tmp1_1;
    // Op 68: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 69: dim3x3 mul
    gl64_t s1_69_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_69_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_69_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA69 = (tmp3_0 + tmp3_1) * (s1_69_0 + s1_69_1);
    gl64_t kB69 = (tmp3_0 + tmp3_2) * (s1_69_0 + s1_69_2);
    gl64_t kC69 = (tmp3_1 + tmp3_2) * (s1_69_1 + s1_69_2);
    gl64_t kD69 = tmp3_0 * s1_69_0;
    gl64_t kE69 = tmp3_1 * s1_69_1;
    gl64_t kF69 = tmp3_2 * s1_69_2;
    gl64_t kG69 = kD69 - kE69;
    tmp3_12 = (kC69 + kG69) - kF69;
    tmp3_13 = ((((kA69 + kC69) - kE69) - kE69) - kD69);
    tmp3_14 = kB69 - kG69;
    // Op 70: dim3x1 mul
    gl64_t s0_70_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_70_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_70_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_70 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp3_0 = s0_70_0 * s1_70; tmp3_1 = s0_70_1 * s1_70; tmp3_2 = s0_70_2 * s1_70;
    // Op 71: dim3x1 add
    gl64_t s1_71 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_71; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 72: dim3x3 mul
    gl64_t s1_72_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_72_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_72_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA72 = (tmp3_0 + tmp3_1) * (s1_72_0 + s1_72_1);
    gl64_t kB72 = (tmp3_0 + tmp3_2) * (s1_72_0 + s1_72_2);
    gl64_t kC72 = (tmp3_1 + tmp3_2) * (s1_72_1 + s1_72_2);
    gl64_t kD72 = tmp3_0 * s1_72_0;
    gl64_t kE72 = tmp3_1 * s1_72_1;
    gl64_t kF72 = tmp3_2 * s1_72_2;
    gl64_t kG72 = kD72 - kE72;
    tmp3_0 = (kC72 + kG72) - kF72;
    tmp3_1 = ((((kA72 + kC72) - kE72) - kE72) - kD72);
    tmp3_2 = kB72 - kG72;
    // Op 73: dim3x1 add
    gl64_t s1_73 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_73; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 74: dim3x3 mul
    gl64_t s1_74_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_74_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_74_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA74 = (tmp3_0 + tmp3_1) * (s1_74_0 + s1_74_1);
    gl64_t kB74 = (tmp3_0 + tmp3_2) * (s1_74_0 + s1_74_2);
    gl64_t kC74 = (tmp3_1 + tmp3_2) * (s1_74_1 + s1_74_2);
    gl64_t kD74 = tmp3_0 * s1_74_0;
    gl64_t kE74 = tmp3_1 * s1_74_1;
    gl64_t kF74 = tmp3_2 * s1_74_2;
    gl64_t kG74 = kD74 - kE74;
    tmp3_0 = (kC74 + kG74) - kF74;
    tmp3_1 = ((((kA74 + kC74) - kE74) - kE74) - kD74);
    tmp3_2 = kB74 - kG74;
    // Op 75: dim1x1 add
    gl64_t s0_75 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_75 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s0_75 + s1_75;
    // Op 76: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 77: dim3x3 mul
    gl64_t s1_77_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_77_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_77_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA77 = (tmp3_0 + tmp3_1) * (s1_77_0 + s1_77_1);
    gl64_t kB77 = (tmp3_0 + tmp3_2) * (s1_77_0 + s1_77_2);
    gl64_t kC77 = (tmp3_1 + tmp3_2) * (s1_77_1 + s1_77_2);
    gl64_t kD77 = tmp3_0 * s1_77_0;
    gl64_t kE77 = tmp3_1 * s1_77_1;
    gl64_t kF77 = tmp3_2 * s1_77_2;
    gl64_t kG77 = kD77 - kE77;
    tmp3_0 = (kC77 + kG77) - kF77;
    tmp3_1 = ((((kA77 + kC77) - kE77) - kE77) - kD77);
    tmp3_2 = kB77 - kG77;
    // Op 78: dim1x1 mul
    gl64_t s0_78 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_78 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s0_78 * s1_78;
    // Op 79: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 80: dim3x3 mul
    gl64_t s1_80_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_80_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_80_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA80 = (tmp3_0 + tmp3_1) * (s1_80_0 + s1_80_1);
    gl64_t kB80 = (tmp3_0 + tmp3_2) * (s1_80_0 + s1_80_2);
    gl64_t kC80 = (tmp3_1 + tmp3_2) * (s1_80_1 + s1_80_2);
    gl64_t kD80 = tmp3_0 * s1_80_0;
    gl64_t kE80 = tmp3_1 * s1_80_1;
    gl64_t kF80 = tmp3_2 * s1_80_2;
    gl64_t kG80 = kD80 - kE80;
    tmp3_0 = (kC80 + kG80) - kF80;
    tmp3_1 = ((((kA80 + kC80) - kE80) - kE80) - kD80);
    tmp3_2 = kB80 - kG80;
    // Op 81: dim3x1 add
    gl64_t s1_81 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_81; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 82: dim3x3 mul
    gl64_t s1_82_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_82_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_82_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA82 = (tmp3_0 + tmp3_1) * (s1_82_0 + s1_82_1);
    gl64_t kB82 = (tmp3_0 + tmp3_2) * (s1_82_0 + s1_82_2);
    gl64_t kC82 = (tmp3_1 + tmp3_2) * (s1_82_1 + s1_82_2);
    gl64_t kD82 = tmp3_0 * s1_82_0;
    gl64_t kE82 = tmp3_1 * s1_82_1;
    gl64_t kF82 = tmp3_2 * s1_82_2;
    gl64_t kG82 = kD82 - kE82;
    tmp3_0 = (kC82 + kG82) - kF82;
    tmp3_1 = ((((kA82 + kC82) - kE82) - kE82) - kD82);
    tmp3_2 = kB82 - kG82;
    // Op 83: dim3x1 add
    gl64_t s1_83 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_0 + s1_83; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 84: dim3x3 add
    gl64_t s1_84_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_84_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_84_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_84_0; tmp3_4 = tmp3_10 + s1_84_1; tmp3_5 = tmp3_11 + s1_84_2;
    // Op 85: dim3x1 mul
    gl64_t s0_85_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_85_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_85_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_85 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp3_0 = s0_85_0 * s1_85; tmp3_1 = s0_85_1 * s1_85; tmp3_2 = s0_85_2 * s1_85;
    // Op 86: dim3x1 add
    gl64_t s1_86 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_86; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 87: dim3x3 mul
    gl64_t s1_87_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_87_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_87_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA87 = (tmp3_0 + tmp3_1) * (s1_87_0 + s1_87_1);
    gl64_t kB87 = (tmp3_0 + tmp3_2) * (s1_87_0 + s1_87_2);
    gl64_t kC87 = (tmp3_1 + tmp3_2) * (s1_87_1 + s1_87_2);
    gl64_t kD87 = tmp3_0 * s1_87_0;
    gl64_t kE87 = tmp3_1 * s1_87_1;
    gl64_t kF87 = tmp3_2 * s1_87_2;
    gl64_t kG87 = kD87 - kE87;
    tmp3_0 = (kC87 + kG87) - kF87;
    tmp3_1 = ((((kA87 + kC87) - kE87) - kE87) - kD87);
    tmp3_2 = kB87 - kG87;
    // Op 88: dim3x1 add
    gl64_t s1_88 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_88; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 89: dim3x3 mul
    gl64_t s1_89_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_89_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_89_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA89 = (tmp3_0 + tmp3_1) * (s1_89_0 + s1_89_1);
    gl64_t kB89 = (tmp3_0 + tmp3_2) * (s1_89_0 + s1_89_2);
    gl64_t kC89 = (tmp3_1 + tmp3_2) * (s1_89_1 + s1_89_2);
    gl64_t kD89 = tmp3_0 * s1_89_0;
    gl64_t kE89 = tmp3_1 * s1_89_1;
    gl64_t kF89 = tmp3_2 * s1_89_2;
    gl64_t kG89 = kD89 - kE89;
    tmp3_0 = (kC89 + kG89) - kF89;
    tmp3_1 = ((((kA89 + kC89) - kE89) - kE89) - kD89);
    tmp3_2 = kB89 - kG89;
    // Op 90: dim1x1 mul
    gl64_t s0_90 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_90 = *(gl64_t*)&expressions_params[9][1];
    tmp1_4 = s0_90 * s1_90;
    // Op 91: dim1x1 mul
    gl64_t s0_91 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_91 = *(gl64_t*)&expressions_params[9][2];
    tmp1_1 = s0_91 * s1_91;
    // Op 92: dim1x1 mul
    gl64_t s0_92 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_92 = *(gl64_t*)&expressions_params[9][3];
    tmp1_2 = s0_92 * s1_92;
    // Op 93: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_2;
    // Op 94: dim1x1 add
    gl64_t s0_94 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_1 = s0_94 + tmp1_1;
    // Op 95: dim1x1 add
    tmp1_1 = tmp1_4 + tmp1_1;
    // Op 96: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 97: dim3x3 mul
    gl64_t s1_97_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_97_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_97_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA97 = (tmp3_0 + tmp3_1) * (s1_97_0 + s1_97_1);
    gl64_t kB97 = (tmp3_0 + tmp3_2) * (s1_97_0 + s1_97_2);
    gl64_t kC97 = (tmp3_1 + tmp3_2) * (s1_97_1 + s1_97_2);
    gl64_t kD97 = tmp3_0 * s1_97_0;
    gl64_t kE97 = tmp3_1 * s1_97_1;
    gl64_t kF97 = tmp3_2 * s1_97_2;
    gl64_t kG97 = kD97 - kE97;
    tmp3_0 = (kC97 + kG97) - kF97;
    tmp3_1 = ((((kA97 + kC97) - kE97) - kE97) - kD97);
    tmp3_2 = kB97 - kG97;
    // Op 98: dim3x1 add
    gl64_t s1_98 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_98; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 99: dim3x3 mul
    gl64_t s1_99_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_99_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_99_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA99 = (tmp3_0 + tmp3_1) * (s1_99_0 + s1_99_1);
    gl64_t kB99 = (tmp3_0 + tmp3_2) * (s1_99_0 + s1_99_2);
    gl64_t kC99 = (tmp3_1 + tmp3_2) * (s1_99_1 + s1_99_2);
    gl64_t kD99 = tmp3_0 * s1_99_0;
    gl64_t kE99 = tmp3_1 * s1_99_1;
    gl64_t kF99 = tmp3_2 * s1_99_2;
    gl64_t kG99 = kD99 - kE99;
    tmp3_0 = (kC99 + kG99) - kF99;
    tmp3_1 = ((((kA99 + kC99) - kE99) - kE99) - kD99);
    tmp3_2 = kB99 - kG99;
    // Op 100: dim3x1 add
    gl64_t s1_100 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_0 + s1_100; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 101: dim3x3 add
    gl64_t s1_101_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_101_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_101_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_101_0; tmp3_1 = tmp3_7 + s1_101_1; tmp3_2 = tmp3_8 + s1_101_2;
    // Op 102: dim3x3 mul
    gl64_t kA102 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB102 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC102 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD102 = tmp3_3 * tmp3_0;
    gl64_t kE102 = tmp3_4 * tmp3_1;
    gl64_t kF102 = tmp3_5 * tmp3_2;
    gl64_t kG102 = kD102 - kE102;
    tmp3_0 = (kC102 + kG102) - kF102;
    tmp3_1 = ((((kA102 + kC102) - kE102) - kE102) - kD102);
    tmp3_2 = kB102 - kG102;
    // Op 103: dim3x3 mul
    gl64_t s0_103_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_103_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_103_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA103 = (s0_103_0 + s0_103_1) * (tmp3_0 + tmp3_1);
    gl64_t kB103 = (s0_103_0 + s0_103_2) * (tmp3_0 + tmp3_2);
    gl64_t kC103 = (s0_103_1 + s0_103_2) * (tmp3_1 + tmp3_2);
    gl64_t kD103 = s0_103_0 * tmp3_0;
    gl64_t kE103 = s0_103_1 * tmp3_1;
    gl64_t kF103 = s0_103_2 * tmp3_2;
    gl64_t kG103 = kD103 - kE103;
    tmp3_0 = (kC103 + kG103) - kF103;
    tmp3_1 = ((((kA103 + kC103) - kE103) - kE103) - kD103);
    tmp3_2 = kB103 - kG103;
    // Op 104: dim3x3 add
    gl64_t s1_104_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_104_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_104_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_104_0; tmp3_7 = tmp3_7 + s1_104_1; tmp3_8 = tmp3_8 + s1_104_2;
    // Op 105: dim3x1 mul
    gl64_t s1_105 = *(gl64_t*)&expressions_params[9][5];
    tmp3_6 = tmp3_6 * s1_105; tmp3_7 = tmp3_7 * s1_105; tmp3_8 = tmp3_8 * s1_105;
    // Op 106: dim3x3 add
    gl64_t s1_106_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_106_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_106_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_106_0; tmp3_10 = tmp3_10 + s1_106_1; tmp3_11 = tmp3_11 + s1_106_2;
    // Op 107: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 108: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 109: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 110: dim3x3 mul
    gl64_t s1_110_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_110_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_110_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA110 = (tmp3_0 + tmp3_1) * (s1_110_0 + s1_110_1);
    gl64_t kB110 = (tmp3_0 + tmp3_2) * (s1_110_0 + s1_110_2);
    gl64_t kC110 = (tmp3_1 + tmp3_2) * (s1_110_1 + s1_110_2);
    gl64_t kD110 = tmp3_0 * s1_110_0;
    gl64_t kE110 = tmp3_1 * s1_110_1;
    gl64_t kF110 = tmp3_2 * s1_110_2;
    gl64_t kG110 = kD110 - kE110;
    tmp3_3 = (kC110 + kG110) - kF110;
    tmp3_4 = ((((kA110 + kC110) - kE110) - kE110) - kD110);
    tmp3_5 = kB110 - kG110;
    // Op 111: dim3x1 mul
    gl64_t s0_111_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_111_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_111_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_111 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp3_0 = s0_111_0 * s1_111; tmp3_1 = s0_111_1 * s1_111; tmp3_2 = s0_111_2 * s1_111;
    // Op 112: dim3x1 add
    gl64_t s1_112 = *(gl64_t*)&expressions_params[9][7];
    tmp3_9 = tmp3_0 + s1_112; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 113: dim3x3 add
    gl64_t s1_113_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_113_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_113_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_113_0; tmp3_13 = tmp3_10 + s1_113_1; tmp3_14 = tmp3_11 + s1_113_2;
    // Op 114: dim3x1 mul
    gl64_t s0_114_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_114_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_114_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_114 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp3_0 = s0_114_0 * s1_114; tmp3_1 = s0_114_1 * s1_114; tmp3_2 = s0_114_2 * s1_114;
    // Op 115: dim3x1 add
    gl64_t s1_115 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_115; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 116: dim3x3 mul
    gl64_t s1_116_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_116_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_116_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA116 = (tmp3_0 + tmp3_1) * (s1_116_0 + s1_116_1);
    gl64_t kB116 = (tmp3_0 + tmp3_2) * (s1_116_0 + s1_116_2);
    gl64_t kC116 = (tmp3_1 + tmp3_2) * (s1_116_1 + s1_116_2);
    gl64_t kD116 = tmp3_0 * s1_116_0;
    gl64_t kE116 = tmp3_1 * s1_116_1;
    gl64_t kF116 = tmp3_2 * s1_116_2;
    gl64_t kG116 = kD116 - kE116;
    tmp3_0 = (kC116 + kG116) - kF116;
    tmp3_1 = ((((kA116 + kC116) - kE116) - kE116) - kD116);
    tmp3_2 = kB116 - kG116;
    // Op 117: dim3x1 add
    gl64_t s1_117 = *(gl64_t*)&expressions_params[9][6];
    tmp3_6 = tmp3_0 + s1_117; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 118: dim3x3 add
    gl64_t s1_118_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_118_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_118_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_118_0; tmp3_1 = tmp3_7 + s1_118_1; tmp3_2 = tmp3_8 + s1_118_2;
    // Op 119: dim3x3 mul
    gl64_t kA119 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB119 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC119 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD119 = tmp3_12 * tmp3_0;
    gl64_t kE119 = tmp3_13 * tmp3_1;
    gl64_t kF119 = tmp3_14 * tmp3_2;
    gl64_t kG119 = kD119 - kE119;
    tmp3_0 = (kC119 + kG119) - kF119;
    tmp3_1 = ((((kA119 + kC119) - kE119) - kE119) - kD119);
    tmp3_2 = kB119 - kG119;
    // Op 120: dim3x3 mul
    gl64_t s0_120_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_120_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_120_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA120 = (s0_120_0 + s0_120_1) * (tmp3_0 + tmp3_1);
    gl64_t kB120 = (s0_120_0 + s0_120_2) * (tmp3_0 + tmp3_2);
    gl64_t kC120 = (s0_120_1 + s0_120_2) * (tmp3_1 + tmp3_2);
    gl64_t kD120 = s0_120_0 * tmp3_0;
    gl64_t kE120 = s0_120_1 * tmp3_1;
    gl64_t kF120 = s0_120_2 * tmp3_2;
    gl64_t kG120 = kD120 - kE120;
    tmp3_0 = (kC120 + kG120) - kF120;
    tmp3_1 = ((((kA120 + kC120) - kE120) - kE120) - kD120);
    tmp3_2 = kB120 - kG120;
    // Op 121: dim3x3 add
    gl64_t s1_121_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_121_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_121_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_121_0; tmp3_7 = tmp3_7 + s1_121_1; tmp3_8 = tmp3_8 + s1_121_2;
    // Op 122: dim3x1 mul
    gl64_t s1_122 = *(gl64_t*)&expressions_params[9][5];
    tmp3_6 = tmp3_6 * s1_122; tmp3_7 = tmp3_7 * s1_122; tmp3_8 = tmp3_8 * s1_122;
    // Op 123: dim3x3 add
    gl64_t s1_123_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_123_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_123_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_123_0; tmp3_10 = tmp3_10 + s1_123_1; tmp3_11 = tmp3_11 + s1_123_2;
    // Op 124: dim3x1 mul
    gl64_t s1_124 = *(gl64_t*)&expressions_params[9][5];
    tmp3_9 = tmp3_9 * s1_124; tmp3_10 = tmp3_10 * s1_124; tmp3_11 = tmp3_11 * s1_124;
    // Op 125: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 126: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 127: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 128: dim3x3 mul
    gl64_t s1_128_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_128_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_128_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA128 = (tmp3_0 + tmp3_1) * (s1_128_0 + s1_128_1);
    gl64_t kB128 = (tmp3_0 + tmp3_2) * (s1_128_0 + s1_128_2);
    gl64_t kC128 = (tmp3_1 + tmp3_2) * (s1_128_1 + s1_128_2);
    gl64_t kD128 = tmp3_0 * s1_128_0;
    gl64_t kE128 = tmp3_1 * s1_128_1;
    gl64_t kF128 = tmp3_2 * s1_128_2;
    gl64_t kG128 = kD128 - kE128;
    tmp3_3 = (kC128 + kG128) - kF128;
    tmp3_4 = ((((kA128 + kC128) - kE128) - kE128) - kD128);
    tmp3_5 = kB128 - kG128;
    // Op 129: dim1x1 sub
    gl64_t s0_129 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_129 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_1 = s0_129 - s1_129;
    // Op 130: dim1x1 mul
    gl64_t s0_130 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_1 = s0_130 * tmp1_1;
    // Op 131: dim1x1 add
    gl64_t s0_131 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_1 = s0_131 + tmp1_1;
    // Op 132: dim3x1 mul
    gl64_t s0_132_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_132_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_132_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_132_0 * tmp1_1; tmp3_1 = s0_132_1 * tmp1_1; tmp3_2 = s0_132_2 * tmp1_1;
    // Op 133: dim1x1 sub
    gl64_t s0_133 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_133 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_1 = s0_133 - s1_133;
    // Op 134: dim1x1 mul
    gl64_t s0_134 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_1 = s0_134 * tmp1_1;
    // Op 135: dim1x1 add
    gl64_t s0_135 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_1 = s0_135 + tmp1_1;
    // Op 136: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 137: dim3x3 mul
    gl64_t s1_137_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_137_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_137_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA137 = (tmp3_0 + tmp3_1) * (s1_137_0 + s1_137_1);
    gl64_t kB137 = (tmp3_0 + tmp3_2) * (s1_137_0 + s1_137_2);
    gl64_t kC137 = (tmp3_1 + tmp3_2) * (s1_137_1 + s1_137_2);
    gl64_t kD137 = tmp3_0 * s1_137_0;
    gl64_t kE137 = tmp3_1 * s1_137_1;
    gl64_t kF137 = tmp3_2 * s1_137_2;
    gl64_t kG137 = kD137 - kE137;
    tmp3_0 = (kC137 + kG137) - kF137;
    tmp3_1 = ((((kA137 + kC137) - kE137) - kE137) - kD137);
    tmp3_2 = kB137 - kG137;
    // Op 138: dim3x1 add
    gl64_t s1_138 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_138; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 139: dim3x3 mul
    gl64_t s1_139_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_139_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_139_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA139 = (tmp3_0 + tmp3_1) * (s1_139_0 + s1_139_1);
    gl64_t kB139 = (tmp3_0 + tmp3_2) * (s1_139_0 + s1_139_2);
    gl64_t kC139 = (tmp3_1 + tmp3_2) * (s1_139_1 + s1_139_2);
    gl64_t kD139 = tmp3_0 * s1_139_0;
    gl64_t kE139 = tmp3_1 * s1_139_1;
    gl64_t kF139 = tmp3_2 * s1_139_2;
    gl64_t kG139 = kD139 - kE139;
    tmp3_0 = (kC139 + kG139) - kF139;
    tmp3_1 = ((((kA139 + kC139) - kE139) - kE139) - kD139);
    tmp3_2 = kB139 - kG139;
    // Op 140: dim3x1 add
    gl64_t s1_140 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_140; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 141: dim3x3 mul
    gl64_t s1_141_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_141_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_141_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA141 = (tmp3_0 + tmp3_1) * (s1_141_0 + s1_141_1);
    gl64_t kB141 = (tmp3_0 + tmp3_2) * (s1_141_0 + s1_141_2);
    gl64_t kC141 = (tmp3_1 + tmp3_2) * (s1_141_1 + s1_141_2);
    gl64_t kD141 = tmp3_0 * s1_141_0;
    gl64_t kE141 = tmp3_1 * s1_141_1;
    gl64_t kF141 = tmp3_2 * s1_141_2;
    gl64_t kG141 = kD141 - kE141;
    tmp3_0 = (kC141 + kG141) - kF141;
    tmp3_1 = ((((kA141 + kC141) - kE141) - kE141) - kD141);
    tmp3_2 = kB141 - kG141;
    // Op 142: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 143: dim3x3 mul
    gl64_t s1_143_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_143_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_143_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA143 = (tmp3_0 + tmp3_1) * (s1_143_0 + s1_143_1);
    gl64_t kB143 = (tmp3_0 + tmp3_2) * (s1_143_0 + s1_143_2);
    gl64_t kC143 = (tmp3_1 + tmp3_2) * (s1_143_1 + s1_143_2);
    gl64_t kD143 = tmp3_0 * s1_143_0;
    gl64_t kE143 = tmp3_1 * s1_143_1;
    gl64_t kF143 = tmp3_2 * s1_143_2;
    gl64_t kG143 = kD143 - kE143;
    tmp3_0 = (kC143 + kG143) - kF143;
    tmp3_1 = ((((kA143 + kC143) - kE143) - kE143) - kD143);
    tmp3_2 = kB143 - kG143;
    // Op 144: dim3x1 add
    gl64_t s1_144 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_144; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 145: dim3x3 mul
    gl64_t s1_145_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_145_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_145_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA145 = (tmp3_0 + tmp3_1) * (s1_145_0 + s1_145_1);
    gl64_t kB145 = (tmp3_0 + tmp3_2) * (s1_145_0 + s1_145_2);
    gl64_t kC145 = (tmp3_1 + tmp3_2) * (s1_145_1 + s1_145_2);
    gl64_t kD145 = tmp3_0 * s1_145_0;
    gl64_t kE145 = tmp3_1 * s1_145_1;
    gl64_t kF145 = tmp3_2 * s1_145_2;
    gl64_t kG145 = kD145 - kE145;
    tmp3_0 = (kC145 + kG145) - kF145;
    tmp3_1 = ((((kA145 + kC145) - kE145) - kE145) - kD145);
    tmp3_2 = kB145 - kG145;
    // Op 146: dim3x1 add
    gl64_t s1_146 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_146; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 147: dim3x3 add
    gl64_t s1_147_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_147_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_147_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_147_0; tmp3_1 = tmp3_1 + s1_147_1; tmp3_2 = tmp3_2 + s1_147_2;
    // Op 148: dim3x3 mul
    uint64_t s0_148_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_148_0 = *(gl64_t*)&dParams->aux_trace[s0_148_pos];
    gl64_t s0_148_1 = *(gl64_t*)&dParams->aux_trace[s0_148_pos + TILE_HEIGHT];
    gl64_t s0_148_2 = *(gl64_t*)&dParams->aux_trace[s0_148_pos + 2*TILE_HEIGHT];
    gl64_t kA148 = (s0_148_0 + s0_148_1) * (tmp3_0 + tmp3_1);
    gl64_t kB148 = (s0_148_0 + s0_148_2) * (tmp3_0 + tmp3_2);
    gl64_t kC148 = (s0_148_1 + s0_148_2) * (tmp3_1 + tmp3_2);
    gl64_t kD148 = s0_148_0 * tmp3_0;
    gl64_t kE148 = s0_148_1 * tmp3_1;
    gl64_t kF148 = s0_148_2 * tmp3_2;
    gl64_t kG148 = kD148 - kE148;
    tmp3_0 = (kC148 + kG148) - kF148;
    tmp3_1 = ((((kA148 + kC148) - kE148) - kE148) - kD148);
    tmp3_2 = kB148 - kG148;
    // Op 149: dim3x1 add
    gl64_t s1_149 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_149; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 150: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 151: dim3x3 mul
    gl64_t s1_151_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_151_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_151_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA151 = (tmp3_0 + tmp3_1) * (s1_151_0 + s1_151_1);
    gl64_t kB151 = (tmp3_0 + tmp3_2) * (s1_151_0 + s1_151_2);
    gl64_t kC151 = (tmp3_1 + tmp3_2) * (s1_151_1 + s1_151_2);
    gl64_t kD151 = tmp3_0 * s1_151_0;
    gl64_t kE151 = tmp3_1 * s1_151_1;
    gl64_t kF151 = tmp3_2 * s1_151_2;
    gl64_t kG151 = kD151 - kE151;
    tmp3_6 = (kC151 + kG151) - kF151;
    tmp3_7 = ((((kA151 + kC151) - kE151) - kE151) - kD151);
    tmp3_8 = kB151 - kG151;
    // Op 152: dim1x1 sub_swap
    gl64_t s0_152 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_152 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_152 - s0_152;
    // Op 153: dim3x1 mul
    uint64_t s0_153_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_153_0 = *(gl64_t*)&dParams->aux_trace[s0_153_pos];
    gl64_t s0_153_1 = *(gl64_t*)&dParams->aux_trace[s0_153_pos + TILE_HEIGHT];
    gl64_t s0_153_2 = *(gl64_t*)&dParams->aux_trace[s0_153_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_153_0 * tmp1_0; tmp3_1 = s0_153_1 * tmp1_0; tmp3_2 = s0_153_2 * tmp1_0;
    // Op 154: dim3x3 sub
    uint64_t s0_154_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_154_0 = *(gl64_t*)&dParams->aux_trace[s0_154_pos];
    gl64_t s0_154_1 = *(gl64_t*)&dParams->aux_trace[s0_154_pos + TILE_HEIGHT];
    gl64_t s0_154_2 = *(gl64_t*)&dParams->aux_trace[s0_154_pos + 2*TILE_HEIGHT];
    tmp3_3 = s0_154_0 - tmp3_0; tmp3_4 = s0_154_1 - tmp3_1; tmp3_5 = s0_154_2 - tmp3_2;
    // Op 155: dim3x3 add
    gl64_t s0_155_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_155_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_155_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_155_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_155_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_155_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_0 = s0_155_0 + s1_155_0; tmp3_1 = s0_155_1 + s1_155_1; tmp3_2 = s0_155_2 + s1_155_2;
    // Op 156: dim3x3 add
    uint64_t s0_156_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_156_0 = *(gl64_t*)&dParams->aux_trace[s0_156_pos];
    gl64_t s0_156_1 = *(gl64_t*)&dParams->aux_trace[s0_156_pos + TILE_HEIGHT];
    gl64_t s0_156_2 = *(gl64_t*)&dParams->aux_trace[s0_156_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_156_0 + tmp3_0; tmp3_1 = s0_156_1 + tmp3_1; tmp3_2 = s0_156_2 + tmp3_2;
    // Op 157: dim3x3 sub
    tmp3_3 = tmp3_3 - tmp3_0; tmp3_4 = tmp3_4 - tmp3_1; tmp3_5 = tmp3_5 - tmp3_2;
    // Op 158: dim3x1 mul
    gl64_t s0_158_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_158_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_158_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_158 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp3_0 = s0_158_0 * s1_158; tmp3_1 = s0_158_1 * s1_158; tmp3_2 = s0_158_2 * s1_158;
    // Op 159: dim3x1 add
    gl64_t s1_159 = *(gl64_t*)&expressions_params[9][8];
    tmp3_0 = tmp3_0 + s1_159; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 160: dim3x3 add
    gl64_t s1_160_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_160_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_160_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_160_0; tmp3_1 = tmp3_1 + s1_160_1; tmp3_2 = tmp3_2 + s1_160_2;
    // Op 161: dim3x3 mul
    gl64_t kA161 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB161 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC161 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD161 = tmp3_3 * tmp3_0;
    gl64_t kE161 = tmp3_4 * tmp3_1;
    gl64_t kF161 = tmp3_5 * tmp3_2;
    gl64_t kG161 = kD161 - kE161;
    tmp3_0 = (kC161 + kG161) - kF161;
    tmp3_1 = ((((kA161 + kC161) - kE161) - kE161) - kD161);
    tmp3_2 = kB161 - kG161;
    // Op 162: dim3x1 add
    gl64_t s1_162 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_162; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 163: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 164: dim3x3 mul
    gl64_t s1_164_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_164_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_164_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA164 = (tmp3_0 + tmp3_1) * (s1_164_0 + s1_164_1);
    gl64_t kB164 = (tmp3_0 + tmp3_2) * (s1_164_0 + s1_164_2);
    gl64_t kC164 = (tmp3_1 + tmp3_2) * (s1_164_1 + s1_164_2);
    gl64_t kD164 = tmp3_0 * s1_164_0;
    gl64_t kE164 = tmp3_1 * s1_164_1;
    gl64_t kF164 = tmp3_2 * s1_164_2;
    gl64_t kG164 = kD164 - kE164;
    tmp3_6 = (kC164 + kG164) - kF164;
    tmp3_7 = ((((kA164 + kC164) - kE164) - kE164) - kD164);
    tmp3_8 = kB164 - kG164;
    // Op 165: dim3x1 mul
    gl64_t s0_165_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_165_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_165_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_165 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = s0_165_0 * s1_165; tmp3_1 = s0_165_1 * s1_165; tmp3_2 = s0_165_2 * s1_165;
    // Op 166: dim3x3 mul
    gl64_t s1_166_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_166_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_166_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA166 = (tmp3_0 + tmp3_1) * (s1_166_0 + s1_166_1);
    gl64_t kB166 = (tmp3_0 + tmp3_2) * (s1_166_0 + s1_166_2);
    gl64_t kC166 = (tmp3_1 + tmp3_2) * (s1_166_1 + s1_166_2);
    gl64_t kD166 = tmp3_0 * s1_166_0;
    gl64_t kE166 = tmp3_1 * s1_166_1;
    gl64_t kF166 = tmp3_2 * s1_166_2;
    gl64_t kG166 = kD166 - kE166;
    tmp3_0 = (kC166 + kG166) - kF166;
    tmp3_1 = ((((kA166 + kC166) - kE166) - kE166) - kD166);
    tmp3_2 = kB166 - kG166;
    // Op 167: dim3x3 mul
    gl64_t s1_167_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_167_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_167_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA167 = (tmp3_0 + tmp3_1) * (s1_167_0 + s1_167_1);
    gl64_t kB167 = (tmp3_0 + tmp3_2) * (s1_167_0 + s1_167_2);
    gl64_t kC167 = (tmp3_1 + tmp3_2) * (s1_167_1 + s1_167_2);
    gl64_t kD167 = tmp3_0 * s1_167_0;
    gl64_t kE167 = tmp3_1 * s1_167_1;
    gl64_t kF167 = tmp3_2 * s1_167_2;
    gl64_t kG167 = kD167 - kE167;
    tmp3_0 = (kC167 + kG167) - kF167;
    tmp3_1 = ((((kA167 + kC167) - kE167) - kE167) - kD167);
    tmp3_2 = kB167 - kG167;
    // Op 168: dim3x1 add
    gl64_t s1_168 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_168; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 169: dim3x3 mul
    gl64_t s1_169_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_169_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_169_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA169 = (tmp3_0 + tmp3_1) * (s1_169_0 + s1_169_1);
    gl64_t kB169 = (tmp3_0 + tmp3_2) * (s1_169_0 + s1_169_2);
    gl64_t kC169 = (tmp3_1 + tmp3_2) * (s1_169_1 + s1_169_2);
    gl64_t kD169 = tmp3_0 * s1_169_0;
    gl64_t kE169 = tmp3_1 * s1_169_1;
    gl64_t kF169 = tmp3_2 * s1_169_2;
    gl64_t kG169 = kD169 - kE169;
    tmp3_0 = (kC169 + kG169) - kF169;
    tmp3_1 = ((((kA169 + kC169) - kE169) - kE169) - kD169);
    tmp3_2 = kB169 - kG169;
    // Op 170: dim3x1 add
    gl64_t s1_170 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_170; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 171: dim3x3 add
    gl64_t s1_171_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_171_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_171_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_171_0; tmp3_1 = tmp3_1 + s1_171_1; tmp3_2 = tmp3_2 + s1_171_2;
    // Op 172: dim3x3 mul
    gl64_t s1_172_0 = *(gl64_t*)&expressions_params[10][1];
    gl64_t s1_172_1 = *(gl64_t*)&expressions_params[10][1+1];
    gl64_t s1_172_2 = *(gl64_t*)&expressions_params[10][1+2];
    gl64_t kA172 = (tmp3_0 + tmp3_1) * (s1_172_0 + s1_172_1);
    gl64_t kB172 = (tmp3_0 + tmp3_2) * (s1_172_0 + s1_172_2);
    gl64_t kC172 = (tmp3_1 + tmp3_2) * (s1_172_1 + s1_172_2);
    gl64_t kD172 = tmp3_0 * s1_172_0;
    gl64_t kE172 = tmp3_1 * s1_172_1;
    gl64_t kF172 = tmp3_2 * s1_172_2;
    gl64_t kG172 = kD172 - kE172;
    tmp3_0 = (kC172 + kG172) - kF172;
    tmp3_1 = ((((kA172 + kC172) - kE172) - kE172) - kD172);
    tmp3_2 = kB172 - kG172;
    // Op 173: dim3x1 sub
    gl64_t s1_173 = *(gl64_t*)&expressions_params[10][0];
    tmp3_0 = tmp3_0 - s1_173; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 174: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 175: dim3x3 mul
    gl64_t s1_175_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_175_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_175_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA175 = (tmp3_0 + tmp3_1) * (s1_175_0 + s1_175_1);
    gl64_t kB175 = (tmp3_0 + tmp3_2) * (s1_175_0 + s1_175_2);
    gl64_t kC175 = (tmp3_1 + tmp3_2) * (s1_175_1 + s1_175_2);
    gl64_t kD175 = tmp3_0 * s1_175_0;
    gl64_t kE175 = tmp3_1 * s1_175_1;
    gl64_t kF175 = tmp3_2 * s1_175_2;
    gl64_t kG175 = kD175 - kE175;
    tmp3_6 = (kC175 + kG175) - kF175;
    tmp3_7 = ((((kA175 + kC175) - kE175) - kE175) - kD175);
    tmp3_8 = kB175 - kG175;
    // Op 176: dim3x3 mul
    gl64_t s0_176_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_176_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_176_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_176_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_176_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_176_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA176 = (s0_176_0 + s0_176_1) * (s1_176_0 + s1_176_1);
    gl64_t kB176 = (s0_176_0 + s0_176_2) * (s1_176_0 + s1_176_2);
    gl64_t kC176 = (s0_176_1 + s0_176_2) * (s1_176_1 + s1_176_2);
    gl64_t kD176 = s0_176_0 * s1_176_0;
    gl64_t kE176 = s0_176_1 * s1_176_1;
    gl64_t kF176 = s0_176_2 * s1_176_2;
    gl64_t kG176 = kD176 - kE176;
    tmp3_0 = (kC176 + kG176) - kF176;
    tmp3_1 = ((((kA176 + kC176) - kE176) - kE176) - kD176);
    tmp3_2 = kB176 - kG176;
    // Op 177: dim3x3 mul
    gl64_t s1_177_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_177_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_177_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA177 = (tmp3_0 + tmp3_1) * (s1_177_0 + s1_177_1);
    gl64_t kB177 = (tmp3_0 + tmp3_2) * (s1_177_0 + s1_177_2);
    gl64_t kC177 = (tmp3_1 + tmp3_2) * (s1_177_1 + s1_177_2);
    gl64_t kD177 = tmp3_0 * s1_177_0;
    gl64_t kE177 = tmp3_1 * s1_177_1;
    gl64_t kF177 = tmp3_2 * s1_177_2;
    gl64_t kG177 = kD177 - kE177;
    tmp3_0 = (kC177 + kG177) - kF177;
    tmp3_1 = ((((kA177 + kC177) - kE177) - kE177) - kD177);
    tmp3_2 = kB177 - kG177;
    // Op 178: dim3x1 add
    gl64_t s1_178 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_178; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 179: dim3x3 mul
    gl64_t s1_179_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_179_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_179_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA179 = (tmp3_0 + tmp3_1) * (s1_179_0 + s1_179_1);
    gl64_t kB179 = (tmp3_0 + tmp3_2) * (s1_179_0 + s1_179_2);
    gl64_t kC179 = (tmp3_1 + tmp3_2) * (s1_179_1 + s1_179_2);
    gl64_t kD179 = tmp3_0 * s1_179_0;
    gl64_t kE179 = tmp3_1 * s1_179_1;
    gl64_t kF179 = tmp3_2 * s1_179_2;
    gl64_t kG179 = kD179 - kE179;
    tmp3_0 = (kC179 + kG179) - kF179;
    tmp3_1 = ((((kA179 + kC179) - kE179) - kE179) - kD179);
    tmp3_2 = kB179 - kG179;
    // Op 180: dim3x1 add
    gl64_t s1_180 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_180; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 181: dim3x3 add
    gl64_t s1_181_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_181_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_181_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_181_0; tmp3_1 = tmp3_1 + s1_181_1; tmp3_2 = tmp3_2 + s1_181_2;
    // Op 182: dim3x3 mul
    gl64_t s1_182_0 = *(gl64_t*)&expressions_params[10][4];
    gl64_t s1_182_1 = *(gl64_t*)&expressions_params[10][4+1];
    gl64_t s1_182_2 = *(gl64_t*)&expressions_params[10][4+2];
    gl64_t kA182 = (tmp3_0 + tmp3_1) * (s1_182_0 + s1_182_1);
    gl64_t kB182 = (tmp3_0 + tmp3_2) * (s1_182_0 + s1_182_2);
    gl64_t kC182 = (tmp3_1 + tmp3_2) * (s1_182_1 + s1_182_2);
    gl64_t kD182 = tmp3_0 * s1_182_0;
    gl64_t kE182 = tmp3_1 * s1_182_1;
    gl64_t kF182 = tmp3_2 * s1_182_2;
    gl64_t kG182 = kD182 - kE182;
    tmp3_0 = (kC182 + kG182) - kF182;
    tmp3_1 = ((((kA182 + kC182) - kE182) - kE182) - kD182);
    tmp3_2 = kB182 - kG182;
    // Op 183: dim1x1 sub
    gl64_t s0_183 = *(gl64_t*)&expressions_params[9][9];
    gl64_t s1_183 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_183 - s1_183;
    // Op 184: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 185: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 186: dim3x3 mul
    gl64_t s1_186_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_186_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_186_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA186 = (tmp3_0 + tmp3_1) * (s1_186_0 + s1_186_1);
    gl64_t kB186 = (tmp3_0 + tmp3_2) * (s1_186_0 + s1_186_2);
    gl64_t kC186 = (tmp3_1 + tmp3_2) * (s1_186_1 + s1_186_2);
    gl64_t kD186 = tmp3_0 * s1_186_0;
    gl64_t kE186 = tmp3_1 * s1_186_1;
    gl64_t kF186 = tmp3_2 * s1_186_2;
    gl64_t kG186 = kD186 - kE186;
    tmp3_6 = (kC186 + kG186) - kF186;
    tmp3_7 = ((((kA186 + kC186) - kE186) - kE186) - kD186);
    tmp3_8 = kB186 - kG186;
    // Op 187: dim3x1 mul
    gl64_t s0_187_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_187_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_187_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_187 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = s0_187_0 * s1_187; tmp3_1 = s0_187_1 * s1_187; tmp3_2 = s0_187_2 * s1_187;
    // Op 188: dim3x1 add
    gl64_t s1_188 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_188; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 189: dim3x3 mul
    gl64_t s1_189_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_189_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_189_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA189 = (tmp3_0 + tmp3_1) * (s1_189_0 + s1_189_1);
    gl64_t kB189 = (tmp3_0 + tmp3_2) * (s1_189_0 + s1_189_2);
    gl64_t kC189 = (tmp3_1 + tmp3_2) * (s1_189_1 + s1_189_2);
    gl64_t kD189 = tmp3_0 * s1_189_0;
    gl64_t kE189 = tmp3_1 * s1_189_1;
    gl64_t kF189 = tmp3_2 * s1_189_2;
    gl64_t kG189 = kD189 - kE189;
    tmp3_0 = (kC189 + kG189) - kF189;
    tmp3_1 = ((((kA189 + kC189) - kE189) - kE189) - kD189);
    tmp3_2 = kB189 - kG189;
    // Op 190: dim3x3 mul
    gl64_t s1_190_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_190_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_190_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA190 = (tmp3_0 + tmp3_1) * (s1_190_0 + s1_190_1);
    gl64_t kB190 = (tmp3_0 + tmp3_2) * (s1_190_0 + s1_190_2);
    gl64_t kC190 = (tmp3_1 + tmp3_2) * (s1_190_1 + s1_190_2);
    gl64_t kD190 = tmp3_0 * s1_190_0;
    gl64_t kE190 = tmp3_1 * s1_190_1;
    gl64_t kF190 = tmp3_2 * s1_190_2;
    gl64_t kG190 = kD190 - kE190;
    tmp3_0 = (kC190 + kG190) - kF190;
    tmp3_1 = ((((kA190 + kC190) - kE190) - kE190) - kD190);
    tmp3_2 = kB190 - kG190;
    // Op 191: dim3x1 add
    gl64_t s1_191 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_191; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 192: dim3x3 mul
    gl64_t s1_192_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_192_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_192_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA192 = (tmp3_0 + tmp3_1) * (s1_192_0 + s1_192_1);
    gl64_t kB192 = (tmp3_0 + tmp3_2) * (s1_192_0 + s1_192_2);
    gl64_t kC192 = (tmp3_1 + tmp3_2) * (s1_192_1 + s1_192_2);
    gl64_t kD192 = tmp3_0 * s1_192_0;
    gl64_t kE192 = tmp3_1 * s1_192_1;
    gl64_t kF192 = tmp3_2 * s1_192_2;
    gl64_t kG192 = kD192 - kE192;
    tmp3_0 = (kC192 + kG192) - kF192;
    tmp3_1 = ((((kA192 + kC192) - kE192) - kE192) - kD192);
    tmp3_2 = kB192 - kG192;
    // Op 193: dim3x1 add
    gl64_t s1_193 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_193; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 194: dim3x3 add
    gl64_t s1_194_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_194_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_194_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_194_0; tmp3_1 = tmp3_1 + s1_194_1; tmp3_2 = tmp3_2 + s1_194_2;
    // Op 195: dim3x3 mul
    gl64_t s1_195_0 = *(gl64_t*)&expressions_params[10][7];
    gl64_t s1_195_1 = *(gl64_t*)&expressions_params[10][7+1];
    gl64_t s1_195_2 = *(gl64_t*)&expressions_params[10][7+2];
    gl64_t kA195 = (tmp3_0 + tmp3_1) * (s1_195_0 + s1_195_1);
    gl64_t kB195 = (tmp3_0 + tmp3_2) * (s1_195_0 + s1_195_2);
    gl64_t kC195 = (tmp3_1 + tmp3_2) * (s1_195_1 + s1_195_2);
    gl64_t kD195 = tmp3_0 * s1_195_0;
    gl64_t kE195 = tmp3_1 * s1_195_1;
    gl64_t kF195 = tmp3_2 * s1_195_2;
    gl64_t kG195 = kD195 - kE195;
    tmp3_0 = (kC195 + kG195) - kF195;
    tmp3_1 = ((((kA195 + kC195) - kE195) - kE195) - kD195);
    tmp3_2 = kB195 - kG195;
    // Op 196: dim3x1 sub
    gl64_t s1_196 = *(gl64_t*)&expressions_params[10][0];
    tmp3_0 = tmp3_0 - s1_196; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 197: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 198: dim3x3 mul
    gl64_t s1_198_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_198_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_198_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA198 = (tmp3_0 + tmp3_1) * (s1_198_0 + s1_198_1);
    gl64_t kB198 = (tmp3_0 + tmp3_2) * (s1_198_0 + s1_198_2);
    gl64_t kC198 = (tmp3_1 + tmp3_2) * (s1_198_1 + s1_198_2);
    gl64_t kD198 = tmp3_0 * s1_198_0;
    gl64_t kE198 = tmp3_1 * s1_198_1;
    gl64_t kF198 = tmp3_2 * s1_198_2;
    gl64_t kG198 = kD198 - kE198;
    tmp3_3 = (kC198 + kG198) - kF198;
    tmp3_4 = ((((kA198 + kC198) - kE198) - kE198) - kD198);
    tmp3_5 = kB198 - kG198;
    // Op 199: dim3x3 sub_swap
    uint64_t s0_199_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_199_0 = *(gl64_t*)&dParams->aux_trace[s0_199_pos];
    gl64_t s0_199_1 = *(gl64_t*)&dParams->aux_trace[s0_199_pos + TILE_HEIGHT];
    gl64_t s0_199_2 = *(gl64_t*)&dParams->aux_trace[s0_199_pos + 2*TILE_HEIGHT];
    gl64_t s1_199_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_199_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_199_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_6 = s1_199_0 - s0_199_0; tmp3_7 = s1_199_1 - s0_199_1; tmp3_8 = s1_199_2 - s0_199_2;
    // Op 200: dim3x3 add
    gl64_t s0_200_0 = *(gl64_t*)&expressions_params[10][1];
    gl64_t s0_200_1 = *(gl64_t*)&expressions_params[10][1+1];
    gl64_t s0_200_2 = *(gl64_t*)&expressions_params[10][1+2];
    gl64_t s1_200_0 = *(gl64_t*)&expressions_params[10][4];
    gl64_t s1_200_1 = *(gl64_t*)&expressions_params[10][4+1];
    gl64_t s1_200_2 = *(gl64_t*)&expressions_params[10][4+2];
    tmp3_0 = s0_200_0 + s1_200_0; tmp3_1 = s0_200_1 + s1_200_1; tmp3_2 = s0_200_2 + s1_200_2;
    // Op 201: dim3x3 add
    gl64_t s1_201_0 = *(gl64_t*)&expressions_params[10][7];
    gl64_t s1_201_1 = *(gl64_t*)&expressions_params[10][7+1];
    gl64_t s1_201_2 = *(gl64_t*)&expressions_params[10][7+2];
    tmp3_0 = tmp3_0 + s1_201_0; tmp3_1 = tmp3_1 + s1_201_1; tmp3_2 = tmp3_2 + s1_201_2;
    // Op 202: dim3x3 sub
    tmp3_0 = tmp3_6 - tmp3_0; tmp3_1 = tmp3_7 - tmp3_1; tmp3_2 = tmp3_8 - tmp3_2;
    // Op 203: dim3x1 mul
    gl64_t s1_203 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_203; tmp3_1 = tmp3_1 * s1_203; tmp3_2 = tmp3_2 * s1_203;
    // Op 204: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 205: dim3x1 mul
    gl64_t s1_205 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_205; tmp3_1 = tmp3_1 * s1_205; tmp3_2 = tmp3_2 * s1_205;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
