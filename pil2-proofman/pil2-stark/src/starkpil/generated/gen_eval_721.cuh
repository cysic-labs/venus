// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: 6f66cdaf  nOps=552 nTemp1=5 nTemp3=5
#define GENERATED_EVAL_NOPS_6f66cdaf 552
#define GENERATED_EVAL_NTEMP1_6f66cdaf 5
#define GENERATED_EVAL_NTEMP3_6f66cdaf 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_6f66cdaf(
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
    gl64_t s0_29 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_29 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_29 - s0_29;
    // Op 30: dim1x1 mul
    gl64_t s0_30 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_30 * tmp1_0;
    // Op 31: dim1x1 sub
    gl64_t s0_31 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_31 = *(gl64_t*)&expressions_params[10][13];
    tmp1_1 = s0_31 - s1_31;
    // Op 32: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 33: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 34: dim3x3 mul
    gl64_t s1_34_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_34_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_34_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA34 = (tmp3_0 + tmp3_1) * (s1_34_0 + s1_34_1);
    gl64_t kB34 = (tmp3_0 + tmp3_2) * (s1_34_0 + s1_34_2);
    gl64_t kC34 = (tmp3_1 + tmp3_2) * (s1_34_1 + s1_34_2);
    gl64_t kD34 = tmp3_0 * s1_34_0;
    gl64_t kE34 = tmp3_1 * s1_34_1;
    gl64_t kF34 = tmp3_2 * s1_34_2;
    gl64_t kG34 = kD34 - kE34;
    tmp3_0 = (kC34 + kG34) - kF34;
    tmp3_1 = ((((kA34 + kC34) - kE34) - kE34) - kD34);
    tmp3_2 = kB34 - kG34;
    // Op 35: dim1x1 sub_swap
    gl64_t s0_35 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_35 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_35 - s0_35;
    // Op 36: dim1x1 mul
    gl64_t s0_36 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_36 * tmp1_0;
    // Op 37: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 38: dim3x3 mul
    gl64_t s1_38_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_38_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_38_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA38 = (tmp3_0 + tmp3_1) * (s1_38_0 + s1_38_1);
    gl64_t kB38 = (tmp3_0 + tmp3_2) * (s1_38_0 + s1_38_2);
    gl64_t kC38 = (tmp3_1 + tmp3_2) * (s1_38_1 + s1_38_2);
    gl64_t kD38 = tmp3_0 * s1_38_0;
    gl64_t kE38 = tmp3_1 * s1_38_1;
    gl64_t kF38 = tmp3_2 * s1_38_2;
    gl64_t kG38 = kD38 - kE38;
    tmp3_0 = (kC38 + kG38) - kF38;
    tmp3_1 = ((((kA38 + kC38) - kE38) - kE38) - kD38);
    tmp3_2 = kB38 - kG38;
    // Op 39: dim1x1 mul
    gl64_t s0_39 = *(gl64_t*)&expressions_params[10][13];
    gl64_t s1_39 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s0_39 * s1_39;
    // Op 40: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 41: dim3x3 mul
    gl64_t s1_41_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_41_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_41_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA41 = (tmp3_0 + tmp3_1) * (s1_41_0 + s1_41_1);
    gl64_t kB41 = (tmp3_0 + tmp3_2) * (s1_41_0 + s1_41_2);
    gl64_t kC41 = (tmp3_1 + tmp3_2) * (s1_41_1 + s1_41_2);
    gl64_t kD41 = tmp3_0 * s1_41_0;
    gl64_t kE41 = tmp3_1 * s1_41_1;
    gl64_t kF41 = tmp3_2 * s1_41_2;
    gl64_t kG41 = kD41 - kE41;
    tmp3_0 = (kC41 + kG41) - kF41;
    tmp3_1 = ((((kA41 + kC41) - kE41) - kE41) - kD41);
    tmp3_2 = kB41 - kG41;
    // Op 42: dim1x1 mul
    gl64_t s0_42 = *(gl64_t*)&expressions_params[10][12];
    gl64_t s1_42 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_42 * s1_42;
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
    gl64_t s0_45 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_45 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_45 - s0_45;
    // Op 46: dim1x1 mul
    gl64_t s0_46 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
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
    gl64_t s0_49 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_49 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_49 - s0_49;
    // Op 50: dim1x1 mul
    gl64_t s0_50 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
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
    gl64_t s0_53 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
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
    gl64_t s0_57 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_57 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_57 - s0_57;
    // Op 58: dim1x1 mul
    gl64_t s0_58 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
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
    gl64_t s0_61 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_61 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_61 - s0_61;
    // Op 62: dim1x1 mul
    gl64_t s0_62 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
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
    gl64_t s0_66 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
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
    gl64_t s0_69 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_69 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_69 - s0_69;
    // Op 70: dim1x1 mul
    gl64_t s0_70 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
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
    gl64_t s0_74 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
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
    gl64_t s0_77 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_77 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_77 - s0_77;
    // Op 78: dim1x1 mul
    gl64_t s0_78 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
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
    gl64_t s0_82 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
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
    gl64_t s0_85 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_85 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_85 - s0_85;
    // Op 86: dim1x1 mul
    gl64_t s0_86 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
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
    gl64_t s0_90 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
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
    gl64_t s0_93 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_93 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_93 - s0_93;
    // Op 94: dim1x1 mul
    gl64_t s0_94 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
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
    gl64_t s0_98 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
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
    gl64_t s0_101 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_101 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_101 - s0_101;
    // Op 102: dim1x1 mul
    gl64_t s0_102 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
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
    // Op 105: dim1x1 sub
    gl64_t s0_105 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_105 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s0_105 - s1_105;
    // Op 106: dim1x1 mul
    gl64_t s0_106 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_106 * tmp1_0;
    // Op 107: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 108: dim3x3 mul
    gl64_t s1_108_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_108_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_108_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA108 = (tmp3_0 + tmp3_1) * (s1_108_0 + s1_108_1);
    gl64_t kB108 = (tmp3_0 + tmp3_2) * (s1_108_0 + s1_108_2);
    gl64_t kC108 = (tmp3_1 + tmp3_2) * (s1_108_1 + s1_108_2);
    gl64_t kD108 = tmp3_0 * s1_108_0;
    gl64_t kE108 = tmp3_1 * s1_108_1;
    gl64_t kF108 = tmp3_2 * s1_108_2;
    gl64_t kG108 = kD108 - kE108;
    tmp3_0 = (kC108 + kG108) - kF108;
    tmp3_1 = ((((kA108 + kC108) - kE108) - kE108) - kD108);
    tmp3_2 = kB108 - kG108;
    // Op 109: dim1x1 sub_swap
    gl64_t s0_109 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_109 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_109 - s0_109;
    // Op 110: dim1x1 mul
    gl64_t s0_110 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_110 * tmp1_0;
    // Op 111: dim1x1 sub
    gl64_t s0_111 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_111 = *(gl64_t*)&expressions_params[10][7];
    tmp1_1 = s0_111 - s1_111;
    // Op 112: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
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
    gl64_t s0_115 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_115 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_115 - s0_115;
    // Op 116: dim1x1 mul
    gl64_t s0_116 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_116 * tmp1_0;
    // Op 117: dim1x1 sub
    gl64_t s0_117 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_117 = *(gl64_t*)&expressions_params[10][8];
    tmp1_1 = s0_117 - s1_117;
    // Op 118: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
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
    gl64_t s0_121 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_121 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_121 - s0_121;
    // Op 122: dim1x1 mul
    gl64_t s0_122 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_122 * tmp1_0;
    // Op 123: dim1x1 sub
    gl64_t s0_123 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_123 = *(gl64_t*)&expressions_params[10][9];
    tmp1_1 = s0_123 - s1_123;
    // Op 124: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
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
    // Op 127: dim1x1 sub_swap
    gl64_t s0_127 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_127 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_127 - s0_127;
    // Op 128: dim1x1 mul
    gl64_t s0_128 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_128 * tmp1_0;
    // Op 129: dim1x1 mul
    gl64_t s0_129 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_129 = *(gl64_t*)&expressions_params[9][5];
    tmp1_2 = s0_129 * s1_129;
    // Op 130: dim1x1 sub
    gl64_t s1_130 = *(gl64_t*)&expressions_params[10][10];
    tmp1_1 = tmp1_2 - s1_130;
    // Op 131: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 132: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 133: dim3x3 mul
    gl64_t s1_133_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_133_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_133_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA133 = (tmp3_0 + tmp3_1) * (s1_133_0 + s1_133_1);
    gl64_t kB133 = (tmp3_0 + tmp3_2) * (s1_133_0 + s1_133_2);
    gl64_t kC133 = (tmp3_1 + tmp3_2) * (s1_133_1 + s1_133_2);
    gl64_t kD133 = tmp3_0 * s1_133_0;
    gl64_t kE133 = tmp3_1 * s1_133_1;
    gl64_t kF133 = tmp3_2 * s1_133_2;
    gl64_t kG133 = kD133 - kE133;
    tmp3_0 = (kC133 + kG133) - kF133;
    tmp3_1 = ((((kA133 + kC133) - kE133) - kE133) - kD133);
    tmp3_2 = kB133 - kG133;
    // Op 134: dim1x1 mul
    gl64_t s0_134 = *(gl64_t*)&expressions_params[10][7];
    gl64_t s1_134 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s0_134 * s1_134;
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
    gl64_t s0_137 = *(gl64_t*)&expressions_params[10][9];
    gl64_t s1_137 = *(gl64_t*)&expressions_params[10][6];
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
    gl64_t s0_140 = *(gl64_t*)&expressions_params[10][8];
    gl64_t s1_140 = *(gl64_t*)&expressions_params[10][6];
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
    gl64_t s0_143 = *(gl64_t*)&expressions_params[10][10];
    gl64_t s1_143 = *(gl64_t*)&expressions_params[10][6];
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
    // Op 146: dim1x1 mul
    gl64_t s0_146 = *(gl64_t*)&expressions_params[10][2];
    gl64_t s1_146 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_146 * s1_146;
    // Op 147: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 148: dim3x3 mul
    gl64_t s1_148_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_148_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_148_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA148 = (tmp3_0 + tmp3_1) * (s1_148_0 + s1_148_1);
    gl64_t kB148 = (tmp3_0 + tmp3_2) * (s1_148_0 + s1_148_2);
    gl64_t kC148 = (tmp3_1 + tmp3_2) * (s1_148_1 + s1_148_2);
    gl64_t kD148 = tmp3_0 * s1_148_0;
    gl64_t kE148 = tmp3_1 * s1_148_1;
    gl64_t kF148 = tmp3_2 * s1_148_2;
    gl64_t kG148 = kD148 - kE148;
    tmp3_0 = (kC148 + kG148) - kF148;
    tmp3_1 = ((((kA148 + kC148) - kE148) - kE148) - kD148);
    tmp3_2 = kB148 - kG148;
    // Op 149: dim1x1 mul
    gl64_t s0_149 = *(gl64_t*)&expressions_params[10][4];
    gl64_t s1_149 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_149 * s1_149;
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
    // Op 152: dim1x1 mul
    gl64_t s0_152 = *(gl64_t*)&expressions_params[10][3];
    gl64_t s1_152 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_152 * s1_152;
    // Op 153: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 154: dim3x3 mul
    gl64_t s1_154_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_154_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_154_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA154 = (tmp3_0 + tmp3_1) * (s1_154_0 + s1_154_1);
    gl64_t kB154 = (tmp3_0 + tmp3_2) * (s1_154_0 + s1_154_2);
    gl64_t kC154 = (tmp3_1 + tmp3_2) * (s1_154_1 + s1_154_2);
    gl64_t kD154 = tmp3_0 * s1_154_0;
    gl64_t kE154 = tmp3_1 * s1_154_1;
    gl64_t kF154 = tmp3_2 * s1_154_2;
    gl64_t kG154 = kD154 - kE154;
    tmp3_0 = (kC154 + kG154) - kF154;
    tmp3_1 = ((((kA154 + kC154) - kE154) - kE154) - kD154);
    tmp3_2 = kB154 - kG154;
    // Op 155: dim1x1 mul
    gl64_t s0_155 = *(gl64_t*)&expressions_params[10][5];
    gl64_t s1_155 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_155 * s1_155;
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
    // Op 158: dim1x1 sub
    gl64_t s0_158 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_158 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_158 - s1_158;
    // Op 159: dim1x1 mul
    gl64_t s0_159 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_3 = s0_159 * tmp1_0;
    // Op 160: dim1x1 sub_swap
    gl64_t s0_160 = *(gl64_t*)&expressions_params[9][5];
    gl64_t s1_160 = *(gl64_t*)&expressions_params[10][4];
    tmp1_0 = s1_160 - s0_160;
    // Op 161: dim1x1 sub
    gl64_t s0_161 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_161 - tmp1_0;
    // Op 162: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
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
    // Op 165: dim1x1 sub_swap
    gl64_t s0_165 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_165 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_165 - s0_165;
    // Op 166: dim1x1 sub_swap
    gl64_t s0_166 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_1))];
    gl64_t s1_166 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s1_166 - s0_166;
    // Op 167: dim1x1 mul
    tmp1_4 = tmp1_0 * tmp1_1;
    // Op 168: dim1x1 sub
    gl64_t s0_168 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 6, domainSize, nCols_1))];
    gl64_t s1_168 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_168 - s1_168;
    // Op 169: dim1x1 sub
    gl64_t s0_169 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_169 - tmp1_0;
    // Op 170: dim1x1 mul
    tmp1_0 = tmp1_4 * tmp1_0;
    // Op 171: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 172: dim3x3 mul
    gl64_t s1_172_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_172_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_172_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 173: dim1x1 add
    gl64_t s0_173 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_173 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_173 + s1_173;
    // Op 174: dim1x1 add
    gl64_t s0_174 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_174 + tmp1_0;
    // Op 175: dim1x1 add
    gl64_t s0_175 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_175 + tmp1_0;
    // Op 176: dim1x1 add
    gl64_t s0_176 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_176 + tmp1_0;
    // Op 177: dim1x1 add
    gl64_t s0_177 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_0 = s0_177 + tmp1_0;
    // Op 178: dim1x1 add
    gl64_t s0_178 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_178 + tmp1_0;
    // Op 179: dim1x1 add
    gl64_t s0_179 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_1 = s0_179 + tmp1_0;
    // Op 180: dim1x1 sub
    gl64_t s0_180 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_180 - tmp1_1;
    // Op 181: dim1x1 mul
    gl64_t s0_181 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_181 * tmp1_0;
    // Op 182: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC183 + kG183) - kF183;
    tmp3_1 = ((((kA183 + kC183) - kE183) - kE183) - kD183);
    tmp3_2 = kB183 - kG183;
    // Op 184: dim1x1 sub_swap
    gl64_t s0_184 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_184 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_184 - s0_184;
    // Op 185: dim1x1 sub
    gl64_t s1_185 = *(gl64_t*)&expressions_params[9][5];
    tmp1_1 = tmp1_1 - s1_185;
    // Op 186: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 187: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC188 + kG188) - kF188;
    tmp3_1 = ((((kA188 + kC188) - kE188) - kE188) - kD188);
    tmp3_2 = kB188 - kG188;
    // Op 189: dim1x1 add
    gl64_t s0_189 = *(gl64_t*)&expressions_params[9][5];
    gl64_t s1_189 = *(gl64_t*)&expressions_params[10][2];
    tmp1_0 = s0_189 + s1_189;
    // Op 190: dim1x1 sub
    gl64_t s0_190 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_190 - tmp1_0;
    // Op 191: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 192: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 193: dim3x3 mul
    gl64_t s1_193_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_193_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_193_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA193 = (tmp3_0 + tmp3_1) * (s1_193_0 + s1_193_1);
    gl64_t kB193 = (tmp3_0 + tmp3_2) * (s1_193_0 + s1_193_2);
    gl64_t kC193 = (tmp3_1 + tmp3_2) * (s1_193_1 + s1_193_2);
    gl64_t kD193 = tmp3_0 * s1_193_0;
    gl64_t kE193 = tmp3_1 * s1_193_1;
    gl64_t kF193 = tmp3_2 * s1_193_2;
    gl64_t kG193 = kD193 - kE193;
    tmp3_0 = (kC193 + kG193) - kF193;
    tmp3_1 = ((((kA193 + kC193) - kE193) - kE193) - kD193);
    tmp3_2 = kB193 - kG193;
    // Op 194: dim1x1 add
    gl64_t s0_194 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 5, domainSize, nCols_1))];
    gl64_t s1_194 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_194 + s1_194;
    // Op 195: dim1x1 sub
    gl64_t s0_195 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_195 - tmp1_0;
    // Op 196: dim1x1 mul
    tmp1_0 = tmp1_4 * tmp1_0;
    // Op 197: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC198 + kG198) - kF198;
    tmp3_1 = ((((kA198 + kC198) - kE198) - kE198) - kD198);
    tmp3_2 = kB198 - kG198;
    // Op 199: dim1x1 sub
    gl64_t s1_199 = *(gl64_t*)&expressions_params[10][5];
    tmp1_0 = tmp1_2 - s1_199;
    // Op 200: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 201: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 202: dim3x3 mul
    gl64_t s1_202_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_202_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_202_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA202 = (tmp3_0 + tmp3_1) * (s1_202_0 + s1_202_1);
    gl64_t kB202 = (tmp3_0 + tmp3_2) * (s1_202_0 + s1_202_2);
    gl64_t kC202 = (tmp3_1 + tmp3_2) * (s1_202_1 + s1_202_2);
    gl64_t kD202 = tmp3_0 * s1_202_0;
    gl64_t kE202 = tmp3_1 * s1_202_1;
    gl64_t kF202 = tmp3_2 * s1_202_2;
    gl64_t kG202 = kD202 - kE202;
    tmp3_0 = (kC202 + kG202) - kF202;
    tmp3_1 = ((((kA202 + kC202) - kE202) - kE202) - kD202);
    tmp3_2 = kB202 - kG202;
    // Op 203: dim1x1 mul
    gl64_t s0_203 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 2, domainSize, nCols_1))];
    gl64_t s1_203 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_203 * s1_203;
    // Op 204: dim1x1 sub
    tmp1_0 = tmp1_2 - tmp1_0;
    // Op 205: dim1x1 mul
    tmp1_0 = tmp1_4 * tmp1_0;
    // Op 206: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 207: dim3x3 mul
    gl64_t s1_207_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_207_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_207_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA207 = (tmp3_0 + tmp3_1) * (s1_207_0 + s1_207_1);
    gl64_t kB207 = (tmp3_0 + tmp3_2) * (s1_207_0 + s1_207_2);
    gl64_t kC207 = (tmp3_1 + tmp3_2) * (s1_207_1 + s1_207_2);
    gl64_t kD207 = tmp3_0 * s1_207_0;
    gl64_t kE207 = tmp3_1 * s1_207_1;
    gl64_t kF207 = tmp3_2 * s1_207_2;
    gl64_t kG207 = kD207 - kE207;
    tmp3_0 = (kC207 + kG207) - kF207;
    tmp3_1 = ((((kA207 + kC207) - kE207) - kE207) - kD207);
    tmp3_2 = kB207 - kG207;
    // Op 208: dim1x1 sub
    gl64_t s0_208 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_208 = *(gl64_t*)&expressions_params[10][3];
    tmp1_0 = s0_208 - s1_208;
    // Op 209: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 210: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 211: dim3x3 mul
    gl64_t s1_211_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_211_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_211_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA211 = (tmp3_0 + tmp3_1) * (s1_211_0 + s1_211_1);
    gl64_t kB211 = (tmp3_0 + tmp3_2) * (s1_211_0 + s1_211_2);
    gl64_t kC211 = (tmp3_1 + tmp3_2) * (s1_211_1 + s1_211_2);
    gl64_t kD211 = tmp3_0 * s1_211_0;
    gl64_t kE211 = tmp3_1 * s1_211_1;
    gl64_t kF211 = tmp3_2 * s1_211_2;
    gl64_t kG211 = kD211 - kE211;
    tmp3_0 = (kC211 + kG211) - kF211;
    tmp3_1 = ((((kA211 + kC211) - kE211) - kE211) - kD211);
    tmp3_2 = kB211 - kG211;
    // Op 212: dim1x1 sub
    gl64_t s0_212 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_212 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 4, domainSize, nCols_1))];
    tmp1_0 = s0_212 - s1_212;
    // Op 213: dim1x1 mul
    tmp1_0 = tmp1_4 * tmp1_0;
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
    gl64_t s1_216 = *(gl64_t*)&expressions_params[10][12];
    tmp1_0 = s0_216 - s1_216;
    // Op 217: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
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
    tmp1_0 = tmp1_4 * tmp1_0;
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
    // Op 224: dim1x1 mul
    gl64_t s0_224 = *(gl64_t*)&expressions_params[9][3];
    gl64_t s1_224 = *(gl64_t*)&expressions_params[10][15];
    tmp1_0 = s0_224 * s1_224;
    // Op 225: dim1x1 add
    gl64_t s1_225 = *(gl64_t*)&expressions_params[10][14];
    tmp1_0 = tmp1_0 + s1_225;
    // Op 226: dim1x1 sub
    gl64_t s1_226 = *(gl64_t*)&expressions_params[10][9];
    tmp1_0 = tmp1_0 - s1_226;
    // Op 227: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 228: dim3x3 mul
    gl64_t s1_228_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_228_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_228_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA228 = (tmp3_0 + tmp3_1) * (s1_228_0 + s1_228_1);
    gl64_t kB228 = (tmp3_0 + tmp3_2) * (s1_228_0 + s1_228_2);
    gl64_t kC228 = (tmp3_1 + tmp3_2) * (s1_228_1 + s1_228_2);
    gl64_t kD228 = tmp3_0 * s1_228_0;
    gl64_t kE228 = tmp3_1 * s1_228_1;
    gl64_t kF228 = tmp3_2 * s1_228_2;
    gl64_t kG228 = kD228 - kE228;
    tmp3_12 = (kC228 + kG228) - kF228;
    tmp3_13 = ((((kA228 + kC228) - kE228) - kE228) - kD228);
    tmp3_14 = kB228 - kG228;
    // Op 229: dim1x1 mul
    gl64_t s0_229 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_229 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_229 * s1_229;
    // Op 230: dim1x1 add
    gl64_t s0_230 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_230 + tmp1_0;
    // Op 231: dim1x1 mul
    gl64_t s0_231 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_231 = *(gl64_t*)&expressions_params[9][3];
    tmp1_4 = s0_231 * s1_231;
    // Op 232: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 233: dim1x1 mul
    gl64_t s0_233 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_233 = *(gl64_t*)&expressions_params[9][4];
    tmp1_4 = s0_233 * s1_233;
    // Op 234: dim1x1 add
    tmp1_4 = tmp1_0 + tmp1_4;
    // Op 235: dim3x1 mul
    gl64_t s0_235_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_235_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_235_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_235_0 * tmp1_4; tmp3_1 = s0_235_1 * tmp1_4; tmp3_2 = s0_235_2 * tmp1_4;
    // Op 236: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 237: dim3x3 mul
    gl64_t s1_237_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_237_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_237_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA237 = (tmp3_0 + tmp3_1) * (s1_237_0 + s1_237_1);
    gl64_t kB237 = (tmp3_0 + tmp3_2) * (s1_237_0 + s1_237_2);
    gl64_t kC237 = (tmp3_1 + tmp3_2) * (s1_237_1 + s1_237_2);
    gl64_t kD237 = tmp3_0 * s1_237_0;
    gl64_t kE237 = tmp3_1 * s1_237_1;
    gl64_t kF237 = tmp3_2 * s1_237_2;
    gl64_t kG237 = kD237 - kE237;
    tmp3_0 = (kC237 + kG237) - kF237;
    tmp3_1 = ((((kA237 + kC237) - kE237) - kE237) - kD237);
    tmp3_2 = kB237 - kG237;
    // Op 238: dim3x1 add
    gl64_t s1_238 = *(gl64_t*)&expressions_params[9][5];
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
    // Op 240: dim1x1 mul
    gl64_t s0_240 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_240 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = s0_240 * s1_240;
    // Op 241: dim1x1 add
    gl64_t s1_241 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_241;
    // Op 242: dim1x1 add
    gl64_t s0_242 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_242 + tmp1_0;
    // Op 243: dim1x1 add
    gl64_t s1_243 = *(gl64_t*)&expressions_params[9][7];
    tmp1_0 = tmp1_0 + s1_243;
    // Op 244: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 246: dim1x1 mul
    gl64_t s0_246 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_246 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_246 * s1_246;
    // Op 247: dim1x1 add
    gl64_t s1_247 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = tmp1_0 + s1_247;
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
    // Op 250: dim1x1 add
    gl64_t s0_250 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_250 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_250 + s1_250;
    // Op 251: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 253: dim3x1 add
    gl64_t s1_253 = *(gl64_t*)&expressions_params[9][9];
    tmp3_9 = tmp3_0 + s1_253; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 254: dim3x3 add
    gl64_t s1_254_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_254_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_254_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_254_0; tmp3_4 = tmp3_10 + s1_254_1; tmp3_5 = tmp3_11 + s1_254_2;
    // Op 255: dim3x1 mul
    gl64_t s0_255_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_255_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_255_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_255_0 * tmp1_4; tmp3_1 = s0_255_1 * tmp1_4; tmp3_2 = s0_255_2 * tmp1_4;
    // Op 256: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_258 = *(gl64_t*)&expressions_params[9][5];
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
    // Op 260: dim1x1 mul
    gl64_t s0_260 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_260 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = s0_260 * s1_260;
    // Op 261: dim1x1 add
    gl64_t s1_261 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_261;
    // Op 262: dim1x1 add
    gl64_t s0_262 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_262 + tmp1_0;
    // Op 263: dim1x1 add
    gl64_t s1_263 = *(gl64_t*)&expressions_params[9][7];
    tmp1_0 = tmp1_0 + s1_263;
    // Op 264: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 265: dim3x3 mul
    gl64_t s1_265_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_265_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_265_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA265 = (tmp3_0 + tmp3_1) * (s1_265_0 + s1_265_1);
    gl64_t kB265 = (tmp3_0 + tmp3_2) * (s1_265_0 + s1_265_2);
    gl64_t kC265 = (tmp3_1 + tmp3_2) * (s1_265_1 + s1_265_2);
    gl64_t kD265 = tmp3_0 * s1_265_0;
    gl64_t kE265 = tmp3_1 * s1_265_1;
    gl64_t kF265 = tmp3_2 * s1_265_2;
    gl64_t kG265 = kD265 - kE265;
    tmp3_0 = (kC265 + kG265) - kF265;
    tmp3_1 = ((((kA265 + kC265) - kE265) - kE265) - kD265);
    tmp3_2 = kB265 - kG265;
    // Op 266: dim1x1 mul
    gl64_t s0_266 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_266 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_266 * s1_266;
    // Op 267: dim1x1 add
    gl64_t s1_267 = *(gl64_t*)&expressions_params[9][8];
    tmp1_0 = tmp1_0 + s1_267;
    // Op 268: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 270: dim1x1 add
    gl64_t s0_270 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_270 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_270 + s1_270;
    // Op 271: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 272: dim3x3 mul
    gl64_t s1_272_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_272_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_272_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA272 = (tmp3_0 + tmp3_1) * (s1_272_0 + s1_272_1);
    gl64_t kB272 = (tmp3_0 + tmp3_2) * (s1_272_0 + s1_272_2);
    gl64_t kC272 = (tmp3_1 + tmp3_2) * (s1_272_1 + s1_272_2);
    gl64_t kD272 = tmp3_0 * s1_272_0;
    gl64_t kE272 = tmp3_1 * s1_272_1;
    gl64_t kF272 = tmp3_2 * s1_272_2;
    gl64_t kG272 = kD272 - kE272;
    tmp3_0 = (kC272 + kG272) - kF272;
    tmp3_1 = ((((kA272 + kC272) - kE272) - kE272) - kD272);
    tmp3_2 = kB272 - kG272;
    // Op 273: dim3x1 add
    gl64_t s1_273 = *(gl64_t*)&expressions_params[9][9];
    tmp3_6 = tmp3_0 + s1_273; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 274: dim3x3 add
    gl64_t s1_274_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_274_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_274_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_274_0; tmp3_1 = tmp3_7 + s1_274_1; tmp3_2 = tmp3_8 + s1_274_2;
    // Op 275: dim3x3 mul
    gl64_t kA275 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB275 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC275 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD275 = tmp3_3 * tmp3_0;
    gl64_t kE275 = tmp3_4 * tmp3_1;
    gl64_t kF275 = tmp3_5 * tmp3_2;
    gl64_t kG275 = kD275 - kE275;
    tmp3_0 = (kC275 + kG275) - kF275;
    tmp3_1 = ((((kA275 + kC275) - kE275) - kE275) - kD275);
    tmp3_2 = kB275 - kG275;
    // Op 276: dim3x3 mul
    gl64_t s0_276_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_276_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_276_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA276 = (s0_276_0 + s0_276_1) * (tmp3_0 + tmp3_1);
    gl64_t kB276 = (s0_276_0 + s0_276_2) * (tmp3_0 + tmp3_2);
    gl64_t kC276 = (s0_276_1 + s0_276_2) * (tmp3_1 + tmp3_2);
    gl64_t kD276 = s0_276_0 * tmp3_0;
    gl64_t kE276 = s0_276_1 * tmp3_1;
    gl64_t kF276 = s0_276_2 * tmp3_2;
    gl64_t kG276 = kD276 - kE276;
    tmp3_0 = (kC276 + kG276) - kF276;
    tmp3_1 = ((((kA276 + kC276) - kE276) - kE276) - kD276);
    tmp3_2 = kB276 - kG276;
    // Op 277: dim1x1 sub_swap
    gl64_t s0_277 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_277 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_277 - s0_277;
    // Op 278: dim3x3 add
    gl64_t s1_278_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_278_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_278_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_278_0; tmp3_7 = tmp3_7 + s1_278_1; tmp3_8 = tmp3_8 + s1_278_2;
    // Op 279: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 280: dim1x1 sub_swap
    gl64_t s0_280 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_280 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_280 - s0_280;
    // Op 281: dim3x3 add
    gl64_t s1_281_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_281_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_281_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_281_0; tmp3_10 = tmp3_10 + s1_281_1; tmp3_11 = tmp3_11 + s1_281_2;
    // Op 282: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 283: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 284: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 285: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 286: dim3x3 mul
    gl64_t s1_286_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_286_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_286_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA286 = (tmp3_0 + tmp3_1) * (s1_286_0 + s1_286_1);
    gl64_t kB286 = (tmp3_0 + tmp3_2) * (s1_286_0 + s1_286_2);
    gl64_t kC286 = (tmp3_1 + tmp3_2) * (s1_286_1 + s1_286_2);
    gl64_t kD286 = tmp3_0 * s1_286_0;
    gl64_t kE286 = tmp3_1 * s1_286_1;
    gl64_t kF286 = tmp3_2 * s1_286_2;
    gl64_t kG286 = kD286 - kE286;
    tmp3_3 = (kC286 + kG286) - kF286;
    tmp3_4 = ((((kA286 + kC286) - kE286) - kE286) - kD286);
    tmp3_5 = kB286 - kG286;
    // Op 287: dim3x1 mul
    gl64_t s0_287_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_287_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_287_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_287_0 * tmp1_4; tmp3_1 = s0_287_1 * tmp1_4; tmp3_2 = s0_287_2 * tmp1_4;
    // Op 288: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 290: dim3x1 add
    gl64_t s1_290 = *(gl64_t*)&expressions_params[9][5];
    tmp3_0 = tmp3_0 + s1_290; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 291: dim3x3 mul
    gl64_t s1_291_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_291_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_291_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA291 = (tmp3_0 + tmp3_1) * (s1_291_0 + s1_291_1);
    gl64_t kB291 = (tmp3_0 + tmp3_2) * (s1_291_0 + s1_291_2);
    gl64_t kC291 = (tmp3_1 + tmp3_2) * (s1_291_1 + s1_291_2);
    gl64_t kD291 = tmp3_0 * s1_291_0;
    gl64_t kE291 = tmp3_1 * s1_291_1;
    gl64_t kF291 = tmp3_2 * s1_291_2;
    gl64_t kG291 = kD291 - kE291;
    tmp3_0 = (kC291 + kG291) - kF291;
    tmp3_1 = ((((kA291 + kC291) - kE291) - kE291) - kD291);
    tmp3_2 = kB291 - kG291;
    // Op 292: dim1x1 mul
    gl64_t s0_292 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_292 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = s0_292 * s1_292;
    // Op 293: dim1x1 add
    gl64_t s1_293 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_293;
    // Op 294: dim1x1 add
    gl64_t s0_294 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_294 + tmp1_0;
    // Op 295: dim1x1 add
    gl64_t s1_295 = *(gl64_t*)&expressions_params[9][7];
    tmp1_0 = tmp1_0 + s1_295;
    // Op 296: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 297: dim3x3 mul
    gl64_t s1_297_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_297_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_297_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA297 = (tmp3_0 + tmp3_1) * (s1_297_0 + s1_297_1);
    gl64_t kB297 = (tmp3_0 + tmp3_2) * (s1_297_0 + s1_297_2);
    gl64_t kC297 = (tmp3_1 + tmp3_2) * (s1_297_1 + s1_297_2);
    gl64_t kD297 = tmp3_0 * s1_297_0;
    gl64_t kE297 = tmp3_1 * s1_297_1;
    gl64_t kF297 = tmp3_2 * s1_297_2;
    gl64_t kG297 = kD297 - kE297;
    tmp3_0 = (kC297 + kG297) - kF297;
    tmp3_1 = ((((kA297 + kC297) - kE297) - kE297) - kD297);
    tmp3_2 = kB297 - kG297;
    // Op 298: dim1x1 mul
    gl64_t s0_298 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_298 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_298 * s1_298;
    // Op 299: dim1x1 add
    gl64_t s1_299 = *(gl64_t*)&expressions_params[9][11];
    tmp1_0 = tmp1_0 + s1_299;
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
    // Op 302: dim1x1 add
    gl64_t s0_302 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_302 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_302 + s1_302;
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
    gl64_t s1_305 = *(gl64_t*)&expressions_params[9][9];
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
    tmp3_0 = s0_307_0 * tmp1_4; tmp3_1 = s0_307_1 * tmp1_4; tmp3_2 = s0_307_2 * tmp1_4;
    // Op 308: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_310 = *(gl64_t*)&expressions_params[9][5];
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
    // Op 312: dim1x1 mul
    gl64_t s0_312 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_312 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = s0_312 * s1_312;
    // Op 313: dim1x1 add
    gl64_t s1_313 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_313;
    // Op 314: dim1x1 add
    gl64_t s0_314 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_314 + tmp1_0;
    // Op 315: dim1x1 add
    gl64_t s1_315 = *(gl64_t*)&expressions_params[9][7];
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
    // Op 318: dim1x1 mul
    gl64_t s0_318 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_318 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_318 * s1_318;
    // Op 319: dim1x1 add
    gl64_t s1_319 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = tmp1_0 + s1_319;
    // Op 320: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 322: dim1x1 add
    gl64_t s0_322 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_322 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_322 + s1_322;
    // Op 323: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_325 = *(gl64_t*)&expressions_params[9][9];
    tmp3_6 = tmp3_0 + s1_325; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 326: dim3x3 add
    gl64_t s1_326_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_326_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_326_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_326_0; tmp3_1 = tmp3_7 + s1_326_1; tmp3_2 = tmp3_8 + s1_326_2;
    // Op 327: dim3x3 mul
    gl64_t kA327 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB327 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC327 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD327 = tmp3_12 * tmp3_0;
    gl64_t kE327 = tmp3_13 * tmp3_1;
    gl64_t kF327 = tmp3_14 * tmp3_2;
    gl64_t kG327 = kD327 - kE327;
    tmp3_0 = (kC327 + kG327) - kF327;
    tmp3_1 = ((((kA327 + kC327) - kE327) - kE327) - kD327);
    tmp3_2 = kB327 - kG327;
    // Op 328: dim3x3 mul
    gl64_t s0_328_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_328_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_328_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA328 = (s0_328_0 + s0_328_1) * (tmp3_0 + tmp3_1);
    gl64_t kB328 = (s0_328_0 + s0_328_2) * (tmp3_0 + tmp3_2);
    gl64_t kC328 = (s0_328_1 + s0_328_2) * (tmp3_1 + tmp3_2);
    gl64_t kD328 = s0_328_0 * tmp3_0;
    gl64_t kE328 = s0_328_1 * tmp3_1;
    gl64_t kF328 = s0_328_2 * tmp3_2;
    gl64_t kG328 = kD328 - kE328;
    tmp3_0 = (kC328 + kG328) - kF328;
    tmp3_1 = ((((kA328 + kC328) - kE328) - kE328) - kD328);
    tmp3_2 = kB328 - kG328;
    // Op 329: dim1x1 sub_swap
    gl64_t s0_329 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_329 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_329 - s0_329;
    // Op 330: dim3x3 add
    gl64_t s1_330_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_330_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_330_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_330_0; tmp3_7 = tmp3_7 + s1_330_1; tmp3_8 = tmp3_8 + s1_330_2;
    // Op 331: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 332: dim1x1 sub_swap
    gl64_t s0_332 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_332 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_332 - s0_332;
    // Op 333: dim3x3 add
    gl64_t s1_333_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_333_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_333_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_333_0; tmp3_10 = tmp3_10 + s1_333_1; tmp3_11 = tmp3_11 + s1_333_2;
    // Op 334: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 335: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 336: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 337: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 338: dim3x3 mul
    gl64_t s1_338_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_338_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_338_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA338 = (tmp3_0 + tmp3_1) * (s1_338_0 + s1_338_1);
    gl64_t kB338 = (tmp3_0 + tmp3_2) * (s1_338_0 + s1_338_2);
    gl64_t kC338 = (tmp3_1 + tmp3_2) * (s1_338_1 + s1_338_2);
    gl64_t kD338 = tmp3_0 * s1_338_0;
    gl64_t kE338 = tmp3_1 * s1_338_1;
    gl64_t kF338 = tmp3_2 * s1_338_2;
    gl64_t kG338 = kD338 - kE338;
    tmp3_12 = (kC338 + kG338) - kF338;
    tmp3_13 = ((((kA338 + kC338) - kE338) - kE338) - kD338);
    tmp3_14 = kB338 - kG338;
    // Op 339: dim3x1 mul
    gl64_t s0_339_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_339_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_339_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_339_0 * tmp1_4; tmp3_1 = s0_339_1 * tmp1_4; tmp3_2 = s0_339_2 * tmp1_4;
    // Op 340: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_342 = *(gl64_t*)&expressions_params[9][5];
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
    gl64_t s0_344 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_344 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = s0_344 * s1_344;
    // Op 345: dim1x1 add
    gl64_t s1_345 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_345;
    // Op 346: dim1x1 add
    gl64_t s0_346 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_346 + tmp1_0;
    // Op 347: dim1x1 add
    gl64_t s1_347 = *(gl64_t*)&expressions_params[9][7];
    tmp1_0 = tmp1_0 + s1_347;
    // Op 348: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 349: dim3x3 mul
    gl64_t s1_349_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_349_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_349_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA349 = (tmp3_0 + tmp3_1) * (s1_349_0 + s1_349_1);
    gl64_t kB349 = (tmp3_0 + tmp3_2) * (s1_349_0 + s1_349_2);
    gl64_t kC349 = (tmp3_1 + tmp3_2) * (s1_349_1 + s1_349_2);
    gl64_t kD349 = tmp3_0 * s1_349_0;
    gl64_t kE349 = tmp3_1 * s1_349_1;
    gl64_t kF349 = tmp3_2 * s1_349_2;
    gl64_t kG349 = kD349 - kE349;
    tmp3_0 = (kC349 + kG349) - kF349;
    tmp3_1 = ((((kA349 + kC349) - kE349) - kE349) - kD349);
    tmp3_2 = kB349 - kG349;
    // Op 350: dim1x1 mul
    gl64_t s0_350 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_350 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_350 * s1_350;
    // Op 351: dim1x1 add
    gl64_t s1_351 = *(gl64_t*)&expressions_params[9][13];
    tmp1_0 = tmp1_0 + s1_351;
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
    gl64_t s0_354 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_354 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_354 + s1_354;
    // Op 355: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 357: dim3x1 add
    gl64_t s1_357 = *(gl64_t*)&expressions_params[9][9];
    tmp3_9 = tmp3_0 + s1_357; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 358: dim3x3 add
    gl64_t s1_358_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_358_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_358_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_358_0; tmp3_4 = tmp3_10 + s1_358_1; tmp3_5 = tmp3_11 + s1_358_2;
    // Op 359: dim3x1 mul
    gl64_t s0_359_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_359_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_359_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_359_0 * tmp1_4; tmp3_1 = s0_359_1 * tmp1_4; tmp3_2 = s0_359_2 * tmp1_4;
    // Op 360: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 361: dim3x3 mul
    gl64_t s1_361_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_361_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_361_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA361 = (tmp3_0 + tmp3_1) * (s1_361_0 + s1_361_1);
    gl64_t kB361 = (tmp3_0 + tmp3_2) * (s1_361_0 + s1_361_2);
    gl64_t kC361 = (tmp3_1 + tmp3_2) * (s1_361_1 + s1_361_2);
    gl64_t kD361 = tmp3_0 * s1_361_0;
    gl64_t kE361 = tmp3_1 * s1_361_1;
    gl64_t kF361 = tmp3_2 * s1_361_2;
    gl64_t kG361 = kD361 - kE361;
    tmp3_0 = (kC361 + kG361) - kF361;
    tmp3_1 = ((((kA361 + kC361) - kE361) - kE361) - kD361);
    tmp3_2 = kB361 - kG361;
    // Op 362: dim3x1 add
    gl64_t s1_362 = *(gl64_t*)&expressions_params[9][5];
    tmp3_0 = tmp3_0 + s1_362; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s0_364 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_364 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = s0_364 * s1_364;
    // Op 365: dim1x1 add
    gl64_t s1_365 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_365;
    // Op 366: dim1x1 add
    gl64_t s0_366 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_366 + tmp1_0;
    // Op 367: dim1x1 add
    gl64_t s1_367 = *(gl64_t*)&expressions_params[9][7];
    tmp1_0 = tmp1_0 + s1_367;
    // Op 368: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 369: dim3x3 mul
    gl64_t s1_369_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_369_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_369_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA369 = (tmp3_0 + tmp3_1) * (s1_369_0 + s1_369_1);
    gl64_t kB369 = (tmp3_0 + tmp3_2) * (s1_369_0 + s1_369_2);
    gl64_t kC369 = (tmp3_1 + tmp3_2) * (s1_369_1 + s1_369_2);
    gl64_t kD369 = tmp3_0 * s1_369_0;
    gl64_t kE369 = tmp3_1 * s1_369_1;
    gl64_t kF369 = tmp3_2 * s1_369_2;
    gl64_t kG369 = kD369 - kE369;
    tmp3_0 = (kC369 + kG369) - kF369;
    tmp3_1 = ((((kA369 + kC369) - kE369) - kE369) - kD369);
    tmp3_2 = kB369 - kG369;
    // Op 370: dim1x1 mul
    gl64_t s0_370 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_370 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_370 * s1_370;
    // Op 371: dim1x1 add
    gl64_t s1_371 = *(gl64_t*)&expressions_params[9][12];
    tmp1_0 = tmp1_0 + s1_371;
    // Op 372: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 374: dim1x1 add
    gl64_t s0_374 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_374 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_374 + s1_374;
    // Op 375: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 377: dim3x1 add
    gl64_t s1_377 = *(gl64_t*)&expressions_params[9][9];
    tmp3_6 = tmp3_0 + s1_377; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 378: dim3x3 add
    gl64_t s1_378_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_378_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_378_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_378_0; tmp3_1 = tmp3_7 + s1_378_1; tmp3_2 = tmp3_8 + s1_378_2;
    // Op 379: dim3x3 mul
    gl64_t kA379 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB379 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC379 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD379 = tmp3_3 * tmp3_0;
    gl64_t kE379 = tmp3_4 * tmp3_1;
    gl64_t kF379 = tmp3_5 * tmp3_2;
    gl64_t kG379 = kD379 - kE379;
    tmp3_0 = (kC379 + kG379) - kF379;
    tmp3_1 = ((((kA379 + kC379) - kE379) - kE379) - kD379);
    tmp3_2 = kB379 - kG379;
    // Op 380: dim3x3 mul
    uint64_t s0_380_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_380_0 = *(gl64_t*)&dParams->aux_trace[s0_380_pos];
    gl64_t s0_380_1 = *(gl64_t*)&dParams->aux_trace[s0_380_pos + TILE_HEIGHT];
    gl64_t s0_380_2 = *(gl64_t*)&dParams->aux_trace[s0_380_pos + 2*TILE_HEIGHT];
    gl64_t kA380 = (s0_380_0 + s0_380_1) * (tmp3_0 + tmp3_1);
    gl64_t kB380 = (s0_380_0 + s0_380_2) * (tmp3_0 + tmp3_2);
    gl64_t kC380 = (s0_380_1 + s0_380_2) * (tmp3_1 + tmp3_2);
    gl64_t kD380 = s0_380_0 * tmp3_0;
    gl64_t kE380 = s0_380_1 * tmp3_1;
    gl64_t kF380 = s0_380_2 * tmp3_2;
    gl64_t kG380 = kD380 - kE380;
    tmp3_0 = (kC380 + kG380) - kF380;
    tmp3_1 = ((((kA380 + kC380) - kE380) - kE380) - kD380);
    tmp3_2 = kB380 - kG380;
    // Op 381: dim1x1 sub_swap
    gl64_t s0_381 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_381 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_381 - s0_381;
    // Op 382: dim3x3 add
    gl64_t s1_382_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_382_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_382_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_382_0; tmp3_7 = tmp3_7 + s1_382_1; tmp3_8 = tmp3_8 + s1_382_2;
    // Op 383: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 384: dim1x1 sub_swap
    gl64_t s0_384 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_384 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_384 - s0_384;
    // Op 385: dim3x3 add
    gl64_t s1_385_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_385_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_385_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_385_0; tmp3_10 = tmp3_10 + s1_385_1; tmp3_11 = tmp3_11 + s1_385_2;
    // Op 386: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 387: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 388: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 389: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 390: dim3x3 mul
    gl64_t s1_390_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_390_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_390_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA390 = (tmp3_0 + tmp3_1) * (s1_390_0 + s1_390_1);
    gl64_t kB390 = (tmp3_0 + tmp3_2) * (s1_390_0 + s1_390_2);
    gl64_t kC390 = (tmp3_1 + tmp3_2) * (s1_390_1 + s1_390_2);
    gl64_t kD390 = tmp3_0 * s1_390_0;
    gl64_t kE390 = tmp3_1 * s1_390_1;
    gl64_t kF390 = tmp3_2 * s1_390_2;
    gl64_t kG390 = kD390 - kE390;
    tmp3_3 = (kC390 + kG390) - kF390;
    tmp3_4 = ((((kA390 + kC390) - kE390) - kE390) - kD390);
    tmp3_5 = kB390 - kG390;
    // Op 391: dim3x1 mul
    gl64_t s0_391_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_391_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_391_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_391_0 * tmp1_4; tmp3_1 = s0_391_1 * tmp1_4; tmp3_2 = s0_391_2 * tmp1_4;
    // Op 392: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 393: dim3x3 mul
    gl64_t s1_393_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_393_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_393_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA393 = (tmp3_0 + tmp3_1) * (s1_393_0 + s1_393_1);
    gl64_t kB393 = (tmp3_0 + tmp3_2) * (s1_393_0 + s1_393_2);
    gl64_t kC393 = (tmp3_1 + tmp3_2) * (s1_393_1 + s1_393_2);
    gl64_t kD393 = tmp3_0 * s1_393_0;
    gl64_t kE393 = tmp3_1 * s1_393_1;
    gl64_t kF393 = tmp3_2 * s1_393_2;
    gl64_t kG393 = kD393 - kE393;
    tmp3_0 = (kC393 + kG393) - kF393;
    tmp3_1 = ((((kA393 + kC393) - kE393) - kE393) - kD393);
    tmp3_2 = kB393 - kG393;
    // Op 394: dim3x1 add
    gl64_t s1_394 = *(gl64_t*)&expressions_params[9][5];
    tmp3_0 = tmp3_0 + s1_394; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s0_396 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_396 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = s0_396 * s1_396;
    // Op 397: dim1x1 add
    gl64_t s1_397 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_397;
    // Op 398: dim1x1 add
    gl64_t s0_398 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_398 + tmp1_0;
    // Op 399: dim1x1 add
    gl64_t s1_399 = *(gl64_t*)&expressions_params[9][7];
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
    gl64_t s0_402 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_402 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_402 * s1_402;
    // Op 403: dim1x1 add
    gl64_t s1_403 = *(gl64_t*)&expressions_params[9][16];
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
    gl64_t s0_406 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_406 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_406 + s1_406;
    // Op 407: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 409: dim3x1 add
    gl64_t s1_409 = *(gl64_t*)&expressions_params[9][9];
    tmp3_9 = tmp3_0 + s1_409; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 410: dim3x3 add
    gl64_t s1_410_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_410_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_410_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_410_0; tmp3_13 = tmp3_10 + s1_410_1; tmp3_14 = tmp3_11 + s1_410_2;
    // Op 411: dim3x1 mul
    gl64_t s0_411_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_411_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_411_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_411 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp3_0 = s0_411_0 * s1_411; tmp3_1 = s0_411_1 * s1_411; tmp3_2 = s0_411_2 * s1_411;
    // Op 412: dim3x1 add
    gl64_t s1_412 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_412; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 414: dim3x3 mul
    gl64_t s1_414_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_414_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_414_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA414 = (tmp3_0 + tmp3_1) * (s1_414_0 + s1_414_1);
    gl64_t kB414 = (tmp3_0 + tmp3_2) * (s1_414_0 + s1_414_2);
    gl64_t kC414 = (tmp3_1 + tmp3_2) * (s1_414_1 + s1_414_2);
    gl64_t kD414 = tmp3_0 * s1_414_0;
    gl64_t kE414 = tmp3_1 * s1_414_1;
    gl64_t kF414 = tmp3_2 * s1_414_2;
    gl64_t kG414 = kD414 - kE414;
    tmp3_0 = (kC414 + kG414) - kF414;
    tmp3_1 = ((((kA414 + kC414) - kE414) - kE414) - kD414);
    tmp3_2 = kB414 - kG414;
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
    // Op 416: dim1x1 mul
    gl64_t s0_416 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_416 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_416 * s1_416;
    // Op 417: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 420: dim1x1 mul
    gl64_t s0_420 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_420 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_420 * s1_420;
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
    // Op 423: dim3x3 mul
    gl64_t s1_423_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_423_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_423_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA423 = (tmp3_0 + tmp3_1) * (s1_423_0 + s1_423_1);
    gl64_t kB423 = (tmp3_0 + tmp3_2) * (s1_423_0 + s1_423_2);
    gl64_t kC423 = (tmp3_1 + tmp3_2) * (s1_423_1 + s1_423_2);
    gl64_t kD423 = tmp3_0 * s1_423_0;
    gl64_t kE423 = tmp3_1 * s1_423_1;
    gl64_t kF423 = tmp3_2 * s1_423_2;
    gl64_t kG423 = kD423 - kE423;
    tmp3_0 = (kC423 + kG423) - kF423;
    tmp3_1 = ((((kA423 + kC423) - kE423) - kE423) - kD423);
    tmp3_2 = kB423 - kG423;
    // Op 424: dim1x1 mul
    gl64_t s0_424 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_424 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_424 * s1_424;
    // Op 425: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 427: dim1x1 mul
    gl64_t s0_427 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_427 = *(gl64_t*)&expressions_params[9][14];
    tmp1_0 = s0_427 * s1_427;
    // Op 428: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 429: dim3x3 mul
    gl64_t s1_429_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_429_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_429_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA429 = (tmp3_0 + tmp3_1) * (s1_429_0 + s1_429_1);
    gl64_t kB429 = (tmp3_0 + tmp3_2) * (s1_429_0 + s1_429_2);
    gl64_t kC429 = (tmp3_1 + tmp3_2) * (s1_429_1 + s1_429_2);
    gl64_t kD429 = tmp3_0 * s1_429_0;
    gl64_t kE429 = tmp3_1 * s1_429_1;
    gl64_t kF429 = tmp3_2 * s1_429_2;
    gl64_t kG429 = kD429 - kE429;
    tmp3_0 = (kC429 + kG429) - kF429;
    tmp3_1 = ((((kA429 + kC429) - kE429) - kE429) - kD429);
    tmp3_2 = kB429 - kG429;
    // Op 430: dim3x1 add
    gl64_t s1_430 = *(gl64_t*)&expressions_params[9][15];
    tmp3_6 = tmp3_0 + s1_430; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 431: dim3x3 add
    gl64_t s1_431_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_431_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_431_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_431_0; tmp3_1 = tmp3_7 + s1_431_1; tmp3_2 = tmp3_8 + s1_431_2;
    // Op 432: dim3x3 mul
    gl64_t kA432 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB432 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC432 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD432 = tmp3_12 * tmp3_0;
    gl64_t kE432 = tmp3_13 * tmp3_1;
    gl64_t kF432 = tmp3_14 * tmp3_2;
    gl64_t kG432 = kD432 - kE432;
    tmp3_0 = (kC432 + kG432) - kF432;
    tmp3_1 = ((((kA432 + kC432) - kE432) - kE432) - kD432);
    tmp3_2 = kB432 - kG432;
    // Op 433: dim3x3 mul
    uint64_t s0_433_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_433_0 = *(gl64_t*)&dParams->aux_trace[s0_433_pos];
    gl64_t s0_433_1 = *(gl64_t*)&dParams->aux_trace[s0_433_pos + TILE_HEIGHT];
    gl64_t s0_433_2 = *(gl64_t*)&dParams->aux_trace[s0_433_pos + 2*TILE_HEIGHT];
    gl64_t kA433 = (s0_433_0 + s0_433_1) * (tmp3_0 + tmp3_1);
    gl64_t kB433 = (s0_433_0 + s0_433_2) * (tmp3_0 + tmp3_2);
    gl64_t kC433 = (s0_433_1 + s0_433_2) * (tmp3_1 + tmp3_2);
    gl64_t kD433 = s0_433_0 * tmp3_0;
    gl64_t kE433 = s0_433_1 * tmp3_1;
    gl64_t kF433 = s0_433_2 * tmp3_2;
    gl64_t kG433 = kD433 - kE433;
    tmp3_0 = (kC433 + kG433) - kF433;
    tmp3_1 = ((((kA433 + kC433) - kE433) - kE433) - kD433);
    tmp3_2 = kB433 - kG433;
    // Op 434: dim1x1 sub_swap
    gl64_t s0_434 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_434 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_434 - s0_434;
    // Op 435: dim3x3 add
    gl64_t s1_435_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_435_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_435_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_435_0; tmp3_7 = tmp3_7 + s1_435_1; tmp3_8 = tmp3_8 + s1_435_2;
    // Op 436: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 437: dim3x3 add
    gl64_t s1_437_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_437_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_437_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_437_0; tmp3_10 = tmp3_10 + s1_437_1; tmp3_11 = tmp3_11 + s1_437_2;
    // Op 438: dim3x1 mul
    gl64_t s1_438 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_438; tmp3_10 = tmp3_10 * s1_438; tmp3_11 = tmp3_11 * s1_438;
    // Op 439: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 440: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 441: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 442: dim3x3 mul
    gl64_t s1_442_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_442_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_442_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA442 = (tmp3_0 + tmp3_1) * (s1_442_0 + s1_442_1);
    gl64_t kB442 = (tmp3_0 + tmp3_2) * (s1_442_0 + s1_442_2);
    gl64_t kC442 = (tmp3_1 + tmp3_2) * (s1_442_1 + s1_442_2);
    gl64_t kD442 = tmp3_0 * s1_442_0;
    gl64_t kE442 = tmp3_1 * s1_442_1;
    gl64_t kF442 = tmp3_2 * s1_442_2;
    gl64_t kG442 = kD442 - kE442;
    tmp3_6 = (kC442 + kG442) - kF442;
    tmp3_7 = ((((kA442 + kC442) - kE442) - kE442) - kD442);
    tmp3_8 = kB442 - kG442;
    // Op 443: dim1x1 sub_swap
    gl64_t s0_443 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_443 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_443 - s0_443;
    // Op 444: dim3x1 mul
    uint64_t s0_444_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_444_0 = *(gl64_t*)&dParams->aux_trace[s0_444_pos];
    gl64_t s0_444_1 = *(gl64_t*)&dParams->aux_trace[s0_444_pos + TILE_HEIGHT];
    gl64_t s0_444_2 = *(gl64_t*)&dParams->aux_trace[s0_444_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_444_0 * tmp1_0; tmp3_1 = s0_444_1 * tmp1_0; tmp3_2 = s0_444_2 * tmp1_0;
    // Op 445: dim3x3 sub
    uint64_t s0_445_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_445_0 = *(gl64_t*)&dParams->aux_trace[s0_445_pos];
    gl64_t s0_445_1 = *(gl64_t*)&dParams->aux_trace[s0_445_pos + TILE_HEIGHT];
    gl64_t s0_445_2 = *(gl64_t*)&dParams->aux_trace[s0_445_pos + 2*TILE_HEIGHT];
    tmp3_3 = s0_445_0 - tmp3_0; tmp3_4 = s0_445_1 - tmp3_1; tmp3_5 = s0_445_2 - tmp3_2;
    // Op 446: dim3x3 add
    gl64_t s0_446_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_446_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_446_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_446_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_446_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_446_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_0 = s0_446_0 + s1_446_0; tmp3_1 = s0_446_1 + s1_446_1; tmp3_2 = s0_446_2 + s1_446_2;
    // Op 447: dim3x3 add
    uint64_t s0_447_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_447_0 = *(gl64_t*)&dParams->aux_trace[s0_447_pos];
    gl64_t s0_447_1 = *(gl64_t*)&dParams->aux_trace[s0_447_pos + TILE_HEIGHT];
    gl64_t s0_447_2 = *(gl64_t*)&dParams->aux_trace[s0_447_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_447_0 + tmp3_0; tmp3_1 = s0_447_1 + tmp3_1; tmp3_2 = s0_447_2 + tmp3_2;
    // Op 448: dim3x3 add
    uint64_t s0_448_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_448_0 = *(gl64_t*)&dParams->aux_trace[s0_448_pos];
    gl64_t s0_448_1 = *(gl64_t*)&dParams->aux_trace[s0_448_pos + TILE_HEIGHT];
    gl64_t s0_448_2 = *(gl64_t*)&dParams->aux_trace[s0_448_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_448_0 + tmp3_0; tmp3_1 = s0_448_1 + tmp3_1; tmp3_2 = s0_448_2 + tmp3_2;
    // Op 449: dim3x3 sub
    tmp3_3 = tmp3_3 - tmp3_0; tmp3_4 = tmp3_4 - tmp3_1; tmp3_5 = tmp3_5 - tmp3_2;
    // Op 450: dim3x1 mul
    gl64_t s0_450_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_450_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_450_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_450_0 * tmp1_4; tmp3_1 = s0_450_1 * tmp1_4; tmp3_2 = s0_450_2 * tmp1_4;
    // Op 451: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 453: dim3x1 add
    gl64_t s1_453 = *(gl64_t*)&expressions_params[9][5];
    tmp3_0 = tmp3_0 + s1_453; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 454: dim3x3 mul
    gl64_t s1_454_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_454_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_454_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA454 = (tmp3_0 + tmp3_1) * (s1_454_0 + s1_454_1);
    gl64_t kB454 = (tmp3_0 + tmp3_2) * (s1_454_0 + s1_454_2);
    gl64_t kC454 = (tmp3_1 + tmp3_2) * (s1_454_1 + s1_454_2);
    gl64_t kD454 = tmp3_0 * s1_454_0;
    gl64_t kE454 = tmp3_1 * s1_454_1;
    gl64_t kF454 = tmp3_2 * s1_454_2;
    gl64_t kG454 = kD454 - kE454;
    tmp3_0 = (kC454 + kG454) - kF454;
    tmp3_1 = ((((kA454 + kC454) - kE454) - kE454) - kD454);
    tmp3_2 = kB454 - kG454;
    // Op 455: dim1x1 mul
    gl64_t s0_455 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_455 = *(gl64_t*)&expressions_params[9][6];
    tmp1_4 = s0_455 * s1_455;
    // Op 456: dim1x1 add
    gl64_t s1_456 = *(gl64_t*)&expressions_params[9][0];
    tmp1_4 = tmp1_4 + s1_456;
    // Op 457: dim1x1 add
    gl64_t s0_457 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_4 = s0_457 + tmp1_4;
    // Op 458: dim1x1 add
    gl64_t s1_458 = *(gl64_t*)&expressions_params[9][7];
    tmp1_4 = tmp1_4 + s1_458;
    // Op 459: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 460: dim3x3 mul
    gl64_t s1_460_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_460_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_460_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA460 = (tmp3_0 + tmp3_1) * (s1_460_0 + s1_460_1);
    gl64_t kB460 = (tmp3_0 + tmp3_2) * (s1_460_0 + s1_460_2);
    gl64_t kC460 = (tmp3_1 + tmp3_2) * (s1_460_1 + s1_460_2);
    gl64_t kD460 = tmp3_0 * s1_460_0;
    gl64_t kE460 = tmp3_1 * s1_460_1;
    gl64_t kF460 = tmp3_2 * s1_460_2;
    gl64_t kG460 = kD460 - kE460;
    tmp3_0 = (kC460 + kG460) - kF460;
    tmp3_1 = ((((kA460 + kC460) - kE460) - kE460) - kD460);
    tmp3_2 = kB460 - kG460;
    // Op 461: dim1x1 mul
    gl64_t s0_461 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_461 = *(gl64_t*)&expressions_params[9][5];
    tmp1_4 = s0_461 * s1_461;
    // Op 462: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 464: dim1x1 add
    gl64_t s0_464 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_464 = *(gl64_t*)&expressions_params[9][0];
    tmp1_4 = s0_464 + s1_464;
    // Op 465: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_467 = *(gl64_t*)&expressions_params[9][9];
    tmp3_0 = tmp3_0 + s1_467; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 468: dim3x3 add
    gl64_t s1_468_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_468_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_468_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_468_0; tmp3_1 = tmp3_1 + s1_468_1; tmp3_2 = tmp3_2 + s1_468_2;
    // Op 469: dim3x3 mul
    gl64_t kA469 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB469 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC469 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD469 = tmp3_3 * tmp3_0;
    gl64_t kE469 = tmp3_4 * tmp3_1;
    gl64_t kF469 = tmp3_5 * tmp3_2;
    gl64_t kG469 = kD469 - kE469;
    tmp3_0 = (kC469 + kG469) - kF469;
    tmp3_1 = ((((kA469 + kC469) - kE469) - kE469) - kD469);
    tmp3_2 = kB469 - kG469;
    // Op 470: dim1x1 sub_swap
    gl64_t s0_470 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_470 = *(gl64_t*)&expressions_params[9][1];
    tmp1_4 = s1_470 - s0_470;
    // Op 471: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 472: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 473: dim3x3 mul
    gl64_t s1_473_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_473_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_473_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA473 = (tmp3_0 + tmp3_1) * (s1_473_0 + s1_473_1);
    gl64_t kB473 = (tmp3_0 + tmp3_2) * (s1_473_0 + s1_473_2);
    gl64_t kC473 = (tmp3_1 + tmp3_2) * (s1_473_1 + s1_473_2);
    gl64_t kD473 = tmp3_0 * s1_473_0;
    gl64_t kE473 = tmp3_1 * s1_473_1;
    gl64_t kF473 = tmp3_2 * s1_473_2;
    gl64_t kG473 = kD473 - kE473;
    tmp3_6 = (kC473 + kG473) - kF473;
    tmp3_7 = ((((kA473 + kC473) - kE473) - kE473) - kD473);
    tmp3_8 = kB473 - kG473;
    // Op 474: dim3x1 mul
    gl64_t s0_474_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_474_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_474_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_474 = *(gl64_t*)&expressions_params[10][5];
    tmp3_0 = s0_474_0 * s1_474; tmp3_1 = s0_474_1 * s1_474; tmp3_2 = s0_474_2 * s1_474;
    // Op 475: dim3x1 add
    gl64_t s1_475 = *(gl64_t*)&expressions_params[10][12];
    tmp3_0 = tmp3_0 + s1_475; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 476: dim3x3 mul
    gl64_t s1_476_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_476_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_476_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA476 = (tmp3_0 + tmp3_1) * (s1_476_0 + s1_476_1);
    gl64_t kB476 = (tmp3_0 + tmp3_2) * (s1_476_0 + s1_476_2);
    gl64_t kC476 = (tmp3_1 + tmp3_2) * (s1_476_1 + s1_476_2);
    gl64_t kD476 = tmp3_0 * s1_476_0;
    gl64_t kE476 = tmp3_1 * s1_476_1;
    gl64_t kF476 = tmp3_2 * s1_476_2;
    gl64_t kG476 = kD476 - kE476;
    tmp3_0 = (kC476 + kG476) - kF476;
    tmp3_1 = ((((kA476 + kC476) - kE476) - kE476) - kD476);
    tmp3_2 = kB476 - kG476;
    // Op 477: dim3x1 add
    gl64_t s1_477 = *(gl64_t*)&expressions_params[10][3];
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
    gl64_t s1_479 = *(gl64_t*)&expressions_params[10][4];
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
    // Op 481: dim3x1 add
    gl64_t s1_481 = *(gl64_t*)&expressions_params[10][2];
    tmp3_0 = tmp3_0 + s1_481; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 482: dim3x3 mul
    gl64_t s1_482_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_482_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_482_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA482 = (tmp3_0 + tmp3_1) * (s1_482_0 + s1_482_1);
    gl64_t kB482 = (tmp3_0 + tmp3_2) * (s1_482_0 + s1_482_2);
    gl64_t kC482 = (tmp3_1 + tmp3_2) * (s1_482_1 + s1_482_2);
    gl64_t kD482 = tmp3_0 * s1_482_0;
    gl64_t kE482 = tmp3_1 * s1_482_1;
    gl64_t kF482 = tmp3_2 * s1_482_2;
    gl64_t kG482 = kD482 - kE482;
    tmp3_0 = (kC482 + kG482) - kF482;
    tmp3_1 = ((((kA482 + kC482) - kE482) - kE482) - kD482);
    tmp3_2 = kB482 - kG482;
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
    gl64_t s1_484 = *(gl64_t*)&expressions_params[10][1];
    tmp3_0 = tmp3_0 + s1_484; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 486: dim3x1 add
    gl64_t s1_486 = *(gl64_t*)&expressions_params[9][17];
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
    // Op 488: dim3x3 mul
    gl64_t s1_488_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_488_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_488_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA488 = (tmp3_0 + tmp3_1) * (s1_488_0 + s1_488_1);
    gl64_t kB488 = (tmp3_0 + tmp3_2) * (s1_488_0 + s1_488_2);
    gl64_t kC488 = (tmp3_1 + tmp3_2) * (s1_488_1 + s1_488_2);
    gl64_t kD488 = tmp3_0 * s1_488_0;
    gl64_t kE488 = tmp3_1 * s1_488_1;
    gl64_t kF488 = tmp3_2 * s1_488_2;
    gl64_t kG488 = kD488 - kE488;
    tmp3_0 = (kC488 + kG488) - kF488;
    tmp3_1 = ((((kA488 + kC488) - kE488) - kE488) - kD488);
    tmp3_2 = kB488 - kG488;
    // Op 489: dim3x1 add
    gl64_t s1_489 = *(gl64_t*)&expressions_params[10][0];
    tmp3_0 = tmp3_0 + s1_489; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 490: dim3x3 mul
    gl64_t s1_490_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_490_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_490_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA490 = (tmp3_0 + tmp3_1) * (s1_490_0 + s1_490_1);
    gl64_t kB490 = (tmp3_0 + tmp3_2) * (s1_490_0 + s1_490_2);
    gl64_t kC490 = (tmp3_1 + tmp3_2) * (s1_490_1 + s1_490_2);
    gl64_t kD490 = tmp3_0 * s1_490_0;
    gl64_t kE490 = tmp3_1 * s1_490_1;
    gl64_t kF490 = tmp3_2 * s1_490_2;
    gl64_t kG490 = kD490 - kE490;
    tmp3_0 = (kC490 + kG490) - kF490;
    tmp3_1 = ((((kA490 + kC490) - kE490) - kE490) - kD490);
    tmp3_2 = kB490 - kG490;
    // Op 491: dim3x1 add
    gl64_t s1_491 = *(gl64_t*)&expressions_params[9][18];
    tmp3_0 = tmp3_0 + s1_491; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 492: dim3x3 add
    gl64_t s1_492_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_492_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_492_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_492_0; tmp3_1 = tmp3_1 + s1_492_1; tmp3_2 = tmp3_2 + s1_492_2;
    // Op 493: dim3x3 mul
    gl64_t s1_493_0 = *(gl64_t*)&expressions_params[10][17];
    gl64_t s1_493_1 = *(gl64_t*)&expressions_params[10][17+1];
    gl64_t s1_493_2 = *(gl64_t*)&expressions_params[10][17+2];
    gl64_t kA493 = (tmp3_0 + tmp3_1) * (s1_493_0 + s1_493_1);
    gl64_t kB493 = (tmp3_0 + tmp3_2) * (s1_493_0 + s1_493_2);
    gl64_t kC493 = (tmp3_1 + tmp3_2) * (s1_493_1 + s1_493_2);
    gl64_t kD493 = tmp3_0 * s1_493_0;
    gl64_t kE493 = tmp3_1 * s1_493_1;
    gl64_t kF493 = tmp3_2 * s1_493_2;
    gl64_t kG493 = kD493 - kE493;
    tmp3_0 = (kC493 + kG493) - kF493;
    tmp3_1 = ((((kA493 + kC493) - kE493) - kE493) - kD493);
    tmp3_2 = kB493 - kG493;
    // Op 494: dim3x1 add
    gl64_t s1_494 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_494; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 495: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 496: dim3x3 mul
    gl64_t s1_496_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_496_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_496_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA496 = (tmp3_0 + tmp3_1) * (s1_496_0 + s1_496_1);
    gl64_t kB496 = (tmp3_0 + tmp3_2) * (s1_496_0 + s1_496_2);
    gl64_t kC496 = (tmp3_1 + tmp3_2) * (s1_496_1 + s1_496_2);
    gl64_t kD496 = tmp3_0 * s1_496_0;
    gl64_t kE496 = tmp3_1 * s1_496_1;
    gl64_t kF496 = tmp3_2 * s1_496_2;
    gl64_t kG496 = kD496 - kE496;
    tmp3_6 = (kC496 + kG496) - kF496;
    tmp3_7 = ((((kA496 + kC496) - kE496) - kE496) - kD496);
    tmp3_8 = kB496 - kG496;
    // Op 497: dim3x1 mul
    gl64_t s0_497_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_497_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_497_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_497 = *(gl64_t*)&expressions_params[10][10];
    tmp3_0 = s0_497_0 * s1_497; tmp3_1 = s0_497_1 * s1_497; tmp3_2 = s0_497_2 * s1_497;
    // Op 498: dim3x1 add
    gl64_t s1_498 = *(gl64_t*)&expressions_params[10][13];
    tmp3_0 = tmp3_0 + s1_498; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 499: dim3x3 mul
    gl64_t s1_499_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_499_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_499_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA499 = (tmp3_0 + tmp3_1) * (s1_499_0 + s1_499_1);
    gl64_t kB499 = (tmp3_0 + tmp3_2) * (s1_499_0 + s1_499_2);
    gl64_t kC499 = (tmp3_1 + tmp3_2) * (s1_499_1 + s1_499_2);
    gl64_t kD499 = tmp3_0 * s1_499_0;
    gl64_t kE499 = tmp3_1 * s1_499_1;
    gl64_t kF499 = tmp3_2 * s1_499_2;
    gl64_t kG499 = kD499 - kE499;
    tmp3_0 = (kC499 + kG499) - kF499;
    tmp3_1 = ((((kA499 + kC499) - kE499) - kE499) - kD499);
    tmp3_2 = kB499 - kG499;
    // Op 500: dim3x1 add
    gl64_t s1_500 = *(gl64_t*)&expressions_params[10][8];
    tmp3_0 = tmp3_0 + s1_500; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 501: dim3x3 mul
    gl64_t s1_501_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_501_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_501_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    gl64_t s1_502 = *(gl64_t*)&expressions_params[10][9];
    tmp3_0 = tmp3_0 + s1_502; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 503: dim3x3 mul
    gl64_t s1_503_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_503_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_503_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA503 = (tmp3_0 + tmp3_1) * (s1_503_0 + s1_503_1);
    gl64_t kB503 = (tmp3_0 + tmp3_2) * (s1_503_0 + s1_503_2);
    gl64_t kC503 = (tmp3_1 + tmp3_2) * (s1_503_1 + s1_503_2);
    gl64_t kD503 = tmp3_0 * s1_503_0;
    gl64_t kE503 = tmp3_1 * s1_503_1;
    gl64_t kF503 = tmp3_2 * s1_503_2;
    gl64_t kG503 = kD503 - kE503;
    tmp3_0 = (kC503 + kG503) - kF503;
    tmp3_1 = ((((kA503 + kC503) - kE503) - kE503) - kD503);
    tmp3_2 = kB503 - kG503;
    // Op 504: dim3x1 add
    gl64_t s1_504 = *(gl64_t*)&expressions_params[10][7];
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
    // Op 506: dim3x3 mul
    gl64_t s1_506_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_506_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_506_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA506 = (tmp3_0 + tmp3_1) * (s1_506_0 + s1_506_1);
    gl64_t kB506 = (tmp3_0 + tmp3_2) * (s1_506_0 + s1_506_2);
    gl64_t kC506 = (tmp3_1 + tmp3_2) * (s1_506_1 + s1_506_2);
    gl64_t kD506 = tmp3_0 * s1_506_0;
    gl64_t kE506 = tmp3_1 * s1_506_1;
    gl64_t kF506 = tmp3_2 * s1_506_2;
    gl64_t kG506 = kD506 - kE506;
    tmp3_0 = (kC506 + kG506) - kF506;
    tmp3_1 = ((((kA506 + kC506) - kE506) - kE506) - kD506);
    tmp3_2 = kB506 - kG506;
    // Op 507: dim3x1 add
    gl64_t s1_507 = *(gl64_t*)&expressions_params[10][6];
    tmp3_0 = tmp3_0 + s1_507; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 508: dim3x3 mul
    gl64_t s1_508_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_508_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_508_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA508 = (tmp3_0 + tmp3_1) * (s1_508_0 + s1_508_1);
    gl64_t kB508 = (tmp3_0 + tmp3_2) * (s1_508_0 + s1_508_2);
    gl64_t kC508 = (tmp3_1 + tmp3_2) * (s1_508_1 + s1_508_2);
    gl64_t kD508 = tmp3_0 * s1_508_0;
    gl64_t kE508 = tmp3_1 * s1_508_1;
    gl64_t kF508 = tmp3_2 * s1_508_2;
    gl64_t kG508 = kD508 - kE508;
    tmp3_0 = (kC508 + kG508) - kF508;
    tmp3_1 = ((((kA508 + kC508) - kE508) - kE508) - kD508);
    tmp3_2 = kB508 - kG508;
    // Op 509: dim3x1 add
    gl64_t s1_509 = *(gl64_t*)&expressions_params[9][17];
    tmp3_0 = tmp3_0 + s1_509; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 510: dim3x3 mul
    gl64_t s1_510_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_510_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_510_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA510 = (tmp3_0 + tmp3_1) * (s1_510_0 + s1_510_1);
    gl64_t kB510 = (tmp3_0 + tmp3_2) * (s1_510_0 + s1_510_2);
    gl64_t kC510 = (tmp3_1 + tmp3_2) * (s1_510_1 + s1_510_2);
    gl64_t kD510 = tmp3_0 * s1_510_0;
    gl64_t kE510 = tmp3_1 * s1_510_1;
    gl64_t kF510 = tmp3_2 * s1_510_2;
    gl64_t kG510 = kD510 - kE510;
    tmp3_0 = (kC510 + kG510) - kF510;
    tmp3_1 = ((((kA510 + kC510) - kE510) - kE510) - kD510);
    tmp3_2 = kB510 - kG510;
    // Op 511: dim3x1 add
    gl64_t s1_511 = *(gl64_t*)&expressions_params[10][11];
    tmp3_0 = tmp3_0 + s1_511; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 512: dim3x3 mul
    gl64_t s1_512_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_512_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_512_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA512 = (tmp3_0 + tmp3_1) * (s1_512_0 + s1_512_1);
    gl64_t kB512 = (tmp3_0 + tmp3_2) * (s1_512_0 + s1_512_2);
    gl64_t kC512 = (tmp3_1 + tmp3_2) * (s1_512_1 + s1_512_2);
    gl64_t kD512 = tmp3_0 * s1_512_0;
    gl64_t kE512 = tmp3_1 * s1_512_1;
    gl64_t kF512 = tmp3_2 * s1_512_2;
    gl64_t kG512 = kD512 - kE512;
    tmp3_0 = (kC512 + kG512) - kF512;
    tmp3_1 = ((((kA512 + kC512) - kE512) - kE512) - kD512);
    tmp3_2 = kB512 - kG512;
    // Op 513: dim1x1 add
    gl64_t s0_513 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_513 = *(gl64_t*)&expressions_params[10][0];
    tmp1_4 = s0_513 + s1_513;
    // Op 514: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 515: dim3x3 mul
    gl64_t s1_515_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_515_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_515_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA515 = (tmp3_0 + tmp3_1) * (s1_515_0 + s1_515_1);
    gl64_t kB515 = (tmp3_0 + tmp3_2) * (s1_515_0 + s1_515_2);
    gl64_t kC515 = (tmp3_1 + tmp3_2) * (s1_515_1 + s1_515_2);
    gl64_t kD515 = tmp3_0 * s1_515_0;
    gl64_t kE515 = tmp3_1 * s1_515_1;
    gl64_t kF515 = tmp3_2 * s1_515_2;
    gl64_t kG515 = kD515 - kE515;
    tmp3_0 = (kC515 + kG515) - kF515;
    tmp3_1 = ((((kA515 + kC515) - kE515) - kE515) - kD515);
    tmp3_2 = kB515 - kG515;
    // Op 516: dim3x1 add
    gl64_t s1_516 = *(gl64_t*)&expressions_params[9][18];
    tmp3_0 = tmp3_0 + s1_516; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 517: dim3x3 add
    gl64_t s1_517_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_517_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_517_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_517_0; tmp3_1 = tmp3_1 + s1_517_1; tmp3_2 = tmp3_2 + s1_517_2;
    // Op 518: dim3x3 mul
    gl64_t s1_518_0 = *(gl64_t*)&expressions_params[10][20];
    gl64_t s1_518_1 = *(gl64_t*)&expressions_params[10][20+1];
    gl64_t s1_518_2 = *(gl64_t*)&expressions_params[10][20+2];
    gl64_t kA518 = (tmp3_0 + tmp3_1) * (s1_518_0 + s1_518_1);
    gl64_t kB518 = (tmp3_0 + tmp3_2) * (s1_518_0 + s1_518_2);
    gl64_t kC518 = (tmp3_1 + tmp3_2) * (s1_518_1 + s1_518_2);
    gl64_t kD518 = tmp3_0 * s1_518_0;
    gl64_t kE518 = tmp3_1 * s1_518_1;
    gl64_t kF518 = tmp3_2 * s1_518_2;
    gl64_t kG518 = kD518 - kE518;
    tmp3_0 = (kC518 + kG518) - kF518;
    tmp3_1 = ((((kA518 + kC518) - kE518) - kE518) - kD518);
    tmp3_2 = kB518 - kG518;
    // Op 519: dim1x1 sub
    gl64_t s0_519 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_519 = *(gl64_t*)&expressions_params[10][11];
    tmp1_4 = s0_519 - s1_519;
    // Op 520: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 521: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 522: dim3x3 mul
    gl64_t s1_522_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_522_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_522_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA522 = (tmp3_0 + tmp3_1) * (s1_522_0 + s1_522_1);
    gl64_t kB522 = (tmp3_0 + tmp3_2) * (s1_522_0 + s1_522_2);
    gl64_t kC522 = (tmp3_1 + tmp3_2) * (s1_522_1 + s1_522_2);
    gl64_t kD522 = tmp3_0 * s1_522_0;
    gl64_t kE522 = tmp3_1 * s1_522_1;
    gl64_t kF522 = tmp3_2 * s1_522_2;
    gl64_t kG522 = kD522 - kE522;
    tmp3_6 = (kC522 + kG522) - kF522;
    tmp3_7 = ((((kA522 + kC522) - kE522) - kE522) - kD522);
    tmp3_8 = kB522 - kG522;
    // Op 523: dim3x1 add
    gl64_t s0_523_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s0_523_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s0_523_2 = *(gl64_t*)&expressions_params[13][3+2];
    gl64_t s1_523 = *(gl64_t*)&expressions_params[9][15];
    tmp3_0 = s0_523_0 + s1_523; tmp3_1 = s0_523_1; tmp3_2 = s0_523_2;
    // Op 524: dim3x3 mul
    gl64_t s1_524_0 = *(gl64_t*)&expressions_params[10][23];
    gl64_t s1_524_1 = *(gl64_t*)&expressions_params[10][23+1];
    gl64_t s1_524_2 = *(gl64_t*)&expressions_params[10][23+2];
    gl64_t kA524 = (tmp3_0 + tmp3_1) * (s1_524_0 + s1_524_1);
    gl64_t kB524 = (tmp3_0 + tmp3_2) * (s1_524_0 + s1_524_2);
    gl64_t kC524 = (tmp3_1 + tmp3_2) * (s1_524_1 + s1_524_2);
    gl64_t kD524 = tmp3_0 * s1_524_0;
    gl64_t kE524 = tmp3_1 * s1_524_1;
    gl64_t kF524 = tmp3_2 * s1_524_2;
    gl64_t kG524 = kD524 - kE524;
    tmp3_0 = (kC524 + kG524) - kF524;
    tmp3_1 = ((((kA524 + kC524) - kE524) - kE524) - kD524);
    tmp3_2 = kB524 - kG524;
    // Op 525: dim1x1 sub
    gl64_t s0_525 = *(gl64_t*)&expressions_params[9][1];
    gl64_t s1_525 = *(gl64_t*)&expressions_params[10][16];
    tmp1_4 = s0_525 - s1_525;
    // Op 526: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 527: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 528: dim3x3 mul
    gl64_t s1_528_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_528_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_528_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA528 = (tmp3_0 + tmp3_1) * (s1_528_0 + s1_528_1);
    gl64_t kB528 = (tmp3_0 + tmp3_2) * (s1_528_0 + s1_528_2);
    gl64_t kC528 = (tmp3_1 + tmp3_2) * (s1_528_1 + s1_528_2);
    gl64_t kD528 = tmp3_0 * s1_528_0;
    gl64_t kE528 = tmp3_1 * s1_528_1;
    gl64_t kF528 = tmp3_2 * s1_528_2;
    gl64_t kG528 = kD528 - kE528;
    tmp3_6 = (kC528 + kG528) - kF528;
    tmp3_7 = ((((kA528 + kC528) - kE528) - kE528) - kD528);
    tmp3_8 = kB528 - kG528;
    // Op 529: dim3x1 mul
    gl64_t s0_529_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_529_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_529_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_529 = *(gl64_t*)&expressions_params[10][14];
    tmp3_0 = s0_529_0 * s1_529; tmp3_1 = s0_529_1 * s1_529; tmp3_2 = s0_529_2 * s1_529;
    // Op 530: dim3x1 add
    gl64_t s1_530 = *(gl64_t*)&expressions_params[9][19];
    tmp3_0 = tmp3_0 + s1_530; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 531: dim3x3 add
    gl64_t s1_531_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_531_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_531_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_531_0; tmp3_1 = tmp3_1 + s1_531_1; tmp3_2 = tmp3_2 + s1_531_2;
    // Op 532: dim3x3 mul
    gl64_t s1_532_0 = *(gl64_t*)&expressions_params[10][26];
    gl64_t s1_532_1 = *(gl64_t*)&expressions_params[10][26+1];
    gl64_t s1_532_2 = *(gl64_t*)&expressions_params[10][26+2];
    gl64_t kA532 = (tmp3_0 + tmp3_1) * (s1_532_0 + s1_532_1);
    gl64_t kB532 = (tmp3_0 + tmp3_2) * (s1_532_0 + s1_532_2);
    gl64_t kC532 = (tmp3_1 + tmp3_2) * (s1_532_1 + s1_532_2);
    gl64_t kD532 = tmp3_0 * s1_532_0;
    gl64_t kE532 = tmp3_1 * s1_532_1;
    gl64_t kF532 = tmp3_2 * s1_532_2;
    gl64_t kG532 = kD532 - kE532;
    tmp3_0 = (kC532 + kG532) - kF532;
    tmp3_1 = ((((kA532 + kC532) - kE532) - kE532) - kD532);
    tmp3_2 = kB532 - kG532;
    // Op 533: dim3x1 add
    gl64_t s1_533 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_533; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 534: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 535: dim3x3 mul
    gl64_t s1_535_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_535_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_535_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA535 = (tmp3_0 + tmp3_1) * (s1_535_0 + s1_535_1);
    gl64_t kB535 = (tmp3_0 + tmp3_2) * (s1_535_0 + s1_535_2);
    gl64_t kC535 = (tmp3_1 + tmp3_2) * (s1_535_1 + s1_535_2);
    gl64_t kD535 = tmp3_0 * s1_535_0;
    gl64_t kE535 = tmp3_1 * s1_535_1;
    gl64_t kF535 = tmp3_2 * s1_535_2;
    gl64_t kG535 = kD535 - kE535;
    tmp3_6 = (kC535 + kG535) - kF535;
    tmp3_7 = ((((kA535 + kC535) - kE535) - kE535) - kD535);
    tmp3_8 = kB535 - kG535;
    // Op 536: dim3x1 mul
    gl64_t s0_536_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_536_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_536_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_536 = *(gl64_t*)&expressions_params[10][15];
    tmp3_0 = s0_536_0 * s1_536; tmp3_1 = s0_536_1 * s1_536; tmp3_2 = s0_536_2 * s1_536;
    // Op 537: dim3x1 add
    gl64_t s1_537 = *(gl64_t*)&expressions_params[9][19];
    tmp3_0 = tmp3_0 + s1_537; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 538: dim3x3 add
    gl64_t s1_538_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_538_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_538_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_538_0; tmp3_1 = tmp3_1 + s1_538_1; tmp3_2 = tmp3_2 + s1_538_2;
    // Op 539: dim3x3 mul
    gl64_t s1_539_0 = *(gl64_t*)&expressions_params[10][29];
    gl64_t s1_539_1 = *(gl64_t*)&expressions_params[10][29+1];
    gl64_t s1_539_2 = *(gl64_t*)&expressions_params[10][29+2];
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
    // Op 540: dim3x1 add
    gl64_t s1_540 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_540; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 541: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 542: dim3x3 mul
    gl64_t s1_542_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_542_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_542_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA542 = (tmp3_0 + tmp3_1) * (s1_542_0 + s1_542_1);
    gl64_t kB542 = (tmp3_0 + tmp3_2) * (s1_542_0 + s1_542_2);
    gl64_t kC542 = (tmp3_1 + tmp3_2) * (s1_542_1 + s1_542_2);
    gl64_t kD542 = tmp3_0 * s1_542_0;
    gl64_t kE542 = tmp3_1 * s1_542_1;
    gl64_t kF542 = tmp3_2 * s1_542_2;
    gl64_t kG542 = kD542 - kE542;
    tmp3_3 = (kC542 + kG542) - kF542;
    tmp3_4 = ((((kA542 + kC542) - kE542) - kE542) - kD542);
    tmp3_5 = kB542 - kG542;
    // Op 543: dim3x3 sub_swap
    uint64_t s0_543_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_543_0 = *(gl64_t*)&dParams->aux_trace[s0_543_pos];
    gl64_t s0_543_1 = *(gl64_t*)&dParams->aux_trace[s0_543_pos + TILE_HEIGHT];
    gl64_t s0_543_2 = *(gl64_t*)&dParams->aux_trace[s0_543_pos + 2*TILE_HEIGHT];
    gl64_t s1_543_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_543_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_543_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_6 = s1_543_0 - s0_543_0; tmp3_7 = s1_543_1 - s0_543_1; tmp3_8 = s1_543_2 - s0_543_2;
    // Op 544: dim3x3 add
    gl64_t s0_544_0 = *(gl64_t*)&expressions_params[10][17];
    gl64_t s0_544_1 = *(gl64_t*)&expressions_params[10][17+1];
    gl64_t s0_544_2 = *(gl64_t*)&expressions_params[10][17+2];
    gl64_t s1_544_0 = *(gl64_t*)&expressions_params[10][20];
    gl64_t s1_544_1 = *(gl64_t*)&expressions_params[10][20+1];
    gl64_t s1_544_2 = *(gl64_t*)&expressions_params[10][20+2];
    tmp3_0 = s0_544_0 + s1_544_0; tmp3_1 = s0_544_1 + s1_544_1; tmp3_2 = s0_544_2 + s1_544_2;
    // Op 545: dim3x3 add
    gl64_t s1_545_0 = *(gl64_t*)&expressions_params[10][23];
    gl64_t s1_545_1 = *(gl64_t*)&expressions_params[10][23+1];
    gl64_t s1_545_2 = *(gl64_t*)&expressions_params[10][23+2];
    tmp3_0 = tmp3_0 + s1_545_0; tmp3_1 = tmp3_1 + s1_545_1; tmp3_2 = tmp3_2 + s1_545_2;
    // Op 546: dim3x3 add
    gl64_t s1_546_0 = *(gl64_t*)&expressions_params[10][26];
    gl64_t s1_546_1 = *(gl64_t*)&expressions_params[10][26+1];
    gl64_t s1_546_2 = *(gl64_t*)&expressions_params[10][26+2];
    tmp3_0 = tmp3_0 + s1_546_0; tmp3_1 = tmp3_1 + s1_546_1; tmp3_2 = tmp3_2 + s1_546_2;
    // Op 547: dim3x3 add
    gl64_t s1_547_0 = *(gl64_t*)&expressions_params[10][29];
    gl64_t s1_547_1 = *(gl64_t*)&expressions_params[10][29+1];
    gl64_t s1_547_2 = *(gl64_t*)&expressions_params[10][29+2];
    tmp3_0 = tmp3_0 + s1_547_0; tmp3_1 = tmp3_1 + s1_547_1; tmp3_2 = tmp3_2 + s1_547_2;
    // Op 548: dim3x3 sub
    tmp3_0 = tmp3_6 - tmp3_0; tmp3_1 = tmp3_7 - tmp3_1; tmp3_2 = tmp3_8 - tmp3_2;
    // Op 549: dim3x1 mul
    gl64_t s1_549 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_549; tmp3_1 = tmp3_1 * s1_549; tmp3_2 = tmp3_2 * s1_549;
    // Op 550: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 551: dim3x1 mul
    gl64_t s1_551 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_551; tmp3_1 = tmp3_1 * s1_551; tmp3_2 = tmp3_2 * s1_551;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
