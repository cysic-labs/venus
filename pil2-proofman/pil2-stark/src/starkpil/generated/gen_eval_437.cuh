// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: 8ac86306  nOps=270 nTemp1=3 nTemp3=5
#define GENERATED_EVAL_NOPS_8ac86306 270
#define GENERATED_EVAL_NTEMP1_8ac86306 3
#define GENERATED_EVAL_NTEMP3_8ac86306 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_8ac86306(
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

    // Op 0: dim3x1 mul
    gl64_t s0_0_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_0_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_0_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp3_0 = s0_0_0 * s1_0; tmp3_1 = s0_0_1 * s1_0; tmp3_2 = s0_0_2 * s1_0;
    // Op 1: dim3x1 add
    gl64_t s1_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
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
    gl64_t s1_3 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 4: dim3x3 mul
    gl64_t s1_4_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_4_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_4_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA4 = (tmp3_0 + tmp3_1) * (s1_4_0 + s1_4_1);
    gl64_t kB4 = (tmp3_0 + tmp3_2) * (s1_4_0 + s1_4_2);
    gl64_t kC4 = (tmp3_1 + tmp3_2) * (s1_4_1 + s1_4_2);
    gl64_t kD4 = tmp3_0 * s1_4_0;
    gl64_t kE4 = tmp3_1 * s1_4_1;
    gl64_t kF4 = tmp3_2 * s1_4_2;
    gl64_t kG4 = kD4 - kE4;
    tmp3_0 = (kC4 + kG4) - kF4;
    tmp3_1 = ((((kA4 + kC4) - kE4) - kE4) - kD4);
    tmp3_2 = kB4 - kG4;
    // Op 5: dim3x1 add
    gl64_t s1_5 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_5; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 6: dim3x3 mul
    gl64_t s1_6_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_6_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_6_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 7: dim3x1 add
    gl64_t s1_7 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_7; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 8: dim3x3 mul
    gl64_t s1_8_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_8_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_8_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA8 = (tmp3_0 + tmp3_1) * (s1_8_0 + s1_8_1);
    gl64_t kB8 = (tmp3_0 + tmp3_2) * (s1_8_0 + s1_8_2);
    gl64_t kC8 = (tmp3_1 + tmp3_2) * (s1_8_1 + s1_8_2);
    gl64_t kD8 = tmp3_0 * s1_8_0;
    gl64_t kE8 = tmp3_1 * s1_8_1;
    gl64_t kF8 = tmp3_2 * s1_8_2;
    gl64_t kG8 = kD8 - kE8;
    tmp3_0 = (kC8 + kG8) - kF8;
    tmp3_1 = ((((kA8 + kC8) - kE8) - kE8) - kD8);
    tmp3_2 = kB8 - kG8;
    // Op 9: dim3x1 add
    gl64_t s1_9 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_9; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 10: dim3x3 mul
    gl64_t s1_10_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_10_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_10_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 11: dim3x1 add
    gl64_t s1_11 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_11; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 12: dim3x3 mul
    gl64_t s1_12_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_12_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_12_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA12 = (tmp3_0 + tmp3_1) * (s1_12_0 + s1_12_1);
    gl64_t kB12 = (tmp3_0 + tmp3_2) * (s1_12_0 + s1_12_2);
    gl64_t kC12 = (tmp3_1 + tmp3_2) * (s1_12_1 + s1_12_2);
    gl64_t kD12 = tmp3_0 * s1_12_0;
    gl64_t kE12 = tmp3_1 * s1_12_1;
    gl64_t kF12 = tmp3_2 * s1_12_2;
    gl64_t kG12 = kD12 - kE12;
    tmp3_0 = (kC12 + kG12) - kF12;
    tmp3_1 = ((((kA12 + kC12) - kE12) - kE12) - kD12);
    tmp3_2 = kB12 - kG12;
    // Op 13: dim3x1 add
    gl64_t s1_13 = *(gl64_t*)&expressions_params[9][1];
    tmp3_9 = tmp3_0 + s1_13; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 14: dim3x3 add
    gl64_t s1_14_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_14_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_14_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_14_0; tmp3_4 = tmp3_10 + s1_14_1; tmp3_5 = tmp3_11 + s1_14_2;
    // Op 15: dim3x1 mul
    gl64_t s0_15_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_15_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_15_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_15 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp3_0 = s0_15_0 * s1_15; tmp3_1 = s0_15_1 * s1_15; tmp3_2 = s0_15_2 * s1_15;
    // Op 16: dim3x1 add
    gl64_t s1_16 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_16; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 17: dim3x3 mul
    gl64_t s1_17_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_17_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_17_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA17 = (tmp3_0 + tmp3_1) * (s1_17_0 + s1_17_1);
    gl64_t kB17 = (tmp3_0 + tmp3_2) * (s1_17_0 + s1_17_2);
    gl64_t kC17 = (tmp3_1 + tmp3_2) * (s1_17_1 + s1_17_2);
    gl64_t kD17 = tmp3_0 * s1_17_0;
    gl64_t kE17 = tmp3_1 * s1_17_1;
    gl64_t kF17 = tmp3_2 * s1_17_2;
    gl64_t kG17 = kD17 - kE17;
    tmp3_0 = (kC17 + kG17) - kF17;
    tmp3_1 = ((((kA17 + kC17) - kE17) - kE17) - kD17);
    tmp3_2 = kB17 - kG17;
    // Op 18: dim3x1 add
    gl64_t s1_18 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_18; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 19: dim3x3 mul
    gl64_t s1_19_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_19_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_19_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA19 = (tmp3_0 + tmp3_1) * (s1_19_0 + s1_19_1);
    gl64_t kB19 = (tmp3_0 + tmp3_2) * (s1_19_0 + s1_19_2);
    gl64_t kC19 = (tmp3_1 + tmp3_2) * (s1_19_1 + s1_19_2);
    gl64_t kD19 = tmp3_0 * s1_19_0;
    gl64_t kE19 = tmp3_1 * s1_19_1;
    gl64_t kF19 = tmp3_2 * s1_19_2;
    gl64_t kG19 = kD19 - kE19;
    tmp3_0 = (kC19 + kG19) - kF19;
    tmp3_1 = ((((kA19 + kC19) - kE19) - kE19) - kD19);
    tmp3_2 = kB19 - kG19;
    // Op 20: dim3x1 add
    gl64_t s1_20 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_20; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 21: dim3x3 mul
    gl64_t s1_21_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_21_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_21_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA21 = (tmp3_0 + tmp3_1) * (s1_21_0 + s1_21_1);
    gl64_t kB21 = (tmp3_0 + tmp3_2) * (s1_21_0 + s1_21_2);
    gl64_t kC21 = (tmp3_1 + tmp3_2) * (s1_21_1 + s1_21_2);
    gl64_t kD21 = tmp3_0 * s1_21_0;
    gl64_t kE21 = tmp3_1 * s1_21_1;
    gl64_t kF21 = tmp3_2 * s1_21_2;
    gl64_t kG21 = kD21 - kE21;
    tmp3_0 = (kC21 + kG21) - kF21;
    tmp3_1 = ((((kA21 + kC21) - kE21) - kE21) - kD21);
    tmp3_2 = kB21 - kG21;
    // Op 22: dim3x1 add
    gl64_t s1_22 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_22; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 23: dim3x3 mul
    gl64_t s1_23_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_23_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_23_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA23 = (tmp3_0 + tmp3_1) * (s1_23_0 + s1_23_1);
    gl64_t kB23 = (tmp3_0 + tmp3_2) * (s1_23_0 + s1_23_2);
    gl64_t kC23 = (tmp3_1 + tmp3_2) * (s1_23_1 + s1_23_2);
    gl64_t kD23 = tmp3_0 * s1_23_0;
    gl64_t kE23 = tmp3_1 * s1_23_1;
    gl64_t kF23 = tmp3_2 * s1_23_2;
    gl64_t kG23 = kD23 - kE23;
    tmp3_0 = (kC23 + kG23) - kF23;
    tmp3_1 = ((((kA23 + kC23) - kE23) - kE23) - kD23);
    tmp3_2 = kB23 - kG23;
    // Op 24: dim3x1 add
    gl64_t s1_24 = *(gl64_t*)&expressions_params[9][0];
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
    gl64_t s1_26 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
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
    gl64_t s1_28 = *(gl64_t*)&expressions_params[9][1];
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
    gl64_t s1_33 = *(gl64_t*)&expressions_params[9][2];
    tmp3_6 = tmp3_6 * s1_33; tmp3_7 = tmp3_7 * s1_33; tmp3_8 = tmp3_8 * s1_33;
    // Op 34: dim3x3 add
    gl64_t s1_34_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_34_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_34_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_34_0; tmp3_10 = tmp3_10 + s1_34_1; tmp3_11 = tmp3_11 + s1_34_2;
    // Op 35: dim3x1 mul
    gl64_t s1_35 = *(gl64_t*)&expressions_params[9][2];
    tmp3_9 = tmp3_9 * s1_35; tmp3_10 = tmp3_10 * s1_35; tmp3_11 = tmp3_11 * s1_35;
    // Op 36: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 37: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
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
    tmp3_12 = (kC38 + kG38) - kF38;
    tmp3_13 = ((((kA38 + kC38) - kE38) - kE38) - kD38);
    tmp3_14 = kB38 - kG38;
    // Op 39: dim3x1 mul
    gl64_t s0_39_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_39_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_39_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_39 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp3_0 = s0_39_0 * s1_39; tmp3_1 = s0_39_1 * s1_39; tmp3_2 = s0_39_2 * s1_39;
    // Op 40: dim3x1 add
    gl64_t s1_40 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_40; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 41: dim3x3 mul
    gl64_t s1_41_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_41_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_41_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 42: dim3x1 add
    gl64_t s1_42 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_42; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 43: dim3x3 mul
    gl64_t s1_43_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_43_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_43_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 44: dim3x1 add
    gl64_t s1_44 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_44; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_46 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_46; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 47: dim3x3 mul
    gl64_t s1_47_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_47_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_47_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 48: dim3x1 add
    gl64_t s1_48 = *(gl64_t*)&expressions_params[9][5];
    tmp3_0 = tmp3_0 + s1_48; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_50 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
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
    gl64_t s1_52 = *(gl64_t*)&expressions_params[9][1];
    tmp3_3 = tmp3_0 + s1_52; tmp3_4 = tmp3_1; tmp3_5 = tmp3_2;
    // Op 53: dim3x3 add
    gl64_t s1_53_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_53_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_53_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_3 + s1_53_0; tmp3_7 = tmp3_4 + s1_53_1; tmp3_8 = tmp3_5 + s1_53_2;
    // Op 54: dim3x1 mul
    gl64_t s0_54_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_54_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_54_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_54 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp3_0 = s0_54_0 * s1_54; tmp3_1 = s0_54_1 * s1_54; tmp3_2 = s0_54_2 * s1_54;
    // Op 55: dim3x1 add
    gl64_t s1_55 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
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
    gl64_t s1_57 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
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
    gl64_t s1_59 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
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
    gl64_t s1_61 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
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
    // Op 63: dim3x1 add
    gl64_t s1_63 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_63; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 64: dim3x3 mul
    gl64_t s1_64_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_64_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_64_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 65: dim3x1 add
    gl64_t s1_65 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_65; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 66: dim3x3 mul
    gl64_t s1_66_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_66_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_66_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 67: dim3x1 add
    gl64_t s1_67 = *(gl64_t*)&expressions_params[9][1];
    tmp3_9 = tmp3_0 + s1_67; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 68: dim3x3 add
    gl64_t s1_68_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_68_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_68_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_9 + s1_68_0; tmp3_1 = tmp3_10 + s1_68_1; tmp3_2 = tmp3_11 + s1_68_2;
    // Op 69: dim3x3 mul
    gl64_t kA69 = (tmp3_6 + tmp3_7) * (tmp3_0 + tmp3_1);
    gl64_t kB69 = (tmp3_6 + tmp3_8) * (tmp3_0 + tmp3_2);
    gl64_t kC69 = (tmp3_7 + tmp3_8) * (tmp3_1 + tmp3_2);
    gl64_t kD69 = tmp3_6 * tmp3_0;
    gl64_t kE69 = tmp3_7 * tmp3_1;
    gl64_t kF69 = tmp3_8 * tmp3_2;
    gl64_t kG69 = kD69 - kE69;
    tmp3_0 = (kC69 + kG69) - kF69;
    tmp3_1 = ((((kA69 + kC69) - kE69) - kE69) - kD69);
    tmp3_2 = kB69 - kG69;
    // Op 70: dim3x3 mul
    gl64_t s0_70_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_70_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_70_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
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
    tmp3_9 = tmp3_9 + s1_71_0; tmp3_10 = tmp3_10 + s1_71_1; tmp3_11 = tmp3_11 + s1_71_2;
    // Op 72: dim3x1 mul
    gl64_t s1_72 = *(gl64_t*)&expressions_params[9][2];
    tmp3_9 = tmp3_9 * s1_72; tmp3_10 = tmp3_10 * s1_72; tmp3_11 = tmp3_11 * s1_72;
    // Op 73: dim3x3 add
    gl64_t s1_73_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_73_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_73_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_3 + s1_73_0; tmp3_4 = tmp3_4 + s1_73_1; tmp3_5 = tmp3_5 + s1_73_2;
    // Op 74: dim3x1 mul
    gl64_t s1_74 = *(gl64_t*)&expressions_params[9][2];
    tmp3_3 = tmp3_3 * s1_74; tmp3_4 = tmp3_4 * s1_74; tmp3_5 = tmp3_5 * s1_74;
    // Op 75: dim3x3 add
    tmp3_3 = tmp3_9 + tmp3_3; tmp3_4 = tmp3_10 + tmp3_4; tmp3_5 = tmp3_11 + tmp3_5;
    // Op 76: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_3; tmp3_1 = tmp3_1 - tmp3_4; tmp3_2 = tmp3_2 - tmp3_5;
    // Op 77: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
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
    tmp3_6 = (kC78 + kG78) - kF78;
    tmp3_7 = ((((kA78 + kC78) - kE78) - kE78) - kD78);
    tmp3_8 = kB78 - kG78;
    // Op 79: dim3x1 mul
    gl64_t s0_79_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_79_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_79_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_79 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp3_0 = s0_79_0 * s1_79; tmp3_1 = s0_79_1 * s1_79; tmp3_2 = s0_79_2 * s1_79;
    // Op 80: dim3x1 add
    gl64_t s1_80 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_80; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 81: dim3x3 mul
    gl64_t s1_81_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_81_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_81_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA81 = (tmp3_0 + tmp3_1) * (s1_81_0 + s1_81_1);
    gl64_t kB81 = (tmp3_0 + tmp3_2) * (s1_81_0 + s1_81_2);
    gl64_t kC81 = (tmp3_1 + tmp3_2) * (s1_81_1 + s1_81_2);
    gl64_t kD81 = tmp3_0 * s1_81_0;
    gl64_t kE81 = tmp3_1 * s1_81_1;
    gl64_t kF81 = tmp3_2 * s1_81_2;
    gl64_t kG81 = kD81 - kE81;
    tmp3_0 = (kC81 + kG81) - kF81;
    tmp3_1 = ((((kA81 + kC81) - kE81) - kE81) - kD81);
    tmp3_2 = kB81 - kG81;
    // Op 82: dim3x1 add
    gl64_t s1_82 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_82; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 83: dim3x3 mul
    gl64_t s1_83_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_83_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_83_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA83 = (tmp3_0 + tmp3_1) * (s1_83_0 + s1_83_1);
    gl64_t kB83 = (tmp3_0 + tmp3_2) * (s1_83_0 + s1_83_2);
    gl64_t kC83 = (tmp3_1 + tmp3_2) * (s1_83_1 + s1_83_2);
    gl64_t kD83 = tmp3_0 * s1_83_0;
    gl64_t kE83 = tmp3_1 * s1_83_1;
    gl64_t kF83 = tmp3_2 * s1_83_2;
    gl64_t kG83 = kD83 - kE83;
    tmp3_0 = (kC83 + kG83) - kF83;
    tmp3_1 = ((((kA83 + kC83) - kE83) - kE83) - kD83);
    tmp3_2 = kB83 - kG83;
    // Op 84: dim3x1 add
    gl64_t s1_84 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_84; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 85: dim3x3 mul
    gl64_t s1_85_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_85_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_85_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 86: dim3x1 add
    gl64_t s1_86 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_86; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 87: dim3x3 mul
    gl64_t s1_87_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_87_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_87_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 88: dim3x1 add
    gl64_t s1_88 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_88; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 89: dim3x3 mul
    gl64_t s1_89_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_89_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_89_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA89 = (tmp3_0 + tmp3_1) * (s1_89_0 + s1_89_1);
    gl64_t kB89 = (tmp3_0 + tmp3_2) * (s1_89_0 + s1_89_2);
    gl64_t kC89 = (tmp3_1 + tmp3_2) * (s1_89_1 + s1_89_2);
    gl64_t kD89 = tmp3_0 * s1_89_0;
    gl64_t kE89 = tmp3_1 * s1_89_1;
    gl64_t kF89 = tmp3_2 * s1_89_2;
    gl64_t kG89 = kD89 - kE89;
    tmp3_0 = (kC89 + kG89) - kF89;
    tmp3_1 = ((((kA89 + kC89) - kE89) - kE89) - kD89);
    tmp3_2 = kB89 - kG89;
    // Op 90: dim3x1 add
    gl64_t s1_90 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_90; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 91: dim3x3 mul
    gl64_t s1_91_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_91_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_91_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 92: dim3x1 add
    gl64_t s1_92 = *(gl64_t*)&expressions_params[9][1];
    tmp3_9 = tmp3_0 + s1_92; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 93: dim3x3 add
    gl64_t s1_93_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_93_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_93_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_93_0; tmp3_13 = tmp3_10 + s1_93_1; tmp3_14 = tmp3_11 + s1_93_2;
    // Op 94: dim3x1 mul
    gl64_t s0_94_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_94_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_94_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_94 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp3_0 = s0_94_0 * s1_94; tmp3_1 = s0_94_1 * s1_94; tmp3_2 = s0_94_2 * s1_94;
    // Op 95: dim3x1 add
    gl64_t s1_95 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_95; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 96: dim3x3 mul
    gl64_t s1_96_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_96_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_96_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 97: dim3x1 add
    gl64_t s1_97 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_97; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 98: dim3x3 mul
    gl64_t s1_98_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_98_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_98_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 99: dim3x1 add
    gl64_t s1_99 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_99; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 100: dim3x3 mul
    gl64_t s1_100_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_100_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_100_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 101: dim3x1 add
    gl64_t s1_101 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_101; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 102: dim3x3 mul
    gl64_t s1_102_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_102_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_102_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA102 = (tmp3_0 + tmp3_1) * (s1_102_0 + s1_102_1);
    gl64_t kB102 = (tmp3_0 + tmp3_2) * (s1_102_0 + s1_102_2);
    gl64_t kC102 = (tmp3_1 + tmp3_2) * (s1_102_1 + s1_102_2);
    gl64_t kD102 = tmp3_0 * s1_102_0;
    gl64_t kE102 = tmp3_1 * s1_102_1;
    gl64_t kF102 = tmp3_2 * s1_102_2;
    gl64_t kG102 = kD102 - kE102;
    tmp3_0 = (kC102 + kG102) - kF102;
    tmp3_1 = ((((kA102 + kC102) - kE102) - kE102) - kD102);
    tmp3_2 = kB102 - kG102;
    // Op 103: dim3x1 add
    gl64_t s1_103 = *(gl64_t*)&expressions_params[9][6];
    tmp3_0 = tmp3_0 + s1_103; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 104: dim3x3 mul
    gl64_t s1_104_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_104_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_104_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 105: dim3x1 add
    gl64_t s1_105 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_105; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 106: dim3x3 mul
    gl64_t s1_106_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_106_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_106_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 107: dim3x1 add
    gl64_t s1_107 = *(gl64_t*)&expressions_params[9][1];
    tmp3_3 = tmp3_0 + s1_107; tmp3_4 = tmp3_1; tmp3_5 = tmp3_2;
    // Op 108: dim3x3 add
    gl64_t s1_108_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_108_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_108_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_3 + s1_108_0; tmp3_1 = tmp3_4 + s1_108_1; tmp3_2 = tmp3_5 + s1_108_2;
    // Op 109: dim3x3 mul
    gl64_t kA109 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB109 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC109 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD109 = tmp3_12 * tmp3_0;
    gl64_t kE109 = tmp3_13 * tmp3_1;
    gl64_t kF109 = tmp3_14 * tmp3_2;
    gl64_t kG109 = kD109 - kE109;
    tmp3_0 = (kC109 + kG109) - kF109;
    tmp3_1 = ((((kA109 + kC109) - kE109) - kE109) - kD109);
    tmp3_2 = kB109 - kG109;
    // Op 110: dim3x3 mul
    uint64_t s0_110_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_110_0 = *(gl64_t*)&dParams->aux_trace[s0_110_pos];
    gl64_t s0_110_1 = *(gl64_t*)&dParams->aux_trace[s0_110_pos + TILE_HEIGHT];
    gl64_t s0_110_2 = *(gl64_t*)&dParams->aux_trace[s0_110_pos + 2*TILE_HEIGHT];
    gl64_t kA110 = (s0_110_0 + s0_110_1) * (tmp3_0 + tmp3_1);
    gl64_t kB110 = (s0_110_0 + s0_110_2) * (tmp3_0 + tmp3_2);
    gl64_t kC110 = (s0_110_1 + s0_110_2) * (tmp3_1 + tmp3_2);
    gl64_t kD110 = s0_110_0 * tmp3_0;
    gl64_t kE110 = s0_110_1 * tmp3_1;
    gl64_t kF110 = s0_110_2 * tmp3_2;
    gl64_t kG110 = kD110 - kE110;
    tmp3_0 = (kC110 + kG110) - kF110;
    tmp3_1 = ((((kA110 + kC110) - kE110) - kE110) - kD110);
    tmp3_2 = kB110 - kG110;
    // Op 111: dim3x3 add
    gl64_t s1_111_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_111_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_111_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_3 + s1_111_0; tmp3_4 = tmp3_4 + s1_111_1; tmp3_5 = tmp3_5 + s1_111_2;
    // Op 112: dim3x1 mul
    gl64_t s1_112 = *(gl64_t*)&expressions_params[9][2];
    tmp3_3 = tmp3_3 * s1_112; tmp3_4 = tmp3_4 * s1_112; tmp3_5 = tmp3_5 * s1_112;
    // Op 113: dim3x3 add
    gl64_t s1_113_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_113_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_113_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_113_0; tmp3_10 = tmp3_10 + s1_113_1; tmp3_11 = tmp3_11 + s1_113_2;
    // Op 114: dim3x1 mul
    gl64_t s1_114 = *(gl64_t*)&expressions_params[9][2];
    tmp3_9 = tmp3_9 * s1_114; tmp3_10 = tmp3_10 * s1_114; tmp3_11 = tmp3_11 * s1_114;
    // Op 115: dim3x3 add
    tmp3_3 = tmp3_3 + tmp3_9; tmp3_4 = tmp3_4 + tmp3_10; tmp3_5 = tmp3_5 + tmp3_11;
    // Op 116: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_3; tmp3_1 = tmp3_1 - tmp3_4; tmp3_2 = tmp3_2 - tmp3_5;
    // Op 117: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 118: dim3x3 mul
    gl64_t s1_118_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_118_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_118_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA118 = (tmp3_0 + tmp3_1) * (s1_118_0 + s1_118_1);
    gl64_t kB118 = (tmp3_0 + tmp3_2) * (s1_118_0 + s1_118_2);
    gl64_t kC118 = (tmp3_1 + tmp3_2) * (s1_118_1 + s1_118_2);
    gl64_t kD118 = tmp3_0 * s1_118_0;
    gl64_t kE118 = tmp3_1 * s1_118_1;
    gl64_t kF118 = tmp3_2 * s1_118_2;
    gl64_t kG118 = kD118 - kE118;
    tmp3_12 = (kC118 + kG118) - kF118;
    tmp3_13 = ((((kA118 + kC118) - kE118) - kE118) - kD118);
    tmp3_14 = kB118 - kG118;
    // Op 119: dim3x1 mul
    gl64_t s0_119_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_119_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_119_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_119 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp3_0 = s0_119_0 * s1_119; tmp3_1 = s0_119_1 * s1_119; tmp3_2 = s0_119_2 * s1_119;
    // Op 120: dim3x1 add
    gl64_t s1_120 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_120; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 121: dim3x3 mul
    gl64_t s1_121_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_121_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_121_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA121 = (tmp3_0 + tmp3_1) * (s1_121_0 + s1_121_1);
    gl64_t kB121 = (tmp3_0 + tmp3_2) * (s1_121_0 + s1_121_2);
    gl64_t kC121 = (tmp3_1 + tmp3_2) * (s1_121_1 + s1_121_2);
    gl64_t kD121 = tmp3_0 * s1_121_0;
    gl64_t kE121 = tmp3_1 * s1_121_1;
    gl64_t kF121 = tmp3_2 * s1_121_2;
    gl64_t kG121 = kD121 - kE121;
    tmp3_0 = (kC121 + kG121) - kF121;
    tmp3_1 = ((((kA121 + kC121) - kE121) - kE121) - kD121);
    tmp3_2 = kB121 - kG121;
    // Op 122: dim3x1 add
    gl64_t s1_122 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_122; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 123: dim3x3 mul
    gl64_t s1_123_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_123_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_123_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA123 = (tmp3_0 + tmp3_1) * (s1_123_0 + s1_123_1);
    gl64_t kB123 = (tmp3_0 + tmp3_2) * (s1_123_0 + s1_123_2);
    gl64_t kC123 = (tmp3_1 + tmp3_2) * (s1_123_1 + s1_123_2);
    gl64_t kD123 = tmp3_0 * s1_123_0;
    gl64_t kE123 = tmp3_1 * s1_123_1;
    gl64_t kF123 = tmp3_2 * s1_123_2;
    gl64_t kG123 = kD123 - kE123;
    tmp3_0 = (kC123 + kG123) - kF123;
    tmp3_1 = ((((kA123 + kC123) - kE123) - kE123) - kD123);
    tmp3_2 = kB123 - kG123;
    // Op 124: dim3x1 add
    gl64_t s1_124 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_124; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 125: dim3x3 mul
    gl64_t s1_125_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_125_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_125_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA125 = (tmp3_0 + tmp3_1) * (s1_125_0 + s1_125_1);
    gl64_t kB125 = (tmp3_0 + tmp3_2) * (s1_125_0 + s1_125_2);
    gl64_t kC125 = (tmp3_1 + tmp3_2) * (s1_125_1 + s1_125_2);
    gl64_t kD125 = tmp3_0 * s1_125_0;
    gl64_t kE125 = tmp3_1 * s1_125_1;
    gl64_t kF125 = tmp3_2 * s1_125_2;
    gl64_t kG125 = kD125 - kE125;
    tmp3_0 = (kC125 + kG125) - kF125;
    tmp3_1 = ((((kA125 + kC125) - kE125) - kE125) - kD125);
    tmp3_2 = kB125 - kG125;
    // Op 126: dim3x1 add
    gl64_t s1_126 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_126; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 127: dim3x3 mul
    gl64_t s1_127_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_127_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_127_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA127 = (tmp3_0 + tmp3_1) * (s1_127_0 + s1_127_1);
    gl64_t kB127 = (tmp3_0 + tmp3_2) * (s1_127_0 + s1_127_2);
    gl64_t kC127 = (tmp3_1 + tmp3_2) * (s1_127_1 + s1_127_2);
    gl64_t kD127 = tmp3_0 * s1_127_0;
    gl64_t kE127 = tmp3_1 * s1_127_1;
    gl64_t kF127 = tmp3_2 * s1_127_2;
    gl64_t kG127 = kD127 - kE127;
    tmp3_0 = (kC127 + kG127) - kF127;
    tmp3_1 = ((((kA127 + kC127) - kE127) - kE127) - kD127);
    tmp3_2 = kB127 - kG127;
    // Op 128: dim3x1 add
    gl64_t s1_128 = *(gl64_t*)&expressions_params[9][10];
    tmp3_0 = tmp3_0 + s1_128; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 129: dim3x3 mul
    gl64_t s1_129_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_129_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_129_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 130: dim3x1 add
    gl64_t s1_130 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
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
    gl64_t s1_132 = *(gl64_t*)&expressions_params[9][1];
    tmp3_9 = tmp3_0 + s1_132; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 133: dim3x3 add
    gl64_t s1_133_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_133_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_133_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_9 + s1_133_0; tmp3_7 = tmp3_10 + s1_133_1; tmp3_8 = tmp3_11 + s1_133_2;
    // Op 134: dim3x1 mul
    gl64_t s0_134_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_134_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_134_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_134 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp3_0 = s0_134_0 * s1_134; tmp3_1 = s0_134_1 * s1_134; tmp3_2 = s0_134_2 * s1_134;
    // Op 135: dim3x1 add
    gl64_t s1_135 = *(gl64_t*)&expressions_params[9][8];
    tmp3_3 = tmp3_0 + s1_135; tmp3_4 = tmp3_1; tmp3_5 = tmp3_2;
    // Op 136: dim3x3 add
    gl64_t s1_136_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_136_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_136_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_3 + s1_136_0; tmp3_1 = tmp3_4 + s1_136_1; tmp3_2 = tmp3_5 + s1_136_2;
    // Op 137: dim3x3 mul
    gl64_t kA137 = (tmp3_6 + tmp3_7) * (tmp3_0 + tmp3_1);
    gl64_t kB137 = (tmp3_6 + tmp3_8) * (tmp3_0 + tmp3_2);
    gl64_t kC137 = (tmp3_7 + tmp3_8) * (tmp3_1 + tmp3_2);
    gl64_t kD137 = tmp3_6 * tmp3_0;
    gl64_t kE137 = tmp3_7 * tmp3_1;
    gl64_t kF137 = tmp3_8 * tmp3_2;
    gl64_t kG137 = kD137 - kE137;
    tmp3_0 = (kC137 + kG137) - kF137;
    tmp3_1 = ((((kA137 + kC137) - kE137) - kE137) - kD137);
    tmp3_2 = kB137 - kG137;
    // Op 138: dim3x3 mul
    uint64_t s0_138_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_138_0 = *(gl64_t*)&dParams->aux_trace[s0_138_pos];
    gl64_t s0_138_1 = *(gl64_t*)&dParams->aux_trace[s0_138_pos + TILE_HEIGHT];
    gl64_t s0_138_2 = *(gl64_t*)&dParams->aux_trace[s0_138_pos + 2*TILE_HEIGHT];
    gl64_t kA138 = (s0_138_0 + s0_138_1) * (tmp3_0 + tmp3_1);
    gl64_t kB138 = (s0_138_0 + s0_138_2) * (tmp3_0 + tmp3_2);
    gl64_t kC138 = (s0_138_1 + s0_138_2) * (tmp3_1 + tmp3_2);
    gl64_t kD138 = s0_138_0 * tmp3_0;
    gl64_t kE138 = s0_138_1 * tmp3_1;
    gl64_t kF138 = s0_138_2 * tmp3_2;
    gl64_t kG138 = kD138 - kE138;
    tmp3_0 = (kC138 + kG138) - kF138;
    tmp3_1 = ((((kA138 + kC138) - kE138) - kE138) - kD138);
    tmp3_2 = kB138 - kG138;
    // Op 139: dim3x3 add
    gl64_t s1_139_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_139_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_139_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_3 + s1_139_0; tmp3_4 = tmp3_4 + s1_139_1; tmp3_5 = tmp3_5 + s1_139_2;
    // Op 140: dim3x1 mul
    gl64_t s1_140 = *(gl64_t*)&expressions_params[9][2];
    tmp3_3 = tmp3_3 * s1_140; tmp3_4 = tmp3_4 * s1_140; tmp3_5 = tmp3_5 * s1_140;
    // Op 141: dim1x1 sub_swap
    gl64_t s0_141 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_141 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = s1_141 - s0_141;
    // Op 142: dim3x3 add
    gl64_t s1_142_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_142_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_142_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_142_0; tmp3_10 = tmp3_10 + s1_142_1; tmp3_11 = tmp3_11 + s1_142_2;
    // Op 143: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 144: dim3x3 add
    tmp3_3 = tmp3_3 + tmp3_9; tmp3_4 = tmp3_4 + tmp3_10; tmp3_5 = tmp3_5 + tmp3_11;
    // Op 145: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_3; tmp3_1 = tmp3_1 - tmp3_4; tmp3_2 = tmp3_2 - tmp3_5;
    // Op 146: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
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
    tmp3_12 = (kC147 + kG147) - kF147;
    tmp3_13 = ((((kA147 + kC147) - kE147) - kE147) - kD147);
    tmp3_14 = kB147 - kG147;
    // Op 148: dim1x1 add
    gl64_t s0_148 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_148 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_148 + s1_148;
    // Op 149: dim1x1 add
    gl64_t s0_149 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_0 = s0_149 + tmp1_0;
    // Op 150: dim1x1 add
    gl64_t s0_150 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_150 + tmp1_0;
    // Op 151: dim1x1 add
    gl64_t s0_151 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_0 = s0_151 + tmp1_0;
    // Op 152: dim1x1 add
    gl64_t s0_152 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_152 + tmp1_0;
    // Op 153: dim1x1 add
    gl64_t s0_153 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = s0_153 + tmp1_0;
    // Op 154: dim1x1 add
    gl64_t s0_154 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_0 = s0_154 + tmp1_0;
    // Op 155: dim3x1 mul
    gl64_t s0_155_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_155_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_155_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_155_0 * tmp1_0; tmp3_1 = s0_155_1 * tmp1_0; tmp3_2 = s0_155_2 * tmp1_0;
    // Op 156: dim1x1 add
    gl64_t s0_156 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_156 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_156 + s1_156;
    // Op 157: dim1x1 add
    gl64_t s0_157 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_157 + tmp1_0;
    // Op 158: dim1x1 add
    gl64_t s0_158 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp1_0 = s0_158 + tmp1_0;
    // Op 159: dim1x1 add
    gl64_t s0_159 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp1_0 = s0_159 + tmp1_0;
    // Op 160: dim1x1 add
    gl64_t s0_160 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_0 = s0_160 + tmp1_0;
    // Op 161: dim1x1 add
    gl64_t s0_161 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_161 + tmp1_0;
    // Op 162: dim1x1 add
    gl64_t s0_162 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_162 + tmp1_0;
    // Op 163: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 165: dim1x1 mul
    gl64_t s0_165 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_165 = *(gl64_t*)&expressions_params[9][11];
    tmp1_0 = s0_165 * s1_165;
    // Op 166: dim1x1 add
    gl64_t s0_166 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_166 + tmp1_0;
    // Op 167: dim1x1 mul
    gl64_t s0_167 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_167 = *(gl64_t*)&expressions_params[9][12];
    tmp1_1 = s0_167 * s1_167;
    // Op 168: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 169: dim1x1 mul
    gl64_t s0_169 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_169 = *(gl64_t*)&expressions_params[9][13];
    tmp1_1 = s0_169 * s1_169;
    // Op 170: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 171: dim1x1 sub
    gl64_t s0_171 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_171 - tmp1_0;
    // Op 172: dim1x1 mul
    gl64_t s0_172 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_2 = s0_172 * tmp1_0;
    // Op 173: dim1x1 mul
    gl64_t s0_173 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_173 = *(gl64_t*)&expressions_params[9][11];
    tmp1_0 = s0_173 * s1_173;
    // Op 174: dim1x1 add
    gl64_t s0_174 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_174 + tmp1_0;
    // Op 175: dim1x1 mul
    gl64_t s0_175 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_175 = *(gl64_t*)&expressions_params[9][12];
    tmp1_1 = s0_175 * s1_175;
    // Op 176: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 177: dim1x1 mul
    gl64_t s0_177 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_177 = *(gl64_t*)&expressions_params[9][13];
    tmp1_1 = s0_177 * s1_177;
    // Op 178: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 179: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 180: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 181: dim3x3 mul
    gl64_t s1_181_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_181_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_181_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA181 = (tmp3_0 + tmp3_1) * (s1_181_0 + s1_181_1);
    gl64_t kB181 = (tmp3_0 + tmp3_2) * (s1_181_0 + s1_181_2);
    gl64_t kC181 = (tmp3_1 + tmp3_2) * (s1_181_1 + s1_181_2);
    gl64_t kD181 = tmp3_0 * s1_181_0;
    gl64_t kE181 = tmp3_1 * s1_181_1;
    gl64_t kF181 = tmp3_2 * s1_181_2;
    gl64_t kG181 = kD181 - kE181;
    tmp3_0 = (kC181 + kG181) - kF181;
    tmp3_1 = ((((kA181 + kC181) - kE181) - kE181) - kD181);
    tmp3_2 = kB181 - kG181;
    // Op 182: dim1x1 mul
    gl64_t s0_182 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    gl64_t s1_182 = *(gl64_t*)&expressions_params[9][11];
    tmp1_0 = s0_182 * s1_182;
    // Op 183: dim1x1 add
    gl64_t s0_183 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_1 = s0_183 + tmp1_0;
    // Op 184: dim1x1 mul
    gl64_t s0_184 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_184 = *(gl64_t*)&expressions_params[9][11];
    tmp1_0 = s0_184 * s1_184;
    // Op 185: dim1x1 add
    gl64_t s0_185 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_185 + tmp1_0;
    // Op 186: dim1x1 mul
    gl64_t s0_186 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_186 = *(gl64_t*)&expressions_params[9][12];
    tmp1_2 = s0_186 * s1_186;
    // Op 187: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 188: dim1x1 mul
    gl64_t s0_188 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_188 = *(gl64_t*)&expressions_params[9][13];
    tmp1_2 = s0_188 * s1_188;
    // Op 189: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 190: dim1x1 sub
    tmp1_0 = tmp1_1 - tmp1_0;
    // Op 191: dim1x1 mul
    gl64_t s0_191 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_2 = s0_191 * tmp1_0;
    // Op 192: dim1x1 mul
    gl64_t s0_192 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_192 = *(gl64_t*)&expressions_params[9][11];
    tmp1_0 = s0_192 * s1_192;
    // Op 193: dim1x1 add
    gl64_t s0_193 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_193 + tmp1_0;
    // Op 194: dim1x1 mul
    gl64_t s0_194 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_194 = *(gl64_t*)&expressions_params[9][12];
    tmp1_1 = s0_194 * s1_194;
    // Op 195: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 196: dim1x1 mul
    gl64_t s0_196 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_196 = *(gl64_t*)&expressions_params[9][13];
    tmp1_1 = s0_196 * s1_196;
    // Op 197: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 198: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 199: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 200: dim3x3 mul
    gl64_t s1_200_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_200_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_200_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    gl64_t s0_201 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_201 = *(gl64_t*)&expressions_params[9][11];
    tmp1_0 = s0_201 * s1_201;
    // Op 202: dim1x1 add
    gl64_t s0_202 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_202 + tmp1_0;
    // Op 203: dim1x1 mul
    gl64_t s0_203 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_203 = *(gl64_t*)&expressions_params[9][12];
    tmp1_2 = s0_203 * s1_203;
    // Op 204: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 205: dim1x1 mul
    gl64_t s0_205 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_205 = *(gl64_t*)&expressions_params[9][13];
    tmp1_2 = s0_205 * s1_205;
    // Op 206: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 207: dim1x1 sub_swap
    gl64_t s0_207 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = tmp1_0 - s0_207;
    // Op 208: dim1x1 mul
    gl64_t s0_208 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_208 * tmp1_0;
    // Op 209: dim1x1 add
    gl64_t s0_209 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_209 + tmp1_0;
    // Op 210: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 211: dim3x3 mul
    gl64_t s1_211_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_211_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_211_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 212: dim1x1 mul
    gl64_t s0_212 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_212 = *(gl64_t*)&expressions_params[9][11];
    tmp1_0 = s0_212 * s1_212;
    // Op 213: dim1x1 add
    gl64_t s0_213 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_213 + tmp1_0;
    // Op 214: dim1x1 mul
    gl64_t s0_214 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_214 = *(gl64_t*)&expressions_params[9][12];
    tmp1_2 = s0_214 * s1_214;
    // Op 215: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 216: dim1x1 mul
    gl64_t s0_216 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_216 = *(gl64_t*)&expressions_params[9][13];
    tmp1_2 = s0_216 * s1_216;
    // Op 217: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 218: dim1x1 sub_swap
    gl64_t s0_218 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp1_0 = tmp1_0 - s0_218;
    // Op 219: dim1x1 mul
    gl64_t s0_219 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_219 * tmp1_0;
    // Op 220: dim1x1 add
    gl64_t s0_220 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp1_0 = s0_220 + tmp1_0;
    // Op 221: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_223 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_223; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 225: dim3x1 add
    gl64_t s1_225 = *(gl64_t*)&expressions_params[9][14];
    tmp3_0 = tmp3_0 + s1_225; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 226: dim3x3 add
    gl64_t s1_226_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_226_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_226_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_226_0; tmp3_1 = tmp3_1 + s1_226_1; tmp3_2 = tmp3_2 + s1_226_2;
    // Op 227: dim3x3 mul
    gl64_t s0_227_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_227_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_227_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    gl64_t kA227 = (s0_227_0 + s0_227_1) * (tmp3_0 + tmp3_1);
    gl64_t kB227 = (s0_227_0 + s0_227_2) * (tmp3_0 + tmp3_2);
    gl64_t kC227 = (s0_227_1 + s0_227_2) * (tmp3_1 + tmp3_2);
    gl64_t kD227 = s0_227_0 * tmp3_0;
    gl64_t kE227 = s0_227_1 * tmp3_1;
    gl64_t kF227 = s0_227_2 * tmp3_2;
    gl64_t kG227 = kD227 - kE227;
    tmp3_0 = (kC227 + kG227) - kF227;
    tmp3_1 = ((((kA227 + kC227) - kE227) - kE227) - kD227);
    tmp3_2 = kB227 - kG227;
    // Op 228: dim3x1 sub
    gl64_t s1_228 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 - s1_228; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 229: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 230: dim3x3 mul
    gl64_t s1_230_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_230_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_230_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA230 = (tmp3_0 + tmp3_1) * (s1_230_0 + s1_230_1);
    gl64_t kB230 = (tmp3_0 + tmp3_2) * (s1_230_0 + s1_230_2);
    gl64_t kC230 = (tmp3_1 + tmp3_2) * (s1_230_1 + s1_230_2);
    gl64_t kD230 = tmp3_0 * s1_230_0;
    gl64_t kE230 = tmp3_1 * s1_230_1;
    gl64_t kF230 = tmp3_2 * s1_230_2;
    gl64_t kG230 = kD230 - kE230;
    tmp3_3 = (kC230 + kG230) - kF230;
    tmp3_4 = ((((kA230 + kC230) - kE230) - kE230) - kD230);
    tmp3_5 = kB230 - kG230;
    // Op 231: dim1x1 sub_swap
    gl64_t s0_231 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_231 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s1_231 - s0_231;
    // Op 232: dim3x1 mul
    uint64_t s0_232_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_232_0 = *(gl64_t*)&dParams->aux_trace[s0_232_pos];
    gl64_t s0_232_1 = *(gl64_t*)&dParams->aux_trace[s0_232_pos + TILE_HEIGHT];
    gl64_t s0_232_2 = *(gl64_t*)&dParams->aux_trace[s0_232_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_232_0 * tmp1_0; tmp3_1 = s0_232_1 * tmp1_0; tmp3_2 = s0_232_2 * tmp1_0;
    // Op 233: dim3x3 sub
    uint64_t s0_233_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_233_0 = *(gl64_t*)&dParams->aux_trace[s0_233_pos];
    gl64_t s0_233_1 = *(gl64_t*)&dParams->aux_trace[s0_233_pos + TILE_HEIGHT];
    gl64_t s0_233_2 = *(gl64_t*)&dParams->aux_trace[s0_233_pos + 2*TILE_HEIGHT];
    tmp3_12 = s0_233_0 - tmp3_0; tmp3_13 = s0_233_1 - tmp3_1; tmp3_14 = s0_233_2 - tmp3_2;
    // Op 234: dim3x3 add
    gl64_t s0_234_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_234_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_234_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_234_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_234_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_234_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_0 = s0_234_0 + s1_234_0; tmp3_1 = s0_234_1 + s1_234_1; tmp3_2 = s0_234_2 + s1_234_2;
    // Op 235: dim3x3 add
    uint64_t s0_235_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_235_0 = *(gl64_t*)&dParams->aux_trace[s0_235_pos];
    gl64_t s0_235_1 = *(gl64_t*)&dParams->aux_trace[s0_235_pos + TILE_HEIGHT];
    gl64_t s0_235_2 = *(gl64_t*)&dParams->aux_trace[s0_235_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_235_0 + tmp3_0; tmp3_1 = s0_235_1 + tmp3_1; tmp3_2 = s0_235_2 + tmp3_2;
    // Op 236: dim3x3 add
    uint64_t s0_236_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_236_0 = *(gl64_t*)&dParams->aux_trace[s0_236_pos];
    gl64_t s0_236_1 = *(gl64_t*)&dParams->aux_trace[s0_236_pos + TILE_HEIGHT];
    gl64_t s0_236_2 = *(gl64_t*)&dParams->aux_trace[s0_236_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_236_0 + tmp3_0; tmp3_1 = s0_236_1 + tmp3_1; tmp3_2 = s0_236_2 + tmp3_2;
    // Op 237: dim3x3 add
    gl64_t s0_237_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_237_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_237_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    tmp3_0 = s0_237_0 + tmp3_0; tmp3_1 = s0_237_1 + tmp3_1; tmp3_2 = s0_237_2 + tmp3_2;
    // Op 238: dim3x3 sub
    tmp3_12 = tmp3_12 - tmp3_0; tmp3_13 = tmp3_13 - tmp3_1; tmp3_14 = tmp3_14 - tmp3_2;
    // Op 239: dim3x1 mul
    gl64_t s0_239_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_239_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_239_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_239 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp3_0 = s0_239_0 * s1_239; tmp3_1 = s0_239_1 * s1_239; tmp3_2 = s0_239_2 * s1_239;
    // Op 240: dim3x1 add
    gl64_t s1_240 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
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
    // Op 242: dim3x1 add
    gl64_t s1_242 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_242; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 243: dim3x3 mul
    gl64_t s1_243_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_243_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_243_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA243 = (tmp3_0 + tmp3_1) * (s1_243_0 + s1_243_1);
    gl64_t kB243 = (tmp3_0 + tmp3_2) * (s1_243_0 + s1_243_2);
    gl64_t kC243 = (tmp3_1 + tmp3_2) * (s1_243_1 + s1_243_2);
    gl64_t kD243 = tmp3_0 * s1_243_0;
    gl64_t kE243 = tmp3_1 * s1_243_1;
    gl64_t kF243 = tmp3_2 * s1_243_2;
    gl64_t kG243 = kD243 - kE243;
    tmp3_0 = (kC243 + kG243) - kF243;
    tmp3_1 = ((((kA243 + kC243) - kE243) - kE243) - kD243);
    tmp3_2 = kB243 - kG243;
    // Op 244: dim3x1 add
    gl64_t s1_244 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
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
    gl64_t s1_246 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_246; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 247: dim3x3 mul
    gl64_t s1_247_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_247_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_247_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA247 = (tmp3_0 + tmp3_1) * (s1_247_0 + s1_247_1);
    gl64_t kB247 = (tmp3_0 + tmp3_2) * (s1_247_0 + s1_247_2);
    gl64_t kC247 = (tmp3_1 + tmp3_2) * (s1_247_1 + s1_247_2);
    gl64_t kD247 = tmp3_0 * s1_247_0;
    gl64_t kE247 = tmp3_1 * s1_247_1;
    gl64_t kF247 = tmp3_2 * s1_247_2;
    gl64_t kG247 = kD247 - kE247;
    tmp3_0 = (kC247 + kG247) - kF247;
    tmp3_1 = ((((kA247 + kC247) - kE247) - kE247) - kD247);
    tmp3_2 = kB247 - kG247;
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
    gl64_t s1_249 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
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
    gl64_t s1_251 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_251; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 252: dim3x3 add
    gl64_t s1_252_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_252_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_252_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_252_0; tmp3_1 = tmp3_1 + s1_252_1; tmp3_2 = tmp3_2 + s1_252_2;
    // Op 253: dim3x3 mul
    gl64_t kA253 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB253 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC253 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD253 = tmp3_12 * tmp3_0;
    gl64_t kE253 = tmp3_13 * tmp3_1;
    gl64_t kF253 = tmp3_14 * tmp3_2;
    gl64_t kG253 = kD253 - kE253;
    tmp3_0 = (kC253 + kG253) - kF253;
    tmp3_1 = ((((kA253 + kC253) - kE253) - kE253) - kD253);
    tmp3_2 = kB253 - kG253;
    // Op 254: dim3x1 add
    gl64_t s1_254 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_254; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 255: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
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
    tmp3_3 = (kC256 + kG256) - kF256;
    tmp3_4 = ((((kA256 + kC256) - kE256) - kE256) - kD256);
    tmp3_5 = kB256 - kG256;
    // Op 257: dim3x1 mul
    gl64_t s0_257_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_257_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_257_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_257 = *(gl64_t*)&expressions_params[9][15];
    tmp3_0 = s0_257_0 * s1_257; tmp3_1 = s0_257_1 * s1_257; tmp3_2 = s0_257_2 * s1_257;
    // Op 258: dim3x1 add
    gl64_t s1_258 = *(gl64_t*)&expressions_params[9][14];
    tmp3_0 = tmp3_0 + s1_258; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 259: dim3x3 add
    gl64_t s1_259_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_259_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_259_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_259_0; tmp3_1 = tmp3_1 + s1_259_1; tmp3_2 = tmp3_2 + s1_259_2;
    // Op 260: dim3x3 mul
    gl64_t s1_260_0 = *(gl64_t*)&expressions_params[10][1];
    gl64_t s1_260_1 = *(gl64_t*)&expressions_params[10][1+1];
    gl64_t s1_260_2 = *(gl64_t*)&expressions_params[10][1+2];
    gl64_t kA260 = (tmp3_0 + tmp3_1) * (s1_260_0 + s1_260_1);
    gl64_t kB260 = (tmp3_0 + tmp3_2) * (s1_260_0 + s1_260_2);
    gl64_t kC260 = (tmp3_1 + tmp3_2) * (s1_260_1 + s1_260_2);
    gl64_t kD260 = tmp3_0 * s1_260_0;
    gl64_t kE260 = tmp3_1 * s1_260_1;
    gl64_t kF260 = tmp3_2 * s1_260_2;
    gl64_t kG260 = kD260 - kE260;
    tmp3_0 = (kC260 + kG260) - kF260;
    tmp3_1 = ((((kA260 + kC260) - kE260) - kE260) - kD260);
    tmp3_2 = kB260 - kG260;
    // Op 261: dim1x1 sub
    gl64_t s0_261 = *(gl64_t*)&expressions_params[9][9];
    gl64_t s1_261 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_261 - s1_261;
    // Op 262: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 263: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
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
    // Op 265: dim3x3 sub_swap
    uint64_t s0_265_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_265_0 = *(gl64_t*)&dParams->aux_trace[s0_265_pos];
    gl64_t s0_265_1 = *(gl64_t*)&dParams->aux_trace[s0_265_pos + TILE_HEIGHT];
    gl64_t s0_265_2 = *(gl64_t*)&dParams->aux_trace[s0_265_pos + 2*TILE_HEIGHT];
    gl64_t s1_265_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_265_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_265_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_0 = s1_265_0 - s0_265_0; tmp3_1 = s1_265_1 - s0_265_1; tmp3_2 = s1_265_2 - s0_265_2;
    // Op 266: dim3x3 sub
    gl64_t s1_266_0 = *(gl64_t*)&expressions_params[10][1];
    gl64_t s1_266_1 = *(gl64_t*)&expressions_params[10][1+1];
    gl64_t s1_266_2 = *(gl64_t*)&expressions_params[10][1+2];
    tmp3_0 = tmp3_0 - s1_266_0; tmp3_1 = tmp3_1 - s1_266_1; tmp3_2 = tmp3_2 - s1_266_2;
    // Op 267: dim3x1 mul
    gl64_t s1_267 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_267; tmp3_1 = tmp3_1 * s1_267; tmp3_2 = tmp3_2 * s1_267;
    // Op 268: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 269: dim3x1 mul
    gl64_t s1_269 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_269; tmp3_1 = tmp3_1 * s1_269; tmp3_2 = tmp3_2 * s1_269;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
