// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: 15241f19  nOps=251 nTemp1=1 nTemp3=5
#define GENERATED_EVAL_NOPS_15241f19 251
#define GENERATED_EVAL_NTEMP1_15241f19 1
#define GENERATED_EVAL_NTEMP3_15241f19 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_15241f19(
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

    // Register-resident temporaries: 1 tmp1 + 15 tmp3 slots
    gl64_t tmp1_0 = gl64_t(uint64_t(0));
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

    // Op 0: dim3x1 mul
    gl64_t s0_0_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_0_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_0_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_0 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_0)];
    tmp3_0 = s0_0_0 * s1_0; tmp3_1 = s0_0_1 * s1_0; tmp3_2 = s0_0_2 * s1_0;
    // Op 1: dim3x1 add
    gl64_t s1_1 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_0)];
    tmp3_9 = tmp3_0 + s1_1; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 2: dim3x3 add
    gl64_t s1_2_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_2_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_2_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_2_0; tmp3_4 = tmp3_10 + s1_2_1; tmp3_5 = tmp3_11 + s1_2_2;
    // Op 3: dim3x1 mul
    gl64_t s0_3_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_0)];
    tmp3_0 = s0_3_0 * s1_3; tmp3_1 = s0_3_1 * s1_3; tmp3_2 = s0_3_2 * s1_3;
    // Op 4: dim3x1 add
    gl64_t s1_4 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_0)];
    tmp3_6 = tmp3_0 + s1_4; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 5: dim3x3 add
    gl64_t s1_5_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_5_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_5_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_5_0; tmp3_1 = tmp3_7 + s1_5_1; tmp3_2 = tmp3_8 + s1_5_2;
    // Op 6: dim3x3 mul
    gl64_t kA6 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB6 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC6 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD6 = tmp3_3 * tmp3_0;
    gl64_t kE6 = tmp3_4 * tmp3_1;
    gl64_t kF6 = tmp3_5 * tmp3_2;
    gl64_t kG6 = kD6 - kE6;
    tmp3_0 = (kC6 + kG6) - kF6;
    tmp3_1 = ((((kA6 + kC6) - kE6) - kE6) - kD6);
    tmp3_2 = kB6 - kG6;
    // Op 7: dim3x3 mul
    gl64_t s0_7_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_7_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_7_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA7 = (s0_7_0 + s0_7_1) * (tmp3_0 + tmp3_1);
    gl64_t kB7 = (s0_7_0 + s0_7_2) * (tmp3_0 + tmp3_2);
    gl64_t kC7 = (s0_7_1 + s0_7_2) * (tmp3_1 + tmp3_2);
    gl64_t kD7 = s0_7_0 * tmp3_0;
    gl64_t kE7 = s0_7_1 * tmp3_1;
    gl64_t kF7 = s0_7_2 * tmp3_2;
    gl64_t kG7 = kD7 - kE7;
    tmp3_0 = (kC7 + kG7) - kF7;
    tmp3_1 = ((((kA7 + kC7) - kE7) - kE7) - kD7);
    tmp3_2 = kB7 - kG7;
    // Op 8: dim3x3 add
    gl64_t s1_8_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_8_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_8_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_8_0; tmp3_7 = tmp3_7 + s1_8_1; tmp3_8 = tmp3_8 + s1_8_2;
    // Op 9: dim3x1 mul
    gl64_t s1_9 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp3_6 = tmp3_6 * s1_9; tmp3_7 = tmp3_7 * s1_9; tmp3_8 = tmp3_8 * s1_9;
    // Op 10: dim3x3 add
    gl64_t s1_10_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_10_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_10_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_10_0; tmp3_10 = tmp3_10 + s1_10_1; tmp3_11 = tmp3_11 + s1_10_2;
    // Op 11: dim3x1 mul
    gl64_t s1_11 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_11; tmp3_10 = tmp3_10 * s1_11; tmp3_11 = tmp3_11 * s1_11;
    // Op 12: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 13: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
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
    tmp3_12 = (kC14 + kG14) - kF14;
    tmp3_13 = ((((kA14 + kC14) - kE14) - kE14) - kD14);
    tmp3_14 = kB14 - kG14;
    // Op 15: dim3x1 mul
    gl64_t s0_15_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_15_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_15_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_15 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_0)];
    tmp3_0 = s0_15_0 * s1_15; tmp3_1 = s0_15_1 * s1_15; tmp3_2 = s0_15_2 * s1_15;
    // Op 16: dim3x1 add
    gl64_t s1_16 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_0)];
    tmp3_3 = tmp3_0 + s1_16; tmp3_4 = tmp3_1; tmp3_5 = tmp3_2;
    // Op 17: dim3x3 add
    gl64_t s1_17_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_17_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_17_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_3 + s1_17_0; tmp3_7 = tmp3_4 + s1_17_1; tmp3_8 = tmp3_5 + s1_17_2;
    // Op 18: dim3x1 mul
    gl64_t s0_18_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_18_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_18_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_18 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_0)];
    tmp3_0 = s0_18_0 * s1_18; tmp3_1 = s0_18_1 * s1_18; tmp3_2 = s0_18_2 * s1_18;
    // Op 19: dim3x1 add
    gl64_t s1_19 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_0)];
    tmp3_9 = tmp3_0 + s1_19; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 20: dim3x3 add
    gl64_t s1_20_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_20_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_20_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_9 + s1_20_0; tmp3_1 = tmp3_10 + s1_20_1; tmp3_2 = tmp3_11 + s1_20_2;
    // Op 21: dim3x3 mul
    gl64_t kA21 = (tmp3_6 + tmp3_7) * (tmp3_0 + tmp3_1);
    gl64_t kB21 = (tmp3_6 + tmp3_8) * (tmp3_0 + tmp3_2);
    gl64_t kC21 = (tmp3_7 + tmp3_8) * (tmp3_1 + tmp3_2);
    gl64_t kD21 = tmp3_6 * tmp3_0;
    gl64_t kE21 = tmp3_7 * tmp3_1;
    gl64_t kF21 = tmp3_8 * tmp3_2;
    gl64_t kG21 = kD21 - kE21;
    tmp3_0 = (kC21 + kG21) - kF21;
    tmp3_1 = ((((kA21 + kC21) - kE21) - kE21) - kD21);
    tmp3_2 = kB21 - kG21;
    // Op 22: dim3x3 mul
    gl64_t s0_22_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_22_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_22_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA22 = (s0_22_0 + s0_22_1) * (tmp3_0 + tmp3_1);
    gl64_t kB22 = (s0_22_0 + s0_22_2) * (tmp3_0 + tmp3_2);
    gl64_t kC22 = (s0_22_1 + s0_22_2) * (tmp3_1 + tmp3_2);
    gl64_t kD22 = s0_22_0 * tmp3_0;
    gl64_t kE22 = s0_22_1 * tmp3_1;
    gl64_t kF22 = s0_22_2 * tmp3_2;
    gl64_t kG22 = kD22 - kE22;
    tmp3_0 = (kC22 + kG22) - kF22;
    tmp3_1 = ((((kA22 + kC22) - kE22) - kE22) - kD22);
    tmp3_2 = kB22 - kG22;
    // Op 23: dim3x3 add
    gl64_t s1_23_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_23_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_23_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_23_0; tmp3_10 = tmp3_10 + s1_23_1; tmp3_11 = tmp3_11 + s1_23_2;
    // Op 24: dim3x1 mul
    gl64_t s1_24 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_24; tmp3_10 = tmp3_10 * s1_24; tmp3_11 = tmp3_11 * s1_24;
    // Op 25: dim3x3 add
    gl64_t s1_25_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_25_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_25_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_3 + s1_25_0; tmp3_4 = tmp3_4 + s1_25_1; tmp3_5 = tmp3_5 + s1_25_2;
    // Op 26: dim3x1 mul
    gl64_t s1_26 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp3_3 = tmp3_3 * s1_26; tmp3_4 = tmp3_4 * s1_26; tmp3_5 = tmp3_5 * s1_26;
    // Op 27: dim3x3 add
    tmp3_3 = tmp3_9 + tmp3_3; tmp3_4 = tmp3_10 + tmp3_4; tmp3_5 = tmp3_11 + tmp3_5;
    // Op 28: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_3; tmp3_1 = tmp3_1 - tmp3_4; tmp3_2 = tmp3_2 - tmp3_5;
    // Op 29: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 30: dim3x3 mul
    gl64_t s1_30_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_30_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_30_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA30 = (tmp3_0 + tmp3_1) * (s1_30_0 + s1_30_1);
    gl64_t kB30 = (tmp3_0 + tmp3_2) * (s1_30_0 + s1_30_2);
    gl64_t kC30 = (tmp3_1 + tmp3_2) * (s1_30_1 + s1_30_2);
    gl64_t kD30 = tmp3_0 * s1_30_0;
    gl64_t kE30 = tmp3_1 * s1_30_1;
    gl64_t kF30 = tmp3_2 * s1_30_2;
    gl64_t kG30 = kD30 - kE30;
    tmp3_6 = (kC30 + kG30) - kF30;
    tmp3_7 = ((((kA30 + kC30) - kE30) - kE30) - kD30);
    tmp3_8 = kB30 - kG30;
    // Op 31: dim3x1 mul
    gl64_t s0_31_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_31_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_31_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_31 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_0)];
    tmp3_0 = s0_31_0 * s1_31; tmp3_1 = s0_31_1 * s1_31; tmp3_2 = s0_31_2 * s1_31;
    // Op 32: dim3x1 add
    gl64_t s1_32 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_0)];
    tmp3_9 = tmp3_0 + s1_32; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 33: dim3x3 add
    gl64_t s1_33_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_33_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_33_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_33_0; tmp3_13 = tmp3_10 + s1_33_1; tmp3_14 = tmp3_11 + s1_33_2;
    // Op 34: dim3x1 mul
    gl64_t s0_34_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_34_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_34_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_34 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_0)];
    tmp3_0 = s0_34_0 * s1_34; tmp3_1 = s0_34_1 * s1_34; tmp3_2 = s0_34_2 * s1_34;
    // Op 35: dim3x1 add
    gl64_t s1_35 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_0)];
    tmp3_3 = tmp3_0 + s1_35; tmp3_4 = tmp3_1; tmp3_5 = tmp3_2;
    // Op 36: dim3x3 add
    gl64_t s1_36_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_36_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_36_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_3 + s1_36_0; tmp3_1 = tmp3_4 + s1_36_1; tmp3_2 = tmp3_5 + s1_36_2;
    // Op 37: dim3x3 mul
    gl64_t kA37 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB37 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC37 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD37 = tmp3_12 * tmp3_0;
    gl64_t kE37 = tmp3_13 * tmp3_1;
    gl64_t kF37 = tmp3_14 * tmp3_2;
    gl64_t kG37 = kD37 - kE37;
    tmp3_0 = (kC37 + kG37) - kF37;
    tmp3_1 = ((((kA37 + kC37) - kE37) - kE37) - kD37);
    tmp3_2 = kB37 - kG37;
    // Op 38: dim3x3 mul
    uint64_t s0_38_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_38_0 = *(gl64_t*)&dParams->aux_trace[s0_38_pos];
    gl64_t s0_38_1 = *(gl64_t*)&dParams->aux_trace[s0_38_pos + TILE_HEIGHT];
    gl64_t s0_38_2 = *(gl64_t*)&dParams->aux_trace[s0_38_pos + 2*TILE_HEIGHT];
    gl64_t kA38 = (s0_38_0 + s0_38_1) * (tmp3_0 + tmp3_1);
    gl64_t kB38 = (s0_38_0 + s0_38_2) * (tmp3_0 + tmp3_2);
    gl64_t kC38 = (s0_38_1 + s0_38_2) * (tmp3_1 + tmp3_2);
    gl64_t kD38 = s0_38_0 * tmp3_0;
    gl64_t kE38 = s0_38_1 * tmp3_1;
    gl64_t kF38 = s0_38_2 * tmp3_2;
    gl64_t kG38 = kD38 - kE38;
    tmp3_0 = (kC38 + kG38) - kF38;
    tmp3_1 = ((((kA38 + kC38) - kE38) - kE38) - kD38);
    tmp3_2 = kB38 - kG38;
    // Op 39: dim3x3 add
    gl64_t s1_39_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_39_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_39_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_3 + s1_39_0; tmp3_4 = tmp3_4 + s1_39_1; tmp3_5 = tmp3_5 + s1_39_2;
    // Op 40: dim3x1 mul
    gl64_t s1_40 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp3_3 = tmp3_3 * s1_40; tmp3_4 = tmp3_4 * s1_40; tmp3_5 = tmp3_5 * s1_40;
    // Op 41: dim3x3 add
    gl64_t s1_41_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_41_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_41_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_41_0; tmp3_10 = tmp3_10 + s1_41_1; tmp3_11 = tmp3_11 + s1_41_2;
    // Op 42: dim3x1 mul
    gl64_t s1_42 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_42; tmp3_10 = tmp3_10 * s1_42; tmp3_11 = tmp3_11 * s1_42;
    // Op 43: dim3x3 add
    tmp3_3 = tmp3_3 + tmp3_9; tmp3_4 = tmp3_4 + tmp3_10; tmp3_5 = tmp3_5 + tmp3_11;
    // Op 44: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_3; tmp3_1 = tmp3_1 - tmp3_4; tmp3_2 = tmp3_2 - tmp3_5;
    // Op 45: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    tmp3_12 = (kC46 + kG46) - kF46;
    tmp3_13 = ((((kA46 + kC46) - kE46) - kE46) - kD46);
    tmp3_14 = kB46 - kG46;
    // Op 47: dim3x1 mul
    gl64_t s0_47_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_47_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_47_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_47 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_0)];
    tmp3_0 = s0_47_0 * s1_47; tmp3_1 = s0_47_1 * s1_47; tmp3_2 = s0_47_2 * s1_47;
    // Op 48: dim3x1 add
    gl64_t s1_48 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_0)];
    tmp3_9 = tmp3_0 + s1_48; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 49: dim3x3 add
    gl64_t s1_49_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_49_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_49_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_9 + s1_49_0; tmp3_7 = tmp3_10 + s1_49_1; tmp3_8 = tmp3_11 + s1_49_2;
    // Op 50: dim3x1 mul
    gl64_t s0_50_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_50_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_50_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_50 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_0)];
    tmp3_0 = s0_50_0 * s1_50; tmp3_1 = s0_50_1 * s1_50; tmp3_2 = s0_50_2 * s1_50;
    // Op 51: dim3x1 add
    gl64_t s1_51 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_0)];
    tmp3_3 = tmp3_0 + s1_51; tmp3_4 = tmp3_1; tmp3_5 = tmp3_2;
    // Op 52: dim3x3 add
    gl64_t s1_52_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_52_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_52_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_3 + s1_52_0; tmp3_1 = tmp3_4 + s1_52_1; tmp3_2 = tmp3_5 + s1_52_2;
    // Op 53: dim3x3 mul
    gl64_t kA53 = (tmp3_6 + tmp3_7) * (tmp3_0 + tmp3_1);
    gl64_t kB53 = (tmp3_6 + tmp3_8) * (tmp3_0 + tmp3_2);
    gl64_t kC53 = (tmp3_7 + tmp3_8) * (tmp3_1 + tmp3_2);
    gl64_t kD53 = tmp3_6 * tmp3_0;
    gl64_t kE53 = tmp3_7 * tmp3_1;
    gl64_t kF53 = tmp3_8 * tmp3_2;
    gl64_t kG53 = kD53 - kE53;
    tmp3_0 = (kC53 + kG53) - kF53;
    tmp3_1 = ((((kA53 + kC53) - kE53) - kE53) - kD53);
    tmp3_2 = kB53 - kG53;
    // Op 54: dim3x3 mul
    uint64_t s0_54_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_54_0 = *(gl64_t*)&dParams->aux_trace[s0_54_pos];
    gl64_t s0_54_1 = *(gl64_t*)&dParams->aux_trace[s0_54_pos + TILE_HEIGHT];
    gl64_t s0_54_2 = *(gl64_t*)&dParams->aux_trace[s0_54_pos + 2*TILE_HEIGHT];
    gl64_t kA54 = (s0_54_0 + s0_54_1) * (tmp3_0 + tmp3_1);
    gl64_t kB54 = (s0_54_0 + s0_54_2) * (tmp3_0 + tmp3_2);
    gl64_t kC54 = (s0_54_1 + s0_54_2) * (tmp3_1 + tmp3_2);
    gl64_t kD54 = s0_54_0 * tmp3_0;
    gl64_t kE54 = s0_54_1 * tmp3_1;
    gl64_t kF54 = s0_54_2 * tmp3_2;
    gl64_t kG54 = kD54 - kE54;
    tmp3_0 = (kC54 + kG54) - kF54;
    tmp3_1 = ((((kA54 + kC54) - kE54) - kE54) - kD54);
    tmp3_2 = kB54 - kG54;
    // Op 55: dim3x3 add
    gl64_t s1_55_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_55_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_55_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_3 + s1_55_0; tmp3_4 = tmp3_4 + s1_55_1; tmp3_5 = tmp3_5 + s1_55_2;
    // Op 56: dim3x1 mul
    gl64_t s1_56 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp3_3 = tmp3_3 * s1_56; tmp3_4 = tmp3_4 * s1_56; tmp3_5 = tmp3_5 * s1_56;
    // Op 57: dim3x3 add
    gl64_t s1_57_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_57_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_57_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_57_0; tmp3_10 = tmp3_10 + s1_57_1; tmp3_11 = tmp3_11 + s1_57_2;
    // Op 58: dim3x1 mul
    gl64_t s1_58 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_58; tmp3_10 = tmp3_10 * s1_58; tmp3_11 = tmp3_11 * s1_58;
    // Op 59: dim3x3 add
    tmp3_3 = tmp3_3 + tmp3_9; tmp3_4 = tmp3_4 + tmp3_10; tmp3_5 = tmp3_5 + tmp3_11;
    // Op 60: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_3; tmp3_1 = tmp3_1 - tmp3_4; tmp3_2 = tmp3_2 - tmp3_5;
    // Op 61: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
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
    tmp3_6 = (kC62 + kG62) - kF62;
    tmp3_7 = ((((kA62 + kC62) - kE62) - kE62) - kD62);
    tmp3_8 = kB62 - kG62;
    // Op 63: dim3x1 mul
    gl64_t s0_63_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_63_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_63_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_63 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 38, domainSize, nCols_0)];
    tmp3_0 = s0_63_0 * s1_63; tmp3_1 = s0_63_1 * s1_63; tmp3_2 = s0_63_2 * s1_63;
    // Op 64: dim3x1 add
    gl64_t s1_64 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_0)];
    tmp3_9 = tmp3_0 + s1_64; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 65: dim3x3 add
    gl64_t s1_65_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_65_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_65_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_65_0; tmp3_13 = tmp3_10 + s1_65_1; tmp3_14 = tmp3_11 + s1_65_2;
    // Op 66: dim3x1 mul
    gl64_t s0_66_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_66_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_66_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_66 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 39, domainSize, nCols_0)];
    tmp3_0 = s0_66_0 * s1_66; tmp3_1 = s0_66_1 * s1_66; tmp3_2 = s0_66_2 * s1_66;
    // Op 67: dim3x1 add
    gl64_t s1_67 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_0)];
    tmp3_3 = tmp3_0 + s1_67; tmp3_4 = tmp3_1; tmp3_5 = tmp3_2;
    // Op 68: dim3x3 add
    gl64_t s1_68_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_68_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_68_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_3 + s1_68_0; tmp3_1 = tmp3_4 + s1_68_1; tmp3_2 = tmp3_5 + s1_68_2;
    // Op 69: dim3x3 mul
    gl64_t kA69 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB69 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC69 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD69 = tmp3_12 * tmp3_0;
    gl64_t kE69 = tmp3_13 * tmp3_1;
    gl64_t kF69 = tmp3_14 * tmp3_2;
    gl64_t kG69 = kD69 - kE69;
    tmp3_0 = (kC69 + kG69) - kF69;
    tmp3_1 = ((((kA69 + kC69) - kE69) - kE69) - kD69);
    tmp3_2 = kB69 - kG69;
    // Op 70: dim3x3 mul
    gl64_t s0_70_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_70_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_70_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    gl64_t kA70 = (s0_70_0 + s0_70_1) * (tmp3_0 + tmp3_1);
    gl64_t kB70 = (s0_70_0 + s0_70_2) * (tmp3_0 + tmp3_2);
    gl64_t kC70 = (s0_70_1 + s0_70_2) * (tmp3_1 + tmp3_2);
    gl64_t kD70 = s0_70_0 * tmp3_0;
    gl64_t kE70 = s0_70_1 * tmp3_1;
    gl64_t kF70 = s0_70_2 * tmp3_2;
    gl64_t kG70 = kD70 - kE70;
    tmp3_0 = (kC70 + kG70) - kF70;
    tmp3_1 = ((((kA70 + kC70) - kE70) - kE70) - kD70);
    tmp3_2 = kB70 - kG70;
    // Op 71: dim3x3 add
    gl64_t s1_71_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_71_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_71_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_3 + s1_71_0; tmp3_4 = tmp3_4 + s1_71_1; tmp3_5 = tmp3_5 + s1_71_2;
    // Op 72: dim3x1 mul
    gl64_t s1_72 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp3_3 = tmp3_3 * s1_72; tmp3_4 = tmp3_4 * s1_72; tmp3_5 = tmp3_5 * s1_72;
    // Op 73: dim3x3 add
    gl64_t s1_73_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_73_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_73_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_73_0; tmp3_10 = tmp3_10 + s1_73_1; tmp3_11 = tmp3_11 + s1_73_2;
    // Op 74: dim3x1 mul
    gl64_t s1_74 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_74; tmp3_10 = tmp3_10 * s1_74; tmp3_11 = tmp3_11 * s1_74;
    // Op 75: dim3x3 add
    tmp3_3 = tmp3_3 + tmp3_9; tmp3_4 = tmp3_4 + tmp3_10; tmp3_5 = tmp3_5 + tmp3_11;
    // Op 76: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_3; tmp3_1 = tmp3_1 - tmp3_4; tmp3_2 = tmp3_2 - tmp3_5;
    // Op 77: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    tmp3_12 = (kC78 + kG78) - kF78;
    tmp3_13 = ((((kA78 + kC78) - kE78) - kE78) - kD78);
    tmp3_14 = kB78 - kG78;
    // Op 79: dim3x1 mul
    gl64_t s0_79_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_79_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_79_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_79 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 40, domainSize, nCols_0)];
    tmp3_0 = s0_79_0 * s1_79; tmp3_1 = s0_79_1 * s1_79; tmp3_2 = s0_79_2 * s1_79;
    // Op 80: dim3x1 add
    gl64_t s1_80 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_0)];
    tmp3_9 = tmp3_0 + s1_80; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 81: dim3x3 add
    gl64_t s1_81_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_81_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_81_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_9 + s1_81_0; tmp3_7 = tmp3_10 + s1_81_1; tmp3_8 = tmp3_11 + s1_81_2;
    // Op 82: dim3x1 mul
    gl64_t s0_82_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_82_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_82_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_82 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 41, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 41, domainSize, nCols_0)];
    tmp3_0 = s0_82_0 * s1_82; tmp3_1 = s0_82_1 * s1_82; tmp3_2 = s0_82_2 * s1_82;
    // Op 83: dim3x1 add
    gl64_t s1_83 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_0)];
    tmp3_3 = tmp3_0 + s1_83; tmp3_4 = tmp3_1; tmp3_5 = tmp3_2;
    // Op 84: dim3x3 add
    gl64_t s1_84_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_84_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_84_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_3 + s1_84_0; tmp3_1 = tmp3_4 + s1_84_1; tmp3_2 = tmp3_5 + s1_84_2;
    // Op 85: dim3x3 mul
    gl64_t kA85 = (tmp3_6 + tmp3_7) * (tmp3_0 + tmp3_1);
    gl64_t kB85 = (tmp3_6 + tmp3_8) * (tmp3_0 + tmp3_2);
    gl64_t kC85 = (tmp3_7 + tmp3_8) * (tmp3_1 + tmp3_2);
    gl64_t kD85 = tmp3_6 * tmp3_0;
    gl64_t kE85 = tmp3_7 * tmp3_1;
    gl64_t kF85 = tmp3_8 * tmp3_2;
    gl64_t kG85 = kD85 - kE85;
    tmp3_0 = (kC85 + kG85) - kF85;
    tmp3_1 = ((((kA85 + kC85) - kE85) - kE85) - kD85);
    tmp3_2 = kB85 - kG85;
    // Op 86: dim3x3 mul
    gl64_t s0_86_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+0, domainSize, nCols_2))];
    gl64_t s0_86_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+1, domainSize, nCols_2))];
    gl64_t s0_86_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+2, domainSize, nCols_2))];
    gl64_t kA86 = (s0_86_0 + s0_86_1) * (tmp3_0 + tmp3_1);
    gl64_t kB86 = (s0_86_0 + s0_86_2) * (tmp3_0 + tmp3_2);
    gl64_t kC86 = (s0_86_1 + s0_86_2) * (tmp3_1 + tmp3_2);
    gl64_t kD86 = s0_86_0 * tmp3_0;
    gl64_t kE86 = s0_86_1 * tmp3_1;
    gl64_t kF86 = s0_86_2 * tmp3_2;
    gl64_t kG86 = kD86 - kE86;
    tmp3_0 = (kC86 + kG86) - kF86;
    tmp3_1 = ((((kA86 + kC86) - kE86) - kE86) - kD86);
    tmp3_2 = kB86 - kG86;
    // Op 87: dim3x3 add
    gl64_t s1_87_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_87_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_87_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_3 + s1_87_0; tmp3_4 = tmp3_4 + s1_87_1; tmp3_5 = tmp3_5 + s1_87_2;
    // Op 88: dim3x1 mul
    gl64_t s1_88 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp3_3 = tmp3_3 * s1_88; tmp3_4 = tmp3_4 * s1_88; tmp3_5 = tmp3_5 * s1_88;
    // Op 89: dim3x3 add
    gl64_t s1_89_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_89_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_89_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_89_0; tmp3_10 = tmp3_10 + s1_89_1; tmp3_11 = tmp3_11 + s1_89_2;
    // Op 90: dim3x1 mul
    gl64_t s1_90 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_90; tmp3_10 = tmp3_10 * s1_90; tmp3_11 = tmp3_11 * s1_90;
    // Op 91: dim3x3 add
    tmp3_3 = tmp3_3 + tmp3_9; tmp3_4 = tmp3_4 + tmp3_10; tmp3_5 = tmp3_5 + tmp3_11;
    // Op 92: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_3; tmp3_1 = tmp3_1 - tmp3_4; tmp3_2 = tmp3_2 - tmp3_5;
    // Op 93: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
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
    tmp3_6 = (kC94 + kG94) - kF94;
    tmp3_7 = ((((kA94 + kC94) - kE94) - kE94) - kD94);
    tmp3_8 = kB94 - kG94;
    // Op 95: dim3x1 mul
    gl64_t s0_95_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_95_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_95_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_95 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 42, domainSize, nCols_0)];
    tmp3_0 = s0_95_0 * s1_95; tmp3_1 = s0_95_1 * s1_95; tmp3_2 = s0_95_2 * s1_95;
    // Op 96: dim3x1 add
    gl64_t s1_96 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_0)];
    tmp3_9 = tmp3_0 + s1_96; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 97: dim3x3 add
    gl64_t s1_97_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_97_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_97_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_97_0; tmp3_13 = tmp3_10 + s1_97_1; tmp3_14 = tmp3_11 + s1_97_2;
    // Op 98: dim3x1 mul
    gl64_t s0_98_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_98_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_98_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_98 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 43, domainSize, nCols_0)];
    tmp3_0 = s0_98_0 * s1_98; tmp3_1 = s0_98_1 * s1_98; tmp3_2 = s0_98_2 * s1_98;
    // Op 99: dim3x1 add
    gl64_t s1_99 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_0)];
    tmp3_3 = tmp3_0 + s1_99; tmp3_4 = tmp3_1; tmp3_5 = tmp3_2;
    // Op 100: dim3x3 add
    gl64_t s1_100_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_100_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_100_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_3 + s1_100_0; tmp3_1 = tmp3_4 + s1_100_1; tmp3_2 = tmp3_5 + s1_100_2;
    // Op 101: dim3x3 mul
    gl64_t kA101 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB101 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC101 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD101 = tmp3_12 * tmp3_0;
    gl64_t kE101 = tmp3_13 * tmp3_1;
    gl64_t kF101 = tmp3_14 * tmp3_2;
    gl64_t kG101 = kD101 - kE101;
    tmp3_0 = (kC101 + kG101) - kF101;
    tmp3_1 = ((((kA101 + kC101) - kE101) - kE101) - kD101);
    tmp3_2 = kB101 - kG101;
    // Op 102: dim3x3 mul
    uint64_t s0_102_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_2));
    gl64_t s0_102_0 = *(gl64_t*)&dParams->aux_trace[s0_102_pos];
    gl64_t s0_102_1 = *(gl64_t*)&dParams->aux_trace[s0_102_pos + TILE_HEIGHT];
    gl64_t s0_102_2 = *(gl64_t*)&dParams->aux_trace[s0_102_pos + 2*TILE_HEIGHT];
    gl64_t kA102 = (s0_102_0 + s0_102_1) * (tmp3_0 + tmp3_1);
    gl64_t kB102 = (s0_102_0 + s0_102_2) * (tmp3_0 + tmp3_2);
    gl64_t kC102 = (s0_102_1 + s0_102_2) * (tmp3_1 + tmp3_2);
    gl64_t kD102 = s0_102_0 * tmp3_0;
    gl64_t kE102 = s0_102_1 * tmp3_1;
    gl64_t kF102 = s0_102_2 * tmp3_2;
    gl64_t kG102 = kD102 - kE102;
    tmp3_0 = (kC102 + kG102) - kF102;
    tmp3_1 = ((((kA102 + kC102) - kE102) - kE102) - kD102);
    tmp3_2 = kB102 - kG102;
    // Op 103: dim3x3 add
    gl64_t s1_103_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_103_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_103_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_3 + s1_103_0; tmp3_4 = tmp3_4 + s1_103_1; tmp3_5 = tmp3_5 + s1_103_2;
    // Op 104: dim3x1 mul
    gl64_t s1_104 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp3_3 = tmp3_3 * s1_104; tmp3_4 = tmp3_4 * s1_104; tmp3_5 = tmp3_5 * s1_104;
    // Op 105: dim3x3 add
    gl64_t s1_105_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_105_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_105_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_105_0; tmp3_10 = tmp3_10 + s1_105_1; tmp3_11 = tmp3_11 + s1_105_2;
    // Op 106: dim3x1 mul
    gl64_t s1_106 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_106; tmp3_10 = tmp3_10 * s1_106; tmp3_11 = tmp3_11 * s1_106;
    // Op 107: dim3x3 add
    tmp3_3 = tmp3_3 + tmp3_9; tmp3_4 = tmp3_4 + tmp3_10; tmp3_5 = tmp3_5 + tmp3_11;
    // Op 108: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_3; tmp3_1 = tmp3_1 - tmp3_4; tmp3_2 = tmp3_2 - tmp3_5;
    // Op 109: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    tmp3_12 = (kC110 + kG110) - kF110;
    tmp3_13 = ((((kA110 + kC110) - kE110) - kE110) - kD110);
    tmp3_14 = kB110 - kG110;
    // Op 111: dim3x1 mul
    gl64_t s0_111_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_111_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_111_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_111 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 44, domainSize, nCols_0)];
    tmp3_0 = s0_111_0 * s1_111; tmp3_1 = s0_111_1 * s1_111; tmp3_2 = s0_111_2 * s1_111;
    // Op 112: dim3x1 add
    gl64_t s1_112 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_0)];
    tmp3_9 = tmp3_0 + s1_112; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 113: dim3x3 add
    gl64_t s1_113_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_113_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_113_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_9 + s1_113_0; tmp3_7 = tmp3_10 + s1_113_1; tmp3_8 = tmp3_11 + s1_113_2;
    // Op 114: dim3x1 mul
    gl64_t s0_114_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_114_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_114_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_114 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 45, domainSize, nCols_0)];
    tmp3_0 = s0_114_0 * s1_114; tmp3_1 = s0_114_1 * s1_114; tmp3_2 = s0_114_2 * s1_114;
    // Op 115: dim3x1 add
    gl64_t s1_115 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_0)];
    tmp3_3 = tmp3_0 + s1_115; tmp3_4 = tmp3_1; tmp3_5 = tmp3_2;
    // Op 116: dim3x3 add
    gl64_t s1_116_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_116_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_116_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_3 + s1_116_0; tmp3_1 = tmp3_4 + s1_116_1; tmp3_2 = tmp3_5 + s1_116_2;
    // Op 117: dim3x3 mul
    gl64_t kA117 = (tmp3_6 + tmp3_7) * (tmp3_0 + tmp3_1);
    gl64_t kB117 = (tmp3_6 + tmp3_8) * (tmp3_0 + tmp3_2);
    gl64_t kC117 = (tmp3_7 + tmp3_8) * (tmp3_1 + tmp3_2);
    gl64_t kD117 = tmp3_6 * tmp3_0;
    gl64_t kE117 = tmp3_7 * tmp3_1;
    gl64_t kF117 = tmp3_8 * tmp3_2;
    gl64_t kG117 = kD117 - kE117;
    tmp3_0 = (kC117 + kG117) - kF117;
    tmp3_1 = ((((kA117 + kC117) - kE117) - kE117) - kD117);
    tmp3_2 = kB117 - kG117;
    // Op 118: dim3x3 mul
    uint64_t s0_118_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_2));
    gl64_t s0_118_0 = *(gl64_t*)&dParams->aux_trace[s0_118_pos];
    gl64_t s0_118_1 = *(gl64_t*)&dParams->aux_trace[s0_118_pos + TILE_HEIGHT];
    gl64_t s0_118_2 = *(gl64_t*)&dParams->aux_trace[s0_118_pos + 2*TILE_HEIGHT];
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
    tmp3_3 = tmp3_3 + s1_119_0; tmp3_4 = tmp3_4 + s1_119_1; tmp3_5 = tmp3_5 + s1_119_2;
    // Op 120: dim3x1 mul
    gl64_t s1_120 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp3_3 = tmp3_3 * s1_120; tmp3_4 = tmp3_4 * s1_120; tmp3_5 = tmp3_5 * s1_120;
    // Op 121: dim3x3 add
    gl64_t s1_121_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_121_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_121_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_121_0; tmp3_10 = tmp3_10 + s1_121_1; tmp3_11 = tmp3_11 + s1_121_2;
    // Op 122: dim3x1 mul
    gl64_t s1_122 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_122; tmp3_10 = tmp3_10 * s1_122; tmp3_11 = tmp3_11 * s1_122;
    // Op 123: dim3x3 add
    tmp3_3 = tmp3_3 + tmp3_9; tmp3_4 = tmp3_4 + tmp3_10; tmp3_5 = tmp3_5 + tmp3_11;
    // Op 124: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_3; tmp3_1 = tmp3_1 - tmp3_4; tmp3_2 = tmp3_2 - tmp3_5;
    // Op 125: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
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
    tmp3_6 = (kC126 + kG126) - kF126;
    tmp3_7 = ((((kA126 + kC126) - kE126) - kE126) - kD126);
    tmp3_8 = kB126 - kG126;
    // Op 127: dim3x1 mul
    gl64_t s0_127_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_127_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_127_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_127 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 46, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 46, domainSize, nCols_0)];
    tmp3_0 = s0_127_0 * s1_127; tmp3_1 = s0_127_1 * s1_127; tmp3_2 = s0_127_2 * s1_127;
    // Op 128: dim3x1 add
    gl64_t s1_128 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_0)];
    tmp3_9 = tmp3_0 + s1_128; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 129: dim3x3 add
    gl64_t s1_129_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_129_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_129_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_129_0; tmp3_13 = tmp3_10 + s1_129_1; tmp3_14 = tmp3_11 + s1_129_2;
    // Op 130: dim3x1 mul
    gl64_t s0_130_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_130_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_130_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_130 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 47, domainSize, nCols_0)];
    tmp3_0 = s0_130_0 * s1_130; tmp3_1 = s0_130_1 * s1_130; tmp3_2 = s0_130_2 * s1_130;
    // Op 131: dim3x1 add
    gl64_t s1_131 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_0)];
    tmp3_3 = tmp3_0 + s1_131; tmp3_4 = tmp3_1; tmp3_5 = tmp3_2;
    // Op 132: dim3x3 add
    gl64_t s1_132_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_132_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_132_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_3 + s1_132_0; tmp3_1 = tmp3_4 + s1_132_1; tmp3_2 = tmp3_5 + s1_132_2;
    // Op 133: dim3x3 mul
    gl64_t kA133 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB133 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC133 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD133 = tmp3_12 * tmp3_0;
    gl64_t kE133 = tmp3_13 * tmp3_1;
    gl64_t kF133 = tmp3_14 * tmp3_2;
    gl64_t kG133 = kD133 - kE133;
    tmp3_0 = (kC133 + kG133) - kF133;
    tmp3_1 = ((((kA133 + kC133) - kE133) - kE133) - kD133);
    tmp3_2 = kB133 - kG133;
    // Op 134: dim3x3 mul
    gl64_t s0_134_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+0, domainSize, nCols_2))];
    gl64_t s0_134_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+1, domainSize, nCols_2))];
    gl64_t s0_134_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+2, domainSize, nCols_2))];
    gl64_t kA134 = (s0_134_0 + s0_134_1) * (tmp3_0 + tmp3_1);
    gl64_t kB134 = (s0_134_0 + s0_134_2) * (tmp3_0 + tmp3_2);
    gl64_t kC134 = (s0_134_1 + s0_134_2) * (tmp3_1 + tmp3_2);
    gl64_t kD134 = s0_134_0 * tmp3_0;
    gl64_t kE134 = s0_134_1 * tmp3_1;
    gl64_t kF134 = s0_134_2 * tmp3_2;
    gl64_t kG134 = kD134 - kE134;
    tmp3_0 = (kC134 + kG134) - kF134;
    tmp3_1 = ((((kA134 + kC134) - kE134) - kE134) - kD134);
    tmp3_2 = kB134 - kG134;
    // Op 135: dim3x3 add
    gl64_t s1_135_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_135_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_135_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_3 + s1_135_0; tmp3_4 = tmp3_4 + s1_135_1; tmp3_5 = tmp3_5 + s1_135_2;
    // Op 136: dim3x1 mul
    gl64_t s1_136 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp3_3 = tmp3_3 * s1_136; tmp3_4 = tmp3_4 * s1_136; tmp3_5 = tmp3_5 * s1_136;
    // Op 137: dim3x3 add
    gl64_t s1_137_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_137_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_137_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_137_0; tmp3_10 = tmp3_10 + s1_137_1; tmp3_11 = tmp3_11 + s1_137_2;
    // Op 138: dim3x1 mul
    gl64_t s1_138 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_138; tmp3_10 = tmp3_10 * s1_138; tmp3_11 = tmp3_11 * s1_138;
    // Op 139: dim3x3 add
    tmp3_3 = tmp3_3 + tmp3_9; tmp3_4 = tmp3_4 + tmp3_10; tmp3_5 = tmp3_5 + tmp3_11;
    // Op 140: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_3; tmp3_1 = tmp3_1 - tmp3_4; tmp3_2 = tmp3_2 - tmp3_5;
    // Op 141: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    tmp3_12 = (kC142 + kG142) - kF142;
    tmp3_13 = ((((kA142 + kC142) - kE142) - kE142) - kD142);
    tmp3_14 = kB142 - kG142;
    // Op 143: dim3x1 mul
    gl64_t s0_143_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_143_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_143_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_143 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 48, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 48, domainSize, nCols_0)];
    tmp3_0 = s0_143_0 * s1_143; tmp3_1 = s0_143_1 * s1_143; tmp3_2 = s0_143_2 * s1_143;
    // Op 144: dim3x1 add
    gl64_t s1_144 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_0)];
    tmp3_9 = tmp3_0 + s1_144; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 145: dim3x3 add
    gl64_t s1_145_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_145_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_145_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_9 + s1_145_0; tmp3_7 = tmp3_10 + s1_145_1; tmp3_8 = tmp3_11 + s1_145_2;
    // Op 146: dim3x1 mul
    gl64_t s0_146_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_146_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_146_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_146 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 49, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 49, domainSize, nCols_0)];
    tmp3_0 = s0_146_0 * s1_146; tmp3_1 = s0_146_1 * s1_146; tmp3_2 = s0_146_2 * s1_146;
    // Op 147: dim3x1 add
    gl64_t s1_147 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_0)];
    tmp3_3 = tmp3_0 + s1_147; tmp3_4 = tmp3_1; tmp3_5 = tmp3_2;
    // Op 148: dim3x3 add
    gl64_t s1_148_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_148_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_148_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_3 + s1_148_0; tmp3_1 = tmp3_4 + s1_148_1; tmp3_2 = tmp3_5 + s1_148_2;
    // Op 149: dim3x3 mul
    gl64_t kA149 = (tmp3_6 + tmp3_7) * (tmp3_0 + tmp3_1);
    gl64_t kB149 = (tmp3_6 + tmp3_8) * (tmp3_0 + tmp3_2);
    gl64_t kC149 = (tmp3_7 + tmp3_8) * (tmp3_1 + tmp3_2);
    gl64_t kD149 = tmp3_6 * tmp3_0;
    gl64_t kE149 = tmp3_7 * tmp3_1;
    gl64_t kF149 = tmp3_8 * tmp3_2;
    gl64_t kG149 = kD149 - kE149;
    tmp3_0 = (kC149 + kG149) - kF149;
    tmp3_1 = ((((kA149 + kC149) - kE149) - kE149) - kD149);
    tmp3_2 = kB149 - kG149;
    // Op 150: dim3x3 mul
    gl64_t s0_150_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 30+0, domainSize, nCols_2))];
    gl64_t s0_150_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 30+1, domainSize, nCols_2))];
    gl64_t s0_150_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 30+2, domainSize, nCols_2))];
    gl64_t kA150 = (s0_150_0 + s0_150_1) * (tmp3_0 + tmp3_1);
    gl64_t kB150 = (s0_150_0 + s0_150_2) * (tmp3_0 + tmp3_2);
    gl64_t kC150 = (s0_150_1 + s0_150_2) * (tmp3_1 + tmp3_2);
    gl64_t kD150 = s0_150_0 * tmp3_0;
    gl64_t kE150 = s0_150_1 * tmp3_1;
    gl64_t kF150 = s0_150_2 * tmp3_2;
    gl64_t kG150 = kD150 - kE150;
    tmp3_0 = (kC150 + kG150) - kF150;
    tmp3_1 = ((((kA150 + kC150) - kE150) - kE150) - kD150);
    tmp3_2 = kB150 - kG150;
    // Op 151: dim3x3 add
    gl64_t s1_151_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_151_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_151_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_3 + s1_151_0; tmp3_4 = tmp3_4 + s1_151_1; tmp3_5 = tmp3_5 + s1_151_2;
    // Op 152: dim3x1 mul
    gl64_t s1_152 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp3_3 = tmp3_3 * s1_152; tmp3_4 = tmp3_4 * s1_152; tmp3_5 = tmp3_5 * s1_152;
    // Op 153: dim3x3 add
    gl64_t s1_153_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_153_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_153_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_153_0; tmp3_10 = tmp3_10 + s1_153_1; tmp3_11 = tmp3_11 + s1_153_2;
    // Op 154: dim3x1 mul
    gl64_t s1_154 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_154; tmp3_10 = tmp3_10 * s1_154; tmp3_11 = tmp3_11 * s1_154;
    // Op 155: dim3x3 add
    tmp3_3 = tmp3_3 + tmp3_9; tmp3_4 = tmp3_4 + tmp3_10; tmp3_5 = tmp3_5 + tmp3_11;
    // Op 156: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_3; tmp3_1 = tmp3_1 - tmp3_4; tmp3_2 = tmp3_2 - tmp3_5;
    // Op 157: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
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
    tmp3_6 = (kC158 + kG158) - kF158;
    tmp3_7 = ((((kA158 + kC158) - kE158) - kE158) - kD158);
    tmp3_8 = kB158 - kG158;
    // Op 159: dim3x1 mul
    gl64_t s0_159_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_159_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_159_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_159 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 50, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 50, domainSize, nCols_0)];
    tmp3_0 = s0_159_0 * s1_159; tmp3_1 = s0_159_1 * s1_159; tmp3_2 = s0_159_2 * s1_159;
    // Op 160: dim3x1 add
    gl64_t s1_160 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_0)];
    tmp3_9 = tmp3_0 + s1_160; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 161: dim3x3 add
    gl64_t s1_161_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_161_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_161_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_161_0; tmp3_13 = tmp3_10 + s1_161_1; tmp3_14 = tmp3_11 + s1_161_2;
    // Op 162: dim3x1 mul
    gl64_t s0_162_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_162_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_162_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_162 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 51, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 51, domainSize, nCols_0)];
    tmp3_0 = s0_162_0 * s1_162; tmp3_1 = s0_162_1 * s1_162; tmp3_2 = s0_162_2 * s1_162;
    // Op 163: dim3x1 add
    gl64_t s1_163 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_0)];
    tmp3_3 = tmp3_0 + s1_163; tmp3_4 = tmp3_1; tmp3_5 = tmp3_2;
    // Op 164: dim3x3 add
    gl64_t s1_164_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_164_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_164_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_3 + s1_164_0; tmp3_1 = tmp3_4 + s1_164_1; tmp3_2 = tmp3_5 + s1_164_2;
    // Op 165: dim3x3 mul
    gl64_t kA165 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB165 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC165 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD165 = tmp3_12 * tmp3_0;
    gl64_t kE165 = tmp3_13 * tmp3_1;
    gl64_t kF165 = tmp3_14 * tmp3_2;
    gl64_t kG165 = kD165 - kE165;
    tmp3_0 = (kC165 + kG165) - kF165;
    tmp3_1 = ((((kA165 + kC165) - kE165) - kE165) - kD165);
    tmp3_2 = kB165 - kG165;
    // Op 166: dim3x3 mul
    uint64_t s0_166_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_2));
    gl64_t s0_166_0 = *(gl64_t*)&dParams->aux_trace[s0_166_pos];
    gl64_t s0_166_1 = *(gl64_t*)&dParams->aux_trace[s0_166_pos + TILE_HEIGHT];
    gl64_t s0_166_2 = *(gl64_t*)&dParams->aux_trace[s0_166_pos + 2*TILE_HEIGHT];
    gl64_t kA166 = (s0_166_0 + s0_166_1) * (tmp3_0 + tmp3_1);
    gl64_t kB166 = (s0_166_0 + s0_166_2) * (tmp3_0 + tmp3_2);
    gl64_t kC166 = (s0_166_1 + s0_166_2) * (tmp3_1 + tmp3_2);
    gl64_t kD166 = s0_166_0 * tmp3_0;
    gl64_t kE166 = s0_166_1 * tmp3_1;
    gl64_t kF166 = s0_166_2 * tmp3_2;
    gl64_t kG166 = kD166 - kE166;
    tmp3_0 = (kC166 + kG166) - kF166;
    tmp3_1 = ((((kA166 + kC166) - kE166) - kE166) - kD166);
    tmp3_2 = kB166 - kG166;
    // Op 167: dim3x3 add
    gl64_t s1_167_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_167_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_167_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_3 + s1_167_0; tmp3_4 = tmp3_4 + s1_167_1; tmp3_5 = tmp3_5 + s1_167_2;
    // Op 168: dim3x1 mul
    gl64_t s1_168 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp3_3 = tmp3_3 * s1_168; tmp3_4 = tmp3_4 * s1_168; tmp3_5 = tmp3_5 * s1_168;
    // Op 169: dim3x3 add
    gl64_t s1_169_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_169_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_169_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_169_0; tmp3_10 = tmp3_10 + s1_169_1; tmp3_11 = tmp3_11 + s1_169_2;
    // Op 170: dim3x1 mul
    gl64_t s1_170 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_170; tmp3_10 = tmp3_10 * s1_170; tmp3_11 = tmp3_11 * s1_170;
    // Op 171: dim3x3 add
    tmp3_3 = tmp3_3 + tmp3_9; tmp3_4 = tmp3_4 + tmp3_10; tmp3_5 = tmp3_5 + tmp3_11;
    // Op 172: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_3; tmp3_1 = tmp3_1 - tmp3_4; tmp3_2 = tmp3_2 - tmp3_5;
    // Op 173: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    tmp3_12 = (kC174 + kG174) - kF174;
    tmp3_13 = ((((kA174 + kC174) - kE174) - kE174) - kD174);
    tmp3_14 = kB174 - kG174;
    // Op 175: dim3x1 mul
    gl64_t s0_175_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_175_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_175_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_175 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 52, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 52, domainSize, nCols_0)];
    tmp3_0 = s0_175_0 * s1_175; tmp3_1 = s0_175_1 * s1_175; tmp3_2 = s0_175_2 * s1_175;
    // Op 176: dim3x1 add
    gl64_t s1_176 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_0)];
    tmp3_9 = tmp3_0 + s1_176; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 177: dim3x3 add
    gl64_t s1_177_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_177_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_177_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_9 + s1_177_0; tmp3_7 = tmp3_10 + s1_177_1; tmp3_8 = tmp3_11 + s1_177_2;
    // Op 178: dim3x1 mul
    gl64_t s0_178_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_178_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_178_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_178 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 53, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 53, domainSize, nCols_0)];
    tmp3_0 = s0_178_0 * s1_178; tmp3_1 = s0_178_1 * s1_178; tmp3_2 = s0_178_2 * s1_178;
    // Op 179: dim3x1 add
    gl64_t s1_179 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_0)];
    tmp3_3 = tmp3_0 + s1_179; tmp3_4 = tmp3_1; tmp3_5 = tmp3_2;
    // Op 180: dim3x3 add
    gl64_t s1_180_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_180_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_180_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_3 + s1_180_0; tmp3_1 = tmp3_4 + s1_180_1; tmp3_2 = tmp3_5 + s1_180_2;
    // Op 181: dim3x3 mul
    gl64_t kA181 = (tmp3_6 + tmp3_7) * (tmp3_0 + tmp3_1);
    gl64_t kB181 = (tmp3_6 + tmp3_8) * (tmp3_0 + tmp3_2);
    gl64_t kC181 = (tmp3_7 + tmp3_8) * (tmp3_1 + tmp3_2);
    gl64_t kD181 = tmp3_6 * tmp3_0;
    gl64_t kE181 = tmp3_7 * tmp3_1;
    gl64_t kF181 = tmp3_8 * tmp3_2;
    gl64_t kG181 = kD181 - kE181;
    tmp3_0 = (kC181 + kG181) - kF181;
    tmp3_1 = ((((kA181 + kC181) - kE181) - kE181) - kD181);
    tmp3_2 = kB181 - kG181;
    // Op 182: dim3x3 mul
    uint64_t s0_182_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_2));
    gl64_t s0_182_0 = *(gl64_t*)&dParams->aux_trace[s0_182_pos];
    gl64_t s0_182_1 = *(gl64_t*)&dParams->aux_trace[s0_182_pos + TILE_HEIGHT];
    gl64_t s0_182_2 = *(gl64_t*)&dParams->aux_trace[s0_182_pos + 2*TILE_HEIGHT];
    gl64_t kA182 = (s0_182_0 + s0_182_1) * (tmp3_0 + tmp3_1);
    gl64_t kB182 = (s0_182_0 + s0_182_2) * (tmp3_0 + tmp3_2);
    gl64_t kC182 = (s0_182_1 + s0_182_2) * (tmp3_1 + tmp3_2);
    gl64_t kD182 = s0_182_0 * tmp3_0;
    gl64_t kE182 = s0_182_1 * tmp3_1;
    gl64_t kF182 = s0_182_2 * tmp3_2;
    gl64_t kG182 = kD182 - kE182;
    tmp3_0 = (kC182 + kG182) - kF182;
    tmp3_1 = ((((kA182 + kC182) - kE182) - kE182) - kD182);
    tmp3_2 = kB182 - kG182;
    // Op 183: dim3x3 add
    gl64_t s1_183_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_183_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_183_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_3 + s1_183_0; tmp3_4 = tmp3_4 + s1_183_1; tmp3_5 = tmp3_5 + s1_183_2;
    // Op 184: dim3x1 mul
    gl64_t s1_184 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp3_3 = tmp3_3 * s1_184; tmp3_4 = tmp3_4 * s1_184; tmp3_5 = tmp3_5 * s1_184;
    // Op 185: dim3x3 add
    gl64_t s1_185_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_185_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_185_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_185_0; tmp3_10 = tmp3_10 + s1_185_1; tmp3_11 = tmp3_11 + s1_185_2;
    // Op 186: dim3x1 mul
    gl64_t s1_186 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_186; tmp3_10 = tmp3_10 * s1_186; tmp3_11 = tmp3_11 * s1_186;
    // Op 187: dim3x3 add
    tmp3_3 = tmp3_3 + tmp3_9; tmp3_4 = tmp3_4 + tmp3_10; tmp3_5 = tmp3_5 + tmp3_11;
    // Op 188: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_3; tmp3_1 = tmp3_1 - tmp3_4; tmp3_2 = tmp3_2 - tmp3_5;
    // Op 189: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
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
    tmp3_6 = (kC190 + kG190) - kF190;
    tmp3_7 = ((((kA190 + kC190) - kE190) - kE190) - kD190);
    tmp3_8 = kB190 - kG190;
    // Op 191: dim3x1 mul
    gl64_t s0_191_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_191_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_191_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_191 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 54, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 54, domainSize, nCols_0)];
    tmp3_0 = s0_191_0 * s1_191; tmp3_1 = s0_191_1 * s1_191; tmp3_2 = s0_191_2 * s1_191;
    // Op 192: dim3x1 add
    gl64_t s1_192 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_0)];
    tmp3_9 = tmp3_0 + s1_192; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 193: dim3x3 add
    gl64_t s1_193_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_193_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_193_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_193_0; tmp3_13 = tmp3_10 + s1_193_1; tmp3_14 = tmp3_11 + s1_193_2;
    // Op 194: dim3x1 mul
    gl64_t s0_194_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_194_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_194_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_194 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 55, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 55, domainSize, nCols_0)];
    tmp3_0 = s0_194_0 * s1_194; tmp3_1 = s0_194_1 * s1_194; tmp3_2 = s0_194_2 * s1_194;
    // Op 195: dim3x1 add
    gl64_t s1_195 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_0)];
    tmp3_3 = tmp3_0 + s1_195; tmp3_4 = tmp3_1; tmp3_5 = tmp3_2;
    // Op 196: dim3x3 add
    gl64_t s1_196_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_196_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_196_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_3 + s1_196_0; tmp3_1 = tmp3_4 + s1_196_1; tmp3_2 = tmp3_5 + s1_196_2;
    // Op 197: dim3x3 mul
    gl64_t kA197 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB197 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC197 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD197 = tmp3_12 * tmp3_0;
    gl64_t kE197 = tmp3_13 * tmp3_1;
    gl64_t kF197 = tmp3_14 * tmp3_2;
    gl64_t kG197 = kD197 - kE197;
    tmp3_0 = (kC197 + kG197) - kF197;
    tmp3_1 = ((((kA197 + kC197) - kE197) - kE197) - kD197);
    tmp3_2 = kB197 - kG197;
    // Op 198: dim3x3 mul
    gl64_t s0_198_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 39+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 39+0, domainSize, nCols_2))];
    gl64_t s0_198_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 39+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 39+1, domainSize, nCols_2))];
    gl64_t s0_198_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 39+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 39+2, domainSize, nCols_2))];
    gl64_t kA198 = (s0_198_0 + s0_198_1) * (tmp3_0 + tmp3_1);
    gl64_t kB198 = (s0_198_0 + s0_198_2) * (tmp3_0 + tmp3_2);
    gl64_t kC198 = (s0_198_1 + s0_198_2) * (tmp3_1 + tmp3_2);
    gl64_t kD198 = s0_198_0 * tmp3_0;
    gl64_t kE198 = s0_198_1 * tmp3_1;
    gl64_t kF198 = s0_198_2 * tmp3_2;
    gl64_t kG198 = kD198 - kE198;
    tmp3_0 = (kC198 + kG198) - kF198;
    tmp3_1 = ((((kA198 + kC198) - kE198) - kE198) - kD198);
    tmp3_2 = kB198 - kG198;
    // Op 199: dim3x3 add
    gl64_t s1_199_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_199_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_199_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_3 + s1_199_0; tmp3_4 = tmp3_4 + s1_199_1; tmp3_5 = tmp3_5 + s1_199_2;
    // Op 200: dim3x1 mul
    gl64_t s1_200 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp3_3 = tmp3_3 * s1_200; tmp3_4 = tmp3_4 * s1_200; tmp3_5 = tmp3_5 * s1_200;
    // Op 201: dim3x3 add
    gl64_t s1_201_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_201_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_201_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_201_0; tmp3_10 = tmp3_10 + s1_201_1; tmp3_11 = tmp3_11 + s1_201_2;
    // Op 202: dim3x1 mul
    gl64_t s1_202 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_202; tmp3_10 = tmp3_10 * s1_202; tmp3_11 = tmp3_11 * s1_202;
    // Op 203: dim3x3 add
    tmp3_3 = tmp3_3 + tmp3_9; tmp3_4 = tmp3_4 + tmp3_10; tmp3_5 = tmp3_5 + tmp3_11;
    // Op 204: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_3; tmp3_1 = tmp3_1 - tmp3_4; tmp3_2 = tmp3_2 - tmp3_5;
    // Op 205: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    gl64_t s1_207 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 56, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 56, domainSize, nCols_0)];
    tmp3_0 = s0_207_0 * s1_207; tmp3_1 = s0_207_1 * s1_207; tmp3_2 = s0_207_2 * s1_207;
    // Op 208: dim3x1 add
    gl64_t s1_208 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_0)];
    tmp3_9 = tmp3_0 + s1_208; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 209: dim3x3 add
    gl64_t s1_209_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_209_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_209_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_9 + s1_209_0; tmp3_7 = tmp3_10 + s1_209_1; tmp3_8 = tmp3_11 + s1_209_2;
    // Op 210: dim3x1 mul
    gl64_t s0_210_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_210_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_210_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_210 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 57, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 57, domainSize, nCols_0)];
    tmp3_0 = s0_210_0 * s1_210; tmp3_1 = s0_210_1 * s1_210; tmp3_2 = s0_210_2 * s1_210;
    // Op 211: dim3x1 add
    gl64_t s1_211 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_0)];
    tmp3_3 = tmp3_0 + s1_211; tmp3_4 = tmp3_1; tmp3_5 = tmp3_2;
    // Op 212: dim3x3 add
    gl64_t s1_212_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_212_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_212_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_3 + s1_212_0; tmp3_1 = tmp3_4 + s1_212_1; tmp3_2 = tmp3_5 + s1_212_2;
    // Op 213: dim3x3 mul
    gl64_t kA213 = (tmp3_6 + tmp3_7) * (tmp3_0 + tmp3_1);
    gl64_t kB213 = (tmp3_6 + tmp3_8) * (tmp3_0 + tmp3_2);
    gl64_t kC213 = (tmp3_7 + tmp3_8) * (tmp3_1 + tmp3_2);
    gl64_t kD213 = tmp3_6 * tmp3_0;
    gl64_t kE213 = tmp3_7 * tmp3_1;
    gl64_t kF213 = tmp3_8 * tmp3_2;
    gl64_t kG213 = kD213 - kE213;
    tmp3_0 = (kC213 + kG213) - kF213;
    tmp3_1 = ((((kA213 + kC213) - kE213) - kE213) - kD213);
    tmp3_2 = kB213 - kG213;
    // Op 214: dim3x3 mul
    gl64_t s0_214_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 42+0, domainSize, nCols_2))];
    gl64_t s0_214_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 42+1, domainSize, nCols_2))];
    gl64_t s0_214_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 42+2, domainSize, nCols_2))];
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
    // Op 215: dim3x3 add
    gl64_t s1_215_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_215_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_215_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_3 + s1_215_0; tmp3_4 = tmp3_4 + s1_215_1; tmp3_5 = tmp3_5 + s1_215_2;
    // Op 216: dim3x1 mul
    gl64_t s1_216 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp3_3 = tmp3_3 * s1_216; tmp3_4 = tmp3_4 * s1_216; tmp3_5 = tmp3_5 * s1_216;
    // Op 217: dim3x3 add
    gl64_t s1_217_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_217_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_217_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_217_0; tmp3_10 = tmp3_10 + s1_217_1; tmp3_11 = tmp3_11 + s1_217_2;
    // Op 218: dim3x1 mul
    gl64_t s1_218 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_218; tmp3_10 = tmp3_10 * s1_218; tmp3_11 = tmp3_11 * s1_218;
    // Op 219: dim3x3 add
    tmp3_3 = tmp3_3 + tmp3_9; tmp3_4 = tmp3_4 + tmp3_10; tmp3_5 = tmp3_5 + tmp3_11;
    // Op 220: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_3; tmp3_1 = tmp3_1 - tmp3_4; tmp3_2 = tmp3_2 - tmp3_5;
    // Op 221: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 222: dim3x3 mul
    gl64_t s1_222_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_222_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_222_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA222 = (tmp3_0 + tmp3_1) * (s1_222_0 + s1_222_1);
    gl64_t kB222 = (tmp3_0 + tmp3_2) * (s1_222_0 + s1_222_2);
    gl64_t kC222 = (tmp3_1 + tmp3_2) * (s1_222_1 + s1_222_2);
    gl64_t kD222 = tmp3_0 * s1_222_0;
    gl64_t kE222 = tmp3_1 * s1_222_1;
    gl64_t kF222 = tmp3_2 * s1_222_2;
    gl64_t kG222 = kD222 - kE222;
    tmp3_3 = (kC222 + kG222) - kF222;
    tmp3_4 = ((((kA222 + kC222) - kE222) - kE222) - kD222);
    tmp3_5 = kB222 - kG222;
    // Op 223: dim1x1 sub_swap
    gl64_t s0_223 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 58, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 58, domainSize, nCols_0)];
    gl64_t s1_223 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_223 - s0_223;
    // Op 224: dim3x1 mul
    uint64_t s0_224_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_224_0 = *(gl64_t*)&dParams->aux_trace[s0_224_pos];
    gl64_t s0_224_1 = *(gl64_t*)&dParams->aux_trace[s0_224_pos + TILE_HEIGHT];
    gl64_t s0_224_2 = *(gl64_t*)&dParams->aux_trace[s0_224_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_224_0 * tmp1_0; tmp3_1 = s0_224_1 * tmp1_0; tmp3_2 = s0_224_2 * tmp1_0;
    // Op 225: dim3x3 sub
    uint64_t s0_225_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_225_0 = *(gl64_t*)&dParams->aux_trace[s0_225_pos];
    gl64_t s0_225_1 = *(gl64_t*)&dParams->aux_trace[s0_225_pos + TILE_HEIGHT];
    gl64_t s0_225_2 = *(gl64_t*)&dParams->aux_trace[s0_225_pos + 2*TILE_HEIGHT];
    tmp3_12 = s0_225_0 - tmp3_0; tmp3_13 = s0_225_1 - tmp3_1; tmp3_14 = s0_225_2 - tmp3_2;
    // Op 226: dim3x3 add
    gl64_t s0_226_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_226_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_226_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_226_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_226_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_226_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_0 = s0_226_0 + s1_226_0; tmp3_1 = s0_226_1 + s1_226_1; tmp3_2 = s0_226_2 + s1_226_2;
    // Op 227: dim3x3 add
    uint64_t s0_227_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_227_0 = *(gl64_t*)&dParams->aux_trace[s0_227_pos];
    gl64_t s0_227_1 = *(gl64_t*)&dParams->aux_trace[s0_227_pos + TILE_HEIGHT];
    gl64_t s0_227_2 = *(gl64_t*)&dParams->aux_trace[s0_227_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_227_0 + tmp3_0; tmp3_1 = s0_227_1 + tmp3_1; tmp3_2 = s0_227_2 + tmp3_2;
    // Op 228: dim3x3 add
    uint64_t s0_228_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_228_0 = *(gl64_t*)&dParams->aux_trace[s0_228_pos];
    gl64_t s0_228_1 = *(gl64_t*)&dParams->aux_trace[s0_228_pos + TILE_HEIGHT];
    gl64_t s0_228_2 = *(gl64_t*)&dParams->aux_trace[s0_228_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_228_0 + tmp3_0; tmp3_1 = s0_228_1 + tmp3_1; tmp3_2 = s0_228_2 + tmp3_2;
    // Op 229: dim3x3 add
    gl64_t s0_229_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_229_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_229_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    tmp3_0 = s0_229_0 + tmp3_0; tmp3_1 = s0_229_1 + tmp3_1; tmp3_2 = s0_229_2 + tmp3_2;
    // Op 230: dim3x3 add
    gl64_t s0_230_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+0, domainSize, nCols_2))];
    gl64_t s0_230_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+1, domainSize, nCols_2))];
    gl64_t s0_230_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+2, domainSize, nCols_2))];
    tmp3_0 = s0_230_0 + tmp3_0; tmp3_1 = s0_230_1 + tmp3_1; tmp3_2 = s0_230_2 + tmp3_2;
    // Op 231: dim3x3 add
    uint64_t s0_231_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_2));
    gl64_t s0_231_0 = *(gl64_t*)&dParams->aux_trace[s0_231_pos];
    gl64_t s0_231_1 = *(gl64_t*)&dParams->aux_trace[s0_231_pos + TILE_HEIGHT];
    gl64_t s0_231_2 = *(gl64_t*)&dParams->aux_trace[s0_231_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_231_0 + tmp3_0; tmp3_1 = s0_231_1 + tmp3_1; tmp3_2 = s0_231_2 + tmp3_2;
    // Op 232: dim3x3 add
    uint64_t s0_232_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_2));
    gl64_t s0_232_0 = *(gl64_t*)&dParams->aux_trace[s0_232_pos];
    gl64_t s0_232_1 = *(gl64_t*)&dParams->aux_trace[s0_232_pos + TILE_HEIGHT];
    gl64_t s0_232_2 = *(gl64_t*)&dParams->aux_trace[s0_232_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_232_0 + tmp3_0; tmp3_1 = s0_232_1 + tmp3_1; tmp3_2 = s0_232_2 + tmp3_2;
    // Op 233: dim3x3 add
    gl64_t s0_233_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+0, domainSize, nCols_2))];
    gl64_t s0_233_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+1, domainSize, nCols_2))];
    gl64_t s0_233_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+2, domainSize, nCols_2))];
    tmp3_0 = s0_233_0 + tmp3_0; tmp3_1 = s0_233_1 + tmp3_1; tmp3_2 = s0_233_2 + tmp3_2;
    // Op 234: dim3x3 add
    gl64_t s0_234_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 30+0, domainSize, nCols_2))];
    gl64_t s0_234_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 30+1, domainSize, nCols_2))];
    gl64_t s0_234_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 30+2, domainSize, nCols_2))];
    tmp3_0 = s0_234_0 + tmp3_0; tmp3_1 = s0_234_1 + tmp3_1; tmp3_2 = s0_234_2 + tmp3_2;
    // Op 235: dim3x3 add
    uint64_t s0_235_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_2));
    gl64_t s0_235_0 = *(gl64_t*)&dParams->aux_trace[s0_235_pos];
    gl64_t s0_235_1 = *(gl64_t*)&dParams->aux_trace[s0_235_pos + TILE_HEIGHT];
    gl64_t s0_235_2 = *(gl64_t*)&dParams->aux_trace[s0_235_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_235_0 + tmp3_0; tmp3_1 = s0_235_1 + tmp3_1; tmp3_2 = s0_235_2 + tmp3_2;
    // Op 236: dim3x3 add
    uint64_t s0_236_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_2));
    gl64_t s0_236_0 = *(gl64_t*)&dParams->aux_trace[s0_236_pos];
    gl64_t s0_236_1 = *(gl64_t*)&dParams->aux_trace[s0_236_pos + TILE_HEIGHT];
    gl64_t s0_236_2 = *(gl64_t*)&dParams->aux_trace[s0_236_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_236_0 + tmp3_0; tmp3_1 = s0_236_1 + tmp3_1; tmp3_2 = s0_236_2 + tmp3_2;
    // Op 237: dim3x3 add
    gl64_t s0_237_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 39+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 39+0, domainSize, nCols_2))];
    gl64_t s0_237_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 39+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 39+1, domainSize, nCols_2))];
    gl64_t s0_237_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 39+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 39+2, domainSize, nCols_2))];
    tmp3_0 = s0_237_0 + tmp3_0; tmp3_1 = s0_237_1 + tmp3_1; tmp3_2 = s0_237_2 + tmp3_2;
    // Op 238: dim3x3 add
    gl64_t s0_238_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 42+0, domainSize, nCols_2))];
    gl64_t s0_238_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 42+1, domainSize, nCols_2))];
    gl64_t s0_238_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 42+2, domainSize, nCols_2))];
    tmp3_0 = s0_238_0 + tmp3_0; tmp3_1 = s0_238_1 + tmp3_1; tmp3_2 = s0_238_2 + tmp3_2;
    // Op 239: dim3x3 sub
    tmp3_12 = tmp3_12 - tmp3_0; tmp3_13 = tmp3_13 - tmp3_1; tmp3_14 = tmp3_14 - tmp3_2;
    // Op 240: dim3x1 mul
    gl64_t s0_240_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_240_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_240_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_240 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_0)];
    tmp3_0 = s0_240_0 * s1_240; tmp3_1 = s0_240_1 * s1_240; tmp3_2 = s0_240_2 * s1_240;
    // Op 241: dim3x1 add
    gl64_t s1_241 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_241; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 242: dim3x3 add
    gl64_t s1_242_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_242_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_242_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_242_0; tmp3_1 = tmp3_1 + s1_242_1; tmp3_2 = tmp3_2 + s1_242_2;
    // Op 243: dim3x3 mul
    gl64_t kA243 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB243 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC243 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD243 = tmp3_12 * tmp3_0;
    gl64_t kE243 = tmp3_13 * tmp3_1;
    gl64_t kF243 = tmp3_14 * tmp3_2;
    gl64_t kG243 = kD243 - kE243;
    tmp3_0 = (kC243 + kG243) - kF243;
    tmp3_1 = ((((kA243 + kC243) - kE243) - kE243) - kD243);
    tmp3_2 = kB243 - kG243;
    // Op 244: dim3x1 sub
    gl64_t s1_244 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 - s1_244; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_3 = (kC246 + kG246) - kF246;
    tmp3_4 = ((((kA246 + kC246) - kE246) - kE246) - kD246);
    tmp3_5 = kB246 - kG246;
    // Op 247: dim3x3 sub_swap
    uint64_t s0_247_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_247_0 = *(gl64_t*)&dParams->aux_trace[s0_247_pos];
    gl64_t s0_247_1 = *(gl64_t*)&dParams->aux_trace[s0_247_pos + TILE_HEIGHT];
    gl64_t s0_247_2 = *(gl64_t*)&dParams->aux_trace[s0_247_pos + 2*TILE_HEIGHT];
    gl64_t s1_247_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_247_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_247_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_0 = s1_247_0 - s0_247_0; tmp3_1 = s1_247_1 - s0_247_1; tmp3_2 = s1_247_2 - s0_247_2;
    // Op 248: dim3x1 mul
    gl64_t s1_248 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 58, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 58, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_248; tmp3_1 = tmp3_1 * s1_248; tmp3_2 = tmp3_2 * s1_248;
    // Op 249: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 250: dim3x1 mul
    gl64_t s1_250 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_250; tmp3_1 = tmp3_1 * s1_250; tmp3_2 = tmp3_2 * s1_250;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
