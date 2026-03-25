// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: 22e7bf00  nOps=142 nTemp1=1 nTemp3=5
#define GENERATED_EVAL_NOPS_22e7bf00 142
#define GENERATED_EVAL_NTEMP1_22e7bf00 1
#define GENERATED_EVAL_NTEMP3_22e7bf00 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_22e7bf00(
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
    gl64_t s1_0 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_0)];
    tmp3_0 = s0_0_0 * s1_0; tmp3_1 = s0_0_1 * s1_0; tmp3_2 = s0_0_2 * s1_0;
    // Op 1: dim3x1 add
    gl64_t s1_1 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2: dim3x3 mul
    gl64_t s1_2_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_2_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_2_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA2 = (tmp3_0 + tmp3_1) * (s1_2_0 + s1_2_1);
    gl64_t kB2 = (tmp3_0 + tmp3_2) * (s1_2_0 + s1_2_2);
    gl64_t kC2 = (tmp3_1 + tmp3_2) * (s1_2_1 + s1_2_2);
    gl64_t kD2 = tmp3_0 * s1_2_0;
    gl64_t kE2 = tmp3_1 * s1_2_1;
    gl64_t kF2 = tmp3_2 * s1_2_2;
    gl64_t kG2 = kD2 - kE2;
    tmp3_0 = (kC2 + kG2) - kF2;
    tmp3_1 = ((((kA2 + kC2) - kE2) - kE2) - kD2);
    tmp3_2 = kB2 - kG2;
    // Op 3: dim3x1 add
    gl64_t s1_3 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_0)];
    tmp3_9 = tmp3_0 + s1_3; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 4: dim3x3 add
    gl64_t s1_4_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_4_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_4_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_4_0; tmp3_4 = tmp3_10 + s1_4_1; tmp3_5 = tmp3_11 + s1_4_2;
    // Op 5: dim3x1 mul
    gl64_t s0_5_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_5_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_5_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_5 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_0)];
    tmp3_0 = s0_5_0 * s1_5; tmp3_1 = s0_5_1 * s1_5; tmp3_2 = s0_5_2 * s1_5;
    // Op 6: dim3x1 add
    gl64_t s1_6 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_6; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 7: dim3x3 mul
    gl64_t s1_7_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_7_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_7_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA7 = (tmp3_0 + tmp3_1) * (s1_7_0 + s1_7_1);
    gl64_t kB7 = (tmp3_0 + tmp3_2) * (s1_7_0 + s1_7_2);
    gl64_t kC7 = (tmp3_1 + tmp3_2) * (s1_7_1 + s1_7_2);
    gl64_t kD7 = tmp3_0 * s1_7_0;
    gl64_t kE7 = tmp3_1 * s1_7_1;
    gl64_t kF7 = tmp3_2 * s1_7_2;
    gl64_t kG7 = kD7 - kE7;
    tmp3_0 = (kC7 + kG7) - kF7;
    tmp3_1 = ((((kA7 + kC7) - kE7) - kE7) - kD7);
    tmp3_2 = kB7 - kG7;
    // Op 8: dim3x1 add
    gl64_t s1_8 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_8; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 9: dim3x3 mul
    gl64_t s1_9_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_9_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_9_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA9 = (tmp3_0 + tmp3_1) * (s1_9_0 + s1_9_1);
    gl64_t kB9 = (tmp3_0 + tmp3_2) * (s1_9_0 + s1_9_2);
    gl64_t kC9 = (tmp3_1 + tmp3_2) * (s1_9_1 + s1_9_2);
    gl64_t kD9 = tmp3_0 * s1_9_0;
    gl64_t kE9 = tmp3_1 * s1_9_1;
    gl64_t kF9 = tmp3_2 * s1_9_2;
    gl64_t kG9 = kD9 - kE9;
    tmp3_0 = (kC9 + kG9) - kF9;
    tmp3_1 = ((((kA9 + kC9) - kE9) - kE9) - kD9);
    tmp3_2 = kB9 - kG9;
    // Op 10: dim3x1 add
    gl64_t s1_10 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_10; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 11: dim3x3 mul
    gl64_t s1_11_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_11_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_11_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA11 = (tmp3_0 + tmp3_1) * (s1_11_0 + s1_11_1);
    gl64_t kB11 = (tmp3_0 + tmp3_2) * (s1_11_0 + s1_11_2);
    gl64_t kC11 = (tmp3_1 + tmp3_2) * (s1_11_1 + s1_11_2);
    gl64_t kD11 = tmp3_0 * s1_11_0;
    gl64_t kE11 = tmp3_1 * s1_11_1;
    gl64_t kF11 = tmp3_2 * s1_11_2;
    gl64_t kG11 = kD11 - kE11;
    tmp3_0 = (kC11 + kG11) - kF11;
    tmp3_1 = ((((kA11 + kC11) - kE11) - kE11) - kD11);
    tmp3_2 = kB11 - kG11;
    // Op 12: dim3x1 add
    gl64_t s1_12 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_0)];
    tmp3_6 = tmp3_0 + s1_12; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 13: dim3x3 add
    gl64_t s1_13_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_13_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_13_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_13_0; tmp3_1 = tmp3_7 + s1_13_1; tmp3_2 = tmp3_8 + s1_13_2;
    // Op 14: dim3x3 mul
    gl64_t kA14 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB14 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC14 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD14 = tmp3_3 * tmp3_0;
    gl64_t kE14 = tmp3_4 * tmp3_1;
    gl64_t kF14 = tmp3_5 * tmp3_2;
    gl64_t kG14 = kD14 - kE14;
    tmp3_0 = (kC14 + kG14) - kF14;
    tmp3_1 = ((((kA14 + kC14) - kE14) - kE14) - kD14);
    tmp3_2 = kB14 - kG14;
    // Op 15: dim3x3 mul
    gl64_t s0_15_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_15_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_15_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA15 = (s0_15_0 + s0_15_1) * (tmp3_0 + tmp3_1);
    gl64_t kB15 = (s0_15_0 + s0_15_2) * (tmp3_0 + tmp3_2);
    gl64_t kC15 = (s0_15_1 + s0_15_2) * (tmp3_1 + tmp3_2);
    gl64_t kD15 = s0_15_0 * tmp3_0;
    gl64_t kE15 = s0_15_1 * tmp3_1;
    gl64_t kF15 = s0_15_2 * tmp3_2;
    gl64_t kG15 = kD15 - kE15;
    tmp3_0 = (kC15 + kG15) - kF15;
    tmp3_1 = ((((kA15 + kC15) - kE15) - kE15) - kD15);
    tmp3_2 = kB15 - kG15;
    // Op 16: dim3x3 add
    gl64_t s1_16_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_16_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_16_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_16_0; tmp3_7 = tmp3_7 + s1_16_1; tmp3_8 = tmp3_8 + s1_16_2;
    // Op 17: dim3x1 mul
    gl64_t s1_17 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp3_6 = tmp3_6 * s1_17; tmp3_7 = tmp3_7 * s1_17; tmp3_8 = tmp3_8 * s1_17;
    // Op 18: dim3x3 add
    gl64_t s1_18_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_18_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_18_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_18_0; tmp3_10 = tmp3_10 + s1_18_1; tmp3_11 = tmp3_11 + s1_18_2;
    // Op 19: dim3x1 mul
    gl64_t s1_19 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_19; tmp3_10 = tmp3_10 * s1_19; tmp3_11 = tmp3_11 * s1_19;
    // Op 20: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 21: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 22: dim3x3 mul
    gl64_t s1_22_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_22_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_22_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA22 = (tmp3_0 + tmp3_1) * (s1_22_0 + s1_22_1);
    gl64_t kB22 = (tmp3_0 + tmp3_2) * (s1_22_0 + s1_22_2);
    gl64_t kC22 = (tmp3_1 + tmp3_2) * (s1_22_1 + s1_22_2);
    gl64_t kD22 = tmp3_0 * s1_22_0;
    gl64_t kE22 = tmp3_1 * s1_22_1;
    gl64_t kF22 = tmp3_2 * s1_22_2;
    gl64_t kG22 = kD22 - kE22;
    tmp3_12 = (kC22 + kG22) - kF22;
    tmp3_13 = ((((kA22 + kC22) - kE22) - kE22) - kD22);
    tmp3_14 = kB22 - kG22;
    // Op 23: dim3x1 mul
    gl64_t s0_23_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_23_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_23_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_23 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_0)];
    tmp3_0 = s0_23_0 * s1_23; tmp3_1 = s0_23_1 * s1_23; tmp3_2 = s0_23_2 * s1_23;
    // Op 24: dim3x1 add
    gl64_t s1_24 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_24; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 25: dim3x3 mul
    gl64_t s1_25_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_25_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_25_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 26: dim3x1 add
    gl64_t s1_26 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_26; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 27: dim3x3 mul
    gl64_t s1_27_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_27_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_27_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA27 = (tmp3_0 + tmp3_1) * (s1_27_0 + s1_27_1);
    gl64_t kB27 = (tmp3_0 + tmp3_2) * (s1_27_0 + s1_27_2);
    gl64_t kC27 = (tmp3_1 + tmp3_2) * (s1_27_1 + s1_27_2);
    gl64_t kD27 = tmp3_0 * s1_27_0;
    gl64_t kE27 = tmp3_1 * s1_27_1;
    gl64_t kF27 = tmp3_2 * s1_27_2;
    gl64_t kG27 = kD27 - kE27;
    tmp3_0 = (kC27 + kG27) - kF27;
    tmp3_1 = ((((kA27 + kC27) - kE27) - kE27) - kD27);
    tmp3_2 = kB27 - kG27;
    // Op 28: dim3x1 add
    gl64_t s1_28 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_28; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 29: dim3x3 mul
    gl64_t s1_29_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_29_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_29_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 30: dim3x1 add
    gl64_t s1_30 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_30; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 31: dim3x3 mul
    gl64_t s1_31_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_31_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_31_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 32: dim3x1 add
    gl64_t s1_32 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_32; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 33: dim3x3 mul
    gl64_t s1_33_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_33_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_33_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA33 = (tmp3_0 + tmp3_1) * (s1_33_0 + s1_33_1);
    gl64_t kB33 = (tmp3_0 + tmp3_2) * (s1_33_0 + s1_33_2);
    gl64_t kC33 = (tmp3_1 + tmp3_2) * (s1_33_1 + s1_33_2);
    gl64_t kD33 = tmp3_0 * s1_33_0;
    gl64_t kE33 = tmp3_1 * s1_33_1;
    gl64_t kF33 = tmp3_2 * s1_33_2;
    gl64_t kG33 = kD33 - kE33;
    tmp3_0 = (kC33 + kG33) - kF33;
    tmp3_1 = ((((kA33 + kC33) - kE33) - kE33) - kD33);
    tmp3_2 = kB33 - kG33;
    // Op 34: dim3x1 add
    gl64_t s1_34 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_34; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 35: dim3x3 mul
    gl64_t s1_35_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_35_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_35_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA35 = (tmp3_0 + tmp3_1) * (s1_35_0 + s1_35_1);
    gl64_t kB35 = (tmp3_0 + tmp3_2) * (s1_35_0 + s1_35_2);
    gl64_t kC35 = (tmp3_1 + tmp3_2) * (s1_35_1 + s1_35_2);
    gl64_t kD35 = tmp3_0 * s1_35_0;
    gl64_t kE35 = tmp3_1 * s1_35_1;
    gl64_t kF35 = tmp3_2 * s1_35_2;
    gl64_t kG35 = kD35 - kE35;
    tmp3_0 = (kC35 + kG35) - kF35;
    tmp3_1 = ((((kA35 + kC35) - kE35) - kE35) - kD35);
    tmp3_2 = kB35 - kG35;
    // Op 36: dim3x1 add
    gl64_t s1_36 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_0)];
    tmp3_3 = tmp3_0 + s1_36; tmp3_4 = tmp3_1; tmp3_5 = tmp3_2;
    // Op 37: dim3x3 add
    gl64_t s1_37_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_37_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_37_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_3 + s1_37_0; tmp3_7 = tmp3_4 + s1_37_1; tmp3_8 = tmp3_5 + s1_37_2;
    // Op 38: dim3x1 mul
    gl64_t s0_38_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_38_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_38_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_38 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_0)];
    tmp3_0 = s0_38_0 * s1_38; tmp3_1 = s0_38_1 * s1_38; tmp3_2 = s0_38_2 * s1_38;
    // Op 39: dim3x1 add
    gl64_t s1_39 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_0)];
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
    gl64_t s1_41 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_0)];
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
    gl64_t s1_43 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_0)];
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
    // Op 45: dim3x1 add
    gl64_t s1_45 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_45; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 46: dim3x3 mul
    gl64_t s1_46_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_46_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_46_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 47: dim3x1 add
    gl64_t s1_47 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_47; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 48: dim3x3 mul
    gl64_t s1_48_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_48_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_48_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 49: dim3x1 add
    gl64_t s1_49 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_49; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 50: dim3x3 mul
    gl64_t s1_50_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_50_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_50_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 51: dim3x1 add
    gl64_t s1_51 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_0)];
    tmp3_9 = tmp3_0 + s1_51; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 52: dim3x3 add
    gl64_t s1_52_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_52_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_52_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_9 + s1_52_0; tmp3_1 = tmp3_10 + s1_52_1; tmp3_2 = tmp3_11 + s1_52_2;
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
    gl64_t s0_54_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_54_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_54_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
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
    tmp3_9 = tmp3_9 + s1_55_0; tmp3_10 = tmp3_10 + s1_55_1; tmp3_11 = tmp3_11 + s1_55_2;
    // Op 56: dim3x1 mul
    gl64_t s1_56 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_56; tmp3_10 = tmp3_10 * s1_56; tmp3_11 = tmp3_11 * s1_56;
    // Op 57: dim3x3 add
    gl64_t s1_57_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_57_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_57_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_3 + s1_57_0; tmp3_4 = tmp3_4 + s1_57_1; tmp3_5 = tmp3_5 + s1_57_2;
    // Op 58: dim3x1 mul
    gl64_t s1_58 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp3_3 = tmp3_3 * s1_58; tmp3_4 = tmp3_4 * s1_58; tmp3_5 = tmp3_5 * s1_58;
    // Op 59: dim3x3 add
    tmp3_3 = tmp3_9 + tmp3_3; tmp3_4 = tmp3_10 + tmp3_4; tmp3_5 = tmp3_11 + tmp3_5;
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
    gl64_t s1_63 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_0)];
    tmp3_0 = s0_63_0 * s1_63; tmp3_1 = s0_63_1 * s1_63; tmp3_2 = s0_63_2 * s1_63;
    // Op 64: dim3x1 add
    gl64_t s1_64 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_64; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 65: dim3x3 mul
    gl64_t s1_65_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_65_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_65_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA65 = (tmp3_0 + tmp3_1) * (s1_65_0 + s1_65_1);
    gl64_t kB65 = (tmp3_0 + tmp3_2) * (s1_65_0 + s1_65_2);
    gl64_t kC65 = (tmp3_1 + tmp3_2) * (s1_65_1 + s1_65_2);
    gl64_t kD65 = tmp3_0 * s1_65_0;
    gl64_t kE65 = tmp3_1 * s1_65_1;
    gl64_t kF65 = tmp3_2 * s1_65_2;
    gl64_t kG65 = kD65 - kE65;
    tmp3_0 = (kC65 + kG65) - kF65;
    tmp3_1 = ((((kA65 + kC65) - kE65) - kE65) - kD65);
    tmp3_2 = kB65 - kG65;
    // Op 66: dim3x1 add
    gl64_t s1_66 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_66; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 67: dim3x3 mul
    gl64_t s1_67_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_67_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_67_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 68: dim3x1 add
    gl64_t s1_68 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_68; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 69: dim3x3 mul
    gl64_t s1_69_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_69_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_69_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA69 = (tmp3_0 + tmp3_1) * (s1_69_0 + s1_69_1);
    gl64_t kB69 = (tmp3_0 + tmp3_2) * (s1_69_0 + s1_69_2);
    gl64_t kC69 = (tmp3_1 + tmp3_2) * (s1_69_1 + s1_69_2);
    gl64_t kD69 = tmp3_0 * s1_69_0;
    gl64_t kE69 = tmp3_1 * s1_69_1;
    gl64_t kF69 = tmp3_2 * s1_69_2;
    gl64_t kG69 = kD69 - kE69;
    tmp3_0 = (kC69 + kG69) - kF69;
    tmp3_1 = ((((kA69 + kC69) - kE69) - kE69) - kD69);
    tmp3_2 = kB69 - kG69;
    // Op 70: dim3x1 add
    gl64_t s1_70 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_70; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 71: dim3x3 mul
    gl64_t s1_71_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_71_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_71_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 72: dim3x1 add
    gl64_t s1_72 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_72; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 73: dim3x3 mul
    gl64_t s1_73_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_73_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_73_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA73 = (tmp3_0 + tmp3_1) * (s1_73_0 + s1_73_1);
    gl64_t kB73 = (tmp3_0 + tmp3_2) * (s1_73_0 + s1_73_2);
    gl64_t kC73 = (tmp3_1 + tmp3_2) * (s1_73_1 + s1_73_2);
    gl64_t kD73 = tmp3_0 * s1_73_0;
    gl64_t kE73 = tmp3_1 * s1_73_1;
    gl64_t kF73 = tmp3_2 * s1_73_2;
    gl64_t kG73 = kD73 - kE73;
    tmp3_0 = (kC73 + kG73) - kF73;
    tmp3_1 = ((((kA73 + kC73) - kE73) - kE73) - kD73);
    tmp3_2 = kB73 - kG73;
    // Op 74: dim3x1 add
    gl64_t s1_74 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_74; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 75: dim3x3 mul
    gl64_t s1_75_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_75_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_75_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 76: dim3x1 add
    gl64_t s1_76 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_0)];
    tmp3_9 = tmp3_0 + s1_76; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 77: dim3x3 add
    gl64_t s1_77_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_77_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_77_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_77_0; tmp3_13 = tmp3_10 + s1_77_1; tmp3_14 = tmp3_11 + s1_77_2;
    // Op 78: dim3x1 mul
    gl64_t s0_78_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_78_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_78_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_78 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 43, domainSize, nCols_0)];
    tmp3_0 = s0_78_0 * s1_78; tmp3_1 = s0_78_1 * s1_78; tmp3_2 = s0_78_2 * s1_78;
    // Op 79: dim3x1 add
    gl64_t s1_79 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 42, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_79; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 80: dim3x3 mul
    gl64_t s1_80_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_80_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_80_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 81: dim3x1 add
    gl64_t s1_81 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 41, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 41, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_81; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 82: dim3x3 mul
    gl64_t s1_82_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_82_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_82_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 83: dim3x1 add
    gl64_t s1_83 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 40, domainSize, nCols_0)];
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
    gl64_t s1_85 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 39, domainSize, nCols_0)];
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
    gl64_t s1_87 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 38, domainSize, nCols_0)];
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
    gl64_t s1_89 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_0)];
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
    gl64_t s1_91 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_0)];
    tmp3_3 = tmp3_0 + s1_91; tmp3_4 = tmp3_1; tmp3_5 = tmp3_2;
    // Op 92: dim3x3 add
    gl64_t s1_92_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_92_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_92_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_3 + s1_92_0; tmp3_1 = tmp3_4 + s1_92_1; tmp3_2 = tmp3_5 + s1_92_2;
    // Op 93: dim3x3 mul
    gl64_t kA93 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB93 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC93 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD93 = tmp3_12 * tmp3_0;
    gl64_t kE93 = tmp3_13 * tmp3_1;
    gl64_t kF93 = tmp3_14 * tmp3_2;
    gl64_t kG93 = kD93 - kE93;
    tmp3_0 = (kC93 + kG93) - kF93;
    tmp3_1 = ((((kA93 + kC93) - kE93) - kE93) - kD93);
    tmp3_2 = kB93 - kG93;
    // Op 94: dim3x3 mul
    uint64_t s0_94_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_94_0 = *(gl64_t*)&dParams->aux_trace[s0_94_pos];
    gl64_t s0_94_1 = *(gl64_t*)&dParams->aux_trace[s0_94_pos + TILE_HEIGHT];
    gl64_t s0_94_2 = *(gl64_t*)&dParams->aux_trace[s0_94_pos + 2*TILE_HEIGHT];
    gl64_t kA94 = (s0_94_0 + s0_94_1) * (tmp3_0 + tmp3_1);
    gl64_t kB94 = (s0_94_0 + s0_94_2) * (tmp3_0 + tmp3_2);
    gl64_t kC94 = (s0_94_1 + s0_94_2) * (tmp3_1 + tmp3_2);
    gl64_t kD94 = s0_94_0 * tmp3_0;
    gl64_t kE94 = s0_94_1 * tmp3_1;
    gl64_t kF94 = s0_94_2 * tmp3_2;
    gl64_t kG94 = kD94 - kE94;
    tmp3_0 = (kC94 + kG94) - kF94;
    tmp3_1 = ((((kA94 + kC94) - kE94) - kE94) - kD94);
    tmp3_2 = kB94 - kG94;
    // Op 95: dim3x3 add
    gl64_t s1_95_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_95_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_95_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_3 + s1_95_0; tmp3_4 = tmp3_4 + s1_95_1; tmp3_5 = tmp3_5 + s1_95_2;
    // Op 96: dim3x1 mul
    gl64_t s1_96 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp3_3 = tmp3_3 * s1_96; tmp3_4 = tmp3_4 * s1_96; tmp3_5 = tmp3_5 * s1_96;
    // Op 97: dim3x3 add
    gl64_t s1_97_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_97_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_97_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_97_0; tmp3_10 = tmp3_10 + s1_97_1; tmp3_11 = tmp3_11 + s1_97_2;
    // Op 98: dim3x1 mul
    gl64_t s1_98 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_98; tmp3_10 = tmp3_10 * s1_98; tmp3_11 = tmp3_11 * s1_98;
    // Op 99: dim3x3 add
    tmp3_3 = tmp3_3 + tmp3_9; tmp3_4 = tmp3_4 + tmp3_10; tmp3_5 = tmp3_5 + tmp3_11;
    // Op 100: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_3; tmp3_1 = tmp3_1 - tmp3_4; tmp3_2 = tmp3_2 - tmp3_5;
    // Op 101: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    tmp3_6 = (kC102 + kG102) - kF102;
    tmp3_7 = ((((kA102 + kC102) - kE102) - kE102) - kD102);
    tmp3_8 = kB102 - kG102;
    // Op 103: dim3x1 mul
    gl64_t s0_103_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_103_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_103_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_103 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 50, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 50, domainSize, nCols_0)];
    tmp3_0 = s0_103_0 * s1_103; tmp3_1 = s0_103_1 * s1_103; tmp3_2 = s0_103_2 * s1_103;
    // Op 104: dim3x1 add
    gl64_t s1_104 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 49, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 49, domainSize, nCols_0)];
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
    gl64_t s1_106 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 48, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 48, domainSize, nCols_0)];
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
    gl64_t s1_108 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 47, domainSize, nCols_0)];
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
    gl64_t s1_110 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 46, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 46, domainSize, nCols_0)];
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
    gl64_t s1_112 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 45, domainSize, nCols_0)];
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
    // Op 114: dim3x1 add
    gl64_t s1_114 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 44, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_114; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 115: dim3x3 mul
    gl64_t s1_115_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_115_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_115_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA115 = (tmp3_0 + tmp3_1) * (s1_115_0 + s1_115_1);
    gl64_t kB115 = (tmp3_0 + tmp3_2) * (s1_115_0 + s1_115_2);
    gl64_t kC115 = (tmp3_1 + tmp3_2) * (s1_115_1 + s1_115_2);
    gl64_t kD115 = tmp3_0 * s1_115_0;
    gl64_t kE115 = tmp3_1 * s1_115_1;
    gl64_t kF115 = tmp3_2 * s1_115_2;
    gl64_t kG115 = kD115 - kE115;
    tmp3_0 = (kC115 + kG115) - kF115;
    tmp3_1 = ((((kA115 + kC115) - kE115) - kE115) - kD115);
    tmp3_2 = kB115 - kG115;
    // Op 116: dim3x1 add
    gl64_t s1_116 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_116; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 117: dim3x3 add
    gl64_t s1_117_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_117_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_117_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_117_0; tmp3_1 = tmp3_1 + s1_117_1; tmp3_2 = tmp3_2 + s1_117_2;
    // Op 118: dim3x3 mul
    uint64_t s0_118_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
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
    // Op 119: dim3x1 sub
    gl64_t s1_119 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 - s1_119; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 120: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 121: dim3x3 mul
    gl64_t s1_121_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_121_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_121_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA121 = (tmp3_0 + tmp3_1) * (s1_121_0 + s1_121_1);
    gl64_t kB121 = (tmp3_0 + tmp3_2) * (s1_121_0 + s1_121_2);
    gl64_t kC121 = (tmp3_1 + tmp3_2) * (s1_121_1 + s1_121_2);
    gl64_t kD121 = tmp3_0 * s1_121_0;
    gl64_t kE121 = tmp3_1 * s1_121_1;
    gl64_t kF121 = tmp3_2 * s1_121_2;
    gl64_t kG121 = kD121 - kE121;
    tmp3_3 = (kC121 + kG121) - kF121;
    tmp3_4 = ((((kA121 + kC121) - kE121) - kE121) - kD121);
    tmp3_5 = kB121 - kG121;
    // Op 122: dim1x1 sub_swap
    gl64_t s0_122 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 51, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 51, domainSize, nCols_0)];
    gl64_t s1_122 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_122 - s0_122;
    // Op 123: dim3x1 mul
    uint64_t s0_123_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_123_0 = *(gl64_t*)&dParams->aux_trace[s0_123_pos];
    gl64_t s0_123_1 = *(gl64_t*)&dParams->aux_trace[s0_123_pos + TILE_HEIGHT];
    gl64_t s0_123_2 = *(gl64_t*)&dParams->aux_trace[s0_123_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_123_0 * tmp1_0; tmp3_1 = s0_123_1 * tmp1_0; tmp3_2 = s0_123_2 * tmp1_0;
    // Op 124: dim3x3 sub
    uint64_t s0_124_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_124_0 = *(gl64_t*)&dParams->aux_trace[s0_124_pos];
    gl64_t s0_124_1 = *(gl64_t*)&dParams->aux_trace[s0_124_pos + TILE_HEIGHT];
    gl64_t s0_124_2 = *(gl64_t*)&dParams->aux_trace[s0_124_pos + 2*TILE_HEIGHT];
    tmp3_6 = s0_124_0 - tmp3_0; tmp3_7 = s0_124_1 - tmp3_1; tmp3_8 = s0_124_2 - tmp3_2;
    // Op 125: dim3x3 add
    gl64_t s0_125_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_125_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_125_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_125_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_125_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_125_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_0 = s0_125_0 + s1_125_0; tmp3_1 = s0_125_1 + s1_125_1; tmp3_2 = s0_125_2 + s1_125_2;
    // Op 126: dim3x3 add
    uint64_t s0_126_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_126_0 = *(gl64_t*)&dParams->aux_trace[s0_126_pos];
    gl64_t s0_126_1 = *(gl64_t*)&dParams->aux_trace[s0_126_pos + TILE_HEIGHT];
    gl64_t s0_126_2 = *(gl64_t*)&dParams->aux_trace[s0_126_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_126_0 + tmp3_0; tmp3_1 = s0_126_1 + tmp3_1; tmp3_2 = s0_126_2 + tmp3_2;
    // Op 127: dim3x3 add
    uint64_t s0_127_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_127_0 = *(gl64_t*)&dParams->aux_trace[s0_127_pos];
    gl64_t s0_127_1 = *(gl64_t*)&dParams->aux_trace[s0_127_pos + TILE_HEIGHT];
    gl64_t s0_127_2 = *(gl64_t*)&dParams->aux_trace[s0_127_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_127_0 + tmp3_0; tmp3_1 = s0_127_1 + tmp3_1; tmp3_2 = s0_127_2 + tmp3_2;
    // Op 128: dim3x3 sub
    tmp3_6 = tmp3_6 - tmp3_0; tmp3_7 = tmp3_7 - tmp3_1; tmp3_8 = tmp3_8 - tmp3_2;
    // Op 129: dim3x1 mul
    gl64_t s0_129_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_129_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_129_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_129 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_0)];
    tmp3_0 = s0_129_0 * s1_129; tmp3_1 = s0_129_1 * s1_129; tmp3_2 = s0_129_2 * s1_129;
    // Op 130: dim3x1 add
    gl64_t s1_130 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_130; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 131: dim3x3 mul
    gl64_t s1_131_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_131_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_131_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 132: dim3x1 add
    gl64_t s1_132 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_132; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 133: dim3x3 add
    gl64_t s1_133_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_133_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_133_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_133_0; tmp3_1 = tmp3_1 + s1_133_1; tmp3_2 = tmp3_2 + s1_133_2;
    // Op 134: dim3x3 mul
    gl64_t kA134 = (tmp3_6 + tmp3_7) * (tmp3_0 + tmp3_1);
    gl64_t kB134 = (tmp3_6 + tmp3_8) * (tmp3_0 + tmp3_2);
    gl64_t kC134 = (tmp3_7 + tmp3_8) * (tmp3_1 + tmp3_2);
    gl64_t kD134 = tmp3_6 * tmp3_0;
    gl64_t kE134 = tmp3_7 * tmp3_1;
    gl64_t kF134 = tmp3_8 * tmp3_2;
    gl64_t kG134 = kD134 - kE134;
    tmp3_0 = (kC134 + kG134) - kF134;
    tmp3_1 = ((((kA134 + kC134) - kE134) - kE134) - kD134);
    tmp3_2 = kB134 - kG134;
    // Op 135: dim3x1 sub
    gl64_t s1_135 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 - s1_135; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 136: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
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
    tmp3_3 = (kC137 + kG137) - kF137;
    tmp3_4 = ((((kA137 + kC137) - kE137) - kE137) - kD137);
    tmp3_5 = kB137 - kG137;
    // Op 138: dim3x3 sub_swap
    uint64_t s0_138_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_138_0 = *(gl64_t*)&dParams->aux_trace[s0_138_pos];
    gl64_t s0_138_1 = *(gl64_t*)&dParams->aux_trace[s0_138_pos + TILE_HEIGHT];
    gl64_t s0_138_2 = *(gl64_t*)&dParams->aux_trace[s0_138_pos + 2*TILE_HEIGHT];
    gl64_t s1_138_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_138_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_138_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_0 = s1_138_0 - s0_138_0; tmp3_1 = s1_138_1 - s0_138_1; tmp3_2 = s1_138_2 - s0_138_2;
    // Op 139: dim3x1 mul
    gl64_t s1_139 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 51, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 51, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_139; tmp3_1 = tmp3_1 * s1_139; tmp3_2 = tmp3_2 * s1_139;
    // Op 140: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 141: dim3x1 mul
    gl64_t s1_141 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_141; tmp3_1 = tmp3_1 * s1_141; tmp3_2 = tmp3_2 * s1_141;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
