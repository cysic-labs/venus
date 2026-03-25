// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: b8aa312d  nOps=36 nTemp1=1 nTemp3=2
#define GENERATED_EVAL_NOPS_b8aa312d 36
#define GENERATED_EVAL_NTEMP1_b8aa312d 1
#define GENERATED_EVAL_NTEMP3_b8aa312d 2

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_b8aa312d(
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

    // Register-resident temporaries: 1 tmp1 + 6 tmp3 slots
    gl64_t tmp1_0 = gl64_t(uint64_t(0));
    gl64_t tmp3_0 = gl64_t(uint64_t(0));
    gl64_t tmp3_1 = gl64_t(uint64_t(0));
    gl64_t tmp3_2 = gl64_t(uint64_t(0));
    gl64_t tmp3_3 = gl64_t(uint64_t(0));
    gl64_t tmp3_4 = gl64_t(uint64_t(0));
    gl64_t tmp3_5 = gl64_t(uint64_t(0));

    // Op 0: dim3x1 mul
    gl64_t s0_0_0 = *(gl64_t*)&expressions_params[14][0];
    gl64_t s0_0_1 = *(gl64_t*)&expressions_params[14][0+1];
    gl64_t s0_0_2 = *(gl64_t*)&expressions_params[14][0+2];
    gl64_t s1_0 = *(gl64_t*)&dParams->pCustomCommitsFixed[dExpsArgs->mapOffsetsCustomExps[0] + getBufferOffset(logicalRow_1, 10, domainSize, dArgs->mapSectionsNCustomFixed[0])];
    tmp3_0 = s0_0_0 * s1_0; tmp3_1 = s0_0_1 * s1_0; tmp3_2 = s0_0_2 * s1_0;
    // Op 1: dim3x1 add
    gl64_t s1_1 = *(gl64_t*)&dParams->pCustomCommitsFixed[dExpsArgs->mapOffsetsCustomExps[0] + getBufferOffset(logicalRow_1, 9, domainSize, dArgs->mapSectionsNCustomFixed[0])];
    tmp3_0 = tmp3_0 + s1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2: dim3x3 mul
    gl64_t s1_2_0 = *(gl64_t*)&expressions_params[14][0];
    gl64_t s1_2_1 = *(gl64_t*)&expressions_params[14][0+1];
    gl64_t s1_2_2 = *(gl64_t*)&expressions_params[14][0+2];
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
    gl64_t s1_3 = *(gl64_t*)&dParams->pCustomCommitsFixed[dExpsArgs->mapOffsetsCustomExps[0] + getBufferOffset(logicalRow_1, 8, domainSize, dArgs->mapSectionsNCustomFixed[0])];
    tmp3_0 = tmp3_0 + s1_3; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 4: dim3x3 mul
    gl64_t s1_4_0 = *(gl64_t*)&expressions_params[14][0];
    gl64_t s1_4_1 = *(gl64_t*)&expressions_params[14][0+1];
    gl64_t s1_4_2 = *(gl64_t*)&expressions_params[14][0+2];
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
    gl64_t s1_5 = *(gl64_t*)&dParams->pCustomCommitsFixed[dExpsArgs->mapOffsetsCustomExps[0] + getBufferOffset(logicalRow_1, 7, domainSize, dArgs->mapSectionsNCustomFixed[0])];
    tmp3_0 = tmp3_0 + s1_5; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 6: dim3x3 mul
    gl64_t s1_6_0 = *(gl64_t*)&expressions_params[14][0];
    gl64_t s1_6_1 = *(gl64_t*)&expressions_params[14][0+1];
    gl64_t s1_6_2 = *(gl64_t*)&expressions_params[14][0+2];
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
    gl64_t s1_7 = *(gl64_t*)&dParams->pCustomCommitsFixed[dExpsArgs->mapOffsetsCustomExps[0] + getBufferOffset(logicalRow_1, 6, domainSize, dArgs->mapSectionsNCustomFixed[0])];
    tmp3_0 = tmp3_0 + s1_7; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 8: dim3x3 mul
    gl64_t s1_8_0 = *(gl64_t*)&expressions_params[14][0];
    gl64_t s1_8_1 = *(gl64_t*)&expressions_params[14][0+1];
    gl64_t s1_8_2 = *(gl64_t*)&expressions_params[14][0+2];
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
    gl64_t s1_9 = *(gl64_t*)&dParams->pCustomCommitsFixed[dExpsArgs->mapOffsetsCustomExps[0] + getBufferOffset(logicalRow_1, 5, domainSize, dArgs->mapSectionsNCustomFixed[0])];
    tmp3_0 = tmp3_0 + s1_9; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 10: dim3x3 mul
    gl64_t s1_10_0 = *(gl64_t*)&expressions_params[14][0];
    gl64_t s1_10_1 = *(gl64_t*)&expressions_params[14][0+1];
    gl64_t s1_10_2 = *(gl64_t*)&expressions_params[14][0+2];
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
    gl64_t s1_11 = *(gl64_t*)&dParams->pCustomCommitsFixed[dExpsArgs->mapOffsetsCustomExps[0] + getBufferOffset(logicalRow_1, 4, domainSize, dArgs->mapSectionsNCustomFixed[0])];
    tmp3_0 = tmp3_0 + s1_11; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 12: dim3x3 mul
    gl64_t s1_12_0 = *(gl64_t*)&expressions_params[14][0];
    gl64_t s1_12_1 = *(gl64_t*)&expressions_params[14][0+1];
    gl64_t s1_12_2 = *(gl64_t*)&expressions_params[14][0+2];
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
    gl64_t s1_13 = *(gl64_t*)&dParams->pCustomCommitsFixed[dExpsArgs->mapOffsetsCustomExps[0] + getBufferOffset(logicalRow_1, 3, domainSize, dArgs->mapSectionsNCustomFixed[0])];
    tmp3_0 = tmp3_0 + s1_13; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 14: dim3x3 mul
    gl64_t s1_14_0 = *(gl64_t*)&expressions_params[14][0];
    gl64_t s1_14_1 = *(gl64_t*)&expressions_params[14][0+1];
    gl64_t s1_14_2 = *(gl64_t*)&expressions_params[14][0+2];
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
    // Op 15: dim3x1 add
    gl64_t s1_15 = *(gl64_t*)&dParams->pCustomCommitsFixed[dExpsArgs->mapOffsetsCustomExps[0] + getBufferOffset(logicalRow_1, 2, domainSize, dArgs->mapSectionsNCustomFixed[0])];
    tmp3_0 = tmp3_0 + s1_15; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 16: dim3x3 mul
    gl64_t s1_16_0 = *(gl64_t*)&expressions_params[14][0];
    gl64_t s1_16_1 = *(gl64_t*)&expressions_params[14][0+1];
    gl64_t s1_16_2 = *(gl64_t*)&expressions_params[14][0+2];
    gl64_t kA16 = (tmp3_0 + tmp3_1) * (s1_16_0 + s1_16_1);
    gl64_t kB16 = (tmp3_0 + tmp3_2) * (s1_16_0 + s1_16_2);
    gl64_t kC16 = (tmp3_1 + tmp3_2) * (s1_16_1 + s1_16_2);
    gl64_t kD16 = tmp3_0 * s1_16_0;
    gl64_t kE16 = tmp3_1 * s1_16_1;
    gl64_t kF16 = tmp3_2 * s1_16_2;
    gl64_t kG16 = kD16 - kE16;
    tmp3_0 = (kC16 + kG16) - kF16;
    tmp3_1 = ((((kA16 + kC16) - kE16) - kE16) - kD16);
    tmp3_2 = kB16 - kG16;
    // Op 17: dim3x1 add
    gl64_t s1_17 = *(gl64_t*)&dParams->pCustomCommitsFixed[dExpsArgs->mapOffsetsCustomExps[0] + getBufferOffset(logicalRow_1, 1, domainSize, dArgs->mapSectionsNCustomFixed[0])];
    tmp3_0 = tmp3_0 + s1_17; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 18: dim3x3 mul
    gl64_t s1_18_0 = *(gl64_t*)&expressions_params[14][0];
    gl64_t s1_18_1 = *(gl64_t*)&expressions_params[14][0+1];
    gl64_t s1_18_2 = *(gl64_t*)&expressions_params[14][0+2];
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
    // Op 19: dim3x1 add
    gl64_t s1_19 = *(gl64_t*)&dParams->pCustomCommitsFixed[dExpsArgs->mapOffsetsCustomExps[0] + getBufferOffset(logicalRow_1, 0, domainSize, dArgs->mapSectionsNCustomFixed[0])];
    tmp3_0 = tmp3_0 + s1_19; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 20: dim3x3 mul
    gl64_t s1_20_0 = *(gl64_t*)&expressions_params[14][0];
    gl64_t s1_20_1 = *(gl64_t*)&expressions_params[14][0+1];
    gl64_t s1_20_2 = *(gl64_t*)&expressions_params[14][0+2];
    gl64_t kA20 = (tmp3_0 + tmp3_1) * (s1_20_0 + s1_20_1);
    gl64_t kB20 = (tmp3_0 + tmp3_2) * (s1_20_0 + s1_20_2);
    gl64_t kC20 = (tmp3_1 + tmp3_2) * (s1_20_1 + s1_20_2);
    gl64_t kD20 = tmp3_0 * s1_20_0;
    gl64_t kE20 = tmp3_1 * s1_20_1;
    gl64_t kF20 = tmp3_2 * s1_20_2;
    gl64_t kG20 = kD20 - kE20;
    tmp3_0 = (kC20 + kG20) - kF20;
    tmp3_1 = ((((kA20 + kC20) - kE20) - kE20) - kD20);
    tmp3_2 = kB20 - kG20;
    // Op 21: dim3x1 add
    gl64_t s1_21 = *(gl64_t*)&expressions_params[10][1];
    tmp3_0 = tmp3_0 + s1_21; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 22: dim3x3 add
    gl64_t s1_22_0 = *(gl64_t*)&expressions_params[14][3];
    gl64_t s1_22_1 = *(gl64_t*)&expressions_params[14][3+1];
    gl64_t s1_22_2 = *(gl64_t*)&expressions_params[14][3+2];
    tmp3_0 = tmp3_0 + s1_22_0; tmp3_1 = tmp3_1 + s1_22_1; tmp3_2 = tmp3_2 + s1_22_2;
    // Op 23: dim3x3 mul
    gl64_t s0_23_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_23_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_23_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA23 = (s0_23_0 + s0_23_1) * (tmp3_0 + tmp3_1);
    gl64_t kB23 = (s0_23_0 + s0_23_2) * (tmp3_0 + tmp3_2);
    gl64_t kC23 = (s0_23_1 + s0_23_2) * (tmp3_1 + tmp3_2);
    gl64_t kD23 = s0_23_0 * tmp3_0;
    gl64_t kE23 = s0_23_1 * tmp3_1;
    gl64_t kF23 = s0_23_2 * tmp3_2;
    gl64_t kG23 = kD23 - kE23;
    tmp3_0 = (kC23 + kG23) - kF23;
    tmp3_1 = ((((kA23 + kC23) - kE23) - kE23) - kD23);
    tmp3_2 = kB23 - kG23;
    // Op 24: dim3x1 sub
    gl64_t s1_24 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 - s1_24; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 25: dim3x3 mul
    gl64_t s1_25_0 = *(gl64_t*)&expressions_params[14][6];
    gl64_t s1_25_1 = *(gl64_t*)&expressions_params[14][6+1];
    gl64_t s1_25_2 = *(gl64_t*)&expressions_params[14][6+2];
    gl64_t kA25 = (tmp3_0 + tmp3_1) * (s1_25_0 + s1_25_1);
    gl64_t kB25 = (tmp3_0 + tmp3_2) * (s1_25_0 + s1_25_2);
    gl64_t kC25 = (tmp3_1 + tmp3_2) * (s1_25_1 + s1_25_2);
    gl64_t kD25 = tmp3_0 * s1_25_0;
    gl64_t kE25 = tmp3_1 * s1_25_1;
    gl64_t kF25 = tmp3_2 * s1_25_2;
    gl64_t kG25 = kD25 - kE25;
    tmp3_3 = (kC25 + kG25) - kF25;
    tmp3_4 = ((((kA25 + kC25) - kE25) - kE25) - kD25);
    tmp3_5 = kB25 - kG25;
    // Op 26: dim3x3 sub_swap
    uint64_t s0_26_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_26_0 = *(gl64_t*)&dParams->aux_trace[s0_26_pos];
    gl64_t s0_26_1 = *(gl64_t*)&dParams->aux_trace[s0_26_pos + TILE_HEIGHT];
    gl64_t s0_26_2 = *(gl64_t*)&dParams->aux_trace[s0_26_pos + 2*TILE_HEIGHT];
    gl64_t s1_26_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_26_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_26_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s1_26_0 - s0_26_0; tmp3_1 = s1_26_1 - s0_26_1; tmp3_2 = s1_26_2 - s0_26_2;
    // Op 27: dim3x1 mul
    gl64_t s1_27 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_27; tmp3_1 = tmp3_1 * s1_27; tmp3_2 = tmp3_2 * s1_27;
    // Op 28: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 29: dim3x3 mul
    gl64_t s1_29_0 = *(gl64_t*)&expressions_params[14][6];
    gl64_t s1_29_1 = *(gl64_t*)&expressions_params[14][6+1];
    gl64_t s1_29_2 = *(gl64_t*)&expressions_params[14][6+2];
    gl64_t kA29 = (tmp3_0 + tmp3_1) * (s1_29_0 + s1_29_1);
    gl64_t kB29 = (tmp3_0 + tmp3_2) * (s1_29_0 + s1_29_2);
    gl64_t kC29 = (tmp3_1 + tmp3_2) * (s1_29_1 + s1_29_2);
    gl64_t kD29 = tmp3_0 * s1_29_0;
    gl64_t kE29 = tmp3_1 * s1_29_1;
    gl64_t kF29 = tmp3_2 * s1_29_2;
    gl64_t kG29 = kD29 - kE29;
    tmp3_3 = (kC29 + kG29) - kF29;
    tmp3_4 = ((((kA29 + kC29) - kE29) - kE29) - kD29);
    tmp3_5 = kB29 - kG29;
    // Op 30: dim1x1 sub_swap
    gl64_t s0_30 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_30 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s1_30 - s0_30;
    // Op 31: dim3x1 mul
    uint64_t s0_31_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_31_0 = *(gl64_t*)&dParams->aux_trace[s0_31_pos];
    gl64_t s0_31_1 = *(gl64_t*)&dParams->aux_trace[s0_31_pos + TILE_HEIGHT];
    gl64_t s0_31_2 = *(gl64_t*)&dParams->aux_trace[s0_31_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_31_0 * tmp1_0; tmp3_1 = s0_31_1 * tmp1_0; tmp3_2 = s0_31_2 * tmp1_0;
    // Op 32: dim3x3 sub
    uint64_t s0_32_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_32_0 = *(gl64_t*)&dParams->aux_trace[s0_32_pos];
    gl64_t s0_32_1 = *(gl64_t*)&dParams->aux_trace[s0_32_pos + TILE_HEIGHT];
    gl64_t s0_32_2 = *(gl64_t*)&dParams->aux_trace[s0_32_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_32_0 - tmp3_0; tmp3_1 = s0_32_1 - tmp3_1; tmp3_2 = s0_32_2 - tmp3_2;
    // Op 33: dim3x3 sub
    gl64_t s0_33_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_33_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_33_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    tmp3_0 = s0_33_0 - tmp3_0; tmp3_1 = s0_33_1 - tmp3_1; tmp3_2 = s0_33_2 - tmp3_2;
    // Op 34: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 35: dim3x1 mul
    gl64_t s1_35 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_35; tmp3_1 = tmp3_1 * s1_35; tmp3_2 = tmp3_2 * s1_35;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
