// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: ed8323e8  nOps=511 nTemp1=9 nTemp3=5
#define GENERATED_EVAL_NOPS_ed8323e8 511
#define GENERATED_EVAL_NTEMP1_ed8323e8 9
#define GENERATED_EVAL_NTEMP3_ed8323e8 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_ed8323e8(
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

    // Register-resident temporaries: 9 tmp1 + 15 tmp3 slots
    gl64_t tmp1_0 = gl64_t(uint64_t(0));
    gl64_t tmp1_1 = gl64_t(uint64_t(0));
    gl64_t tmp1_2 = gl64_t(uint64_t(0));
    gl64_t tmp1_3 = gl64_t(uint64_t(0));
    gl64_t tmp1_4 = gl64_t(uint64_t(0));
    gl64_t tmp1_5 = gl64_t(uint64_t(0));
    gl64_t tmp1_6 = gl64_t(uint64_t(0));
    gl64_t tmp1_7 = gl64_t(uint64_t(0));
    gl64_t tmp1_8 = gl64_t(uint64_t(0));
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
    tmp1_8 = s0_21 + tmp1_0;
    // Op 22: dim1x1 sub_swap
    gl64_t s1_22 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_22 - tmp1_8;
    // Op 23: dim1x1 mul
    tmp1_0 = tmp1_8 * tmp1_0;
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
    // Op 59: dim1x1 mul
    gl64_t s0_59 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_59 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_59 * s1_59;
    // Op 60: dim1x1 add
    gl64_t s0_60 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_7 = s0_60 + tmp1_0;
    // Op 61: dim1x1 mul
    gl64_t s0_61 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_0 = s0_61 * tmp1_7;
    // Op 62: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_8;
    // Op 63: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 64: dim3x3 mul
    gl64_t s1_64_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_64_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_64_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA64 = (tmp3_0 + tmp3_1) * (s1_64_0 + s1_64_1);
    gl64_t kB64 = (tmp3_0 + tmp3_2) * (s1_64_0 + s1_64_2);
    gl64_t kC64 = (tmp3_1 + tmp3_2) * (s1_64_1 + s1_64_2);
    gl64_t kD64 = tmp3_0 * s1_64_0;
    gl64_t kE64 = tmp3_1 * s1_64_1;
    gl64_t kF64 = tmp3_2 * s1_64_2;
    gl64_t kG64 = kD64 - kE64;
    tmp3_0 = (kC64 + kG64) - kF64;
    tmp3_1 = ((((kA64 + kC64) - kE64) - kE64) - kD64);
    tmp3_2 = kB64 - kG64;
    // Op 65: dim1x1 add
    gl64_t s0_65 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_65 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_65 + s1_65;
    // Op 66: dim1x1 mul
    gl64_t s0_66 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_0 = s0_66 * tmp1_0;
    // Op 67: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 68: dim3x3 mul
    gl64_t s1_68_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_68_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_68_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA68 = (tmp3_0 + tmp3_1) * (s1_68_0 + s1_68_1);
    gl64_t kB68 = (tmp3_0 + tmp3_2) * (s1_68_0 + s1_68_2);
    gl64_t kC68 = (tmp3_1 + tmp3_2) * (s1_68_1 + s1_68_2);
    gl64_t kD68 = tmp3_0 * s1_68_0;
    gl64_t kE68 = tmp3_1 * s1_68_1;
    gl64_t kF68 = tmp3_2 * s1_68_2;
    gl64_t kG68 = kD68 - kE68;
    tmp3_0 = (kC68 + kG68) - kF68;
    tmp3_1 = ((((kA68 + kC68) - kE68) - kE68) - kD68);
    tmp3_2 = kB68 - kG68;
    // Op 69: dim1x1 mul
    gl64_t s0_69 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_69 * tmp1_7;
    // Op 70: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_8;
    // Op 71: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 72: dim3x3 mul
    gl64_t s1_72_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_72_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_72_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 73: dim1x1 sub_swap
    gl64_t s0_73 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_73 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_73 - s0_73;
    // Op 74: dim1x1 mul
    gl64_t s0_74 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_74 * tmp1_0;
    // Op 75: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 76: dim3x3 mul
    gl64_t s1_76_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_76_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_76_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA76 = (tmp3_0 + tmp3_1) * (s1_76_0 + s1_76_1);
    gl64_t kB76 = (tmp3_0 + tmp3_2) * (s1_76_0 + s1_76_2);
    gl64_t kC76 = (tmp3_1 + tmp3_2) * (s1_76_1 + s1_76_2);
    gl64_t kD76 = tmp3_0 * s1_76_0;
    gl64_t kE76 = tmp3_1 * s1_76_1;
    gl64_t kF76 = tmp3_2 * s1_76_2;
    gl64_t kG76 = kD76 - kE76;
    tmp3_0 = (kC76 + kG76) - kF76;
    tmp3_1 = ((((kA76 + kC76) - kE76) - kE76) - kD76);
    tmp3_2 = kB76 - kG76;
    // Op 77: dim1x1 sub_swap
    gl64_t s0_77 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_77 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_77 - s0_77;
    // Op 78: dim1x1 mul
    gl64_t s0_78 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = s0_78 * tmp1_0;
    // Op 79: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 80: dim3x3 mul
    gl64_t s1_80_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_80_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_80_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 81: dim1x1 sub_swap
    gl64_t s0_81 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_81 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_81 - s0_81;
    // Op 82: dim1x1 mul
    gl64_t s0_82 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_82 * tmp1_0;
    // Op 83: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 84: dim3x3 mul
    gl64_t s1_84_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_84_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_84_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 85: dim1x1 sub_swap
    gl64_t s1_85 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_85 - tmp1_8;
    // Op 86: dim1x1 mul
    gl64_t s0_86 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = s0_86 * tmp1_0;
    // Op 87: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 88: dim3x3 mul
    gl64_t s1_88_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_88_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_88_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA88 = (tmp3_0 + tmp3_1) * (s1_88_0 + s1_88_1);
    gl64_t kB88 = (tmp3_0 + tmp3_2) * (s1_88_0 + s1_88_2);
    gl64_t kC88 = (tmp3_1 + tmp3_2) * (s1_88_1 + s1_88_2);
    gl64_t kD88 = tmp3_0 * s1_88_0;
    gl64_t kE88 = tmp3_1 * s1_88_1;
    gl64_t kF88 = tmp3_2 * s1_88_2;
    gl64_t kG88 = kD88 - kE88;
    tmp3_0 = (kC88 + kG88) - kF88;
    tmp3_1 = ((((kA88 + kC88) - kE88) - kE88) - kD88);
    tmp3_2 = kB88 - kG88;
    // Op 89: dim1x1 sub_swap
    gl64_t s1_89 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_89 - tmp1_8;
    // Op 90: dim1x1 mul
    gl64_t s0_90 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_90 * tmp1_0;
    // Op 91: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 92: dim3x3 mul
    gl64_t s1_92_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_92_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_92_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 93: dim1x1 sub_swap
    gl64_t s1_93 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_93 - tmp1_8;
    // Op 94: dim1x1 mul
    gl64_t s0_94 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_94 * tmp1_0;
    // Op 95: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 96: dim3x3 mul
    gl64_t s1_96_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_96_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_96_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA96 = (tmp3_0 + tmp3_1) * (s1_96_0 + s1_96_1);
    gl64_t kB96 = (tmp3_0 + tmp3_2) * (s1_96_0 + s1_96_2);
    gl64_t kC96 = (tmp3_1 + tmp3_2) * (s1_96_1 + s1_96_2);
    gl64_t kD96 = tmp3_0 * s1_96_0;
    gl64_t kE96 = tmp3_1 * s1_96_1;
    gl64_t kF96 = tmp3_2 * s1_96_2;
    gl64_t kG96 = kD96 - kE96;
    tmp3_0 = (kC96 + kG96) - kF96;
    tmp3_1 = ((((kA96 + kC96) - kE96) - kE96) - kD96);
    tmp3_2 = kB96 - kG96;
    // Op 97: dim1x1 sub_swap
    gl64_t s0_97 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    gl64_t s1_97 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_97 - s0_97;
    // Op 98: dim1x1 mul
    gl64_t s0_98 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp1_0 = s0_98 * tmp1_0;
    // Op 99: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 100: dim3x3 mul
    gl64_t s1_100_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_100_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_100_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA100 = (tmp3_0 + tmp3_1) * (s1_100_0 + s1_100_1);
    gl64_t kB100 = (tmp3_0 + tmp3_2) * (s1_100_0 + s1_100_2);
    gl64_t kC100 = (tmp3_1 + tmp3_2) * (s1_100_1 + s1_100_2);
    gl64_t kD100 = tmp3_0 * s1_100_0;
    gl64_t kE100 = tmp3_1 * s1_100_1;
    gl64_t kF100 = tmp3_2 * s1_100_2;
    gl64_t kG100 = kD100 - kE100;
    tmp3_0 = (kC100 + kG100) - kF100;
    tmp3_1 = ((((kA100 + kC100) - kE100) - kE100) - kD100);
    tmp3_2 = kB100 - kG100;
    // Op 101: dim1x1 sub_swap
    gl64_t s0_101 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_101 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_101 - s0_101;
    // Op 102: dim1x1 mul
    gl64_t s0_102 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_102 * tmp1_0;
    // Op 103: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 104: dim3x3 mul
    gl64_t s1_104_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_104_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_104_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA104 = (tmp3_0 + tmp3_1) * (s1_104_0 + s1_104_1);
    gl64_t kB104 = (tmp3_0 + tmp3_2) * (s1_104_0 + s1_104_2);
    gl64_t kC104 = (tmp3_1 + tmp3_2) * (s1_104_1 + s1_104_2);
    gl64_t kD104 = tmp3_0 * s1_104_0;
    gl64_t kE104 = tmp3_1 * s1_104_1;
    gl64_t kF104 = tmp3_2 * s1_104_2;
    gl64_t kG104 = kD104 - kE104;
    tmp3_0 = (kC104 + kG104) - kF104;
    tmp3_1 = ((((kA104 + kC104) - kE104) - kE104) - kD104);
    tmp3_2 = kB104 - kG104;
    // Op 105: dim1x1 mul
    gl64_t s0_105 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    gl64_t s1_105 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_105 * s1_105;
    // Op 106: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 107: dim3x3 mul
    gl64_t s1_107_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_107_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_107_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    gl64_t s0_108 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_108 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    tmp1_0 = s0_108 + s1_108;
    // Op 109: dim1x1 add
    gl64_t s0_109 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    gl64_t s1_109 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp1_1 = s0_109 + s1_109;
    // Op 110: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 111: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 112: dim3x3 mul
    gl64_t s1_112_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_112_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_112_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA112 = (tmp3_0 + tmp3_1) * (s1_112_0 + s1_112_1);
    gl64_t kB112 = (tmp3_0 + tmp3_2) * (s1_112_0 + s1_112_2);
    gl64_t kC112 = (tmp3_1 + tmp3_2) * (s1_112_1 + s1_112_2);
    gl64_t kD112 = tmp3_0 * s1_112_0;
    gl64_t kE112 = tmp3_1 * s1_112_1;
    gl64_t kF112 = tmp3_2 * s1_112_2;
    gl64_t kG112 = kD112 - kE112;
    tmp3_0 = (kC112 + kG112) - kF112;
    tmp3_1 = ((((kA112 + kC112) - kE112) - kE112) - kD112);
    tmp3_2 = kB112 - kG112;
    // Op 113: dim1x1 sub_swap
    gl64_t s0_113 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_113 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_113 - s0_113;
    // Op 114: dim1x1 mul
    gl64_t s0_114 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp1_0 = s0_114 * tmp1_0;
    // Op 115: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 116: dim3x3 mul
    gl64_t s1_116_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_116_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_116_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 117: dim1x1 sub_swap
    gl64_t s0_117 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_117 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_117 - s0_117;
    // Op 118: dim1x1 mul
    gl64_t s0_118 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    tmp1_0 = s0_118 * tmp1_0;
    // Op 119: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 120: dim3x3 mul
    gl64_t s1_120_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_120_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_120_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA120 = (tmp3_0 + tmp3_1) * (s1_120_0 + s1_120_1);
    gl64_t kB120 = (tmp3_0 + tmp3_2) * (s1_120_0 + s1_120_2);
    gl64_t kC120 = (tmp3_1 + tmp3_2) * (s1_120_1 + s1_120_2);
    gl64_t kD120 = tmp3_0 * s1_120_0;
    gl64_t kE120 = tmp3_1 * s1_120_1;
    gl64_t kF120 = tmp3_2 * s1_120_2;
    gl64_t kG120 = kD120 - kE120;
    tmp3_0 = (kC120 + kG120) - kF120;
    tmp3_1 = ((((kA120 + kC120) - kE120) - kE120) - kD120);
    tmp3_2 = kB120 - kG120;
    // Op 121: dim1x1 sub_swap
    gl64_t s0_121 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_121 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_121 - s0_121;
    // Op 122: dim1x1 mul
    gl64_t s0_122 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp1_0 = s0_122 * tmp1_0;
    // Op 123: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 124: dim3x3 mul
    gl64_t s1_124_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_124_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_124_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA124 = (tmp3_0 + tmp3_1) * (s1_124_0 + s1_124_1);
    gl64_t kB124 = (tmp3_0 + tmp3_2) * (s1_124_0 + s1_124_2);
    gl64_t kC124 = (tmp3_1 + tmp3_2) * (s1_124_1 + s1_124_2);
    gl64_t kD124 = tmp3_0 * s1_124_0;
    gl64_t kE124 = tmp3_1 * s1_124_1;
    gl64_t kF124 = tmp3_2 * s1_124_2;
    gl64_t kG124 = kD124 - kE124;
    tmp3_0 = (kC124 + kG124) - kF124;
    tmp3_1 = ((((kA124 + kC124) - kE124) - kE124) - kD124);
    tmp3_2 = kB124 - kG124;
    // Op 125: dim1x1 sub_swap
    gl64_t s0_125 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_125 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_125 - s0_125;
    // Op 126: dim1x1 mul
    gl64_t s0_126 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp1_0 = s0_126 * tmp1_0;
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
    // Op 129: dim1x1 sub_swap
    gl64_t s0_129 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_129 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_129 - s0_129;
    // Op 130: dim1x1 mul
    gl64_t s0_130 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp1_0 = s0_130 * tmp1_0;
    // Op 131: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 132: dim3x3 mul
    gl64_t s1_132_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_132_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_132_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA132 = (tmp3_0 + tmp3_1) * (s1_132_0 + s1_132_1);
    gl64_t kB132 = (tmp3_0 + tmp3_2) * (s1_132_0 + s1_132_2);
    gl64_t kC132 = (tmp3_1 + tmp3_2) * (s1_132_1 + s1_132_2);
    gl64_t kD132 = tmp3_0 * s1_132_0;
    gl64_t kE132 = tmp3_1 * s1_132_1;
    gl64_t kF132 = tmp3_2 * s1_132_2;
    gl64_t kG132 = kD132 - kE132;
    tmp3_0 = (kC132 + kG132) - kF132;
    tmp3_1 = ((((kA132 + kC132) - kE132) - kE132) - kD132);
    tmp3_2 = kB132 - kG132;
    // Op 133: dim1x1 sub_swap
    gl64_t s0_133 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_133 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_133 - s0_133;
    // Op 134: dim1x1 mul
    gl64_t s0_134 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_134 * tmp1_0;
    // Op 135: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 136: dim3x3 mul
    gl64_t s1_136_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_136_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_136_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA136 = (tmp3_0 + tmp3_1) * (s1_136_0 + s1_136_1);
    gl64_t kB136 = (tmp3_0 + tmp3_2) * (s1_136_0 + s1_136_2);
    gl64_t kC136 = (tmp3_1 + tmp3_2) * (s1_136_1 + s1_136_2);
    gl64_t kD136 = tmp3_0 * s1_136_0;
    gl64_t kE136 = tmp3_1 * s1_136_1;
    gl64_t kF136 = tmp3_2 * s1_136_2;
    gl64_t kG136 = kD136 - kE136;
    tmp3_0 = (kC136 + kG136) - kF136;
    tmp3_1 = ((((kA136 + kC136) - kE136) - kE136) - kD136);
    tmp3_2 = kB136 - kG136;
    // Op 137: dim1x1 mul
    gl64_t s0_137 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_137 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_137 * s1_137;
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
    // Op 140: dim1x1 mul
    gl64_t s0_140 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_140 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_140 * s1_140;
    // Op 141: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 142: dim3x3 mul
    gl64_t s1_142_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_142_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_142_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA142 = (tmp3_0 + tmp3_1) * (s1_142_0 + s1_142_1);
    gl64_t kB142 = (tmp3_0 + tmp3_2) * (s1_142_0 + s1_142_2);
    gl64_t kC142 = (tmp3_1 + tmp3_2) * (s1_142_1 + s1_142_2);
    gl64_t kD142 = tmp3_0 * s1_142_0;
    gl64_t kE142 = tmp3_1 * s1_142_1;
    gl64_t kF142 = tmp3_2 * s1_142_2;
    gl64_t kG142 = kD142 - kE142;
    tmp3_0 = (kC142 + kG142) - kF142;
    tmp3_1 = ((((kA142 + kC142) - kE142) - kE142) - kD142);
    tmp3_2 = kB142 - kG142;
    // Op 143: dim1x1 mul
    gl64_t s0_143 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    gl64_t s1_143 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_143 * s1_143;
    // Op 144: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 145: dim3x3 mul
    gl64_t s1_145_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_145_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_145_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 146: dim1x1 sub_swap
    gl64_t s0_146 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_146 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_146 - s0_146;
    // Op 147: dim1x1 mul
    gl64_t s0_147 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp1_0 = s0_147 * tmp1_0;
    // Op 148: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 149: dim3x3 mul
    gl64_t s1_149_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_149_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_149_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 150: dim1x1 sub_swap
    gl64_t s0_150 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_150 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_150 - s0_150;
    // Op 151: dim1x1 mul
    gl64_t s0_151 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_151 * tmp1_0;
    // Op 152: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 153: dim3x3 mul
    gl64_t s1_153_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_153_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_153_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 154: dim1x1 sub_swap
    gl64_t s0_154 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    gl64_t s1_154 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_154 - s0_154;
    // Op 155: dim1x1 mul
    gl64_t s0_155 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp1_0 = s0_155 * tmp1_0;
    // Op 156: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 157: dim3x3 mul
    gl64_t s1_157_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_157_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_157_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 158: dim1x1 sub_swap
    gl64_t s0_158 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    gl64_t s1_158 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_158 - s0_158;
    // Op 159: dim1x1 mul
    gl64_t s0_159 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    tmp1_0 = s0_159 * tmp1_0;
    // Op 160: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 161: dim3x3 mul
    gl64_t s1_161_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_161_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_161_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA161 = (tmp3_0 + tmp3_1) * (s1_161_0 + s1_161_1);
    gl64_t kB161 = (tmp3_0 + tmp3_2) * (s1_161_0 + s1_161_2);
    gl64_t kC161 = (tmp3_1 + tmp3_2) * (s1_161_1 + s1_161_2);
    gl64_t kD161 = tmp3_0 * s1_161_0;
    gl64_t kE161 = tmp3_1 * s1_161_1;
    gl64_t kF161 = tmp3_2 * s1_161_2;
    gl64_t kG161 = kD161 - kE161;
    tmp3_0 = (kC161 + kG161) - kF161;
    tmp3_1 = ((((kA161 + kC161) - kE161) - kE161) - kD161);
    tmp3_2 = kB161 - kG161;
    // Op 162: dim1x1 sub_swap
    gl64_t s0_162 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_162 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_162 - s0_162;
    // Op 163: dim1x1 mul
    gl64_t s0_163 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp1_0 = s0_163 * tmp1_0;
    // Op 164: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 165: dim3x3 mul
    gl64_t s1_165_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_165_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_165_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA165 = (tmp3_0 + tmp3_1) * (s1_165_0 + s1_165_1);
    gl64_t kB165 = (tmp3_0 + tmp3_2) * (s1_165_0 + s1_165_2);
    gl64_t kC165 = (tmp3_1 + tmp3_2) * (s1_165_1 + s1_165_2);
    gl64_t kD165 = tmp3_0 * s1_165_0;
    gl64_t kE165 = tmp3_1 * s1_165_1;
    gl64_t kF165 = tmp3_2 * s1_165_2;
    gl64_t kG165 = kD165 - kE165;
    tmp3_0 = (kC165 + kG165) - kF165;
    tmp3_1 = ((((kA165 + kC165) - kE165) - kE165) - kD165);
    tmp3_2 = kB165 - kG165;
    // Op 166: dim1x1 sub_swap
    gl64_t s0_166 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_166 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_166 - s0_166;
    // Op 167: dim1x1 mul
    gl64_t s0_167 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp1_0 = s0_167 * tmp1_0;
    // Op 168: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 169: dim3x3 mul
    gl64_t s1_169_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_169_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_169_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 170: dim1x1 add
    gl64_t s0_170 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    gl64_t s1_170 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_4 = s0_170 + s1_170;
    // Op 171: dim1x1 sub_swap
    gl64_t s1_171 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_171 - tmp1_4;
    // Op 172: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_3;
    // Op 173: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 174: dim3x3 mul
    gl64_t s1_174_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_174_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_174_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA174 = (tmp3_0 + tmp3_1) * (s1_174_0 + s1_174_1);
    gl64_t kB174 = (tmp3_0 + tmp3_2) * (s1_174_0 + s1_174_2);
    gl64_t kC174 = (tmp3_1 + tmp3_2) * (s1_174_1 + s1_174_2);
    gl64_t kD174 = tmp3_0 * s1_174_0;
    gl64_t kE174 = tmp3_1 * s1_174_1;
    gl64_t kF174 = tmp3_2 * s1_174_2;
    gl64_t kG174 = kD174 - kE174;
    tmp3_0 = (kC174 + kG174) - kF174;
    tmp3_1 = ((((kA174 + kC174) - kE174) - kE174) - kD174);
    tmp3_2 = kB174 - kG174;
    // Op 175: dim1x1 sub_swap
    gl64_t s0_175 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_175 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_175 - s0_175;
    // Op 176: dim1x1 mul
    tmp1_0 = tmp1_4 * tmp1_0;
    // Op 177: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 178: dim3x3 mul
    gl64_t s1_178_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_178_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_178_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 179: dim1x1 mul
    gl64_t s0_179 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_179 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_179 * s1_179;
    // Op 180: dim1x1 mul
    gl64_t s0_180 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    gl64_t s1_180 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s0_180 * s1_180;
    // Op 181: dim1x1 add
    tmp1_5 = tmp1_0 + tmp1_1;
    // Op 182: dim1x1 mul
    gl64_t s0_182 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_182 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s0_182 * s1_182;
    // Op 183: dim1x1 add
    tmp1_0 = tmp1_5 + tmp1_0;
    // Op 184: dim1x1 add
    gl64_t s0_184 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_184 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_1 = s0_184 + s1_184;
    // Op 185: dim1x1 mul
    tmp1_2 = tmp1_0 * tmp1_1;
    // Op 186: dim1x1 mul
    gl64_t s0_186 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_186 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_186 * s1_186;
    // Op 187: dim1x1 mul
    gl64_t s0_187 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_187 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s0_187 * s1_187;
    // Op 188: dim1x1 add
    tmp1_1 = tmp1_0 + tmp1_1;
    // Op 189: dim1x1 add
    gl64_t s0_189 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_189 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_189 + s1_189;
    // Op 190: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 191: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 192: dim1x1 sub
    gl64_t s0_192 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    tmp1_0 = s0_192 - tmp1_0;
    // Op 193: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC194 + kG194) - kF194;
    tmp3_1 = ((((kA194 + kC194) - kE194) - kE194) - kD194);
    tmp3_2 = kB194 - kG194;
    // Op 195: dim1x1 add
    gl64_t s0_195 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_195 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_195 + s1_195;
    // Op 196: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 197: dim1x1 mul
    gl64_t s0_197 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_197 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_1 = s0_197 * s1_197;
    // Op 198: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 199: dim1x1 sub
    gl64_t s0_199 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    tmp1_0 = s0_199 - tmp1_0;
    // Op 200: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 201: dim3x3 mul
    gl64_t s1_201_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_201_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_201_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA201 = (tmp3_0 + tmp3_1) * (s1_201_0 + s1_201_1);
    gl64_t kB201 = (tmp3_0 + tmp3_2) * (s1_201_0 + s1_201_2);
    gl64_t kC201 = (tmp3_1 + tmp3_2) * (s1_201_1 + s1_201_2);
    gl64_t kD201 = tmp3_0 * s1_201_0;
    gl64_t kE201 = tmp3_1 * s1_201_1;
    gl64_t kF201 = tmp3_2 * s1_201_2;
    gl64_t kG201 = kD201 - kE201;
    tmp3_0 = (kC201 + kG201) - kF201;
    tmp3_1 = ((((kA201 + kC201) - kE201) - kE201) - kD201);
    tmp3_2 = kB201 - kG201;
    // Op 202: dim1x1 add
    tmp1_1 = tmp1_7 + tmp1_3;
    // Op 203: dim1x1 mul
    gl64_t s0_203 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_3 = s0_203 * tmp1_1;
    // Op 204: dim1x1 sub
    gl64_t s0_204 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    tmp1_3 = s0_204 - tmp1_3;
    // Op 205: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_3; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 206: dim3x3 mul
    gl64_t s1_206_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_206_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_206_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA206 = (tmp3_0 + tmp3_1) * (s1_206_0 + s1_206_1);
    gl64_t kB206 = (tmp3_0 + tmp3_2) * (s1_206_0 + s1_206_2);
    gl64_t kC206 = (tmp3_1 + tmp3_2) * (s1_206_1 + s1_206_2);
    gl64_t kD206 = tmp3_0 * s1_206_0;
    gl64_t kE206 = tmp3_1 * s1_206_1;
    gl64_t kF206 = tmp3_2 * s1_206_2;
    gl64_t kG206 = kD206 - kE206;
    tmp3_12 = (kC206 + kG206) - kF206;
    tmp3_13 = ((((kA206 + kC206) - kE206) - kE206) - kD206);
    tmp3_14 = kB206 - kG206;
    // Op 207: dim3x1 mul
    gl64_t s0_207_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_207_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_207_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_207 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp3_0 = s0_207_0 * s1_207; tmp3_1 = s0_207_1 * s1_207; tmp3_2 = s0_207_2 * s1_207;
    // Op 208: dim3x1 add
    gl64_t s1_208 = *(gl64_t*)&expressions_params[9][5];
    tmp3_9 = tmp3_0 + s1_208; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 209: dim3x3 add
    gl64_t s1_209_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_209_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_209_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_209_0; tmp3_4 = tmp3_10 + s1_209_1; tmp3_5 = tmp3_11 + s1_209_2;
    // Op 210: dim3x1 mul
    gl64_t s0_210_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_210_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_210_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_210 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp3_0 = s0_210_0 * s1_210; tmp3_1 = s0_210_1 * s1_210; tmp3_2 = s0_210_2 * s1_210;
    // Op 211: dim3x1 add
    gl64_t s1_211 = *(gl64_t*)&expressions_params[9][5];
    tmp3_6 = tmp3_0 + s1_211; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 212: dim3x3 add
    gl64_t s1_212_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_212_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_212_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_212_0; tmp3_1 = tmp3_7 + s1_212_1; tmp3_2 = tmp3_8 + s1_212_2;
    // Op 213: dim3x3 mul
    gl64_t kA213 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB213 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC213 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD213 = tmp3_3 * tmp3_0;
    gl64_t kE213 = tmp3_4 * tmp3_1;
    gl64_t kF213 = tmp3_5 * tmp3_2;
    gl64_t kG213 = kD213 - kE213;
    tmp3_0 = (kC213 + kG213) - kF213;
    tmp3_1 = ((((kA213 + kC213) - kE213) - kE213) - kD213);
    tmp3_2 = kB213 - kG213;
    // Op 214: dim3x3 mul
    gl64_t s0_214_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_214_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_214_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA214 = (s0_214_0 + s0_214_1) * (tmp3_0 + tmp3_1);
    gl64_t kB214 = (s0_214_0 + s0_214_2) * (tmp3_0 + tmp3_2);
    gl64_t kC214 = (s0_214_1 + s0_214_2) * (tmp3_1 + tmp3_2);
    gl64_t kD214 = s0_214_0 * tmp3_0;
    gl64_t kE214 = s0_214_1 * tmp3_1;
    gl64_t kF214 = s0_214_2 * tmp3_2;
    gl64_t kG214 = kD214 - kE214;
    tmp3_0 = (kC214 + kG214) - kF214;
    tmp3_1 = ((((kA214 + kC214) - kE214) - kE214) - kD214);
    tmp3_2 = kB214 - kG214;
    // Op 215: dim1x1 sub_swap
    gl64_t s0_215 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_215 = *(gl64_t*)&expressions_params[9][4];
    tmp1_3 = s1_215 - s0_215;
    // Op 216: dim3x3 add
    gl64_t s1_216_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_216_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_216_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_216_0; tmp3_7 = tmp3_7 + s1_216_1; tmp3_8 = tmp3_8 + s1_216_2;
    // Op 217: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_3; tmp3_7 = tmp3_7 * tmp1_3; tmp3_8 = tmp3_8 * tmp1_3;
    // Op 218: dim1x1 sub_swap
    gl64_t s0_218 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_218 = *(gl64_t*)&expressions_params[9][4];
    tmp1_3 = s1_218 - s0_218;
    // Op 219: dim3x3 add
    gl64_t s1_219_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_219_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_219_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_219_0; tmp3_10 = tmp3_10 + s1_219_1; tmp3_11 = tmp3_11 + s1_219_2;
    // Op 220: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_3; tmp3_10 = tmp3_10 * tmp1_3; tmp3_11 = tmp3_11 * tmp1_3;
    // Op 221: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 222: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 223: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 224: dim3x3 mul
    gl64_t s1_224_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_224_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_224_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA224 = (tmp3_0 + tmp3_1) * (s1_224_0 + s1_224_1);
    gl64_t kB224 = (tmp3_0 + tmp3_2) * (s1_224_0 + s1_224_2);
    gl64_t kC224 = (tmp3_1 + tmp3_2) * (s1_224_1 + s1_224_2);
    gl64_t kD224 = tmp3_0 * s1_224_0;
    gl64_t kE224 = tmp3_1 * s1_224_1;
    gl64_t kF224 = tmp3_2 * s1_224_2;
    gl64_t kG224 = kD224 - kE224;
    tmp3_3 = (kC224 + kG224) - kF224;
    tmp3_4 = ((((kA224 + kC224) - kE224) - kE224) - kD224);
    tmp3_5 = kB224 - kG224;
    // Op 225: dim3x1 mul
    gl64_t s0_225_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_225_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_225_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_225 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp3_0 = s0_225_0 * s1_225; tmp3_1 = s0_225_1 * s1_225; tmp3_2 = s0_225_2 * s1_225;
    // Op 226: dim3x1 add
    gl64_t s1_226 = *(gl64_t*)&expressions_params[9][6];
    tmp3_9 = tmp3_0 + s1_226; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 227: dim3x3 add
    gl64_t s1_227_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_227_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_227_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_227_0; tmp3_13 = tmp3_10 + s1_227_1; tmp3_14 = tmp3_11 + s1_227_2;
    // Op 228: dim3x1 mul
    gl64_t s0_228_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_228_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_228_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_228 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp3_0 = s0_228_0 * s1_228; tmp3_1 = s0_228_1 * s1_228; tmp3_2 = s0_228_2 * s1_228;
    // Op 229: dim3x1 add
    gl64_t s1_229 = *(gl64_t*)&expressions_params[9][6];
    tmp3_6 = tmp3_0 + s1_229; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 230: dim3x3 add
    gl64_t s1_230_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_230_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_230_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_230_0; tmp3_1 = tmp3_7 + s1_230_1; tmp3_2 = tmp3_8 + s1_230_2;
    // Op 231: dim3x3 mul
    gl64_t kA231 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB231 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC231 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD231 = tmp3_12 * tmp3_0;
    gl64_t kE231 = tmp3_13 * tmp3_1;
    gl64_t kF231 = tmp3_14 * tmp3_2;
    gl64_t kG231 = kD231 - kE231;
    tmp3_0 = (kC231 + kG231) - kF231;
    tmp3_1 = ((((kA231 + kC231) - kE231) - kE231) - kD231);
    tmp3_2 = kB231 - kG231;
    // Op 232: dim3x3 mul
    gl64_t s0_232_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_232_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_232_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA232 = (s0_232_0 + s0_232_1) * (tmp3_0 + tmp3_1);
    gl64_t kB232 = (s0_232_0 + s0_232_2) * (tmp3_0 + tmp3_2);
    gl64_t kC232 = (s0_232_1 + s0_232_2) * (tmp3_1 + tmp3_2);
    gl64_t kD232 = s0_232_0 * tmp3_0;
    gl64_t kE232 = s0_232_1 * tmp3_1;
    gl64_t kF232 = s0_232_2 * tmp3_2;
    gl64_t kG232 = kD232 - kE232;
    tmp3_0 = (kC232 + kG232) - kF232;
    tmp3_1 = ((((kA232 + kC232) - kE232) - kE232) - kD232);
    tmp3_2 = kB232 - kG232;
    // Op 233: dim1x1 sub_swap
    gl64_t s1_233 = *(gl64_t*)&expressions_params[9][4];
    tmp1_3 = s1_233 - tmp1_8;
    // Op 234: dim3x3 add
    gl64_t s1_234_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_234_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_234_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_234_0; tmp3_7 = tmp3_7 + s1_234_1; tmp3_8 = tmp3_8 + s1_234_2;
    // Op 235: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_3; tmp3_7 = tmp3_7 * tmp1_3; tmp3_8 = tmp3_8 * tmp1_3;
    // Op 236: dim1x1 sub_swap
    gl64_t s1_236 = *(gl64_t*)&expressions_params[9][4];
    tmp1_3 = s1_236 - tmp1_8;
    // Op 237: dim3x3 add
    gl64_t s1_237_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_237_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_237_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_237_0; tmp3_10 = tmp3_10 + s1_237_1; tmp3_11 = tmp3_11 + s1_237_2;
    // Op 238: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_3; tmp3_10 = tmp3_10 * tmp1_3; tmp3_11 = tmp3_11 * tmp1_3;
    // Op 239: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 240: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 241: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 242: dim3x3 mul
    gl64_t s1_242_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_242_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_242_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA242 = (tmp3_0 + tmp3_1) * (s1_242_0 + s1_242_1);
    gl64_t kB242 = (tmp3_0 + tmp3_2) * (s1_242_0 + s1_242_2);
    gl64_t kC242 = (tmp3_1 + tmp3_2) * (s1_242_1 + s1_242_2);
    gl64_t kD242 = tmp3_0 * s1_242_0;
    gl64_t kE242 = tmp3_1 * s1_242_1;
    gl64_t kF242 = tmp3_2 * s1_242_2;
    gl64_t kG242 = kD242 - kE242;
    tmp3_12 = (kC242 + kG242) - kF242;
    tmp3_13 = ((((kA242 + kC242) - kE242) - kE242) - kD242);
    tmp3_14 = kB242 - kG242;
    // Op 243: dim3x1 mul
    gl64_t s0_243_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_243_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_243_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_243 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp3_0 = s0_243_0 * s1_243; tmp3_1 = s0_243_1 * s1_243; tmp3_2 = s0_243_2 * s1_243;
    // Op 244: dim3x1 add
    gl64_t s1_244 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_244; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 245: dim3x3 mul
    gl64_t s1_245_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_245_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_245_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA245 = (tmp3_0 + tmp3_1) * (s1_245_0 + s1_245_1);
    gl64_t kB245 = (tmp3_0 + tmp3_2) * (s1_245_0 + s1_245_2);
    gl64_t kC245 = (tmp3_1 + tmp3_2) * (s1_245_1 + s1_245_2);
    gl64_t kD245 = tmp3_0 * s1_245_0;
    gl64_t kE245 = tmp3_1 * s1_245_1;
    gl64_t kF245 = tmp3_2 * s1_245_2;
    gl64_t kG245 = kD245 - kE245;
    tmp3_0 = (kC245 + kG245) - kF245;
    tmp3_1 = ((((kA245 + kC245) - kE245) - kE245) - kD245);
    tmp3_2 = kB245 - kG245;
    // Op 246: dim3x1 add
    gl64_t s1_246 = *(gl64_t*)&expressions_params[9][13];
    tmp3_9 = tmp3_0 + s1_246; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 247: dim3x3 add
    gl64_t s1_247_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_247_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_247_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_247_0; tmp3_4 = tmp3_10 + s1_247_1; tmp3_5 = tmp3_11 + s1_247_2;
    // Op 248: dim3x1 mul
    gl64_t s0_248_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_248_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_248_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_248 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp3_0 = s0_248_0 * s1_248; tmp3_1 = s0_248_1 * s1_248; tmp3_2 = s0_248_2 * s1_248;
    // Op 249: dim3x1 add
    gl64_t s1_249 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_249; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 250: dim3x3 mul
    gl64_t s1_250_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_250_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_250_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA250 = (tmp3_0 + tmp3_1) * (s1_250_0 + s1_250_1);
    gl64_t kB250 = (tmp3_0 + tmp3_2) * (s1_250_0 + s1_250_2);
    gl64_t kC250 = (tmp3_1 + tmp3_2) * (s1_250_1 + s1_250_2);
    gl64_t kD250 = tmp3_0 * s1_250_0;
    gl64_t kE250 = tmp3_1 * s1_250_1;
    gl64_t kF250 = tmp3_2 * s1_250_2;
    gl64_t kG250 = kD250 - kE250;
    tmp3_0 = (kC250 + kG250) - kF250;
    tmp3_1 = ((((kA250 + kC250) - kE250) - kE250) - kD250);
    tmp3_2 = kB250 - kG250;
    // Op 251: dim3x1 add
    gl64_t s1_251 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_251; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 252: dim3x3 mul
    gl64_t s1_252_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_252_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_252_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA252 = (tmp3_0 + tmp3_1) * (s1_252_0 + s1_252_1);
    gl64_t kB252 = (tmp3_0 + tmp3_2) * (s1_252_0 + s1_252_2);
    gl64_t kC252 = (tmp3_1 + tmp3_2) * (s1_252_1 + s1_252_2);
    gl64_t kD252 = tmp3_0 * s1_252_0;
    gl64_t kE252 = tmp3_1 * s1_252_1;
    gl64_t kF252 = tmp3_2 * s1_252_2;
    gl64_t kG252 = kD252 - kE252;
    tmp3_0 = (kC252 + kG252) - kF252;
    tmp3_1 = ((((kA252 + kC252) - kE252) - kE252) - kD252);
    tmp3_2 = kB252 - kG252;
    // Op 253: dim1x1 mul
    gl64_t s0_253 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_253 = *(gl64_t*)&expressions_params[9][7];
    tmp1_3 = s0_253 * s1_253;
    // Op 254: dim1x1 add
    gl64_t s0_254 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_3 = s0_254 + tmp1_3;
    // Op 255: dim1x1 mul
    gl64_t s0_255 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_255 = *(gl64_t*)&expressions_params[9][8];
    tmp1_0 = s0_255 * s1_255;
    // Op 256: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_0;
    // Op 257: dim1x1 mul
    gl64_t s0_257 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_257 = *(gl64_t*)&expressions_params[9][1];
    tmp1_3 = s0_257 * s1_257;
    // Op 258: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 259: dim1x1 mul
    gl64_t s0_259 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_259 = *(gl64_t*)&expressions_params[9][9];
    tmp1_3 = s0_259 * s1_259;
    // Op 260: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 261: dim1x1 mul
    gl64_t s1_261 = *(gl64_t*)&expressions_params[9][10];
    tmp1_4 = tmp1_4 * s1_261;
    // Op 262: dim1x1 add
    tmp1_4 = tmp1_0 + tmp1_4;
    // Op 263: dim1x1 add
    gl64_t s0_263 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_263 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_263 + s1_263;
    // Op 264: dim1x1 mul
    gl64_t s1_264 = *(gl64_t*)&expressions_params[9][11];
    tmp1_0 = tmp1_0 * s1_264;
    // Op 265: dim1x1 add
    tmp1_0 = tmp1_4 + tmp1_0;
    // Op 266: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 267: dim3x3 mul
    gl64_t s1_267_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_267_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_267_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA267 = (tmp3_0 + tmp3_1) * (s1_267_0 + s1_267_1);
    gl64_t kB267 = (tmp3_0 + tmp3_2) * (s1_267_0 + s1_267_2);
    gl64_t kC267 = (tmp3_1 + tmp3_2) * (s1_267_1 + s1_267_2);
    gl64_t kD267 = tmp3_0 * s1_267_0;
    gl64_t kE267 = tmp3_1 * s1_267_1;
    gl64_t kF267 = tmp3_2 * s1_267_2;
    gl64_t kG267 = kD267 - kE267;
    tmp3_0 = (kC267 + kG267) - kF267;
    tmp3_1 = ((((kA267 + kC267) - kE267) - kE267) - kD267);
    tmp3_2 = kB267 - kG267;
    // Op 268: dim3x1 add
    gl64_t s1_268 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_268; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 269: dim3x3 mul
    gl64_t s1_269_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_269_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_269_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA269 = (tmp3_0 + tmp3_1) * (s1_269_0 + s1_269_1);
    gl64_t kB269 = (tmp3_0 + tmp3_2) * (s1_269_0 + s1_269_2);
    gl64_t kC269 = (tmp3_1 + tmp3_2) * (s1_269_1 + s1_269_2);
    gl64_t kD269 = tmp3_0 * s1_269_0;
    gl64_t kE269 = tmp3_1 * s1_269_1;
    gl64_t kF269 = tmp3_2 * s1_269_2;
    gl64_t kG269 = kD269 - kE269;
    tmp3_0 = (kC269 + kG269) - kF269;
    tmp3_1 = ((((kA269 + kC269) - kE269) - kE269) - kD269);
    tmp3_2 = kB269 - kG269;
    // Op 270: dim3x1 add
    gl64_t s1_270 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_270; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 271: dim3x3 mul
    gl64_t s1_271_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_271_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_271_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA271 = (tmp3_0 + tmp3_1) * (s1_271_0 + s1_271_1);
    gl64_t kB271 = (tmp3_0 + tmp3_2) * (s1_271_0 + s1_271_2);
    gl64_t kC271 = (tmp3_1 + tmp3_2) * (s1_271_1 + s1_271_2);
    gl64_t kD271 = tmp3_0 * s1_271_0;
    gl64_t kE271 = tmp3_1 * s1_271_1;
    gl64_t kF271 = tmp3_2 * s1_271_2;
    gl64_t kG271 = kD271 - kE271;
    tmp3_0 = (kC271 + kG271) - kF271;
    tmp3_1 = ((((kA271 + kC271) - kE271) - kE271) - kD271);
    tmp3_2 = kB271 - kG271;
    // Op 272: dim3x1 add
    gl64_t s1_272 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_272; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 273: dim3x3 mul
    gl64_t s1_273_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_273_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_273_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA273 = (tmp3_0 + tmp3_1) * (s1_273_0 + s1_273_1);
    gl64_t kB273 = (tmp3_0 + tmp3_2) * (s1_273_0 + s1_273_2);
    gl64_t kC273 = (tmp3_1 + tmp3_2) * (s1_273_1 + s1_273_2);
    gl64_t kD273 = tmp3_0 * s1_273_0;
    gl64_t kE273 = tmp3_1 * s1_273_1;
    gl64_t kF273 = tmp3_2 * s1_273_2;
    gl64_t kG273 = kD273 - kE273;
    tmp3_0 = (kC273 + kG273) - kF273;
    tmp3_1 = ((((kA273 + kC273) - kE273) - kE273) - kD273);
    tmp3_2 = kB273 - kG273;
    // Op 274: dim3x1 add
    gl64_t s1_274 = *(gl64_t*)&expressions_params[9][12];
    tmp3_6 = tmp3_0 + s1_274; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 275: dim3x3 add
    gl64_t s1_275_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_275_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_275_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_275_0; tmp3_1 = tmp3_7 + s1_275_1; tmp3_2 = tmp3_8 + s1_275_2;
    // Op 276: dim3x3 mul
    gl64_t kA276 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB276 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC276 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD276 = tmp3_3 * tmp3_0;
    gl64_t kE276 = tmp3_4 * tmp3_1;
    gl64_t kF276 = tmp3_5 * tmp3_2;
    gl64_t kG276 = kD276 - kE276;
    tmp3_0 = (kC276 + kG276) - kF276;
    tmp3_1 = ((((kA276 + kC276) - kE276) - kE276) - kD276);
    tmp3_2 = kB276 - kG276;
    // Op 277: dim3x3 mul
    uint64_t s0_277_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_277_0 = *(gl64_t*)&dParams->aux_trace[s0_277_pos];
    gl64_t s0_277_1 = *(gl64_t*)&dParams->aux_trace[s0_277_pos + TILE_HEIGHT];
    gl64_t s0_277_2 = *(gl64_t*)&dParams->aux_trace[s0_277_pos + 2*TILE_HEIGHT];
    gl64_t kA277 = (s0_277_0 + s0_277_1) * (tmp3_0 + tmp3_1);
    gl64_t kB277 = (s0_277_0 + s0_277_2) * (tmp3_0 + tmp3_2);
    gl64_t kC277 = (s0_277_1 + s0_277_2) * (tmp3_1 + tmp3_2);
    gl64_t kD277 = s0_277_0 * tmp3_0;
    gl64_t kE277 = s0_277_1 * tmp3_1;
    gl64_t kF277 = s0_277_2 * tmp3_2;
    gl64_t kG277 = kD277 - kE277;
    tmp3_0 = (kC277 + kG277) - kF277;
    tmp3_1 = ((((kA277 + kC277) - kE277) - kE277) - kD277);
    tmp3_2 = kB277 - kG277;
    // Op 278: dim1x1 sub_swap
    gl64_t s1_278 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s1_278 - tmp1_8;
    // Op 279: dim3x3 add
    gl64_t s1_279_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_279_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_279_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_279_0; tmp3_7 = tmp3_7 + s1_279_1; tmp3_8 = tmp3_8 + s1_279_2;
    // Op 280: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 281: dim1x1 sub_swap
    gl64_t s1_281 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s1_281 - tmp1_8;
    // Op 282: dim3x3 add
    gl64_t s1_282_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_282_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_282_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_282_0; tmp3_10 = tmp3_10 + s1_282_1; tmp3_11 = tmp3_11 + s1_282_2;
    // Op 283: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 284: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 285: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 286: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 287: dim3x3 mul
    gl64_t s1_287_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_287_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_287_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA287 = (tmp3_0 + tmp3_1) * (s1_287_0 + s1_287_1);
    gl64_t kB287 = (tmp3_0 + tmp3_2) * (s1_287_0 + s1_287_2);
    gl64_t kC287 = (tmp3_1 + tmp3_2) * (s1_287_1 + s1_287_2);
    gl64_t kD287 = tmp3_0 * s1_287_0;
    gl64_t kE287 = tmp3_1 * s1_287_1;
    gl64_t kF287 = tmp3_2 * s1_287_2;
    gl64_t kG287 = kD287 - kE287;
    tmp3_3 = (kC287 + kG287) - kF287;
    tmp3_4 = ((((kA287 + kC287) - kE287) - kE287) - kD287);
    tmp3_5 = kB287 - kG287;
    // Op 288: dim3x1 mul
    gl64_t s0_288_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_288_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_288_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_288 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp3_0 = s0_288_0 * s1_288; tmp3_1 = s0_288_1 * s1_288; tmp3_2 = s0_288_2 * s1_288;
    // Op 289: dim3x1 add
    gl64_t s1_289 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_289; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_291 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
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
    // Op 294: dim3x3 mul
    gl64_t s1_294_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_294_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_294_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA294 = (tmp3_0 + tmp3_1) * (s1_294_0 + s1_294_1);
    gl64_t kB294 = (tmp3_0 + tmp3_2) * (s1_294_0 + s1_294_2);
    gl64_t kC294 = (tmp3_1 + tmp3_2) * (s1_294_1 + s1_294_2);
    gl64_t kD294 = tmp3_0 * s1_294_0;
    gl64_t kE294 = tmp3_1 * s1_294_1;
    gl64_t kF294 = tmp3_2 * s1_294_2;
    gl64_t kG294 = kD294 - kE294;
    tmp3_0 = (kC294 + kG294) - kF294;
    tmp3_1 = ((((kA294 + kC294) - kE294) - kE294) - kD294);
    tmp3_2 = kB294 - kG294;
    // Op 295: dim1x1 mul
    gl64_t s0_295 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_295 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_295 * s1_295;
    // Op 296: dim1x1 mul
    gl64_t s0_296 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_296 = *(gl64_t*)&expressions_params[9][1];
    tmp1_4 = s0_296 * s1_296;
    // Op 297: dim1x1 add
    tmp1_3 = tmp1_0 + tmp1_4;
    // Op 298: dim1x1 mul
    gl64_t s0_298 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_298 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s0_298 * s1_298;
    // Op 299: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_0;
    // Op 300: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 301: dim3x3 mul
    gl64_t s1_301_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_301_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_301_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA301 = (tmp3_0 + tmp3_1) * (s1_301_0 + s1_301_1);
    gl64_t kB301 = (tmp3_0 + tmp3_2) * (s1_301_0 + s1_301_2);
    gl64_t kC301 = (tmp3_1 + tmp3_2) * (s1_301_1 + s1_301_2);
    gl64_t kD301 = tmp3_0 * s1_301_0;
    gl64_t kE301 = tmp3_1 * s1_301_1;
    gl64_t kF301 = tmp3_2 * s1_301_2;
    gl64_t kG301 = kD301 - kE301;
    tmp3_0 = (kC301 + kG301) - kF301;
    tmp3_1 = ((((kA301 + kC301) - kE301) - kE301) - kD301);
    tmp3_2 = kB301 - kG301;
    // Op 302: dim3x3 mul
    gl64_t s1_302_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_302_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_302_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA302 = (tmp3_0 + tmp3_1) * (s1_302_0 + s1_302_1);
    gl64_t kB302 = (tmp3_0 + tmp3_2) * (s1_302_0 + s1_302_2);
    gl64_t kC302 = (tmp3_1 + tmp3_2) * (s1_302_1 + s1_302_2);
    gl64_t kD302 = tmp3_0 * s1_302_0;
    gl64_t kE302 = tmp3_1 * s1_302_1;
    gl64_t kF302 = tmp3_2 * s1_302_2;
    gl64_t kG302 = kD302 - kE302;
    tmp3_0 = (kC302 + kG302) - kF302;
    tmp3_1 = ((((kA302 + kC302) - kE302) - kE302) - kD302);
    tmp3_2 = kB302 - kG302;
    // Op 303: dim3x1 add
    gl64_t s1_303 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_303; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 305: dim3x3 mul
    gl64_t s1_305_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_305_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_305_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA305 = (tmp3_0 + tmp3_1) * (s1_305_0 + s1_305_1);
    gl64_t kB305 = (tmp3_0 + tmp3_2) * (s1_305_0 + s1_305_2);
    gl64_t kC305 = (tmp3_1 + tmp3_2) * (s1_305_1 + s1_305_2);
    gl64_t kD305 = tmp3_0 * s1_305_0;
    gl64_t kE305 = tmp3_1 * s1_305_1;
    gl64_t kF305 = tmp3_2 * s1_305_2;
    gl64_t kG305 = kD305 - kE305;
    tmp3_0 = (kC305 + kG305) - kF305;
    tmp3_1 = ((((kA305 + kC305) - kE305) - kE305) - kD305);
    tmp3_2 = kB305 - kG305;
    // Op 306: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 307: dim3x3 mul
    gl64_t s1_307_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_307_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_307_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA307 = (tmp3_0 + tmp3_1) * (s1_307_0 + s1_307_1);
    gl64_t kB307 = (tmp3_0 + tmp3_2) * (s1_307_0 + s1_307_2);
    gl64_t kC307 = (tmp3_1 + tmp3_2) * (s1_307_1 + s1_307_2);
    gl64_t kD307 = tmp3_0 * s1_307_0;
    gl64_t kE307 = tmp3_1 * s1_307_1;
    gl64_t kF307 = tmp3_2 * s1_307_2;
    gl64_t kG307 = kD307 - kE307;
    tmp3_0 = (kC307 + kG307) - kF307;
    tmp3_1 = ((((kA307 + kC307) - kE307) - kE307) - kD307);
    tmp3_2 = kB307 - kG307;
    // Op 308: dim1x1 mul
    gl64_t s0_308 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_308 = *(gl64_t*)&expressions_params[9][16];
    tmp1_0 = s0_308 * s1_308;
    // Op 309: dim1x1 mul
    gl64_t s0_309 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_309 = *(gl64_t*)&expressions_params[9][17];
    tmp1_4 = s0_309 * s1_309;
    // Op 310: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 311: dim1x1 mul
    gl64_t s0_311 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_311 = *(gl64_t*)&expressions_params[9][18];
    tmp1_4 = s0_311 * s1_311;
    // Op 312: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 313: dim1x1 mul
    gl64_t s0_313 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_313 = *(gl64_t*)&expressions_params[9][19];
    tmp1_4 = s0_313 * s1_313;
    // Op 314: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 315: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 316: dim3x3 mul
    gl64_t s1_316_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_316_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_316_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA316 = (tmp3_0 + tmp3_1) * (s1_316_0 + s1_316_1);
    gl64_t kB316 = (tmp3_0 + tmp3_2) * (s1_316_0 + s1_316_2);
    gl64_t kC316 = (tmp3_1 + tmp3_2) * (s1_316_1 + s1_316_2);
    gl64_t kD316 = tmp3_0 * s1_316_0;
    gl64_t kE316 = tmp3_1 * s1_316_1;
    gl64_t kF316 = tmp3_2 * s1_316_2;
    gl64_t kG316 = kD316 - kE316;
    tmp3_0 = (kC316 + kG316) - kF316;
    tmp3_1 = ((((kA316 + kC316) - kE316) - kE316) - kD316);
    tmp3_2 = kB316 - kG316;
    // Op 317: dim3x1 add
    gl64_t s1_317 = *(gl64_t*)&expressions_params[9][20];
    tmp3_9 = tmp3_0 + s1_317; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 318: dim3x3 add
    gl64_t s1_318_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_318_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_318_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_318_0; tmp3_13 = tmp3_10 + s1_318_1; tmp3_14 = tmp3_11 + s1_318_2;
    // Op 319: dim3x1 mul
    gl64_t s0_319_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_319_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_319_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_319 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    tmp3_0 = s0_319_0 * s1_319; tmp3_1 = s0_319_1 * s1_319; tmp3_2 = s0_319_2 * s1_319;
    // Op 320: dim3x1 add
    gl64_t s1_320 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
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
    gl64_t s1_322 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_322; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_324 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_324; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 326: dim3x1 add
    gl64_t s1_326 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_326; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 327: dim3x3 mul
    gl64_t s1_327_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_327_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_327_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA327 = (tmp3_0 + tmp3_1) * (s1_327_0 + s1_327_1);
    gl64_t kB327 = (tmp3_0 + tmp3_2) * (s1_327_0 + s1_327_2);
    gl64_t kC327 = (tmp3_1 + tmp3_2) * (s1_327_1 + s1_327_2);
    gl64_t kD327 = tmp3_0 * s1_327_0;
    gl64_t kE327 = tmp3_1 * s1_327_1;
    gl64_t kF327 = tmp3_2 * s1_327_2;
    gl64_t kG327 = kD327 - kE327;
    tmp3_0 = (kC327 + kG327) - kF327;
    tmp3_1 = ((((kA327 + kC327) - kE327) - kE327) - kD327);
    tmp3_2 = kB327 - kG327;
    // Op 328: dim3x1 add
    gl64_t s1_328 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_328; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 329: dim3x3 mul
    gl64_t s1_329_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_329_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_329_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA329 = (tmp3_0 + tmp3_1) * (s1_329_0 + s1_329_1);
    gl64_t kB329 = (tmp3_0 + tmp3_2) * (s1_329_0 + s1_329_2);
    gl64_t kC329 = (tmp3_1 + tmp3_2) * (s1_329_1 + s1_329_2);
    gl64_t kD329 = tmp3_0 * s1_329_0;
    gl64_t kE329 = tmp3_1 * s1_329_1;
    gl64_t kF329 = tmp3_2 * s1_329_2;
    gl64_t kG329 = kD329 - kE329;
    tmp3_0 = (kC329 + kG329) - kF329;
    tmp3_1 = ((((kA329 + kC329) - kE329) - kE329) - kD329);
    tmp3_2 = kB329 - kG329;
    // Op 330: dim3x1 add
    gl64_t s1_330 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_330; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 331: dim3x3 mul
    gl64_t s1_331_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_331_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_331_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA331 = (tmp3_0 + tmp3_1) * (s1_331_0 + s1_331_1);
    gl64_t kB331 = (tmp3_0 + tmp3_2) * (s1_331_0 + s1_331_2);
    gl64_t kC331 = (tmp3_1 + tmp3_2) * (s1_331_1 + s1_331_2);
    gl64_t kD331 = tmp3_0 * s1_331_0;
    gl64_t kE331 = tmp3_1 * s1_331_1;
    gl64_t kF331 = tmp3_2 * s1_331_2;
    gl64_t kG331 = kD331 - kE331;
    tmp3_0 = (kC331 + kG331) - kF331;
    tmp3_1 = ((((kA331 + kC331) - kE331) - kE331) - kD331);
    tmp3_2 = kB331 - kG331;
    // Op 332: dim3x1 add
    gl64_t s1_332 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_332; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = tmp3_0 + tmp1_5; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 335: dim3x3 mul
    gl64_t s1_335_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_335_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_335_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA335 = (tmp3_0 + tmp3_1) * (s1_335_0 + s1_335_1);
    gl64_t kB335 = (tmp3_0 + tmp3_2) * (s1_335_0 + s1_335_2);
    gl64_t kC335 = (tmp3_1 + tmp3_2) * (s1_335_1 + s1_335_2);
    gl64_t kD335 = tmp3_0 * s1_335_0;
    gl64_t kE335 = tmp3_1 * s1_335_1;
    gl64_t kF335 = tmp3_2 * s1_335_2;
    gl64_t kG335 = kD335 - kE335;
    tmp3_0 = (kC335 + kG335) - kF335;
    tmp3_1 = ((((kA335 + kC335) - kE335) - kE335) - kD335);
    tmp3_2 = kB335 - kG335;
    // Op 336: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_3; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 337: dim3x3 mul
    gl64_t s1_337_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_337_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_337_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA337 = (tmp3_0 + tmp3_1) * (s1_337_0 + s1_337_1);
    gl64_t kB337 = (tmp3_0 + tmp3_2) * (s1_337_0 + s1_337_2);
    gl64_t kC337 = (tmp3_1 + tmp3_2) * (s1_337_1 + s1_337_2);
    gl64_t kD337 = tmp3_0 * s1_337_0;
    gl64_t kE337 = tmp3_1 * s1_337_1;
    gl64_t kF337 = tmp3_2 * s1_337_2;
    gl64_t kG337 = kD337 - kE337;
    tmp3_0 = (kC337 + kG337) - kF337;
    tmp3_1 = ((((kA337 + kC337) - kE337) - kE337) - kD337);
    tmp3_2 = kB337 - kG337;
    // Op 338: dim1x1 mul
    gl64_t s0_338 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_338 = *(gl64_t*)&expressions_params[9][8];
    tmp1_0 = s0_338 * s1_338;
    // Op 339: dim1x1 add
    gl64_t s0_339 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_339 + tmp1_0;
    // Op 340: dim1x1 mul
    gl64_t s0_340 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_340 = *(gl64_t*)&expressions_params[9][14];
    tmp1_4 = s0_340 * s1_340;
    // Op 341: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 342: dim1x1 mul
    gl64_t s0_342 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_342 = *(gl64_t*)&expressions_params[9][7];
    tmp1_4 = s0_342 * s1_342;
    // Op 343: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 344: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 345: dim3x3 mul
    gl64_t s1_345_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_345_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_345_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA345 = (tmp3_0 + tmp3_1) * (s1_345_0 + s1_345_1);
    gl64_t kB345 = (tmp3_0 + tmp3_2) * (s1_345_0 + s1_345_2);
    gl64_t kC345 = (tmp3_1 + tmp3_2) * (s1_345_1 + s1_345_2);
    gl64_t kD345 = tmp3_0 * s1_345_0;
    gl64_t kE345 = tmp3_1 * s1_345_1;
    gl64_t kF345 = tmp3_2 * s1_345_2;
    gl64_t kG345 = kD345 - kE345;
    tmp3_0 = (kC345 + kG345) - kF345;
    tmp3_1 = ((((kA345 + kC345) - kE345) - kE345) - kD345);
    tmp3_2 = kB345 - kG345;
    // Op 346: dim3x1 add
    gl64_t s1_346 = *(gl64_t*)&expressions_params[9][15];
    tmp3_6 = tmp3_0 + s1_346; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 347: dim3x3 add
    gl64_t s1_347_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_347_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_347_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_347_0; tmp3_1 = tmp3_7 + s1_347_1; tmp3_2 = tmp3_8 + s1_347_2;
    // Op 348: dim3x3 mul
    gl64_t kA348 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB348 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC348 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD348 = tmp3_12 * tmp3_0;
    gl64_t kE348 = tmp3_13 * tmp3_1;
    gl64_t kF348 = tmp3_14 * tmp3_2;
    gl64_t kG348 = kD348 - kE348;
    tmp3_0 = (kC348 + kG348) - kF348;
    tmp3_1 = ((((kA348 + kC348) - kE348) - kE348) - kD348);
    tmp3_2 = kB348 - kG348;
    // Op 349: dim3x3 mul
    uint64_t s0_349_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_349_0 = *(gl64_t*)&dParams->aux_trace[s0_349_pos];
    gl64_t s0_349_1 = *(gl64_t*)&dParams->aux_trace[s0_349_pos + TILE_HEIGHT];
    gl64_t s0_349_2 = *(gl64_t*)&dParams->aux_trace[s0_349_pos + 2*TILE_HEIGHT];
    gl64_t kA349 = (s0_349_0 + s0_349_1) * (tmp3_0 + tmp3_1);
    gl64_t kB349 = (s0_349_0 + s0_349_2) * (tmp3_0 + tmp3_2);
    gl64_t kC349 = (s0_349_1 + s0_349_2) * (tmp3_1 + tmp3_2);
    gl64_t kD349 = s0_349_0 * tmp3_0;
    gl64_t kE349 = s0_349_1 * tmp3_1;
    gl64_t kF349 = s0_349_2 * tmp3_2;
    gl64_t kG349 = kD349 - kE349;
    tmp3_0 = (kC349 + kG349) - kF349;
    tmp3_1 = ((((kA349 + kC349) - kE349) - kE349) - kD349);
    tmp3_2 = kB349 - kG349;
    // Op 350: dim1x1 sub_swap
    gl64_t s0_350 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_350 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s1_350 - s0_350;
    // Op 351: dim3x3 add
    gl64_t s1_351_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_351_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_351_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_351_0; tmp3_7 = tmp3_7 + s1_351_1; tmp3_8 = tmp3_8 + s1_351_2;
    // Op 352: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 353: dim1x1 sub_swap
    gl64_t s0_353 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_353 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s1_353 - s0_353;
    // Op 354: dim3x3 add
    gl64_t s1_354_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_354_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_354_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_354_0; tmp3_10 = tmp3_10 + s1_354_1; tmp3_11 = tmp3_11 + s1_354_2;
    // Op 355: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 356: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 357: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 358: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 359: dim3x3 mul
    gl64_t s1_359_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_359_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_359_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA359 = (tmp3_0 + tmp3_1) * (s1_359_0 + s1_359_1);
    gl64_t kB359 = (tmp3_0 + tmp3_2) * (s1_359_0 + s1_359_2);
    gl64_t kC359 = (tmp3_1 + tmp3_2) * (s1_359_1 + s1_359_2);
    gl64_t kD359 = tmp3_0 * s1_359_0;
    gl64_t kE359 = tmp3_1 * s1_359_1;
    gl64_t kF359 = tmp3_2 * s1_359_2;
    gl64_t kG359 = kD359 - kE359;
    tmp3_12 = (kC359 + kG359) - kF359;
    tmp3_13 = ((((kA359 + kC359) - kE359) - kE359) - kD359);
    tmp3_14 = kB359 - kG359;
    // Op 360: dim3x1 mul
    gl64_t s0_360_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_360_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_360_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_360 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp3_0 = s0_360_0 * s1_360; tmp3_1 = s0_360_1 * s1_360; tmp3_2 = s0_360_2 * s1_360;
    // Op 361: dim3x1 add
    gl64_t s1_361 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_361; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 362: dim3x3 mul
    gl64_t s1_362_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_362_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_362_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA362 = (tmp3_0 + tmp3_1) * (s1_362_0 + s1_362_1);
    gl64_t kB362 = (tmp3_0 + tmp3_2) * (s1_362_0 + s1_362_2);
    gl64_t kC362 = (tmp3_1 + tmp3_2) * (s1_362_1 + s1_362_2);
    gl64_t kD362 = tmp3_0 * s1_362_0;
    gl64_t kE362 = tmp3_1 * s1_362_1;
    gl64_t kF362 = tmp3_2 * s1_362_2;
    gl64_t kG362 = kD362 - kE362;
    tmp3_0 = (kC362 + kG362) - kF362;
    tmp3_1 = ((((kA362 + kC362) - kE362) - kE362) - kD362);
    tmp3_2 = kB362 - kG362;
    // Op 363: dim3x1 add
    gl64_t s1_363 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_363; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 364: dim3x3 mul
    gl64_t s1_364_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_364_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_364_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA364 = (tmp3_0 + tmp3_1) * (s1_364_0 + s1_364_1);
    gl64_t kB364 = (tmp3_0 + tmp3_2) * (s1_364_0 + s1_364_2);
    gl64_t kC364 = (tmp3_1 + tmp3_2) * (s1_364_1 + s1_364_2);
    gl64_t kD364 = tmp3_0 * s1_364_0;
    gl64_t kE364 = tmp3_1 * s1_364_1;
    gl64_t kF364 = tmp3_2 * s1_364_2;
    gl64_t kG364 = kD364 - kE364;
    tmp3_0 = (kC364 + kG364) - kF364;
    tmp3_1 = ((((kA364 + kC364) - kE364) - kE364) - kD364);
    tmp3_2 = kB364 - kG364;
    // Op 365: dim3x1 add
    gl64_t s1_365 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_365; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 367: dim3x1 add
    gl64_t s1_367 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_367; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 368: dim3x3 mul
    gl64_t s1_368_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_368_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_368_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA368 = (tmp3_0 + tmp3_1) * (s1_368_0 + s1_368_1);
    gl64_t kB368 = (tmp3_0 + tmp3_2) * (s1_368_0 + s1_368_2);
    gl64_t kC368 = (tmp3_1 + tmp3_2) * (s1_368_1 + s1_368_2);
    gl64_t kD368 = tmp3_0 * s1_368_0;
    gl64_t kE368 = tmp3_1 * s1_368_1;
    gl64_t kF368 = tmp3_2 * s1_368_2;
    gl64_t kG368 = kD368 - kE368;
    tmp3_0 = (kC368 + kG368) - kF368;
    tmp3_1 = ((((kA368 + kC368) - kE368) - kE368) - kD368);
    tmp3_2 = kB368 - kG368;
    // Op 369: dim1x1 sub_swap
    gl64_t s0_369 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_0 = tmp1_7 - s0_369;
    // Op 370: dim1x1 mul
    gl64_t s0_370 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_370 = *(gl64_t*)&expressions_params[9][2];
    tmp1_4 = s0_370 * s1_370;
    // Op 371: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_4;
    // Op 372: dim1x1 mul
    gl64_t s0_372 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_372 = *(gl64_t*)&expressions_params[9][1];
    tmp1_4 = s0_372 * s1_372;
    // Op 373: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_4;
    // Op 374: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 375: dim3x3 mul
    gl64_t s1_375_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_375_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_375_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA375 = (tmp3_0 + tmp3_1) * (s1_375_0 + s1_375_1);
    gl64_t kB375 = (tmp3_0 + tmp3_2) * (s1_375_0 + s1_375_2);
    gl64_t kC375 = (tmp3_1 + tmp3_2) * (s1_375_1 + s1_375_2);
    gl64_t kD375 = tmp3_0 * s1_375_0;
    gl64_t kE375 = tmp3_1 * s1_375_1;
    gl64_t kF375 = tmp3_2 * s1_375_2;
    gl64_t kG375 = kD375 - kE375;
    tmp3_0 = (kC375 + kG375) - kF375;
    tmp3_1 = ((((kA375 + kC375) - kE375) - kE375) - kD375);
    tmp3_2 = kB375 - kG375;
    // Op 376: dim3x1 add
    gl64_t s1_376 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_376; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 377: dim3x3 mul
    gl64_t s1_377_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_377_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_377_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA377 = (tmp3_0 + tmp3_1) * (s1_377_0 + s1_377_1);
    gl64_t kB377 = (tmp3_0 + tmp3_2) * (s1_377_0 + s1_377_2);
    gl64_t kC377 = (tmp3_1 + tmp3_2) * (s1_377_1 + s1_377_2);
    gl64_t kD377 = tmp3_0 * s1_377_0;
    gl64_t kE377 = tmp3_1 * s1_377_1;
    gl64_t kF377 = tmp3_2 * s1_377_2;
    gl64_t kG377 = kD377 - kE377;
    tmp3_0 = (kC377 + kG377) - kF377;
    tmp3_1 = ((((kA377 + kC377) - kE377) - kE377) - kD377);
    tmp3_2 = kB377 - kG377;
    // Op 378: dim3x3 mul
    gl64_t s1_378_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_378_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_378_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA378 = (tmp3_0 + tmp3_1) * (s1_378_0 + s1_378_1);
    gl64_t kB378 = (tmp3_0 + tmp3_2) * (s1_378_0 + s1_378_2);
    gl64_t kC378 = (tmp3_1 + tmp3_2) * (s1_378_1 + s1_378_2);
    gl64_t kD378 = tmp3_0 * s1_378_0;
    gl64_t kE378 = tmp3_1 * s1_378_1;
    gl64_t kF378 = tmp3_2 * s1_378_2;
    gl64_t kG378 = kD378 - kE378;
    tmp3_0 = (kC378 + kG378) - kF378;
    tmp3_1 = ((((kA378 + kC378) - kE378) - kE378) - kD378);
    tmp3_2 = kB378 - kG378;
    // Op 379: dim1x1 mul
    gl64_t s0_379 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_379 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s0_379 * s1_379;
    // Op 380: dim1x1 add
    tmp1_0 = tmp1_5 + tmp1_0;
    // Op 381: dim1x1 mul
    gl64_t s0_381 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_381 = *(gl64_t*)&expressions_params[9][1];
    tmp1_5 = s0_381 * s1_381;
    // Op 382: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_5;
    // Op 383: dim1x1 mul
    gl64_t s0_383 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_383 = *(gl64_t*)&expressions_params[9][2];
    tmp1_5 = s0_383 * s1_383;
    // Op 384: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_5;
    // Op 385: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 386: dim3x3 mul
    gl64_t s1_386_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_386_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_386_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA386 = (tmp3_0 + tmp3_1) * (s1_386_0 + s1_386_1);
    gl64_t kB386 = (tmp3_0 + tmp3_2) * (s1_386_0 + s1_386_2);
    gl64_t kC386 = (tmp3_1 + tmp3_2) * (s1_386_1 + s1_386_2);
    gl64_t kD386 = tmp3_0 * s1_386_0;
    gl64_t kE386 = tmp3_1 * s1_386_1;
    gl64_t kF386 = tmp3_2 * s1_386_2;
    gl64_t kG386 = kD386 - kE386;
    tmp3_0 = (kC386 + kG386) - kF386;
    tmp3_1 = ((((kA386 + kC386) - kE386) - kE386) - kD386);
    tmp3_2 = kB386 - kG386;
    // Op 387: dim1x1 mul
    gl64_t s0_387 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_387 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s0_387 * s1_387;
    // Op 388: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_0;
    // Op 389: dim1x1 mul
    gl64_t s0_389 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_389 = *(gl64_t*)&expressions_params[9][1];
    tmp1_3 = s0_389 * s1_389;
    // Op 390: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 391: dim1x1 mul
    gl64_t s0_391 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_391 = *(gl64_t*)&expressions_params[9][2];
    tmp1_3 = s0_391 * s1_391;
    // Op 392: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 393: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 394: dim3x3 mul
    gl64_t s1_394_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_394_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_394_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA394 = (tmp3_0 + tmp3_1) * (s1_394_0 + s1_394_1);
    gl64_t kB394 = (tmp3_0 + tmp3_2) * (s1_394_0 + s1_394_2);
    gl64_t kC394 = (tmp3_1 + tmp3_2) * (s1_394_1 + s1_394_2);
    gl64_t kD394 = tmp3_0 * s1_394_0;
    gl64_t kE394 = tmp3_1 * s1_394_1;
    gl64_t kF394 = tmp3_2 * s1_394_2;
    gl64_t kG394 = kD394 - kE394;
    tmp3_0 = (kC394 + kG394) - kF394;
    tmp3_1 = ((((kA394 + kC394) - kE394) - kE394) - kD394);
    tmp3_2 = kB394 - kG394;
    // Op 395: dim1x1 mul
    gl64_t s0_395 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_395 = *(gl64_t*)&expressions_params[9][8];
    tmp1_0 = s0_395 * s1_395;
    // Op 396: dim1x1 add
    gl64_t s0_396 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_396 + tmp1_0;
    // Op 397: dim1x1 mul
    gl64_t s0_397 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_397 = *(gl64_t*)&expressions_params[9][14];
    tmp1_3 = s0_397 * s1_397;
    // Op 398: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 399: dim1x1 mul
    gl64_t s0_399 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_399 = *(gl64_t*)&expressions_params[9][7];
    tmp1_3 = s0_399 * s1_399;
    // Op 400: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 401: dim1x1 add
    gl64_t s1_401 = *(gl64_t*)&expressions_params[9][23];
    tmp1_0 = tmp1_0 + s1_401;
    // Op 402: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_404 = *(gl64_t*)&expressions_params[9][15];
    tmp3_9 = tmp3_0 + s1_404; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 405: dim3x3 add
    gl64_t s1_405_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_405_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_405_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_405_0; tmp3_4 = tmp3_10 + s1_405_1; tmp3_5 = tmp3_11 + s1_405_2;
    // Op 406: dim3x1 mul
    gl64_t s0_406_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_406_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_406_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_406_0 * tmp1_1; tmp3_1 = s0_406_1 * tmp1_1; tmp3_2 = s0_406_2 * tmp1_1;
    // Op 407: dim3x1 add
    gl64_t s1_407 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_407; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 408: dim3x3 mul
    gl64_t s1_408_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_408_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_408_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA408 = (tmp3_0 + tmp3_1) * (s1_408_0 + s1_408_1);
    gl64_t kB408 = (tmp3_0 + tmp3_2) * (s1_408_0 + s1_408_2);
    gl64_t kC408 = (tmp3_1 + tmp3_2) * (s1_408_1 + s1_408_2);
    gl64_t kD408 = tmp3_0 * s1_408_0;
    gl64_t kE408 = tmp3_1 * s1_408_1;
    gl64_t kF408 = tmp3_2 * s1_408_2;
    gl64_t kG408 = kD408 - kE408;
    tmp3_0 = (kC408 + kG408) - kF408;
    tmp3_1 = ((((kA408 + kC408) - kE408) - kE408) - kD408);
    tmp3_2 = kB408 - kG408;
    // Op 409: dim1x1 mul
    gl64_t s0_409 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_409 = *(gl64_t*)&expressions_params[9][8];
    tmp1_1 = s0_409 * s1_409;
    // Op 410: dim1x1 add
    gl64_t s1_410 = *(gl64_t*)&expressions_params[9][21];
    tmp1_1 = tmp1_1 + s1_410;
    // Op 411: dim1x1 add
    gl64_t s1_411 = *(gl64_t*)&expressions_params[9][7];
    tmp1_1 = tmp1_1 + s1_411;
    // Op 412: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 413: dim3x3 mul
    gl64_t s1_413_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_413_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_413_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA413 = (tmp3_0 + tmp3_1) * (s1_413_0 + s1_413_1);
    gl64_t kB413 = (tmp3_0 + tmp3_2) * (s1_413_0 + s1_413_2);
    gl64_t kC413 = (tmp3_1 + tmp3_2) * (s1_413_1 + s1_413_2);
    gl64_t kD413 = tmp3_0 * s1_413_0;
    gl64_t kE413 = tmp3_1 * s1_413_1;
    gl64_t kF413 = tmp3_2 * s1_413_2;
    gl64_t kG413 = kD413 - kE413;
    tmp3_0 = (kC413 + kG413) - kF413;
    tmp3_1 = ((((kA413 + kC413) - kE413) - kE413) - kD413);
    tmp3_2 = kB413 - kG413;
    // Op 414: dim3x1 add
    gl64_t s1_414 = *(gl64_t*)&expressions_params[9][22];
    tmp3_0 = tmp3_0 + s1_414; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 415: dim3x3 mul
    gl64_t s1_415_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_415_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_415_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA415 = (tmp3_0 + tmp3_1) * (s1_415_0 + s1_415_1);
    gl64_t kB415 = (tmp3_0 + tmp3_2) * (s1_415_0 + s1_415_2);
    gl64_t kC415 = (tmp3_1 + tmp3_2) * (s1_415_1 + s1_415_2);
    gl64_t kD415 = tmp3_0 * s1_415_0;
    gl64_t kE415 = tmp3_1 * s1_415_1;
    gl64_t kF415 = tmp3_2 * s1_415_2;
    gl64_t kG415 = kD415 - kE415;
    tmp3_0 = (kC415 + kG415) - kF415;
    tmp3_1 = ((((kA415 + kC415) - kE415) - kE415) - kD415);
    tmp3_2 = kB415 - kG415;
    // Op 416: dim3x1 add
    gl64_t s1_416 = *(gl64_t*)&expressions_params[9][21];
    tmp3_0 = tmp3_0 + s1_416; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 417: dim3x3 mul
    gl64_t s1_417_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_417_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_417_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA417 = (tmp3_0 + tmp3_1) * (s1_417_0 + s1_417_1);
    gl64_t kB417 = (tmp3_0 + tmp3_2) * (s1_417_0 + s1_417_2);
    gl64_t kC417 = (tmp3_1 + tmp3_2) * (s1_417_1 + s1_417_2);
    gl64_t kD417 = tmp3_0 * s1_417_0;
    gl64_t kE417 = tmp3_1 * s1_417_1;
    gl64_t kF417 = tmp3_2 * s1_417_2;
    gl64_t kG417 = kD417 - kE417;
    tmp3_0 = (kC417 + kG417) - kF417;
    tmp3_1 = ((((kA417 + kC417) - kE417) - kE417) - kD417);
    tmp3_2 = kB417 - kG417;
    // Op 418: dim3x1 add
    gl64_t s1_418 = *(gl64_t*)&expressions_params[9][23];
    tmp3_6 = tmp3_0 + s1_418; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 419: dim3x3 add
    gl64_t s1_419_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_419_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_419_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_419_0; tmp3_1 = tmp3_7 + s1_419_1; tmp3_2 = tmp3_8 + s1_419_2;
    // Op 420: dim3x3 mul
    gl64_t kA420 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB420 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC420 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD420 = tmp3_3 * tmp3_0;
    gl64_t kE420 = tmp3_4 * tmp3_1;
    gl64_t kF420 = tmp3_5 * tmp3_2;
    gl64_t kG420 = kD420 - kE420;
    tmp3_0 = (kC420 + kG420) - kF420;
    tmp3_1 = ((((kA420 + kC420) - kE420) - kE420) - kD420);
    tmp3_2 = kB420 - kG420;
    // Op 421: dim3x3 mul
    gl64_t s0_421_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_421_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_421_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    gl64_t kA421 = (s0_421_0 + s0_421_1) * (tmp3_0 + tmp3_1);
    gl64_t kB421 = (s0_421_0 + s0_421_2) * (tmp3_0 + tmp3_2);
    gl64_t kC421 = (s0_421_1 + s0_421_2) * (tmp3_1 + tmp3_2);
    gl64_t kD421 = s0_421_0 * tmp3_0;
    gl64_t kE421 = s0_421_1 * tmp3_1;
    gl64_t kF421 = s0_421_2 * tmp3_2;
    gl64_t kG421 = kD421 - kE421;
    tmp3_0 = (kC421 + kG421) - kF421;
    tmp3_1 = ((((kA421 + kC421) - kE421) - kE421) - kD421);
    tmp3_2 = kB421 - kG421;
    // Op 422: dim1x1 sub_swap
    gl64_t s0_422 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_422 = *(gl64_t*)&expressions_params[9][4];
    tmp1_1 = s1_422 - s0_422;
    // Op 423: dim3x3 add
    gl64_t s1_423_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_423_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_423_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_423_0; tmp3_7 = tmp3_7 + s1_423_1; tmp3_8 = tmp3_8 + s1_423_2;
    // Op 424: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_1; tmp3_7 = tmp3_7 * tmp1_1; tmp3_8 = tmp3_8 * tmp1_1;
    // Op 425: dim1x1 sub_swap
    gl64_t s1_425 = *(gl64_t*)&expressions_params[9][4];
    tmp1_6 = s1_425 - tmp1_6;
    // Op 426: dim3x3 add
    gl64_t s1_426_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_426_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_426_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_426_0; tmp3_10 = tmp3_10 + s1_426_1; tmp3_11 = tmp3_11 + s1_426_2;
    // Op 427: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_6; tmp3_10 = tmp3_10 * tmp1_6; tmp3_11 = tmp3_11 * tmp1_6;
    // Op 428: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 429: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 430: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 431: dim3x3 mul
    gl64_t s1_431_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_431_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_431_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA431 = (tmp3_0 + tmp3_1) * (s1_431_0 + s1_431_1);
    gl64_t kB431 = (tmp3_0 + tmp3_2) * (s1_431_0 + s1_431_2);
    gl64_t kC431 = (tmp3_1 + tmp3_2) * (s1_431_1 + s1_431_2);
    gl64_t kD431 = tmp3_0 * s1_431_0;
    gl64_t kE431 = tmp3_1 * s1_431_1;
    gl64_t kF431 = tmp3_2 * s1_431_2;
    gl64_t kG431 = kD431 - kE431;
    tmp3_12 = (kC431 + kG431) - kF431;
    tmp3_13 = ((((kA431 + kC431) - kE431) - kE431) - kD431);
    tmp3_14 = kB431 - kG431;
    // Op 432: dim1x1 add
    gl64_t s0_432 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_432 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_6 = s0_432 + s1_432;
    // Op 433: dim1x1 mul
    gl64_t s0_433 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    tmp1_6 = s0_433 * tmp1_6;
    // Op 434: dim1x1 mul
    gl64_t s0_434 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_434 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_1 = s0_434 * s1_434;
    // Op 435: dim1x1 add
    tmp1_1 = tmp1_6 + tmp1_1;
    // Op 436: dim3x1 mul
    gl64_t s0_436_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_436_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_436_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_436_0 * tmp1_1; tmp3_1 = s0_436_1 * tmp1_1; tmp3_2 = s0_436_2 * tmp1_1;
    // Op 437: dim3x1 add
    gl64_t s1_437 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_437; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 438: dim3x3 mul
    gl64_t s1_438_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_438_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_438_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA438 = (tmp3_0 + tmp3_1) * (s1_438_0 + s1_438_1);
    gl64_t kB438 = (tmp3_0 + tmp3_2) * (s1_438_0 + s1_438_2);
    gl64_t kC438 = (tmp3_1 + tmp3_2) * (s1_438_1 + s1_438_2);
    gl64_t kD438 = tmp3_0 * s1_438_0;
    gl64_t kE438 = tmp3_1 * s1_438_1;
    gl64_t kF438 = tmp3_2 * s1_438_2;
    gl64_t kG438 = kD438 - kE438;
    tmp3_0 = (kC438 + kG438) - kF438;
    tmp3_1 = ((((kA438 + kC438) - kE438) - kE438) - kD438);
    tmp3_2 = kB438 - kG438;
    // Op 439: dim3x3 mul
    gl64_t s1_439_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_439_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_439_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA439 = (tmp3_0 + tmp3_1) * (s1_439_0 + s1_439_1);
    gl64_t kB439 = (tmp3_0 + tmp3_2) * (s1_439_0 + s1_439_2);
    gl64_t kC439 = (tmp3_1 + tmp3_2) * (s1_439_1 + s1_439_2);
    gl64_t kD439 = tmp3_0 * s1_439_0;
    gl64_t kE439 = tmp3_1 * s1_439_1;
    gl64_t kF439 = tmp3_2 * s1_439_2;
    gl64_t kG439 = kD439 - kE439;
    tmp3_0 = (kC439 + kG439) - kF439;
    tmp3_1 = ((((kA439 + kC439) - kE439) - kE439) - kD439);
    tmp3_2 = kB439 - kG439;
    // Op 440: dim1x1 add
    gl64_t s0_440 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_440 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp1_6 = s0_440 + s1_440;
    // Op 441: dim1x1 sub_swap
    gl64_t s0_441 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_441 = *(gl64_t*)&expressions_params[9][21];
    tmp1_1 = s1_441 - s0_441;
    // Op 442: dim1x1 mul
    gl64_t s0_442 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_1 = s0_442 * tmp1_1;
    // Op 443: dim1x1 add
    tmp1_1 = tmp1_6 + tmp1_1;
    // Op 444: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 445: dim3x3 mul
    gl64_t s1_445_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_445_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_445_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA445 = (tmp3_0 + tmp3_1) * (s1_445_0 + s1_445_1);
    gl64_t kB445 = (tmp3_0 + tmp3_2) * (s1_445_0 + s1_445_2);
    gl64_t kC445 = (tmp3_1 + tmp3_2) * (s1_445_1 + s1_445_2);
    gl64_t kD445 = tmp3_0 * s1_445_0;
    gl64_t kE445 = tmp3_1 * s1_445_1;
    gl64_t kF445 = tmp3_2 * s1_445_2;
    gl64_t kG445 = kD445 - kE445;
    tmp3_0 = (kC445 + kG445) - kF445;
    tmp3_1 = ((((kA445 + kC445) - kE445) - kE445) - kD445);
    tmp3_2 = kB445 - kG445;
    // Op 446: dim1x1 add
    gl64_t s0_446 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_446 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp1_0 = s0_446 + s1_446;
    // Op 447: dim1x1 mul
    gl64_t s0_447 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_447 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s0_447 * s1_447;
    // Op 448: dim1x1 mul
    gl64_t s0_448 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_448 = *(gl64_t*)&expressions_params[9][1];
    tmp1_6 = s0_448 * s1_448;
    // Op 449: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_6;
    // Op 450: dim1x1 add
    gl64_t s0_450 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_6 = s0_450 + tmp1_1;
    // Op 451: dim1x1 sub_swap
    gl64_t s0_451 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_451 = *(gl64_t*)&expressions_params[9][21];
    tmp1_1 = s1_451 - s0_451;
    // Op 452: dim1x1 mul
    tmp1_1 = tmp1_6 * tmp1_1;
    // Op 453: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 454: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 456: dim3x1 add
    gl64_t s1_456 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_456; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 457: dim3x3 mul
    gl64_t s1_457_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_457_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_457_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA457 = (tmp3_0 + tmp3_1) * (s1_457_0 + s1_457_1);
    gl64_t kB457 = (tmp3_0 + tmp3_2) * (s1_457_0 + s1_457_2);
    gl64_t kC457 = (tmp3_1 + tmp3_2) * (s1_457_1 + s1_457_2);
    gl64_t kD457 = tmp3_0 * s1_457_0;
    gl64_t kE457 = tmp3_1 * s1_457_1;
    gl64_t kF457 = tmp3_2 * s1_457_2;
    gl64_t kG457 = kD457 - kE457;
    tmp3_0 = (kC457 + kG457) - kF457;
    tmp3_1 = ((((kA457 + kC457) - kE457) - kE457) - kD457);
    tmp3_2 = kB457 - kG457;
    // Op 458: dim1x1 mul
    gl64_t s0_458 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_458 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_458 * s1_458;
    // Op 459: dim1x1 mul
    gl64_t s0_459 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    gl64_t s1_459 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s0_459 * s1_459;
    // Op 460: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 461: dim1x1 add
    gl64_t s0_461 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_461 + tmp1_0;
    // Op 462: dim1x1 add
    gl64_t s0_462 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_462 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_1 = s0_462 + s1_462;
    // Op 463: dim1x1 mul
    tmp1_1 = tmp1_0 * tmp1_1;
    // Op 464: dim1x1 add
    gl64_t s0_464 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_464 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_464 + s1_464;
    // Op 465: dim1x1 mul
    tmp1_0 = tmp1_7 * tmp1_0;
    // Op 466: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 467: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 468: dim3x3 mul
    gl64_t s1_468_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_468_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_468_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA468 = (tmp3_0 + tmp3_1) * (s1_468_0 + s1_468_1);
    gl64_t kB468 = (tmp3_0 + tmp3_2) * (s1_468_0 + s1_468_2);
    gl64_t kC468 = (tmp3_1 + tmp3_2) * (s1_468_1 + s1_468_2);
    gl64_t kD468 = tmp3_0 * s1_468_0;
    gl64_t kE468 = tmp3_1 * s1_468_1;
    gl64_t kF468 = tmp3_2 * s1_468_2;
    gl64_t kG468 = kD468 - kE468;
    tmp3_0 = (kC468 + kG468) - kF468;
    tmp3_1 = ((((kA468 + kC468) - kE468) - kE468) - kD468);
    tmp3_2 = kB468 - kG468;
    // Op 469: dim3x1 add
    gl64_t s1_469 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_469; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 470: dim3x3 mul
    gl64_t s1_470_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_470_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_470_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA470 = (tmp3_0 + tmp3_1) * (s1_470_0 + s1_470_1);
    gl64_t kB470 = (tmp3_0 + tmp3_2) * (s1_470_0 + s1_470_2);
    gl64_t kC470 = (tmp3_1 + tmp3_2) * (s1_470_1 + s1_470_2);
    gl64_t kD470 = tmp3_0 * s1_470_0;
    gl64_t kE470 = tmp3_1 * s1_470_1;
    gl64_t kF470 = tmp3_2 * s1_470_2;
    gl64_t kG470 = kD470 - kE470;
    tmp3_0 = (kC470 + kG470) - kF470;
    tmp3_1 = ((((kA470 + kC470) - kE470) - kE470) - kD470);
    tmp3_2 = kB470 - kG470;
    // Op 471: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_6; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 472: dim3x3 mul
    gl64_t s1_472_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_472_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_472_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA472 = (tmp3_0 + tmp3_1) * (s1_472_0 + s1_472_1);
    gl64_t kB472 = (tmp3_0 + tmp3_2) * (s1_472_0 + s1_472_2);
    gl64_t kC472 = (tmp3_1 + tmp3_2) * (s1_472_1 + s1_472_2);
    gl64_t kD472 = tmp3_0 * s1_472_0;
    gl64_t kE472 = tmp3_1 * s1_472_1;
    gl64_t kF472 = tmp3_2 * s1_472_2;
    gl64_t kG472 = kD472 - kE472;
    tmp3_0 = (kC472 + kG472) - kF472;
    tmp3_1 = ((((kA472 + kC472) - kE472) - kE472) - kD472);
    tmp3_2 = kB472 - kG472;
    // Op 473: dim1x1 mul
    gl64_t s0_473 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_473 = *(gl64_t*)&expressions_params[9][24];
    tmp1_6 = s0_473 * s1_473;
    // Op 474: dim1x1 mul
    gl64_t s0_474 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_474 = *(gl64_t*)&expressions_params[9][25];
    tmp1_0 = s0_474 * s1_474;
    // Op 475: dim1x1 add
    tmp1_0 = tmp1_6 + tmp1_0;
    // Op 476: dim1x1 mul
    gl64_t s0_476 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_476 = *(gl64_t*)&expressions_params[9][26];
    tmp1_6 = s0_476 * s1_476;
    // Op 477: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_6;
    // Op 478: dim1x1 mul
    gl64_t s0_478 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_478 = *(gl64_t*)&expressions_params[9][27];
    tmp1_6 = s0_478 * s1_478;
    // Op 479: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_6;
    // Op 480: dim1x1 mul
    gl64_t s0_480 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_480 = *(gl64_t*)&expressions_params[9][19];
    tmp1_6 = s0_480 * s1_480;
    // Op 481: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_6;
    // Op 482: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 483: dim3x3 mul
    gl64_t s1_483_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_483_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_483_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA483 = (tmp3_0 + tmp3_1) * (s1_483_0 + s1_483_1);
    gl64_t kB483 = (tmp3_0 + tmp3_2) * (s1_483_0 + s1_483_2);
    gl64_t kC483 = (tmp3_1 + tmp3_2) * (s1_483_1 + s1_483_2);
    gl64_t kD483 = tmp3_0 * s1_483_0;
    gl64_t kE483 = tmp3_1 * s1_483_1;
    gl64_t kF483 = tmp3_2 * s1_483_2;
    gl64_t kG483 = kD483 - kE483;
    tmp3_0 = (kC483 + kG483) - kF483;
    tmp3_1 = ((((kA483 + kC483) - kE483) - kE483) - kD483);
    tmp3_2 = kB483 - kG483;
    // Op 484: dim3x1 add
    gl64_t s1_484 = *(gl64_t*)&expressions_params[9][20];
    tmp3_0 = tmp3_0 + s1_484; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 485: dim3x3 add
    gl64_t s1_485_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_485_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_485_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_485_0; tmp3_1 = tmp3_1 + s1_485_1; tmp3_2 = tmp3_2 + s1_485_2;
    // Op 486: dim3x3 mul
    gl64_t s0_486_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+0, domainSize, nCols_2))];
    gl64_t s0_486_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+1, domainSize, nCols_2))];
    gl64_t s0_486_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+2, domainSize, nCols_2))];
    gl64_t kA486 = (s0_486_0 + s0_486_1) * (tmp3_0 + tmp3_1);
    gl64_t kB486 = (s0_486_0 + s0_486_2) * (tmp3_0 + tmp3_2);
    gl64_t kC486 = (s0_486_1 + s0_486_2) * (tmp3_1 + tmp3_2);
    gl64_t kD486 = s0_486_0 * tmp3_0;
    gl64_t kE486 = s0_486_1 * tmp3_1;
    gl64_t kF486 = s0_486_2 * tmp3_2;
    gl64_t kG486 = kD486 - kE486;
    tmp3_0 = (kC486 + kG486) - kF486;
    tmp3_1 = ((((kA486 + kC486) - kE486) - kE486) - kD486);
    tmp3_2 = kB486 - kG486;
    // Op 487: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_8; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 488: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
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
    // Op 490: dim1x1 sub_swap
    gl64_t s0_490 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_490 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_490 - s0_490;
    // Op 491: dim3x1 mul
    uint64_t s0_491_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_491_0 = *(gl64_t*)&dParams->aux_trace[s0_491_pos];
    gl64_t s0_491_1 = *(gl64_t*)&dParams->aux_trace[s0_491_pos + TILE_HEIGHT];
    gl64_t s0_491_2 = *(gl64_t*)&dParams->aux_trace[s0_491_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_491_0 * tmp1_0; tmp3_1 = s0_491_1 * tmp1_0; tmp3_2 = s0_491_2 * tmp1_0;
    // Op 492: dim3x3 sub
    uint64_t s0_492_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_492_0 = *(gl64_t*)&dParams->aux_trace[s0_492_pos];
    gl64_t s0_492_1 = *(gl64_t*)&dParams->aux_trace[s0_492_pos + TILE_HEIGHT];
    gl64_t s0_492_2 = *(gl64_t*)&dParams->aux_trace[s0_492_pos + 2*TILE_HEIGHT];
    tmp3_12 = s0_492_0 - tmp3_0; tmp3_13 = s0_492_1 - tmp3_1; tmp3_14 = s0_492_2 - tmp3_2;
    // Op 493: dim3x3 add
    gl64_t s0_493_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_493_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_493_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_493_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_493_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_493_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_0 = s0_493_0 + s1_493_0; tmp3_1 = s0_493_1 + s1_493_1; tmp3_2 = s0_493_2 + s1_493_2;
    // Op 494: dim3x3 add
    uint64_t s0_494_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_494_0 = *(gl64_t*)&dParams->aux_trace[s0_494_pos];
    gl64_t s0_494_1 = *(gl64_t*)&dParams->aux_trace[s0_494_pos + TILE_HEIGHT];
    gl64_t s0_494_2 = *(gl64_t*)&dParams->aux_trace[s0_494_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_494_0 + tmp3_0; tmp3_1 = s0_494_1 + tmp3_1; tmp3_2 = s0_494_2 + tmp3_2;
    // Op 495: dim3x3 add
    uint64_t s0_495_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_495_0 = *(gl64_t*)&dParams->aux_trace[s0_495_pos];
    gl64_t s0_495_1 = *(gl64_t*)&dParams->aux_trace[s0_495_pos + TILE_HEIGHT];
    gl64_t s0_495_2 = *(gl64_t*)&dParams->aux_trace[s0_495_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_495_0 + tmp3_0; tmp3_1 = s0_495_1 + tmp3_1; tmp3_2 = s0_495_2 + tmp3_2;
    // Op 496: dim3x3 add
    gl64_t s0_496_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_496_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_496_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    tmp3_0 = s0_496_0 + tmp3_0; tmp3_1 = s0_496_1 + tmp3_1; tmp3_2 = s0_496_2 + tmp3_2;
    // Op 497: dim3x3 add
    gl64_t s0_497_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+0, domainSize, nCols_2))];
    gl64_t s0_497_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+1, domainSize, nCols_2))];
    gl64_t s0_497_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+2, domainSize, nCols_2))];
    tmp3_0 = s0_497_0 + tmp3_0; tmp3_1 = s0_497_1 + tmp3_1; tmp3_2 = s0_497_2 + tmp3_2;
    // Op 498: dim3x3 sub
    tmp3_12 = tmp3_12 - tmp3_0; tmp3_13 = tmp3_13 - tmp3_1; tmp3_14 = tmp3_14 - tmp3_2;
    // Op 499: dim3x1 mul
    gl64_t s0_499_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_499_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_499_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_499 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp3_0 = s0_499_0 * s1_499; tmp3_1 = s0_499_1 * s1_499; tmp3_2 = s0_499_2 * s1_499;
    // Op 500: dim3x1 add
    gl64_t s1_500 = *(gl64_t*)&expressions_params[9][28];
    tmp3_0 = tmp3_0 + s1_500; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 501: dim3x3 add
    gl64_t s1_501_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_501_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_501_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_501_0; tmp3_1 = tmp3_1 + s1_501_1; tmp3_2 = tmp3_2 + s1_501_2;
    // Op 502: dim3x3 mul
    gl64_t kA502 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB502 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC502 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD502 = tmp3_12 * tmp3_0;
    gl64_t kE502 = tmp3_13 * tmp3_1;
    gl64_t kF502 = tmp3_14 * tmp3_2;
    gl64_t kG502 = kD502 - kE502;
    tmp3_0 = (kC502 + kG502) - kF502;
    tmp3_1 = ((((kA502 + kC502) - kE502) - kE502) - kD502);
    tmp3_2 = kB502 - kG502;
    // Op 503: dim1x1 sub_swap
    gl64_t s1_503 = *(gl64_t*)&expressions_params[9][4];
    tmp1_8 = s1_503 - tmp1_8;
    // Op 504: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_8; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 505: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 506: dim3x3 mul
    gl64_t s1_506_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_506_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_506_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA506 = (tmp3_0 + tmp3_1) * (s1_506_0 + s1_506_1);
    gl64_t kB506 = (tmp3_0 + tmp3_2) * (s1_506_0 + s1_506_2);
    gl64_t kC506 = (tmp3_1 + tmp3_2) * (s1_506_1 + s1_506_2);
    gl64_t kD506 = tmp3_0 * s1_506_0;
    gl64_t kE506 = tmp3_1 * s1_506_1;
    gl64_t kF506 = tmp3_2 * s1_506_2;
    gl64_t kG506 = kD506 - kE506;
    tmp3_6 = (kC506 + kG506) - kF506;
    tmp3_7 = ((((kA506 + kC506) - kE506) - kE506) - kD506);
    tmp3_8 = kB506 - kG506;
    // Op 507: dim3x3 sub_swap
    uint64_t s0_507_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_507_0 = *(gl64_t*)&dParams->aux_trace[s0_507_pos];
    gl64_t s0_507_1 = *(gl64_t*)&dParams->aux_trace[s0_507_pos + TILE_HEIGHT];
    gl64_t s0_507_2 = *(gl64_t*)&dParams->aux_trace[s0_507_pos + 2*TILE_HEIGHT];
    gl64_t s1_507_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_507_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_507_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_0 = s1_507_0 - s0_507_0; tmp3_1 = s1_507_1 - s0_507_1; tmp3_2 = s1_507_2 - s0_507_2;
    // Op 508: dim3x1 mul
    gl64_t s1_508 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_508; tmp3_1 = tmp3_1 * s1_508; tmp3_2 = tmp3_2 * s1_508;
    // Op 509: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 510: dim3x1 mul
    gl64_t s1_510 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_510; tmp3_1 = tmp3_1 * s1_510; tmp3_2 = tmp3_2 * s1_510;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
