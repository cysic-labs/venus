// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: 46c946cc  nOps=494 nTemp1=8 nTemp3=5
#define GENERATED_EVAL_NOPS_46c946cc 494
#define GENERATED_EVAL_NTEMP1_46c946cc 8
#define GENERATED_EVAL_NTEMP3_46c946cc 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_46c946cc(
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

    // Register-resident temporaries: 8 tmp1 + 15 tmp3 slots
    gl64_t tmp1_0 = gl64_t(uint64_t(0));
    gl64_t tmp1_1 = gl64_t(uint64_t(0));
    gl64_t tmp1_2 = gl64_t(uint64_t(0));
    gl64_t tmp1_3 = gl64_t(uint64_t(0));
    gl64_t tmp1_4 = gl64_t(uint64_t(0));
    gl64_t tmp1_5 = gl64_t(uint64_t(0));
    gl64_t tmp1_6 = gl64_t(uint64_t(0));
    gl64_t tmp1_7 = gl64_t(uint64_t(0));
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
    gl64_t s1_0 = *(gl64_t*)&expressions_params[9][21];
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
    gl64_t s1_3 = *(gl64_t*)&expressions_params[9][21];
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
    gl64_t s1_7 = *(gl64_t*)&expressions_params[9][21];
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
    // Op 11: dim1x1 sub_swap
    gl64_t s0_11 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_11 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_11 - s0_11;
    // Op 12: dim1x1 mul
    gl64_t s0_12 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_12 * tmp1_0;
    // Op 13: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 14: dim3x3 mul
    gl64_t s1_14_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_14_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_14_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA14 = (tmp3_0 + tmp3_1) * (s1_14_0 + s1_14_1);
    gl64_t kB14 = (tmp3_0 + tmp3_2) * (s1_14_0 + s1_14_2);
    gl64_t kC14 = (tmp3_1 + tmp3_2) * (s1_14_1 + s1_14_2);
    gl64_t kD14 = tmp3_0 * s1_14_0;
    gl64_t kE14 = tmp3_1 * s1_14_1;
    gl64_t kF14 = tmp3_2 * s1_14_2;
    gl64_t kG14 = kD14 - kE14;
    tmp3_0 = (kC14 + kG14) - kF14;
    tmp3_1 = ((((kA14 + kC14) - kE14) - kE14) - kD14);
    tmp3_2 = kB14 - kG14;
    // Op 15: dim1x1 sub_swap
    gl64_t s0_15 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_15 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_15 - s0_15;
    // Op 16: dim1x1 mul
    gl64_t s0_16 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_16 * tmp1_0;
    // Op 17: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 18: dim3x3 mul
    gl64_t s1_18_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_18_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_18_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA18 = (tmp3_0 + tmp3_1) * (s1_18_0 + s1_18_1);
    gl64_t kB18 = (tmp3_0 + tmp3_2) * (s1_18_0 + s1_18_2);
    gl64_t kC18 = (tmp3_1 + tmp3_2) * (s1_18_1 + s1_18_2);
    gl64_t kD18 = tmp3_0 * s1_18_0;
    gl64_t kE18 = tmp3_1 * s1_18_1;
    gl64_t kF18 = tmp3_2 * s1_18_2;
    gl64_t kG18 = kD18 - kE18;
    tmp3_0 = (kC18 + kG18) - kF18;
    tmp3_1 = ((((kA18 + kC18) - kE18) - kE18) - kD18);
    tmp3_2 = kB18 - kG18;
    // Op 19: dim1x1 add
    gl64_t s0_19 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_19 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_19 + s1_19;
    // Op 20: dim1x1 add
    gl64_t s0_20 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_20 + tmp1_0;
    // Op 21: dim1x1 add
    gl64_t s0_21 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_7 = s0_21 + tmp1_0;
    // Op 22: dim1x1 sub_swap
    gl64_t s1_22 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_22 - tmp1_7;
    // Op 23: dim1x1 mul
    tmp1_0 = tmp1_7 * tmp1_0;
    // Op 24: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 25: dim3x3 mul
    gl64_t s1_25_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_25_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_25_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA25 = (tmp3_0 + tmp3_1) * (s1_25_0 + s1_25_1);
    gl64_t kB25 = (tmp3_0 + tmp3_2) * (s1_25_0 + s1_25_2);
    gl64_t kC25 = (tmp3_1 + tmp3_2) * (s1_25_1 + s1_25_2);
    gl64_t kD25 = tmp3_0 * s1_25_0;
    gl64_t kE25 = tmp3_1 * s1_25_1;
    gl64_t kF25 = tmp3_2 * s1_25_2;
    gl64_t kG25 = kD25 - kE25;
    tmp3_0 = (kC25 + kG25) - kF25;
    tmp3_1 = ((((kA25 + kC25) - kE25) - kE25) - kD25);
    tmp3_2 = kB25 - kG25;
    // Op 26: dim1x1 add
    gl64_t s0_26 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_26 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_26 + s1_26;
    // Op 27: dim1x1 add
    gl64_t s0_27 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_1 = s0_27 + tmp1_0;
    // Op 28: dim1x1 sub_swap
    gl64_t s1_28 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_28 - tmp1_1;
    // Op 29: dim1x1 mul
    gl64_t s0_29 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_29 * tmp1_0;
    // Op 30: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 31: dim3x3 mul
    gl64_t s1_31_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_31_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_31_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA31 = (tmp3_0 + tmp3_1) * (s1_31_0 + s1_31_1);
    gl64_t kB31 = (tmp3_0 + tmp3_2) * (s1_31_0 + s1_31_2);
    gl64_t kC31 = (tmp3_1 + tmp3_2) * (s1_31_1 + s1_31_2);
    gl64_t kD31 = tmp3_0 * s1_31_0;
    gl64_t kE31 = tmp3_1 * s1_31_1;
    gl64_t kF31 = tmp3_2 * s1_31_2;
    gl64_t kG31 = kD31 - kE31;
    tmp3_0 = (kC31 + kG31) - kF31;
    tmp3_1 = ((((kA31 + kC31) - kE31) - kE31) - kD31);
    tmp3_2 = kB31 - kG31;
    // Op 32: dim1x1 sub_swap
    gl64_t s0_32 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_6 = tmp1_1 - s0_32;
    // Op 33: dim1x1 sub_swap
    gl64_t s1_33 = *(gl64_t*)&expressions_params[9][21];
    tmp1_1 = s1_33 - tmp1_6;
    // Op 34: dim1x1 mul
    tmp1_1 = tmp1_6 * tmp1_1;
    // Op 35: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 36: dim3x3 mul
    gl64_t s1_36_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_36_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_36_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA36 = (tmp3_0 + tmp3_1) * (s1_36_0 + s1_36_1);
    gl64_t kB36 = (tmp3_0 + tmp3_2) * (s1_36_0 + s1_36_2);
    gl64_t kC36 = (tmp3_1 + tmp3_2) * (s1_36_1 + s1_36_2);
    gl64_t kD36 = tmp3_0 * s1_36_0;
    gl64_t kE36 = tmp3_1 * s1_36_1;
    gl64_t kF36 = tmp3_2 * s1_36_2;
    gl64_t kG36 = kD36 - kE36;
    tmp3_0 = (kC36 + kG36) - kF36;
    tmp3_1 = ((((kA36 + kC36) - kE36) - kE36) - kD36);
    tmp3_2 = kB36 - kG36;
    // Op 37: dim1x1 sub_swap
    gl64_t s0_37 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_37 = *(gl64_t*)&expressions_params[9][21];
    tmp1_1 = s1_37 - s0_37;
    // Op 38: dim1x1 mul
    gl64_t s0_38 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_1 = s0_38 * tmp1_1;
    // Op 39: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 40: dim3x3 mul
    gl64_t s1_40_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_40_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_40_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA40 = (tmp3_0 + tmp3_1) * (s1_40_0 + s1_40_1);
    gl64_t kB40 = (tmp3_0 + tmp3_2) * (s1_40_0 + s1_40_2);
    gl64_t kC40 = (tmp3_1 + tmp3_2) * (s1_40_1 + s1_40_2);
    gl64_t kD40 = tmp3_0 * s1_40_0;
    gl64_t kE40 = tmp3_1 * s1_40_1;
    gl64_t kF40 = tmp3_2 * s1_40_2;
    gl64_t kG40 = kD40 - kE40;
    tmp3_0 = (kC40 + kG40) - kF40;
    tmp3_1 = ((((kA40 + kC40) - kE40) - kE40) - kD40);
    tmp3_2 = kB40 - kG40;
    // Op 41: dim1x1 mul
    gl64_t s0_41 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_41 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_1 = s0_41 * s1_41;
    // Op 42: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 43: dim3x3 mul
    gl64_t s1_43_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_43_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_43_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA43 = (tmp3_0 + tmp3_1) * (s1_43_0 + s1_43_1);
    gl64_t kB43 = (tmp3_0 + tmp3_2) * (s1_43_0 + s1_43_2);
    gl64_t kC43 = (tmp3_1 + tmp3_2) * (s1_43_1 + s1_43_2);
    gl64_t kD43 = tmp3_0 * s1_43_0;
    gl64_t kE43 = tmp3_1 * s1_43_1;
    gl64_t kF43 = tmp3_2 * s1_43_2;
    gl64_t kG43 = kD43 - kE43;
    tmp3_0 = (kC43 + kG43) - kF43;
    tmp3_1 = ((((kA43 + kC43) - kE43) - kE43) - kD43);
    tmp3_2 = kB43 - kG43;
    // Op 44: dim1x1 add
    gl64_t s0_44 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_44 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_1 = s0_44 + s1_44;
    // Op 45: dim1x1 add
    gl64_t s0_45 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_45 + tmp1_1;
    // Op 46: dim1x1 mul
    gl64_t s0_46 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_46 = *(gl64_t*)&expressions_params[9][3];
    tmp1_1 = s0_46 * s1_46;
    // Op 47: dim1x1 add
    gl64_t s0_47 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_3 = s0_47 + tmp1_1;
    // Op 48: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_3;
    // Op 49: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 50: dim3x3 mul
    gl64_t s1_50_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_50_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_50_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA50 = (tmp3_0 + tmp3_1) * (s1_50_0 + s1_50_1);
    gl64_t kB50 = (tmp3_0 + tmp3_2) * (s1_50_0 + s1_50_2);
    gl64_t kC50 = (tmp3_1 + tmp3_2) * (s1_50_1 + s1_50_2);
    gl64_t kD50 = tmp3_0 * s1_50_0;
    gl64_t kE50 = tmp3_1 * s1_50_1;
    gl64_t kF50 = tmp3_2 * s1_50_2;
    gl64_t kG50 = kD50 - kE50;
    tmp3_0 = (kC50 + kG50) - kF50;
    tmp3_1 = ((((kA50 + kC50) - kE50) - kE50) - kD50);
    tmp3_2 = kB50 - kG50;
    // Op 51: dim1x1 sub_swap
    gl64_t s0_51 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_51 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_51 - s0_51;
    // Op 52: dim1x1 mul
    gl64_t s0_52 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_0 = s0_52 * tmp1_0;
    // Op 53: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 54: dim3x3 mul
    gl64_t s1_54_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_54_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_54_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA54 = (tmp3_0 + tmp3_1) * (s1_54_0 + s1_54_1);
    gl64_t kB54 = (tmp3_0 + tmp3_2) * (s1_54_0 + s1_54_2);
    gl64_t kC54 = (tmp3_1 + tmp3_2) * (s1_54_1 + s1_54_2);
    gl64_t kD54 = tmp3_0 * s1_54_0;
    gl64_t kE54 = tmp3_1 * s1_54_1;
    gl64_t kF54 = tmp3_2 * s1_54_2;
    gl64_t kG54 = kD54 - kE54;
    tmp3_0 = (kC54 + kG54) - kF54;
    tmp3_1 = ((((kA54 + kC54) - kE54) - kE54) - kD54);
    tmp3_2 = kB54 - kG54;
    // Op 55: dim1x1 add
    gl64_t s0_55 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_55 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_55 + s1_55;
    // Op 56: dim1x1 mul
    gl64_t s0_56 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp1_0 = s0_56 * tmp1_0;
    // Op 57: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 58: dim3x3 mul
    gl64_t s1_58_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_58_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_58_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA58 = (tmp3_0 + tmp3_1) * (s1_58_0 + s1_58_1);
    gl64_t kB58 = (tmp3_0 + tmp3_2) * (s1_58_0 + s1_58_2);
    gl64_t kC58 = (tmp3_1 + tmp3_2) * (s1_58_1 + s1_58_2);
    gl64_t kD58 = tmp3_0 * s1_58_0;
    gl64_t kE58 = tmp3_1 * s1_58_1;
    gl64_t kF58 = tmp3_2 * s1_58_2;
    gl64_t kG58 = kD58 - kE58;
    tmp3_0 = (kC58 + kG58) - kF58;
    tmp3_1 = ((((kA58 + kC58) - kE58) - kE58) - kD58);
    tmp3_2 = kB58 - kG58;
    // Op 59: dim1x1 sub_swap
    gl64_t s0_59 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_59 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_59 - s0_59;
    // Op 60: dim1x1 mul
    gl64_t s0_60 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_0 = s0_60 * tmp1_0;
    // Op 61: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 62: dim3x3 mul
    gl64_t s1_62_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_62_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_62_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA62 = (tmp3_0 + tmp3_1) * (s1_62_0 + s1_62_1);
    gl64_t kB62 = (tmp3_0 + tmp3_2) * (s1_62_0 + s1_62_2);
    gl64_t kC62 = (tmp3_1 + tmp3_2) * (s1_62_1 + s1_62_2);
    gl64_t kD62 = tmp3_0 * s1_62_0;
    gl64_t kE62 = tmp3_1 * s1_62_1;
    gl64_t kF62 = tmp3_2 * s1_62_2;
    gl64_t kG62 = kD62 - kE62;
    tmp3_0 = (kC62 + kG62) - kF62;
    tmp3_1 = ((((kA62 + kC62) - kE62) - kE62) - kD62);
    tmp3_2 = kB62 - kG62;
    // Op 63: dim1x1 sub_swap
    gl64_t s0_63 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    gl64_t s1_63 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_63 - s0_63;
    // Op 64: dim1x1 mul
    gl64_t s0_64 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_64 * tmp1_0;
    // Op 65: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 66: dim3x3 mul
    gl64_t s1_66_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_66_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_66_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA66 = (tmp3_0 + tmp3_1) * (s1_66_0 + s1_66_1);
    gl64_t kB66 = (tmp3_0 + tmp3_2) * (s1_66_0 + s1_66_2);
    gl64_t kC66 = (tmp3_1 + tmp3_2) * (s1_66_1 + s1_66_2);
    gl64_t kD66 = tmp3_0 * s1_66_0;
    gl64_t kE66 = tmp3_1 * s1_66_1;
    gl64_t kF66 = tmp3_2 * s1_66_2;
    gl64_t kG66 = kD66 - kE66;
    tmp3_0 = (kC66 + kG66) - kF66;
    tmp3_1 = ((((kA66 + kC66) - kE66) - kE66) - kD66);
    tmp3_2 = kB66 - kG66;
    // Op 67: dim1x1 sub_swap
    gl64_t s0_67 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_67 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_67 - s0_67;
    // Op 68: dim1x1 mul
    gl64_t s0_68 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_68 * tmp1_0;
    // Op 69: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 70: dim3x3 mul
    gl64_t s1_70_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_70_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_70_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA70 = (tmp3_0 + tmp3_1) * (s1_70_0 + s1_70_1);
    gl64_t kB70 = (tmp3_0 + tmp3_2) * (s1_70_0 + s1_70_2);
    gl64_t kC70 = (tmp3_1 + tmp3_2) * (s1_70_1 + s1_70_2);
    gl64_t kD70 = tmp3_0 * s1_70_0;
    gl64_t kE70 = tmp3_1 * s1_70_1;
    gl64_t kF70 = tmp3_2 * s1_70_2;
    gl64_t kG70 = kD70 - kE70;
    tmp3_0 = (kC70 + kG70) - kF70;
    tmp3_1 = ((((kA70 + kC70) - kE70) - kE70) - kD70);
    tmp3_2 = kB70 - kG70;
    // Op 71: dim1x1 sub_swap
    gl64_t s1_71 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_71 - tmp1_7;
    // Op 72: dim1x1 mul
    gl64_t s0_72 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_72 * tmp1_0;
    // Op 73: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 74: dim3x3 mul
    gl64_t s1_74_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_74_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_74_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 75: dim1x1 sub_swap
    gl64_t s1_75 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_75 - tmp1_7;
    // Op 76: dim1x1 mul
    gl64_t s0_76 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_0 = s0_76 * tmp1_0;
    // Op 77: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 78: dim3x3 mul
    gl64_t s1_78_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_78_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_78_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA78 = (tmp3_0 + tmp3_1) * (s1_78_0 + s1_78_1);
    gl64_t kB78 = (tmp3_0 + tmp3_2) * (s1_78_0 + s1_78_2);
    gl64_t kC78 = (tmp3_1 + tmp3_2) * (s1_78_1 + s1_78_2);
    gl64_t kD78 = tmp3_0 * s1_78_0;
    gl64_t kE78 = tmp3_1 * s1_78_1;
    gl64_t kF78 = tmp3_2 * s1_78_2;
    gl64_t kG78 = kD78 - kE78;
    tmp3_0 = (kC78 + kG78) - kF78;
    tmp3_1 = ((((kA78 + kC78) - kE78) - kE78) - kD78);
    tmp3_2 = kB78 - kG78;
    // Op 79: dim1x1 sub_swap
    gl64_t s1_79 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_79 - tmp1_7;
    // Op 80: dim1x1 mul
    gl64_t s0_80 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_80 * tmp1_0;
    // Op 81: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 82: dim3x3 mul
    gl64_t s1_82_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_82_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_82_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 83: dim1x1 sub_swap
    gl64_t s0_83 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_83 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_83 - s0_83;
    // Op 84: dim1x1 mul
    gl64_t s0_84 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_0 = s0_84 * tmp1_0;
    // Op 85: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 86: dim3x3 mul
    gl64_t s1_86_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_86_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_86_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA86 = (tmp3_0 + tmp3_1) * (s1_86_0 + s1_86_1);
    gl64_t kB86 = (tmp3_0 + tmp3_2) * (s1_86_0 + s1_86_2);
    gl64_t kC86 = (tmp3_1 + tmp3_2) * (s1_86_1 + s1_86_2);
    gl64_t kD86 = tmp3_0 * s1_86_0;
    gl64_t kE86 = tmp3_1 * s1_86_1;
    gl64_t kF86 = tmp3_2 * s1_86_2;
    gl64_t kG86 = kD86 - kE86;
    tmp3_0 = (kC86 + kG86) - kF86;
    tmp3_1 = ((((kA86 + kC86) - kE86) - kE86) - kD86);
    tmp3_2 = kB86 - kG86;
    // Op 87: dim1x1 sub_swap
    gl64_t s0_87 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_87 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_87 - s0_87;
    // Op 88: dim1x1 mul
    gl64_t s0_88 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_88 * tmp1_0;
    // Op 89: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 90: dim3x3 mul
    gl64_t s1_90_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_90_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_90_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 91: dim1x1 mul
    gl64_t s0_91 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_91 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_91 * s1_91;
    // Op 92: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 93: dim3x3 mul
    gl64_t s1_93_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_93_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_93_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA93 = (tmp3_0 + tmp3_1) * (s1_93_0 + s1_93_1);
    gl64_t kB93 = (tmp3_0 + tmp3_2) * (s1_93_0 + s1_93_2);
    gl64_t kC93 = (tmp3_1 + tmp3_2) * (s1_93_1 + s1_93_2);
    gl64_t kD93 = tmp3_0 * s1_93_0;
    gl64_t kE93 = tmp3_1 * s1_93_1;
    gl64_t kF93 = tmp3_2 * s1_93_2;
    gl64_t kG93 = kD93 - kE93;
    tmp3_0 = (kC93 + kG93) - kF93;
    tmp3_1 = ((((kA93 + kC93) - kE93) - kE93) - kD93);
    tmp3_2 = kB93 - kG93;
    // Op 94: dim1x1 add
    gl64_t s0_94 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    gl64_t s1_94 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_94 + s1_94;
    // Op 95: dim1x1 add
    gl64_t s0_95 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_95 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    tmp1_1 = s0_95 + s1_95;
    // Op 96: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 97: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 98: dim3x3 mul
    gl64_t s1_98_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_98_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_98_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA98 = (tmp3_0 + tmp3_1) * (s1_98_0 + s1_98_1);
    gl64_t kB98 = (tmp3_0 + tmp3_2) * (s1_98_0 + s1_98_2);
    gl64_t kC98 = (tmp3_1 + tmp3_2) * (s1_98_1 + s1_98_2);
    gl64_t kD98 = tmp3_0 * s1_98_0;
    gl64_t kE98 = tmp3_1 * s1_98_1;
    gl64_t kF98 = tmp3_2 * s1_98_2;
    gl64_t kG98 = kD98 - kE98;
    tmp3_0 = (kC98 + kG98) - kF98;
    tmp3_1 = ((((kA98 + kC98) - kE98) - kE98) - kD98);
    tmp3_2 = kB98 - kG98;
    // Op 99: dim1x1 sub_swap
    gl64_t s0_99 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_99 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_99 - s0_99;
    // Op 100: dim1x1 mul
    gl64_t s0_100 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp1_0 = s0_100 * tmp1_0;
    // Op 101: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 102: dim3x3 mul
    gl64_t s1_102_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_102_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_102_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA102 = (tmp3_0 + tmp3_1) * (s1_102_0 + s1_102_1);
    gl64_t kB102 = (tmp3_0 + tmp3_2) * (s1_102_0 + s1_102_2);
    gl64_t kC102 = (tmp3_1 + tmp3_2) * (s1_102_1 + s1_102_2);
    gl64_t kD102 = tmp3_0 * s1_102_0;
    gl64_t kE102 = tmp3_1 * s1_102_1;
    gl64_t kF102 = tmp3_2 * s1_102_2;
    gl64_t kG102 = kD102 - kE102;
    tmp3_0 = (kC102 + kG102) - kF102;
    tmp3_1 = ((((kA102 + kC102) - kE102) - kE102) - kD102);
    tmp3_2 = kB102 - kG102;
    // Op 103: dim1x1 sub_swap
    gl64_t s0_103 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_103 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_103 - s0_103;
    // Op 104: dim1x1 mul
    gl64_t s0_104 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_104 * tmp1_0;
    // Op 105: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 106: dim3x3 mul
    gl64_t s1_106_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_106_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_106_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA106 = (tmp3_0 + tmp3_1) * (s1_106_0 + s1_106_1);
    gl64_t kB106 = (tmp3_0 + tmp3_2) * (s1_106_0 + s1_106_2);
    gl64_t kC106 = (tmp3_1 + tmp3_2) * (s1_106_1 + s1_106_2);
    gl64_t kD106 = tmp3_0 * s1_106_0;
    gl64_t kE106 = tmp3_1 * s1_106_1;
    gl64_t kF106 = tmp3_2 * s1_106_2;
    gl64_t kG106 = kD106 - kE106;
    tmp3_0 = (kC106 + kG106) - kF106;
    tmp3_1 = ((((kA106 + kC106) - kE106) - kE106) - kD106);
    tmp3_2 = kB106 - kG106;
    // Op 107: dim1x1 sub_swap
    gl64_t s0_107 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_107 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_107 - s0_107;
    // Op 108: dim1x1 mul
    gl64_t s0_108 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_0 = s0_108 * tmp1_0;
    // Op 109: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC110 + kG110) - kF110;
    tmp3_1 = ((((kA110 + kC110) - kE110) - kE110) - kD110);
    tmp3_2 = kB110 - kG110;
    // Op 111: dim1x1 sub_swap
    gl64_t s0_111 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_111 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_111 - s0_111;
    // Op 112: dim1x1 mul
    gl64_t s0_112 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp1_0 = s0_112 * tmp1_0;
    // Op 113: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 114: dim3x3 mul
    gl64_t s1_114_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_114_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_114_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA114 = (tmp3_0 + tmp3_1) * (s1_114_0 + s1_114_1);
    gl64_t kB114 = (tmp3_0 + tmp3_2) * (s1_114_0 + s1_114_2);
    gl64_t kC114 = (tmp3_1 + tmp3_2) * (s1_114_1 + s1_114_2);
    gl64_t kD114 = tmp3_0 * s1_114_0;
    gl64_t kE114 = tmp3_1 * s1_114_1;
    gl64_t kF114 = tmp3_2 * s1_114_2;
    gl64_t kG114 = kD114 - kE114;
    tmp3_0 = (kC114 + kG114) - kF114;
    tmp3_1 = ((((kA114 + kC114) - kE114) - kE114) - kD114);
    tmp3_2 = kB114 - kG114;
    // Op 115: dim1x1 sub_swap
    gl64_t s0_115 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_115 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_115 - s0_115;
    // Op 116: dim1x1 mul
    gl64_t s0_116 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    tmp1_0 = s0_116 * tmp1_0;
    // Op 117: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 118: dim3x3 mul
    gl64_t s1_118_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_118_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_118_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA118 = (tmp3_0 + tmp3_1) * (s1_118_0 + s1_118_1);
    gl64_t kB118 = (tmp3_0 + tmp3_2) * (s1_118_0 + s1_118_2);
    gl64_t kC118 = (tmp3_1 + tmp3_2) * (s1_118_1 + s1_118_2);
    gl64_t kD118 = tmp3_0 * s1_118_0;
    gl64_t kE118 = tmp3_1 * s1_118_1;
    gl64_t kF118 = tmp3_2 * s1_118_2;
    gl64_t kG118 = kD118 - kE118;
    tmp3_0 = (kC118 + kG118) - kF118;
    tmp3_1 = ((((kA118 + kC118) - kE118) - kE118) - kD118);
    tmp3_2 = kB118 - kG118;
    // Op 119: dim1x1 sub_swap
    gl64_t s0_119 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_119 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_119 - s0_119;
    // Op 120: dim1x1 mul
    gl64_t s0_120 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_120 * tmp1_0;
    // Op 121: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC122 + kG122) - kF122;
    tmp3_1 = ((((kA122 + kC122) - kE122) - kE122) - kD122);
    tmp3_2 = kB122 - kG122;
    // Op 123: dim1x1 mul
    gl64_t s0_123 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    gl64_t s1_123 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_123 * s1_123;
    // Op 124: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 125: dim3x3 mul
    gl64_t s1_125_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_125_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_125_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA125 = (tmp3_0 + tmp3_1) * (s1_125_0 + s1_125_1);
    gl64_t kB125 = (tmp3_0 + tmp3_2) * (s1_125_0 + s1_125_2);
    gl64_t kC125 = (tmp3_1 + tmp3_2) * (s1_125_1 + s1_125_2);
    gl64_t kD125 = tmp3_0 * s1_125_0;
    gl64_t kE125 = tmp3_1 * s1_125_1;
    gl64_t kF125 = tmp3_2 * s1_125_2;
    gl64_t kG125 = kD125 - kE125;
    tmp3_0 = (kC125 + kG125) - kF125;
    tmp3_1 = ((((kA125 + kC125) - kE125) - kE125) - kD125);
    tmp3_2 = kB125 - kG125;
    // Op 126: dim1x1 mul
    gl64_t s0_126 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_126 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_126 * s1_126;
    // Op 127: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC128 + kG128) - kF128;
    tmp3_1 = ((((kA128 + kC128) - kE128) - kE128) - kD128);
    tmp3_2 = kB128 - kG128;
    // Op 129: dim1x1 mul
    gl64_t s0_129 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_129 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_129 * s1_129;
    // Op 130: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 131: dim3x3 mul
    gl64_t s1_131_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_131_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_131_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA131 = (tmp3_0 + tmp3_1) * (s1_131_0 + s1_131_1);
    gl64_t kB131 = (tmp3_0 + tmp3_2) * (s1_131_0 + s1_131_2);
    gl64_t kC131 = (tmp3_1 + tmp3_2) * (s1_131_1 + s1_131_2);
    gl64_t kD131 = tmp3_0 * s1_131_0;
    gl64_t kE131 = tmp3_1 * s1_131_1;
    gl64_t kF131 = tmp3_2 * s1_131_2;
    gl64_t kG131 = kD131 - kE131;
    tmp3_0 = (kC131 + kG131) - kF131;
    tmp3_1 = ((((kA131 + kC131) - kE131) - kE131) - kD131);
    tmp3_2 = kB131 - kG131;
    // Op 132: dim1x1 sub_swap
    gl64_t s0_132 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_132 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_132 - s0_132;
    // Op 133: dim1x1 mul
    gl64_t s0_133 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_0 = s0_133 * tmp1_0;
    // Op 134: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 135: dim3x3 mul
    gl64_t s1_135_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_135_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_135_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA135 = (tmp3_0 + tmp3_1) * (s1_135_0 + s1_135_1);
    gl64_t kB135 = (tmp3_0 + tmp3_2) * (s1_135_0 + s1_135_2);
    gl64_t kC135 = (tmp3_1 + tmp3_2) * (s1_135_1 + s1_135_2);
    gl64_t kD135 = tmp3_0 * s1_135_0;
    gl64_t kE135 = tmp3_1 * s1_135_1;
    gl64_t kF135 = tmp3_2 * s1_135_2;
    gl64_t kG135 = kD135 - kE135;
    tmp3_0 = (kC135 + kG135) - kF135;
    tmp3_1 = ((((kA135 + kC135) - kE135) - kE135) - kD135);
    tmp3_2 = kB135 - kG135;
    // Op 136: dim1x1 sub_swap
    gl64_t s0_136 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_136 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_136 - s0_136;
    // Op 137: dim1x1 mul
    gl64_t s0_137 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_137 * tmp1_0;
    // Op 138: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 139: dim3x3 mul
    gl64_t s1_139_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_139_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_139_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 140: dim1x1 sub_swap
    gl64_t s0_140 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_140 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_140 - s0_140;
    // Op 141: dim1x1 mul
    gl64_t s0_141 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp1_0 = s0_141 * tmp1_0;
    // Op 142: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 143: dim3x3 mul
    gl64_t s1_143_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_143_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_143_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 144: dim1x1 sub_swap
    gl64_t s0_144 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_144 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_144 - s0_144;
    // Op 145: dim1x1 mul
    gl64_t s0_145 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_145 * tmp1_0;
    // Op 146: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 147: dim3x3 mul
    gl64_t s1_147_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_147_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_147_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA147 = (tmp3_0 + tmp3_1) * (s1_147_0 + s1_147_1);
    gl64_t kB147 = (tmp3_0 + tmp3_2) * (s1_147_0 + s1_147_2);
    gl64_t kC147 = (tmp3_1 + tmp3_2) * (s1_147_1 + s1_147_2);
    gl64_t kD147 = tmp3_0 * s1_147_0;
    gl64_t kE147 = tmp3_1 * s1_147_1;
    gl64_t kF147 = tmp3_2 * s1_147_2;
    gl64_t kG147 = kD147 - kE147;
    tmp3_0 = (kC147 + kG147) - kF147;
    tmp3_1 = ((((kA147 + kC147) - kE147) - kE147) - kD147);
    tmp3_2 = kB147 - kG147;
    // Op 148: dim1x1 sub_swap
    gl64_t s0_148 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_148 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_148 - s0_148;
    // Op 149: dim1x1 mul
    gl64_t s0_149 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp1_0 = s0_149 * tmp1_0;
    // Op 150: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC151 + kG151) - kF151;
    tmp3_1 = ((((kA151 + kC151) - kE151) - kE151) - kD151);
    tmp3_2 = kB151 - kG151;
    // Op 152: dim1x1 sub_swap
    gl64_t s0_152 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_152 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_152 - s0_152;
    // Op 153: dim1x1 mul
    gl64_t s0_153 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    tmp1_0 = s0_153 * tmp1_0;
    // Op 154: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 155: dim3x3 mul
    gl64_t s1_155_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_155_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_155_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 156: dim1x1 add
    gl64_t s0_156 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_156 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_4 = s0_156 + s1_156;
    // Op 157: dim1x1 sub_swap
    gl64_t s1_157 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_157 - tmp1_4;
    // Op 158: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_3;
    // Op 159: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 160: dim3x3 mul
    gl64_t s1_160_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_160_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_160_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA160 = (tmp3_0 + tmp3_1) * (s1_160_0 + s1_160_1);
    gl64_t kB160 = (tmp3_0 + tmp3_2) * (s1_160_0 + s1_160_2);
    gl64_t kC160 = (tmp3_1 + tmp3_2) * (s1_160_1 + s1_160_2);
    gl64_t kD160 = tmp3_0 * s1_160_0;
    gl64_t kE160 = tmp3_1 * s1_160_1;
    gl64_t kF160 = tmp3_2 * s1_160_2;
    gl64_t kG160 = kD160 - kE160;
    tmp3_0 = (kC160 + kG160) - kF160;
    tmp3_1 = ((((kA160 + kC160) - kE160) - kE160) - kD160);
    tmp3_2 = kB160 - kG160;
    // Op 161: dim1x1 sub_swap
    gl64_t s0_161 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_161 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_161 - s0_161;
    // Op 162: dim1x1 mul
    tmp1_0 = tmp1_4 * tmp1_0;
    // Op 163: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC164 + kG164) - kF164;
    tmp3_1 = ((((kA164 + kC164) - kE164) - kE164) - kD164);
    tmp3_2 = kB164 - kG164;
    // Op 165: dim1x1 mul
    gl64_t s0_165 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_165 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_165 * s1_165;
    // Op 166: dim1x1 mul
    gl64_t s0_166 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    gl64_t s1_166 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s0_166 * s1_166;
    // Op 167: dim1x1 add
    tmp1_5 = tmp1_0 + tmp1_1;
    // Op 168: dim1x1 mul
    gl64_t s0_168 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_168 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s0_168 * s1_168;
    // Op 169: dim1x1 add
    tmp1_0 = tmp1_5 + tmp1_0;
    // Op 170: dim1x1 add
    gl64_t s0_170 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_170 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_1 = s0_170 + s1_170;
    // Op 171: dim1x1 mul
    tmp1_2 = tmp1_0 * tmp1_1;
    // Op 172: dim1x1 mul
    gl64_t s0_172 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_172 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_172 * s1_172;
    // Op 173: dim1x1 mul
    gl64_t s0_173 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_173 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s0_173 * s1_173;
    // Op 174: dim1x1 add
    tmp1_1 = tmp1_0 + tmp1_1;
    // Op 175: dim1x1 add
    gl64_t s0_175 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_175 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_175 + s1_175;
    // Op 176: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 177: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 178: dim1x1 sub
    gl64_t s0_178 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp1_0 = s0_178 - tmp1_0;
    // Op 179: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 180: dim3x3 mul
    gl64_t s1_180_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_180_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_180_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA180 = (tmp3_0 + tmp3_1) * (s1_180_0 + s1_180_1);
    gl64_t kB180 = (tmp3_0 + tmp3_2) * (s1_180_0 + s1_180_2);
    gl64_t kC180 = (tmp3_1 + tmp3_2) * (s1_180_1 + s1_180_2);
    gl64_t kD180 = tmp3_0 * s1_180_0;
    gl64_t kE180 = tmp3_1 * s1_180_1;
    gl64_t kF180 = tmp3_2 * s1_180_2;
    gl64_t kG180 = kD180 - kE180;
    tmp3_0 = (kC180 + kG180) - kF180;
    tmp3_1 = ((((kA180 + kC180) - kE180) - kE180) - kD180);
    tmp3_2 = kB180 - kG180;
    // Op 181: dim1x1 add
    gl64_t s0_181 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_181 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_181 + s1_181;
    // Op 182: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 183: dim1x1 mul
    gl64_t s0_183 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_183 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_1 = s0_183 * s1_183;
    // Op 184: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 185: dim1x1 sub
    gl64_t s0_185 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp1_0 = s0_185 - tmp1_0;
    // Op 186: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC187 + kG187) - kF187;
    tmp3_1 = ((((kA187 + kC187) - kE187) - kE187) - kD187);
    tmp3_2 = kB187 - kG187;
    // Op 188: dim1x1 mul
    gl64_t s0_188 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_188 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_188 * s1_188;
    // Op 189: dim1x1 add
    gl64_t s0_189 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_2 = s0_189 + tmp1_0;
    // Op 190: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_3;
    // Op 191: dim1x1 mul
    gl64_t s0_191 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_3 = s0_191 * tmp1_1;
    // Op 192: dim1x1 sub
    gl64_t s0_192 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    tmp1_3 = s0_192 - tmp1_3;
    // Op 193: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_3; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 194: dim3x3 mul
    gl64_t s1_194_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_194_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_194_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA194 = (tmp3_0 + tmp3_1) * (s1_194_0 + s1_194_1);
    gl64_t kB194 = (tmp3_0 + tmp3_2) * (s1_194_0 + s1_194_2);
    gl64_t kC194 = (tmp3_1 + tmp3_2) * (s1_194_1 + s1_194_2);
    gl64_t kD194 = tmp3_0 * s1_194_0;
    gl64_t kE194 = tmp3_1 * s1_194_1;
    gl64_t kF194 = tmp3_2 * s1_194_2;
    gl64_t kG194 = kD194 - kE194;
    tmp3_12 = (kC194 + kG194) - kF194;
    tmp3_13 = ((((kA194 + kC194) - kE194) - kE194) - kD194);
    tmp3_14 = kB194 - kG194;
    // Op 195: dim3x1 mul
    gl64_t s0_195_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_195_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_195_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_195 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp3_0 = s0_195_0 * s1_195; tmp3_1 = s0_195_1 * s1_195; tmp3_2 = s0_195_2 * s1_195;
    // Op 196: dim3x1 add
    gl64_t s1_196 = *(gl64_t*)&expressions_params[9][5];
    tmp3_9 = tmp3_0 + s1_196; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 197: dim3x3 add
    gl64_t s1_197_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_197_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_197_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_197_0; tmp3_4 = tmp3_10 + s1_197_1; tmp3_5 = tmp3_11 + s1_197_2;
    // Op 198: dim3x1 mul
    gl64_t s0_198_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_198_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_198_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_198 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp3_0 = s0_198_0 * s1_198; tmp3_1 = s0_198_1 * s1_198; tmp3_2 = s0_198_2 * s1_198;
    // Op 199: dim3x1 add
    gl64_t s1_199 = *(gl64_t*)&expressions_params[9][5];
    tmp3_6 = tmp3_0 + s1_199; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 200: dim3x3 add
    gl64_t s1_200_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_200_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_200_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_200_0; tmp3_1 = tmp3_7 + s1_200_1; tmp3_2 = tmp3_8 + s1_200_2;
    // Op 201: dim3x3 mul
    gl64_t kA201 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB201 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC201 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD201 = tmp3_3 * tmp3_0;
    gl64_t kE201 = tmp3_4 * tmp3_1;
    gl64_t kF201 = tmp3_5 * tmp3_2;
    gl64_t kG201 = kD201 - kE201;
    tmp3_0 = (kC201 + kG201) - kF201;
    tmp3_1 = ((((kA201 + kC201) - kE201) - kE201) - kD201);
    tmp3_2 = kB201 - kG201;
    // Op 202: dim3x3 mul
    gl64_t s0_202_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_202_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_202_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA202 = (s0_202_0 + s0_202_1) * (tmp3_0 + tmp3_1);
    gl64_t kB202 = (s0_202_0 + s0_202_2) * (tmp3_0 + tmp3_2);
    gl64_t kC202 = (s0_202_1 + s0_202_2) * (tmp3_1 + tmp3_2);
    gl64_t kD202 = s0_202_0 * tmp3_0;
    gl64_t kE202 = s0_202_1 * tmp3_1;
    gl64_t kF202 = s0_202_2 * tmp3_2;
    gl64_t kG202 = kD202 - kE202;
    tmp3_0 = (kC202 + kG202) - kF202;
    tmp3_1 = ((((kA202 + kC202) - kE202) - kE202) - kD202);
    tmp3_2 = kB202 - kG202;
    // Op 203: dim1x1 sub_swap
    gl64_t s0_203 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_203 = *(gl64_t*)&expressions_params[9][4];
    tmp1_3 = s1_203 - s0_203;
    // Op 204: dim3x3 add
    gl64_t s1_204_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_204_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_204_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_204_0; tmp3_7 = tmp3_7 + s1_204_1; tmp3_8 = tmp3_8 + s1_204_2;
    // Op 205: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_3; tmp3_7 = tmp3_7 * tmp1_3; tmp3_8 = tmp3_8 * tmp1_3;
    // Op 206: dim1x1 sub_swap
    gl64_t s0_206 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_206 = *(gl64_t*)&expressions_params[9][4];
    tmp1_3 = s1_206 - s0_206;
    // Op 207: dim3x3 add
    gl64_t s1_207_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_207_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_207_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_207_0; tmp3_10 = tmp3_10 + s1_207_1; tmp3_11 = tmp3_11 + s1_207_2;
    // Op 208: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_3; tmp3_10 = tmp3_10 * tmp1_3; tmp3_11 = tmp3_11 * tmp1_3;
    // Op 209: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 210: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 211: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 212: dim3x3 mul
    gl64_t s1_212_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_212_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_212_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA212 = (tmp3_0 + tmp3_1) * (s1_212_0 + s1_212_1);
    gl64_t kB212 = (tmp3_0 + tmp3_2) * (s1_212_0 + s1_212_2);
    gl64_t kC212 = (tmp3_1 + tmp3_2) * (s1_212_1 + s1_212_2);
    gl64_t kD212 = tmp3_0 * s1_212_0;
    gl64_t kE212 = tmp3_1 * s1_212_1;
    gl64_t kF212 = tmp3_2 * s1_212_2;
    gl64_t kG212 = kD212 - kE212;
    tmp3_3 = (kC212 + kG212) - kF212;
    tmp3_4 = ((((kA212 + kC212) - kE212) - kE212) - kD212);
    tmp3_5 = kB212 - kG212;
    // Op 213: dim3x1 mul
    gl64_t s0_213_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_213_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_213_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_213 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp3_0 = s0_213_0 * s1_213; tmp3_1 = s0_213_1 * s1_213; tmp3_2 = s0_213_2 * s1_213;
    // Op 214: dim3x1 add
    gl64_t s1_214 = *(gl64_t*)&expressions_params[9][6];
    tmp3_9 = tmp3_0 + s1_214; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 215: dim3x3 add
    gl64_t s1_215_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_215_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_215_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_215_0; tmp3_13 = tmp3_10 + s1_215_1; tmp3_14 = tmp3_11 + s1_215_2;
    // Op 216: dim3x1 mul
    gl64_t s0_216_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_216_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_216_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_216 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp3_0 = s0_216_0 * s1_216; tmp3_1 = s0_216_1 * s1_216; tmp3_2 = s0_216_2 * s1_216;
    // Op 217: dim3x1 add
    gl64_t s1_217 = *(gl64_t*)&expressions_params[9][6];
    tmp3_6 = tmp3_0 + s1_217; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 218: dim3x3 add
    gl64_t s1_218_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_218_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_218_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_218_0; tmp3_1 = tmp3_7 + s1_218_1; tmp3_2 = tmp3_8 + s1_218_2;
    // Op 219: dim3x3 mul
    gl64_t kA219 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB219 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC219 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD219 = tmp3_12 * tmp3_0;
    gl64_t kE219 = tmp3_13 * tmp3_1;
    gl64_t kF219 = tmp3_14 * tmp3_2;
    gl64_t kG219 = kD219 - kE219;
    tmp3_0 = (kC219 + kG219) - kF219;
    tmp3_1 = ((((kA219 + kC219) - kE219) - kE219) - kD219);
    tmp3_2 = kB219 - kG219;
    // Op 220: dim3x3 mul
    gl64_t s0_220_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_220_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_220_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA220 = (s0_220_0 + s0_220_1) * (tmp3_0 + tmp3_1);
    gl64_t kB220 = (s0_220_0 + s0_220_2) * (tmp3_0 + tmp3_2);
    gl64_t kC220 = (s0_220_1 + s0_220_2) * (tmp3_1 + tmp3_2);
    gl64_t kD220 = s0_220_0 * tmp3_0;
    gl64_t kE220 = s0_220_1 * tmp3_1;
    gl64_t kF220 = s0_220_2 * tmp3_2;
    gl64_t kG220 = kD220 - kE220;
    tmp3_0 = (kC220 + kG220) - kF220;
    tmp3_1 = ((((kA220 + kC220) - kE220) - kE220) - kD220);
    tmp3_2 = kB220 - kG220;
    // Op 221: dim1x1 sub_swap
    gl64_t s1_221 = *(gl64_t*)&expressions_params[9][4];
    tmp1_3 = s1_221 - tmp1_7;
    // Op 222: dim3x3 add
    gl64_t s1_222_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_222_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_222_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_222_0; tmp3_7 = tmp3_7 + s1_222_1; tmp3_8 = tmp3_8 + s1_222_2;
    // Op 223: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_3; tmp3_7 = tmp3_7 * tmp1_3; tmp3_8 = tmp3_8 * tmp1_3;
    // Op 224: dim1x1 sub_swap
    gl64_t s1_224 = *(gl64_t*)&expressions_params[9][4];
    tmp1_3 = s1_224 - tmp1_7;
    // Op 225: dim3x3 add
    gl64_t s1_225_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_225_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_225_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_225_0; tmp3_10 = tmp3_10 + s1_225_1; tmp3_11 = tmp3_11 + s1_225_2;
    // Op 226: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_3; tmp3_10 = tmp3_10 * tmp1_3; tmp3_11 = tmp3_11 * tmp1_3;
    // Op 227: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 228: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 229: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 230: dim3x3 mul
    gl64_t s1_230_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_230_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_230_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA230 = (tmp3_0 + tmp3_1) * (s1_230_0 + s1_230_1);
    gl64_t kB230 = (tmp3_0 + tmp3_2) * (s1_230_0 + s1_230_2);
    gl64_t kC230 = (tmp3_1 + tmp3_2) * (s1_230_1 + s1_230_2);
    gl64_t kD230 = tmp3_0 * s1_230_0;
    gl64_t kE230 = tmp3_1 * s1_230_1;
    gl64_t kF230 = tmp3_2 * s1_230_2;
    gl64_t kG230 = kD230 - kE230;
    tmp3_12 = (kC230 + kG230) - kF230;
    tmp3_13 = ((((kA230 + kC230) - kE230) - kE230) - kD230);
    tmp3_14 = kB230 - kG230;
    // Op 231: dim3x1 mul
    gl64_t s0_231_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_231_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_231_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_231 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp3_0 = s0_231_0 * s1_231; tmp3_1 = s0_231_1 * s1_231; tmp3_2 = s0_231_2 * s1_231;
    // Op 232: dim3x1 add
    gl64_t s1_232 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_232; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 233: dim3x3 mul
    gl64_t s1_233_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_233_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_233_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA233 = (tmp3_0 + tmp3_1) * (s1_233_0 + s1_233_1);
    gl64_t kB233 = (tmp3_0 + tmp3_2) * (s1_233_0 + s1_233_2);
    gl64_t kC233 = (tmp3_1 + tmp3_2) * (s1_233_1 + s1_233_2);
    gl64_t kD233 = tmp3_0 * s1_233_0;
    gl64_t kE233 = tmp3_1 * s1_233_1;
    gl64_t kF233 = tmp3_2 * s1_233_2;
    gl64_t kG233 = kD233 - kE233;
    tmp3_0 = (kC233 + kG233) - kF233;
    tmp3_1 = ((((kA233 + kC233) - kE233) - kE233) - kD233);
    tmp3_2 = kB233 - kG233;
    // Op 234: dim3x1 add
    gl64_t s1_234 = *(gl64_t*)&expressions_params[9][13];
    tmp3_9 = tmp3_0 + s1_234; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 235: dim3x3 add
    gl64_t s1_235_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_235_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_235_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_235_0; tmp3_4 = tmp3_10 + s1_235_1; tmp3_5 = tmp3_11 + s1_235_2;
    // Op 236: dim3x1 mul
    gl64_t s0_236_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_236_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_236_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_236 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp3_0 = s0_236_0 * s1_236; tmp3_1 = s0_236_1 * s1_236; tmp3_2 = s0_236_2 * s1_236;
    // Op 237: dim3x1 add
    gl64_t s1_237 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_237; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 238: dim3x3 mul
    gl64_t s1_238_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_238_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_238_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA238 = (tmp3_0 + tmp3_1) * (s1_238_0 + s1_238_1);
    gl64_t kB238 = (tmp3_0 + tmp3_2) * (s1_238_0 + s1_238_2);
    gl64_t kC238 = (tmp3_1 + tmp3_2) * (s1_238_1 + s1_238_2);
    gl64_t kD238 = tmp3_0 * s1_238_0;
    gl64_t kE238 = tmp3_1 * s1_238_1;
    gl64_t kF238 = tmp3_2 * s1_238_2;
    gl64_t kG238 = kD238 - kE238;
    tmp3_0 = (kC238 + kG238) - kF238;
    tmp3_1 = ((((kA238 + kC238) - kE238) - kE238) - kD238);
    tmp3_2 = kB238 - kG238;
    // Op 239: dim3x1 add
    gl64_t s1_239 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_239; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 240: dim3x3 mul
    gl64_t s1_240_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_240_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_240_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA240 = (tmp3_0 + tmp3_1) * (s1_240_0 + s1_240_1);
    gl64_t kB240 = (tmp3_0 + tmp3_2) * (s1_240_0 + s1_240_2);
    gl64_t kC240 = (tmp3_1 + tmp3_2) * (s1_240_1 + s1_240_2);
    gl64_t kD240 = tmp3_0 * s1_240_0;
    gl64_t kE240 = tmp3_1 * s1_240_1;
    gl64_t kF240 = tmp3_2 * s1_240_2;
    gl64_t kG240 = kD240 - kE240;
    tmp3_0 = (kC240 + kG240) - kF240;
    tmp3_1 = ((((kA240 + kC240) - kE240) - kE240) - kD240);
    tmp3_2 = kB240 - kG240;
    // Op 241: dim1x1 mul
    gl64_t s0_241 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    gl64_t s1_241 = *(gl64_t*)&expressions_params[9][7];
    tmp1_3 = s0_241 * s1_241;
    // Op 242: dim1x1 add
    gl64_t s0_242 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_3 = s0_242 + tmp1_3;
    // Op 243: dim1x1 mul
    gl64_t s0_243 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_243 = *(gl64_t*)&expressions_params[9][8];
    tmp1_0 = s0_243 * s1_243;
    // Op 244: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_0;
    // Op 245: dim1x1 mul
    gl64_t s0_245 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_245 = *(gl64_t*)&expressions_params[9][1];
    tmp1_3 = s0_245 * s1_245;
    // Op 246: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 247: dim1x1 mul
    gl64_t s0_247 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_247 = *(gl64_t*)&expressions_params[9][9];
    tmp1_3 = s0_247 * s1_247;
    // Op 248: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 249: dim1x1 mul
    gl64_t s1_249 = *(gl64_t*)&expressions_params[9][10];
    tmp1_4 = tmp1_4 * s1_249;
    // Op 250: dim1x1 add
    tmp1_4 = tmp1_0 + tmp1_4;
    // Op 251: dim1x1 add
    gl64_t s0_251 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_251 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_251 + s1_251;
    // Op 252: dim1x1 mul
    gl64_t s1_252 = *(gl64_t*)&expressions_params[9][11];
    tmp1_0 = tmp1_0 * s1_252;
    // Op 253: dim1x1 add
    tmp1_0 = tmp1_4 + tmp1_0;
    // Op 254: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 255: dim3x3 mul
    gl64_t s1_255_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_255_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_255_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA255 = (tmp3_0 + tmp3_1) * (s1_255_0 + s1_255_1);
    gl64_t kB255 = (tmp3_0 + tmp3_2) * (s1_255_0 + s1_255_2);
    gl64_t kC255 = (tmp3_1 + tmp3_2) * (s1_255_1 + s1_255_2);
    gl64_t kD255 = tmp3_0 * s1_255_0;
    gl64_t kE255 = tmp3_1 * s1_255_1;
    gl64_t kF255 = tmp3_2 * s1_255_2;
    gl64_t kG255 = kD255 - kE255;
    tmp3_0 = (kC255 + kG255) - kF255;
    tmp3_1 = ((((kA255 + kC255) - kE255) - kE255) - kD255);
    tmp3_2 = kB255 - kG255;
    // Op 256: dim3x1 add
    gl64_t s1_256 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_256; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 257: dim3x3 mul
    gl64_t s1_257_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_257_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_257_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA257 = (tmp3_0 + tmp3_1) * (s1_257_0 + s1_257_1);
    gl64_t kB257 = (tmp3_0 + tmp3_2) * (s1_257_0 + s1_257_2);
    gl64_t kC257 = (tmp3_1 + tmp3_2) * (s1_257_1 + s1_257_2);
    gl64_t kD257 = tmp3_0 * s1_257_0;
    gl64_t kE257 = tmp3_1 * s1_257_1;
    gl64_t kF257 = tmp3_2 * s1_257_2;
    gl64_t kG257 = kD257 - kE257;
    tmp3_0 = (kC257 + kG257) - kF257;
    tmp3_1 = ((((kA257 + kC257) - kE257) - kE257) - kD257);
    tmp3_2 = kB257 - kG257;
    // Op 258: dim3x1 add
    gl64_t s1_258 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_258; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 259: dim3x3 mul
    gl64_t s1_259_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_259_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_259_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA259 = (tmp3_0 + tmp3_1) * (s1_259_0 + s1_259_1);
    gl64_t kB259 = (tmp3_0 + tmp3_2) * (s1_259_0 + s1_259_2);
    gl64_t kC259 = (tmp3_1 + tmp3_2) * (s1_259_1 + s1_259_2);
    gl64_t kD259 = tmp3_0 * s1_259_0;
    gl64_t kE259 = tmp3_1 * s1_259_1;
    gl64_t kF259 = tmp3_2 * s1_259_2;
    gl64_t kG259 = kD259 - kE259;
    tmp3_0 = (kC259 + kG259) - kF259;
    tmp3_1 = ((((kA259 + kC259) - kE259) - kE259) - kD259);
    tmp3_2 = kB259 - kG259;
    // Op 260: dim3x1 add
    gl64_t s1_260 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_260; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 261: dim3x3 mul
    gl64_t s1_261_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_261_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_261_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA261 = (tmp3_0 + tmp3_1) * (s1_261_0 + s1_261_1);
    gl64_t kB261 = (tmp3_0 + tmp3_2) * (s1_261_0 + s1_261_2);
    gl64_t kC261 = (tmp3_1 + tmp3_2) * (s1_261_1 + s1_261_2);
    gl64_t kD261 = tmp3_0 * s1_261_0;
    gl64_t kE261 = tmp3_1 * s1_261_1;
    gl64_t kF261 = tmp3_2 * s1_261_2;
    gl64_t kG261 = kD261 - kE261;
    tmp3_0 = (kC261 + kG261) - kF261;
    tmp3_1 = ((((kA261 + kC261) - kE261) - kE261) - kD261);
    tmp3_2 = kB261 - kG261;
    // Op 262: dim3x1 add
    gl64_t s1_262 = *(gl64_t*)&expressions_params[9][12];
    tmp3_6 = tmp3_0 + s1_262; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 263: dim3x3 add
    gl64_t s1_263_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_263_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_263_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_263_0; tmp3_1 = tmp3_7 + s1_263_1; tmp3_2 = tmp3_8 + s1_263_2;
    // Op 264: dim3x3 mul
    gl64_t kA264 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB264 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC264 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD264 = tmp3_3 * tmp3_0;
    gl64_t kE264 = tmp3_4 * tmp3_1;
    gl64_t kF264 = tmp3_5 * tmp3_2;
    gl64_t kG264 = kD264 - kE264;
    tmp3_0 = (kC264 + kG264) - kF264;
    tmp3_1 = ((((kA264 + kC264) - kE264) - kE264) - kD264);
    tmp3_2 = kB264 - kG264;
    // Op 265: dim3x3 mul
    uint64_t s0_265_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_265_0 = *(gl64_t*)&dParams->aux_trace[s0_265_pos];
    gl64_t s0_265_1 = *(gl64_t*)&dParams->aux_trace[s0_265_pos + TILE_HEIGHT];
    gl64_t s0_265_2 = *(gl64_t*)&dParams->aux_trace[s0_265_pos + 2*TILE_HEIGHT];
    gl64_t kA265 = (s0_265_0 + s0_265_1) * (tmp3_0 + tmp3_1);
    gl64_t kB265 = (s0_265_0 + s0_265_2) * (tmp3_0 + tmp3_2);
    gl64_t kC265 = (s0_265_1 + s0_265_2) * (tmp3_1 + tmp3_2);
    gl64_t kD265 = s0_265_0 * tmp3_0;
    gl64_t kE265 = s0_265_1 * tmp3_1;
    gl64_t kF265 = s0_265_2 * tmp3_2;
    gl64_t kG265 = kD265 - kE265;
    tmp3_0 = (kC265 + kG265) - kF265;
    tmp3_1 = ((((kA265 + kC265) - kE265) - kE265) - kD265);
    tmp3_2 = kB265 - kG265;
    // Op 266: dim1x1 sub_swap
    gl64_t s1_266 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s1_266 - tmp1_7;
    // Op 267: dim3x3 add
    gl64_t s1_267_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_267_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_267_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_267_0; tmp3_7 = tmp3_7 + s1_267_1; tmp3_8 = tmp3_8 + s1_267_2;
    // Op 268: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 269: dim1x1 sub_swap
    gl64_t s1_269 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s1_269 - tmp1_7;
    // Op 270: dim3x3 add
    gl64_t s1_270_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_270_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_270_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_270_0; tmp3_10 = tmp3_10 + s1_270_1; tmp3_11 = tmp3_11 + s1_270_2;
    // Op 271: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 272: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 273: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 274: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 275: dim3x3 mul
    gl64_t s1_275_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_275_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_275_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA275 = (tmp3_0 + tmp3_1) * (s1_275_0 + s1_275_1);
    gl64_t kB275 = (tmp3_0 + tmp3_2) * (s1_275_0 + s1_275_2);
    gl64_t kC275 = (tmp3_1 + tmp3_2) * (s1_275_1 + s1_275_2);
    gl64_t kD275 = tmp3_0 * s1_275_0;
    gl64_t kE275 = tmp3_1 * s1_275_1;
    gl64_t kF275 = tmp3_2 * s1_275_2;
    gl64_t kG275 = kD275 - kE275;
    tmp3_3 = (kC275 + kG275) - kF275;
    tmp3_4 = ((((kA275 + kC275) - kE275) - kE275) - kD275);
    tmp3_5 = kB275 - kG275;
    // Op 276: dim3x1 mul
    gl64_t s0_276_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_276_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_276_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_276 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp3_0 = s0_276_0 * s1_276; tmp3_1 = s0_276_1 * s1_276; tmp3_2 = s0_276_2 * s1_276;
    // Op 277: dim3x1 add
    gl64_t s1_277 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_277; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 278: dim3x3 mul
    gl64_t s1_278_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_278_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_278_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA278 = (tmp3_0 + tmp3_1) * (s1_278_0 + s1_278_1);
    gl64_t kB278 = (tmp3_0 + tmp3_2) * (s1_278_0 + s1_278_2);
    gl64_t kC278 = (tmp3_1 + tmp3_2) * (s1_278_1 + s1_278_2);
    gl64_t kD278 = tmp3_0 * s1_278_0;
    gl64_t kE278 = tmp3_1 * s1_278_1;
    gl64_t kF278 = tmp3_2 * s1_278_2;
    gl64_t kG278 = kD278 - kE278;
    tmp3_0 = (kC278 + kG278) - kF278;
    tmp3_1 = ((((kA278 + kC278) - kE278) - kE278) - kD278);
    tmp3_2 = kB278 - kG278;
    // Op 279: dim3x1 add
    gl64_t s1_279 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_279; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 280: dim3x3 mul
    gl64_t s1_280_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_280_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_280_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA280 = (tmp3_0 + tmp3_1) * (s1_280_0 + s1_280_1);
    gl64_t kB280 = (tmp3_0 + tmp3_2) * (s1_280_0 + s1_280_2);
    gl64_t kC280 = (tmp3_1 + tmp3_2) * (s1_280_1 + s1_280_2);
    gl64_t kD280 = tmp3_0 * s1_280_0;
    gl64_t kE280 = tmp3_1 * s1_280_1;
    gl64_t kF280 = tmp3_2 * s1_280_2;
    gl64_t kG280 = kD280 - kE280;
    tmp3_0 = (kC280 + kG280) - kF280;
    tmp3_1 = ((((kA280 + kC280) - kE280) - kE280) - kD280);
    tmp3_2 = kB280 - kG280;
    // Op 281: dim3x3 mul
    gl64_t s1_281_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_281_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_281_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA281 = (tmp3_0 + tmp3_1) * (s1_281_0 + s1_281_1);
    gl64_t kB281 = (tmp3_0 + tmp3_2) * (s1_281_0 + s1_281_2);
    gl64_t kC281 = (tmp3_1 + tmp3_2) * (s1_281_1 + s1_281_2);
    gl64_t kD281 = tmp3_0 * s1_281_0;
    gl64_t kE281 = tmp3_1 * s1_281_1;
    gl64_t kF281 = tmp3_2 * s1_281_2;
    gl64_t kG281 = kD281 - kE281;
    tmp3_0 = (kC281 + kG281) - kF281;
    tmp3_1 = ((((kA281 + kC281) - kE281) - kE281) - kD281);
    tmp3_2 = kB281 - kG281;
    // Op 282: dim3x3 mul
    gl64_t s1_282_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_282_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_282_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA282 = (tmp3_0 + tmp3_1) * (s1_282_0 + s1_282_1);
    gl64_t kB282 = (tmp3_0 + tmp3_2) * (s1_282_0 + s1_282_2);
    gl64_t kC282 = (tmp3_1 + tmp3_2) * (s1_282_1 + s1_282_2);
    gl64_t kD282 = tmp3_0 * s1_282_0;
    gl64_t kE282 = tmp3_1 * s1_282_1;
    gl64_t kF282 = tmp3_2 * s1_282_2;
    gl64_t kG282 = kD282 - kE282;
    tmp3_0 = (kC282 + kG282) - kF282;
    tmp3_1 = ((((kA282 + kC282) - kE282) - kE282) - kD282);
    tmp3_2 = kB282 - kG282;
    // Op 283: dim1x1 mul
    gl64_t s0_283 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_283 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_283 * s1_283;
    // Op 284: dim1x1 mul
    gl64_t s0_284 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_284 = *(gl64_t*)&expressions_params[9][1];
    tmp1_4 = s0_284 * s1_284;
    // Op 285: dim1x1 add
    tmp1_3 = tmp1_0 + tmp1_4;
    // Op 286: dim1x1 mul
    gl64_t s0_286 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_286 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s0_286 * s1_286;
    // Op 287: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_0;
    // Op 288: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 289: dim3x3 mul
    gl64_t s1_289_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_289_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_289_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA289 = (tmp3_0 + tmp3_1) * (s1_289_0 + s1_289_1);
    gl64_t kB289 = (tmp3_0 + tmp3_2) * (s1_289_0 + s1_289_2);
    gl64_t kC289 = (tmp3_1 + tmp3_2) * (s1_289_1 + s1_289_2);
    gl64_t kD289 = tmp3_0 * s1_289_0;
    gl64_t kE289 = tmp3_1 * s1_289_1;
    gl64_t kF289 = tmp3_2 * s1_289_2;
    gl64_t kG289 = kD289 - kE289;
    tmp3_0 = (kC289 + kG289) - kF289;
    tmp3_1 = ((((kA289 + kC289) - kE289) - kE289) - kD289);
    tmp3_2 = kB289 - kG289;
    // Op 290: dim3x3 mul
    gl64_t s1_290_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_290_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_290_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA290 = (tmp3_0 + tmp3_1) * (s1_290_0 + s1_290_1);
    gl64_t kB290 = (tmp3_0 + tmp3_2) * (s1_290_0 + s1_290_2);
    gl64_t kC290 = (tmp3_1 + tmp3_2) * (s1_290_1 + s1_290_2);
    gl64_t kD290 = tmp3_0 * s1_290_0;
    gl64_t kE290 = tmp3_1 * s1_290_1;
    gl64_t kF290 = tmp3_2 * s1_290_2;
    gl64_t kG290 = kD290 - kE290;
    tmp3_0 = (kC290 + kG290) - kF290;
    tmp3_1 = ((((kA290 + kC290) - kE290) - kE290) - kD290);
    tmp3_2 = kB290 - kG290;
    // Op 291: dim3x1 add
    gl64_t s1_291 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_291; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 292: dim3x3 mul
    gl64_t s1_292_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_292_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_292_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA292 = (tmp3_0 + tmp3_1) * (s1_292_0 + s1_292_1);
    gl64_t kB292 = (tmp3_0 + tmp3_2) * (s1_292_0 + s1_292_2);
    gl64_t kC292 = (tmp3_1 + tmp3_2) * (s1_292_1 + s1_292_2);
    gl64_t kD292 = tmp3_0 * s1_292_0;
    gl64_t kE292 = tmp3_1 * s1_292_1;
    gl64_t kF292 = tmp3_2 * s1_292_2;
    gl64_t kG292 = kD292 - kE292;
    tmp3_0 = (kC292 + kG292) - kF292;
    tmp3_1 = ((((kA292 + kC292) - kE292) - kE292) - kD292);
    tmp3_2 = kB292 - kG292;
    // Op 293: dim3x3 mul
    gl64_t s1_293_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_293_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_293_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA293 = (tmp3_0 + tmp3_1) * (s1_293_0 + s1_293_1);
    gl64_t kB293 = (tmp3_0 + tmp3_2) * (s1_293_0 + s1_293_2);
    gl64_t kC293 = (tmp3_1 + tmp3_2) * (s1_293_1 + s1_293_2);
    gl64_t kD293 = tmp3_0 * s1_293_0;
    gl64_t kE293 = tmp3_1 * s1_293_1;
    gl64_t kF293 = tmp3_2 * s1_293_2;
    gl64_t kG293 = kD293 - kE293;
    tmp3_0 = (kC293 + kG293) - kF293;
    tmp3_1 = ((((kA293 + kC293) - kE293) - kE293) - kD293);
    tmp3_2 = kB293 - kG293;
    // Op 294: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 295: dim3x3 mul
    gl64_t s1_295_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_295_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_295_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA295 = (tmp3_0 + tmp3_1) * (s1_295_0 + s1_295_1);
    gl64_t kB295 = (tmp3_0 + tmp3_2) * (s1_295_0 + s1_295_2);
    gl64_t kC295 = (tmp3_1 + tmp3_2) * (s1_295_1 + s1_295_2);
    gl64_t kD295 = tmp3_0 * s1_295_0;
    gl64_t kE295 = tmp3_1 * s1_295_1;
    gl64_t kF295 = tmp3_2 * s1_295_2;
    gl64_t kG295 = kD295 - kE295;
    tmp3_0 = (kC295 + kG295) - kF295;
    tmp3_1 = ((((kA295 + kC295) - kE295) - kE295) - kD295);
    tmp3_2 = kB295 - kG295;
    // Op 296: dim1x1 mul
    gl64_t s0_296 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_296 = *(gl64_t*)&expressions_params[9][16];
    tmp1_0 = s0_296 * s1_296;
    // Op 297: dim1x1 mul
    gl64_t s0_297 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_297 = *(gl64_t*)&expressions_params[9][17];
    tmp1_4 = s0_297 * s1_297;
    // Op 298: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 299: dim1x1 mul
    gl64_t s0_299 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_299 = *(gl64_t*)&expressions_params[9][18];
    tmp1_4 = s0_299 * s1_299;
    // Op 300: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 301: dim1x1 mul
    gl64_t s0_301 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_301 = *(gl64_t*)&expressions_params[9][19];
    tmp1_4 = s0_301 * s1_301;
    // Op 302: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 303: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 304: dim3x3 mul
    gl64_t s1_304_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_304_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_304_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA304 = (tmp3_0 + tmp3_1) * (s1_304_0 + s1_304_1);
    gl64_t kB304 = (tmp3_0 + tmp3_2) * (s1_304_0 + s1_304_2);
    gl64_t kC304 = (tmp3_1 + tmp3_2) * (s1_304_1 + s1_304_2);
    gl64_t kD304 = tmp3_0 * s1_304_0;
    gl64_t kE304 = tmp3_1 * s1_304_1;
    gl64_t kF304 = tmp3_2 * s1_304_2;
    gl64_t kG304 = kD304 - kE304;
    tmp3_0 = (kC304 + kG304) - kF304;
    tmp3_1 = ((((kA304 + kC304) - kE304) - kE304) - kD304);
    tmp3_2 = kB304 - kG304;
    // Op 305: dim3x1 add
    gl64_t s1_305 = *(gl64_t*)&expressions_params[9][20];
    tmp3_9 = tmp3_0 + s1_305; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 306: dim3x3 add
    gl64_t s1_306_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_306_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_306_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_306_0; tmp3_13 = tmp3_10 + s1_306_1; tmp3_14 = tmp3_11 + s1_306_2;
    // Op 307: dim3x1 mul
    gl64_t s0_307_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_307_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_307_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_307 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp3_0 = s0_307_0 * s1_307; tmp3_1 = s0_307_1 * s1_307; tmp3_2 = s0_307_2 * s1_307;
    // Op 308: dim3x1 add
    gl64_t s1_308 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_308; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 309: dim3x3 mul
    gl64_t s1_309_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_309_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_309_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA309 = (tmp3_0 + tmp3_1) * (s1_309_0 + s1_309_1);
    gl64_t kB309 = (tmp3_0 + tmp3_2) * (s1_309_0 + s1_309_2);
    gl64_t kC309 = (tmp3_1 + tmp3_2) * (s1_309_1 + s1_309_2);
    gl64_t kD309 = tmp3_0 * s1_309_0;
    gl64_t kE309 = tmp3_1 * s1_309_1;
    gl64_t kF309 = tmp3_2 * s1_309_2;
    gl64_t kG309 = kD309 - kE309;
    tmp3_0 = (kC309 + kG309) - kF309;
    tmp3_1 = ((((kA309 + kC309) - kE309) - kE309) - kD309);
    tmp3_2 = kB309 - kG309;
    // Op 310: dim3x1 add
    gl64_t s1_310 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_310; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 311: dim3x3 mul
    gl64_t s1_311_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_311_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_311_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA311 = (tmp3_0 + tmp3_1) * (s1_311_0 + s1_311_1);
    gl64_t kB311 = (tmp3_0 + tmp3_2) * (s1_311_0 + s1_311_2);
    gl64_t kC311 = (tmp3_1 + tmp3_2) * (s1_311_1 + s1_311_2);
    gl64_t kD311 = tmp3_0 * s1_311_0;
    gl64_t kE311 = tmp3_1 * s1_311_1;
    gl64_t kF311 = tmp3_2 * s1_311_2;
    gl64_t kG311 = kD311 - kE311;
    tmp3_0 = (kC311 + kG311) - kF311;
    tmp3_1 = ((((kA311 + kC311) - kE311) - kE311) - kD311);
    tmp3_2 = kB311 - kG311;
    // Op 312: dim3x1 add
    gl64_t s1_312 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_312; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 313: dim3x3 mul
    gl64_t s1_313_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_313_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_313_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA313 = (tmp3_0 + tmp3_1) * (s1_313_0 + s1_313_1);
    gl64_t kB313 = (tmp3_0 + tmp3_2) * (s1_313_0 + s1_313_2);
    gl64_t kC313 = (tmp3_1 + tmp3_2) * (s1_313_1 + s1_313_2);
    gl64_t kD313 = tmp3_0 * s1_313_0;
    gl64_t kE313 = tmp3_1 * s1_313_1;
    gl64_t kF313 = tmp3_2 * s1_313_2;
    gl64_t kG313 = kD313 - kE313;
    tmp3_0 = (kC313 + kG313) - kF313;
    tmp3_1 = ((((kA313 + kC313) - kE313) - kE313) - kD313);
    tmp3_2 = kB313 - kG313;
    // Op 314: dim3x1 add
    gl64_t s1_314 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_314; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 315: dim3x3 mul
    gl64_t s1_315_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_315_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_315_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA315 = (tmp3_0 + tmp3_1) * (s1_315_0 + s1_315_1);
    gl64_t kB315 = (tmp3_0 + tmp3_2) * (s1_315_0 + s1_315_2);
    gl64_t kC315 = (tmp3_1 + tmp3_2) * (s1_315_1 + s1_315_2);
    gl64_t kD315 = tmp3_0 * s1_315_0;
    gl64_t kE315 = tmp3_1 * s1_315_1;
    gl64_t kF315 = tmp3_2 * s1_315_2;
    gl64_t kG315 = kD315 - kE315;
    tmp3_0 = (kC315 + kG315) - kF315;
    tmp3_1 = ((((kA315 + kC315) - kE315) - kE315) - kD315);
    tmp3_2 = kB315 - kG315;
    // Op 316: dim3x1 add
    gl64_t s1_316 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_316; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 317: dim3x3 mul
    gl64_t s1_317_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_317_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_317_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA317 = (tmp3_0 + tmp3_1) * (s1_317_0 + s1_317_1);
    gl64_t kB317 = (tmp3_0 + tmp3_2) * (s1_317_0 + s1_317_2);
    gl64_t kC317 = (tmp3_1 + tmp3_2) * (s1_317_1 + s1_317_2);
    gl64_t kD317 = tmp3_0 * s1_317_0;
    gl64_t kE317 = tmp3_1 * s1_317_1;
    gl64_t kF317 = tmp3_2 * s1_317_2;
    gl64_t kG317 = kD317 - kE317;
    tmp3_0 = (kC317 + kG317) - kF317;
    tmp3_1 = ((((kA317 + kC317) - kE317) - kE317) - kD317);
    tmp3_2 = kB317 - kG317;
    // Op 318: dim3x1 add
    gl64_t s1_318 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_318; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 319: dim3x3 mul
    gl64_t s1_319_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_319_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_319_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA319 = (tmp3_0 + tmp3_1) * (s1_319_0 + s1_319_1);
    gl64_t kB319 = (tmp3_0 + tmp3_2) * (s1_319_0 + s1_319_2);
    gl64_t kC319 = (tmp3_1 + tmp3_2) * (s1_319_1 + s1_319_2);
    gl64_t kD319 = tmp3_0 * s1_319_0;
    gl64_t kE319 = tmp3_1 * s1_319_1;
    gl64_t kF319 = tmp3_2 * s1_319_2;
    gl64_t kG319 = kD319 - kE319;
    tmp3_0 = (kC319 + kG319) - kF319;
    tmp3_1 = ((((kA319 + kC319) - kE319) - kE319) - kD319);
    tmp3_2 = kB319 - kG319;
    // Op 320: dim3x1 add
    gl64_t s1_320 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_320; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 321: dim3x3 mul
    gl64_t s1_321_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_321_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_321_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA321 = (tmp3_0 + tmp3_1) * (s1_321_0 + s1_321_1);
    gl64_t kB321 = (tmp3_0 + tmp3_2) * (s1_321_0 + s1_321_2);
    gl64_t kC321 = (tmp3_1 + tmp3_2) * (s1_321_1 + s1_321_2);
    gl64_t kD321 = tmp3_0 * s1_321_0;
    gl64_t kE321 = tmp3_1 * s1_321_1;
    gl64_t kF321 = tmp3_2 * s1_321_2;
    gl64_t kG321 = kD321 - kE321;
    tmp3_0 = (kC321 + kG321) - kF321;
    tmp3_1 = ((((kA321 + kC321) - kE321) - kE321) - kD321);
    tmp3_2 = kB321 - kG321;
    // Op 322: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_5; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 323: dim3x3 mul
    gl64_t s1_323_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_323_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_323_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA323 = (tmp3_0 + tmp3_1) * (s1_323_0 + s1_323_1);
    gl64_t kB323 = (tmp3_0 + tmp3_2) * (s1_323_0 + s1_323_2);
    gl64_t kC323 = (tmp3_1 + tmp3_2) * (s1_323_1 + s1_323_2);
    gl64_t kD323 = tmp3_0 * s1_323_0;
    gl64_t kE323 = tmp3_1 * s1_323_1;
    gl64_t kF323 = tmp3_2 * s1_323_2;
    gl64_t kG323 = kD323 - kE323;
    tmp3_0 = (kC323 + kG323) - kF323;
    tmp3_1 = ((((kA323 + kC323) - kE323) - kE323) - kD323);
    tmp3_2 = kB323 - kG323;
    // Op 324: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_3; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 325: dim3x3 mul
    gl64_t s1_325_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_325_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_325_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA325 = (tmp3_0 + tmp3_1) * (s1_325_0 + s1_325_1);
    gl64_t kB325 = (tmp3_0 + tmp3_2) * (s1_325_0 + s1_325_2);
    gl64_t kC325 = (tmp3_1 + tmp3_2) * (s1_325_1 + s1_325_2);
    gl64_t kD325 = tmp3_0 * s1_325_0;
    gl64_t kE325 = tmp3_1 * s1_325_1;
    gl64_t kF325 = tmp3_2 * s1_325_2;
    gl64_t kG325 = kD325 - kE325;
    tmp3_0 = (kC325 + kG325) - kF325;
    tmp3_1 = ((((kA325 + kC325) - kE325) - kE325) - kD325);
    tmp3_2 = kB325 - kG325;
    // Op 326: dim1x1 mul
    gl64_t s0_326 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_326 = *(gl64_t*)&expressions_params[9][8];
    tmp1_0 = s0_326 * s1_326;
    // Op 327: dim1x1 add
    gl64_t s0_327 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_327 + tmp1_0;
    // Op 328: dim1x1 mul
    gl64_t s0_328 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_328 = *(gl64_t*)&expressions_params[9][14];
    tmp1_4 = s0_328 * s1_328;
    // Op 329: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 330: dim1x1 mul
    gl64_t s0_330 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_330 = *(gl64_t*)&expressions_params[9][7];
    tmp1_4 = s0_330 * s1_330;
    // Op 331: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 332: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 333: dim3x3 mul
    gl64_t s1_333_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_333_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_333_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA333 = (tmp3_0 + tmp3_1) * (s1_333_0 + s1_333_1);
    gl64_t kB333 = (tmp3_0 + tmp3_2) * (s1_333_0 + s1_333_2);
    gl64_t kC333 = (tmp3_1 + tmp3_2) * (s1_333_1 + s1_333_2);
    gl64_t kD333 = tmp3_0 * s1_333_0;
    gl64_t kE333 = tmp3_1 * s1_333_1;
    gl64_t kF333 = tmp3_2 * s1_333_2;
    gl64_t kG333 = kD333 - kE333;
    tmp3_0 = (kC333 + kG333) - kF333;
    tmp3_1 = ((((kA333 + kC333) - kE333) - kE333) - kD333);
    tmp3_2 = kB333 - kG333;
    // Op 334: dim3x1 add
    gl64_t s1_334 = *(gl64_t*)&expressions_params[9][15];
    tmp3_6 = tmp3_0 + s1_334; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 335: dim3x3 add
    gl64_t s1_335_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_335_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_335_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_335_0; tmp3_1 = tmp3_7 + s1_335_1; tmp3_2 = tmp3_8 + s1_335_2;
    // Op 336: dim3x3 mul
    gl64_t kA336 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB336 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC336 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD336 = tmp3_12 * tmp3_0;
    gl64_t kE336 = tmp3_13 * tmp3_1;
    gl64_t kF336 = tmp3_14 * tmp3_2;
    gl64_t kG336 = kD336 - kE336;
    tmp3_0 = (kC336 + kG336) - kF336;
    tmp3_1 = ((((kA336 + kC336) - kE336) - kE336) - kD336);
    tmp3_2 = kB336 - kG336;
    // Op 337: dim3x3 mul
    uint64_t s0_337_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_337_0 = *(gl64_t*)&dParams->aux_trace[s0_337_pos];
    gl64_t s0_337_1 = *(gl64_t*)&dParams->aux_trace[s0_337_pos + TILE_HEIGHT];
    gl64_t s0_337_2 = *(gl64_t*)&dParams->aux_trace[s0_337_pos + 2*TILE_HEIGHT];
    gl64_t kA337 = (s0_337_0 + s0_337_1) * (tmp3_0 + tmp3_1);
    gl64_t kB337 = (s0_337_0 + s0_337_2) * (tmp3_0 + tmp3_2);
    gl64_t kC337 = (s0_337_1 + s0_337_2) * (tmp3_1 + tmp3_2);
    gl64_t kD337 = s0_337_0 * tmp3_0;
    gl64_t kE337 = s0_337_1 * tmp3_1;
    gl64_t kF337 = s0_337_2 * tmp3_2;
    gl64_t kG337 = kD337 - kE337;
    tmp3_0 = (kC337 + kG337) - kF337;
    tmp3_1 = ((((kA337 + kC337) - kE337) - kE337) - kD337);
    tmp3_2 = kB337 - kG337;
    // Op 338: dim1x1 sub_swap
    gl64_t s0_338 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    gl64_t s1_338 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s1_338 - s0_338;
    // Op 339: dim3x3 add
    gl64_t s1_339_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_339_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_339_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_339_0; tmp3_7 = tmp3_7 + s1_339_1; tmp3_8 = tmp3_8 + s1_339_2;
    // Op 340: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 341: dim1x1 sub_swap
    gl64_t s0_341 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_341 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s1_341 - s0_341;
    // Op 342: dim3x3 add
    gl64_t s1_342_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_342_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_342_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_342_0; tmp3_10 = tmp3_10 + s1_342_1; tmp3_11 = tmp3_11 + s1_342_2;
    // Op 343: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 344: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 345: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 346: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 347: dim3x3 mul
    gl64_t s1_347_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_347_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_347_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA347 = (tmp3_0 + tmp3_1) * (s1_347_0 + s1_347_1);
    gl64_t kB347 = (tmp3_0 + tmp3_2) * (s1_347_0 + s1_347_2);
    gl64_t kC347 = (tmp3_1 + tmp3_2) * (s1_347_1 + s1_347_2);
    gl64_t kD347 = tmp3_0 * s1_347_0;
    gl64_t kE347 = tmp3_1 * s1_347_1;
    gl64_t kF347 = tmp3_2 * s1_347_2;
    gl64_t kG347 = kD347 - kE347;
    tmp3_12 = (kC347 + kG347) - kF347;
    tmp3_13 = ((((kA347 + kC347) - kE347) - kE347) - kD347);
    tmp3_14 = kB347 - kG347;
    // Op 348: dim3x1 mul
    gl64_t s0_348_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_348_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_348_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_348 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    tmp3_0 = s0_348_0 * s1_348; tmp3_1 = s0_348_1 * s1_348; tmp3_2 = s0_348_2 * s1_348;
    // Op 349: dim3x1 add
    gl64_t s1_349 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_349; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 350: dim3x3 mul
    gl64_t s1_350_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_350_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_350_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA350 = (tmp3_0 + tmp3_1) * (s1_350_0 + s1_350_1);
    gl64_t kB350 = (tmp3_0 + tmp3_2) * (s1_350_0 + s1_350_2);
    gl64_t kC350 = (tmp3_1 + tmp3_2) * (s1_350_1 + s1_350_2);
    gl64_t kD350 = tmp3_0 * s1_350_0;
    gl64_t kE350 = tmp3_1 * s1_350_1;
    gl64_t kF350 = tmp3_2 * s1_350_2;
    gl64_t kG350 = kD350 - kE350;
    tmp3_0 = (kC350 + kG350) - kF350;
    tmp3_1 = ((((kA350 + kC350) - kE350) - kE350) - kD350);
    tmp3_2 = kB350 - kG350;
    // Op 351: dim3x1 add
    gl64_t s1_351 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_351; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 352: dim3x3 mul
    gl64_t s1_352_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_352_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_352_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA352 = (tmp3_0 + tmp3_1) * (s1_352_0 + s1_352_1);
    gl64_t kB352 = (tmp3_0 + tmp3_2) * (s1_352_0 + s1_352_2);
    gl64_t kC352 = (tmp3_1 + tmp3_2) * (s1_352_1 + s1_352_2);
    gl64_t kD352 = tmp3_0 * s1_352_0;
    gl64_t kE352 = tmp3_1 * s1_352_1;
    gl64_t kF352 = tmp3_2 * s1_352_2;
    gl64_t kG352 = kD352 - kE352;
    tmp3_0 = (kC352 + kG352) - kF352;
    tmp3_1 = ((((kA352 + kC352) - kE352) - kE352) - kD352);
    tmp3_2 = kB352 - kG352;
    // Op 353: dim3x1 add
    gl64_t s1_353 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_353; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 354: dim3x3 mul
    gl64_t s1_354_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_354_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_354_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA354 = (tmp3_0 + tmp3_1) * (s1_354_0 + s1_354_1);
    gl64_t kB354 = (tmp3_0 + tmp3_2) * (s1_354_0 + s1_354_2);
    gl64_t kC354 = (tmp3_1 + tmp3_2) * (s1_354_1 + s1_354_2);
    gl64_t kD354 = tmp3_0 * s1_354_0;
    gl64_t kE354 = tmp3_1 * s1_354_1;
    gl64_t kF354 = tmp3_2 * s1_354_2;
    gl64_t kG354 = kD354 - kE354;
    tmp3_0 = (kC354 + kG354) - kF354;
    tmp3_1 = ((((kA354 + kC354) - kE354) - kE354) - kD354);
    tmp3_2 = kB354 - kG354;
    // Op 355: dim3x1 add
    gl64_t s1_355 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_355; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 356: dim3x3 mul
    gl64_t s1_356_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_356_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_356_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA356 = (tmp3_0 + tmp3_1) * (s1_356_0 + s1_356_1);
    gl64_t kB356 = (tmp3_0 + tmp3_2) * (s1_356_0 + s1_356_2);
    gl64_t kC356 = (tmp3_1 + tmp3_2) * (s1_356_1 + s1_356_2);
    gl64_t kD356 = tmp3_0 * s1_356_0;
    gl64_t kE356 = tmp3_1 * s1_356_1;
    gl64_t kF356 = tmp3_2 * s1_356_2;
    gl64_t kG356 = kD356 - kE356;
    tmp3_0 = (kC356 + kG356) - kF356;
    tmp3_1 = ((((kA356 + kC356) - kE356) - kE356) - kD356);
    tmp3_2 = kB356 - kG356;
    // Op 357: dim1x1 sub_swap
    gl64_t s0_357 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = tmp1_2 - s0_357;
    // Op 358: dim1x1 mul
    gl64_t s0_358 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_358 = *(gl64_t*)&expressions_params[9][2];
    tmp1_4 = s0_358 * s1_358;
    // Op 359: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_4;
    // Op 360: dim1x1 mul
    gl64_t s0_360 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_360 = *(gl64_t*)&expressions_params[9][1];
    tmp1_4 = s0_360 * s1_360;
    // Op 361: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_4;
    // Op 362: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 363: dim3x3 mul
    gl64_t s1_363_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_363_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_363_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA363 = (tmp3_0 + tmp3_1) * (s1_363_0 + s1_363_1);
    gl64_t kB363 = (tmp3_0 + tmp3_2) * (s1_363_0 + s1_363_2);
    gl64_t kC363 = (tmp3_1 + tmp3_2) * (s1_363_1 + s1_363_2);
    gl64_t kD363 = tmp3_0 * s1_363_0;
    gl64_t kE363 = tmp3_1 * s1_363_1;
    gl64_t kF363 = tmp3_2 * s1_363_2;
    gl64_t kG363 = kD363 - kE363;
    tmp3_0 = (kC363 + kG363) - kF363;
    tmp3_1 = ((((kA363 + kC363) - kE363) - kE363) - kD363);
    tmp3_2 = kB363 - kG363;
    // Op 364: dim3x1 add
    gl64_t s1_364 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_364; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 365: dim3x3 mul
    gl64_t s1_365_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_365_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_365_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA365 = (tmp3_0 + tmp3_1) * (s1_365_0 + s1_365_1);
    gl64_t kB365 = (tmp3_0 + tmp3_2) * (s1_365_0 + s1_365_2);
    gl64_t kC365 = (tmp3_1 + tmp3_2) * (s1_365_1 + s1_365_2);
    gl64_t kD365 = tmp3_0 * s1_365_0;
    gl64_t kE365 = tmp3_1 * s1_365_1;
    gl64_t kF365 = tmp3_2 * s1_365_2;
    gl64_t kG365 = kD365 - kE365;
    tmp3_0 = (kC365 + kG365) - kF365;
    tmp3_1 = ((((kA365 + kC365) - kE365) - kE365) - kD365);
    tmp3_2 = kB365 - kG365;
    // Op 366: dim3x3 mul
    gl64_t s1_366_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_366_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_366_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA366 = (tmp3_0 + tmp3_1) * (s1_366_0 + s1_366_1);
    gl64_t kB366 = (tmp3_0 + tmp3_2) * (s1_366_0 + s1_366_2);
    gl64_t kC366 = (tmp3_1 + tmp3_2) * (s1_366_1 + s1_366_2);
    gl64_t kD366 = tmp3_0 * s1_366_0;
    gl64_t kE366 = tmp3_1 * s1_366_1;
    gl64_t kF366 = tmp3_2 * s1_366_2;
    gl64_t kG366 = kD366 - kE366;
    tmp3_0 = (kC366 + kG366) - kF366;
    tmp3_1 = ((((kA366 + kC366) - kE366) - kE366) - kD366);
    tmp3_2 = kB366 - kG366;
    // Op 367: dim1x1 mul
    gl64_t s0_367 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_367 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s0_367 * s1_367;
    // Op 368: dim1x1 add
    tmp1_0 = tmp1_5 + tmp1_0;
    // Op 369: dim1x1 mul
    gl64_t s0_369 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_369 = *(gl64_t*)&expressions_params[9][1];
    tmp1_5 = s0_369 * s1_369;
    // Op 370: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_5;
    // Op 371: dim1x1 mul
    gl64_t s0_371 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_371 = *(gl64_t*)&expressions_params[9][2];
    tmp1_5 = s0_371 * s1_371;
    // Op 372: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_5;
    // Op 373: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 374: dim3x3 mul
    gl64_t s1_374_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_374_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_374_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA374 = (tmp3_0 + tmp3_1) * (s1_374_0 + s1_374_1);
    gl64_t kB374 = (tmp3_0 + tmp3_2) * (s1_374_0 + s1_374_2);
    gl64_t kC374 = (tmp3_1 + tmp3_2) * (s1_374_1 + s1_374_2);
    gl64_t kD374 = tmp3_0 * s1_374_0;
    gl64_t kE374 = tmp3_1 * s1_374_1;
    gl64_t kF374 = tmp3_2 * s1_374_2;
    gl64_t kG374 = kD374 - kE374;
    tmp3_0 = (kC374 + kG374) - kF374;
    tmp3_1 = ((((kA374 + kC374) - kE374) - kE374) - kD374);
    tmp3_2 = kB374 - kG374;
    // Op 375: dim1x1 mul
    gl64_t s0_375 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_375 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s0_375 * s1_375;
    // Op 376: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_0;
    // Op 377: dim1x1 mul
    gl64_t s0_377 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_377 = *(gl64_t*)&expressions_params[9][1];
    tmp1_3 = s0_377 * s1_377;
    // Op 378: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 379: dim1x1 mul
    gl64_t s0_379 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_379 = *(gl64_t*)&expressions_params[9][2];
    tmp1_3 = s0_379 * s1_379;
    // Op 380: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 381: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 382: dim3x3 mul
    gl64_t s1_382_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_382_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_382_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA382 = (tmp3_0 + tmp3_1) * (s1_382_0 + s1_382_1);
    gl64_t kB382 = (tmp3_0 + tmp3_2) * (s1_382_0 + s1_382_2);
    gl64_t kC382 = (tmp3_1 + tmp3_2) * (s1_382_1 + s1_382_2);
    gl64_t kD382 = tmp3_0 * s1_382_0;
    gl64_t kE382 = tmp3_1 * s1_382_1;
    gl64_t kF382 = tmp3_2 * s1_382_2;
    gl64_t kG382 = kD382 - kE382;
    tmp3_0 = (kC382 + kG382) - kF382;
    tmp3_1 = ((((kA382 + kC382) - kE382) - kE382) - kD382);
    tmp3_2 = kB382 - kG382;
    // Op 383: dim1x1 mul
    gl64_t s0_383 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_383 = *(gl64_t*)&expressions_params[9][8];
    tmp1_0 = s0_383 * s1_383;
    // Op 384: dim1x1 add
    gl64_t s0_384 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_384 + tmp1_0;
    // Op 385: dim1x1 mul
    gl64_t s0_385 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_385 = *(gl64_t*)&expressions_params[9][14];
    tmp1_3 = s0_385 * s1_385;
    // Op 386: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 387: dim1x1 mul
    gl64_t s0_387 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_387 = *(gl64_t*)&expressions_params[9][7];
    tmp1_3 = s0_387 * s1_387;
    // Op 388: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 389: dim1x1 add
    gl64_t s1_389 = *(gl64_t*)&expressions_params[9][23];
    tmp1_0 = tmp1_0 + s1_389;
    // Op 390: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 391: dim3x3 mul
    gl64_t s1_391_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_391_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_391_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA391 = (tmp3_0 + tmp3_1) * (s1_391_0 + s1_391_1);
    gl64_t kB391 = (tmp3_0 + tmp3_2) * (s1_391_0 + s1_391_2);
    gl64_t kC391 = (tmp3_1 + tmp3_2) * (s1_391_1 + s1_391_2);
    gl64_t kD391 = tmp3_0 * s1_391_0;
    gl64_t kE391 = tmp3_1 * s1_391_1;
    gl64_t kF391 = tmp3_2 * s1_391_2;
    gl64_t kG391 = kD391 - kE391;
    tmp3_0 = (kC391 + kG391) - kF391;
    tmp3_1 = ((((kA391 + kC391) - kE391) - kE391) - kD391);
    tmp3_2 = kB391 - kG391;
    // Op 392: dim3x1 add
    gl64_t s1_392 = *(gl64_t*)&expressions_params[9][15];
    tmp3_9 = tmp3_0 + s1_392; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 393: dim3x3 add
    gl64_t s1_393_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_393_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_393_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_393_0; tmp3_4 = tmp3_10 + s1_393_1; tmp3_5 = tmp3_11 + s1_393_2;
    // Op 394: dim3x1 mul
    gl64_t s0_394_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_394_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_394_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_394_0 * tmp1_1; tmp3_1 = s0_394_1 * tmp1_1; tmp3_2 = s0_394_2 * tmp1_1;
    // Op 395: dim3x1 add
    gl64_t s1_395 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_395; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 396: dim3x3 mul
    gl64_t s1_396_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_396_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_396_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA396 = (tmp3_0 + tmp3_1) * (s1_396_0 + s1_396_1);
    gl64_t kB396 = (tmp3_0 + tmp3_2) * (s1_396_0 + s1_396_2);
    gl64_t kC396 = (tmp3_1 + tmp3_2) * (s1_396_1 + s1_396_2);
    gl64_t kD396 = tmp3_0 * s1_396_0;
    gl64_t kE396 = tmp3_1 * s1_396_1;
    gl64_t kF396 = tmp3_2 * s1_396_2;
    gl64_t kG396 = kD396 - kE396;
    tmp3_0 = (kC396 + kG396) - kF396;
    tmp3_1 = ((((kA396 + kC396) - kE396) - kE396) - kD396);
    tmp3_2 = kB396 - kG396;
    // Op 397: dim1x1 mul
    gl64_t s0_397 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_397 = *(gl64_t*)&expressions_params[9][8];
    tmp1_1 = s0_397 * s1_397;
    // Op 398: dim1x1 add
    gl64_t s1_398 = *(gl64_t*)&expressions_params[9][21];
    tmp1_1 = tmp1_1 + s1_398;
    // Op 399: dim1x1 add
    gl64_t s1_399 = *(gl64_t*)&expressions_params[9][7];
    tmp1_1 = tmp1_1 + s1_399;
    // Op 400: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 401: dim3x3 mul
    gl64_t s1_401_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_401_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_401_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA401 = (tmp3_0 + tmp3_1) * (s1_401_0 + s1_401_1);
    gl64_t kB401 = (tmp3_0 + tmp3_2) * (s1_401_0 + s1_401_2);
    gl64_t kC401 = (tmp3_1 + tmp3_2) * (s1_401_1 + s1_401_2);
    gl64_t kD401 = tmp3_0 * s1_401_0;
    gl64_t kE401 = tmp3_1 * s1_401_1;
    gl64_t kF401 = tmp3_2 * s1_401_2;
    gl64_t kG401 = kD401 - kE401;
    tmp3_0 = (kC401 + kG401) - kF401;
    tmp3_1 = ((((kA401 + kC401) - kE401) - kE401) - kD401);
    tmp3_2 = kB401 - kG401;
    // Op 402: dim3x1 add
    gl64_t s1_402 = *(gl64_t*)&expressions_params[9][22];
    tmp3_0 = tmp3_0 + s1_402; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 403: dim3x3 mul
    gl64_t s1_403_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_403_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_403_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA403 = (tmp3_0 + tmp3_1) * (s1_403_0 + s1_403_1);
    gl64_t kB403 = (tmp3_0 + tmp3_2) * (s1_403_0 + s1_403_2);
    gl64_t kC403 = (tmp3_1 + tmp3_2) * (s1_403_1 + s1_403_2);
    gl64_t kD403 = tmp3_0 * s1_403_0;
    gl64_t kE403 = tmp3_1 * s1_403_1;
    gl64_t kF403 = tmp3_2 * s1_403_2;
    gl64_t kG403 = kD403 - kE403;
    tmp3_0 = (kC403 + kG403) - kF403;
    tmp3_1 = ((((kA403 + kC403) - kE403) - kE403) - kD403);
    tmp3_2 = kB403 - kG403;
    // Op 404: dim3x1 add
    gl64_t s1_404 = *(gl64_t*)&expressions_params[9][21];
    tmp3_0 = tmp3_0 + s1_404; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 405: dim3x3 mul
    gl64_t s1_405_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_405_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_405_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA405 = (tmp3_0 + tmp3_1) * (s1_405_0 + s1_405_1);
    gl64_t kB405 = (tmp3_0 + tmp3_2) * (s1_405_0 + s1_405_2);
    gl64_t kC405 = (tmp3_1 + tmp3_2) * (s1_405_1 + s1_405_2);
    gl64_t kD405 = tmp3_0 * s1_405_0;
    gl64_t kE405 = tmp3_1 * s1_405_1;
    gl64_t kF405 = tmp3_2 * s1_405_2;
    gl64_t kG405 = kD405 - kE405;
    tmp3_0 = (kC405 + kG405) - kF405;
    tmp3_1 = ((((kA405 + kC405) - kE405) - kE405) - kD405);
    tmp3_2 = kB405 - kG405;
    // Op 406: dim3x1 add
    gl64_t s1_406 = *(gl64_t*)&expressions_params[9][23];
    tmp3_6 = tmp3_0 + s1_406; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 407: dim3x3 add
    gl64_t s1_407_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_407_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_407_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_407_0; tmp3_1 = tmp3_7 + s1_407_1; tmp3_2 = tmp3_8 + s1_407_2;
    // Op 408: dim3x3 mul
    gl64_t kA408 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB408 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC408 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD408 = tmp3_3 * tmp3_0;
    gl64_t kE408 = tmp3_4 * tmp3_1;
    gl64_t kF408 = tmp3_5 * tmp3_2;
    gl64_t kG408 = kD408 - kE408;
    tmp3_0 = (kC408 + kG408) - kF408;
    tmp3_1 = ((((kA408 + kC408) - kE408) - kE408) - kD408);
    tmp3_2 = kB408 - kG408;
    // Op 409: dim3x3 mul
    gl64_t s0_409_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_409_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_409_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    gl64_t kA409 = (s0_409_0 + s0_409_1) * (tmp3_0 + tmp3_1);
    gl64_t kB409 = (s0_409_0 + s0_409_2) * (tmp3_0 + tmp3_2);
    gl64_t kC409 = (s0_409_1 + s0_409_2) * (tmp3_1 + tmp3_2);
    gl64_t kD409 = s0_409_0 * tmp3_0;
    gl64_t kE409 = s0_409_1 * tmp3_1;
    gl64_t kF409 = s0_409_2 * tmp3_2;
    gl64_t kG409 = kD409 - kE409;
    tmp3_0 = (kC409 + kG409) - kF409;
    tmp3_1 = ((((kA409 + kC409) - kE409) - kE409) - kD409);
    tmp3_2 = kB409 - kG409;
    // Op 410: dim1x1 sub_swap
    gl64_t s0_410 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_410 = *(gl64_t*)&expressions_params[9][4];
    tmp1_1 = s1_410 - s0_410;
    // Op 411: dim3x3 add
    gl64_t s1_411_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_411_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_411_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_411_0; tmp3_7 = tmp3_7 + s1_411_1; tmp3_8 = tmp3_8 + s1_411_2;
    // Op 412: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_1; tmp3_7 = tmp3_7 * tmp1_1; tmp3_8 = tmp3_8 * tmp1_1;
    // Op 413: dim1x1 sub_swap
    gl64_t s1_413 = *(gl64_t*)&expressions_params[9][4];
    tmp1_6 = s1_413 - tmp1_6;
    // Op 414: dim3x3 add
    gl64_t s1_414_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_414_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_414_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_414_0; tmp3_10 = tmp3_10 + s1_414_1; tmp3_11 = tmp3_11 + s1_414_2;
    // Op 415: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_6; tmp3_10 = tmp3_10 * tmp1_6; tmp3_11 = tmp3_11 * tmp1_6;
    // Op 416: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 417: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 418: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 419: dim3x3 mul
    gl64_t s1_419_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_419_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_419_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA419 = (tmp3_0 + tmp3_1) * (s1_419_0 + s1_419_1);
    gl64_t kB419 = (tmp3_0 + tmp3_2) * (s1_419_0 + s1_419_2);
    gl64_t kC419 = (tmp3_1 + tmp3_2) * (s1_419_1 + s1_419_2);
    gl64_t kD419 = tmp3_0 * s1_419_0;
    gl64_t kE419 = tmp3_1 * s1_419_1;
    gl64_t kF419 = tmp3_2 * s1_419_2;
    gl64_t kG419 = kD419 - kE419;
    tmp3_12 = (kC419 + kG419) - kF419;
    tmp3_13 = ((((kA419 + kC419) - kE419) - kE419) - kD419);
    tmp3_14 = kB419 - kG419;
    // Op 420: dim1x1 add
    gl64_t s0_420 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_420 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_6 = s0_420 + s1_420;
    // Op 421: dim1x1 mul
    gl64_t s0_421 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    tmp1_6 = s0_421 * tmp1_6;
    // Op 422: dim1x1 mul
    gl64_t s0_422 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_422 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_1 = s0_422 * s1_422;
    // Op 423: dim1x1 add
    tmp1_1 = tmp1_6 + tmp1_1;
    // Op 424: dim3x1 mul
    gl64_t s0_424_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_424_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_424_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_424_0 * tmp1_1; tmp3_1 = s0_424_1 * tmp1_1; tmp3_2 = s0_424_2 * tmp1_1;
    // Op 425: dim3x1 add
    gl64_t s1_425 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_425; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 426: dim3x3 mul
    gl64_t s1_426_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_426_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_426_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA426 = (tmp3_0 + tmp3_1) * (s1_426_0 + s1_426_1);
    gl64_t kB426 = (tmp3_0 + tmp3_2) * (s1_426_0 + s1_426_2);
    gl64_t kC426 = (tmp3_1 + tmp3_2) * (s1_426_1 + s1_426_2);
    gl64_t kD426 = tmp3_0 * s1_426_0;
    gl64_t kE426 = tmp3_1 * s1_426_1;
    gl64_t kF426 = tmp3_2 * s1_426_2;
    gl64_t kG426 = kD426 - kE426;
    tmp3_0 = (kC426 + kG426) - kF426;
    tmp3_1 = ((((kA426 + kC426) - kE426) - kE426) - kD426);
    tmp3_2 = kB426 - kG426;
    // Op 427: dim3x3 mul
    gl64_t s1_427_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_427_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_427_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA427 = (tmp3_0 + tmp3_1) * (s1_427_0 + s1_427_1);
    gl64_t kB427 = (tmp3_0 + tmp3_2) * (s1_427_0 + s1_427_2);
    gl64_t kC427 = (tmp3_1 + tmp3_2) * (s1_427_1 + s1_427_2);
    gl64_t kD427 = tmp3_0 * s1_427_0;
    gl64_t kE427 = tmp3_1 * s1_427_1;
    gl64_t kF427 = tmp3_2 * s1_427_2;
    gl64_t kG427 = kD427 - kE427;
    tmp3_0 = (kC427 + kG427) - kF427;
    tmp3_1 = ((((kA427 + kC427) - kE427) - kE427) - kD427);
    tmp3_2 = kB427 - kG427;
    // Op 428: dim1x1 add
    gl64_t s0_428 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_428 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    tmp1_1 = s0_428 + s1_428;
    // Op 429: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 430: dim3x3 mul
    gl64_t s1_430_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_430_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_430_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA430 = (tmp3_0 + tmp3_1) * (s1_430_0 + s1_430_1);
    gl64_t kB430 = (tmp3_0 + tmp3_2) * (s1_430_0 + s1_430_2);
    gl64_t kC430 = (tmp3_1 + tmp3_2) * (s1_430_1 + s1_430_2);
    gl64_t kD430 = tmp3_0 * s1_430_0;
    gl64_t kE430 = tmp3_1 * s1_430_1;
    gl64_t kF430 = tmp3_2 * s1_430_2;
    gl64_t kG430 = kD430 - kE430;
    tmp3_0 = (kC430 + kG430) - kF430;
    tmp3_1 = ((((kA430 + kC430) - kE430) - kE430) - kD430);
    tmp3_2 = kB430 - kG430;
    // Op 431: dim1x1 add
    gl64_t s0_431 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    gl64_t s1_431 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp1_0 = s0_431 + s1_431;
    // Op 432: dim1x1 mul
    gl64_t s0_432 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_432 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s0_432 * s1_432;
    // Op 433: dim1x1 mul
    gl64_t s0_433 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_433 = *(gl64_t*)&expressions_params[9][1];
    tmp1_6 = s0_433 * s1_433;
    // Op 434: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_6;
    // Op 435: dim1x1 add
    gl64_t s0_435 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_6 = s0_435 + tmp1_1;
    // Op 436: dim1x1 sub_swap
    gl64_t s0_436 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_436 = *(gl64_t*)&expressions_params[9][21];
    tmp1_1 = s1_436 - s0_436;
    // Op 437: dim1x1 mul
    tmp1_1 = tmp1_6 * tmp1_1;
    // Op 438: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 439: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 440: dim3x3 mul
    gl64_t s1_440_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_440_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_440_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA440 = (tmp3_0 + tmp3_1) * (s1_440_0 + s1_440_1);
    gl64_t kB440 = (tmp3_0 + tmp3_2) * (s1_440_0 + s1_440_2);
    gl64_t kC440 = (tmp3_1 + tmp3_2) * (s1_440_1 + s1_440_2);
    gl64_t kD440 = tmp3_0 * s1_440_0;
    gl64_t kE440 = tmp3_1 * s1_440_1;
    gl64_t kF440 = tmp3_2 * s1_440_2;
    gl64_t kG440 = kD440 - kE440;
    tmp3_0 = (kC440 + kG440) - kF440;
    tmp3_1 = ((((kA440 + kC440) - kE440) - kE440) - kD440);
    tmp3_2 = kB440 - kG440;
    // Op 441: dim3x3 mul
    gl64_t s1_441_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_441_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_441_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA441 = (tmp3_0 + tmp3_1) * (s1_441_0 + s1_441_1);
    gl64_t kB441 = (tmp3_0 + tmp3_2) * (s1_441_0 + s1_441_2);
    gl64_t kC441 = (tmp3_1 + tmp3_2) * (s1_441_1 + s1_441_2);
    gl64_t kD441 = tmp3_0 * s1_441_0;
    gl64_t kE441 = tmp3_1 * s1_441_1;
    gl64_t kF441 = tmp3_2 * s1_441_2;
    gl64_t kG441 = kD441 - kE441;
    tmp3_0 = (kC441 + kG441) - kF441;
    tmp3_1 = ((((kA441 + kC441) - kE441) - kE441) - kD441);
    tmp3_2 = kB441 - kG441;
    // Op 442: dim1x1 mul
    gl64_t s0_442 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_442 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_442 * s1_442;
    // Op 443: dim1x1 mul
    gl64_t s0_443 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    gl64_t s1_443 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s0_443 * s1_443;
    // Op 444: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 445: dim1x1 add
    gl64_t s0_445 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_445 + tmp1_0;
    // Op 446: dim1x1 add
    gl64_t s0_446 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_446 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_1 = s0_446 + s1_446;
    // Op 447: dim1x1 mul
    tmp1_1 = tmp1_0 * tmp1_1;
    // Op 448: dim1x1 add
    gl64_t s0_448 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_448 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_448 + s1_448;
    // Op 449: dim1x1 mul
    tmp1_0 = tmp1_2 * tmp1_0;
    // Op 450: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 451: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 452: dim3x3 mul
    gl64_t s1_452_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_452_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_452_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA452 = (tmp3_0 + tmp3_1) * (s1_452_0 + s1_452_1);
    gl64_t kB452 = (tmp3_0 + tmp3_2) * (s1_452_0 + s1_452_2);
    gl64_t kC452 = (tmp3_1 + tmp3_2) * (s1_452_1 + s1_452_2);
    gl64_t kD452 = tmp3_0 * s1_452_0;
    gl64_t kE452 = tmp3_1 * s1_452_1;
    gl64_t kF452 = tmp3_2 * s1_452_2;
    gl64_t kG452 = kD452 - kE452;
    tmp3_0 = (kC452 + kG452) - kF452;
    tmp3_1 = ((((kA452 + kC452) - kE452) - kE452) - kD452);
    tmp3_2 = kB452 - kG452;
    // Op 453: dim3x3 mul
    gl64_t s1_453_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_453_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_453_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA453 = (tmp3_0 + tmp3_1) * (s1_453_0 + s1_453_1);
    gl64_t kB453 = (tmp3_0 + tmp3_2) * (s1_453_0 + s1_453_2);
    gl64_t kC453 = (tmp3_1 + tmp3_2) * (s1_453_1 + s1_453_2);
    gl64_t kD453 = tmp3_0 * s1_453_0;
    gl64_t kE453 = tmp3_1 * s1_453_1;
    gl64_t kF453 = tmp3_2 * s1_453_2;
    gl64_t kG453 = kD453 - kE453;
    tmp3_0 = (kC453 + kG453) - kF453;
    tmp3_1 = ((((kA453 + kC453) - kE453) - kE453) - kD453);
    tmp3_2 = kB453 - kG453;
    // Op 454: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_6; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 455: dim3x3 mul
    gl64_t s1_455_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_455_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_455_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA455 = (tmp3_0 + tmp3_1) * (s1_455_0 + s1_455_1);
    gl64_t kB455 = (tmp3_0 + tmp3_2) * (s1_455_0 + s1_455_2);
    gl64_t kC455 = (tmp3_1 + tmp3_2) * (s1_455_1 + s1_455_2);
    gl64_t kD455 = tmp3_0 * s1_455_0;
    gl64_t kE455 = tmp3_1 * s1_455_1;
    gl64_t kF455 = tmp3_2 * s1_455_2;
    gl64_t kG455 = kD455 - kE455;
    tmp3_0 = (kC455 + kG455) - kF455;
    tmp3_1 = ((((kA455 + kC455) - kE455) - kE455) - kD455);
    tmp3_2 = kB455 - kG455;
    // Op 456: dim1x1 mul
    gl64_t s0_456 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_456 = *(gl64_t*)&expressions_params[9][24];
    tmp1_6 = s0_456 * s1_456;
    // Op 457: dim1x1 mul
    gl64_t s0_457 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_457 = *(gl64_t*)&expressions_params[9][25];
    tmp1_0 = s0_457 * s1_457;
    // Op 458: dim1x1 add
    tmp1_0 = tmp1_6 + tmp1_0;
    // Op 459: dim1x1 mul
    gl64_t s0_459 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_459 = *(gl64_t*)&expressions_params[9][26];
    tmp1_6 = s0_459 * s1_459;
    // Op 460: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_6;
    // Op 461: dim1x1 mul
    gl64_t s0_461 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_461 = *(gl64_t*)&expressions_params[9][27];
    tmp1_6 = s0_461 * s1_461;
    // Op 462: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_6;
    // Op 463: dim1x1 mul
    gl64_t s0_463 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_463 = *(gl64_t*)&expressions_params[9][19];
    tmp1_6 = s0_463 * s1_463;
    // Op 464: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_6;
    // Op 465: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 466: dim3x3 mul
    gl64_t s1_466_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_466_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_466_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA466 = (tmp3_0 + tmp3_1) * (s1_466_0 + s1_466_1);
    gl64_t kB466 = (tmp3_0 + tmp3_2) * (s1_466_0 + s1_466_2);
    gl64_t kC466 = (tmp3_1 + tmp3_2) * (s1_466_1 + s1_466_2);
    gl64_t kD466 = tmp3_0 * s1_466_0;
    gl64_t kE466 = tmp3_1 * s1_466_1;
    gl64_t kF466 = tmp3_2 * s1_466_2;
    gl64_t kG466 = kD466 - kE466;
    tmp3_0 = (kC466 + kG466) - kF466;
    tmp3_1 = ((((kA466 + kC466) - kE466) - kE466) - kD466);
    tmp3_2 = kB466 - kG466;
    // Op 467: dim3x1 add
    gl64_t s1_467 = *(gl64_t*)&expressions_params[9][20];
    tmp3_0 = tmp3_0 + s1_467; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 468: dim3x3 add
    gl64_t s1_468_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_468_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_468_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_468_0; tmp3_1 = tmp3_1 + s1_468_1; tmp3_2 = tmp3_2 + s1_468_2;
    // Op 469: dim3x3 mul
    gl64_t s0_469_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+0, domainSize, nCols_2))];
    gl64_t s0_469_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+1, domainSize, nCols_2))];
    gl64_t s0_469_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+2, domainSize, nCols_2))];
    gl64_t kA469 = (s0_469_0 + s0_469_1) * (tmp3_0 + tmp3_1);
    gl64_t kB469 = (s0_469_0 + s0_469_2) * (tmp3_0 + tmp3_2);
    gl64_t kC469 = (s0_469_1 + s0_469_2) * (tmp3_1 + tmp3_2);
    gl64_t kD469 = s0_469_0 * tmp3_0;
    gl64_t kE469 = s0_469_1 * tmp3_1;
    gl64_t kF469 = s0_469_2 * tmp3_2;
    gl64_t kG469 = kD469 - kE469;
    tmp3_0 = (kC469 + kG469) - kF469;
    tmp3_1 = ((((kA469 + kC469) - kE469) - kE469) - kD469);
    tmp3_2 = kB469 - kG469;
    // Op 470: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_7; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 471: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 472: dim3x3 mul
    gl64_t s1_472_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_472_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_472_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA472 = (tmp3_0 + tmp3_1) * (s1_472_0 + s1_472_1);
    gl64_t kB472 = (tmp3_0 + tmp3_2) * (s1_472_0 + s1_472_2);
    gl64_t kC472 = (tmp3_1 + tmp3_2) * (s1_472_1 + s1_472_2);
    gl64_t kD472 = tmp3_0 * s1_472_0;
    gl64_t kE472 = tmp3_1 * s1_472_1;
    gl64_t kF472 = tmp3_2 * s1_472_2;
    gl64_t kG472 = kD472 - kE472;
    tmp3_6 = (kC472 + kG472) - kF472;
    tmp3_7 = ((((kA472 + kC472) - kE472) - kE472) - kD472);
    tmp3_8 = kB472 - kG472;
    // Op 473: dim1x1 sub_swap
    gl64_t s0_473 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_473 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_473 - s0_473;
    // Op 474: dim3x1 mul
    uint64_t s0_474_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_474_0 = *(gl64_t*)&dParams->aux_trace[s0_474_pos];
    gl64_t s0_474_1 = *(gl64_t*)&dParams->aux_trace[s0_474_pos + TILE_HEIGHT];
    gl64_t s0_474_2 = *(gl64_t*)&dParams->aux_trace[s0_474_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_474_0 * tmp1_0; tmp3_1 = s0_474_1 * tmp1_0; tmp3_2 = s0_474_2 * tmp1_0;
    // Op 475: dim3x3 sub
    uint64_t s0_475_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_475_0 = *(gl64_t*)&dParams->aux_trace[s0_475_pos];
    gl64_t s0_475_1 = *(gl64_t*)&dParams->aux_trace[s0_475_pos + TILE_HEIGHT];
    gl64_t s0_475_2 = *(gl64_t*)&dParams->aux_trace[s0_475_pos + 2*TILE_HEIGHT];
    tmp3_12 = s0_475_0 - tmp3_0; tmp3_13 = s0_475_1 - tmp3_1; tmp3_14 = s0_475_2 - tmp3_2;
    // Op 476: dim3x3 add
    gl64_t s0_476_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_476_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_476_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_476_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_476_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_476_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_0 = s0_476_0 + s1_476_0; tmp3_1 = s0_476_1 + s1_476_1; tmp3_2 = s0_476_2 + s1_476_2;
    // Op 477: dim3x3 add
    uint64_t s0_477_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_477_0 = *(gl64_t*)&dParams->aux_trace[s0_477_pos];
    gl64_t s0_477_1 = *(gl64_t*)&dParams->aux_trace[s0_477_pos + TILE_HEIGHT];
    gl64_t s0_477_2 = *(gl64_t*)&dParams->aux_trace[s0_477_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_477_0 + tmp3_0; tmp3_1 = s0_477_1 + tmp3_1; tmp3_2 = s0_477_2 + tmp3_2;
    // Op 478: dim3x3 add
    uint64_t s0_478_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_478_0 = *(gl64_t*)&dParams->aux_trace[s0_478_pos];
    gl64_t s0_478_1 = *(gl64_t*)&dParams->aux_trace[s0_478_pos + TILE_HEIGHT];
    gl64_t s0_478_2 = *(gl64_t*)&dParams->aux_trace[s0_478_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_478_0 + tmp3_0; tmp3_1 = s0_478_1 + tmp3_1; tmp3_2 = s0_478_2 + tmp3_2;
    // Op 479: dim3x3 add
    gl64_t s0_479_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_479_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_479_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    tmp3_0 = s0_479_0 + tmp3_0; tmp3_1 = s0_479_1 + tmp3_1; tmp3_2 = s0_479_2 + tmp3_2;
    // Op 480: dim3x3 add
    gl64_t s0_480_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+0, domainSize, nCols_2))];
    gl64_t s0_480_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+1, domainSize, nCols_2))];
    gl64_t s0_480_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+2, domainSize, nCols_2))];
    tmp3_0 = s0_480_0 + tmp3_0; tmp3_1 = s0_480_1 + tmp3_1; tmp3_2 = s0_480_2 + tmp3_2;
    // Op 481: dim3x3 sub
    tmp3_12 = tmp3_12 - tmp3_0; tmp3_13 = tmp3_13 - tmp3_1; tmp3_14 = tmp3_14 - tmp3_2;
    // Op 482: dim3x1 mul
    gl64_t s0_482_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_482_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_482_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_482 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp3_0 = s0_482_0 * s1_482; tmp3_1 = s0_482_1 * s1_482; tmp3_2 = s0_482_2 * s1_482;
    // Op 483: dim3x1 add
    gl64_t s1_483 = *(gl64_t*)&expressions_params[9][28];
    tmp3_0 = tmp3_0 + s1_483; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 484: dim3x3 add
    gl64_t s1_484_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_484_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_484_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_484_0; tmp3_1 = tmp3_1 + s1_484_1; tmp3_2 = tmp3_2 + s1_484_2;
    // Op 485: dim3x3 mul
    gl64_t kA485 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB485 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC485 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD485 = tmp3_12 * tmp3_0;
    gl64_t kE485 = tmp3_13 * tmp3_1;
    gl64_t kF485 = tmp3_14 * tmp3_2;
    gl64_t kG485 = kD485 - kE485;
    tmp3_0 = (kC485 + kG485) - kF485;
    tmp3_1 = ((((kA485 + kC485) - kE485) - kE485) - kD485);
    tmp3_2 = kB485 - kG485;
    // Op 486: dim1x1 sub_swap
    gl64_t s1_486 = *(gl64_t*)&expressions_params[9][4];
    tmp1_7 = s1_486 - tmp1_7;
    // Op 487: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_7; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 488: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 489: dim3x3 mul
    gl64_t s1_489_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_489_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_489_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA489 = (tmp3_0 + tmp3_1) * (s1_489_0 + s1_489_1);
    gl64_t kB489 = (tmp3_0 + tmp3_2) * (s1_489_0 + s1_489_2);
    gl64_t kC489 = (tmp3_1 + tmp3_2) * (s1_489_1 + s1_489_2);
    gl64_t kD489 = tmp3_0 * s1_489_0;
    gl64_t kE489 = tmp3_1 * s1_489_1;
    gl64_t kF489 = tmp3_2 * s1_489_2;
    gl64_t kG489 = kD489 - kE489;
    tmp3_6 = (kC489 + kG489) - kF489;
    tmp3_7 = ((((kA489 + kC489) - kE489) - kE489) - kD489);
    tmp3_8 = kB489 - kG489;
    // Op 490: dim3x3 sub_swap
    uint64_t s0_490_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_490_0 = *(gl64_t*)&dParams->aux_trace[s0_490_pos];
    gl64_t s0_490_1 = *(gl64_t*)&dParams->aux_trace[s0_490_pos + TILE_HEIGHT];
    gl64_t s0_490_2 = *(gl64_t*)&dParams->aux_trace[s0_490_pos + 2*TILE_HEIGHT];
    gl64_t s1_490_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_490_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_490_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_0 = s1_490_0 - s0_490_0; tmp3_1 = s1_490_1 - s0_490_1; tmp3_2 = s1_490_2 - s0_490_2;
    // Op 491: dim3x1 mul
    gl64_t s1_491 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_491; tmp3_1 = tmp3_1 * s1_491; tmp3_2 = tmp3_2 * s1_491;
    // Op 492: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 493: dim3x1 mul
    gl64_t s1_493 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_493; tmp3_1 = tmp3_1 * s1_493; tmp3_2 = tmp3_2 * s1_493;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
