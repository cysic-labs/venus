// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: 67674211  nOps=245 nTemp1=5 nTemp3=5
#define GENERATED_EVAL_NOPS_67674211 245
#define GENERATED_EVAL_NTEMP1_67674211 5
#define GENERATED_EVAL_NTEMP3_67674211 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_67674211(
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
    // Op 66: dim1x1 sub_swap
    gl64_t s0_66 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_66 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_66 - s0_66;
    // Op 67: dim1x1 sub
    gl64_t s0_67 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_1 = s0_67 - tmp1_4;
    // Op 68: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 69: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC70 + kG70) - kF70;
    tmp3_1 = ((((kA70 + kC70) - kE70) - kE70) - kD70);
    tmp3_2 = kB70 - kG70;
    // Op 71: dim1x1 mul
    gl64_t s0_71 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 5, domainSize, nCols_1))];
    gl64_t s1_71 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_71 * s1_71;
    // Op 72: dim1x1 add
    gl64_t s0_72 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 4, domainSize, nCols_1))];
    tmp1_1 = s0_72 + tmp1_0;
    // Op 73: dim1x1 sub_swap
    gl64_t s1_73 = *(gl64_t*)&expressions_params[10][3];
    tmp1_0 = s1_73 - tmp1_1;
    // Op 74: dim1x1 mul
    gl64_t s0_74 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_0 = s0_74 * tmp1_0;
    // Op 75: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 76: dim1x1 sub
    tmp1_0 = tmp1_2 - tmp1_0;
    // Op 77: dim1x1 mul
    gl64_t s0_77 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2))];
    tmp1_0 = s0_77 * tmp1_0;
    // Op 78: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 79: dim3x3 mul
    gl64_t s1_79_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_79_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_79_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA79 = (tmp3_0 + tmp3_1) * (s1_79_0 + s1_79_1);
    gl64_t kB79 = (tmp3_0 + tmp3_2) * (s1_79_0 + s1_79_2);
    gl64_t kC79 = (tmp3_1 + tmp3_2) * (s1_79_1 + s1_79_2);
    gl64_t kD79 = tmp3_0 * s1_79_0;
    gl64_t kE79 = tmp3_1 * s1_79_1;
    gl64_t kF79 = tmp3_2 * s1_79_2;
    gl64_t kG79 = kD79 - kE79;
    tmp3_0 = (kC79 + kG79) - kF79;
    tmp3_1 = ((((kA79 + kC79) - kE79) - kE79) - kD79);
    tmp3_2 = kB79 - kG79;
    // Op 80: dim1x1 mul
    gl64_t s0_80 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 7, domainSize, nCols_1))];
    gl64_t s1_80 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_80 * s1_80;
    // Op 81: dim1x1 add
    gl64_t s0_81 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 6, domainSize, nCols_1))];
    tmp1_2 = s0_81 + tmp1_0;
    // Op 82: dim1x1 sub_swap
    gl64_t s1_82 = *(gl64_t*)&expressions_params[10][4];
    tmp1_0 = s1_82 - tmp1_2;
    // Op 83: dim1x1 mul
    gl64_t s0_83 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_0 = s0_83 * tmp1_0;
    // Op 84: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 85: dim1x1 sub
    tmp1_0 = tmp1_3 - tmp1_0;
    // Op 86: dim1x1 mul
    gl64_t s0_86 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_2))];
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
    tmp3_12 = (kC88 + kG88) - kF88;
    tmp3_13 = ((((kA88 + kC88) - kE88) - kE88) - kD88);
    tmp3_14 = kB88 - kG88;
    // Op 89: dim3x1 mul
    gl64_t s0_89_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_89_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_89_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_89 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp3_0 = s0_89_0 * s1_89; tmp3_1 = s0_89_1 * s1_89; tmp3_2 = s0_89_2 * s1_89;
    // Op 90: dim3x1 add
    gl64_t s1_90 = *(gl64_t*)&expressions_params[9][1];
    tmp3_9 = tmp3_0 + s1_90; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 91: dim3x3 add
    gl64_t s1_91_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_91_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_91_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_91_0; tmp3_4 = tmp3_10 + s1_91_1; tmp3_5 = tmp3_11 + s1_91_2;
    // Op 92: dim3x1 mul
    gl64_t s0_92_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_92_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_92_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_92 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp3_0 = s0_92_0 * s1_92; tmp3_1 = s0_92_1 * s1_92; tmp3_2 = s0_92_2 * s1_92;
    // Op 93: dim3x1 add
    gl64_t s1_93 = *(gl64_t*)&expressions_params[9][1];
    tmp3_6 = tmp3_0 + s1_93; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 94: dim3x3 add
    gl64_t s1_94_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_94_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_94_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_94_0; tmp3_1 = tmp3_7 + s1_94_1; tmp3_2 = tmp3_8 + s1_94_2;
    // Op 95: dim3x3 mul
    gl64_t kA95 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB95 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC95 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD95 = tmp3_3 * tmp3_0;
    gl64_t kE95 = tmp3_4 * tmp3_1;
    gl64_t kF95 = tmp3_5 * tmp3_2;
    gl64_t kG95 = kD95 - kE95;
    tmp3_0 = (kC95 + kG95) - kF95;
    tmp3_1 = ((((kA95 + kC95) - kE95) - kE95) - kD95);
    tmp3_2 = kB95 - kG95;
    // Op 96: dim3x3 mul
    gl64_t s0_96_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_96_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_96_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA96 = (s0_96_0 + s0_96_1) * (tmp3_0 + tmp3_1);
    gl64_t kB96 = (s0_96_0 + s0_96_2) * (tmp3_0 + tmp3_2);
    gl64_t kC96 = (s0_96_1 + s0_96_2) * (tmp3_1 + tmp3_2);
    gl64_t kD96 = s0_96_0 * tmp3_0;
    gl64_t kE96 = s0_96_1 * tmp3_1;
    gl64_t kF96 = s0_96_2 * tmp3_2;
    gl64_t kG96 = kD96 - kE96;
    tmp3_0 = (kC96 + kG96) - kF96;
    tmp3_1 = ((((kA96 + kC96) - kE96) - kE96) - kD96);
    tmp3_2 = kB96 - kG96;
    // Op 97: dim3x3 add
    gl64_t s1_97_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_97_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_97_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_97_0; tmp3_7 = tmp3_7 + s1_97_1; tmp3_8 = tmp3_8 + s1_97_2;
    // Op 98: dim3x1 mul
    gl64_t s1_98 = *(gl64_t*)&expressions_params[9][2];
    tmp3_6 = tmp3_6 * s1_98; tmp3_7 = tmp3_7 * s1_98; tmp3_8 = tmp3_8 * s1_98;
    // Op 99: dim3x3 add
    gl64_t s1_99_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_99_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_99_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_99_0; tmp3_10 = tmp3_10 + s1_99_1; tmp3_11 = tmp3_11 + s1_99_2;
    // Op 100: dim3x1 mul
    gl64_t s1_100 = *(gl64_t*)&expressions_params[9][2];
    tmp3_9 = tmp3_9 * s1_100; tmp3_10 = tmp3_10 * s1_100; tmp3_11 = tmp3_11 * s1_100;
    // Op 101: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 102: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 103: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
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
    tmp3_3 = (kC104 + kG104) - kF104;
    tmp3_4 = ((((kA104 + kC104) - kE104) - kE104) - kD104);
    tmp3_5 = kB104 - kG104;
    // Op 105: dim3x1 mul
    gl64_t s0_105_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_105_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_105_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_105 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp3_0 = s0_105_0 * s1_105; tmp3_1 = s0_105_1 * s1_105; tmp3_2 = s0_105_2 * s1_105;
    // Op 106: dim3x1 add
    gl64_t s1_106 = *(gl64_t*)&expressions_params[9][1];
    tmp3_9 = tmp3_0 + s1_106; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 107: dim3x3 add
    gl64_t s1_107_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_107_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_107_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_107_0; tmp3_13 = tmp3_10 + s1_107_1; tmp3_14 = tmp3_11 + s1_107_2;
    // Op 108: dim1x1 mul
    gl64_t s0_108 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_108 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_108 * s1_108;
    // Op 109: dim1x1 add
    gl64_t s0_109 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_109 + tmp1_0;
    // Op 110: dim3x1 mul
    gl64_t s0_110_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_110_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_110_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_110_0 * tmp1_0; tmp3_1 = s0_110_1 * tmp1_0; tmp3_2 = s0_110_2 * tmp1_0;
    // Op 111: dim1x1 mul
    gl64_t s0_111 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_111 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_111 * s1_111;
    // Op 112: dim1x1 add
    gl64_t s0_112 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_112 + tmp1_0;
    // Op 113: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_115 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_115; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_117 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
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
    // Op 119: dim1x1 mul
    gl64_t s0_119 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_119 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s0_119 * s1_119;
    // Op 120: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_122 = *(gl64_t*)&expressions_params[9][0];
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
    gl64_t s1_124 = *(gl64_t*)&expressions_params[9][5];
    tmp3_6 = tmp3_0 + s1_124; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 125: dim3x3 add
    gl64_t s1_125_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_125_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_125_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_125_0; tmp3_1 = tmp3_7 + s1_125_1; tmp3_2 = tmp3_8 + s1_125_2;
    // Op 126: dim3x3 mul
    gl64_t kA126 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB126 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC126 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD126 = tmp3_12 * tmp3_0;
    gl64_t kE126 = tmp3_13 * tmp3_1;
    gl64_t kF126 = tmp3_14 * tmp3_2;
    gl64_t kG126 = kD126 - kE126;
    tmp3_0 = (kC126 + kG126) - kF126;
    tmp3_1 = ((((kA126 + kC126) - kE126) - kE126) - kD126);
    tmp3_2 = kB126 - kG126;
    // Op 127: dim3x3 mul
    gl64_t s0_127_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_127_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_127_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA127 = (s0_127_0 + s0_127_1) * (tmp3_0 + tmp3_1);
    gl64_t kB127 = (s0_127_0 + s0_127_2) * (tmp3_0 + tmp3_2);
    gl64_t kC127 = (s0_127_1 + s0_127_2) * (tmp3_1 + tmp3_2);
    gl64_t kD127 = s0_127_0 * tmp3_0;
    gl64_t kE127 = s0_127_1 * tmp3_1;
    gl64_t kF127 = s0_127_2 * tmp3_2;
    gl64_t kG127 = kD127 - kE127;
    tmp3_0 = (kC127 + kG127) - kF127;
    tmp3_1 = ((((kA127 + kC127) - kE127) - kE127) - kD127);
    tmp3_2 = kB127 - kG127;
    // Op 128: dim3x3 add
    gl64_t s1_128_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_128_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_128_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_128_0; tmp3_7 = tmp3_7 + s1_128_1; tmp3_8 = tmp3_8 + s1_128_2;
    // Op 129: dim3x1 mul
    gl64_t s1_129 = *(gl64_t*)&expressions_params[9][2];
    tmp3_6 = tmp3_6 * s1_129; tmp3_7 = tmp3_7 * s1_129; tmp3_8 = tmp3_8 * s1_129;
    // Op 130: dim3x3 add
    gl64_t s1_130_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_130_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_130_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_130_0; tmp3_10 = tmp3_10 + s1_130_1; tmp3_11 = tmp3_11 + s1_130_2;
    // Op 131: dim3x1 mul
    gl64_t s1_131 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_131; tmp3_10 = tmp3_10 * s1_131; tmp3_11 = tmp3_11 * s1_131;
    // Op 132: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 133: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 134: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 135: dim3x3 mul
    gl64_t s1_135_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_135_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_135_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA135 = (tmp3_0 + tmp3_1) * (s1_135_0 + s1_135_1);
    gl64_t kB135 = (tmp3_0 + tmp3_2) * (s1_135_0 + s1_135_2);
    gl64_t kC135 = (tmp3_1 + tmp3_2) * (s1_135_1 + s1_135_2);
    gl64_t kD135 = tmp3_0 * s1_135_0;
    gl64_t kE135 = tmp3_1 * s1_135_1;
    gl64_t kF135 = tmp3_2 * s1_135_2;
    gl64_t kG135 = kD135 - kE135;
    tmp3_3 = (kC135 + kG135) - kF135;
    tmp3_4 = ((((kA135 + kC135) - kE135) - kE135) - kD135);
    tmp3_5 = kB135 - kG135;
    // Op 136: dim1x1 sub
    gl64_t s0_136 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_4 = s0_136 - tmp1_4;
    // Op 137: dim1x1 sub
    gl64_t s1_137 = *(gl64_t*)&expressions_params[9][0];
    tmp1_4 = tmp1_4 - s1_137;
    // Op 138: dim3x1 mul
    gl64_t s0_138_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_138_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_138_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_138_0 * tmp1_4; tmp3_1 = s0_138_1 * tmp1_4; tmp3_2 = s0_138_2 * tmp1_4;
    // Op 139: dim3x1 add
    gl64_t s1_139 = *(gl64_t*)&expressions_params[9][6];
    tmp3_0 = tmp3_0 + s1_139; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 140: dim3x3 add
    gl64_t s1_140_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_140_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_140_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_140_0; tmp3_1 = tmp3_1 + s1_140_1; tmp3_2 = tmp3_2 + s1_140_2;
    // Op 141: dim3x3 mul
    uint64_t s0_141_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_141_0 = *(gl64_t*)&dParams->aux_trace[s0_141_pos];
    gl64_t s0_141_1 = *(gl64_t*)&dParams->aux_trace[s0_141_pos + TILE_HEIGHT];
    gl64_t s0_141_2 = *(gl64_t*)&dParams->aux_trace[s0_141_pos + 2*TILE_HEIGHT];
    gl64_t kA141 = (s0_141_0 + s0_141_1) * (tmp3_0 + tmp3_1);
    gl64_t kB141 = (s0_141_0 + s0_141_2) * (tmp3_0 + tmp3_2);
    gl64_t kC141 = (s0_141_1 + s0_141_2) * (tmp3_1 + tmp3_2);
    gl64_t kD141 = s0_141_0 * tmp3_0;
    gl64_t kE141 = s0_141_1 * tmp3_1;
    gl64_t kF141 = s0_141_2 * tmp3_2;
    gl64_t kG141 = kD141 - kE141;
    tmp3_0 = (kC141 + kG141) - kF141;
    tmp3_1 = ((((kA141 + kC141) - kE141) - kE141) - kD141);
    tmp3_2 = kB141 - kG141;
    // Op 142: dim1x1 sub_swap
    gl64_t s0_142 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_142 = *(gl64_t*)&expressions_params[9][9];
    tmp1_4 = s1_142 - s0_142;
    // Op 143: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 144: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
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
    tmp3_6 = (kC145 + kG145) - kF145;
    tmp3_7 = ((((kA145 + kC145) - kE145) - kE145) - kD145);
    tmp3_8 = kB145 - kG145;
    // Op 146: dim1x1 sub_swap
    gl64_t s0_146 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_0)];
    gl64_t s1_146 = *(gl64_t*)&expressions_params[9][0];
    tmp1_4 = s1_146 - s0_146;
    // Op 147: dim3x1 mul
    uint64_t s0_147_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_147_0 = *(gl64_t*)&dParams->aux_trace[s0_147_pos];
    gl64_t s0_147_1 = *(gl64_t*)&dParams->aux_trace[s0_147_pos + TILE_HEIGHT];
    gl64_t s0_147_2 = *(gl64_t*)&dParams->aux_trace[s0_147_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_147_0 * tmp1_4; tmp3_1 = s0_147_1 * tmp1_4; tmp3_2 = s0_147_2 * tmp1_4;
    // Op 148: dim3x3 sub
    uint64_t s0_148_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_148_0 = *(gl64_t*)&dParams->aux_trace[s0_148_pos];
    gl64_t s0_148_1 = *(gl64_t*)&dParams->aux_trace[s0_148_pos + TILE_HEIGHT];
    gl64_t s0_148_2 = *(gl64_t*)&dParams->aux_trace[s0_148_pos + 2*TILE_HEIGHT];
    tmp3_3 = s0_148_0 - tmp3_0; tmp3_4 = s0_148_1 - tmp3_1; tmp3_5 = s0_148_2 - tmp3_2;
    // Op 149: dim3x3 add
    gl64_t s0_149_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_149_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_149_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_149_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_149_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_149_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_0 = s0_149_0 + s1_149_0; tmp3_1 = s0_149_1 + s1_149_1; tmp3_2 = s0_149_2 + s1_149_2;
    // Op 150: dim3x3 add
    uint64_t s0_150_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_150_0 = *(gl64_t*)&dParams->aux_trace[s0_150_pos];
    gl64_t s0_150_1 = *(gl64_t*)&dParams->aux_trace[s0_150_pos + TILE_HEIGHT];
    gl64_t s0_150_2 = *(gl64_t*)&dParams->aux_trace[s0_150_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_150_0 + tmp3_0; tmp3_1 = s0_150_1 + tmp3_1; tmp3_2 = s0_150_2 + tmp3_2;
    // Op 151: dim3x3 sub
    tmp3_3 = tmp3_3 - tmp3_0; tmp3_4 = tmp3_4 - tmp3_1; tmp3_5 = tmp3_5 - tmp3_2;
    // Op 152: dim3x1 mul
    gl64_t s0_152_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_152_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_152_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_152 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp3_0 = s0_152_0 * s1_152; tmp3_1 = s0_152_1 * s1_152; tmp3_2 = s0_152_2 * s1_152;
    // Op 153: dim3x1 add
    gl64_t s1_153 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_153; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 154: dim3x3 add
    gl64_t s1_154_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_154_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_154_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_154_0; tmp3_1 = tmp3_1 + s1_154_1; tmp3_2 = tmp3_2 + s1_154_2;
    // Op 155: dim3x3 mul
    gl64_t kA155 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB155 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC155 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD155 = tmp3_3 * tmp3_0;
    gl64_t kE155 = tmp3_4 * tmp3_1;
    gl64_t kF155 = tmp3_5 * tmp3_2;
    gl64_t kG155 = kD155 - kE155;
    tmp3_0 = (kC155 + kG155) - kF155;
    tmp3_1 = ((((kA155 + kC155) - kE155) - kE155) - kD155);
    tmp3_2 = kB155 - kG155;
    // Op 156: dim3x1 add
    gl64_t s1_156 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_156; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 157: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    gl64_t s1_159 = *(gl64_t*)&expressions_params[10][4];
    tmp3_0 = s0_159_0 * s1_159; tmp3_1 = s0_159_1 * s1_159; tmp3_2 = s0_159_2 * s1_159;
    // Op 160: dim3x1 add
    gl64_t s1_160 = *(gl64_t*)&expressions_params[10][3];
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
    gl64_t s1_162 = *(gl64_t*)&expressions_params[10][5];
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
    // Op 164: dim3x1 add
    gl64_t s1_164 = *(gl64_t*)&expressions_params[10][6];
    tmp3_0 = tmp3_0 + s1_164; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 165: dim3x3 mul
    gl64_t s1_165_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_165_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_165_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA165 = (tmp3_0 + tmp3_1) * (s1_165_0 + s1_165_1);
    gl64_t kB165 = (tmp3_0 + tmp3_2) * (s1_165_0 + s1_165_2);
    gl64_t kC165 = (tmp3_1 + tmp3_2) * (s1_165_1 + s1_165_2);
    gl64_t kD165 = tmp3_0 * s1_165_0;
    gl64_t kE165 = tmp3_1 * s1_165_1;
    gl64_t kF165 = tmp3_2 * s1_165_2;
    gl64_t kG165 = kD165 - kE165;
    tmp3_0 = (kC165 + kG165) - kF165;
    tmp3_1 = ((((kA165 + kC165) - kE165) - kE165) - kD165);
    tmp3_2 = kB165 - kG165;
    // Op 166: dim3x1 add
    gl64_t s1_166 = *(gl64_t*)&expressions_params[10][0];
    tmp3_0 = tmp3_0 + s1_166; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 167: dim3x3 mul
    gl64_t s1_167_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_167_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_167_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA167 = (tmp3_0 + tmp3_1) * (s1_167_0 + s1_167_1);
    gl64_t kB167 = (tmp3_0 + tmp3_2) * (s1_167_0 + s1_167_2);
    gl64_t kC167 = (tmp3_1 + tmp3_2) * (s1_167_1 + s1_167_2);
    gl64_t kD167 = tmp3_0 * s1_167_0;
    gl64_t kE167 = tmp3_1 * s1_167_1;
    gl64_t kF167 = tmp3_2 * s1_167_2;
    gl64_t kG167 = kD167 - kE167;
    tmp3_0 = (kC167 + kG167) - kF167;
    tmp3_1 = ((((kA167 + kC167) - kE167) - kE167) - kD167);
    tmp3_2 = kB167 - kG167;
    // Op 168: dim3x1 add
    gl64_t s1_168 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_168; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 169: dim3x3 mul
    gl64_t s1_169_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_169_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_169_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    gl64_t s1_170 = *(gl64_t*)&expressions_params[9][8];
    tmp3_0 = tmp3_0 + s1_170; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 171: dim3x3 add
    gl64_t s1_171_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_171_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_171_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_171_0; tmp3_1 = tmp3_1 + s1_171_1; tmp3_2 = tmp3_2 + s1_171_2;
    // Op 172: dim3x3 mul
    gl64_t s1_172_0 = *(gl64_t*)&expressions_params[10][15];
    gl64_t s1_172_1 = *(gl64_t*)&expressions_params[10][15+1];
    gl64_t s1_172_2 = *(gl64_t*)&expressions_params[10][15+2];
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
    // Op 173: dim3x1 add
    gl64_t s1_173 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_173; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 174: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 175: dim3x3 mul
    gl64_t s1_175_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_175_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_175_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA175 = (tmp3_0 + tmp3_1) * (s1_175_0 + s1_175_1);
    gl64_t kB175 = (tmp3_0 + tmp3_2) * (s1_175_0 + s1_175_2);
    gl64_t kC175 = (tmp3_1 + tmp3_2) * (s1_175_1 + s1_175_2);
    gl64_t kD175 = tmp3_0 * s1_175_0;
    gl64_t kE175 = tmp3_1 * s1_175_1;
    gl64_t kF175 = tmp3_2 * s1_175_2;
    gl64_t kG175 = kD175 - kE175;
    tmp3_6 = (kC175 + kG175) - kF175;
    tmp3_7 = ((((kA175 + kC175) - kE175) - kE175) - kD175);
    tmp3_8 = kB175 - kG175;
    // Op 176: dim3x1 mul
    gl64_t s0_176_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_176_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_176_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_176 = *(gl64_t*)&expressions_params[10][8];
    tmp3_0 = s0_176_0 * s1_176; tmp3_1 = s0_176_1 * s1_176; tmp3_2 = s0_176_2 * s1_176;
    // Op 177: dim3x1 add
    gl64_t s1_177 = *(gl64_t*)&expressions_params[10][7];
    tmp3_0 = tmp3_0 + s1_177; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 178: dim3x3 mul
    gl64_t s1_178_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_178_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_178_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA178 = (tmp3_0 + tmp3_1) * (s1_178_0 + s1_178_1);
    gl64_t kB178 = (tmp3_0 + tmp3_2) * (s1_178_0 + s1_178_2);
    gl64_t kC178 = (tmp3_1 + tmp3_2) * (s1_178_1 + s1_178_2);
    gl64_t kD178 = tmp3_0 * s1_178_0;
    gl64_t kE178 = tmp3_1 * s1_178_1;
    gl64_t kF178 = tmp3_2 * s1_178_2;
    gl64_t kG178 = kD178 - kE178;
    tmp3_0 = (kC178 + kG178) - kF178;
    tmp3_1 = ((((kA178 + kC178) - kE178) - kE178) - kD178);
    tmp3_2 = kB178 - kG178;
    // Op 179: dim3x1 add
    gl64_t s1_179 = *(gl64_t*)&expressions_params[10][9];
    tmp3_0 = tmp3_0 + s1_179; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 181: dim3x1 add
    gl64_t s1_181 = *(gl64_t*)&expressions_params[10][10];
    tmp3_0 = tmp3_0 + s1_181; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 182: dim3x3 mul
    gl64_t s1_182_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_182_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_182_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA182 = (tmp3_0 + tmp3_1) * (s1_182_0 + s1_182_1);
    gl64_t kB182 = (tmp3_0 + tmp3_2) * (s1_182_0 + s1_182_2);
    gl64_t kC182 = (tmp3_1 + tmp3_2) * (s1_182_1 + s1_182_2);
    gl64_t kD182 = tmp3_0 * s1_182_0;
    gl64_t kE182 = tmp3_1 * s1_182_1;
    gl64_t kF182 = tmp3_2 * s1_182_2;
    gl64_t kG182 = kD182 - kE182;
    tmp3_0 = (kC182 + kG182) - kF182;
    tmp3_1 = ((((kA182 + kC182) - kE182) - kE182) - kD182);
    tmp3_2 = kB182 - kG182;
    // Op 183: dim1x1 add
    gl64_t s0_183 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_183 = *(gl64_t*)&expressions_params[10][0];
    tmp1_4 = s0_183 + s1_183;
    // Op 184: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_186 = *(gl64_t*)&expressions_params[9][7];
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
    gl64_t s1_188 = *(gl64_t*)&expressions_params[9][8];
    tmp3_0 = tmp3_0 + s1_188; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 189: dim3x3 add
    gl64_t s1_189_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_189_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_189_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_189_0; tmp3_1 = tmp3_1 + s1_189_1; tmp3_2 = tmp3_2 + s1_189_2;
    // Op 190: dim3x3 mul
    gl64_t s1_190_0 = *(gl64_t*)&expressions_params[10][18];
    gl64_t s1_190_1 = *(gl64_t*)&expressions_params[10][18+1];
    gl64_t s1_190_2 = *(gl64_t*)&expressions_params[10][18+2];
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
    // Op 191: dim1x1 sub
    gl64_t s0_191 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_191 = *(gl64_t*)&expressions_params[10][2];
    tmp1_4 = s0_191 - s1_191;
    // Op 192: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 193: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 194: dim3x3 mul
    gl64_t s1_194_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_194_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_194_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA194 = (tmp3_0 + tmp3_1) * (s1_194_0 + s1_194_1);
    gl64_t kB194 = (tmp3_0 + tmp3_2) * (s1_194_0 + s1_194_2);
    gl64_t kC194 = (tmp3_1 + tmp3_2) * (s1_194_1 + s1_194_2);
    gl64_t kD194 = tmp3_0 * s1_194_0;
    gl64_t kE194 = tmp3_1 * s1_194_1;
    gl64_t kF194 = tmp3_2 * s1_194_2;
    gl64_t kG194 = kD194 - kE194;
    tmp3_6 = (kC194 + kG194) - kF194;
    tmp3_7 = ((((kA194 + kC194) - kE194) - kE194) - kD194);
    tmp3_8 = kB194 - kG194;
    // Op 195: dim3x1 mul
    gl64_t s0_195_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_195_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_195_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_195 = *(gl64_t*)&expressions_params[10][11];
    tmp3_0 = s0_195_0 * s1_195; tmp3_1 = s0_195_1 * s1_195; tmp3_2 = s0_195_2 * s1_195;
    // Op 196: dim3x1 add
    gl64_t s1_196 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_196; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 197: dim3x3 add
    gl64_t s1_197_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_197_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_197_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_197_0; tmp3_1 = tmp3_1 + s1_197_1; tmp3_2 = tmp3_2 + s1_197_2;
    // Op 198: dim3x3 mul
    gl64_t s1_198_0 = *(gl64_t*)&expressions_params[10][21];
    gl64_t s1_198_1 = *(gl64_t*)&expressions_params[10][21+1];
    gl64_t s1_198_2 = *(gl64_t*)&expressions_params[10][21+2];
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
    // Op 199: dim3x1 add
    gl64_t s1_199 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_199; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 200: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 201: dim3x3 mul
    gl64_t s1_201_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_201_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_201_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA201 = (tmp3_0 + tmp3_1) * (s1_201_0 + s1_201_1);
    gl64_t kB201 = (tmp3_0 + tmp3_2) * (s1_201_0 + s1_201_2);
    gl64_t kC201 = (tmp3_1 + tmp3_2) * (s1_201_1 + s1_201_2);
    gl64_t kD201 = tmp3_0 * s1_201_0;
    gl64_t kE201 = tmp3_1 * s1_201_1;
    gl64_t kF201 = tmp3_2 * s1_201_2;
    gl64_t kG201 = kD201 - kE201;
    tmp3_6 = (kC201 + kG201) - kF201;
    tmp3_7 = ((((kA201 + kC201) - kE201) - kE201) - kD201);
    tmp3_8 = kB201 - kG201;
    // Op 202: dim3x1 mul
    gl64_t s0_202_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_202_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_202_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_202 = *(gl64_t*)&expressions_params[10][12];
    tmp3_0 = s0_202_0 * s1_202; tmp3_1 = s0_202_1 * s1_202; tmp3_2 = s0_202_2 * s1_202;
    // Op 203: dim3x1 add
    gl64_t s1_203 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_203; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 204: dim3x3 add
    gl64_t s1_204_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_204_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_204_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_204_0; tmp3_1 = tmp3_1 + s1_204_1; tmp3_2 = tmp3_2 + s1_204_2;
    // Op 205: dim3x3 mul
    gl64_t s1_205_0 = *(gl64_t*)&expressions_params[10][24];
    gl64_t s1_205_1 = *(gl64_t*)&expressions_params[10][24+1];
    gl64_t s1_205_2 = *(gl64_t*)&expressions_params[10][24+2];
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
    // Op 206: dim3x1 add
    gl64_t s1_206 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_206; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 207: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 208: dim3x3 mul
    gl64_t s1_208_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_208_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_208_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA208 = (tmp3_0 + tmp3_1) * (s1_208_0 + s1_208_1);
    gl64_t kB208 = (tmp3_0 + tmp3_2) * (s1_208_0 + s1_208_2);
    gl64_t kC208 = (tmp3_1 + tmp3_2) * (s1_208_1 + s1_208_2);
    gl64_t kD208 = tmp3_0 * s1_208_0;
    gl64_t kE208 = tmp3_1 * s1_208_1;
    gl64_t kF208 = tmp3_2 * s1_208_2;
    gl64_t kG208 = kD208 - kE208;
    tmp3_6 = (kC208 + kG208) - kF208;
    tmp3_7 = ((((kA208 + kC208) - kE208) - kE208) - kD208);
    tmp3_8 = kB208 - kG208;
    // Op 209: dim3x1 mul
    gl64_t s0_209_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_209_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_209_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_209 = *(gl64_t*)&expressions_params[10][13];
    tmp3_0 = s0_209_0 * s1_209; tmp3_1 = s0_209_1 * s1_209; tmp3_2 = s0_209_2 * s1_209;
    // Op 210: dim3x1 add
    gl64_t s1_210 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_210; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 211: dim3x3 add
    gl64_t s1_211_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_211_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_211_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_211_0; tmp3_1 = tmp3_1 + s1_211_1; tmp3_2 = tmp3_2 + s1_211_2;
    // Op 212: dim3x3 mul
    gl64_t s1_212_0 = *(gl64_t*)&expressions_params[10][27];
    gl64_t s1_212_1 = *(gl64_t*)&expressions_params[10][27+1];
    gl64_t s1_212_2 = *(gl64_t*)&expressions_params[10][27+2];
    gl64_t kA212 = (tmp3_0 + tmp3_1) * (s1_212_0 + s1_212_1);
    gl64_t kB212 = (tmp3_0 + tmp3_2) * (s1_212_0 + s1_212_2);
    gl64_t kC212 = (tmp3_1 + tmp3_2) * (s1_212_1 + s1_212_2);
    gl64_t kD212 = tmp3_0 * s1_212_0;
    gl64_t kE212 = tmp3_1 * s1_212_1;
    gl64_t kF212 = tmp3_2 * s1_212_2;
    gl64_t kG212 = kD212 - kE212;
    tmp3_0 = (kC212 + kG212) - kF212;
    tmp3_1 = ((((kA212 + kC212) - kE212) - kE212) - kD212);
    tmp3_2 = kB212 - kG212;
    // Op 213: dim3x1 add
    gl64_t s1_213 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_213; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 214: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    tmp3_6 = (kC215 + kG215) - kF215;
    tmp3_7 = ((((kA215 + kC215) - kE215) - kE215) - kD215);
    tmp3_8 = kB215 - kG215;
    // Op 216: dim3x1 mul
    gl64_t s0_216_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_216_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_216_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_216 = *(gl64_t*)&expressions_params[10][14];
    tmp3_0 = s0_216_0 * s1_216; tmp3_1 = s0_216_1 * s1_216; tmp3_2 = s0_216_2 * s1_216;
    // Op 217: dim3x1 add
    gl64_t s1_217 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_217; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 218: dim3x3 add
    gl64_t s1_218_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_218_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_218_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_218_0; tmp3_1 = tmp3_1 + s1_218_1; tmp3_2 = tmp3_2 + s1_218_2;
    // Op 219: dim3x3 mul
    gl64_t s1_219_0 = *(gl64_t*)&expressions_params[10][30];
    gl64_t s1_219_1 = *(gl64_t*)&expressions_params[10][30+1];
    gl64_t s1_219_2 = *(gl64_t*)&expressions_params[10][30+2];
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
    // Op 220: dim3x1 add
    gl64_t s1_220 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_220; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 221: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    // Op 223: dim3x3 sub_swap
    uint64_t s0_223_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_223_0 = *(gl64_t*)&dParams->aux_trace[s0_223_pos];
    gl64_t s0_223_1 = *(gl64_t*)&dParams->aux_trace[s0_223_pos + TILE_HEIGHT];
    gl64_t s0_223_2 = *(gl64_t*)&dParams->aux_trace[s0_223_pos + 2*TILE_HEIGHT];
    gl64_t s1_223_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_223_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_223_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_6 = s1_223_0 - s0_223_0; tmp3_7 = s1_223_1 - s0_223_1; tmp3_8 = s1_223_2 - s0_223_2;
    // Op 224: dim3x3 add
    gl64_t s0_224_0 = *(gl64_t*)&expressions_params[10][15];
    gl64_t s0_224_1 = *(gl64_t*)&expressions_params[10][15+1];
    gl64_t s0_224_2 = *(gl64_t*)&expressions_params[10][15+2];
    gl64_t s1_224_0 = *(gl64_t*)&expressions_params[10][18];
    gl64_t s1_224_1 = *(gl64_t*)&expressions_params[10][18+1];
    gl64_t s1_224_2 = *(gl64_t*)&expressions_params[10][18+2];
    tmp3_0 = s0_224_0 + s1_224_0; tmp3_1 = s0_224_1 + s1_224_1; tmp3_2 = s0_224_2 + s1_224_2;
    // Op 225: dim3x3 add
    gl64_t s1_225_0 = *(gl64_t*)&expressions_params[10][21];
    gl64_t s1_225_1 = *(gl64_t*)&expressions_params[10][21+1];
    gl64_t s1_225_2 = *(gl64_t*)&expressions_params[10][21+2];
    tmp3_0 = tmp3_0 + s1_225_0; tmp3_1 = tmp3_1 + s1_225_1; tmp3_2 = tmp3_2 + s1_225_2;
    // Op 226: dim3x3 add
    gl64_t s1_226_0 = *(gl64_t*)&expressions_params[10][24];
    gl64_t s1_226_1 = *(gl64_t*)&expressions_params[10][24+1];
    gl64_t s1_226_2 = *(gl64_t*)&expressions_params[10][24+2];
    tmp3_0 = tmp3_0 + s1_226_0; tmp3_1 = tmp3_1 + s1_226_1; tmp3_2 = tmp3_2 + s1_226_2;
    // Op 227: dim3x3 add
    gl64_t s1_227_0 = *(gl64_t*)&expressions_params[10][27];
    gl64_t s1_227_1 = *(gl64_t*)&expressions_params[10][27+1];
    gl64_t s1_227_2 = *(gl64_t*)&expressions_params[10][27+2];
    tmp3_0 = tmp3_0 + s1_227_0; tmp3_1 = tmp3_1 + s1_227_1; tmp3_2 = tmp3_2 + s1_227_2;
    // Op 228: dim3x3 add
    gl64_t s1_228_0 = *(gl64_t*)&expressions_params[10][30];
    gl64_t s1_228_1 = *(gl64_t*)&expressions_params[10][30+1];
    gl64_t s1_228_2 = *(gl64_t*)&expressions_params[10][30+2];
    tmp3_0 = tmp3_0 + s1_228_0; tmp3_1 = tmp3_1 + s1_228_1; tmp3_2 = tmp3_2 + s1_228_2;
    // Op 229: dim3x3 sub
    tmp3_0 = tmp3_6 - tmp3_0; tmp3_1 = tmp3_7 - tmp3_1; tmp3_2 = tmp3_8 - tmp3_2;
    // Op 230: dim3x1 mul
    gl64_t s1_230 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_230; tmp3_1 = tmp3_1 * s1_230; tmp3_2 = tmp3_2 * s1_230;
    // Op 231: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 232: dim3x3 mul
    gl64_t s1_232_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_232_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_232_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 233: dim1x1 sub_swap
    gl64_t s0_233 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_233 = *(gl64_t*)&expressions_params[9][0];
    tmp1_4 = s1_233 - s0_233;
    // Op 234: dim1x1 sub_swap
    gl64_t s0_234 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_234 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_234 - s0_234;
    // Op 235: dim1x1 mul
    tmp1_0 = tmp1_4 * tmp1_0;
    // Op 236: dim1x1 sub
    gl64_t s0_236 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2))];
    tmp1_0 = s0_236 - tmp1_0;
    // Op 237: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 238: dim3x3 mul
    gl64_t s1_238_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_238_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_238_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA238 = (tmp3_0 + tmp3_1) * (s1_238_0 + s1_238_1);
    gl64_t kB238 = (tmp3_0 + tmp3_2) * (s1_238_0 + s1_238_2);
    gl64_t kC238 = (tmp3_1 + tmp3_2) * (s1_238_1 + s1_238_2);
    gl64_t kD238 = tmp3_0 * s1_238_0;
    gl64_t kE238 = tmp3_1 * s1_238_1;
    gl64_t kF238 = tmp3_2 * s1_238_2;
    gl64_t kG238 = kD238 - kE238;
    tmp3_0 = (kC238 + kG238) - kF238;
    tmp3_1 = ((((kA238 + kC238) - kE238) - kE238) - kD238);
    tmp3_2 = kB238 - kG238;
    // Op 239: dim1x1 sub_swap
    gl64_t s0_239 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_239 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_239 - s0_239;
    // Op 240: dim1x1 sub_swap
    gl64_t s0_240 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_240 = *(gl64_t*)&expressions_params[9][0];
    tmp1_4 = s1_240 - s0_240;
    // Op 241: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_4;
    // Op 242: dim1x1 sub
    gl64_t s0_242 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_2))];
    tmp1_0 = s0_242 - tmp1_0;
    // Op 243: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 244: dim3x1 mul
    gl64_t s1_244 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_244; tmp3_1 = tmp3_1 * s1_244; tmp3_2 = tmp3_2 * s1_244;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
