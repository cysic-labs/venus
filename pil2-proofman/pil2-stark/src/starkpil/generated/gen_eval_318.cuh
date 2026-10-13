// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: 9c9cd96d  nOps=243 nTemp1=5 nTemp3=5
#define GENERATED_EVAL_NOPS_9c9cd96d 243
#define GENERATED_EVAL_NTEMP1_9c9cd96d 5
#define GENERATED_EVAL_NTEMP3_9c9cd96d 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_9c9cd96d(
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
    gl64_t s1_3 = *(gl64_t*)&expressions_params[10][2];
    tmp1_0 = s0_3 - s1_3;
    // Op 4: dim1x1 mul
    gl64_t s1_4 = *(gl64_t*)&expressions_params[10][2];
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
    // Op 7: dim1x1 mul
    gl64_t s0_7 = *(gl64_t*)&expressions_params[10][1];
    gl64_t s1_7 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_7 * s1_7;
    // Op 8: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 9: dim3x3 mul
    gl64_t s1_9_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_9_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_9_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 10: dim1x1 sub_swap
    gl64_t s0_10 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_10 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_10 - s0_10;
    // Op 11: dim1x1 mul
    gl64_t s0_11 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_11 * tmp1_0;
    // Op 12: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 13: dim3x3 mul
    gl64_t s1_13_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_13_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_13_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA13 = (tmp3_0 + tmp3_1) * (s1_13_0 + s1_13_1);
    gl64_t kB13 = (tmp3_0 + tmp3_2) * (s1_13_0 + s1_13_2);
    gl64_t kC13 = (tmp3_1 + tmp3_2) * (s1_13_1 + s1_13_2);
    gl64_t kD13 = tmp3_0 * s1_13_0;
    gl64_t kE13 = tmp3_1 * s1_13_1;
    gl64_t kF13 = tmp3_2 * s1_13_2;
    gl64_t kG13 = kD13 - kE13;
    tmp3_0 = (kC13 + kG13) - kF13;
    tmp3_1 = ((((kA13 + kC13) - kE13) - kE13) - kD13);
    tmp3_2 = kB13 - kG13;
    // Op 14: dim1x1 sub_swap
    gl64_t s0_14 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_14 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_14 - s0_14;
    // Op 15: dim1x1 mul
    gl64_t s0_15 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_15 * tmp1_0;
    // Op 16: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 17: dim3x3 mul
    gl64_t s1_17_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_17_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_17_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 18: dim1x1 sub_swap
    gl64_t s0_18 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_18 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_18 - s0_18;
    // Op 19: dim1x1 mul
    gl64_t s0_19 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_19 * tmp1_0;
    // Op 20: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 21: dim3x3 mul
    gl64_t s1_21_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_21_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_21_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 22: dim1x1 sub_swap
    gl64_t s0_22 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_22 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s1_22 - s0_22;
    // Op 23: dim1x1 mul
    gl64_t s0_23 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_23 * tmp1_0;
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
    gl64_t s0_26 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_26 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_26 * s1_26;
    // Op 27: dim1x1 add
    gl64_t s0_27 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_2 = s0_27 + tmp1_0;
    // Op 28: dim1x1 sub
    gl64_t s1_28 = *(gl64_t*)&expressions_params[10][7];
    tmp1_0 = tmp1_2 - s1_28;
    // Op 29: dim1x1 mul
    gl64_t s0_29 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_29 * tmp1_0;
    // Op 30: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 31: dim3x3 mul
    gl64_t s1_31_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_31_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_31_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 32: dim1x1 mul
    gl64_t s0_32 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_32 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_32 * s1_32;
    // Op 33: dim1x1 add
    gl64_t s0_33 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_3 = s0_33 + tmp1_0;
    // Op 34: dim1x1 sub
    gl64_t s1_34 = *(gl64_t*)&expressions_params[10][8];
    tmp1_0 = tmp1_3 - s1_34;
    // Op 35: dim1x1 mul
    gl64_t s0_35 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_35 * tmp1_0;
    // Op 36: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 37: dim3x3 mul
    gl64_t s1_37_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_37_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_37_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA37 = (tmp3_0 + tmp3_1) * (s1_37_0 + s1_37_1);
    gl64_t kB37 = (tmp3_0 + tmp3_2) * (s1_37_0 + s1_37_2);
    gl64_t kC37 = (tmp3_1 + tmp3_2) * (s1_37_1 + s1_37_2);
    gl64_t kD37 = tmp3_0 * s1_37_0;
    gl64_t kE37 = tmp3_1 * s1_37_1;
    gl64_t kF37 = tmp3_2 * s1_37_2;
    gl64_t kG37 = kD37 - kE37;
    tmp3_0 = (kC37 + kG37) - kF37;
    tmp3_1 = ((((kA37 + kC37) - kE37) - kE37) - kD37);
    tmp3_2 = kB37 - kG37;
    // Op 38: dim1x1 sub
    gl64_t s0_38 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_38 = *(gl64_t*)&expressions_params[10][10];
    tmp1_0 = s0_38 - s1_38;
    // Op 39: dim1x1 mul
    gl64_t s0_39 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_39 * tmp1_0;
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
    // Op 42: dim1x1 sub
    gl64_t s0_42 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_42 = *(gl64_t*)&expressions_params[10][9];
    tmp1_0 = s0_42 - s1_42;
    // Op 43: dim1x1 mul
    gl64_t s0_43 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_43 * tmp1_0;
    // Op 44: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 45: dim3x3 mul
    gl64_t s1_45_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_45_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_45_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 46: dim1x1 sub_swap
    gl64_t s0_46 = *(gl64_t*)&expressions_params[9][10];
    gl64_t s1_46 = *(gl64_t*)&expressions_params[10][6];
    tmp1_1 = s1_46 - s0_46;
    // Op 47: dim1x1 mul
    gl64_t s0_47 = *(gl64_t*)&expressions_params[9][3];
    gl64_t s1_47 = *(gl64_t*)&expressions_params[10][12];
    tmp1_0 = s0_47 * s1_47;
    // Op 48: dim1x1 add
    gl64_t s1_48 = *(gl64_t*)&expressions_params[10][11];
    tmp1_0 = tmp1_0 + s1_48;
    // Op 49: dim1x1 sub
    tmp1_0 = tmp1_1 - tmp1_0;
    // Op 50: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 51: dim3x3 mul
    gl64_t s1_51_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_51_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_51_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 52: dim1x1 sub
    gl64_t s0_52 = *(gl64_t*)&expressions_params[9][11];
    gl64_t s1_52 = *(gl64_t*)&expressions_params[10][10];
    tmp1_1 = s0_52 - s1_52;
    // Op 53: dim1x1 mul
    gl64_t s0_53 = *(gl64_t*)&expressions_params[9][3];
    gl64_t s1_53 = *(gl64_t*)&expressions_params[10][14];
    tmp1_0 = s0_53 * s1_53;
    // Op 54: dim1x1 add
    gl64_t s1_54 = *(gl64_t*)&expressions_params[10][13];
    tmp1_0 = tmp1_0 + s1_54;
    // Op 55: dim1x1 sub
    tmp1_0 = tmp1_1 - tmp1_0;
    // Op 56: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 57: dim3x3 mul
    gl64_t s1_57_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_57_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_57_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 58: dim1x1 sub_swap
    gl64_t s0_58 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_58 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s1_58 - s0_58;
    // Op 59: dim1x1 sub_swap
    gl64_t s0_59 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_1))];
    gl64_t s1_59 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s1_59 - s0_59;
    // Op 60: dim1x1 mul
    gl64_t s0_60 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_0 = s0_60 * tmp1_0;
    // Op 61: dim1x1 add
    gl64_t s0_61 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_1))];
    tmp1_4 = s0_61 + tmp1_0;
    // Op 62: dim1x1 sub
    gl64_t s0_62 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_62 - tmp1_4;
    // Op 63: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 64: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 65: dim3x3 mul
    gl64_t s1_65_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_65_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_65_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 66: dim1x1 mul
    gl64_t s0_66 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 5, domainSize, nCols_1))];
    gl64_t s1_66 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_66 * s1_66;
    // Op 67: dim1x1 add
    gl64_t s0_67 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 4, domainSize, nCols_1))];
    tmp1_1 = s0_67 + tmp1_0;
    // Op 68: dim1x1 sub_swap
    gl64_t s1_68 = *(gl64_t*)&expressions_params[10][3];
    tmp1_0 = s1_68 - tmp1_1;
    // Op 69: dim1x1 mul
    gl64_t s0_69 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_0 = s0_69 * tmp1_0;
    // Op 70: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 71: dim1x1 sub
    tmp1_0 = tmp1_2 - tmp1_0;
    // Op 72: dim1x1 mul
    gl64_t s0_72 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2))];
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
    // Op 75: dim1x1 mul
    gl64_t s0_75 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 7, domainSize, nCols_1))];
    gl64_t s1_75 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_75 * s1_75;
    // Op 76: dim1x1 add
    gl64_t s0_76 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 6, domainSize, nCols_1))];
    tmp1_2 = s0_76 + tmp1_0;
    // Op 77: dim1x1 sub_swap
    gl64_t s1_77 = *(gl64_t*)&expressions_params[10][4];
    tmp1_0 = s1_77 - tmp1_2;
    // Op 78: dim1x1 mul
    gl64_t s0_78 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_0 = s0_78 * tmp1_0;
    // Op 79: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 80: dim1x1 sub
    tmp1_0 = tmp1_3 - tmp1_0;
    // Op 81: dim1x1 mul
    gl64_t s0_81 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_2))];
    tmp1_0 = s0_81 * tmp1_0;
    // Op 82: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 83: dim3x3 mul
    gl64_t s1_83_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_83_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_83_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA83 = (tmp3_0 + tmp3_1) * (s1_83_0 + s1_83_1);
    gl64_t kB83 = (tmp3_0 + tmp3_2) * (s1_83_0 + s1_83_2);
    gl64_t kC83 = (tmp3_1 + tmp3_2) * (s1_83_1 + s1_83_2);
    gl64_t kD83 = tmp3_0 * s1_83_0;
    gl64_t kE83 = tmp3_1 * s1_83_1;
    gl64_t kF83 = tmp3_2 * s1_83_2;
    gl64_t kG83 = kD83 - kE83;
    tmp3_12 = (kC83 + kG83) - kF83;
    tmp3_13 = ((((kA83 + kC83) - kE83) - kE83) - kD83);
    tmp3_14 = kB83 - kG83;
    // Op 84: dim3x1 mul
    gl64_t s0_84_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_84_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_84_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_84 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp3_0 = s0_84_0 * s1_84; tmp3_1 = s0_84_1 * s1_84; tmp3_2 = s0_84_2 * s1_84;
    // Op 85: dim3x1 add
    gl64_t s1_85 = *(gl64_t*)&expressions_params[9][1];
    tmp3_9 = tmp3_0 + s1_85; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 86: dim3x3 add
    gl64_t s1_86_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_86_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_86_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_86_0; tmp3_4 = tmp3_10 + s1_86_1; tmp3_5 = tmp3_11 + s1_86_2;
    // Op 87: dim3x1 mul
    gl64_t s0_87_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_87_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_87_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_87 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp3_0 = s0_87_0 * s1_87; tmp3_1 = s0_87_1 * s1_87; tmp3_2 = s0_87_2 * s1_87;
    // Op 88: dim3x1 add
    gl64_t s1_88 = *(gl64_t*)&expressions_params[9][1];
    tmp3_6 = tmp3_0 + s1_88; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 89: dim3x3 add
    gl64_t s1_89_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_89_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_89_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_89_0; tmp3_1 = tmp3_7 + s1_89_1; tmp3_2 = tmp3_8 + s1_89_2;
    // Op 90: dim3x3 mul
    gl64_t kA90 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB90 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC90 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD90 = tmp3_3 * tmp3_0;
    gl64_t kE90 = tmp3_4 * tmp3_1;
    gl64_t kF90 = tmp3_5 * tmp3_2;
    gl64_t kG90 = kD90 - kE90;
    tmp3_0 = (kC90 + kG90) - kF90;
    tmp3_1 = ((((kA90 + kC90) - kE90) - kE90) - kD90);
    tmp3_2 = kB90 - kG90;
    // Op 91: dim3x3 mul
    gl64_t s0_91_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_91_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_91_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA91 = (s0_91_0 + s0_91_1) * (tmp3_0 + tmp3_1);
    gl64_t kB91 = (s0_91_0 + s0_91_2) * (tmp3_0 + tmp3_2);
    gl64_t kC91 = (s0_91_1 + s0_91_2) * (tmp3_1 + tmp3_2);
    gl64_t kD91 = s0_91_0 * tmp3_0;
    gl64_t kE91 = s0_91_1 * tmp3_1;
    gl64_t kF91 = s0_91_2 * tmp3_2;
    gl64_t kG91 = kD91 - kE91;
    tmp3_0 = (kC91 + kG91) - kF91;
    tmp3_1 = ((((kA91 + kC91) - kE91) - kE91) - kD91);
    tmp3_2 = kB91 - kG91;
    // Op 92: dim3x3 add
    gl64_t s1_92_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_92_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_92_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_92_0; tmp3_7 = tmp3_7 + s1_92_1; tmp3_8 = tmp3_8 + s1_92_2;
    // Op 93: dim3x1 mul
    gl64_t s1_93 = *(gl64_t*)&expressions_params[9][2];
    tmp3_6 = tmp3_6 * s1_93; tmp3_7 = tmp3_7 * s1_93; tmp3_8 = tmp3_8 * s1_93;
    // Op 94: dim3x3 add
    gl64_t s1_94_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_94_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_94_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_94_0; tmp3_10 = tmp3_10 + s1_94_1; tmp3_11 = tmp3_11 + s1_94_2;
    // Op 95: dim3x1 mul
    gl64_t s1_95 = *(gl64_t*)&expressions_params[9][2];
    tmp3_9 = tmp3_9 * s1_95; tmp3_10 = tmp3_10 * s1_95; tmp3_11 = tmp3_11 * s1_95;
    // Op 96: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 97: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 98: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 99: dim3x3 mul
    gl64_t s1_99_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_99_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_99_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA99 = (tmp3_0 + tmp3_1) * (s1_99_0 + s1_99_1);
    gl64_t kB99 = (tmp3_0 + tmp3_2) * (s1_99_0 + s1_99_2);
    gl64_t kC99 = (tmp3_1 + tmp3_2) * (s1_99_1 + s1_99_2);
    gl64_t kD99 = tmp3_0 * s1_99_0;
    gl64_t kE99 = tmp3_1 * s1_99_1;
    gl64_t kF99 = tmp3_2 * s1_99_2;
    gl64_t kG99 = kD99 - kE99;
    tmp3_3 = (kC99 + kG99) - kF99;
    tmp3_4 = ((((kA99 + kC99) - kE99) - kE99) - kD99);
    tmp3_5 = kB99 - kG99;
    // Op 100: dim3x1 mul
    gl64_t s0_100_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_100_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_100_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_100 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp3_0 = s0_100_0 * s1_100; tmp3_1 = s0_100_1 * s1_100; tmp3_2 = s0_100_2 * s1_100;
    // Op 101: dim3x1 add
    gl64_t s1_101 = *(gl64_t*)&expressions_params[9][1];
    tmp3_9 = tmp3_0 + s1_101; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 102: dim3x3 add
    gl64_t s1_102_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_102_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_102_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_102_0; tmp3_13 = tmp3_10 + s1_102_1; tmp3_14 = tmp3_11 + s1_102_2;
    // Op 103: dim1x1 mul
    gl64_t s0_103 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_103 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_103 * s1_103;
    // Op 104: dim1x1 add
    gl64_t s0_104 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_104 + tmp1_0;
    // Op 105: dim3x1 mul
    gl64_t s0_105_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_105_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_105_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_105_0 * tmp1_0; tmp3_1 = s0_105_1 * tmp1_0; tmp3_2 = s0_105_2 * tmp1_0;
    // Op 106: dim1x1 mul
    gl64_t s0_106 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_106 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_106 * s1_106;
    // Op 107: dim1x1 add
    gl64_t s0_107 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_107 + tmp1_0;
    // Op 108: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_110 = *(gl64_t*)&expressions_params[9][4];
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
    gl64_t s1_112 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
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
    // Op 114: dim1x1 mul
    gl64_t s0_114 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_114 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s0_114 * s1_114;
    // Op 115: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 116: dim3x3 mul
    gl64_t s1_116_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_116_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_116_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 117: dim3x1 add
    gl64_t s1_117 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_117; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 118: dim3x3 mul
    gl64_t s1_118_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_118_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_118_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA118 = (tmp3_0 + tmp3_1) * (s1_118_0 + s1_118_1);
    gl64_t kB118 = (tmp3_0 + tmp3_2) * (s1_118_0 + s1_118_2);
    gl64_t kC118 = (tmp3_1 + tmp3_2) * (s1_118_1 + s1_118_2);
    gl64_t kD118 = tmp3_0 * s1_118_0;
    gl64_t kE118 = tmp3_1 * s1_118_1;
    gl64_t kF118 = tmp3_2 * s1_118_2;
    gl64_t kG118 = kD118 - kE118;
    tmp3_0 = (kC118 + kG118) - kF118;
    tmp3_1 = ((((kA118 + kC118) - kE118) - kE118) - kD118);
    tmp3_2 = kB118 - kG118;
    // Op 119: dim3x1 add
    gl64_t s1_119 = *(gl64_t*)&expressions_params[9][5];
    tmp3_6 = tmp3_0 + s1_119; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 120: dim3x3 add
    gl64_t s1_120_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_120_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_120_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_120_0; tmp3_1 = tmp3_7 + s1_120_1; tmp3_2 = tmp3_8 + s1_120_2;
    // Op 121: dim3x3 mul
    gl64_t kA121 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB121 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC121 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD121 = tmp3_12 * tmp3_0;
    gl64_t kE121 = tmp3_13 * tmp3_1;
    gl64_t kF121 = tmp3_14 * tmp3_2;
    gl64_t kG121 = kD121 - kE121;
    tmp3_0 = (kC121 + kG121) - kF121;
    tmp3_1 = ((((kA121 + kC121) - kE121) - kE121) - kD121);
    tmp3_2 = kB121 - kG121;
    // Op 122: dim3x3 mul
    gl64_t s0_122_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_122_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_122_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA122 = (s0_122_0 + s0_122_1) * (tmp3_0 + tmp3_1);
    gl64_t kB122 = (s0_122_0 + s0_122_2) * (tmp3_0 + tmp3_2);
    gl64_t kC122 = (s0_122_1 + s0_122_2) * (tmp3_1 + tmp3_2);
    gl64_t kD122 = s0_122_0 * tmp3_0;
    gl64_t kE122 = s0_122_1 * tmp3_1;
    gl64_t kF122 = s0_122_2 * tmp3_2;
    gl64_t kG122 = kD122 - kE122;
    tmp3_0 = (kC122 + kG122) - kF122;
    tmp3_1 = ((((kA122 + kC122) - kE122) - kE122) - kD122);
    tmp3_2 = kB122 - kG122;
    // Op 123: dim3x3 add
    gl64_t s1_123_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_123_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_123_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_123_0; tmp3_7 = tmp3_7 + s1_123_1; tmp3_8 = tmp3_8 + s1_123_2;
    // Op 124: dim3x1 mul
    gl64_t s1_124 = *(gl64_t*)&expressions_params[9][2];
    tmp3_6 = tmp3_6 * s1_124; tmp3_7 = tmp3_7 * s1_124; tmp3_8 = tmp3_8 * s1_124;
    // Op 125: dim3x3 add
    gl64_t s1_125_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_125_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_125_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_125_0; tmp3_10 = tmp3_10 + s1_125_1; tmp3_11 = tmp3_11 + s1_125_2;
    // Op 126: dim3x1 mul
    gl64_t s1_126 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_126; tmp3_10 = tmp3_10 * s1_126; tmp3_11 = tmp3_11 * s1_126;
    // Op 127: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 128: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 129: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 130: dim3x3 mul
    gl64_t s1_130_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_130_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_130_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA130 = (tmp3_0 + tmp3_1) * (s1_130_0 + s1_130_1);
    gl64_t kB130 = (tmp3_0 + tmp3_2) * (s1_130_0 + s1_130_2);
    gl64_t kC130 = (tmp3_1 + tmp3_2) * (s1_130_1 + s1_130_2);
    gl64_t kD130 = tmp3_0 * s1_130_0;
    gl64_t kE130 = tmp3_1 * s1_130_1;
    gl64_t kF130 = tmp3_2 * s1_130_2;
    gl64_t kG130 = kD130 - kE130;
    tmp3_3 = (kC130 + kG130) - kF130;
    tmp3_4 = ((((kA130 + kC130) - kE130) - kE130) - kD130);
    tmp3_5 = kB130 - kG130;
    // Op 131: dim1x1 sub
    gl64_t s0_131 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_4 = s0_131 - tmp1_4;
    // Op 132: dim1x1 sub
    gl64_t s1_132 = *(gl64_t*)&expressions_params[9][0];
    tmp1_4 = tmp1_4 - s1_132;
    // Op 133: dim3x1 mul
    gl64_t s0_133_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_133_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_133_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_133_0 * tmp1_4; tmp3_1 = s0_133_1 * tmp1_4; tmp3_2 = s0_133_2 * tmp1_4;
    // Op 134: dim3x1 add
    gl64_t s1_134 = *(gl64_t*)&expressions_params[9][6];
    tmp3_0 = tmp3_0 + s1_134; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 135: dim3x3 add
    gl64_t s1_135_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_135_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_135_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_135_0; tmp3_1 = tmp3_1 + s1_135_1; tmp3_2 = tmp3_2 + s1_135_2;
    // Op 136: dim3x3 mul
    uint64_t s0_136_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_136_0 = *(gl64_t*)&dParams->aux_trace[s0_136_pos];
    gl64_t s0_136_1 = *(gl64_t*)&dParams->aux_trace[s0_136_pos + TILE_HEIGHT];
    gl64_t s0_136_2 = *(gl64_t*)&dParams->aux_trace[s0_136_pos + 2*TILE_HEIGHT];
    gl64_t kA136 = (s0_136_0 + s0_136_1) * (tmp3_0 + tmp3_1);
    gl64_t kB136 = (s0_136_0 + s0_136_2) * (tmp3_0 + tmp3_2);
    gl64_t kC136 = (s0_136_1 + s0_136_2) * (tmp3_1 + tmp3_2);
    gl64_t kD136 = s0_136_0 * tmp3_0;
    gl64_t kE136 = s0_136_1 * tmp3_1;
    gl64_t kF136 = s0_136_2 * tmp3_2;
    gl64_t kG136 = kD136 - kE136;
    tmp3_0 = (kC136 + kG136) - kF136;
    tmp3_1 = ((((kA136 + kC136) - kE136) - kE136) - kD136);
    tmp3_2 = kB136 - kG136;
    // Op 137: dim1x1 sub_swap
    gl64_t s0_137 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_137 = *(gl64_t*)&expressions_params[9][9];
    tmp1_4 = s1_137 - s0_137;
    // Op 138: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 139: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
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
    tmp3_6 = (kC140 + kG140) - kF140;
    tmp3_7 = ((((kA140 + kC140) - kE140) - kE140) - kD140);
    tmp3_8 = kB140 - kG140;
    // Op 141: dim1x1 sub_swap
    gl64_t s0_141 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_0)];
    gl64_t s1_141 = *(gl64_t*)&expressions_params[9][0];
    tmp1_4 = s1_141 - s0_141;
    // Op 142: dim3x1 mul
    uint64_t s0_142_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_142_0 = *(gl64_t*)&dParams->aux_trace[s0_142_pos];
    gl64_t s0_142_1 = *(gl64_t*)&dParams->aux_trace[s0_142_pos + TILE_HEIGHT];
    gl64_t s0_142_2 = *(gl64_t*)&dParams->aux_trace[s0_142_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_142_0 * tmp1_4; tmp3_1 = s0_142_1 * tmp1_4; tmp3_2 = s0_142_2 * tmp1_4;
    // Op 143: dim3x3 sub
    uint64_t s0_143_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_143_0 = *(gl64_t*)&dParams->aux_trace[s0_143_pos];
    gl64_t s0_143_1 = *(gl64_t*)&dParams->aux_trace[s0_143_pos + TILE_HEIGHT];
    gl64_t s0_143_2 = *(gl64_t*)&dParams->aux_trace[s0_143_pos + 2*TILE_HEIGHT];
    tmp3_3 = s0_143_0 - tmp3_0; tmp3_4 = s0_143_1 - tmp3_1; tmp3_5 = s0_143_2 - tmp3_2;
    // Op 144: dim3x3 add
    gl64_t s0_144_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_144_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_144_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_144_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_144_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_144_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_0 = s0_144_0 + s1_144_0; tmp3_1 = s0_144_1 + s1_144_1; tmp3_2 = s0_144_2 + s1_144_2;
    // Op 145: dim3x3 add
    uint64_t s0_145_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_145_0 = *(gl64_t*)&dParams->aux_trace[s0_145_pos];
    gl64_t s0_145_1 = *(gl64_t*)&dParams->aux_trace[s0_145_pos + TILE_HEIGHT];
    gl64_t s0_145_2 = *(gl64_t*)&dParams->aux_trace[s0_145_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_145_0 + tmp3_0; tmp3_1 = s0_145_1 + tmp3_1; tmp3_2 = s0_145_2 + tmp3_2;
    // Op 146: dim3x3 sub
    tmp3_3 = tmp3_3 - tmp3_0; tmp3_4 = tmp3_4 - tmp3_1; tmp3_5 = tmp3_5 - tmp3_2;
    // Op 147: dim3x1 mul
    gl64_t s0_147_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_147_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_147_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_147 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp3_0 = s0_147_0 * s1_147; tmp3_1 = s0_147_1 * s1_147; tmp3_2 = s0_147_2 * s1_147;
    // Op 148: dim3x1 add
    gl64_t s1_148 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_148; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 149: dim3x3 add
    gl64_t s1_149_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_149_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_149_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_149_0; tmp3_1 = tmp3_1 + s1_149_1; tmp3_2 = tmp3_2 + s1_149_2;
    // Op 150: dim3x3 mul
    gl64_t kA150 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB150 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC150 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD150 = tmp3_3 * tmp3_0;
    gl64_t kE150 = tmp3_4 * tmp3_1;
    gl64_t kF150 = tmp3_5 * tmp3_2;
    gl64_t kG150 = kD150 - kE150;
    tmp3_0 = (kC150 + kG150) - kF150;
    tmp3_1 = ((((kA150 + kC150) - kE150) - kE150) - kD150);
    tmp3_2 = kB150 - kG150;
    // Op 151: dim3x1 add
    gl64_t s1_151 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_151; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 152: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 153: dim3x3 mul
    gl64_t s1_153_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_153_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_153_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA153 = (tmp3_0 + tmp3_1) * (s1_153_0 + s1_153_1);
    gl64_t kB153 = (tmp3_0 + tmp3_2) * (s1_153_0 + s1_153_2);
    gl64_t kC153 = (tmp3_1 + tmp3_2) * (s1_153_1 + s1_153_2);
    gl64_t kD153 = tmp3_0 * s1_153_0;
    gl64_t kE153 = tmp3_1 * s1_153_1;
    gl64_t kF153 = tmp3_2 * s1_153_2;
    gl64_t kG153 = kD153 - kE153;
    tmp3_6 = (kC153 + kG153) - kF153;
    tmp3_7 = ((((kA153 + kC153) - kE153) - kE153) - kD153);
    tmp3_8 = kB153 - kG153;
    // Op 154: dim3x1 mul
    gl64_t s0_154_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_154_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_154_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_154 = *(gl64_t*)&expressions_params[10][4];
    tmp3_0 = s0_154_0 * s1_154; tmp3_1 = s0_154_1 * s1_154; tmp3_2 = s0_154_2 * s1_154;
    // Op 155: dim3x1 add
    gl64_t s1_155 = *(gl64_t*)&expressions_params[10][3];
    tmp3_0 = tmp3_0 + s1_155; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 156: dim3x3 mul
    gl64_t s1_156_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_156_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_156_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 157: dim3x1 add
    gl64_t s1_157 = *(gl64_t*)&expressions_params[10][5];
    tmp3_0 = tmp3_0 + s1_157; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 158: dim3x3 mul
    gl64_t s1_158_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_158_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_158_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 159: dim3x1 add
    gl64_t s1_159 = *(gl64_t*)&expressions_params[10][6];
    tmp3_0 = tmp3_0 + s1_159; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 160: dim3x3 mul
    gl64_t s1_160_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_160_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_160_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA160 = (tmp3_0 + tmp3_1) * (s1_160_0 + s1_160_1);
    gl64_t kB160 = (tmp3_0 + tmp3_2) * (s1_160_0 + s1_160_2);
    gl64_t kC160 = (tmp3_1 + tmp3_2) * (s1_160_1 + s1_160_2);
    gl64_t kD160 = tmp3_0 * s1_160_0;
    gl64_t kE160 = tmp3_1 * s1_160_1;
    gl64_t kF160 = tmp3_2 * s1_160_2;
    gl64_t kG160 = kD160 - kE160;
    tmp3_0 = (kC160 + kG160) - kF160;
    tmp3_1 = ((((kA160 + kC160) - kE160) - kE160) - kD160);
    tmp3_2 = kB160 - kG160;
    // Op 161: dim3x1 add
    gl64_t s1_161 = *(gl64_t*)&expressions_params[10][1];
    tmp3_0 = tmp3_0 + s1_161; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 162: dim3x3 mul
    gl64_t s1_162_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_162_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_162_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 163: dim3x1 add
    gl64_t s1_163 = *(gl64_t*)&expressions_params[10][0];
    tmp3_0 = tmp3_0 + s1_163; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_165 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_165; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 166: dim3x3 mul
    gl64_t s1_166_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_166_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_166_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 167: dim3x1 add
    gl64_t s1_167 = *(gl64_t*)&expressions_params[9][8];
    tmp3_0 = tmp3_0 + s1_167; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 168: dim3x3 add
    gl64_t s1_168_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_168_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_168_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_168_0; tmp3_1 = tmp3_1 + s1_168_1; tmp3_2 = tmp3_2 + s1_168_2;
    // Op 169: dim3x3 mul
    gl64_t s1_169_0 = *(gl64_t*)&expressions_params[10][15];
    gl64_t s1_169_1 = *(gl64_t*)&expressions_params[10][15+1];
    gl64_t s1_169_2 = *(gl64_t*)&expressions_params[10][15+2];
    gl64_t kA169 = (tmp3_0 + tmp3_1) * (s1_169_0 + s1_169_1);
    gl64_t kB169 = (tmp3_0 + tmp3_2) * (s1_169_0 + s1_169_2);
    gl64_t kC169 = (tmp3_1 + tmp3_2) * (s1_169_1 + s1_169_2);
    gl64_t kD169 = tmp3_0 * s1_169_0;
    gl64_t kE169 = tmp3_1 * s1_169_1;
    gl64_t kF169 = tmp3_2 * s1_169_2;
    gl64_t kG169 = kD169 - kE169;
    tmp3_0 = (kC169 + kG169) - kF169;
    tmp3_1 = ((((kA169 + kC169) - kE169) - kE169) - kD169);
    tmp3_2 = kB169 - kG169;
    // Op 170: dim3x1 add
    gl64_t s1_170 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_170; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 171: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    tmp3_6 = (kC172 + kG172) - kF172;
    tmp3_7 = ((((kA172 + kC172) - kE172) - kE172) - kD172);
    tmp3_8 = kB172 - kG172;
    // Op 173: dim3x1 mul
    gl64_t s0_173_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_173_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_173_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_173 = *(gl64_t*)&expressions_params[10][8];
    tmp3_0 = s0_173_0 * s1_173; tmp3_1 = s0_173_1 * s1_173; tmp3_2 = s0_173_2 * s1_173;
    // Op 174: dim3x1 add
    gl64_t s1_174 = *(gl64_t*)&expressions_params[10][7];
    tmp3_0 = tmp3_0 + s1_174; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 175: dim3x3 mul
    gl64_t s1_175_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_175_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_175_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA175 = (tmp3_0 + tmp3_1) * (s1_175_0 + s1_175_1);
    gl64_t kB175 = (tmp3_0 + tmp3_2) * (s1_175_0 + s1_175_2);
    gl64_t kC175 = (tmp3_1 + tmp3_2) * (s1_175_1 + s1_175_2);
    gl64_t kD175 = tmp3_0 * s1_175_0;
    gl64_t kE175 = tmp3_1 * s1_175_1;
    gl64_t kF175 = tmp3_2 * s1_175_2;
    gl64_t kG175 = kD175 - kE175;
    tmp3_0 = (kC175 + kG175) - kF175;
    tmp3_1 = ((((kA175 + kC175) - kE175) - kE175) - kD175);
    tmp3_2 = kB175 - kG175;
    // Op 176: dim3x1 add
    gl64_t s1_176 = *(gl64_t*)&expressions_params[10][9];
    tmp3_0 = tmp3_0 + s1_176; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 177: dim3x3 mul
    gl64_t s1_177_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_177_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_177_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA177 = (tmp3_0 + tmp3_1) * (s1_177_0 + s1_177_1);
    gl64_t kB177 = (tmp3_0 + tmp3_2) * (s1_177_0 + s1_177_2);
    gl64_t kC177 = (tmp3_1 + tmp3_2) * (s1_177_1 + s1_177_2);
    gl64_t kD177 = tmp3_0 * s1_177_0;
    gl64_t kE177 = tmp3_1 * s1_177_1;
    gl64_t kF177 = tmp3_2 * s1_177_2;
    gl64_t kG177 = kD177 - kE177;
    tmp3_0 = (kC177 + kG177) - kF177;
    tmp3_1 = ((((kA177 + kC177) - kE177) - kE177) - kD177);
    tmp3_2 = kB177 - kG177;
    // Op 178: dim3x1 add
    gl64_t s1_178 = *(gl64_t*)&expressions_params[10][10];
    tmp3_0 = tmp3_0 + s1_178; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 179: dim3x3 mul
    gl64_t s1_179_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_179_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_179_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 180: dim3x3 mul
    gl64_t s1_180_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_180_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_180_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA180 = (tmp3_0 + tmp3_1) * (s1_180_0 + s1_180_1);
    gl64_t kB180 = (tmp3_0 + tmp3_2) * (s1_180_0 + s1_180_2);
    gl64_t kC180 = (tmp3_1 + tmp3_2) * (s1_180_1 + s1_180_2);
    gl64_t kD180 = tmp3_0 * s1_180_0;
    gl64_t kE180 = tmp3_1 * s1_180_1;
    gl64_t kF180 = tmp3_2 * s1_180_2;
    gl64_t kG180 = kD180 - kE180;
    tmp3_0 = (kC180 + kG180) - kF180;
    tmp3_1 = ((((kA180 + kC180) - kE180) - kE180) - kD180);
    tmp3_2 = kB180 - kG180;
    // Op 181: dim1x1 add
    gl64_t s0_181 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_181 = *(gl64_t*)&expressions_params[10][0];
    tmp1_4 = s0_181 + s1_181;
    // Op 182: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 183: dim3x3 mul
    gl64_t s1_183_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_183_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_183_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 184: dim3x1 add
    gl64_t s1_184 = *(gl64_t*)&expressions_params[9][7];
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
    gl64_t s1_186 = *(gl64_t*)&expressions_params[9][8];
    tmp3_0 = tmp3_0 + s1_186; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 187: dim3x3 add
    gl64_t s1_187_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_187_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_187_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_187_0; tmp3_1 = tmp3_1 + s1_187_1; tmp3_2 = tmp3_2 + s1_187_2;
    // Op 188: dim3x3 mul
    gl64_t s1_188_0 = *(gl64_t*)&expressions_params[10][18];
    gl64_t s1_188_1 = *(gl64_t*)&expressions_params[10][18+1];
    gl64_t s1_188_2 = *(gl64_t*)&expressions_params[10][18+2];
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
    // Op 189: dim1x1 sub
    gl64_t s0_189 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_189 = *(gl64_t*)&expressions_params[10][2];
    tmp1_4 = s0_189 - s1_189;
    // Op 190: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 191: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 192: dim3x3 mul
    gl64_t s1_192_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_192_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_192_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA192 = (tmp3_0 + tmp3_1) * (s1_192_0 + s1_192_1);
    gl64_t kB192 = (tmp3_0 + tmp3_2) * (s1_192_0 + s1_192_2);
    gl64_t kC192 = (tmp3_1 + tmp3_2) * (s1_192_1 + s1_192_2);
    gl64_t kD192 = tmp3_0 * s1_192_0;
    gl64_t kE192 = tmp3_1 * s1_192_1;
    gl64_t kF192 = tmp3_2 * s1_192_2;
    gl64_t kG192 = kD192 - kE192;
    tmp3_6 = (kC192 + kG192) - kF192;
    tmp3_7 = ((((kA192 + kC192) - kE192) - kE192) - kD192);
    tmp3_8 = kB192 - kG192;
    // Op 193: dim3x1 mul
    gl64_t s0_193_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_193_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_193_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_193 = *(gl64_t*)&expressions_params[10][11];
    tmp3_0 = s0_193_0 * s1_193; tmp3_1 = s0_193_1 * s1_193; tmp3_2 = s0_193_2 * s1_193;
    // Op 194: dim3x1 add
    gl64_t s1_194 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_194; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 195: dim3x3 add
    gl64_t s1_195_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_195_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_195_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_195_0; tmp3_1 = tmp3_1 + s1_195_1; tmp3_2 = tmp3_2 + s1_195_2;
    // Op 196: dim3x3 mul
    gl64_t s1_196_0 = *(gl64_t*)&expressions_params[10][21];
    gl64_t s1_196_1 = *(gl64_t*)&expressions_params[10][21+1];
    gl64_t s1_196_2 = *(gl64_t*)&expressions_params[10][21+2];
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
    gl64_t s1_197 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_197; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 198: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 199: dim3x3 mul
    gl64_t s1_199_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_199_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_199_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA199 = (tmp3_0 + tmp3_1) * (s1_199_0 + s1_199_1);
    gl64_t kB199 = (tmp3_0 + tmp3_2) * (s1_199_0 + s1_199_2);
    gl64_t kC199 = (tmp3_1 + tmp3_2) * (s1_199_1 + s1_199_2);
    gl64_t kD199 = tmp3_0 * s1_199_0;
    gl64_t kE199 = tmp3_1 * s1_199_1;
    gl64_t kF199 = tmp3_2 * s1_199_2;
    gl64_t kG199 = kD199 - kE199;
    tmp3_6 = (kC199 + kG199) - kF199;
    tmp3_7 = ((((kA199 + kC199) - kE199) - kE199) - kD199);
    tmp3_8 = kB199 - kG199;
    // Op 200: dim3x1 mul
    gl64_t s0_200_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_200_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_200_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_200 = *(gl64_t*)&expressions_params[10][12];
    tmp3_0 = s0_200_0 * s1_200; tmp3_1 = s0_200_1 * s1_200; tmp3_2 = s0_200_2 * s1_200;
    // Op 201: dim3x1 add
    gl64_t s1_201 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_201; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 202: dim3x3 add
    gl64_t s1_202_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_202_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_202_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_202_0; tmp3_1 = tmp3_1 + s1_202_1; tmp3_2 = tmp3_2 + s1_202_2;
    // Op 203: dim3x3 mul
    gl64_t s1_203_0 = *(gl64_t*)&expressions_params[10][24];
    gl64_t s1_203_1 = *(gl64_t*)&expressions_params[10][24+1];
    gl64_t s1_203_2 = *(gl64_t*)&expressions_params[10][24+2];
    gl64_t kA203 = (tmp3_0 + tmp3_1) * (s1_203_0 + s1_203_1);
    gl64_t kB203 = (tmp3_0 + tmp3_2) * (s1_203_0 + s1_203_2);
    gl64_t kC203 = (tmp3_1 + tmp3_2) * (s1_203_1 + s1_203_2);
    gl64_t kD203 = tmp3_0 * s1_203_0;
    gl64_t kE203 = tmp3_1 * s1_203_1;
    gl64_t kF203 = tmp3_2 * s1_203_2;
    gl64_t kG203 = kD203 - kE203;
    tmp3_0 = (kC203 + kG203) - kF203;
    tmp3_1 = ((((kA203 + kC203) - kE203) - kE203) - kD203);
    tmp3_2 = kB203 - kG203;
    // Op 204: dim3x1 add
    gl64_t s1_204 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_204; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_6 = (kC206 + kG206) - kF206;
    tmp3_7 = ((((kA206 + kC206) - kE206) - kE206) - kD206);
    tmp3_8 = kB206 - kG206;
    // Op 207: dim3x1 mul
    gl64_t s0_207_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_207_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_207_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_207 = *(gl64_t*)&expressions_params[10][13];
    tmp3_0 = s0_207_0 * s1_207; tmp3_1 = s0_207_1 * s1_207; tmp3_2 = s0_207_2 * s1_207;
    // Op 208: dim3x1 add
    gl64_t s1_208 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_208; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 209: dim3x3 add
    gl64_t s1_209_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_209_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_209_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_209_0; tmp3_1 = tmp3_1 + s1_209_1; tmp3_2 = tmp3_2 + s1_209_2;
    // Op 210: dim3x3 mul
    gl64_t s1_210_0 = *(gl64_t*)&expressions_params[10][27];
    gl64_t s1_210_1 = *(gl64_t*)&expressions_params[10][27+1];
    gl64_t s1_210_2 = *(gl64_t*)&expressions_params[10][27+2];
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
    // Op 211: dim3x1 add
    gl64_t s1_211 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_211; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 212: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    tmp3_6 = (kC213 + kG213) - kF213;
    tmp3_7 = ((((kA213 + kC213) - kE213) - kE213) - kD213);
    tmp3_8 = kB213 - kG213;
    // Op 214: dim3x1 mul
    gl64_t s0_214_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_214_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_214_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_214 = *(gl64_t*)&expressions_params[10][14];
    tmp3_0 = s0_214_0 * s1_214; tmp3_1 = s0_214_1 * s1_214; tmp3_2 = s0_214_2 * s1_214;
    // Op 215: dim3x1 add
    gl64_t s1_215 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_215; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 216: dim3x3 add
    gl64_t s1_216_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_216_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_216_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_216_0; tmp3_1 = tmp3_1 + s1_216_1; tmp3_2 = tmp3_2 + s1_216_2;
    // Op 217: dim3x3 mul
    gl64_t s1_217_0 = *(gl64_t*)&expressions_params[10][30];
    gl64_t s1_217_1 = *(gl64_t*)&expressions_params[10][30+1];
    gl64_t s1_217_2 = *(gl64_t*)&expressions_params[10][30+2];
    gl64_t kA217 = (tmp3_0 + tmp3_1) * (s1_217_0 + s1_217_1);
    gl64_t kB217 = (tmp3_0 + tmp3_2) * (s1_217_0 + s1_217_2);
    gl64_t kC217 = (tmp3_1 + tmp3_2) * (s1_217_1 + s1_217_2);
    gl64_t kD217 = tmp3_0 * s1_217_0;
    gl64_t kE217 = tmp3_1 * s1_217_1;
    gl64_t kF217 = tmp3_2 * s1_217_2;
    gl64_t kG217 = kD217 - kE217;
    tmp3_0 = (kC217 + kG217) - kF217;
    tmp3_1 = ((((kA217 + kC217) - kE217) - kE217) - kD217);
    tmp3_2 = kB217 - kG217;
    // Op 218: dim3x1 add
    gl64_t s1_218 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_218; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 219: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 220: dim3x3 mul
    gl64_t s1_220_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_220_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_220_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA220 = (tmp3_0 + tmp3_1) * (s1_220_0 + s1_220_1);
    gl64_t kB220 = (tmp3_0 + tmp3_2) * (s1_220_0 + s1_220_2);
    gl64_t kC220 = (tmp3_1 + tmp3_2) * (s1_220_1 + s1_220_2);
    gl64_t kD220 = tmp3_0 * s1_220_0;
    gl64_t kE220 = tmp3_1 * s1_220_1;
    gl64_t kF220 = tmp3_2 * s1_220_2;
    gl64_t kG220 = kD220 - kE220;
    tmp3_3 = (kC220 + kG220) - kF220;
    tmp3_4 = ((((kA220 + kC220) - kE220) - kE220) - kD220);
    tmp3_5 = kB220 - kG220;
    // Op 221: dim3x3 sub_swap
    uint64_t s0_221_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_221_0 = *(gl64_t*)&dParams->aux_trace[s0_221_pos];
    gl64_t s0_221_1 = *(gl64_t*)&dParams->aux_trace[s0_221_pos + TILE_HEIGHT];
    gl64_t s0_221_2 = *(gl64_t*)&dParams->aux_trace[s0_221_pos + 2*TILE_HEIGHT];
    gl64_t s1_221_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_221_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_221_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_6 = s1_221_0 - s0_221_0; tmp3_7 = s1_221_1 - s0_221_1; tmp3_8 = s1_221_2 - s0_221_2;
    // Op 222: dim3x3 add
    gl64_t s0_222_0 = *(gl64_t*)&expressions_params[10][15];
    gl64_t s0_222_1 = *(gl64_t*)&expressions_params[10][15+1];
    gl64_t s0_222_2 = *(gl64_t*)&expressions_params[10][15+2];
    gl64_t s1_222_0 = *(gl64_t*)&expressions_params[10][18];
    gl64_t s1_222_1 = *(gl64_t*)&expressions_params[10][18+1];
    gl64_t s1_222_2 = *(gl64_t*)&expressions_params[10][18+2];
    tmp3_0 = s0_222_0 + s1_222_0; tmp3_1 = s0_222_1 + s1_222_1; tmp3_2 = s0_222_2 + s1_222_2;
    // Op 223: dim3x3 add
    gl64_t s1_223_0 = *(gl64_t*)&expressions_params[10][21];
    gl64_t s1_223_1 = *(gl64_t*)&expressions_params[10][21+1];
    gl64_t s1_223_2 = *(gl64_t*)&expressions_params[10][21+2];
    tmp3_0 = tmp3_0 + s1_223_0; tmp3_1 = tmp3_1 + s1_223_1; tmp3_2 = tmp3_2 + s1_223_2;
    // Op 224: dim3x3 add
    gl64_t s1_224_0 = *(gl64_t*)&expressions_params[10][24];
    gl64_t s1_224_1 = *(gl64_t*)&expressions_params[10][24+1];
    gl64_t s1_224_2 = *(gl64_t*)&expressions_params[10][24+2];
    tmp3_0 = tmp3_0 + s1_224_0; tmp3_1 = tmp3_1 + s1_224_1; tmp3_2 = tmp3_2 + s1_224_2;
    // Op 225: dim3x3 add
    gl64_t s1_225_0 = *(gl64_t*)&expressions_params[10][27];
    gl64_t s1_225_1 = *(gl64_t*)&expressions_params[10][27+1];
    gl64_t s1_225_2 = *(gl64_t*)&expressions_params[10][27+2];
    tmp3_0 = tmp3_0 + s1_225_0; tmp3_1 = tmp3_1 + s1_225_1; tmp3_2 = tmp3_2 + s1_225_2;
    // Op 226: dim3x3 add
    gl64_t s1_226_0 = *(gl64_t*)&expressions_params[10][30];
    gl64_t s1_226_1 = *(gl64_t*)&expressions_params[10][30+1];
    gl64_t s1_226_2 = *(gl64_t*)&expressions_params[10][30+2];
    tmp3_0 = tmp3_0 + s1_226_0; tmp3_1 = tmp3_1 + s1_226_1; tmp3_2 = tmp3_2 + s1_226_2;
    // Op 227: dim3x3 sub
    tmp3_0 = tmp3_6 - tmp3_0; tmp3_1 = tmp3_7 - tmp3_1; tmp3_2 = tmp3_8 - tmp3_2;
    // Op 228: dim3x1 mul
    gl64_t s1_228 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_228; tmp3_1 = tmp3_1 * s1_228; tmp3_2 = tmp3_2 * s1_228;
    // Op 229: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
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
    tmp3_0 = (kC230 + kG230) - kF230;
    tmp3_1 = ((((kA230 + kC230) - kE230) - kE230) - kD230);
    tmp3_2 = kB230 - kG230;
    // Op 231: dim1x1 sub_swap
    gl64_t s0_231 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_231 = *(gl64_t*)&expressions_params[9][0];
    tmp1_4 = s1_231 - s0_231;
    // Op 232: dim1x1 sub_swap
    gl64_t s0_232 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_232 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_232 - s0_232;
    // Op 233: dim1x1 mul
    tmp1_0 = tmp1_4 * tmp1_0;
    // Op 234: dim1x1 sub
    gl64_t s0_234 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2))];
    tmp1_0 = s0_234 - tmp1_0;
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
    // Op 237: dim1x1 sub_swap
    gl64_t s0_237 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_237 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_237 - s0_237;
    // Op 238: dim1x1 sub_swap
    gl64_t s0_238 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_238 = *(gl64_t*)&expressions_params[9][0];
    tmp1_4 = s1_238 - s0_238;
    // Op 239: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_4;
    // Op 240: dim1x1 sub
    gl64_t s0_240 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_2))];
    tmp1_0 = s0_240 - tmp1_0;
    // Op 241: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 242: dim3x1 mul
    gl64_t s1_242 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_242; tmp3_1 = tmp3_1 * s1_242; tmp3_2 = tmp3_2 * s1_242;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
