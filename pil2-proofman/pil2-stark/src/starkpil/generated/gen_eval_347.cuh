// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: 9d2022fc  nOps=274 nTemp1=5 nTemp3=5
#define GENERATED_EVAL_NOPS_9d2022fc 274
#define GENERATED_EVAL_NTEMP1_9d2022fc 5
#define GENERATED_EVAL_NTEMP3_9d2022fc 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_9d2022fc(
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
    // Op 65: dim1x1 sub
    gl64_t s0_65 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 4, domainSize, nCols_1))];
    gl64_t s1_65 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 1, domainSize, nCols_1))];
    tmp1_0 = s0_65 - s1_65;
    // Op 66: dim1x1 mul
    gl64_t s0_66 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 5, domainSize, nCols_1))];
    tmp1_0 = s0_66 * tmp1_0;
    // Op 67: dim1x1 add
    gl64_t s0_67 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 1, domainSize, nCols_1))];
    tmp1_1 = s0_67 + tmp1_0;
    // Op 68: dim1x1 sub_swap
    gl64_t s1_68 = *(gl64_t*)&expressions_params[10][5];
    tmp1_0 = s1_68 - tmp1_1;
    // Op 69: dim1x1 mul
    gl64_t s0_69 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_0 = s0_69 * tmp1_0;
    // Op 70: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 71: dim1x1 sub
    gl64_t s0_71 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_71 - tmp1_0;
    // Op 72: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 73: dim3x3 mul
    gl64_t s1_73_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_73_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_73_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 74: dim1x1 mul
    gl64_t s0_74 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_74 = *(gl64_t*)&expressions_params[9][13];
    tmp1_0 = s0_74 * s1_74;
    // Op 75: dim1x1 add
    gl64_t s0_75 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_75 + tmp1_0;
    // Op 76: dim1x1 add
    gl64_t s1_76 = *(gl64_t*)&expressions_params[9][0];
    tmp1_3 = tmp1_0 + s1_76;
    // Op 77: dim1x1 sub_swap
    gl64_t s0_77 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_1))];
    gl64_t s1_77 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s1_77 - s0_77;
    // Op 78: dim1x1 mul
    gl64_t s0_78 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_0 = s0_78 * tmp1_0;
    // Op 79: dim1x1 add
    gl64_t s0_79 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_1))];
    tmp1_4 = s0_79 + tmp1_0;
    // Op 80: dim1x1 sub
    gl64_t s0_80 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_2 = s0_80 - tmp1_4;
    // Op 81: dim1x1 sub
    gl64_t s0_81 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_81 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_81 - s1_81;
    // Op 82: dim1x1 sub_swap
    gl64_t s0_82 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_82 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s1_82 - s0_82;
    // Op 83: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 84: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_0;
    // Op 85: dim1x1 mul
    gl64_t s0_85 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_2 = s0_85 * tmp1_2;
    // Op 86: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 87: dim1x1 sub
    tmp1_0 = tmp1_3 - tmp1_0;
    // Op 88: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 89: dim3x3 mul
    gl64_t s1_89_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_89_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_89_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 90: dim1x1 mul
    gl64_t s0_90 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_90 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_90 * s1_90;
    // Op 91: dim1x1 sub_swap
    gl64_t s0_91 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_91 = *(gl64_t*)&expressions_params[9][0];
    tmp1_3 = s1_91 - s0_91;
    // Op 92: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_3;
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
    // Op 95: dim1x1 sub_swap
    gl64_t s0_95 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_95 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_95 - s0_95;
    // Op 96: dim1x1 sub_swap
    gl64_t s0_96 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_96 = *(gl64_t*)&expressions_params[9][0];
    tmp1_3 = s1_96 - s0_96;
    // Op 97: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_3;
    // Op 98: dim1x1 sub
    gl64_t s0_98 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_98 - tmp1_0;
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
    gl64_t s0_101 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_101 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_101 - s0_101;
    // Op 102: dim1x1 sub
    gl64_t s0_102 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_4 = s0_102 - tmp1_4;
    // Op 103: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_4;
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
    gl64_t s0_106 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 6, domainSize, nCols_1))];
    gl64_t s1_106 = *(gl64_t*)&expressions_params[10][3];
    tmp1_0 = s1_106 - s0_106;
    // Op 107: dim1x1 mul
    gl64_t s0_107 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_0 = s0_107 * tmp1_0;
    // Op 108: dim1x1 add
    gl64_t s0_108 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 6, domainSize, nCols_1))];
    tmp1_0 = s0_108 + tmp1_0;
    // Op 109: dim1x1 sub
    gl64_t s0_109 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_109 - tmp1_0;
    // Op 110: dim1x1 mul
    gl64_t s0_110 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_110 * tmp1_0;
    // Op 111: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 112: dim3x3 mul
    gl64_t s1_112_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_112_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_112_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA112 = (tmp3_0 + tmp3_1) * (s1_112_0 + s1_112_1);
    gl64_t kB112 = (tmp3_0 + tmp3_2) * (s1_112_0 + s1_112_2);
    gl64_t kC112 = (tmp3_1 + tmp3_2) * (s1_112_1 + s1_112_2);
    gl64_t kD112 = tmp3_0 * s1_112_0;
    gl64_t kE112 = tmp3_1 * s1_112_1;
    gl64_t kF112 = tmp3_2 * s1_112_2;
    gl64_t kG112 = kD112 - kE112;
    tmp3_0 = (kC112 + kG112) - kF112;
    tmp3_1 = ((((kA112 + kC112) - kE112) - kE112) - kD112);
    tmp3_2 = kB112 - kG112;
    // Op 113: dim1x1 sub_swap
    gl64_t s0_113 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_113 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_113 - s0_113;
    // Op 114: dim1x1 mul
    gl64_t s0_114 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_114 * tmp1_0;
    // Op 115: dim1x1 mul
    gl64_t s0_115 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
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
    gl64_t s0_118 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 7, domainSize, nCols_1))];
    gl64_t s1_118 = *(gl64_t*)&expressions_params[10][4];
    tmp1_0 = s1_118 - s0_118;
    // Op 119: dim1x1 mul
    gl64_t s0_119 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_0 = s0_119 * tmp1_0;
    // Op 120: dim1x1 add
    gl64_t s0_120 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 7, domainSize, nCols_1))];
    tmp1_0 = s0_120 + tmp1_0;
    // Op 121: dim1x1 sub
    gl64_t s0_121 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_121 - tmp1_0;
    // Op 122: dim1x1 mul
    gl64_t s0_122 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_122 * tmp1_0;
    // Op 123: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 124: dim3x3 mul
    gl64_t s1_124_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_124_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_124_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA124 = (tmp3_0 + tmp3_1) * (s1_124_0 + s1_124_1);
    gl64_t kB124 = (tmp3_0 + tmp3_2) * (s1_124_0 + s1_124_2);
    gl64_t kC124 = (tmp3_1 + tmp3_2) * (s1_124_1 + s1_124_2);
    gl64_t kD124 = tmp3_0 * s1_124_0;
    gl64_t kE124 = tmp3_1 * s1_124_1;
    gl64_t kF124 = tmp3_2 * s1_124_2;
    gl64_t kG124 = kD124 - kE124;
    tmp3_0 = (kC124 + kG124) - kF124;
    tmp3_1 = ((((kA124 + kC124) - kE124) - kE124) - kD124);
    tmp3_2 = kB124 - kG124;
    // Op 125: dim1x1 sub_swap
    gl64_t s0_125 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_125 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_125 - s0_125;
    // Op 126: dim1x1 mul
    gl64_t s0_126 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_126 * tmp1_0;
    // Op 127: dim1x1 mul
    gl64_t s0_127 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
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
    tmp3_12 = (kC129 + kG129) - kF129;
    tmp3_13 = ((((kA129 + kC129) - kE129) - kE129) - kD129);
    tmp3_14 = kB129 - kG129;
    // Op 130: dim3x1 mul
    gl64_t s0_130_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_130_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_130_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_130 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp3_0 = s0_130_0 * s1_130; tmp3_1 = s0_130_1 * s1_130; tmp3_2 = s0_130_2 * s1_130;
    // Op 131: dim3x1 add
    gl64_t s1_131 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_0 + s1_131; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 132: dim3x3 add
    gl64_t s1_132_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_132_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_132_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_132_0; tmp3_4 = tmp3_10 + s1_132_1; tmp3_5 = tmp3_11 + s1_132_2;
    // Op 133: dim1x1 sub
    gl64_t s0_133 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_133 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_133 - s1_133;
    // Op 134: dim1x1 sub_swap
    gl64_t s0_134 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = tmp1_0 - s0_134;
    // Op 135: dim3x1 mul
    gl64_t s0_135_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_135_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_135_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_135_0 * tmp1_0; tmp3_1 = s0_135_1 * tmp1_0; tmp3_2 = s0_135_2 * tmp1_0;
    // Op 136: dim3x1 add
    gl64_t s1_136 = *(gl64_t*)&expressions_params[9][1];
    tmp3_6 = tmp3_0 + s1_136; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 137: dim3x3 add
    gl64_t s1_137_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_137_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_137_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_137_0; tmp3_1 = tmp3_7 + s1_137_1; tmp3_2 = tmp3_8 + s1_137_2;
    // Op 138: dim3x3 mul
    gl64_t kA138 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB138 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC138 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD138 = tmp3_3 * tmp3_0;
    gl64_t kE138 = tmp3_4 * tmp3_1;
    gl64_t kF138 = tmp3_5 * tmp3_2;
    gl64_t kG138 = kD138 - kE138;
    tmp3_0 = (kC138 + kG138) - kF138;
    tmp3_1 = ((((kA138 + kC138) - kE138) - kE138) - kD138);
    tmp3_2 = kB138 - kG138;
    // Op 139: dim3x3 mul
    gl64_t s0_139_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_139_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_139_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA139 = (s0_139_0 + s0_139_1) * (tmp3_0 + tmp3_1);
    gl64_t kB139 = (s0_139_0 + s0_139_2) * (tmp3_0 + tmp3_2);
    gl64_t kC139 = (s0_139_1 + s0_139_2) * (tmp3_1 + tmp3_2);
    gl64_t kD139 = s0_139_0 * tmp3_0;
    gl64_t kE139 = s0_139_1 * tmp3_1;
    gl64_t kF139 = s0_139_2 * tmp3_2;
    gl64_t kG139 = kD139 - kE139;
    tmp3_0 = (kC139 + kG139) - kF139;
    tmp3_1 = ((((kA139 + kC139) - kE139) - kE139) - kD139);
    tmp3_2 = kB139 - kG139;
    // Op 140: dim3x3 add
    gl64_t s1_140_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_140_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_140_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_140_0; tmp3_7 = tmp3_7 + s1_140_1; tmp3_8 = tmp3_8 + s1_140_2;
    // Op 141: dim3x1 mul
    gl64_t s1_141 = *(gl64_t*)&expressions_params[9][2];
    tmp3_6 = tmp3_6 * s1_141; tmp3_7 = tmp3_7 * s1_141; tmp3_8 = tmp3_8 * s1_141;
    // Op 142: dim1x1 sub_swap
    gl64_t s0_142 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_142 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s1_142 - s0_142;
    // Op 143: dim3x3 add
    gl64_t s1_143_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_143_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_143_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_143_0; tmp3_10 = tmp3_10 + s1_143_1; tmp3_11 = tmp3_11 + s1_143_2;
    // Op 144: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_0; tmp3_10 = tmp3_10 * tmp1_0; tmp3_11 = tmp3_11 * tmp1_0;
    // Op 145: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 146: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 147: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
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
    tmp3_3 = (kC148 + kG148) - kF148;
    tmp3_4 = ((((kA148 + kC148) - kE148) - kE148) - kD148);
    tmp3_5 = kB148 - kG148;
    // Op 149: dim3x1 mul
    gl64_t s0_149_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_149_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_149_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_149 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp3_0 = s0_149_0 * s1_149; tmp3_1 = s0_149_1 * s1_149; tmp3_2 = s0_149_2 * s1_149;
    // Op 150: dim3x1 add
    gl64_t s1_150 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_150; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 151: dim3x3 mul
    gl64_t s1_151_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_151_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_151_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 152: dim3x1 add
    gl64_t s1_152 = *(gl64_t*)&expressions_params[9][5];
    tmp3_0 = tmp3_0 + s1_152; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 153: dim3x3 mul
    gl64_t s1_153_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_153_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_153_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA153 = (tmp3_0 + tmp3_1) * (s1_153_0 + s1_153_1);
    gl64_t kB153 = (tmp3_0 + tmp3_2) * (s1_153_0 + s1_153_2);
    gl64_t kC153 = (tmp3_1 + tmp3_2) * (s1_153_1 + s1_153_2);
    gl64_t kD153 = tmp3_0 * s1_153_0;
    gl64_t kE153 = tmp3_1 * s1_153_1;
    gl64_t kF153 = tmp3_2 * s1_153_2;
    gl64_t kG153 = kD153 - kE153;
    tmp3_0 = (kC153 + kG153) - kF153;
    tmp3_1 = ((((kA153 + kC153) - kE153) - kE153) - kD153);
    tmp3_2 = kB153 - kG153;
    // Op 154: dim3x1 add
    gl64_t s1_154 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
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
    // Op 156: dim1x1 mul
    gl64_t s0_156 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_156 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_156 * s1_156;
    // Op 157: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 159: dim1x1 add
    gl64_t s0_159 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_159 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_159 + s1_159;
    // Op 160: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_162 = *(gl64_t*)&expressions_params[9][6];
    tmp3_9 = tmp3_0 + s1_162; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 163: dim3x3 add
    gl64_t s1_163_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_163_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_163_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_163_0; tmp3_13 = tmp3_10 + s1_163_1; tmp3_14 = tmp3_11 + s1_163_2;
    // Op 164: dim3x1 mul
    gl64_t s0_164_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_164_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_164_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_164 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp3_0 = s0_164_0 * s1_164; tmp3_1 = s0_164_1 * s1_164; tmp3_2 = s0_164_2 * s1_164;
    // Op 165: dim3x1 add
    gl64_t s1_165 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
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
    gl64_t s1_167 = *(gl64_t*)&expressions_params[9][5];
    tmp3_0 = tmp3_0 + s1_167; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 168: dim3x3 mul
    gl64_t s1_168_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_168_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_168_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA168 = (tmp3_0 + tmp3_1) * (s1_168_0 + s1_168_1);
    gl64_t kB168 = (tmp3_0 + tmp3_2) * (s1_168_0 + s1_168_2);
    gl64_t kC168 = (tmp3_1 + tmp3_2) * (s1_168_1 + s1_168_2);
    gl64_t kD168 = tmp3_0 * s1_168_0;
    gl64_t kE168 = tmp3_1 * s1_168_1;
    gl64_t kF168 = tmp3_2 * s1_168_2;
    gl64_t kG168 = kD168 - kE168;
    tmp3_0 = (kC168 + kG168) - kF168;
    tmp3_1 = ((((kA168 + kC168) - kE168) - kE168) - kD168);
    tmp3_2 = kB168 - kG168;
    // Op 169: dim3x1 add
    gl64_t s1_169 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_169; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 170: dim3x3 mul
    gl64_t s1_170_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_170_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_170_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA170 = (tmp3_0 + tmp3_1) * (s1_170_0 + s1_170_1);
    gl64_t kB170 = (tmp3_0 + tmp3_2) * (s1_170_0 + s1_170_2);
    gl64_t kC170 = (tmp3_1 + tmp3_2) * (s1_170_1 + s1_170_2);
    gl64_t kD170 = tmp3_0 * s1_170_0;
    gl64_t kE170 = tmp3_1 * s1_170_1;
    gl64_t kF170 = tmp3_2 * s1_170_2;
    gl64_t kG170 = kD170 - kE170;
    tmp3_0 = (kC170 + kG170) - kF170;
    tmp3_1 = ((((kA170 + kC170) - kE170) - kE170) - kD170);
    tmp3_2 = kB170 - kG170;
    // Op 171: dim1x1 mul
    gl64_t s0_171 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_171 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_171 * s1_171;
    // Op 172: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_174 = *(gl64_t*)&expressions_params[9][0];
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
    gl64_t s1_176 = *(gl64_t*)&expressions_params[9][6];
    tmp3_6 = tmp3_0 + s1_176; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 177: dim3x3 add
    gl64_t s1_177_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_177_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_177_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_177_0; tmp3_1 = tmp3_7 + s1_177_1; tmp3_2 = tmp3_8 + s1_177_2;
    // Op 178: dim3x3 mul
    gl64_t kA178 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB178 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC178 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD178 = tmp3_12 * tmp3_0;
    gl64_t kE178 = tmp3_13 * tmp3_1;
    gl64_t kF178 = tmp3_14 * tmp3_2;
    gl64_t kG178 = kD178 - kE178;
    tmp3_0 = (kC178 + kG178) - kF178;
    tmp3_1 = ((((kA178 + kC178) - kE178) - kE178) - kD178);
    tmp3_2 = kB178 - kG178;
    // Op 179: dim3x3 mul
    gl64_t s0_179_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_179_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_179_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA179 = (s0_179_0 + s0_179_1) * (tmp3_0 + tmp3_1);
    gl64_t kB179 = (s0_179_0 + s0_179_2) * (tmp3_0 + tmp3_2);
    gl64_t kC179 = (s0_179_1 + s0_179_2) * (tmp3_1 + tmp3_2);
    gl64_t kD179 = s0_179_0 * tmp3_0;
    gl64_t kE179 = s0_179_1 * tmp3_1;
    gl64_t kF179 = s0_179_2 * tmp3_2;
    gl64_t kG179 = kD179 - kE179;
    tmp3_0 = (kC179 + kG179) - kF179;
    tmp3_1 = ((((kA179 + kC179) - kE179) - kE179) - kD179);
    tmp3_2 = kB179 - kG179;
    // Op 180: dim3x3 add
    gl64_t s1_180_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_180_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_180_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_180_0; tmp3_7 = tmp3_7 + s1_180_1; tmp3_8 = tmp3_8 + s1_180_2;
    // Op 181: dim3x1 mul
    gl64_t s1_181 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_6 = tmp3_6 * s1_181; tmp3_7 = tmp3_7 * s1_181; tmp3_8 = tmp3_8 * s1_181;
    // Op 182: dim3x3 add
    gl64_t s1_182_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_182_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_182_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_182_0; tmp3_10 = tmp3_10 + s1_182_1; tmp3_11 = tmp3_11 + s1_182_2;
    // Op 183: dim3x1 mul
    gl64_t s1_183 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_183; tmp3_10 = tmp3_10 * s1_183; tmp3_11 = tmp3_11 * s1_183;
    // Op 184: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 185: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 186: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 187: dim3x3 mul
    gl64_t s1_187_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_187_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_187_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA187 = (tmp3_0 + tmp3_1) * (s1_187_0 + s1_187_1);
    gl64_t kB187 = (tmp3_0 + tmp3_2) * (s1_187_0 + s1_187_2);
    gl64_t kC187 = (tmp3_1 + tmp3_2) * (s1_187_1 + s1_187_2);
    gl64_t kD187 = tmp3_0 * s1_187_0;
    gl64_t kE187 = tmp3_1 * s1_187_1;
    gl64_t kF187 = tmp3_2 * s1_187_2;
    gl64_t kG187 = kD187 - kE187;
    tmp3_6 = (kC187 + kG187) - kF187;
    tmp3_7 = ((((kA187 + kC187) - kE187) - kE187) - kD187);
    tmp3_8 = kB187 - kG187;
    // Op 188: dim1x1 sub_swap
    gl64_t s0_188 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_0)];
    gl64_t s1_188 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_188 - s0_188;
    // Op 189: dim3x1 mul
    uint64_t s0_189_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_189_0 = *(gl64_t*)&dParams->aux_trace[s0_189_pos];
    gl64_t s0_189_1 = *(gl64_t*)&dParams->aux_trace[s0_189_pos + TILE_HEIGHT];
    gl64_t s0_189_2 = *(gl64_t*)&dParams->aux_trace[s0_189_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_189_0 * tmp1_0; tmp3_1 = s0_189_1 * tmp1_0; tmp3_2 = s0_189_2 * tmp1_0;
    // Op 190: dim3x3 sub
    uint64_t s0_190_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_190_0 = *(gl64_t*)&dParams->aux_trace[s0_190_pos];
    gl64_t s0_190_1 = *(gl64_t*)&dParams->aux_trace[s0_190_pos + TILE_HEIGHT];
    gl64_t s0_190_2 = *(gl64_t*)&dParams->aux_trace[s0_190_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_190_0 - tmp3_0; tmp3_1 = s0_190_1 - tmp3_1; tmp3_2 = s0_190_2 - tmp3_2;
    // Op 191: dim3x3 add
    gl64_t s0_191_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_191_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_191_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_191_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_191_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_191_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_3 = s0_191_0 + s1_191_0; tmp3_4 = s0_191_1 + s1_191_1; tmp3_5 = s0_191_2 + s1_191_2;
    // Op 192: dim3x3 sub
    tmp3_3 = tmp3_0 - tmp3_3; tmp3_4 = tmp3_1 - tmp3_4; tmp3_5 = tmp3_2 - tmp3_5;
    // Op 193: dim3x1 mul
    gl64_t s0_193_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_193_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_193_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_193 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp3_0 = s0_193_0 * s1_193; tmp3_1 = s0_193_1 * s1_193; tmp3_2 = s0_193_2 * s1_193;
    // Op 194: dim3x1 add
    gl64_t s1_194 = *(gl64_t*)&expressions_params[9][9];
    tmp3_0 = tmp3_0 + s1_194; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 195: dim3x3 add
    gl64_t s1_195_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_195_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_195_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_195_0; tmp3_1 = tmp3_1 + s1_195_1; tmp3_2 = tmp3_2 + s1_195_2;
    // Op 196: dim3x3 mul
    gl64_t kA196 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB196 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC196 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD196 = tmp3_3 * tmp3_0;
    gl64_t kE196 = tmp3_4 * tmp3_1;
    gl64_t kF196 = tmp3_5 * tmp3_2;
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
    gl64_t s1_200 = *(gl64_t*)&expressions_params[10][4];
    tmp3_0 = s0_200_0 * s1_200; tmp3_1 = s0_200_1 * s1_200; tmp3_2 = s0_200_2 * s1_200;
    // Op 201: dim3x1 add
    gl64_t s1_201 = *(gl64_t*)&expressions_params[10][3];
    tmp3_0 = tmp3_0 + s1_201; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 202: dim3x3 mul
    gl64_t s1_202_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_202_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_202_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 203: dim3x1 add
    gl64_t s1_203 = *(gl64_t*)&expressions_params[10][5];
    tmp3_0 = tmp3_0 + s1_203; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 204: dim3x3 mul
    gl64_t s1_204_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_204_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_204_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA204 = (tmp3_0 + tmp3_1) * (s1_204_0 + s1_204_1);
    gl64_t kB204 = (tmp3_0 + tmp3_2) * (s1_204_0 + s1_204_2);
    gl64_t kC204 = (tmp3_1 + tmp3_2) * (s1_204_1 + s1_204_2);
    gl64_t kD204 = tmp3_0 * s1_204_0;
    gl64_t kE204 = tmp3_1 * s1_204_1;
    gl64_t kF204 = tmp3_2 * s1_204_2;
    gl64_t kG204 = kD204 - kE204;
    tmp3_0 = (kC204 + kG204) - kF204;
    tmp3_1 = ((((kA204 + kC204) - kE204) - kE204) - kD204);
    tmp3_2 = kB204 - kG204;
    // Op 205: dim3x1 add
    gl64_t s1_205 = *(gl64_t*)&expressions_params[10][6];
    tmp3_0 = tmp3_0 + s1_205; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 206: dim3x3 mul
    gl64_t s1_206_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_206_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_206_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA206 = (tmp3_0 + tmp3_1) * (s1_206_0 + s1_206_1);
    gl64_t kB206 = (tmp3_0 + tmp3_2) * (s1_206_0 + s1_206_2);
    gl64_t kC206 = (tmp3_1 + tmp3_2) * (s1_206_1 + s1_206_2);
    gl64_t kD206 = tmp3_0 * s1_206_0;
    gl64_t kE206 = tmp3_1 * s1_206_1;
    gl64_t kF206 = tmp3_2 * s1_206_2;
    gl64_t kG206 = kD206 - kE206;
    tmp3_0 = (kC206 + kG206) - kF206;
    tmp3_1 = ((((kA206 + kC206) - kE206) - kE206) - kD206);
    tmp3_2 = kB206 - kG206;
    // Op 207: dim3x1 add
    gl64_t s1_207 = *(gl64_t*)&expressions_params[10][0];
    tmp3_0 = tmp3_0 + s1_207; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 208: dim3x3 mul
    gl64_t s1_208_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_208_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_208_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA208 = (tmp3_0 + tmp3_1) * (s1_208_0 + s1_208_1);
    gl64_t kB208 = (tmp3_0 + tmp3_2) * (s1_208_0 + s1_208_2);
    gl64_t kC208 = (tmp3_1 + tmp3_2) * (s1_208_1 + s1_208_2);
    gl64_t kD208 = tmp3_0 * s1_208_0;
    gl64_t kE208 = tmp3_1 * s1_208_1;
    gl64_t kF208 = tmp3_2 * s1_208_2;
    gl64_t kG208 = kD208 - kE208;
    tmp3_0 = (kC208 + kG208) - kF208;
    tmp3_1 = ((((kA208 + kC208) - kE208) - kE208) - kD208);
    tmp3_2 = kB208 - kG208;
    // Op 209: dim3x1 add
    gl64_t s1_209 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_209; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 210: dim3x3 mul
    gl64_t s1_210_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_210_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_210_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    gl64_t s1_211 = *(gl64_t*)&expressions_params[9][8];
    tmp3_0 = tmp3_0 + s1_211; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 212: dim3x3 add
    gl64_t s1_212_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_212_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_212_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_212_0; tmp3_1 = tmp3_1 + s1_212_1; tmp3_2 = tmp3_2 + s1_212_2;
    // Op 213: dim3x3 mul
    gl64_t s1_213_0 = *(gl64_t*)&expressions_params[10][15];
    gl64_t s1_213_1 = *(gl64_t*)&expressions_params[10][15+1];
    gl64_t s1_213_2 = *(gl64_t*)&expressions_params[10][15+2];
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
    gl64_t s1_214 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_214; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 215: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 216: dim3x3 mul
    gl64_t s1_216_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_216_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_216_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA216 = (tmp3_0 + tmp3_1) * (s1_216_0 + s1_216_1);
    gl64_t kB216 = (tmp3_0 + tmp3_2) * (s1_216_0 + s1_216_2);
    gl64_t kC216 = (tmp3_1 + tmp3_2) * (s1_216_1 + s1_216_2);
    gl64_t kD216 = tmp3_0 * s1_216_0;
    gl64_t kE216 = tmp3_1 * s1_216_1;
    gl64_t kF216 = tmp3_2 * s1_216_2;
    gl64_t kG216 = kD216 - kE216;
    tmp3_6 = (kC216 + kG216) - kF216;
    tmp3_7 = ((((kA216 + kC216) - kE216) - kE216) - kD216);
    tmp3_8 = kB216 - kG216;
    // Op 217: dim3x1 mul
    gl64_t s0_217_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_217_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_217_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_217 = *(gl64_t*)&expressions_params[10][8];
    tmp3_0 = s0_217_0 * s1_217; tmp3_1 = s0_217_1 * s1_217; tmp3_2 = s0_217_2 * s1_217;
    // Op 218: dim3x1 add
    gl64_t s1_218 = *(gl64_t*)&expressions_params[10][7];
    tmp3_0 = tmp3_0 + s1_218; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 219: dim3x3 mul
    gl64_t s1_219_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_219_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_219_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    gl64_t s1_220 = *(gl64_t*)&expressions_params[10][9];
    tmp3_0 = tmp3_0 + s1_220; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 221: dim3x3 mul
    gl64_t s1_221_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_221_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_221_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA221 = (tmp3_0 + tmp3_1) * (s1_221_0 + s1_221_1);
    gl64_t kB221 = (tmp3_0 + tmp3_2) * (s1_221_0 + s1_221_2);
    gl64_t kC221 = (tmp3_1 + tmp3_2) * (s1_221_1 + s1_221_2);
    gl64_t kD221 = tmp3_0 * s1_221_0;
    gl64_t kE221 = tmp3_1 * s1_221_1;
    gl64_t kF221 = tmp3_2 * s1_221_2;
    gl64_t kG221 = kD221 - kE221;
    tmp3_0 = (kC221 + kG221) - kF221;
    tmp3_1 = ((((kA221 + kC221) - kE221) - kE221) - kD221);
    tmp3_2 = kB221 - kG221;
    // Op 222: dim3x1 add
    gl64_t s1_222 = *(gl64_t*)&expressions_params[10][10];
    tmp3_0 = tmp3_0 + s1_222; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 223: dim3x3 mul
    gl64_t s1_223_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_223_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_223_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 224: dim1x1 add
    gl64_t s0_224 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_224 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_224 + s1_224;
    // Op 225: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_227 = *(gl64_t*)&expressions_params[9][7];
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
    gl64_t s1_229 = *(gl64_t*)&expressions_params[9][8];
    tmp3_0 = tmp3_0 + s1_229; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 230: dim3x3 add
    gl64_t s1_230_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_230_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_230_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_230_0; tmp3_1 = tmp3_1 + s1_230_1; tmp3_2 = tmp3_2 + s1_230_2;
    // Op 231: dim3x3 mul
    gl64_t s1_231_0 = *(gl64_t*)&expressions_params[10][18];
    gl64_t s1_231_1 = *(gl64_t*)&expressions_params[10][18+1];
    gl64_t s1_231_2 = *(gl64_t*)&expressions_params[10][18+2];
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
    // Op 232: dim1x1 sub
    gl64_t s0_232 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_232 = *(gl64_t*)&expressions_params[10][2];
    tmp1_0 = s0_232 - s1_232;
    // Op 233: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 234: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 235: dim3x3 mul
    gl64_t s1_235_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_235_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_235_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA235 = (tmp3_0 + tmp3_1) * (s1_235_0 + s1_235_1);
    gl64_t kB235 = (tmp3_0 + tmp3_2) * (s1_235_0 + s1_235_2);
    gl64_t kC235 = (tmp3_1 + tmp3_2) * (s1_235_1 + s1_235_2);
    gl64_t kD235 = tmp3_0 * s1_235_0;
    gl64_t kE235 = tmp3_1 * s1_235_1;
    gl64_t kF235 = tmp3_2 * s1_235_2;
    gl64_t kG235 = kD235 - kE235;
    tmp3_6 = (kC235 + kG235) - kF235;
    tmp3_7 = ((((kA235 + kC235) - kE235) - kE235) - kD235);
    tmp3_8 = kB235 - kG235;
    // Op 236: dim3x1 mul
    gl64_t s0_236_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_236_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_236_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_236 = *(gl64_t*)&expressions_params[10][11];
    tmp3_0 = s0_236_0 * s1_236; tmp3_1 = s0_236_1 * s1_236; tmp3_2 = s0_236_2 * s1_236;
    // Op 237: dim3x1 add
    gl64_t s1_237 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_237; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 238: dim3x3 add
    gl64_t s1_238_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_238_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_238_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_238_0; tmp3_1 = tmp3_1 + s1_238_1; tmp3_2 = tmp3_2 + s1_238_2;
    // Op 239: dim3x3 mul
    gl64_t s1_239_0 = *(gl64_t*)&expressions_params[10][21];
    gl64_t s1_239_1 = *(gl64_t*)&expressions_params[10][21+1];
    gl64_t s1_239_2 = *(gl64_t*)&expressions_params[10][21+2];
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
    // Op 240: dim3x1 add
    gl64_t s1_240 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_240; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 241: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 242: dim3x3 mul
    gl64_t s1_242_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_242_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_242_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA242 = (tmp3_0 + tmp3_1) * (s1_242_0 + s1_242_1);
    gl64_t kB242 = (tmp3_0 + tmp3_2) * (s1_242_0 + s1_242_2);
    gl64_t kC242 = (tmp3_1 + tmp3_2) * (s1_242_1 + s1_242_2);
    gl64_t kD242 = tmp3_0 * s1_242_0;
    gl64_t kE242 = tmp3_1 * s1_242_1;
    gl64_t kF242 = tmp3_2 * s1_242_2;
    gl64_t kG242 = kD242 - kE242;
    tmp3_6 = (kC242 + kG242) - kF242;
    tmp3_7 = ((((kA242 + kC242) - kE242) - kE242) - kD242);
    tmp3_8 = kB242 - kG242;
    // Op 243: dim3x1 mul
    gl64_t s0_243_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_243_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_243_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_243 = *(gl64_t*)&expressions_params[10][12];
    tmp3_0 = s0_243_0 * s1_243; tmp3_1 = s0_243_1 * s1_243; tmp3_2 = s0_243_2 * s1_243;
    // Op 244: dim3x1 add
    gl64_t s1_244 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_244; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 245: dim3x3 add
    gl64_t s1_245_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_245_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_245_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_245_0; tmp3_1 = tmp3_1 + s1_245_1; tmp3_2 = tmp3_2 + s1_245_2;
    // Op 246: dim3x3 mul
    gl64_t s1_246_0 = *(gl64_t*)&expressions_params[10][24];
    gl64_t s1_246_1 = *(gl64_t*)&expressions_params[10][24+1];
    gl64_t s1_246_2 = *(gl64_t*)&expressions_params[10][24+2];
    gl64_t kA246 = (tmp3_0 + tmp3_1) * (s1_246_0 + s1_246_1);
    gl64_t kB246 = (tmp3_0 + tmp3_2) * (s1_246_0 + s1_246_2);
    gl64_t kC246 = (tmp3_1 + tmp3_2) * (s1_246_1 + s1_246_2);
    gl64_t kD246 = tmp3_0 * s1_246_0;
    gl64_t kE246 = tmp3_1 * s1_246_1;
    gl64_t kF246 = tmp3_2 * s1_246_2;
    gl64_t kG246 = kD246 - kE246;
    tmp3_0 = (kC246 + kG246) - kF246;
    tmp3_1 = ((((kA246 + kC246) - kE246) - kE246) - kD246);
    tmp3_2 = kB246 - kG246;
    // Op 247: dim3x1 add
    gl64_t s1_247 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_247; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 248: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 249: dim3x3 mul
    gl64_t s1_249_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_249_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_249_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA249 = (tmp3_0 + tmp3_1) * (s1_249_0 + s1_249_1);
    gl64_t kB249 = (tmp3_0 + tmp3_2) * (s1_249_0 + s1_249_2);
    gl64_t kC249 = (tmp3_1 + tmp3_2) * (s1_249_1 + s1_249_2);
    gl64_t kD249 = tmp3_0 * s1_249_0;
    gl64_t kE249 = tmp3_1 * s1_249_1;
    gl64_t kF249 = tmp3_2 * s1_249_2;
    gl64_t kG249 = kD249 - kE249;
    tmp3_6 = (kC249 + kG249) - kF249;
    tmp3_7 = ((((kA249 + kC249) - kE249) - kE249) - kD249);
    tmp3_8 = kB249 - kG249;
    // Op 250: dim3x1 mul
    gl64_t s0_250_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_250_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_250_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_250 = *(gl64_t*)&expressions_params[10][13];
    tmp3_0 = s0_250_0 * s1_250; tmp3_1 = s0_250_1 * s1_250; tmp3_2 = s0_250_2 * s1_250;
    // Op 251: dim3x1 add
    gl64_t s1_251 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_251; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 252: dim3x3 add
    gl64_t s1_252_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_252_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_252_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_252_0; tmp3_1 = tmp3_1 + s1_252_1; tmp3_2 = tmp3_2 + s1_252_2;
    // Op 253: dim3x3 mul
    gl64_t s1_253_0 = *(gl64_t*)&expressions_params[10][27];
    gl64_t s1_253_1 = *(gl64_t*)&expressions_params[10][27+1];
    gl64_t s1_253_2 = *(gl64_t*)&expressions_params[10][27+2];
    gl64_t kA253 = (tmp3_0 + tmp3_1) * (s1_253_0 + s1_253_1);
    gl64_t kB253 = (tmp3_0 + tmp3_2) * (s1_253_0 + s1_253_2);
    gl64_t kC253 = (tmp3_1 + tmp3_2) * (s1_253_1 + s1_253_2);
    gl64_t kD253 = tmp3_0 * s1_253_0;
    gl64_t kE253 = tmp3_1 * s1_253_1;
    gl64_t kF253 = tmp3_2 * s1_253_2;
    gl64_t kG253 = kD253 - kE253;
    tmp3_0 = (kC253 + kG253) - kF253;
    tmp3_1 = ((((kA253 + kC253) - kE253) - kE253) - kD253);
    tmp3_2 = kB253 - kG253;
    // Op 254: dim3x1 add
    gl64_t s1_254 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_254; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 255: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    tmp3_6 = (kC256 + kG256) - kF256;
    tmp3_7 = ((((kA256 + kC256) - kE256) - kE256) - kD256);
    tmp3_8 = kB256 - kG256;
    // Op 257: dim3x1 mul
    gl64_t s0_257_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_257_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_257_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_257 = *(gl64_t*)&expressions_params[10][14];
    tmp3_0 = s0_257_0 * s1_257; tmp3_1 = s0_257_1 * s1_257; tmp3_2 = s0_257_2 * s1_257;
    // Op 258: dim3x1 add
    gl64_t s1_258 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_258; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 259: dim3x3 add
    gl64_t s1_259_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_259_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_259_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_259_0; tmp3_1 = tmp3_1 + s1_259_1; tmp3_2 = tmp3_2 + s1_259_2;
    // Op 260: dim3x3 mul
    gl64_t s1_260_0 = *(gl64_t*)&expressions_params[10][30];
    gl64_t s1_260_1 = *(gl64_t*)&expressions_params[10][30+1];
    gl64_t s1_260_2 = *(gl64_t*)&expressions_params[10][30+2];
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
    // Op 261: dim3x1 add
    gl64_t s1_261 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_261; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 262: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    tmp3_3 = (kC263 + kG263) - kF263;
    tmp3_4 = ((((kA263 + kC263) - kE263) - kE263) - kD263);
    tmp3_5 = kB263 - kG263;
    // Op 264: dim3x3 sub_swap
    uint64_t s0_264_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_264_0 = *(gl64_t*)&dParams->aux_trace[s0_264_pos];
    gl64_t s0_264_1 = *(gl64_t*)&dParams->aux_trace[s0_264_pos + TILE_HEIGHT];
    gl64_t s0_264_2 = *(gl64_t*)&dParams->aux_trace[s0_264_pos + 2*TILE_HEIGHT];
    gl64_t s1_264_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_264_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_264_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_6 = s1_264_0 - s0_264_0; tmp3_7 = s1_264_1 - s0_264_1; tmp3_8 = s1_264_2 - s0_264_2;
    // Op 265: dim3x3 add
    gl64_t s0_265_0 = *(gl64_t*)&expressions_params[10][15];
    gl64_t s0_265_1 = *(gl64_t*)&expressions_params[10][15+1];
    gl64_t s0_265_2 = *(gl64_t*)&expressions_params[10][15+2];
    gl64_t s1_265_0 = *(gl64_t*)&expressions_params[10][18];
    gl64_t s1_265_1 = *(gl64_t*)&expressions_params[10][18+1];
    gl64_t s1_265_2 = *(gl64_t*)&expressions_params[10][18+2];
    tmp3_0 = s0_265_0 + s1_265_0; tmp3_1 = s0_265_1 + s1_265_1; tmp3_2 = s0_265_2 + s1_265_2;
    // Op 266: dim3x3 add
    gl64_t s1_266_0 = *(gl64_t*)&expressions_params[10][21];
    gl64_t s1_266_1 = *(gl64_t*)&expressions_params[10][21+1];
    gl64_t s1_266_2 = *(gl64_t*)&expressions_params[10][21+2];
    tmp3_0 = tmp3_0 + s1_266_0; tmp3_1 = tmp3_1 + s1_266_1; tmp3_2 = tmp3_2 + s1_266_2;
    // Op 267: dim3x3 add
    gl64_t s1_267_0 = *(gl64_t*)&expressions_params[10][24];
    gl64_t s1_267_1 = *(gl64_t*)&expressions_params[10][24+1];
    gl64_t s1_267_2 = *(gl64_t*)&expressions_params[10][24+2];
    tmp3_0 = tmp3_0 + s1_267_0; tmp3_1 = tmp3_1 + s1_267_1; tmp3_2 = tmp3_2 + s1_267_2;
    // Op 268: dim3x3 add
    gl64_t s1_268_0 = *(gl64_t*)&expressions_params[10][27];
    gl64_t s1_268_1 = *(gl64_t*)&expressions_params[10][27+1];
    gl64_t s1_268_2 = *(gl64_t*)&expressions_params[10][27+2];
    tmp3_0 = tmp3_0 + s1_268_0; tmp3_1 = tmp3_1 + s1_268_1; tmp3_2 = tmp3_2 + s1_268_2;
    // Op 269: dim3x3 add
    gl64_t s1_269_0 = *(gl64_t*)&expressions_params[10][30];
    gl64_t s1_269_1 = *(gl64_t*)&expressions_params[10][30+1];
    gl64_t s1_269_2 = *(gl64_t*)&expressions_params[10][30+2];
    tmp3_0 = tmp3_0 + s1_269_0; tmp3_1 = tmp3_1 + s1_269_1; tmp3_2 = tmp3_2 + s1_269_2;
    // Op 270: dim3x3 sub
    tmp3_0 = tmp3_6 - tmp3_0; tmp3_1 = tmp3_7 - tmp3_1; tmp3_2 = tmp3_8 - tmp3_2;
    // Op 271: dim3x1 mul
    gl64_t s1_271 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_271; tmp3_1 = tmp3_1 * s1_271; tmp3_2 = tmp3_2 * s1_271;
    // Op 272: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 273: dim3x1 mul
    gl64_t s1_273 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_273; tmp3_1 = tmp3_1 * s1_273; tmp3_2 = tmp3_2 * s1_273;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
