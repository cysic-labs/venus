// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: b2412d29  nOps=96 nTemp1=3 nTemp3=5
#define GENERATED_EVAL_NOPS_b2412d29 96
#define GENERATED_EVAL_NTEMP1_b2412d29 3
#define GENERATED_EVAL_NTEMP3_b2412d29 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_b2412d29(
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

    // Register-resident temporaries: 3 tmp1 + 15 tmp3 slots
    gl64_t tmp1_0 = gl64_t(uint64_t(0));
    gl64_t tmp1_1 = gl64_t(uint64_t(0));
    gl64_t tmp1_2 = gl64_t(uint64_t(0));
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
    gl64_t s0_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_0 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = s1_0 - s0_0;
    // Op 1: dim1x1 mul
    gl64_t s0_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_1 * tmp1_0;
    // Op 2: dim3x1 mul
    gl64_t s0_2_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s0_2_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s0_2_2 = *(gl64_t*)&expressions_params[13][6+2];
    tmp3_0 = s0_2_0 * tmp1_0; tmp3_1 = s0_2_1 * tmp1_0; tmp3_2 = s0_2_2 * tmp1_0;
    // Op 3: dim1x1 add
    gl64_t s0_3 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_3 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_2 = s0_3 + s1_3;
    // Op 4: dim1x1 mul
    gl64_t s0_4 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_4 = *(gl64_t*)&expressions_params[9][7];
    tmp1_0 = s0_4 * s1_4;
    // Op 5: dim1x1 mul
    gl64_t s0_5 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_5 = *(gl64_t*)&expressions_params[9][2];
    tmp1_1 = s0_5 * s1_5;
    // Op 6: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 7: dim1x1 add
    gl64_t s0_7 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_7 + tmp1_0;
    // Op 8: dim1x1 sub
    tmp1_0 = tmp1_2 - tmp1_0;
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
    gl64_t s0_11 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_11 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = s1_11 - s0_11;
    // Op 12: dim1x1 mul
    gl64_t s0_12 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
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
    // Op 15: dim1x1 add
    gl64_t s0_15 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_15 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_15 + s1_15;
    // Op 16: dim1x1 add
    gl64_t s0_16 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_1 = s0_16 + tmp1_0;
    // Op 17: dim1x1 mul
    gl64_t s0_17 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_17 = *(gl64_t*)&expressions_params[9][7];
    tmp1_0 = s0_17 * s1_17;
    // Op 18: dim1x1 mul
    gl64_t s0_18 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_18 = *(gl64_t*)&expressions_params[9][2];
    tmp1_2 = s0_18 * s1_18;
    // Op 19: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 20: dim1x1 add
    gl64_t s0_20 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_20 + tmp1_0;
    // Op 21: dim1x1 sub
    tmp1_0 = tmp1_1 - tmp1_0;
    // Op 22: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 23: dim3x3 mul
    gl64_t s1_23_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_23_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_23_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA23 = (tmp3_0 + tmp3_1) * (s1_23_0 + s1_23_1);
    gl64_t kB23 = (tmp3_0 + tmp3_2) * (s1_23_0 + s1_23_2);
    gl64_t kC23 = (tmp3_1 + tmp3_2) * (s1_23_1 + s1_23_2);
    gl64_t kD23 = tmp3_0 * s1_23_0;
    gl64_t kE23 = tmp3_1 * s1_23_1;
    gl64_t kF23 = tmp3_2 * s1_23_2;
    gl64_t kG23 = kD23 - kE23;
    tmp3_12 = (kC23 + kG23) - kF23;
    tmp3_13 = ((((kA23 + kC23) - kE23) - kE23) - kD23);
    tmp3_14 = kB23 - kG23;
    // Op 24: dim3x1 mul
    gl64_t s0_24_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_24_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_24_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_24 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp3_0 = s0_24_0 * s1_24; tmp3_1 = s0_24_1 * s1_24; tmp3_2 = s0_24_2 * s1_24;
    // Op 25: dim3x1 add
    gl64_t s1_25 = *(gl64_t*)&expressions_params[9][0];
    tmp3_9 = tmp3_0 + s1_25; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 26: dim3x3 add
    gl64_t s1_26_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_26_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_26_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_26_0; tmp3_4 = tmp3_10 + s1_26_1; tmp3_5 = tmp3_11 + s1_26_2;
    // Op 27: dim3x1 mul
    gl64_t s0_27_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_27_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_27_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_27 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp3_0 = s0_27_0 * s1_27; tmp3_1 = s0_27_1 * s1_27; tmp3_2 = s0_27_2 * s1_27;
    // Op 28: dim3x1 add
    gl64_t s1_28 = *(gl64_t*)&expressions_params[9][0];
    tmp3_6 = tmp3_0 + s1_28; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 29: dim3x3 add
    gl64_t s1_29_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_29_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_29_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_29_0; tmp3_1 = tmp3_7 + s1_29_1; tmp3_2 = tmp3_8 + s1_29_2;
    // Op 30: dim3x3 mul
    gl64_t kA30 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB30 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC30 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD30 = tmp3_3 * tmp3_0;
    gl64_t kE30 = tmp3_4 * tmp3_1;
    gl64_t kF30 = tmp3_5 * tmp3_2;
    gl64_t kG30 = kD30 - kE30;
    tmp3_0 = (kC30 + kG30) - kF30;
    tmp3_1 = ((((kA30 + kC30) - kE30) - kE30) - kD30);
    tmp3_2 = kB30 - kG30;
    // Op 31: dim3x3 mul
    gl64_t s0_31_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_31_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_31_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA31 = (s0_31_0 + s0_31_1) * (tmp3_0 + tmp3_1);
    gl64_t kB31 = (s0_31_0 + s0_31_2) * (tmp3_0 + tmp3_2);
    gl64_t kC31 = (s0_31_1 + s0_31_2) * (tmp3_1 + tmp3_2);
    gl64_t kD31 = s0_31_0 * tmp3_0;
    gl64_t kE31 = s0_31_1 * tmp3_1;
    gl64_t kF31 = s0_31_2 * tmp3_2;
    gl64_t kG31 = kD31 - kE31;
    tmp3_0 = (kC31 + kG31) - kF31;
    tmp3_1 = ((((kA31 + kC31) - kE31) - kE31) - kD31);
    tmp3_2 = kB31 - kG31;
    // Op 32: dim3x3 add
    gl64_t s1_32_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_32_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_32_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_32_0; tmp3_7 = tmp3_7 + s1_32_1; tmp3_8 = tmp3_8 + s1_32_2;
    // Op 33: dim3x1 mul
    gl64_t s1_33 = *(gl64_t*)&expressions_params[9][1];
    tmp3_6 = tmp3_6 * s1_33; tmp3_7 = tmp3_7 * s1_33; tmp3_8 = tmp3_8 * s1_33;
    // Op 34: dim3x3 add
    gl64_t s1_34_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_34_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_34_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_34_0; tmp3_10 = tmp3_10 + s1_34_1; tmp3_11 = tmp3_11 + s1_34_2;
    // Op 35: dim3x1 mul
    gl64_t s1_35 = *(gl64_t*)&expressions_params[9][1];
    tmp3_9 = tmp3_9 * s1_35; tmp3_10 = tmp3_10 * s1_35; tmp3_11 = tmp3_11 * s1_35;
    // Op 36: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 37: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 38: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
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
    tmp3_3 = (kC39 + kG39) - kF39;
    tmp3_4 = ((((kA39 + kC39) - kE39) - kE39) - kD39);
    tmp3_5 = kB39 - kG39;
    // Op 40: dim3x1 mul
    gl64_t s0_40_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_40_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_40_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_40 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp3_0 = s0_40_0 * s1_40; tmp3_1 = s0_40_1 * s1_40; tmp3_2 = s0_40_2 * s1_40;
    // Op 41: dim3x1 add
    gl64_t s1_41 = *(gl64_t*)&expressions_params[9][0];
    tmp3_9 = tmp3_0 + s1_41; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 42: dim3x3 add
    gl64_t s1_42_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_42_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_42_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_42_0; tmp3_13 = tmp3_10 + s1_42_1; tmp3_14 = tmp3_11 + s1_42_2;
    // Op 43: dim1x1 mul
    gl64_t s0_43 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_43 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_43 * s1_43;
    // Op 44: dim1x1 add
    gl64_t s0_44 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_44 + tmp1_0;
    // Op 45: dim3x1 mul
    gl64_t s0_45_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_45_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_45_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_45_0 * tmp1_0; tmp3_1 = s0_45_1 * tmp1_0; tmp3_2 = s0_45_2 * tmp1_0;
    // Op 46: dim1x1 mul
    gl64_t s0_46 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_46 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_46 * s1_46;
    // Op 47: dim1x1 add
    gl64_t s0_47 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_47 + tmp1_0;
    // Op 48: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 49: dim3x3 mul
    gl64_t s1_49_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_49_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_49_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 50: dim3x1 add
    gl64_t s1_50 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_50; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 51: dim3x3 mul
    gl64_t s1_51_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_51_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_51_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 52: dim3x1 add
    gl64_t s1_52 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_52; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 53: dim3x3 mul
    gl64_t s1_53_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_53_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_53_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 54: dim3x1 add
    gl64_t s1_54 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_54; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 55: dim3x3 mul
    gl64_t s1_55_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_55_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_55_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 56: dim3x1 add
    gl64_t s1_56 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_56; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 57: dim3x3 mul
    gl64_t s1_57_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_57_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_57_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 58: dim3x1 add
    gl64_t s1_58 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_58; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 59: dim3x3 mul
    gl64_t s1_59_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_59_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_59_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 60: dim3x1 add
    gl64_t s1_60 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_0 + s1_60; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 61: dim3x3 add
    gl64_t s1_61_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_61_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_61_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_61_0; tmp3_1 = tmp3_7 + s1_61_1; tmp3_2 = tmp3_8 + s1_61_2;
    // Op 62: dim3x3 mul
    gl64_t kA62 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB62 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC62 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD62 = tmp3_12 * tmp3_0;
    gl64_t kE62 = tmp3_13 * tmp3_1;
    gl64_t kF62 = tmp3_14 * tmp3_2;
    gl64_t kG62 = kD62 - kE62;
    tmp3_0 = (kC62 + kG62) - kF62;
    tmp3_1 = ((((kA62 + kC62) - kE62) - kE62) - kD62);
    tmp3_2 = kB62 - kG62;
    // Op 63: dim3x3 mul
    gl64_t s0_63_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_63_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_63_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA63 = (s0_63_0 + s0_63_1) * (tmp3_0 + tmp3_1);
    gl64_t kB63 = (s0_63_0 + s0_63_2) * (tmp3_0 + tmp3_2);
    gl64_t kC63 = (s0_63_1 + s0_63_2) * (tmp3_1 + tmp3_2);
    gl64_t kD63 = s0_63_0 * tmp3_0;
    gl64_t kE63 = s0_63_1 * tmp3_1;
    gl64_t kF63 = s0_63_2 * tmp3_2;
    gl64_t kG63 = kD63 - kE63;
    tmp3_0 = (kC63 + kG63) - kF63;
    tmp3_1 = ((((kA63 + kC63) - kE63) - kE63) - kD63);
    tmp3_2 = kB63 - kG63;
    // Op 64: dim3x3 add
    gl64_t s1_64_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_64_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_64_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_64_0; tmp3_7 = tmp3_7 + s1_64_1; tmp3_8 = tmp3_8 + s1_64_2;
    // Op 65: dim3x1 mul
    gl64_t s1_65 = *(gl64_t*)&expressions_params[9][1];
    tmp3_6 = tmp3_6 * s1_65; tmp3_7 = tmp3_7 * s1_65; tmp3_8 = tmp3_8 * s1_65;
    // Op 66: dim3x3 add
    gl64_t s1_66_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_66_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_66_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_66_0; tmp3_10 = tmp3_10 + s1_66_1; tmp3_11 = tmp3_11 + s1_66_2;
    // Op 67: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 68: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 69: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
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
    tmp3_6 = (kC70 + kG70) - kF70;
    tmp3_7 = ((((kA70 + kC70) - kE70) - kE70) - kD70);
    tmp3_8 = kB70 - kG70;
    // Op 71: dim1x1 sub_swap
    gl64_t s0_71 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_71 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = s1_71 - s0_71;
    // Op 72: dim3x1 mul
    uint64_t s0_72_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_72_0 = *(gl64_t*)&dParams->aux_trace[s0_72_pos];
    gl64_t s0_72_1 = *(gl64_t*)&dParams->aux_trace[s0_72_pos + TILE_HEIGHT];
    gl64_t s0_72_2 = *(gl64_t*)&dParams->aux_trace[s0_72_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_72_0 * tmp1_0; tmp3_1 = s0_72_1 * tmp1_0; tmp3_2 = s0_72_2 * tmp1_0;
    // Op 73: dim3x3 sub
    uint64_t s0_73_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_73_0 = *(gl64_t*)&dParams->aux_trace[s0_73_pos];
    gl64_t s0_73_1 = *(gl64_t*)&dParams->aux_trace[s0_73_pos + TILE_HEIGHT];
    gl64_t s0_73_2 = *(gl64_t*)&dParams->aux_trace[s0_73_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_73_0 - tmp3_0; tmp3_1 = s0_73_1 - tmp3_1; tmp3_2 = s0_73_2 - tmp3_2;
    // Op 74: dim3x3 add
    gl64_t s0_74_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_74_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_74_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_74_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_74_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_74_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_3 = s0_74_0 + s1_74_0; tmp3_4 = s0_74_1 + s1_74_1; tmp3_5 = s0_74_2 + s1_74_2;
    // Op 75: dim3x3 sub
    tmp3_3 = tmp3_0 - tmp3_3; tmp3_4 = tmp3_1 - tmp3_4; tmp3_5 = tmp3_2 - tmp3_5;
    // Op 76: dim3x1 mul
    gl64_t s0_76_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_76_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_76_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_76 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp3_0 = s0_76_0 * s1_76; tmp3_1 = s0_76_1 * s1_76; tmp3_2 = s0_76_2 * s1_76;
    // Op 77: dim3x1 add
    gl64_t s1_77 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_77; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 78: dim3x3 add
    gl64_t s1_78_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_78_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_78_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_78_0; tmp3_1 = tmp3_1 + s1_78_1; tmp3_2 = tmp3_2 + s1_78_2;
    // Op 79: dim3x3 mul
    gl64_t kA79 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB79 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC79 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD79 = tmp3_3 * tmp3_0;
    gl64_t kE79 = tmp3_4 * tmp3_1;
    gl64_t kF79 = tmp3_5 * tmp3_2;
    gl64_t kG79 = kD79 - kE79;
    tmp3_0 = (kC79 + kG79) - kF79;
    tmp3_1 = ((((kA79 + kC79) - kE79) - kE79) - kD79);
    tmp3_2 = kB79 - kG79;
    // Op 80: dim3x1 add
    gl64_t s1_80 = *(gl64_t*)&expressions_params[9][6];
    tmp3_0 = tmp3_0 + s1_80; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 81: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    tmp3_6 = (kC82 + kG82) - kF82;
    tmp3_7 = ((((kA82 + kC82) - kE82) - kE82) - kD82);
    tmp3_8 = kB82 - kG82;
    // Op 83: dim3x1 mul
    gl64_t s0_83_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_83_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_83_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_83 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = s0_83_0 * s1_83; tmp3_1 = s0_83_1 * s1_83; tmp3_2 = s0_83_2 * s1_83;
    // Op 84: dim3x1 add
    gl64_t s1_84 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_84; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 85: dim3x3 add
    gl64_t s1_85_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_85_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_85_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_85_0; tmp3_1 = tmp3_1 + s1_85_1; tmp3_2 = tmp3_2 + s1_85_2;
    // Op 86: dim3x3 mul
    gl64_t s1_86_0 = *(gl64_t*)&expressions_params[10][1];
    gl64_t s1_86_1 = *(gl64_t*)&expressions_params[10][1+1];
    gl64_t s1_86_2 = *(gl64_t*)&expressions_params[10][1+2];
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
    // Op 87: dim1x1 sub
    gl64_t s0_87 = *(gl64_t*)&expressions_params[9][5];
    gl64_t s1_87 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_87 - s1_87;
    // Op 88: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 89: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    tmp3_6 = (kC90 + kG90) - kF90;
    tmp3_7 = ((((kA90 + kC90) - kE90) - kE90) - kD90);
    tmp3_8 = kB90 - kG90;
    // Op 91: dim3x3 sub_swap
    uint64_t s0_91_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_91_0 = *(gl64_t*)&dParams->aux_trace[s0_91_pos];
    gl64_t s0_91_1 = *(gl64_t*)&dParams->aux_trace[s0_91_pos + TILE_HEIGHT];
    gl64_t s0_91_2 = *(gl64_t*)&dParams->aux_trace[s0_91_pos + 2*TILE_HEIGHT];
    gl64_t s1_91_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_91_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_91_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_0 = s1_91_0 - s0_91_0; tmp3_1 = s1_91_1 - s0_91_1; tmp3_2 = s1_91_2 - s0_91_2;
    // Op 92: dim3x3 sub
    gl64_t s1_92_0 = *(gl64_t*)&expressions_params[10][1];
    gl64_t s1_92_1 = *(gl64_t*)&expressions_params[10][1+1];
    gl64_t s1_92_2 = *(gl64_t*)&expressions_params[10][1+2];
    tmp3_0 = tmp3_0 - s1_92_0; tmp3_1 = tmp3_1 - s1_92_1; tmp3_2 = tmp3_2 - s1_92_2;
    // Op 93: dim3x1 mul
    gl64_t s1_93 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_93; tmp3_1 = tmp3_1 * s1_93; tmp3_2 = tmp3_2 * s1_93;
    // Op 94: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 95: dim3x1 mul
    gl64_t s1_95 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_95; tmp3_1 = tmp3_1 * s1_95; tmp3_2 = tmp3_2 * s1_95;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
