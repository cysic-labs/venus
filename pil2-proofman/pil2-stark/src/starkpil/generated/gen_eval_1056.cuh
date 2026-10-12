// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: 1afe6bfa  nOps=775 nTemp1=4 nTemp3=5
#define GENERATED_EVAL_NOPS_1afe6bfa 775
#define GENERATED_EVAL_NTEMP1_1afe6bfa 4
#define GENERATED_EVAL_NTEMP3_1afe6bfa 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_1afe6bfa(
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

    // Register-resident temporaries: 4 tmp1 + 15 tmp3 slots
    gl64_t tmp1_0 = gl64_t(uint64_t(0));
    gl64_t tmp1_1 = gl64_t(uint64_t(0));
    gl64_t tmp1_2 = gl64_t(uint64_t(0));
    gl64_t tmp1_3 = gl64_t(uint64_t(0));
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
    gl64_t s0_33 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_33 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_33 - s0_33;
    // Op 34: dim1x1 mul
    gl64_t s0_34 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
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
    gl64_t s0_38 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
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
    gl64_t s0_41 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_41 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_41 - s0_41;
    // Op 42: dim1x1 mul
    gl64_t s0_42 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
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
    gl64_t s0_45 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_45 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_45 - s0_45;
    // Op 46: dim1x1 mul
    gl64_t s0_46 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
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
    gl64_t s0_49 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
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
    gl64_t s0_53 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_53 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_53 - s0_53;
    // Op 54: dim1x1 mul
    gl64_t s0_54 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
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
    gl64_t s0_57 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_57 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_57 - s0_57;
    // Op 58: dim1x1 mul
    gl64_t s0_58 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
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
    gl64_t s0_61 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_61 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_61 - s0_61;
    // Op 62: dim1x1 mul
    gl64_t s0_62 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
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
    // Op 65: dim1x1 sub_swap
    gl64_t s0_65 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_65 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_65 - s0_65;
    // Op 66: dim1x1 mul
    gl64_t s0_66 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
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
    // Op 69: dim1x1 sub_swap
    gl64_t s0_69 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_69 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_69 - s0_69;
    // Op 70: dim1x1 mul
    gl64_t s0_70 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_0 = s0_70 * tmp1_0;
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
    gl64_t s0_73 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_73 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_73 - s0_73;
    // Op 74: dim1x1 mul
    gl64_t s0_74 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
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
    gl64_t s0_77 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_77 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_77 - s0_77;
    // Op 78: dim1x1 mul
    gl64_t s0_78 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
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
    gl64_t s0_81 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_81 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_81 - s0_81;
    // Op 82: dim1x1 mul
    gl64_t s0_82 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
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
    gl64_t s0_85 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_85 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_85 - s0_85;
    // Op 86: dim1x1 mul
    gl64_t s0_86 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
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
    gl64_t s0_89 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_89 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_89 - s0_89;
    // Op 90: dim1x1 mul
    gl64_t s0_90 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
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
    gl64_t s0_93 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_93 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_93 - s0_93;
    // Op 94: dim1x1 mul
    gl64_t s0_94 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
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
    gl64_t s0_97 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_97 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_97 - s0_97;
    // Op 98: dim1x1 mul
    gl64_t s0_98 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
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
    // Op 101: dim1x1 sub
    gl64_t s0_101 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_101 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s0_101 - s1_101;
    // Op 102: dim1x1 mul
    gl64_t s0_102 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
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
    // Op 105: dim1x1 sub_swap
    gl64_t s0_105 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_105 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_105 - s0_105;
    // Op 106: dim1x1 mul
    gl64_t s0_106 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_106 * tmp1_0;
    // Op 107: dim1x1 sub
    gl64_t s0_107 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_107 = *(gl64_t*)&expressions_params[10][7];
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
    gl64_t s0_113 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_113 = *(gl64_t*)&expressions_params[10][8];
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
    tmp1_0 = s0_118 * tmp1_0;
    // Op 119: dim1x1 sub
    gl64_t s0_119 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_119 = *(gl64_t*)&expressions_params[10][9];
    tmp1_1 = s0_119 - s1_119;
    // Op 120: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
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
    // Op 123: dim1x1 sub_swap
    gl64_t s0_123 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_123 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_123 - s0_123;
    // Op 124: dim1x1 mul
    gl64_t s0_124 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_124 * tmp1_0;
    // Op 125: dim1x1 sub
    gl64_t s0_125 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_125 = *(gl64_t*)&expressions_params[10][10];
    tmp1_1 = s0_125 - s1_125;
    // Op 126: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
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
    gl64_t s0_129 = *(gl64_t*)&expressions_params[10][7];
    gl64_t s1_129 = *(gl64_t*)&expressions_params[10][6];
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
    // Op 132: dim1x1 mul
    gl64_t s0_132 = *(gl64_t*)&expressions_params[10][9];
    gl64_t s1_132 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s0_132 * s1_132;
    // Op 133: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 134: dim3x3 mul
    gl64_t s1_134_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_134_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_134_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA134 = (tmp3_0 + tmp3_1) * (s1_134_0 + s1_134_1);
    gl64_t kB134 = (tmp3_0 + tmp3_2) * (s1_134_0 + s1_134_2);
    gl64_t kC134 = (tmp3_1 + tmp3_2) * (s1_134_1 + s1_134_2);
    gl64_t kD134 = tmp3_0 * s1_134_0;
    gl64_t kE134 = tmp3_1 * s1_134_1;
    gl64_t kF134 = tmp3_2 * s1_134_2;
    gl64_t kG134 = kD134 - kE134;
    tmp3_0 = (kC134 + kG134) - kF134;
    tmp3_1 = ((((kA134 + kC134) - kE134) - kE134) - kD134);
    tmp3_2 = kB134 - kG134;
    // Op 135: dim1x1 mul
    gl64_t s0_135 = *(gl64_t*)&expressions_params[10][8];
    gl64_t s1_135 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s0_135 * s1_135;
    // Op 136: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 137: dim3x3 mul
    gl64_t s1_137_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_137_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_137_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 138: dim1x1 mul
    gl64_t s0_138 = *(gl64_t*)&expressions_params[10][10];
    gl64_t s1_138 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s0_138 * s1_138;
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
    // Op 141: dim1x1 mul
    gl64_t s0_141 = *(gl64_t*)&expressions_params[10][2];
    gl64_t s1_141 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_141 * s1_141;
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
    // Op 144: dim1x1 mul
    gl64_t s0_144 = *(gl64_t*)&expressions_params[10][4];
    gl64_t s1_144 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_144 * s1_144;
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
    // Op 147: dim1x1 mul
    gl64_t s0_147 = *(gl64_t*)&expressions_params[10][3];
    gl64_t s1_147 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_147 * s1_147;
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
    // Op 150: dim1x1 mul
    gl64_t s0_150 = *(gl64_t*)&expressions_params[10][5];
    gl64_t s1_150 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_150 * s1_150;
    // Op 151: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 152: dim3x3 mul
    gl64_t s1_152_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_152_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_152_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA152 = (tmp3_0 + tmp3_1) * (s1_152_0 + s1_152_1);
    gl64_t kB152 = (tmp3_0 + tmp3_2) * (s1_152_0 + s1_152_2);
    gl64_t kC152 = (tmp3_1 + tmp3_2) * (s1_152_1 + s1_152_2);
    gl64_t kD152 = tmp3_0 * s1_152_0;
    gl64_t kE152 = tmp3_1 * s1_152_1;
    gl64_t kF152 = tmp3_2 * s1_152_2;
    gl64_t kG152 = kD152 - kE152;
    tmp3_0 = (kC152 + kG152) - kF152;
    tmp3_1 = ((((kA152 + kC152) - kE152) - kE152) - kD152);
    tmp3_2 = kB152 - kG152;
    // Op 153: dim1x1 sub_swap
    gl64_t s0_153 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_153 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_153 - s0_153;
    // Op 154: dim1x1 mul
    gl64_t s0_154 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_154 * tmp1_0;
    // Op 155: dim1x1 sub
    gl64_t s0_155 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_155 = *(gl64_t*)&expressions_params[10][13];
    tmp1_1 = s0_155 - s1_155;
    // Op 156: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 157: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 158: dim3x3 mul
    gl64_t s1_158_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_158_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_158_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA158 = (tmp3_0 + tmp3_1) * (s1_158_0 + s1_158_1);
    gl64_t kB158 = (tmp3_0 + tmp3_2) * (s1_158_0 + s1_158_2);
    gl64_t kC158 = (tmp3_1 + tmp3_2) * (s1_158_1 + s1_158_2);
    gl64_t kD158 = tmp3_0 * s1_158_0;
    gl64_t kE158 = tmp3_1 * s1_158_1;
    gl64_t kF158 = tmp3_2 * s1_158_2;
    gl64_t kG158 = kD158 - kE158;
    tmp3_0 = (kC158 + kG158) - kF158;
    tmp3_1 = ((((kA158 + kC158) - kE158) - kE158) - kD158);
    tmp3_2 = kB158 - kG158;
    // Op 159: dim1x1 mul
    gl64_t s0_159 = *(gl64_t*)&expressions_params[10][12];
    gl64_t s1_159 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_159 * s1_159;
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
    // Op 162: dim1x1 mul
    gl64_t s0_162 = *(gl64_t*)&expressions_params[10][13];
    gl64_t s1_162 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s0_162 * s1_162;
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
    // Op 165: dim1x1 sub
    gl64_t s0_165 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_165 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_165 - s1_165;
    // Op 166: dim1x1 mul
    gl64_t s0_166 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_2 = s0_166 * tmp1_0;
    // Op 167: dim1x1 sub_swap
    gl64_t s0_167 = *(gl64_t*)&expressions_params[9][2];
    gl64_t s1_167 = *(gl64_t*)&expressions_params[10][4];
    tmp1_0 = s1_167 - s0_167;
    // Op 168: dim1x1 sub
    gl64_t s0_168 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_168 - tmp1_0;
    // Op 169: dim1x1 mul
    tmp1_0 = tmp1_2 * tmp1_0;
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
    // Op 172: dim1x1 sub_swap
    gl64_t s0_172 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_172 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_172 - s0_172;
    // Op 173: dim1x1 sub_swap
    gl64_t s0_173 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 1, domainSize, nCols_1))];
    gl64_t s1_173 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s1_173 - s0_173;
    // Op 174: dim1x1 mul
    tmp1_3 = tmp1_0 * tmp1_1;
    // Op 175: dim1x1 sub
    gl64_t s0_175 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 7, domainSize, nCols_1))];
    gl64_t s1_175 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_175 - s1_175;
    // Op 176: dim1x1 sub
    gl64_t s0_176 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_176 - tmp1_0;
    // Op 177: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 178: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 179: dim3x3 mul
    gl64_t s1_179_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_179_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_179_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 180: dim1x1 add
    gl64_t s0_180 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_180 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_180 + s1_180;
    // Op 181: dim1x1 add
    gl64_t s0_181 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_181 + tmp1_0;
    // Op 182: dim1x1 add
    gl64_t s0_182 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_182 + tmp1_0;
    // Op 183: dim1x1 add
    gl64_t s0_183 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_0 = s0_183 + tmp1_0;
    // Op 184: dim1x1 add
    gl64_t s0_184 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_184 + tmp1_0;
    // Op 185: dim1x1 add
    gl64_t s0_185 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_185 + tmp1_0;
    // Op 186: dim1x1 add
    gl64_t s0_186 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_1 = s0_186 + tmp1_0;
    // Op 187: dim1x1 sub
    gl64_t s0_187 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_187 - tmp1_1;
    // Op 188: dim1x1 mul
    gl64_t s0_188 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_188 * tmp1_0;
    // Op 189: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 190: dim3x3 mul
    gl64_t s1_190_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_190_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_190_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 191: dim1x1 sub_swap
    gl64_t s0_191 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_191 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_191 - s0_191;
    // Op 192: dim1x1 sub
    gl64_t s1_192 = *(gl64_t*)&expressions_params[9][2];
    tmp1_1 = tmp1_1 - s1_192;
    // Op 193: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
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
    // Op 196: dim1x1 add
    gl64_t s0_196 = *(gl64_t*)&expressions_params[9][2];
    gl64_t s1_196 = *(gl64_t*)&expressions_params[10][2];
    tmp1_0 = s0_196 + s1_196;
    // Op 197: dim1x1 sub
    gl64_t s0_197 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_197 - tmp1_0;
    // Op 198: dim1x1 mul
    tmp1_0 = tmp1_2 * tmp1_0;
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
    // Op 201: dim1x1 add
    gl64_t s0_201 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 6, domainSize, nCols_1))];
    gl64_t s1_201 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_201 + s1_201;
    // Op 202: dim1x1 sub
    gl64_t s0_202 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_202 - tmp1_0;
    // Op 203: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
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
    // Op 206: dim1x1 add
    gl64_t s0_206 = *(gl64_t*)&expressions_params[9][2];
    gl64_t s1_206 = *(gl64_t*)&expressions_params[10][12];
    tmp1_0 = s0_206 + s1_206;
    // Op 207: dim1x1 sub
    gl64_t s0_207 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_207 - tmp1_0;
    // Op 208: dim1x1 mul
    tmp1_0 = tmp1_2 * tmp1_0;
    // Op 209: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 210: dim3x3 mul
    gl64_t s1_210_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_210_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_210_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA210 = (tmp3_0 + tmp3_1) * (s1_210_0 + s1_210_1);
    gl64_t kB210 = (tmp3_0 + tmp3_2) * (s1_210_0 + s1_210_2);
    gl64_t kC210 = (tmp3_1 + tmp3_2) * (s1_210_1 + s1_210_2);
    gl64_t kD210 = tmp3_0 * s1_210_0;
    gl64_t kE210 = tmp3_1 * s1_210_1;
    gl64_t kF210 = tmp3_2 * s1_210_2;
    gl64_t kG210 = kD210 - kE210;
    tmp3_0 = (kC210 + kG210) - kF210;
    tmp3_1 = ((((kA210 + kC210) - kE210) - kE210) - kD210);
    tmp3_2 = kB210 - kG210;
    // Op 211: dim1x1 add
    gl64_t s0_211 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_1))];
    gl64_t s1_211 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_211 + s1_211;
    // Op 212: dim1x1 sub
    gl64_t s0_212 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_212 - tmp1_0;
    // Op 213: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 214: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 215: dim3x3 mul
    gl64_t s1_215_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_215_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_215_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA215 = (tmp3_0 + tmp3_1) * (s1_215_0 + s1_215_1);
    gl64_t kB215 = (tmp3_0 + tmp3_2) * (s1_215_0 + s1_215_2);
    gl64_t kC215 = (tmp3_1 + tmp3_2) * (s1_215_1 + s1_215_2);
    gl64_t kD215 = tmp3_0 * s1_215_0;
    gl64_t kE215 = tmp3_1 * s1_215_1;
    gl64_t kF215 = tmp3_2 * s1_215_2;
    gl64_t kG215 = kD215 - kE215;
    tmp3_0 = (kC215 + kG215) - kF215;
    tmp3_1 = ((((kA215 + kC215) - kE215) - kE215) - kD215);
    tmp3_2 = kB215 - kG215;
    // Op 216: dim1x1 sub
    gl64_t s0_216 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_216 = *(gl64_t*)&expressions_params[10][5];
    tmp1_0 = s0_216 - s1_216;
    // Op 217: dim1x1 mul
    tmp1_0 = tmp1_2 * tmp1_0;
    // Op 218: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC219 + kG219) - kF219;
    tmp3_1 = ((((kA219 + kC219) - kE219) - kE219) - kD219);
    tmp3_2 = kB219 - kG219;
    // Op 220: dim1x1 sub
    gl64_t s0_220 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_220 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 3, domainSize, nCols_1))];
    tmp1_0 = s0_220 - s1_220;
    // Op 221: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
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
    // Op 224: dim1x1 sub
    gl64_t s0_224 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_224 = *(gl64_t*)&expressions_params[10][3];
    tmp1_0 = s0_224 - s1_224;
    // Op 225: dim1x1 mul
    tmp1_0 = tmp1_2 * tmp1_0;
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
    // Op 228: dim1x1 sub
    gl64_t s0_228 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_228 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 5, domainSize, nCols_1))];
    tmp1_0 = s0_228 - s1_228;
    // Op 229: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 230: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s0_232 = *(gl64_t*)&expressions_params[9][19];
    gl64_t s1_232 = *(gl64_t*)&expressions_params[10][15];
    tmp1_0 = s0_232 * s1_232;
    // Op 233: dim1x1 add
    gl64_t s1_233 = *(gl64_t*)&expressions_params[10][14];
    tmp1_0 = tmp1_0 + s1_233;
    // Op 234: dim1x1 sub
    gl64_t s1_234 = *(gl64_t*)&expressions_params[10][9];
    tmp1_0 = tmp1_0 - s1_234;
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
    tmp3_12 = (kC236 + kG236) - kF236;
    tmp3_13 = ((((kA236 + kC236) - kE236) - kE236) - kD236);
    tmp3_14 = kB236 - kG236;
    // Op 237: dim3x1 mul
    gl64_t s0_237_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_237_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_237_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_237 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp3_0 = s0_237_0 * s1_237; tmp3_1 = s0_237_1 * s1_237; tmp3_2 = s0_237_2 * s1_237;
    // Op 238: dim3x1 add
    gl64_t s1_238 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_238; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 239: dim3x3 mul
    gl64_t s1_239_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_239_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_239_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA239 = (tmp3_0 + tmp3_1) * (s1_239_0 + s1_239_1);
    gl64_t kB239 = (tmp3_0 + tmp3_2) * (s1_239_0 + s1_239_2);
    gl64_t kC239 = (tmp3_1 + tmp3_2) * (s1_239_1 + s1_239_2);
    gl64_t kD239 = tmp3_0 * s1_239_0;
    gl64_t kE239 = tmp3_1 * s1_239_1;
    gl64_t kF239 = tmp3_2 * s1_239_2;
    gl64_t kG239 = kD239 - kE239;
    tmp3_0 = (kC239 + kG239) - kF239;
    tmp3_1 = ((((kA239 + kC239) - kE239) - kE239) - kD239);
    tmp3_2 = kB239 - kG239;
    // Op 240: dim3x1 add
    gl64_t s1_240 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_240; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 241: dim3x3 mul
    gl64_t s1_241_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_241_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_241_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 242: dim1x1 mul
    gl64_t s0_242 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_242 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_242 * s1_242;
    // Op 243: dim1x1 add
    gl64_t s1_243 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_243;
    // Op 244: dim1x1 add
    gl64_t s1_244 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_244;
    // Op 245: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 247: dim1x1 mul
    gl64_t s0_247 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_247 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_247 * s1_247;
    // Op 248: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 249: dim3x3 mul
    gl64_t s1_249_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_249_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_249_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA249 = (tmp3_0 + tmp3_1) * (s1_249_0 + s1_249_1);
    gl64_t kB249 = (tmp3_0 + tmp3_2) * (s1_249_0 + s1_249_2);
    gl64_t kC249 = (tmp3_1 + tmp3_2) * (s1_249_1 + s1_249_2);
    gl64_t kD249 = tmp3_0 * s1_249_0;
    gl64_t kE249 = tmp3_1 * s1_249_1;
    gl64_t kF249 = tmp3_2 * s1_249_2;
    gl64_t kG249 = kD249 - kE249;
    tmp3_0 = (kC249 + kG249) - kF249;
    tmp3_1 = ((((kA249 + kC249) - kE249) - kE249) - kD249);
    tmp3_2 = kB249 - kG249;
    // Op 250: dim3x1 add
    gl64_t s1_250 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_250; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 251: dim3x3 mul
    gl64_t s1_251_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_251_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_251_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA251 = (tmp3_0 + tmp3_1) * (s1_251_0 + s1_251_1);
    gl64_t kB251 = (tmp3_0 + tmp3_2) * (s1_251_0 + s1_251_2);
    gl64_t kC251 = (tmp3_1 + tmp3_2) * (s1_251_1 + s1_251_2);
    gl64_t kD251 = tmp3_0 * s1_251_0;
    gl64_t kE251 = tmp3_1 * s1_251_1;
    gl64_t kF251 = tmp3_2 * s1_251_2;
    gl64_t kG251 = kD251 - kE251;
    tmp3_0 = (kC251 + kG251) - kF251;
    tmp3_1 = ((((kA251 + kC251) - kE251) - kE251) - kD251);
    tmp3_2 = kB251 - kG251;
    // Op 252: dim3x1 add
    gl64_t s1_252 = *(gl64_t*)&expressions_params[9][5];
    tmp3_9 = tmp3_0 + s1_252; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 253: dim3x3 add
    gl64_t s1_253_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_253_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_253_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_253_0; tmp3_4 = tmp3_10 + s1_253_1; tmp3_5 = tmp3_11 + s1_253_2;
    // Op 254: dim3x1 mul
    gl64_t s0_254_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_254_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_254_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_254 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp3_0 = s0_254_0 * s1_254; tmp3_1 = s0_254_1 * s1_254; tmp3_2 = s0_254_2 * s1_254;
    // Op 255: dim3x1 add
    gl64_t s1_255 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_255; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 256: dim3x3 mul
    gl64_t s1_256_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_256_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_256_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 257: dim3x1 add
    gl64_t s1_257 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_257; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 258: dim3x3 mul
    gl64_t s1_258_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_258_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_258_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA258 = (tmp3_0 + tmp3_1) * (s1_258_0 + s1_258_1);
    gl64_t kB258 = (tmp3_0 + tmp3_2) * (s1_258_0 + s1_258_2);
    gl64_t kC258 = (tmp3_1 + tmp3_2) * (s1_258_1 + s1_258_2);
    gl64_t kD258 = tmp3_0 * s1_258_0;
    gl64_t kE258 = tmp3_1 * s1_258_1;
    gl64_t kF258 = tmp3_2 * s1_258_2;
    gl64_t kG258 = kD258 - kE258;
    tmp3_0 = (kC258 + kG258) - kF258;
    tmp3_1 = ((((kA258 + kC258) - kE258) - kE258) - kD258);
    tmp3_2 = kB258 - kG258;
    // Op 259: dim1x1 mul
    gl64_t s0_259 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_259 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_259 * s1_259;
    // Op 260: dim1x1 add
    gl64_t s1_260 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_260;
    // Op 261: dim1x1 add
    gl64_t s0_261 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_261 + tmp1_0;
    // Op 262: dim1x1 add
    gl64_t s1_262 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_262;
    // Op 263: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 264: dim3x3 mul
    gl64_t s1_264_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_264_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_264_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA264 = (tmp3_0 + tmp3_1) * (s1_264_0 + s1_264_1);
    gl64_t kB264 = (tmp3_0 + tmp3_2) * (s1_264_0 + s1_264_2);
    gl64_t kC264 = (tmp3_1 + tmp3_2) * (s1_264_1 + s1_264_2);
    gl64_t kD264 = tmp3_0 * s1_264_0;
    gl64_t kE264 = tmp3_1 * s1_264_1;
    gl64_t kF264 = tmp3_2 * s1_264_2;
    gl64_t kG264 = kD264 - kE264;
    tmp3_0 = (kC264 + kG264) - kF264;
    tmp3_1 = ((((kA264 + kC264) - kE264) - kE264) - kD264);
    tmp3_2 = kB264 - kG264;
    // Op 265: dim1x1 mul
    gl64_t s0_265 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_265 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_265 * s1_265;
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
    // Op 268: dim1x1 add
    gl64_t s0_268 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_268 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_268 + s1_268;
    // Op 269: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 271: dim3x1 add
    gl64_t s1_271 = *(gl64_t*)&expressions_params[9][5];
    tmp3_6 = tmp3_0 + s1_271; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 272: dim3x3 add
    gl64_t s1_272_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_272_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_272_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_272_0; tmp3_1 = tmp3_7 + s1_272_1; tmp3_2 = tmp3_8 + s1_272_2;
    // Op 273: dim3x3 mul
    gl64_t kA273 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB273 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC273 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD273 = tmp3_3 * tmp3_0;
    gl64_t kE273 = tmp3_4 * tmp3_1;
    gl64_t kF273 = tmp3_5 * tmp3_2;
    gl64_t kG273 = kD273 - kE273;
    tmp3_0 = (kC273 + kG273) - kF273;
    tmp3_1 = ((((kA273 + kC273) - kE273) - kE273) - kD273);
    tmp3_2 = kB273 - kG273;
    // Op 274: dim3x3 mul
    gl64_t s0_274_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_274_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_274_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA274 = (s0_274_0 + s0_274_1) * (tmp3_0 + tmp3_1);
    gl64_t kB274 = (s0_274_0 + s0_274_2) * (tmp3_0 + tmp3_2);
    gl64_t kC274 = (s0_274_1 + s0_274_2) * (tmp3_1 + tmp3_2);
    gl64_t kD274 = s0_274_0 * tmp3_0;
    gl64_t kE274 = s0_274_1 * tmp3_1;
    gl64_t kF274 = s0_274_2 * tmp3_2;
    gl64_t kG274 = kD274 - kE274;
    tmp3_0 = (kC274 + kG274) - kF274;
    tmp3_1 = ((((kA274 + kC274) - kE274) - kE274) - kD274);
    tmp3_2 = kB274 - kG274;
    // Op 275: dim1x1 sub_swap
    gl64_t s0_275 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_275 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_275 - s0_275;
    // Op 276: dim3x3 add
    gl64_t s1_276_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_276_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_276_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_276_0; tmp3_7 = tmp3_7 + s1_276_1; tmp3_8 = tmp3_8 + s1_276_2;
    // Op 277: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 278: dim1x1 sub_swap
    gl64_t s0_278 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_278 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_278 - s0_278;
    // Op 279: dim3x3 add
    gl64_t s1_279_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_279_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_279_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_279_0; tmp3_10 = tmp3_10 + s1_279_1; tmp3_11 = tmp3_11 + s1_279_2;
    // Op 280: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 281: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 282: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 283: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 284: dim3x3 mul
    gl64_t s1_284_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_284_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_284_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA284 = (tmp3_0 + tmp3_1) * (s1_284_0 + s1_284_1);
    gl64_t kB284 = (tmp3_0 + tmp3_2) * (s1_284_0 + s1_284_2);
    gl64_t kC284 = (tmp3_1 + tmp3_2) * (s1_284_1 + s1_284_2);
    gl64_t kD284 = tmp3_0 * s1_284_0;
    gl64_t kE284 = tmp3_1 * s1_284_1;
    gl64_t kF284 = tmp3_2 * s1_284_2;
    gl64_t kG284 = kD284 - kE284;
    tmp3_3 = (kC284 + kG284) - kF284;
    tmp3_4 = ((((kA284 + kC284) - kE284) - kE284) - kD284);
    tmp3_5 = kB284 - kG284;
    // Op 285: dim3x1 mul
    gl64_t s0_285_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_285_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_285_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_285 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp3_0 = s0_285_0 * s1_285; tmp3_1 = s0_285_1 * s1_285; tmp3_2 = s0_285_2 * s1_285;
    // Op 286: dim3x1 add
    gl64_t s1_286 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_286; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 288: dim3x1 add
    gl64_t s1_288 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_288; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 290: dim1x1 mul
    gl64_t s0_290 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_290 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_290 * s1_290;
    // Op 291: dim1x1 add
    gl64_t s1_291 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_291;
    // Op 292: dim1x1 add
    gl64_t s1_292 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_292;
    // Op 293: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s0_295 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_295 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_295 * s1_295;
    // Op 296: dim1x1 add
    gl64_t s1_296 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = tmp1_0 + s1_296;
    // Op 297: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_299 = *(gl64_t*)&expressions_params[9][0];
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
    gl64_t s1_301 = *(gl64_t*)&expressions_params[9][5];
    tmp3_9 = tmp3_0 + s1_301; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 302: dim3x3 add
    gl64_t s1_302_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_302_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_302_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_302_0; tmp3_13 = tmp3_10 + s1_302_1; tmp3_14 = tmp3_11 + s1_302_2;
    // Op 303: dim3x1 mul
    gl64_t s0_303_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_303_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_303_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_303 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp3_0 = s0_303_0 * s1_303; tmp3_1 = s0_303_1 * s1_303; tmp3_2 = s0_303_2 * s1_303;
    // Op 304: dim3x1 add
    gl64_t s1_304 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_304; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_306 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_306; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s0_308 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_308 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_308 * s1_308;
    // Op 309: dim1x1 add
    gl64_t s1_309 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_309;
    // Op 310: dim1x1 add
    gl64_t s0_310 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_310 + tmp1_0;
    // Op 311: dim1x1 add
    gl64_t s1_311 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_311;
    // Op 312: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s0_314 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_314 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_314 * s1_314;
    // Op 315: dim1x1 add
    gl64_t s1_315 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = tmp1_0 + s1_315;
    // Op 316: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 318: dim1x1 add
    gl64_t s0_318 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_318 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_318 + s1_318;
    // Op 319: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 320: dim3x3 mul
    gl64_t s1_320_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_320_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_320_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA320 = (tmp3_0 + tmp3_1) * (s1_320_0 + s1_320_1);
    gl64_t kB320 = (tmp3_0 + tmp3_2) * (s1_320_0 + s1_320_2);
    gl64_t kC320 = (tmp3_1 + tmp3_2) * (s1_320_1 + s1_320_2);
    gl64_t kD320 = tmp3_0 * s1_320_0;
    gl64_t kE320 = tmp3_1 * s1_320_1;
    gl64_t kF320 = tmp3_2 * s1_320_2;
    gl64_t kG320 = kD320 - kE320;
    tmp3_0 = (kC320 + kG320) - kF320;
    tmp3_1 = ((((kA320 + kC320) - kE320) - kE320) - kD320);
    tmp3_2 = kB320 - kG320;
    // Op 321: dim3x1 add
    gl64_t s1_321 = *(gl64_t*)&expressions_params[9][5];
    tmp3_6 = tmp3_0 + s1_321; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 322: dim3x3 add
    gl64_t s1_322_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_322_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_322_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_322_0; tmp3_1 = tmp3_7 + s1_322_1; tmp3_2 = tmp3_8 + s1_322_2;
    // Op 323: dim3x3 mul
    gl64_t kA323 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB323 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC323 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD323 = tmp3_12 * tmp3_0;
    gl64_t kE323 = tmp3_13 * tmp3_1;
    gl64_t kF323 = tmp3_14 * tmp3_2;
    gl64_t kG323 = kD323 - kE323;
    tmp3_0 = (kC323 + kG323) - kF323;
    tmp3_1 = ((((kA323 + kC323) - kE323) - kE323) - kD323);
    tmp3_2 = kB323 - kG323;
    // Op 324: dim3x3 mul
    gl64_t s0_324_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_324_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_324_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA324 = (s0_324_0 + s0_324_1) * (tmp3_0 + tmp3_1);
    gl64_t kB324 = (s0_324_0 + s0_324_2) * (tmp3_0 + tmp3_2);
    gl64_t kC324 = (s0_324_1 + s0_324_2) * (tmp3_1 + tmp3_2);
    gl64_t kD324 = s0_324_0 * tmp3_0;
    gl64_t kE324 = s0_324_1 * tmp3_1;
    gl64_t kF324 = s0_324_2 * tmp3_2;
    gl64_t kG324 = kD324 - kE324;
    tmp3_0 = (kC324 + kG324) - kF324;
    tmp3_1 = ((((kA324 + kC324) - kE324) - kE324) - kD324);
    tmp3_2 = kB324 - kG324;
    // Op 325: dim1x1 sub_swap
    gl64_t s0_325 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_325 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_325 - s0_325;
    // Op 326: dim3x3 add
    gl64_t s1_326_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_326_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_326_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_326_0; tmp3_7 = tmp3_7 + s1_326_1; tmp3_8 = tmp3_8 + s1_326_2;
    // Op 327: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 328: dim1x1 sub_swap
    gl64_t s0_328 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_328 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_328 - s0_328;
    // Op 329: dim3x3 add
    gl64_t s1_329_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_329_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_329_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_329_0; tmp3_10 = tmp3_10 + s1_329_1; tmp3_11 = tmp3_11 + s1_329_2;
    // Op 330: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 331: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 332: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 333: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 334: dim3x3 mul
    gl64_t s1_334_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_334_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_334_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA334 = (tmp3_0 + tmp3_1) * (s1_334_0 + s1_334_1);
    gl64_t kB334 = (tmp3_0 + tmp3_2) * (s1_334_0 + s1_334_2);
    gl64_t kC334 = (tmp3_1 + tmp3_2) * (s1_334_1 + s1_334_2);
    gl64_t kD334 = tmp3_0 * s1_334_0;
    gl64_t kE334 = tmp3_1 * s1_334_1;
    gl64_t kF334 = tmp3_2 * s1_334_2;
    gl64_t kG334 = kD334 - kE334;
    tmp3_12 = (kC334 + kG334) - kF334;
    tmp3_13 = ((((kA334 + kC334) - kE334) - kE334) - kD334);
    tmp3_14 = kB334 - kG334;
    // Op 335: dim3x1 mul
    gl64_t s0_335_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_335_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_335_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_335 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp3_0 = s0_335_0 * s1_335; tmp3_1 = s0_335_1 * s1_335; tmp3_2 = s0_335_2 * s1_335;
    // Op 336: dim3x1 add
    gl64_t s1_336 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
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
    // Op 338: dim3x1 add
    gl64_t s1_338 = *(gl64_t*)&expressions_params[9][2];
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
    // Op 340: dim1x1 mul
    gl64_t s0_340 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_340 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_340 * s1_340;
    // Op 341: dim1x1 add
    gl64_t s1_341 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_341;
    // Op 342: dim1x1 add
    gl64_t s1_342 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_342;
    // Op 343: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 344: dim3x3 mul
    gl64_t s1_344_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_344_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_344_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA344 = (tmp3_0 + tmp3_1) * (s1_344_0 + s1_344_1);
    gl64_t kB344 = (tmp3_0 + tmp3_2) * (s1_344_0 + s1_344_2);
    gl64_t kC344 = (tmp3_1 + tmp3_2) * (s1_344_1 + s1_344_2);
    gl64_t kD344 = tmp3_0 * s1_344_0;
    gl64_t kE344 = tmp3_1 * s1_344_1;
    gl64_t kF344 = tmp3_2 * s1_344_2;
    gl64_t kG344 = kD344 - kE344;
    tmp3_0 = (kC344 + kG344) - kF344;
    tmp3_1 = ((((kA344 + kC344) - kE344) - kE344) - kD344);
    tmp3_2 = kB344 - kG344;
    // Op 345: dim1x1 mul
    gl64_t s0_345 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_345 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_345 * s1_345;
    // Op 346: dim1x1 add
    gl64_t s1_346 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = tmp1_0 + s1_346;
    // Op 347: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 348: dim3x3 mul
    gl64_t s1_348_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_348_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_348_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA348 = (tmp3_0 + tmp3_1) * (s1_348_0 + s1_348_1);
    gl64_t kB348 = (tmp3_0 + tmp3_2) * (s1_348_0 + s1_348_2);
    gl64_t kC348 = (tmp3_1 + tmp3_2) * (s1_348_1 + s1_348_2);
    gl64_t kD348 = tmp3_0 * s1_348_0;
    gl64_t kE348 = tmp3_1 * s1_348_1;
    gl64_t kF348 = tmp3_2 * s1_348_2;
    gl64_t kG348 = kD348 - kE348;
    tmp3_0 = (kC348 + kG348) - kF348;
    tmp3_1 = ((((kA348 + kC348) - kE348) - kE348) - kD348);
    tmp3_2 = kB348 - kG348;
    // Op 349: dim3x1 add
    gl64_t s1_349 = *(gl64_t*)&expressions_params[9][0];
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
    gl64_t s1_351 = *(gl64_t*)&expressions_params[9][5];
    tmp3_9 = tmp3_0 + s1_351; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 352: dim3x3 add
    gl64_t s1_352_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_352_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_352_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_352_0; tmp3_4 = tmp3_10 + s1_352_1; tmp3_5 = tmp3_11 + s1_352_2;
    // Op 353: dim3x1 mul
    gl64_t s0_353_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_353_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_353_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_353 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp3_0 = s0_353_0 * s1_353; tmp3_1 = s0_353_1 * s1_353; tmp3_2 = s0_353_2 * s1_353;
    // Op 354: dim3x1 add
    gl64_t s1_354 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_354; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 356: dim3x1 add
    gl64_t s1_356 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_356; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 358: dim1x1 mul
    gl64_t s0_358 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_358 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_358 * s1_358;
    // Op 359: dim1x1 add
    gl64_t s1_359 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_359;
    // Op 360: dim1x1 add
    gl64_t s0_360 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_360 + tmp1_0;
    // Op 361: dim1x1 add
    gl64_t s1_361 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_361;
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
    gl64_t s0_364 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_364 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_364 * s1_364;
    // Op 365: dim1x1 add
    gl64_t s1_365 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = tmp1_0 + s1_365;
    // Op 366: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 367: dim3x3 mul
    gl64_t s1_367_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_367_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_367_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA367 = (tmp3_0 + tmp3_1) * (s1_367_0 + s1_367_1);
    gl64_t kB367 = (tmp3_0 + tmp3_2) * (s1_367_0 + s1_367_2);
    gl64_t kC367 = (tmp3_1 + tmp3_2) * (s1_367_1 + s1_367_2);
    gl64_t kD367 = tmp3_0 * s1_367_0;
    gl64_t kE367 = tmp3_1 * s1_367_1;
    gl64_t kF367 = tmp3_2 * s1_367_2;
    gl64_t kG367 = kD367 - kE367;
    tmp3_0 = (kC367 + kG367) - kF367;
    tmp3_1 = ((((kA367 + kC367) - kE367) - kE367) - kD367);
    tmp3_2 = kB367 - kG367;
    // Op 368: dim1x1 add
    gl64_t s0_368 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_368 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_368 + s1_368;
    // Op 369: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 370: dim3x3 mul
    gl64_t s1_370_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_370_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_370_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA370 = (tmp3_0 + tmp3_1) * (s1_370_0 + s1_370_1);
    gl64_t kB370 = (tmp3_0 + tmp3_2) * (s1_370_0 + s1_370_2);
    gl64_t kC370 = (tmp3_1 + tmp3_2) * (s1_370_1 + s1_370_2);
    gl64_t kD370 = tmp3_0 * s1_370_0;
    gl64_t kE370 = tmp3_1 * s1_370_1;
    gl64_t kF370 = tmp3_2 * s1_370_2;
    gl64_t kG370 = kD370 - kE370;
    tmp3_0 = (kC370 + kG370) - kF370;
    tmp3_1 = ((((kA370 + kC370) - kE370) - kE370) - kD370);
    tmp3_2 = kB370 - kG370;
    // Op 371: dim3x1 add
    gl64_t s1_371 = *(gl64_t*)&expressions_params[9][5];
    tmp3_6 = tmp3_0 + s1_371; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 372: dim3x3 add
    gl64_t s1_372_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_372_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_372_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_372_0; tmp3_1 = tmp3_7 + s1_372_1; tmp3_2 = tmp3_8 + s1_372_2;
    // Op 373: dim3x3 mul
    gl64_t kA373 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB373 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC373 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD373 = tmp3_3 * tmp3_0;
    gl64_t kE373 = tmp3_4 * tmp3_1;
    gl64_t kF373 = tmp3_5 * tmp3_2;
    gl64_t kG373 = kD373 - kE373;
    tmp3_0 = (kC373 + kG373) - kF373;
    tmp3_1 = ((((kA373 + kC373) - kE373) - kE373) - kD373);
    tmp3_2 = kB373 - kG373;
    // Op 374: dim3x3 mul
    uint64_t s0_374_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_374_0 = *(gl64_t*)&dParams->aux_trace[s0_374_pos];
    gl64_t s0_374_1 = *(gl64_t*)&dParams->aux_trace[s0_374_pos + TILE_HEIGHT];
    gl64_t s0_374_2 = *(gl64_t*)&dParams->aux_trace[s0_374_pos + 2*TILE_HEIGHT];
    gl64_t kA374 = (s0_374_0 + s0_374_1) * (tmp3_0 + tmp3_1);
    gl64_t kB374 = (s0_374_0 + s0_374_2) * (tmp3_0 + tmp3_2);
    gl64_t kC374 = (s0_374_1 + s0_374_2) * (tmp3_1 + tmp3_2);
    gl64_t kD374 = s0_374_0 * tmp3_0;
    gl64_t kE374 = s0_374_1 * tmp3_1;
    gl64_t kF374 = s0_374_2 * tmp3_2;
    gl64_t kG374 = kD374 - kE374;
    tmp3_0 = (kC374 + kG374) - kF374;
    tmp3_1 = ((((kA374 + kC374) - kE374) - kE374) - kD374);
    tmp3_2 = kB374 - kG374;
    // Op 375: dim1x1 sub_swap
    gl64_t s0_375 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_375 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_375 - s0_375;
    // Op 376: dim3x3 add
    gl64_t s1_376_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_376_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_376_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_376_0; tmp3_7 = tmp3_7 + s1_376_1; tmp3_8 = tmp3_8 + s1_376_2;
    // Op 377: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 378: dim1x1 sub_swap
    gl64_t s0_378 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_378 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_378 - s0_378;
    // Op 379: dim3x3 add
    gl64_t s1_379_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_379_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_379_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_379_0; tmp3_10 = tmp3_10 + s1_379_1; tmp3_11 = tmp3_11 + s1_379_2;
    // Op 380: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 381: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 382: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 383: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 384: dim3x3 mul
    gl64_t s1_384_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_384_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_384_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA384 = (tmp3_0 + tmp3_1) * (s1_384_0 + s1_384_1);
    gl64_t kB384 = (tmp3_0 + tmp3_2) * (s1_384_0 + s1_384_2);
    gl64_t kC384 = (tmp3_1 + tmp3_2) * (s1_384_1 + s1_384_2);
    gl64_t kD384 = tmp3_0 * s1_384_0;
    gl64_t kE384 = tmp3_1 * s1_384_1;
    gl64_t kF384 = tmp3_2 * s1_384_2;
    gl64_t kG384 = kD384 - kE384;
    tmp3_3 = (kC384 + kG384) - kF384;
    tmp3_4 = ((((kA384 + kC384) - kE384) - kE384) - kD384);
    tmp3_5 = kB384 - kG384;
    // Op 385: dim3x1 mul
    gl64_t s0_385_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_385_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_385_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_385 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp3_0 = s0_385_0 * s1_385; tmp3_1 = s0_385_1 * s1_385; tmp3_2 = s0_385_2 * s1_385;
    // Op 386: dim3x1 add
    gl64_t s1_386 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
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
    gl64_t s1_388 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_388; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 389: dim3x3 mul
    gl64_t s1_389_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_389_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_389_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA389 = (tmp3_0 + tmp3_1) * (s1_389_0 + s1_389_1);
    gl64_t kB389 = (tmp3_0 + tmp3_2) * (s1_389_0 + s1_389_2);
    gl64_t kC389 = (tmp3_1 + tmp3_2) * (s1_389_1 + s1_389_2);
    gl64_t kD389 = tmp3_0 * s1_389_0;
    gl64_t kE389 = tmp3_1 * s1_389_1;
    gl64_t kF389 = tmp3_2 * s1_389_2;
    gl64_t kG389 = kD389 - kE389;
    tmp3_0 = (kC389 + kG389) - kF389;
    tmp3_1 = ((((kA389 + kC389) - kE389) - kE389) - kD389);
    tmp3_2 = kB389 - kG389;
    // Op 390: dim1x1 mul
    gl64_t s0_390 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_390 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_390 * s1_390;
    // Op 391: dim1x1 add
    gl64_t s1_391 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_391;
    // Op 392: dim1x1 add
    gl64_t s1_392 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_392;
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
    gl64_t s0_395 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_395 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_395 * s1_395;
    // Op 396: dim1x1 add
    gl64_t s1_396 = *(gl64_t*)&expressions_params[9][7];
    tmp1_0 = tmp1_0 + s1_396;
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
    // Op 399: dim3x1 add
    gl64_t s1_399 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_399; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 400: dim3x3 mul
    gl64_t s1_400_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_400_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_400_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA400 = (tmp3_0 + tmp3_1) * (s1_400_0 + s1_400_1);
    gl64_t kB400 = (tmp3_0 + tmp3_2) * (s1_400_0 + s1_400_2);
    gl64_t kC400 = (tmp3_1 + tmp3_2) * (s1_400_1 + s1_400_2);
    gl64_t kD400 = tmp3_0 * s1_400_0;
    gl64_t kE400 = tmp3_1 * s1_400_1;
    gl64_t kF400 = tmp3_2 * s1_400_2;
    gl64_t kG400 = kD400 - kE400;
    tmp3_0 = (kC400 + kG400) - kF400;
    tmp3_1 = ((((kA400 + kC400) - kE400) - kE400) - kD400);
    tmp3_2 = kB400 - kG400;
    // Op 401: dim3x1 add
    gl64_t s1_401 = *(gl64_t*)&expressions_params[9][5];
    tmp3_9 = tmp3_0 + s1_401; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 402: dim3x3 add
    gl64_t s1_402_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_402_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_402_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_402_0; tmp3_13 = tmp3_10 + s1_402_1; tmp3_14 = tmp3_11 + s1_402_2;
    // Op 403: dim3x1 mul
    gl64_t s0_403_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_403_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_403_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_403 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp3_0 = s0_403_0 * s1_403; tmp3_1 = s0_403_1 * s1_403; tmp3_2 = s0_403_2 * s1_403;
    // Op 404: dim3x1 add
    gl64_t s1_404 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
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
    gl64_t s1_406 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_406; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 407: dim3x3 mul
    gl64_t s1_407_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_407_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_407_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA407 = (tmp3_0 + tmp3_1) * (s1_407_0 + s1_407_1);
    gl64_t kB407 = (tmp3_0 + tmp3_2) * (s1_407_0 + s1_407_2);
    gl64_t kC407 = (tmp3_1 + tmp3_2) * (s1_407_1 + s1_407_2);
    gl64_t kD407 = tmp3_0 * s1_407_0;
    gl64_t kE407 = tmp3_1 * s1_407_1;
    gl64_t kF407 = tmp3_2 * s1_407_2;
    gl64_t kG407 = kD407 - kE407;
    tmp3_0 = (kC407 + kG407) - kF407;
    tmp3_1 = ((((kA407 + kC407) - kE407) - kE407) - kD407);
    tmp3_2 = kB407 - kG407;
    // Op 408: dim1x1 mul
    gl64_t s0_408 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_408 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_408 * s1_408;
    // Op 409: dim1x1 add
    gl64_t s1_409 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_409;
    // Op 410: dim1x1 add
    gl64_t s0_410 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_410 + tmp1_0;
    // Op 411: dim1x1 add
    gl64_t s1_411 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_411;
    // Op 412: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 414: dim1x1 mul
    gl64_t s0_414 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_414 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_414 * s1_414;
    // Op 415: dim1x1 add
    gl64_t s1_415 = *(gl64_t*)&expressions_params[9][7];
    tmp1_0 = tmp1_0 + s1_415;
    // Op 416: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 418: dim1x1 add
    gl64_t s0_418 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_418 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_418 + s1_418;
    // Op 419: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 420: dim3x3 mul
    gl64_t s1_420_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_420_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_420_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA420 = (tmp3_0 + tmp3_1) * (s1_420_0 + s1_420_1);
    gl64_t kB420 = (tmp3_0 + tmp3_2) * (s1_420_0 + s1_420_2);
    gl64_t kC420 = (tmp3_1 + tmp3_2) * (s1_420_1 + s1_420_2);
    gl64_t kD420 = tmp3_0 * s1_420_0;
    gl64_t kE420 = tmp3_1 * s1_420_1;
    gl64_t kF420 = tmp3_2 * s1_420_2;
    gl64_t kG420 = kD420 - kE420;
    tmp3_0 = (kC420 + kG420) - kF420;
    tmp3_1 = ((((kA420 + kC420) - kE420) - kE420) - kD420);
    tmp3_2 = kB420 - kG420;
    // Op 421: dim3x1 add
    gl64_t s1_421 = *(gl64_t*)&expressions_params[9][5];
    tmp3_6 = tmp3_0 + s1_421; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 422: dim3x3 add
    gl64_t s1_422_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_422_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_422_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_422_0; tmp3_1 = tmp3_7 + s1_422_1; tmp3_2 = tmp3_8 + s1_422_2;
    // Op 423: dim3x3 mul
    gl64_t kA423 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB423 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC423 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD423 = tmp3_12 * tmp3_0;
    gl64_t kE423 = tmp3_13 * tmp3_1;
    gl64_t kF423 = tmp3_14 * tmp3_2;
    gl64_t kG423 = kD423 - kE423;
    tmp3_0 = (kC423 + kG423) - kF423;
    tmp3_1 = ((((kA423 + kC423) - kE423) - kE423) - kD423);
    tmp3_2 = kB423 - kG423;
    // Op 424: dim3x3 mul
    uint64_t s0_424_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_424_0 = *(gl64_t*)&dParams->aux_trace[s0_424_pos];
    gl64_t s0_424_1 = *(gl64_t*)&dParams->aux_trace[s0_424_pos + TILE_HEIGHT];
    gl64_t s0_424_2 = *(gl64_t*)&dParams->aux_trace[s0_424_pos + 2*TILE_HEIGHT];
    gl64_t kA424 = (s0_424_0 + s0_424_1) * (tmp3_0 + tmp3_1);
    gl64_t kB424 = (s0_424_0 + s0_424_2) * (tmp3_0 + tmp3_2);
    gl64_t kC424 = (s0_424_1 + s0_424_2) * (tmp3_1 + tmp3_2);
    gl64_t kD424 = s0_424_0 * tmp3_0;
    gl64_t kE424 = s0_424_1 * tmp3_1;
    gl64_t kF424 = s0_424_2 * tmp3_2;
    gl64_t kG424 = kD424 - kE424;
    tmp3_0 = (kC424 + kG424) - kF424;
    tmp3_1 = ((((kA424 + kC424) - kE424) - kE424) - kD424);
    tmp3_2 = kB424 - kG424;
    // Op 425: dim1x1 sub_swap
    gl64_t s0_425 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_425 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_425 - s0_425;
    // Op 426: dim3x3 add
    gl64_t s1_426_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_426_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_426_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_426_0; tmp3_7 = tmp3_7 + s1_426_1; tmp3_8 = tmp3_8 + s1_426_2;
    // Op 427: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 428: dim1x1 sub_swap
    gl64_t s0_428 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_428 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_428 - s0_428;
    // Op 429: dim3x3 add
    gl64_t s1_429_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_429_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_429_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_429_0; tmp3_10 = tmp3_10 + s1_429_1; tmp3_11 = tmp3_11 + s1_429_2;
    // Op 430: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 431: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 432: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 433: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 434: dim3x3 mul
    gl64_t s1_434_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_434_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_434_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA434 = (tmp3_0 + tmp3_1) * (s1_434_0 + s1_434_1);
    gl64_t kB434 = (tmp3_0 + tmp3_2) * (s1_434_0 + s1_434_2);
    gl64_t kC434 = (tmp3_1 + tmp3_2) * (s1_434_1 + s1_434_2);
    gl64_t kD434 = tmp3_0 * s1_434_0;
    gl64_t kE434 = tmp3_1 * s1_434_1;
    gl64_t kF434 = tmp3_2 * s1_434_2;
    gl64_t kG434 = kD434 - kE434;
    tmp3_12 = (kC434 + kG434) - kF434;
    tmp3_13 = ((((kA434 + kC434) - kE434) - kE434) - kD434);
    tmp3_14 = kB434 - kG434;
    // Op 435: dim3x1 mul
    gl64_t s0_435_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_435_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_435_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_435 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp3_0 = s0_435_0 * s1_435; tmp3_1 = s0_435_1 * s1_435; tmp3_2 = s0_435_2 * s1_435;
    // Op 436: dim3x1 add
    gl64_t s1_436 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_436; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_438 = *(gl64_t*)&expressions_params[9][2];
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
    // Op 440: dim1x1 mul
    gl64_t s0_440 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_440 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_440 * s1_440;
    // Op 441: dim1x1 add
    gl64_t s1_441 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_441;
    // Op 442: dim1x1 add
    gl64_t s1_442 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_442;
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
    // Op 445: dim1x1 mul
    gl64_t s0_445 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_445 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_445 * s1_445;
    // Op 446: dim1x1 add
    gl64_t s1_446 = *(gl64_t*)&expressions_params[9][8];
    tmp1_0 = tmp1_0 + s1_446;
    // Op 447: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_449 = *(gl64_t*)&expressions_params[9][0];
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
    // Op 451: dim3x1 add
    gl64_t s1_451 = *(gl64_t*)&expressions_params[9][5];
    tmp3_9 = tmp3_0 + s1_451; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 452: dim3x3 add
    gl64_t s1_452_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_452_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_452_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_452_0; tmp3_4 = tmp3_10 + s1_452_1; tmp3_5 = tmp3_11 + s1_452_2;
    // Op 453: dim3x1 mul
    gl64_t s0_453_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_453_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_453_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_453 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp3_0 = s0_453_0 * s1_453; tmp3_1 = s0_453_1 * s1_453; tmp3_2 = s0_453_2 * s1_453;
    // Op 454: dim3x1 add
    gl64_t s1_454 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_454; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_456 = *(gl64_t*)&expressions_params[9][2];
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
    gl64_t s0_458 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_458 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_458 * s1_458;
    // Op 459: dim1x1 add
    gl64_t s1_459 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_459;
    // Op 460: dim1x1 add
    gl64_t s0_460 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_460 + tmp1_0;
    // Op 461: dim1x1 add
    gl64_t s1_461 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_461;
    // Op 462: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 464: dim1x1 mul
    gl64_t s0_464 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_464 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_464 * s1_464;
    // Op 465: dim1x1 add
    gl64_t s1_465 = *(gl64_t*)&expressions_params[9][8];
    tmp1_0 = tmp1_0 + s1_465;
    // Op 466: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 468: dim1x1 add
    gl64_t s0_468 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_468 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_468 + s1_468;
    // Op 469: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_471 = *(gl64_t*)&expressions_params[9][5];
    tmp3_6 = tmp3_0 + s1_471; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 472: dim3x3 add
    gl64_t s1_472_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_472_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_472_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_472_0; tmp3_1 = tmp3_7 + s1_472_1; tmp3_2 = tmp3_8 + s1_472_2;
    // Op 473: dim3x3 mul
    gl64_t kA473 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB473 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC473 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD473 = tmp3_3 * tmp3_0;
    gl64_t kE473 = tmp3_4 * tmp3_1;
    gl64_t kF473 = tmp3_5 * tmp3_2;
    gl64_t kG473 = kD473 - kE473;
    tmp3_0 = (kC473 + kG473) - kF473;
    tmp3_1 = ((((kA473 + kC473) - kE473) - kE473) - kD473);
    tmp3_2 = kB473 - kG473;
    // Op 474: dim3x3 mul
    gl64_t s0_474_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_474_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_474_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    gl64_t kA474 = (s0_474_0 + s0_474_1) * (tmp3_0 + tmp3_1);
    gl64_t kB474 = (s0_474_0 + s0_474_2) * (tmp3_0 + tmp3_2);
    gl64_t kC474 = (s0_474_1 + s0_474_2) * (tmp3_1 + tmp3_2);
    gl64_t kD474 = s0_474_0 * tmp3_0;
    gl64_t kE474 = s0_474_1 * tmp3_1;
    gl64_t kF474 = s0_474_2 * tmp3_2;
    gl64_t kG474 = kD474 - kE474;
    tmp3_0 = (kC474 + kG474) - kF474;
    tmp3_1 = ((((kA474 + kC474) - kE474) - kE474) - kD474);
    tmp3_2 = kB474 - kG474;
    // Op 475: dim1x1 sub_swap
    gl64_t s0_475 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_475 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_475 - s0_475;
    // Op 476: dim3x3 add
    gl64_t s1_476_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_476_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_476_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_476_0; tmp3_7 = tmp3_7 + s1_476_1; tmp3_8 = tmp3_8 + s1_476_2;
    // Op 477: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 478: dim1x1 sub_swap
    gl64_t s0_478 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_478 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_478 - s0_478;
    // Op 479: dim3x3 add
    gl64_t s1_479_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_479_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_479_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_479_0; tmp3_10 = tmp3_10 + s1_479_1; tmp3_11 = tmp3_11 + s1_479_2;
    // Op 480: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 481: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 482: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 483: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
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
    tmp3_3 = (kC484 + kG484) - kF484;
    tmp3_4 = ((((kA484 + kC484) - kE484) - kE484) - kD484);
    tmp3_5 = kB484 - kG484;
    // Op 485: dim3x1 mul
    gl64_t s0_485_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_485_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_485_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_485 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp3_0 = s0_485_0 * s1_485; tmp3_1 = s0_485_1 * s1_485; tmp3_2 = s0_485_2 * s1_485;
    // Op 486: dim3x1 add
    gl64_t s1_486 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_486; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 487: dim3x3 mul
    gl64_t s1_487_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_487_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_487_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA487 = (tmp3_0 + tmp3_1) * (s1_487_0 + s1_487_1);
    gl64_t kB487 = (tmp3_0 + tmp3_2) * (s1_487_0 + s1_487_2);
    gl64_t kC487 = (tmp3_1 + tmp3_2) * (s1_487_1 + s1_487_2);
    gl64_t kD487 = tmp3_0 * s1_487_0;
    gl64_t kE487 = tmp3_1 * s1_487_1;
    gl64_t kF487 = tmp3_2 * s1_487_2;
    gl64_t kG487 = kD487 - kE487;
    tmp3_0 = (kC487 + kG487) - kF487;
    tmp3_1 = ((((kA487 + kC487) - kE487) - kE487) - kD487);
    tmp3_2 = kB487 - kG487;
    // Op 488: dim3x1 add
    gl64_t s1_488 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_488; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 490: dim1x1 mul
    gl64_t s0_490 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_490 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_490 * s1_490;
    // Op 491: dim1x1 add
    gl64_t s1_491 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_491;
    // Op 492: dim1x1 add
    gl64_t s1_492 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_492;
    // Op 493: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 494: dim3x3 mul
    gl64_t s1_494_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_494_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_494_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 495: dim1x1 mul
    gl64_t s0_495 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_495 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_495 * s1_495;
    // Op 496: dim1x1 add
    gl64_t s1_496 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = tmp1_0 + s1_496;
    // Op 497: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 499: dim3x1 add
    gl64_t s1_499 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_499; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 500: dim3x3 mul
    gl64_t s1_500_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_500_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_500_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA500 = (tmp3_0 + tmp3_1) * (s1_500_0 + s1_500_1);
    gl64_t kB500 = (tmp3_0 + tmp3_2) * (s1_500_0 + s1_500_2);
    gl64_t kC500 = (tmp3_1 + tmp3_2) * (s1_500_1 + s1_500_2);
    gl64_t kD500 = tmp3_0 * s1_500_0;
    gl64_t kE500 = tmp3_1 * s1_500_1;
    gl64_t kF500 = tmp3_2 * s1_500_2;
    gl64_t kG500 = kD500 - kE500;
    tmp3_0 = (kC500 + kG500) - kF500;
    tmp3_1 = ((((kA500 + kC500) - kE500) - kE500) - kD500);
    tmp3_2 = kB500 - kG500;
    // Op 501: dim3x1 add
    gl64_t s1_501 = *(gl64_t*)&expressions_params[9][5];
    tmp3_9 = tmp3_0 + s1_501; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 502: dim3x3 add
    gl64_t s1_502_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_502_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_502_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_502_0; tmp3_13 = tmp3_10 + s1_502_1; tmp3_14 = tmp3_11 + s1_502_2;
    // Op 503: dim3x1 mul
    gl64_t s0_503_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_503_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_503_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_503 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp3_0 = s0_503_0 * s1_503; tmp3_1 = s0_503_1 * s1_503; tmp3_2 = s0_503_2 * s1_503;
    // Op 504: dim3x1 add
    gl64_t s1_504 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_504; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 506: dim3x1 add
    gl64_t s1_506 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_506; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 507: dim3x3 mul
    gl64_t s1_507_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_507_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_507_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA507 = (tmp3_0 + tmp3_1) * (s1_507_0 + s1_507_1);
    gl64_t kB507 = (tmp3_0 + tmp3_2) * (s1_507_0 + s1_507_2);
    gl64_t kC507 = (tmp3_1 + tmp3_2) * (s1_507_1 + s1_507_2);
    gl64_t kD507 = tmp3_0 * s1_507_0;
    gl64_t kE507 = tmp3_1 * s1_507_1;
    gl64_t kF507 = tmp3_2 * s1_507_2;
    gl64_t kG507 = kD507 - kE507;
    tmp3_0 = (kC507 + kG507) - kF507;
    tmp3_1 = ((((kA507 + kC507) - kE507) - kE507) - kD507);
    tmp3_2 = kB507 - kG507;
    // Op 508: dim1x1 mul
    gl64_t s0_508 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_508 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_508 * s1_508;
    // Op 509: dim1x1 add
    gl64_t s1_509 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_509;
    // Op 510: dim1x1 add
    gl64_t s0_510 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_510 + tmp1_0;
    // Op 511: dim1x1 add
    gl64_t s1_511 = *(gl64_t*)&expressions_params[9][4];
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
    // Op 514: dim1x1 mul
    gl64_t s0_514 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_514 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_514 * s1_514;
    // Op 515: dim1x1 add
    gl64_t s1_515 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = tmp1_0 + s1_515;
    // Op 516: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 517: dim3x3 mul
    gl64_t s1_517_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_517_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_517_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA517 = (tmp3_0 + tmp3_1) * (s1_517_0 + s1_517_1);
    gl64_t kB517 = (tmp3_0 + tmp3_2) * (s1_517_0 + s1_517_2);
    gl64_t kC517 = (tmp3_1 + tmp3_2) * (s1_517_1 + s1_517_2);
    gl64_t kD517 = tmp3_0 * s1_517_0;
    gl64_t kE517 = tmp3_1 * s1_517_1;
    gl64_t kF517 = tmp3_2 * s1_517_2;
    gl64_t kG517 = kD517 - kE517;
    tmp3_0 = (kC517 + kG517) - kF517;
    tmp3_1 = ((((kA517 + kC517) - kE517) - kE517) - kD517);
    tmp3_2 = kB517 - kG517;
    // Op 518: dim1x1 add
    gl64_t s0_518 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_518 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_518 + s1_518;
    // Op 519: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 520: dim3x3 mul
    gl64_t s1_520_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_520_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_520_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA520 = (tmp3_0 + tmp3_1) * (s1_520_0 + s1_520_1);
    gl64_t kB520 = (tmp3_0 + tmp3_2) * (s1_520_0 + s1_520_2);
    gl64_t kC520 = (tmp3_1 + tmp3_2) * (s1_520_1 + s1_520_2);
    gl64_t kD520 = tmp3_0 * s1_520_0;
    gl64_t kE520 = tmp3_1 * s1_520_1;
    gl64_t kF520 = tmp3_2 * s1_520_2;
    gl64_t kG520 = kD520 - kE520;
    tmp3_0 = (kC520 + kG520) - kF520;
    tmp3_1 = ((((kA520 + kC520) - kE520) - kE520) - kD520);
    tmp3_2 = kB520 - kG520;
    // Op 521: dim3x1 add
    gl64_t s1_521 = *(gl64_t*)&expressions_params[9][5];
    tmp3_6 = tmp3_0 + s1_521; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 522: dim3x3 add
    gl64_t s1_522_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_522_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_522_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_522_0; tmp3_1 = tmp3_7 + s1_522_1; tmp3_2 = tmp3_8 + s1_522_2;
    // Op 523: dim3x3 mul
    gl64_t kA523 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB523 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC523 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD523 = tmp3_12 * tmp3_0;
    gl64_t kE523 = tmp3_13 * tmp3_1;
    gl64_t kF523 = tmp3_14 * tmp3_2;
    gl64_t kG523 = kD523 - kE523;
    tmp3_0 = (kC523 + kG523) - kF523;
    tmp3_1 = ((((kA523 + kC523) - kE523) - kE523) - kD523);
    tmp3_2 = kB523 - kG523;
    // Op 524: dim3x3 mul
    gl64_t s0_524_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+0, domainSize, nCols_2))];
    gl64_t s0_524_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+1, domainSize, nCols_2))];
    gl64_t s0_524_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+2, domainSize, nCols_2))];
    gl64_t kA524 = (s0_524_0 + s0_524_1) * (tmp3_0 + tmp3_1);
    gl64_t kB524 = (s0_524_0 + s0_524_2) * (tmp3_0 + tmp3_2);
    gl64_t kC524 = (s0_524_1 + s0_524_2) * (tmp3_1 + tmp3_2);
    gl64_t kD524 = s0_524_0 * tmp3_0;
    gl64_t kE524 = s0_524_1 * tmp3_1;
    gl64_t kF524 = s0_524_2 * tmp3_2;
    gl64_t kG524 = kD524 - kE524;
    tmp3_0 = (kC524 + kG524) - kF524;
    tmp3_1 = ((((kA524 + kC524) - kE524) - kE524) - kD524);
    tmp3_2 = kB524 - kG524;
    // Op 525: dim1x1 sub_swap
    gl64_t s0_525 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_525 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_525 - s0_525;
    // Op 526: dim3x3 add
    gl64_t s1_526_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_526_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_526_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_526_0; tmp3_7 = tmp3_7 + s1_526_1; tmp3_8 = tmp3_8 + s1_526_2;
    // Op 527: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 528: dim1x1 sub_swap
    gl64_t s0_528 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_528 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_528 - s0_528;
    // Op 529: dim3x3 add
    gl64_t s1_529_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_529_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_529_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_529_0; tmp3_10 = tmp3_10 + s1_529_1; tmp3_11 = tmp3_11 + s1_529_2;
    // Op 530: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 531: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 532: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 533: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 534: dim3x3 mul
    gl64_t s1_534_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_534_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_534_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA534 = (tmp3_0 + tmp3_1) * (s1_534_0 + s1_534_1);
    gl64_t kB534 = (tmp3_0 + tmp3_2) * (s1_534_0 + s1_534_2);
    gl64_t kC534 = (tmp3_1 + tmp3_2) * (s1_534_1 + s1_534_2);
    gl64_t kD534 = tmp3_0 * s1_534_0;
    gl64_t kE534 = tmp3_1 * s1_534_1;
    gl64_t kF534 = tmp3_2 * s1_534_2;
    gl64_t kG534 = kD534 - kE534;
    tmp3_12 = (kC534 + kG534) - kF534;
    tmp3_13 = ((((kA534 + kC534) - kE534) - kE534) - kD534);
    tmp3_14 = kB534 - kG534;
    // Op 535: dim3x1 mul
    gl64_t s0_535_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_535_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_535_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_535 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp3_0 = s0_535_0 * s1_535; tmp3_1 = s0_535_1 * s1_535; tmp3_2 = s0_535_2 * s1_535;
    // Op 536: dim3x1 add
    gl64_t s1_536 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_536; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 538: dim3x1 add
    gl64_t s1_538 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_538; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 539: dim3x3 mul
    gl64_t s1_539_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_539_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_539_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA539 = (tmp3_0 + tmp3_1) * (s1_539_0 + s1_539_1);
    gl64_t kB539 = (tmp3_0 + tmp3_2) * (s1_539_0 + s1_539_2);
    gl64_t kC539 = (tmp3_1 + tmp3_2) * (s1_539_1 + s1_539_2);
    gl64_t kD539 = tmp3_0 * s1_539_0;
    gl64_t kE539 = tmp3_1 * s1_539_1;
    gl64_t kF539 = tmp3_2 * s1_539_2;
    gl64_t kG539 = kD539 - kE539;
    tmp3_0 = (kC539 + kG539) - kF539;
    tmp3_1 = ((((kA539 + kC539) - kE539) - kE539) - kD539);
    tmp3_2 = kB539 - kG539;
    // Op 540: dim1x1 mul
    gl64_t s0_540 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_540 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_540 * s1_540;
    // Op 541: dim1x1 add
    gl64_t s1_541 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_541;
    // Op 542: dim1x1 add
    gl64_t s1_542 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_542;
    // Op 543: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 544: dim3x3 mul
    gl64_t s1_544_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_544_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_544_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA544 = (tmp3_0 + tmp3_1) * (s1_544_0 + s1_544_1);
    gl64_t kB544 = (tmp3_0 + tmp3_2) * (s1_544_0 + s1_544_2);
    gl64_t kC544 = (tmp3_1 + tmp3_2) * (s1_544_1 + s1_544_2);
    gl64_t kD544 = tmp3_0 * s1_544_0;
    gl64_t kE544 = tmp3_1 * s1_544_1;
    gl64_t kF544 = tmp3_2 * s1_544_2;
    gl64_t kG544 = kD544 - kE544;
    tmp3_0 = (kC544 + kG544) - kF544;
    tmp3_1 = ((((kA544 + kC544) - kE544) - kE544) - kD544);
    tmp3_2 = kB544 - kG544;
    // Op 545: dim1x1 mul
    gl64_t s0_545 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_545 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_545 * s1_545;
    // Op 546: dim1x1 add
    gl64_t s1_546 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = tmp1_0 + s1_546;
    // Op 547: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 548: dim3x3 mul
    gl64_t s1_548_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_548_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_548_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA548 = (tmp3_0 + tmp3_1) * (s1_548_0 + s1_548_1);
    gl64_t kB548 = (tmp3_0 + tmp3_2) * (s1_548_0 + s1_548_2);
    gl64_t kC548 = (tmp3_1 + tmp3_2) * (s1_548_1 + s1_548_2);
    gl64_t kD548 = tmp3_0 * s1_548_0;
    gl64_t kE548 = tmp3_1 * s1_548_1;
    gl64_t kF548 = tmp3_2 * s1_548_2;
    gl64_t kG548 = kD548 - kE548;
    tmp3_0 = (kC548 + kG548) - kF548;
    tmp3_1 = ((((kA548 + kC548) - kE548) - kE548) - kD548);
    tmp3_2 = kB548 - kG548;
    // Op 549: dim3x1 add
    gl64_t s1_549 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_549; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 551: dim3x1 add
    gl64_t s1_551 = *(gl64_t*)&expressions_params[9][5];
    tmp3_9 = tmp3_0 + s1_551; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 552: dim3x3 add
    gl64_t s1_552_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_552_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_552_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_552_0; tmp3_4 = tmp3_10 + s1_552_1; tmp3_5 = tmp3_11 + s1_552_2;
    // Op 553: dim3x1 mul
    gl64_t s0_553_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_553_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_553_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_553 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp3_0 = s0_553_0 * s1_553; tmp3_1 = s0_553_1 * s1_553; tmp3_2 = s0_553_2 * s1_553;
    // Op 554: dim3x1 add
    gl64_t s1_554 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_554; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 555: dim3x3 mul
    gl64_t s1_555_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_555_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_555_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA555 = (tmp3_0 + tmp3_1) * (s1_555_0 + s1_555_1);
    gl64_t kB555 = (tmp3_0 + tmp3_2) * (s1_555_0 + s1_555_2);
    gl64_t kC555 = (tmp3_1 + tmp3_2) * (s1_555_1 + s1_555_2);
    gl64_t kD555 = tmp3_0 * s1_555_0;
    gl64_t kE555 = tmp3_1 * s1_555_1;
    gl64_t kF555 = tmp3_2 * s1_555_2;
    gl64_t kG555 = kD555 - kE555;
    tmp3_0 = (kC555 + kG555) - kF555;
    tmp3_1 = ((((kA555 + kC555) - kE555) - kE555) - kD555);
    tmp3_2 = kB555 - kG555;
    // Op 556: dim3x1 add
    gl64_t s1_556 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_556; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 557: dim3x3 mul
    gl64_t s1_557_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_557_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_557_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA557 = (tmp3_0 + tmp3_1) * (s1_557_0 + s1_557_1);
    gl64_t kB557 = (tmp3_0 + tmp3_2) * (s1_557_0 + s1_557_2);
    gl64_t kC557 = (tmp3_1 + tmp3_2) * (s1_557_1 + s1_557_2);
    gl64_t kD557 = tmp3_0 * s1_557_0;
    gl64_t kE557 = tmp3_1 * s1_557_1;
    gl64_t kF557 = tmp3_2 * s1_557_2;
    gl64_t kG557 = kD557 - kE557;
    tmp3_0 = (kC557 + kG557) - kF557;
    tmp3_1 = ((((kA557 + kC557) - kE557) - kE557) - kD557);
    tmp3_2 = kB557 - kG557;
    // Op 558: dim1x1 mul
    gl64_t s0_558 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_558 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_558 * s1_558;
    // Op 559: dim1x1 add
    gl64_t s1_559 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_559;
    // Op 560: dim1x1 add
    gl64_t s0_560 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_560 + tmp1_0;
    // Op 561: dim1x1 add
    gl64_t s1_561 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_561;
    // Op 562: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 563: dim3x3 mul
    gl64_t s1_563_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_563_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_563_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA563 = (tmp3_0 + tmp3_1) * (s1_563_0 + s1_563_1);
    gl64_t kB563 = (tmp3_0 + tmp3_2) * (s1_563_0 + s1_563_2);
    gl64_t kC563 = (tmp3_1 + tmp3_2) * (s1_563_1 + s1_563_2);
    gl64_t kD563 = tmp3_0 * s1_563_0;
    gl64_t kE563 = tmp3_1 * s1_563_1;
    gl64_t kF563 = tmp3_2 * s1_563_2;
    gl64_t kG563 = kD563 - kE563;
    tmp3_0 = (kC563 + kG563) - kF563;
    tmp3_1 = ((((kA563 + kC563) - kE563) - kE563) - kD563);
    tmp3_2 = kB563 - kG563;
    // Op 564: dim1x1 mul
    gl64_t s0_564 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_564 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_564 * s1_564;
    // Op 565: dim1x1 add
    gl64_t s1_565 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = tmp1_0 + s1_565;
    // Op 566: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 567: dim3x3 mul
    gl64_t s1_567_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_567_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_567_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA567 = (tmp3_0 + tmp3_1) * (s1_567_0 + s1_567_1);
    gl64_t kB567 = (tmp3_0 + tmp3_2) * (s1_567_0 + s1_567_2);
    gl64_t kC567 = (tmp3_1 + tmp3_2) * (s1_567_1 + s1_567_2);
    gl64_t kD567 = tmp3_0 * s1_567_0;
    gl64_t kE567 = tmp3_1 * s1_567_1;
    gl64_t kF567 = tmp3_2 * s1_567_2;
    gl64_t kG567 = kD567 - kE567;
    tmp3_0 = (kC567 + kG567) - kF567;
    tmp3_1 = ((((kA567 + kC567) - kE567) - kE567) - kD567);
    tmp3_2 = kB567 - kG567;
    // Op 568: dim1x1 add
    gl64_t s0_568 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_568 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_568 + s1_568;
    // Op 569: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 570: dim3x3 mul
    gl64_t s1_570_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_570_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_570_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA570 = (tmp3_0 + tmp3_1) * (s1_570_0 + s1_570_1);
    gl64_t kB570 = (tmp3_0 + tmp3_2) * (s1_570_0 + s1_570_2);
    gl64_t kC570 = (tmp3_1 + tmp3_2) * (s1_570_1 + s1_570_2);
    gl64_t kD570 = tmp3_0 * s1_570_0;
    gl64_t kE570 = tmp3_1 * s1_570_1;
    gl64_t kF570 = tmp3_2 * s1_570_2;
    gl64_t kG570 = kD570 - kE570;
    tmp3_0 = (kC570 + kG570) - kF570;
    tmp3_1 = ((((kA570 + kC570) - kE570) - kE570) - kD570);
    tmp3_2 = kB570 - kG570;
    // Op 571: dim3x1 add
    gl64_t s1_571 = *(gl64_t*)&expressions_params[9][5];
    tmp3_6 = tmp3_0 + s1_571; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 572: dim3x3 add
    gl64_t s1_572_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_572_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_572_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_572_0; tmp3_1 = tmp3_7 + s1_572_1; tmp3_2 = tmp3_8 + s1_572_2;
    // Op 573: dim3x3 mul
    gl64_t kA573 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB573 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC573 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD573 = tmp3_3 * tmp3_0;
    gl64_t kE573 = tmp3_4 * tmp3_1;
    gl64_t kF573 = tmp3_5 * tmp3_2;
    gl64_t kG573 = kD573 - kE573;
    tmp3_0 = (kC573 + kG573) - kF573;
    tmp3_1 = ((((kA573 + kC573) - kE573) - kE573) - kD573);
    tmp3_2 = kB573 - kG573;
    // Op 574: dim3x3 mul
    uint64_t s0_574_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_2));
    gl64_t s0_574_0 = *(gl64_t*)&dParams->aux_trace[s0_574_pos];
    gl64_t s0_574_1 = *(gl64_t*)&dParams->aux_trace[s0_574_pos + TILE_HEIGHT];
    gl64_t s0_574_2 = *(gl64_t*)&dParams->aux_trace[s0_574_pos + 2*TILE_HEIGHT];
    gl64_t kA574 = (s0_574_0 + s0_574_1) * (tmp3_0 + tmp3_1);
    gl64_t kB574 = (s0_574_0 + s0_574_2) * (tmp3_0 + tmp3_2);
    gl64_t kC574 = (s0_574_1 + s0_574_2) * (tmp3_1 + tmp3_2);
    gl64_t kD574 = s0_574_0 * tmp3_0;
    gl64_t kE574 = s0_574_1 * tmp3_1;
    gl64_t kF574 = s0_574_2 * tmp3_2;
    gl64_t kG574 = kD574 - kE574;
    tmp3_0 = (kC574 + kG574) - kF574;
    tmp3_1 = ((((kA574 + kC574) - kE574) - kE574) - kD574);
    tmp3_2 = kB574 - kG574;
    // Op 575: dim1x1 sub_swap
    gl64_t s0_575 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_575 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_575 - s0_575;
    // Op 576: dim3x3 add
    gl64_t s1_576_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_576_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_576_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_576_0; tmp3_7 = tmp3_7 + s1_576_1; tmp3_8 = tmp3_8 + s1_576_2;
    // Op 577: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 578: dim1x1 sub_swap
    gl64_t s0_578 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_578 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_578 - s0_578;
    // Op 579: dim3x3 add
    gl64_t s1_579_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_579_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_579_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_579_0; tmp3_10 = tmp3_10 + s1_579_1; tmp3_11 = tmp3_11 + s1_579_2;
    // Op 580: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 581: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 582: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 583: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 584: dim3x3 mul
    gl64_t s1_584_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_584_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_584_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA584 = (tmp3_0 + tmp3_1) * (s1_584_0 + s1_584_1);
    gl64_t kB584 = (tmp3_0 + tmp3_2) * (s1_584_0 + s1_584_2);
    gl64_t kC584 = (tmp3_1 + tmp3_2) * (s1_584_1 + s1_584_2);
    gl64_t kD584 = tmp3_0 * s1_584_0;
    gl64_t kE584 = tmp3_1 * s1_584_1;
    gl64_t kF584 = tmp3_2 * s1_584_2;
    gl64_t kG584 = kD584 - kE584;
    tmp3_3 = (kC584 + kG584) - kF584;
    tmp3_4 = ((((kA584 + kC584) - kE584) - kE584) - kD584);
    tmp3_5 = kB584 - kG584;
    // Op 585: dim3x1 mul
    gl64_t s0_585_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_585_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_585_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_585 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    tmp3_0 = s0_585_0 * s1_585; tmp3_1 = s0_585_1 * s1_585; tmp3_2 = s0_585_2 * s1_585;
    // Op 586: dim3x1 add
    gl64_t s1_586 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
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
    gl64_t s1_588 = *(gl64_t*)&expressions_params[9][2];
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
    // Op 590: dim1x1 mul
    gl64_t s0_590 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_590 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_590 * s1_590;
    // Op 591: dim1x1 add
    gl64_t s1_591 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_591;
    // Op 592: dim1x1 add
    gl64_t s1_592 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_592;
    // Op 593: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 594: dim3x3 mul
    gl64_t s1_594_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_594_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_594_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA594 = (tmp3_0 + tmp3_1) * (s1_594_0 + s1_594_1);
    gl64_t kB594 = (tmp3_0 + tmp3_2) * (s1_594_0 + s1_594_2);
    gl64_t kC594 = (tmp3_1 + tmp3_2) * (s1_594_1 + s1_594_2);
    gl64_t kD594 = tmp3_0 * s1_594_0;
    gl64_t kE594 = tmp3_1 * s1_594_1;
    gl64_t kF594 = tmp3_2 * s1_594_2;
    gl64_t kG594 = kD594 - kE594;
    tmp3_0 = (kC594 + kG594) - kF594;
    tmp3_1 = ((((kA594 + kC594) - kE594) - kE594) - kD594);
    tmp3_2 = kB594 - kG594;
    // Op 595: dim1x1 mul
    gl64_t s0_595 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_595 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_595 * s1_595;
    // Op 596: dim1x1 add
    gl64_t s1_596 = *(gl64_t*)&expressions_params[9][11];
    tmp1_0 = tmp1_0 + s1_596;
    // Op 597: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 598: dim3x3 mul
    gl64_t s1_598_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_598_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_598_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA598 = (tmp3_0 + tmp3_1) * (s1_598_0 + s1_598_1);
    gl64_t kB598 = (tmp3_0 + tmp3_2) * (s1_598_0 + s1_598_2);
    gl64_t kC598 = (tmp3_1 + tmp3_2) * (s1_598_1 + s1_598_2);
    gl64_t kD598 = tmp3_0 * s1_598_0;
    gl64_t kE598 = tmp3_1 * s1_598_1;
    gl64_t kF598 = tmp3_2 * s1_598_2;
    gl64_t kG598 = kD598 - kE598;
    tmp3_0 = (kC598 + kG598) - kF598;
    tmp3_1 = ((((kA598 + kC598) - kE598) - kE598) - kD598);
    tmp3_2 = kB598 - kG598;
    // Op 599: dim3x1 add
    gl64_t s1_599 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_599; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 600: dim3x3 mul
    gl64_t s1_600_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_600_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_600_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA600 = (tmp3_0 + tmp3_1) * (s1_600_0 + s1_600_1);
    gl64_t kB600 = (tmp3_0 + tmp3_2) * (s1_600_0 + s1_600_2);
    gl64_t kC600 = (tmp3_1 + tmp3_2) * (s1_600_1 + s1_600_2);
    gl64_t kD600 = tmp3_0 * s1_600_0;
    gl64_t kE600 = tmp3_1 * s1_600_1;
    gl64_t kF600 = tmp3_2 * s1_600_2;
    gl64_t kG600 = kD600 - kE600;
    tmp3_0 = (kC600 + kG600) - kF600;
    tmp3_1 = ((((kA600 + kC600) - kE600) - kE600) - kD600);
    tmp3_2 = kB600 - kG600;
    // Op 601: dim3x1 add
    gl64_t s1_601 = *(gl64_t*)&expressions_params[9][5];
    tmp3_9 = tmp3_0 + s1_601; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 602: dim3x3 add
    gl64_t s1_602_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_602_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_602_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_602_0; tmp3_13 = tmp3_10 + s1_602_1; tmp3_14 = tmp3_11 + s1_602_2;
    // Op 603: dim3x1 mul
    gl64_t s0_603_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_603_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_603_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_603 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    tmp3_0 = s0_603_0 * s1_603; tmp3_1 = s0_603_1 * s1_603; tmp3_2 = s0_603_2 * s1_603;
    // Op 604: dim3x1 add
    gl64_t s1_604 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
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
    gl64_t s1_606 = *(gl64_t*)&expressions_params[9][2];
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
    // Op 608: dim1x1 mul
    gl64_t s0_608 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_608 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_608 * s1_608;
    // Op 609: dim1x1 add
    gl64_t s1_609 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_609;
    // Op 610: dim1x1 add
    gl64_t s0_610 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_610 + tmp1_0;
    // Op 611: dim1x1 add
    gl64_t s1_611 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_611;
    // Op 612: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 613: dim3x3 mul
    gl64_t s1_613_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_613_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_613_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA613 = (tmp3_0 + tmp3_1) * (s1_613_0 + s1_613_1);
    gl64_t kB613 = (tmp3_0 + tmp3_2) * (s1_613_0 + s1_613_2);
    gl64_t kC613 = (tmp3_1 + tmp3_2) * (s1_613_1 + s1_613_2);
    gl64_t kD613 = tmp3_0 * s1_613_0;
    gl64_t kE613 = tmp3_1 * s1_613_1;
    gl64_t kF613 = tmp3_2 * s1_613_2;
    gl64_t kG613 = kD613 - kE613;
    tmp3_0 = (kC613 + kG613) - kF613;
    tmp3_1 = ((((kA613 + kC613) - kE613) - kE613) - kD613);
    tmp3_2 = kB613 - kG613;
    // Op 614: dim1x1 mul
    gl64_t s0_614 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_614 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_614 * s1_614;
    // Op 615: dim1x1 add
    gl64_t s1_615 = *(gl64_t*)&expressions_params[9][11];
    tmp1_0 = tmp1_0 + s1_615;
    // Op 616: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 617: dim3x3 mul
    gl64_t s1_617_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_617_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_617_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 618: dim1x1 add
    gl64_t s0_618 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_618 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_618 + s1_618;
    // Op 619: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 620: dim3x3 mul
    gl64_t s1_620_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_620_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_620_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA620 = (tmp3_0 + tmp3_1) * (s1_620_0 + s1_620_1);
    gl64_t kB620 = (tmp3_0 + tmp3_2) * (s1_620_0 + s1_620_2);
    gl64_t kC620 = (tmp3_1 + tmp3_2) * (s1_620_1 + s1_620_2);
    gl64_t kD620 = tmp3_0 * s1_620_0;
    gl64_t kE620 = tmp3_1 * s1_620_1;
    gl64_t kF620 = tmp3_2 * s1_620_2;
    gl64_t kG620 = kD620 - kE620;
    tmp3_0 = (kC620 + kG620) - kF620;
    tmp3_1 = ((((kA620 + kC620) - kE620) - kE620) - kD620);
    tmp3_2 = kB620 - kG620;
    // Op 621: dim3x1 add
    gl64_t s1_621 = *(gl64_t*)&expressions_params[9][5];
    tmp3_6 = tmp3_0 + s1_621; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 622: dim3x3 add
    gl64_t s1_622_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_622_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_622_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_622_0; tmp3_1 = tmp3_7 + s1_622_1; tmp3_2 = tmp3_8 + s1_622_2;
    // Op 623: dim3x3 mul
    gl64_t kA623 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB623 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC623 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD623 = tmp3_12 * tmp3_0;
    gl64_t kE623 = tmp3_13 * tmp3_1;
    gl64_t kF623 = tmp3_14 * tmp3_2;
    gl64_t kG623 = kD623 - kE623;
    tmp3_0 = (kC623 + kG623) - kF623;
    tmp3_1 = ((((kA623 + kC623) - kE623) - kE623) - kD623);
    tmp3_2 = kB623 - kG623;
    // Op 624: dim3x3 mul
    uint64_t s0_624_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_2));
    gl64_t s0_624_0 = *(gl64_t*)&dParams->aux_trace[s0_624_pos];
    gl64_t s0_624_1 = *(gl64_t*)&dParams->aux_trace[s0_624_pos + TILE_HEIGHT];
    gl64_t s0_624_2 = *(gl64_t*)&dParams->aux_trace[s0_624_pos + 2*TILE_HEIGHT];
    gl64_t kA624 = (s0_624_0 + s0_624_1) * (tmp3_0 + tmp3_1);
    gl64_t kB624 = (s0_624_0 + s0_624_2) * (tmp3_0 + tmp3_2);
    gl64_t kC624 = (s0_624_1 + s0_624_2) * (tmp3_1 + tmp3_2);
    gl64_t kD624 = s0_624_0 * tmp3_0;
    gl64_t kE624 = s0_624_1 * tmp3_1;
    gl64_t kF624 = s0_624_2 * tmp3_2;
    gl64_t kG624 = kD624 - kE624;
    tmp3_0 = (kC624 + kG624) - kF624;
    tmp3_1 = ((((kA624 + kC624) - kE624) - kE624) - kD624);
    tmp3_2 = kB624 - kG624;
    // Op 625: dim1x1 sub_swap
    gl64_t s0_625 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_625 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_625 - s0_625;
    // Op 626: dim3x3 add
    gl64_t s1_626_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_626_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_626_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_626_0; tmp3_7 = tmp3_7 + s1_626_1; tmp3_8 = tmp3_8 + s1_626_2;
    // Op 627: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 628: dim1x1 sub_swap
    gl64_t s0_628 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_628 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_628 - s0_628;
    // Op 629: dim3x3 add
    gl64_t s1_629_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_629_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_629_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_629_0; tmp3_10 = tmp3_10 + s1_629_1; tmp3_11 = tmp3_11 + s1_629_2;
    // Op 630: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 631: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 632: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 633: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 634: dim3x3 mul
    gl64_t s1_634_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_634_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_634_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA634 = (tmp3_0 + tmp3_1) * (s1_634_0 + s1_634_1);
    gl64_t kB634 = (tmp3_0 + tmp3_2) * (s1_634_0 + s1_634_2);
    gl64_t kC634 = (tmp3_1 + tmp3_2) * (s1_634_1 + s1_634_2);
    gl64_t kD634 = tmp3_0 * s1_634_0;
    gl64_t kE634 = tmp3_1 * s1_634_1;
    gl64_t kF634 = tmp3_2 * s1_634_2;
    gl64_t kG634 = kD634 - kE634;
    tmp3_3 = (kC634 + kG634) - kF634;
    tmp3_4 = ((((kA634 + kC634) - kE634) - kE634) - kD634);
    tmp3_5 = kB634 - kG634;
    // Op 635: dim1x1 mul
    gl64_t s0_635 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_635 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_635 * s1_635;
    // Op 636: dim1x1 sub
    gl64_t s0_636 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_636 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_3 = s0_636 - s1_636;
    // Op 637: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_3;
    // Op 638: dim3x1 mul
    gl64_t s0_638_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_638_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_638_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_638_0 * tmp1_0; tmp3_1 = s0_638_1 * tmp1_0; tmp3_2 = s0_638_2 * tmp1_0;
    // Op 639: dim3x1 add
    gl64_t s1_639 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_639; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 641: dim3x3 mul
    gl64_t s1_641_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_641_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_641_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA641 = (tmp3_0 + tmp3_1) * (s1_641_0 + s1_641_1);
    gl64_t kB641 = (tmp3_0 + tmp3_2) * (s1_641_0 + s1_641_2);
    gl64_t kC641 = (tmp3_1 + tmp3_2) * (s1_641_1 + s1_641_2);
    gl64_t kD641 = tmp3_0 * s1_641_0;
    gl64_t kE641 = tmp3_1 * s1_641_1;
    gl64_t kF641 = tmp3_2 * s1_641_2;
    gl64_t kG641 = kD641 - kE641;
    tmp3_0 = (kC641 + kG641) - kF641;
    tmp3_1 = ((((kA641 + kC641) - kE641) - kE641) - kD641);
    tmp3_2 = kB641 - kG641;
    // Op 642: dim3x3 mul
    gl64_t s1_642_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_642_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_642_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA642 = (tmp3_0 + tmp3_1) * (s1_642_0 + s1_642_1);
    gl64_t kB642 = (tmp3_0 + tmp3_2) * (s1_642_0 + s1_642_2);
    gl64_t kC642 = (tmp3_1 + tmp3_2) * (s1_642_1 + s1_642_2);
    gl64_t kD642 = tmp3_0 * s1_642_0;
    gl64_t kE642 = tmp3_1 * s1_642_1;
    gl64_t kF642 = tmp3_2 * s1_642_2;
    gl64_t kG642 = kD642 - kE642;
    tmp3_0 = (kC642 + kG642) - kF642;
    tmp3_1 = ((((kA642 + kC642) - kE642) - kE642) - kD642);
    tmp3_2 = kB642 - kG642;
    // Op 643: dim1x1 mul
    gl64_t s0_643 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_643 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_643 * s1_643;
    // Op 644: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 645: dim3x3 mul
    gl64_t s1_645_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_645_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_645_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA645 = (tmp3_0 + tmp3_1) * (s1_645_0 + s1_645_1);
    gl64_t kB645 = (tmp3_0 + tmp3_2) * (s1_645_0 + s1_645_2);
    gl64_t kC645 = (tmp3_1 + tmp3_2) * (s1_645_1 + s1_645_2);
    gl64_t kD645 = tmp3_0 * s1_645_0;
    gl64_t kE645 = tmp3_1 * s1_645_1;
    gl64_t kF645 = tmp3_2 * s1_645_2;
    gl64_t kG645 = kD645 - kE645;
    tmp3_0 = (kC645 + kG645) - kF645;
    tmp3_1 = ((((kA645 + kC645) - kE645) - kE645) - kD645);
    tmp3_2 = kB645 - kG645;
    // Op 646: dim3x3 mul
    gl64_t s1_646_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_646_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_646_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA646 = (tmp3_0 + tmp3_1) * (s1_646_0 + s1_646_1);
    gl64_t kB646 = (tmp3_0 + tmp3_2) * (s1_646_0 + s1_646_2);
    gl64_t kC646 = (tmp3_1 + tmp3_2) * (s1_646_1 + s1_646_2);
    gl64_t kD646 = tmp3_0 * s1_646_0;
    gl64_t kE646 = tmp3_1 * s1_646_1;
    gl64_t kF646 = tmp3_2 * s1_646_2;
    gl64_t kG646 = kD646 - kE646;
    tmp3_0 = (kC646 + kG646) - kF646;
    tmp3_1 = ((((kA646 + kC646) - kE646) - kE646) - kD646);
    tmp3_2 = kB646 - kG646;
    // Op 647: dim1x1 mul
    gl64_t s0_647 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_647 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_647 * s1_647;
    // Op 648: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 649: dim3x3 mul
    gl64_t s1_649_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_649_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_649_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 650: dim3x3 mul
    gl64_t s1_650_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_650_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_650_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA650 = (tmp3_0 + tmp3_1) * (s1_650_0 + s1_650_1);
    gl64_t kB650 = (tmp3_0 + tmp3_2) * (s1_650_0 + s1_650_2);
    gl64_t kC650 = (tmp3_1 + tmp3_2) * (s1_650_1 + s1_650_2);
    gl64_t kD650 = tmp3_0 * s1_650_0;
    gl64_t kE650 = tmp3_1 * s1_650_1;
    gl64_t kF650 = tmp3_2 * s1_650_2;
    gl64_t kG650 = kD650 - kE650;
    tmp3_0 = (kC650 + kG650) - kF650;
    tmp3_1 = ((((kA650 + kC650) - kE650) - kE650) - kD650);
    tmp3_2 = kB650 - kG650;
    // Op 651: dim1x1 mul
    gl64_t s0_651 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_651 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_651 * s1_651;
    // Op 652: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 653: dim3x3 mul
    gl64_t s1_653_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_653_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_653_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA653 = (tmp3_0 + tmp3_1) * (s1_653_0 + s1_653_1);
    gl64_t kB653 = (tmp3_0 + tmp3_2) * (s1_653_0 + s1_653_2);
    gl64_t kC653 = (tmp3_1 + tmp3_2) * (s1_653_1 + s1_653_2);
    gl64_t kD653 = tmp3_0 * s1_653_0;
    gl64_t kE653 = tmp3_1 * s1_653_1;
    gl64_t kF653 = tmp3_2 * s1_653_2;
    gl64_t kG653 = kD653 - kE653;
    tmp3_0 = (kC653 + kG653) - kF653;
    tmp3_1 = ((((kA653 + kC653) - kE653) - kE653) - kD653);
    tmp3_2 = kB653 - kG653;
    // Op 654: dim1x1 mul
    gl64_t s0_654 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_654 = *(gl64_t*)&expressions_params[9][12];
    tmp1_0 = s0_654 * s1_654;
    // Op 655: dim1x1 mul
    gl64_t s0_655 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_655 = *(gl64_t*)&expressions_params[9][13];
    tmp1_3 = s0_655 * s1_655;
    // Op 656: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 657: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 658: dim3x3 mul
    gl64_t s1_658_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_658_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_658_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA658 = (tmp3_0 + tmp3_1) * (s1_658_0 + s1_658_1);
    gl64_t kB658 = (tmp3_0 + tmp3_2) * (s1_658_0 + s1_658_2);
    gl64_t kC658 = (tmp3_1 + tmp3_2) * (s1_658_1 + s1_658_2);
    gl64_t kD658 = tmp3_0 * s1_658_0;
    gl64_t kE658 = tmp3_1 * s1_658_1;
    gl64_t kF658 = tmp3_2 * s1_658_2;
    gl64_t kG658 = kD658 - kE658;
    tmp3_0 = (kC658 + kG658) - kF658;
    tmp3_1 = ((((kA658 + kC658) - kE658) - kE658) - kD658);
    tmp3_2 = kB658 - kG658;
    // Op 659: dim3x1 add
    gl64_t s1_659 = *(gl64_t*)&expressions_params[9][14];
    tmp3_0 = tmp3_0 + s1_659; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 660: dim3x3 add
    gl64_t s1_660_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_660_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_660_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_660_0; tmp3_1 = tmp3_1 + s1_660_1; tmp3_2 = tmp3_2 + s1_660_2;
    // Op 661: dim3x3 mul
    gl64_t s0_661_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+0, domainSize, nCols_2))];
    gl64_t s0_661_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+1, domainSize, nCols_2))];
    gl64_t s0_661_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+2, domainSize, nCols_2))];
    gl64_t kA661 = (s0_661_0 + s0_661_1) * (tmp3_0 + tmp3_1);
    gl64_t kB661 = (s0_661_0 + s0_661_2) * (tmp3_0 + tmp3_2);
    gl64_t kC661 = (s0_661_1 + s0_661_2) * (tmp3_1 + tmp3_2);
    gl64_t kD661 = s0_661_0 * tmp3_0;
    gl64_t kE661 = s0_661_1 * tmp3_1;
    gl64_t kF661 = s0_661_2 * tmp3_2;
    gl64_t kG661 = kD661 - kE661;
    tmp3_0 = (kC661 + kG661) - kF661;
    tmp3_1 = ((((kA661 + kC661) - kE661) - kE661) - kD661);
    tmp3_2 = kB661 - kG661;
    // Op 662: dim3x1 sub
    gl64_t s1_662 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 - s1_662; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 663: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 664: dim3x3 mul
    gl64_t s1_664_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_664_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_664_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA664 = (tmp3_0 + tmp3_1) * (s1_664_0 + s1_664_1);
    gl64_t kB664 = (tmp3_0 + tmp3_2) * (s1_664_0 + s1_664_2);
    gl64_t kC664 = (tmp3_1 + tmp3_2) * (s1_664_1 + s1_664_2);
    gl64_t kD664 = tmp3_0 * s1_664_0;
    gl64_t kE664 = tmp3_1 * s1_664_1;
    gl64_t kF664 = tmp3_2 * s1_664_2;
    gl64_t kG664 = kD664 - kE664;
    tmp3_6 = (kC664 + kG664) - kF664;
    tmp3_7 = ((((kA664 + kC664) - kE664) - kE664) - kD664);
    tmp3_8 = kB664 - kG664;
    // Op 665: dim1x1 sub_swap
    gl64_t s0_665 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_665 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_665 - s0_665;
    // Op 666: dim3x1 mul
    uint64_t s0_666_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_666_0 = *(gl64_t*)&dParams->aux_trace[s0_666_pos];
    gl64_t s0_666_1 = *(gl64_t*)&dParams->aux_trace[s0_666_pos + TILE_HEIGHT];
    gl64_t s0_666_2 = *(gl64_t*)&dParams->aux_trace[s0_666_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_666_0 * tmp1_0; tmp3_1 = s0_666_1 * tmp1_0; tmp3_2 = s0_666_2 * tmp1_0;
    // Op 667: dim3x3 sub
    uint64_t s0_667_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_667_0 = *(gl64_t*)&dParams->aux_trace[s0_667_pos];
    gl64_t s0_667_1 = *(gl64_t*)&dParams->aux_trace[s0_667_pos + TILE_HEIGHT];
    gl64_t s0_667_2 = *(gl64_t*)&dParams->aux_trace[s0_667_pos + 2*TILE_HEIGHT];
    tmp3_3 = s0_667_0 - tmp3_0; tmp3_4 = s0_667_1 - tmp3_1; tmp3_5 = s0_667_2 - tmp3_2;
    // Op 668: dim3x3 add
    gl64_t s0_668_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_668_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_668_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_668_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_668_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_668_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_0 = s0_668_0 + s1_668_0; tmp3_1 = s0_668_1 + s1_668_1; tmp3_2 = s0_668_2 + s1_668_2;
    // Op 669: dim3x3 add
    uint64_t s0_669_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_669_0 = *(gl64_t*)&dParams->aux_trace[s0_669_pos];
    gl64_t s0_669_1 = *(gl64_t*)&dParams->aux_trace[s0_669_pos + TILE_HEIGHT];
    gl64_t s0_669_2 = *(gl64_t*)&dParams->aux_trace[s0_669_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_669_0 + tmp3_0; tmp3_1 = s0_669_1 + tmp3_1; tmp3_2 = s0_669_2 + tmp3_2;
    // Op 670: dim3x3 add
    uint64_t s0_670_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_670_0 = *(gl64_t*)&dParams->aux_trace[s0_670_pos];
    gl64_t s0_670_1 = *(gl64_t*)&dParams->aux_trace[s0_670_pos + TILE_HEIGHT];
    gl64_t s0_670_2 = *(gl64_t*)&dParams->aux_trace[s0_670_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_670_0 + tmp3_0; tmp3_1 = s0_670_1 + tmp3_1; tmp3_2 = s0_670_2 + tmp3_2;
    // Op 671: dim3x3 add
    gl64_t s0_671_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_671_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_671_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    tmp3_0 = s0_671_0 + tmp3_0; tmp3_1 = s0_671_1 + tmp3_1; tmp3_2 = s0_671_2 + tmp3_2;
    // Op 672: dim3x3 add
    gl64_t s0_672_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+0, domainSize, nCols_2))];
    gl64_t s0_672_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+1, domainSize, nCols_2))];
    gl64_t s0_672_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+2, domainSize, nCols_2))];
    tmp3_0 = s0_672_0 + tmp3_0; tmp3_1 = s0_672_1 + tmp3_1; tmp3_2 = s0_672_2 + tmp3_2;
    // Op 673: dim3x3 add
    uint64_t s0_673_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_2));
    gl64_t s0_673_0 = *(gl64_t*)&dParams->aux_trace[s0_673_pos];
    gl64_t s0_673_1 = *(gl64_t*)&dParams->aux_trace[s0_673_pos + TILE_HEIGHT];
    gl64_t s0_673_2 = *(gl64_t*)&dParams->aux_trace[s0_673_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_673_0 + tmp3_0; tmp3_1 = s0_673_1 + tmp3_1; tmp3_2 = s0_673_2 + tmp3_2;
    // Op 674: dim3x3 add
    uint64_t s0_674_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_2));
    gl64_t s0_674_0 = *(gl64_t*)&dParams->aux_trace[s0_674_pos];
    gl64_t s0_674_1 = *(gl64_t*)&dParams->aux_trace[s0_674_pos + TILE_HEIGHT];
    gl64_t s0_674_2 = *(gl64_t*)&dParams->aux_trace[s0_674_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_674_0 + tmp3_0; tmp3_1 = s0_674_1 + tmp3_1; tmp3_2 = s0_674_2 + tmp3_2;
    // Op 675: dim3x3 add
    gl64_t s0_675_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+0, domainSize, nCols_2))];
    gl64_t s0_675_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+1, domainSize, nCols_2))];
    gl64_t s0_675_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+2, domainSize, nCols_2))];
    tmp3_0 = s0_675_0 + tmp3_0; tmp3_1 = s0_675_1 + tmp3_1; tmp3_2 = s0_675_2 + tmp3_2;
    // Op 676: dim3x3 sub
    tmp3_3 = tmp3_3 - tmp3_0; tmp3_4 = tmp3_4 - tmp3_1; tmp3_5 = tmp3_5 - tmp3_2;
    // Op 677: dim1x1 mul
    gl64_t s0_677 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_677 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_677 * s1_677;
    // Op 678: dim3x1 mul
    gl64_t s0_678_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_678_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_678_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_678_0 * tmp1_0; tmp3_1 = s0_678_1 * tmp1_0; tmp3_2 = s0_678_2 * tmp1_0;
    // Op 679: dim3x1 add
    gl64_t s1_679 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_679; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 680: dim3x3 mul
    gl64_t s1_680_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_680_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_680_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA680 = (tmp3_0 + tmp3_1) * (s1_680_0 + s1_680_1);
    gl64_t kB680 = (tmp3_0 + tmp3_2) * (s1_680_0 + s1_680_2);
    gl64_t kC680 = (tmp3_1 + tmp3_2) * (s1_680_1 + s1_680_2);
    gl64_t kD680 = tmp3_0 * s1_680_0;
    gl64_t kE680 = tmp3_1 * s1_680_1;
    gl64_t kF680 = tmp3_2 * s1_680_2;
    gl64_t kG680 = kD680 - kE680;
    tmp3_0 = (kC680 + kG680) - kF680;
    tmp3_1 = ((((kA680 + kC680) - kE680) - kE680) - kD680);
    tmp3_2 = kB680 - kG680;
    // Op 681: dim1x1 mul
    gl64_t s0_681 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_681 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_681 * s1_681;
    // Op 682: dim1x1 add
    gl64_t s1_682 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_682;
    // Op 683: dim1x1 add
    gl64_t s1_683 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = tmp1_0 + s1_683;
    // Op 684: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 685: dim3x3 mul
    gl64_t s1_685_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_685_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_685_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA685 = (tmp3_0 + tmp3_1) * (s1_685_0 + s1_685_1);
    gl64_t kB685 = (tmp3_0 + tmp3_2) * (s1_685_0 + s1_685_2);
    gl64_t kC685 = (tmp3_1 + tmp3_2) * (s1_685_1 + s1_685_2);
    gl64_t kD685 = tmp3_0 * s1_685_0;
    gl64_t kE685 = tmp3_1 * s1_685_1;
    gl64_t kF685 = tmp3_2 * s1_685_2;
    gl64_t kG685 = kD685 - kE685;
    tmp3_0 = (kC685 + kG685) - kF685;
    tmp3_1 = ((((kA685 + kC685) - kE685) - kE685) - kD685);
    tmp3_2 = kB685 - kG685;
    // Op 686: dim3x1 add
    gl64_t s1_686 = *(gl64_t*)&expressions_params[9][18];
    tmp3_0 = tmp3_0 + s1_686; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 687: dim3x3 mul
    gl64_t s1_687_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_687_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_687_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA687 = (tmp3_0 + tmp3_1) * (s1_687_0 + s1_687_1);
    gl64_t kB687 = (tmp3_0 + tmp3_2) * (s1_687_0 + s1_687_2);
    gl64_t kC687 = (tmp3_1 + tmp3_2) * (s1_687_1 + s1_687_2);
    gl64_t kD687 = tmp3_0 * s1_687_0;
    gl64_t kE687 = tmp3_1 * s1_687_1;
    gl64_t kF687 = tmp3_2 * s1_687_2;
    gl64_t kG687 = kD687 - kE687;
    tmp3_0 = (kC687 + kG687) - kF687;
    tmp3_1 = ((((kA687 + kC687) - kE687) - kE687) - kD687);
    tmp3_2 = kB687 - kG687;
    // Op 688: dim3x1 add
    gl64_t s1_688 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_688; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 689: dim3x3 mul
    gl64_t s1_689_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_689_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_689_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA689 = (tmp3_0 + tmp3_1) * (s1_689_0 + s1_689_1);
    gl64_t kB689 = (tmp3_0 + tmp3_2) * (s1_689_0 + s1_689_2);
    gl64_t kC689 = (tmp3_1 + tmp3_2) * (s1_689_1 + s1_689_2);
    gl64_t kD689 = tmp3_0 * s1_689_0;
    gl64_t kE689 = tmp3_1 * s1_689_1;
    gl64_t kF689 = tmp3_2 * s1_689_2;
    gl64_t kG689 = kD689 - kE689;
    tmp3_0 = (kC689 + kG689) - kF689;
    tmp3_1 = ((((kA689 + kC689) - kE689) - kE689) - kD689);
    tmp3_2 = kB689 - kG689;
    // Op 690: dim3x1 add
    gl64_t s1_690 = *(gl64_t*)&expressions_params[9][5];
    tmp3_0 = tmp3_0 + s1_690; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 691: dim3x3 add
    gl64_t s1_691_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_691_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_691_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_691_0; tmp3_1 = tmp3_1 + s1_691_1; tmp3_2 = tmp3_2 + s1_691_2;
    // Op 692: dim3x3 mul
    gl64_t kA692 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB692 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC692 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD692 = tmp3_3 * tmp3_0;
    gl64_t kE692 = tmp3_4 * tmp3_1;
    gl64_t kF692 = tmp3_5 * tmp3_2;
    gl64_t kG692 = kD692 - kE692;
    tmp3_0 = (kC692 + kG692) - kF692;
    tmp3_1 = ((((kA692 + kC692) - kE692) - kE692) - kD692);
    tmp3_2 = kB692 - kG692;
    // Op 693: dim1x1 sub_swap
    gl64_t s0_693 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_693 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_693 - s0_693;
    // Op 694: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 695: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 696: dim3x3 mul
    gl64_t s1_696_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_696_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_696_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA696 = (tmp3_0 + tmp3_1) * (s1_696_0 + s1_696_1);
    gl64_t kB696 = (tmp3_0 + tmp3_2) * (s1_696_0 + s1_696_2);
    gl64_t kC696 = (tmp3_1 + tmp3_2) * (s1_696_1 + s1_696_2);
    gl64_t kD696 = tmp3_0 * s1_696_0;
    gl64_t kE696 = tmp3_1 * s1_696_1;
    gl64_t kF696 = tmp3_2 * s1_696_2;
    gl64_t kG696 = kD696 - kE696;
    tmp3_6 = (kC696 + kG696) - kF696;
    tmp3_7 = ((((kA696 + kC696) - kE696) - kE696) - kD696);
    tmp3_8 = kB696 - kG696;
    // Op 697: dim3x1 mul
    gl64_t s0_697_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_697_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_697_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_697 = *(gl64_t*)&expressions_params[10][5];
    tmp3_0 = s0_697_0 * s1_697; tmp3_1 = s0_697_1 * s1_697; tmp3_2 = s0_697_2 * s1_697;
    // Op 698: dim3x3 mul
    gl64_t s1_698_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_698_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_698_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA698 = (tmp3_0 + tmp3_1) * (s1_698_0 + s1_698_1);
    gl64_t kB698 = (tmp3_0 + tmp3_2) * (s1_698_0 + s1_698_2);
    gl64_t kC698 = (tmp3_1 + tmp3_2) * (s1_698_1 + s1_698_2);
    gl64_t kD698 = tmp3_0 * s1_698_0;
    gl64_t kE698 = tmp3_1 * s1_698_1;
    gl64_t kF698 = tmp3_2 * s1_698_2;
    gl64_t kG698 = kD698 - kE698;
    tmp3_0 = (kC698 + kG698) - kF698;
    tmp3_1 = ((((kA698 + kC698) - kE698) - kE698) - kD698);
    tmp3_2 = kB698 - kG698;
    // Op 699: dim3x1 add
    gl64_t s1_699 = *(gl64_t*)&expressions_params[10][3];
    tmp3_0 = tmp3_0 + s1_699; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 700: dim3x3 mul
    gl64_t s1_700_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_700_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_700_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA700 = (tmp3_0 + tmp3_1) * (s1_700_0 + s1_700_1);
    gl64_t kB700 = (tmp3_0 + tmp3_2) * (s1_700_0 + s1_700_2);
    gl64_t kC700 = (tmp3_1 + tmp3_2) * (s1_700_1 + s1_700_2);
    gl64_t kD700 = tmp3_0 * s1_700_0;
    gl64_t kE700 = tmp3_1 * s1_700_1;
    gl64_t kF700 = tmp3_2 * s1_700_2;
    gl64_t kG700 = kD700 - kE700;
    tmp3_0 = (kC700 + kG700) - kF700;
    tmp3_1 = ((((kA700 + kC700) - kE700) - kE700) - kD700);
    tmp3_2 = kB700 - kG700;
    // Op 701: dim3x1 add
    gl64_t s1_701 = *(gl64_t*)&expressions_params[10][4];
    tmp3_0 = tmp3_0 + s1_701; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 702: dim3x3 mul
    gl64_t s1_702_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_702_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_702_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA702 = (tmp3_0 + tmp3_1) * (s1_702_0 + s1_702_1);
    gl64_t kB702 = (tmp3_0 + tmp3_2) * (s1_702_0 + s1_702_2);
    gl64_t kC702 = (tmp3_1 + tmp3_2) * (s1_702_1 + s1_702_2);
    gl64_t kD702 = tmp3_0 * s1_702_0;
    gl64_t kE702 = tmp3_1 * s1_702_1;
    gl64_t kF702 = tmp3_2 * s1_702_2;
    gl64_t kG702 = kD702 - kE702;
    tmp3_0 = (kC702 + kG702) - kF702;
    tmp3_1 = ((((kA702 + kC702) - kE702) - kE702) - kD702);
    tmp3_2 = kB702 - kG702;
    // Op 703: dim3x1 add
    gl64_t s1_703 = *(gl64_t*)&expressions_params[10][2];
    tmp3_0 = tmp3_0 + s1_703; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 704: dim3x3 mul
    gl64_t s1_704_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_704_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_704_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA704 = (tmp3_0 + tmp3_1) * (s1_704_0 + s1_704_1);
    gl64_t kB704 = (tmp3_0 + tmp3_2) * (s1_704_0 + s1_704_2);
    gl64_t kC704 = (tmp3_1 + tmp3_2) * (s1_704_1 + s1_704_2);
    gl64_t kD704 = tmp3_0 * s1_704_0;
    gl64_t kE704 = tmp3_1 * s1_704_1;
    gl64_t kF704 = tmp3_2 * s1_704_2;
    gl64_t kG704 = kD704 - kE704;
    tmp3_0 = (kC704 + kG704) - kF704;
    tmp3_1 = ((((kA704 + kC704) - kE704) - kE704) - kD704);
    tmp3_2 = kB704 - kG704;
    // Op 705: dim3x1 add
    gl64_t s1_705 = *(gl64_t*)&expressions_params[10][12];
    tmp3_0 = tmp3_0 + s1_705; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 706: dim3x3 mul
    gl64_t s1_706_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_706_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_706_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA706 = (tmp3_0 + tmp3_1) * (s1_706_0 + s1_706_1);
    gl64_t kB706 = (tmp3_0 + tmp3_2) * (s1_706_0 + s1_706_2);
    gl64_t kC706 = (tmp3_1 + tmp3_2) * (s1_706_1 + s1_706_2);
    gl64_t kD706 = tmp3_0 * s1_706_0;
    gl64_t kE706 = tmp3_1 * s1_706_1;
    gl64_t kF706 = tmp3_2 * s1_706_2;
    gl64_t kG706 = kD706 - kE706;
    tmp3_0 = (kC706 + kG706) - kF706;
    tmp3_1 = ((((kA706 + kC706) - kE706) - kE706) - kD706);
    tmp3_2 = kB706 - kG706;
    // Op 707: dim3x1 add
    gl64_t s1_707 = *(gl64_t*)&expressions_params[10][1];
    tmp3_0 = tmp3_0 + s1_707; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 708: dim3x3 mul
    gl64_t s1_708_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_708_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_708_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA708 = (tmp3_0 + tmp3_1) * (s1_708_0 + s1_708_1);
    gl64_t kB708 = (tmp3_0 + tmp3_2) * (s1_708_0 + s1_708_2);
    gl64_t kC708 = (tmp3_1 + tmp3_2) * (s1_708_1 + s1_708_2);
    gl64_t kD708 = tmp3_0 * s1_708_0;
    gl64_t kE708 = tmp3_1 * s1_708_1;
    gl64_t kF708 = tmp3_2 * s1_708_2;
    gl64_t kG708 = kD708 - kE708;
    tmp3_0 = (kC708 + kG708) - kF708;
    tmp3_1 = ((((kA708 + kC708) - kE708) - kE708) - kD708);
    tmp3_2 = kB708 - kG708;
    // Op 709: dim3x1 add
    gl64_t s1_709 = *(gl64_t*)&expressions_params[9][15];
    tmp3_0 = tmp3_0 + s1_709; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 710: dim3x3 mul
    gl64_t s1_710_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_710_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_710_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA710 = (tmp3_0 + tmp3_1) * (s1_710_0 + s1_710_1);
    gl64_t kB710 = (tmp3_0 + tmp3_2) * (s1_710_0 + s1_710_2);
    gl64_t kC710 = (tmp3_1 + tmp3_2) * (s1_710_1 + s1_710_2);
    gl64_t kD710 = tmp3_0 * s1_710_0;
    gl64_t kE710 = tmp3_1 * s1_710_1;
    gl64_t kF710 = tmp3_2 * s1_710_2;
    gl64_t kG710 = kD710 - kE710;
    tmp3_0 = (kC710 + kG710) - kF710;
    tmp3_1 = ((((kA710 + kC710) - kE710) - kE710) - kD710);
    tmp3_2 = kB710 - kG710;
    // Op 711: dim3x3 mul
    gl64_t s1_711_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_711_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_711_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA711 = (tmp3_0 + tmp3_1) * (s1_711_0 + s1_711_1);
    gl64_t kB711 = (tmp3_0 + tmp3_2) * (s1_711_0 + s1_711_2);
    gl64_t kC711 = (tmp3_1 + tmp3_2) * (s1_711_1 + s1_711_2);
    gl64_t kD711 = tmp3_0 * s1_711_0;
    gl64_t kE711 = tmp3_1 * s1_711_1;
    gl64_t kF711 = tmp3_2 * s1_711_2;
    gl64_t kG711 = kD711 - kE711;
    tmp3_0 = (kC711 + kG711) - kF711;
    tmp3_1 = ((((kA711 + kC711) - kE711) - kE711) - kD711);
    tmp3_2 = kB711 - kG711;
    // Op 712: dim3x1 add
    gl64_t s1_712 = *(gl64_t*)&expressions_params[10][0];
    tmp3_0 = tmp3_0 + s1_712; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 713: dim3x3 mul
    gl64_t s1_713_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_713_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_713_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA713 = (tmp3_0 + tmp3_1) * (s1_713_0 + s1_713_1);
    gl64_t kB713 = (tmp3_0 + tmp3_2) * (s1_713_0 + s1_713_2);
    gl64_t kC713 = (tmp3_1 + tmp3_2) * (s1_713_1 + s1_713_2);
    gl64_t kD713 = tmp3_0 * s1_713_0;
    gl64_t kE713 = tmp3_1 * s1_713_1;
    gl64_t kF713 = tmp3_2 * s1_713_2;
    gl64_t kG713 = kD713 - kE713;
    tmp3_0 = (kC713 + kG713) - kF713;
    tmp3_1 = ((((kA713 + kC713) - kE713) - kE713) - kD713);
    tmp3_2 = kB713 - kG713;
    // Op 714: dim3x1 add
    gl64_t s1_714 = *(gl64_t*)&expressions_params[9][16];
    tmp3_0 = tmp3_0 + s1_714; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 715: dim3x3 add
    gl64_t s1_715_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_715_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_715_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_715_0; tmp3_1 = tmp3_1 + s1_715_1; tmp3_2 = tmp3_2 + s1_715_2;
    // Op 716: dim3x3 mul
    gl64_t s1_716_0 = *(gl64_t*)&expressions_params[10][17];
    gl64_t s1_716_1 = *(gl64_t*)&expressions_params[10][17+1];
    gl64_t s1_716_2 = *(gl64_t*)&expressions_params[10][17+2];
    gl64_t kA716 = (tmp3_0 + tmp3_1) * (s1_716_0 + s1_716_1);
    gl64_t kB716 = (tmp3_0 + tmp3_2) * (s1_716_0 + s1_716_2);
    gl64_t kC716 = (tmp3_1 + tmp3_2) * (s1_716_1 + s1_716_2);
    gl64_t kD716 = tmp3_0 * s1_716_0;
    gl64_t kE716 = tmp3_1 * s1_716_1;
    gl64_t kF716 = tmp3_2 * s1_716_2;
    gl64_t kG716 = kD716 - kE716;
    tmp3_0 = (kC716 + kG716) - kF716;
    tmp3_1 = ((((kA716 + kC716) - kE716) - kE716) - kD716);
    tmp3_2 = kB716 - kG716;
    // Op 717: dim3x1 add
    gl64_t s1_717 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_717; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 718: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 719: dim3x3 mul
    gl64_t s1_719_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_719_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_719_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA719 = (tmp3_0 + tmp3_1) * (s1_719_0 + s1_719_1);
    gl64_t kB719 = (tmp3_0 + tmp3_2) * (s1_719_0 + s1_719_2);
    gl64_t kC719 = (tmp3_1 + tmp3_2) * (s1_719_1 + s1_719_2);
    gl64_t kD719 = tmp3_0 * s1_719_0;
    gl64_t kE719 = tmp3_1 * s1_719_1;
    gl64_t kF719 = tmp3_2 * s1_719_2;
    gl64_t kG719 = kD719 - kE719;
    tmp3_6 = (kC719 + kG719) - kF719;
    tmp3_7 = ((((kA719 + kC719) - kE719) - kE719) - kD719);
    tmp3_8 = kB719 - kG719;
    // Op 720: dim3x1 mul
    gl64_t s0_720_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_720_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_720_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_720 = *(gl64_t*)&expressions_params[10][10];
    tmp3_0 = s0_720_0 * s1_720; tmp3_1 = s0_720_1 * s1_720; tmp3_2 = s0_720_2 * s1_720;
    // Op 721: dim3x3 mul
    gl64_t s1_721_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_721_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_721_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA721 = (tmp3_0 + tmp3_1) * (s1_721_0 + s1_721_1);
    gl64_t kB721 = (tmp3_0 + tmp3_2) * (s1_721_0 + s1_721_2);
    gl64_t kC721 = (tmp3_1 + tmp3_2) * (s1_721_1 + s1_721_2);
    gl64_t kD721 = tmp3_0 * s1_721_0;
    gl64_t kE721 = tmp3_1 * s1_721_1;
    gl64_t kF721 = tmp3_2 * s1_721_2;
    gl64_t kG721 = kD721 - kE721;
    tmp3_0 = (kC721 + kG721) - kF721;
    tmp3_1 = ((((kA721 + kC721) - kE721) - kE721) - kD721);
    tmp3_2 = kB721 - kG721;
    // Op 722: dim3x1 add
    gl64_t s1_722 = *(gl64_t*)&expressions_params[10][8];
    tmp3_0 = tmp3_0 + s1_722; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 723: dim3x3 mul
    gl64_t s1_723_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_723_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_723_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA723 = (tmp3_0 + tmp3_1) * (s1_723_0 + s1_723_1);
    gl64_t kB723 = (tmp3_0 + tmp3_2) * (s1_723_0 + s1_723_2);
    gl64_t kC723 = (tmp3_1 + tmp3_2) * (s1_723_1 + s1_723_2);
    gl64_t kD723 = tmp3_0 * s1_723_0;
    gl64_t kE723 = tmp3_1 * s1_723_1;
    gl64_t kF723 = tmp3_2 * s1_723_2;
    gl64_t kG723 = kD723 - kE723;
    tmp3_0 = (kC723 + kG723) - kF723;
    tmp3_1 = ((((kA723 + kC723) - kE723) - kE723) - kD723);
    tmp3_2 = kB723 - kG723;
    // Op 724: dim3x1 add
    gl64_t s1_724 = *(gl64_t*)&expressions_params[10][9];
    tmp3_0 = tmp3_0 + s1_724; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 725: dim3x3 mul
    gl64_t s1_725_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_725_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_725_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA725 = (tmp3_0 + tmp3_1) * (s1_725_0 + s1_725_1);
    gl64_t kB725 = (tmp3_0 + tmp3_2) * (s1_725_0 + s1_725_2);
    gl64_t kC725 = (tmp3_1 + tmp3_2) * (s1_725_1 + s1_725_2);
    gl64_t kD725 = tmp3_0 * s1_725_0;
    gl64_t kE725 = tmp3_1 * s1_725_1;
    gl64_t kF725 = tmp3_2 * s1_725_2;
    gl64_t kG725 = kD725 - kE725;
    tmp3_0 = (kC725 + kG725) - kF725;
    tmp3_1 = ((((kA725 + kC725) - kE725) - kE725) - kD725);
    tmp3_2 = kB725 - kG725;
    // Op 726: dim3x1 add
    gl64_t s1_726 = *(gl64_t*)&expressions_params[10][7];
    tmp3_0 = tmp3_0 + s1_726; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 727: dim3x3 mul
    gl64_t s1_727_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_727_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_727_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA727 = (tmp3_0 + tmp3_1) * (s1_727_0 + s1_727_1);
    gl64_t kB727 = (tmp3_0 + tmp3_2) * (s1_727_0 + s1_727_2);
    gl64_t kC727 = (tmp3_1 + tmp3_2) * (s1_727_1 + s1_727_2);
    gl64_t kD727 = tmp3_0 * s1_727_0;
    gl64_t kE727 = tmp3_1 * s1_727_1;
    gl64_t kF727 = tmp3_2 * s1_727_2;
    gl64_t kG727 = kD727 - kE727;
    tmp3_0 = (kC727 + kG727) - kF727;
    tmp3_1 = ((((kA727 + kC727) - kE727) - kE727) - kD727);
    tmp3_2 = kB727 - kG727;
    // Op 728: dim3x1 add
    gl64_t s1_728 = *(gl64_t*)&expressions_params[10][13];
    tmp3_0 = tmp3_0 + s1_728; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 729: dim3x3 mul
    gl64_t s1_729_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_729_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_729_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA729 = (tmp3_0 + tmp3_1) * (s1_729_0 + s1_729_1);
    gl64_t kB729 = (tmp3_0 + tmp3_2) * (s1_729_0 + s1_729_2);
    gl64_t kC729 = (tmp3_1 + tmp3_2) * (s1_729_1 + s1_729_2);
    gl64_t kD729 = tmp3_0 * s1_729_0;
    gl64_t kE729 = tmp3_1 * s1_729_1;
    gl64_t kF729 = tmp3_2 * s1_729_2;
    gl64_t kG729 = kD729 - kE729;
    tmp3_0 = (kC729 + kG729) - kF729;
    tmp3_1 = ((((kA729 + kC729) - kE729) - kE729) - kD729);
    tmp3_2 = kB729 - kG729;
    // Op 730: dim3x1 add
    gl64_t s1_730 = *(gl64_t*)&expressions_params[10][6];
    tmp3_0 = tmp3_0 + s1_730; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 731: dim3x3 mul
    gl64_t s1_731_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_731_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_731_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA731 = (tmp3_0 + tmp3_1) * (s1_731_0 + s1_731_1);
    gl64_t kB731 = (tmp3_0 + tmp3_2) * (s1_731_0 + s1_731_2);
    gl64_t kC731 = (tmp3_1 + tmp3_2) * (s1_731_1 + s1_731_2);
    gl64_t kD731 = tmp3_0 * s1_731_0;
    gl64_t kE731 = tmp3_1 * s1_731_1;
    gl64_t kF731 = tmp3_2 * s1_731_2;
    gl64_t kG731 = kD731 - kE731;
    tmp3_0 = (kC731 + kG731) - kF731;
    tmp3_1 = ((((kA731 + kC731) - kE731) - kE731) - kD731);
    tmp3_2 = kB731 - kG731;
    // Op 732: dim3x1 add
    gl64_t s1_732 = *(gl64_t*)&expressions_params[9][15];
    tmp3_0 = tmp3_0 + s1_732; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 733: dim3x3 mul
    gl64_t s1_733_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_733_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_733_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA733 = (tmp3_0 + tmp3_1) * (s1_733_0 + s1_733_1);
    gl64_t kB733 = (tmp3_0 + tmp3_2) * (s1_733_0 + s1_733_2);
    gl64_t kC733 = (tmp3_1 + tmp3_2) * (s1_733_1 + s1_733_2);
    gl64_t kD733 = tmp3_0 * s1_733_0;
    gl64_t kE733 = tmp3_1 * s1_733_1;
    gl64_t kF733 = tmp3_2 * s1_733_2;
    gl64_t kG733 = kD733 - kE733;
    tmp3_0 = (kC733 + kG733) - kF733;
    tmp3_1 = ((((kA733 + kC733) - kE733) - kE733) - kD733);
    tmp3_2 = kB733 - kG733;
    // Op 734: dim3x1 add
    gl64_t s1_734 = *(gl64_t*)&expressions_params[10][11];
    tmp3_0 = tmp3_0 + s1_734; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 735: dim3x3 mul
    gl64_t s1_735_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_735_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_735_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA735 = (tmp3_0 + tmp3_1) * (s1_735_0 + s1_735_1);
    gl64_t kB735 = (tmp3_0 + tmp3_2) * (s1_735_0 + s1_735_2);
    gl64_t kC735 = (tmp3_1 + tmp3_2) * (s1_735_1 + s1_735_2);
    gl64_t kD735 = tmp3_0 * s1_735_0;
    gl64_t kE735 = tmp3_1 * s1_735_1;
    gl64_t kF735 = tmp3_2 * s1_735_2;
    gl64_t kG735 = kD735 - kE735;
    tmp3_0 = (kC735 + kG735) - kF735;
    tmp3_1 = ((((kA735 + kC735) - kE735) - kE735) - kD735);
    tmp3_2 = kB735 - kG735;
    // Op 736: dim1x1 add
    gl64_t s0_736 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_736 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_736 + s1_736;
    // Op 737: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 738: dim3x3 mul
    gl64_t s1_738_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_738_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_738_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA738 = (tmp3_0 + tmp3_1) * (s1_738_0 + s1_738_1);
    gl64_t kB738 = (tmp3_0 + tmp3_2) * (s1_738_0 + s1_738_2);
    gl64_t kC738 = (tmp3_1 + tmp3_2) * (s1_738_1 + s1_738_2);
    gl64_t kD738 = tmp3_0 * s1_738_0;
    gl64_t kE738 = tmp3_1 * s1_738_1;
    gl64_t kF738 = tmp3_2 * s1_738_2;
    gl64_t kG738 = kD738 - kE738;
    tmp3_0 = (kC738 + kG738) - kF738;
    tmp3_1 = ((((kA738 + kC738) - kE738) - kE738) - kD738);
    tmp3_2 = kB738 - kG738;
    // Op 739: dim3x1 add
    gl64_t s1_739 = *(gl64_t*)&expressions_params[9][16];
    tmp3_0 = tmp3_0 + s1_739; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 740: dim3x3 add
    gl64_t s1_740_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_740_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_740_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_740_0; tmp3_1 = tmp3_1 + s1_740_1; tmp3_2 = tmp3_2 + s1_740_2;
    // Op 741: dim3x3 mul
    gl64_t s1_741_0 = *(gl64_t*)&expressions_params[10][20];
    gl64_t s1_741_1 = *(gl64_t*)&expressions_params[10][20+1];
    gl64_t s1_741_2 = *(gl64_t*)&expressions_params[10][20+2];
    gl64_t kA741 = (tmp3_0 + tmp3_1) * (s1_741_0 + s1_741_1);
    gl64_t kB741 = (tmp3_0 + tmp3_2) * (s1_741_0 + s1_741_2);
    gl64_t kC741 = (tmp3_1 + tmp3_2) * (s1_741_1 + s1_741_2);
    gl64_t kD741 = tmp3_0 * s1_741_0;
    gl64_t kE741 = tmp3_1 * s1_741_1;
    gl64_t kF741 = tmp3_2 * s1_741_2;
    gl64_t kG741 = kD741 - kE741;
    tmp3_0 = (kC741 + kG741) - kF741;
    tmp3_1 = ((((kA741 + kC741) - kE741) - kE741) - kD741);
    tmp3_2 = kB741 - kG741;
    // Op 742: dim1x1 sub
    gl64_t s0_742 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_742 = *(gl64_t*)&expressions_params[10][11];
    tmp1_0 = s0_742 - s1_742;
    // Op 743: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 744: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 745: dim3x3 mul
    gl64_t s1_745_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_745_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_745_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA745 = (tmp3_0 + tmp3_1) * (s1_745_0 + s1_745_1);
    gl64_t kB745 = (tmp3_0 + tmp3_2) * (s1_745_0 + s1_745_2);
    gl64_t kC745 = (tmp3_1 + tmp3_2) * (s1_745_1 + s1_745_2);
    gl64_t kD745 = tmp3_0 * s1_745_0;
    gl64_t kE745 = tmp3_1 * s1_745_1;
    gl64_t kF745 = tmp3_2 * s1_745_2;
    gl64_t kG745 = kD745 - kE745;
    tmp3_6 = (kC745 + kG745) - kF745;
    tmp3_7 = ((((kA745 + kC745) - kE745) - kE745) - kD745);
    tmp3_8 = kB745 - kG745;
    // Op 746: dim3x1 add
    gl64_t s0_746_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s0_746_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s0_746_2 = *(gl64_t*)&expressions_params[13][3+2];
    gl64_t s1_746 = *(gl64_t*)&expressions_params[9][14];
    tmp3_0 = s0_746_0 + s1_746; tmp3_1 = s0_746_1; tmp3_2 = s0_746_2;
    // Op 747: dim3x3 mul
    gl64_t s1_747_0 = *(gl64_t*)&expressions_params[10][23];
    gl64_t s1_747_1 = *(gl64_t*)&expressions_params[10][23+1];
    gl64_t s1_747_2 = *(gl64_t*)&expressions_params[10][23+2];
    gl64_t kA747 = (tmp3_0 + tmp3_1) * (s1_747_0 + s1_747_1);
    gl64_t kB747 = (tmp3_0 + tmp3_2) * (s1_747_0 + s1_747_2);
    gl64_t kC747 = (tmp3_1 + tmp3_2) * (s1_747_1 + s1_747_2);
    gl64_t kD747 = tmp3_0 * s1_747_0;
    gl64_t kE747 = tmp3_1 * s1_747_1;
    gl64_t kF747 = tmp3_2 * s1_747_2;
    gl64_t kG747 = kD747 - kE747;
    tmp3_0 = (kC747 + kG747) - kF747;
    tmp3_1 = ((((kA747 + kC747) - kE747) - kE747) - kD747);
    tmp3_2 = kB747 - kG747;
    // Op 748: dim1x1 sub
    gl64_t s0_748 = *(gl64_t*)&expressions_params[9][1];
    gl64_t s1_748 = *(gl64_t*)&expressions_params[10][16];
    tmp1_0 = s0_748 - s1_748;
    // Op 749: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 750: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 751: dim3x3 mul
    gl64_t s1_751_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_751_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_751_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA751 = (tmp3_0 + tmp3_1) * (s1_751_0 + s1_751_1);
    gl64_t kB751 = (tmp3_0 + tmp3_2) * (s1_751_0 + s1_751_2);
    gl64_t kC751 = (tmp3_1 + tmp3_2) * (s1_751_1 + s1_751_2);
    gl64_t kD751 = tmp3_0 * s1_751_0;
    gl64_t kE751 = tmp3_1 * s1_751_1;
    gl64_t kF751 = tmp3_2 * s1_751_2;
    gl64_t kG751 = kD751 - kE751;
    tmp3_6 = (kC751 + kG751) - kF751;
    tmp3_7 = ((((kA751 + kC751) - kE751) - kE751) - kD751);
    tmp3_8 = kB751 - kG751;
    // Op 752: dim3x1 mul
    gl64_t s0_752_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_752_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_752_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_752 = *(gl64_t*)&expressions_params[10][14];
    tmp3_0 = s0_752_0 * s1_752; tmp3_1 = s0_752_1 * s1_752; tmp3_2 = s0_752_2 * s1_752;
    // Op 753: dim3x1 add
    gl64_t s1_753 = *(gl64_t*)&expressions_params[9][17];
    tmp3_0 = tmp3_0 + s1_753; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 754: dim3x3 add
    gl64_t s1_754_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_754_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_754_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_754_0; tmp3_1 = tmp3_1 + s1_754_1; tmp3_2 = tmp3_2 + s1_754_2;
    // Op 755: dim3x3 mul
    gl64_t s1_755_0 = *(gl64_t*)&expressions_params[10][26];
    gl64_t s1_755_1 = *(gl64_t*)&expressions_params[10][26+1];
    gl64_t s1_755_2 = *(gl64_t*)&expressions_params[10][26+2];
    gl64_t kA755 = (tmp3_0 + tmp3_1) * (s1_755_0 + s1_755_1);
    gl64_t kB755 = (tmp3_0 + tmp3_2) * (s1_755_0 + s1_755_2);
    gl64_t kC755 = (tmp3_1 + tmp3_2) * (s1_755_1 + s1_755_2);
    gl64_t kD755 = tmp3_0 * s1_755_0;
    gl64_t kE755 = tmp3_1 * s1_755_1;
    gl64_t kF755 = tmp3_2 * s1_755_2;
    gl64_t kG755 = kD755 - kE755;
    tmp3_0 = (kC755 + kG755) - kF755;
    tmp3_1 = ((((kA755 + kC755) - kE755) - kE755) - kD755);
    tmp3_2 = kB755 - kG755;
    // Op 756: dim3x1 add
    gl64_t s1_756 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_756; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 757: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 758: dim3x3 mul
    gl64_t s1_758_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_758_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_758_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA758 = (tmp3_0 + tmp3_1) * (s1_758_0 + s1_758_1);
    gl64_t kB758 = (tmp3_0 + tmp3_2) * (s1_758_0 + s1_758_2);
    gl64_t kC758 = (tmp3_1 + tmp3_2) * (s1_758_1 + s1_758_2);
    gl64_t kD758 = tmp3_0 * s1_758_0;
    gl64_t kE758 = tmp3_1 * s1_758_1;
    gl64_t kF758 = tmp3_2 * s1_758_2;
    gl64_t kG758 = kD758 - kE758;
    tmp3_6 = (kC758 + kG758) - kF758;
    tmp3_7 = ((((kA758 + kC758) - kE758) - kE758) - kD758);
    tmp3_8 = kB758 - kG758;
    // Op 759: dim3x1 mul
    gl64_t s0_759_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_759_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_759_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_759 = *(gl64_t*)&expressions_params[10][15];
    tmp3_0 = s0_759_0 * s1_759; tmp3_1 = s0_759_1 * s1_759; tmp3_2 = s0_759_2 * s1_759;
    // Op 760: dim3x1 add
    gl64_t s1_760 = *(gl64_t*)&expressions_params[9][17];
    tmp3_0 = tmp3_0 + s1_760; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 761: dim3x3 add
    gl64_t s1_761_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_761_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_761_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_761_0; tmp3_1 = tmp3_1 + s1_761_1; tmp3_2 = tmp3_2 + s1_761_2;
    // Op 762: dim3x3 mul
    gl64_t s1_762_0 = *(gl64_t*)&expressions_params[10][29];
    gl64_t s1_762_1 = *(gl64_t*)&expressions_params[10][29+1];
    gl64_t s1_762_2 = *(gl64_t*)&expressions_params[10][29+2];
    gl64_t kA762 = (tmp3_0 + tmp3_1) * (s1_762_0 + s1_762_1);
    gl64_t kB762 = (tmp3_0 + tmp3_2) * (s1_762_0 + s1_762_2);
    gl64_t kC762 = (tmp3_1 + tmp3_2) * (s1_762_1 + s1_762_2);
    gl64_t kD762 = tmp3_0 * s1_762_0;
    gl64_t kE762 = tmp3_1 * s1_762_1;
    gl64_t kF762 = tmp3_2 * s1_762_2;
    gl64_t kG762 = kD762 - kE762;
    tmp3_0 = (kC762 + kG762) - kF762;
    tmp3_1 = ((((kA762 + kC762) - kE762) - kE762) - kD762);
    tmp3_2 = kB762 - kG762;
    // Op 763: dim3x1 add
    gl64_t s1_763 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_763; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 764: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 765: dim3x3 mul
    gl64_t s1_765_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_765_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_765_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA765 = (tmp3_0 + tmp3_1) * (s1_765_0 + s1_765_1);
    gl64_t kB765 = (tmp3_0 + tmp3_2) * (s1_765_0 + s1_765_2);
    gl64_t kC765 = (tmp3_1 + tmp3_2) * (s1_765_1 + s1_765_2);
    gl64_t kD765 = tmp3_0 * s1_765_0;
    gl64_t kE765 = tmp3_1 * s1_765_1;
    gl64_t kF765 = tmp3_2 * s1_765_2;
    gl64_t kG765 = kD765 - kE765;
    tmp3_3 = (kC765 + kG765) - kF765;
    tmp3_4 = ((((kA765 + kC765) - kE765) - kE765) - kD765);
    tmp3_5 = kB765 - kG765;
    // Op 766: dim3x3 sub_swap
    uint64_t s0_766_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_766_0 = *(gl64_t*)&dParams->aux_trace[s0_766_pos];
    gl64_t s0_766_1 = *(gl64_t*)&dParams->aux_trace[s0_766_pos + TILE_HEIGHT];
    gl64_t s0_766_2 = *(gl64_t*)&dParams->aux_trace[s0_766_pos + 2*TILE_HEIGHT];
    gl64_t s1_766_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_766_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_766_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_6 = s1_766_0 - s0_766_0; tmp3_7 = s1_766_1 - s0_766_1; tmp3_8 = s1_766_2 - s0_766_2;
    // Op 767: dim3x3 add
    gl64_t s0_767_0 = *(gl64_t*)&expressions_params[10][17];
    gl64_t s0_767_1 = *(gl64_t*)&expressions_params[10][17+1];
    gl64_t s0_767_2 = *(gl64_t*)&expressions_params[10][17+2];
    gl64_t s1_767_0 = *(gl64_t*)&expressions_params[10][20];
    gl64_t s1_767_1 = *(gl64_t*)&expressions_params[10][20+1];
    gl64_t s1_767_2 = *(gl64_t*)&expressions_params[10][20+2];
    tmp3_0 = s0_767_0 + s1_767_0; tmp3_1 = s0_767_1 + s1_767_1; tmp3_2 = s0_767_2 + s1_767_2;
    // Op 768: dim3x3 add
    gl64_t s1_768_0 = *(gl64_t*)&expressions_params[10][23];
    gl64_t s1_768_1 = *(gl64_t*)&expressions_params[10][23+1];
    gl64_t s1_768_2 = *(gl64_t*)&expressions_params[10][23+2];
    tmp3_0 = tmp3_0 + s1_768_0; tmp3_1 = tmp3_1 + s1_768_1; tmp3_2 = tmp3_2 + s1_768_2;
    // Op 769: dim3x3 add
    gl64_t s1_769_0 = *(gl64_t*)&expressions_params[10][26];
    gl64_t s1_769_1 = *(gl64_t*)&expressions_params[10][26+1];
    gl64_t s1_769_2 = *(gl64_t*)&expressions_params[10][26+2];
    tmp3_0 = tmp3_0 + s1_769_0; tmp3_1 = tmp3_1 + s1_769_1; tmp3_2 = tmp3_2 + s1_769_2;
    // Op 770: dim3x3 add
    gl64_t s1_770_0 = *(gl64_t*)&expressions_params[10][29];
    gl64_t s1_770_1 = *(gl64_t*)&expressions_params[10][29+1];
    gl64_t s1_770_2 = *(gl64_t*)&expressions_params[10][29+2];
    tmp3_0 = tmp3_0 + s1_770_0; tmp3_1 = tmp3_1 + s1_770_1; tmp3_2 = tmp3_2 + s1_770_2;
    // Op 771: dim3x3 sub
    tmp3_0 = tmp3_6 - tmp3_0; tmp3_1 = tmp3_7 - tmp3_1; tmp3_2 = tmp3_8 - tmp3_2;
    // Op 772: dim3x1 mul
    gl64_t s1_772 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_772; tmp3_1 = tmp3_1 * s1_772; tmp3_2 = tmp3_2 * s1_772;
    // Op 773: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 774: dim3x1 mul
    gl64_t s1_774 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_774; tmp3_1 = tmp3_1 * s1_774; tmp3_2 = tmp3_2 * s1_774;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
