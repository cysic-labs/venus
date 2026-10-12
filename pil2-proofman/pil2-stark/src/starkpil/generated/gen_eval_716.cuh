// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: ffbd2669  nOps=514 nTemp1=5 nTemp3=5
#define GENERATED_EVAL_NOPS_ffbd2669 514
#define GENERATED_EVAL_NTEMP1_ffbd2669 5
#define GENERATED_EVAL_NTEMP3_ffbd2669 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_ffbd2669(
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
    gl64_t s0_15 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_15 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_15 - s0_15;
    // Op 16: dim1x1 mul
    gl64_t s0_16 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
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
    gl64_t s0_19 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_1))];
    gl64_t s1_19 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s1_19 - s0_19;
    // Op 20: dim1x1 mul
    gl64_t s0_20 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_0 = s0_20 * tmp1_0;
    // Op 21: dim1x1 add
    gl64_t s0_21 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_1))];
    tmp1_0 = s0_21 + tmp1_0;
    // Op 22: dim1x1 sub
    gl64_t s0_22 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
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
    gl64_t s0_25 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_25 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_25 - s0_25;
    // Op 26: dim1x1 mul
    gl64_t s0_26 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
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
    gl64_t s0_29 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_29 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_29 - s0_29;
    // Op 30: dim1x1 mul
    gl64_t s0_30 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
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
    gl64_t s0_33 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_33 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_33 - s0_33;
    // Op 34: dim1x1 mul
    gl64_t s0_34 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
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
    gl64_t s0_37 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_37 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_37 - s0_37;
    // Op 38: dim1x1 mul
    gl64_t s0_38 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_38 * tmp1_0;
    // Op 39: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 41: dim1x1 sub_swap
    gl64_t s0_41 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_41 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_41 - s0_41;
    // Op 42: dim1x1 mul
    gl64_t s0_42 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_42 * tmp1_0;
    // Op 43: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 44: dim3x3 mul
    gl64_t s1_44_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_44_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_44_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA44 = (tmp3_0 + tmp3_1) * (s1_44_0 + s1_44_1);
    gl64_t kB44 = (tmp3_0 + tmp3_2) * (s1_44_0 + s1_44_2);
    gl64_t kC44 = (tmp3_1 + tmp3_2) * (s1_44_1 + s1_44_2);
    gl64_t kD44 = tmp3_0 * s1_44_0;
    gl64_t kE44 = tmp3_1 * s1_44_1;
    gl64_t kF44 = tmp3_2 * s1_44_2;
    gl64_t kG44 = kD44 - kE44;
    tmp3_0 = (kC44 + kG44) - kF44;
    tmp3_1 = ((((kA44 + kC44) - kE44) - kE44) - kD44);
    tmp3_2 = kB44 - kG44;
    // Op 45: dim1x1 sub_swap
    gl64_t s0_45 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_45 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_45 - s0_45;
    // Op 46: dim1x1 mul
    gl64_t s0_46 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_46 * tmp1_0;
    // Op 47: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 48: dim3x3 mul
    gl64_t s1_48_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_48_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_48_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA48 = (tmp3_0 + tmp3_1) * (s1_48_0 + s1_48_1);
    gl64_t kB48 = (tmp3_0 + tmp3_2) * (s1_48_0 + s1_48_2);
    gl64_t kC48 = (tmp3_1 + tmp3_2) * (s1_48_1 + s1_48_2);
    gl64_t kD48 = tmp3_0 * s1_48_0;
    gl64_t kE48 = tmp3_1 * s1_48_1;
    gl64_t kF48 = tmp3_2 * s1_48_2;
    gl64_t kG48 = kD48 - kE48;
    tmp3_0 = (kC48 + kG48) - kF48;
    tmp3_1 = ((((kA48 + kC48) - kE48) - kE48) - kD48);
    tmp3_2 = kB48 - kG48;
    // Op 49: dim1x1 sub_swap
    gl64_t s0_49 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_49 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_49 - s0_49;
    // Op 50: dim1x1 mul
    gl64_t s0_50 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_50 * tmp1_0;
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
    gl64_t s0_54 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
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
    // Op 57: dim1x1 sub
    gl64_t s0_57 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_57 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s0_57 - s1_57;
    // Op 58: dim1x1 mul
    gl64_t s0_58 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
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
    gl64_t s0_61 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_61 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_61 - s0_61;
    // Op 62: dim1x1 mul
    gl64_t s0_62 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_62 * tmp1_0;
    // Op 63: dim1x1 sub
    gl64_t s0_63 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_63 = *(gl64_t*)&expressions_params[10][7];
    tmp1_1 = s0_63 - s1_63;
    // Op 64: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
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
    gl64_t s0_67 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_67 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_67 - s0_67;
    // Op 68: dim1x1 mul
    gl64_t s0_68 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_68 * tmp1_0;
    // Op 69: dim1x1 sub
    gl64_t s0_69 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_69 = *(gl64_t*)&expressions_params[10][8];
    tmp1_1 = s0_69 - s1_69;
    // Op 70: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
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
    gl64_t s0_73 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_73 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_73 - s0_73;
    // Op 74: dim1x1 mul
    gl64_t s0_74 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_74 * tmp1_0;
    // Op 75: dim1x1 sub
    gl64_t s0_75 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_75 = *(gl64_t*)&expressions_params[10][9];
    tmp1_1 = s0_75 - s1_75;
    // Op 76: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
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
    gl64_t s0_79 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_79 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_79 - s0_79;
    // Op 80: dim1x1 mul
    gl64_t s0_80 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_80 * tmp1_0;
    // Op 81: dim1x1 mul
    gl64_t s0_81 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_81 = *(gl64_t*)&expressions_params[9][6];
    tmp1_2 = s0_81 * s1_81;
    // Op 82: dim1x1 sub
    gl64_t s1_82 = *(gl64_t*)&expressions_params[10][10];
    tmp1_1 = tmp1_2 - s1_82;
    // Op 83: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 84: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 85: dim3x3 mul
    gl64_t s1_85_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_85_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_85_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA85 = (tmp3_0 + tmp3_1) * (s1_85_0 + s1_85_1);
    gl64_t kB85 = (tmp3_0 + tmp3_2) * (s1_85_0 + s1_85_2);
    gl64_t kC85 = (tmp3_1 + tmp3_2) * (s1_85_1 + s1_85_2);
    gl64_t kD85 = tmp3_0 * s1_85_0;
    gl64_t kE85 = tmp3_1 * s1_85_1;
    gl64_t kF85 = tmp3_2 * s1_85_2;
    gl64_t kG85 = kD85 - kE85;
    tmp3_0 = (kC85 + kG85) - kF85;
    tmp3_1 = ((((kA85 + kC85) - kE85) - kE85) - kD85);
    tmp3_2 = kB85 - kG85;
    // Op 86: dim1x1 mul
    gl64_t s0_86 = *(gl64_t*)&expressions_params[10][7];
    gl64_t s1_86 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s0_86 * s1_86;
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
    // Op 89: dim1x1 mul
    gl64_t s0_89 = *(gl64_t*)&expressions_params[10][9];
    gl64_t s1_89 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s0_89 * s1_89;
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
    // Op 92: dim1x1 mul
    gl64_t s0_92 = *(gl64_t*)&expressions_params[10][8];
    gl64_t s1_92 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s0_92 * s1_92;
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
    // Op 95: dim1x1 mul
    gl64_t s0_95 = *(gl64_t*)&expressions_params[10][10];
    gl64_t s1_95 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s0_95 * s1_95;
    // Op 96: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 97: dim3x3 mul
    gl64_t s1_97_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_97_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_97_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 98: dim1x1 mul
    gl64_t s0_98 = *(gl64_t*)&expressions_params[10][2];
    gl64_t s1_98 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_98 * s1_98;
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
    // Op 101: dim1x1 mul
    gl64_t s0_101 = *(gl64_t*)&expressions_params[10][4];
    gl64_t s1_101 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_101 * s1_101;
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
    // Op 104: dim1x1 mul
    gl64_t s0_104 = *(gl64_t*)&expressions_params[10][3];
    gl64_t s1_104 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_104 * s1_104;
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
    // Op 107: dim1x1 mul
    gl64_t s0_107 = *(gl64_t*)&expressions_params[10][5];
    gl64_t s1_107 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_107 * s1_107;
    // Op 108: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 109: dim3x3 mul
    gl64_t s1_109_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_109_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_109_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA109 = (tmp3_0 + tmp3_1) * (s1_109_0 + s1_109_1);
    gl64_t kB109 = (tmp3_0 + tmp3_2) * (s1_109_0 + s1_109_2);
    gl64_t kC109 = (tmp3_1 + tmp3_2) * (s1_109_1 + s1_109_2);
    gl64_t kD109 = tmp3_0 * s1_109_0;
    gl64_t kE109 = tmp3_1 * s1_109_1;
    gl64_t kF109 = tmp3_2 * s1_109_2;
    gl64_t kG109 = kD109 - kE109;
    tmp3_0 = (kC109 + kG109) - kF109;
    tmp3_1 = ((((kA109 + kC109) - kE109) - kE109) - kD109);
    tmp3_2 = kB109 - kG109;
    // Op 110: dim1x1 sub
    gl64_t s0_110 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_110 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_110 - s1_110;
    // Op 111: dim1x1 mul
    gl64_t s0_111 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_3 = s0_111 * tmp1_0;
    // Op 112: dim1x1 sub_swap
    gl64_t s0_112 = *(gl64_t*)&expressions_params[9][6];
    gl64_t s1_112 = *(gl64_t*)&expressions_params[10][4];
    tmp1_0 = s1_112 - s0_112;
    // Op 113: dim1x1 sub
    gl64_t s0_113 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_113 - tmp1_0;
    // Op 114: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
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
    gl64_t s0_117 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_117 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_117 - s0_117;
    // Op 118: dim1x1 sub_swap
    gl64_t s0_118 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_1))];
    gl64_t s1_118 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s1_118 - s0_118;
    // Op 119: dim1x1 mul
    tmp1_4 = tmp1_0 * tmp1_1;
    // Op 120: dim1x1 sub
    gl64_t s0_120 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 5, domainSize, nCols_1))];
    gl64_t s1_120 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = s0_120 - s1_120;
    // Op 121: dim1x1 sub
    gl64_t s0_121 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_121 - tmp1_0;
    // Op 122: dim1x1 mul
    tmp1_0 = tmp1_4 * tmp1_0;
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
    // Op 125: dim1x1 add
    gl64_t s0_125 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_125 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_125 + s1_125;
    // Op 126: dim1x1 add
    gl64_t s0_126 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_126 + tmp1_0;
    // Op 127: dim1x1 add
    gl64_t s0_127 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_1 = s0_127 + tmp1_0;
    // Op 128: dim1x1 sub
    gl64_t s0_128 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_128 - tmp1_1;
    // Op 129: dim1x1 mul
    gl64_t s0_129 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_129 * tmp1_0;
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
    gl64_t s0_132 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_132 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_132 - s0_132;
    // Op 133: dim1x1 sub
    gl64_t s1_133 = *(gl64_t*)&expressions_params[9][6];
    tmp1_1 = tmp1_1 - s1_133;
    // Op 134: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
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
    // Op 137: dim1x1 add
    gl64_t s0_137 = *(gl64_t*)&expressions_params[9][6];
    gl64_t s1_137 = *(gl64_t*)&expressions_params[10][2];
    tmp1_0 = s0_137 + s1_137;
    // Op 138: dim1x1 sub
    gl64_t s0_138 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_138 - tmp1_0;
    // Op 139: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
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
    // Op 142: dim1x1 add
    gl64_t s0_142 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 4, domainSize, nCols_1))];
    gl64_t s1_142 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = s0_142 + s1_142;
    // Op 143: dim1x1 sub
    gl64_t s0_143 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_143 - tmp1_0;
    // Op 144: dim1x1 mul
    tmp1_0 = tmp1_4 * tmp1_0;
    // Op 145: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 146: dim3x3 mul
    gl64_t s1_146_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_146_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_146_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA146 = (tmp3_0 + tmp3_1) * (s1_146_0 + s1_146_1);
    gl64_t kB146 = (tmp3_0 + tmp3_2) * (s1_146_0 + s1_146_2);
    gl64_t kC146 = (tmp3_1 + tmp3_2) * (s1_146_1 + s1_146_2);
    gl64_t kD146 = tmp3_0 * s1_146_0;
    gl64_t kE146 = tmp3_1 * s1_146_1;
    gl64_t kF146 = tmp3_2 * s1_146_2;
    gl64_t kG146 = kD146 - kE146;
    tmp3_0 = (kC146 + kG146) - kF146;
    tmp3_1 = ((((kA146 + kC146) - kE146) - kE146) - kD146);
    tmp3_2 = kB146 - kG146;
    // Op 147: dim1x1 sub
    gl64_t s1_147 = *(gl64_t*)&expressions_params[10][5];
    tmp1_0 = tmp1_2 - s1_147;
    // Op 148: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
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
    // Op 151: dim1x1 mul
    gl64_t s0_151 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 2, domainSize, nCols_1))];
    gl64_t s1_151 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = s0_151 * s1_151;
    // Op 152: dim1x1 sub
    tmp1_0 = tmp1_2 - tmp1_0;
    // Op 153: dim1x1 mul
    tmp1_0 = tmp1_4 * tmp1_0;
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
    // Op 156: dim1x1 sub
    gl64_t s0_156 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_156 = *(gl64_t*)&expressions_params[10][3];
    tmp1_0 = s0_156 - s1_156;
    // Op 157: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
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
    // Op 160: dim1x1 sub
    gl64_t s0_160 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_160 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 3, domainSize, nCols_1))];
    tmp1_0 = s0_160 - s1_160;
    // Op 161: dim1x1 mul
    tmp1_0 = tmp1_4 * tmp1_0;
    // Op 162: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC163 + kG163) - kF163;
    tmp3_1 = ((((kA163 + kC163) - kE163) - kE163) - kD163);
    tmp3_2 = kB163 - kG163;
    // Op 164: dim1x1 mul
    gl64_t s0_164 = *(gl64_t*)&expressions_params[9][15];
    gl64_t s1_164 = *(gl64_t*)&expressions_params[10][13];
    tmp1_0 = s0_164 * s1_164;
    // Op 165: dim1x1 add
    gl64_t s1_165 = *(gl64_t*)&expressions_params[10][12];
    tmp1_0 = tmp1_0 + s1_165;
    // Op 166: dim1x1 sub
    gl64_t s1_166 = *(gl64_t*)&expressions_params[10][9];
    tmp1_0 = tmp1_0 - s1_166;
    // Op 167: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 168: dim3x3 mul
    gl64_t s1_168_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_168_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_168_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA168 = (tmp3_0 + tmp3_1) * (s1_168_0 + s1_168_1);
    gl64_t kB168 = (tmp3_0 + tmp3_2) * (s1_168_0 + s1_168_2);
    gl64_t kC168 = (tmp3_1 + tmp3_2) * (s1_168_1 + s1_168_2);
    gl64_t kD168 = tmp3_0 * s1_168_0;
    gl64_t kE168 = tmp3_1 * s1_168_1;
    gl64_t kF168 = tmp3_2 * s1_168_2;
    gl64_t kG168 = kD168 - kE168;
    tmp3_12 = (kC168 + kG168) - kF168;
    tmp3_13 = ((((kA168 + kC168) - kE168) - kE168) - kD168);
    tmp3_14 = kB168 - kG168;
    // Op 169: dim3x1 mul
    gl64_t s0_169_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_169_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_169_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_169 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp3_0 = s0_169_0 * s1_169; tmp3_1 = s0_169_1 * s1_169; tmp3_2 = s0_169_2 * s1_169;
    // Op 170: dim3x1 add
    gl64_t s1_170 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_170; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 171: dim3x3 add
    gl64_t s1_171_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_171_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_171_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_171_0; tmp3_4 = tmp3_10 + s1_171_1; tmp3_5 = tmp3_11 + s1_171_2;
    // Op 172: dim3x1 mul
    gl64_t s0_172_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_172_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_172_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_172 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp3_0 = s0_172_0 * s1_172; tmp3_1 = s0_172_1 * s1_172; tmp3_2 = s0_172_2 * s1_172;
    // Op 173: dim3x1 add
    gl64_t s1_173 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_173; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 174: dim3x3 mul
    gl64_t s1_174_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_174_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_174_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 175: dim3x1 add
    gl64_t s1_175 = *(gl64_t*)&expressions_params[9][2];
    tmp3_6 = tmp3_0 + s1_175; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 176: dim3x3 add
    gl64_t s1_176_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_176_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_176_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_176_0; tmp3_1 = tmp3_7 + s1_176_1; tmp3_2 = tmp3_8 + s1_176_2;
    // Op 177: dim3x3 mul
    gl64_t kA177 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB177 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC177 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD177 = tmp3_3 * tmp3_0;
    gl64_t kE177 = tmp3_4 * tmp3_1;
    gl64_t kF177 = tmp3_5 * tmp3_2;
    gl64_t kG177 = kD177 - kE177;
    tmp3_0 = (kC177 + kG177) - kF177;
    tmp3_1 = ((((kA177 + kC177) - kE177) - kE177) - kD177);
    tmp3_2 = kB177 - kG177;
    // Op 178: dim3x3 mul
    gl64_t s0_178_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_178_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_178_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA178 = (s0_178_0 + s0_178_1) * (tmp3_0 + tmp3_1);
    gl64_t kB178 = (s0_178_0 + s0_178_2) * (tmp3_0 + tmp3_2);
    gl64_t kC178 = (s0_178_1 + s0_178_2) * (tmp3_1 + tmp3_2);
    gl64_t kD178 = s0_178_0 * tmp3_0;
    gl64_t kE178 = s0_178_1 * tmp3_1;
    gl64_t kF178 = s0_178_2 * tmp3_2;
    gl64_t kG178 = kD178 - kE178;
    tmp3_0 = (kC178 + kG178) - kF178;
    tmp3_1 = ((((kA178 + kC178) - kE178) - kE178) - kD178);
    tmp3_2 = kB178 - kG178;
    // Op 179: dim1x1 sub_swap
    gl64_t s0_179 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_179 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_179 - s0_179;
    // Op 180: dim3x3 add
    gl64_t s1_180_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_180_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_180_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_180_0; tmp3_7 = tmp3_7 + s1_180_1; tmp3_8 = tmp3_8 + s1_180_2;
    // Op 181: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 182: dim1x1 sub_swap
    gl64_t s0_182 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_182 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_182 - s0_182;
    // Op 183: dim3x3 add
    gl64_t s1_183_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_183_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_183_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_183_0; tmp3_10 = tmp3_10 + s1_183_1; tmp3_11 = tmp3_11 + s1_183_2;
    // Op 184: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 185: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 186: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 187: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 188: dim3x3 mul
    gl64_t s1_188_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_188_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_188_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA188 = (tmp3_0 + tmp3_1) * (s1_188_0 + s1_188_1);
    gl64_t kB188 = (tmp3_0 + tmp3_2) * (s1_188_0 + s1_188_2);
    gl64_t kC188 = (tmp3_1 + tmp3_2) * (s1_188_1 + s1_188_2);
    gl64_t kD188 = tmp3_0 * s1_188_0;
    gl64_t kE188 = tmp3_1 * s1_188_1;
    gl64_t kF188 = tmp3_2 * s1_188_2;
    gl64_t kG188 = kD188 - kE188;
    tmp3_3 = (kC188 + kG188) - kF188;
    tmp3_4 = ((((kA188 + kC188) - kE188) - kE188) - kD188);
    tmp3_5 = kB188 - kG188;
    // Op 189: dim3x1 mul
    gl64_t s0_189_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_189_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_189_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_189 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp3_0 = s0_189_0 * s1_189; tmp3_1 = s0_189_1 * s1_189; tmp3_2 = s0_189_2 * s1_189;
    // Op 190: dim3x1 add
    gl64_t s1_190 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_190; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 191: dim3x3 add
    gl64_t s1_191_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_191_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_191_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_191_0; tmp3_13 = tmp3_10 + s1_191_1; tmp3_14 = tmp3_11 + s1_191_2;
    // Op 192: dim3x1 mul
    gl64_t s0_192_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_192_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_192_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_192 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp3_0 = s0_192_0 * s1_192; tmp3_1 = s0_192_1 * s1_192; tmp3_2 = s0_192_2 * s1_192;
    // Op 193: dim3x1 add
    gl64_t s1_193 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_0 + s1_193; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 194: dim3x3 add
    gl64_t s1_194_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_194_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_194_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_194_0; tmp3_1 = tmp3_7 + s1_194_1; tmp3_2 = tmp3_8 + s1_194_2;
    // Op 195: dim3x3 mul
    gl64_t kA195 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB195 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC195 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD195 = tmp3_12 * tmp3_0;
    gl64_t kE195 = tmp3_13 * tmp3_1;
    gl64_t kF195 = tmp3_14 * tmp3_2;
    gl64_t kG195 = kD195 - kE195;
    tmp3_0 = (kC195 + kG195) - kF195;
    tmp3_1 = ((((kA195 + kC195) - kE195) - kE195) - kD195);
    tmp3_2 = kB195 - kG195;
    // Op 196: dim3x3 mul
    gl64_t s0_196_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_196_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_196_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA196 = (s0_196_0 + s0_196_1) * (tmp3_0 + tmp3_1);
    gl64_t kB196 = (s0_196_0 + s0_196_2) * (tmp3_0 + tmp3_2);
    gl64_t kC196 = (s0_196_1 + s0_196_2) * (tmp3_1 + tmp3_2);
    gl64_t kD196 = s0_196_0 * tmp3_0;
    gl64_t kE196 = s0_196_1 * tmp3_1;
    gl64_t kF196 = s0_196_2 * tmp3_2;
    gl64_t kG196 = kD196 - kE196;
    tmp3_0 = (kC196 + kG196) - kF196;
    tmp3_1 = ((((kA196 + kC196) - kE196) - kE196) - kD196);
    tmp3_2 = kB196 - kG196;
    // Op 197: dim1x1 sub_swap
    gl64_t s0_197 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_197 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_197 - s0_197;
    // Op 198: dim3x3 add
    gl64_t s1_198_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_198_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_198_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_198_0; tmp3_7 = tmp3_7 + s1_198_1; tmp3_8 = tmp3_8 + s1_198_2;
    // Op 199: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 200: dim1x1 sub_swap
    gl64_t s0_200 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_200 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_200 - s0_200;
    // Op 201: dim3x3 add
    gl64_t s1_201_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_201_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_201_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_201_0; tmp3_10 = tmp3_10 + s1_201_1; tmp3_11 = tmp3_11 + s1_201_2;
    // Op 202: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 203: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 204: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 205: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
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
    gl64_t s1_207 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp3_0 = s0_207_0 * s1_207; tmp3_1 = s0_207_1 * s1_207; tmp3_2 = s0_207_2 * s1_207;
    // Op 208: dim3x1 add
    gl64_t s1_208 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_208; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 209: dim3x3 mul
    gl64_t s1_209_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_209_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_209_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 210: dim3x1 add
    gl64_t s1_210 = *(gl64_t*)&expressions_params[9][2];
    tmp3_9 = tmp3_0 + s1_210; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 211: dim3x3 add
    gl64_t s1_211_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_211_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_211_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_211_0; tmp3_4 = tmp3_10 + s1_211_1; tmp3_5 = tmp3_11 + s1_211_2;
    // Op 212: dim3x1 mul
    gl64_t s0_212_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_212_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_212_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_212 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp3_0 = s0_212_0 * s1_212; tmp3_1 = s0_212_1 * s1_212; tmp3_2 = s0_212_2 * s1_212;
    // Op 213: dim3x1 add
    gl64_t s1_213 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_0 + s1_213; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 214: dim3x3 add
    gl64_t s1_214_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_214_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_214_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_214_0; tmp3_1 = tmp3_7 + s1_214_1; tmp3_2 = tmp3_8 + s1_214_2;
    // Op 215: dim3x3 mul
    gl64_t kA215 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB215 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC215 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD215 = tmp3_3 * tmp3_0;
    gl64_t kE215 = tmp3_4 * tmp3_1;
    gl64_t kF215 = tmp3_5 * tmp3_2;
    gl64_t kG215 = kD215 - kE215;
    tmp3_0 = (kC215 + kG215) - kF215;
    tmp3_1 = ((((kA215 + kC215) - kE215) - kE215) - kD215);
    tmp3_2 = kB215 - kG215;
    // Op 216: dim3x3 mul
    uint64_t s0_216_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_216_0 = *(gl64_t*)&dParams->aux_trace[s0_216_pos];
    gl64_t s0_216_1 = *(gl64_t*)&dParams->aux_trace[s0_216_pos + TILE_HEIGHT];
    gl64_t s0_216_2 = *(gl64_t*)&dParams->aux_trace[s0_216_pos + 2*TILE_HEIGHT];
    gl64_t kA216 = (s0_216_0 + s0_216_1) * (tmp3_0 + tmp3_1);
    gl64_t kB216 = (s0_216_0 + s0_216_2) * (tmp3_0 + tmp3_2);
    gl64_t kC216 = (s0_216_1 + s0_216_2) * (tmp3_1 + tmp3_2);
    gl64_t kD216 = s0_216_0 * tmp3_0;
    gl64_t kE216 = s0_216_1 * tmp3_1;
    gl64_t kF216 = s0_216_2 * tmp3_2;
    gl64_t kG216 = kD216 - kE216;
    tmp3_0 = (kC216 + kG216) - kF216;
    tmp3_1 = ((((kA216 + kC216) - kE216) - kE216) - kD216);
    tmp3_2 = kB216 - kG216;
    // Op 217: dim1x1 sub_swap
    gl64_t s0_217 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_217 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_217 - s0_217;
    // Op 218: dim3x3 add
    gl64_t s1_218_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_218_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_218_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_218_0; tmp3_7 = tmp3_7 + s1_218_1; tmp3_8 = tmp3_8 + s1_218_2;
    // Op 219: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 220: dim1x1 sub_swap
    gl64_t s0_220 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_220 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_220 - s0_220;
    // Op 221: dim3x3 add
    gl64_t s1_221_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_221_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_221_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_221_0; tmp3_10 = tmp3_10 + s1_221_1; tmp3_11 = tmp3_11 + s1_221_2;
    // Op 222: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 223: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 224: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 225: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 226: dim3x3 mul
    gl64_t s1_226_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_226_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_226_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA226 = (tmp3_0 + tmp3_1) * (s1_226_0 + s1_226_1);
    gl64_t kB226 = (tmp3_0 + tmp3_2) * (s1_226_0 + s1_226_2);
    gl64_t kC226 = (tmp3_1 + tmp3_2) * (s1_226_1 + s1_226_2);
    gl64_t kD226 = tmp3_0 * s1_226_0;
    gl64_t kE226 = tmp3_1 * s1_226_1;
    gl64_t kF226 = tmp3_2 * s1_226_2;
    gl64_t kG226 = kD226 - kE226;
    tmp3_3 = (kC226 + kG226) - kF226;
    tmp3_4 = ((((kA226 + kC226) - kE226) - kE226) - kD226);
    tmp3_5 = kB226 - kG226;
    // Op 227: dim3x1 mul
    gl64_t s0_227_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_227_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_227_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_227 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp3_0 = s0_227_0 * s1_227; tmp3_1 = s0_227_1 * s1_227; tmp3_2 = s0_227_2 * s1_227;
    // Op 228: dim3x1 add
    gl64_t s1_228 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_228; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 229: dim3x3 add
    gl64_t s1_229_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_229_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_229_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_229_0; tmp3_13 = tmp3_10 + s1_229_1; tmp3_14 = tmp3_11 + s1_229_2;
    // Op 230: dim3x1 mul
    gl64_t s0_230_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_230_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_230_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_230 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp3_0 = s0_230_0 * s1_230; tmp3_1 = s0_230_1 * s1_230; tmp3_2 = s0_230_2 * s1_230;
    // Op 231: dim3x1 add
    gl64_t s1_231 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_231; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 232: dim3x3 mul
    gl64_t s1_232_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_232_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_232_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA232 = (tmp3_0 + tmp3_1) * (s1_232_0 + s1_232_1);
    gl64_t kB232 = (tmp3_0 + tmp3_2) * (s1_232_0 + s1_232_2);
    gl64_t kC232 = (tmp3_1 + tmp3_2) * (s1_232_1 + s1_232_2);
    gl64_t kD232 = tmp3_0 * s1_232_0;
    gl64_t kE232 = tmp3_1 * s1_232_1;
    gl64_t kF232 = tmp3_2 * s1_232_2;
    gl64_t kG232 = kD232 - kE232;
    tmp3_0 = (kC232 + kG232) - kF232;
    tmp3_1 = ((((kA232 + kC232) - kE232) - kE232) - kD232);
    tmp3_2 = kB232 - kG232;
    // Op 233: dim3x1 add
    gl64_t s1_233 = *(gl64_t*)&expressions_params[9][2];
    tmp3_6 = tmp3_0 + s1_233; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 234: dim3x3 add
    gl64_t s1_234_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_234_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_234_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_234_0; tmp3_1 = tmp3_7 + s1_234_1; tmp3_2 = tmp3_8 + s1_234_2;
    // Op 235: dim3x3 mul
    gl64_t kA235 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB235 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC235 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD235 = tmp3_12 * tmp3_0;
    gl64_t kE235 = tmp3_13 * tmp3_1;
    gl64_t kF235 = tmp3_14 * tmp3_2;
    gl64_t kG235 = kD235 - kE235;
    tmp3_0 = (kC235 + kG235) - kF235;
    tmp3_1 = ((((kA235 + kC235) - kE235) - kE235) - kD235);
    tmp3_2 = kB235 - kG235;
    // Op 236: dim3x3 mul
    uint64_t s0_236_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_236_0 = *(gl64_t*)&dParams->aux_trace[s0_236_pos];
    gl64_t s0_236_1 = *(gl64_t*)&dParams->aux_trace[s0_236_pos + TILE_HEIGHT];
    gl64_t s0_236_2 = *(gl64_t*)&dParams->aux_trace[s0_236_pos + 2*TILE_HEIGHT];
    gl64_t kA236 = (s0_236_0 + s0_236_1) * (tmp3_0 + tmp3_1);
    gl64_t kB236 = (s0_236_0 + s0_236_2) * (tmp3_0 + tmp3_2);
    gl64_t kC236 = (s0_236_1 + s0_236_2) * (tmp3_1 + tmp3_2);
    gl64_t kD236 = s0_236_0 * tmp3_0;
    gl64_t kE236 = s0_236_1 * tmp3_1;
    gl64_t kF236 = s0_236_2 * tmp3_2;
    gl64_t kG236 = kD236 - kE236;
    tmp3_0 = (kC236 + kG236) - kF236;
    tmp3_1 = ((((kA236 + kC236) - kE236) - kE236) - kD236);
    tmp3_2 = kB236 - kG236;
    // Op 237: dim1x1 sub_swap
    gl64_t s0_237 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_237 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_237 - s0_237;
    // Op 238: dim3x3 add
    gl64_t s1_238_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_238_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_238_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_238_0; tmp3_7 = tmp3_7 + s1_238_1; tmp3_8 = tmp3_8 + s1_238_2;
    // Op 239: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 240: dim1x1 sub_swap
    gl64_t s0_240 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_240 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_240 - s0_240;
    // Op 241: dim3x3 add
    gl64_t s1_241_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_241_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_241_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_241_0; tmp3_10 = tmp3_10 + s1_241_1; tmp3_11 = tmp3_11 + s1_241_2;
    // Op 242: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 243: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 244: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 245: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 246: dim3x3 mul
    gl64_t s1_246_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_246_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_246_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA246 = (tmp3_0 + tmp3_1) * (s1_246_0 + s1_246_1);
    gl64_t kB246 = (tmp3_0 + tmp3_2) * (s1_246_0 + s1_246_2);
    gl64_t kC246 = (tmp3_1 + tmp3_2) * (s1_246_1 + s1_246_2);
    gl64_t kD246 = tmp3_0 * s1_246_0;
    gl64_t kE246 = tmp3_1 * s1_246_1;
    gl64_t kF246 = tmp3_2 * s1_246_2;
    gl64_t kG246 = kD246 - kE246;
    tmp3_12 = (kC246 + kG246) - kF246;
    tmp3_13 = ((((kA246 + kC246) - kE246) - kE246) - kD246);
    tmp3_14 = kB246 - kG246;
    // Op 247: dim3x1 mul
    gl64_t s0_247_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_247_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_247_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_247 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp3_0 = s0_247_0 * s1_247; tmp3_1 = s0_247_1 * s1_247; tmp3_2 = s0_247_2 * s1_247;
    // Op 248: dim3x1 add
    gl64_t s1_248 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_248; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 249: dim3x3 add
    gl64_t s1_249_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_249_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_249_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_249_0; tmp3_4 = tmp3_10 + s1_249_1; tmp3_5 = tmp3_11 + s1_249_2;
    // Op 250: dim3x1 mul
    gl64_t s0_250_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_250_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_250_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_250 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp3_0 = s0_250_0 * s1_250; tmp3_1 = s0_250_1 * s1_250; tmp3_2 = s0_250_2 * s1_250;
    // Op 251: dim3x1 add
    gl64_t s1_251 = *(gl64_t*)&expressions_params[9][3];
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
    gl64_t s0_254_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_254_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_254_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
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
    gl64_t s0_255 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_255 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_255 - s0_255;
    // Op 256: dim3x3 add
    gl64_t s1_256_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_256_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_256_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_256_0; tmp3_7 = tmp3_7 + s1_256_1; tmp3_8 = tmp3_8 + s1_256_2;
    // Op 257: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 258: dim1x1 sub_swap
    gl64_t s0_258 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_258 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_258 - s0_258;
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
    gl64_t s1_265 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp3_0 = s0_265_0 * s1_265; tmp3_1 = s0_265_1 * s1_265; tmp3_2 = s0_265_2 * s1_265;
    // Op 266: dim3x1 add
    gl64_t s1_266 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
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
    gl64_t s1_268 = *(gl64_t*)&expressions_params[9][2];
    tmp3_9 = tmp3_0 + s1_268; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 269: dim3x3 add
    gl64_t s1_269_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_269_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_269_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_269_0; tmp3_13 = tmp3_10 + s1_269_1; tmp3_14 = tmp3_11 + s1_269_2;
    // Op 270: dim1x1 mul
    gl64_t s0_270 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    gl64_t s1_270 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s0_270 * s1_270;
    // Op 271: dim1x1 add
    gl64_t s0_271 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_271 + tmp1_0;
    // Op 272: dim3x1 mul
    gl64_t s0_272_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_272_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_272_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_272_0 * tmp1_0; tmp3_1 = s0_272_1 * tmp1_0; tmp3_2 = s0_272_2 * tmp1_0;
    // Op 273: dim1x1 mul
    gl64_t s0_273 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    gl64_t s1_273 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s0_273 * s1_273;
    // Op 274: dim1x1 add
    gl64_t s0_274 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_274 + tmp1_0;
    // Op 275: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 276: dim3x3 mul
    gl64_t s1_276_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_276_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_276_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA276 = (tmp3_0 + tmp3_1) * (s1_276_0 + s1_276_1);
    gl64_t kB276 = (tmp3_0 + tmp3_2) * (s1_276_0 + s1_276_2);
    gl64_t kC276 = (tmp3_1 + tmp3_2) * (s1_276_1 + s1_276_2);
    gl64_t kD276 = tmp3_0 * s1_276_0;
    gl64_t kE276 = tmp3_1 * s1_276_1;
    gl64_t kF276 = tmp3_2 * s1_276_2;
    gl64_t kG276 = kD276 - kE276;
    tmp3_0 = (kC276 + kG276) - kF276;
    tmp3_1 = ((((kA276 + kC276) - kE276) - kE276) - kD276);
    tmp3_2 = kB276 - kG276;
    // Op 277: dim3x1 add
    gl64_t s1_277 = *(gl64_t*)&expressions_params[9][5];
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
    // Op 279: dim1x1 mul
    gl64_t s0_279 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_279 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = s0_279 * s1_279;
    // Op 280: dim1x1 add
    gl64_t s1_280 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_280;
    // Op 281: dim1x1 add
    gl64_t s0_281 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_281 + tmp1_0;
    // Op 282: dim1x1 add
    gl64_t s1_282 = *(gl64_t*)&expressions_params[9][7];
    tmp1_0 = tmp1_0 + s1_282;
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
    gl64_t s0_285 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_285 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_285 * s1_285;
    // Op 286: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 287: dim3x3 mul
    gl64_t s1_287_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_287_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_287_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA287 = (tmp3_0 + tmp3_1) * (s1_287_0 + s1_287_1);
    gl64_t kB287 = (tmp3_0 + tmp3_2) * (s1_287_0 + s1_287_2);
    gl64_t kC287 = (tmp3_1 + tmp3_2) * (s1_287_1 + s1_287_2);
    gl64_t kD287 = tmp3_0 * s1_287_0;
    gl64_t kE287 = tmp3_1 * s1_287_1;
    gl64_t kF287 = tmp3_2 * s1_287_2;
    gl64_t kG287 = kD287 - kE287;
    tmp3_0 = (kC287 + kG287) - kF287;
    tmp3_1 = ((((kA287 + kC287) - kE287) - kE287) - kD287);
    tmp3_2 = kB287 - kG287;
    // Op 288: dim1x1 add
    gl64_t s0_288 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_288 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_288 + s1_288;
    // Op 289: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_291 = *(gl64_t*)&expressions_params[9][8];
    tmp3_6 = tmp3_0 + s1_291; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 292: dim3x3 add
    gl64_t s1_292_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_292_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_292_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_292_0; tmp3_1 = tmp3_7 + s1_292_1; tmp3_2 = tmp3_8 + s1_292_2;
    // Op 293: dim3x3 mul
    gl64_t kA293 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB293 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC293 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD293 = tmp3_12 * tmp3_0;
    gl64_t kE293 = tmp3_13 * tmp3_1;
    gl64_t kF293 = tmp3_14 * tmp3_2;
    gl64_t kG293 = kD293 - kE293;
    tmp3_0 = (kC293 + kG293) - kF293;
    tmp3_1 = ((((kA293 + kC293) - kE293) - kE293) - kD293);
    tmp3_2 = kB293 - kG293;
    // Op 294: dim3x3 mul
    gl64_t s0_294_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+0, domainSize, nCols_2))];
    gl64_t s0_294_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+1, domainSize, nCols_2))];
    gl64_t s0_294_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+2, domainSize, nCols_2))];
    gl64_t kA294 = (s0_294_0 + s0_294_1) * (tmp3_0 + tmp3_1);
    gl64_t kB294 = (s0_294_0 + s0_294_2) * (tmp3_0 + tmp3_2);
    gl64_t kC294 = (s0_294_1 + s0_294_2) * (tmp3_1 + tmp3_2);
    gl64_t kD294 = s0_294_0 * tmp3_0;
    gl64_t kE294 = s0_294_1 * tmp3_1;
    gl64_t kF294 = s0_294_2 * tmp3_2;
    gl64_t kG294 = kD294 - kE294;
    tmp3_0 = (kC294 + kG294) - kF294;
    tmp3_1 = ((((kA294 + kC294) - kE294) - kE294) - kD294);
    tmp3_2 = kB294 - kG294;
    // Op 295: dim1x1 sub_swap
    gl64_t s0_295 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_295 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_295 - s0_295;
    // Op 296: dim3x3 add
    gl64_t s1_296_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_296_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_296_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_296_0; tmp3_7 = tmp3_7 + s1_296_1; tmp3_8 = tmp3_8 + s1_296_2;
    // Op 297: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 298: dim1x1 sub_swap
    gl64_t s0_298 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_298 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_298 - s0_298;
    // Op 299: dim3x3 add
    gl64_t s1_299_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_299_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_299_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_299_0; tmp3_10 = tmp3_10 + s1_299_1; tmp3_11 = tmp3_11 + s1_299_2;
    // Op 300: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 301: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 302: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 303: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
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
    tmp3_12 = (kC304 + kG304) - kF304;
    tmp3_13 = ((((kA304 + kC304) - kE304) - kE304) - kD304);
    tmp3_14 = kB304 - kG304;
    // Op 305: dim1x1 mul
    gl64_t s0_305 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_305 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s0_305 * s1_305;
    // Op 306: dim1x1 add
    gl64_t s0_306 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_306 + tmp1_0;
    // Op 307: dim3x1 mul
    gl64_t s0_307_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_307_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_307_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_307_0 * tmp1_0; tmp3_1 = s0_307_1 * tmp1_0; tmp3_2 = s0_307_2 * tmp1_0;
    // Op 308: dim1x1 mul
    gl64_t s0_308 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_308 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s0_308 * s1_308;
    // Op 309: dim1x1 add
    gl64_t s0_309 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_0 = s0_309 + tmp1_0;
    // Op 310: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_312 = *(gl64_t*)&expressions_params[9][5];
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
    // Op 314: dim1x1 mul
    gl64_t s0_314 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_314 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = s0_314 * s1_314;
    // Op 315: dim1x1 add
    gl64_t s1_315 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_315;
    // Op 316: dim1x1 add
    gl64_t s0_316 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_316 + tmp1_0;
    // Op 317: dim1x1 add
    gl64_t s1_317 = *(gl64_t*)&expressions_params[9][7];
    tmp1_0 = tmp1_0 + s1_317;
    // Op 318: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 320: dim1x1 mul
    gl64_t s0_320 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_320 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_320 * s1_320;
    // Op 321: dim1x1 add
    gl64_t s1_321 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = tmp1_0 + s1_321;
    // Op 322: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 324: dim1x1 add
    gl64_t s0_324 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_324 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_324 + s1_324;
    // Op 325: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 327: dim3x1 add
    gl64_t s1_327 = *(gl64_t*)&expressions_params[9][8];
    tmp3_9 = tmp3_0 + s1_327; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 328: dim3x3 add
    gl64_t s1_328_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_328_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_328_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_328_0; tmp3_4 = tmp3_10 + s1_328_1; tmp3_5 = tmp3_11 + s1_328_2;
    // Op 329: dim1x1 mul
    gl64_t s0_329 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_329 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s0_329 * s1_329;
    // Op 330: dim1x1 add
    gl64_t s0_330 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_330 + tmp1_0;
    // Op 331: dim3x1 mul
    gl64_t s0_331_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_331_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_331_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_331_0 * tmp1_0; tmp3_1 = s0_331_1 * tmp1_0; tmp3_2 = s0_331_2 * tmp1_0;
    // Op 332: dim1x1 mul
    gl64_t s0_332 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    gl64_t s1_332 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s0_332 * s1_332;
    // Op 333: dim1x1 add
    gl64_t s0_333 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_333 + tmp1_0;
    // Op 334: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_336 = *(gl64_t*)&expressions_params[9][5];
    tmp3_0 = tmp3_0 + s1_336; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s0_338 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_338 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = s0_338 * s1_338;
    // Op 339: dim1x1 add
    gl64_t s1_339 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_339;
    // Op 340: dim1x1 add
    gl64_t s0_340 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_340 + tmp1_0;
    // Op 341: dim1x1 add
    gl64_t s1_341 = *(gl64_t*)&expressions_params[9][7];
    tmp1_0 = tmp1_0 + s1_341;
    // Op 342: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s0_344 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_344 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_344 * s1_344;
    // Op 345: dim1x1 add
    gl64_t s1_345 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = tmp1_0 + s1_345;
    // Op 346: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 347: dim3x3 mul
    gl64_t s1_347_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_347_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_347_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA347 = (tmp3_0 + tmp3_1) * (s1_347_0 + s1_347_1);
    gl64_t kB347 = (tmp3_0 + tmp3_2) * (s1_347_0 + s1_347_2);
    gl64_t kC347 = (tmp3_1 + tmp3_2) * (s1_347_1 + s1_347_2);
    gl64_t kD347 = tmp3_0 * s1_347_0;
    gl64_t kE347 = tmp3_1 * s1_347_1;
    gl64_t kF347 = tmp3_2 * s1_347_2;
    gl64_t kG347 = kD347 - kE347;
    tmp3_0 = (kC347 + kG347) - kF347;
    tmp3_1 = ((((kA347 + kC347) - kE347) - kE347) - kD347);
    tmp3_2 = kB347 - kG347;
    // Op 348: dim1x1 add
    gl64_t s0_348 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_348 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_348 + s1_348;
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
    // Op 351: dim3x1 add
    gl64_t s1_351 = *(gl64_t*)&expressions_params[9][8];
    tmp3_6 = tmp3_0 + s1_351; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 352: dim3x3 add
    gl64_t s1_352_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_352_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_352_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_352_0; tmp3_1 = tmp3_7 + s1_352_1; tmp3_2 = tmp3_8 + s1_352_2;
    // Op 353: dim3x3 mul
    gl64_t kA353 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB353 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC353 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD353 = tmp3_3 * tmp3_0;
    gl64_t kE353 = tmp3_4 * tmp3_1;
    gl64_t kF353 = tmp3_5 * tmp3_2;
    gl64_t kG353 = kD353 - kE353;
    tmp3_0 = (kC353 + kG353) - kF353;
    tmp3_1 = ((((kA353 + kC353) - kE353) - kE353) - kD353);
    tmp3_2 = kB353 - kG353;
    // Op 354: dim3x3 mul
    uint64_t s0_354_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_2));
    gl64_t s0_354_0 = *(gl64_t*)&dParams->aux_trace[s0_354_pos];
    gl64_t s0_354_1 = *(gl64_t*)&dParams->aux_trace[s0_354_pos + TILE_HEIGHT];
    gl64_t s0_354_2 = *(gl64_t*)&dParams->aux_trace[s0_354_pos + 2*TILE_HEIGHT];
    gl64_t kA354 = (s0_354_0 + s0_354_1) * (tmp3_0 + tmp3_1);
    gl64_t kB354 = (s0_354_0 + s0_354_2) * (tmp3_0 + tmp3_2);
    gl64_t kC354 = (s0_354_1 + s0_354_2) * (tmp3_1 + tmp3_2);
    gl64_t kD354 = s0_354_0 * tmp3_0;
    gl64_t kE354 = s0_354_1 * tmp3_1;
    gl64_t kF354 = s0_354_2 * tmp3_2;
    gl64_t kG354 = kD354 - kE354;
    tmp3_0 = (kC354 + kG354) - kF354;
    tmp3_1 = ((((kA354 + kC354) - kE354) - kE354) - kD354);
    tmp3_2 = kB354 - kG354;
    // Op 355: dim1x1 sub_swap
    gl64_t s0_355 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_355 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_355 - s0_355;
    // Op 356: dim3x3 add
    gl64_t s1_356_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_356_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_356_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_356_0; tmp3_7 = tmp3_7 + s1_356_1; tmp3_8 = tmp3_8 + s1_356_2;
    // Op 357: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 358: dim1x1 sub_swap
    gl64_t s0_358 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_358 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_358 - s0_358;
    // Op 359: dim3x3 add
    gl64_t s1_359_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_359_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_359_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_359_0; tmp3_10 = tmp3_10 + s1_359_1; tmp3_11 = tmp3_11 + s1_359_2;
    // Op 360: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 361: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 362: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 363: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 364: dim3x3 mul
    gl64_t s1_364_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_364_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_364_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA364 = (tmp3_0 + tmp3_1) * (s1_364_0 + s1_364_1);
    gl64_t kB364 = (tmp3_0 + tmp3_2) * (s1_364_0 + s1_364_2);
    gl64_t kC364 = (tmp3_1 + tmp3_2) * (s1_364_1 + s1_364_2);
    gl64_t kD364 = tmp3_0 * s1_364_0;
    gl64_t kE364 = tmp3_1 * s1_364_1;
    gl64_t kF364 = tmp3_2 * s1_364_2;
    gl64_t kG364 = kD364 - kE364;
    tmp3_3 = (kC364 + kG364) - kF364;
    tmp3_4 = ((((kA364 + kC364) - kE364) - kE364) - kD364);
    tmp3_5 = kB364 - kG364;
    // Op 365: dim1x1 mul
    gl64_t s0_365 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_365 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s0_365 * s1_365;
    // Op 366: dim1x1 add
    gl64_t s0_366 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp1_0 = s0_366 + tmp1_0;
    // Op 367: dim3x1 mul
    gl64_t s0_367_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_367_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_367_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_367_0 * tmp1_0; tmp3_1 = s0_367_1 * tmp1_0; tmp3_2 = s0_367_2 * tmp1_0;
    // Op 368: dim1x1 mul
    gl64_t s0_368 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_368 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s0_368 * s1_368;
    // Op 369: dim1x1 add
    gl64_t s0_369 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_0 = s0_369 + tmp1_0;
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
    // Op 372: dim3x1 add
    gl64_t s1_372 = *(gl64_t*)&expressions_params[9][5];
    tmp3_0 = tmp3_0 + s1_372; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 373: dim3x3 mul
    gl64_t s1_373_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_373_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_373_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA373 = (tmp3_0 + tmp3_1) * (s1_373_0 + s1_373_1);
    gl64_t kB373 = (tmp3_0 + tmp3_2) * (s1_373_0 + s1_373_2);
    gl64_t kC373 = (tmp3_1 + tmp3_2) * (s1_373_1 + s1_373_2);
    gl64_t kD373 = tmp3_0 * s1_373_0;
    gl64_t kE373 = tmp3_1 * s1_373_1;
    gl64_t kF373 = tmp3_2 * s1_373_2;
    gl64_t kG373 = kD373 - kE373;
    tmp3_0 = (kC373 + kG373) - kF373;
    tmp3_1 = ((((kA373 + kC373) - kE373) - kE373) - kD373);
    tmp3_2 = kB373 - kG373;
    // Op 374: dim1x1 mul
    gl64_t s0_374 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_374 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = s0_374 * s1_374;
    // Op 375: dim1x1 add
    gl64_t s1_375 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_375;
    // Op 376: dim1x1 add
    gl64_t s0_376 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_376 + tmp1_0;
    // Op 377: dim1x1 add
    gl64_t s1_377 = *(gl64_t*)&expressions_params[9][7];
    tmp1_0 = tmp1_0 + s1_377;
    // Op 378: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 379: dim3x3 mul
    gl64_t s1_379_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_379_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_379_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA379 = (tmp3_0 + tmp3_1) * (s1_379_0 + s1_379_1);
    gl64_t kB379 = (tmp3_0 + tmp3_2) * (s1_379_0 + s1_379_2);
    gl64_t kC379 = (tmp3_1 + tmp3_2) * (s1_379_1 + s1_379_2);
    gl64_t kD379 = tmp3_0 * s1_379_0;
    gl64_t kE379 = tmp3_1 * s1_379_1;
    gl64_t kF379 = tmp3_2 * s1_379_2;
    gl64_t kG379 = kD379 - kE379;
    tmp3_0 = (kC379 + kG379) - kF379;
    tmp3_1 = ((((kA379 + kC379) - kE379) - kE379) - kD379);
    tmp3_2 = kB379 - kG379;
    // Op 380: dim1x1 mul
    gl64_t s0_380 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_380 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_380 * s1_380;
    // Op 381: dim1x1 add
    gl64_t s1_381 = *(gl64_t*)&expressions_params[9][12];
    tmp1_0 = tmp1_0 + s1_381;
    // Op 382: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 383: dim3x3 mul
    gl64_t s1_383_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_383_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_383_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA383 = (tmp3_0 + tmp3_1) * (s1_383_0 + s1_383_1);
    gl64_t kB383 = (tmp3_0 + tmp3_2) * (s1_383_0 + s1_383_2);
    gl64_t kC383 = (tmp3_1 + tmp3_2) * (s1_383_1 + s1_383_2);
    gl64_t kD383 = tmp3_0 * s1_383_0;
    gl64_t kE383 = tmp3_1 * s1_383_1;
    gl64_t kF383 = tmp3_2 * s1_383_2;
    gl64_t kG383 = kD383 - kE383;
    tmp3_0 = (kC383 + kG383) - kF383;
    tmp3_1 = ((((kA383 + kC383) - kE383) - kE383) - kD383);
    tmp3_2 = kB383 - kG383;
    // Op 384: dim1x1 add
    gl64_t s0_384 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_384 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_384 + s1_384;
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
    // Op 387: dim3x1 add
    gl64_t s1_387 = *(gl64_t*)&expressions_params[9][8];
    tmp3_9 = tmp3_0 + s1_387; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 388: dim3x3 add
    gl64_t s1_388_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_388_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_388_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_388_0; tmp3_13 = tmp3_10 + s1_388_1; tmp3_14 = tmp3_11 + s1_388_2;
    // Op 389: dim3x1 mul
    gl64_t s0_389_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_389_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_389_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_389 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp3_0 = s0_389_0 * s1_389; tmp3_1 = s0_389_1 * s1_389; tmp3_2 = s0_389_2 * s1_389;
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
    // Op 392: dim1x1 mul
    gl64_t s0_392 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_392 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_392 * s1_392;
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
    // Op 395: dim3x3 mul
    gl64_t s1_395_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_395_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_395_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA395 = (tmp3_0 + tmp3_1) * (s1_395_0 + s1_395_1);
    gl64_t kB395 = (tmp3_0 + tmp3_2) * (s1_395_0 + s1_395_2);
    gl64_t kC395 = (tmp3_1 + tmp3_2) * (s1_395_1 + s1_395_2);
    gl64_t kD395 = tmp3_0 * s1_395_0;
    gl64_t kE395 = tmp3_1 * s1_395_1;
    gl64_t kF395 = tmp3_2 * s1_395_2;
    gl64_t kG395 = kD395 - kE395;
    tmp3_0 = (kC395 + kG395) - kF395;
    tmp3_1 = ((((kA395 + kC395) - kE395) - kE395) - kD395);
    tmp3_2 = kB395 - kG395;
    // Op 396: dim1x1 mul
    gl64_t s0_396 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_396 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_396 * s1_396;
    // Op 397: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 398: dim3x3 mul
    gl64_t s1_398_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_398_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_398_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA398 = (tmp3_0 + tmp3_1) * (s1_398_0 + s1_398_1);
    gl64_t kB398 = (tmp3_0 + tmp3_2) * (s1_398_0 + s1_398_2);
    gl64_t kC398 = (tmp3_1 + tmp3_2) * (s1_398_1 + s1_398_2);
    gl64_t kD398 = tmp3_0 * s1_398_0;
    gl64_t kE398 = tmp3_1 * s1_398_1;
    gl64_t kF398 = tmp3_2 * s1_398_2;
    gl64_t kG398 = kD398 - kE398;
    tmp3_0 = (kC398 + kG398) - kF398;
    tmp3_1 = ((((kA398 + kC398) - kE398) - kE398) - kD398);
    tmp3_2 = kB398 - kG398;
    // Op 399: dim3x3 mul
    gl64_t s1_399_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_399_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_399_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA399 = (tmp3_0 + tmp3_1) * (s1_399_0 + s1_399_1);
    gl64_t kB399 = (tmp3_0 + tmp3_2) * (s1_399_0 + s1_399_2);
    gl64_t kC399 = (tmp3_1 + tmp3_2) * (s1_399_1 + s1_399_2);
    gl64_t kD399 = tmp3_0 * s1_399_0;
    gl64_t kE399 = tmp3_1 * s1_399_1;
    gl64_t kF399 = tmp3_2 * s1_399_2;
    gl64_t kG399 = kD399 - kE399;
    tmp3_0 = (kC399 + kG399) - kF399;
    tmp3_1 = ((((kA399 + kC399) - kE399) - kE399) - kD399);
    tmp3_2 = kB399 - kG399;
    // Op 400: dim1x1 mul
    gl64_t s0_400 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_400 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_400 * s1_400;
    // Op 401: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 402: dim3x3 mul
    gl64_t s1_402_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_402_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_402_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA402 = (tmp3_0 + tmp3_1) * (s1_402_0 + s1_402_1);
    gl64_t kB402 = (tmp3_0 + tmp3_2) * (s1_402_0 + s1_402_2);
    gl64_t kC402 = (tmp3_1 + tmp3_2) * (s1_402_1 + s1_402_2);
    gl64_t kD402 = tmp3_0 * s1_402_0;
    gl64_t kE402 = tmp3_1 * s1_402_1;
    gl64_t kF402 = tmp3_2 * s1_402_2;
    gl64_t kG402 = kD402 - kE402;
    tmp3_0 = (kC402 + kG402) - kF402;
    tmp3_1 = ((((kA402 + kC402) - kE402) - kE402) - kD402);
    tmp3_2 = kB402 - kG402;
    // Op 403: dim1x1 mul
    gl64_t s0_403 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_403 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_403 * s1_403;
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
    // Op 406: dim3x1 add
    gl64_t s1_406 = *(gl64_t*)&expressions_params[9][11];
    tmp3_6 = tmp3_0 + s1_406; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 407: dim3x3 add
    gl64_t s1_407_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_407_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_407_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_407_0; tmp3_1 = tmp3_7 + s1_407_1; tmp3_2 = tmp3_8 + s1_407_2;
    // Op 408: dim3x3 mul
    gl64_t kA408 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB408 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC408 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD408 = tmp3_12 * tmp3_0;
    gl64_t kE408 = tmp3_13 * tmp3_1;
    gl64_t kF408 = tmp3_14 * tmp3_2;
    gl64_t kG408 = kD408 - kE408;
    tmp3_0 = (kC408 + kG408) - kF408;
    tmp3_1 = ((((kA408 + kC408) - kE408) - kE408) - kD408);
    tmp3_2 = kB408 - kG408;
    // Op 409: dim3x3 mul
    uint64_t s0_409_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_2));
    gl64_t s0_409_0 = *(gl64_t*)&dParams->aux_trace[s0_409_pos];
    gl64_t s0_409_1 = *(gl64_t*)&dParams->aux_trace[s0_409_pos + TILE_HEIGHT];
    gl64_t s0_409_2 = *(gl64_t*)&dParams->aux_trace[s0_409_pos + 2*TILE_HEIGHT];
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
    gl64_t s0_410 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_410 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_410 - s0_410;
    // Op 411: dim3x3 add
    gl64_t s1_411_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_411_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_411_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_411_0; tmp3_7 = tmp3_7 + s1_411_1; tmp3_8 = tmp3_8 + s1_411_2;
    // Op 412: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 413: dim3x3 add
    gl64_t s1_413_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_413_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_413_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_413_0; tmp3_10 = tmp3_10 + s1_413_1; tmp3_11 = tmp3_11 + s1_413_2;
    // Op 414: dim3x1 mul
    gl64_t s1_414 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_414; tmp3_10 = tmp3_10 * s1_414; tmp3_11 = tmp3_11 * s1_414;
    // Op 415: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 416: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 417: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 418: dim3x3 mul
    gl64_t s1_418_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_418_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_418_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA418 = (tmp3_0 + tmp3_1) * (s1_418_0 + s1_418_1);
    gl64_t kB418 = (tmp3_0 + tmp3_2) * (s1_418_0 + s1_418_2);
    gl64_t kC418 = (tmp3_1 + tmp3_2) * (s1_418_1 + s1_418_2);
    gl64_t kD418 = tmp3_0 * s1_418_0;
    gl64_t kE418 = tmp3_1 * s1_418_1;
    gl64_t kF418 = tmp3_2 * s1_418_2;
    gl64_t kG418 = kD418 - kE418;
    tmp3_6 = (kC418 + kG418) - kF418;
    tmp3_7 = ((((kA418 + kC418) - kE418) - kE418) - kD418);
    tmp3_8 = kB418 - kG418;
    // Op 419: dim1x1 sub_swap
    gl64_t s0_419 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_419 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_419 - s0_419;
    // Op 420: dim3x1 mul
    uint64_t s0_420_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_420_0 = *(gl64_t*)&dParams->aux_trace[s0_420_pos];
    gl64_t s0_420_1 = *(gl64_t*)&dParams->aux_trace[s0_420_pos + TILE_HEIGHT];
    gl64_t s0_420_2 = *(gl64_t*)&dParams->aux_trace[s0_420_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_420_0 * tmp1_0; tmp3_1 = s0_420_1 * tmp1_0; tmp3_2 = s0_420_2 * tmp1_0;
    // Op 421: dim3x3 sub
    uint64_t s0_421_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_421_0 = *(gl64_t*)&dParams->aux_trace[s0_421_pos];
    gl64_t s0_421_1 = *(gl64_t*)&dParams->aux_trace[s0_421_pos + TILE_HEIGHT];
    gl64_t s0_421_2 = *(gl64_t*)&dParams->aux_trace[s0_421_pos + 2*TILE_HEIGHT];
    tmp3_3 = s0_421_0 - tmp3_0; tmp3_4 = s0_421_1 - tmp3_1; tmp3_5 = s0_421_2 - tmp3_2;
    // Op 422: dim3x3 add
    gl64_t s0_422_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_422_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_422_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_422_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_422_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_422_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_0 = s0_422_0 + s1_422_0; tmp3_1 = s0_422_1 + s1_422_1; tmp3_2 = s0_422_2 + s1_422_2;
    // Op 423: dim3x3 add
    uint64_t s0_423_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_423_0 = *(gl64_t*)&dParams->aux_trace[s0_423_pos];
    gl64_t s0_423_1 = *(gl64_t*)&dParams->aux_trace[s0_423_pos + TILE_HEIGHT];
    gl64_t s0_423_2 = *(gl64_t*)&dParams->aux_trace[s0_423_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_423_0 + tmp3_0; tmp3_1 = s0_423_1 + tmp3_1; tmp3_2 = s0_423_2 + tmp3_2;
    // Op 424: dim3x3 add
    uint64_t s0_424_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_424_0 = *(gl64_t*)&dParams->aux_trace[s0_424_pos];
    gl64_t s0_424_1 = *(gl64_t*)&dParams->aux_trace[s0_424_pos + TILE_HEIGHT];
    gl64_t s0_424_2 = *(gl64_t*)&dParams->aux_trace[s0_424_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_424_0 + tmp3_0; tmp3_1 = s0_424_1 + tmp3_1; tmp3_2 = s0_424_2 + tmp3_2;
    // Op 425: dim3x3 add
    gl64_t s0_425_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_425_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_425_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    tmp3_0 = s0_425_0 + tmp3_0; tmp3_1 = s0_425_1 + tmp3_1; tmp3_2 = s0_425_2 + tmp3_2;
    // Op 426: dim3x3 add
    gl64_t s0_426_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+0, domainSize, nCols_2))];
    gl64_t s0_426_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+1, domainSize, nCols_2))];
    gl64_t s0_426_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+2, domainSize, nCols_2))];
    tmp3_0 = s0_426_0 + tmp3_0; tmp3_1 = s0_426_1 + tmp3_1; tmp3_2 = s0_426_2 + tmp3_2;
    // Op 427: dim3x3 add
    uint64_t s0_427_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_2));
    gl64_t s0_427_0 = *(gl64_t*)&dParams->aux_trace[s0_427_pos];
    gl64_t s0_427_1 = *(gl64_t*)&dParams->aux_trace[s0_427_pos + TILE_HEIGHT];
    gl64_t s0_427_2 = *(gl64_t*)&dParams->aux_trace[s0_427_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_427_0 + tmp3_0; tmp3_1 = s0_427_1 + tmp3_1; tmp3_2 = s0_427_2 + tmp3_2;
    // Op 428: dim3x3 add
    uint64_t s0_428_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_2));
    gl64_t s0_428_0 = *(gl64_t*)&dParams->aux_trace[s0_428_pos];
    gl64_t s0_428_1 = *(gl64_t*)&dParams->aux_trace[s0_428_pos + TILE_HEIGHT];
    gl64_t s0_428_2 = *(gl64_t*)&dParams->aux_trace[s0_428_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_428_0 + tmp3_0; tmp3_1 = s0_428_1 + tmp3_1; tmp3_2 = s0_428_2 + tmp3_2;
    // Op 429: dim3x3 sub
    tmp3_3 = tmp3_3 - tmp3_0; tmp3_4 = tmp3_4 - tmp3_1; tmp3_5 = tmp3_5 - tmp3_2;
    // Op 430: dim3x1 mul
    gl64_t s0_430_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_430_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_430_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_430 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp3_0 = s0_430_0 * s1_430; tmp3_1 = s0_430_1 * s1_430; tmp3_2 = s0_430_2 * s1_430;
    // Op 431: dim3x1 add
    gl64_t s1_431 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_431; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 432: dim3x3 add
    gl64_t s1_432_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_432_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_432_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_432_0; tmp3_1 = tmp3_1 + s1_432_1; tmp3_2 = tmp3_2 + s1_432_2;
    // Op 433: dim3x3 mul
    gl64_t kA433 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB433 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC433 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD433 = tmp3_3 * tmp3_0;
    gl64_t kE433 = tmp3_4 * tmp3_1;
    gl64_t kF433 = tmp3_5 * tmp3_2;
    gl64_t kG433 = kD433 - kE433;
    tmp3_0 = (kC433 + kG433) - kF433;
    tmp3_1 = ((((kA433 + kC433) - kE433) - kE433) - kD433);
    tmp3_2 = kB433 - kG433;
    // Op 434: dim1x1 sub_swap
    gl64_t s0_434 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_434 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_434 - s0_434;
    // Op 435: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 436: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 437: dim3x3 mul
    gl64_t s1_437_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_437_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_437_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA437 = (tmp3_0 + tmp3_1) * (s1_437_0 + s1_437_1);
    gl64_t kB437 = (tmp3_0 + tmp3_2) * (s1_437_0 + s1_437_2);
    gl64_t kC437 = (tmp3_1 + tmp3_2) * (s1_437_1 + s1_437_2);
    gl64_t kD437 = tmp3_0 * s1_437_0;
    gl64_t kE437 = tmp3_1 * s1_437_1;
    gl64_t kF437 = tmp3_2 * s1_437_2;
    gl64_t kG437 = kD437 - kE437;
    tmp3_6 = (kC437 + kG437) - kF437;
    tmp3_7 = ((((kA437 + kC437) - kE437) - kE437) - kD437);
    tmp3_8 = kB437 - kG437;
    // Op 438: dim3x1 mul
    gl64_t s0_438_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_438_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_438_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_438 = *(gl64_t*)&expressions_params[10][5];
    tmp3_0 = s0_438_0 * s1_438; tmp3_1 = s0_438_1 * s1_438; tmp3_2 = s0_438_2 * s1_438;
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
    gl64_t s1_440 = *(gl64_t*)&expressions_params[10][3];
    tmp3_0 = tmp3_0 + s1_440; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 442: dim3x1 add
    gl64_t s1_442 = *(gl64_t*)&expressions_params[10][4];
    tmp3_0 = tmp3_0 + s1_442; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 443: dim3x3 mul
    gl64_t s1_443_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_443_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_443_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA443 = (tmp3_0 + tmp3_1) * (s1_443_0 + s1_443_1);
    gl64_t kB443 = (tmp3_0 + tmp3_2) * (s1_443_0 + s1_443_2);
    gl64_t kC443 = (tmp3_1 + tmp3_2) * (s1_443_1 + s1_443_2);
    gl64_t kD443 = tmp3_0 * s1_443_0;
    gl64_t kE443 = tmp3_1 * s1_443_1;
    gl64_t kF443 = tmp3_2 * s1_443_2;
    gl64_t kG443 = kD443 - kE443;
    tmp3_0 = (kC443 + kG443) - kF443;
    tmp3_1 = ((((kA443 + kC443) - kE443) - kE443) - kD443);
    tmp3_2 = kB443 - kG443;
    // Op 444: dim3x1 add
    gl64_t s1_444 = *(gl64_t*)&expressions_params[10][2];
    tmp3_0 = tmp3_0 + s1_444; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 447: dim3x1 add
    gl64_t s1_447 = *(gl64_t*)&expressions_params[10][1];
    tmp3_0 = tmp3_0 + s1_447; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 448: dim3x3 mul
    gl64_t s1_448_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_448_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_448_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA448 = (tmp3_0 + tmp3_1) * (s1_448_0 + s1_448_1);
    gl64_t kB448 = (tmp3_0 + tmp3_2) * (s1_448_0 + s1_448_2);
    gl64_t kC448 = (tmp3_1 + tmp3_2) * (s1_448_1 + s1_448_2);
    gl64_t kD448 = tmp3_0 * s1_448_0;
    gl64_t kE448 = tmp3_1 * s1_448_1;
    gl64_t kF448 = tmp3_2 * s1_448_2;
    gl64_t kG448 = kD448 - kE448;
    tmp3_0 = (kC448 + kG448) - kF448;
    tmp3_1 = ((((kA448 + kC448) - kE448) - kE448) - kD448);
    tmp3_2 = kB448 - kG448;
    // Op 449: dim3x1 add
    gl64_t s1_449 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_449; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 450: dim3x3 mul
    gl64_t s1_450_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_450_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_450_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA450 = (tmp3_0 + tmp3_1) * (s1_450_0 + s1_450_1);
    gl64_t kB450 = (tmp3_0 + tmp3_2) * (s1_450_0 + s1_450_2);
    gl64_t kC450 = (tmp3_1 + tmp3_2) * (s1_450_1 + s1_450_2);
    gl64_t kD450 = tmp3_0 * s1_450_0;
    gl64_t kE450 = tmp3_1 * s1_450_1;
    gl64_t kF450 = tmp3_2 * s1_450_2;
    gl64_t kG450 = kD450 - kE450;
    tmp3_0 = (kC450 + kG450) - kF450;
    tmp3_1 = ((((kA450 + kC450) - kE450) - kE450) - kD450);
    tmp3_2 = kB450 - kG450;
    // Op 451: dim3x3 mul
    gl64_t s1_451_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_451_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_451_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA451 = (tmp3_0 + tmp3_1) * (s1_451_0 + s1_451_1);
    gl64_t kB451 = (tmp3_0 + tmp3_2) * (s1_451_0 + s1_451_2);
    gl64_t kC451 = (tmp3_1 + tmp3_2) * (s1_451_1 + s1_451_2);
    gl64_t kD451 = tmp3_0 * s1_451_0;
    gl64_t kE451 = tmp3_1 * s1_451_1;
    gl64_t kF451 = tmp3_2 * s1_451_2;
    gl64_t kG451 = kD451 - kE451;
    tmp3_0 = (kC451 + kG451) - kF451;
    tmp3_1 = ((((kA451 + kC451) - kE451) - kE451) - kD451);
    tmp3_2 = kB451 - kG451;
    // Op 452: dim3x1 add
    gl64_t s1_452 = *(gl64_t*)&expressions_params[10][0];
    tmp3_0 = tmp3_0 + s1_452; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_454 = *(gl64_t*)&expressions_params[9][13];
    tmp3_0 = tmp3_0 + s1_454; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 455: dim3x3 add
    gl64_t s1_455_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_455_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_455_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_455_0; tmp3_1 = tmp3_1 + s1_455_1; tmp3_2 = tmp3_2 + s1_455_2;
    // Op 456: dim3x3 mul
    gl64_t s1_456_0 = *(gl64_t*)&expressions_params[10][15];
    gl64_t s1_456_1 = *(gl64_t*)&expressions_params[10][15+1];
    gl64_t s1_456_2 = *(gl64_t*)&expressions_params[10][15+2];
    gl64_t kA456 = (tmp3_0 + tmp3_1) * (s1_456_0 + s1_456_1);
    gl64_t kB456 = (tmp3_0 + tmp3_2) * (s1_456_0 + s1_456_2);
    gl64_t kC456 = (tmp3_1 + tmp3_2) * (s1_456_1 + s1_456_2);
    gl64_t kD456 = tmp3_0 * s1_456_0;
    gl64_t kE456 = tmp3_1 * s1_456_1;
    gl64_t kF456 = tmp3_2 * s1_456_2;
    gl64_t kG456 = kD456 - kE456;
    tmp3_0 = (kC456 + kG456) - kF456;
    tmp3_1 = ((((kA456 + kC456) - kE456) - kE456) - kD456);
    tmp3_2 = kB456 - kG456;
    // Op 457: dim3x1 add
    gl64_t s1_457 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_457; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 458: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 459: dim3x3 mul
    gl64_t s1_459_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_459_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_459_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA459 = (tmp3_0 + tmp3_1) * (s1_459_0 + s1_459_1);
    gl64_t kB459 = (tmp3_0 + tmp3_2) * (s1_459_0 + s1_459_2);
    gl64_t kC459 = (tmp3_1 + tmp3_2) * (s1_459_1 + s1_459_2);
    gl64_t kD459 = tmp3_0 * s1_459_0;
    gl64_t kE459 = tmp3_1 * s1_459_1;
    gl64_t kF459 = tmp3_2 * s1_459_2;
    gl64_t kG459 = kD459 - kE459;
    tmp3_6 = (kC459 + kG459) - kF459;
    tmp3_7 = ((((kA459 + kC459) - kE459) - kE459) - kD459);
    tmp3_8 = kB459 - kG459;
    // Op 460: dim3x1 mul
    gl64_t s0_460_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_460_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_460_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_460 = *(gl64_t*)&expressions_params[10][10];
    tmp3_0 = s0_460_0 * s1_460; tmp3_1 = s0_460_1 * s1_460; tmp3_2 = s0_460_2 * s1_460;
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
    gl64_t s1_462 = *(gl64_t*)&expressions_params[10][8];
    tmp3_0 = tmp3_0 + s1_462; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 463: dim3x3 mul
    gl64_t s1_463_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_463_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_463_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA463 = (tmp3_0 + tmp3_1) * (s1_463_0 + s1_463_1);
    gl64_t kB463 = (tmp3_0 + tmp3_2) * (s1_463_0 + s1_463_2);
    gl64_t kC463 = (tmp3_1 + tmp3_2) * (s1_463_1 + s1_463_2);
    gl64_t kD463 = tmp3_0 * s1_463_0;
    gl64_t kE463 = tmp3_1 * s1_463_1;
    gl64_t kF463 = tmp3_2 * s1_463_2;
    gl64_t kG463 = kD463 - kE463;
    tmp3_0 = (kC463 + kG463) - kF463;
    tmp3_1 = ((((kA463 + kC463) - kE463) - kE463) - kD463);
    tmp3_2 = kB463 - kG463;
    // Op 464: dim3x1 add
    gl64_t s1_464 = *(gl64_t*)&expressions_params[10][9];
    tmp3_0 = tmp3_0 + s1_464; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 465: dim3x3 mul
    gl64_t s1_465_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_465_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_465_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA465 = (tmp3_0 + tmp3_1) * (s1_465_0 + s1_465_1);
    gl64_t kB465 = (tmp3_0 + tmp3_2) * (s1_465_0 + s1_465_2);
    gl64_t kC465 = (tmp3_1 + tmp3_2) * (s1_465_1 + s1_465_2);
    gl64_t kD465 = tmp3_0 * s1_465_0;
    gl64_t kE465 = tmp3_1 * s1_465_1;
    gl64_t kF465 = tmp3_2 * s1_465_2;
    gl64_t kG465 = kD465 - kE465;
    tmp3_0 = (kC465 + kG465) - kF465;
    tmp3_1 = ((((kA465 + kC465) - kE465) - kE465) - kD465);
    tmp3_2 = kB465 - kG465;
    // Op 466: dim3x1 add
    gl64_t s1_466 = *(gl64_t*)&expressions_params[10][7];
    tmp3_0 = tmp3_0 + s1_466; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 467: dim3x3 mul
    gl64_t s1_467_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_467_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_467_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA467 = (tmp3_0 + tmp3_1) * (s1_467_0 + s1_467_1);
    gl64_t kB467 = (tmp3_0 + tmp3_2) * (s1_467_0 + s1_467_2);
    gl64_t kC467 = (tmp3_1 + tmp3_2) * (s1_467_1 + s1_467_2);
    gl64_t kD467 = tmp3_0 * s1_467_0;
    gl64_t kE467 = tmp3_1 * s1_467_1;
    gl64_t kF467 = tmp3_2 * s1_467_2;
    gl64_t kG467 = kD467 - kE467;
    tmp3_0 = (kC467 + kG467) - kF467;
    tmp3_1 = ((((kA467 + kC467) - kE467) - kE467) - kD467);
    tmp3_2 = kB467 - kG467;
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
    gl64_t s1_469 = *(gl64_t*)&expressions_params[10][6];
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
    gl64_t s1_471 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_471; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 473: dim3x1 add
    gl64_t s1_473 = *(gl64_t*)&expressions_params[10][11];
    tmp3_0 = tmp3_0 + s1_473; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 474: dim3x3 mul
    gl64_t s1_474_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_474_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_474_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA474 = (tmp3_0 + tmp3_1) * (s1_474_0 + s1_474_1);
    gl64_t kB474 = (tmp3_0 + tmp3_2) * (s1_474_0 + s1_474_2);
    gl64_t kC474 = (tmp3_1 + tmp3_2) * (s1_474_1 + s1_474_2);
    gl64_t kD474 = tmp3_0 * s1_474_0;
    gl64_t kE474 = tmp3_1 * s1_474_1;
    gl64_t kF474 = tmp3_2 * s1_474_2;
    gl64_t kG474 = kD474 - kE474;
    tmp3_0 = (kC474 + kG474) - kF474;
    tmp3_1 = ((((kA474 + kC474) - kE474) - kE474) - kD474);
    tmp3_2 = kB474 - kG474;
    // Op 475: dim1x1 add
    gl64_t s0_475 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_475 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_475 + s1_475;
    // Op 476: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 477: dim3x3 mul
    gl64_t s1_477_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_477_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_477_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA477 = (tmp3_0 + tmp3_1) * (s1_477_0 + s1_477_1);
    gl64_t kB477 = (tmp3_0 + tmp3_2) * (s1_477_0 + s1_477_2);
    gl64_t kC477 = (tmp3_1 + tmp3_2) * (s1_477_1 + s1_477_2);
    gl64_t kD477 = tmp3_0 * s1_477_0;
    gl64_t kE477 = tmp3_1 * s1_477_1;
    gl64_t kF477 = tmp3_2 * s1_477_2;
    gl64_t kG477 = kD477 - kE477;
    tmp3_0 = (kC477 + kG477) - kF477;
    tmp3_1 = ((((kA477 + kC477) - kE477) - kE477) - kD477);
    tmp3_2 = kB477 - kG477;
    // Op 478: dim3x1 add
    gl64_t s1_478 = *(gl64_t*)&expressions_params[9][13];
    tmp3_0 = tmp3_0 + s1_478; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 479: dim3x3 add
    gl64_t s1_479_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_479_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_479_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_479_0; tmp3_1 = tmp3_1 + s1_479_1; tmp3_2 = tmp3_2 + s1_479_2;
    // Op 480: dim3x3 mul
    gl64_t s1_480_0 = *(gl64_t*)&expressions_params[10][18];
    gl64_t s1_480_1 = *(gl64_t*)&expressions_params[10][18+1];
    gl64_t s1_480_2 = *(gl64_t*)&expressions_params[10][18+2];
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
    // Op 481: dim1x1 sub
    gl64_t s0_481 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_481 = *(gl64_t*)&expressions_params[10][11];
    tmp1_0 = s0_481 - s1_481;
    // Op 482: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 483: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 484: dim3x3 mul
    gl64_t s1_484_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_484_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_484_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA484 = (tmp3_0 + tmp3_1) * (s1_484_0 + s1_484_1);
    gl64_t kB484 = (tmp3_0 + tmp3_2) * (s1_484_0 + s1_484_2);
    gl64_t kC484 = (tmp3_1 + tmp3_2) * (s1_484_1 + s1_484_2);
    gl64_t kD484 = tmp3_0 * s1_484_0;
    gl64_t kE484 = tmp3_1 * s1_484_1;
    gl64_t kF484 = tmp3_2 * s1_484_2;
    gl64_t kG484 = kD484 - kE484;
    tmp3_6 = (kC484 + kG484) - kF484;
    tmp3_7 = ((((kA484 + kC484) - kE484) - kE484) - kD484);
    tmp3_8 = kB484 - kG484;
    // Op 485: dim3x1 add
    gl64_t s0_485_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s0_485_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s0_485_2 = *(gl64_t*)&expressions_params[13][3+2];
    gl64_t s1_485 = *(gl64_t*)&expressions_params[9][11];
    tmp3_0 = s0_485_0 + s1_485; tmp3_1 = s0_485_1; tmp3_2 = s0_485_2;
    // Op 486: dim3x3 mul
    gl64_t s1_486_0 = *(gl64_t*)&expressions_params[10][21];
    gl64_t s1_486_1 = *(gl64_t*)&expressions_params[10][21+1];
    gl64_t s1_486_2 = *(gl64_t*)&expressions_params[10][21+2];
    gl64_t kA486 = (tmp3_0 + tmp3_1) * (s1_486_0 + s1_486_1);
    gl64_t kB486 = (tmp3_0 + tmp3_2) * (s1_486_0 + s1_486_2);
    gl64_t kC486 = (tmp3_1 + tmp3_2) * (s1_486_1 + s1_486_2);
    gl64_t kD486 = tmp3_0 * s1_486_0;
    gl64_t kE486 = tmp3_1 * s1_486_1;
    gl64_t kF486 = tmp3_2 * s1_486_2;
    gl64_t kG486 = kD486 - kE486;
    tmp3_0 = (kC486 + kG486) - kF486;
    tmp3_1 = ((((kA486 + kC486) - kE486) - kE486) - kD486);
    tmp3_2 = kB486 - kG486;
    // Op 487: dim1x1 sub
    gl64_t s0_487 = *(gl64_t*)&expressions_params[9][1];
    gl64_t s1_487 = *(gl64_t*)&expressions_params[10][14];
    tmp1_0 = s0_487 - s1_487;
    // Op 488: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 489: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 490: dim3x3 mul
    gl64_t s1_490_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_490_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_490_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA490 = (tmp3_0 + tmp3_1) * (s1_490_0 + s1_490_1);
    gl64_t kB490 = (tmp3_0 + tmp3_2) * (s1_490_0 + s1_490_2);
    gl64_t kC490 = (tmp3_1 + tmp3_2) * (s1_490_1 + s1_490_2);
    gl64_t kD490 = tmp3_0 * s1_490_0;
    gl64_t kE490 = tmp3_1 * s1_490_1;
    gl64_t kF490 = tmp3_2 * s1_490_2;
    gl64_t kG490 = kD490 - kE490;
    tmp3_6 = (kC490 + kG490) - kF490;
    tmp3_7 = ((((kA490 + kC490) - kE490) - kE490) - kD490);
    tmp3_8 = kB490 - kG490;
    // Op 491: dim3x1 mul
    gl64_t s0_491_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_491_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_491_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_491 = *(gl64_t*)&expressions_params[10][12];
    tmp3_0 = s0_491_0 * s1_491; tmp3_1 = s0_491_1 * s1_491; tmp3_2 = s0_491_2 * s1_491;
    // Op 492: dim3x1 add
    gl64_t s1_492 = *(gl64_t*)&expressions_params[9][14];
    tmp3_0 = tmp3_0 + s1_492; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 493: dim3x3 add
    gl64_t s1_493_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_493_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_493_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_493_0; tmp3_1 = tmp3_1 + s1_493_1; tmp3_2 = tmp3_2 + s1_493_2;
    // Op 494: dim3x3 mul
    gl64_t s1_494_0 = *(gl64_t*)&expressions_params[10][24];
    gl64_t s1_494_1 = *(gl64_t*)&expressions_params[10][24+1];
    gl64_t s1_494_2 = *(gl64_t*)&expressions_params[10][24+2];
    gl64_t kA494 = (tmp3_0 + tmp3_1) * (s1_494_0 + s1_494_1);
    gl64_t kB494 = (tmp3_0 + tmp3_2) * (s1_494_0 + s1_494_2);
    gl64_t kC494 = (tmp3_1 + tmp3_2) * (s1_494_1 + s1_494_2);
    gl64_t kD494 = tmp3_0 * s1_494_0;
    gl64_t kE494 = tmp3_1 * s1_494_1;
    gl64_t kF494 = tmp3_2 * s1_494_2;
    gl64_t kG494 = kD494 - kE494;
    tmp3_0 = (kC494 + kG494) - kF494;
    tmp3_1 = ((((kA494 + kC494) - kE494) - kE494) - kD494);
    tmp3_2 = kB494 - kG494;
    // Op 495: dim3x1 add
    gl64_t s1_495 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_495; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 496: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 497: dim3x3 mul
    gl64_t s1_497_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_497_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_497_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA497 = (tmp3_0 + tmp3_1) * (s1_497_0 + s1_497_1);
    gl64_t kB497 = (tmp3_0 + tmp3_2) * (s1_497_0 + s1_497_2);
    gl64_t kC497 = (tmp3_1 + tmp3_2) * (s1_497_1 + s1_497_2);
    gl64_t kD497 = tmp3_0 * s1_497_0;
    gl64_t kE497 = tmp3_1 * s1_497_1;
    gl64_t kF497 = tmp3_2 * s1_497_2;
    gl64_t kG497 = kD497 - kE497;
    tmp3_6 = (kC497 + kG497) - kF497;
    tmp3_7 = ((((kA497 + kC497) - kE497) - kE497) - kD497);
    tmp3_8 = kB497 - kG497;
    // Op 498: dim3x1 mul
    gl64_t s0_498_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_498_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_498_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_498 = *(gl64_t*)&expressions_params[10][13];
    tmp3_0 = s0_498_0 * s1_498; tmp3_1 = s0_498_1 * s1_498; tmp3_2 = s0_498_2 * s1_498;
    // Op 499: dim3x1 add
    gl64_t s1_499 = *(gl64_t*)&expressions_params[9][14];
    tmp3_0 = tmp3_0 + s1_499; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 500: dim3x3 add
    gl64_t s1_500_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_500_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_500_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_500_0; tmp3_1 = tmp3_1 + s1_500_1; tmp3_2 = tmp3_2 + s1_500_2;
    // Op 501: dim3x3 mul
    gl64_t s1_501_0 = *(gl64_t*)&expressions_params[10][27];
    gl64_t s1_501_1 = *(gl64_t*)&expressions_params[10][27+1];
    gl64_t s1_501_2 = *(gl64_t*)&expressions_params[10][27+2];
    gl64_t kA501 = (tmp3_0 + tmp3_1) * (s1_501_0 + s1_501_1);
    gl64_t kB501 = (tmp3_0 + tmp3_2) * (s1_501_0 + s1_501_2);
    gl64_t kC501 = (tmp3_1 + tmp3_2) * (s1_501_1 + s1_501_2);
    gl64_t kD501 = tmp3_0 * s1_501_0;
    gl64_t kE501 = tmp3_1 * s1_501_1;
    gl64_t kF501 = tmp3_2 * s1_501_2;
    gl64_t kG501 = kD501 - kE501;
    tmp3_0 = (kC501 + kG501) - kF501;
    tmp3_1 = ((((kA501 + kC501) - kE501) - kE501) - kD501);
    tmp3_2 = kB501 - kG501;
    // Op 502: dim3x1 add
    gl64_t s1_502 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_502; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 503: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 504: dim3x3 mul
    gl64_t s1_504_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_504_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_504_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA504 = (tmp3_0 + tmp3_1) * (s1_504_0 + s1_504_1);
    gl64_t kB504 = (tmp3_0 + tmp3_2) * (s1_504_0 + s1_504_2);
    gl64_t kC504 = (tmp3_1 + tmp3_2) * (s1_504_1 + s1_504_2);
    gl64_t kD504 = tmp3_0 * s1_504_0;
    gl64_t kE504 = tmp3_1 * s1_504_1;
    gl64_t kF504 = tmp3_2 * s1_504_2;
    gl64_t kG504 = kD504 - kE504;
    tmp3_3 = (kC504 + kG504) - kF504;
    tmp3_4 = ((((kA504 + kC504) - kE504) - kE504) - kD504);
    tmp3_5 = kB504 - kG504;
    // Op 505: dim3x3 sub_swap
    uint64_t s0_505_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_505_0 = *(gl64_t*)&dParams->aux_trace[s0_505_pos];
    gl64_t s0_505_1 = *(gl64_t*)&dParams->aux_trace[s0_505_pos + TILE_HEIGHT];
    gl64_t s0_505_2 = *(gl64_t*)&dParams->aux_trace[s0_505_pos + 2*TILE_HEIGHT];
    gl64_t s1_505_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_505_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_505_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_6 = s1_505_0 - s0_505_0; tmp3_7 = s1_505_1 - s0_505_1; tmp3_8 = s1_505_2 - s0_505_2;
    // Op 506: dim3x3 add
    gl64_t s0_506_0 = *(gl64_t*)&expressions_params[10][15];
    gl64_t s0_506_1 = *(gl64_t*)&expressions_params[10][15+1];
    gl64_t s0_506_2 = *(gl64_t*)&expressions_params[10][15+2];
    gl64_t s1_506_0 = *(gl64_t*)&expressions_params[10][18];
    gl64_t s1_506_1 = *(gl64_t*)&expressions_params[10][18+1];
    gl64_t s1_506_2 = *(gl64_t*)&expressions_params[10][18+2];
    tmp3_0 = s0_506_0 + s1_506_0; tmp3_1 = s0_506_1 + s1_506_1; tmp3_2 = s0_506_2 + s1_506_2;
    // Op 507: dim3x3 add
    gl64_t s1_507_0 = *(gl64_t*)&expressions_params[10][21];
    gl64_t s1_507_1 = *(gl64_t*)&expressions_params[10][21+1];
    gl64_t s1_507_2 = *(gl64_t*)&expressions_params[10][21+2];
    tmp3_0 = tmp3_0 + s1_507_0; tmp3_1 = tmp3_1 + s1_507_1; tmp3_2 = tmp3_2 + s1_507_2;
    // Op 508: dim3x3 add
    gl64_t s1_508_0 = *(gl64_t*)&expressions_params[10][24];
    gl64_t s1_508_1 = *(gl64_t*)&expressions_params[10][24+1];
    gl64_t s1_508_2 = *(gl64_t*)&expressions_params[10][24+2];
    tmp3_0 = tmp3_0 + s1_508_0; tmp3_1 = tmp3_1 + s1_508_1; tmp3_2 = tmp3_2 + s1_508_2;
    // Op 509: dim3x3 add
    gl64_t s1_509_0 = *(gl64_t*)&expressions_params[10][27];
    gl64_t s1_509_1 = *(gl64_t*)&expressions_params[10][27+1];
    gl64_t s1_509_2 = *(gl64_t*)&expressions_params[10][27+2];
    tmp3_0 = tmp3_0 + s1_509_0; tmp3_1 = tmp3_1 + s1_509_1; tmp3_2 = tmp3_2 + s1_509_2;
    // Op 510: dim3x3 sub
    tmp3_0 = tmp3_6 - tmp3_0; tmp3_1 = tmp3_7 - tmp3_1; tmp3_2 = tmp3_8 - tmp3_2;
    // Op 511: dim3x1 mul
    gl64_t s1_511 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_511; tmp3_1 = tmp3_1 * s1_511; tmp3_2 = tmp3_2 * s1_511;
    // Op 512: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 513: dim3x1 mul
    gl64_t s1_513 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_513; tmp3_1 = tmp3_1 * s1_513; tmp3_2 = tmp3_2 * s1_513;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
