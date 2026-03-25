// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: 4a7a1ff2  nOps=486 nTemp1=7 nTemp3=5
#define GENERATED_EVAL_NOPS_4a7a1ff2 486
#define GENERATED_EVAL_NTEMP1_4a7a1ff2 7
#define GENERATED_EVAL_NTEMP3_4a7a1ff2 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_4a7a1ff2(
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

    // Register-resident temporaries: 7 tmp1 + 15 tmp3 slots
    gl64_t tmp1_0 = gl64_t(uint64_t(0));
    gl64_t tmp1_1 = gl64_t(uint64_t(0));
    gl64_t tmp1_2 = gl64_t(uint64_t(0));
    gl64_t tmp1_3 = gl64_t(uint64_t(0));
    gl64_t tmp1_4 = gl64_t(uint64_t(0));
    gl64_t tmp1_5 = gl64_t(uint64_t(0));
    gl64_t tmp1_6 = gl64_t(uint64_t(0));
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
    tmp1_6 = s0_21 + tmp1_0;
    // Op 22: dim1x1 sub_swap
    gl64_t s1_22 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_22 - tmp1_6;
    // Op 23: dim1x1 mul
    tmp1_0 = tmp1_6 * tmp1_0;
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
    // Op 26: dim1x1 sub_swap
    gl64_t s0_26 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_26 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_26 - s0_26;
    // Op 27: dim1x1 mul
    gl64_t s0_27 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_27 * tmp1_0;
    // Op 28: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 29: dim3x3 mul
    gl64_t s1_29_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_29_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_29_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA29 = (tmp3_0 + tmp3_1) * (s1_29_0 + s1_29_1);
    gl64_t kB29 = (tmp3_0 + tmp3_2) * (s1_29_0 + s1_29_2);
    gl64_t kC29 = (tmp3_1 + tmp3_2) * (s1_29_1 + s1_29_2);
    gl64_t kD29 = tmp3_0 * s1_29_0;
    gl64_t kE29 = tmp3_1 * s1_29_1;
    gl64_t kF29 = tmp3_2 * s1_29_2;
    gl64_t kG29 = kD29 - kE29;
    tmp3_0 = (kC29 + kG29) - kF29;
    tmp3_1 = ((((kA29 + kC29) - kE29) - kE29) - kD29);
    tmp3_2 = kB29 - kG29;
    // Op 30: dim1x1 mul
    gl64_t s0_30 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_30 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_30 * s1_30;
    // Op 31: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 32: dim3x3 mul
    gl64_t s1_32_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_32_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_32_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA32 = (tmp3_0 + tmp3_1) * (s1_32_0 + s1_32_1);
    gl64_t kB32 = (tmp3_0 + tmp3_2) * (s1_32_0 + s1_32_2);
    gl64_t kC32 = (tmp3_1 + tmp3_2) * (s1_32_1 + s1_32_2);
    gl64_t kD32 = tmp3_0 * s1_32_0;
    gl64_t kE32 = tmp3_1 * s1_32_1;
    gl64_t kF32 = tmp3_2 * s1_32_2;
    gl64_t kG32 = kD32 - kE32;
    tmp3_0 = (kC32 + kG32) - kF32;
    tmp3_1 = ((((kA32 + kC32) - kE32) - kE32) - kD32);
    tmp3_2 = kB32 - kG32;
    // Op 33: dim1x1 add
    gl64_t s0_33 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_33 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_33 + s1_33;
    // Op 34: dim1x1 add
    gl64_t s0_34 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_1 = s0_34 + tmp1_0;
    // Op 35: dim1x1 mul
    gl64_t s0_35 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_35 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_35 * s1_35;
    // Op 36: dim1x1 add
    gl64_t s0_36 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_3 = s0_36 + tmp1_0;
    // Op 37: dim1x1 mul
    tmp1_1 = tmp1_1 * tmp1_3;
    // Op 38: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 39: dim3x3 mul
    gl64_t s1_39_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_39_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_39_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA39 = (tmp3_0 + tmp3_1) * (s1_39_0 + s1_39_1);
    gl64_t kB39 = (tmp3_0 + tmp3_2) * (s1_39_0 + s1_39_2);
    gl64_t kC39 = (tmp3_1 + tmp3_2) * (s1_39_1 + s1_39_2);
    gl64_t kD39 = tmp3_0 * s1_39_0;
    gl64_t kE39 = tmp3_1 * s1_39_1;
    gl64_t kF39 = tmp3_2 * s1_39_2;
    gl64_t kG39 = kD39 - kE39;
    tmp3_0 = (kC39 + kG39) - kF39;
    tmp3_1 = ((((kA39 + kC39) - kE39) - kE39) - kD39);
    tmp3_2 = kB39 - kG39;
    // Op 40: dim1x1 sub_swap
    gl64_t s0_40 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_40 = *(gl64_t*)&expressions_params[9][21];
    tmp1_1 = s1_40 - s0_40;
    // Op 41: dim1x1 mul
    gl64_t s0_41 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_1 = s0_41 * tmp1_1;
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
    gl64_t s0_44 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_44 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_1 = s0_44 + s1_44;
    // Op 45: dim1x1 mul
    gl64_t s0_45 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp1_1 = s0_45 * tmp1_1;
    // Op 46: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 47: dim3x3 mul
    gl64_t s1_47_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_47_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_47_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA47 = (tmp3_0 + tmp3_1) * (s1_47_0 + s1_47_1);
    gl64_t kB47 = (tmp3_0 + tmp3_2) * (s1_47_0 + s1_47_2);
    gl64_t kC47 = (tmp3_1 + tmp3_2) * (s1_47_1 + s1_47_2);
    gl64_t kD47 = tmp3_0 * s1_47_0;
    gl64_t kE47 = tmp3_1 * s1_47_1;
    gl64_t kF47 = tmp3_2 * s1_47_2;
    gl64_t kG47 = kD47 - kE47;
    tmp3_0 = (kC47 + kG47) - kF47;
    tmp3_1 = ((((kA47 + kC47) - kE47) - kE47) - kD47);
    tmp3_2 = kB47 - kG47;
    // Op 48: dim1x1 sub_swap
    gl64_t s0_48 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_48 = *(gl64_t*)&expressions_params[9][21];
    tmp1_1 = s1_48 - s0_48;
    // Op 49: dim1x1 mul
    gl64_t s0_49 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_1 = s0_49 * tmp1_1;
    // Op 50: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 51: dim3x3 mul
    gl64_t s1_51_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_51_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_51_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA51 = (tmp3_0 + tmp3_1) * (s1_51_0 + s1_51_1);
    gl64_t kB51 = (tmp3_0 + tmp3_2) * (s1_51_0 + s1_51_2);
    gl64_t kC51 = (tmp3_1 + tmp3_2) * (s1_51_1 + s1_51_2);
    gl64_t kD51 = tmp3_0 * s1_51_0;
    gl64_t kE51 = tmp3_1 * s1_51_1;
    gl64_t kF51 = tmp3_2 * s1_51_2;
    gl64_t kG51 = kD51 - kE51;
    tmp3_0 = (kC51 + kG51) - kF51;
    tmp3_1 = ((((kA51 + kC51) - kE51) - kE51) - kD51);
    tmp3_2 = kB51 - kG51;
    // Op 52: dim1x1 sub_swap
    gl64_t s0_52 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    gl64_t s1_52 = *(gl64_t*)&expressions_params[9][21];
    tmp1_1 = s1_52 - s0_52;
    // Op 53: dim1x1 mul
    gl64_t s0_53 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_1 = s0_53 * tmp1_1;
    // Op 54: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 55: dim3x3 mul
    gl64_t s1_55_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_55_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_55_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA55 = (tmp3_0 + tmp3_1) * (s1_55_0 + s1_55_1);
    gl64_t kB55 = (tmp3_0 + tmp3_2) * (s1_55_0 + s1_55_2);
    gl64_t kC55 = (tmp3_1 + tmp3_2) * (s1_55_1 + s1_55_2);
    gl64_t kD55 = tmp3_0 * s1_55_0;
    gl64_t kE55 = tmp3_1 * s1_55_1;
    gl64_t kF55 = tmp3_2 * s1_55_2;
    gl64_t kG55 = kD55 - kE55;
    tmp3_0 = (kC55 + kG55) - kF55;
    tmp3_1 = ((((kA55 + kC55) - kE55) - kE55) - kD55);
    tmp3_2 = kB55 - kG55;
    // Op 56: dim1x1 sub_swap
    gl64_t s0_56 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_56 = *(gl64_t*)&expressions_params[9][21];
    tmp1_1 = s1_56 - s0_56;
    // Op 57: dim1x1 mul
    gl64_t s0_57 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_1 = s0_57 * tmp1_1;
    // Op 58: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 59: dim3x3 mul
    gl64_t s1_59_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_59_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_59_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA59 = (tmp3_0 + tmp3_1) * (s1_59_0 + s1_59_1);
    gl64_t kB59 = (tmp3_0 + tmp3_2) * (s1_59_0 + s1_59_2);
    gl64_t kC59 = (tmp3_1 + tmp3_2) * (s1_59_1 + s1_59_2);
    gl64_t kD59 = tmp3_0 * s1_59_0;
    gl64_t kE59 = tmp3_1 * s1_59_1;
    gl64_t kF59 = tmp3_2 * s1_59_2;
    gl64_t kG59 = kD59 - kE59;
    tmp3_0 = (kC59 + kG59) - kF59;
    tmp3_1 = ((((kA59 + kC59) - kE59) - kE59) - kD59);
    tmp3_2 = kB59 - kG59;
    // Op 60: dim1x1 sub_swap
    gl64_t s1_60 = *(gl64_t*)&expressions_params[9][21];
    tmp1_1 = s1_60 - tmp1_6;
    // Op 61: dim1x1 mul
    gl64_t s0_61 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_1 = s0_61 * tmp1_1;
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
    // Op 64: dim1x1 sub_swap
    gl64_t s1_64 = *(gl64_t*)&expressions_params[9][21];
    tmp1_1 = s1_64 - tmp1_6;
    // Op 65: dim1x1 mul
    gl64_t s0_65 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_1 = s0_65 * tmp1_1;
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
    // Op 68: dim1x1 sub_swap
    gl64_t s1_68 = *(gl64_t*)&expressions_params[9][21];
    tmp1_1 = s1_68 - tmp1_6;
    // Op 69: dim1x1 mul
    gl64_t s0_69 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_1 = s0_69 * tmp1_1;
    // Op 70: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 71: dim3x3 mul
    gl64_t s1_71_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_71_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_71_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA71 = (tmp3_0 + tmp3_1) * (s1_71_0 + s1_71_1);
    gl64_t kB71 = (tmp3_0 + tmp3_2) * (s1_71_0 + s1_71_2);
    gl64_t kC71 = (tmp3_1 + tmp3_2) * (s1_71_1 + s1_71_2);
    gl64_t kD71 = tmp3_0 * s1_71_0;
    gl64_t kE71 = tmp3_1 * s1_71_1;
    gl64_t kF71 = tmp3_2 * s1_71_2;
    gl64_t kG71 = kD71 - kE71;
    tmp3_0 = (kC71 + kG71) - kF71;
    tmp3_1 = ((((kA71 + kC71) - kE71) - kE71) - kD71);
    tmp3_2 = kB71 - kG71;
    // Op 72: dim1x1 sub_swap
    gl64_t s0_72 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_72 = *(gl64_t*)&expressions_params[9][21];
    tmp1_1 = s1_72 - s0_72;
    // Op 73: dim1x1 mul
    gl64_t s0_73 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_1 = s0_73 * tmp1_1;
    // Op 74: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 75: dim3x3 mul
    gl64_t s1_75_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_75_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_75_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA75 = (tmp3_0 + tmp3_1) * (s1_75_0 + s1_75_1);
    gl64_t kB75 = (tmp3_0 + tmp3_2) * (s1_75_0 + s1_75_2);
    gl64_t kC75 = (tmp3_1 + tmp3_2) * (s1_75_1 + s1_75_2);
    gl64_t kD75 = tmp3_0 * s1_75_0;
    gl64_t kE75 = tmp3_1 * s1_75_1;
    gl64_t kF75 = tmp3_2 * s1_75_2;
    gl64_t kG75 = kD75 - kE75;
    tmp3_0 = (kC75 + kG75) - kF75;
    tmp3_1 = ((((kA75 + kC75) - kE75) - kE75) - kD75);
    tmp3_2 = kB75 - kG75;
    // Op 76: dim1x1 sub_swap
    gl64_t s0_76 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_76 = *(gl64_t*)&expressions_params[9][21];
    tmp1_1 = s1_76 - s0_76;
    // Op 77: dim1x1 mul
    gl64_t s0_77 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_1 = s0_77 * tmp1_1;
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
    tmp3_0 = (kC79 + kG79) - kF79;
    tmp3_1 = ((((kA79 + kC79) - kE79) - kE79) - kD79);
    tmp3_2 = kB79 - kG79;
    // Op 80: dim1x1 mul
    gl64_t s0_80 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_80 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_1 = s0_80 * s1_80;
    // Op 81: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 83: dim1x1 add
    gl64_t s0_83 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    gl64_t s1_83 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_1 = s0_83 + s1_83;
    // Op 84: dim1x1 add
    gl64_t s0_84 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_84 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    tmp1_0 = s0_84 + s1_84;
    // Op 85: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 86: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 87: dim3x3 mul
    gl64_t s1_87_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_87_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_87_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 88: dim1x1 sub_swap
    gl64_t s0_88 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_88 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_88 - s0_88;
    // Op 89: dim1x1 mul
    gl64_t s0_89 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp1_0 = s0_89 * tmp1_0;
    // Op 90: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 91: dim3x3 mul
    gl64_t s1_91_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_91_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_91_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA91 = (tmp3_0 + tmp3_1) * (s1_91_0 + s1_91_1);
    gl64_t kB91 = (tmp3_0 + tmp3_2) * (s1_91_0 + s1_91_2);
    gl64_t kC91 = (tmp3_1 + tmp3_2) * (s1_91_1 + s1_91_2);
    gl64_t kD91 = tmp3_0 * s1_91_0;
    gl64_t kE91 = tmp3_1 * s1_91_1;
    gl64_t kF91 = tmp3_2 * s1_91_2;
    gl64_t kG91 = kD91 - kE91;
    tmp3_0 = (kC91 + kG91) - kF91;
    tmp3_1 = ((((kA91 + kC91) - kE91) - kE91) - kD91);
    tmp3_2 = kB91 - kG91;
    // Op 92: dim1x1 sub_swap
    gl64_t s0_92 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_92 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_92 - s0_92;
    // Op 93: dim1x1 mul
    gl64_t s0_93 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_93 * tmp1_0;
    // Op 94: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 95: dim3x3 mul
    gl64_t s1_95_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_95_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_95_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA95 = (tmp3_0 + tmp3_1) * (s1_95_0 + s1_95_1);
    gl64_t kB95 = (tmp3_0 + tmp3_2) * (s1_95_0 + s1_95_2);
    gl64_t kC95 = (tmp3_1 + tmp3_2) * (s1_95_1 + s1_95_2);
    gl64_t kD95 = tmp3_0 * s1_95_0;
    gl64_t kE95 = tmp3_1 * s1_95_1;
    gl64_t kF95 = tmp3_2 * s1_95_2;
    gl64_t kG95 = kD95 - kE95;
    tmp3_0 = (kC95 + kG95) - kF95;
    tmp3_1 = ((((kA95 + kC95) - kE95) - kE95) - kD95);
    tmp3_2 = kB95 - kG95;
    // Op 96: dim1x1 sub_swap
    gl64_t s0_96 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_96 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_96 - s0_96;
    // Op 97: dim1x1 mul
    gl64_t s0_97 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_0 = s0_97 * tmp1_0;
    // Op 98: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 99: dim3x3 mul
    gl64_t s1_99_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_99_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_99_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 100: dim1x1 sub_swap
    gl64_t s0_100 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_100 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_100 - s0_100;
    // Op 101: dim1x1 mul
    gl64_t s0_101 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp1_0 = s0_101 * tmp1_0;
    // Op 102: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 103: dim3x3 mul
    gl64_t s1_103_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_103_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_103_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA103 = (tmp3_0 + tmp3_1) * (s1_103_0 + s1_103_1);
    gl64_t kB103 = (tmp3_0 + tmp3_2) * (s1_103_0 + s1_103_2);
    gl64_t kC103 = (tmp3_1 + tmp3_2) * (s1_103_1 + s1_103_2);
    gl64_t kD103 = tmp3_0 * s1_103_0;
    gl64_t kE103 = tmp3_1 * s1_103_1;
    gl64_t kF103 = tmp3_2 * s1_103_2;
    gl64_t kG103 = kD103 - kE103;
    tmp3_0 = (kC103 + kG103) - kF103;
    tmp3_1 = ((((kA103 + kC103) - kE103) - kE103) - kD103);
    tmp3_2 = kB103 - kG103;
    // Op 104: dim1x1 sub_swap
    gl64_t s0_104 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_104 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_104 - s0_104;
    // Op 105: dim1x1 mul
    gl64_t s0_105 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    tmp1_0 = s0_105 * tmp1_0;
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
    // Op 108: dim1x1 sub_swap
    gl64_t s0_108 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_108 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_108 - s0_108;
    // Op 109: dim1x1 mul
    gl64_t s0_109 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_109 * tmp1_0;
    // Op 110: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 111: dim3x3 mul
    gl64_t s1_111_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_111_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_111_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA111 = (tmp3_0 + tmp3_1) * (s1_111_0 + s1_111_1);
    gl64_t kB111 = (tmp3_0 + tmp3_2) * (s1_111_0 + s1_111_2);
    gl64_t kC111 = (tmp3_1 + tmp3_2) * (s1_111_1 + s1_111_2);
    gl64_t kD111 = tmp3_0 * s1_111_0;
    gl64_t kE111 = tmp3_1 * s1_111_1;
    gl64_t kF111 = tmp3_2 * s1_111_2;
    gl64_t kG111 = kD111 - kE111;
    tmp3_0 = (kC111 + kG111) - kF111;
    tmp3_1 = ((((kA111 + kC111) - kE111) - kE111) - kD111);
    tmp3_2 = kB111 - kG111;
    // Op 112: dim1x1 mul
    gl64_t s0_112 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    gl64_t s1_112 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_112 * s1_112;
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
    // Op 115: dim1x1 mul
    gl64_t s0_115 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_115 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_115 * s1_115;
    // Op 116: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 117: dim3x3 mul
    gl64_t s1_117_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_117_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_117_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA117 = (tmp3_0 + tmp3_1) * (s1_117_0 + s1_117_1);
    gl64_t kB117 = (tmp3_0 + tmp3_2) * (s1_117_0 + s1_117_2);
    gl64_t kC117 = (tmp3_1 + tmp3_2) * (s1_117_1 + s1_117_2);
    gl64_t kD117 = tmp3_0 * s1_117_0;
    gl64_t kE117 = tmp3_1 * s1_117_1;
    gl64_t kF117 = tmp3_2 * s1_117_2;
    gl64_t kG117 = kD117 - kE117;
    tmp3_0 = (kC117 + kG117) - kF117;
    tmp3_1 = ((((kA117 + kC117) - kE117) - kE117) - kD117);
    tmp3_2 = kB117 - kG117;
    // Op 118: dim1x1 mul
    gl64_t s0_118 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_118 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_118 * s1_118;
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
    gl64_t s0_121 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_121 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_121 - s0_121;
    // Op 122: dim1x1 mul
    gl64_t s0_122 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
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
    gl64_t s0_125 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_125 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_125 - s0_125;
    // Op 126: dim1x1 mul
    gl64_t s0_126 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
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
    gl64_t s0_129 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_129 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_129 - s0_129;
    // Op 130: dim1x1 mul
    gl64_t s0_130 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
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
    gl64_t s0_133 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
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
    // Op 137: dim1x1 sub_swap
    gl64_t s0_137 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_137 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_137 - s0_137;
    // Op 138: dim1x1 mul
    gl64_t s0_138 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp1_0 = s0_138 * tmp1_0;
    // Op 139: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC140 + kG140) - kF140;
    tmp3_1 = ((((kA140 + kC140) - kE140) - kE140) - kD140);
    tmp3_2 = kB140 - kG140;
    // Op 141: dim1x1 sub_swap
    gl64_t s0_141 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_141 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_141 - s0_141;
    // Op 142: dim1x1 mul
    gl64_t s0_142 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    tmp1_0 = s0_142 * tmp1_0;
    // Op 143: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 144: dim3x3 mul
    gl64_t s1_144_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_144_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_144_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA144 = (tmp3_0 + tmp3_1) * (s1_144_0 + s1_144_1);
    gl64_t kB144 = (tmp3_0 + tmp3_2) * (s1_144_0 + s1_144_2);
    gl64_t kC144 = (tmp3_1 + tmp3_2) * (s1_144_1 + s1_144_2);
    gl64_t kD144 = tmp3_0 * s1_144_0;
    gl64_t kE144 = tmp3_1 * s1_144_1;
    gl64_t kF144 = tmp3_2 * s1_144_2;
    gl64_t kG144 = kD144 - kE144;
    tmp3_0 = (kC144 + kG144) - kF144;
    tmp3_1 = ((((kA144 + kC144) - kE144) - kE144) - kD144);
    tmp3_2 = kB144 - kG144;
    // Op 145: dim1x1 add
    gl64_t s0_145 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_145 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_4 = s0_145 + s1_145;
    // Op 146: dim1x1 sub_swap
    gl64_t s1_146 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_146 - tmp1_4;
    // Op 147: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_3;
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
    tmp1_0 = tmp1_4 * tmp1_0;
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
    // Op 154: dim1x1 mul
    gl64_t s0_154 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_154 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_154 * s1_154;
    // Op 155: dim1x1 mul
    gl64_t s0_155 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    gl64_t s1_155 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s0_155 * s1_155;
    // Op 156: dim1x1 add
    tmp1_5 = tmp1_0 + tmp1_1;
    // Op 157: dim1x1 mul
    gl64_t s0_157 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_157 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s0_157 * s1_157;
    // Op 158: dim1x1 add
    tmp1_0 = tmp1_5 + tmp1_0;
    // Op 159: dim1x1 add
    gl64_t s0_159 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_159 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_1 = s0_159 + s1_159;
    // Op 160: dim1x1 mul
    tmp1_2 = tmp1_0 * tmp1_1;
    // Op 161: dim1x1 mul
    gl64_t s0_161 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_161 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_161 * s1_161;
    // Op 162: dim1x1 mul
    gl64_t s0_162 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_162 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s0_162 * s1_162;
    // Op 163: dim1x1 add
    tmp1_1 = tmp1_0 + tmp1_1;
    // Op 164: dim1x1 add
    gl64_t s0_164 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_164 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_164 + s1_164;
    // Op 165: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 166: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 167: dim1x1 sub
    gl64_t s0_167 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp1_0 = s0_167 - tmp1_0;
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
    gl64_t s0_170 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_170 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_170 + s1_170;
    // Op 171: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 172: dim1x1 mul
    gl64_t s0_172 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_172 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_1 = s0_172 * s1_172;
    // Op 173: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 174: dim1x1 sub
    gl64_t s0_174 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp1_0 = s0_174 - tmp1_0;
    // Op 175: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC176 + kG176) - kF176;
    tmp3_1 = ((((kA176 + kC176) - kE176) - kE176) - kD176);
    tmp3_2 = kB176 - kG176;
    // Op 177: dim1x1 mul
    gl64_t s0_177 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_177 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_177 * s1_177;
    // Op 178: dim1x1 add
    gl64_t s0_178 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_2 = s0_178 + tmp1_0;
    // Op 179: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_3;
    // Op 180: dim1x1 mul
    gl64_t s0_180 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_3 = s0_180 * tmp1_1;
    // Op 181: dim1x1 sub
    gl64_t s0_181 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    tmp1_3 = s0_181 - tmp1_3;
    // Op 182: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_3; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 183: dim3x3 mul
    gl64_t s1_183_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_183_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_183_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA183 = (tmp3_0 + tmp3_1) * (s1_183_0 + s1_183_1);
    gl64_t kB183 = (tmp3_0 + tmp3_2) * (s1_183_0 + s1_183_2);
    gl64_t kC183 = (tmp3_1 + tmp3_2) * (s1_183_1 + s1_183_2);
    gl64_t kD183 = tmp3_0 * s1_183_0;
    gl64_t kE183 = tmp3_1 * s1_183_1;
    gl64_t kF183 = tmp3_2 * s1_183_2;
    gl64_t kG183 = kD183 - kE183;
    tmp3_12 = (kC183 + kG183) - kF183;
    tmp3_13 = ((((kA183 + kC183) - kE183) - kE183) - kD183);
    tmp3_14 = kB183 - kG183;
    // Op 184: dim3x1 mul
    gl64_t s0_184_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_184_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_184_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_184 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp3_0 = s0_184_0 * s1_184; tmp3_1 = s0_184_1 * s1_184; tmp3_2 = s0_184_2 * s1_184;
    // Op 185: dim3x1 add
    gl64_t s1_185 = *(gl64_t*)&expressions_params[9][5];
    tmp3_9 = tmp3_0 + s1_185; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 186: dim3x3 add
    gl64_t s1_186_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_186_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_186_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_186_0; tmp3_4 = tmp3_10 + s1_186_1; tmp3_5 = tmp3_11 + s1_186_2;
    // Op 187: dim3x1 mul
    gl64_t s0_187_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_187_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_187_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_187 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp3_0 = s0_187_0 * s1_187; tmp3_1 = s0_187_1 * s1_187; tmp3_2 = s0_187_2 * s1_187;
    // Op 188: dim3x1 add
    gl64_t s1_188 = *(gl64_t*)&expressions_params[9][5];
    tmp3_6 = tmp3_0 + s1_188; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 189: dim3x3 add
    gl64_t s1_189_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_189_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_189_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_189_0; tmp3_1 = tmp3_7 + s1_189_1; tmp3_2 = tmp3_8 + s1_189_2;
    // Op 190: dim3x3 mul
    gl64_t kA190 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB190 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC190 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD190 = tmp3_3 * tmp3_0;
    gl64_t kE190 = tmp3_4 * tmp3_1;
    gl64_t kF190 = tmp3_5 * tmp3_2;
    gl64_t kG190 = kD190 - kE190;
    tmp3_0 = (kC190 + kG190) - kF190;
    tmp3_1 = ((((kA190 + kC190) - kE190) - kE190) - kD190);
    tmp3_2 = kB190 - kG190;
    // Op 191: dim3x3 mul
    gl64_t s0_191_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_191_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_191_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA191 = (s0_191_0 + s0_191_1) * (tmp3_0 + tmp3_1);
    gl64_t kB191 = (s0_191_0 + s0_191_2) * (tmp3_0 + tmp3_2);
    gl64_t kC191 = (s0_191_1 + s0_191_2) * (tmp3_1 + tmp3_2);
    gl64_t kD191 = s0_191_0 * tmp3_0;
    gl64_t kE191 = s0_191_1 * tmp3_1;
    gl64_t kF191 = s0_191_2 * tmp3_2;
    gl64_t kG191 = kD191 - kE191;
    tmp3_0 = (kC191 + kG191) - kF191;
    tmp3_1 = ((((kA191 + kC191) - kE191) - kE191) - kD191);
    tmp3_2 = kB191 - kG191;
    // Op 192: dim1x1 sub_swap
    gl64_t s0_192 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_192 = *(gl64_t*)&expressions_params[9][4];
    tmp1_3 = s1_192 - s0_192;
    // Op 193: dim3x3 add
    gl64_t s1_193_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_193_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_193_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_193_0; tmp3_7 = tmp3_7 + s1_193_1; tmp3_8 = tmp3_8 + s1_193_2;
    // Op 194: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_3; tmp3_7 = tmp3_7 * tmp1_3; tmp3_8 = tmp3_8 * tmp1_3;
    // Op 195: dim1x1 sub_swap
    gl64_t s0_195 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_195 = *(gl64_t*)&expressions_params[9][4];
    tmp1_3 = s1_195 - s0_195;
    // Op 196: dim3x3 add
    gl64_t s1_196_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_196_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_196_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_196_0; tmp3_10 = tmp3_10 + s1_196_1; tmp3_11 = tmp3_11 + s1_196_2;
    // Op 197: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_3; tmp3_10 = tmp3_10 * tmp1_3; tmp3_11 = tmp3_11 * tmp1_3;
    // Op 198: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 199: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 200: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
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
    tmp3_3 = (kC201 + kG201) - kF201;
    tmp3_4 = ((((kA201 + kC201) - kE201) - kE201) - kD201);
    tmp3_5 = kB201 - kG201;
    // Op 202: dim3x1 mul
    gl64_t s0_202_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_202_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_202_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_202 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp3_0 = s0_202_0 * s1_202; tmp3_1 = s0_202_1 * s1_202; tmp3_2 = s0_202_2 * s1_202;
    // Op 203: dim3x1 add
    gl64_t s1_203 = *(gl64_t*)&expressions_params[9][6];
    tmp3_9 = tmp3_0 + s1_203; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 204: dim3x3 add
    gl64_t s1_204_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_204_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_204_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_204_0; tmp3_13 = tmp3_10 + s1_204_1; tmp3_14 = tmp3_11 + s1_204_2;
    // Op 205: dim3x1 mul
    gl64_t s0_205_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_205_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_205_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_205 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp3_0 = s0_205_0 * s1_205; tmp3_1 = s0_205_1 * s1_205; tmp3_2 = s0_205_2 * s1_205;
    // Op 206: dim3x1 add
    gl64_t s1_206 = *(gl64_t*)&expressions_params[9][6];
    tmp3_6 = tmp3_0 + s1_206; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 207: dim3x3 add
    gl64_t s1_207_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_207_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_207_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_207_0; tmp3_1 = tmp3_7 + s1_207_1; tmp3_2 = tmp3_8 + s1_207_2;
    // Op 208: dim3x3 mul
    gl64_t kA208 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB208 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC208 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD208 = tmp3_12 * tmp3_0;
    gl64_t kE208 = tmp3_13 * tmp3_1;
    gl64_t kF208 = tmp3_14 * tmp3_2;
    gl64_t kG208 = kD208 - kE208;
    tmp3_0 = (kC208 + kG208) - kF208;
    tmp3_1 = ((((kA208 + kC208) - kE208) - kE208) - kD208);
    tmp3_2 = kB208 - kG208;
    // Op 209: dim3x3 mul
    gl64_t s0_209_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_209_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_209_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA209 = (s0_209_0 + s0_209_1) * (tmp3_0 + tmp3_1);
    gl64_t kB209 = (s0_209_0 + s0_209_2) * (tmp3_0 + tmp3_2);
    gl64_t kC209 = (s0_209_1 + s0_209_2) * (tmp3_1 + tmp3_2);
    gl64_t kD209 = s0_209_0 * tmp3_0;
    gl64_t kE209 = s0_209_1 * tmp3_1;
    gl64_t kF209 = s0_209_2 * tmp3_2;
    gl64_t kG209 = kD209 - kE209;
    tmp3_0 = (kC209 + kG209) - kF209;
    tmp3_1 = ((((kA209 + kC209) - kE209) - kE209) - kD209);
    tmp3_2 = kB209 - kG209;
    // Op 210: dim1x1 sub_swap
    gl64_t s1_210 = *(gl64_t*)&expressions_params[9][4];
    tmp1_3 = s1_210 - tmp1_6;
    // Op 211: dim3x3 add
    gl64_t s1_211_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_211_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_211_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_211_0; tmp3_7 = tmp3_7 + s1_211_1; tmp3_8 = tmp3_8 + s1_211_2;
    // Op 212: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_3; tmp3_7 = tmp3_7 * tmp1_3; tmp3_8 = tmp3_8 * tmp1_3;
    // Op 213: dim1x1 sub_swap
    gl64_t s1_213 = *(gl64_t*)&expressions_params[9][4];
    tmp1_3 = s1_213 - tmp1_6;
    // Op 214: dim3x3 add
    gl64_t s1_214_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_214_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_214_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_214_0; tmp3_10 = tmp3_10 + s1_214_1; tmp3_11 = tmp3_11 + s1_214_2;
    // Op 215: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_3; tmp3_10 = tmp3_10 * tmp1_3; tmp3_11 = tmp3_11 * tmp1_3;
    // Op 216: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 217: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 218: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 219: dim3x3 mul
    gl64_t s1_219_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_219_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_219_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA219 = (tmp3_0 + tmp3_1) * (s1_219_0 + s1_219_1);
    gl64_t kB219 = (tmp3_0 + tmp3_2) * (s1_219_0 + s1_219_2);
    gl64_t kC219 = (tmp3_1 + tmp3_2) * (s1_219_1 + s1_219_2);
    gl64_t kD219 = tmp3_0 * s1_219_0;
    gl64_t kE219 = tmp3_1 * s1_219_1;
    gl64_t kF219 = tmp3_2 * s1_219_2;
    gl64_t kG219 = kD219 - kE219;
    tmp3_12 = (kC219 + kG219) - kF219;
    tmp3_13 = ((((kA219 + kC219) - kE219) - kE219) - kD219);
    tmp3_14 = kB219 - kG219;
    // Op 220: dim3x1 mul
    gl64_t s0_220_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_220_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_220_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_220 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp3_0 = s0_220_0 * s1_220; tmp3_1 = s0_220_1 * s1_220; tmp3_2 = s0_220_2 * s1_220;
    // Op 221: dim3x1 add
    gl64_t s1_221 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_221; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 222: dim3x3 mul
    gl64_t s1_222_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_222_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_222_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA222 = (tmp3_0 + tmp3_1) * (s1_222_0 + s1_222_1);
    gl64_t kB222 = (tmp3_0 + tmp3_2) * (s1_222_0 + s1_222_2);
    gl64_t kC222 = (tmp3_1 + tmp3_2) * (s1_222_1 + s1_222_2);
    gl64_t kD222 = tmp3_0 * s1_222_0;
    gl64_t kE222 = tmp3_1 * s1_222_1;
    gl64_t kF222 = tmp3_2 * s1_222_2;
    gl64_t kG222 = kD222 - kE222;
    tmp3_0 = (kC222 + kG222) - kF222;
    tmp3_1 = ((((kA222 + kC222) - kE222) - kE222) - kD222);
    tmp3_2 = kB222 - kG222;
    // Op 223: dim3x1 add
    gl64_t s1_223 = *(gl64_t*)&expressions_params[9][13];
    tmp3_9 = tmp3_0 + s1_223; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 224: dim3x3 add
    gl64_t s1_224_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_224_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_224_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_224_0; tmp3_4 = tmp3_10 + s1_224_1; tmp3_5 = tmp3_11 + s1_224_2;
    // Op 225: dim3x1 mul
    gl64_t s0_225_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_225_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_225_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_225 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp3_0 = s0_225_0 * s1_225; tmp3_1 = s0_225_1 * s1_225; tmp3_2 = s0_225_2 * s1_225;
    // Op 226: dim3x1 add
    gl64_t s1_226 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_226; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 227: dim3x3 mul
    gl64_t s1_227_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_227_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_227_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA227 = (tmp3_0 + tmp3_1) * (s1_227_0 + s1_227_1);
    gl64_t kB227 = (tmp3_0 + tmp3_2) * (s1_227_0 + s1_227_2);
    gl64_t kC227 = (tmp3_1 + tmp3_2) * (s1_227_1 + s1_227_2);
    gl64_t kD227 = tmp3_0 * s1_227_0;
    gl64_t kE227 = tmp3_1 * s1_227_1;
    gl64_t kF227 = tmp3_2 * s1_227_2;
    gl64_t kG227 = kD227 - kE227;
    tmp3_0 = (kC227 + kG227) - kF227;
    tmp3_1 = ((((kA227 + kC227) - kE227) - kE227) - kD227);
    tmp3_2 = kB227 - kG227;
    // Op 228: dim3x1 add
    gl64_t s1_228 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_228; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 229: dim3x3 mul
    gl64_t s1_229_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_229_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_229_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA229 = (tmp3_0 + tmp3_1) * (s1_229_0 + s1_229_1);
    gl64_t kB229 = (tmp3_0 + tmp3_2) * (s1_229_0 + s1_229_2);
    gl64_t kC229 = (tmp3_1 + tmp3_2) * (s1_229_1 + s1_229_2);
    gl64_t kD229 = tmp3_0 * s1_229_0;
    gl64_t kE229 = tmp3_1 * s1_229_1;
    gl64_t kF229 = tmp3_2 * s1_229_2;
    gl64_t kG229 = kD229 - kE229;
    tmp3_0 = (kC229 + kG229) - kF229;
    tmp3_1 = ((((kA229 + kC229) - kE229) - kE229) - kD229);
    tmp3_2 = kB229 - kG229;
    // Op 230: dim1x1 mul
    gl64_t s0_230 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    gl64_t s1_230 = *(gl64_t*)&expressions_params[9][7];
    tmp1_3 = s0_230 * s1_230;
    // Op 231: dim1x1 add
    gl64_t s0_231 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_3 = s0_231 + tmp1_3;
    // Op 232: dim1x1 mul
    gl64_t s0_232 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_232 = *(gl64_t*)&expressions_params[9][8];
    tmp1_0 = s0_232 * s1_232;
    // Op 233: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_0;
    // Op 234: dim1x1 mul
    gl64_t s0_234 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_234 = *(gl64_t*)&expressions_params[9][1];
    tmp1_3 = s0_234 * s1_234;
    // Op 235: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 236: dim1x1 mul
    gl64_t s0_236 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_236 = *(gl64_t*)&expressions_params[9][9];
    tmp1_3 = s0_236 * s1_236;
    // Op 237: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 238: dim1x1 mul
    gl64_t s1_238 = *(gl64_t*)&expressions_params[9][10];
    tmp1_4 = tmp1_4 * s1_238;
    // Op 239: dim1x1 add
    tmp1_4 = tmp1_0 + tmp1_4;
    // Op 240: dim1x1 add
    gl64_t s0_240 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_240 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_240 + s1_240;
    // Op 241: dim1x1 mul
    gl64_t s1_241 = *(gl64_t*)&expressions_params[9][11];
    tmp1_0 = tmp1_0 * s1_241;
    // Op 242: dim1x1 add
    tmp1_0 = tmp1_4 + tmp1_0;
    // Op 243: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 244: dim3x3 mul
    gl64_t s1_244_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_244_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_244_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA244 = (tmp3_0 + tmp3_1) * (s1_244_0 + s1_244_1);
    gl64_t kB244 = (tmp3_0 + tmp3_2) * (s1_244_0 + s1_244_2);
    gl64_t kC244 = (tmp3_1 + tmp3_2) * (s1_244_1 + s1_244_2);
    gl64_t kD244 = tmp3_0 * s1_244_0;
    gl64_t kE244 = tmp3_1 * s1_244_1;
    gl64_t kF244 = tmp3_2 * s1_244_2;
    gl64_t kG244 = kD244 - kE244;
    tmp3_0 = (kC244 + kG244) - kF244;
    tmp3_1 = ((((kA244 + kC244) - kE244) - kE244) - kD244);
    tmp3_2 = kB244 - kG244;
    // Op 245: dim3x1 add
    gl64_t s1_245 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_245; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 246: dim3x3 mul
    gl64_t s1_246_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_246_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_246_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA246 = (tmp3_0 + tmp3_1) * (s1_246_0 + s1_246_1);
    gl64_t kB246 = (tmp3_0 + tmp3_2) * (s1_246_0 + s1_246_2);
    gl64_t kC246 = (tmp3_1 + tmp3_2) * (s1_246_1 + s1_246_2);
    gl64_t kD246 = tmp3_0 * s1_246_0;
    gl64_t kE246 = tmp3_1 * s1_246_1;
    gl64_t kF246 = tmp3_2 * s1_246_2;
    gl64_t kG246 = kD246 - kE246;
    tmp3_0 = (kC246 + kG246) - kF246;
    tmp3_1 = ((((kA246 + kC246) - kE246) - kE246) - kD246);
    tmp3_2 = kB246 - kG246;
    // Op 247: dim3x1 add
    gl64_t s1_247 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_247; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 248: dim3x3 mul
    gl64_t s1_248_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_248_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_248_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA248 = (tmp3_0 + tmp3_1) * (s1_248_0 + s1_248_1);
    gl64_t kB248 = (tmp3_0 + tmp3_2) * (s1_248_0 + s1_248_2);
    gl64_t kC248 = (tmp3_1 + tmp3_2) * (s1_248_1 + s1_248_2);
    gl64_t kD248 = tmp3_0 * s1_248_0;
    gl64_t kE248 = tmp3_1 * s1_248_1;
    gl64_t kF248 = tmp3_2 * s1_248_2;
    gl64_t kG248 = kD248 - kE248;
    tmp3_0 = (kC248 + kG248) - kF248;
    tmp3_1 = ((((kA248 + kC248) - kE248) - kE248) - kD248);
    tmp3_2 = kB248 - kG248;
    // Op 249: dim3x1 add
    gl64_t s1_249 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
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
    gl64_t s1_251 = *(gl64_t*)&expressions_params[9][12];
    tmp3_6 = tmp3_0 + s1_251; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 252: dim3x3 add
    gl64_t s1_252_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_252_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_252_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_252_0; tmp3_1 = tmp3_7 + s1_252_1; tmp3_2 = tmp3_8 + s1_252_2;
    // Op 253: dim3x3 mul
    gl64_t kA253 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB253 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC253 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD253 = tmp3_3 * tmp3_0;
    gl64_t kE253 = tmp3_4 * tmp3_1;
    gl64_t kF253 = tmp3_5 * tmp3_2;
    gl64_t kG253 = kD253 - kE253;
    tmp3_0 = (kC253 + kG253) - kF253;
    tmp3_1 = ((((kA253 + kC253) - kE253) - kE253) - kD253);
    tmp3_2 = kB253 - kG253;
    // Op 254: dim3x3 mul
    uint64_t s0_254_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_254_0 = *(gl64_t*)&dParams->aux_trace[s0_254_pos];
    gl64_t s0_254_1 = *(gl64_t*)&dParams->aux_trace[s0_254_pos + TILE_HEIGHT];
    gl64_t s0_254_2 = *(gl64_t*)&dParams->aux_trace[s0_254_pos + 2*TILE_HEIGHT];
    gl64_t kA254 = (s0_254_0 + s0_254_1) * (tmp3_0 + tmp3_1);
    gl64_t kB254 = (s0_254_0 + s0_254_2) * (tmp3_0 + tmp3_2);
    gl64_t kC254 = (s0_254_1 + s0_254_2) * (tmp3_1 + tmp3_2);
    gl64_t kD254 = s0_254_0 * tmp3_0;
    gl64_t kE254 = s0_254_1 * tmp3_1;
    gl64_t kF254 = s0_254_2 * tmp3_2;
    gl64_t kG254 = kD254 - kE254;
    tmp3_0 = (kC254 + kG254) - kF254;
    tmp3_1 = ((((kA254 + kC254) - kE254) - kE254) - kD254);
    tmp3_2 = kB254 - kG254;
    // Op 255: dim1x1 sub_swap
    gl64_t s1_255 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s1_255 - tmp1_6;
    // Op 256: dim3x3 add
    gl64_t s1_256_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_256_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_256_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_256_0; tmp3_7 = tmp3_7 + s1_256_1; tmp3_8 = tmp3_8 + s1_256_2;
    // Op 257: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 258: dim1x1 sub_swap
    gl64_t s1_258 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s1_258 - tmp1_6;
    // Op 259: dim3x3 add
    gl64_t s1_259_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_259_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_259_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_259_0; tmp3_10 = tmp3_10 + s1_259_1; tmp3_11 = tmp3_11 + s1_259_2;
    // Op 260: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 261: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 262: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 263: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 264: dim3x3 mul
    gl64_t s1_264_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_264_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_264_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA264 = (tmp3_0 + tmp3_1) * (s1_264_0 + s1_264_1);
    gl64_t kB264 = (tmp3_0 + tmp3_2) * (s1_264_0 + s1_264_2);
    gl64_t kC264 = (tmp3_1 + tmp3_2) * (s1_264_1 + s1_264_2);
    gl64_t kD264 = tmp3_0 * s1_264_0;
    gl64_t kE264 = tmp3_1 * s1_264_1;
    gl64_t kF264 = tmp3_2 * s1_264_2;
    gl64_t kG264 = kD264 - kE264;
    tmp3_3 = (kC264 + kG264) - kF264;
    tmp3_4 = ((((kA264 + kC264) - kE264) - kE264) - kD264);
    tmp3_5 = kB264 - kG264;
    // Op 265: dim3x1 mul
    gl64_t s0_265_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_265_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_265_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_265 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp3_0 = s0_265_0 * s1_265; tmp3_1 = s0_265_1 * s1_265; tmp3_2 = s0_265_2 * s1_265;
    // Op 266: dim3x1 add
    gl64_t s1_266 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_266; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_268 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
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
    // Op 270: dim3x3 mul
    gl64_t s1_270_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_270_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_270_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA270 = (tmp3_0 + tmp3_1) * (s1_270_0 + s1_270_1);
    gl64_t kB270 = (tmp3_0 + tmp3_2) * (s1_270_0 + s1_270_2);
    gl64_t kC270 = (tmp3_1 + tmp3_2) * (s1_270_1 + s1_270_2);
    gl64_t kD270 = tmp3_0 * s1_270_0;
    gl64_t kE270 = tmp3_1 * s1_270_1;
    gl64_t kF270 = tmp3_2 * s1_270_2;
    gl64_t kG270 = kD270 - kE270;
    tmp3_0 = (kC270 + kG270) - kF270;
    tmp3_1 = ((((kA270 + kC270) - kE270) - kE270) - kD270);
    tmp3_2 = kB270 - kG270;
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
    // Op 272: dim1x1 mul
    gl64_t s0_272 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_272 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_272 * s1_272;
    // Op 273: dim1x1 mul
    gl64_t s0_273 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_273 = *(gl64_t*)&expressions_params[9][1];
    tmp1_4 = s0_273 * s1_273;
    // Op 274: dim1x1 add
    tmp1_3 = tmp1_0 + tmp1_4;
    // Op 275: dim1x1 mul
    gl64_t s0_275 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_275 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s0_275 * s1_275;
    // Op 276: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_0;
    // Op 277: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 279: dim3x3 mul
    gl64_t s1_279_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_279_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_279_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA279 = (tmp3_0 + tmp3_1) * (s1_279_0 + s1_279_1);
    gl64_t kB279 = (tmp3_0 + tmp3_2) * (s1_279_0 + s1_279_2);
    gl64_t kC279 = (tmp3_1 + tmp3_2) * (s1_279_1 + s1_279_2);
    gl64_t kD279 = tmp3_0 * s1_279_0;
    gl64_t kE279 = tmp3_1 * s1_279_1;
    gl64_t kF279 = tmp3_2 * s1_279_2;
    gl64_t kG279 = kD279 - kE279;
    tmp3_0 = (kC279 + kG279) - kF279;
    tmp3_1 = ((((kA279 + kC279) - kE279) - kE279) - kD279);
    tmp3_2 = kB279 - kG279;
    // Op 280: dim3x1 add
    gl64_t s1_280 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_280; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 283: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 284: dim3x3 mul
    gl64_t s1_284_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_284_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_284_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA284 = (tmp3_0 + tmp3_1) * (s1_284_0 + s1_284_1);
    gl64_t kB284 = (tmp3_0 + tmp3_2) * (s1_284_0 + s1_284_2);
    gl64_t kC284 = (tmp3_1 + tmp3_2) * (s1_284_1 + s1_284_2);
    gl64_t kD284 = tmp3_0 * s1_284_0;
    gl64_t kE284 = tmp3_1 * s1_284_1;
    gl64_t kF284 = tmp3_2 * s1_284_2;
    gl64_t kG284 = kD284 - kE284;
    tmp3_0 = (kC284 + kG284) - kF284;
    tmp3_1 = ((((kA284 + kC284) - kE284) - kE284) - kD284);
    tmp3_2 = kB284 - kG284;
    // Op 285: dim1x1 mul
    gl64_t s0_285 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_285 = *(gl64_t*)&expressions_params[9][16];
    tmp1_0 = s0_285 * s1_285;
    // Op 286: dim1x1 mul
    gl64_t s0_286 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_286 = *(gl64_t*)&expressions_params[9][17];
    tmp1_4 = s0_286 * s1_286;
    // Op 287: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 288: dim1x1 mul
    gl64_t s0_288 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_288 = *(gl64_t*)&expressions_params[9][18];
    tmp1_4 = s0_288 * s1_288;
    // Op 289: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 290: dim1x1 mul
    gl64_t s0_290 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_290 = *(gl64_t*)&expressions_params[9][19];
    tmp1_4 = s0_290 * s1_290;
    // Op 291: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 292: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_294 = *(gl64_t*)&expressions_params[9][20];
    tmp3_9 = tmp3_0 + s1_294; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 295: dim3x3 add
    gl64_t s1_295_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_295_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_295_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_295_0; tmp3_13 = tmp3_10 + s1_295_1; tmp3_14 = tmp3_11 + s1_295_2;
    // Op 296: dim3x1 mul
    gl64_t s0_296_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_296_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_296_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_296 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp3_0 = s0_296_0 * s1_296; tmp3_1 = s0_296_1 * s1_296; tmp3_2 = s0_296_2 * s1_296;
    // Op 297: dim3x1 add
    gl64_t s1_297 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_297; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 298: dim3x3 mul
    gl64_t s1_298_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_298_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_298_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA298 = (tmp3_0 + tmp3_1) * (s1_298_0 + s1_298_1);
    gl64_t kB298 = (tmp3_0 + tmp3_2) * (s1_298_0 + s1_298_2);
    gl64_t kC298 = (tmp3_1 + tmp3_2) * (s1_298_1 + s1_298_2);
    gl64_t kD298 = tmp3_0 * s1_298_0;
    gl64_t kE298 = tmp3_1 * s1_298_1;
    gl64_t kF298 = tmp3_2 * s1_298_2;
    gl64_t kG298 = kD298 - kE298;
    tmp3_0 = (kC298 + kG298) - kF298;
    tmp3_1 = ((((kA298 + kC298) - kE298) - kE298) - kD298);
    tmp3_2 = kB298 - kG298;
    // Op 299: dim3x1 add
    gl64_t s1_299 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_299; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 300: dim3x3 mul
    gl64_t s1_300_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_300_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_300_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA300 = (tmp3_0 + tmp3_1) * (s1_300_0 + s1_300_1);
    gl64_t kB300 = (tmp3_0 + tmp3_2) * (s1_300_0 + s1_300_2);
    gl64_t kC300 = (tmp3_1 + tmp3_2) * (s1_300_1 + s1_300_2);
    gl64_t kD300 = tmp3_0 * s1_300_0;
    gl64_t kE300 = tmp3_1 * s1_300_1;
    gl64_t kF300 = tmp3_2 * s1_300_2;
    gl64_t kG300 = kD300 - kE300;
    tmp3_0 = (kC300 + kG300) - kF300;
    tmp3_1 = ((((kA300 + kC300) - kE300) - kE300) - kD300);
    tmp3_2 = kB300 - kG300;
    // Op 301: dim3x1 add
    gl64_t s1_301 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_301; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_303 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
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
    // Op 305: dim3x1 add
    gl64_t s1_305 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_305; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 306: dim3x3 mul
    gl64_t s1_306_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_306_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_306_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA306 = (tmp3_0 + tmp3_1) * (s1_306_0 + s1_306_1);
    gl64_t kB306 = (tmp3_0 + tmp3_2) * (s1_306_0 + s1_306_2);
    gl64_t kC306 = (tmp3_1 + tmp3_2) * (s1_306_1 + s1_306_2);
    gl64_t kD306 = tmp3_0 * s1_306_0;
    gl64_t kE306 = tmp3_1 * s1_306_1;
    gl64_t kF306 = tmp3_2 * s1_306_2;
    gl64_t kG306 = kD306 - kE306;
    tmp3_0 = (kC306 + kG306) - kF306;
    tmp3_1 = ((((kA306 + kC306) - kE306) - kE306) - kD306);
    tmp3_2 = kB306 - kG306;
    // Op 307: dim3x1 add
    gl64_t s1_307 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_307; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 308: dim3x3 mul
    gl64_t s1_308_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_308_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_308_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA308 = (tmp3_0 + tmp3_1) * (s1_308_0 + s1_308_1);
    gl64_t kB308 = (tmp3_0 + tmp3_2) * (s1_308_0 + s1_308_2);
    gl64_t kC308 = (tmp3_1 + tmp3_2) * (s1_308_1 + s1_308_2);
    gl64_t kD308 = tmp3_0 * s1_308_0;
    gl64_t kE308 = tmp3_1 * s1_308_1;
    gl64_t kF308 = tmp3_2 * s1_308_2;
    gl64_t kG308 = kD308 - kE308;
    tmp3_0 = (kC308 + kG308) - kF308;
    tmp3_1 = ((((kA308 + kC308) - kE308) - kE308) - kD308);
    tmp3_2 = kB308 - kG308;
    // Op 309: dim3x1 add
    gl64_t s1_309 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_309; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 310: dim3x3 mul
    gl64_t s1_310_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_310_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_310_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA310 = (tmp3_0 + tmp3_1) * (s1_310_0 + s1_310_1);
    gl64_t kB310 = (tmp3_0 + tmp3_2) * (s1_310_0 + s1_310_2);
    gl64_t kC310 = (tmp3_1 + tmp3_2) * (s1_310_1 + s1_310_2);
    gl64_t kD310 = tmp3_0 * s1_310_0;
    gl64_t kE310 = tmp3_1 * s1_310_1;
    gl64_t kF310 = tmp3_2 * s1_310_2;
    gl64_t kG310 = kD310 - kE310;
    tmp3_0 = (kC310 + kG310) - kF310;
    tmp3_1 = ((((kA310 + kC310) - kE310) - kE310) - kD310);
    tmp3_2 = kB310 - kG310;
    // Op 311: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_5; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 312: dim3x3 mul
    gl64_t s1_312_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_312_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_312_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA312 = (tmp3_0 + tmp3_1) * (s1_312_0 + s1_312_1);
    gl64_t kB312 = (tmp3_0 + tmp3_2) * (s1_312_0 + s1_312_2);
    gl64_t kC312 = (tmp3_1 + tmp3_2) * (s1_312_1 + s1_312_2);
    gl64_t kD312 = tmp3_0 * s1_312_0;
    gl64_t kE312 = tmp3_1 * s1_312_1;
    gl64_t kF312 = tmp3_2 * s1_312_2;
    gl64_t kG312 = kD312 - kE312;
    tmp3_0 = (kC312 + kG312) - kF312;
    tmp3_1 = ((((kA312 + kC312) - kE312) - kE312) - kD312);
    tmp3_2 = kB312 - kG312;
    // Op 313: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_3; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 314: dim3x3 mul
    gl64_t s1_314_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_314_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_314_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA314 = (tmp3_0 + tmp3_1) * (s1_314_0 + s1_314_1);
    gl64_t kB314 = (tmp3_0 + tmp3_2) * (s1_314_0 + s1_314_2);
    gl64_t kC314 = (tmp3_1 + tmp3_2) * (s1_314_1 + s1_314_2);
    gl64_t kD314 = tmp3_0 * s1_314_0;
    gl64_t kE314 = tmp3_1 * s1_314_1;
    gl64_t kF314 = tmp3_2 * s1_314_2;
    gl64_t kG314 = kD314 - kE314;
    tmp3_0 = (kC314 + kG314) - kF314;
    tmp3_1 = ((((kA314 + kC314) - kE314) - kE314) - kD314);
    tmp3_2 = kB314 - kG314;
    // Op 315: dim1x1 mul
    gl64_t s0_315 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_315 = *(gl64_t*)&expressions_params[9][8];
    tmp1_0 = s0_315 * s1_315;
    // Op 316: dim1x1 add
    gl64_t s0_316 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_316 + tmp1_0;
    // Op 317: dim1x1 mul
    gl64_t s0_317 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_317 = *(gl64_t*)&expressions_params[9][14];
    tmp1_4 = s0_317 * s1_317;
    // Op 318: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 319: dim1x1 mul
    gl64_t s0_319 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_319 = *(gl64_t*)&expressions_params[9][7];
    tmp1_4 = s0_319 * s1_319;
    // Op 320: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 321: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 322: dim3x3 mul
    gl64_t s1_322_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_322_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_322_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA322 = (tmp3_0 + tmp3_1) * (s1_322_0 + s1_322_1);
    gl64_t kB322 = (tmp3_0 + tmp3_2) * (s1_322_0 + s1_322_2);
    gl64_t kC322 = (tmp3_1 + tmp3_2) * (s1_322_1 + s1_322_2);
    gl64_t kD322 = tmp3_0 * s1_322_0;
    gl64_t kE322 = tmp3_1 * s1_322_1;
    gl64_t kF322 = tmp3_2 * s1_322_2;
    gl64_t kG322 = kD322 - kE322;
    tmp3_0 = (kC322 + kG322) - kF322;
    tmp3_1 = ((((kA322 + kC322) - kE322) - kE322) - kD322);
    tmp3_2 = kB322 - kG322;
    // Op 323: dim3x1 add
    gl64_t s1_323 = *(gl64_t*)&expressions_params[9][15];
    tmp3_6 = tmp3_0 + s1_323; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 324: dim3x3 add
    gl64_t s1_324_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_324_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_324_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_324_0; tmp3_1 = tmp3_7 + s1_324_1; tmp3_2 = tmp3_8 + s1_324_2;
    // Op 325: dim3x3 mul
    gl64_t kA325 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB325 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC325 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD325 = tmp3_12 * tmp3_0;
    gl64_t kE325 = tmp3_13 * tmp3_1;
    gl64_t kF325 = tmp3_14 * tmp3_2;
    gl64_t kG325 = kD325 - kE325;
    tmp3_0 = (kC325 + kG325) - kF325;
    tmp3_1 = ((((kA325 + kC325) - kE325) - kE325) - kD325);
    tmp3_2 = kB325 - kG325;
    // Op 326: dim3x3 mul
    uint64_t s0_326_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_326_0 = *(gl64_t*)&dParams->aux_trace[s0_326_pos];
    gl64_t s0_326_1 = *(gl64_t*)&dParams->aux_trace[s0_326_pos + TILE_HEIGHT];
    gl64_t s0_326_2 = *(gl64_t*)&dParams->aux_trace[s0_326_pos + 2*TILE_HEIGHT];
    gl64_t kA326 = (s0_326_0 + s0_326_1) * (tmp3_0 + tmp3_1);
    gl64_t kB326 = (s0_326_0 + s0_326_2) * (tmp3_0 + tmp3_2);
    gl64_t kC326 = (s0_326_1 + s0_326_2) * (tmp3_1 + tmp3_2);
    gl64_t kD326 = s0_326_0 * tmp3_0;
    gl64_t kE326 = s0_326_1 * tmp3_1;
    gl64_t kF326 = s0_326_2 * tmp3_2;
    gl64_t kG326 = kD326 - kE326;
    tmp3_0 = (kC326 + kG326) - kF326;
    tmp3_1 = ((((kA326 + kC326) - kE326) - kE326) - kD326);
    tmp3_2 = kB326 - kG326;
    // Op 327: dim1x1 sub_swap
    gl64_t s0_327 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    gl64_t s1_327 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s1_327 - s0_327;
    // Op 328: dim3x3 add
    gl64_t s1_328_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_328_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_328_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_328_0; tmp3_7 = tmp3_7 + s1_328_1; tmp3_8 = tmp3_8 + s1_328_2;
    // Op 329: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 330: dim1x1 sub_swap
    gl64_t s0_330 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_330 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s1_330 - s0_330;
    // Op 331: dim3x3 add
    gl64_t s1_331_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_331_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_331_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_331_0; tmp3_10 = tmp3_10 + s1_331_1; tmp3_11 = tmp3_11 + s1_331_2;
    // Op 332: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 333: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 334: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 335: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 336: dim3x3 mul
    gl64_t s1_336_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_336_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_336_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA336 = (tmp3_0 + tmp3_1) * (s1_336_0 + s1_336_1);
    gl64_t kB336 = (tmp3_0 + tmp3_2) * (s1_336_0 + s1_336_2);
    gl64_t kC336 = (tmp3_1 + tmp3_2) * (s1_336_1 + s1_336_2);
    gl64_t kD336 = tmp3_0 * s1_336_0;
    gl64_t kE336 = tmp3_1 * s1_336_1;
    gl64_t kF336 = tmp3_2 * s1_336_2;
    gl64_t kG336 = kD336 - kE336;
    tmp3_12 = (kC336 + kG336) - kF336;
    tmp3_13 = ((((kA336 + kC336) - kE336) - kE336) - kD336);
    tmp3_14 = kB336 - kG336;
    // Op 337: dim3x1 mul
    gl64_t s0_337_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_337_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_337_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_337 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    tmp3_0 = s0_337_0 * s1_337; tmp3_1 = s0_337_1 * s1_337; tmp3_2 = s0_337_2 * s1_337;
    // Op 338: dim3x1 add
    gl64_t s1_338 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_338; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 339: dim3x3 mul
    gl64_t s1_339_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_339_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_339_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA339 = (tmp3_0 + tmp3_1) * (s1_339_0 + s1_339_1);
    gl64_t kB339 = (tmp3_0 + tmp3_2) * (s1_339_0 + s1_339_2);
    gl64_t kC339 = (tmp3_1 + tmp3_2) * (s1_339_1 + s1_339_2);
    gl64_t kD339 = tmp3_0 * s1_339_0;
    gl64_t kE339 = tmp3_1 * s1_339_1;
    gl64_t kF339 = tmp3_2 * s1_339_2;
    gl64_t kG339 = kD339 - kE339;
    tmp3_0 = (kC339 + kG339) - kF339;
    tmp3_1 = ((((kA339 + kC339) - kE339) - kE339) - kD339);
    tmp3_2 = kB339 - kG339;
    // Op 340: dim3x1 add
    gl64_t s1_340 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_340; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 341: dim3x3 mul
    gl64_t s1_341_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_341_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_341_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA341 = (tmp3_0 + tmp3_1) * (s1_341_0 + s1_341_1);
    gl64_t kB341 = (tmp3_0 + tmp3_2) * (s1_341_0 + s1_341_2);
    gl64_t kC341 = (tmp3_1 + tmp3_2) * (s1_341_1 + s1_341_2);
    gl64_t kD341 = tmp3_0 * s1_341_0;
    gl64_t kE341 = tmp3_1 * s1_341_1;
    gl64_t kF341 = tmp3_2 * s1_341_2;
    gl64_t kG341 = kD341 - kE341;
    tmp3_0 = (kC341 + kG341) - kF341;
    tmp3_1 = ((((kA341 + kC341) - kE341) - kE341) - kD341);
    tmp3_2 = kB341 - kG341;
    // Op 342: dim3x1 add
    gl64_t s1_342 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_342; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 343: dim3x3 mul
    gl64_t s1_343_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_343_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_343_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA343 = (tmp3_0 + tmp3_1) * (s1_343_0 + s1_343_1);
    gl64_t kB343 = (tmp3_0 + tmp3_2) * (s1_343_0 + s1_343_2);
    gl64_t kC343 = (tmp3_1 + tmp3_2) * (s1_343_1 + s1_343_2);
    gl64_t kD343 = tmp3_0 * s1_343_0;
    gl64_t kE343 = tmp3_1 * s1_343_1;
    gl64_t kF343 = tmp3_2 * s1_343_2;
    gl64_t kG343 = kD343 - kE343;
    tmp3_0 = (kC343 + kG343) - kF343;
    tmp3_1 = ((((kA343 + kC343) - kE343) - kE343) - kD343);
    tmp3_2 = kB343 - kG343;
    // Op 344: dim3x1 add
    gl64_t s1_344 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_344; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 346: dim1x1 sub_swap
    gl64_t s0_346 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = tmp1_2 - s0_346;
    // Op 347: dim1x1 mul
    gl64_t s0_347 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_347 = *(gl64_t*)&expressions_params[9][2];
    tmp1_4 = s0_347 * s1_347;
    // Op 348: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_4;
    // Op 349: dim1x1 mul
    gl64_t s0_349 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_349 = *(gl64_t*)&expressions_params[9][1];
    tmp1_4 = s0_349 * s1_349;
    // Op 350: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_4;
    // Op 351: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_353 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
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
    // Op 355: dim3x3 mul
    gl64_t s1_355_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_355_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_355_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA355 = (tmp3_0 + tmp3_1) * (s1_355_0 + s1_355_1);
    gl64_t kB355 = (tmp3_0 + tmp3_2) * (s1_355_0 + s1_355_2);
    gl64_t kC355 = (tmp3_1 + tmp3_2) * (s1_355_1 + s1_355_2);
    gl64_t kD355 = tmp3_0 * s1_355_0;
    gl64_t kE355 = tmp3_1 * s1_355_1;
    gl64_t kF355 = tmp3_2 * s1_355_2;
    gl64_t kG355 = kD355 - kE355;
    tmp3_0 = (kC355 + kG355) - kF355;
    tmp3_1 = ((((kA355 + kC355) - kE355) - kE355) - kD355);
    tmp3_2 = kB355 - kG355;
    // Op 356: dim1x1 mul
    gl64_t s0_356 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_356 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s0_356 * s1_356;
    // Op 357: dim1x1 add
    tmp1_0 = tmp1_5 + tmp1_0;
    // Op 358: dim1x1 mul
    gl64_t s0_358 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_358 = *(gl64_t*)&expressions_params[9][1];
    tmp1_5 = s0_358 * s1_358;
    // Op 359: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_5;
    // Op 360: dim1x1 mul
    gl64_t s0_360 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_360 = *(gl64_t*)&expressions_params[9][2];
    tmp1_5 = s0_360 * s1_360;
    // Op 361: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_5;
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
    // Op 364: dim1x1 mul
    gl64_t s0_364 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_364 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s0_364 * s1_364;
    // Op 365: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_0;
    // Op 366: dim1x1 mul
    gl64_t s0_366 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_366 = *(gl64_t*)&expressions_params[9][1];
    tmp1_3 = s0_366 * s1_366;
    // Op 367: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 368: dim1x1 mul
    gl64_t s0_368 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_368 = *(gl64_t*)&expressions_params[9][2];
    tmp1_3 = s0_368 * s1_368;
    // Op 369: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 370: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 371: dim3x3 mul
    gl64_t s1_371_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_371_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_371_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA371 = (tmp3_0 + tmp3_1) * (s1_371_0 + s1_371_1);
    gl64_t kB371 = (tmp3_0 + tmp3_2) * (s1_371_0 + s1_371_2);
    gl64_t kC371 = (tmp3_1 + tmp3_2) * (s1_371_1 + s1_371_2);
    gl64_t kD371 = tmp3_0 * s1_371_0;
    gl64_t kE371 = tmp3_1 * s1_371_1;
    gl64_t kF371 = tmp3_2 * s1_371_2;
    gl64_t kG371 = kD371 - kE371;
    tmp3_0 = (kC371 + kG371) - kF371;
    tmp3_1 = ((((kA371 + kC371) - kE371) - kE371) - kD371);
    tmp3_2 = kB371 - kG371;
    // Op 372: dim1x1 mul
    gl64_t s0_372 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_372 = *(gl64_t*)&expressions_params[9][8];
    tmp1_0 = s0_372 * s1_372;
    // Op 373: dim1x1 add
    gl64_t s0_373 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_373 + tmp1_0;
    // Op 374: dim1x1 mul
    gl64_t s0_374 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_374 = *(gl64_t*)&expressions_params[9][14];
    tmp1_3 = s0_374 * s1_374;
    // Op 375: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 376: dim1x1 mul
    gl64_t s0_376 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_376 = *(gl64_t*)&expressions_params[9][7];
    tmp1_3 = s0_376 * s1_376;
    // Op 377: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 378: dim1x1 add
    gl64_t s1_378 = *(gl64_t*)&expressions_params[9][23];
    tmp1_0 = tmp1_0 + s1_378;
    // Op 379: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 380: dim3x3 mul
    gl64_t s1_380_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_380_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_380_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA380 = (tmp3_0 + tmp3_1) * (s1_380_0 + s1_380_1);
    gl64_t kB380 = (tmp3_0 + tmp3_2) * (s1_380_0 + s1_380_2);
    gl64_t kC380 = (tmp3_1 + tmp3_2) * (s1_380_1 + s1_380_2);
    gl64_t kD380 = tmp3_0 * s1_380_0;
    gl64_t kE380 = tmp3_1 * s1_380_1;
    gl64_t kF380 = tmp3_2 * s1_380_2;
    gl64_t kG380 = kD380 - kE380;
    tmp3_0 = (kC380 + kG380) - kF380;
    tmp3_1 = ((((kA380 + kC380) - kE380) - kE380) - kD380);
    tmp3_2 = kB380 - kG380;
    // Op 381: dim3x1 add
    gl64_t s1_381 = *(gl64_t*)&expressions_params[9][15];
    tmp3_9 = tmp3_0 + s1_381; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 382: dim3x3 add
    gl64_t s1_382_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_382_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_382_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_382_0; tmp3_4 = tmp3_10 + s1_382_1; tmp3_5 = tmp3_11 + s1_382_2;
    // Op 383: dim3x1 mul
    gl64_t s0_383_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_383_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_383_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_383_0 * tmp1_1; tmp3_1 = s0_383_1 * tmp1_1; tmp3_2 = s0_383_2 * tmp1_1;
    // Op 384: dim3x1 add
    gl64_t s1_384 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_384; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 385: dim3x3 mul
    gl64_t s1_385_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_385_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_385_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA385 = (tmp3_0 + tmp3_1) * (s1_385_0 + s1_385_1);
    gl64_t kB385 = (tmp3_0 + tmp3_2) * (s1_385_0 + s1_385_2);
    gl64_t kC385 = (tmp3_1 + tmp3_2) * (s1_385_1 + s1_385_2);
    gl64_t kD385 = tmp3_0 * s1_385_0;
    gl64_t kE385 = tmp3_1 * s1_385_1;
    gl64_t kF385 = tmp3_2 * s1_385_2;
    gl64_t kG385 = kD385 - kE385;
    tmp3_0 = (kC385 + kG385) - kF385;
    tmp3_1 = ((((kA385 + kC385) - kE385) - kE385) - kD385);
    tmp3_2 = kB385 - kG385;
    // Op 386: dim1x1 mul
    gl64_t s0_386 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_386 = *(gl64_t*)&expressions_params[9][8];
    tmp1_1 = s0_386 * s1_386;
    // Op 387: dim1x1 add
    gl64_t s1_387 = *(gl64_t*)&expressions_params[9][21];
    tmp1_1 = tmp1_1 + s1_387;
    // Op 388: dim1x1 add
    gl64_t s1_388 = *(gl64_t*)&expressions_params[9][7];
    tmp1_1 = tmp1_1 + s1_388;
    // Op 389: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 390: dim3x3 mul
    gl64_t s1_390_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_390_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_390_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA390 = (tmp3_0 + tmp3_1) * (s1_390_0 + s1_390_1);
    gl64_t kB390 = (tmp3_0 + tmp3_2) * (s1_390_0 + s1_390_2);
    gl64_t kC390 = (tmp3_1 + tmp3_2) * (s1_390_1 + s1_390_2);
    gl64_t kD390 = tmp3_0 * s1_390_0;
    gl64_t kE390 = tmp3_1 * s1_390_1;
    gl64_t kF390 = tmp3_2 * s1_390_2;
    gl64_t kG390 = kD390 - kE390;
    tmp3_0 = (kC390 + kG390) - kF390;
    tmp3_1 = ((((kA390 + kC390) - kE390) - kE390) - kD390);
    tmp3_2 = kB390 - kG390;
    // Op 391: dim3x1 add
    gl64_t s1_391 = *(gl64_t*)&expressions_params[9][22];
    tmp3_0 = tmp3_0 + s1_391; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 392: dim3x3 mul
    gl64_t s1_392_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_392_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_392_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA392 = (tmp3_0 + tmp3_1) * (s1_392_0 + s1_392_1);
    gl64_t kB392 = (tmp3_0 + tmp3_2) * (s1_392_0 + s1_392_2);
    gl64_t kC392 = (tmp3_1 + tmp3_2) * (s1_392_1 + s1_392_2);
    gl64_t kD392 = tmp3_0 * s1_392_0;
    gl64_t kE392 = tmp3_1 * s1_392_1;
    gl64_t kF392 = tmp3_2 * s1_392_2;
    gl64_t kG392 = kD392 - kE392;
    tmp3_0 = (kC392 + kG392) - kF392;
    tmp3_1 = ((((kA392 + kC392) - kE392) - kE392) - kD392);
    tmp3_2 = kB392 - kG392;
    // Op 393: dim3x1 add
    gl64_t s1_393 = *(gl64_t*)&expressions_params[9][21];
    tmp3_0 = tmp3_0 + s1_393; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 395: dim3x1 add
    gl64_t s1_395 = *(gl64_t*)&expressions_params[9][23];
    tmp3_6 = tmp3_0 + s1_395; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 396: dim3x3 add
    gl64_t s1_396_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_396_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_396_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_396_0; tmp3_1 = tmp3_7 + s1_396_1; tmp3_2 = tmp3_8 + s1_396_2;
    // Op 397: dim3x3 mul
    gl64_t kA397 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB397 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC397 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD397 = tmp3_3 * tmp3_0;
    gl64_t kE397 = tmp3_4 * tmp3_1;
    gl64_t kF397 = tmp3_5 * tmp3_2;
    gl64_t kG397 = kD397 - kE397;
    tmp3_0 = (kC397 + kG397) - kF397;
    tmp3_1 = ((((kA397 + kC397) - kE397) - kE397) - kD397);
    tmp3_2 = kB397 - kG397;
    // Op 398: dim3x3 mul
    gl64_t s0_398_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_398_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_398_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    gl64_t kA398 = (s0_398_0 + s0_398_1) * (tmp3_0 + tmp3_1);
    gl64_t kB398 = (s0_398_0 + s0_398_2) * (tmp3_0 + tmp3_2);
    gl64_t kC398 = (s0_398_1 + s0_398_2) * (tmp3_1 + tmp3_2);
    gl64_t kD398 = s0_398_0 * tmp3_0;
    gl64_t kE398 = s0_398_1 * tmp3_1;
    gl64_t kF398 = s0_398_2 * tmp3_2;
    gl64_t kG398 = kD398 - kE398;
    tmp3_0 = (kC398 + kG398) - kF398;
    tmp3_1 = ((((kA398 + kC398) - kE398) - kE398) - kD398);
    tmp3_2 = kB398 - kG398;
    // Op 399: dim1x1 sub_swap
    gl64_t s0_399 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_399 = *(gl64_t*)&expressions_params[9][4];
    tmp1_1 = s1_399 - s0_399;
    // Op 400: dim3x3 add
    gl64_t s1_400_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_400_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_400_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_400_0; tmp3_7 = tmp3_7 + s1_400_1; tmp3_8 = tmp3_8 + s1_400_2;
    // Op 401: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_1; tmp3_7 = tmp3_7 * tmp1_1; tmp3_8 = tmp3_8 * tmp1_1;
    // Op 402: dim1x1 add
    gl64_t s0_402 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_402 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_1 = s0_402 + s1_402;
    // Op 403: dim1x1 add
    gl64_t s0_403 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_1 = s0_403 + tmp1_1;
    // Op 404: dim1x1 sub_swap
    gl64_t s0_404 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_1 = tmp1_1 - s0_404;
    // Op 405: dim1x1 sub_swap
    gl64_t s1_405 = *(gl64_t*)&expressions_params[9][4];
    tmp1_1 = s1_405 - tmp1_1;
    // Op 406: dim3x3 add
    gl64_t s1_406_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_406_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_406_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_406_0; tmp3_10 = tmp3_10 + s1_406_1; tmp3_11 = tmp3_11 + s1_406_2;
    // Op 407: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_1; tmp3_10 = tmp3_10 * tmp1_1; tmp3_11 = tmp3_11 * tmp1_1;
    // Op 408: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 409: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 410: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 411: dim3x3 mul
    gl64_t s1_411_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_411_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_411_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA411 = (tmp3_0 + tmp3_1) * (s1_411_0 + s1_411_1);
    gl64_t kB411 = (tmp3_0 + tmp3_2) * (s1_411_0 + s1_411_2);
    gl64_t kC411 = (tmp3_1 + tmp3_2) * (s1_411_1 + s1_411_2);
    gl64_t kD411 = tmp3_0 * s1_411_0;
    gl64_t kE411 = tmp3_1 * s1_411_1;
    gl64_t kF411 = tmp3_2 * s1_411_2;
    gl64_t kG411 = kD411 - kE411;
    tmp3_12 = (kC411 + kG411) - kF411;
    tmp3_13 = ((((kA411 + kC411) - kE411) - kE411) - kD411);
    tmp3_14 = kB411 - kG411;
    // Op 412: dim1x1 add
    gl64_t s0_412 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_412 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_1 = s0_412 + s1_412;
    // Op 413: dim1x1 mul
    gl64_t s0_413 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    tmp1_1 = s0_413 * tmp1_1;
    // Op 414: dim1x1 mul
    gl64_t s0_414 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_414 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_414 * s1_414;
    // Op 415: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 416: dim3x1 mul
    gl64_t s0_416_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_416_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_416_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_416_0 * tmp1_0; tmp3_1 = s0_416_1 * tmp1_0; tmp3_2 = s0_416_2 * tmp1_0;
    // Op 417: dim3x1 add
    gl64_t s1_417 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_417; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 418: dim3x3 mul
    gl64_t s1_418_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_418_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_418_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA418 = (tmp3_0 + tmp3_1) * (s1_418_0 + s1_418_1);
    gl64_t kB418 = (tmp3_0 + tmp3_2) * (s1_418_0 + s1_418_2);
    gl64_t kC418 = (tmp3_1 + tmp3_2) * (s1_418_1 + s1_418_2);
    gl64_t kD418 = tmp3_0 * s1_418_0;
    gl64_t kE418 = tmp3_1 * s1_418_1;
    gl64_t kF418 = tmp3_2 * s1_418_2;
    gl64_t kG418 = kD418 - kE418;
    tmp3_0 = (kC418 + kG418) - kF418;
    tmp3_1 = ((((kA418 + kC418) - kE418) - kE418) - kD418);
    tmp3_2 = kB418 - kG418;
    // Op 419: dim3x3 mul
    gl64_t s1_419_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_419_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_419_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA419 = (tmp3_0 + tmp3_1) * (s1_419_0 + s1_419_1);
    gl64_t kB419 = (tmp3_0 + tmp3_2) * (s1_419_0 + s1_419_2);
    gl64_t kC419 = (tmp3_1 + tmp3_2) * (s1_419_1 + s1_419_2);
    gl64_t kD419 = tmp3_0 * s1_419_0;
    gl64_t kE419 = tmp3_1 * s1_419_1;
    gl64_t kF419 = tmp3_2 * s1_419_2;
    gl64_t kG419 = kD419 - kE419;
    tmp3_0 = (kC419 + kG419) - kF419;
    tmp3_1 = ((((kA419 + kC419) - kE419) - kE419) - kD419);
    tmp3_2 = kB419 - kG419;
    // Op 420: dim1x1 add
    gl64_t s0_420 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_420 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    tmp1_0 = s0_420 + s1_420;
    // Op 421: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 422: dim3x3 mul
    gl64_t s1_422_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_422_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_422_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA422 = (tmp3_0 + tmp3_1) * (s1_422_0 + s1_422_1);
    gl64_t kB422 = (tmp3_0 + tmp3_2) * (s1_422_0 + s1_422_2);
    gl64_t kC422 = (tmp3_1 + tmp3_2) * (s1_422_1 + s1_422_2);
    gl64_t kD422 = tmp3_0 * s1_422_0;
    gl64_t kE422 = tmp3_1 * s1_422_1;
    gl64_t kF422 = tmp3_2 * s1_422_2;
    gl64_t kG422 = kD422 - kE422;
    tmp3_0 = (kC422 + kG422) - kF422;
    tmp3_1 = ((((kA422 + kC422) - kE422) - kE422) - kD422);
    tmp3_2 = kB422 - kG422;
    // Op 423: dim1x1 add
    gl64_t s0_423 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    gl64_t s1_423 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp1_3 = s0_423 + s1_423;
    // Op 424: dim1x1 mul
    gl64_t s0_424 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_424 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_424 * s1_424;
    // Op 425: dim1x1 mul
    gl64_t s0_425 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_425 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s0_425 * s1_425;
    // Op 426: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 427: dim1x1 add
    gl64_t s0_427 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_1 = s0_427 + tmp1_0;
    // Op 428: dim1x1 sub_swap
    gl64_t s0_428 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_428 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_428 - s0_428;
    // Op 429: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 430: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_0;
    // Op 431: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 432: dim3x3 mul
    gl64_t s1_432_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_432_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_432_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA432 = (tmp3_0 + tmp3_1) * (s1_432_0 + s1_432_1);
    gl64_t kB432 = (tmp3_0 + tmp3_2) * (s1_432_0 + s1_432_2);
    gl64_t kC432 = (tmp3_1 + tmp3_2) * (s1_432_1 + s1_432_2);
    gl64_t kD432 = tmp3_0 * s1_432_0;
    gl64_t kE432 = tmp3_1 * s1_432_1;
    gl64_t kF432 = tmp3_2 * s1_432_2;
    gl64_t kG432 = kD432 - kE432;
    tmp3_0 = (kC432 + kG432) - kF432;
    tmp3_1 = ((((kA432 + kC432) - kE432) - kE432) - kD432);
    tmp3_2 = kB432 - kG432;
    // Op 433: dim3x3 mul
    gl64_t s1_433_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_433_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_433_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA433 = (tmp3_0 + tmp3_1) * (s1_433_0 + s1_433_1);
    gl64_t kB433 = (tmp3_0 + tmp3_2) * (s1_433_0 + s1_433_2);
    gl64_t kC433 = (tmp3_1 + tmp3_2) * (s1_433_1 + s1_433_2);
    gl64_t kD433 = tmp3_0 * s1_433_0;
    gl64_t kE433 = tmp3_1 * s1_433_1;
    gl64_t kF433 = tmp3_2 * s1_433_2;
    gl64_t kG433 = kD433 - kE433;
    tmp3_0 = (kC433 + kG433) - kF433;
    tmp3_1 = ((((kA433 + kC433) - kE433) - kE433) - kD433);
    tmp3_2 = kB433 - kG433;
    // Op 434: dim1x1 mul
    gl64_t s0_434 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_434 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_434 * s1_434;
    // Op 435: dim1x1 mul
    gl64_t s0_435 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    gl64_t s1_435 = *(gl64_t*)&expressions_params[9][1];
    tmp1_3 = s0_435 * s1_435;
    // Op 436: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 437: dim1x1 add
    gl64_t s0_437 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_437 + tmp1_0;
    // Op 438: dim1x1 add
    gl64_t s0_438 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_438 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_3 = s0_438 + s1_438;
    // Op 439: dim1x1 mul
    tmp1_3 = tmp1_0 * tmp1_3;
    // Op 440: dim1x1 add
    gl64_t s0_440 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_440 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_440 + s1_440;
    // Op 441: dim1x1 mul
    tmp1_0 = tmp1_2 * tmp1_0;
    // Op 442: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_0;
    // Op 443: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 444: dim3x3 mul
    gl64_t s1_444_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_444_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_444_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA444 = (tmp3_0 + tmp3_1) * (s1_444_0 + s1_444_1);
    gl64_t kB444 = (tmp3_0 + tmp3_2) * (s1_444_0 + s1_444_2);
    gl64_t kC444 = (tmp3_1 + tmp3_2) * (s1_444_1 + s1_444_2);
    gl64_t kD444 = tmp3_0 * s1_444_0;
    gl64_t kE444 = tmp3_1 * s1_444_1;
    gl64_t kF444 = tmp3_2 * s1_444_2;
    gl64_t kG444 = kD444 - kE444;
    tmp3_0 = (kC444 + kG444) - kF444;
    tmp3_1 = ((((kA444 + kC444) - kE444) - kE444) - kD444);
    tmp3_2 = kB444 - kG444;
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
    // Op 446: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 447: dim3x3 mul
    gl64_t s1_447_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_447_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_447_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA447 = (tmp3_0 + tmp3_1) * (s1_447_0 + s1_447_1);
    gl64_t kB447 = (tmp3_0 + tmp3_2) * (s1_447_0 + s1_447_2);
    gl64_t kC447 = (tmp3_1 + tmp3_2) * (s1_447_1 + s1_447_2);
    gl64_t kD447 = tmp3_0 * s1_447_0;
    gl64_t kE447 = tmp3_1 * s1_447_1;
    gl64_t kF447 = tmp3_2 * s1_447_2;
    gl64_t kG447 = kD447 - kE447;
    tmp3_0 = (kC447 + kG447) - kF447;
    tmp3_1 = ((((kA447 + kC447) - kE447) - kE447) - kD447);
    tmp3_2 = kB447 - kG447;
    // Op 448: dim1x1 mul
    gl64_t s0_448 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_448 = *(gl64_t*)&expressions_params[9][24];
    tmp1_1 = s0_448 * s1_448;
    // Op 449: dim1x1 mul
    gl64_t s0_449 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_449 = *(gl64_t*)&expressions_params[9][25];
    tmp1_0 = s0_449 * s1_449;
    // Op 450: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 451: dim1x1 mul
    gl64_t s0_451 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_451 = *(gl64_t*)&expressions_params[9][26];
    tmp1_1 = s0_451 * s1_451;
    // Op 452: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 453: dim1x1 mul
    gl64_t s0_453 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_453 = *(gl64_t*)&expressions_params[9][27];
    tmp1_1 = s0_453 * s1_453;
    // Op 454: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 455: dim1x1 mul
    gl64_t s0_455 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_455 = *(gl64_t*)&expressions_params[9][19];
    tmp1_1 = s0_455 * s1_455;
    // Op 456: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 457: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 458: dim3x3 mul
    gl64_t s1_458_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_458_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_458_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA458 = (tmp3_0 + tmp3_1) * (s1_458_0 + s1_458_1);
    gl64_t kB458 = (tmp3_0 + tmp3_2) * (s1_458_0 + s1_458_2);
    gl64_t kC458 = (tmp3_1 + tmp3_2) * (s1_458_1 + s1_458_2);
    gl64_t kD458 = tmp3_0 * s1_458_0;
    gl64_t kE458 = tmp3_1 * s1_458_1;
    gl64_t kF458 = tmp3_2 * s1_458_2;
    gl64_t kG458 = kD458 - kE458;
    tmp3_0 = (kC458 + kG458) - kF458;
    tmp3_1 = ((((kA458 + kC458) - kE458) - kE458) - kD458);
    tmp3_2 = kB458 - kG458;
    // Op 459: dim3x1 add
    gl64_t s1_459 = *(gl64_t*)&expressions_params[9][20];
    tmp3_0 = tmp3_0 + s1_459; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 460: dim3x3 add
    gl64_t s1_460_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_460_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_460_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_460_0; tmp3_1 = tmp3_1 + s1_460_1; tmp3_2 = tmp3_2 + s1_460_2;
    // Op 461: dim3x3 mul
    gl64_t s0_461_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+0, domainSize, nCols_2))];
    gl64_t s0_461_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+1, domainSize, nCols_2))];
    gl64_t s0_461_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+2, domainSize, nCols_2))];
    gl64_t kA461 = (s0_461_0 + s0_461_1) * (tmp3_0 + tmp3_1);
    gl64_t kB461 = (s0_461_0 + s0_461_2) * (tmp3_0 + tmp3_2);
    gl64_t kC461 = (s0_461_1 + s0_461_2) * (tmp3_1 + tmp3_2);
    gl64_t kD461 = s0_461_0 * tmp3_0;
    gl64_t kE461 = s0_461_1 * tmp3_1;
    gl64_t kF461 = s0_461_2 * tmp3_2;
    gl64_t kG461 = kD461 - kE461;
    tmp3_0 = (kC461 + kG461) - kF461;
    tmp3_1 = ((((kA461 + kC461) - kE461) - kE461) - kD461);
    tmp3_2 = kB461 - kG461;
    // Op 462: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_6; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 463: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 464: dim3x3 mul
    gl64_t s1_464_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_464_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_464_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA464 = (tmp3_0 + tmp3_1) * (s1_464_0 + s1_464_1);
    gl64_t kB464 = (tmp3_0 + tmp3_2) * (s1_464_0 + s1_464_2);
    gl64_t kC464 = (tmp3_1 + tmp3_2) * (s1_464_1 + s1_464_2);
    gl64_t kD464 = tmp3_0 * s1_464_0;
    gl64_t kE464 = tmp3_1 * s1_464_1;
    gl64_t kF464 = tmp3_2 * s1_464_2;
    gl64_t kG464 = kD464 - kE464;
    tmp3_6 = (kC464 + kG464) - kF464;
    tmp3_7 = ((((kA464 + kC464) - kE464) - kE464) - kD464);
    tmp3_8 = kB464 - kG464;
    // Op 465: dim1x1 sub_swap
    gl64_t s0_465 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_465 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = s1_465 - s0_465;
    // Op 466: dim3x1 mul
    uint64_t s0_466_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_466_0 = *(gl64_t*)&dParams->aux_trace[s0_466_pos];
    gl64_t s0_466_1 = *(gl64_t*)&dParams->aux_trace[s0_466_pos + TILE_HEIGHT];
    gl64_t s0_466_2 = *(gl64_t*)&dParams->aux_trace[s0_466_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_466_0 * tmp1_0; tmp3_1 = s0_466_1 * tmp1_0; tmp3_2 = s0_466_2 * tmp1_0;
    // Op 467: dim3x3 sub
    uint64_t s0_467_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_467_0 = *(gl64_t*)&dParams->aux_trace[s0_467_pos];
    gl64_t s0_467_1 = *(gl64_t*)&dParams->aux_trace[s0_467_pos + TILE_HEIGHT];
    gl64_t s0_467_2 = *(gl64_t*)&dParams->aux_trace[s0_467_pos + 2*TILE_HEIGHT];
    tmp3_12 = s0_467_0 - tmp3_0; tmp3_13 = s0_467_1 - tmp3_1; tmp3_14 = s0_467_2 - tmp3_2;
    // Op 468: dim3x3 add
    gl64_t s0_468_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_468_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_468_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_468_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_468_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_468_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_0 = s0_468_0 + s1_468_0; tmp3_1 = s0_468_1 + s1_468_1; tmp3_2 = s0_468_2 + s1_468_2;
    // Op 469: dim3x3 add
    uint64_t s0_469_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_469_0 = *(gl64_t*)&dParams->aux_trace[s0_469_pos];
    gl64_t s0_469_1 = *(gl64_t*)&dParams->aux_trace[s0_469_pos + TILE_HEIGHT];
    gl64_t s0_469_2 = *(gl64_t*)&dParams->aux_trace[s0_469_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_469_0 + tmp3_0; tmp3_1 = s0_469_1 + tmp3_1; tmp3_2 = s0_469_2 + tmp3_2;
    // Op 470: dim3x3 add
    uint64_t s0_470_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_470_0 = *(gl64_t*)&dParams->aux_trace[s0_470_pos];
    gl64_t s0_470_1 = *(gl64_t*)&dParams->aux_trace[s0_470_pos + TILE_HEIGHT];
    gl64_t s0_470_2 = *(gl64_t*)&dParams->aux_trace[s0_470_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_470_0 + tmp3_0; tmp3_1 = s0_470_1 + tmp3_1; tmp3_2 = s0_470_2 + tmp3_2;
    // Op 471: dim3x3 add
    gl64_t s0_471_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_471_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_471_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    tmp3_0 = s0_471_0 + tmp3_0; tmp3_1 = s0_471_1 + tmp3_1; tmp3_2 = s0_471_2 + tmp3_2;
    // Op 472: dim3x3 add
    gl64_t s0_472_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+0, domainSize, nCols_2))];
    gl64_t s0_472_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+1, domainSize, nCols_2))];
    gl64_t s0_472_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+2, domainSize, nCols_2))];
    tmp3_0 = s0_472_0 + tmp3_0; tmp3_1 = s0_472_1 + tmp3_1; tmp3_2 = s0_472_2 + tmp3_2;
    // Op 473: dim3x3 sub
    tmp3_12 = tmp3_12 - tmp3_0; tmp3_13 = tmp3_13 - tmp3_1; tmp3_14 = tmp3_14 - tmp3_2;
    // Op 474: dim3x1 mul
    gl64_t s0_474_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_474_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_474_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_474 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp3_0 = s0_474_0 * s1_474; tmp3_1 = s0_474_1 * s1_474; tmp3_2 = s0_474_2 * s1_474;
    // Op 475: dim3x1 add
    gl64_t s1_475 = *(gl64_t*)&expressions_params[9][28];
    tmp3_0 = tmp3_0 + s1_475; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 476: dim3x3 add
    gl64_t s1_476_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_476_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_476_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_476_0; tmp3_1 = tmp3_1 + s1_476_1; tmp3_2 = tmp3_2 + s1_476_2;
    // Op 477: dim3x3 mul
    gl64_t kA477 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB477 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC477 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD477 = tmp3_12 * tmp3_0;
    gl64_t kE477 = tmp3_13 * tmp3_1;
    gl64_t kF477 = tmp3_14 * tmp3_2;
    gl64_t kG477 = kD477 - kE477;
    tmp3_0 = (kC477 + kG477) - kF477;
    tmp3_1 = ((((kA477 + kC477) - kE477) - kE477) - kD477);
    tmp3_2 = kB477 - kG477;
    // Op 478: dim1x1 sub_swap
    gl64_t s1_478 = *(gl64_t*)&expressions_params[9][4];
    tmp1_6 = s1_478 - tmp1_6;
    // Op 479: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_6; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 480: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 481: dim3x3 mul
    gl64_t s1_481_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_481_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_481_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA481 = (tmp3_0 + tmp3_1) * (s1_481_0 + s1_481_1);
    gl64_t kB481 = (tmp3_0 + tmp3_2) * (s1_481_0 + s1_481_2);
    gl64_t kC481 = (tmp3_1 + tmp3_2) * (s1_481_1 + s1_481_2);
    gl64_t kD481 = tmp3_0 * s1_481_0;
    gl64_t kE481 = tmp3_1 * s1_481_1;
    gl64_t kF481 = tmp3_2 * s1_481_2;
    gl64_t kG481 = kD481 - kE481;
    tmp3_6 = (kC481 + kG481) - kF481;
    tmp3_7 = ((((kA481 + kC481) - kE481) - kE481) - kD481);
    tmp3_8 = kB481 - kG481;
    // Op 482: dim3x3 sub_swap
    uint64_t s0_482_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_482_0 = *(gl64_t*)&dParams->aux_trace[s0_482_pos];
    gl64_t s0_482_1 = *(gl64_t*)&dParams->aux_trace[s0_482_pos + TILE_HEIGHT];
    gl64_t s0_482_2 = *(gl64_t*)&dParams->aux_trace[s0_482_pos + 2*TILE_HEIGHT];
    gl64_t s1_482_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_482_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_482_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_0 = s1_482_0 - s0_482_0; tmp3_1 = s1_482_1 - s0_482_1; tmp3_2 = s1_482_2 - s0_482_2;
    // Op 483: dim3x1 mul
    gl64_t s1_483 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_483; tmp3_1 = tmp3_1 * s1_483; tmp3_2 = tmp3_2 * s1_483;
    // Op 484: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 485: dim3x1 mul
    gl64_t s1_485 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_485; tmp3_1 = tmp3_1 * s1_485; tmp3_2 = tmp3_2 * s1_485;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
