// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: cf025804  nOps=307 nTemp1=2 nTemp3=5
#define GENERATED_EVAL_NOPS_cf025804 307
#define GENERATED_EVAL_NTEMP1_cf025804 2
#define GENERATED_EVAL_NTEMP3_cf025804 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_cf025804(
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

    // Register-resident temporaries: 2 tmp1 + 15 tmp3 slots
    gl64_t tmp1_0 = gl64_t(uint64_t(0));
    gl64_t tmp1_1 = gl64_t(uint64_t(0));
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
    gl64_t s0_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    gl64_t s1_0 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s1_0 - s0_0;
    // Op 1: dim1x1 mul
    gl64_t s0_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    tmp1_0 = s0_1 * tmp1_0;
    // Op 2: dim3x1 mul
    gl64_t s0_2_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s0_2_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s0_2_2 = *(gl64_t*)&expressions_params[13][6+2];
    tmp3_0 = s0_2_0 * tmp1_0; tmp3_1 = s0_2_1 * tmp1_0; tmp3_2 = s0_2_2 * tmp1_0;
    // Op 3: dim1x1 sub_swap
    gl64_t s0_3 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    gl64_t s1_3 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s1_3 - s0_3;
    // Op 4: dim1x1 mul
    gl64_t s0_4 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
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
    gl64_t s0_7 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    gl64_t s1_7 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s1_7 - s0_7;
    // Op 8: dim1x1 mul
    gl64_t s0_8 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
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
    gl64_t s0_11 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    gl64_t s1_11 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s1_11 - s0_11;
    // Op 12: dim1x1 mul
    gl64_t s0_12 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
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
    gl64_t s0_15 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    gl64_t s1_15 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s1_15 - s0_15;
    // Op 16: dim1x1 mul
    gl64_t s0_16 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
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
    gl64_t s0_19 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    gl64_t s1_19 = *(gl64_t*)&expressions_params[9][13];
    tmp1_0 = s0_19 + s1_19;
    // Op 20: dim1x1 sub_swap
    gl64_t s0_20 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = tmp1_0 - s0_20;
    // Op 21: dim1x1 mul
    gl64_t s0_21 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    tmp1_0 = s0_21 * tmp1_0;
    // Op 22: dim1x1 add
    gl64_t s0_22 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_22 + tmp1_0;
    // Op 23: dim1x1 sub
    gl64_t s0_23 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    tmp1_0 = s0_23 - tmp1_0;
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
    // Op 26: dim1x1 mul
    gl64_t s0_26 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    gl64_t s1_26 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    tmp1_0 = s0_26 * s1_26;
    // Op 27: dim1x1 sub
    gl64_t s0_27 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 38, domainSize, nCols_1))];
    tmp1_0 = s0_27 - tmp1_0;
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
    tmp3_12 = (kC29 + kG29) - kF29;
    tmp3_13 = ((((kA29 + kC29) - kE29) - kE29) - kD29);
    tmp3_14 = kB29 - kG29;
    // Op 30: dim1x1 mul
    gl64_t s0_30 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    gl64_t s1_30 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_30 * s1_30;
    // Op 31: dim1x1 add
    gl64_t s0_31 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_31 + tmp1_0;
    // Op 32: dim1x1 mul
    gl64_t s0_32 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    gl64_t s1_32 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s0_32 * s1_32;
    // Op 33: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 34: dim3x1 mul
    gl64_t s0_34_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_34_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_34_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_34_0 * tmp1_0; tmp3_1 = s0_34_1 * tmp1_0; tmp3_2 = s0_34_2 * tmp1_0;
    // Op 35: dim3x1 add
    gl64_t s1_35 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_35; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 36: dim3x3 mul
    gl64_t s1_36_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_36_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_36_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 37: dim3x1 add
    gl64_t s1_37 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_37; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 38: dim3x3 mul
    gl64_t s1_38_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_38_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_38_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 39: dim3x1 add
    gl64_t s1_39 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_39; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 40: dim3x3 mul
    gl64_t s1_40_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_40_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_40_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 41: dim3x1 add
    gl64_t s1_41 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_41; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 42: dim3x3 mul
    gl64_t s1_42_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_42_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_42_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 43: dim3x1 add
    gl64_t s1_43 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_43; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 44: dim3x3 mul
    gl64_t s1_44_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_44_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_44_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 45: dim3x3 mul
    gl64_t s1_45_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_45_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_45_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA45 = (tmp3_0 + tmp3_1) * (s1_45_0 + s1_45_1);
    gl64_t kB45 = (tmp3_0 + tmp3_2) * (s1_45_0 + s1_45_2);
    gl64_t kC45 = (tmp3_1 + tmp3_2) * (s1_45_1 + s1_45_2);
    gl64_t kD45 = tmp3_0 * s1_45_0;
    gl64_t kE45 = tmp3_1 * s1_45_1;
    gl64_t kF45 = tmp3_2 * s1_45_2;
    gl64_t kG45 = kD45 - kE45;
    tmp3_0 = (kC45 + kG45) - kF45;
    tmp3_1 = ((((kA45 + kC45) - kE45) - kE45) - kD45);
    tmp3_2 = kB45 - kG45;
    // Op 46: dim3x1 add
    gl64_t s1_46 = *(gl64_t*)&expressions_params[9][2];
    tmp3_9 = tmp3_0 + s1_46; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 47: dim3x3 add
    gl64_t s1_47_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_47_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_47_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_47_0; tmp3_4 = tmp3_10 + s1_47_1; tmp3_5 = tmp3_11 + s1_47_2;
    // Op 48: dim1x1 mul
    gl64_t s0_48 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    gl64_t s1_48 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_48 * s1_48;
    // Op 49: dim1x1 add
    gl64_t s0_49 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp1_0 = s0_49 + tmp1_0;
    // Op 50: dim1x1 mul
    gl64_t s0_50 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    gl64_t s1_50 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s0_50 * s1_50;
    // Op 51: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 52: dim3x1 mul
    gl64_t s0_52_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_52_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_52_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_52_0 * tmp1_0; tmp3_1 = s0_52_1 * tmp1_0; tmp3_2 = s0_52_2 * tmp1_0;
    // Op 53: dim3x1 add
    gl64_t s1_53 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_53; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 54: dim3x3 mul
    gl64_t s1_54_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_54_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_54_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 55: dim3x1 add
    gl64_t s1_55 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_55; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 56: dim3x3 mul
    gl64_t s1_56_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_56_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_56_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 57: dim3x1 add
    gl64_t s1_57 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_57; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 58: dim3x3 mul
    gl64_t s1_58_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_58_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_58_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 59: dim3x1 add
    gl64_t s1_59 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_59; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 60: dim3x3 mul
    gl64_t s1_60_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_60_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_60_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 61: dim3x1 add
    gl64_t s1_61 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_61; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 62: dim3x3 mul
    gl64_t s1_62_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_62_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_62_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 63: dim3x3 mul
    gl64_t s1_63_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_63_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_63_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 64: dim3x1 add
    gl64_t s1_64 = *(gl64_t*)&expressions_params[9][2];
    tmp3_6 = tmp3_0 + s1_64; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 65: dim3x3 add
    gl64_t s1_65_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_65_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_65_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_65_0; tmp3_1 = tmp3_7 + s1_65_1; tmp3_2 = tmp3_8 + s1_65_2;
    // Op 66: dim3x3 mul
    gl64_t kA66 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB66 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC66 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD66 = tmp3_3 * tmp3_0;
    gl64_t kE66 = tmp3_4 * tmp3_1;
    gl64_t kF66 = tmp3_5 * tmp3_2;
    gl64_t kG66 = kD66 - kE66;
    tmp3_0 = (kC66 + kG66) - kF66;
    tmp3_1 = ((((kA66 + kC66) - kE66) - kE66) - kD66);
    tmp3_2 = kB66 - kG66;
    // Op 67: dim3x3 mul
    gl64_t s0_67_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_67_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_67_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA67 = (s0_67_0 + s0_67_1) * (tmp3_0 + tmp3_1);
    gl64_t kB67 = (s0_67_0 + s0_67_2) * (tmp3_0 + tmp3_2);
    gl64_t kC67 = (s0_67_1 + s0_67_2) * (tmp3_1 + tmp3_2);
    gl64_t kD67 = s0_67_0 * tmp3_0;
    gl64_t kE67 = s0_67_1 * tmp3_1;
    gl64_t kF67 = s0_67_2 * tmp3_2;
    gl64_t kG67 = kD67 - kE67;
    tmp3_0 = (kC67 + kG67) - kF67;
    tmp3_1 = ((((kA67 + kC67) - kE67) - kE67) - kD67);
    tmp3_2 = kB67 - kG67;
    // Op 68: dim3x3 add
    gl64_t s1_68_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_68_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_68_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_68_0; tmp3_7 = tmp3_7 + s1_68_1; tmp3_8 = tmp3_8 + s1_68_2;
    // Op 69: dim3x1 mul
    gl64_t s1_69 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_6 * s1_69; tmp3_7 = tmp3_7 * s1_69; tmp3_8 = tmp3_8 * s1_69;
    // Op 70: dim3x3 add
    gl64_t s1_70_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_70_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_70_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_70_0; tmp3_10 = tmp3_10 + s1_70_1; tmp3_11 = tmp3_11 + s1_70_2;
    // Op 71: dim3x1 mul
    gl64_t s1_71 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_9 * s1_71; tmp3_10 = tmp3_10 * s1_71; tmp3_11 = tmp3_11 * s1_71;
    // Op 72: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 73: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 74: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
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
    tmp3_3 = (kC75 + kG75) - kF75;
    tmp3_4 = ((((kA75 + kC75) - kE75) - kE75) - kD75);
    tmp3_5 = kB75 - kG75;
    // Op 76: dim1x1 mul
    gl64_t s0_76 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    gl64_t s1_76 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_76 * s1_76;
    // Op 77: dim1x1 add
    gl64_t s0_77 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_77 + tmp1_0;
    // Op 78: dim1x1 mul
    gl64_t s0_78 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    gl64_t s1_78 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s0_78 * s1_78;
    // Op 79: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 80: dim1x1 mul
    gl64_t s0_80 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 38, domainSize, nCols_1))];
    gl64_t s1_80 = *(gl64_t*)&expressions_params[9][4];
    tmp1_1 = s0_80 * s1_80;
    // Op 81: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 82: dim3x1 mul
    gl64_t s0_82_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_82_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_82_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_82_0 * tmp1_0; tmp3_1 = s0_82_1 * tmp1_0; tmp3_2 = s0_82_2 * tmp1_0;
    // Op 83: dim3x1 add
    gl64_t s1_83 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
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
    // Op 85: dim3x1 add
    gl64_t s1_85 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_85; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 86: dim3x3 mul
    gl64_t s1_86_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_86_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_86_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 87: dim3x1 add
    gl64_t s1_87 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_87; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 88: dim3x3 mul
    gl64_t s1_88_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_88_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_88_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 89: dim3x1 add
    gl64_t s1_89 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_89; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_91 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
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
    gl64_t s1_93 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_93; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 94: dim3x3 mul
    gl64_t s1_94_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_94_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_94_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 95: dim3x1 add
    gl64_t s1_95 = *(gl64_t*)&expressions_params[9][2];
    tmp3_9 = tmp3_0 + s1_95; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 96: dim3x3 add
    gl64_t s1_96_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_96_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_96_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_96_0; tmp3_13 = tmp3_10 + s1_96_1; tmp3_14 = tmp3_11 + s1_96_2;
    // Op 97: dim1x1 mul
    gl64_t s0_97 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    gl64_t s1_97 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_97 * s1_97;
    // Op 98: dim1x1 add
    gl64_t s0_98 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp1_0 = s0_98 + tmp1_0;
    // Op 99: dim1x1 mul
    gl64_t s0_99 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    gl64_t s1_99 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s0_99 * s1_99;
    // Op 100: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 101: dim1x1 mul
    gl64_t s0_101 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 38, domainSize, nCols_1))];
    gl64_t s1_101 = *(gl64_t*)&expressions_params[9][4];
    tmp1_1 = s0_101 * s1_101;
    // Op 102: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 103: dim3x1 mul
    gl64_t s0_103_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_103_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_103_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_103_0 * tmp1_0; tmp3_1 = s0_103_1 * tmp1_0; tmp3_2 = s0_103_2 * tmp1_0;
    // Op 104: dim3x1 add
    gl64_t s1_104 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_104; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 105: dim3x3 mul
    gl64_t s1_105_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_105_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_105_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA105 = (tmp3_0 + tmp3_1) * (s1_105_0 + s1_105_1);
    gl64_t kB105 = (tmp3_0 + tmp3_2) * (s1_105_0 + s1_105_2);
    gl64_t kC105 = (tmp3_1 + tmp3_2) * (s1_105_1 + s1_105_2);
    gl64_t kD105 = tmp3_0 * s1_105_0;
    gl64_t kE105 = tmp3_1 * s1_105_1;
    gl64_t kF105 = tmp3_2 * s1_105_2;
    gl64_t kG105 = kD105 - kE105;
    tmp3_0 = (kC105 + kG105) - kF105;
    tmp3_1 = ((((kA105 + kC105) - kE105) - kE105) - kD105);
    tmp3_2 = kB105 - kG105;
    // Op 106: dim3x1 add
    gl64_t s1_106 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_106; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 108: dim3x1 add
    gl64_t s1_108 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_108; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 109: dim3x3 mul
    gl64_t s1_109_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_109_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_109_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 110: dim3x1 add
    gl64_t s1_110 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_110; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 111: dim3x3 mul
    gl64_t s1_111_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_111_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_111_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 112: dim3x1 add
    gl64_t s1_112 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_112; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 113: dim3x3 mul
    gl64_t s1_113_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_113_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_113_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA113 = (tmp3_0 + tmp3_1) * (s1_113_0 + s1_113_1);
    gl64_t kB113 = (tmp3_0 + tmp3_2) * (s1_113_0 + s1_113_2);
    gl64_t kC113 = (tmp3_1 + tmp3_2) * (s1_113_1 + s1_113_2);
    gl64_t kD113 = tmp3_0 * s1_113_0;
    gl64_t kE113 = tmp3_1 * s1_113_1;
    gl64_t kF113 = tmp3_2 * s1_113_2;
    gl64_t kG113 = kD113 - kE113;
    tmp3_0 = (kC113 + kG113) - kF113;
    tmp3_1 = ((((kA113 + kC113) - kE113) - kE113) - kD113);
    tmp3_2 = kB113 - kG113;
    // Op 114: dim3x3 mul
    gl64_t s1_114_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_114_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_114_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 115: dim3x1 add
    gl64_t s1_115 = *(gl64_t*)&expressions_params[9][2];
    tmp3_6 = tmp3_0 + s1_115; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 116: dim3x3 add
    gl64_t s1_116_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_116_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_116_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_116_0; tmp3_1 = tmp3_7 + s1_116_1; tmp3_2 = tmp3_8 + s1_116_2;
    // Op 117: dim3x3 mul
    gl64_t kA117 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB117 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC117 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD117 = tmp3_12 * tmp3_0;
    gl64_t kE117 = tmp3_13 * tmp3_1;
    gl64_t kF117 = tmp3_14 * tmp3_2;
    gl64_t kG117 = kD117 - kE117;
    tmp3_0 = (kC117 + kG117) - kF117;
    tmp3_1 = ((((kA117 + kC117) - kE117) - kE117) - kD117);
    tmp3_2 = kB117 - kG117;
    // Op 118: dim3x3 mul
    gl64_t s0_118_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_118_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_118_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA118 = (s0_118_0 + s0_118_1) * (tmp3_0 + tmp3_1);
    gl64_t kB118 = (s0_118_0 + s0_118_2) * (tmp3_0 + tmp3_2);
    gl64_t kC118 = (s0_118_1 + s0_118_2) * (tmp3_1 + tmp3_2);
    gl64_t kD118 = s0_118_0 * tmp3_0;
    gl64_t kE118 = s0_118_1 * tmp3_1;
    gl64_t kF118 = s0_118_2 * tmp3_2;
    gl64_t kG118 = kD118 - kE118;
    tmp3_0 = (kC118 + kG118) - kF118;
    tmp3_1 = ((((kA118 + kC118) - kE118) - kE118) - kD118);
    tmp3_2 = kB118 - kG118;
    // Op 119: dim3x3 add
    gl64_t s1_119_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_119_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_119_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_119_0; tmp3_7 = tmp3_7 + s1_119_1; tmp3_8 = tmp3_8 + s1_119_2;
    // Op 120: dim3x1 mul
    gl64_t s1_120 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_6 * s1_120; tmp3_7 = tmp3_7 * s1_120; tmp3_8 = tmp3_8 * s1_120;
    // Op 121: dim3x3 add
    gl64_t s1_121_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_121_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_121_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_121_0; tmp3_10 = tmp3_10 + s1_121_1; tmp3_11 = tmp3_11 + s1_121_2;
    // Op 122: dim3x1 mul
    gl64_t s1_122 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_9 * s1_122; tmp3_10 = tmp3_10 * s1_122; tmp3_11 = tmp3_11 * s1_122;
    // Op 123: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 124: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 125: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
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
    tmp3_12 = (kC126 + kG126) - kF126;
    tmp3_13 = ((((kA126 + kC126) - kE126) - kE126) - kD126);
    tmp3_14 = kB126 - kG126;
    // Op 127: dim1x1 mul
    gl64_t s0_127 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    gl64_t s1_127 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_127 * s1_127;
    // Op 128: dim1x1 add
    gl64_t s0_128 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    tmp1_0 = s0_128 + tmp1_0;
    // Op 129: dim1x1 mul
    gl64_t s0_129 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    gl64_t s1_129 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s0_129 * s1_129;
    // Op 130: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 131: dim1x1 mul
    gl64_t s0_131 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 38, domainSize, nCols_1))];
    gl64_t s1_131 = *(gl64_t*)&expressions_params[9][4];
    tmp1_1 = s0_131 * s1_131;
    // Op 132: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 133: dim3x1 mul
    gl64_t s0_133_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_133_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_133_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_133_0 * tmp1_0; tmp3_1 = s0_133_1 * tmp1_0; tmp3_2 = s0_133_2 * tmp1_0;
    // Op 134: dim3x1 add
    gl64_t s1_134 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_134; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 135: dim3x3 mul
    gl64_t s1_135_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_135_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_135_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 136: dim3x1 add
    gl64_t s1_136 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_136; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_138 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
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
    gl64_t s1_140 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
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
    gl64_t s1_142 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_142; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 144: dim3x3 mul
    gl64_t s1_144_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_144_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_144_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 145: dim3x1 add
    gl64_t s1_145 = *(gl64_t*)&expressions_params[9][2];
    tmp3_9 = tmp3_0 + s1_145; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 146: dim3x3 add
    gl64_t s1_146_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_146_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_146_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_146_0; tmp3_4 = tmp3_10 + s1_146_1; tmp3_5 = tmp3_11 + s1_146_2;
    // Op 147: dim1x1 mul
    gl64_t s0_147 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    gl64_t s1_147 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_147 * s1_147;
    // Op 148: dim1x1 add
    gl64_t s0_148 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp1_0 = s0_148 + tmp1_0;
    // Op 149: dim1x1 mul
    gl64_t s0_149 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    gl64_t s1_149 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s0_149 * s1_149;
    // Op 150: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 151: dim1x1 mul
    gl64_t s0_151 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 38, domainSize, nCols_1))];
    gl64_t s1_151 = *(gl64_t*)&expressions_params[9][4];
    tmp1_1 = s0_151 * s1_151;
    // Op 152: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 153: dim3x1 mul
    gl64_t s0_153_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_153_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_153_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_153_0 * tmp1_0; tmp3_1 = s0_153_1 * tmp1_0; tmp3_2 = s0_153_2 * tmp1_0;
    // Op 154: dim3x1 add
    gl64_t s1_154 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_154; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_156 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
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
    gl64_t s1_158 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_158; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 159: dim3x3 mul
    gl64_t s1_159_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_159_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_159_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 160: dim3x1 add
    gl64_t s1_160 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_160; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 161: dim3x3 mul
    gl64_t s1_161_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_161_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_161_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 162: dim3x1 add
    gl64_t s1_162 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_162; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 163: dim3x3 mul
    gl64_t s1_163_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_163_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_163_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 164: dim3x3 mul
    gl64_t s1_164_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_164_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_164_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 165: dim3x1 add
    gl64_t s1_165 = *(gl64_t*)&expressions_params[9][2];
    tmp3_6 = tmp3_0 + s1_165; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 166: dim3x3 add
    gl64_t s1_166_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_166_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_166_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_166_0; tmp3_1 = tmp3_7 + s1_166_1; tmp3_2 = tmp3_8 + s1_166_2;
    // Op 167: dim3x3 mul
    gl64_t kA167 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB167 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC167 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD167 = tmp3_3 * tmp3_0;
    gl64_t kE167 = tmp3_4 * tmp3_1;
    gl64_t kF167 = tmp3_5 * tmp3_2;
    gl64_t kG167 = kD167 - kE167;
    tmp3_0 = (kC167 + kG167) - kF167;
    tmp3_1 = ((((kA167 + kC167) - kE167) - kE167) - kD167);
    tmp3_2 = kB167 - kG167;
    // Op 168: dim3x3 mul
    uint64_t s0_168_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_168_0 = *(gl64_t*)&dParams->aux_trace[s0_168_pos];
    gl64_t s0_168_1 = *(gl64_t*)&dParams->aux_trace[s0_168_pos + TILE_HEIGHT];
    gl64_t s0_168_2 = *(gl64_t*)&dParams->aux_trace[s0_168_pos + 2*TILE_HEIGHT];
    gl64_t kA168 = (s0_168_0 + s0_168_1) * (tmp3_0 + tmp3_1);
    gl64_t kB168 = (s0_168_0 + s0_168_2) * (tmp3_0 + tmp3_2);
    gl64_t kC168 = (s0_168_1 + s0_168_2) * (tmp3_1 + tmp3_2);
    gl64_t kD168 = s0_168_0 * tmp3_0;
    gl64_t kE168 = s0_168_1 * tmp3_1;
    gl64_t kF168 = s0_168_2 * tmp3_2;
    gl64_t kG168 = kD168 - kE168;
    tmp3_0 = (kC168 + kG168) - kF168;
    tmp3_1 = ((((kA168 + kC168) - kE168) - kE168) - kD168);
    tmp3_2 = kB168 - kG168;
    // Op 169: dim3x3 add
    gl64_t s1_169_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_169_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_169_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_169_0; tmp3_7 = tmp3_7 + s1_169_1; tmp3_8 = tmp3_8 + s1_169_2;
    // Op 170: dim3x1 mul
    gl64_t s1_170 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_6 * s1_170; tmp3_7 = tmp3_7 * s1_170; tmp3_8 = tmp3_8 * s1_170;
    // Op 171: dim3x3 add
    gl64_t s1_171_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_171_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_171_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_171_0; tmp3_10 = tmp3_10 + s1_171_1; tmp3_11 = tmp3_11 + s1_171_2;
    // Op 172: dim3x1 mul
    gl64_t s1_172 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_9 * s1_172; tmp3_10 = tmp3_10 * s1_172; tmp3_11 = tmp3_11 * s1_172;
    // Op 173: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 174: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 175: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
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
    tmp3_3 = (kC176 + kG176) - kF176;
    tmp3_4 = ((((kA176 + kC176) - kE176) - kE176) - kD176);
    tmp3_5 = kB176 - kG176;
    // Op 177: dim1x1 mul
    gl64_t s0_177 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    gl64_t s1_177 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_177 * s1_177;
    // Op 178: dim1x1 add
    gl64_t s0_178 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp1_0 = s0_178 + tmp1_0;
    // Op 179: dim1x1 mul
    gl64_t s0_179 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    gl64_t s1_179 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s0_179 * s1_179;
    // Op 180: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 181: dim1x1 mul
    gl64_t s0_181 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    gl64_t s1_181 = *(gl64_t*)&expressions_params[9][4];
    tmp1_1 = s0_181 * s1_181;
    // Op 182: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 183: dim3x1 mul
    gl64_t s0_183_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_183_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_183_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_183_0 * tmp1_0; tmp3_1 = s0_183_1 * tmp1_0; tmp3_2 = s0_183_2 * tmp1_0;
    // Op 184: dim3x1 add
    gl64_t s1_184 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_184; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 185: dim3x3 mul
    gl64_t s1_185_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_185_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_185_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA185 = (tmp3_0 + tmp3_1) * (s1_185_0 + s1_185_1);
    gl64_t kB185 = (tmp3_0 + tmp3_2) * (s1_185_0 + s1_185_2);
    gl64_t kC185 = (tmp3_1 + tmp3_2) * (s1_185_1 + s1_185_2);
    gl64_t kD185 = tmp3_0 * s1_185_0;
    gl64_t kE185 = tmp3_1 * s1_185_1;
    gl64_t kF185 = tmp3_2 * s1_185_2;
    gl64_t kG185 = kD185 - kE185;
    tmp3_0 = (kC185 + kG185) - kF185;
    tmp3_1 = ((((kA185 + kC185) - kE185) - kE185) - kD185);
    tmp3_2 = kB185 - kG185;
    // Op 186: dim3x1 add
    gl64_t s1_186 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_186; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 187: dim3x3 mul
    gl64_t s1_187_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_187_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_187_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 188: dim3x1 add
    gl64_t s1_188 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
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
    // Op 190: dim3x1 add
    gl64_t s1_190 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
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
    gl64_t s1_192 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_192; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 193: dim3x3 mul
    gl64_t s1_193_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_193_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_193_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 194: dim1x1 sub_swap
    gl64_t s0_194 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    gl64_t s1_194 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s1_194 - s0_194;
    // Op 195: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 196: dim3x3 mul
    gl64_t s1_196_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_196_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_196_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA196 = (tmp3_0 + tmp3_1) * (s1_196_0 + s1_196_1);
    gl64_t kB196 = (tmp3_0 + tmp3_2) * (s1_196_0 + s1_196_2);
    gl64_t kC196 = (tmp3_1 + tmp3_2) * (s1_196_1 + s1_196_2);
    gl64_t kD196 = tmp3_0 * s1_196_0;
    gl64_t kE196 = tmp3_1 * s1_196_1;
    gl64_t kF196 = tmp3_2 * s1_196_2;
    gl64_t kG196 = kD196 - kE196;
    tmp3_0 = (kC196 + kG196) - kF196;
    tmp3_1 = ((((kA196 + kC196) - kE196) - kE196) - kD196);
    tmp3_2 = kB196 - kG196;
    // Op 197: dim3x1 add
    gl64_t s1_197 = *(gl64_t*)&expressions_params[9][2];
    tmp3_9 = tmp3_0 + s1_197; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 198: dim3x3 add
    gl64_t s1_198_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_198_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_198_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_198_0; tmp3_13 = tmp3_10 + s1_198_1; tmp3_14 = tmp3_11 + s1_198_2;
    // Op 199: dim3x1 mul
    gl64_t s0_199_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_199_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_199_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_199 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp3_0 = s0_199_0 * s1_199; tmp3_1 = s0_199_1 * s1_199; tmp3_2 = s0_199_2 * s1_199;
    // Op 200: dim1x1 mul
    gl64_t s0_200 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_200 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_200 * s1_200;
    // Op 201: dim1x1 add
    gl64_t s0_201 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_201 + tmp1_0;
    // Op 202: dim1x1 mul
    gl64_t s0_202 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_202 = *(gl64_t*)&expressions_params[9][6];
    tmp1_1 = s0_202 * s1_202;
    // Op 203: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 204: dim1x1 mul
    gl64_t s0_204 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_204 = *(gl64_t*)&expressions_params[9][7];
    tmp1_1 = s0_204 * s1_204;
    // Op 205: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 206: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 207: dim3x3 mul
    gl64_t s1_207_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_207_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_207_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 208: dim1x1 mul
    gl64_t s0_208 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    gl64_t s1_208 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_208 * s1_208;
    // Op 209: dim1x1 add
    gl64_t s0_209 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_209 + tmp1_0;
    // Op 210: dim1x1 mul
    gl64_t s0_210 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_210 = *(gl64_t*)&expressions_params[9][6];
    tmp1_1 = s0_210 * s1_210;
    // Op 211: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 212: dim1x1 mul
    gl64_t s0_212 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_212 = *(gl64_t*)&expressions_params[9][7];
    tmp1_1 = s0_212 * s1_212;
    // Op 213: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 214: dim1x1 add
    gl64_t s0_214 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp1_0 = s0_214 + tmp1_0;
    // Op 215: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 216: dim3x3 mul
    gl64_t s1_216_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_216_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_216_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA216 = (tmp3_0 + tmp3_1) * (s1_216_0 + s1_216_1);
    gl64_t kB216 = (tmp3_0 + tmp3_2) * (s1_216_0 + s1_216_2);
    gl64_t kC216 = (tmp3_1 + tmp3_2) * (s1_216_1 + s1_216_2);
    gl64_t kD216 = tmp3_0 * s1_216_0;
    gl64_t kE216 = tmp3_1 * s1_216_1;
    gl64_t kF216 = tmp3_2 * s1_216_2;
    gl64_t kG216 = kD216 - kE216;
    tmp3_0 = (kC216 + kG216) - kF216;
    tmp3_1 = ((((kA216 + kC216) - kE216) - kE216) - kD216);
    tmp3_2 = kB216 - kG216;
    // Op 217: dim1x1 mul
    gl64_t s0_217 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_217 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_217 * s1_217;
    // Op 218: dim1x1 add
    gl64_t s0_218 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_218 + tmp1_0;
    // Op 219: dim1x1 mul
    gl64_t s0_219 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_219 = *(gl64_t*)&expressions_params[9][6];
    tmp1_1 = s0_219 * s1_219;
    // Op 220: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 221: dim1x1 mul
    gl64_t s0_221 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    gl64_t s1_221 = *(gl64_t*)&expressions_params[9][7];
    tmp1_1 = s0_221 * s1_221;
    // Op 222: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 223: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 224: dim3x3 mul
    gl64_t s1_224_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_224_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_224_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA224 = (tmp3_0 + tmp3_1) * (s1_224_0 + s1_224_1);
    gl64_t kB224 = (tmp3_0 + tmp3_2) * (s1_224_0 + s1_224_2);
    gl64_t kC224 = (tmp3_1 + tmp3_2) * (s1_224_1 + s1_224_2);
    gl64_t kD224 = tmp3_0 * s1_224_0;
    gl64_t kE224 = tmp3_1 * s1_224_1;
    gl64_t kF224 = tmp3_2 * s1_224_2;
    gl64_t kG224 = kD224 - kE224;
    tmp3_0 = (kC224 + kG224) - kF224;
    tmp3_1 = ((((kA224 + kC224) - kE224) - kE224) - kD224);
    tmp3_2 = kB224 - kG224;
    // Op 225: dim1x1 mul
    gl64_t s0_225 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_225 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_225 * s1_225;
    // Op 226: dim1x1 add
    gl64_t s0_226 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_226 + tmp1_0;
    // Op 227: dim1x1 mul
    gl64_t s0_227 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_227 = *(gl64_t*)&expressions_params[9][6];
    tmp1_1 = s0_227 * s1_227;
    // Op 228: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 229: dim1x1 mul
    gl64_t s0_229 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_229 = *(gl64_t*)&expressions_params[9][7];
    tmp1_1 = s0_229 * s1_229;
    // Op 230: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 231: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 233: dim1x1 mul
    gl64_t s0_233 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_233 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_233 * s1_233;
    // Op 234: dim1x1 add
    gl64_t s0_234 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_234 + tmp1_0;
    // Op 235: dim1x1 mul
    gl64_t s0_235 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_235 = *(gl64_t*)&expressions_params[9][6];
    tmp1_1 = s0_235 * s1_235;
    // Op 236: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 237: dim1x1 mul
    gl64_t s0_237 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_237 = *(gl64_t*)&expressions_params[9][7];
    tmp1_1 = s0_237 * s1_237;
    // Op 238: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 239: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s0_241 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_241 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_241 * s1_241;
    // Op 242: dim1x1 add
    gl64_t s0_242 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_242 + tmp1_0;
    // Op 243: dim1x1 mul
    gl64_t s0_243 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_243 = *(gl64_t*)&expressions_params[9][6];
    tmp1_1 = s0_243 * s1_243;
    // Op 244: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 245: dim1x1 mul
    gl64_t s0_245 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_245 = *(gl64_t*)&expressions_params[9][7];
    tmp1_1 = s0_245 * s1_245;
    // Op 246: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 247: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 249: dim1x1 mul
    gl64_t s0_249 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    gl64_t s1_249 = *(gl64_t*)&expressions_params[9][8];
    tmp1_0 = s0_249 * s1_249;
    // Op 250: dim1x1 add
    gl64_t s0_250 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_250 + tmp1_0;
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
    tmp3_6 = tmp3_0 + s1_253; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 254: dim3x3 add
    gl64_t s1_254_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_254_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_254_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_254_0; tmp3_1 = tmp3_7 + s1_254_1; tmp3_2 = tmp3_8 + s1_254_2;
    // Op 255: dim3x3 mul
    gl64_t kA255 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB255 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC255 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD255 = tmp3_12 * tmp3_0;
    gl64_t kE255 = tmp3_13 * tmp3_1;
    gl64_t kF255 = tmp3_14 * tmp3_2;
    gl64_t kG255 = kD255 - kE255;
    tmp3_0 = (kC255 + kG255) - kF255;
    tmp3_1 = ((((kA255 + kC255) - kE255) - kE255) - kD255);
    tmp3_2 = kB255 - kG255;
    // Op 256: dim3x3 mul
    uint64_t s0_256_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_256_0 = *(gl64_t*)&dParams->aux_trace[s0_256_pos];
    gl64_t s0_256_1 = *(gl64_t*)&dParams->aux_trace[s0_256_pos + TILE_HEIGHT];
    gl64_t s0_256_2 = *(gl64_t*)&dParams->aux_trace[s0_256_pos + 2*TILE_HEIGHT];
    gl64_t kA256 = (s0_256_0 + s0_256_1) * (tmp3_0 + tmp3_1);
    gl64_t kB256 = (s0_256_0 + s0_256_2) * (tmp3_0 + tmp3_2);
    gl64_t kC256 = (s0_256_1 + s0_256_2) * (tmp3_1 + tmp3_2);
    gl64_t kD256 = s0_256_0 * tmp3_0;
    gl64_t kE256 = s0_256_1 * tmp3_1;
    gl64_t kF256 = s0_256_2 * tmp3_2;
    gl64_t kG256 = kD256 - kE256;
    tmp3_0 = (kC256 + kG256) - kF256;
    tmp3_1 = ((((kA256 + kC256) - kE256) - kE256) - kD256);
    tmp3_2 = kB256 - kG256;
    // Op 257: dim3x3 add
    gl64_t s1_257_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_257_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_257_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_257_0; tmp3_7 = tmp3_7 + s1_257_1; tmp3_8 = tmp3_8 + s1_257_2;
    // Op 258: dim3x1 mul
    gl64_t s1_258 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_6 * s1_258; tmp3_7 = tmp3_7 * s1_258; tmp3_8 = tmp3_8 * s1_258;
    // Op 259: dim3x3 add
    gl64_t s1_259_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_259_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_259_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_259_0; tmp3_10 = tmp3_10 + s1_259_1; tmp3_11 = tmp3_11 + s1_259_2;
    // Op 260: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 261: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 262: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
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
    tmp3_6 = (kC263 + kG263) - kF263;
    tmp3_7 = ((((kA263 + kC263) - kE263) - kE263) - kD263);
    tmp3_8 = kB263 - kG263;
    // Op 264: dim1x1 sub_swap
    gl64_t s0_264 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_264 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s1_264 - s0_264;
    // Op 265: dim3x1 mul
    uint64_t s0_265_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_265_0 = *(gl64_t*)&dParams->aux_trace[s0_265_pos];
    gl64_t s0_265_1 = *(gl64_t*)&dParams->aux_trace[s0_265_pos + TILE_HEIGHT];
    gl64_t s0_265_2 = *(gl64_t*)&dParams->aux_trace[s0_265_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_265_0 * tmp1_0; tmp3_1 = s0_265_1 * tmp1_0; tmp3_2 = s0_265_2 * tmp1_0;
    // Op 266: dim3x3 sub
    uint64_t s0_266_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_266_0 = *(gl64_t*)&dParams->aux_trace[s0_266_pos];
    gl64_t s0_266_1 = *(gl64_t*)&dParams->aux_trace[s0_266_pos + TILE_HEIGHT];
    gl64_t s0_266_2 = *(gl64_t*)&dParams->aux_trace[s0_266_pos + 2*TILE_HEIGHT];
    tmp3_3 = s0_266_0 - tmp3_0; tmp3_4 = s0_266_1 - tmp3_1; tmp3_5 = s0_266_2 - tmp3_2;
    // Op 267: dim3x3 add
    gl64_t s0_267_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_267_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_267_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_267_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_267_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_267_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_0 = s0_267_0 + s1_267_0; tmp3_1 = s0_267_1 + s1_267_1; tmp3_2 = s0_267_2 + s1_267_2;
    // Op 268: dim3x3 add
    uint64_t s0_268_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_268_0 = *(gl64_t*)&dParams->aux_trace[s0_268_pos];
    gl64_t s0_268_1 = *(gl64_t*)&dParams->aux_trace[s0_268_pos + TILE_HEIGHT];
    gl64_t s0_268_2 = *(gl64_t*)&dParams->aux_trace[s0_268_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_268_0 + tmp3_0; tmp3_1 = s0_268_1 + tmp3_1; tmp3_2 = s0_268_2 + tmp3_2;
    // Op 269: dim3x3 add
    uint64_t s0_269_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_269_0 = *(gl64_t*)&dParams->aux_trace[s0_269_pos];
    gl64_t s0_269_1 = *(gl64_t*)&dParams->aux_trace[s0_269_pos + TILE_HEIGHT];
    gl64_t s0_269_2 = *(gl64_t*)&dParams->aux_trace[s0_269_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_269_0 + tmp3_0; tmp3_1 = s0_269_1 + tmp3_1; tmp3_2 = s0_269_2 + tmp3_2;
    // Op 270: dim3x3 sub
    tmp3_3 = tmp3_3 - tmp3_0; tmp3_4 = tmp3_4 - tmp3_1; tmp3_5 = tmp3_5 - tmp3_2;
    // Op 271: dim1x1 mul
    gl64_t s0_271 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    gl64_t s1_271 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_271 * s1_271;
    // Op 272: dim1x1 add
    gl64_t s0_272 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_0 = s0_272 + tmp1_0;
    // Op 273: dim1x1 mul
    gl64_t s0_273 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    gl64_t s1_273 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s0_273 * s1_273;
    // Op 274: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 275: dim3x1 mul
    gl64_t s0_275_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_275_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_275_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_275_0 * tmp1_0; tmp3_1 = s0_275_1 * tmp1_0; tmp3_2 = s0_275_2 * tmp1_0;
    // Op 276: dim3x1 add
    gl64_t s1_276 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_276; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 277: dim3x3 mul
    gl64_t s1_277_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_277_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_277_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA277 = (tmp3_0 + tmp3_1) * (s1_277_0 + s1_277_1);
    gl64_t kB277 = (tmp3_0 + tmp3_2) * (s1_277_0 + s1_277_2);
    gl64_t kC277 = (tmp3_1 + tmp3_2) * (s1_277_1 + s1_277_2);
    gl64_t kD277 = tmp3_0 * s1_277_0;
    gl64_t kE277 = tmp3_1 * s1_277_1;
    gl64_t kF277 = tmp3_2 * s1_277_2;
    gl64_t kG277 = kD277 - kE277;
    tmp3_0 = (kC277 + kG277) - kF277;
    tmp3_1 = ((((kA277 + kC277) - kE277) - kE277) - kD277);
    tmp3_2 = kB277 - kG277;
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
    gl64_t s1_279 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
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
    // Op 281: dim3x1 add
    gl64_t s1_281 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_281; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_283 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_283; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s0_285 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    gl64_t s1_285 = *(gl64_t*)&expressions_params[9][0];
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
    // Op 288: dim3x1 add
    gl64_t s1_288 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_288; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 289: dim3x3 add
    gl64_t s1_289_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_289_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_289_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_289_0; tmp3_1 = tmp3_1 + s1_289_1; tmp3_2 = tmp3_2 + s1_289_2;
    // Op 290: dim3x3 mul
    gl64_t kA290 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB290 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC290 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD290 = tmp3_3 * tmp3_0;
    gl64_t kE290 = tmp3_4 * tmp3_1;
    gl64_t kF290 = tmp3_5 * tmp3_2;
    gl64_t kG290 = kD290 - kE290;
    tmp3_0 = (kC290 + kG290) - kF290;
    tmp3_1 = ((((kA290 + kC290) - kE290) - kE290) - kD290);
    tmp3_2 = kB290 - kG290;
    // Op 291: dim3x1 add
    gl64_t s1_291 = *(gl64_t*)&expressions_params[9][10];
    tmp3_0 = tmp3_0 + s1_291; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 292: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 293: dim3x3 mul
    gl64_t s1_293_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_293_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_293_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA293 = (tmp3_0 + tmp3_1) * (s1_293_0 + s1_293_1);
    gl64_t kB293 = (tmp3_0 + tmp3_2) * (s1_293_0 + s1_293_2);
    gl64_t kC293 = (tmp3_1 + tmp3_2) * (s1_293_1 + s1_293_2);
    gl64_t kD293 = tmp3_0 * s1_293_0;
    gl64_t kE293 = tmp3_1 * s1_293_1;
    gl64_t kF293 = tmp3_2 * s1_293_2;
    gl64_t kG293 = kD293 - kE293;
    tmp3_6 = (kC293 + kG293) - kF293;
    tmp3_7 = ((((kA293 + kC293) - kE293) - kE293) - kD293);
    tmp3_8 = kB293 - kG293;
    // Op 294: dim3x1 mul
    gl64_t s0_294_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_294_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_294_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_294 = *(gl64_t*)&expressions_params[9][11];
    tmp3_0 = s0_294_0 * s1_294; tmp3_1 = s0_294_1 * s1_294; tmp3_2 = s0_294_2 * s1_294;
    // Op 295: dim3x1 add
    gl64_t s1_295 = *(gl64_t*)&expressions_params[9][9];
    tmp3_0 = tmp3_0 + s1_295; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 296: dim3x3 add
    gl64_t s1_296_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_296_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_296_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_296_0; tmp3_1 = tmp3_1 + s1_296_1; tmp3_2 = tmp3_2 + s1_296_2;
    // Op 297: dim3x3 mul
    gl64_t s1_297_0 = *(gl64_t*)&expressions_params[10][1];
    gl64_t s1_297_1 = *(gl64_t*)&expressions_params[10][1+1];
    gl64_t s1_297_2 = *(gl64_t*)&expressions_params[10][1+2];
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
    // Op 298: dim1x1 sub
    gl64_t s0_298 = *(gl64_t*)&expressions_params[9][12];
    gl64_t s1_298 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_298 - s1_298;
    // Op 299: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 300: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 301: dim3x3 mul
    gl64_t s1_301_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_301_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_301_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA301 = (tmp3_0 + tmp3_1) * (s1_301_0 + s1_301_1);
    gl64_t kB301 = (tmp3_0 + tmp3_2) * (s1_301_0 + s1_301_2);
    gl64_t kC301 = (tmp3_1 + tmp3_2) * (s1_301_1 + s1_301_2);
    gl64_t kD301 = tmp3_0 * s1_301_0;
    gl64_t kE301 = tmp3_1 * s1_301_1;
    gl64_t kF301 = tmp3_2 * s1_301_2;
    gl64_t kG301 = kD301 - kE301;
    tmp3_6 = (kC301 + kG301) - kF301;
    tmp3_7 = ((((kA301 + kC301) - kE301) - kE301) - kD301);
    tmp3_8 = kB301 - kG301;
    // Op 302: dim3x3 sub_swap
    uint64_t s0_302_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_302_0 = *(gl64_t*)&dParams->aux_trace[s0_302_pos];
    gl64_t s0_302_1 = *(gl64_t*)&dParams->aux_trace[s0_302_pos + TILE_HEIGHT];
    gl64_t s0_302_2 = *(gl64_t*)&dParams->aux_trace[s0_302_pos + 2*TILE_HEIGHT];
    gl64_t s1_302_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_302_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_302_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_0 = s1_302_0 - s0_302_0; tmp3_1 = s1_302_1 - s0_302_1; tmp3_2 = s1_302_2 - s0_302_2;
    // Op 303: dim3x3 sub
    gl64_t s1_303_0 = *(gl64_t*)&expressions_params[10][1];
    gl64_t s1_303_1 = *(gl64_t*)&expressions_params[10][1+1];
    gl64_t s1_303_2 = *(gl64_t*)&expressions_params[10][1+2];
    tmp3_0 = tmp3_0 - s1_303_0; tmp3_1 = tmp3_1 - s1_303_1; tmp3_2 = tmp3_2 - s1_303_2;
    // Op 304: dim3x1 mul
    gl64_t s1_304 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_304; tmp3_1 = tmp3_1 * s1_304; tmp3_2 = tmp3_2 * s1_304;
    // Op 305: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 306: dim3x1 mul
    gl64_t s1_306 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_306; tmp3_1 = tmp3_1 * s1_306; tmp3_2 = tmp3_2 * s1_306;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
