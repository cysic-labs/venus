// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: 225bfe59  nOps=677 nTemp1=6 nTemp3=5
#define GENERATED_EVAL_NOPS_225bfe59 677
#define GENERATED_EVAL_NTEMP1_225bfe59 6
#define GENERATED_EVAL_NTEMP3_225bfe59 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_225bfe59(
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

    // Register-resident temporaries: 6 tmp1 + 15 tmp3 slots
    gl64_t tmp1_0 = gl64_t(uint64_t(0));
    gl64_t tmp1_1 = gl64_t(uint64_t(0));
    gl64_t tmp1_2 = gl64_t(uint64_t(0));
    gl64_t tmp1_3 = gl64_t(uint64_t(0));
    gl64_t tmp1_4 = gl64_t(uint64_t(0));
    gl64_t tmp1_5 = gl64_t(uint64_t(0));
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

    // Op 0: dim1x1 sub
    gl64_t s0_0 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_0 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_0 - s1_0;
    // Op 1: dim1x1 mul
    gl64_t s1_1 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = tmp1_0 * s1_1;
    // Op 2: dim3x1 mul
    gl64_t s0_2_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s0_2_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s0_2_2 = *(gl64_t*)&expressions_params[13][6+2];
    tmp3_0 = s0_2_0 * tmp1_0; tmp3_1 = s0_2_1 * tmp1_0; tmp3_2 = s0_2_2 * tmp1_0;
    // Op 3: dim1x1 sub
    gl64_t s0_3 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_3 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s0_3 - s1_3;
    // Op 4: dim1x1 mul
    gl64_t s1_4 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = tmp1_0 * s1_4;
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
    // Op 7: dim1x1 sub
    gl64_t s0_7 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_7 = *(gl64_t*)&expressions_params[10][11];
    tmp1_0 = s0_7 - s1_7;
    // Op 8: dim1x1 mul
    gl64_t s1_8 = *(gl64_t*)&expressions_params[10][11];
    tmp1_0 = tmp1_0 * s1_8;
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
    // Op 11: dim1x1 sub
    gl64_t s0_11 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_11 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s0_11 - s1_11;
    // Op 12: dim1x1 mul
    gl64_t s1_12 = *(gl64_t*)&expressions_params[10][11];
    tmp1_0 = tmp1_0 * s1_12;
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
    gl64_t s0_15 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_15 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_15 - s0_15;
    // Op 16: dim1x1 mul
    gl64_t s0_16 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
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
    // Op 19: dim1x1 sub_swap
    gl64_t s0_19 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 1, domainSize, nCols_1))];
    gl64_t s1_19 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s1_19 - s0_19;
    // Op 20: dim1x1 mul
    gl64_t s0_20 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_0 = s0_20 * tmp1_0;
    // Op 21: dim1x1 add
    gl64_t s0_21 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 1, domainSize, nCols_1))];
    tmp1_0 = s0_21 + tmp1_0;
    // Op 22: dim1x1 sub
    gl64_t s0_22 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_22 - tmp1_0;
    // Op 23: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 24: dim3x3 mul
    gl64_t s1_24_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_24_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_24_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA24 = (tmp3_0 + tmp3_1) * (s1_24_0 + s1_24_1);
    gl64_t kB24 = (tmp3_0 + tmp3_2) * (s1_24_0 + s1_24_2);
    gl64_t kC24 = (tmp3_1 + tmp3_2) * (s1_24_1 + s1_24_2);
    gl64_t kD24 = tmp3_0 * s1_24_0;
    gl64_t kE24 = tmp3_1 * s1_24_1;
    gl64_t kF24 = tmp3_2 * s1_24_2;
    gl64_t kG24 = kD24 - kE24;
    tmp3_0 = (kC24 + kG24) - kF24;
    tmp3_1 = ((((kA24 + kC24) - kE24) - kE24) - kD24);
    tmp3_2 = kB24 - kG24;
    // Op 25: dim1x1 sub_swap
    gl64_t s0_25 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_25 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_25 - s0_25;
    // Op 26: dim1x1 mul
    gl64_t s0_26 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_26 * tmp1_0;
    // Op 27: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 28: dim3x3 mul
    gl64_t s1_28_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_28_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_28_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA28 = (tmp3_0 + tmp3_1) * (s1_28_0 + s1_28_1);
    gl64_t kB28 = (tmp3_0 + tmp3_2) * (s1_28_0 + s1_28_2);
    gl64_t kC28 = (tmp3_1 + tmp3_2) * (s1_28_1 + s1_28_2);
    gl64_t kD28 = tmp3_0 * s1_28_0;
    gl64_t kE28 = tmp3_1 * s1_28_1;
    gl64_t kF28 = tmp3_2 * s1_28_2;
    gl64_t kG28 = kD28 - kE28;
    tmp3_0 = (kC28 + kG28) - kF28;
    tmp3_1 = ((((kA28 + kC28) - kE28) - kE28) - kD28);
    tmp3_2 = kB28 - kG28;
    // Op 29: dim1x1 sub_swap
    gl64_t s0_29 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_29 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_29 - s0_29;
    // Op 30: dim1x1 mul
    gl64_t s0_30 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_30 * tmp1_0;
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
    // Op 33: dim1x1 sub_swap
    gl64_t s0_33 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_33 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_33 - s0_33;
    // Op 34: dim1x1 mul
    gl64_t s0_34 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_34 * tmp1_0;
    // Op 35: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s0_37 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_37 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_37 - s0_37;
    // Op 38: dim1x1 mul
    gl64_t s0_38 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_38 * tmp1_0;
    // Op 39: dim1x1 sub
    gl64_t s0_39 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_39 = *(gl64_t*)&expressions_params[10][15];
    tmp1_1 = s0_39 - s1_39;
    // Op 40: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 41: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 42: dim3x3 mul
    gl64_t s1_42_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_42_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_42_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA42 = (tmp3_0 + tmp3_1) * (s1_42_0 + s1_42_1);
    gl64_t kB42 = (tmp3_0 + tmp3_2) * (s1_42_0 + s1_42_2);
    gl64_t kC42 = (tmp3_1 + tmp3_2) * (s1_42_1 + s1_42_2);
    gl64_t kD42 = tmp3_0 * s1_42_0;
    gl64_t kE42 = tmp3_1 * s1_42_1;
    gl64_t kF42 = tmp3_2 * s1_42_2;
    gl64_t kG42 = kD42 - kE42;
    tmp3_0 = (kC42 + kG42) - kF42;
    tmp3_1 = ((((kA42 + kC42) - kE42) - kE42) - kD42);
    tmp3_2 = kB42 - kG42;
    // Op 43: dim1x1 sub_swap
    gl64_t s0_43 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_43 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_43 - s0_43;
    // Op 44: dim1x1 mul
    gl64_t s0_44 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_44 * tmp1_0;
    // Op 45: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 46: dim3x3 mul
    gl64_t s1_46_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_46_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_46_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA46 = (tmp3_0 + tmp3_1) * (s1_46_0 + s1_46_1);
    gl64_t kB46 = (tmp3_0 + tmp3_2) * (s1_46_0 + s1_46_2);
    gl64_t kC46 = (tmp3_1 + tmp3_2) * (s1_46_1 + s1_46_2);
    gl64_t kD46 = tmp3_0 * s1_46_0;
    gl64_t kE46 = tmp3_1 * s1_46_1;
    gl64_t kF46 = tmp3_2 * s1_46_2;
    gl64_t kG46 = kD46 - kE46;
    tmp3_0 = (kC46 + kG46) - kF46;
    tmp3_1 = ((((kA46 + kC46) - kE46) - kE46) - kD46);
    tmp3_2 = kB46 - kG46;
    // Op 47: dim1x1 mul
    gl64_t s0_47 = *(gl64_t*)&expressions_params[10][15];
    gl64_t s1_47 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s0_47 * s1_47;
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
    gl64_t s0_50 = *(gl64_t*)&expressions_params[10][14];
    gl64_t s1_50 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_50 * s1_50;
    // Op 51: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 52: dim3x3 mul
    gl64_t s1_52_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_52_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_52_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA52 = (tmp3_0 + tmp3_1) * (s1_52_0 + s1_52_1);
    gl64_t kB52 = (tmp3_0 + tmp3_2) * (s1_52_0 + s1_52_2);
    gl64_t kC52 = (tmp3_1 + tmp3_2) * (s1_52_1 + s1_52_2);
    gl64_t kD52 = tmp3_0 * s1_52_0;
    gl64_t kE52 = tmp3_1 * s1_52_1;
    gl64_t kF52 = tmp3_2 * s1_52_2;
    gl64_t kG52 = kD52 - kE52;
    tmp3_0 = (kC52 + kG52) - kF52;
    tmp3_1 = ((((kA52 + kC52) - kE52) - kE52) - kD52);
    tmp3_2 = kB52 - kG52;
    // Op 53: dim1x1 sub_swap
    gl64_t s0_53 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_53 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_53 - s0_53;
    // Op 54: dim1x1 mul
    gl64_t s0_54 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_54 * tmp1_0;
    // Op 55: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 56: dim3x3 mul
    gl64_t s1_56_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_56_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_56_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA56 = (tmp3_0 + tmp3_1) * (s1_56_0 + s1_56_1);
    gl64_t kB56 = (tmp3_0 + tmp3_2) * (s1_56_0 + s1_56_2);
    gl64_t kC56 = (tmp3_1 + tmp3_2) * (s1_56_1 + s1_56_2);
    gl64_t kD56 = tmp3_0 * s1_56_0;
    gl64_t kE56 = tmp3_1 * s1_56_1;
    gl64_t kF56 = tmp3_2 * s1_56_2;
    gl64_t kG56 = kD56 - kE56;
    tmp3_0 = (kC56 + kG56) - kF56;
    tmp3_1 = ((((kA56 + kC56) - kE56) - kE56) - kD56);
    tmp3_2 = kB56 - kG56;
    // Op 57: dim1x1 sub_swap
    gl64_t s0_57 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_57 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_57 - s0_57;
    // Op 58: dim1x1 mul
    gl64_t s0_58 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_58 * tmp1_0;
    // Op 59: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 60: dim3x3 mul
    gl64_t s1_60_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_60_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_60_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA60 = (tmp3_0 + tmp3_1) * (s1_60_0 + s1_60_1);
    gl64_t kB60 = (tmp3_0 + tmp3_2) * (s1_60_0 + s1_60_2);
    gl64_t kC60 = (tmp3_1 + tmp3_2) * (s1_60_1 + s1_60_2);
    gl64_t kD60 = tmp3_0 * s1_60_0;
    gl64_t kE60 = tmp3_1 * s1_60_1;
    gl64_t kF60 = tmp3_2 * s1_60_2;
    gl64_t kG60 = kD60 - kE60;
    tmp3_0 = (kC60 + kG60) - kF60;
    tmp3_1 = ((((kA60 + kC60) - kE60) - kE60) - kD60);
    tmp3_2 = kB60 - kG60;
    // Op 61: dim1x1 sub_swap
    gl64_t s0_61 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_61 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_61 - s0_61;
    // Op 62: dim1x1 mul
    gl64_t s0_62 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_62 * tmp1_0;
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
    gl64_t s0_65 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_65 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_65 + s1_65;
    // Op 66: dim1x1 add
    gl64_t s0_66 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_5 = s0_66 + tmp1_0;
    // Op 67: dim1x1 sub_swap
    gl64_t s1_67 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_67 - tmp1_5;
    // Op 68: dim1x1 mul
    tmp1_0 = tmp1_5 * tmp1_0;
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
    gl64_t s0_71 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_71 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_71 - s0_71;
    // Op 72: dim1x1 mul
    gl64_t s0_72 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
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
    gl64_t s1_75 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_75 - tmp1_5;
    // Op 76: dim1x1 mul
    gl64_t s0_76 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
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
    gl64_t s0_79 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_79 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_79 - s0_79;
    // Op 80: dim1x1 mul
    gl64_t s0_80 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
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
    gl64_t s0_83 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_83 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_83 - s0_83;
    // Op 84: dim1x1 mul
    gl64_t s0_84 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
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
    gl64_t s0_87 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_87 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_87 - s0_87;
    // Op 88: dim1x1 mul
    gl64_t s0_88 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
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
    // Op 91: dim1x1 sub_swap
    gl64_t s0_91 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_91 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_91 - s0_91;
    // Op 92: dim1x1 mul
    gl64_t s0_92 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_92 * tmp1_0;
    // Op 93: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 94: dim3x3 mul
    gl64_t s1_94_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_94_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_94_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA94 = (tmp3_0 + tmp3_1) * (s1_94_0 + s1_94_1);
    gl64_t kB94 = (tmp3_0 + tmp3_2) * (s1_94_0 + s1_94_2);
    gl64_t kC94 = (tmp3_1 + tmp3_2) * (s1_94_1 + s1_94_2);
    gl64_t kD94 = tmp3_0 * s1_94_0;
    gl64_t kE94 = tmp3_1 * s1_94_1;
    gl64_t kF94 = tmp3_2 * s1_94_2;
    gl64_t kG94 = kD94 - kE94;
    tmp3_0 = (kC94 + kG94) - kF94;
    tmp3_1 = ((((kA94 + kC94) - kE94) - kE94) - kD94);
    tmp3_2 = kB94 - kG94;
    // Op 95: dim1x1 sub
    gl64_t s0_95 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_95 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s0_95 - s1_95;
    // Op 96: dim1x1 mul
    gl64_t s0_96 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_96 * tmp1_0;
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
    gl64_t s0_99 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_99 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_99 - s0_99;
    // Op 100: dim1x1 mul
    gl64_t s0_100 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_100 * tmp1_0;
    // Op 101: dim1x1 sub
    gl64_t s0_101 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_101 = *(gl64_t*)&expressions_params[10][7];
    tmp1_1 = s0_101 - s1_101;
    // Op 102: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
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
    // Op 105: dim1x1 sub_swap
    gl64_t s0_105 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_105 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_105 - s0_105;
    // Op 106: dim1x1 mul
    gl64_t s0_106 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_106 * tmp1_0;
    // Op 107: dim1x1 sub
    gl64_t s0_107 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_107 = *(gl64_t*)&expressions_params[10][8];
    tmp1_1 = s0_107 - s1_107;
    // Op 108: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
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
    gl64_t s0_111 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_111 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_111 - s0_111;
    // Op 112: dim1x1 mul
    gl64_t s0_112 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_112 * tmp1_0;
    // Op 113: dim1x1 sub
    gl64_t s0_113 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_113 = *(gl64_t*)&expressions_params[10][9];
    tmp1_1 = s0_113 - s1_113;
    // Op 114: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
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
    gl64_t s0_117 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_117 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_117 - s0_117;
    // Op 118: dim1x1 mul
    gl64_t s0_118 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_2 = s0_118 * tmp1_0;
    // Op 119: dim1x1 mul
    gl64_t s0_119 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_119 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s0_119 * s1_119;
    // Op 120: dim1x1 add
    gl64_t s0_120 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_120 + tmp1_0;
    // Op 121: dim1x1 mul
    gl64_t s0_121 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_121 = *(gl64_t*)&expressions_params[9][2];
    tmp1_1 = s0_121 * s1_121;
    // Op 122: dim1x1 add
    tmp1_4 = tmp1_0 + tmp1_1;
    // Op 123: dim1x1 sub
    gl64_t s1_123 = *(gl64_t*)&expressions_params[10][10];
    tmp1_0 = tmp1_4 - s1_123;
    // Op 124: dim1x1 mul
    tmp1_0 = tmp1_2 * tmp1_0;
    // Op 125: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 126: dim3x3 mul
    gl64_t s1_126_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_126_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_126_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA126 = (tmp3_0 + tmp3_1) * (s1_126_0 + s1_126_1);
    gl64_t kB126 = (tmp3_0 + tmp3_2) * (s1_126_0 + s1_126_2);
    gl64_t kC126 = (tmp3_1 + tmp3_2) * (s1_126_1 + s1_126_2);
    gl64_t kD126 = tmp3_0 * s1_126_0;
    gl64_t kE126 = tmp3_1 * s1_126_1;
    gl64_t kF126 = tmp3_2 * s1_126_2;
    gl64_t kG126 = kD126 - kE126;
    tmp3_0 = (kC126 + kG126) - kF126;
    tmp3_1 = ((((kA126 + kC126) - kE126) - kE126) - kD126);
    tmp3_2 = kB126 - kG126;
    // Op 127: dim1x1 mul
    gl64_t s0_127 = *(gl64_t*)&expressions_params[10][7];
    gl64_t s1_127 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s0_127 * s1_127;
    // Op 128: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 129: dim3x3 mul
    gl64_t s1_129_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_129_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_129_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA129 = (tmp3_0 + tmp3_1) * (s1_129_0 + s1_129_1);
    gl64_t kB129 = (tmp3_0 + tmp3_2) * (s1_129_0 + s1_129_2);
    gl64_t kC129 = (tmp3_1 + tmp3_2) * (s1_129_1 + s1_129_2);
    gl64_t kD129 = tmp3_0 * s1_129_0;
    gl64_t kE129 = tmp3_1 * s1_129_1;
    gl64_t kF129 = tmp3_2 * s1_129_2;
    gl64_t kG129 = kD129 - kE129;
    tmp3_0 = (kC129 + kG129) - kF129;
    tmp3_1 = ((((kA129 + kC129) - kE129) - kE129) - kD129);
    tmp3_2 = kB129 - kG129;
    // Op 130: dim1x1 mul
    gl64_t s0_130 = *(gl64_t*)&expressions_params[10][9];
    gl64_t s1_130 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s0_130 * s1_130;
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
    // Op 133: dim1x1 mul
    gl64_t s0_133 = *(gl64_t*)&expressions_params[10][8];
    gl64_t s1_133 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s0_133 * s1_133;
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
    // Op 136: dim1x1 mul
    gl64_t s0_136 = *(gl64_t*)&expressions_params[10][10];
    gl64_t s1_136 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s0_136 * s1_136;
    // Op 137: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 138: dim3x3 mul
    gl64_t s1_138_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_138_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_138_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA138 = (tmp3_0 + tmp3_1) * (s1_138_0 + s1_138_1);
    gl64_t kB138 = (tmp3_0 + tmp3_2) * (s1_138_0 + s1_138_2);
    gl64_t kC138 = (tmp3_1 + tmp3_2) * (s1_138_1 + s1_138_2);
    gl64_t kD138 = tmp3_0 * s1_138_0;
    gl64_t kE138 = tmp3_1 * s1_138_1;
    gl64_t kF138 = tmp3_2 * s1_138_2;
    gl64_t kG138 = kD138 - kE138;
    tmp3_0 = (kC138 + kG138) - kF138;
    tmp3_1 = ((((kA138 + kC138) - kE138) - kE138) - kD138);
    tmp3_2 = kB138 - kG138;
    // Op 139: dim1x1 mul
    gl64_t s0_139 = *(gl64_t*)&expressions_params[10][2];
    gl64_t s1_139 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_139 * s1_139;
    // Op 140: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 141: dim3x3 mul
    gl64_t s1_141_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_141_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_141_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 142: dim1x1 mul
    gl64_t s0_142 = *(gl64_t*)&expressions_params[10][4];
    gl64_t s1_142 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_142 * s1_142;
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
    // Op 145: dim1x1 mul
    gl64_t s0_145 = *(gl64_t*)&expressions_params[10][3];
    gl64_t s1_145 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_145 * s1_145;
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
    // Op 148: dim1x1 mul
    gl64_t s0_148 = *(gl64_t*)&expressions_params[10][5];
    gl64_t s1_148 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_148 * s1_148;
    // Op 149: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 150: dim3x3 mul
    gl64_t s1_150_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_150_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_150_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA150 = (tmp3_0 + tmp3_1) * (s1_150_0 + s1_150_1);
    gl64_t kB150 = (tmp3_0 + tmp3_2) * (s1_150_0 + s1_150_2);
    gl64_t kC150 = (tmp3_1 + tmp3_2) * (s1_150_1 + s1_150_2);
    gl64_t kD150 = tmp3_0 * s1_150_0;
    gl64_t kE150 = tmp3_1 * s1_150_1;
    gl64_t kF150 = tmp3_2 * s1_150_2;
    gl64_t kG150 = kD150 - kE150;
    tmp3_0 = (kC150 + kG150) - kF150;
    tmp3_1 = ((((kA150 + kC150) - kE150) - kE150) - kD150);
    tmp3_2 = kB150 - kG150;
    // Op 151: dim1x1 sub_swap
    gl64_t s0_151 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_151 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_151 - s0_151;
    // Op 152: dim1x1 mul
    gl64_t s0_152 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_152 * tmp1_0;
    // Op 153: dim1x1 sub
    gl64_t s0_153 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_153 = *(gl64_t*)&expressions_params[10][13];
    tmp1_2 = s0_153 - s1_153;
    // Op 154: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_2;
    // Op 155: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 156: dim3x3 mul
    gl64_t s1_156_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_156_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_156_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA156 = (tmp3_0 + tmp3_1) * (s1_156_0 + s1_156_1);
    gl64_t kB156 = (tmp3_0 + tmp3_2) * (s1_156_0 + s1_156_2);
    gl64_t kC156 = (tmp3_1 + tmp3_2) * (s1_156_1 + s1_156_2);
    gl64_t kD156 = tmp3_0 * s1_156_0;
    gl64_t kE156 = tmp3_1 * s1_156_1;
    gl64_t kF156 = tmp3_2 * s1_156_2;
    gl64_t kG156 = kD156 - kE156;
    tmp3_0 = (kC156 + kG156) - kF156;
    tmp3_1 = ((((kA156 + kC156) - kE156) - kE156) - kD156);
    tmp3_2 = kB156 - kG156;
    // Op 157: dim1x1 mul
    gl64_t s0_157 = *(gl64_t*)&expressions_params[10][12];
    gl64_t s1_157 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_157 * s1_157;
    // Op 158: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 159: dim3x3 mul
    gl64_t s1_159_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_159_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_159_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA159 = (tmp3_0 + tmp3_1) * (s1_159_0 + s1_159_1);
    gl64_t kB159 = (tmp3_0 + tmp3_2) * (s1_159_0 + s1_159_2);
    gl64_t kC159 = (tmp3_1 + tmp3_2) * (s1_159_1 + s1_159_2);
    gl64_t kD159 = tmp3_0 * s1_159_0;
    gl64_t kE159 = tmp3_1 * s1_159_1;
    gl64_t kF159 = tmp3_2 * s1_159_2;
    gl64_t kG159 = kD159 - kE159;
    tmp3_0 = (kC159 + kG159) - kF159;
    tmp3_1 = ((((kA159 + kC159) - kE159) - kE159) - kD159);
    tmp3_2 = kB159 - kG159;
    // Op 160: dim1x1 mul
    gl64_t s0_160 = *(gl64_t*)&expressions_params[10][13];
    gl64_t s1_160 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s0_160 * s1_160;
    // Op 161: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 162: dim3x3 mul
    gl64_t s1_162_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_162_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_162_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA162 = (tmp3_0 + tmp3_1) * (s1_162_0 + s1_162_1);
    gl64_t kB162 = (tmp3_0 + tmp3_2) * (s1_162_0 + s1_162_2);
    gl64_t kC162 = (tmp3_1 + tmp3_2) * (s1_162_1 + s1_162_2);
    gl64_t kD162 = tmp3_0 * s1_162_0;
    gl64_t kE162 = tmp3_1 * s1_162_1;
    gl64_t kF162 = tmp3_2 * s1_162_2;
    gl64_t kG162 = kD162 - kE162;
    tmp3_0 = (kC162 + kG162) - kF162;
    tmp3_1 = ((((kA162 + kC162) - kE162) - kE162) - kD162);
    tmp3_2 = kB162 - kG162;
    // Op 163: dim1x1 sub_swap
    gl64_t s0_163 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_163 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_163 - s0_163;
    // Op 164: dim1x1 mul
    gl64_t s0_164 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_164 * tmp1_0;
    // Op 165: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 166: dim3x3 mul
    gl64_t s1_166_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_166_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_166_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 167: dim1x1 add
    gl64_t s0_167 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_167 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_3 = s0_167 + s1_167;
    // Op 168: dim1x1 mul
    tmp1_0 = tmp1_5 * tmp1_3;
    // Op 169: dim1x1 sub
    gl64_t s0_169 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_169 - tmp1_0;
    // Op 170: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 171: dim3x3 mul
    gl64_t s1_171_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_171_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_171_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA171 = (tmp3_0 + tmp3_1) * (s1_171_0 + s1_171_1);
    gl64_t kB171 = (tmp3_0 + tmp3_2) * (s1_171_0 + s1_171_2);
    gl64_t kC171 = (tmp3_1 + tmp3_2) * (s1_171_1 + s1_171_2);
    gl64_t kD171 = tmp3_0 * s1_171_0;
    gl64_t kE171 = tmp3_1 * s1_171_1;
    gl64_t kF171 = tmp3_2 * s1_171_2;
    gl64_t kG171 = kD171 - kE171;
    tmp3_0 = (kC171 + kG171) - kF171;
    tmp3_1 = ((((kA171 + kC171) - kE171) - kE171) - kD171);
    tmp3_2 = kB171 - kG171;
    // Op 172: dim1x1 mul
    gl64_t s0_172 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_1 = s0_172 * tmp1_5;
    // Op 173: dim1x1 mul
    gl64_t s0_173 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_173 = *(gl64_t*)&expressions_params[9][16];
    tmp1_0 = s0_173 * s1_173;
    // Op 174: dim1x1 add
    gl64_t s0_174 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_174 + tmp1_0;
    // Op 175: dim1x1 mul
    gl64_t s0_175 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_175 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_175 * s1_175;
    // Op 176: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 177: dim1x1 mul
    gl64_t s0_177 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_177 = *(gl64_t*)&expressions_params[9][18];
    tmp1_2 = s0_177 * s1_177;
    // Op 178: dim1x1 add
    tmp1_2 = tmp1_0 + tmp1_2;
    // Op 179: dim1x1 sub
    gl64_t s0_179 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_179 - tmp1_2;
    // Op 180: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 181: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 182: dim3x3 mul
    gl64_t s1_182_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_182_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_182_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 183: dim1x1 mul
    gl64_t s0_183 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_183 * tmp1_5;
    // Op 184: dim1x1 sub
    gl64_t s0_184 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_1 = s0_184 - tmp1_2;
    // Op 185: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
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
    // Op 188: dim1x1 sub_swap
    gl64_t s0_188 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_188 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_188 - s0_188;
    // Op 189: dim1x1 mul
    gl64_t s0_189 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = s0_189 * tmp1_0;
    // Op 190: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 191: dim3x3 mul
    gl64_t s1_191_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_191_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_191_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 192: dim1x1 mul
    gl64_t s0_192 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_0 = s0_192 * tmp1_3;
    // Op 193: dim1x1 sub
    gl64_t s0_193 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = s0_193 - tmp1_0;
    // Op 194: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 195: dim3x3 mul
    gl64_t s1_195_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_195_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_195_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 196: dim1x1 mul
    gl64_t s0_196 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_196 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_196 * s1_196;
    // Op 197: dim1x1 sub
    gl64_t s0_197 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp1_1 = s0_197 - tmp1_2;
    // Op 198: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 199: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 200: dim3x3 mul
    gl64_t s1_200_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_200_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_200_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA200 = (tmp3_0 + tmp3_1) * (s1_200_0 + s1_200_1);
    gl64_t kB200 = (tmp3_0 + tmp3_2) * (s1_200_0 + s1_200_2);
    gl64_t kC200 = (tmp3_1 + tmp3_2) * (s1_200_1 + s1_200_2);
    gl64_t kD200 = tmp3_0 * s1_200_0;
    gl64_t kE200 = tmp3_1 * s1_200_1;
    gl64_t kF200 = tmp3_2 * s1_200_2;
    gl64_t kG200 = kD200 - kE200;
    tmp3_0 = (kC200 + kG200) - kF200;
    tmp3_1 = ((((kA200 + kC200) - kE200) - kE200) - kD200);
    tmp3_2 = kB200 - kG200;
    // Op 201: dim1x1 mul
    gl64_t s0_201 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_201 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_201 * s1_201;
    // Op 202: dim1x1 sub
    gl64_t s0_202 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_1 = s0_202 - tmp1_2;
    // Op 203: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 204: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 205: dim3x3 mul
    gl64_t s1_205_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_205_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_205_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA205 = (tmp3_0 + tmp3_1) * (s1_205_0 + s1_205_1);
    gl64_t kB205 = (tmp3_0 + tmp3_2) * (s1_205_0 + s1_205_2);
    gl64_t kC205 = (tmp3_1 + tmp3_2) * (s1_205_1 + s1_205_2);
    gl64_t kD205 = tmp3_0 * s1_205_0;
    gl64_t kE205 = tmp3_1 * s1_205_1;
    gl64_t kF205 = tmp3_2 * s1_205_2;
    gl64_t kG205 = kD205 - kE205;
    tmp3_0 = (kC205 + kG205) - kF205;
    tmp3_1 = ((((kA205 + kC205) - kE205) - kE205) - kD205);
    tmp3_2 = kB205 - kG205;
    // Op 206: dim1x1 sub_swap
    gl64_t s0_206 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_206 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_206 - s0_206;
    // Op 207: dim1x1 mul
    gl64_t s0_207 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_207 * tmp1_0;
    // Op 208: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 209: dim3x3 mul
    gl64_t s1_209_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_209_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_209_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA209 = (tmp3_0 + tmp3_1) * (s1_209_0 + s1_209_1);
    gl64_t kB209 = (tmp3_0 + tmp3_2) * (s1_209_0 + s1_209_2);
    gl64_t kC209 = (tmp3_1 + tmp3_2) * (s1_209_1 + s1_209_2);
    gl64_t kD209 = tmp3_0 * s1_209_0;
    gl64_t kE209 = tmp3_1 * s1_209_1;
    gl64_t kF209 = tmp3_2 * s1_209_2;
    gl64_t kG209 = kD209 - kE209;
    tmp3_0 = (kC209 + kG209) - kF209;
    tmp3_1 = ((((kA209 + kC209) - kE209) - kE209) - kD209);
    tmp3_2 = kB209 - kG209;
    // Op 210: dim1x1 mul
    gl64_t s0_210 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_210 * tmp1_3;
    // Op 211: dim1x1 sub
    gl64_t s0_211 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_211 - tmp1_0;
    // Op 212: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 213: dim3x3 mul
    gl64_t s1_213_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_213_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_213_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA213 = (tmp3_0 + tmp3_1) * (s1_213_0 + s1_213_1);
    gl64_t kB213 = (tmp3_0 + tmp3_2) * (s1_213_0 + s1_213_2);
    gl64_t kC213 = (tmp3_1 + tmp3_2) * (s1_213_1 + s1_213_2);
    gl64_t kD213 = tmp3_0 * s1_213_0;
    gl64_t kE213 = tmp3_1 * s1_213_1;
    gl64_t kF213 = tmp3_2 * s1_213_2;
    gl64_t kG213 = kD213 - kE213;
    tmp3_0 = (kC213 + kG213) - kF213;
    tmp3_1 = ((((kA213 + kC213) - kE213) - kE213) - kD213);
    tmp3_2 = kB213 - kG213;
    // Op 214: dim1x1 mul
    gl64_t s0_214 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_214 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_214 * s1_214;
    // Op 215: dim1x1 sub
    gl64_t s0_215 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp1_1 = s0_215 - tmp1_2;
    // Op 216: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 217: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 218: dim3x3 mul
    gl64_t s1_218_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_218_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_218_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA218 = (tmp3_0 + tmp3_1) * (s1_218_0 + s1_218_1);
    gl64_t kB218 = (tmp3_0 + tmp3_2) * (s1_218_0 + s1_218_2);
    gl64_t kC218 = (tmp3_1 + tmp3_2) * (s1_218_1 + s1_218_2);
    gl64_t kD218 = tmp3_0 * s1_218_0;
    gl64_t kE218 = tmp3_1 * s1_218_1;
    gl64_t kF218 = tmp3_2 * s1_218_2;
    gl64_t kG218 = kD218 - kE218;
    tmp3_0 = (kC218 + kG218) - kF218;
    tmp3_1 = ((((kA218 + kC218) - kE218) - kE218) - kD218);
    tmp3_2 = kB218 - kG218;
    // Op 219: dim1x1 mul
    gl64_t s0_219 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_219 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_219 * s1_219;
    // Op 220: dim1x1 sub
    gl64_t s0_220 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_1 = s0_220 - tmp1_2;
    // Op 221: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 222: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 223: dim3x3 mul
    gl64_t s1_223_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_223_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_223_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA223 = (tmp3_0 + tmp3_1) * (s1_223_0 + s1_223_1);
    gl64_t kB223 = (tmp3_0 + tmp3_2) * (s1_223_0 + s1_223_2);
    gl64_t kC223 = (tmp3_1 + tmp3_2) * (s1_223_1 + s1_223_2);
    gl64_t kD223 = tmp3_0 * s1_223_0;
    gl64_t kE223 = tmp3_1 * s1_223_1;
    gl64_t kF223 = tmp3_2 * s1_223_2;
    gl64_t kG223 = kD223 - kE223;
    tmp3_0 = (kC223 + kG223) - kF223;
    tmp3_1 = ((((kA223 + kC223) - kE223) - kE223) - kD223);
    tmp3_2 = kB223 - kG223;
    // Op 224: dim1x1 sub_swap
    gl64_t s0_224 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_224 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_224 - s0_224;
    // Op 225: dim1x1 mul
    gl64_t s0_225 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_0 = s0_225 * tmp1_0;
    // Op 226: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 227: dim3x3 mul
    gl64_t s1_227_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_227_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_227_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 228: dim1x1 mul
    gl64_t s0_228 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_3 = s0_228 * tmp1_3;
    // Op 229: dim1x1 sub
    gl64_t s0_229 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_3 = s0_229 - tmp1_3;
    // Op 230: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_3; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 231: dim3x3 mul
    gl64_t s1_231_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_231_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_231_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA231 = (tmp3_0 + tmp3_1) * (s1_231_0 + s1_231_1);
    gl64_t kB231 = (tmp3_0 + tmp3_2) * (s1_231_0 + s1_231_2);
    gl64_t kC231 = (tmp3_1 + tmp3_2) * (s1_231_1 + s1_231_2);
    gl64_t kD231 = tmp3_0 * s1_231_0;
    gl64_t kE231 = tmp3_1 * s1_231_1;
    gl64_t kF231 = tmp3_2 * s1_231_2;
    gl64_t kG231 = kD231 - kE231;
    tmp3_0 = (kC231 + kG231) - kF231;
    tmp3_1 = ((((kA231 + kC231) - kE231) - kE231) - kD231);
    tmp3_2 = kB231 - kG231;
    // Op 232: dim1x1 mul
    gl64_t s0_232 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_232 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_3 = s0_232 * s1_232;
    // Op 233: dim1x1 sub
    gl64_t s0_233 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_0 = s0_233 - tmp1_2;
    // Op 234: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 235: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 236: dim3x3 mul
    gl64_t s1_236_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_236_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_236_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA236 = (tmp3_0 + tmp3_1) * (s1_236_0 + s1_236_1);
    gl64_t kB236 = (tmp3_0 + tmp3_2) * (s1_236_0 + s1_236_2);
    gl64_t kC236 = (tmp3_1 + tmp3_2) * (s1_236_1 + s1_236_2);
    gl64_t kD236 = tmp3_0 * s1_236_0;
    gl64_t kE236 = tmp3_1 * s1_236_1;
    gl64_t kF236 = tmp3_2 * s1_236_2;
    gl64_t kG236 = kD236 - kE236;
    tmp3_0 = (kC236 + kG236) - kF236;
    tmp3_1 = ((((kA236 + kC236) - kE236) - kE236) - kD236);
    tmp3_2 = kB236 - kG236;
    // Op 237: dim1x1 mul
    gl64_t s0_237 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_237 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_237 * s1_237;
    // Op 238: dim1x1 sub
    gl64_t s0_238 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_2 = s0_238 - tmp1_2;
    // Op 239: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_2;
    // Op 240: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 241: dim3x3 mul
    gl64_t s1_241_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_241_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_241_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA241 = (tmp3_0 + tmp3_1) * (s1_241_0 + s1_241_1);
    gl64_t kB241 = (tmp3_0 + tmp3_2) * (s1_241_0 + s1_241_2);
    gl64_t kC241 = (tmp3_1 + tmp3_2) * (s1_241_1 + s1_241_2);
    gl64_t kD241 = tmp3_0 * s1_241_0;
    gl64_t kE241 = tmp3_1 * s1_241_1;
    gl64_t kF241 = tmp3_2 * s1_241_2;
    gl64_t kG241 = kD241 - kE241;
    tmp3_0 = (kC241 + kG241) - kF241;
    tmp3_1 = ((((kA241 + kC241) - kE241) - kE241) - kD241);
    tmp3_2 = kB241 - kG241;
    // Op 242: dim1x1 sub
    gl64_t s0_242 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_242 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_242 - s1_242;
    // Op 243: dim1x1 mul
    gl64_t s0_243 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_3 = s0_243 * tmp1_0;
    // Op 244: dim1x1 sub_swap
    gl64_t s0_244 = *(gl64_t*)&expressions_params[9][3];
    gl64_t s1_244 = *(gl64_t*)&expressions_params[10][4];
    tmp1_0 = s1_244 - s0_244;
    // Op 245: dim1x1 sub
    gl64_t s0_245 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_245 - tmp1_0;
    // Op 246: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 247: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 248: dim3x3 mul
    gl64_t s1_248_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_248_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_248_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 249: dim1x1 sub_swap
    gl64_t s0_249 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_249 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_249 - s0_249;
    // Op 250: dim1x1 sub_swap
    gl64_t s0_250 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 1, domainSize, nCols_1))];
    gl64_t s1_250 = *(gl64_t*)&expressions_params[9][0];
    tmp1_2 = s1_250 - s0_250;
    // Op 251: dim1x1 mul
    tmp1_1 = tmp1_0 * tmp1_2;
    // Op 252: dim1x1 sub
    gl64_t s0_252 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 10, domainSize, nCols_1))];
    gl64_t s1_252 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_252 - s1_252;
    // Op 253: dim1x1 sub
    gl64_t s0_253 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_253 - tmp1_0;
    // Op 254: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 255: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 256: dim3x3 mul
    gl64_t s1_256_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_256_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_256_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA256 = (tmp3_0 + tmp3_1) * (s1_256_0 + s1_256_1);
    gl64_t kB256 = (tmp3_0 + tmp3_2) * (s1_256_0 + s1_256_2);
    gl64_t kC256 = (tmp3_1 + tmp3_2) * (s1_256_1 + s1_256_2);
    gl64_t kD256 = tmp3_0 * s1_256_0;
    gl64_t kE256 = tmp3_1 * s1_256_1;
    gl64_t kF256 = tmp3_2 * s1_256_2;
    gl64_t kG256 = kD256 - kE256;
    tmp3_0 = (kC256 + kG256) - kF256;
    tmp3_1 = ((((kA256 + kC256) - kE256) - kE256) - kD256);
    tmp3_2 = kB256 - kG256;
    // Op 257: dim1x1 add
    gl64_t s0_257 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_0 = s0_257 + tmp1_5;
    // Op 258: dim1x1 add
    gl64_t s0_258 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_258 + tmp1_0;
    // Op 259: dim1x1 add
    gl64_t s0_259 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_2 = s0_259 + tmp1_0;
    // Op 260: dim1x1 sub
    gl64_t s0_260 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_260 - tmp1_2;
    // Op 261: dim1x1 mul
    gl64_t s0_261 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_261 * tmp1_0;
    // Op 262: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 263: dim3x3 mul
    gl64_t s1_263_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_263_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_263_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA263 = (tmp3_0 + tmp3_1) * (s1_263_0 + s1_263_1);
    gl64_t kB263 = (tmp3_0 + tmp3_2) * (s1_263_0 + s1_263_2);
    gl64_t kC263 = (tmp3_1 + tmp3_2) * (s1_263_1 + s1_263_2);
    gl64_t kD263 = tmp3_0 * s1_263_0;
    gl64_t kE263 = tmp3_1 * s1_263_1;
    gl64_t kF263 = tmp3_2 * s1_263_2;
    gl64_t kG263 = kD263 - kE263;
    tmp3_0 = (kC263 + kG263) - kF263;
    tmp3_1 = ((((kA263 + kC263) - kE263) - kE263) - kD263);
    tmp3_2 = kB263 - kG263;
    // Op 264: dim1x1 sub_swap
    gl64_t s0_264 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_264 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_264 - s0_264;
    // Op 265: dim1x1 sub
    gl64_t s1_265 = *(gl64_t*)&expressions_params[9][3];
    tmp1_2 = tmp1_2 - s1_265;
    // Op 266: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_2;
    // Op 267: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 268: dim3x3 mul
    gl64_t s1_268_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_268_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_268_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA268 = (tmp3_0 + tmp3_1) * (s1_268_0 + s1_268_1);
    gl64_t kB268 = (tmp3_0 + tmp3_2) * (s1_268_0 + s1_268_2);
    gl64_t kC268 = (tmp3_1 + tmp3_2) * (s1_268_1 + s1_268_2);
    gl64_t kD268 = tmp3_0 * s1_268_0;
    gl64_t kE268 = tmp3_1 * s1_268_1;
    gl64_t kF268 = tmp3_2 * s1_268_2;
    gl64_t kG268 = kD268 - kE268;
    tmp3_0 = (kC268 + kG268) - kF268;
    tmp3_1 = ((((kA268 + kC268) - kE268) - kE268) - kD268);
    tmp3_2 = kB268 - kG268;
    // Op 269: dim1x1 add
    gl64_t s0_269 = *(gl64_t*)&expressions_params[9][3];
    gl64_t s1_269 = *(gl64_t*)&expressions_params[10][2];
    tmp1_0 = s0_269 + s1_269;
    // Op 270: dim1x1 sub
    gl64_t s0_270 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_270 - tmp1_0;
    // Op 271: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 272: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 273: dim3x3 mul
    gl64_t s1_273_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_273_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_273_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 274: dim1x1 add
    gl64_t s0_274 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 9, domainSize, nCols_1))];
    gl64_t s1_274 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_274 + s1_274;
    // Op 275: dim1x1 sub
    gl64_t s0_275 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_275 - tmp1_0;
    // Op 276: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 277: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 278: dim3x3 mul
    gl64_t s1_278_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_278_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_278_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 279: dim1x1 add
    gl64_t s0_279 = *(gl64_t*)&expressions_params[9][3];
    gl64_t s1_279 = *(gl64_t*)&expressions_params[10][12];
    tmp1_0 = s0_279 + s1_279;
    // Op 280: dim1x1 sub
    gl64_t s0_280 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_280 - tmp1_0;
    // Op 281: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 282: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 283: dim3x3 mul
    gl64_t s1_283_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_283_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_283_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA283 = (tmp3_0 + tmp3_1) * (s1_283_0 + s1_283_1);
    gl64_t kB283 = (tmp3_0 + tmp3_2) * (s1_283_0 + s1_283_2);
    gl64_t kC283 = (tmp3_1 + tmp3_2) * (s1_283_1 + s1_283_2);
    gl64_t kD283 = tmp3_0 * s1_283_0;
    gl64_t kE283 = tmp3_1 * s1_283_1;
    gl64_t kF283 = tmp3_2 * s1_283_2;
    gl64_t kG283 = kD283 - kE283;
    tmp3_0 = (kC283 + kG283) - kF283;
    tmp3_1 = ((((kA283 + kC283) - kE283) - kE283) - kD283);
    tmp3_2 = kB283 - kG283;
    // Op 284: dim1x1 add
    gl64_t s0_284 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_1))];
    gl64_t s1_284 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_284 + s1_284;
    // Op 285: dim1x1 sub
    gl64_t s0_285 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_285 - tmp1_0;
    // Op 286: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 287: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 288: dim3x3 mul
    gl64_t s1_288_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_288_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_288_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA288 = (tmp3_0 + tmp3_1) * (s1_288_0 + s1_288_1);
    gl64_t kB288 = (tmp3_0 + tmp3_2) * (s1_288_0 + s1_288_2);
    gl64_t kC288 = (tmp3_1 + tmp3_2) * (s1_288_1 + s1_288_2);
    gl64_t kD288 = tmp3_0 * s1_288_0;
    gl64_t kE288 = tmp3_1 * s1_288_1;
    gl64_t kF288 = tmp3_2 * s1_288_2;
    gl64_t kG288 = kD288 - kE288;
    tmp3_0 = (kC288 + kG288) - kF288;
    tmp3_1 = ((((kA288 + kC288) - kE288) - kE288) - kD288);
    tmp3_2 = kB288 - kG288;
    // Op 289: dim1x1 sub
    gl64_t s1_289 = *(gl64_t*)&expressions_params[10][5];
    tmp1_0 = tmp1_4 - s1_289;
    // Op 290: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 291: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 292: dim3x3 mul
    gl64_t s1_292_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_292_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_292_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 293: dim1x1 mul
    gl64_t s0_293 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 4, domainSize, nCols_1))];
    gl64_t s1_293 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s0_293 * s1_293;
    // Op 294: dim1x1 add
    gl64_t s0_294 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 3, domainSize, nCols_1))];
    tmp1_0 = s0_294 + tmp1_0;
    // Op 295: dim1x1 mul
    gl64_t s0_295 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 5, domainSize, nCols_1))];
    gl64_t s1_295 = *(gl64_t*)&expressions_params[9][2];
    tmp1_2 = s0_295 * s1_295;
    // Op 296: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 297: dim1x1 sub
    tmp1_0 = tmp1_4 - tmp1_0;
    // Op 298: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 299: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 300: dim3x3 mul
    gl64_t s1_300_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_300_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_300_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 301: dim1x1 sub
    gl64_t s0_301 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_301 = *(gl64_t*)&expressions_params[10][3];
    tmp1_0 = s0_301 - s1_301;
    // Op 302: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 303: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 304: dim3x3 mul
    gl64_t s1_304_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_304_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_304_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 305: dim1x1 sub
    gl64_t s0_305 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_305 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 8, domainSize, nCols_1))];
    tmp1_0 = s0_305 - s1_305;
    // Op 306: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 307: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 308: dim3x3 mul
    gl64_t s1_308_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_308_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_308_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 309: dim1x1 sub
    gl64_t s0_309 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_309 = *(gl64_t*)&expressions_params[10][14];
    tmp1_0 = s0_309 - s1_309;
    // Op 310: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 311: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 312: dim3x3 mul
    gl64_t s1_312_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_312_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_312_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 313: dim1x1 sub
    gl64_t s0_313 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_313 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 6, domainSize, nCols_1))];
    tmp1_0 = s0_313 - s1_313;
    // Op 314: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 315: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 316: dim3x3 mul
    gl64_t s1_316_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_316_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_316_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 317: dim1x1 mul
    gl64_t s0_317 = *(gl64_t*)&expressions_params[9][17];
    gl64_t s1_317 = *(gl64_t*)&expressions_params[10][17];
    tmp1_0 = s0_317 * s1_317;
    // Op 318: dim1x1 add
    gl64_t s1_318 = *(gl64_t*)&expressions_params[10][16];
    tmp1_0 = tmp1_0 + s1_318;
    // Op 319: dim1x1 sub
    gl64_t s1_319 = *(gl64_t*)&expressions_params[10][9];
    tmp1_0 = tmp1_0 - s1_319;
    // Op 320: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 321: dim3x3 mul
    gl64_t s1_321_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_321_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_321_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA321 = (tmp3_0 + tmp3_1) * (s1_321_0 + s1_321_1);
    gl64_t kB321 = (tmp3_0 + tmp3_2) * (s1_321_0 + s1_321_2);
    gl64_t kC321 = (tmp3_1 + tmp3_2) * (s1_321_1 + s1_321_2);
    gl64_t kD321 = tmp3_0 * s1_321_0;
    gl64_t kE321 = tmp3_1 * s1_321_1;
    gl64_t kF321 = tmp3_2 * s1_321_2;
    gl64_t kG321 = kD321 - kE321;
    tmp3_12 = (kC321 + kG321) - kF321;
    tmp3_13 = ((((kA321 + kC321) - kE321) - kE321) - kD321);
    tmp3_14 = kB321 - kG321;
    // Op 322: dim3x1 mul
    gl64_t s0_322_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_322_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_322_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_322 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp3_0 = s0_322_0 * s1_322; tmp3_1 = s0_322_1 * s1_322; tmp3_2 = s0_322_2 * s1_322;
    // Op 323: dim3x1 add
    gl64_t s1_323 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_323; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 324: dim3x3 mul
    gl64_t s1_324_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_324_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_324_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA324 = (tmp3_0 + tmp3_1) * (s1_324_0 + s1_324_1);
    gl64_t kB324 = (tmp3_0 + tmp3_2) * (s1_324_0 + s1_324_2);
    gl64_t kC324 = (tmp3_1 + tmp3_2) * (s1_324_1 + s1_324_2);
    gl64_t kD324 = tmp3_0 * s1_324_0;
    gl64_t kE324 = tmp3_1 * s1_324_1;
    gl64_t kF324 = tmp3_2 * s1_324_2;
    gl64_t kG324 = kD324 - kE324;
    tmp3_0 = (kC324 + kG324) - kF324;
    tmp3_1 = ((((kA324 + kC324) - kE324) - kE324) - kD324);
    tmp3_2 = kB324 - kG324;
    // Op 325: dim3x1 add
    gl64_t s1_325 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_325; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 326: dim3x3 mul
    gl64_t s1_326_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_326_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_326_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA326 = (tmp3_0 + tmp3_1) * (s1_326_0 + s1_326_1);
    gl64_t kB326 = (tmp3_0 + tmp3_2) * (s1_326_0 + s1_326_2);
    gl64_t kC326 = (tmp3_1 + tmp3_2) * (s1_326_1 + s1_326_2);
    gl64_t kD326 = tmp3_0 * s1_326_0;
    gl64_t kE326 = tmp3_1 * s1_326_1;
    gl64_t kF326 = tmp3_2 * s1_326_2;
    gl64_t kG326 = kD326 - kE326;
    tmp3_0 = (kC326 + kG326) - kF326;
    tmp3_1 = ((((kA326 + kC326) - kE326) - kE326) - kD326);
    tmp3_2 = kB326 - kG326;
    // Op 327: dim1x1 mul
    gl64_t s0_327 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_327 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_327 * s1_327;
    // Op 328: dim1x1 add
    gl64_t s1_328 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_328;
    // Op 329: dim1x1 add
    gl64_t s1_329 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_329;
    // Op 330: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 332: dim1x1 mul
    gl64_t s0_332 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_332 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_332 * s1_332;
    // Op 333: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 334: dim3x3 mul
    gl64_t s1_334_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_334_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_334_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA334 = (tmp3_0 + tmp3_1) * (s1_334_0 + s1_334_1);
    gl64_t kB334 = (tmp3_0 + tmp3_2) * (s1_334_0 + s1_334_2);
    gl64_t kC334 = (tmp3_1 + tmp3_2) * (s1_334_1 + s1_334_2);
    gl64_t kD334 = tmp3_0 * s1_334_0;
    gl64_t kE334 = tmp3_1 * s1_334_1;
    gl64_t kF334 = tmp3_2 * s1_334_2;
    gl64_t kG334 = kD334 - kE334;
    tmp3_0 = (kC334 + kG334) - kF334;
    tmp3_1 = ((((kA334 + kC334) - kE334) - kE334) - kD334);
    tmp3_2 = kB334 - kG334;
    // Op 335: dim3x1 add
    gl64_t s1_335 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_335; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 336: dim3x3 mul
    gl64_t s1_336_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_336_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_336_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA336 = (tmp3_0 + tmp3_1) * (s1_336_0 + s1_336_1);
    gl64_t kB336 = (tmp3_0 + tmp3_2) * (s1_336_0 + s1_336_2);
    gl64_t kC336 = (tmp3_1 + tmp3_2) * (s1_336_1 + s1_336_2);
    gl64_t kD336 = tmp3_0 * s1_336_0;
    gl64_t kE336 = tmp3_1 * s1_336_1;
    gl64_t kF336 = tmp3_2 * s1_336_2;
    gl64_t kG336 = kD336 - kE336;
    tmp3_0 = (kC336 + kG336) - kF336;
    tmp3_1 = ((((kA336 + kC336) - kE336) - kE336) - kD336);
    tmp3_2 = kB336 - kG336;
    // Op 337: dim3x1 add
    gl64_t s1_337 = *(gl64_t*)&expressions_params[9][5];
    tmp3_9 = tmp3_0 + s1_337; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 338: dim3x3 add
    gl64_t s1_338_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_338_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_338_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_338_0; tmp3_4 = tmp3_10 + s1_338_1; tmp3_5 = tmp3_11 + s1_338_2;
    // Op 339: dim3x1 mul
    gl64_t s0_339_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_339_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_339_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_339 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp3_0 = s0_339_0 * s1_339; tmp3_1 = s0_339_1 * s1_339; tmp3_2 = s0_339_2 * s1_339;
    // Op 340: dim3x1 add
    gl64_t s1_340 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
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
    gl64_t s1_342 = *(gl64_t*)&expressions_params[9][2];
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
    // Op 344: dim1x1 mul
    gl64_t s0_344 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_344 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_344 * s1_344;
    // Op 345: dim1x1 add
    gl64_t s1_345 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_345;
    // Op 346: dim1x1 add
    gl64_t s0_346 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_346 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_1 = s0_346 + s1_346;
    // Op 347: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 348: dim1x1 add
    gl64_t s1_348 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_348;
    // Op 349: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 351: dim1x1 mul
    gl64_t s0_351 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_351 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_351 * s1_351;
    // Op 352: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 353: dim3x3 mul
    gl64_t s1_353_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_353_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_353_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA353 = (tmp3_0 + tmp3_1) * (s1_353_0 + s1_353_1);
    gl64_t kB353 = (tmp3_0 + tmp3_2) * (s1_353_0 + s1_353_2);
    gl64_t kC353 = (tmp3_1 + tmp3_2) * (s1_353_1 + s1_353_2);
    gl64_t kD353 = tmp3_0 * s1_353_0;
    gl64_t kE353 = tmp3_1 * s1_353_1;
    gl64_t kF353 = tmp3_2 * s1_353_2;
    gl64_t kG353 = kD353 - kE353;
    tmp3_0 = (kC353 + kG353) - kF353;
    tmp3_1 = ((((kA353 + kC353) - kE353) - kE353) - kD353);
    tmp3_2 = kB353 - kG353;
    // Op 354: dim1x1 add
    gl64_t s0_354 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_354 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_354 + s1_354;
    // Op 355: dim1x1 add
    gl64_t s1_355 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_355;
    // Op 356: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 357: dim3x3 mul
    gl64_t s1_357_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_357_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_357_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA357 = (tmp3_0 + tmp3_1) * (s1_357_0 + s1_357_1);
    gl64_t kB357 = (tmp3_0 + tmp3_2) * (s1_357_0 + s1_357_2);
    gl64_t kC357 = (tmp3_1 + tmp3_2) * (s1_357_1 + s1_357_2);
    gl64_t kD357 = tmp3_0 * s1_357_0;
    gl64_t kE357 = tmp3_1 * s1_357_1;
    gl64_t kF357 = tmp3_2 * s1_357_2;
    gl64_t kG357 = kD357 - kE357;
    tmp3_0 = (kC357 + kG357) - kF357;
    tmp3_1 = ((((kA357 + kC357) - kE357) - kE357) - kD357);
    tmp3_2 = kB357 - kG357;
    // Op 358: dim3x1 add
    gl64_t s1_358 = *(gl64_t*)&expressions_params[9][5];
    tmp3_6 = tmp3_0 + s1_358; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 359: dim3x3 add
    gl64_t s1_359_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_359_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_359_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_359_0; tmp3_1 = tmp3_7 + s1_359_1; tmp3_2 = tmp3_8 + s1_359_2;
    // Op 360: dim3x3 mul
    gl64_t kA360 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB360 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC360 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD360 = tmp3_3 * tmp3_0;
    gl64_t kE360 = tmp3_4 * tmp3_1;
    gl64_t kF360 = tmp3_5 * tmp3_2;
    gl64_t kG360 = kD360 - kE360;
    tmp3_0 = (kC360 + kG360) - kF360;
    tmp3_1 = ((((kA360 + kC360) - kE360) - kE360) - kD360);
    tmp3_2 = kB360 - kG360;
    // Op 361: dim3x3 mul
    gl64_t s0_361_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_361_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_361_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA361 = (s0_361_0 + s0_361_1) * (tmp3_0 + tmp3_1);
    gl64_t kB361 = (s0_361_0 + s0_361_2) * (tmp3_0 + tmp3_2);
    gl64_t kC361 = (s0_361_1 + s0_361_2) * (tmp3_1 + tmp3_2);
    gl64_t kD361 = s0_361_0 * tmp3_0;
    gl64_t kE361 = s0_361_1 * tmp3_1;
    gl64_t kF361 = s0_361_2 * tmp3_2;
    gl64_t kG361 = kD361 - kE361;
    tmp3_0 = (kC361 + kG361) - kF361;
    tmp3_1 = ((((kA361 + kC361) - kE361) - kE361) - kD361);
    tmp3_2 = kB361 - kG361;
    // Op 362: dim1x1 sub_swap
    gl64_t s0_362 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_362 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_362 - s0_362;
    // Op 363: dim3x3 add
    gl64_t s1_363_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_363_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_363_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_363_0; tmp3_7 = tmp3_7 + s1_363_1; tmp3_8 = tmp3_8 + s1_363_2;
    // Op 364: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 365: dim1x1 sub_swap
    gl64_t s1_365 = *(gl64_t*)&expressions_params[9][1];
    tmp1_5 = s1_365 - tmp1_5;
    // Op 366: dim3x3 add
    gl64_t s1_366_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_366_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_366_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_366_0; tmp3_10 = tmp3_10 + s1_366_1; tmp3_11 = tmp3_11 + s1_366_2;
    // Op 367: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_5; tmp3_10 = tmp3_10 * tmp1_5; tmp3_11 = tmp3_11 * tmp1_5;
    // Op 368: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 369: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 370: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 371: dim3x3 mul
    gl64_t s1_371_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_371_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_371_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA371 = (tmp3_0 + tmp3_1) * (s1_371_0 + s1_371_1);
    gl64_t kB371 = (tmp3_0 + tmp3_2) * (s1_371_0 + s1_371_2);
    gl64_t kC371 = (tmp3_1 + tmp3_2) * (s1_371_1 + s1_371_2);
    gl64_t kD371 = tmp3_0 * s1_371_0;
    gl64_t kE371 = tmp3_1 * s1_371_1;
    gl64_t kF371 = tmp3_2 * s1_371_2;
    gl64_t kG371 = kD371 - kE371;
    tmp3_3 = (kC371 + kG371) - kF371;
    tmp3_4 = ((((kA371 + kC371) - kE371) - kE371) - kD371);
    tmp3_5 = kB371 - kG371;
    // Op 372: dim3x1 mul
    gl64_t s0_372_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_372_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_372_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_372 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp3_0 = s0_372_0 * s1_372; tmp3_1 = s0_372_1 * s1_372; tmp3_2 = s0_372_2 * s1_372;
    // Op 373: dim3x1 add
    gl64_t s1_373 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_373; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 375: dim3x1 add
    gl64_t s1_375 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_375; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 376: dim3x3 mul
    gl64_t s1_376_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_376_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_376_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA376 = (tmp3_0 + tmp3_1) * (s1_376_0 + s1_376_1);
    gl64_t kB376 = (tmp3_0 + tmp3_2) * (s1_376_0 + s1_376_2);
    gl64_t kC376 = (tmp3_1 + tmp3_2) * (s1_376_1 + s1_376_2);
    gl64_t kD376 = tmp3_0 * s1_376_0;
    gl64_t kE376 = tmp3_1 * s1_376_1;
    gl64_t kF376 = tmp3_2 * s1_376_2;
    gl64_t kG376 = kD376 - kE376;
    tmp3_0 = (kC376 + kG376) - kF376;
    tmp3_1 = ((((kA376 + kC376) - kE376) - kE376) - kD376);
    tmp3_2 = kB376 - kG376;
    // Op 377: dim1x1 mul
    gl64_t s0_377 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_377 = *(gl64_t*)&expressions_params[9][3];
    tmp1_5 = s0_377 * s1_377;
    // Op 378: dim1x1 add
    gl64_t s1_378 = *(gl64_t*)&expressions_params[9][0];
    tmp1_5 = tmp1_5 + s1_378;
    // Op 379: dim1x1 add
    gl64_t s1_379 = *(gl64_t*)&expressions_params[9][4];
    tmp1_5 = tmp1_5 + s1_379;
    // Op 380: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_5; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 381: dim3x3 mul
    gl64_t s1_381_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_381_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_381_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA381 = (tmp3_0 + tmp3_1) * (s1_381_0 + s1_381_1);
    gl64_t kB381 = (tmp3_0 + tmp3_2) * (s1_381_0 + s1_381_2);
    gl64_t kC381 = (tmp3_1 + tmp3_2) * (s1_381_1 + s1_381_2);
    gl64_t kD381 = tmp3_0 * s1_381_0;
    gl64_t kE381 = tmp3_1 * s1_381_1;
    gl64_t kF381 = tmp3_2 * s1_381_2;
    gl64_t kG381 = kD381 - kE381;
    tmp3_0 = (kC381 + kG381) - kF381;
    tmp3_1 = ((((kA381 + kC381) - kE381) - kE381) - kD381);
    tmp3_2 = kB381 - kG381;
    // Op 382: dim1x1 mul
    gl64_t s0_382 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_382 = *(gl64_t*)&expressions_params[9][2];
    tmp1_5 = s0_382 * s1_382;
    // Op 383: dim1x1 add
    gl64_t s1_383 = *(gl64_t*)&expressions_params[9][2];
    tmp1_5 = tmp1_5 + s1_383;
    // Op 384: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_5; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 386: dim3x1 add
    gl64_t s1_386 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_386; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 387: dim3x3 mul
    gl64_t s1_387_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_387_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_387_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA387 = (tmp3_0 + tmp3_1) * (s1_387_0 + s1_387_1);
    gl64_t kB387 = (tmp3_0 + tmp3_2) * (s1_387_0 + s1_387_2);
    gl64_t kC387 = (tmp3_1 + tmp3_2) * (s1_387_1 + s1_387_2);
    gl64_t kD387 = tmp3_0 * s1_387_0;
    gl64_t kE387 = tmp3_1 * s1_387_1;
    gl64_t kF387 = tmp3_2 * s1_387_2;
    gl64_t kG387 = kD387 - kE387;
    tmp3_0 = (kC387 + kG387) - kF387;
    tmp3_1 = ((((kA387 + kC387) - kE387) - kE387) - kD387);
    tmp3_2 = kB387 - kG387;
    // Op 388: dim3x1 add
    gl64_t s1_388 = *(gl64_t*)&expressions_params[9][5];
    tmp3_9 = tmp3_0 + s1_388; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 389: dim3x3 add
    gl64_t s1_389_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_389_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_389_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_389_0; tmp3_13 = tmp3_10 + s1_389_1; tmp3_14 = tmp3_11 + s1_389_2;
    // Op 390: dim3x1 mul
    gl64_t s0_390_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_390_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_390_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_390 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp3_0 = s0_390_0 * s1_390; tmp3_1 = s0_390_1 * s1_390; tmp3_2 = s0_390_2 * s1_390;
    // Op 391: dim3x1 add
    gl64_t s1_391 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
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
    gl64_t s1_393 = *(gl64_t*)&expressions_params[9][2];
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
    // Op 395: dim1x1 mul
    gl64_t s0_395 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_395 = *(gl64_t*)&expressions_params[9][3];
    tmp1_5 = s0_395 * s1_395;
    // Op 396: dim1x1 add
    gl64_t s1_396 = *(gl64_t*)&expressions_params[9][0];
    tmp1_5 = tmp1_5 + s1_396;
    // Op 397: dim1x1 add
    gl64_t s0_397 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_397 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_397 + s1_397;
    // Op 398: dim1x1 add
    tmp1_0 = tmp1_5 + tmp1_0;
    // Op 399: dim1x1 add
    gl64_t s1_399 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_399;
    // Op 400: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 402: dim1x1 mul
    gl64_t s0_402 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_402 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_402 * s1_402;
    // Op 403: dim1x1 add
    gl64_t s1_403 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = tmp1_0 + s1_403;
    // Op 404: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 406: dim1x1 add
    gl64_t s0_406 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_406 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_406 + s1_406;
    // Op 407: dim1x1 add
    gl64_t s1_407 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_407;
    // Op 408: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 409: dim3x3 mul
    gl64_t s1_409_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_409_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_409_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA409 = (tmp3_0 + tmp3_1) * (s1_409_0 + s1_409_1);
    gl64_t kB409 = (tmp3_0 + tmp3_2) * (s1_409_0 + s1_409_2);
    gl64_t kC409 = (tmp3_1 + tmp3_2) * (s1_409_1 + s1_409_2);
    gl64_t kD409 = tmp3_0 * s1_409_0;
    gl64_t kE409 = tmp3_1 * s1_409_1;
    gl64_t kF409 = tmp3_2 * s1_409_2;
    gl64_t kG409 = kD409 - kE409;
    tmp3_0 = (kC409 + kG409) - kF409;
    tmp3_1 = ((((kA409 + kC409) - kE409) - kE409) - kD409);
    tmp3_2 = kB409 - kG409;
    // Op 410: dim3x1 add
    gl64_t s1_410 = *(gl64_t*)&expressions_params[9][5];
    tmp3_6 = tmp3_0 + s1_410; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 411: dim3x3 add
    gl64_t s1_411_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_411_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_411_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_411_0; tmp3_1 = tmp3_7 + s1_411_1; tmp3_2 = tmp3_8 + s1_411_2;
    // Op 412: dim3x3 mul
    gl64_t kA412 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB412 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC412 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD412 = tmp3_12 * tmp3_0;
    gl64_t kE412 = tmp3_13 * tmp3_1;
    gl64_t kF412 = tmp3_14 * tmp3_2;
    gl64_t kG412 = kD412 - kE412;
    tmp3_0 = (kC412 + kG412) - kF412;
    tmp3_1 = ((((kA412 + kC412) - kE412) - kE412) - kD412);
    tmp3_2 = kB412 - kG412;
    // Op 413: dim3x3 mul
    gl64_t s0_413_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_413_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_413_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA413 = (s0_413_0 + s0_413_1) * (tmp3_0 + tmp3_1);
    gl64_t kB413 = (s0_413_0 + s0_413_2) * (tmp3_0 + tmp3_2);
    gl64_t kC413 = (s0_413_1 + s0_413_2) * (tmp3_1 + tmp3_2);
    gl64_t kD413 = s0_413_0 * tmp3_0;
    gl64_t kE413 = s0_413_1 * tmp3_1;
    gl64_t kF413 = s0_413_2 * tmp3_2;
    gl64_t kG413 = kD413 - kE413;
    tmp3_0 = (kC413 + kG413) - kF413;
    tmp3_1 = ((((kA413 + kC413) - kE413) - kE413) - kD413);
    tmp3_2 = kB413 - kG413;
    // Op 414: dim1x1 sub_swap
    gl64_t s0_414 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_414 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_414 - s0_414;
    // Op 415: dim3x3 add
    gl64_t s1_415_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_415_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_415_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_415_0; tmp3_7 = tmp3_7 + s1_415_1; tmp3_8 = tmp3_8 + s1_415_2;
    // Op 416: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 417: dim1x1 sub_swap
    gl64_t s0_417 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_417 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_417 - s0_417;
    // Op 418: dim3x3 add
    gl64_t s1_418_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_418_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_418_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_418_0; tmp3_10 = tmp3_10 + s1_418_1; tmp3_11 = tmp3_11 + s1_418_2;
    // Op 419: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 420: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 421: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 422: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 423: dim3x3 mul
    gl64_t s1_423_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_423_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_423_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA423 = (tmp3_0 + tmp3_1) * (s1_423_0 + s1_423_1);
    gl64_t kB423 = (tmp3_0 + tmp3_2) * (s1_423_0 + s1_423_2);
    gl64_t kC423 = (tmp3_1 + tmp3_2) * (s1_423_1 + s1_423_2);
    gl64_t kD423 = tmp3_0 * s1_423_0;
    gl64_t kE423 = tmp3_1 * s1_423_1;
    gl64_t kF423 = tmp3_2 * s1_423_2;
    gl64_t kG423 = kD423 - kE423;
    tmp3_12 = (kC423 + kG423) - kF423;
    tmp3_13 = ((((kA423 + kC423) - kE423) - kE423) - kD423);
    tmp3_14 = kB423 - kG423;
    // Op 424: dim3x1 mul
    gl64_t s0_424_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_424_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_424_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_424 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp3_0 = s0_424_0 * s1_424; tmp3_1 = s0_424_1 * s1_424; tmp3_2 = s0_424_2 * s1_424;
    // Op 425: dim3x1 add
    gl64_t s1_425 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
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
    // Op 427: dim3x1 add
    gl64_t s1_427 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_427; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 428: dim3x3 mul
    gl64_t s1_428_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_428_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_428_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA428 = (tmp3_0 + tmp3_1) * (s1_428_0 + s1_428_1);
    gl64_t kB428 = (tmp3_0 + tmp3_2) * (s1_428_0 + s1_428_2);
    gl64_t kC428 = (tmp3_1 + tmp3_2) * (s1_428_1 + s1_428_2);
    gl64_t kD428 = tmp3_0 * s1_428_0;
    gl64_t kE428 = tmp3_1 * s1_428_1;
    gl64_t kF428 = tmp3_2 * s1_428_2;
    gl64_t kG428 = kD428 - kE428;
    tmp3_0 = (kC428 + kG428) - kF428;
    tmp3_1 = ((((kA428 + kC428) - kE428) - kE428) - kD428);
    tmp3_2 = kB428 - kG428;
    // Op 429: dim1x1 mul
    gl64_t s0_429 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_429 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_429 * s1_429;
    // Op 430: dim1x1 add
    gl64_t s1_430 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_430;
    // Op 431: dim1x1 add
    gl64_t s1_431 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_431;
    // Op 432: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s0_434 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_434 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_434 * s1_434;
    // Op 435: dim1x1 add
    gl64_t s1_435 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = tmp1_0 + s1_435;
    // Op 436: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 437: dim3x3 mul
    gl64_t s1_437_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_437_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_437_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA437 = (tmp3_0 + tmp3_1) * (s1_437_0 + s1_437_1);
    gl64_t kB437 = (tmp3_0 + tmp3_2) * (s1_437_0 + s1_437_2);
    gl64_t kC437 = (tmp3_1 + tmp3_2) * (s1_437_1 + s1_437_2);
    gl64_t kD437 = tmp3_0 * s1_437_0;
    gl64_t kE437 = tmp3_1 * s1_437_1;
    gl64_t kF437 = tmp3_2 * s1_437_2;
    gl64_t kG437 = kD437 - kE437;
    tmp3_0 = (kC437 + kG437) - kF437;
    tmp3_1 = ((((kA437 + kC437) - kE437) - kE437) - kD437);
    tmp3_2 = kB437 - kG437;
    // Op 438: dim3x1 add
    gl64_t s1_438 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_438; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 440: dim3x1 add
    gl64_t s1_440 = *(gl64_t*)&expressions_params[9][5];
    tmp3_9 = tmp3_0 + s1_440; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 441: dim3x3 add
    gl64_t s1_441_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_441_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_441_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_441_0; tmp3_4 = tmp3_10 + s1_441_1; tmp3_5 = tmp3_11 + s1_441_2;
    // Op 442: dim3x1 mul
    gl64_t s0_442_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_442_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_442_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_442 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp3_0 = s0_442_0 * s1_442; tmp3_1 = s0_442_1 * s1_442; tmp3_2 = s0_442_2 * s1_442;
    // Op 443: dim3x1 add
    gl64_t s1_443 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_443; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 445: dim3x1 add
    gl64_t s1_445 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_445; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 446: dim3x3 mul
    gl64_t s1_446_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_446_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_446_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA446 = (tmp3_0 + tmp3_1) * (s1_446_0 + s1_446_1);
    gl64_t kB446 = (tmp3_0 + tmp3_2) * (s1_446_0 + s1_446_2);
    gl64_t kC446 = (tmp3_1 + tmp3_2) * (s1_446_1 + s1_446_2);
    gl64_t kD446 = tmp3_0 * s1_446_0;
    gl64_t kE446 = tmp3_1 * s1_446_1;
    gl64_t kF446 = tmp3_2 * s1_446_2;
    gl64_t kG446 = kD446 - kE446;
    tmp3_0 = (kC446 + kG446) - kF446;
    tmp3_1 = ((((kA446 + kC446) - kE446) - kE446) - kD446);
    tmp3_2 = kB446 - kG446;
    // Op 447: dim1x1 mul
    gl64_t s0_447 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_447 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_447 * s1_447;
    // Op 448: dim1x1 add
    gl64_t s1_448 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_448;
    // Op 449: dim1x1 add
    gl64_t s0_449 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_449 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_5 = s0_449 + s1_449;
    // Op 450: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_5;
    // Op 451: dim1x1 add
    gl64_t s1_451 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_451;
    // Op 452: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 454: dim1x1 mul
    gl64_t s0_454 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_454 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_454 * s1_454;
    // Op 455: dim1x1 add
    gl64_t s1_455 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = tmp1_0 + s1_455;
    // Op 456: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 458: dim1x1 add
    gl64_t s0_458 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_458 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_458 + s1_458;
    // Op 459: dim1x1 add
    gl64_t s1_459 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_459;
    // Op 460: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 461: dim3x3 mul
    gl64_t s1_461_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_461_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_461_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA461 = (tmp3_0 + tmp3_1) * (s1_461_0 + s1_461_1);
    gl64_t kB461 = (tmp3_0 + tmp3_2) * (s1_461_0 + s1_461_2);
    gl64_t kC461 = (tmp3_1 + tmp3_2) * (s1_461_1 + s1_461_2);
    gl64_t kD461 = tmp3_0 * s1_461_0;
    gl64_t kE461 = tmp3_1 * s1_461_1;
    gl64_t kF461 = tmp3_2 * s1_461_2;
    gl64_t kG461 = kD461 - kE461;
    tmp3_0 = (kC461 + kG461) - kF461;
    tmp3_1 = ((((kA461 + kC461) - kE461) - kE461) - kD461);
    tmp3_2 = kB461 - kG461;
    // Op 462: dim3x1 add
    gl64_t s1_462 = *(gl64_t*)&expressions_params[9][5];
    tmp3_6 = tmp3_0 + s1_462; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 463: dim3x3 add
    gl64_t s1_463_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_463_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_463_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_463_0; tmp3_1 = tmp3_7 + s1_463_1; tmp3_2 = tmp3_8 + s1_463_2;
    // Op 464: dim3x3 mul
    gl64_t kA464 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB464 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC464 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD464 = tmp3_3 * tmp3_0;
    gl64_t kE464 = tmp3_4 * tmp3_1;
    gl64_t kF464 = tmp3_5 * tmp3_2;
    gl64_t kG464 = kD464 - kE464;
    tmp3_0 = (kC464 + kG464) - kF464;
    tmp3_1 = ((((kA464 + kC464) - kE464) - kE464) - kD464);
    tmp3_2 = kB464 - kG464;
    // Op 465: dim3x3 mul
    uint64_t s0_465_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_465_0 = *(gl64_t*)&dParams->aux_trace[s0_465_pos];
    gl64_t s0_465_1 = *(gl64_t*)&dParams->aux_trace[s0_465_pos + TILE_HEIGHT];
    gl64_t s0_465_2 = *(gl64_t*)&dParams->aux_trace[s0_465_pos + 2*TILE_HEIGHT];
    gl64_t kA465 = (s0_465_0 + s0_465_1) * (tmp3_0 + tmp3_1);
    gl64_t kB465 = (s0_465_0 + s0_465_2) * (tmp3_0 + tmp3_2);
    gl64_t kC465 = (s0_465_1 + s0_465_2) * (tmp3_1 + tmp3_2);
    gl64_t kD465 = s0_465_0 * tmp3_0;
    gl64_t kE465 = s0_465_1 * tmp3_1;
    gl64_t kF465 = s0_465_2 * tmp3_2;
    gl64_t kG465 = kD465 - kE465;
    tmp3_0 = (kC465 + kG465) - kF465;
    tmp3_1 = ((((kA465 + kC465) - kE465) - kE465) - kD465);
    tmp3_2 = kB465 - kG465;
    // Op 466: dim1x1 sub_swap
    gl64_t s0_466 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_466 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_466 - s0_466;
    // Op 467: dim3x3 add
    gl64_t s1_467_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_467_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_467_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_467_0; tmp3_7 = tmp3_7 + s1_467_1; tmp3_8 = tmp3_8 + s1_467_2;
    // Op 468: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 469: dim1x1 sub_swap
    gl64_t s0_469 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_469 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_469 - s0_469;
    // Op 470: dim3x3 add
    gl64_t s1_470_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_470_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_470_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_470_0; tmp3_10 = tmp3_10 + s1_470_1; tmp3_11 = tmp3_11 + s1_470_2;
    // Op 471: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 472: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 473: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 474: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 475: dim3x3 mul
    gl64_t s1_475_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_475_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_475_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA475 = (tmp3_0 + tmp3_1) * (s1_475_0 + s1_475_1);
    gl64_t kB475 = (tmp3_0 + tmp3_2) * (s1_475_0 + s1_475_2);
    gl64_t kC475 = (tmp3_1 + tmp3_2) * (s1_475_1 + s1_475_2);
    gl64_t kD475 = tmp3_0 * s1_475_0;
    gl64_t kE475 = tmp3_1 * s1_475_1;
    gl64_t kF475 = tmp3_2 * s1_475_2;
    gl64_t kG475 = kD475 - kE475;
    tmp3_3 = (kC475 + kG475) - kF475;
    tmp3_4 = ((((kA475 + kC475) - kE475) - kE475) - kD475);
    tmp3_5 = kB475 - kG475;
    // Op 476: dim3x1 mul
    gl64_t s0_476_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_476_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_476_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_476 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp3_0 = s0_476_0 * s1_476; tmp3_1 = s0_476_1 * s1_476; tmp3_2 = s0_476_2 * s1_476;
    // Op 477: dim3x1 add
    gl64_t s1_477 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_477; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 478: dim3x3 mul
    gl64_t s1_478_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_478_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_478_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA478 = (tmp3_0 + tmp3_1) * (s1_478_0 + s1_478_1);
    gl64_t kB478 = (tmp3_0 + tmp3_2) * (s1_478_0 + s1_478_2);
    gl64_t kC478 = (tmp3_1 + tmp3_2) * (s1_478_1 + s1_478_2);
    gl64_t kD478 = tmp3_0 * s1_478_0;
    gl64_t kE478 = tmp3_1 * s1_478_1;
    gl64_t kF478 = tmp3_2 * s1_478_2;
    gl64_t kG478 = kD478 - kE478;
    tmp3_0 = (kC478 + kG478) - kF478;
    tmp3_1 = ((((kA478 + kC478) - kE478) - kE478) - kD478);
    tmp3_2 = kB478 - kG478;
    // Op 479: dim3x1 add
    gl64_t s1_479 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_479; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 480: dim3x3 mul
    gl64_t s1_480_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_480_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_480_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA480 = (tmp3_0 + tmp3_1) * (s1_480_0 + s1_480_1);
    gl64_t kB480 = (tmp3_0 + tmp3_2) * (s1_480_0 + s1_480_2);
    gl64_t kC480 = (tmp3_1 + tmp3_2) * (s1_480_1 + s1_480_2);
    gl64_t kD480 = tmp3_0 * s1_480_0;
    gl64_t kE480 = tmp3_1 * s1_480_1;
    gl64_t kF480 = tmp3_2 * s1_480_2;
    gl64_t kG480 = kD480 - kE480;
    tmp3_0 = (kC480 + kG480) - kF480;
    tmp3_1 = ((((kA480 + kC480) - kE480) - kE480) - kD480);
    tmp3_2 = kB480 - kG480;
    // Op 481: dim1x1 mul
    gl64_t s0_481 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_481 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_481 * s1_481;
    // Op 482: dim1x1 add
    gl64_t s1_482 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_482;
    // Op 483: dim1x1 add
    gl64_t s1_483 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_483;
    // Op 484: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 485: dim3x3 mul
    gl64_t s1_485_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_485_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_485_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA485 = (tmp3_0 + tmp3_1) * (s1_485_0 + s1_485_1);
    gl64_t kB485 = (tmp3_0 + tmp3_2) * (s1_485_0 + s1_485_2);
    gl64_t kC485 = (tmp3_1 + tmp3_2) * (s1_485_1 + s1_485_2);
    gl64_t kD485 = tmp3_0 * s1_485_0;
    gl64_t kE485 = tmp3_1 * s1_485_1;
    gl64_t kF485 = tmp3_2 * s1_485_2;
    gl64_t kG485 = kD485 - kE485;
    tmp3_0 = (kC485 + kG485) - kF485;
    tmp3_1 = ((((kA485 + kC485) - kE485) - kE485) - kD485);
    tmp3_2 = kB485 - kG485;
    // Op 486: dim1x1 mul
    gl64_t s0_486 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_486 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_486 * s1_486;
    // Op 487: dim1x1 add
    gl64_t s1_487 = *(gl64_t*)&expressions_params[9][7];
    tmp1_0 = tmp1_0 + s1_487;
    // Op 488: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 489: dim3x3 mul
    gl64_t s1_489_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_489_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_489_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA489 = (tmp3_0 + tmp3_1) * (s1_489_0 + s1_489_1);
    gl64_t kB489 = (tmp3_0 + tmp3_2) * (s1_489_0 + s1_489_2);
    gl64_t kC489 = (tmp3_1 + tmp3_2) * (s1_489_1 + s1_489_2);
    gl64_t kD489 = tmp3_0 * s1_489_0;
    gl64_t kE489 = tmp3_1 * s1_489_1;
    gl64_t kF489 = tmp3_2 * s1_489_2;
    gl64_t kG489 = kD489 - kE489;
    tmp3_0 = (kC489 + kG489) - kF489;
    tmp3_1 = ((((kA489 + kC489) - kE489) - kE489) - kD489);
    tmp3_2 = kB489 - kG489;
    // Op 490: dim3x1 add
    gl64_t s1_490 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_490; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 491: dim3x3 mul
    gl64_t s1_491_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_491_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_491_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA491 = (tmp3_0 + tmp3_1) * (s1_491_0 + s1_491_1);
    gl64_t kB491 = (tmp3_0 + tmp3_2) * (s1_491_0 + s1_491_2);
    gl64_t kC491 = (tmp3_1 + tmp3_2) * (s1_491_1 + s1_491_2);
    gl64_t kD491 = tmp3_0 * s1_491_0;
    gl64_t kE491 = tmp3_1 * s1_491_1;
    gl64_t kF491 = tmp3_2 * s1_491_2;
    gl64_t kG491 = kD491 - kE491;
    tmp3_0 = (kC491 + kG491) - kF491;
    tmp3_1 = ((((kA491 + kC491) - kE491) - kE491) - kD491);
    tmp3_2 = kB491 - kG491;
    // Op 492: dim3x1 add
    gl64_t s1_492 = *(gl64_t*)&expressions_params[9][5];
    tmp3_9 = tmp3_0 + s1_492; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 493: dim3x3 add
    gl64_t s1_493_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_493_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_493_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_493_0; tmp3_13 = tmp3_10 + s1_493_1; tmp3_14 = tmp3_11 + s1_493_2;
    // Op 494: dim3x1 mul
    gl64_t s0_494_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_494_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_494_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_494 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp3_0 = s0_494_0 * s1_494; tmp3_1 = s0_494_1 * s1_494; tmp3_2 = s0_494_2 * s1_494;
    // Op 495: dim3x1 add
    gl64_t s1_495 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_495; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 496: dim3x3 mul
    gl64_t s1_496_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_496_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_496_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA496 = (tmp3_0 + tmp3_1) * (s1_496_0 + s1_496_1);
    gl64_t kB496 = (tmp3_0 + tmp3_2) * (s1_496_0 + s1_496_2);
    gl64_t kC496 = (tmp3_1 + tmp3_2) * (s1_496_1 + s1_496_2);
    gl64_t kD496 = tmp3_0 * s1_496_0;
    gl64_t kE496 = tmp3_1 * s1_496_1;
    gl64_t kF496 = tmp3_2 * s1_496_2;
    gl64_t kG496 = kD496 - kE496;
    tmp3_0 = (kC496 + kG496) - kF496;
    tmp3_1 = ((((kA496 + kC496) - kE496) - kE496) - kD496);
    tmp3_2 = kB496 - kG496;
    // Op 497: dim3x1 add
    gl64_t s1_497 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_497; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 498: dim3x3 mul
    gl64_t s1_498_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_498_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_498_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA498 = (tmp3_0 + tmp3_1) * (s1_498_0 + s1_498_1);
    gl64_t kB498 = (tmp3_0 + tmp3_2) * (s1_498_0 + s1_498_2);
    gl64_t kC498 = (tmp3_1 + tmp3_2) * (s1_498_1 + s1_498_2);
    gl64_t kD498 = tmp3_0 * s1_498_0;
    gl64_t kE498 = tmp3_1 * s1_498_1;
    gl64_t kF498 = tmp3_2 * s1_498_2;
    gl64_t kG498 = kD498 - kE498;
    tmp3_0 = (kC498 + kG498) - kF498;
    tmp3_1 = ((((kA498 + kC498) - kE498) - kE498) - kD498);
    tmp3_2 = kB498 - kG498;
    // Op 499: dim1x1 mul
    gl64_t s0_499 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_499 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_499 * s1_499;
    // Op 500: dim1x1 add
    gl64_t s1_500 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_500;
    // Op 501: dim1x1 add
    gl64_t s0_501 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_501 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_5 = s0_501 + s1_501;
    // Op 502: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_5;
    // Op 503: dim1x1 add
    gl64_t s1_503 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_503;
    // Op 504: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 505: dim3x3 mul
    gl64_t s1_505_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_505_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_505_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA505 = (tmp3_0 + tmp3_1) * (s1_505_0 + s1_505_1);
    gl64_t kB505 = (tmp3_0 + tmp3_2) * (s1_505_0 + s1_505_2);
    gl64_t kC505 = (tmp3_1 + tmp3_2) * (s1_505_1 + s1_505_2);
    gl64_t kD505 = tmp3_0 * s1_505_0;
    gl64_t kE505 = tmp3_1 * s1_505_1;
    gl64_t kF505 = tmp3_2 * s1_505_2;
    gl64_t kG505 = kD505 - kE505;
    tmp3_0 = (kC505 + kG505) - kF505;
    tmp3_1 = ((((kA505 + kC505) - kE505) - kE505) - kD505);
    tmp3_2 = kB505 - kG505;
    // Op 506: dim1x1 mul
    gl64_t s0_506 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_506 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_506 * s1_506;
    // Op 507: dim1x1 add
    gl64_t s1_507 = *(gl64_t*)&expressions_params[9][7];
    tmp1_0 = tmp1_0 + s1_507;
    // Op 508: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 509: dim3x3 mul
    gl64_t s1_509_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_509_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_509_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA509 = (tmp3_0 + tmp3_1) * (s1_509_0 + s1_509_1);
    gl64_t kB509 = (tmp3_0 + tmp3_2) * (s1_509_0 + s1_509_2);
    gl64_t kC509 = (tmp3_1 + tmp3_2) * (s1_509_1 + s1_509_2);
    gl64_t kD509 = tmp3_0 * s1_509_0;
    gl64_t kE509 = tmp3_1 * s1_509_1;
    gl64_t kF509 = tmp3_2 * s1_509_2;
    gl64_t kG509 = kD509 - kE509;
    tmp3_0 = (kC509 + kG509) - kF509;
    tmp3_1 = ((((kA509 + kC509) - kE509) - kE509) - kD509);
    tmp3_2 = kB509 - kG509;
    // Op 510: dim1x1 add
    gl64_t s0_510 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_510 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_510 + s1_510;
    // Op 511: dim1x1 add
    gl64_t s1_511 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_511;
    // Op 512: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 513: dim3x3 mul
    gl64_t s1_513_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_513_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_513_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA513 = (tmp3_0 + tmp3_1) * (s1_513_0 + s1_513_1);
    gl64_t kB513 = (tmp3_0 + tmp3_2) * (s1_513_0 + s1_513_2);
    gl64_t kC513 = (tmp3_1 + tmp3_2) * (s1_513_1 + s1_513_2);
    gl64_t kD513 = tmp3_0 * s1_513_0;
    gl64_t kE513 = tmp3_1 * s1_513_1;
    gl64_t kF513 = tmp3_2 * s1_513_2;
    gl64_t kG513 = kD513 - kE513;
    tmp3_0 = (kC513 + kG513) - kF513;
    tmp3_1 = ((((kA513 + kC513) - kE513) - kE513) - kD513);
    tmp3_2 = kB513 - kG513;
    // Op 514: dim3x1 add
    gl64_t s1_514 = *(gl64_t*)&expressions_params[9][5];
    tmp3_6 = tmp3_0 + s1_514; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 515: dim3x3 add
    gl64_t s1_515_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_515_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_515_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_515_0; tmp3_1 = tmp3_7 + s1_515_1; tmp3_2 = tmp3_8 + s1_515_2;
    // Op 516: dim3x3 mul
    gl64_t kA516 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB516 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC516 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD516 = tmp3_12 * tmp3_0;
    gl64_t kE516 = tmp3_13 * tmp3_1;
    gl64_t kF516 = tmp3_14 * tmp3_2;
    gl64_t kG516 = kD516 - kE516;
    tmp3_0 = (kC516 + kG516) - kF516;
    tmp3_1 = ((((kA516 + kC516) - kE516) - kE516) - kD516);
    tmp3_2 = kB516 - kG516;
    // Op 517: dim3x3 mul
    uint64_t s0_517_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_517_0 = *(gl64_t*)&dParams->aux_trace[s0_517_pos];
    gl64_t s0_517_1 = *(gl64_t*)&dParams->aux_trace[s0_517_pos + TILE_HEIGHT];
    gl64_t s0_517_2 = *(gl64_t*)&dParams->aux_trace[s0_517_pos + 2*TILE_HEIGHT];
    gl64_t kA517 = (s0_517_0 + s0_517_1) * (tmp3_0 + tmp3_1);
    gl64_t kB517 = (s0_517_0 + s0_517_2) * (tmp3_0 + tmp3_2);
    gl64_t kC517 = (s0_517_1 + s0_517_2) * (tmp3_1 + tmp3_2);
    gl64_t kD517 = s0_517_0 * tmp3_0;
    gl64_t kE517 = s0_517_1 * tmp3_1;
    gl64_t kF517 = s0_517_2 * tmp3_2;
    gl64_t kG517 = kD517 - kE517;
    tmp3_0 = (kC517 + kG517) - kF517;
    tmp3_1 = ((((kA517 + kC517) - kE517) - kE517) - kD517);
    tmp3_2 = kB517 - kG517;
    // Op 518: dim1x1 sub_swap
    gl64_t s0_518 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_518 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_518 - s0_518;
    // Op 519: dim3x3 add
    gl64_t s1_519_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_519_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_519_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_519_0; tmp3_7 = tmp3_7 + s1_519_1; tmp3_8 = tmp3_8 + s1_519_2;
    // Op 520: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 521: dim1x1 sub_swap
    gl64_t s0_521 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_521 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_521 - s0_521;
    // Op 522: dim3x3 add
    gl64_t s1_522_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_522_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_522_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_522_0; tmp3_10 = tmp3_10 + s1_522_1; tmp3_11 = tmp3_11 + s1_522_2;
    // Op 523: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 524: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 525: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 526: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 527: dim3x3 mul
    gl64_t s1_527_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_527_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_527_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA527 = (tmp3_0 + tmp3_1) * (s1_527_0 + s1_527_1);
    gl64_t kB527 = (tmp3_0 + tmp3_2) * (s1_527_0 + s1_527_2);
    gl64_t kC527 = (tmp3_1 + tmp3_2) * (s1_527_1 + s1_527_2);
    gl64_t kD527 = tmp3_0 * s1_527_0;
    gl64_t kE527 = tmp3_1 * s1_527_1;
    gl64_t kF527 = tmp3_2 * s1_527_2;
    gl64_t kG527 = kD527 - kE527;
    tmp3_3 = (kC527 + kG527) - kF527;
    tmp3_4 = ((((kA527 + kC527) - kE527) - kE527) - kD527);
    tmp3_5 = kB527 - kG527;
    // Op 528: dim1x1 mul
    gl64_t s0_528 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_528 = *(gl64_t*)&expressions_params[9][2];
    tmp1_5 = s0_528 * s1_528;
    // Op 529: dim1x1 sub
    gl64_t s0_529 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_529 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_529 - s1_529;
    // Op 530: dim1x1 add
    gl64_t s0_530 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_530 + tmp1_0;
    // Op 531: dim1x1 mul
    tmp1_0 = tmp1_5 * tmp1_0;
    // Op 532: dim1x1 add
    gl64_t s0_532 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_532 + tmp1_0;
    // Op 533: dim3x1 mul
    gl64_t s0_533_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_533_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_533_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_533_0 * tmp1_0; tmp3_1 = s0_533_1 * tmp1_0; tmp3_2 = s0_533_2 * tmp1_0;
    // Op 534: dim3x1 add
    gl64_t s1_534 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_534; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 535: dim3x3 mul
    gl64_t s1_535_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_535_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_535_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA535 = (tmp3_0 + tmp3_1) * (s1_535_0 + s1_535_1);
    gl64_t kB535 = (tmp3_0 + tmp3_2) * (s1_535_0 + s1_535_2);
    gl64_t kC535 = (tmp3_1 + tmp3_2) * (s1_535_1 + s1_535_2);
    gl64_t kD535 = tmp3_0 * s1_535_0;
    gl64_t kE535 = tmp3_1 * s1_535_1;
    gl64_t kF535 = tmp3_2 * s1_535_2;
    gl64_t kG535 = kD535 - kE535;
    tmp3_0 = (kC535 + kG535) - kF535;
    tmp3_1 = ((((kA535 + kC535) - kE535) - kE535) - kD535);
    tmp3_2 = kB535 - kG535;
    // Op 536: dim3x3 mul
    gl64_t s1_536_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_536_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_536_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA536 = (tmp3_0 + tmp3_1) * (s1_536_0 + s1_536_1);
    gl64_t kB536 = (tmp3_0 + tmp3_2) * (s1_536_0 + s1_536_2);
    gl64_t kC536 = (tmp3_1 + tmp3_2) * (s1_536_1 + s1_536_2);
    gl64_t kD536 = tmp3_0 * s1_536_0;
    gl64_t kE536 = tmp3_1 * s1_536_1;
    gl64_t kF536 = tmp3_2 * s1_536_2;
    gl64_t kG536 = kD536 - kE536;
    tmp3_0 = (kC536 + kG536) - kF536;
    tmp3_1 = ((((kA536 + kC536) - kE536) - kE536) - kD536);
    tmp3_2 = kB536 - kG536;
    // Op 537: dim3x3 mul
    gl64_t s1_537_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_537_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_537_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA537 = (tmp3_0 + tmp3_1) * (s1_537_0 + s1_537_1);
    gl64_t kB537 = (tmp3_0 + tmp3_2) * (s1_537_0 + s1_537_2);
    gl64_t kC537 = (tmp3_1 + tmp3_2) * (s1_537_1 + s1_537_2);
    gl64_t kD537 = tmp3_0 * s1_537_0;
    gl64_t kE537 = tmp3_1 * s1_537_1;
    gl64_t kF537 = tmp3_2 * s1_537_2;
    gl64_t kG537 = kD537 - kE537;
    tmp3_0 = (kC537 + kG537) - kF537;
    tmp3_1 = ((((kA537 + kC537) - kE537) - kE537) - kD537);
    tmp3_2 = kB537 - kG537;
    // Op 538: dim1x1 mul
    gl64_t s0_538 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_538 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_538 * s1_538;
    // Op 539: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 540: dim3x3 mul
    gl64_t s1_540_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_540_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_540_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA540 = (tmp3_0 + tmp3_1) * (s1_540_0 + s1_540_1);
    gl64_t kB540 = (tmp3_0 + tmp3_2) * (s1_540_0 + s1_540_2);
    gl64_t kC540 = (tmp3_1 + tmp3_2) * (s1_540_1 + s1_540_2);
    gl64_t kD540 = tmp3_0 * s1_540_0;
    gl64_t kE540 = tmp3_1 * s1_540_1;
    gl64_t kF540 = tmp3_2 * s1_540_2;
    gl64_t kG540 = kD540 - kE540;
    tmp3_0 = (kC540 + kG540) - kF540;
    tmp3_1 = ((((kA540 + kC540) - kE540) - kE540) - kD540);
    tmp3_2 = kB540 - kG540;
    // Op 541: dim3x3 mul
    gl64_t s1_541_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_541_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_541_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA541 = (tmp3_0 + tmp3_1) * (s1_541_0 + s1_541_1);
    gl64_t kB541 = (tmp3_0 + tmp3_2) * (s1_541_0 + s1_541_2);
    gl64_t kC541 = (tmp3_1 + tmp3_2) * (s1_541_1 + s1_541_2);
    gl64_t kD541 = tmp3_0 * s1_541_0;
    gl64_t kE541 = tmp3_1 * s1_541_1;
    gl64_t kF541 = tmp3_2 * s1_541_2;
    gl64_t kG541 = kD541 - kE541;
    tmp3_0 = (kC541 + kG541) - kF541;
    tmp3_1 = ((((kA541 + kC541) - kE541) - kE541) - kD541);
    tmp3_2 = kB541 - kG541;
    // Op 542: dim1x1 mul
    gl64_t s0_542 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_542 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_542 * s1_542;
    // Op 543: dim1x1 mul
    gl64_t s0_543 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_1 = s0_543 * tmp1_0;
    // Op 544: dim1x1 mul
    gl64_t s0_544 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_544 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_544 * s1_544;
    // Op 545: dim1x1 add
    gl64_t s0_545 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_545 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_5 = s0_545 + s1_545;
    // Op 546: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_5;
    // Op 547: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 548: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 549: dim3x3 mul
    gl64_t s1_549_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_549_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_549_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA549 = (tmp3_0 + tmp3_1) * (s1_549_0 + s1_549_1);
    gl64_t kB549 = (tmp3_0 + tmp3_2) * (s1_549_0 + s1_549_2);
    gl64_t kC549 = (tmp3_1 + tmp3_2) * (s1_549_1 + s1_549_2);
    gl64_t kD549 = tmp3_0 * s1_549_0;
    gl64_t kE549 = tmp3_1 * s1_549_1;
    gl64_t kF549 = tmp3_2 * s1_549_2;
    gl64_t kG549 = kD549 - kE549;
    tmp3_0 = (kC549 + kG549) - kF549;
    tmp3_1 = ((((kA549 + kC549) - kE549) - kE549) - kD549);
    tmp3_2 = kB549 - kG549;
    // Op 550: dim3x3 mul
    gl64_t s1_550_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_550_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_550_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA550 = (tmp3_0 + tmp3_1) * (s1_550_0 + s1_550_1);
    gl64_t kB550 = (tmp3_0 + tmp3_2) * (s1_550_0 + s1_550_2);
    gl64_t kC550 = (tmp3_1 + tmp3_2) * (s1_550_1 + s1_550_2);
    gl64_t kD550 = tmp3_0 * s1_550_0;
    gl64_t kE550 = tmp3_1 * s1_550_1;
    gl64_t kF550 = tmp3_2 * s1_550_2;
    gl64_t kG550 = kD550 - kE550;
    tmp3_0 = (kC550 + kG550) - kF550;
    tmp3_1 = ((((kA550 + kC550) - kE550) - kE550) - kD550);
    tmp3_2 = kB550 - kG550;
    // Op 551: dim1x1 mul
    gl64_t s0_551 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_551 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_551 * s1_551;
    // Op 552: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 553: dim3x3 mul
    gl64_t s1_553_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_553_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_553_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA553 = (tmp3_0 + tmp3_1) * (s1_553_0 + s1_553_1);
    gl64_t kB553 = (tmp3_0 + tmp3_2) * (s1_553_0 + s1_553_2);
    gl64_t kC553 = (tmp3_1 + tmp3_2) * (s1_553_1 + s1_553_2);
    gl64_t kD553 = tmp3_0 * s1_553_0;
    gl64_t kE553 = tmp3_1 * s1_553_1;
    gl64_t kF553 = tmp3_2 * s1_553_2;
    gl64_t kG553 = kD553 - kE553;
    tmp3_0 = (kC553 + kG553) - kF553;
    tmp3_1 = ((((kA553 + kC553) - kE553) - kE553) - kD553);
    tmp3_2 = kB553 - kG553;
    // Op 554: dim1x1 mul
    gl64_t s0_554 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_554 = *(gl64_t*)&expressions_params[9][8];
    tmp1_0 = s0_554 * s1_554;
    // Op 555: dim1x1 mul
    gl64_t s0_555 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_555 = *(gl64_t*)&expressions_params[9][9];
    tmp1_1 = s0_555 * s1_555;
    // Op 556: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 557: dim1x1 mul
    gl64_t s0_557 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_557 = *(gl64_t*)&expressions_params[9][10];
    tmp1_1 = s0_557 * s1_557;
    // Op 558: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 559: dim1x1 mul
    gl64_t s0_559 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_559 = *(gl64_t*)&expressions_params[9][11];
    tmp1_1 = s0_559 * s1_559;
    // Op 560: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 561: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 562: dim3x3 mul
    gl64_t s1_562_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_562_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_562_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA562 = (tmp3_0 + tmp3_1) * (s1_562_0 + s1_562_1);
    gl64_t kB562 = (tmp3_0 + tmp3_2) * (s1_562_0 + s1_562_2);
    gl64_t kC562 = (tmp3_1 + tmp3_2) * (s1_562_1 + s1_562_2);
    gl64_t kD562 = tmp3_0 * s1_562_0;
    gl64_t kE562 = tmp3_1 * s1_562_1;
    gl64_t kF562 = tmp3_2 * s1_562_2;
    gl64_t kG562 = kD562 - kE562;
    tmp3_0 = (kC562 + kG562) - kF562;
    tmp3_1 = ((((kA562 + kC562) - kE562) - kE562) - kD562);
    tmp3_2 = kB562 - kG562;
    // Op 563: dim3x1 add
    gl64_t s1_563 = *(gl64_t*)&expressions_params[9][12];
    tmp3_0 = tmp3_0 + s1_563; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 564: dim3x3 add
    gl64_t s1_564_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_564_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_564_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_564_0; tmp3_1 = tmp3_1 + s1_564_1; tmp3_2 = tmp3_2 + s1_564_2;
    // Op 565: dim3x3 mul
    gl64_t s0_565_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_565_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_565_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    gl64_t kA565 = (s0_565_0 + s0_565_1) * (tmp3_0 + tmp3_1);
    gl64_t kB565 = (s0_565_0 + s0_565_2) * (tmp3_0 + tmp3_2);
    gl64_t kC565 = (s0_565_1 + s0_565_2) * (tmp3_1 + tmp3_2);
    gl64_t kD565 = s0_565_0 * tmp3_0;
    gl64_t kE565 = s0_565_1 * tmp3_1;
    gl64_t kF565 = s0_565_2 * tmp3_2;
    gl64_t kG565 = kD565 - kE565;
    tmp3_0 = (kC565 + kG565) - kF565;
    tmp3_1 = ((((kA565 + kC565) - kE565) - kE565) - kD565);
    tmp3_2 = kB565 - kG565;
    // Op 566: dim3x1 sub
    gl64_t s1_566 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 - s1_566; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 567: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 568: dim3x3 mul
    gl64_t s1_568_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_568_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_568_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA568 = (tmp3_0 + tmp3_1) * (s1_568_0 + s1_568_1);
    gl64_t kB568 = (tmp3_0 + tmp3_2) * (s1_568_0 + s1_568_2);
    gl64_t kC568 = (tmp3_1 + tmp3_2) * (s1_568_1 + s1_568_2);
    gl64_t kD568 = tmp3_0 * s1_568_0;
    gl64_t kE568 = tmp3_1 * s1_568_1;
    gl64_t kF568 = tmp3_2 * s1_568_2;
    gl64_t kG568 = kD568 - kE568;
    tmp3_6 = (kC568 + kG568) - kF568;
    tmp3_7 = ((((kA568 + kC568) - kE568) - kE568) - kD568);
    tmp3_8 = kB568 - kG568;
    // Op 569: dim1x1 sub_swap
    gl64_t s0_569 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_569 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_569 - s0_569;
    // Op 570: dim3x1 mul
    uint64_t s0_570_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_570_0 = *(gl64_t*)&dParams->aux_trace[s0_570_pos];
    gl64_t s0_570_1 = *(gl64_t*)&dParams->aux_trace[s0_570_pos + TILE_HEIGHT];
    gl64_t s0_570_2 = *(gl64_t*)&dParams->aux_trace[s0_570_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_570_0 * tmp1_0; tmp3_1 = s0_570_1 * tmp1_0; tmp3_2 = s0_570_2 * tmp1_0;
    // Op 571: dim3x3 sub
    uint64_t s0_571_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_571_0 = *(gl64_t*)&dParams->aux_trace[s0_571_pos];
    gl64_t s0_571_1 = *(gl64_t*)&dParams->aux_trace[s0_571_pos + TILE_HEIGHT];
    gl64_t s0_571_2 = *(gl64_t*)&dParams->aux_trace[s0_571_pos + 2*TILE_HEIGHT];
    tmp3_3 = s0_571_0 - tmp3_0; tmp3_4 = s0_571_1 - tmp3_1; tmp3_5 = s0_571_2 - tmp3_2;
    // Op 572: dim3x3 add
    gl64_t s0_572_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_572_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_572_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_572_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_572_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_572_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_0 = s0_572_0 + s1_572_0; tmp3_1 = s0_572_1 + s1_572_1; tmp3_2 = s0_572_2 + s1_572_2;
    // Op 573: dim3x3 add
    uint64_t s0_573_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_573_0 = *(gl64_t*)&dParams->aux_trace[s0_573_pos];
    gl64_t s0_573_1 = *(gl64_t*)&dParams->aux_trace[s0_573_pos + TILE_HEIGHT];
    gl64_t s0_573_2 = *(gl64_t*)&dParams->aux_trace[s0_573_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_573_0 + tmp3_0; tmp3_1 = s0_573_1 + tmp3_1; tmp3_2 = s0_573_2 + tmp3_2;
    // Op 574: dim3x3 add
    uint64_t s0_574_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_574_0 = *(gl64_t*)&dParams->aux_trace[s0_574_pos];
    gl64_t s0_574_1 = *(gl64_t*)&dParams->aux_trace[s0_574_pos + TILE_HEIGHT];
    gl64_t s0_574_2 = *(gl64_t*)&dParams->aux_trace[s0_574_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_574_0 + tmp3_0; tmp3_1 = s0_574_1 + tmp3_1; tmp3_2 = s0_574_2 + tmp3_2;
    // Op 575: dim3x3 add
    gl64_t s0_575_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_575_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_575_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    tmp3_0 = s0_575_0 + tmp3_0; tmp3_1 = s0_575_1 + tmp3_1; tmp3_2 = s0_575_2 + tmp3_2;
    // Op 576: dim3x3 sub
    tmp3_3 = tmp3_3 - tmp3_0; tmp3_4 = tmp3_4 - tmp3_1; tmp3_5 = tmp3_5 - tmp3_2;
    // Op 577: dim1x1 mul
    gl64_t s0_577 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_577 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_577 * s1_577;
    // Op 578: dim3x1 mul
    gl64_t s0_578_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_578_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_578_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_578_0 * tmp1_0; tmp3_1 = s0_578_1 * tmp1_0; tmp3_2 = s0_578_2 * tmp1_0;
    // Op 579: dim3x1 add
    gl64_t s1_579 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_579; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 580: dim3x3 mul
    gl64_t s1_580_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_580_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_580_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA580 = (tmp3_0 + tmp3_1) * (s1_580_0 + s1_580_1);
    gl64_t kB580 = (tmp3_0 + tmp3_2) * (s1_580_0 + s1_580_2);
    gl64_t kC580 = (tmp3_1 + tmp3_2) * (s1_580_1 + s1_580_2);
    gl64_t kD580 = tmp3_0 * s1_580_0;
    gl64_t kE580 = tmp3_1 * s1_580_1;
    gl64_t kF580 = tmp3_2 * s1_580_2;
    gl64_t kG580 = kD580 - kE580;
    tmp3_0 = (kC580 + kG580) - kF580;
    tmp3_1 = ((((kA580 + kC580) - kE580) - kE580) - kD580);
    tmp3_2 = kB580 - kG580;
    // Op 581: dim1x1 mul
    gl64_t s0_581 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_581 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_581 * s1_581;
    // Op 582: dim1x1 add
    gl64_t s1_582 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_582;
    // Op 583: dim1x1 add
    gl64_t s1_583 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_583;
    // Op 584: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 585: dim3x3 mul
    gl64_t s1_585_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_585_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_585_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA585 = (tmp3_0 + tmp3_1) * (s1_585_0 + s1_585_1);
    gl64_t kB585 = (tmp3_0 + tmp3_2) * (s1_585_0 + s1_585_2);
    gl64_t kC585 = (tmp3_1 + tmp3_2) * (s1_585_1 + s1_585_2);
    gl64_t kD585 = tmp3_0 * s1_585_0;
    gl64_t kE585 = tmp3_1 * s1_585_1;
    gl64_t kF585 = tmp3_2 * s1_585_2;
    gl64_t kG585 = kD585 - kE585;
    tmp3_0 = (kC585 + kG585) - kF585;
    tmp3_1 = ((((kA585 + kC585) - kE585) - kE585) - kD585);
    tmp3_2 = kB585 - kG585;
    // Op 586: dim3x1 add
    gl64_t s1_586 = *(gl64_t*)&expressions_params[9][15];
    tmp3_0 = tmp3_0 + s1_586; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 587: dim3x3 mul
    gl64_t s1_587_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_587_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_587_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA587 = (tmp3_0 + tmp3_1) * (s1_587_0 + s1_587_1);
    gl64_t kB587 = (tmp3_0 + tmp3_2) * (s1_587_0 + s1_587_2);
    gl64_t kC587 = (tmp3_1 + tmp3_2) * (s1_587_1 + s1_587_2);
    gl64_t kD587 = tmp3_0 * s1_587_0;
    gl64_t kE587 = tmp3_1 * s1_587_1;
    gl64_t kF587 = tmp3_2 * s1_587_2;
    gl64_t kG587 = kD587 - kE587;
    tmp3_0 = (kC587 + kG587) - kF587;
    tmp3_1 = ((((kA587 + kC587) - kE587) - kE587) - kD587);
    tmp3_2 = kB587 - kG587;
    // Op 588: dim3x1 add
    gl64_t s1_588 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_588; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 589: dim3x3 mul
    gl64_t s1_589_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_589_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_589_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA589 = (tmp3_0 + tmp3_1) * (s1_589_0 + s1_589_1);
    gl64_t kB589 = (tmp3_0 + tmp3_2) * (s1_589_0 + s1_589_2);
    gl64_t kC589 = (tmp3_1 + tmp3_2) * (s1_589_1 + s1_589_2);
    gl64_t kD589 = tmp3_0 * s1_589_0;
    gl64_t kE589 = tmp3_1 * s1_589_1;
    gl64_t kF589 = tmp3_2 * s1_589_2;
    gl64_t kG589 = kD589 - kE589;
    tmp3_0 = (kC589 + kG589) - kF589;
    tmp3_1 = ((((kA589 + kC589) - kE589) - kE589) - kD589);
    tmp3_2 = kB589 - kG589;
    // Op 590: dim3x1 add
    gl64_t s1_590 = *(gl64_t*)&expressions_params[9][5];
    tmp3_0 = tmp3_0 + s1_590; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 591: dim3x3 add
    gl64_t s1_591_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_591_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_591_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_591_0; tmp3_1 = tmp3_1 + s1_591_1; tmp3_2 = tmp3_2 + s1_591_2;
    // Op 592: dim3x3 mul
    gl64_t kA592 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB592 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC592 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD592 = tmp3_3 * tmp3_0;
    gl64_t kE592 = tmp3_4 * tmp3_1;
    gl64_t kF592 = tmp3_5 * tmp3_2;
    gl64_t kG592 = kD592 - kE592;
    tmp3_0 = (kC592 + kG592) - kF592;
    tmp3_1 = ((((kA592 + kC592) - kE592) - kE592) - kD592);
    tmp3_2 = kB592 - kG592;
    // Op 593: dim1x1 sub_swap
    gl64_t s0_593 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_593 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_593 - s0_593;
    // Op 594: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 595: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 596: dim3x3 mul
    gl64_t s1_596_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_596_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_596_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA596 = (tmp3_0 + tmp3_1) * (s1_596_0 + s1_596_1);
    gl64_t kB596 = (tmp3_0 + tmp3_2) * (s1_596_0 + s1_596_2);
    gl64_t kC596 = (tmp3_1 + tmp3_2) * (s1_596_1 + s1_596_2);
    gl64_t kD596 = tmp3_0 * s1_596_0;
    gl64_t kE596 = tmp3_1 * s1_596_1;
    gl64_t kF596 = tmp3_2 * s1_596_2;
    gl64_t kG596 = kD596 - kE596;
    tmp3_6 = (kC596 + kG596) - kF596;
    tmp3_7 = ((((kA596 + kC596) - kE596) - kE596) - kD596);
    tmp3_8 = kB596 - kG596;
    // Op 597: dim3x1 mul
    gl64_t s0_597_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_597_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_597_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_597 = *(gl64_t*)&expressions_params[10][5];
    tmp3_0 = s0_597_0 * s1_597; tmp3_1 = s0_597_1 * s1_597; tmp3_2 = s0_597_2 * s1_597;
    // Op 598: dim3x1 add
    gl64_t s1_598 = *(gl64_t*)&expressions_params[10][14];
    tmp3_0 = tmp3_0 + s1_598; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 599: dim3x3 mul
    gl64_t s1_599_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_599_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_599_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA599 = (tmp3_0 + tmp3_1) * (s1_599_0 + s1_599_1);
    gl64_t kB599 = (tmp3_0 + tmp3_2) * (s1_599_0 + s1_599_2);
    gl64_t kC599 = (tmp3_1 + tmp3_2) * (s1_599_1 + s1_599_2);
    gl64_t kD599 = tmp3_0 * s1_599_0;
    gl64_t kE599 = tmp3_1 * s1_599_1;
    gl64_t kF599 = tmp3_2 * s1_599_2;
    gl64_t kG599 = kD599 - kE599;
    tmp3_0 = (kC599 + kG599) - kF599;
    tmp3_1 = ((((kA599 + kC599) - kE599) - kE599) - kD599);
    tmp3_2 = kB599 - kG599;
    // Op 600: dim3x1 add
    gl64_t s1_600 = *(gl64_t*)&expressions_params[10][3];
    tmp3_0 = tmp3_0 + s1_600; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 601: dim3x3 mul
    gl64_t s1_601_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_601_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_601_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA601 = (tmp3_0 + tmp3_1) * (s1_601_0 + s1_601_1);
    gl64_t kB601 = (tmp3_0 + tmp3_2) * (s1_601_0 + s1_601_2);
    gl64_t kC601 = (tmp3_1 + tmp3_2) * (s1_601_1 + s1_601_2);
    gl64_t kD601 = tmp3_0 * s1_601_0;
    gl64_t kE601 = tmp3_1 * s1_601_1;
    gl64_t kF601 = tmp3_2 * s1_601_2;
    gl64_t kG601 = kD601 - kE601;
    tmp3_0 = (kC601 + kG601) - kF601;
    tmp3_1 = ((((kA601 + kC601) - kE601) - kE601) - kD601);
    tmp3_2 = kB601 - kG601;
    // Op 602: dim3x1 add
    gl64_t s1_602 = *(gl64_t*)&expressions_params[10][4];
    tmp3_0 = tmp3_0 + s1_602; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 603: dim3x3 mul
    gl64_t s1_603_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_603_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_603_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA603 = (tmp3_0 + tmp3_1) * (s1_603_0 + s1_603_1);
    gl64_t kB603 = (tmp3_0 + tmp3_2) * (s1_603_0 + s1_603_2);
    gl64_t kC603 = (tmp3_1 + tmp3_2) * (s1_603_1 + s1_603_2);
    gl64_t kD603 = tmp3_0 * s1_603_0;
    gl64_t kE603 = tmp3_1 * s1_603_1;
    gl64_t kF603 = tmp3_2 * s1_603_2;
    gl64_t kG603 = kD603 - kE603;
    tmp3_0 = (kC603 + kG603) - kF603;
    tmp3_1 = ((((kA603 + kC603) - kE603) - kE603) - kD603);
    tmp3_2 = kB603 - kG603;
    // Op 604: dim3x1 add
    gl64_t s1_604 = *(gl64_t*)&expressions_params[10][2];
    tmp3_0 = tmp3_0 + s1_604; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 605: dim3x3 mul
    gl64_t s1_605_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_605_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_605_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA605 = (tmp3_0 + tmp3_1) * (s1_605_0 + s1_605_1);
    gl64_t kB605 = (tmp3_0 + tmp3_2) * (s1_605_0 + s1_605_2);
    gl64_t kC605 = (tmp3_1 + tmp3_2) * (s1_605_1 + s1_605_2);
    gl64_t kD605 = tmp3_0 * s1_605_0;
    gl64_t kE605 = tmp3_1 * s1_605_1;
    gl64_t kF605 = tmp3_2 * s1_605_2;
    gl64_t kG605 = kD605 - kE605;
    tmp3_0 = (kC605 + kG605) - kF605;
    tmp3_1 = ((((kA605 + kC605) - kE605) - kE605) - kD605);
    tmp3_2 = kB605 - kG605;
    // Op 606: dim3x1 add
    gl64_t s1_606 = *(gl64_t*)&expressions_params[10][12];
    tmp3_0 = tmp3_0 + s1_606; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 607: dim3x3 mul
    gl64_t s1_607_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_607_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_607_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA607 = (tmp3_0 + tmp3_1) * (s1_607_0 + s1_607_1);
    gl64_t kB607 = (tmp3_0 + tmp3_2) * (s1_607_0 + s1_607_2);
    gl64_t kC607 = (tmp3_1 + tmp3_2) * (s1_607_1 + s1_607_2);
    gl64_t kD607 = tmp3_0 * s1_607_0;
    gl64_t kE607 = tmp3_1 * s1_607_1;
    gl64_t kF607 = tmp3_2 * s1_607_2;
    gl64_t kG607 = kD607 - kE607;
    tmp3_0 = (kC607 + kG607) - kF607;
    tmp3_1 = ((((kA607 + kC607) - kE607) - kE607) - kD607);
    tmp3_2 = kB607 - kG607;
    // Op 608: dim3x1 add
    gl64_t s1_608 = *(gl64_t*)&expressions_params[10][1];
    tmp3_0 = tmp3_0 + s1_608; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 609: dim3x3 mul
    gl64_t s1_609_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_609_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_609_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA609 = (tmp3_0 + tmp3_1) * (s1_609_0 + s1_609_1);
    gl64_t kB609 = (tmp3_0 + tmp3_2) * (s1_609_0 + s1_609_2);
    gl64_t kC609 = (tmp3_1 + tmp3_2) * (s1_609_1 + s1_609_2);
    gl64_t kD609 = tmp3_0 * s1_609_0;
    gl64_t kE609 = tmp3_1 * s1_609_1;
    gl64_t kF609 = tmp3_2 * s1_609_2;
    gl64_t kG609 = kD609 - kE609;
    tmp3_0 = (kC609 + kG609) - kF609;
    tmp3_1 = ((((kA609 + kC609) - kE609) - kE609) - kD609);
    tmp3_2 = kB609 - kG609;
    // Op 610: dim3x1 add
    gl64_t s1_610 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_610; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 611: dim3x3 mul
    gl64_t s1_611_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_611_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_611_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA611 = (tmp3_0 + tmp3_1) * (s1_611_0 + s1_611_1);
    gl64_t kB611 = (tmp3_0 + tmp3_2) * (s1_611_0 + s1_611_2);
    gl64_t kC611 = (tmp3_1 + tmp3_2) * (s1_611_1 + s1_611_2);
    gl64_t kD611 = tmp3_0 * s1_611_0;
    gl64_t kE611 = tmp3_1 * s1_611_1;
    gl64_t kF611 = tmp3_2 * s1_611_2;
    gl64_t kG611 = kD611 - kE611;
    tmp3_0 = (kC611 + kG611) - kF611;
    tmp3_1 = ((((kA611 + kC611) - kE611) - kE611) - kD611);
    tmp3_2 = kB611 - kG611;
    // Op 612: dim3x3 mul
    gl64_t s1_612_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_612_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_612_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA612 = (tmp3_0 + tmp3_1) * (s1_612_0 + s1_612_1);
    gl64_t kB612 = (tmp3_0 + tmp3_2) * (s1_612_0 + s1_612_2);
    gl64_t kC612 = (tmp3_1 + tmp3_2) * (s1_612_1 + s1_612_2);
    gl64_t kD612 = tmp3_0 * s1_612_0;
    gl64_t kE612 = tmp3_1 * s1_612_1;
    gl64_t kF612 = tmp3_2 * s1_612_2;
    gl64_t kG612 = kD612 - kE612;
    tmp3_0 = (kC612 + kG612) - kF612;
    tmp3_1 = ((((kA612 + kC612) - kE612) - kE612) - kD612);
    tmp3_2 = kB612 - kG612;
    // Op 613: dim3x1 add
    gl64_t s1_613 = *(gl64_t*)&expressions_params[10][0];
    tmp3_0 = tmp3_0 + s1_613; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 614: dim3x3 mul
    gl64_t s1_614_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_614_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_614_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA614 = (tmp3_0 + tmp3_1) * (s1_614_0 + s1_614_1);
    gl64_t kB614 = (tmp3_0 + tmp3_2) * (s1_614_0 + s1_614_2);
    gl64_t kC614 = (tmp3_1 + tmp3_2) * (s1_614_1 + s1_614_2);
    gl64_t kD614 = tmp3_0 * s1_614_0;
    gl64_t kE614 = tmp3_1 * s1_614_1;
    gl64_t kF614 = tmp3_2 * s1_614_2;
    gl64_t kG614 = kD614 - kE614;
    tmp3_0 = (kC614 + kG614) - kF614;
    tmp3_1 = ((((kA614 + kC614) - kE614) - kE614) - kD614);
    tmp3_2 = kB614 - kG614;
    // Op 615: dim3x1 add
    gl64_t s1_615 = *(gl64_t*)&expressions_params[9][13];
    tmp3_0 = tmp3_0 + s1_615; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 616: dim3x3 add
    gl64_t s1_616_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_616_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_616_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_616_0; tmp3_1 = tmp3_1 + s1_616_1; tmp3_2 = tmp3_2 + s1_616_2;
    // Op 617: dim3x3 mul
    gl64_t s1_617_0 = *(gl64_t*)&expressions_params[10][19];
    gl64_t s1_617_1 = *(gl64_t*)&expressions_params[10][19+1];
    gl64_t s1_617_2 = *(gl64_t*)&expressions_params[10][19+2];
    gl64_t kA617 = (tmp3_0 + tmp3_1) * (s1_617_0 + s1_617_1);
    gl64_t kB617 = (tmp3_0 + tmp3_2) * (s1_617_0 + s1_617_2);
    gl64_t kC617 = (tmp3_1 + tmp3_2) * (s1_617_1 + s1_617_2);
    gl64_t kD617 = tmp3_0 * s1_617_0;
    gl64_t kE617 = tmp3_1 * s1_617_1;
    gl64_t kF617 = tmp3_2 * s1_617_2;
    gl64_t kG617 = kD617 - kE617;
    tmp3_0 = (kC617 + kG617) - kF617;
    tmp3_1 = ((((kA617 + kC617) - kE617) - kE617) - kD617);
    tmp3_2 = kB617 - kG617;
    // Op 618: dim3x1 add
    gl64_t s1_618 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_618; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 619: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 620: dim3x3 mul
    gl64_t s1_620_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_620_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_620_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA620 = (tmp3_0 + tmp3_1) * (s1_620_0 + s1_620_1);
    gl64_t kB620 = (tmp3_0 + tmp3_2) * (s1_620_0 + s1_620_2);
    gl64_t kC620 = (tmp3_1 + tmp3_2) * (s1_620_1 + s1_620_2);
    gl64_t kD620 = tmp3_0 * s1_620_0;
    gl64_t kE620 = tmp3_1 * s1_620_1;
    gl64_t kF620 = tmp3_2 * s1_620_2;
    gl64_t kG620 = kD620 - kE620;
    tmp3_6 = (kC620 + kG620) - kF620;
    tmp3_7 = ((((kA620 + kC620) - kE620) - kE620) - kD620);
    tmp3_8 = kB620 - kG620;
    // Op 621: dim3x1 mul
    gl64_t s0_621_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_621_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_621_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_621 = *(gl64_t*)&expressions_params[10][10];
    tmp3_0 = s0_621_0 * s1_621; tmp3_1 = s0_621_1 * s1_621; tmp3_2 = s0_621_2 * s1_621;
    // Op 622: dim3x1 add
    gl64_t s1_622 = *(gl64_t*)&expressions_params[10][15];
    tmp3_0 = tmp3_0 + s1_622; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 623: dim3x3 mul
    gl64_t s1_623_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_623_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_623_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA623 = (tmp3_0 + tmp3_1) * (s1_623_0 + s1_623_1);
    gl64_t kB623 = (tmp3_0 + tmp3_2) * (s1_623_0 + s1_623_2);
    gl64_t kC623 = (tmp3_1 + tmp3_2) * (s1_623_1 + s1_623_2);
    gl64_t kD623 = tmp3_0 * s1_623_0;
    gl64_t kE623 = tmp3_1 * s1_623_1;
    gl64_t kF623 = tmp3_2 * s1_623_2;
    gl64_t kG623 = kD623 - kE623;
    tmp3_0 = (kC623 + kG623) - kF623;
    tmp3_1 = ((((kA623 + kC623) - kE623) - kE623) - kD623);
    tmp3_2 = kB623 - kG623;
    // Op 624: dim3x1 add
    gl64_t s1_624 = *(gl64_t*)&expressions_params[10][8];
    tmp3_0 = tmp3_0 + s1_624; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 625: dim3x3 mul
    gl64_t s1_625_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_625_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_625_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA625 = (tmp3_0 + tmp3_1) * (s1_625_0 + s1_625_1);
    gl64_t kB625 = (tmp3_0 + tmp3_2) * (s1_625_0 + s1_625_2);
    gl64_t kC625 = (tmp3_1 + tmp3_2) * (s1_625_1 + s1_625_2);
    gl64_t kD625 = tmp3_0 * s1_625_0;
    gl64_t kE625 = tmp3_1 * s1_625_1;
    gl64_t kF625 = tmp3_2 * s1_625_2;
    gl64_t kG625 = kD625 - kE625;
    tmp3_0 = (kC625 + kG625) - kF625;
    tmp3_1 = ((((kA625 + kC625) - kE625) - kE625) - kD625);
    tmp3_2 = kB625 - kG625;
    // Op 626: dim3x1 add
    gl64_t s1_626 = *(gl64_t*)&expressions_params[10][9];
    tmp3_0 = tmp3_0 + s1_626; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 627: dim3x3 mul
    gl64_t s1_627_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_627_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_627_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA627 = (tmp3_0 + tmp3_1) * (s1_627_0 + s1_627_1);
    gl64_t kB627 = (tmp3_0 + tmp3_2) * (s1_627_0 + s1_627_2);
    gl64_t kC627 = (tmp3_1 + tmp3_2) * (s1_627_1 + s1_627_2);
    gl64_t kD627 = tmp3_0 * s1_627_0;
    gl64_t kE627 = tmp3_1 * s1_627_1;
    gl64_t kF627 = tmp3_2 * s1_627_2;
    gl64_t kG627 = kD627 - kE627;
    tmp3_0 = (kC627 + kG627) - kF627;
    tmp3_1 = ((((kA627 + kC627) - kE627) - kE627) - kD627);
    tmp3_2 = kB627 - kG627;
    // Op 628: dim3x1 add
    gl64_t s1_628 = *(gl64_t*)&expressions_params[10][7];
    tmp3_0 = tmp3_0 + s1_628; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 629: dim3x3 mul
    gl64_t s1_629_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_629_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_629_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA629 = (tmp3_0 + tmp3_1) * (s1_629_0 + s1_629_1);
    gl64_t kB629 = (tmp3_0 + tmp3_2) * (s1_629_0 + s1_629_2);
    gl64_t kC629 = (tmp3_1 + tmp3_2) * (s1_629_1 + s1_629_2);
    gl64_t kD629 = tmp3_0 * s1_629_0;
    gl64_t kE629 = tmp3_1 * s1_629_1;
    gl64_t kF629 = tmp3_2 * s1_629_2;
    gl64_t kG629 = kD629 - kE629;
    tmp3_0 = (kC629 + kG629) - kF629;
    tmp3_1 = ((((kA629 + kC629) - kE629) - kE629) - kD629);
    tmp3_2 = kB629 - kG629;
    // Op 630: dim3x1 add
    gl64_t s1_630 = *(gl64_t*)&expressions_params[10][13];
    tmp3_0 = tmp3_0 + s1_630; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 631: dim3x3 mul
    gl64_t s1_631_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_631_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_631_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA631 = (tmp3_0 + tmp3_1) * (s1_631_0 + s1_631_1);
    gl64_t kB631 = (tmp3_0 + tmp3_2) * (s1_631_0 + s1_631_2);
    gl64_t kC631 = (tmp3_1 + tmp3_2) * (s1_631_1 + s1_631_2);
    gl64_t kD631 = tmp3_0 * s1_631_0;
    gl64_t kE631 = tmp3_1 * s1_631_1;
    gl64_t kF631 = tmp3_2 * s1_631_2;
    gl64_t kG631 = kD631 - kE631;
    tmp3_0 = (kC631 + kG631) - kF631;
    tmp3_1 = ((((kA631 + kC631) - kE631) - kE631) - kD631);
    tmp3_2 = kB631 - kG631;
    // Op 632: dim3x1 add
    gl64_t s1_632 = *(gl64_t*)&expressions_params[10][6];
    tmp3_0 = tmp3_0 + s1_632; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 633: dim3x3 mul
    gl64_t s1_633_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_633_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_633_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA633 = (tmp3_0 + tmp3_1) * (s1_633_0 + s1_633_1);
    gl64_t kB633 = (tmp3_0 + tmp3_2) * (s1_633_0 + s1_633_2);
    gl64_t kC633 = (tmp3_1 + tmp3_2) * (s1_633_1 + s1_633_2);
    gl64_t kD633 = tmp3_0 * s1_633_0;
    gl64_t kE633 = tmp3_1 * s1_633_1;
    gl64_t kF633 = tmp3_2 * s1_633_2;
    gl64_t kG633 = kD633 - kE633;
    tmp3_0 = (kC633 + kG633) - kF633;
    tmp3_1 = ((((kA633 + kC633) - kE633) - kE633) - kD633);
    tmp3_2 = kB633 - kG633;
    // Op 634: dim3x1 add
    gl64_t s1_634 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_634; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 635: dim3x3 mul
    gl64_t s1_635_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_635_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_635_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA635 = (tmp3_0 + tmp3_1) * (s1_635_0 + s1_635_1);
    gl64_t kB635 = (tmp3_0 + tmp3_2) * (s1_635_0 + s1_635_2);
    gl64_t kC635 = (tmp3_1 + tmp3_2) * (s1_635_1 + s1_635_2);
    gl64_t kD635 = tmp3_0 * s1_635_0;
    gl64_t kE635 = tmp3_1 * s1_635_1;
    gl64_t kF635 = tmp3_2 * s1_635_2;
    gl64_t kG635 = kD635 - kE635;
    tmp3_0 = (kC635 + kG635) - kF635;
    tmp3_1 = ((((kA635 + kC635) - kE635) - kE635) - kD635);
    tmp3_2 = kB635 - kG635;
    // Op 636: dim3x1 add
    gl64_t s1_636 = *(gl64_t*)&expressions_params[10][11];
    tmp3_0 = tmp3_0 + s1_636; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 637: dim3x3 mul
    gl64_t s1_637_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_637_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_637_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA637 = (tmp3_0 + tmp3_1) * (s1_637_0 + s1_637_1);
    gl64_t kB637 = (tmp3_0 + tmp3_2) * (s1_637_0 + s1_637_2);
    gl64_t kC637 = (tmp3_1 + tmp3_2) * (s1_637_1 + s1_637_2);
    gl64_t kD637 = tmp3_0 * s1_637_0;
    gl64_t kE637 = tmp3_1 * s1_637_1;
    gl64_t kF637 = tmp3_2 * s1_637_2;
    gl64_t kG637 = kD637 - kE637;
    tmp3_0 = (kC637 + kG637) - kF637;
    tmp3_1 = ((((kA637 + kC637) - kE637) - kE637) - kD637);
    tmp3_2 = kB637 - kG637;
    // Op 638: dim1x1 add
    gl64_t s0_638 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_638 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_638 + s1_638;
    // Op 639: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 640: dim3x3 mul
    gl64_t s1_640_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_640_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_640_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA640 = (tmp3_0 + tmp3_1) * (s1_640_0 + s1_640_1);
    gl64_t kB640 = (tmp3_0 + tmp3_2) * (s1_640_0 + s1_640_2);
    gl64_t kC640 = (tmp3_1 + tmp3_2) * (s1_640_1 + s1_640_2);
    gl64_t kD640 = tmp3_0 * s1_640_0;
    gl64_t kE640 = tmp3_1 * s1_640_1;
    gl64_t kF640 = tmp3_2 * s1_640_2;
    gl64_t kG640 = kD640 - kE640;
    tmp3_0 = (kC640 + kG640) - kF640;
    tmp3_1 = ((((kA640 + kC640) - kE640) - kE640) - kD640);
    tmp3_2 = kB640 - kG640;
    // Op 641: dim3x1 add
    gl64_t s1_641 = *(gl64_t*)&expressions_params[9][13];
    tmp3_0 = tmp3_0 + s1_641; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 642: dim3x3 add
    gl64_t s1_642_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_642_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_642_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_642_0; tmp3_1 = tmp3_1 + s1_642_1; tmp3_2 = tmp3_2 + s1_642_2;
    // Op 643: dim3x3 mul
    gl64_t s1_643_0 = *(gl64_t*)&expressions_params[10][22];
    gl64_t s1_643_1 = *(gl64_t*)&expressions_params[10][22+1];
    gl64_t s1_643_2 = *(gl64_t*)&expressions_params[10][22+2];
    gl64_t kA643 = (tmp3_0 + tmp3_1) * (s1_643_0 + s1_643_1);
    gl64_t kB643 = (tmp3_0 + tmp3_2) * (s1_643_0 + s1_643_2);
    gl64_t kC643 = (tmp3_1 + tmp3_2) * (s1_643_1 + s1_643_2);
    gl64_t kD643 = tmp3_0 * s1_643_0;
    gl64_t kE643 = tmp3_1 * s1_643_1;
    gl64_t kF643 = tmp3_2 * s1_643_2;
    gl64_t kG643 = kD643 - kE643;
    tmp3_0 = (kC643 + kG643) - kF643;
    tmp3_1 = ((((kA643 + kC643) - kE643) - kE643) - kD643);
    tmp3_2 = kB643 - kG643;
    // Op 644: dim1x1 sub
    gl64_t s0_644 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_644 = *(gl64_t*)&expressions_params[10][11];
    tmp1_0 = s0_644 - s1_644;
    // Op 645: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 646: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 647: dim3x3 mul
    gl64_t s1_647_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_647_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_647_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA647 = (tmp3_0 + tmp3_1) * (s1_647_0 + s1_647_1);
    gl64_t kB647 = (tmp3_0 + tmp3_2) * (s1_647_0 + s1_647_2);
    gl64_t kC647 = (tmp3_1 + tmp3_2) * (s1_647_1 + s1_647_2);
    gl64_t kD647 = tmp3_0 * s1_647_0;
    gl64_t kE647 = tmp3_1 * s1_647_1;
    gl64_t kF647 = tmp3_2 * s1_647_2;
    gl64_t kG647 = kD647 - kE647;
    tmp3_6 = (kC647 + kG647) - kF647;
    tmp3_7 = ((((kA647 + kC647) - kE647) - kE647) - kD647);
    tmp3_8 = kB647 - kG647;
    // Op 648: dim3x1 add
    gl64_t s0_648_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s0_648_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s0_648_2 = *(gl64_t*)&expressions_params[13][3+2];
    gl64_t s1_648 = *(gl64_t*)&expressions_params[9][12];
    tmp3_0 = s0_648_0 + s1_648; tmp3_1 = s0_648_1; tmp3_2 = s0_648_2;
    // Op 649: dim3x3 mul
    gl64_t s1_649_0 = *(gl64_t*)&expressions_params[10][25];
    gl64_t s1_649_1 = *(gl64_t*)&expressions_params[10][25+1];
    gl64_t s1_649_2 = *(gl64_t*)&expressions_params[10][25+2];
    gl64_t kA649 = (tmp3_0 + tmp3_1) * (s1_649_0 + s1_649_1);
    gl64_t kB649 = (tmp3_0 + tmp3_2) * (s1_649_0 + s1_649_2);
    gl64_t kC649 = (tmp3_1 + tmp3_2) * (s1_649_1 + s1_649_2);
    gl64_t kD649 = tmp3_0 * s1_649_0;
    gl64_t kE649 = tmp3_1 * s1_649_1;
    gl64_t kF649 = tmp3_2 * s1_649_2;
    gl64_t kG649 = kD649 - kE649;
    tmp3_0 = (kC649 + kG649) - kF649;
    tmp3_1 = ((((kA649 + kC649) - kE649) - kE649) - kD649);
    tmp3_2 = kB649 - kG649;
    // Op 650: dim1x1 sub
    gl64_t s0_650 = *(gl64_t*)&expressions_params[9][1];
    gl64_t s1_650 = *(gl64_t*)&expressions_params[10][18];
    tmp1_0 = s0_650 - s1_650;
    // Op 651: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 652: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 653: dim3x3 mul
    gl64_t s1_653_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_653_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_653_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA653 = (tmp3_0 + tmp3_1) * (s1_653_0 + s1_653_1);
    gl64_t kB653 = (tmp3_0 + tmp3_2) * (s1_653_0 + s1_653_2);
    gl64_t kC653 = (tmp3_1 + tmp3_2) * (s1_653_1 + s1_653_2);
    gl64_t kD653 = tmp3_0 * s1_653_0;
    gl64_t kE653 = tmp3_1 * s1_653_1;
    gl64_t kF653 = tmp3_2 * s1_653_2;
    gl64_t kG653 = kD653 - kE653;
    tmp3_6 = (kC653 + kG653) - kF653;
    tmp3_7 = ((((kA653 + kC653) - kE653) - kE653) - kD653);
    tmp3_8 = kB653 - kG653;
    // Op 654: dim3x1 mul
    gl64_t s0_654_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_654_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_654_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_654 = *(gl64_t*)&expressions_params[10][16];
    tmp3_0 = s0_654_0 * s1_654; tmp3_1 = s0_654_1 * s1_654; tmp3_2 = s0_654_2 * s1_654;
    // Op 655: dim3x1 add
    gl64_t s1_655 = *(gl64_t*)&expressions_params[9][14];
    tmp3_0 = tmp3_0 + s1_655; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 656: dim3x3 add
    gl64_t s1_656_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_656_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_656_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_656_0; tmp3_1 = tmp3_1 + s1_656_1; tmp3_2 = tmp3_2 + s1_656_2;
    // Op 657: dim3x3 mul
    gl64_t s1_657_0 = *(gl64_t*)&expressions_params[10][28];
    gl64_t s1_657_1 = *(gl64_t*)&expressions_params[10][28+1];
    gl64_t s1_657_2 = *(gl64_t*)&expressions_params[10][28+2];
    gl64_t kA657 = (tmp3_0 + tmp3_1) * (s1_657_0 + s1_657_1);
    gl64_t kB657 = (tmp3_0 + tmp3_2) * (s1_657_0 + s1_657_2);
    gl64_t kC657 = (tmp3_1 + tmp3_2) * (s1_657_1 + s1_657_2);
    gl64_t kD657 = tmp3_0 * s1_657_0;
    gl64_t kE657 = tmp3_1 * s1_657_1;
    gl64_t kF657 = tmp3_2 * s1_657_2;
    gl64_t kG657 = kD657 - kE657;
    tmp3_0 = (kC657 + kG657) - kF657;
    tmp3_1 = ((((kA657 + kC657) - kE657) - kE657) - kD657);
    tmp3_2 = kB657 - kG657;
    // Op 658: dim3x1 add
    gl64_t s1_658 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_658; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 659: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 660: dim3x3 mul
    gl64_t s1_660_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_660_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_660_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA660 = (tmp3_0 + tmp3_1) * (s1_660_0 + s1_660_1);
    gl64_t kB660 = (tmp3_0 + tmp3_2) * (s1_660_0 + s1_660_2);
    gl64_t kC660 = (tmp3_1 + tmp3_2) * (s1_660_1 + s1_660_2);
    gl64_t kD660 = tmp3_0 * s1_660_0;
    gl64_t kE660 = tmp3_1 * s1_660_1;
    gl64_t kF660 = tmp3_2 * s1_660_2;
    gl64_t kG660 = kD660 - kE660;
    tmp3_6 = (kC660 + kG660) - kF660;
    tmp3_7 = ((((kA660 + kC660) - kE660) - kE660) - kD660);
    tmp3_8 = kB660 - kG660;
    // Op 661: dim3x1 mul
    gl64_t s0_661_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_661_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_661_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_661 = *(gl64_t*)&expressions_params[10][17];
    tmp3_0 = s0_661_0 * s1_661; tmp3_1 = s0_661_1 * s1_661; tmp3_2 = s0_661_2 * s1_661;
    // Op 662: dim3x1 add
    gl64_t s1_662 = *(gl64_t*)&expressions_params[9][14];
    tmp3_0 = tmp3_0 + s1_662; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 663: dim3x3 add
    gl64_t s1_663_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_663_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_663_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_663_0; tmp3_1 = tmp3_1 + s1_663_1; tmp3_2 = tmp3_2 + s1_663_2;
    // Op 664: dim3x3 mul
    gl64_t s1_664_0 = *(gl64_t*)&expressions_params[10][31];
    gl64_t s1_664_1 = *(gl64_t*)&expressions_params[10][31+1];
    gl64_t s1_664_2 = *(gl64_t*)&expressions_params[10][31+2];
    gl64_t kA664 = (tmp3_0 + tmp3_1) * (s1_664_0 + s1_664_1);
    gl64_t kB664 = (tmp3_0 + tmp3_2) * (s1_664_0 + s1_664_2);
    gl64_t kC664 = (tmp3_1 + tmp3_2) * (s1_664_1 + s1_664_2);
    gl64_t kD664 = tmp3_0 * s1_664_0;
    gl64_t kE664 = tmp3_1 * s1_664_1;
    gl64_t kF664 = tmp3_2 * s1_664_2;
    gl64_t kG664 = kD664 - kE664;
    tmp3_0 = (kC664 + kG664) - kF664;
    tmp3_1 = ((((kA664 + kC664) - kE664) - kE664) - kD664);
    tmp3_2 = kB664 - kG664;
    // Op 665: dim3x1 add
    gl64_t s1_665 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_665; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 666: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 667: dim3x3 mul
    gl64_t s1_667_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_667_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_667_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA667 = (tmp3_0 + tmp3_1) * (s1_667_0 + s1_667_1);
    gl64_t kB667 = (tmp3_0 + tmp3_2) * (s1_667_0 + s1_667_2);
    gl64_t kC667 = (tmp3_1 + tmp3_2) * (s1_667_1 + s1_667_2);
    gl64_t kD667 = tmp3_0 * s1_667_0;
    gl64_t kE667 = tmp3_1 * s1_667_1;
    gl64_t kF667 = tmp3_2 * s1_667_2;
    gl64_t kG667 = kD667 - kE667;
    tmp3_3 = (kC667 + kG667) - kF667;
    tmp3_4 = ((((kA667 + kC667) - kE667) - kE667) - kD667);
    tmp3_5 = kB667 - kG667;
    // Op 668: dim3x3 sub_swap
    uint64_t s0_668_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_668_0 = *(gl64_t*)&dParams->aux_trace[s0_668_pos];
    gl64_t s0_668_1 = *(gl64_t*)&dParams->aux_trace[s0_668_pos + TILE_HEIGHT];
    gl64_t s0_668_2 = *(gl64_t*)&dParams->aux_trace[s0_668_pos + 2*TILE_HEIGHT];
    gl64_t s1_668_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_668_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_668_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_6 = s1_668_0 - s0_668_0; tmp3_7 = s1_668_1 - s0_668_1; tmp3_8 = s1_668_2 - s0_668_2;
    // Op 669: dim3x3 add
    gl64_t s0_669_0 = *(gl64_t*)&expressions_params[10][19];
    gl64_t s0_669_1 = *(gl64_t*)&expressions_params[10][19+1];
    gl64_t s0_669_2 = *(gl64_t*)&expressions_params[10][19+2];
    gl64_t s1_669_0 = *(gl64_t*)&expressions_params[10][22];
    gl64_t s1_669_1 = *(gl64_t*)&expressions_params[10][22+1];
    gl64_t s1_669_2 = *(gl64_t*)&expressions_params[10][22+2];
    tmp3_0 = s0_669_0 + s1_669_0; tmp3_1 = s0_669_1 + s1_669_1; tmp3_2 = s0_669_2 + s1_669_2;
    // Op 670: dim3x3 add
    gl64_t s1_670_0 = *(gl64_t*)&expressions_params[10][25];
    gl64_t s1_670_1 = *(gl64_t*)&expressions_params[10][25+1];
    gl64_t s1_670_2 = *(gl64_t*)&expressions_params[10][25+2];
    tmp3_0 = tmp3_0 + s1_670_0; tmp3_1 = tmp3_1 + s1_670_1; tmp3_2 = tmp3_2 + s1_670_2;
    // Op 671: dim3x3 add
    gl64_t s1_671_0 = *(gl64_t*)&expressions_params[10][28];
    gl64_t s1_671_1 = *(gl64_t*)&expressions_params[10][28+1];
    gl64_t s1_671_2 = *(gl64_t*)&expressions_params[10][28+2];
    tmp3_0 = tmp3_0 + s1_671_0; tmp3_1 = tmp3_1 + s1_671_1; tmp3_2 = tmp3_2 + s1_671_2;
    // Op 672: dim3x3 add
    gl64_t s1_672_0 = *(gl64_t*)&expressions_params[10][31];
    gl64_t s1_672_1 = *(gl64_t*)&expressions_params[10][31+1];
    gl64_t s1_672_2 = *(gl64_t*)&expressions_params[10][31+2];
    tmp3_0 = tmp3_0 + s1_672_0; tmp3_1 = tmp3_1 + s1_672_1; tmp3_2 = tmp3_2 + s1_672_2;
    // Op 673: dim3x3 sub
    tmp3_0 = tmp3_6 - tmp3_0; tmp3_1 = tmp3_7 - tmp3_1; tmp3_2 = tmp3_8 - tmp3_2;
    // Op 674: dim3x1 mul
    gl64_t s1_674 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_674; tmp3_1 = tmp3_1 * s1_674; tmp3_2 = tmp3_2 * s1_674;
    // Op 675: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 676: dim3x1 mul
    gl64_t s1_676 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_676; tmp3_1 = tmp3_1 * s1_676; tmp3_2 = tmp3_2 * s1_676;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
