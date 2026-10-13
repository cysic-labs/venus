// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: 4f8a9fd0  nOps=205 nTemp1=5 nTemp3=5
#define GENERATED_EVAL_NOPS_4f8a9fd0 205
#define GENERATED_EVAL_NTEMP1_4f8a9fd0 5
#define GENERATED_EVAL_NTEMP3_4f8a9fd0 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_4f8a9fd0(
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
    gl64_t s1_0 = *(gl64_t*)&expressions_params[9][1];
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
    gl64_t s1_3 = *(gl64_t*)&expressions_params[9][1];
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
    gl64_t s1_7 = *(gl64_t*)&expressions_params[9][1];
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
    gl64_t s1_14 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_14 - s0_14;
    // Op 15: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 16: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_0;
    // Op 17: dim1x1 sub_swap
    gl64_t s0_17 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_17 = *(gl64_t*)&expressions_params[9][1];
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
    gl64_t s1_21 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_21 - s0_21;
    // Op 22: dim1x1 sub_swap
    gl64_t s0_22 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_22 = *(gl64_t*)&expressions_params[9][1];
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
    gl64_t s1_27 = *(gl64_t*)&expressions_params[9][1];
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
    gl64_t s1_32 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_32 - s0_32;
    // Op 33: dim1x1 mul
    gl64_t s1_33 = *(gl64_t*)&expressions_params[9][12];
    tmp1_0 = tmp1_0 * s1_33;
    // Op 34: dim1x1 sub_swap
    gl64_t s0_34 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_34 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_34 - s0_34;
    // Op 35: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 36: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_0;
    // Op 37: dim1x1 sub_swap
    gl64_t s0_37 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_37 = *(gl64_t*)&expressions_params[9][1];
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
    gl64_t s1_42 = *(gl64_t*)&expressions_params[9][1];
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
    // Op 50: dim1x1 sub_swap
    gl64_t s0_50 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_50 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_50 - s0_50;
    // Op 51: dim1x1 mul
    gl64_t s0_51 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_51 * tmp1_0;
    // Op 52: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 53: dim3x3 mul
    gl64_t s1_53_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_53_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_53_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA53 = (tmp3_0 + tmp3_1) * (s1_53_0 + s1_53_1);
    gl64_t kB53 = (tmp3_0 + tmp3_2) * (s1_53_0 + s1_53_2);
    gl64_t kC53 = (tmp3_1 + tmp3_2) * (s1_53_1 + s1_53_2);
    gl64_t kD53 = tmp3_0 * s1_53_0;
    gl64_t kE53 = tmp3_1 * s1_53_1;
    gl64_t kF53 = tmp3_2 * s1_53_2;
    gl64_t kG53 = kD53 - kE53;
    tmp3_0 = (kC53 + kG53) - kF53;
    tmp3_1 = ((((kA53 + kC53) - kE53) - kE53) - kD53);
    tmp3_2 = kB53 - kG53;
    // Op 54: dim1x1 mul
    gl64_t s0_54 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_4 = s0_54 * tmp1_4;
    // Op 55: dim1x1 mul
    gl64_t s0_55 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_2 = s0_55 * tmp1_2;
    // Op 56: dim1x1 add
    tmp1_2 = tmp1_4 + tmp1_2;
    // Op 57: dim1x1 mul
    gl64_t s0_57 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_1 = s0_57 * tmp1_1;
    // Op 58: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_1;
    // Op 59: dim1x1 sub
    gl64_t s0_59 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_1 = s0_59 - tmp1_1;
    // Op 60: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 61: dim3x3 mul
    gl64_t s1_61_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_61_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_61_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA61 = (tmp3_0 + tmp3_1) * (s1_61_0 + s1_61_1);
    gl64_t kB61 = (tmp3_0 + tmp3_2) * (s1_61_0 + s1_61_2);
    gl64_t kC61 = (tmp3_1 + tmp3_2) * (s1_61_1 + s1_61_2);
    gl64_t kD61 = tmp3_0 * s1_61_0;
    gl64_t kE61 = tmp3_1 * s1_61_1;
    gl64_t kF61 = tmp3_2 * s1_61_2;
    gl64_t kG61 = kD61 - kE61;
    tmp3_0 = (kC61 + kG61) - kF61;
    tmp3_1 = ((((kA61 + kC61) - kE61) - kE61) - kD61);
    tmp3_2 = kB61 - kG61;
    // Op 62: dim1x1 sub
    gl64_t s0_62 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_62 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_1 = s0_62 - s1_62;
    // Op 63: dim1x1 mul
    gl64_t s0_63 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_1 = s0_63 * tmp1_1;
    // Op 64: dim1x1 add
    gl64_t s0_64 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_1 = s0_64 + tmp1_1;
    // Op 65: dim1x1 sub
    gl64_t s0_65 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_1 = s0_65 - tmp1_1;
    // Op 66: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 67: dim3x3 mul
    gl64_t s1_67_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_67_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_67_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA67 = (tmp3_0 + tmp3_1) * (s1_67_0 + s1_67_1);
    gl64_t kB67 = (tmp3_0 + tmp3_2) * (s1_67_0 + s1_67_2);
    gl64_t kC67 = (tmp3_1 + tmp3_2) * (s1_67_1 + s1_67_2);
    gl64_t kD67 = tmp3_0 * s1_67_0;
    gl64_t kE67 = tmp3_1 * s1_67_1;
    gl64_t kF67 = tmp3_2 * s1_67_2;
    gl64_t kG67 = kD67 - kE67;
    tmp3_0 = (kC67 + kG67) - kF67;
    tmp3_1 = ((((kA67 + kC67) - kE67) - kE67) - kD67);
    tmp3_2 = kB67 - kG67;
    // Op 68: dim1x1 sub
    gl64_t s0_68 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_68 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_1 = s0_68 - s1_68;
    // Op 69: dim1x1 mul
    gl64_t s0_69 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_1 = s0_69 * tmp1_1;
    // Op 70: dim1x1 add
    gl64_t s0_70 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_1 = s0_70 + tmp1_1;
    // Op 71: dim1x1 sub
    gl64_t s0_71 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_1 = s0_71 - tmp1_1;
    // Op 72: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 73: dim3x3 mul
    gl64_t s1_73_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_73_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_73_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA73 = (tmp3_0 + tmp3_1) * (s1_73_0 + s1_73_1);
    gl64_t kB73 = (tmp3_0 + tmp3_2) * (s1_73_0 + s1_73_2);
    gl64_t kC73 = (tmp3_1 + tmp3_2) * (s1_73_1 + s1_73_2);
    gl64_t kD73 = tmp3_0 * s1_73_0;
    gl64_t kE73 = tmp3_1 * s1_73_1;
    gl64_t kF73 = tmp3_2 * s1_73_2;
    gl64_t kG73 = kD73 - kE73;
    tmp3_0 = (kC73 + kG73) - kF73;
    tmp3_1 = ((((kA73 + kC73) - kE73) - kE73) - kD73);
    tmp3_2 = kB73 - kG73;
    // Op 74: dim1x1 sub
    gl64_t s0_74 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_74 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_1 = s0_74 - s1_74;
    // Op 75: dim1x1 mul
    gl64_t s0_75 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_1 = s0_75 * tmp1_1;
    // Op 76: dim1x1 add
    gl64_t s0_76 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_1 = s0_76 + tmp1_1;
    // Op 77: dim1x1 sub
    gl64_t s0_77 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_1 = s0_77 - tmp1_1;
    // Op 78: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 79: dim3x3 mul
    gl64_t s1_79_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_79_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_79_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA79 = (tmp3_0 + tmp3_1) * (s1_79_0 + s1_79_1);
    gl64_t kB79 = (tmp3_0 + tmp3_2) * (s1_79_0 + s1_79_2);
    gl64_t kC79 = (tmp3_1 + tmp3_2) * (s1_79_1 + s1_79_2);
    gl64_t kD79 = tmp3_0 * s1_79_0;
    gl64_t kE79 = tmp3_1 * s1_79_1;
    gl64_t kF79 = tmp3_2 * s1_79_2;
    gl64_t kG79 = kD79 - kE79;
    tmp3_12 = (kC79 + kG79) - kF79;
    tmp3_13 = ((((kA79 + kC79) - kE79) - kE79) - kD79);
    tmp3_14 = kB79 - kG79;
    // Op 80: dim3x1 mul
    gl64_t s0_80_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_80_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_80_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_80 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp3_0 = s0_80_0 * s1_80; tmp3_1 = s0_80_1 * s1_80; tmp3_2 = s0_80_2 * s1_80;
    // Op 81: dim3x1 add
    gl64_t s1_81 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
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
    gl64_t s1_83 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_83; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 84: dim3x3 mul
    gl64_t s1_84_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_84_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_84_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA84 = (tmp3_0 + tmp3_1) * (s1_84_0 + s1_84_1);
    gl64_t kB84 = (tmp3_0 + tmp3_2) * (s1_84_0 + s1_84_2);
    gl64_t kC84 = (tmp3_1 + tmp3_2) * (s1_84_1 + s1_84_2);
    gl64_t kD84 = tmp3_0 * s1_84_0;
    gl64_t kE84 = tmp3_1 * s1_84_1;
    gl64_t kF84 = tmp3_2 * s1_84_2;
    gl64_t kG84 = kD84 - kE84;
    tmp3_0 = (kC84 + kG84) - kF84;
    tmp3_1 = ((((kA84 + kC84) - kE84) - kE84) - kD84);
    tmp3_2 = kB84 - kG84;
    // Op 85: dim1x1 add
    gl64_t s0_85 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_85 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s0_85 + s1_85;
    // Op 86: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 88: dim1x1 mul
    gl64_t s0_88 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_88 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_88 * s1_88;
    // Op 89: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 90: dim3x3 mul
    gl64_t s1_90_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_90_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_90_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA90 = (tmp3_0 + tmp3_1) * (s1_90_0 + s1_90_1);
    gl64_t kB90 = (tmp3_0 + tmp3_2) * (s1_90_0 + s1_90_2);
    gl64_t kC90 = (tmp3_1 + tmp3_2) * (s1_90_1 + s1_90_2);
    gl64_t kD90 = tmp3_0 * s1_90_0;
    gl64_t kE90 = tmp3_1 * s1_90_1;
    gl64_t kF90 = tmp3_2 * s1_90_2;
    gl64_t kG90 = kD90 - kE90;
    tmp3_0 = (kC90 + kG90) - kF90;
    tmp3_1 = ((((kA90 + kC90) - kE90) - kE90) - kD90);
    tmp3_2 = kB90 - kG90;
    // Op 91: dim3x1 add
    gl64_t s1_91 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_91; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 92: dim3x3 mul
    gl64_t s1_92_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_92_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_92_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA92 = (tmp3_0 + tmp3_1) * (s1_92_0 + s1_92_1);
    gl64_t kB92 = (tmp3_0 + tmp3_2) * (s1_92_0 + s1_92_2);
    gl64_t kC92 = (tmp3_1 + tmp3_2) * (s1_92_1 + s1_92_2);
    gl64_t kD92 = tmp3_0 * s1_92_0;
    gl64_t kE92 = tmp3_1 * s1_92_1;
    gl64_t kF92 = tmp3_2 * s1_92_2;
    gl64_t kG92 = kD92 - kE92;
    tmp3_0 = (kC92 + kG92) - kF92;
    tmp3_1 = ((((kA92 + kC92) - kE92) - kE92) - kD92);
    tmp3_2 = kB92 - kG92;
    // Op 93: dim3x1 add
    gl64_t s1_93 = *(gl64_t*)&expressions_params[9][5];
    tmp3_9 = tmp3_0 + s1_93; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 94: dim3x3 add
    gl64_t s1_94_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_94_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_94_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_94_0; tmp3_4 = tmp3_10 + s1_94_1; tmp3_5 = tmp3_11 + s1_94_2;
    // Op 95: dim3x1 mul
    gl64_t s0_95_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_95_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_95_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_95 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp3_0 = s0_95_0 * s1_95; tmp3_1 = s0_95_1 * s1_95; tmp3_2 = s0_95_2 * s1_95;
    // Op 96: dim3x1 add
    gl64_t s1_96 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_96; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_98 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
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
    // Op 100: dim1x1 mul
    gl64_t s0_100 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_100 = *(gl64_t*)&expressions_params[9][2];
    tmp1_4 = s0_100 * s1_100;
    // Op 101: dim1x1 mul
    gl64_t s0_101 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_101 = *(gl64_t*)&expressions_params[9][3];
    tmp1_1 = s0_101 * s1_101;
    // Op 102: dim1x1 mul
    gl64_t s0_102 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_102 = *(gl64_t*)&expressions_params[9][4];
    tmp1_2 = s0_102 * s1_102;
    // Op 103: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_2;
    // Op 104: dim1x1 add
    gl64_t s0_104 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_1 = s0_104 + tmp1_1;
    // Op 105: dim1x1 add
    tmp1_1 = tmp1_4 + tmp1_1;
    // Op 106: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 107: dim3x3 mul
    gl64_t s1_107_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_107_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_107_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA107 = (tmp3_0 + tmp3_1) * (s1_107_0 + s1_107_1);
    gl64_t kB107 = (tmp3_0 + tmp3_2) * (s1_107_0 + s1_107_2);
    gl64_t kC107 = (tmp3_1 + tmp3_2) * (s1_107_1 + s1_107_2);
    gl64_t kD107 = tmp3_0 * s1_107_0;
    gl64_t kE107 = tmp3_1 * s1_107_1;
    gl64_t kF107 = tmp3_2 * s1_107_2;
    gl64_t kG107 = kD107 - kE107;
    tmp3_0 = (kC107 + kG107) - kF107;
    tmp3_1 = ((((kA107 + kC107) - kE107) - kE107) - kD107);
    tmp3_2 = kB107 - kG107;
    // Op 108: dim1x1 add
    gl64_t s0_108 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_108 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s0_108 + s1_108;
    // Op 109: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 110: dim3x3 mul
    gl64_t s1_110_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_110_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_110_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA110 = (tmp3_0 + tmp3_1) * (s1_110_0 + s1_110_1);
    gl64_t kB110 = (tmp3_0 + tmp3_2) * (s1_110_0 + s1_110_2);
    gl64_t kC110 = (tmp3_1 + tmp3_2) * (s1_110_1 + s1_110_2);
    gl64_t kD110 = tmp3_0 * s1_110_0;
    gl64_t kE110 = tmp3_1 * s1_110_1;
    gl64_t kF110 = tmp3_2 * s1_110_2;
    gl64_t kG110 = kD110 - kE110;
    tmp3_0 = (kC110 + kG110) - kF110;
    tmp3_1 = ((((kA110 + kC110) - kE110) - kE110) - kD110);
    tmp3_2 = kB110 - kG110;
    // Op 111: dim3x1 add
    gl64_t s1_111 = *(gl64_t*)&expressions_params[9][5];
    tmp3_6 = tmp3_0 + s1_111; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 112: dim3x3 add
    gl64_t s1_112_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_112_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_112_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_112_0; tmp3_1 = tmp3_7 + s1_112_1; tmp3_2 = tmp3_8 + s1_112_2;
    // Op 113: dim3x3 mul
    gl64_t kA113 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB113 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC113 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD113 = tmp3_3 * tmp3_0;
    gl64_t kE113 = tmp3_4 * tmp3_1;
    gl64_t kF113 = tmp3_5 * tmp3_2;
    gl64_t kG113 = kD113 - kE113;
    tmp3_0 = (kC113 + kG113) - kF113;
    tmp3_1 = ((((kA113 + kC113) - kE113) - kE113) - kD113);
    tmp3_2 = kB113 - kG113;
    // Op 114: dim3x3 mul
    gl64_t s0_114_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_114_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_114_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA114 = (s0_114_0 + s0_114_1) * (tmp3_0 + tmp3_1);
    gl64_t kB114 = (s0_114_0 + s0_114_2) * (tmp3_0 + tmp3_2);
    gl64_t kC114 = (s0_114_1 + s0_114_2) * (tmp3_1 + tmp3_2);
    gl64_t kD114 = s0_114_0 * tmp3_0;
    gl64_t kE114 = s0_114_1 * tmp3_1;
    gl64_t kF114 = s0_114_2 * tmp3_2;
    gl64_t kG114 = kD114 - kE114;
    tmp3_0 = (kC114 + kG114) - kF114;
    tmp3_1 = ((((kA114 + kC114) - kE114) - kE114) - kD114);
    tmp3_2 = kB114 - kG114;
    // Op 115: dim1x1 sub_swap
    gl64_t s0_115 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_115 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s1_115 - s0_115;
    // Op 116: dim3x3 add
    gl64_t s1_116_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_116_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_116_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_116_0; tmp3_7 = tmp3_7 + s1_116_1; tmp3_8 = tmp3_8 + s1_116_2;
    // Op 117: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_1; tmp3_7 = tmp3_7 * tmp1_1; tmp3_8 = tmp3_8 * tmp1_1;
    // Op 118: dim3x3 add
    gl64_t s1_118_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_118_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_118_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_118_0; tmp3_10 = tmp3_10 + s1_118_1; tmp3_11 = tmp3_11 + s1_118_2;
    // Op 119: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 120: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 121: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 122: dim3x3 mul
    gl64_t s1_122_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_122_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_122_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA122 = (tmp3_0 + tmp3_1) * (s1_122_0 + s1_122_1);
    gl64_t kB122 = (tmp3_0 + tmp3_2) * (s1_122_0 + s1_122_2);
    gl64_t kC122 = (tmp3_1 + tmp3_2) * (s1_122_1 + s1_122_2);
    gl64_t kD122 = tmp3_0 * s1_122_0;
    gl64_t kE122 = tmp3_1 * s1_122_1;
    gl64_t kF122 = tmp3_2 * s1_122_2;
    gl64_t kG122 = kD122 - kE122;
    tmp3_3 = (kC122 + kG122) - kF122;
    tmp3_4 = ((((kA122 + kC122) - kE122) - kE122) - kD122);
    tmp3_5 = kB122 - kG122;
    // Op 123: dim3x1 mul
    gl64_t s0_123_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_123_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_123_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_123 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp3_0 = s0_123_0 * s1_123; tmp3_1 = s0_123_1 * s1_123; tmp3_2 = s0_123_2 * s1_123;
    // Op 124: dim3x1 add
    gl64_t s1_124 = *(gl64_t*)&expressions_params[9][8];
    tmp3_9 = tmp3_0 + s1_124; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 125: dim3x3 add
    gl64_t s1_125_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_125_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_125_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_125_0; tmp3_13 = tmp3_10 + s1_125_1; tmp3_14 = tmp3_11 + s1_125_2;
    // Op 126: dim3x1 mul
    gl64_t s0_126_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_126_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_126_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_126 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp3_0 = s0_126_0 * s1_126; tmp3_1 = s0_126_1 * s1_126; tmp3_2 = s0_126_2 * s1_126;
    // Op 127: dim3x1 add
    gl64_t s1_127 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_127; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 128: dim3x3 mul
    gl64_t s1_128_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_128_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_128_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA128 = (tmp3_0 + tmp3_1) * (s1_128_0 + s1_128_1);
    gl64_t kB128 = (tmp3_0 + tmp3_2) * (s1_128_0 + s1_128_2);
    gl64_t kC128 = (tmp3_1 + tmp3_2) * (s1_128_1 + s1_128_2);
    gl64_t kD128 = tmp3_0 * s1_128_0;
    gl64_t kE128 = tmp3_1 * s1_128_1;
    gl64_t kF128 = tmp3_2 * s1_128_2;
    gl64_t kG128 = kD128 - kE128;
    tmp3_0 = (kC128 + kG128) - kF128;
    tmp3_1 = ((((kA128 + kC128) - kE128) - kE128) - kD128);
    tmp3_2 = kB128 - kG128;
    // Op 129: dim3x1 add
    gl64_t s1_129 = *(gl64_t*)&expressions_params[9][6];
    tmp3_6 = tmp3_0 + s1_129; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 130: dim3x3 add
    gl64_t s1_130_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_130_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_130_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_130_0; tmp3_1 = tmp3_7 + s1_130_1; tmp3_2 = tmp3_8 + s1_130_2;
    // Op 131: dim3x3 mul
    gl64_t kA131 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB131 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC131 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD131 = tmp3_12 * tmp3_0;
    gl64_t kE131 = tmp3_13 * tmp3_1;
    gl64_t kF131 = tmp3_14 * tmp3_2;
    gl64_t kG131 = kD131 - kE131;
    tmp3_0 = (kC131 + kG131) - kF131;
    tmp3_1 = ((((kA131 + kC131) - kE131) - kE131) - kD131);
    tmp3_2 = kB131 - kG131;
    // Op 132: dim3x3 mul
    gl64_t s0_132_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_132_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_132_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA132 = (s0_132_0 + s0_132_1) * (tmp3_0 + tmp3_1);
    gl64_t kB132 = (s0_132_0 + s0_132_2) * (tmp3_0 + tmp3_2);
    gl64_t kC132 = (s0_132_1 + s0_132_2) * (tmp3_1 + tmp3_2);
    gl64_t kD132 = s0_132_0 * tmp3_0;
    gl64_t kE132 = s0_132_1 * tmp3_1;
    gl64_t kF132 = s0_132_2 * tmp3_2;
    gl64_t kG132 = kD132 - kE132;
    tmp3_0 = (kC132 + kG132) - kF132;
    tmp3_1 = ((((kA132 + kC132) - kE132) - kE132) - kD132);
    tmp3_2 = kB132 - kG132;
    // Op 133: dim3x3 add
    gl64_t s1_133_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_133_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_133_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_133_0; tmp3_7 = tmp3_7 + s1_133_1; tmp3_8 = tmp3_8 + s1_133_2;
    // Op 134: dim3x1 mul
    gl64_t s1_134 = *(gl64_t*)&expressions_params[9][7];
    tmp3_6 = tmp3_6 * s1_134; tmp3_7 = tmp3_7 * s1_134; tmp3_8 = tmp3_8 * s1_134;
    // Op 135: dim3x3 add
    gl64_t s1_135_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_135_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_135_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_135_0; tmp3_10 = tmp3_10 + s1_135_1; tmp3_11 = tmp3_11 + s1_135_2;
    // Op 136: dim3x1 mul
    gl64_t s1_136 = *(gl64_t*)&expressions_params[9][7];
    tmp3_9 = tmp3_9 * s1_136; tmp3_10 = tmp3_10 * s1_136; tmp3_11 = tmp3_11 * s1_136;
    // Op 137: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 138: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 139: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 140: dim3x3 mul
    gl64_t s1_140_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_140_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_140_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA140 = (tmp3_0 + tmp3_1) * (s1_140_0 + s1_140_1);
    gl64_t kB140 = (tmp3_0 + tmp3_2) * (s1_140_0 + s1_140_2);
    gl64_t kC140 = (tmp3_1 + tmp3_2) * (s1_140_1 + s1_140_2);
    gl64_t kD140 = tmp3_0 * s1_140_0;
    gl64_t kE140 = tmp3_1 * s1_140_1;
    gl64_t kF140 = tmp3_2 * s1_140_2;
    gl64_t kG140 = kD140 - kE140;
    tmp3_3 = (kC140 + kG140) - kF140;
    tmp3_4 = ((((kA140 + kC140) - kE140) - kE140) - kD140);
    tmp3_5 = kB140 - kG140;
    // Op 141: dim1x1 sub
    gl64_t s0_141 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_141 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_1 = s0_141 - s1_141;
    // Op 142: dim1x1 mul
    gl64_t s0_142 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_1 = s0_142 * tmp1_1;
    // Op 143: dim1x1 add
    gl64_t s0_143 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_1 = s0_143 + tmp1_1;
    // Op 144: dim3x1 mul
    gl64_t s0_144_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_144_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_144_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_144_0 * tmp1_1; tmp3_1 = s0_144_1 * tmp1_1; tmp3_2 = s0_144_2 * tmp1_1;
    // Op 145: dim1x1 sub
    gl64_t s0_145 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_145 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_1 = s0_145 - s1_145;
    // Op 146: dim1x1 mul
    gl64_t s0_146 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_1 = s0_146 * tmp1_1;
    // Op 147: dim1x1 add
    gl64_t s0_147 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_1 = s0_147 + tmp1_1;
    // Op 148: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 149: dim3x3 mul
    gl64_t s1_149_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_149_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_149_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA149 = (tmp3_0 + tmp3_1) * (s1_149_0 + s1_149_1);
    gl64_t kB149 = (tmp3_0 + tmp3_2) * (s1_149_0 + s1_149_2);
    gl64_t kC149 = (tmp3_1 + tmp3_2) * (s1_149_1 + s1_149_2);
    gl64_t kD149 = tmp3_0 * s1_149_0;
    gl64_t kE149 = tmp3_1 * s1_149_1;
    gl64_t kF149 = tmp3_2 * s1_149_2;
    gl64_t kG149 = kD149 - kE149;
    tmp3_0 = (kC149 + kG149) - kF149;
    tmp3_1 = ((((kA149 + kC149) - kE149) - kE149) - kD149);
    tmp3_2 = kB149 - kG149;
    // Op 150: dim3x1 add
    gl64_t s1_150 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_150; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 151: dim3x3 mul
    gl64_t s1_151_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_151_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_151_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA151 = (tmp3_0 + tmp3_1) * (s1_151_0 + s1_151_1);
    gl64_t kB151 = (tmp3_0 + tmp3_2) * (s1_151_0 + s1_151_2);
    gl64_t kC151 = (tmp3_1 + tmp3_2) * (s1_151_1 + s1_151_2);
    gl64_t kD151 = tmp3_0 * s1_151_0;
    gl64_t kE151 = tmp3_1 * s1_151_1;
    gl64_t kF151 = tmp3_2 * s1_151_2;
    gl64_t kG151 = kD151 - kE151;
    tmp3_0 = (kC151 + kG151) - kF151;
    tmp3_1 = ((((kA151 + kC151) - kE151) - kE151) - kD151);
    tmp3_2 = kB151 - kG151;
    // Op 152: dim3x1 add
    gl64_t s1_152 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_152; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 153: dim3x3 mul
    gl64_t s1_153_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_153_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_153_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA153 = (tmp3_0 + tmp3_1) * (s1_153_0 + s1_153_1);
    gl64_t kB153 = (tmp3_0 + tmp3_2) * (s1_153_0 + s1_153_2);
    gl64_t kC153 = (tmp3_1 + tmp3_2) * (s1_153_1 + s1_153_2);
    gl64_t kD153 = tmp3_0 * s1_153_0;
    gl64_t kE153 = tmp3_1 * s1_153_1;
    gl64_t kF153 = tmp3_2 * s1_153_2;
    gl64_t kG153 = kD153 - kE153;
    tmp3_0 = (kC153 + kG153) - kF153;
    tmp3_1 = ((((kA153 + kC153) - kE153) - kE153) - kD153);
    tmp3_2 = kB153 - kG153;
    // Op 154: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 155: dim3x3 mul
    gl64_t s1_155_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_155_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_155_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA155 = (tmp3_0 + tmp3_1) * (s1_155_0 + s1_155_1);
    gl64_t kB155 = (tmp3_0 + tmp3_2) * (s1_155_0 + s1_155_2);
    gl64_t kC155 = (tmp3_1 + tmp3_2) * (s1_155_1 + s1_155_2);
    gl64_t kD155 = tmp3_0 * s1_155_0;
    gl64_t kE155 = tmp3_1 * s1_155_1;
    gl64_t kF155 = tmp3_2 * s1_155_2;
    gl64_t kG155 = kD155 - kE155;
    tmp3_0 = (kC155 + kG155) - kF155;
    tmp3_1 = ((((kA155 + kC155) - kE155) - kE155) - kD155);
    tmp3_2 = kB155 - kG155;
    // Op 156: dim3x1 add
    gl64_t s1_156 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_156; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 157: dim3x3 mul
    gl64_t s1_157_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_157_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_157_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA157 = (tmp3_0 + tmp3_1) * (s1_157_0 + s1_157_1);
    gl64_t kB157 = (tmp3_0 + tmp3_2) * (s1_157_0 + s1_157_2);
    gl64_t kC157 = (tmp3_1 + tmp3_2) * (s1_157_1 + s1_157_2);
    gl64_t kD157 = tmp3_0 * s1_157_0;
    gl64_t kE157 = tmp3_1 * s1_157_1;
    gl64_t kF157 = tmp3_2 * s1_157_2;
    gl64_t kG157 = kD157 - kE157;
    tmp3_0 = (kC157 + kG157) - kF157;
    tmp3_1 = ((((kA157 + kC157) - kE157) - kE157) - kD157);
    tmp3_2 = kB157 - kG157;
    // Op 158: dim3x1 add
    gl64_t s1_158 = *(gl64_t*)&expressions_params[9][5];
    tmp3_0 = tmp3_0 + s1_158; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 159: dim3x3 add
    gl64_t s1_159_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_159_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_159_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_159_0; tmp3_1 = tmp3_1 + s1_159_1; tmp3_2 = tmp3_2 + s1_159_2;
    // Op 160: dim3x3 mul
    uint64_t s0_160_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_160_0 = *(gl64_t*)&dParams->aux_trace[s0_160_pos];
    gl64_t s0_160_1 = *(gl64_t*)&dParams->aux_trace[s0_160_pos + TILE_HEIGHT];
    gl64_t s0_160_2 = *(gl64_t*)&dParams->aux_trace[s0_160_pos + 2*TILE_HEIGHT];
    gl64_t kA160 = (s0_160_0 + s0_160_1) * (tmp3_0 + tmp3_1);
    gl64_t kB160 = (s0_160_0 + s0_160_2) * (tmp3_0 + tmp3_2);
    gl64_t kC160 = (s0_160_1 + s0_160_2) * (tmp3_1 + tmp3_2);
    gl64_t kD160 = s0_160_0 * tmp3_0;
    gl64_t kE160 = s0_160_1 * tmp3_1;
    gl64_t kF160 = s0_160_2 * tmp3_2;
    gl64_t kG160 = kD160 - kE160;
    tmp3_0 = (kC160 + kG160) - kF160;
    tmp3_1 = ((((kA160 + kC160) - kE160) - kE160) - kD160);
    tmp3_2 = kB160 - kG160;
    // Op 161: dim3x1 add
    gl64_t s1_161 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_161; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 162: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 163: dim3x3 mul
    gl64_t s1_163_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_163_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_163_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA163 = (tmp3_0 + tmp3_1) * (s1_163_0 + s1_163_1);
    gl64_t kB163 = (tmp3_0 + tmp3_2) * (s1_163_0 + s1_163_2);
    gl64_t kC163 = (tmp3_1 + tmp3_2) * (s1_163_1 + s1_163_2);
    gl64_t kD163 = tmp3_0 * s1_163_0;
    gl64_t kE163 = tmp3_1 * s1_163_1;
    gl64_t kF163 = tmp3_2 * s1_163_2;
    gl64_t kG163 = kD163 - kE163;
    tmp3_6 = (kC163 + kG163) - kF163;
    tmp3_7 = ((((kA163 + kC163) - kE163) - kE163) - kD163);
    tmp3_8 = kB163 - kG163;
    // Op 164: dim1x1 sub_swap
    gl64_t s0_164 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_164 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_164 - s0_164;
    // Op 165: dim3x1 mul
    uint64_t s0_165_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_165_0 = *(gl64_t*)&dParams->aux_trace[s0_165_pos];
    gl64_t s0_165_1 = *(gl64_t*)&dParams->aux_trace[s0_165_pos + TILE_HEIGHT];
    gl64_t s0_165_2 = *(gl64_t*)&dParams->aux_trace[s0_165_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_165_0 * tmp1_0; tmp3_1 = s0_165_1 * tmp1_0; tmp3_2 = s0_165_2 * tmp1_0;
    // Op 166: dim3x3 sub
    uint64_t s0_166_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_166_0 = *(gl64_t*)&dParams->aux_trace[s0_166_pos];
    gl64_t s0_166_1 = *(gl64_t*)&dParams->aux_trace[s0_166_pos + TILE_HEIGHT];
    gl64_t s0_166_2 = *(gl64_t*)&dParams->aux_trace[s0_166_pos + 2*TILE_HEIGHT];
    tmp3_3 = s0_166_0 - tmp3_0; tmp3_4 = s0_166_1 - tmp3_1; tmp3_5 = s0_166_2 - tmp3_2;
    // Op 167: dim3x3 add
    gl64_t s0_167_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_167_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_167_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_167_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_167_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_167_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_0 = s0_167_0 + s1_167_0; tmp3_1 = s0_167_1 + s1_167_1; tmp3_2 = s0_167_2 + s1_167_2;
    // Op 168: dim3x3 add
    uint64_t s0_168_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_168_0 = *(gl64_t*)&dParams->aux_trace[s0_168_pos];
    gl64_t s0_168_1 = *(gl64_t*)&dParams->aux_trace[s0_168_pos + TILE_HEIGHT];
    gl64_t s0_168_2 = *(gl64_t*)&dParams->aux_trace[s0_168_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_168_0 + tmp3_0; tmp3_1 = s0_168_1 + tmp3_1; tmp3_2 = s0_168_2 + tmp3_2;
    // Op 169: dim3x3 sub
    tmp3_3 = tmp3_3 - tmp3_0; tmp3_4 = tmp3_4 - tmp3_1; tmp3_5 = tmp3_5 - tmp3_2;
    // Op 170: dim3x1 mul
    gl64_t s0_170_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_170_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_170_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_170 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp3_0 = s0_170_0 * s1_170; tmp3_1 = s0_170_1 * s1_170; tmp3_2 = s0_170_2 * s1_170;
    // Op 171: dim3x1 add
    gl64_t s1_171 = *(gl64_t*)&expressions_params[9][9];
    tmp3_0 = tmp3_0 + s1_171; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 172: dim3x3 add
    gl64_t s1_172_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_172_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_172_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_172_0; tmp3_1 = tmp3_1 + s1_172_1; tmp3_2 = tmp3_2 + s1_172_2;
    // Op 173: dim3x3 mul
    gl64_t kA173 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB173 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC173 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD173 = tmp3_3 * tmp3_0;
    gl64_t kE173 = tmp3_4 * tmp3_1;
    gl64_t kF173 = tmp3_5 * tmp3_2;
    gl64_t kG173 = kD173 - kE173;
    tmp3_0 = (kC173 + kG173) - kF173;
    tmp3_1 = ((((kA173 + kC173) - kE173) - kE173) - kD173);
    tmp3_2 = kB173 - kG173;
    // Op 174: dim3x1 add
    gl64_t s1_174 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_174; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 175: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 176: dim3x3 mul
    gl64_t s1_176_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_176_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_176_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA176 = (tmp3_0 + tmp3_1) * (s1_176_0 + s1_176_1);
    gl64_t kB176 = (tmp3_0 + tmp3_2) * (s1_176_0 + s1_176_2);
    gl64_t kC176 = (tmp3_1 + tmp3_2) * (s1_176_1 + s1_176_2);
    gl64_t kD176 = tmp3_0 * s1_176_0;
    gl64_t kE176 = tmp3_1 * s1_176_1;
    gl64_t kF176 = tmp3_2 * s1_176_2;
    gl64_t kG176 = kD176 - kE176;
    tmp3_6 = (kC176 + kG176) - kF176;
    tmp3_7 = ((((kA176 + kC176) - kE176) - kE176) - kD176);
    tmp3_8 = kB176 - kG176;
    // Op 177: dim3x1 mul
    gl64_t s0_177_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_177_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_177_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_177 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = s0_177_0 * s1_177; tmp3_1 = s0_177_1 * s1_177; tmp3_2 = s0_177_2 * s1_177;
    // Op 178: dim3x3 mul
    gl64_t s1_178_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_178_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_178_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA178 = (tmp3_0 + tmp3_1) * (s1_178_0 + s1_178_1);
    gl64_t kB178 = (tmp3_0 + tmp3_2) * (s1_178_0 + s1_178_2);
    gl64_t kC178 = (tmp3_1 + tmp3_2) * (s1_178_1 + s1_178_2);
    gl64_t kD178 = tmp3_0 * s1_178_0;
    gl64_t kE178 = tmp3_1 * s1_178_1;
    gl64_t kF178 = tmp3_2 * s1_178_2;
    gl64_t kG178 = kD178 - kE178;
    tmp3_0 = (kC178 + kG178) - kF178;
    tmp3_1 = ((((kA178 + kC178) - kE178) - kE178) - kD178);
    tmp3_2 = kB178 - kG178;
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
    gl64_t s1_180 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_180; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 181: dim3x3 mul
    gl64_t s1_181_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_181_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_181_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA181 = (tmp3_0 + tmp3_1) * (s1_181_0 + s1_181_1);
    gl64_t kB181 = (tmp3_0 + tmp3_2) * (s1_181_0 + s1_181_2);
    gl64_t kC181 = (tmp3_1 + tmp3_2) * (s1_181_1 + s1_181_2);
    gl64_t kD181 = tmp3_0 * s1_181_0;
    gl64_t kE181 = tmp3_1 * s1_181_1;
    gl64_t kF181 = tmp3_2 * s1_181_2;
    gl64_t kG181 = kD181 - kE181;
    tmp3_0 = (kC181 + kG181) - kF181;
    tmp3_1 = ((((kA181 + kC181) - kE181) - kE181) - kD181);
    tmp3_2 = kB181 - kG181;
    // Op 182: dim3x1 add
    gl64_t s1_182 = *(gl64_t*)&expressions_params[9][5];
    tmp3_0 = tmp3_0 + s1_182; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 183: dim3x3 add
    gl64_t s1_183_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_183_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_183_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_183_0; tmp3_1 = tmp3_1 + s1_183_1; tmp3_2 = tmp3_2 + s1_183_2;
    // Op 184: dim3x3 mul
    gl64_t s1_184_0 = *(gl64_t*)&expressions_params[10][1];
    gl64_t s1_184_1 = *(gl64_t*)&expressions_params[10][1+1];
    gl64_t s1_184_2 = *(gl64_t*)&expressions_params[10][1+2];
    gl64_t kA184 = (tmp3_0 + tmp3_1) * (s1_184_0 + s1_184_1);
    gl64_t kB184 = (tmp3_0 + tmp3_2) * (s1_184_0 + s1_184_2);
    gl64_t kC184 = (tmp3_1 + tmp3_2) * (s1_184_1 + s1_184_2);
    gl64_t kD184 = tmp3_0 * s1_184_0;
    gl64_t kE184 = tmp3_1 * s1_184_1;
    gl64_t kF184 = tmp3_2 * s1_184_2;
    gl64_t kG184 = kD184 - kE184;
    tmp3_0 = (kC184 + kG184) - kF184;
    tmp3_1 = ((((kA184 + kC184) - kE184) - kE184) - kD184);
    tmp3_2 = kB184 - kG184;
    // Op 185: dim3x1 sub
    gl64_t s1_185 = *(gl64_t*)&expressions_params[10][0];
    tmp3_0 = tmp3_0 - s1_185; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 186: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 187: dim3x3 mul
    gl64_t s1_187_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_187_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_187_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA187 = (tmp3_0 + tmp3_1) * (s1_187_0 + s1_187_1);
    gl64_t kB187 = (tmp3_0 + tmp3_2) * (s1_187_0 + s1_187_2);
    gl64_t kC187 = (tmp3_1 + tmp3_2) * (s1_187_1 + s1_187_2);
    gl64_t kD187 = tmp3_0 * s1_187_0;
    gl64_t kE187 = tmp3_1 * s1_187_1;
    gl64_t kF187 = tmp3_2 * s1_187_2;
    gl64_t kG187 = kD187 - kE187;
    tmp3_6 = (kC187 + kG187) - kF187;
    tmp3_7 = ((((kA187 + kC187) - kE187) - kE187) - kD187);
    tmp3_8 = kB187 - kG187;
    // Op 188: dim3x3 mul
    gl64_t s0_188_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_188_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_188_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_188_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_188_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_188_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA188 = (s0_188_0 + s0_188_1) * (s1_188_0 + s1_188_1);
    gl64_t kB188 = (s0_188_0 + s0_188_2) * (s1_188_0 + s1_188_2);
    gl64_t kC188 = (s0_188_1 + s0_188_2) * (s1_188_1 + s1_188_2);
    gl64_t kD188 = s0_188_0 * s1_188_0;
    gl64_t kE188 = s0_188_1 * s1_188_1;
    gl64_t kF188 = s0_188_2 * s1_188_2;
    gl64_t kG188 = kD188 - kE188;
    tmp3_0 = (kC188 + kG188) - kF188;
    tmp3_1 = ((((kA188 + kC188) - kE188) - kE188) - kD188);
    tmp3_2 = kB188 - kG188;
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
    // Op 190: dim3x1 add
    gl64_t s1_190 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_190; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 191: dim3x3 mul
    gl64_t s1_191_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_191_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_191_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA191 = (tmp3_0 + tmp3_1) * (s1_191_0 + s1_191_1);
    gl64_t kB191 = (tmp3_0 + tmp3_2) * (s1_191_0 + s1_191_2);
    gl64_t kC191 = (tmp3_1 + tmp3_2) * (s1_191_1 + s1_191_2);
    gl64_t kD191 = tmp3_0 * s1_191_0;
    gl64_t kE191 = tmp3_1 * s1_191_1;
    gl64_t kF191 = tmp3_2 * s1_191_2;
    gl64_t kG191 = kD191 - kE191;
    tmp3_0 = (kC191 + kG191) - kF191;
    tmp3_1 = ((((kA191 + kC191) - kE191) - kE191) - kD191);
    tmp3_2 = kB191 - kG191;
    // Op 192: dim3x1 add
    gl64_t s1_192 = *(gl64_t*)&expressions_params[9][5];
    tmp3_0 = tmp3_0 + s1_192; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 193: dim3x3 add
    gl64_t s1_193_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_193_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_193_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_193_0; tmp3_1 = tmp3_1 + s1_193_1; tmp3_2 = tmp3_2 + s1_193_2;
    // Op 194: dim3x3 mul
    gl64_t s1_194_0 = *(gl64_t*)&expressions_params[10][4];
    gl64_t s1_194_1 = *(gl64_t*)&expressions_params[10][4+1];
    gl64_t s1_194_2 = *(gl64_t*)&expressions_params[10][4+2];
    gl64_t kA194 = (tmp3_0 + tmp3_1) * (s1_194_0 + s1_194_1);
    gl64_t kB194 = (tmp3_0 + tmp3_2) * (s1_194_0 + s1_194_2);
    gl64_t kC194 = (tmp3_1 + tmp3_2) * (s1_194_1 + s1_194_2);
    gl64_t kD194 = tmp3_0 * s1_194_0;
    gl64_t kE194 = tmp3_1 * s1_194_1;
    gl64_t kF194 = tmp3_2 * s1_194_2;
    gl64_t kG194 = kD194 - kE194;
    tmp3_0 = (kC194 + kG194) - kF194;
    tmp3_1 = ((((kA194 + kC194) - kE194) - kE194) - kD194);
    tmp3_2 = kB194 - kG194;
    // Op 195: dim1x1 sub
    gl64_t s0_195 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_195 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_195 - s1_195;
    // Op 196: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = s1_199_0 - s0_199_0; tmp3_1 = s1_199_1 - s0_199_1; tmp3_2 = s1_199_2 - s0_199_2;
    // Op 200: dim3x3 add
    gl64_t s0_200_0 = *(gl64_t*)&expressions_params[10][1];
    gl64_t s0_200_1 = *(gl64_t*)&expressions_params[10][1+1];
    gl64_t s0_200_2 = *(gl64_t*)&expressions_params[10][1+2];
    gl64_t s1_200_0 = *(gl64_t*)&expressions_params[10][4];
    gl64_t s1_200_1 = *(gl64_t*)&expressions_params[10][4+1];
    gl64_t s1_200_2 = *(gl64_t*)&expressions_params[10][4+2];
    tmp3_6 = s0_200_0 + s1_200_0; tmp3_7 = s0_200_1 + s1_200_1; tmp3_8 = s0_200_2 + s1_200_2;
    // Op 201: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 202: dim3x1 mul
    gl64_t s1_202 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_202; tmp3_1 = tmp3_1 * s1_202; tmp3_2 = tmp3_2 * s1_202;
    // Op 203: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 204: dim3x1 mul
    gl64_t s1_204 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_204; tmp3_1 = tmp3_1 * s1_204; tmp3_2 = tmp3_2 * s1_204;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
