// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: 0d2d2ae5  nOps=298 nTemp1=5 nTemp3=5
#define GENERATED_EVAL_NOPS_0d2d2ae5 298
#define GENERATED_EVAL_NTEMP1_0d2d2ae5 5
#define GENERATED_EVAL_NTEMP3_0d2d2ae5 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_0d2d2ae5(
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
    gl64_t s0_10 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_10 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_10 - s0_10;
    // Op 11: dim1x1 mul
    gl64_t s0_11 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
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
    gl64_t s0_14 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_14 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_14 - s0_14;
    // Op 15: dim1x1 mul
    gl64_t s0_15 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
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
    gl64_t s0_18 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_18 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_18 - s0_18;
    // Op 19: dim1x1 mul
    gl64_t s0_19 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
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
    gl64_t s0_22 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_22 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_22 - s0_22;
    // Op 23: dim1x1 mul
    gl64_t s0_23 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
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
    // Op 26: dim1x1 sub_swap
    gl64_t s0_26 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_26 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_26 - s0_26;
    // Op 27: dim1x1 mul
    gl64_t s0_27 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_27 * tmp1_0;
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
    tmp3_0 = (kC29 + kG29) - kF29;
    tmp3_1 = ((((kA29 + kC29) - kE29) - kE29) - kD29);
    tmp3_2 = kB29 - kG29;
    // Op 30: dim1x1 sub_swap
    gl64_t s0_30 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_30 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_30 - s0_30;
    // Op 31: dim1x1 mul
    gl64_t s0_31 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_31 * tmp1_0;
    // Op 32: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 33: dim3x3 mul
    gl64_t s1_33_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_33_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_33_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 34: dim1x1 sub
    gl64_t s0_34 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_34 = *(gl64_t*)&expressions_params[10][7];
    tmp1_0 = s0_34 - s1_34;
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
    gl64_t s0_38 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_38 = *(gl64_t*)&expressions_params[10][8];
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
    gl64_t s0_42 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_42 = *(gl64_t*)&expressions_params[10][10];
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
    // Op 46: dim1x1 sub
    gl64_t s0_46 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_46 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_46 - s1_46;
    // Op 47: dim1x1 mul
    gl64_t s0_47 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_47 * tmp1_0;
    // Op 48: dim1x1 add
    gl64_t s0_48 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_48 + tmp1_0;
    // Op 49: dim1x1 sub
    gl64_t s1_49 = *(gl64_t*)&expressions_params[10][9];
    tmp1_0 = tmp1_0 - s1_49;
    // Op 50: dim1x1 mul
    gl64_t s0_50 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
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
    gl64_t s0_53 = *(gl64_t*)&expressions_params[9][10];
    gl64_t s1_53 = *(gl64_t*)&expressions_params[10][6];
    tmp1_1 = s1_53 - s0_53;
    // Op 54: dim1x1 mul
    gl64_t s0_54 = *(gl64_t*)&expressions_params[9][11];
    gl64_t s1_54 = *(gl64_t*)&expressions_params[10][12];
    tmp1_0 = s0_54 * s1_54;
    // Op 55: dim1x1 add
    gl64_t s1_55 = *(gl64_t*)&expressions_params[10][11];
    tmp1_0 = tmp1_0 + s1_55;
    // Op 56: dim1x1 sub
    tmp1_0 = tmp1_1 - tmp1_0;
    // Op 57: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 58: dim3x3 mul
    gl64_t s1_58_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_58_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_58_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 59: dim1x1 sub
    gl64_t s0_59 = *(gl64_t*)&expressions_params[9][12];
    gl64_t s1_59 = *(gl64_t*)&expressions_params[10][10];
    tmp1_1 = s0_59 - s1_59;
    // Op 60: dim1x1 mul
    gl64_t s0_60 = *(gl64_t*)&expressions_params[9][11];
    gl64_t s1_60 = *(gl64_t*)&expressions_params[10][14];
    tmp1_0 = s0_60 * s1_60;
    // Op 61: dim1x1 add
    gl64_t s1_61 = *(gl64_t*)&expressions_params[10][13];
    tmp1_0 = tmp1_0 + s1_61;
    // Op 62: dim1x1 sub
    tmp1_0 = tmp1_1 - tmp1_0;
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
    // Op 65: dim1x1 mul
    gl64_t s0_65 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_65 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_65 * s1_65;
    // Op 66: dim1x1 sub_swap
    gl64_t s0_66 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_66 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s1_66 - s0_66;
    // Op 67: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 68: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 69: dim3x3 mul
    gl64_t s1_69_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_69_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_69_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 70: dim1x1 sub
    gl64_t s0_70 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 4, domainSize, nCols_1))];
    gl64_t s1_70 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 1, domainSize, nCols_1))];
    tmp1_0 = s0_70 - s1_70;
    // Op 71: dim1x1 mul
    gl64_t s0_71 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 5, domainSize, nCols_1))];
    tmp1_0 = s0_71 * tmp1_0;
    // Op 72: dim1x1 add
    gl64_t s0_72 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 1, domainSize, nCols_1))];
    tmp1_1 = s0_72 + tmp1_0;
    // Op 73: dim1x1 sub_swap
    gl64_t s1_73 = *(gl64_t*)&expressions_params[10][5];
    tmp1_0 = s1_73 - tmp1_1;
    // Op 74: dim1x1 mul
    gl64_t s0_74 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_0 = s0_74 * tmp1_0;
    // Op 75: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 76: dim1x1 sub
    gl64_t s0_76 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_76 - tmp1_0;
    // Op 77: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC78 + kG78) - kF78;
    tmp3_1 = ((((kA78 + kC78) - kE78) - kE78) - kD78);
    tmp3_2 = kB78 - kG78;
    // Op 79: dim1x1 mul
    gl64_t s0_79 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_79 = *(gl64_t*)&expressions_params[9][13];
    tmp1_0 = s0_79 * s1_79;
    // Op 80: dim1x1 add
    gl64_t s0_80 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_80 + tmp1_0;
    // Op 81: dim1x1 add
    gl64_t s1_81 = *(gl64_t*)&expressions_params[9][0];
    tmp1_3 = tmp1_0 + s1_81;
    // Op 82: dim1x1 sub_swap
    gl64_t s0_82 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_1))];
    gl64_t s1_82 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s1_82 - s0_82;
    // Op 83: dim1x1 mul
    gl64_t s0_83 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_0 = s0_83 * tmp1_0;
    // Op 84: dim1x1 add
    gl64_t s0_84 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_1))];
    tmp1_4 = s0_84 + tmp1_0;
    // Op 85: dim1x1 sub
    gl64_t s0_85 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_2 = s0_85 - tmp1_4;
    // Op 86: dim1x1 sub
    gl64_t s0_86 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_86 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_86 - s1_86;
    // Op 87: dim1x1 sub_swap
    gl64_t s0_87 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_87 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s1_87 - s0_87;
    // Op 88: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 89: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_0;
    // Op 90: dim1x1 mul
    gl64_t s0_90 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_2 = s0_90 * tmp1_2;
    // Op 91: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 92: dim1x1 sub
    tmp1_0 = tmp1_3 - tmp1_0;
    // Op 93: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC94 + kG94) - kF94;
    tmp3_1 = ((((kA94 + kC94) - kE94) - kE94) - kD94);
    tmp3_2 = kB94 - kG94;
    // Op 95: dim1x1 mul
    gl64_t s0_95 = *(gl64_t*)&expressions_params[9][13];
    gl64_t s1_95 = *(gl64_t*)&expressions_params[10][16];
    tmp1_0 = s0_95 * s1_95;
    // Op 96: dim1x1 add
    gl64_t s1_96 = *(gl64_t*)&expressions_params[10][15];
    tmp1_0 = tmp1_0 + s1_96;
    // Op 97: dim1x1 sub_swap
    gl64_t s1_97 = *(gl64_t*)&expressions_params[10][9];
    tmp1_0 = s1_97 - tmp1_0;
    // Op 98: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC99 + kG99) - kF99;
    tmp3_1 = ((((kA99 + kC99) - kE99) - kE99) - kD99);
    tmp3_2 = kB99 - kG99;
    // Op 100: dim1x1 sub_swap
    gl64_t s0_100 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_100 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_100 - s0_100;
    // Op 101: dim1x1 sub_swap
    gl64_t s0_101 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_101 = *(gl64_t*)&expressions_params[9][0];
    tmp1_3 = s1_101 - s0_101;
    // Op 102: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_3;
    // Op 103: dim1x1 sub
    gl64_t s0_103 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_103 - tmp1_0;
    // Op 104: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 105: dim3x3 mul
    gl64_t s1_105_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_105_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_105_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 106: dim1x1 sub_swap
    gl64_t s0_106 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_106 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_106 - s0_106;
    // Op 107: dim1x1 sub
    gl64_t s0_107 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_4 = s0_107 - tmp1_4;
    // Op 108: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_4;
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
    gl64_t s0_111 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 6, domainSize, nCols_1))];
    gl64_t s1_111 = *(gl64_t*)&expressions_params[10][3];
    tmp1_0 = s1_111 - s0_111;
    // Op 112: dim1x1 mul
    gl64_t s0_112 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_0 = s0_112 * tmp1_0;
    // Op 113: dim1x1 add
    gl64_t s0_113 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 6, domainSize, nCols_1))];
    tmp1_0 = s0_113 + tmp1_0;
    // Op 114: dim1x1 sub
    gl64_t s0_114 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_114 - tmp1_0;
    // Op 115: dim1x1 mul
    gl64_t s0_115 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_115 * tmp1_0;
    // Op 116: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 117: dim3x3 mul
    gl64_t s1_117_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_117_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_117_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA117 = (tmp3_0 + tmp3_1) * (s1_117_0 + s1_117_1);
    gl64_t kB117 = (tmp3_0 + tmp3_2) * (s1_117_0 + s1_117_2);
    gl64_t kC117 = (tmp3_1 + tmp3_2) * (s1_117_1 + s1_117_2);
    gl64_t kD117 = tmp3_0 * s1_117_0;
    gl64_t kE117 = tmp3_1 * s1_117_1;
    gl64_t kF117 = tmp3_2 * s1_117_2;
    gl64_t kG117 = kD117 - kE117;
    tmp3_0 = (kC117 + kG117) - kF117;
    tmp3_1 = ((((kA117 + kC117) - kE117) - kE117) - kD117);
    tmp3_2 = kB117 - kG117;
    // Op 118: dim1x1 sub_swap
    gl64_t s0_118 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_118 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_118 - s0_118;
    // Op 119: dim1x1 mul
    gl64_t s0_119 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_119 * tmp1_0;
    // Op 120: dim1x1 mul
    gl64_t s0_120 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_120 * tmp1_0;
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
    gl64_t s0_123 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 7, domainSize, nCols_1))];
    gl64_t s1_123 = *(gl64_t*)&expressions_params[10][4];
    tmp1_0 = s1_123 - s0_123;
    // Op 124: dim1x1 mul
    gl64_t s0_124 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_0 = s0_124 * tmp1_0;
    // Op 125: dim1x1 add
    gl64_t s0_125 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 7, domainSize, nCols_1))];
    tmp1_0 = s0_125 + tmp1_0;
    // Op 126: dim1x1 sub
    gl64_t s0_126 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_126 - tmp1_0;
    // Op 127: dim1x1 mul
    gl64_t s0_127 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_127 * tmp1_0;
    // Op 128: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 129: dim3x3 mul
    gl64_t s1_129_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_129_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_129_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 130: dim1x1 sub_swap
    gl64_t s0_130 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_130 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_130 - s0_130;
    // Op 131: dim1x1 mul
    gl64_t s0_131 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_131 * tmp1_0;
    // Op 132: dim1x1 mul
    gl64_t s0_132 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_132 * tmp1_0;
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
    tmp3_12 = (kC134 + kG134) - kF134;
    tmp3_13 = ((((kA134 + kC134) - kE134) - kE134) - kD134);
    tmp3_14 = kB134 - kG134;
    // Op 135: dim3x1 mul
    gl64_t s0_135_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_135_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_135_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_135 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp3_0 = s0_135_0 * s1_135; tmp3_1 = s0_135_1 * s1_135; tmp3_2 = s0_135_2 * s1_135;
    // Op 136: dim3x1 add
    gl64_t s1_136 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_0 + s1_136; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 137: dim3x3 add
    gl64_t s1_137_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_137_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_137_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_137_0; tmp3_4 = tmp3_10 + s1_137_1; tmp3_5 = tmp3_11 + s1_137_2;
    // Op 138: dim1x1 sub
    gl64_t s0_138 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_138 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_138 - s1_138;
    // Op 139: dim1x1 sub_swap
    gl64_t s0_139 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = tmp1_0 - s0_139;
    // Op 140: dim3x1 mul
    gl64_t s0_140_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_140_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_140_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_140_0 * tmp1_0; tmp3_1 = s0_140_1 * tmp1_0; tmp3_2 = s0_140_2 * tmp1_0;
    // Op 141: dim3x1 add
    gl64_t s1_141 = *(gl64_t*)&expressions_params[9][1];
    tmp3_6 = tmp3_0 + s1_141; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 142: dim3x3 add
    gl64_t s1_142_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_142_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_142_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_142_0; tmp3_1 = tmp3_7 + s1_142_1; tmp3_2 = tmp3_8 + s1_142_2;
    // Op 143: dim3x3 mul
    gl64_t kA143 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB143 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC143 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD143 = tmp3_3 * tmp3_0;
    gl64_t kE143 = tmp3_4 * tmp3_1;
    gl64_t kF143 = tmp3_5 * tmp3_2;
    gl64_t kG143 = kD143 - kE143;
    tmp3_0 = (kC143 + kG143) - kF143;
    tmp3_1 = ((((kA143 + kC143) - kE143) - kE143) - kD143);
    tmp3_2 = kB143 - kG143;
    // Op 144: dim3x3 mul
    gl64_t s0_144_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_144_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_144_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA144 = (s0_144_0 + s0_144_1) * (tmp3_0 + tmp3_1);
    gl64_t kB144 = (s0_144_0 + s0_144_2) * (tmp3_0 + tmp3_2);
    gl64_t kC144 = (s0_144_1 + s0_144_2) * (tmp3_1 + tmp3_2);
    gl64_t kD144 = s0_144_0 * tmp3_0;
    gl64_t kE144 = s0_144_1 * tmp3_1;
    gl64_t kF144 = s0_144_2 * tmp3_2;
    gl64_t kG144 = kD144 - kE144;
    tmp3_0 = (kC144 + kG144) - kF144;
    tmp3_1 = ((((kA144 + kC144) - kE144) - kE144) - kD144);
    tmp3_2 = kB144 - kG144;
    // Op 145: dim3x3 add
    gl64_t s1_145_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_145_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_145_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_145_0; tmp3_7 = tmp3_7 + s1_145_1; tmp3_8 = tmp3_8 + s1_145_2;
    // Op 146: dim3x1 mul
    gl64_t s1_146 = *(gl64_t*)&expressions_params[9][2];
    tmp3_6 = tmp3_6 * s1_146; tmp3_7 = tmp3_7 * s1_146; tmp3_8 = tmp3_8 * s1_146;
    // Op 147: dim1x1 sub_swap
    gl64_t s0_147 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_147 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s1_147 - s0_147;
    // Op 148: dim3x3 add
    gl64_t s1_148_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_148_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_148_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_148_0; tmp3_10 = tmp3_10 + s1_148_1; tmp3_11 = tmp3_11 + s1_148_2;
    // Op 149: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 150: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 151: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 152: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
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
    tmp3_3 = (kC153 + kG153) - kF153;
    tmp3_4 = ((((kA153 + kC153) - kE153) - kE153) - kD153);
    tmp3_5 = kB153 - kG153;
    // Op 154: dim3x1 mul
    gl64_t s0_154_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_154_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_154_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_154 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp3_0 = s0_154_0 * s1_154; tmp3_1 = s0_154_1 * s1_154; tmp3_2 = s0_154_2 * s1_154;
    // Op 155: dim3x1 add
    gl64_t s1_155 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
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
    gl64_t s1_157 = *(gl64_t*)&expressions_params[9][5];
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
    gl64_t s1_159 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
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
    // Op 161: dim1x1 mul
    gl64_t s0_161 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_161 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_161 * s1_161;
    // Op 162: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 164: dim1x1 add
    gl64_t s0_164 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_164 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_164 + s1_164;
    // Op 165: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_167 = *(gl64_t*)&expressions_params[9][6];
    tmp3_9 = tmp3_0 + s1_167; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 168: dim3x3 add
    gl64_t s1_168_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_168_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_168_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_168_0; tmp3_13 = tmp3_10 + s1_168_1; tmp3_14 = tmp3_11 + s1_168_2;
    // Op 169: dim3x1 mul
    gl64_t s0_169_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_169_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_169_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_169 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp3_0 = s0_169_0 * s1_169; tmp3_1 = s0_169_1 * s1_169; tmp3_2 = s0_169_2 * s1_169;
    // Op 170: dim3x1 add
    gl64_t s1_170 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_170; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 171: dim3x3 mul
    gl64_t s1_171_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_171_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_171_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 172: dim3x1 add
    gl64_t s1_172 = *(gl64_t*)&expressions_params[9][5];
    tmp3_0 = tmp3_0 + s1_172; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 173: dim3x3 mul
    gl64_t s1_173_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_173_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_173_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA173 = (tmp3_0 + tmp3_1) * (s1_173_0 + s1_173_1);
    gl64_t kB173 = (tmp3_0 + tmp3_2) * (s1_173_0 + s1_173_2);
    gl64_t kC173 = (tmp3_1 + tmp3_2) * (s1_173_1 + s1_173_2);
    gl64_t kD173 = tmp3_0 * s1_173_0;
    gl64_t kE173 = tmp3_1 * s1_173_1;
    gl64_t kF173 = tmp3_2 * s1_173_2;
    gl64_t kG173 = kD173 - kE173;
    tmp3_0 = (kC173 + kG173) - kF173;
    tmp3_1 = ((((kA173 + kC173) - kE173) - kE173) - kD173);
    tmp3_2 = kB173 - kG173;
    // Op 174: dim3x1 add
    gl64_t s1_174 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
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
    // Op 176: dim1x1 mul
    gl64_t s0_176 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_176 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_176 * s1_176;
    // Op 177: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_179 = *(gl64_t*)&expressions_params[9][0];
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
    gl64_t s1_181 = *(gl64_t*)&expressions_params[9][6];
    tmp3_6 = tmp3_0 + s1_181; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 182: dim3x3 add
    gl64_t s1_182_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_182_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_182_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_182_0; tmp3_1 = tmp3_7 + s1_182_1; tmp3_2 = tmp3_8 + s1_182_2;
    // Op 183: dim3x3 mul
    gl64_t kA183 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB183 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC183 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD183 = tmp3_12 * tmp3_0;
    gl64_t kE183 = tmp3_13 * tmp3_1;
    gl64_t kF183 = tmp3_14 * tmp3_2;
    gl64_t kG183 = kD183 - kE183;
    tmp3_0 = (kC183 + kG183) - kF183;
    tmp3_1 = ((((kA183 + kC183) - kE183) - kE183) - kD183);
    tmp3_2 = kB183 - kG183;
    // Op 184: dim3x3 mul
    gl64_t s0_184_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_184_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_184_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA184 = (s0_184_0 + s0_184_1) * (tmp3_0 + tmp3_1);
    gl64_t kB184 = (s0_184_0 + s0_184_2) * (tmp3_0 + tmp3_2);
    gl64_t kC184 = (s0_184_1 + s0_184_2) * (tmp3_1 + tmp3_2);
    gl64_t kD184 = s0_184_0 * tmp3_0;
    gl64_t kE184 = s0_184_1 * tmp3_1;
    gl64_t kF184 = s0_184_2 * tmp3_2;
    gl64_t kG184 = kD184 - kE184;
    tmp3_0 = (kC184 + kG184) - kF184;
    tmp3_1 = ((((kA184 + kC184) - kE184) - kE184) - kD184);
    tmp3_2 = kB184 - kG184;
    // Op 185: dim3x3 add
    gl64_t s1_185_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_185_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_185_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_185_0; tmp3_7 = tmp3_7 + s1_185_1; tmp3_8 = tmp3_8 + s1_185_2;
    // Op 186: dim3x1 mul
    gl64_t s1_186 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_6 = tmp3_6 * s1_186; tmp3_7 = tmp3_7 * s1_186; tmp3_8 = tmp3_8 * s1_186;
    // Op 187: dim3x3 add
    gl64_t s1_187_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_187_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_187_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_187_0; tmp3_10 = tmp3_10 + s1_187_1; tmp3_11 = tmp3_11 + s1_187_2;
    // Op 188: dim3x1 mul
    gl64_t s1_188 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_188; tmp3_10 = tmp3_10 * s1_188; tmp3_11 = tmp3_11 * s1_188;
    // Op 189: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 190: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 191: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
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
    // Op 193: dim1x1 sub_swap
    gl64_t s0_193 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_0)];
    gl64_t s1_193 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_193 - s0_193;
    // Op 194: dim3x1 mul
    uint64_t s0_194_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_194_0 = *(gl64_t*)&dParams->aux_trace[s0_194_pos];
    gl64_t s0_194_1 = *(gl64_t*)&dParams->aux_trace[s0_194_pos + TILE_HEIGHT];
    gl64_t s0_194_2 = *(gl64_t*)&dParams->aux_trace[s0_194_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_194_0 * tmp1_0; tmp3_1 = s0_194_1 * tmp1_0; tmp3_2 = s0_194_2 * tmp1_0;
    // Op 195: dim3x3 sub
    uint64_t s0_195_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_195_0 = *(gl64_t*)&dParams->aux_trace[s0_195_pos];
    gl64_t s0_195_1 = *(gl64_t*)&dParams->aux_trace[s0_195_pos + TILE_HEIGHT];
    gl64_t s0_195_2 = *(gl64_t*)&dParams->aux_trace[s0_195_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_195_0 - tmp3_0; tmp3_1 = s0_195_1 - tmp3_1; tmp3_2 = s0_195_2 - tmp3_2;
    // Op 196: dim3x3 add
    gl64_t s0_196_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_196_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_196_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_196_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_196_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_196_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_3 = s0_196_0 + s1_196_0; tmp3_4 = s0_196_1 + s1_196_1; tmp3_5 = s0_196_2 + s1_196_2;
    // Op 197: dim3x3 sub
    tmp3_3 = tmp3_0 - tmp3_3; tmp3_4 = tmp3_1 - tmp3_4; tmp3_5 = tmp3_2 - tmp3_5;
    // Op 198: dim3x1 mul
    gl64_t s0_198_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_198_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_198_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_198 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp3_0 = s0_198_0 * s1_198; tmp3_1 = s0_198_1 * s1_198; tmp3_2 = s0_198_2 * s1_198;
    // Op 199: dim3x1 add
    gl64_t s1_199 = *(gl64_t*)&expressions_params[9][9];
    tmp3_0 = tmp3_0 + s1_199; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 200: dim3x3 add
    gl64_t s1_200_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_200_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_200_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_200_0; tmp3_1 = tmp3_1 + s1_200_1; tmp3_2 = tmp3_2 + s1_200_2;
    // Op 201: dim3x3 mul
    gl64_t kA201 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB201 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC201 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD201 = tmp3_3 * tmp3_0;
    gl64_t kE201 = tmp3_4 * tmp3_1;
    gl64_t kF201 = tmp3_5 * tmp3_2;
    gl64_t kG201 = kD201 - kE201;
    tmp3_0 = (kC201 + kG201) - kF201;
    tmp3_1 = ((((kA201 + kC201) - kE201) - kE201) - kD201);
    tmp3_2 = kB201 - kG201;
    // Op 202: dim3x1 add
    gl64_t s1_202 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_202; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 203: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 204: dim3x3 mul
    gl64_t s1_204_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_204_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_204_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA204 = (tmp3_0 + tmp3_1) * (s1_204_0 + s1_204_1);
    gl64_t kB204 = (tmp3_0 + tmp3_2) * (s1_204_0 + s1_204_2);
    gl64_t kC204 = (tmp3_1 + tmp3_2) * (s1_204_1 + s1_204_2);
    gl64_t kD204 = tmp3_0 * s1_204_0;
    gl64_t kE204 = tmp3_1 * s1_204_1;
    gl64_t kF204 = tmp3_2 * s1_204_2;
    gl64_t kG204 = kD204 - kE204;
    tmp3_6 = (kC204 + kG204) - kF204;
    tmp3_7 = ((((kA204 + kC204) - kE204) - kE204) - kD204);
    tmp3_8 = kB204 - kG204;
    // Op 205: dim3x1 mul
    gl64_t s0_205_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_205_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_205_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_205 = *(gl64_t*)&expressions_params[10][4];
    tmp3_0 = s0_205_0 * s1_205; tmp3_1 = s0_205_1 * s1_205; tmp3_2 = s0_205_2 * s1_205;
    // Op 206: dim3x1 add
    gl64_t s1_206 = *(gl64_t*)&expressions_params[10][3];
    tmp3_0 = tmp3_0 + s1_206; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 208: dim3x1 add
    gl64_t s1_208 = *(gl64_t*)&expressions_params[10][5];
    tmp3_0 = tmp3_0 + s1_208; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 209: dim3x3 mul
    gl64_t s1_209_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_209_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_209_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA209 = (tmp3_0 + tmp3_1) * (s1_209_0 + s1_209_1);
    gl64_t kB209 = (tmp3_0 + tmp3_2) * (s1_209_0 + s1_209_2);
    gl64_t kC209 = (tmp3_1 + tmp3_2) * (s1_209_1 + s1_209_2);
    gl64_t kD209 = tmp3_0 * s1_209_0;
    gl64_t kE209 = tmp3_1 * s1_209_1;
    gl64_t kF209 = tmp3_2 * s1_209_2;
    gl64_t kG209 = kD209 - kE209;
    tmp3_0 = (kC209 + kG209) - kF209;
    tmp3_1 = ((((kA209 + kC209) - kE209) - kE209) - kD209);
    tmp3_2 = kB209 - kG209;
    // Op 210: dim3x1 add
    gl64_t s1_210 = *(gl64_t*)&expressions_params[10][6];
    tmp3_0 = tmp3_0 + s1_210; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 212: dim3x1 add
    gl64_t s1_212 = *(gl64_t*)&expressions_params[10][1];
    tmp3_0 = tmp3_0 + s1_212; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 213: dim3x3 mul
    gl64_t s1_213_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_213_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_213_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA213 = (tmp3_0 + tmp3_1) * (s1_213_0 + s1_213_1);
    gl64_t kB213 = (tmp3_0 + tmp3_2) * (s1_213_0 + s1_213_2);
    gl64_t kC213 = (tmp3_1 + tmp3_2) * (s1_213_1 + s1_213_2);
    gl64_t kD213 = tmp3_0 * s1_213_0;
    gl64_t kE213 = tmp3_1 * s1_213_1;
    gl64_t kF213 = tmp3_2 * s1_213_2;
    gl64_t kG213 = kD213 - kE213;
    tmp3_0 = (kC213 + kG213) - kF213;
    tmp3_1 = ((((kA213 + kC213) - kE213) - kE213) - kD213);
    tmp3_2 = kB213 - kG213;
    // Op 214: dim3x1 add
    gl64_t s1_214 = *(gl64_t*)&expressions_params[10][0];
    tmp3_0 = tmp3_0 + s1_214; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 215: dim3x3 mul
    gl64_t s1_215_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_215_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_215_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 216: dim3x1 add
    gl64_t s1_216 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_216; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 217: dim3x3 mul
    gl64_t s1_217_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_217_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_217_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    gl64_t s1_218 = *(gl64_t*)&expressions_params[9][8];
    tmp3_0 = tmp3_0 + s1_218; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 219: dim3x3 add
    gl64_t s1_219_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_219_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_219_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_219_0; tmp3_1 = tmp3_1 + s1_219_1; tmp3_2 = tmp3_2 + s1_219_2;
    // Op 220: dim3x3 mul
    gl64_t s1_220_0 = *(gl64_t*)&expressions_params[10][17];
    gl64_t s1_220_1 = *(gl64_t*)&expressions_params[10][17+1];
    gl64_t s1_220_2 = *(gl64_t*)&expressions_params[10][17+2];
    gl64_t kA220 = (tmp3_0 + tmp3_1) * (s1_220_0 + s1_220_1);
    gl64_t kB220 = (tmp3_0 + tmp3_2) * (s1_220_0 + s1_220_2);
    gl64_t kC220 = (tmp3_1 + tmp3_2) * (s1_220_1 + s1_220_2);
    gl64_t kD220 = tmp3_0 * s1_220_0;
    gl64_t kE220 = tmp3_1 * s1_220_1;
    gl64_t kF220 = tmp3_2 * s1_220_2;
    gl64_t kG220 = kD220 - kE220;
    tmp3_0 = (kC220 + kG220) - kF220;
    tmp3_1 = ((((kA220 + kC220) - kE220) - kE220) - kD220);
    tmp3_2 = kB220 - kG220;
    // Op 221: dim3x1 add
    gl64_t s1_221 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_221; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 222: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    tmp3_6 = (kC223 + kG223) - kF223;
    tmp3_7 = ((((kA223 + kC223) - kE223) - kE223) - kD223);
    tmp3_8 = kB223 - kG223;
    // Op 224: dim3x1 mul
    gl64_t s0_224_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_224_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_224_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_224 = *(gl64_t*)&expressions_params[10][8];
    tmp3_0 = s0_224_0 * s1_224; tmp3_1 = s0_224_1 * s1_224; tmp3_2 = s0_224_2 * s1_224;
    // Op 225: dim3x1 add
    gl64_t s1_225 = *(gl64_t*)&expressions_params[10][7];
    tmp3_0 = tmp3_0 + s1_225; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 226: dim3x3 mul
    gl64_t s1_226_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_226_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_226_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA226 = (tmp3_0 + tmp3_1) * (s1_226_0 + s1_226_1);
    gl64_t kB226 = (tmp3_0 + tmp3_2) * (s1_226_0 + s1_226_2);
    gl64_t kC226 = (tmp3_1 + tmp3_2) * (s1_226_1 + s1_226_2);
    gl64_t kD226 = tmp3_0 * s1_226_0;
    gl64_t kE226 = tmp3_1 * s1_226_1;
    gl64_t kF226 = tmp3_2 * s1_226_2;
    gl64_t kG226 = kD226 - kE226;
    tmp3_0 = (kC226 + kG226) - kF226;
    tmp3_1 = ((((kA226 + kC226) - kE226) - kE226) - kD226);
    tmp3_2 = kB226 - kG226;
    // Op 227: dim3x1 add
    gl64_t s1_227 = *(gl64_t*)&expressions_params[10][9];
    tmp3_0 = tmp3_0 + s1_227; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 228: dim3x3 mul
    gl64_t s1_228_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_228_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_228_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA228 = (tmp3_0 + tmp3_1) * (s1_228_0 + s1_228_1);
    gl64_t kB228 = (tmp3_0 + tmp3_2) * (s1_228_0 + s1_228_2);
    gl64_t kC228 = (tmp3_1 + tmp3_2) * (s1_228_1 + s1_228_2);
    gl64_t kD228 = tmp3_0 * s1_228_0;
    gl64_t kE228 = tmp3_1 * s1_228_1;
    gl64_t kF228 = tmp3_2 * s1_228_2;
    gl64_t kG228 = kD228 - kE228;
    tmp3_0 = (kC228 + kG228) - kF228;
    tmp3_1 = ((((kA228 + kC228) - kE228) - kE228) - kD228);
    tmp3_2 = kB228 - kG228;
    // Op 229: dim3x1 add
    gl64_t s1_229 = *(gl64_t*)&expressions_params[10][10];
    tmp3_0 = tmp3_0 + s1_229; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 230: dim3x3 mul
    gl64_t s1_230_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_230_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_230_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 231: dim3x3 mul
    gl64_t s1_231_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_231_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_231_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 232: dim1x1 add
    gl64_t s0_232 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_232 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_232 + s1_232;
    // Op 233: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 234: dim3x3 mul
    gl64_t s1_234_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_234_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_234_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA234 = (tmp3_0 + tmp3_1) * (s1_234_0 + s1_234_1);
    gl64_t kB234 = (tmp3_0 + tmp3_2) * (s1_234_0 + s1_234_2);
    gl64_t kC234 = (tmp3_1 + tmp3_2) * (s1_234_1 + s1_234_2);
    gl64_t kD234 = tmp3_0 * s1_234_0;
    gl64_t kE234 = tmp3_1 * s1_234_1;
    gl64_t kF234 = tmp3_2 * s1_234_2;
    gl64_t kG234 = kD234 - kE234;
    tmp3_0 = (kC234 + kG234) - kF234;
    tmp3_1 = ((((kA234 + kC234) - kE234) - kE234) - kD234);
    tmp3_2 = kB234 - kG234;
    // Op 235: dim3x1 add
    gl64_t s1_235 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_235; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 236: dim3x3 mul
    gl64_t s1_236_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_236_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_236_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 237: dim3x1 add
    gl64_t s1_237 = *(gl64_t*)&expressions_params[9][8];
    tmp3_0 = tmp3_0 + s1_237; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 238: dim3x3 add
    gl64_t s1_238_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_238_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_238_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_238_0; tmp3_1 = tmp3_1 + s1_238_1; tmp3_2 = tmp3_2 + s1_238_2;
    // Op 239: dim3x3 mul
    gl64_t s1_239_0 = *(gl64_t*)&expressions_params[10][20];
    gl64_t s1_239_1 = *(gl64_t*)&expressions_params[10][20+1];
    gl64_t s1_239_2 = *(gl64_t*)&expressions_params[10][20+2];
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
    // Op 240: dim1x1 sub
    gl64_t s0_240 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_240 = *(gl64_t*)&expressions_params[10][2];
    tmp1_0 = s0_240 - s1_240;
    // Op 241: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 242: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 243: dim3x3 mul
    gl64_t s1_243_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_243_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_243_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA243 = (tmp3_0 + tmp3_1) * (s1_243_0 + s1_243_1);
    gl64_t kB243 = (tmp3_0 + tmp3_2) * (s1_243_0 + s1_243_2);
    gl64_t kC243 = (tmp3_1 + tmp3_2) * (s1_243_1 + s1_243_2);
    gl64_t kD243 = tmp3_0 * s1_243_0;
    gl64_t kE243 = tmp3_1 * s1_243_1;
    gl64_t kF243 = tmp3_2 * s1_243_2;
    gl64_t kG243 = kD243 - kE243;
    tmp3_6 = (kC243 + kG243) - kF243;
    tmp3_7 = ((((kA243 + kC243) - kE243) - kE243) - kD243);
    tmp3_8 = kB243 - kG243;
    // Op 244: dim3x1 mul
    gl64_t s0_244_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_244_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_244_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_244 = *(gl64_t*)&expressions_params[10][11];
    tmp3_0 = s0_244_0 * s1_244; tmp3_1 = s0_244_1 * s1_244; tmp3_2 = s0_244_2 * s1_244;
    // Op 245: dim3x1 add
    gl64_t s1_245 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_245; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 246: dim3x3 add
    gl64_t s1_246_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_246_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_246_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_246_0; tmp3_1 = tmp3_1 + s1_246_1; tmp3_2 = tmp3_2 + s1_246_2;
    // Op 247: dim3x3 mul
    gl64_t s1_247_0 = *(gl64_t*)&expressions_params[10][23];
    gl64_t s1_247_1 = *(gl64_t*)&expressions_params[10][23+1];
    gl64_t s1_247_2 = *(gl64_t*)&expressions_params[10][23+2];
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
    // Op 248: dim3x1 add
    gl64_t s1_248 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_248; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 249: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 250: dim3x3 mul
    gl64_t s1_250_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_250_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_250_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA250 = (tmp3_0 + tmp3_1) * (s1_250_0 + s1_250_1);
    gl64_t kB250 = (tmp3_0 + tmp3_2) * (s1_250_0 + s1_250_2);
    gl64_t kC250 = (tmp3_1 + tmp3_2) * (s1_250_1 + s1_250_2);
    gl64_t kD250 = tmp3_0 * s1_250_0;
    gl64_t kE250 = tmp3_1 * s1_250_1;
    gl64_t kF250 = tmp3_2 * s1_250_2;
    gl64_t kG250 = kD250 - kE250;
    tmp3_6 = (kC250 + kG250) - kF250;
    tmp3_7 = ((((kA250 + kC250) - kE250) - kE250) - kD250);
    tmp3_8 = kB250 - kG250;
    // Op 251: dim3x1 mul
    gl64_t s0_251_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_251_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_251_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_251 = *(gl64_t*)&expressions_params[10][12];
    tmp3_0 = s0_251_0 * s1_251; tmp3_1 = s0_251_1 * s1_251; tmp3_2 = s0_251_2 * s1_251;
    // Op 252: dim3x1 add
    gl64_t s1_252 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_252; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 253: dim3x3 add
    gl64_t s1_253_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_253_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_253_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_253_0; tmp3_1 = tmp3_1 + s1_253_1; tmp3_2 = tmp3_2 + s1_253_2;
    // Op 254: dim3x3 mul
    gl64_t s1_254_0 = *(gl64_t*)&expressions_params[10][26];
    gl64_t s1_254_1 = *(gl64_t*)&expressions_params[10][26+1];
    gl64_t s1_254_2 = *(gl64_t*)&expressions_params[10][26+2];
    gl64_t kA254 = (tmp3_0 + tmp3_1) * (s1_254_0 + s1_254_1);
    gl64_t kB254 = (tmp3_0 + tmp3_2) * (s1_254_0 + s1_254_2);
    gl64_t kC254 = (tmp3_1 + tmp3_2) * (s1_254_1 + s1_254_2);
    gl64_t kD254 = tmp3_0 * s1_254_0;
    gl64_t kE254 = tmp3_1 * s1_254_1;
    gl64_t kF254 = tmp3_2 * s1_254_2;
    gl64_t kG254 = kD254 - kE254;
    tmp3_0 = (kC254 + kG254) - kF254;
    tmp3_1 = ((((kA254 + kC254) - kE254) - kE254) - kD254);
    tmp3_2 = kB254 - kG254;
    // Op 255: dim3x1 add
    gl64_t s1_255 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_255; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 256: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 257: dim3x3 mul
    gl64_t s1_257_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_257_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_257_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA257 = (tmp3_0 + tmp3_1) * (s1_257_0 + s1_257_1);
    gl64_t kB257 = (tmp3_0 + tmp3_2) * (s1_257_0 + s1_257_2);
    gl64_t kC257 = (tmp3_1 + tmp3_2) * (s1_257_1 + s1_257_2);
    gl64_t kD257 = tmp3_0 * s1_257_0;
    gl64_t kE257 = tmp3_1 * s1_257_1;
    gl64_t kF257 = tmp3_2 * s1_257_2;
    gl64_t kG257 = kD257 - kE257;
    tmp3_6 = (kC257 + kG257) - kF257;
    tmp3_7 = ((((kA257 + kC257) - kE257) - kE257) - kD257);
    tmp3_8 = kB257 - kG257;
    // Op 258: dim3x1 mul
    gl64_t s0_258_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_258_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_258_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_258 = *(gl64_t*)&expressions_params[10][13];
    tmp3_0 = s0_258_0 * s1_258; tmp3_1 = s0_258_1 * s1_258; tmp3_2 = s0_258_2 * s1_258;
    // Op 259: dim3x1 add
    gl64_t s1_259 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_259; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 260: dim3x3 add
    gl64_t s1_260_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_260_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_260_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_260_0; tmp3_1 = tmp3_1 + s1_260_1; tmp3_2 = tmp3_2 + s1_260_2;
    // Op 261: dim3x3 mul
    gl64_t s1_261_0 = *(gl64_t*)&expressions_params[10][29];
    gl64_t s1_261_1 = *(gl64_t*)&expressions_params[10][29+1];
    gl64_t s1_261_2 = *(gl64_t*)&expressions_params[10][29+2];
    gl64_t kA261 = (tmp3_0 + tmp3_1) * (s1_261_0 + s1_261_1);
    gl64_t kB261 = (tmp3_0 + tmp3_2) * (s1_261_0 + s1_261_2);
    gl64_t kC261 = (tmp3_1 + tmp3_2) * (s1_261_1 + s1_261_2);
    gl64_t kD261 = tmp3_0 * s1_261_0;
    gl64_t kE261 = tmp3_1 * s1_261_1;
    gl64_t kF261 = tmp3_2 * s1_261_2;
    gl64_t kG261 = kD261 - kE261;
    tmp3_0 = (kC261 + kG261) - kF261;
    tmp3_1 = ((((kA261 + kC261) - kE261) - kE261) - kD261);
    tmp3_2 = kB261 - kG261;
    // Op 262: dim3x1 add
    gl64_t s1_262 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_262; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 263: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    tmp3_6 = (kC264 + kG264) - kF264;
    tmp3_7 = ((((kA264 + kC264) - kE264) - kE264) - kD264);
    tmp3_8 = kB264 - kG264;
    // Op 265: dim3x1 mul
    gl64_t s0_265_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_265_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_265_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_265 = *(gl64_t*)&expressions_params[10][14];
    tmp3_0 = s0_265_0 * s1_265; tmp3_1 = s0_265_1 * s1_265; tmp3_2 = s0_265_2 * s1_265;
    // Op 266: dim3x1 add
    gl64_t s1_266 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_266; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 267: dim3x3 add
    gl64_t s1_267_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_267_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_267_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_267_0; tmp3_1 = tmp3_1 + s1_267_1; tmp3_2 = tmp3_2 + s1_267_2;
    // Op 268: dim3x3 mul
    gl64_t s1_268_0 = *(gl64_t*)&expressions_params[10][32];
    gl64_t s1_268_1 = *(gl64_t*)&expressions_params[10][32+1];
    gl64_t s1_268_2 = *(gl64_t*)&expressions_params[10][32+2];
    gl64_t kA268 = (tmp3_0 + tmp3_1) * (s1_268_0 + s1_268_1);
    gl64_t kB268 = (tmp3_0 + tmp3_2) * (s1_268_0 + s1_268_2);
    gl64_t kC268 = (tmp3_1 + tmp3_2) * (s1_268_1 + s1_268_2);
    gl64_t kD268 = tmp3_0 * s1_268_0;
    gl64_t kE268 = tmp3_1 * s1_268_1;
    gl64_t kF268 = tmp3_2 * s1_268_2;
    gl64_t kG268 = kD268 - kE268;
    tmp3_0 = (kC268 + kG268) - kF268;
    tmp3_1 = ((((kA268 + kC268) - kE268) - kE268) - kD268);
    tmp3_2 = kB268 - kG268;
    // Op 269: dim3x1 add
    gl64_t s1_269 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_269; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 270: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 271: dim3x3 mul
    gl64_t s1_271_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_271_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_271_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA271 = (tmp3_0 + tmp3_1) * (s1_271_0 + s1_271_1);
    gl64_t kB271 = (tmp3_0 + tmp3_2) * (s1_271_0 + s1_271_2);
    gl64_t kC271 = (tmp3_1 + tmp3_2) * (s1_271_1 + s1_271_2);
    gl64_t kD271 = tmp3_0 * s1_271_0;
    gl64_t kE271 = tmp3_1 * s1_271_1;
    gl64_t kF271 = tmp3_2 * s1_271_2;
    gl64_t kG271 = kD271 - kE271;
    tmp3_6 = (kC271 + kG271) - kF271;
    tmp3_7 = ((((kA271 + kC271) - kE271) - kE271) - kD271);
    tmp3_8 = kB271 - kG271;
    // Op 272: dim3x1 mul
    gl64_t s0_272_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_272_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_272_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_272 = *(gl64_t*)&expressions_params[10][15];
    tmp3_0 = s0_272_0 * s1_272; tmp3_1 = s0_272_1 * s1_272; tmp3_2 = s0_272_2 * s1_272;
    // Op 273: dim3x1 add
    gl64_t s1_273 = *(gl64_t*)&expressions_params[9][9];
    tmp3_0 = tmp3_0 + s1_273; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 274: dim3x3 add
    gl64_t s1_274_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_274_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_274_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_274_0; tmp3_1 = tmp3_1 + s1_274_1; tmp3_2 = tmp3_2 + s1_274_2;
    // Op 275: dim3x3 mul
    gl64_t s1_275_0 = *(gl64_t*)&expressions_params[10][35];
    gl64_t s1_275_1 = *(gl64_t*)&expressions_params[10][35+1];
    gl64_t s1_275_2 = *(gl64_t*)&expressions_params[10][35+2];
    gl64_t kA275 = (tmp3_0 + tmp3_1) * (s1_275_0 + s1_275_1);
    gl64_t kB275 = (tmp3_0 + tmp3_2) * (s1_275_0 + s1_275_2);
    gl64_t kC275 = (tmp3_1 + tmp3_2) * (s1_275_1 + s1_275_2);
    gl64_t kD275 = tmp3_0 * s1_275_0;
    gl64_t kE275 = tmp3_1 * s1_275_1;
    gl64_t kF275 = tmp3_2 * s1_275_2;
    gl64_t kG275 = kD275 - kE275;
    tmp3_0 = (kC275 + kG275) - kF275;
    tmp3_1 = ((((kA275 + kC275) - kE275) - kE275) - kD275);
    tmp3_2 = kB275 - kG275;
    // Op 276: dim3x1 add
    gl64_t s1_276 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_276; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 277: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 278: dim3x3 mul
    gl64_t s1_278_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_278_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_278_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA278 = (tmp3_0 + tmp3_1) * (s1_278_0 + s1_278_1);
    gl64_t kB278 = (tmp3_0 + tmp3_2) * (s1_278_0 + s1_278_2);
    gl64_t kC278 = (tmp3_1 + tmp3_2) * (s1_278_1 + s1_278_2);
    gl64_t kD278 = tmp3_0 * s1_278_0;
    gl64_t kE278 = tmp3_1 * s1_278_1;
    gl64_t kF278 = tmp3_2 * s1_278_2;
    gl64_t kG278 = kD278 - kE278;
    tmp3_6 = (kC278 + kG278) - kF278;
    tmp3_7 = ((((kA278 + kC278) - kE278) - kE278) - kD278);
    tmp3_8 = kB278 - kG278;
    // Op 279: dim3x1 mul
    gl64_t s0_279_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_279_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_279_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_279 = *(gl64_t*)&expressions_params[10][16];
    tmp3_0 = s0_279_0 * s1_279; tmp3_1 = s0_279_1 * s1_279; tmp3_2 = s0_279_2 * s1_279;
    // Op 280: dim3x1 add
    gl64_t s1_280 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_280; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 281: dim3x3 add
    gl64_t s1_281_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_281_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_281_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_281_0; tmp3_1 = tmp3_1 + s1_281_1; tmp3_2 = tmp3_2 + s1_281_2;
    // Op 282: dim3x3 mul
    gl64_t s1_282_0 = *(gl64_t*)&expressions_params[10][38];
    gl64_t s1_282_1 = *(gl64_t*)&expressions_params[10][38+1];
    gl64_t s1_282_2 = *(gl64_t*)&expressions_params[10][38+2];
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
    gl64_t s1_283 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_283; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 284: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 285: dim3x3 mul
    gl64_t s1_285_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_285_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_285_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA285 = (tmp3_0 + tmp3_1) * (s1_285_0 + s1_285_1);
    gl64_t kB285 = (tmp3_0 + tmp3_2) * (s1_285_0 + s1_285_2);
    gl64_t kC285 = (tmp3_1 + tmp3_2) * (s1_285_1 + s1_285_2);
    gl64_t kD285 = tmp3_0 * s1_285_0;
    gl64_t kE285 = tmp3_1 * s1_285_1;
    gl64_t kF285 = tmp3_2 * s1_285_2;
    gl64_t kG285 = kD285 - kE285;
    tmp3_3 = (kC285 + kG285) - kF285;
    tmp3_4 = ((((kA285 + kC285) - kE285) - kE285) - kD285);
    tmp3_5 = kB285 - kG285;
    // Op 286: dim3x3 sub_swap
    uint64_t s0_286_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_286_0 = *(gl64_t*)&dParams->aux_trace[s0_286_pos];
    gl64_t s0_286_1 = *(gl64_t*)&dParams->aux_trace[s0_286_pos + TILE_HEIGHT];
    gl64_t s0_286_2 = *(gl64_t*)&dParams->aux_trace[s0_286_pos + 2*TILE_HEIGHT];
    gl64_t s1_286_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_286_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_286_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_6 = s1_286_0 - s0_286_0; tmp3_7 = s1_286_1 - s0_286_1; tmp3_8 = s1_286_2 - s0_286_2;
    // Op 287: dim3x3 add
    gl64_t s0_287_0 = *(gl64_t*)&expressions_params[10][17];
    gl64_t s0_287_1 = *(gl64_t*)&expressions_params[10][17+1];
    gl64_t s0_287_2 = *(gl64_t*)&expressions_params[10][17+2];
    gl64_t s1_287_0 = *(gl64_t*)&expressions_params[10][20];
    gl64_t s1_287_1 = *(gl64_t*)&expressions_params[10][20+1];
    gl64_t s1_287_2 = *(gl64_t*)&expressions_params[10][20+2];
    tmp3_0 = s0_287_0 + s1_287_0; tmp3_1 = s0_287_1 + s1_287_1; tmp3_2 = s0_287_2 + s1_287_2;
    // Op 288: dim3x3 add
    gl64_t s1_288_0 = *(gl64_t*)&expressions_params[10][23];
    gl64_t s1_288_1 = *(gl64_t*)&expressions_params[10][23+1];
    gl64_t s1_288_2 = *(gl64_t*)&expressions_params[10][23+2];
    tmp3_0 = tmp3_0 + s1_288_0; tmp3_1 = tmp3_1 + s1_288_1; tmp3_2 = tmp3_2 + s1_288_2;
    // Op 289: dim3x3 add
    gl64_t s1_289_0 = *(gl64_t*)&expressions_params[10][26];
    gl64_t s1_289_1 = *(gl64_t*)&expressions_params[10][26+1];
    gl64_t s1_289_2 = *(gl64_t*)&expressions_params[10][26+2];
    tmp3_0 = tmp3_0 + s1_289_0; tmp3_1 = tmp3_1 + s1_289_1; tmp3_2 = tmp3_2 + s1_289_2;
    // Op 290: dim3x3 add
    gl64_t s1_290_0 = *(gl64_t*)&expressions_params[10][29];
    gl64_t s1_290_1 = *(gl64_t*)&expressions_params[10][29+1];
    gl64_t s1_290_2 = *(gl64_t*)&expressions_params[10][29+2];
    tmp3_0 = tmp3_0 + s1_290_0; tmp3_1 = tmp3_1 + s1_290_1; tmp3_2 = tmp3_2 + s1_290_2;
    // Op 291: dim3x3 add
    gl64_t s1_291_0 = *(gl64_t*)&expressions_params[10][32];
    gl64_t s1_291_1 = *(gl64_t*)&expressions_params[10][32+1];
    gl64_t s1_291_2 = *(gl64_t*)&expressions_params[10][32+2];
    tmp3_0 = tmp3_0 + s1_291_0; tmp3_1 = tmp3_1 + s1_291_1; tmp3_2 = tmp3_2 + s1_291_2;
    // Op 292: dim3x3 add
    gl64_t s1_292_0 = *(gl64_t*)&expressions_params[10][35];
    gl64_t s1_292_1 = *(gl64_t*)&expressions_params[10][35+1];
    gl64_t s1_292_2 = *(gl64_t*)&expressions_params[10][35+2];
    tmp3_0 = tmp3_0 + s1_292_0; tmp3_1 = tmp3_1 + s1_292_1; tmp3_2 = tmp3_2 + s1_292_2;
    // Op 293: dim3x3 add
    gl64_t s1_293_0 = *(gl64_t*)&expressions_params[10][38];
    gl64_t s1_293_1 = *(gl64_t*)&expressions_params[10][38+1];
    gl64_t s1_293_2 = *(gl64_t*)&expressions_params[10][38+2];
    tmp3_0 = tmp3_0 + s1_293_0; tmp3_1 = tmp3_1 + s1_293_1; tmp3_2 = tmp3_2 + s1_293_2;
    // Op 294: dim3x3 sub
    tmp3_0 = tmp3_6 - tmp3_0; tmp3_1 = tmp3_7 - tmp3_1; tmp3_2 = tmp3_8 - tmp3_2;
    // Op 295: dim3x1 mul
    gl64_t s1_295 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_295; tmp3_1 = tmp3_1 * s1_295; tmp3_2 = tmp3_2 * s1_295;
    // Op 296: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 297: dim3x1 mul
    gl64_t s1_297 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_297; tmp3_1 = tmp3_1 * s1_297; tmp3_2 = tmp3_2 * s1_297;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
