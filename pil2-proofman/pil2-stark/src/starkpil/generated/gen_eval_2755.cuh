// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: e45c5827  nOps=2017 nTemp1=5 nTemp3=5
#define GENERATED_EVAL_NOPS_e45c5827 2017
#define GENERATED_EVAL_NTEMP1_e45c5827 5
#define GENERATED_EVAL_NTEMP3_e45c5827 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_e45c5827(
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
    gl64_t s1_0 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_0 - s1_0;
    // Op 1: dim1x1 mul
    gl64_t s1_1 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = tmp1_0 * s1_1;
    // Op 2: dim3x1 mul
    gl64_t s0_2_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s0_2_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s0_2_2 = *(gl64_t*)&expressions_params[13][6+2];
    tmp3_0 = s0_2_0 * tmp1_0; tmp3_1 = s0_2_1 * tmp1_0; tmp3_2 = s0_2_2 * tmp1_0;
    // Op 3: dim1x1 mul
    gl64_t s0_3 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    gl64_t s1_3 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_3 * s1_3;
    // Op 4: dim1x1 add
    gl64_t s0_4 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_0 = s0_4 + tmp1_0;
    // Op 5: dim1x1 sub
    gl64_t s0_5 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp1_0 = s0_5 - tmp1_0;
    // Op 6: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 7: dim3x3 mul
    gl64_t s1_7_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_7_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_7_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 8: dim1x1 add
    gl64_t s0_8 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_8 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_8 + s1_8;
    // Op 9: dim1x1 mul
    gl64_t s0_9 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_9 * tmp1_0;
    // Op 10: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 11: dim3x3 mul
    gl64_t s1_11_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_11_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_11_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 12: dim1x1 sub_swap
    gl64_t s0_12 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_12 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_12 - s0_12;
    // Op 13: dim1x1 sub_swap
    gl64_t s0_13 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = tmp1_0 - s0_13;
    // Op 14: dim1x1 sub_swap
    gl64_t s0_14 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    tmp1_2 = tmp1_0 - s0_14;
    // Op 15: dim1x1 sub_swap
    gl64_t s0_15 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 4, domainSize, nCols_1))];
    gl64_t s1_15 = *(gl64_t*)&expressions_params[10][3];
    tmp1_0 = s1_15 - s0_15;
    // Op 16: dim1x1 mul
    gl64_t s0_16 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_0 = s0_16 * tmp1_0;
    // Op 17: dim1x1 add
    gl64_t s0_17 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 4, domainSize, nCols_1))];
    tmp1_1 = s0_17 + tmp1_0;
    // Op 18: dim1x1 sub
    gl64_t s0_18 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_18 - tmp1_1;
    // Op 19: dim1x1 mul
    tmp1_0 = tmp1_2 * tmp1_0;
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
    gl64_t s0_22 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_22 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_22 - s0_22;
    // Op 23: dim1x1 sub_swap
    gl64_t s0_23 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = tmp1_0 - s0_23;
    // Op 24: dim1x1 sub_swap
    gl64_t s0_24 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = tmp1_0 - s0_24;
    // Op 25: dim1x1 sub_swap
    gl64_t s0_25 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    tmp1_3 = tmp1_0 - s0_25;
    // Op 26: dim1x1 sub
    gl64_t s0_26 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_1 = s0_26 - tmp1_1;
    // Op 27: dim1x1 mul
    tmp1_1 = tmp1_3 * tmp1_1;
    // Op 28: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 30: dim1x1 sub
    gl64_t s0_30 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_30 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_1 = s0_30 - s1_30;
    // Op 31: dim1x1 mul
    gl64_t s0_31 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_1 = s0_31 * tmp1_1;
    // Op 32: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s0_34 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_34 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_1 = s0_34 - s1_34;
    // Op 35: dim1x1 mul
    gl64_t s0_35 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_1 = s0_35 * tmp1_1;
    // Op 36: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 38: dim1x1 sub_swap
    gl64_t s0_38 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_38 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s1_38 - s0_38;
    // Op 39: dim1x1 sub_swap
    gl64_t s0_39 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_39 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_39 - s0_39;
    // Op 40: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 41: dim1x1 mul
    gl64_t s0_41 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_41 * tmp1_0;
    // Op 42: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 43: dim3x3 mul
    gl64_t s1_43_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_43_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_43_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 44: dim1x1 sub_swap
    gl64_t s0_44 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_44 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_44 - s0_44;
    // Op 45: dim1x1 mul
    gl64_t s0_45 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_0 = s0_45 * tmp1_0;
    // Op 46: dim1x1 sub
    gl64_t s0_46 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_46 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_1 = s0_46 - s1_46;
    // Op 47: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 48: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 49: dim3x3 mul
    gl64_t s1_49_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_49_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_49_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 50: dim1x1 sub_swap
    gl64_t s0_50 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 5, domainSize, nCols_1))];
    gl64_t s1_50 = *(gl64_t*)&expressions_params[10][4];
    tmp1_0 = s1_50 - s0_50;
    // Op 51: dim1x1 mul
    gl64_t s0_51 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_0 = s0_51 * tmp1_0;
    // Op 52: dim1x1 add
    gl64_t s0_52 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 5, domainSize, nCols_1))];
    tmp1_1 = s0_52 + tmp1_0;
    // Op 53: dim1x1 sub
    gl64_t s0_53 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_53 - tmp1_1;
    // Op 54: dim1x1 mul
    tmp1_0 = tmp1_2 * tmp1_0;
    // Op 55: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 56: dim3x3 mul
    gl64_t s1_56_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_56_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_56_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 57: dim1x1 sub
    gl64_t s0_57 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_1 = s0_57 - tmp1_1;
    // Op 58: dim1x1 mul
    tmp1_1 = tmp1_3 * tmp1_1;
    // Op 59: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 60: dim3x3 mul
    gl64_t s1_60_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_60_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_60_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 61: dim1x1 sub
    gl64_t s0_61 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_61 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_1 = s0_61 - s1_61;
    // Op 62: dim1x1 mul
    gl64_t s0_62 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_1 = s0_62 * tmp1_1;
    // Op 63: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s0_65 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_65 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp1_1 = s0_65 - s1_65;
    // Op 66: dim1x1 mul
    gl64_t s0_66 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_1 = s0_66 * tmp1_1;
    // Op 67: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 68: dim3x3 mul
    gl64_t s1_68_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_68_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_68_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA68 = (tmp3_0 + tmp3_1) * (s1_68_0 + s1_68_1);
    gl64_t kB68 = (tmp3_0 + tmp3_2) * (s1_68_0 + s1_68_2);
    gl64_t kC68 = (tmp3_1 + tmp3_2) * (s1_68_1 + s1_68_2);
    gl64_t kD68 = tmp3_0 * s1_68_0;
    gl64_t kE68 = tmp3_1 * s1_68_1;
    gl64_t kF68 = tmp3_2 * s1_68_2;
    gl64_t kG68 = kD68 - kE68;
    tmp3_0 = (kC68 + kG68) - kF68;
    tmp3_1 = ((((kA68 + kC68) - kE68) - kE68) - kD68);
    tmp3_2 = kB68 - kG68;
    // Op 69: dim1x1 sub_swap
    gl64_t s0_69 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_69 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s1_69 - s0_69;
    // Op 70: dim1x1 sub_swap
    gl64_t s0_70 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_70 = *(gl64_t*)&expressions_params[9][0];
    tmp1_3 = s1_70 - s0_70;
    // Op 71: dim1x1 mul
    tmp1_1 = tmp1_1 * tmp1_3;
    // Op 72: dim1x1 mul
    gl64_t s0_72 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_1 = s0_72 * tmp1_1;
    // Op 73: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 75: dim1x1 sub_swap
    gl64_t s0_75 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_75 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s1_75 - s0_75;
    // Op 76: dim1x1 mul
    gl64_t s0_76 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_1 = s0_76 * tmp1_1;
    // Op 77: dim1x1 sub
    gl64_t s0_77 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_77 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_3 = s0_77 - s1_77;
    // Op 78: dim1x1 mul
    tmp1_1 = tmp1_1 * tmp1_3;
    // Op 79: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 80: dim3x3 mul
    gl64_t s1_80_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_80_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_80_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 81: dim1x1 sub_swap
    gl64_t s0_81 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_81 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s1_81 - s0_81;
    // Op 82: dim1x1 sub_swap
    gl64_t s0_82 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_82 = *(gl64_t*)&expressions_params[9][0];
    tmp1_3 = s1_82 - s0_82;
    // Op 83: dim1x1 mul
    tmp1_1 = tmp1_1 * tmp1_3;
    // Op 84: dim1x1 sub_swap
    gl64_t s0_84 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_84 = *(gl64_t*)&expressions_params[9][0];
    tmp1_3 = s1_84 - s0_84;
    // Op 85: dim1x1 mul
    tmp1_1 = tmp1_1 * tmp1_3;
    // Op 86: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 87: dim3x3 mul
    gl64_t s1_87_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_87_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_87_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 88: dim1x1 sub_swap
    gl64_t s0_88 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_88 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s1_88 - s0_88;
    // Op 89: dim1x1 mul
    gl64_t s0_89 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_1 = s0_89 * tmp1_1;
    // Op 90: dim1x1 mul
    gl64_t s0_90 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_1 = s0_90 * tmp1_1;
    // Op 91: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 92: dim3x3 mul
    gl64_t s1_92_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_92_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_92_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 93: dim1x1 mul
    gl64_t s0_93 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_93 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_1 = s0_93 * s1_93;
    // Op 94: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 95: dim3x3 mul
    gl64_t s1_95_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_95_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_95_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA95 = (tmp3_0 + tmp3_1) * (s1_95_0 + s1_95_1);
    gl64_t kB95 = (tmp3_0 + tmp3_2) * (s1_95_0 + s1_95_2);
    gl64_t kC95 = (tmp3_1 + tmp3_2) * (s1_95_1 + s1_95_2);
    gl64_t kD95 = tmp3_0 * s1_95_0;
    gl64_t kE95 = tmp3_1 * s1_95_1;
    gl64_t kF95 = tmp3_2 * s1_95_2;
    gl64_t kG95 = kD95 - kE95;
    tmp3_0 = (kC95 + kG95) - kF95;
    tmp3_1 = ((((kA95 + kC95) - kE95) - kE95) - kD95);
    tmp3_2 = kB95 - kG95;
    // Op 96: dim1x1 sub_swap
    gl64_t s0_96 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_96 = *(gl64_t*)&expressions_params[9][0];
    tmp1_2 = s1_96 - s0_96;
    // Op 97: dim1x1 add
    gl64_t s0_97 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 4, domainSize, nCols_1))];
    gl64_t s1_97 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 26, domainSize, nCols_1))];
    tmp1_1 = s0_97 + s1_97;
    // Op 98: dim1x1 mul
    gl64_t s0_98 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 25, domainSize, nCols_1))];
    tmp1_0 = s0_98 * tmp1_1;
    // Op 99: dim1x1 sub_swap
    gl64_t s0_99 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 25, domainSize, nCols_1))];
    gl64_t s1_99 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s1_99 - s0_99;
    // Op 100: dim1x1 add
    gl64_t s0_100 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 7, domainSize, nCols_1))];
    gl64_t s1_100 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 27, domainSize, nCols_1))];
    tmp1_3 = s0_100 + s1_100;
    // Op 101: dim1x1 mul
    tmp1_1 = tmp1_1 * tmp1_3;
    // Op 102: dim1x1 add
    tmp1_1 = tmp1_0 + tmp1_1;
    // Op 103: dim1x1 sub
    gl64_t s0_103 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 26, domainSize, nCols_1))];
    gl64_t s1_103 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 27, domainSize, nCols_1))];
    tmp1_0 = s0_103 - s1_103;
    // Op 104: dim1x1 mul
    gl64_t s0_104 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 6, domainSize, nCols_1))];
    tmp1_0 = s0_104 * tmp1_0;
    // Op 105: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 106: dim1x1 sub
    gl64_t s0_106 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_106 - tmp1_0;
    // Op 107: dim1x1 mul
    tmp1_0 = tmp1_2 * tmp1_0;
    // Op 108: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 109: dim3x3 mul
    gl64_t s1_109_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_109_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_109_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 110: dim1x1 add
    gl64_t s0_110 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_110 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_110 + s1_110;
    // Op 111: dim1x1 mul
    gl64_t s0_111 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_1 = s0_111 * tmp1_0;
    // Op 112: dim1x1 sub_swap
    gl64_t s0_112 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_112 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_112 - s0_112;
    // Op 113: dim1x1 add
    gl64_t s0_113 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_113 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp1_2 = s0_113 + s1_113;
    // Op 114: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_2;
    // Op 115: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 116: dim1x1 sub
    gl64_t s0_116 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_116 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp1_0 = s0_116 - s1_116;
    // Op 117: dim1x1 mul
    gl64_t s0_117 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_117 * tmp1_0;
    // Op 118: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 119: dim1x1 sub_swap
    gl64_t s1_119 = *(gl64_t*)&expressions_params[10][5];
    tmp1_0 = s1_119 - tmp1_0;
    // Op 120: dim1x1 mul
    gl64_t s0_120 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
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
    gl64_t s0_123 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_123 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s1_123 - s0_123;
    // Op 124: dim1x1 mul
    gl64_t s0_124 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_124 * tmp1_0;
    // Op 125: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC126 + kG126) - kF126;
    tmp3_1 = ((((kA126 + kC126) - kE126) - kE126) - kD126);
    tmp3_2 = kB126 - kG126;
    // Op 127: dim1x1 sub_swap
    gl64_t s0_127 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_127 = *(gl64_t*)&expressions_params[10][7];
    tmp1_0 = s1_127 - s0_127;
    // Op 128: dim1x1 mul
    gl64_t s0_128 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_128 * tmp1_0;
    // Op 129: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC130 + kG130) - kF130;
    tmp3_1 = ((((kA130 + kC130) - kE130) - kE130) - kD130);
    tmp3_2 = kB130 - kG130;
    // Op 131: dim1x1 sub_swap
    gl64_t s0_131 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_131 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_131 - s0_131;
    // Op 132: dim1x1 mul
    gl64_t s0_132 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
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
    tmp3_0 = (kC134 + kG134) - kF134;
    tmp3_1 = ((((kA134 + kC134) - kE134) - kE134) - kD134);
    tmp3_2 = kB134 - kG134;
    // Op 135: dim1x1 sub_swap
    gl64_t s0_135 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_135 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_135 - s0_135;
    // Op 136: dim1x1 mul
    gl64_t s0_136 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_136 * tmp1_0;
    // Op 137: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 138: dim3x3 mul
    gl64_t s1_138_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_138_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_138_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA138 = (tmp3_0 + tmp3_1) * (s1_138_0 + s1_138_1);
    gl64_t kB138 = (tmp3_0 + tmp3_2) * (s1_138_0 + s1_138_2);
    gl64_t kC138 = (tmp3_1 + tmp3_2) * (s1_138_1 + s1_138_2);
    gl64_t kD138 = tmp3_0 * s1_138_0;
    gl64_t kE138 = tmp3_1 * s1_138_1;
    gl64_t kF138 = tmp3_2 * s1_138_2;
    gl64_t kG138 = kD138 - kE138;
    tmp3_0 = (kC138 + kG138) - kF138;
    tmp3_1 = ((((kA138 + kC138) - kE138) - kE138) - kD138);
    tmp3_2 = kB138 - kG138;
    // Op 139: dim1x1 sub_swap
    gl64_t s0_139 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_139 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_139 - s0_139;
    // Op 140: dim1x1 mul
    gl64_t s0_140 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_140 * tmp1_0;
    // Op 141: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC142 + kG142) - kF142;
    tmp3_1 = ((((kA142 + kC142) - kE142) - kE142) - kD142);
    tmp3_2 = kB142 - kG142;
    // Op 143: dim1x1 sub_swap
    gl64_t s0_143 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_143 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_143 - s0_143;
    // Op 144: dim1x1 mul
    gl64_t s0_144 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_144 * tmp1_0;
    // Op 145: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 146: dim3x3 mul
    gl64_t s1_146_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_146_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_146_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA146 = (tmp3_0 + tmp3_1) * (s1_146_0 + s1_146_1);
    gl64_t kB146 = (tmp3_0 + tmp3_2) * (s1_146_0 + s1_146_2);
    gl64_t kC146 = (tmp3_1 + tmp3_2) * (s1_146_1 + s1_146_2);
    gl64_t kD146 = tmp3_0 * s1_146_0;
    gl64_t kE146 = tmp3_1 * s1_146_1;
    gl64_t kF146 = tmp3_2 * s1_146_2;
    gl64_t kG146 = kD146 - kE146;
    tmp3_0 = (kC146 + kG146) - kF146;
    tmp3_1 = ((((kA146 + kC146) - kE146) - kE146) - kD146);
    tmp3_2 = kB146 - kG146;
    // Op 147: dim1x1 sub_swap
    gl64_t s0_147 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_147 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_147 - s0_147;
    // Op 148: dim1x1 mul
    gl64_t s0_148 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_148 * tmp1_0;
    // Op 149: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 150: dim3x3 mul
    gl64_t s1_150_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_150_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_150_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA150 = (tmp3_0 + tmp3_1) * (s1_150_0 + s1_150_1);
    gl64_t kB150 = (tmp3_0 + tmp3_2) * (s1_150_0 + s1_150_2);
    gl64_t kC150 = (tmp3_1 + tmp3_2) * (s1_150_1 + s1_150_2);
    gl64_t kD150 = tmp3_0 * s1_150_0;
    gl64_t kE150 = tmp3_1 * s1_150_1;
    gl64_t kF150 = tmp3_2 * s1_150_2;
    gl64_t kG150 = kD150 - kE150;
    tmp3_0 = (kC150 + kG150) - kF150;
    tmp3_1 = ((((kA150 + kC150) - kE150) - kE150) - kD150);
    tmp3_2 = kB150 - kG150;
    // Op 151: dim1x1 sub_swap
    gl64_t s0_151 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_151 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_151 - s0_151;
    // Op 152: dim1x1 mul
    gl64_t s0_152 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_152 * tmp1_0;
    // Op 153: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 154: dim3x3 mul
    gl64_t s1_154_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_154_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_154_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA154 = (tmp3_0 + tmp3_1) * (s1_154_0 + s1_154_1);
    gl64_t kB154 = (tmp3_0 + tmp3_2) * (s1_154_0 + s1_154_2);
    gl64_t kC154 = (tmp3_1 + tmp3_2) * (s1_154_1 + s1_154_2);
    gl64_t kD154 = tmp3_0 * s1_154_0;
    gl64_t kE154 = tmp3_1 * s1_154_1;
    gl64_t kF154 = tmp3_2 * s1_154_2;
    gl64_t kG154 = kD154 - kE154;
    tmp3_0 = (kC154 + kG154) - kF154;
    tmp3_1 = ((((kA154 + kC154) - kE154) - kE154) - kD154);
    tmp3_2 = kB154 - kG154;
    // Op 155: dim1x1 sub_swap
    gl64_t s0_155 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_155 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_155 - s0_155;
    // Op 156: dim1x1 mul
    gl64_t s0_156 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_0 = s0_156 * tmp1_0;
    // Op 157: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC158 + kG158) - kF158;
    tmp3_1 = ((((kA158 + kC158) - kE158) - kE158) - kD158);
    tmp3_2 = kB158 - kG158;
    // Op 159: dim1x1 sub_swap
    gl64_t s0_159 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    gl64_t s1_159 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_159 - s0_159;
    // Op 160: dim1x1 mul
    gl64_t s0_160 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_160 * tmp1_0;
    // Op 161: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 162: dim3x3 mul
    gl64_t s1_162_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_162_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_162_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 163: dim1x1 sub_swap
    gl64_t s0_163 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_163 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_163 - s0_163;
    // Op 164: dim1x1 mul
    gl64_t s0_164 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_164 * tmp1_0;
    // Op 165: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 166: dim3x3 mul
    gl64_t s1_166_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_166_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_166_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 167: dim1x1 sub_swap
    gl64_t s0_167 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_167 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_167 - s0_167;
    // Op 168: dim1x1 mul
    gl64_t s0_168 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = s0_168 * tmp1_0;
    // Op 169: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 170: dim3x3 mul
    gl64_t s1_170_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_170_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_170_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 171: dim1x1 sub_swap
    gl64_t s0_171 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_171 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_171 - s0_171;
    // Op 172: dim1x1 mul
    gl64_t s0_172 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_0 = s0_172 * tmp1_0;
    // Op 173: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC174 + kG174) - kF174;
    tmp3_1 = ((((kA174 + kC174) - kE174) - kE174) - kD174);
    tmp3_2 = kB174 - kG174;
    // Op 175: dim1x1 sub_swap
    gl64_t s0_175 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_175 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_175 - s0_175;
    // Op 176: dim1x1 mul
    gl64_t s0_176 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_176 * tmp1_0;
    // Op 177: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 178: dim3x3 mul
    gl64_t s1_178_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_178_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_178_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 179: dim1x1 sub_swap
    gl64_t s0_179 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    gl64_t s1_179 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_179 - s0_179;
    // Op 180: dim1x1 mul
    gl64_t s0_180 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_180 * tmp1_0;
    // Op 181: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 182: dim3x3 mul
    gl64_t s1_182_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_182_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_182_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 183: dim1x1 sub_swap
    gl64_t s0_183 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    gl64_t s1_183 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_183 - s0_183;
    // Op 184: dim1x1 mul
    gl64_t s0_184 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    tmp1_0 = s0_184 * tmp1_0;
    // Op 185: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 186: dim3x3 mul
    gl64_t s1_186_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_186_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_186_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA186 = (tmp3_0 + tmp3_1) * (s1_186_0 + s1_186_1);
    gl64_t kB186 = (tmp3_0 + tmp3_2) * (s1_186_0 + s1_186_2);
    gl64_t kC186 = (tmp3_1 + tmp3_2) * (s1_186_1 + s1_186_2);
    gl64_t kD186 = tmp3_0 * s1_186_0;
    gl64_t kE186 = tmp3_1 * s1_186_1;
    gl64_t kF186 = tmp3_2 * s1_186_2;
    gl64_t kG186 = kD186 - kE186;
    tmp3_0 = (kC186 + kG186) - kF186;
    tmp3_1 = ((((kA186 + kC186) - kE186) - kE186) - kD186);
    tmp3_2 = kB186 - kG186;
    // Op 187: dim1x1 sub_swap
    gl64_t s0_187 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    gl64_t s1_187 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_187 - s0_187;
    // Op 188: dim1x1 mul
    gl64_t s0_188 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    tmp1_0 = s0_188 * tmp1_0;
    // Op 189: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC190 + kG190) - kF190;
    tmp3_1 = ((((kA190 + kC190) - kE190) - kE190) - kD190);
    tmp3_2 = kB190 - kG190;
    // Op 191: dim1x1 sub_swap
    gl64_t s0_191 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    gl64_t s1_191 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_191 - s0_191;
    // Op 192: dim1x1 mul
    gl64_t s0_192 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    tmp1_0 = s0_192 * tmp1_0;
    // Op 193: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC194 + kG194) - kF194;
    tmp3_1 = ((((kA194 + kC194) - kE194) - kE194) - kD194);
    tmp3_2 = kB194 - kG194;
    // Op 195: dim1x1 sub_swap
    gl64_t s0_195 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_195 = *(gl64_t*)&expressions_params[10][2];
    tmp1_0 = s1_195 - s0_195;
    // Op 196: dim1x1 mul
    gl64_t s0_196 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_0 = s0_196 * tmp1_0;
    // Op 197: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 198: dim3x3 mul
    gl64_t s1_198_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_198_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_198_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA198 = (tmp3_0 + tmp3_1) * (s1_198_0 + s1_198_1);
    gl64_t kB198 = (tmp3_0 + tmp3_2) * (s1_198_0 + s1_198_2);
    gl64_t kC198 = (tmp3_1 + tmp3_2) * (s1_198_1 + s1_198_2);
    gl64_t kD198 = tmp3_0 * s1_198_0;
    gl64_t kE198 = tmp3_1 * s1_198_1;
    gl64_t kF198 = tmp3_2 * s1_198_2;
    gl64_t kG198 = kD198 - kE198;
    tmp3_12 = (kC198 + kG198) - kF198;
    tmp3_13 = ((((kA198 + kC198) - kE198) - kE198) - kD198);
    tmp3_14 = kB198 - kG198;
    // Op 199: dim3x1 mul
    gl64_t s0_199_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_199_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_199_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_199 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp3_0 = s0_199_0 * s1_199; tmp3_1 = s0_199_1 * s1_199; tmp3_2 = s0_199_2 * s1_199;
    // Op 200: dim3x1 add
    gl64_t s1_200 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_200; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 201: dim3x3 mul
    gl64_t s1_201_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_201_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_201_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA201 = (tmp3_0 + tmp3_1) * (s1_201_0 + s1_201_1);
    gl64_t kB201 = (tmp3_0 + tmp3_2) * (s1_201_0 + s1_201_2);
    gl64_t kC201 = (tmp3_1 + tmp3_2) * (s1_201_1 + s1_201_2);
    gl64_t kD201 = tmp3_0 * s1_201_0;
    gl64_t kE201 = tmp3_1 * s1_201_1;
    gl64_t kF201 = tmp3_2 * s1_201_2;
    gl64_t kG201 = kD201 - kE201;
    tmp3_0 = (kC201 + kG201) - kF201;
    tmp3_1 = ((((kA201 + kC201) - kE201) - kE201) - kD201);
    tmp3_2 = kB201 - kG201;
    // Op 202: dim3x1 add
    gl64_t s1_202 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_202; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 203: dim3x3 mul
    gl64_t s1_203_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_203_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_203_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 204: dim1x1 mul
    gl64_t s0_204 = *(gl64_t*)&expressions_params[9][5];
    gl64_t s1_204 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_204 * s1_204;
    // Op 205: dim1x1 add
    gl64_t s0_205 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_0)];
    tmp1_4 = s0_205 + tmp1_0;
    // Op 206: dim1x1 mul
    gl64_t s1_206 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = tmp1_4 * s1_206;
    // Op 207: dim1x1 add
    gl64_t s1_207 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = tmp1_0 + s1_207;
    // Op 208: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_210 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
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
    // Op 212: dim1x1 mul
    gl64_t s0_212 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    gl64_t s1_212 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_212 * s1_212;
    // Op 213: dim1x1 add
    gl64_t s0_213 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_213 + tmp1_0;
    // Op 214: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_216 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_0 + s1_216; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 217: dim3x3 add
    gl64_t s1_217_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_217_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_217_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_217_0; tmp3_4 = tmp3_10 + s1_217_1; tmp3_5 = tmp3_11 + s1_217_2;
    // Op 218: dim3x1 mul
    gl64_t s0_218_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_218_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_218_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_218 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp3_0 = s0_218_0 * s1_218; tmp3_1 = s0_218_1 * s1_218; tmp3_2 = s0_218_2 * s1_218;
    // Op 219: dim3x1 add
    gl64_t s1_219 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_219; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 220: dim3x3 mul
    gl64_t s1_220_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_220_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_220_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    gl64_t s1_221 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_221; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_223 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
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
    gl64_t s1_225 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
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
    gl64_t s1_227 = *(gl64_t*)&expressions_params[9][3];
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
    gl64_t s1_229 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_0 + s1_229; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 230: dim3x3 add
    gl64_t s1_230_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_230_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_230_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_230_0; tmp3_1 = tmp3_7 + s1_230_1; tmp3_2 = tmp3_8 + s1_230_2;
    // Op 231: dim3x3 mul
    gl64_t kA231 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB231 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC231 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD231 = tmp3_3 * tmp3_0;
    gl64_t kE231 = tmp3_4 * tmp3_1;
    gl64_t kF231 = tmp3_5 * tmp3_2;
    gl64_t kG231 = kD231 - kE231;
    tmp3_0 = (kC231 + kG231) - kF231;
    tmp3_1 = ((((kA231 + kC231) - kE231) - kE231) - kD231);
    tmp3_2 = kB231 - kG231;
    // Op 232: dim3x3 mul
    gl64_t s0_232_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_232_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_232_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA232 = (s0_232_0 + s0_232_1) * (tmp3_0 + tmp3_1);
    gl64_t kB232 = (s0_232_0 + s0_232_2) * (tmp3_0 + tmp3_2);
    gl64_t kC232 = (s0_232_1 + s0_232_2) * (tmp3_1 + tmp3_2);
    gl64_t kD232 = s0_232_0 * tmp3_0;
    gl64_t kE232 = s0_232_1 * tmp3_1;
    gl64_t kF232 = s0_232_2 * tmp3_2;
    gl64_t kG232 = kD232 - kE232;
    tmp3_0 = (kC232 + kG232) - kF232;
    tmp3_1 = ((((kA232 + kC232) - kE232) - kE232) - kD232);
    tmp3_2 = kB232 - kG232;
    // Op 233: dim1x1 add
    gl64_t s0_233 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_233 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    tmp1_0 = s0_233 + s1_233;
    // Op 234: dim1x1 sub_swap
    gl64_t s1_234 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_234 - tmp1_0;
    // Op 235: dim3x3 add
    gl64_t s1_235_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_235_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_235_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_235_0; tmp3_7 = tmp3_7 + s1_235_1; tmp3_8 = tmp3_8 + s1_235_2;
    // Op 236: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 237: dim3x3 add
    gl64_t s1_237_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_237_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_237_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_237_0; tmp3_10 = tmp3_10 + s1_237_1; tmp3_11 = tmp3_11 + s1_237_2;
    // Op 238: dim3x1 mul
    gl64_t s1_238 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_238; tmp3_10 = tmp3_10 * s1_238; tmp3_11 = tmp3_11 * s1_238;
    // Op 239: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 240: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 241: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
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
    tmp3_3 = (kC242 + kG242) - kF242;
    tmp3_4 = ((((kA242 + kC242) - kE242) - kE242) - kD242);
    tmp3_5 = kB242 - kG242;
    // Op 243: dim3x1 mul
    gl64_t s0_243_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_243_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_243_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_243 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    tmp3_0 = s0_243_0 * s1_243; tmp3_1 = s0_243_1 * s1_243; tmp3_2 = s0_243_2 * s1_243;
    // Op 244: dim3x1 add
    gl64_t s1_244 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
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
    gl64_t s1_246 = *(gl64_t*)&expressions_params[9][2];
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
    // Op 248: dim3x1 add
    gl64_t s1_248 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_248; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 249: dim3x3 mul
    gl64_t s1_249_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_249_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_249_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA249 = (tmp3_0 + tmp3_1) * (s1_249_0 + s1_249_1);
    gl64_t kB249 = (tmp3_0 + tmp3_2) * (s1_249_0 + s1_249_2);
    gl64_t kC249 = (tmp3_1 + tmp3_2) * (s1_249_1 + s1_249_2);
    gl64_t kD249 = tmp3_0 * s1_249_0;
    gl64_t kE249 = tmp3_1 * s1_249_1;
    gl64_t kF249 = tmp3_2 * s1_249_2;
    gl64_t kG249 = kD249 - kE249;
    tmp3_0 = (kC249 + kG249) - kF249;
    tmp3_1 = ((((kA249 + kC249) - kE249) - kE249) - kD249);
    tmp3_2 = kB249 - kG249;
    // Op 250: dim3x1 add
    gl64_t s1_250 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_250; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 251: dim3x3 mul
    gl64_t s1_251_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_251_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_251_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA251 = (tmp3_0 + tmp3_1) * (s1_251_0 + s1_251_1);
    gl64_t kB251 = (tmp3_0 + tmp3_2) * (s1_251_0 + s1_251_2);
    gl64_t kC251 = (tmp3_1 + tmp3_2) * (s1_251_1 + s1_251_2);
    gl64_t kD251 = tmp3_0 * s1_251_0;
    gl64_t kE251 = tmp3_1 * s1_251_1;
    gl64_t kF251 = tmp3_2 * s1_251_2;
    gl64_t kG251 = kD251 - kE251;
    tmp3_0 = (kC251 + kG251) - kF251;
    tmp3_1 = ((((kA251 + kC251) - kE251) - kE251) - kD251);
    tmp3_2 = kB251 - kG251;
    // Op 252: dim3x1 add
    gl64_t s1_252 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_252; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 253: dim3x3 mul
    gl64_t s1_253_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_253_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_253_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    gl64_t s1_254 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_0 + s1_254; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 255: dim3x3 add
    gl64_t s1_255_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_255_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_255_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_255_0; tmp3_13 = tmp3_10 + s1_255_1; tmp3_14 = tmp3_11 + s1_255_2;
    // Op 256: dim1x1 sub_swap
    gl64_t s0_256 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    tmp1_1 = tmp1_1 - s0_256;
    // Op 257: dim1x1 sub
    gl64_t s1_257 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = tmp1_1 - s1_257;
    // Op 258: dim3x1 mul
    gl64_t s0_258_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_258_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_258_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_258_0 * tmp1_1; tmp3_1 = s0_258_1 * tmp1_1; tmp3_2 = s0_258_2 * tmp1_1;
    // Op 259: dim3x1 add
    gl64_t s1_259 = *(gl64_t*)&expressions_params[9][7];
    tmp3_6 = tmp3_0 + s1_259; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 260: dim3x3 add
    gl64_t s1_260_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_260_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_260_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_260_0; tmp3_1 = tmp3_7 + s1_260_1; tmp3_2 = tmp3_8 + s1_260_2;
    // Op 261: dim3x3 mul
    gl64_t kA261 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB261 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC261 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD261 = tmp3_12 * tmp3_0;
    gl64_t kE261 = tmp3_13 * tmp3_1;
    gl64_t kF261 = tmp3_14 * tmp3_2;
    gl64_t kG261 = kD261 - kE261;
    tmp3_0 = (kC261 + kG261) - kF261;
    tmp3_1 = ((((kA261 + kC261) - kE261) - kE261) - kD261);
    tmp3_2 = kB261 - kG261;
    // Op 262: dim3x3 mul
    gl64_t s0_262_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_262_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_262_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA262 = (s0_262_0 + s0_262_1) * (tmp3_0 + tmp3_1);
    gl64_t kB262 = (s0_262_0 + s0_262_2) * (tmp3_0 + tmp3_2);
    gl64_t kC262 = (s0_262_1 + s0_262_2) * (tmp3_1 + tmp3_2);
    gl64_t kD262 = s0_262_0 * tmp3_0;
    gl64_t kE262 = s0_262_1 * tmp3_1;
    gl64_t kF262 = s0_262_2 * tmp3_2;
    gl64_t kG262 = kD262 - kE262;
    tmp3_0 = (kC262 + kG262) - kF262;
    tmp3_1 = ((((kA262 + kC262) - kE262) - kE262) - kD262);
    tmp3_2 = kB262 - kG262;
    // Op 263: dim3x3 add
    gl64_t s1_263_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_263_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_263_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_263_0; tmp3_7 = tmp3_7 + s1_263_1; tmp3_8 = tmp3_8 + s1_263_2;
    // Op 264: dim3x1 mul
    gl64_t s1_264 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    tmp3_6 = tmp3_6 * s1_264; tmp3_7 = tmp3_7 * s1_264; tmp3_8 = tmp3_8 * s1_264;
    // Op 265: dim1x1 sub_swap
    gl64_t s0_265 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    gl64_t s1_265 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_265 - s0_265;
    // Op 266: dim3x3 add
    gl64_t s1_266_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_266_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_266_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_266_0; tmp3_10 = tmp3_10 + s1_266_1; tmp3_11 = tmp3_11 + s1_266_2;
    // Op 267: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_1; tmp3_10 = tmp3_10 * tmp1_1; tmp3_11 = tmp3_11 * tmp1_1;
    // Op 268: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 269: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 270: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
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
    tmp3_12 = (kC271 + kG271) - kF271;
    tmp3_13 = ((((kA271 + kC271) - kE271) - kE271) - kD271);
    tmp3_14 = kB271 - kG271;
    // Op 272: dim1x1 mul
    gl64_t s1_272 = *(gl64_t*)&expressions_params[9][6];
    tmp1_1 = tmp1_4 * s1_272;
    // Op 273: dim1x1 add
    gl64_t s1_273 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = tmp1_1 + s1_273;
    // Op 274: dim1x1 add
    gl64_t s1_274 = *(gl64_t*)&expressions_params[9][0];
    tmp1_2 = tmp1_1 + s1_274;
    // Op 275: dim1x1 sub_swap
    gl64_t s0_275 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp1_1 = tmp1_2 - s0_275;
    // Op 276: dim1x1 sub
    gl64_t s1_276 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = tmp1_1 - s1_276;
    // Op 277: dim3x1 mul
    gl64_t s0_277_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_277_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_277_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_277_0 * tmp1_1; tmp3_1 = s0_277_1 * tmp1_1; tmp3_2 = s0_277_2 * tmp1_1;
    // Op 278: dim3x1 add
    gl64_t s1_278 = *(gl64_t*)&expressions_params[9][7];
    tmp3_9 = tmp3_0 + s1_278; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 279: dim3x3 add
    gl64_t s1_279_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_279_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_279_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_279_0; tmp3_4 = tmp3_10 + s1_279_1; tmp3_5 = tmp3_11 + s1_279_2;
    // Op 280: dim1x1 mul
    gl64_t s1_280 = *(gl64_t*)&expressions_params[9][6];
    tmp1_1 = tmp1_4 * s1_280;
    // Op 281: dim1x1 add
    gl64_t s1_281 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = tmp1_1 + s1_281;
    // Op 282: dim1x1 add
    gl64_t s1_282 = *(gl64_t*)&expressions_params[9][8];
    tmp1_3 = tmp1_1 + s1_282;
    // Op 283: dim1x1 sub_swap
    gl64_t s0_283 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp1_1 = tmp1_3 - s0_283;
    // Op 284: dim1x1 sub
    gl64_t s1_284 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = tmp1_1 - s1_284;
    // Op 285: dim3x1 mul
    gl64_t s0_285_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_285_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_285_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_285_0 * tmp1_1; tmp3_1 = s0_285_1 * tmp1_1; tmp3_2 = s0_285_2 * tmp1_1;
    // Op 286: dim3x1 add
    gl64_t s1_286 = *(gl64_t*)&expressions_params[9][7];
    tmp3_6 = tmp3_0 + s1_286; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 287: dim3x3 add
    gl64_t s1_287_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_287_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_287_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_287_0; tmp3_1 = tmp3_7 + s1_287_1; tmp3_2 = tmp3_8 + s1_287_2;
    // Op 288: dim3x3 mul
    gl64_t kA288 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB288 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC288 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD288 = tmp3_3 * tmp3_0;
    gl64_t kE288 = tmp3_4 * tmp3_1;
    gl64_t kF288 = tmp3_5 * tmp3_2;
    gl64_t kG288 = kD288 - kE288;
    tmp3_0 = (kC288 + kG288) - kF288;
    tmp3_1 = ((((kA288 + kC288) - kE288) - kE288) - kD288);
    tmp3_2 = kB288 - kG288;
    // Op 289: dim3x3 mul
    uint64_t s0_289_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_289_0 = *(gl64_t*)&dParams->aux_trace[s0_289_pos];
    gl64_t s0_289_1 = *(gl64_t*)&dParams->aux_trace[s0_289_pos + TILE_HEIGHT];
    gl64_t s0_289_2 = *(gl64_t*)&dParams->aux_trace[s0_289_pos + 2*TILE_HEIGHT];
    gl64_t kA289 = (s0_289_0 + s0_289_1) * (tmp3_0 + tmp3_1);
    gl64_t kB289 = (s0_289_0 + s0_289_2) * (tmp3_0 + tmp3_2);
    gl64_t kC289 = (s0_289_1 + s0_289_2) * (tmp3_1 + tmp3_2);
    gl64_t kD289 = s0_289_0 * tmp3_0;
    gl64_t kE289 = s0_289_1 * tmp3_1;
    gl64_t kF289 = s0_289_2 * tmp3_2;
    gl64_t kG289 = kD289 - kE289;
    tmp3_0 = (kC289 + kG289) - kF289;
    tmp3_1 = ((((kA289 + kC289) - kE289) - kE289) - kD289);
    tmp3_2 = kB289 - kG289;
    // Op 290: dim1x1 sub_swap
    gl64_t s0_290 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    gl64_t s1_290 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_290 - s0_290;
    // Op 291: dim3x3 add
    gl64_t s1_291_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_291_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_291_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_291_0; tmp3_7 = tmp3_7 + s1_291_1; tmp3_8 = tmp3_8 + s1_291_2;
    // Op 292: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_1; tmp3_7 = tmp3_7 * tmp1_1; tmp3_8 = tmp3_8 * tmp1_1;
    // Op 293: dim1x1 sub_swap
    gl64_t s0_293 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    gl64_t s1_293 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_293 - s0_293;
    // Op 294: dim3x3 add
    gl64_t s1_294_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_294_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_294_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_294_0; tmp3_10 = tmp3_10 + s1_294_1; tmp3_11 = tmp3_11 + s1_294_2;
    // Op 295: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_1; tmp3_10 = tmp3_10 * tmp1_1; tmp3_11 = tmp3_11 * tmp1_1;
    // Op 296: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 297: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 298: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 299: dim3x3 mul
    gl64_t s1_299_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_299_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_299_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA299 = (tmp3_0 + tmp3_1) * (s1_299_0 + s1_299_1);
    gl64_t kB299 = (tmp3_0 + tmp3_2) * (s1_299_0 + s1_299_2);
    gl64_t kC299 = (tmp3_1 + tmp3_2) * (s1_299_1 + s1_299_2);
    gl64_t kD299 = tmp3_0 * s1_299_0;
    gl64_t kE299 = tmp3_1 * s1_299_1;
    gl64_t kF299 = tmp3_2 * s1_299_2;
    gl64_t kG299 = kD299 - kE299;
    tmp3_12 = (kC299 + kG299) - kF299;
    tmp3_13 = ((((kA299 + kC299) - kE299) - kE299) - kD299);
    tmp3_14 = kB299 - kG299;
    // Op 300: dim1x1 mul
    gl64_t s0_300 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_300 = *(gl64_t*)&expressions_params[9][8];
    tmp1_1 = s0_300 * s1_300;
    // Op 301: dim1x1 add
    gl64_t s1_301 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = tmp1_1 + s1_301;
    // Op 302: dim1x1 mul
    gl64_t s0_302 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_302 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = s0_302 * s1_302;
    // Op 303: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 304: dim1x1 mul
    gl64_t s0_304 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_304 = *(gl64_t*)&expressions_params[9][2];
    tmp1_1 = s0_304 * s1_304;
    // Op 305: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 306: dim1x1 mul
    gl64_t s0_306 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_306 = *(gl64_t*)&expressions_params[9][9];
    tmp1_1 = s0_306 * s1_306;
    // Op 307: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 308: dim1x1 mul
    gl64_t s0_308 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_308 = *(gl64_t*)&expressions_params[9][10];
    tmp1_1 = s0_308 * s1_308;
    // Op 309: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 310: dim1x1 mul
    gl64_t s0_310 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_310 = *(gl64_t*)&expressions_params[9][11];
    tmp1_1 = s0_310 * s1_310;
    // Op 311: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 312: dim1x1 mul
    gl64_t s0_312 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    gl64_t s1_312 = *(gl64_t*)&expressions_params[9][12];
    tmp1_1 = s0_312 * s1_312;
    // Op 313: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 314: dim1x1 mul
    gl64_t s0_314 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_314 = *(gl64_t*)&expressions_params[9][13];
    tmp1_1 = s0_314 * s1_314;
    // Op 315: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 316: dim1x1 mul
    gl64_t s0_316 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_316 = *(gl64_t*)&expressions_params[9][14];
    tmp1_1 = s0_316 * s1_316;
    // Op 317: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 318: dim1x1 mul
    gl64_t s0_318 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_318 = *(gl64_t*)&expressions_params[9][15];
    tmp1_1 = s0_318 * s1_318;
    // Op 319: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 320: dim1x1 mul
    gl64_t s0_320 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_320 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_320 * s1_320;
    // Op 321: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 322: dim1x1 mul
    gl64_t s0_322 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    gl64_t s1_322 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_322 * s1_322;
    // Op 323: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 324: dim1x1 mul
    gl64_t s0_324 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    gl64_t s1_324 = *(gl64_t*)&expressions_params[9][18];
    tmp1_1 = s0_324 * s1_324;
    // Op 325: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 326: dim1x1 mul
    gl64_t s0_326 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    gl64_t s1_326 = *(gl64_t*)&expressions_params[9][19];
    tmp1_1 = s0_326 * s1_326;
    // Op 327: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 328: dim1x1 mul
    gl64_t s0_328 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    gl64_t s1_328 = *(gl64_t*)&expressions_params[9][20];
    tmp1_1 = s0_328 * s1_328;
    // Op 329: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 330: dim3x1 mul
    gl64_t s0_330_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_330_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_330_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_330_0 * tmp1_0; tmp3_1 = s0_330_1 * tmp1_0; tmp3_2 = s0_330_2 * tmp1_0;
    // Op 331: dim3x1 add
    gl64_t s1_331 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_331; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 332: dim3x3 mul
    gl64_t s1_332_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_332_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_332_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA332 = (tmp3_0 + tmp3_1) * (s1_332_0 + s1_332_1);
    gl64_t kB332 = (tmp3_0 + tmp3_2) * (s1_332_0 + s1_332_2);
    gl64_t kC332 = (tmp3_1 + tmp3_2) * (s1_332_1 + s1_332_2);
    gl64_t kD332 = tmp3_0 * s1_332_0;
    gl64_t kE332 = tmp3_1 * s1_332_1;
    gl64_t kF332 = tmp3_2 * s1_332_2;
    gl64_t kG332 = kD332 - kE332;
    tmp3_0 = (kC332 + kG332) - kF332;
    tmp3_1 = ((((kA332 + kC332) - kE332) - kE332) - kD332);
    tmp3_2 = kB332 - kG332;
    // Op 333: dim3x1 add
    gl64_t s1_333 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_333; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 334: dim3x3 mul
    gl64_t s1_334_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_334_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_334_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA334 = (tmp3_0 + tmp3_1) * (s1_334_0 + s1_334_1);
    gl64_t kB334 = (tmp3_0 + tmp3_2) * (s1_334_0 + s1_334_2);
    gl64_t kC334 = (tmp3_1 + tmp3_2) * (s1_334_1 + s1_334_2);
    gl64_t kD334 = tmp3_0 * s1_334_0;
    gl64_t kE334 = tmp3_1 * s1_334_1;
    gl64_t kF334 = tmp3_2 * s1_334_2;
    gl64_t kG334 = kD334 - kE334;
    tmp3_0 = (kC334 + kG334) - kF334;
    tmp3_1 = ((((kA334 + kC334) - kE334) - kE334) - kD334);
    tmp3_2 = kB334 - kG334;
    // Op 335: dim3x1 add
    gl64_t s1_335 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_335; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 336: dim3x3 mul
    gl64_t s1_336_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_336_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_336_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA336 = (tmp3_0 + tmp3_1) * (s1_336_0 + s1_336_1);
    gl64_t kB336 = (tmp3_0 + tmp3_2) * (s1_336_0 + s1_336_2);
    gl64_t kC336 = (tmp3_1 + tmp3_2) * (s1_336_1 + s1_336_2);
    gl64_t kD336 = tmp3_0 * s1_336_0;
    gl64_t kE336 = tmp3_1 * s1_336_1;
    gl64_t kF336 = tmp3_2 * s1_336_2;
    gl64_t kG336 = kD336 - kE336;
    tmp3_0 = (kC336 + kG336) - kF336;
    tmp3_1 = ((((kA336 + kC336) - kE336) - kE336) - kD336);
    tmp3_2 = kB336 - kG336;
    // Op 337: dim3x1 add
    gl64_t s1_337 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_337; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 338: dim3x3 mul
    gl64_t s1_338_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_338_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_338_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA338 = (tmp3_0 + tmp3_1) * (s1_338_0 + s1_338_1);
    gl64_t kB338 = (tmp3_0 + tmp3_2) * (s1_338_0 + s1_338_2);
    gl64_t kC338 = (tmp3_1 + tmp3_2) * (s1_338_1 + s1_338_2);
    gl64_t kD338 = tmp3_0 * s1_338_0;
    gl64_t kE338 = tmp3_1 * s1_338_1;
    gl64_t kF338 = tmp3_2 * s1_338_2;
    gl64_t kG338 = kD338 - kE338;
    tmp3_0 = (kC338 + kG338) - kF338;
    tmp3_1 = ((((kA338 + kC338) - kE338) - kE338) - kD338);
    tmp3_2 = kB338 - kG338;
    // Op 339: dim3x1 add
    gl64_t s1_339 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_339; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 340: dim3x3 mul
    gl64_t s1_340_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_340_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_340_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA340 = (tmp3_0 + tmp3_1) * (s1_340_0 + s1_340_1);
    gl64_t kB340 = (tmp3_0 + tmp3_2) * (s1_340_0 + s1_340_2);
    gl64_t kC340 = (tmp3_1 + tmp3_2) * (s1_340_1 + s1_340_2);
    gl64_t kD340 = tmp3_0 * s1_340_0;
    gl64_t kE340 = tmp3_1 * s1_340_1;
    gl64_t kF340 = tmp3_2 * s1_340_2;
    gl64_t kG340 = kD340 - kE340;
    tmp3_0 = (kC340 + kG340) - kF340;
    tmp3_1 = ((((kA340 + kC340) - kE340) - kE340) - kD340);
    tmp3_2 = kB340 - kG340;
    // Op 341: dim3x1 add
    gl64_t s1_341 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_341; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 342: dim3x3 mul
    gl64_t s1_342_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_342_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_342_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA342 = (tmp3_0 + tmp3_1) * (s1_342_0 + s1_342_1);
    gl64_t kB342 = (tmp3_0 + tmp3_2) * (s1_342_0 + s1_342_2);
    gl64_t kC342 = (tmp3_1 + tmp3_2) * (s1_342_1 + s1_342_2);
    gl64_t kD342 = tmp3_0 * s1_342_0;
    gl64_t kE342 = tmp3_1 * s1_342_1;
    gl64_t kF342 = tmp3_2 * s1_342_2;
    gl64_t kG342 = kD342 - kE342;
    tmp3_0 = (kC342 + kG342) - kF342;
    tmp3_1 = ((((kA342 + kC342) - kE342) - kE342) - kD342);
    tmp3_2 = kB342 - kG342;
    // Op 343: dim3x1 add
    gl64_t s1_343 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_343; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 344: dim3x3 mul
    gl64_t s1_344_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_344_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_344_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA344 = (tmp3_0 + tmp3_1) * (s1_344_0 + s1_344_1);
    gl64_t kB344 = (tmp3_0 + tmp3_2) * (s1_344_0 + s1_344_2);
    gl64_t kC344 = (tmp3_1 + tmp3_2) * (s1_344_1 + s1_344_2);
    gl64_t kD344 = tmp3_0 * s1_344_0;
    gl64_t kE344 = tmp3_1 * s1_344_1;
    gl64_t kF344 = tmp3_2 * s1_344_2;
    gl64_t kG344 = kD344 - kE344;
    tmp3_0 = (kC344 + kG344) - kF344;
    tmp3_1 = ((((kA344 + kC344) - kE344) - kE344) - kD344);
    tmp3_2 = kB344 - kG344;
    // Op 345: dim3x1 add
    gl64_t s1_345 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_345; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 346: dim3x3 mul
    gl64_t s1_346_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_346_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_346_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA346 = (tmp3_0 + tmp3_1) * (s1_346_0 + s1_346_1);
    gl64_t kB346 = (tmp3_0 + tmp3_2) * (s1_346_0 + s1_346_2);
    gl64_t kC346 = (tmp3_1 + tmp3_2) * (s1_346_1 + s1_346_2);
    gl64_t kD346 = tmp3_0 * s1_346_0;
    gl64_t kE346 = tmp3_1 * s1_346_1;
    gl64_t kF346 = tmp3_2 * s1_346_2;
    gl64_t kG346 = kD346 - kE346;
    tmp3_0 = (kC346 + kG346) - kF346;
    tmp3_1 = ((((kA346 + kC346) - kE346) - kE346) - kD346);
    tmp3_2 = kB346 - kG346;
    // Op 347: dim3x1 add
    gl64_t s1_347 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_347; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 348: dim3x3 mul
    gl64_t s1_348_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_348_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_348_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA348 = (tmp3_0 + tmp3_1) * (s1_348_0 + s1_348_1);
    gl64_t kB348 = (tmp3_0 + tmp3_2) * (s1_348_0 + s1_348_2);
    gl64_t kC348 = (tmp3_1 + tmp3_2) * (s1_348_1 + s1_348_2);
    gl64_t kD348 = tmp3_0 * s1_348_0;
    gl64_t kE348 = tmp3_1 * s1_348_1;
    gl64_t kF348 = tmp3_2 * s1_348_2;
    gl64_t kG348 = kD348 - kE348;
    tmp3_0 = (kC348 + kG348) - kF348;
    tmp3_1 = ((((kA348 + kC348) - kE348) - kE348) - kD348);
    tmp3_2 = kB348 - kG348;
    // Op 349: dim3x1 add
    gl64_t s1_349 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_349; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 350: dim3x3 mul
    gl64_t s1_350_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_350_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_350_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA350 = (tmp3_0 + tmp3_1) * (s1_350_0 + s1_350_1);
    gl64_t kB350 = (tmp3_0 + tmp3_2) * (s1_350_0 + s1_350_2);
    gl64_t kC350 = (tmp3_1 + tmp3_2) * (s1_350_1 + s1_350_2);
    gl64_t kD350 = tmp3_0 * s1_350_0;
    gl64_t kE350 = tmp3_1 * s1_350_1;
    gl64_t kF350 = tmp3_2 * s1_350_2;
    gl64_t kG350 = kD350 - kE350;
    tmp3_0 = (kC350 + kG350) - kF350;
    tmp3_1 = ((((kA350 + kC350) - kE350) - kE350) - kD350);
    tmp3_2 = kB350 - kG350;
    // Op 351: dim3x1 add
    gl64_t s1_351 = *(gl64_t*)&expressions_params[9][21];
    tmp3_0 = tmp3_0 + s1_351; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 352: dim3x3 add
    gl64_t s1_352_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_352_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_352_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_352_0; tmp3_1 = tmp3_1 + s1_352_1; tmp3_2 = tmp3_2 + s1_352_2;
    // Op 353: dim3x3 mul
    uint64_t s0_353_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_353_0 = *(gl64_t*)&dParams->aux_trace[s0_353_pos];
    gl64_t s0_353_1 = *(gl64_t*)&dParams->aux_trace[s0_353_pos + TILE_HEIGHT];
    gl64_t s0_353_2 = *(gl64_t*)&dParams->aux_trace[s0_353_pos + 2*TILE_HEIGHT];
    gl64_t kA353 = (s0_353_0 + s0_353_1) * (tmp3_0 + tmp3_1);
    gl64_t kB353 = (s0_353_0 + s0_353_2) * (tmp3_0 + tmp3_2);
    gl64_t kC353 = (s0_353_1 + s0_353_2) * (tmp3_1 + tmp3_2);
    gl64_t kD353 = s0_353_0 * tmp3_0;
    gl64_t kE353 = s0_353_1 * tmp3_1;
    gl64_t kF353 = s0_353_2 * tmp3_2;
    gl64_t kG353 = kD353 - kE353;
    tmp3_0 = (kC353 + kG353) - kF353;
    tmp3_1 = ((((kA353 + kC353) - kE353) - kE353) - kD353);
    tmp3_2 = kB353 - kG353;
    // Op 354: dim3x1 add
    gl64_t s1_354 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_354; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 355: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 356: dim3x3 mul
    gl64_t s1_356_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_356_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_356_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA356 = (tmp3_0 + tmp3_1) * (s1_356_0 + s1_356_1);
    gl64_t kB356 = (tmp3_0 + tmp3_2) * (s1_356_0 + s1_356_2);
    gl64_t kC356 = (tmp3_1 + tmp3_2) * (s1_356_1 + s1_356_2);
    gl64_t kD356 = tmp3_0 * s1_356_0;
    gl64_t kE356 = tmp3_1 * s1_356_1;
    gl64_t kF356 = tmp3_2 * s1_356_2;
    gl64_t kG356 = kD356 - kE356;
    tmp3_12 = (kC356 + kG356) - kF356;
    tmp3_13 = ((((kA356 + kC356) - kE356) - kE356) - kD356);
    tmp3_14 = kB356 - kG356;
    // Op 357: dim3x1 mul
    gl64_t s0_357_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_357_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_357_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_357 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp3_0 = s0_357_0 * s1_357; tmp3_1 = s0_357_1 * s1_357; tmp3_2 = s0_357_2 * s1_357;
    // Op 358: dim3x1 add
    gl64_t s1_358 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_358; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 359: dim3x3 mul
    gl64_t s1_359_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_359_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_359_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA359 = (tmp3_0 + tmp3_1) * (s1_359_0 + s1_359_1);
    gl64_t kB359 = (tmp3_0 + tmp3_2) * (s1_359_0 + s1_359_2);
    gl64_t kC359 = (tmp3_1 + tmp3_2) * (s1_359_1 + s1_359_2);
    gl64_t kD359 = tmp3_0 * s1_359_0;
    gl64_t kE359 = tmp3_1 * s1_359_1;
    gl64_t kF359 = tmp3_2 * s1_359_2;
    gl64_t kG359 = kD359 - kE359;
    tmp3_0 = (kC359 + kG359) - kF359;
    tmp3_1 = ((((kA359 + kC359) - kE359) - kE359) - kD359);
    tmp3_2 = kB359 - kG359;
    // Op 360: dim1x1 sub
    gl64_t s0_360 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    gl64_t s1_360 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_360 - s1_360;
    // Op 361: dim1x1 mul
    gl64_t s0_361 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_361 * tmp1_0;
    // Op 362: dim1x1 add
    gl64_t s1_362 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = tmp1_0 + s1_362;
    // Op 363: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 364: dim3x3 mul
    gl64_t s1_364_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_364_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_364_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA364 = (tmp3_0 + tmp3_1) * (s1_364_0 + s1_364_1);
    gl64_t kB364 = (tmp3_0 + tmp3_2) * (s1_364_0 + s1_364_2);
    gl64_t kC364 = (tmp3_1 + tmp3_2) * (s1_364_1 + s1_364_2);
    gl64_t kD364 = tmp3_0 * s1_364_0;
    gl64_t kE364 = tmp3_1 * s1_364_1;
    gl64_t kF364 = tmp3_2 * s1_364_2;
    gl64_t kG364 = kD364 - kE364;
    tmp3_0 = (kC364 + kG364) - kF364;
    tmp3_1 = ((((kA364 + kC364) - kE364) - kE364) - kD364);
    tmp3_2 = kB364 - kG364;
    // Op 365: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 366: dim3x3 mul
    gl64_t s1_366_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_366_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_366_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA366 = (tmp3_0 + tmp3_1) * (s1_366_0 + s1_366_1);
    gl64_t kB366 = (tmp3_0 + tmp3_2) * (s1_366_0 + s1_366_2);
    gl64_t kC366 = (tmp3_1 + tmp3_2) * (s1_366_1 + s1_366_2);
    gl64_t kD366 = tmp3_0 * s1_366_0;
    gl64_t kE366 = tmp3_1 * s1_366_1;
    gl64_t kF366 = tmp3_2 * s1_366_2;
    gl64_t kG366 = kD366 - kE366;
    tmp3_0 = (kC366 + kG366) - kF366;
    tmp3_1 = ((((kA366 + kC366) - kE366) - kE366) - kD366);
    tmp3_2 = kB366 - kG366;
    // Op 367: dim3x1 add
    gl64_t s1_367 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_367; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 368: dim3x3 mul
    gl64_t s1_368_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_368_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_368_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA368 = (tmp3_0 + tmp3_1) * (s1_368_0 + s1_368_1);
    gl64_t kB368 = (tmp3_0 + tmp3_2) * (s1_368_0 + s1_368_2);
    gl64_t kC368 = (tmp3_1 + tmp3_2) * (s1_368_1 + s1_368_2);
    gl64_t kD368 = tmp3_0 * s1_368_0;
    gl64_t kE368 = tmp3_1 * s1_368_1;
    gl64_t kF368 = tmp3_2 * s1_368_2;
    gl64_t kG368 = kD368 - kE368;
    tmp3_0 = (kC368 + kG368) - kF368;
    tmp3_1 = ((((kA368 + kC368) - kE368) - kE368) - kD368);
    tmp3_2 = kB368 - kG368;
    // Op 369: dim1x1 add
    gl64_t s0_369 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_369 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_369 + s1_369;
    // Op 370: dim1x1 mul
    gl64_t s0_370 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    gl64_t s1_370 = *(gl64_t*)&expressions_params[9][3];
    tmp1_2 = s0_370 * s1_370;
    // Op 371: dim1x1 add
    tmp1_2 = tmp1_0 + tmp1_2;
    // Op 372: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 373: dim3x3 mul
    gl64_t s1_373_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_373_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_373_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA373 = (tmp3_0 + tmp3_1) * (s1_373_0 + s1_373_1);
    gl64_t kB373 = (tmp3_0 + tmp3_2) * (s1_373_0 + s1_373_2);
    gl64_t kC373 = (tmp3_1 + tmp3_2) * (s1_373_1 + s1_373_2);
    gl64_t kD373 = tmp3_0 * s1_373_0;
    gl64_t kE373 = tmp3_1 * s1_373_1;
    gl64_t kF373 = tmp3_2 * s1_373_2;
    gl64_t kG373 = kD373 - kE373;
    tmp3_0 = (kC373 + kG373) - kF373;
    tmp3_1 = ((((kA373 + kC373) - kE373) - kE373) - kD373);
    tmp3_2 = kB373 - kG373;
    // Op 374: dim3x1 add
    gl64_t s1_374 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_374; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 375: dim3x3 add
    gl64_t s1_375_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_375_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_375_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_375_0; tmp3_1 = tmp3_1 + s1_375_1; tmp3_2 = tmp3_2 + s1_375_2;
    // Op 376: dim3x3 mul
    gl64_t s0_376_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_376_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_376_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    gl64_t kA376 = (s0_376_0 + s0_376_1) * (tmp3_0 + tmp3_1);
    gl64_t kB376 = (s0_376_0 + s0_376_2) * (tmp3_0 + tmp3_2);
    gl64_t kC376 = (s0_376_1 + s0_376_2) * (tmp3_1 + tmp3_2);
    gl64_t kD376 = s0_376_0 * tmp3_0;
    gl64_t kE376 = s0_376_1 * tmp3_1;
    gl64_t kF376 = s0_376_2 * tmp3_2;
    gl64_t kG376 = kD376 - kE376;
    tmp3_0 = (kC376 + kG376) - kF376;
    tmp3_1 = ((((kA376 + kC376) - kE376) - kE376) - kD376);
    tmp3_2 = kB376 - kG376;
    // Op 377: dim1x1 add
    gl64_t s0_377 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    tmp1_0 = s0_377 + tmp1_0;
    // Op 378: dim1x1 sub_swap
    gl64_t s1_378 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_378 - tmp1_0;
    // Op 379: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 380: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 381: dim3x3 mul
    gl64_t s1_381_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_381_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_381_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA381 = (tmp3_0 + tmp3_1) * (s1_381_0 + s1_381_1);
    gl64_t kB381 = (tmp3_0 + tmp3_2) * (s1_381_0 + s1_381_2);
    gl64_t kC381 = (tmp3_1 + tmp3_2) * (s1_381_1 + s1_381_2);
    gl64_t kD381 = tmp3_0 * s1_381_0;
    gl64_t kE381 = tmp3_1 * s1_381_1;
    gl64_t kF381 = tmp3_2 * s1_381_2;
    gl64_t kG381 = kD381 - kE381;
    tmp3_12 = (kC381 + kG381) - kF381;
    tmp3_13 = ((((kA381 + kC381) - kE381) - kE381) - kD381);
    tmp3_14 = kB381 - kG381;
    // Op 382: dim1x1 sub_swap
    gl64_t s0_382 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    gl64_t s1_382 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_382 - s0_382;
    // Op 383: dim1x1 mul
    gl64_t s0_383 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_383 * tmp1_0;
    // Op 384: dim3x1 mul
    gl64_t s0_384_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_384_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_384_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_384_0 * tmp1_0; tmp3_1 = s0_384_1 * tmp1_0; tmp3_2 = s0_384_2 * tmp1_0;
    // Op 385: dim1x1 add
    gl64_t s0_385 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_385 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp1_0 = s0_385 + s1_385;
    // Op 386: dim1x1 sub_swap
    gl64_t s0_386 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = tmp1_0 - s0_386;
    // Op 387: dim1x1 mul
    gl64_t s0_387 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_387 * tmp1_0;
    // Op 388: dim1x1 add
    gl64_t s0_388 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_388 + tmp1_0;
    // Op 389: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 390: dim3x3 mul
    gl64_t s1_390_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_390_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_390_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA390 = (tmp3_0 + tmp3_1) * (s1_390_0 + s1_390_1);
    gl64_t kB390 = (tmp3_0 + tmp3_2) * (s1_390_0 + s1_390_2);
    gl64_t kC390 = (tmp3_1 + tmp3_2) * (s1_390_1 + s1_390_2);
    gl64_t kD390 = tmp3_0 * s1_390_0;
    gl64_t kE390 = tmp3_1 * s1_390_1;
    gl64_t kF390 = tmp3_2 * s1_390_2;
    gl64_t kG390 = kD390 - kE390;
    tmp3_0 = (kC390 + kG390) - kF390;
    tmp3_1 = ((((kA390 + kC390) - kE390) - kE390) - kD390);
    tmp3_2 = kB390 - kG390;
    // Op 391: dim1x1 sub
    gl64_t s0_391 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    gl64_t s1_391 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_391 - s1_391;
    // Op 392: dim1x1 mul
    gl64_t s0_392 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = s0_392 * tmp1_0;
    // Op 393: dim1x1 add
    gl64_t s1_393 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = tmp1_0 + s1_393;
    // Op 394: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 395: dim3x3 mul
    gl64_t s1_395_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_395_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_395_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA395 = (tmp3_0 + tmp3_1) * (s1_395_0 + s1_395_1);
    gl64_t kB395 = (tmp3_0 + tmp3_2) * (s1_395_0 + s1_395_2);
    gl64_t kC395 = (tmp3_1 + tmp3_2) * (s1_395_1 + s1_395_2);
    gl64_t kD395 = tmp3_0 * s1_395_0;
    gl64_t kE395 = tmp3_1 * s1_395_1;
    gl64_t kF395 = tmp3_2 * s1_395_2;
    gl64_t kG395 = kD395 - kE395;
    tmp3_0 = (kC395 + kG395) - kF395;
    tmp3_1 = ((((kA395 + kC395) - kE395) - kE395) - kD395);
    tmp3_2 = kB395 - kG395;
    // Op 396: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_3; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 397: dim3x3 mul
    gl64_t s1_397_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_397_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_397_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA397 = (tmp3_0 + tmp3_1) * (s1_397_0 + s1_397_1);
    gl64_t kB397 = (tmp3_0 + tmp3_2) * (s1_397_0 + s1_397_2);
    gl64_t kC397 = (tmp3_1 + tmp3_2) * (s1_397_1 + s1_397_2);
    gl64_t kD397 = tmp3_0 * s1_397_0;
    gl64_t kE397 = tmp3_1 * s1_397_1;
    gl64_t kF397 = tmp3_2 * s1_397_2;
    gl64_t kG397 = kD397 - kE397;
    tmp3_0 = (kC397 + kG397) - kF397;
    tmp3_1 = ((((kA397 + kC397) - kE397) - kE397) - kD397);
    tmp3_2 = kB397 - kG397;
    // Op 398: dim1x1 mul
    gl64_t s0_398 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_398 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_3 = s0_398 * s1_398;
    // Op 399: dim1x1 add
    gl64_t s0_399 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_3 = s0_399 + tmp1_3;
    // Op 400: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_3; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 401: dim3x3 mul
    gl64_t s1_401_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_401_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_401_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA401 = (tmp3_0 + tmp3_1) * (s1_401_0 + s1_401_1);
    gl64_t kB401 = (tmp3_0 + tmp3_2) * (s1_401_0 + s1_401_2);
    gl64_t kC401 = (tmp3_1 + tmp3_2) * (s1_401_1 + s1_401_2);
    gl64_t kD401 = tmp3_0 * s1_401_0;
    gl64_t kE401 = tmp3_1 * s1_401_1;
    gl64_t kF401 = tmp3_2 * s1_401_2;
    gl64_t kG401 = kD401 - kE401;
    tmp3_0 = (kC401 + kG401) - kF401;
    tmp3_1 = ((((kA401 + kC401) - kE401) - kE401) - kD401);
    tmp3_2 = kB401 - kG401;
    // Op 402: dim1x1 add
    gl64_t s0_402 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_402 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_3 = s0_402 + s1_402;
    // Op 403: dim1x1 mul
    gl64_t s1_403 = *(gl64_t*)&expressions_params[9][8];
    tmp1_3 = tmp1_3 * s1_403;
    // Op 404: dim1x1 mul
    gl64_t s0_404 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    gl64_t s1_404 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_404 * s1_404;
    // Op 405: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_0;
    // Op 406: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 407: dim3x3 mul
    gl64_t s1_407_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_407_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_407_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA407 = (tmp3_0 + tmp3_1) * (s1_407_0 + s1_407_1);
    gl64_t kB407 = (tmp3_0 + tmp3_2) * (s1_407_0 + s1_407_2);
    gl64_t kC407 = (tmp3_1 + tmp3_2) * (s1_407_1 + s1_407_2);
    gl64_t kD407 = tmp3_0 * s1_407_0;
    gl64_t kE407 = tmp3_1 * s1_407_1;
    gl64_t kF407 = tmp3_2 * s1_407_2;
    gl64_t kG407 = kD407 - kE407;
    tmp3_0 = (kC407 + kG407) - kF407;
    tmp3_1 = ((((kA407 + kC407) - kE407) - kE407) - kD407);
    tmp3_2 = kB407 - kG407;
    // Op 408: dim3x1 add
    gl64_t s1_408 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_408; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 409: dim3x3 add
    gl64_t s1_409_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_409_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_409_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_409_0; tmp3_1 = tmp3_1 + s1_409_1; tmp3_2 = tmp3_2 + s1_409_2;
    // Op 410: dim3x3 mul
    gl64_t s0_410_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+0, domainSize, nCols_2))];
    gl64_t s0_410_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+1, domainSize, nCols_2))];
    gl64_t s0_410_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+2, domainSize, nCols_2))];
    gl64_t kA410 = (s0_410_0 + s0_410_1) * (tmp3_0 + tmp3_1);
    gl64_t kB410 = (s0_410_0 + s0_410_2) * (tmp3_0 + tmp3_2);
    gl64_t kC410 = (s0_410_1 + s0_410_2) * (tmp3_1 + tmp3_2);
    gl64_t kD410 = s0_410_0 * tmp3_0;
    gl64_t kE410 = s0_410_1 * tmp3_1;
    gl64_t kF410 = s0_410_2 * tmp3_2;
    gl64_t kG410 = kD410 - kE410;
    tmp3_0 = (kC410 + kG410) - kF410;
    tmp3_1 = ((((kA410 + kC410) - kE410) - kE410) - kD410);
    tmp3_2 = kB410 - kG410;
    // Op 411: dim1x1 add
    gl64_t s0_411 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_411 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = s0_411 + s1_411;
    // Op 412: dim1x1 add
    gl64_t s0_412 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    tmp1_0 = s0_412 + tmp1_0;
    // Op 413: dim1x1 sub_swap
    gl64_t s1_413 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_413 - tmp1_0;
    // Op 414: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 415: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 416: dim3x3 mul
    gl64_t s1_416_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_416_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_416_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA416 = (tmp3_0 + tmp3_1) * (s1_416_0 + s1_416_1);
    gl64_t kB416 = (tmp3_0 + tmp3_2) * (s1_416_0 + s1_416_2);
    gl64_t kC416 = (tmp3_1 + tmp3_2) * (s1_416_1 + s1_416_2);
    gl64_t kD416 = tmp3_0 * s1_416_0;
    gl64_t kE416 = tmp3_1 * s1_416_1;
    gl64_t kF416 = tmp3_2 * s1_416_2;
    gl64_t kG416 = kD416 - kE416;
    tmp3_12 = (kC416 + kG416) - kF416;
    tmp3_13 = ((((kA416 + kC416) - kE416) - kE416) - kD416);
    tmp3_14 = kB416 - kG416;
    // Op 417: dim1x1 mul
    gl64_t s0_417 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_417 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_417 * s1_417;
    // Op 418: dim3x1 mul
    gl64_t s0_418_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_418_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_418_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_418_0 * tmp1_0; tmp3_1 = s0_418_1 * tmp1_0; tmp3_2 = s0_418_2 * tmp1_0;
    // Op 419: dim1x1 mul
    gl64_t s0_419 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_4 = s0_419 * tmp1_4;
    // Op 420: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 421: dim3x3 mul
    gl64_t s1_421_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_421_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_421_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA421 = (tmp3_0 + tmp3_1) * (s1_421_0 + s1_421_1);
    gl64_t kB421 = (tmp3_0 + tmp3_2) * (s1_421_0 + s1_421_2);
    gl64_t kC421 = (tmp3_1 + tmp3_2) * (s1_421_1 + s1_421_2);
    gl64_t kD421 = tmp3_0 * s1_421_0;
    gl64_t kE421 = tmp3_1 * s1_421_1;
    gl64_t kF421 = tmp3_2 * s1_421_2;
    gl64_t kG421 = kD421 - kE421;
    tmp3_0 = (kC421 + kG421) - kF421;
    tmp3_1 = ((((kA421 + kC421) - kE421) - kE421) - kD421);
    tmp3_2 = kB421 - kG421;
    // Op 422: dim3x1 add
    gl64_t s1_422 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_422; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 423: dim3x3 mul
    gl64_t s1_423_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_423_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_423_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA423 = (tmp3_0 + tmp3_1) * (s1_423_0 + s1_423_1);
    gl64_t kB423 = (tmp3_0 + tmp3_2) * (s1_423_0 + s1_423_2);
    gl64_t kC423 = (tmp3_1 + tmp3_2) * (s1_423_1 + s1_423_2);
    gl64_t kD423 = tmp3_0 * s1_423_0;
    gl64_t kE423 = tmp3_1 * s1_423_1;
    gl64_t kF423 = tmp3_2 * s1_423_2;
    gl64_t kG423 = kD423 - kE423;
    tmp3_0 = (kC423 + kG423) - kF423;
    tmp3_1 = ((((kA423 + kC423) - kE423) - kE423) - kD423);
    tmp3_2 = kB423 - kG423;
    // Op 424: dim3x1 add
    gl64_t s1_424 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_424; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 425: dim3x3 mul
    gl64_t s1_425_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_425_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_425_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA425 = (tmp3_0 + tmp3_1) * (s1_425_0 + s1_425_1);
    gl64_t kB425 = (tmp3_0 + tmp3_2) * (s1_425_0 + s1_425_2);
    gl64_t kC425 = (tmp3_1 + tmp3_2) * (s1_425_1 + s1_425_2);
    gl64_t kD425 = tmp3_0 * s1_425_0;
    gl64_t kE425 = tmp3_1 * s1_425_1;
    gl64_t kF425 = tmp3_2 * s1_425_2;
    gl64_t kG425 = kD425 - kE425;
    tmp3_0 = (kC425 + kG425) - kF425;
    tmp3_1 = ((((kA425 + kC425) - kE425) - kE425) - kD425);
    tmp3_2 = kB425 - kG425;
    // Op 426: dim3x1 add
    gl64_t s1_426 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_426; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 427: dim3x3 mul
    gl64_t s1_427_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_427_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_427_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA427 = (tmp3_0 + tmp3_1) * (s1_427_0 + s1_427_1);
    gl64_t kB427 = (tmp3_0 + tmp3_2) * (s1_427_0 + s1_427_2);
    gl64_t kC427 = (tmp3_1 + tmp3_2) * (s1_427_1 + s1_427_2);
    gl64_t kD427 = tmp3_0 * s1_427_0;
    gl64_t kE427 = tmp3_1 * s1_427_1;
    gl64_t kF427 = tmp3_2 * s1_427_2;
    gl64_t kG427 = kD427 - kE427;
    tmp3_0 = (kC427 + kG427) - kF427;
    tmp3_1 = ((((kA427 + kC427) - kE427) - kE427) - kD427);
    tmp3_2 = kB427 - kG427;
    // Op 428: dim1x1 sub_swap
    gl64_t s0_428 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_428 = *(gl64_t*)&expressions_params[9][0];
    tmp1_4 = s1_428 - s0_428;
    // Op 429: dim1x1 mul
    gl64_t s0_429 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_4 = s0_429 * tmp1_4;
    // Op 430: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 431: dim3x3 mul
    gl64_t s1_431_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_431_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_431_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA431 = (tmp3_0 + tmp3_1) * (s1_431_0 + s1_431_1);
    gl64_t kB431 = (tmp3_0 + tmp3_2) * (s1_431_0 + s1_431_2);
    gl64_t kC431 = (tmp3_1 + tmp3_2) * (s1_431_1 + s1_431_2);
    gl64_t kD431 = tmp3_0 * s1_431_0;
    gl64_t kE431 = tmp3_1 * s1_431_1;
    gl64_t kF431 = tmp3_2 * s1_431_2;
    gl64_t kG431 = kD431 - kE431;
    tmp3_0 = (kC431 + kG431) - kF431;
    tmp3_1 = ((((kA431 + kC431) - kE431) - kE431) - kD431);
    tmp3_2 = kB431 - kG431;
    // Op 432: dim3x1 add
    gl64_t s1_432 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_432; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 433: dim3x3 mul
    gl64_t s1_433_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_433_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_433_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA433 = (tmp3_0 + tmp3_1) * (s1_433_0 + s1_433_1);
    gl64_t kB433 = (tmp3_0 + tmp3_2) * (s1_433_0 + s1_433_2);
    gl64_t kC433 = (tmp3_1 + tmp3_2) * (s1_433_1 + s1_433_2);
    gl64_t kD433 = tmp3_0 * s1_433_0;
    gl64_t kE433 = tmp3_1 * s1_433_1;
    gl64_t kF433 = tmp3_2 * s1_433_2;
    gl64_t kG433 = kD433 - kE433;
    tmp3_0 = (kC433 + kG433) - kF433;
    tmp3_1 = ((((kA433 + kC433) - kE433) - kE433) - kD433);
    tmp3_2 = kB433 - kG433;
    // Op 434: dim1x1 sub_swap
    gl64_t s0_434 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_434 = *(gl64_t*)&expressions_params[9][0];
    tmp1_4 = s1_434 - s0_434;
    // Op 435: dim1x1 mul
    gl64_t s0_435 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_4 = s0_435 * tmp1_4;
    // Op 436: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 437: dim3x3 mul
    gl64_t s1_437_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_437_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_437_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA437 = (tmp3_0 + tmp3_1) * (s1_437_0 + s1_437_1);
    gl64_t kB437 = (tmp3_0 + tmp3_2) * (s1_437_0 + s1_437_2);
    gl64_t kC437 = (tmp3_1 + tmp3_2) * (s1_437_1 + s1_437_2);
    gl64_t kD437 = tmp3_0 * s1_437_0;
    gl64_t kE437 = tmp3_1 * s1_437_1;
    gl64_t kF437 = tmp3_2 * s1_437_2;
    gl64_t kG437 = kD437 - kE437;
    tmp3_0 = (kC437 + kG437) - kF437;
    tmp3_1 = ((((kA437 + kC437) - kE437) - kE437) - kD437);
    tmp3_2 = kB437 - kG437;
    // Op 438: dim3x1 add
    gl64_t s1_438 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_438; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 439: dim3x3 mul
    gl64_t s1_439_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_439_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_439_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA439 = (tmp3_0 + tmp3_1) * (s1_439_0 + s1_439_1);
    gl64_t kB439 = (tmp3_0 + tmp3_2) * (s1_439_0 + s1_439_2);
    gl64_t kC439 = (tmp3_1 + tmp3_2) * (s1_439_1 + s1_439_2);
    gl64_t kD439 = tmp3_0 * s1_439_0;
    gl64_t kE439 = tmp3_1 * s1_439_1;
    gl64_t kF439 = tmp3_2 * s1_439_2;
    gl64_t kG439 = kD439 - kE439;
    tmp3_0 = (kC439 + kG439) - kF439;
    tmp3_1 = ((((kA439 + kC439) - kE439) - kE439) - kD439);
    tmp3_2 = kB439 - kG439;
    // Op 440: dim3x1 add
    gl64_t s1_440 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_440; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 441: dim3x3 mul
    gl64_t s1_441_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_441_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_441_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA441 = (tmp3_0 + tmp3_1) * (s1_441_0 + s1_441_1);
    gl64_t kB441 = (tmp3_0 + tmp3_2) * (s1_441_0 + s1_441_2);
    gl64_t kC441 = (tmp3_1 + tmp3_2) * (s1_441_1 + s1_441_2);
    gl64_t kD441 = tmp3_0 * s1_441_0;
    gl64_t kE441 = tmp3_1 * s1_441_1;
    gl64_t kF441 = tmp3_2 * s1_441_2;
    gl64_t kG441 = kD441 - kE441;
    tmp3_0 = (kC441 + kG441) - kF441;
    tmp3_1 = ((((kA441 + kC441) - kE441) - kE441) - kD441);
    tmp3_2 = kB441 - kG441;
    // Op 442: dim3x1 add
    gl64_t s1_442 = *(gl64_t*)&expressions_params[9][22];
    tmp3_0 = tmp3_0 + s1_442; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 443: dim3x3 add
    gl64_t s1_443_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_443_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_443_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_443_0; tmp3_1 = tmp3_1 + s1_443_1; tmp3_2 = tmp3_2 + s1_443_2;
    // Op 444: dim3x3 mul
    uint64_t s0_444_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_2));
    gl64_t s0_444_0 = *(gl64_t*)&dParams->aux_trace[s0_444_pos];
    gl64_t s0_444_1 = *(gl64_t*)&dParams->aux_trace[s0_444_pos + TILE_HEIGHT];
    gl64_t s0_444_2 = *(gl64_t*)&dParams->aux_trace[s0_444_pos + 2*TILE_HEIGHT];
    gl64_t kA444 = (s0_444_0 + s0_444_1) * (tmp3_0 + tmp3_1);
    gl64_t kB444 = (s0_444_0 + s0_444_2) * (tmp3_0 + tmp3_2);
    gl64_t kC444 = (s0_444_1 + s0_444_2) * (tmp3_1 + tmp3_2);
    gl64_t kD444 = s0_444_0 * tmp3_0;
    gl64_t kE444 = s0_444_1 * tmp3_1;
    gl64_t kF444 = s0_444_2 * tmp3_2;
    gl64_t kG444 = kD444 - kE444;
    tmp3_0 = (kC444 + kG444) - kF444;
    tmp3_1 = ((((kA444 + kC444) - kE444) - kE444) - kD444);
    tmp3_2 = kB444 - kG444;
    // Op 445: dim1x1 sub_swap
    gl64_t s0_445 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_445 = *(gl64_t*)&expressions_params[9][1];
    tmp1_4 = s1_445 - s0_445;
    // Op 446: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 447: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 448: dim3x3 mul
    gl64_t s1_448_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_448_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_448_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA448 = (tmp3_0 + tmp3_1) * (s1_448_0 + s1_448_1);
    gl64_t kB448 = (tmp3_0 + tmp3_2) * (s1_448_0 + s1_448_2);
    gl64_t kC448 = (tmp3_1 + tmp3_2) * (s1_448_1 + s1_448_2);
    gl64_t kD448 = tmp3_0 * s1_448_0;
    gl64_t kE448 = tmp3_1 * s1_448_1;
    gl64_t kF448 = tmp3_2 * s1_448_2;
    gl64_t kG448 = kD448 - kE448;
    tmp3_6 = (kC448 + kG448) - kF448;
    tmp3_7 = ((((kA448 + kC448) - kE448) - kE448) - kD448);
    tmp3_8 = kB448 - kG448;
    // Op 449: dim1x1 sub_swap
    gl64_t s0_449 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_0)];
    gl64_t s1_449 = *(gl64_t*)&expressions_params[9][0];
    tmp1_4 = s1_449 - s0_449;
    // Op 450: dim3x1 mul
    uint64_t s0_450_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_450_0 = *(gl64_t*)&dParams->aux_trace[s0_450_pos];
    gl64_t s0_450_1 = *(gl64_t*)&dParams->aux_trace[s0_450_pos + TILE_HEIGHT];
    gl64_t s0_450_2 = *(gl64_t*)&dParams->aux_trace[s0_450_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_450_0 * tmp1_4; tmp3_1 = s0_450_1 * tmp1_4; tmp3_2 = s0_450_2 * tmp1_4;
    // Op 451: dim3x3 sub
    uint64_t s0_451_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_451_0 = *(gl64_t*)&dParams->aux_trace[s0_451_pos];
    gl64_t s0_451_1 = *(gl64_t*)&dParams->aux_trace[s0_451_pos + TILE_HEIGHT];
    gl64_t s0_451_2 = *(gl64_t*)&dParams->aux_trace[s0_451_pos + 2*TILE_HEIGHT];
    tmp3_12 = s0_451_0 - tmp3_0; tmp3_13 = s0_451_1 - tmp3_1; tmp3_14 = s0_451_2 - tmp3_2;
    // Op 452: dim3x3 add
    gl64_t s0_452_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_452_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_452_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_452_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_452_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_452_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_0 = s0_452_0 + s1_452_0; tmp3_1 = s0_452_1 + s1_452_1; tmp3_2 = s0_452_2 + s1_452_2;
    // Op 453: dim3x3 add
    uint64_t s0_453_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_453_0 = *(gl64_t*)&dParams->aux_trace[s0_453_pos];
    gl64_t s0_453_1 = *(gl64_t*)&dParams->aux_trace[s0_453_pos + TILE_HEIGHT];
    gl64_t s0_453_2 = *(gl64_t*)&dParams->aux_trace[s0_453_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_453_0 + tmp3_0; tmp3_1 = s0_453_1 + tmp3_1; tmp3_2 = s0_453_2 + tmp3_2;
    // Op 454: dim3x3 add
    uint64_t s0_454_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_454_0 = *(gl64_t*)&dParams->aux_trace[s0_454_pos];
    gl64_t s0_454_1 = *(gl64_t*)&dParams->aux_trace[s0_454_pos + TILE_HEIGHT];
    gl64_t s0_454_2 = *(gl64_t*)&dParams->aux_trace[s0_454_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_454_0 + tmp3_0; tmp3_1 = s0_454_1 + tmp3_1; tmp3_2 = s0_454_2 + tmp3_2;
    // Op 455: dim3x3 add
    gl64_t s0_455_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_455_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_455_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    tmp3_0 = s0_455_0 + tmp3_0; tmp3_1 = s0_455_1 + tmp3_1; tmp3_2 = s0_455_2 + tmp3_2;
    // Op 456: dim3x3 add
    gl64_t s0_456_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+0, domainSize, nCols_2))];
    gl64_t s0_456_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+1, domainSize, nCols_2))];
    gl64_t s0_456_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+2, domainSize, nCols_2))];
    tmp3_0 = s0_456_0 + tmp3_0; tmp3_1 = s0_456_1 + tmp3_1; tmp3_2 = s0_456_2 + tmp3_2;
    // Op 457: dim3x3 add
    uint64_t s0_457_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_2));
    gl64_t s0_457_0 = *(gl64_t*)&dParams->aux_trace[s0_457_pos];
    gl64_t s0_457_1 = *(gl64_t*)&dParams->aux_trace[s0_457_pos + TILE_HEIGHT];
    gl64_t s0_457_2 = *(gl64_t*)&dParams->aux_trace[s0_457_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_457_0 + tmp3_0; tmp3_1 = s0_457_1 + tmp3_1; tmp3_2 = s0_457_2 + tmp3_2;
    // Op 458: dim3x3 sub
    tmp3_12 = tmp3_12 - tmp3_0; tmp3_13 = tmp3_13 - tmp3_1; tmp3_14 = tmp3_14 - tmp3_2;
    // Op 459: dim3x1 mul
    gl64_t s0_459_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_459_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_459_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_459 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp3_0 = s0_459_0 * s1_459; tmp3_1 = s0_459_1 * s1_459; tmp3_2 = s0_459_2 * s1_459;
    // Op 460: dim3x1 add
    gl64_t s1_460 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_460; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 461: dim3x3 mul
    gl64_t s1_461_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_461_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_461_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA461 = (tmp3_0 + tmp3_1) * (s1_461_0 + s1_461_1);
    gl64_t kB461 = (tmp3_0 + tmp3_2) * (s1_461_0 + s1_461_2);
    gl64_t kC461 = (tmp3_1 + tmp3_2) * (s1_461_1 + s1_461_2);
    gl64_t kD461 = tmp3_0 * s1_461_0;
    gl64_t kE461 = tmp3_1 * s1_461_1;
    gl64_t kF461 = tmp3_2 * s1_461_2;
    gl64_t kG461 = kD461 - kE461;
    tmp3_0 = (kC461 + kG461) - kF461;
    tmp3_1 = ((((kA461 + kC461) - kE461) - kE461) - kD461);
    tmp3_2 = kB461 - kG461;
    // Op 462: dim3x1 add
    gl64_t s1_462 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_462; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 463: dim3x3 mul
    gl64_t s1_463_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_463_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_463_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA463 = (tmp3_0 + tmp3_1) * (s1_463_0 + s1_463_1);
    gl64_t kB463 = (tmp3_0 + tmp3_2) * (s1_463_0 + s1_463_2);
    gl64_t kC463 = (tmp3_1 + tmp3_2) * (s1_463_1 + s1_463_2);
    gl64_t kD463 = tmp3_0 * s1_463_0;
    gl64_t kE463 = tmp3_1 * s1_463_1;
    gl64_t kF463 = tmp3_2 * s1_463_2;
    gl64_t kG463 = kD463 - kE463;
    tmp3_0 = (kC463 + kG463) - kF463;
    tmp3_1 = ((((kA463 + kC463) - kE463) - kE463) - kD463);
    tmp3_2 = kB463 - kG463;
    // Op 464: dim3x1 add
    gl64_t s1_464 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_464; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 465: dim3x3 mul
    gl64_t s1_465_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_465_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_465_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA465 = (tmp3_0 + tmp3_1) * (s1_465_0 + s1_465_1);
    gl64_t kB465 = (tmp3_0 + tmp3_2) * (s1_465_0 + s1_465_2);
    gl64_t kC465 = (tmp3_1 + tmp3_2) * (s1_465_1 + s1_465_2);
    gl64_t kD465 = tmp3_0 * s1_465_0;
    gl64_t kE465 = tmp3_1 * s1_465_1;
    gl64_t kF465 = tmp3_2 * s1_465_2;
    gl64_t kG465 = kD465 - kE465;
    tmp3_0 = (kC465 + kG465) - kF465;
    tmp3_1 = ((((kA465 + kC465) - kE465) - kE465) - kD465);
    tmp3_2 = kB465 - kG465;
    // Op 466: dim3x1 add
    gl64_t s1_466 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_466; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 467: dim3x3 mul
    gl64_t s1_467_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_467_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_467_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA467 = (tmp3_0 + tmp3_1) * (s1_467_0 + s1_467_1);
    gl64_t kB467 = (tmp3_0 + tmp3_2) * (s1_467_0 + s1_467_2);
    gl64_t kC467 = (tmp3_1 + tmp3_2) * (s1_467_1 + s1_467_2);
    gl64_t kD467 = tmp3_0 * s1_467_0;
    gl64_t kE467 = tmp3_1 * s1_467_1;
    gl64_t kF467 = tmp3_2 * s1_467_2;
    gl64_t kG467 = kD467 - kE467;
    tmp3_0 = (kC467 + kG467) - kF467;
    tmp3_1 = ((((kA467 + kC467) - kE467) - kE467) - kD467);
    tmp3_2 = kB467 - kG467;
    // Op 468: dim3x1 add
    gl64_t s1_468 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_468; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 469: dim3x3 mul
    gl64_t s1_469_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_469_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_469_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA469 = (tmp3_0 + tmp3_1) * (s1_469_0 + s1_469_1);
    gl64_t kB469 = (tmp3_0 + tmp3_2) * (s1_469_0 + s1_469_2);
    gl64_t kC469 = (tmp3_1 + tmp3_2) * (s1_469_1 + s1_469_2);
    gl64_t kD469 = tmp3_0 * s1_469_0;
    gl64_t kE469 = tmp3_1 * s1_469_1;
    gl64_t kF469 = tmp3_2 * s1_469_2;
    gl64_t kG469 = kD469 - kE469;
    tmp3_0 = (kC469 + kG469) - kF469;
    tmp3_1 = ((((kA469 + kC469) - kE469) - kE469) - kD469);
    tmp3_2 = kB469 - kG469;
    // Op 470: dim3x1 add
    gl64_t s1_470 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_470; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 471: dim3x3 add
    gl64_t s1_471_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_471_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_471_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_471_0; tmp3_1 = tmp3_1 + s1_471_1; tmp3_2 = tmp3_2 + s1_471_2;
    // Op 472: dim3x3 mul
    gl64_t kA472 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB472 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC472 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD472 = tmp3_12 * tmp3_0;
    gl64_t kE472 = tmp3_13 * tmp3_1;
    gl64_t kF472 = tmp3_14 * tmp3_2;
    gl64_t kG472 = kD472 - kE472;
    tmp3_0 = (kC472 + kG472) - kF472;
    tmp3_1 = ((((kA472 + kC472) - kE472) - kE472) - kD472);
    tmp3_2 = kB472 - kG472;
    // Op 473: dim3x1 sub
    gl64_t s1_473 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 - s1_473; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 474: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 475: dim3x3 mul
    gl64_t s1_475_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_475_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_475_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA475 = (tmp3_0 + tmp3_1) * (s1_475_0 + s1_475_1);
    gl64_t kB475 = (tmp3_0 + tmp3_2) * (s1_475_0 + s1_475_2);
    gl64_t kC475 = (tmp3_1 + tmp3_2) * (s1_475_1 + s1_475_2);
    gl64_t kD475 = tmp3_0 * s1_475_0;
    gl64_t kE475 = tmp3_1 * s1_475_1;
    gl64_t kF475 = tmp3_2 * s1_475_2;
    gl64_t kG475 = kD475 - kE475;
    tmp3_6 = (kC475 + kG475) - kF475;
    tmp3_7 = ((((kA475 + kC475) - kE475) - kE475) - kD475);
    tmp3_8 = kB475 - kG475;
    // Op 476: dim3x1 mul
    gl64_t s0_476_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_476_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_476_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_476 = *(gl64_t*)&expressions_params[10][4];
    tmp3_0 = s0_476_0 * s1_476; tmp3_1 = s0_476_1 * s1_476; tmp3_2 = s0_476_2 * s1_476;
    // Op 477: dim3x1 add
    gl64_t s1_477 = *(gl64_t*)&expressions_params[10][3];
    tmp3_0 = tmp3_0 + s1_477; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 478: dim3x3 mul
    gl64_t s1_478_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_478_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_478_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA478 = (tmp3_0 + tmp3_1) * (s1_478_0 + s1_478_1);
    gl64_t kB478 = (tmp3_0 + tmp3_2) * (s1_478_0 + s1_478_2);
    gl64_t kC478 = (tmp3_1 + tmp3_2) * (s1_478_1 + s1_478_2);
    gl64_t kD478 = tmp3_0 * s1_478_0;
    gl64_t kE478 = tmp3_1 * s1_478_1;
    gl64_t kF478 = tmp3_2 * s1_478_2;
    gl64_t kG478 = kD478 - kE478;
    tmp3_0 = (kC478 + kG478) - kF478;
    tmp3_1 = ((((kA478 + kC478) - kE478) - kE478) - kD478);
    tmp3_2 = kB478 - kG478;
    // Op 479: dim3x1 add
    gl64_t s1_479 = *(gl64_t*)&expressions_params[10][2];
    tmp3_0 = tmp3_0 + s1_479; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 480: dim3x3 mul
    gl64_t s1_480_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_480_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_480_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA480 = (tmp3_0 + tmp3_1) * (s1_480_0 + s1_480_1);
    gl64_t kB480 = (tmp3_0 + tmp3_2) * (s1_480_0 + s1_480_2);
    gl64_t kC480 = (tmp3_1 + tmp3_2) * (s1_480_1 + s1_480_2);
    gl64_t kD480 = tmp3_0 * s1_480_0;
    gl64_t kE480 = tmp3_1 * s1_480_1;
    gl64_t kF480 = tmp3_2 * s1_480_2;
    gl64_t kG480 = kD480 - kE480;
    tmp3_0 = (kC480 + kG480) - kF480;
    tmp3_1 = ((((kA480 + kC480) - kE480) - kE480) - kD480);
    tmp3_2 = kB480 - kG480;
    // Op 481: dim3x3 mul
    gl64_t s1_481_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_481_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_481_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA481 = (tmp3_0 + tmp3_1) * (s1_481_0 + s1_481_1);
    gl64_t kB481 = (tmp3_0 + tmp3_2) * (s1_481_0 + s1_481_2);
    gl64_t kC481 = (tmp3_1 + tmp3_2) * (s1_481_1 + s1_481_2);
    gl64_t kD481 = tmp3_0 * s1_481_0;
    gl64_t kE481 = tmp3_1 * s1_481_1;
    gl64_t kF481 = tmp3_2 * s1_481_2;
    gl64_t kG481 = kD481 - kE481;
    tmp3_0 = (kC481 + kG481) - kF481;
    tmp3_1 = ((((kA481 + kC481) - kE481) - kE481) - kD481);
    tmp3_2 = kB481 - kG481;
    // Op 482: dim3x1 add
    gl64_t s1_482 = *(gl64_t*)&expressions_params[10][1];
    tmp3_0 = tmp3_0 + s1_482; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 483: dim3x3 mul
    gl64_t s1_483_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_483_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_483_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA483 = (tmp3_0 + tmp3_1) * (s1_483_0 + s1_483_1);
    gl64_t kB483 = (tmp3_0 + tmp3_2) * (s1_483_0 + s1_483_2);
    gl64_t kC483 = (tmp3_1 + tmp3_2) * (s1_483_1 + s1_483_2);
    gl64_t kD483 = tmp3_0 * s1_483_0;
    gl64_t kE483 = tmp3_1 * s1_483_1;
    gl64_t kF483 = tmp3_2 * s1_483_2;
    gl64_t kG483 = kD483 - kE483;
    tmp3_0 = (kC483 + kG483) - kF483;
    tmp3_1 = ((((kA483 + kC483) - kE483) - kE483) - kD483);
    tmp3_2 = kB483 - kG483;
    // Op 484: dim3x1 add
    gl64_t s1_484 = *(gl64_t*)&expressions_params[9][23];
    tmp3_0 = tmp3_0 + s1_484; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 485: dim3x3 add
    gl64_t s1_485_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_485_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_485_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_485_0; tmp3_1 = tmp3_1 + s1_485_1; tmp3_2 = tmp3_2 + s1_485_2;
    // Op 486: dim3x3 mul
    gl64_t s1_486_0 = *(gl64_t*)&expressions_params[10][101];
    gl64_t s1_486_1 = *(gl64_t*)&expressions_params[10][101+1];
    gl64_t s1_486_2 = *(gl64_t*)&expressions_params[10][101+2];
    gl64_t kA486 = (tmp3_0 + tmp3_1) * (s1_486_0 + s1_486_1);
    gl64_t kB486 = (tmp3_0 + tmp3_2) * (s1_486_0 + s1_486_2);
    gl64_t kC486 = (tmp3_1 + tmp3_2) * (s1_486_1 + s1_486_2);
    gl64_t kD486 = tmp3_0 * s1_486_0;
    gl64_t kE486 = tmp3_1 * s1_486_1;
    gl64_t kF486 = tmp3_2 * s1_486_2;
    gl64_t kG486 = kD486 - kE486;
    tmp3_0 = (kC486 + kG486) - kF486;
    tmp3_1 = ((((kA486 + kC486) - kE486) - kE486) - kD486);
    tmp3_2 = kB486 - kG486;
    // Op 487: dim3x1 add
    gl64_t s1_487 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_487; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 488: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 489: dim3x3 mul
    gl64_t s1_489_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_489_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_489_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA489 = (tmp3_0 + tmp3_1) * (s1_489_0 + s1_489_1);
    gl64_t kB489 = (tmp3_0 + tmp3_2) * (s1_489_0 + s1_489_2);
    gl64_t kC489 = (tmp3_1 + tmp3_2) * (s1_489_1 + s1_489_2);
    gl64_t kD489 = tmp3_0 * s1_489_0;
    gl64_t kE489 = tmp3_1 * s1_489_1;
    gl64_t kF489 = tmp3_2 * s1_489_2;
    gl64_t kG489 = kD489 - kE489;
    tmp3_6 = (kC489 + kG489) - kF489;
    tmp3_7 = ((((kA489 + kC489) - kE489) - kE489) - kD489);
    tmp3_8 = kB489 - kG489;
    // Op 490: dim3x1 mul
    gl64_t s0_490_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_490_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_490_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_490 = *(gl64_t*)&expressions_params[10][7];
    tmp3_0 = s0_490_0 * s1_490; tmp3_1 = s0_490_1 * s1_490; tmp3_2 = s0_490_2 * s1_490;
    // Op 491: dim3x1 add
    gl64_t s1_491 = *(gl64_t*)&expressions_params[10][6];
    tmp3_0 = tmp3_0 + s1_491; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 492: dim3x3 mul
    gl64_t s1_492_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_492_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_492_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA492 = (tmp3_0 + tmp3_1) * (s1_492_0 + s1_492_1);
    gl64_t kB492 = (tmp3_0 + tmp3_2) * (s1_492_0 + s1_492_2);
    gl64_t kC492 = (tmp3_1 + tmp3_2) * (s1_492_1 + s1_492_2);
    gl64_t kD492 = tmp3_0 * s1_492_0;
    gl64_t kE492 = tmp3_1 * s1_492_1;
    gl64_t kF492 = tmp3_2 * s1_492_2;
    gl64_t kG492 = kD492 - kE492;
    tmp3_0 = (kC492 + kG492) - kF492;
    tmp3_1 = ((((kA492 + kC492) - kE492) - kE492) - kD492);
    tmp3_2 = kB492 - kG492;
    // Op 493: dim3x1 add
    gl64_t s1_493 = *(gl64_t*)&expressions_params[10][5];
    tmp3_0 = tmp3_0 + s1_493; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 494: dim3x3 mul
    gl64_t s1_494_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_494_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_494_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA494 = (tmp3_0 + tmp3_1) * (s1_494_0 + s1_494_1);
    gl64_t kB494 = (tmp3_0 + tmp3_2) * (s1_494_0 + s1_494_2);
    gl64_t kC494 = (tmp3_1 + tmp3_2) * (s1_494_1 + s1_494_2);
    gl64_t kD494 = tmp3_0 * s1_494_0;
    gl64_t kE494 = tmp3_1 * s1_494_1;
    gl64_t kF494 = tmp3_2 * s1_494_2;
    gl64_t kG494 = kD494 - kE494;
    tmp3_0 = (kC494 + kG494) - kF494;
    tmp3_1 = ((((kA494 + kC494) - kE494) - kE494) - kD494);
    tmp3_2 = kB494 - kG494;
    // Op 495: dim3x1 add
    gl64_t s1_495 = *(gl64_t*)&expressions_params[10][0];
    tmp3_0 = tmp3_0 + s1_495; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 496: dim3x3 mul
    gl64_t s1_496_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_496_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_496_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA496 = (tmp3_0 + tmp3_1) * (s1_496_0 + s1_496_1);
    gl64_t kB496 = (tmp3_0 + tmp3_2) * (s1_496_0 + s1_496_2);
    gl64_t kC496 = (tmp3_1 + tmp3_2) * (s1_496_1 + s1_496_2);
    gl64_t kD496 = tmp3_0 * s1_496_0;
    gl64_t kE496 = tmp3_1 * s1_496_1;
    gl64_t kF496 = tmp3_2 * s1_496_2;
    gl64_t kG496 = kD496 - kE496;
    tmp3_0 = (kC496 + kG496) - kF496;
    tmp3_1 = ((((kA496 + kC496) - kE496) - kE496) - kD496);
    tmp3_2 = kB496 - kG496;
    // Op 497: dim1x1 add
    gl64_t s0_497 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_497 = *(gl64_t*)&expressions_params[10][1];
    tmp1_4 = s0_497 + s1_497;
    // Op 498: dim1x1 sub
    gl64_t s0_498 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_498 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_498 - s1_498;
    // Op 499: dim1x1 mul
    tmp1_0 = tmp1_4 * tmp1_0;
    // Op 500: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 501: dim3x3 mul
    gl64_t s1_501_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_501_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_501_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA501 = (tmp3_0 + tmp3_1) * (s1_501_0 + s1_501_1);
    gl64_t kB501 = (tmp3_0 + tmp3_2) * (s1_501_0 + s1_501_2);
    gl64_t kC501 = (tmp3_1 + tmp3_2) * (s1_501_1 + s1_501_2);
    gl64_t kD501 = tmp3_0 * s1_501_0;
    gl64_t kE501 = tmp3_1 * s1_501_1;
    gl64_t kF501 = tmp3_2 * s1_501_2;
    gl64_t kG501 = kD501 - kE501;
    tmp3_0 = (kC501 + kG501) - kF501;
    tmp3_1 = ((((kA501 + kC501) - kE501) - kE501) - kD501);
    tmp3_2 = kB501 - kG501;
    // Op 502: dim3x1 add
    gl64_t s1_502 = *(gl64_t*)&expressions_params[9][23];
    tmp3_0 = tmp3_0 + s1_502; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 503: dim3x3 add
    gl64_t s1_503_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_503_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_503_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_503_0; tmp3_1 = tmp3_1 + s1_503_1; tmp3_2 = tmp3_2 + s1_503_2;
    // Op 504: dim3x3 mul
    gl64_t s1_504_0 = *(gl64_t*)&expressions_params[10][104];
    gl64_t s1_504_1 = *(gl64_t*)&expressions_params[10][104+1];
    gl64_t s1_504_2 = *(gl64_t*)&expressions_params[10][104+2];
    gl64_t kA504 = (tmp3_0 + tmp3_1) * (s1_504_0 + s1_504_1);
    gl64_t kB504 = (tmp3_0 + tmp3_2) * (s1_504_0 + s1_504_2);
    gl64_t kC504 = (tmp3_1 + tmp3_2) * (s1_504_1 + s1_504_2);
    gl64_t kD504 = tmp3_0 * s1_504_0;
    gl64_t kE504 = tmp3_1 * s1_504_1;
    gl64_t kF504 = tmp3_2 * s1_504_2;
    gl64_t kG504 = kD504 - kE504;
    tmp3_0 = (kC504 + kG504) - kF504;
    tmp3_1 = ((((kA504 + kC504) - kE504) - kE504) - kD504);
    tmp3_2 = kB504 - kG504;
    // Op 505: dim3x1 sub
    gl64_t s1_505 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_505; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 506: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 507: dim3x3 mul
    gl64_t s1_507_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_507_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_507_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA507 = (tmp3_0 + tmp3_1) * (s1_507_0 + s1_507_1);
    gl64_t kB507 = (tmp3_0 + tmp3_2) * (s1_507_0 + s1_507_2);
    gl64_t kC507 = (tmp3_1 + tmp3_2) * (s1_507_1 + s1_507_2);
    gl64_t kD507 = tmp3_0 * s1_507_0;
    gl64_t kE507 = tmp3_1 * s1_507_1;
    gl64_t kF507 = tmp3_2 * s1_507_2;
    gl64_t kG507 = kD507 - kE507;
    tmp3_6 = (kC507 + kG507) - kF507;
    tmp3_7 = ((((kA507 + kC507) - kE507) - kE507) - kD507);
    tmp3_8 = kB507 - kG507;
    // Op 508: dim1x1 add
    gl64_t s0_508 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_508 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_508 + s1_508;
    // Op 509: dim1x1 mul
    gl64_t s1_509 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = tmp1_0 * s1_509;
    // Op 510: dim1x1 sub
    gl64_t s1_510 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_510;
    // Op 511: dim1x1 mul
    gl64_t s1_511 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = tmp1_0 * s1_511;
    // Op 512: dim1x1 add
    gl64_t s1_512 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_512;
    // Op 513: dim1x1 add
    gl64_t s1_513 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = tmp1_0 + s1_513;
    // Op 514: dim1x1 sub
    gl64_t s1_514 = *(gl64_t*)&expressions_params[9][0];
    tmp1_4 = tmp1_0 - s1_514;
    // Op 515: dim1x1 sub
    gl64_t s1_515 = *(gl64_t*)&expressions_params[10][70];
    tmp1_0 = tmp1_4 - s1_515;
    // Op 516: dim1x1 sub
    gl64_t s1_516 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_516;
    // Op 517: dim3x1 mul
    gl64_t s0_517_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_517_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_517_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_517_0 * tmp1_0; tmp3_1 = s0_517_1 * tmp1_0; tmp3_2 = s0_517_2 * tmp1_0;
    // Op 518: dim3x1 add
    gl64_t s1_518 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_518; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 519: dim3x3 add
    gl64_t s1_519_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_519_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_519_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_519_0; tmp3_1 = tmp3_1 + s1_519_1; tmp3_2 = tmp3_2 + s1_519_2;
    // Op 520: dim3x3 mul
    gl64_t s1_520_0 = *(gl64_t*)&expressions_params[10][107];
    gl64_t s1_520_1 = *(gl64_t*)&expressions_params[10][107+1];
    gl64_t s1_520_2 = *(gl64_t*)&expressions_params[10][107+2];
    gl64_t kA520 = (tmp3_0 + tmp3_1) * (s1_520_0 + s1_520_1);
    gl64_t kB520 = (tmp3_0 + tmp3_2) * (s1_520_0 + s1_520_2);
    gl64_t kC520 = (tmp3_1 + tmp3_2) * (s1_520_1 + s1_520_2);
    gl64_t kD520 = tmp3_0 * s1_520_0;
    gl64_t kE520 = tmp3_1 * s1_520_1;
    gl64_t kF520 = tmp3_2 * s1_520_2;
    gl64_t kG520 = kD520 - kE520;
    tmp3_0 = (kC520 + kG520) - kF520;
    tmp3_1 = ((((kA520 + kC520) - kE520) - kE520) - kD520);
    tmp3_2 = kB520 - kG520;
    // Op 521: dim3x1 add
    gl64_t s1_521 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_521; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 522: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 523: dim3x3 mul
    gl64_t s1_523_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_523_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_523_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA523 = (tmp3_0 + tmp3_1) * (s1_523_0 + s1_523_1);
    gl64_t kB523 = (tmp3_0 + tmp3_2) * (s1_523_0 + s1_523_2);
    gl64_t kC523 = (tmp3_1 + tmp3_2) * (s1_523_1 + s1_523_2);
    gl64_t kD523 = tmp3_0 * s1_523_0;
    gl64_t kE523 = tmp3_1 * s1_523_1;
    gl64_t kF523 = tmp3_2 * s1_523_2;
    gl64_t kG523 = kD523 - kE523;
    tmp3_6 = (kC523 + kG523) - kF523;
    tmp3_7 = ((((kA523 + kC523) - kE523) - kE523) - kD523);
    tmp3_8 = kB523 - kG523;
    // Op 524: dim3x1 mul
    gl64_t s0_524_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_524_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_524_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_524 = *(gl64_t*)&expressions_params[10][9];
    tmp3_0 = s0_524_0 * s1_524; tmp3_1 = s0_524_1 * s1_524; tmp3_2 = s0_524_2 * s1_524;
    // Op 525: dim3x1 add
    gl64_t s1_525 = *(gl64_t*)&expressions_params[10][8];
    tmp3_0 = tmp3_0 + s1_525; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 526: dim3x3 mul
    gl64_t s1_526_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_526_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_526_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA526 = (tmp3_0 + tmp3_1) * (s1_526_0 + s1_526_1);
    gl64_t kB526 = (tmp3_0 + tmp3_2) * (s1_526_0 + s1_526_2);
    gl64_t kC526 = (tmp3_1 + tmp3_2) * (s1_526_1 + s1_526_2);
    gl64_t kD526 = tmp3_0 * s1_526_0;
    gl64_t kE526 = tmp3_1 * s1_526_1;
    gl64_t kF526 = tmp3_2 * s1_526_2;
    gl64_t kG526 = kD526 - kE526;
    tmp3_0 = (kC526 + kG526) - kF526;
    tmp3_1 = ((((kA526 + kC526) - kE526) - kE526) - kD526);
    tmp3_2 = kB526 - kG526;
    // Op 527: dim3x1 add
    gl64_t s1_527 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_527; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 528: dim3x3 mul
    gl64_t s1_528_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_528_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_528_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA528 = (tmp3_0 + tmp3_1) * (s1_528_0 + s1_528_1);
    gl64_t kB528 = (tmp3_0 + tmp3_2) * (s1_528_0 + s1_528_2);
    gl64_t kC528 = (tmp3_1 + tmp3_2) * (s1_528_1 + s1_528_2);
    gl64_t kD528 = tmp3_0 * s1_528_0;
    gl64_t kE528 = tmp3_1 * s1_528_1;
    gl64_t kF528 = tmp3_2 * s1_528_2;
    gl64_t kG528 = kD528 - kE528;
    tmp3_0 = (kC528 + kG528) - kF528;
    tmp3_1 = ((((kA528 + kC528) - kE528) - kE528) - kD528);
    tmp3_2 = kB528 - kG528;
    // Op 529: dim3x1 add
    gl64_t s1_529 = *(gl64_t*)&expressions_params[10][70];
    tmp3_0 = tmp3_0 + s1_529; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 530: dim3x3 mul
    gl64_t s1_530_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_530_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_530_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA530 = (tmp3_0 + tmp3_1) * (s1_530_0 + s1_530_1);
    gl64_t kB530 = (tmp3_0 + tmp3_2) * (s1_530_0 + s1_530_2);
    gl64_t kC530 = (tmp3_1 + tmp3_2) * (s1_530_1 + s1_530_2);
    gl64_t kD530 = tmp3_0 * s1_530_0;
    gl64_t kE530 = tmp3_1 * s1_530_1;
    gl64_t kF530 = tmp3_2 * s1_530_2;
    gl64_t kG530 = kD530 - kE530;
    tmp3_0 = (kC530 + kG530) - kF530;
    tmp3_1 = ((((kA530 + kC530) - kE530) - kE530) - kD530);
    tmp3_2 = kB530 - kG530;
    // Op 531: dim3x1 add
    gl64_t s1_531 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_531; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 532: dim3x3 mul
    gl64_t s1_532_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_532_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_532_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA532 = (tmp3_0 + tmp3_1) * (s1_532_0 + s1_532_1);
    gl64_t kB532 = (tmp3_0 + tmp3_2) * (s1_532_0 + s1_532_2);
    gl64_t kC532 = (tmp3_1 + tmp3_2) * (s1_532_1 + s1_532_2);
    gl64_t kD532 = tmp3_0 * s1_532_0;
    gl64_t kE532 = tmp3_1 * s1_532_1;
    gl64_t kF532 = tmp3_2 * s1_532_2;
    gl64_t kG532 = kD532 - kE532;
    tmp3_0 = (kC532 + kG532) - kF532;
    tmp3_1 = ((((kA532 + kC532) - kE532) - kE532) - kD532);
    tmp3_2 = kB532 - kG532;
    // Op 533: dim3x1 add
    gl64_t s1_533 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_533; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 534: dim3x3 mul
    gl64_t s1_534_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_534_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_534_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA534 = (tmp3_0 + tmp3_1) * (s1_534_0 + s1_534_1);
    gl64_t kB534 = (tmp3_0 + tmp3_2) * (s1_534_0 + s1_534_2);
    gl64_t kC534 = (tmp3_1 + tmp3_2) * (s1_534_1 + s1_534_2);
    gl64_t kD534 = tmp3_0 * s1_534_0;
    gl64_t kE534 = tmp3_1 * s1_534_1;
    gl64_t kF534 = tmp3_2 * s1_534_2;
    gl64_t kG534 = kD534 - kE534;
    tmp3_0 = (kC534 + kG534) - kF534;
    tmp3_1 = ((((kA534 + kC534) - kE534) - kE534) - kD534);
    tmp3_2 = kB534 - kG534;
    // Op 535: dim3x1 add
    gl64_t s1_535 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_535; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 536: dim3x3 add
    gl64_t s1_536_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_536_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_536_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_536_0; tmp3_1 = tmp3_1 + s1_536_1; tmp3_2 = tmp3_2 + s1_536_2;
    // Op 537: dim3x3 mul
    gl64_t s1_537_0 = *(gl64_t*)&expressions_params[10][110];
    gl64_t s1_537_1 = *(gl64_t*)&expressions_params[10][110+1];
    gl64_t s1_537_2 = *(gl64_t*)&expressions_params[10][110+2];
    gl64_t kA537 = (tmp3_0 + tmp3_1) * (s1_537_0 + s1_537_1);
    gl64_t kB537 = (tmp3_0 + tmp3_2) * (s1_537_0 + s1_537_2);
    gl64_t kC537 = (tmp3_1 + tmp3_2) * (s1_537_1 + s1_537_2);
    gl64_t kD537 = tmp3_0 * s1_537_0;
    gl64_t kE537 = tmp3_1 * s1_537_1;
    gl64_t kF537 = tmp3_2 * s1_537_2;
    gl64_t kG537 = kD537 - kE537;
    tmp3_0 = (kC537 + kG537) - kF537;
    tmp3_1 = ((((kA537 + kC537) - kE537) - kE537) - kD537);
    tmp3_2 = kB537 - kG537;
    // Op 538: dim3x1 sub
    gl64_t s1_538 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_538; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 539: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 540: dim3x3 mul
    gl64_t s1_540_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_540_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_540_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA540 = (tmp3_0 + tmp3_1) * (s1_540_0 + s1_540_1);
    gl64_t kB540 = (tmp3_0 + tmp3_2) * (s1_540_0 + s1_540_2);
    gl64_t kC540 = (tmp3_1 + tmp3_2) * (s1_540_1 + s1_540_2);
    gl64_t kD540 = tmp3_0 * s1_540_0;
    gl64_t kE540 = tmp3_1 * s1_540_1;
    gl64_t kF540 = tmp3_2 * s1_540_2;
    gl64_t kG540 = kD540 - kE540;
    tmp3_6 = (kC540 + kG540) - kF540;
    tmp3_7 = ((((kA540 + kC540) - kE540) - kE540) - kD540);
    tmp3_8 = kB540 - kG540;
    // Op 541: dim3x1 mul
    gl64_t s0_541_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_541_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_541_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_541 = *(gl64_t*)&expressions_params[10][9];
    tmp3_0 = s0_541_0 * s1_541; tmp3_1 = s0_541_1 * s1_541; tmp3_2 = s0_541_2 * s1_541;
    // Op 542: dim3x1 add
    gl64_t s1_542 = *(gl64_t*)&expressions_params[10][8];
    tmp3_0 = tmp3_0 + s1_542; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 543: dim3x3 mul
    gl64_t s1_543_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_543_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_543_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA543 = (tmp3_0 + tmp3_1) * (s1_543_0 + s1_543_1);
    gl64_t kB543 = (tmp3_0 + tmp3_2) * (s1_543_0 + s1_543_2);
    gl64_t kC543 = (tmp3_1 + tmp3_2) * (s1_543_1 + s1_543_2);
    gl64_t kD543 = tmp3_0 * s1_543_0;
    gl64_t kE543 = tmp3_1 * s1_543_1;
    gl64_t kF543 = tmp3_2 * s1_543_2;
    gl64_t kG543 = kD543 - kE543;
    tmp3_0 = (kC543 + kG543) - kF543;
    tmp3_1 = ((((kA543 + kC543) - kE543) - kE543) - kD543);
    tmp3_2 = kB543 - kG543;
    // Op 544: dim3x1 add
    gl64_t s1_544 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_544; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 545: dim3x3 mul
    gl64_t s1_545_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_545_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_545_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA545 = (tmp3_0 + tmp3_1) * (s1_545_0 + s1_545_1);
    gl64_t kB545 = (tmp3_0 + tmp3_2) * (s1_545_0 + s1_545_2);
    gl64_t kC545 = (tmp3_1 + tmp3_2) * (s1_545_1 + s1_545_2);
    gl64_t kD545 = tmp3_0 * s1_545_0;
    gl64_t kE545 = tmp3_1 * s1_545_1;
    gl64_t kF545 = tmp3_2 * s1_545_2;
    gl64_t kG545 = kD545 - kE545;
    tmp3_0 = (kC545 + kG545) - kF545;
    tmp3_1 = ((((kA545 + kC545) - kE545) - kE545) - kD545);
    tmp3_2 = kB545 - kG545;
    // Op 546: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 547: dim3x3 mul
    gl64_t s1_547_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_547_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_547_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA547 = (tmp3_0 + tmp3_1) * (s1_547_0 + s1_547_1);
    gl64_t kB547 = (tmp3_0 + tmp3_2) * (s1_547_0 + s1_547_2);
    gl64_t kC547 = (tmp3_1 + tmp3_2) * (s1_547_1 + s1_547_2);
    gl64_t kD547 = tmp3_0 * s1_547_0;
    gl64_t kE547 = tmp3_1 * s1_547_1;
    gl64_t kF547 = tmp3_2 * s1_547_2;
    gl64_t kG547 = kD547 - kE547;
    tmp3_0 = (kC547 + kG547) - kF547;
    tmp3_1 = ((((kA547 + kC547) - kE547) - kE547) - kD547);
    tmp3_2 = kB547 - kG547;
    // Op 548: dim3x1 add
    gl64_t s1_548 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_548; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 549: dim3x3 mul
    gl64_t s1_549_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_549_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_549_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA549 = (tmp3_0 + tmp3_1) * (s1_549_0 + s1_549_1);
    gl64_t kB549 = (tmp3_0 + tmp3_2) * (s1_549_0 + s1_549_2);
    gl64_t kC549 = (tmp3_1 + tmp3_2) * (s1_549_1 + s1_549_2);
    gl64_t kD549 = tmp3_0 * s1_549_0;
    gl64_t kE549 = tmp3_1 * s1_549_1;
    gl64_t kF549 = tmp3_2 * s1_549_2;
    gl64_t kG549 = kD549 - kE549;
    tmp3_0 = (kC549 + kG549) - kF549;
    tmp3_1 = ((((kA549 + kC549) - kE549) - kE549) - kD549);
    tmp3_2 = kB549 - kG549;
    // Op 550: dim3x1 add
    gl64_t s1_550 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_550; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 551: dim3x3 mul
    gl64_t s1_551_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_551_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_551_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA551 = (tmp3_0 + tmp3_1) * (s1_551_0 + s1_551_1);
    gl64_t kB551 = (tmp3_0 + tmp3_2) * (s1_551_0 + s1_551_2);
    gl64_t kC551 = (tmp3_1 + tmp3_2) * (s1_551_1 + s1_551_2);
    gl64_t kD551 = tmp3_0 * s1_551_0;
    gl64_t kE551 = tmp3_1 * s1_551_1;
    gl64_t kF551 = tmp3_2 * s1_551_2;
    gl64_t kG551 = kD551 - kE551;
    tmp3_0 = (kC551 + kG551) - kF551;
    tmp3_1 = ((((kA551 + kC551) - kE551) - kE551) - kD551);
    tmp3_2 = kB551 - kG551;
    // Op 552: dim3x1 add
    gl64_t s1_552 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_552; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 553: dim3x3 add
    gl64_t s1_553_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_553_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_553_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_553_0; tmp3_1 = tmp3_1 + s1_553_1; tmp3_2 = tmp3_2 + s1_553_2;
    // Op 554: dim3x3 mul
    gl64_t s1_554_0 = *(gl64_t*)&expressions_params[10][113];
    gl64_t s1_554_1 = *(gl64_t*)&expressions_params[10][113+1];
    gl64_t s1_554_2 = *(gl64_t*)&expressions_params[10][113+2];
    gl64_t kA554 = (tmp3_0 + tmp3_1) * (s1_554_0 + s1_554_1);
    gl64_t kB554 = (tmp3_0 + tmp3_2) * (s1_554_0 + s1_554_2);
    gl64_t kC554 = (tmp3_1 + tmp3_2) * (s1_554_1 + s1_554_2);
    gl64_t kD554 = tmp3_0 * s1_554_0;
    gl64_t kE554 = tmp3_1 * s1_554_1;
    gl64_t kF554 = tmp3_2 * s1_554_2;
    gl64_t kG554 = kD554 - kE554;
    tmp3_0 = (kC554 + kG554) - kF554;
    tmp3_1 = ((((kA554 + kC554) - kE554) - kE554) - kD554);
    tmp3_2 = kB554 - kG554;
    // Op 555: dim1x1 sub
    gl64_t s0_555 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_555 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_555 - s1_555;
    // Op 556: dim1x1 sub_swap
    gl64_t s1_556 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_556 - tmp1_0;
    // Op 557: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 558: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 559: dim3x3 mul
    gl64_t s1_559_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_559_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_559_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA559 = (tmp3_0 + tmp3_1) * (s1_559_0 + s1_559_1);
    gl64_t kB559 = (tmp3_0 + tmp3_2) * (s1_559_0 + s1_559_2);
    gl64_t kC559 = (tmp3_1 + tmp3_2) * (s1_559_1 + s1_559_2);
    gl64_t kD559 = tmp3_0 * s1_559_0;
    gl64_t kE559 = tmp3_1 * s1_559_1;
    gl64_t kF559 = tmp3_2 * s1_559_2;
    gl64_t kG559 = kD559 - kE559;
    tmp3_6 = (kC559 + kG559) - kF559;
    tmp3_7 = ((((kA559 + kC559) - kE559) - kE559) - kD559);
    tmp3_8 = kB559 - kG559;
    // Op 560: dim1x1 sub
    gl64_t s1_560 = *(gl64_t*)&expressions_params[10][71];
    tmp1_0 = tmp1_4 - s1_560;
    // Op 561: dim1x1 sub
    gl64_t s1_561 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_561;
    // Op 562: dim3x1 mul
    gl64_t s0_562_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_562_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_562_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_562_0 * tmp1_0; tmp3_1 = s0_562_1 * tmp1_0; tmp3_2 = s0_562_2 * tmp1_0;
    // Op 563: dim3x1 add
    gl64_t s1_563 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_563; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 564: dim3x3 add
    gl64_t s1_564_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_564_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_564_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_564_0; tmp3_1 = tmp3_1 + s1_564_1; tmp3_2 = tmp3_2 + s1_564_2;
    // Op 565: dim3x3 mul
    gl64_t s1_565_0 = *(gl64_t*)&expressions_params[10][116];
    gl64_t s1_565_1 = *(gl64_t*)&expressions_params[10][116+1];
    gl64_t s1_565_2 = *(gl64_t*)&expressions_params[10][116+2];
    gl64_t kA565 = (tmp3_0 + tmp3_1) * (s1_565_0 + s1_565_1);
    gl64_t kB565 = (tmp3_0 + tmp3_2) * (s1_565_0 + s1_565_2);
    gl64_t kC565 = (tmp3_1 + tmp3_2) * (s1_565_1 + s1_565_2);
    gl64_t kD565 = tmp3_0 * s1_565_0;
    gl64_t kE565 = tmp3_1 * s1_565_1;
    gl64_t kF565 = tmp3_2 * s1_565_2;
    gl64_t kG565 = kD565 - kE565;
    tmp3_0 = (kC565 + kG565) - kF565;
    tmp3_1 = ((((kA565 + kC565) - kE565) - kE565) - kD565);
    tmp3_2 = kB565 - kG565;
    // Op 566: dim3x1 add
    gl64_t s1_566 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_566; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 567: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 568: dim3x3 mul
    gl64_t s1_568_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_568_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_568_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA568 = (tmp3_0 + tmp3_1) * (s1_568_0 + s1_568_1);
    gl64_t kB568 = (tmp3_0 + tmp3_2) * (s1_568_0 + s1_568_2);
    gl64_t kC568 = (tmp3_1 + tmp3_2) * (s1_568_1 + s1_568_2);
    gl64_t kD568 = tmp3_0 * s1_568_0;
    gl64_t kE568 = tmp3_1 * s1_568_1;
    gl64_t kF568 = tmp3_2 * s1_568_2;
    gl64_t kG568 = kD568 - kE568;
    tmp3_6 = (kC568 + kG568) - kF568;
    tmp3_7 = ((((kA568 + kC568) - kE568) - kE568) - kD568);
    tmp3_8 = kB568 - kG568;
    // Op 569: dim3x1 mul
    gl64_t s0_569_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_569_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_569_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_569 = *(gl64_t*)&expressions_params[10][11];
    tmp3_0 = s0_569_0 * s1_569; tmp3_1 = s0_569_1 * s1_569; tmp3_2 = s0_569_2 * s1_569;
    // Op 570: dim3x1 add
    gl64_t s1_570 = *(gl64_t*)&expressions_params[10][10];
    tmp3_0 = tmp3_0 + s1_570; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 571: dim3x3 mul
    gl64_t s1_571_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_571_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_571_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA571 = (tmp3_0 + tmp3_1) * (s1_571_0 + s1_571_1);
    gl64_t kB571 = (tmp3_0 + tmp3_2) * (s1_571_0 + s1_571_2);
    gl64_t kC571 = (tmp3_1 + tmp3_2) * (s1_571_1 + s1_571_2);
    gl64_t kD571 = tmp3_0 * s1_571_0;
    gl64_t kE571 = tmp3_1 * s1_571_1;
    gl64_t kF571 = tmp3_2 * s1_571_2;
    gl64_t kG571 = kD571 - kE571;
    tmp3_0 = (kC571 + kG571) - kF571;
    tmp3_1 = ((((kA571 + kC571) - kE571) - kE571) - kD571);
    tmp3_2 = kB571 - kG571;
    // Op 572: dim3x1 add
    gl64_t s1_572 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_572; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 573: dim3x3 mul
    gl64_t s1_573_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_573_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_573_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA573 = (tmp3_0 + tmp3_1) * (s1_573_0 + s1_573_1);
    gl64_t kB573 = (tmp3_0 + tmp3_2) * (s1_573_0 + s1_573_2);
    gl64_t kC573 = (tmp3_1 + tmp3_2) * (s1_573_1 + s1_573_2);
    gl64_t kD573 = tmp3_0 * s1_573_0;
    gl64_t kE573 = tmp3_1 * s1_573_1;
    gl64_t kF573 = tmp3_2 * s1_573_2;
    gl64_t kG573 = kD573 - kE573;
    tmp3_0 = (kC573 + kG573) - kF573;
    tmp3_1 = ((((kA573 + kC573) - kE573) - kE573) - kD573);
    tmp3_2 = kB573 - kG573;
    // Op 574: dim3x1 add
    gl64_t s1_574 = *(gl64_t*)&expressions_params[10][71];
    tmp3_0 = tmp3_0 + s1_574; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 575: dim3x3 mul
    gl64_t s1_575_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_575_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_575_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA575 = (tmp3_0 + tmp3_1) * (s1_575_0 + s1_575_1);
    gl64_t kB575 = (tmp3_0 + tmp3_2) * (s1_575_0 + s1_575_2);
    gl64_t kC575 = (tmp3_1 + tmp3_2) * (s1_575_1 + s1_575_2);
    gl64_t kD575 = tmp3_0 * s1_575_0;
    gl64_t kE575 = tmp3_1 * s1_575_1;
    gl64_t kF575 = tmp3_2 * s1_575_2;
    gl64_t kG575 = kD575 - kE575;
    tmp3_0 = (kC575 + kG575) - kF575;
    tmp3_1 = ((((kA575 + kC575) - kE575) - kE575) - kD575);
    tmp3_2 = kB575 - kG575;
    // Op 576: dim3x1 add
    gl64_t s1_576 = *(gl64_t*)&expressions_params[9][8];
    tmp3_0 = tmp3_0 + s1_576; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 577: dim3x3 mul
    gl64_t s1_577_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_577_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_577_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA577 = (tmp3_0 + tmp3_1) * (s1_577_0 + s1_577_1);
    gl64_t kB577 = (tmp3_0 + tmp3_2) * (s1_577_0 + s1_577_2);
    gl64_t kC577 = (tmp3_1 + tmp3_2) * (s1_577_1 + s1_577_2);
    gl64_t kD577 = tmp3_0 * s1_577_0;
    gl64_t kE577 = tmp3_1 * s1_577_1;
    gl64_t kF577 = tmp3_2 * s1_577_2;
    gl64_t kG577 = kD577 - kE577;
    tmp3_0 = (kC577 + kG577) - kF577;
    tmp3_1 = ((((kA577 + kC577) - kE577) - kE577) - kD577);
    tmp3_2 = kB577 - kG577;
    // Op 578: dim3x1 add
    gl64_t s1_578 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_578; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 579: dim3x3 mul
    gl64_t s1_579_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_579_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_579_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA579 = (tmp3_0 + tmp3_1) * (s1_579_0 + s1_579_1);
    gl64_t kB579 = (tmp3_0 + tmp3_2) * (s1_579_0 + s1_579_2);
    gl64_t kC579 = (tmp3_1 + tmp3_2) * (s1_579_1 + s1_579_2);
    gl64_t kD579 = tmp3_0 * s1_579_0;
    gl64_t kE579 = tmp3_1 * s1_579_1;
    gl64_t kF579 = tmp3_2 * s1_579_2;
    gl64_t kG579 = kD579 - kE579;
    tmp3_0 = (kC579 + kG579) - kF579;
    tmp3_1 = ((((kA579 + kC579) - kE579) - kE579) - kD579);
    tmp3_2 = kB579 - kG579;
    // Op 580: dim3x1 add
    gl64_t s1_580 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_580; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 581: dim3x3 add
    gl64_t s1_581_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_581_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_581_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_581_0; tmp3_1 = tmp3_1 + s1_581_1; tmp3_2 = tmp3_2 + s1_581_2;
    // Op 582: dim3x3 mul
    gl64_t s1_582_0 = *(gl64_t*)&expressions_params[10][119];
    gl64_t s1_582_1 = *(gl64_t*)&expressions_params[10][119+1];
    gl64_t s1_582_2 = *(gl64_t*)&expressions_params[10][119+2];
    gl64_t kA582 = (tmp3_0 + tmp3_1) * (s1_582_0 + s1_582_1);
    gl64_t kB582 = (tmp3_0 + tmp3_2) * (s1_582_0 + s1_582_2);
    gl64_t kC582 = (tmp3_1 + tmp3_2) * (s1_582_1 + s1_582_2);
    gl64_t kD582 = tmp3_0 * s1_582_0;
    gl64_t kE582 = tmp3_1 * s1_582_1;
    gl64_t kF582 = tmp3_2 * s1_582_2;
    gl64_t kG582 = kD582 - kE582;
    tmp3_0 = (kC582 + kG582) - kF582;
    tmp3_1 = ((((kA582 + kC582) - kE582) - kE582) - kD582);
    tmp3_2 = kB582 - kG582;
    // Op 583: dim3x1 sub
    gl64_t s1_583 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_583; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 584: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 585: dim3x3 mul
    gl64_t s1_585_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_585_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_585_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA585 = (tmp3_0 + tmp3_1) * (s1_585_0 + s1_585_1);
    gl64_t kB585 = (tmp3_0 + tmp3_2) * (s1_585_0 + s1_585_2);
    gl64_t kC585 = (tmp3_1 + tmp3_2) * (s1_585_1 + s1_585_2);
    gl64_t kD585 = tmp3_0 * s1_585_0;
    gl64_t kE585 = tmp3_1 * s1_585_1;
    gl64_t kF585 = tmp3_2 * s1_585_2;
    gl64_t kG585 = kD585 - kE585;
    tmp3_6 = (kC585 + kG585) - kF585;
    tmp3_7 = ((((kA585 + kC585) - kE585) - kE585) - kD585);
    tmp3_8 = kB585 - kG585;
    // Op 586: dim3x1 mul
    gl64_t s0_586_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_586_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_586_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_586 = *(gl64_t*)&expressions_params[10][11];
    tmp3_0 = s0_586_0 * s1_586; tmp3_1 = s0_586_1 * s1_586; tmp3_2 = s0_586_2 * s1_586;
    // Op 587: dim3x1 add
    gl64_t s1_587 = *(gl64_t*)&expressions_params[10][10];
    tmp3_0 = tmp3_0 + s1_587; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 588: dim3x3 mul
    gl64_t s1_588_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_588_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_588_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA588 = (tmp3_0 + tmp3_1) * (s1_588_0 + s1_588_1);
    gl64_t kB588 = (tmp3_0 + tmp3_2) * (s1_588_0 + s1_588_2);
    gl64_t kC588 = (tmp3_1 + tmp3_2) * (s1_588_1 + s1_588_2);
    gl64_t kD588 = tmp3_0 * s1_588_0;
    gl64_t kE588 = tmp3_1 * s1_588_1;
    gl64_t kF588 = tmp3_2 * s1_588_2;
    gl64_t kG588 = kD588 - kE588;
    tmp3_0 = (kC588 + kG588) - kF588;
    tmp3_1 = ((((kA588 + kC588) - kE588) - kE588) - kD588);
    tmp3_2 = kB588 - kG588;
    // Op 589: dim3x1 add
    gl64_t s1_589 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_589; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 590: dim3x3 mul
    gl64_t s1_590_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_590_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_590_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA590 = (tmp3_0 + tmp3_1) * (s1_590_0 + s1_590_1);
    gl64_t kB590 = (tmp3_0 + tmp3_2) * (s1_590_0 + s1_590_2);
    gl64_t kC590 = (tmp3_1 + tmp3_2) * (s1_590_1 + s1_590_2);
    gl64_t kD590 = tmp3_0 * s1_590_0;
    gl64_t kE590 = tmp3_1 * s1_590_1;
    gl64_t kF590 = tmp3_2 * s1_590_2;
    gl64_t kG590 = kD590 - kE590;
    tmp3_0 = (kC590 + kG590) - kF590;
    tmp3_1 = ((((kA590 + kC590) - kE590) - kE590) - kD590);
    tmp3_2 = kB590 - kG590;
    // Op 591: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 592: dim3x3 mul
    gl64_t s1_592_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_592_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_592_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA592 = (tmp3_0 + tmp3_1) * (s1_592_0 + s1_592_1);
    gl64_t kB592 = (tmp3_0 + tmp3_2) * (s1_592_0 + s1_592_2);
    gl64_t kC592 = (tmp3_1 + tmp3_2) * (s1_592_1 + s1_592_2);
    gl64_t kD592 = tmp3_0 * s1_592_0;
    gl64_t kE592 = tmp3_1 * s1_592_1;
    gl64_t kF592 = tmp3_2 * s1_592_2;
    gl64_t kG592 = kD592 - kE592;
    tmp3_0 = (kC592 + kG592) - kF592;
    tmp3_1 = ((((kA592 + kC592) - kE592) - kE592) - kD592);
    tmp3_2 = kB592 - kG592;
    // Op 593: dim3x1 add
    gl64_t s1_593 = *(gl64_t*)&expressions_params[9][8];
    tmp3_0 = tmp3_0 + s1_593; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 594: dim3x3 mul
    gl64_t s1_594_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_594_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_594_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA594 = (tmp3_0 + tmp3_1) * (s1_594_0 + s1_594_1);
    gl64_t kB594 = (tmp3_0 + tmp3_2) * (s1_594_0 + s1_594_2);
    gl64_t kC594 = (tmp3_1 + tmp3_2) * (s1_594_1 + s1_594_2);
    gl64_t kD594 = tmp3_0 * s1_594_0;
    gl64_t kE594 = tmp3_1 * s1_594_1;
    gl64_t kF594 = tmp3_2 * s1_594_2;
    gl64_t kG594 = kD594 - kE594;
    tmp3_0 = (kC594 + kG594) - kF594;
    tmp3_1 = ((((kA594 + kC594) - kE594) - kE594) - kD594);
    tmp3_2 = kB594 - kG594;
    // Op 595: dim3x1 add
    gl64_t s1_595 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_595; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 596: dim3x3 mul
    gl64_t s1_596_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_596_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_596_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA596 = (tmp3_0 + tmp3_1) * (s1_596_0 + s1_596_1);
    gl64_t kB596 = (tmp3_0 + tmp3_2) * (s1_596_0 + s1_596_2);
    gl64_t kC596 = (tmp3_1 + tmp3_2) * (s1_596_1 + s1_596_2);
    gl64_t kD596 = tmp3_0 * s1_596_0;
    gl64_t kE596 = tmp3_1 * s1_596_1;
    gl64_t kF596 = tmp3_2 * s1_596_2;
    gl64_t kG596 = kD596 - kE596;
    tmp3_0 = (kC596 + kG596) - kF596;
    tmp3_1 = ((((kA596 + kC596) - kE596) - kE596) - kD596);
    tmp3_2 = kB596 - kG596;
    // Op 597: dim3x1 add
    gl64_t s1_597 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_597; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 598: dim3x3 add
    gl64_t s1_598_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_598_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_598_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_598_0; tmp3_1 = tmp3_1 + s1_598_1; tmp3_2 = tmp3_2 + s1_598_2;
    // Op 599: dim3x3 mul
    gl64_t s1_599_0 = *(gl64_t*)&expressions_params[10][122];
    gl64_t s1_599_1 = *(gl64_t*)&expressions_params[10][122+1];
    gl64_t s1_599_2 = *(gl64_t*)&expressions_params[10][122+2];
    gl64_t kA599 = (tmp3_0 + tmp3_1) * (s1_599_0 + s1_599_1);
    gl64_t kB599 = (tmp3_0 + tmp3_2) * (s1_599_0 + s1_599_2);
    gl64_t kC599 = (tmp3_1 + tmp3_2) * (s1_599_1 + s1_599_2);
    gl64_t kD599 = tmp3_0 * s1_599_0;
    gl64_t kE599 = tmp3_1 * s1_599_1;
    gl64_t kF599 = tmp3_2 * s1_599_2;
    gl64_t kG599 = kD599 - kE599;
    tmp3_0 = (kC599 + kG599) - kF599;
    tmp3_1 = ((((kA599 + kC599) - kE599) - kE599) - kD599);
    tmp3_2 = kB599 - kG599;
    // Op 600: dim1x1 sub
    gl64_t s0_600 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_600 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_600 - s1_600;
    // Op 601: dim1x1 sub_swap
    gl64_t s1_601 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_601 - tmp1_0;
    // Op 602: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 603: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 604: dim3x3 mul
    gl64_t s1_604_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_604_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_604_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA604 = (tmp3_0 + tmp3_1) * (s1_604_0 + s1_604_1);
    gl64_t kB604 = (tmp3_0 + tmp3_2) * (s1_604_0 + s1_604_2);
    gl64_t kC604 = (tmp3_1 + tmp3_2) * (s1_604_1 + s1_604_2);
    gl64_t kD604 = tmp3_0 * s1_604_0;
    gl64_t kE604 = tmp3_1 * s1_604_1;
    gl64_t kF604 = tmp3_2 * s1_604_2;
    gl64_t kG604 = kD604 - kE604;
    tmp3_6 = (kC604 + kG604) - kF604;
    tmp3_7 = ((((kA604 + kC604) - kE604) - kE604) - kD604);
    tmp3_8 = kB604 - kG604;
    // Op 605: dim1x1 sub
    gl64_t s1_605 = *(gl64_t*)&expressions_params[10][72];
    tmp1_0 = tmp1_4 - s1_605;
    // Op 606: dim1x1 sub
    gl64_t s1_606 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_606;
    // Op 607: dim3x1 mul
    gl64_t s0_607_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_607_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_607_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_607_0 * tmp1_0; tmp3_1 = s0_607_1 * tmp1_0; tmp3_2 = s0_607_2 * tmp1_0;
    // Op 608: dim3x1 add
    gl64_t s1_608 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_608; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 609: dim3x3 add
    gl64_t s1_609_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_609_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_609_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_609_0; tmp3_1 = tmp3_1 + s1_609_1; tmp3_2 = tmp3_2 + s1_609_2;
    // Op 610: dim3x3 mul
    gl64_t s1_610_0 = *(gl64_t*)&expressions_params[10][125];
    gl64_t s1_610_1 = *(gl64_t*)&expressions_params[10][125+1];
    gl64_t s1_610_2 = *(gl64_t*)&expressions_params[10][125+2];
    gl64_t kA610 = (tmp3_0 + tmp3_1) * (s1_610_0 + s1_610_1);
    gl64_t kB610 = (tmp3_0 + tmp3_2) * (s1_610_0 + s1_610_2);
    gl64_t kC610 = (tmp3_1 + tmp3_2) * (s1_610_1 + s1_610_2);
    gl64_t kD610 = tmp3_0 * s1_610_0;
    gl64_t kE610 = tmp3_1 * s1_610_1;
    gl64_t kF610 = tmp3_2 * s1_610_2;
    gl64_t kG610 = kD610 - kE610;
    tmp3_0 = (kC610 + kG610) - kF610;
    tmp3_1 = ((((kA610 + kC610) - kE610) - kE610) - kD610);
    tmp3_2 = kB610 - kG610;
    // Op 611: dim3x1 add
    gl64_t s1_611 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_611; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 612: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 613: dim3x3 mul
    gl64_t s1_613_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_613_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_613_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA613 = (tmp3_0 + tmp3_1) * (s1_613_0 + s1_613_1);
    gl64_t kB613 = (tmp3_0 + tmp3_2) * (s1_613_0 + s1_613_2);
    gl64_t kC613 = (tmp3_1 + tmp3_2) * (s1_613_1 + s1_613_2);
    gl64_t kD613 = tmp3_0 * s1_613_0;
    gl64_t kE613 = tmp3_1 * s1_613_1;
    gl64_t kF613 = tmp3_2 * s1_613_2;
    gl64_t kG613 = kD613 - kE613;
    tmp3_6 = (kC613 + kG613) - kF613;
    tmp3_7 = ((((kA613 + kC613) - kE613) - kE613) - kD613);
    tmp3_8 = kB613 - kG613;
    // Op 614: dim3x1 mul
    gl64_t s0_614_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_614_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_614_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_614 = *(gl64_t*)&expressions_params[10][13];
    tmp3_0 = s0_614_0 * s1_614; tmp3_1 = s0_614_1 * s1_614; tmp3_2 = s0_614_2 * s1_614;
    // Op 615: dim3x1 add
    gl64_t s1_615 = *(gl64_t*)&expressions_params[10][12];
    tmp3_0 = tmp3_0 + s1_615; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 616: dim3x3 mul
    gl64_t s1_616_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_616_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_616_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA616 = (tmp3_0 + tmp3_1) * (s1_616_0 + s1_616_1);
    gl64_t kB616 = (tmp3_0 + tmp3_2) * (s1_616_0 + s1_616_2);
    gl64_t kC616 = (tmp3_1 + tmp3_2) * (s1_616_1 + s1_616_2);
    gl64_t kD616 = tmp3_0 * s1_616_0;
    gl64_t kE616 = tmp3_1 * s1_616_1;
    gl64_t kF616 = tmp3_2 * s1_616_2;
    gl64_t kG616 = kD616 - kE616;
    tmp3_0 = (kC616 + kG616) - kF616;
    tmp3_1 = ((((kA616 + kC616) - kE616) - kE616) - kD616);
    tmp3_2 = kB616 - kG616;
    // Op 617: dim3x1 add
    gl64_t s1_617 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_617; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 618: dim3x3 mul
    gl64_t s1_618_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_618_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_618_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA618 = (tmp3_0 + tmp3_1) * (s1_618_0 + s1_618_1);
    gl64_t kB618 = (tmp3_0 + tmp3_2) * (s1_618_0 + s1_618_2);
    gl64_t kC618 = (tmp3_1 + tmp3_2) * (s1_618_1 + s1_618_2);
    gl64_t kD618 = tmp3_0 * s1_618_0;
    gl64_t kE618 = tmp3_1 * s1_618_1;
    gl64_t kF618 = tmp3_2 * s1_618_2;
    gl64_t kG618 = kD618 - kE618;
    tmp3_0 = (kC618 + kG618) - kF618;
    tmp3_1 = ((((kA618 + kC618) - kE618) - kE618) - kD618);
    tmp3_2 = kB618 - kG618;
    // Op 619: dim3x1 add
    gl64_t s1_619 = *(gl64_t*)&expressions_params[10][72];
    tmp3_0 = tmp3_0 + s1_619; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 620: dim3x3 mul
    gl64_t s1_620_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_620_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_620_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA620 = (tmp3_0 + tmp3_1) * (s1_620_0 + s1_620_1);
    gl64_t kB620 = (tmp3_0 + tmp3_2) * (s1_620_0 + s1_620_2);
    gl64_t kC620 = (tmp3_1 + tmp3_2) * (s1_620_1 + s1_620_2);
    gl64_t kD620 = tmp3_0 * s1_620_0;
    gl64_t kE620 = tmp3_1 * s1_620_1;
    gl64_t kF620 = tmp3_2 * s1_620_2;
    gl64_t kG620 = kD620 - kE620;
    tmp3_0 = (kC620 + kG620) - kF620;
    tmp3_1 = ((((kA620 + kC620) - kE620) - kE620) - kD620);
    tmp3_2 = kB620 - kG620;
    // Op 621: dim3x1 add
    gl64_t s1_621 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_621; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 622: dim3x3 mul
    gl64_t s1_622_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_622_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_622_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA622 = (tmp3_0 + tmp3_1) * (s1_622_0 + s1_622_1);
    gl64_t kB622 = (tmp3_0 + tmp3_2) * (s1_622_0 + s1_622_2);
    gl64_t kC622 = (tmp3_1 + tmp3_2) * (s1_622_1 + s1_622_2);
    gl64_t kD622 = tmp3_0 * s1_622_0;
    gl64_t kE622 = tmp3_1 * s1_622_1;
    gl64_t kF622 = tmp3_2 * s1_622_2;
    gl64_t kG622 = kD622 - kE622;
    tmp3_0 = (kC622 + kG622) - kF622;
    tmp3_1 = ((((kA622 + kC622) - kE622) - kE622) - kD622);
    tmp3_2 = kB622 - kG622;
    // Op 623: dim3x1 add
    gl64_t s1_623 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_623; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 624: dim3x3 mul
    gl64_t s1_624_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_624_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_624_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA624 = (tmp3_0 + tmp3_1) * (s1_624_0 + s1_624_1);
    gl64_t kB624 = (tmp3_0 + tmp3_2) * (s1_624_0 + s1_624_2);
    gl64_t kC624 = (tmp3_1 + tmp3_2) * (s1_624_1 + s1_624_2);
    gl64_t kD624 = tmp3_0 * s1_624_0;
    gl64_t kE624 = tmp3_1 * s1_624_1;
    gl64_t kF624 = tmp3_2 * s1_624_2;
    gl64_t kG624 = kD624 - kE624;
    tmp3_0 = (kC624 + kG624) - kF624;
    tmp3_1 = ((((kA624 + kC624) - kE624) - kE624) - kD624);
    tmp3_2 = kB624 - kG624;
    // Op 625: dim3x1 add
    gl64_t s1_625 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_625; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 626: dim3x3 add
    gl64_t s1_626_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_626_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_626_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_626_0; tmp3_1 = tmp3_1 + s1_626_1; tmp3_2 = tmp3_2 + s1_626_2;
    // Op 627: dim3x3 mul
    gl64_t s1_627_0 = *(gl64_t*)&expressions_params[10][128];
    gl64_t s1_627_1 = *(gl64_t*)&expressions_params[10][128+1];
    gl64_t s1_627_2 = *(gl64_t*)&expressions_params[10][128+2];
    gl64_t kA627 = (tmp3_0 + tmp3_1) * (s1_627_0 + s1_627_1);
    gl64_t kB627 = (tmp3_0 + tmp3_2) * (s1_627_0 + s1_627_2);
    gl64_t kC627 = (tmp3_1 + tmp3_2) * (s1_627_1 + s1_627_2);
    gl64_t kD627 = tmp3_0 * s1_627_0;
    gl64_t kE627 = tmp3_1 * s1_627_1;
    gl64_t kF627 = tmp3_2 * s1_627_2;
    gl64_t kG627 = kD627 - kE627;
    tmp3_0 = (kC627 + kG627) - kF627;
    tmp3_1 = ((((kA627 + kC627) - kE627) - kE627) - kD627);
    tmp3_2 = kB627 - kG627;
    // Op 628: dim3x1 sub
    gl64_t s1_628 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_628; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 629: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 630: dim3x3 mul
    gl64_t s1_630_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_630_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_630_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA630 = (tmp3_0 + tmp3_1) * (s1_630_0 + s1_630_1);
    gl64_t kB630 = (tmp3_0 + tmp3_2) * (s1_630_0 + s1_630_2);
    gl64_t kC630 = (tmp3_1 + tmp3_2) * (s1_630_1 + s1_630_2);
    gl64_t kD630 = tmp3_0 * s1_630_0;
    gl64_t kE630 = tmp3_1 * s1_630_1;
    gl64_t kF630 = tmp3_2 * s1_630_2;
    gl64_t kG630 = kD630 - kE630;
    tmp3_6 = (kC630 + kG630) - kF630;
    tmp3_7 = ((((kA630 + kC630) - kE630) - kE630) - kD630);
    tmp3_8 = kB630 - kG630;
    // Op 631: dim3x1 mul
    gl64_t s0_631_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_631_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_631_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_631 = *(gl64_t*)&expressions_params[10][13];
    tmp3_0 = s0_631_0 * s1_631; tmp3_1 = s0_631_1 * s1_631; tmp3_2 = s0_631_2 * s1_631;
    // Op 632: dim3x1 add
    gl64_t s1_632 = *(gl64_t*)&expressions_params[10][12];
    tmp3_0 = tmp3_0 + s1_632; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 633: dim3x3 mul
    gl64_t s1_633_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_633_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_633_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA633 = (tmp3_0 + tmp3_1) * (s1_633_0 + s1_633_1);
    gl64_t kB633 = (tmp3_0 + tmp3_2) * (s1_633_0 + s1_633_2);
    gl64_t kC633 = (tmp3_1 + tmp3_2) * (s1_633_1 + s1_633_2);
    gl64_t kD633 = tmp3_0 * s1_633_0;
    gl64_t kE633 = tmp3_1 * s1_633_1;
    gl64_t kF633 = tmp3_2 * s1_633_2;
    gl64_t kG633 = kD633 - kE633;
    tmp3_0 = (kC633 + kG633) - kF633;
    tmp3_1 = ((((kA633 + kC633) - kE633) - kE633) - kD633);
    tmp3_2 = kB633 - kG633;
    // Op 634: dim3x1 add
    gl64_t s1_634 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_634; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 635: dim3x3 mul
    gl64_t s1_635_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_635_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_635_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA635 = (tmp3_0 + tmp3_1) * (s1_635_0 + s1_635_1);
    gl64_t kB635 = (tmp3_0 + tmp3_2) * (s1_635_0 + s1_635_2);
    gl64_t kC635 = (tmp3_1 + tmp3_2) * (s1_635_1 + s1_635_2);
    gl64_t kD635 = tmp3_0 * s1_635_0;
    gl64_t kE635 = tmp3_1 * s1_635_1;
    gl64_t kF635 = tmp3_2 * s1_635_2;
    gl64_t kG635 = kD635 - kE635;
    tmp3_0 = (kC635 + kG635) - kF635;
    tmp3_1 = ((((kA635 + kC635) - kE635) - kE635) - kD635);
    tmp3_2 = kB635 - kG635;
    // Op 636: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 637: dim3x3 mul
    gl64_t s1_637_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_637_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_637_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA637 = (tmp3_0 + tmp3_1) * (s1_637_0 + s1_637_1);
    gl64_t kB637 = (tmp3_0 + tmp3_2) * (s1_637_0 + s1_637_2);
    gl64_t kC637 = (tmp3_1 + tmp3_2) * (s1_637_1 + s1_637_2);
    gl64_t kD637 = tmp3_0 * s1_637_0;
    gl64_t kE637 = tmp3_1 * s1_637_1;
    gl64_t kF637 = tmp3_2 * s1_637_2;
    gl64_t kG637 = kD637 - kE637;
    tmp3_0 = (kC637 + kG637) - kF637;
    tmp3_1 = ((((kA637 + kC637) - kE637) - kE637) - kD637);
    tmp3_2 = kB637 - kG637;
    // Op 638: dim3x1 add
    gl64_t s1_638 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_638; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 639: dim3x3 mul
    gl64_t s1_639_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_639_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_639_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA639 = (tmp3_0 + tmp3_1) * (s1_639_0 + s1_639_1);
    gl64_t kB639 = (tmp3_0 + tmp3_2) * (s1_639_0 + s1_639_2);
    gl64_t kC639 = (tmp3_1 + tmp3_2) * (s1_639_1 + s1_639_2);
    gl64_t kD639 = tmp3_0 * s1_639_0;
    gl64_t kE639 = tmp3_1 * s1_639_1;
    gl64_t kF639 = tmp3_2 * s1_639_2;
    gl64_t kG639 = kD639 - kE639;
    tmp3_0 = (kC639 + kG639) - kF639;
    tmp3_1 = ((((kA639 + kC639) - kE639) - kE639) - kD639);
    tmp3_2 = kB639 - kG639;
    // Op 640: dim3x1 add
    gl64_t s1_640 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_640; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 641: dim3x3 mul
    gl64_t s1_641_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_641_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_641_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA641 = (tmp3_0 + tmp3_1) * (s1_641_0 + s1_641_1);
    gl64_t kB641 = (tmp3_0 + tmp3_2) * (s1_641_0 + s1_641_2);
    gl64_t kC641 = (tmp3_1 + tmp3_2) * (s1_641_1 + s1_641_2);
    gl64_t kD641 = tmp3_0 * s1_641_0;
    gl64_t kE641 = tmp3_1 * s1_641_1;
    gl64_t kF641 = tmp3_2 * s1_641_2;
    gl64_t kG641 = kD641 - kE641;
    tmp3_0 = (kC641 + kG641) - kF641;
    tmp3_1 = ((((kA641 + kC641) - kE641) - kE641) - kD641);
    tmp3_2 = kB641 - kG641;
    // Op 642: dim3x1 add
    gl64_t s1_642 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_642; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 643: dim3x3 add
    gl64_t s1_643_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_643_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_643_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_643_0; tmp3_1 = tmp3_1 + s1_643_1; tmp3_2 = tmp3_2 + s1_643_2;
    // Op 644: dim3x3 mul
    gl64_t s1_644_0 = *(gl64_t*)&expressions_params[10][131];
    gl64_t s1_644_1 = *(gl64_t*)&expressions_params[10][131+1];
    gl64_t s1_644_2 = *(gl64_t*)&expressions_params[10][131+2];
    gl64_t kA644 = (tmp3_0 + tmp3_1) * (s1_644_0 + s1_644_1);
    gl64_t kB644 = (tmp3_0 + tmp3_2) * (s1_644_0 + s1_644_2);
    gl64_t kC644 = (tmp3_1 + tmp3_2) * (s1_644_1 + s1_644_2);
    gl64_t kD644 = tmp3_0 * s1_644_0;
    gl64_t kE644 = tmp3_1 * s1_644_1;
    gl64_t kF644 = tmp3_2 * s1_644_2;
    gl64_t kG644 = kD644 - kE644;
    tmp3_0 = (kC644 + kG644) - kF644;
    tmp3_1 = ((((kA644 + kC644) - kE644) - kE644) - kD644);
    tmp3_2 = kB644 - kG644;
    // Op 645: dim1x1 sub
    gl64_t s0_645 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_645 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_645 - s1_645;
    // Op 646: dim1x1 sub_swap
    gl64_t s1_646 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_646 - tmp1_0;
    // Op 647: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 648: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 649: dim3x3 mul
    gl64_t s1_649_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_649_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_649_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA649 = (tmp3_0 + tmp3_1) * (s1_649_0 + s1_649_1);
    gl64_t kB649 = (tmp3_0 + tmp3_2) * (s1_649_0 + s1_649_2);
    gl64_t kC649 = (tmp3_1 + tmp3_2) * (s1_649_1 + s1_649_2);
    gl64_t kD649 = tmp3_0 * s1_649_0;
    gl64_t kE649 = tmp3_1 * s1_649_1;
    gl64_t kF649 = tmp3_2 * s1_649_2;
    gl64_t kG649 = kD649 - kE649;
    tmp3_6 = (kC649 + kG649) - kF649;
    tmp3_7 = ((((kA649 + kC649) - kE649) - kE649) - kD649);
    tmp3_8 = kB649 - kG649;
    // Op 650: dim1x1 sub
    gl64_t s1_650 = *(gl64_t*)&expressions_params[10][73];
    tmp1_0 = tmp1_4 - s1_650;
    // Op 651: dim1x1 sub
    gl64_t s1_651 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_651;
    // Op 652: dim3x1 mul
    gl64_t s0_652_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_652_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_652_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_652_0 * tmp1_0; tmp3_1 = s0_652_1 * tmp1_0; tmp3_2 = s0_652_2 * tmp1_0;
    // Op 653: dim3x1 add
    gl64_t s1_653 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_653; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 654: dim3x3 add
    gl64_t s1_654_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_654_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_654_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_654_0; tmp3_1 = tmp3_1 + s1_654_1; tmp3_2 = tmp3_2 + s1_654_2;
    // Op 655: dim3x3 mul
    gl64_t s1_655_0 = *(gl64_t*)&expressions_params[10][134];
    gl64_t s1_655_1 = *(gl64_t*)&expressions_params[10][134+1];
    gl64_t s1_655_2 = *(gl64_t*)&expressions_params[10][134+2];
    gl64_t kA655 = (tmp3_0 + tmp3_1) * (s1_655_0 + s1_655_1);
    gl64_t kB655 = (tmp3_0 + tmp3_2) * (s1_655_0 + s1_655_2);
    gl64_t kC655 = (tmp3_1 + tmp3_2) * (s1_655_1 + s1_655_2);
    gl64_t kD655 = tmp3_0 * s1_655_0;
    gl64_t kE655 = tmp3_1 * s1_655_1;
    gl64_t kF655 = tmp3_2 * s1_655_2;
    gl64_t kG655 = kD655 - kE655;
    tmp3_0 = (kC655 + kG655) - kF655;
    tmp3_1 = ((((kA655 + kC655) - kE655) - kE655) - kD655);
    tmp3_2 = kB655 - kG655;
    // Op 656: dim3x1 add
    gl64_t s1_656 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_656; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 657: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 658: dim3x3 mul
    gl64_t s1_658_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_658_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_658_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA658 = (tmp3_0 + tmp3_1) * (s1_658_0 + s1_658_1);
    gl64_t kB658 = (tmp3_0 + tmp3_2) * (s1_658_0 + s1_658_2);
    gl64_t kC658 = (tmp3_1 + tmp3_2) * (s1_658_1 + s1_658_2);
    gl64_t kD658 = tmp3_0 * s1_658_0;
    gl64_t kE658 = tmp3_1 * s1_658_1;
    gl64_t kF658 = tmp3_2 * s1_658_2;
    gl64_t kG658 = kD658 - kE658;
    tmp3_6 = (kC658 + kG658) - kF658;
    tmp3_7 = ((((kA658 + kC658) - kE658) - kE658) - kD658);
    tmp3_8 = kB658 - kG658;
    // Op 659: dim3x1 mul
    gl64_t s0_659_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_659_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_659_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_659 = *(gl64_t*)&expressions_params[10][15];
    tmp3_0 = s0_659_0 * s1_659; tmp3_1 = s0_659_1 * s1_659; tmp3_2 = s0_659_2 * s1_659;
    // Op 660: dim3x1 add
    gl64_t s1_660 = *(gl64_t*)&expressions_params[10][14];
    tmp3_0 = tmp3_0 + s1_660; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 661: dim3x3 mul
    gl64_t s1_661_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_661_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_661_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA661 = (tmp3_0 + tmp3_1) * (s1_661_0 + s1_661_1);
    gl64_t kB661 = (tmp3_0 + tmp3_2) * (s1_661_0 + s1_661_2);
    gl64_t kC661 = (tmp3_1 + tmp3_2) * (s1_661_1 + s1_661_2);
    gl64_t kD661 = tmp3_0 * s1_661_0;
    gl64_t kE661 = tmp3_1 * s1_661_1;
    gl64_t kF661 = tmp3_2 * s1_661_2;
    gl64_t kG661 = kD661 - kE661;
    tmp3_0 = (kC661 + kG661) - kF661;
    tmp3_1 = ((((kA661 + kC661) - kE661) - kE661) - kD661);
    tmp3_2 = kB661 - kG661;
    // Op 662: dim3x1 add
    gl64_t s1_662 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_662; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 663: dim3x3 mul
    gl64_t s1_663_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_663_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_663_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA663 = (tmp3_0 + tmp3_1) * (s1_663_0 + s1_663_1);
    gl64_t kB663 = (tmp3_0 + tmp3_2) * (s1_663_0 + s1_663_2);
    gl64_t kC663 = (tmp3_1 + tmp3_2) * (s1_663_1 + s1_663_2);
    gl64_t kD663 = tmp3_0 * s1_663_0;
    gl64_t kE663 = tmp3_1 * s1_663_1;
    gl64_t kF663 = tmp3_2 * s1_663_2;
    gl64_t kG663 = kD663 - kE663;
    tmp3_0 = (kC663 + kG663) - kF663;
    tmp3_1 = ((((kA663 + kC663) - kE663) - kE663) - kD663);
    tmp3_2 = kB663 - kG663;
    // Op 664: dim3x1 add
    gl64_t s1_664 = *(gl64_t*)&expressions_params[10][73];
    tmp3_0 = tmp3_0 + s1_664; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 665: dim3x3 mul
    gl64_t s1_665_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_665_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_665_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA665 = (tmp3_0 + tmp3_1) * (s1_665_0 + s1_665_1);
    gl64_t kB665 = (tmp3_0 + tmp3_2) * (s1_665_0 + s1_665_2);
    gl64_t kC665 = (tmp3_1 + tmp3_2) * (s1_665_1 + s1_665_2);
    gl64_t kD665 = tmp3_0 * s1_665_0;
    gl64_t kE665 = tmp3_1 * s1_665_1;
    gl64_t kF665 = tmp3_2 * s1_665_2;
    gl64_t kG665 = kD665 - kE665;
    tmp3_0 = (kC665 + kG665) - kF665;
    tmp3_1 = ((((kA665 + kC665) - kE665) - kE665) - kD665);
    tmp3_2 = kB665 - kG665;
    // Op 666: dim3x1 add
    gl64_t s1_666 = *(gl64_t*)&expressions_params[9][6];
    tmp3_0 = tmp3_0 + s1_666; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 667: dim3x3 mul
    gl64_t s1_667_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_667_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_667_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA667 = (tmp3_0 + tmp3_1) * (s1_667_0 + s1_667_1);
    gl64_t kB667 = (tmp3_0 + tmp3_2) * (s1_667_0 + s1_667_2);
    gl64_t kC667 = (tmp3_1 + tmp3_2) * (s1_667_1 + s1_667_2);
    gl64_t kD667 = tmp3_0 * s1_667_0;
    gl64_t kE667 = tmp3_1 * s1_667_1;
    gl64_t kF667 = tmp3_2 * s1_667_2;
    gl64_t kG667 = kD667 - kE667;
    tmp3_0 = (kC667 + kG667) - kF667;
    tmp3_1 = ((((kA667 + kC667) - kE667) - kE667) - kD667);
    tmp3_2 = kB667 - kG667;
    // Op 668: dim3x1 add
    gl64_t s1_668 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_668; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 669: dim3x3 mul
    gl64_t s1_669_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_669_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_669_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA669 = (tmp3_0 + tmp3_1) * (s1_669_0 + s1_669_1);
    gl64_t kB669 = (tmp3_0 + tmp3_2) * (s1_669_0 + s1_669_2);
    gl64_t kC669 = (tmp3_1 + tmp3_2) * (s1_669_1 + s1_669_2);
    gl64_t kD669 = tmp3_0 * s1_669_0;
    gl64_t kE669 = tmp3_1 * s1_669_1;
    gl64_t kF669 = tmp3_2 * s1_669_2;
    gl64_t kG669 = kD669 - kE669;
    tmp3_0 = (kC669 + kG669) - kF669;
    tmp3_1 = ((((kA669 + kC669) - kE669) - kE669) - kD669);
    tmp3_2 = kB669 - kG669;
    // Op 670: dim3x1 add
    gl64_t s1_670 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_670; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 671: dim3x3 add
    gl64_t s1_671_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_671_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_671_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_671_0; tmp3_1 = tmp3_1 + s1_671_1; tmp3_2 = tmp3_2 + s1_671_2;
    // Op 672: dim3x3 mul
    gl64_t s1_672_0 = *(gl64_t*)&expressions_params[10][137];
    gl64_t s1_672_1 = *(gl64_t*)&expressions_params[10][137+1];
    gl64_t s1_672_2 = *(gl64_t*)&expressions_params[10][137+2];
    gl64_t kA672 = (tmp3_0 + tmp3_1) * (s1_672_0 + s1_672_1);
    gl64_t kB672 = (tmp3_0 + tmp3_2) * (s1_672_0 + s1_672_2);
    gl64_t kC672 = (tmp3_1 + tmp3_2) * (s1_672_1 + s1_672_2);
    gl64_t kD672 = tmp3_0 * s1_672_0;
    gl64_t kE672 = tmp3_1 * s1_672_1;
    gl64_t kF672 = tmp3_2 * s1_672_2;
    gl64_t kG672 = kD672 - kE672;
    tmp3_0 = (kC672 + kG672) - kF672;
    tmp3_1 = ((((kA672 + kC672) - kE672) - kE672) - kD672);
    tmp3_2 = kB672 - kG672;
    // Op 673: dim3x1 sub
    gl64_t s1_673 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_673; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 674: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 675: dim3x3 mul
    gl64_t s1_675_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_675_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_675_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA675 = (tmp3_0 + tmp3_1) * (s1_675_0 + s1_675_1);
    gl64_t kB675 = (tmp3_0 + tmp3_2) * (s1_675_0 + s1_675_2);
    gl64_t kC675 = (tmp3_1 + tmp3_2) * (s1_675_1 + s1_675_2);
    gl64_t kD675 = tmp3_0 * s1_675_0;
    gl64_t kE675 = tmp3_1 * s1_675_1;
    gl64_t kF675 = tmp3_2 * s1_675_2;
    gl64_t kG675 = kD675 - kE675;
    tmp3_6 = (kC675 + kG675) - kF675;
    tmp3_7 = ((((kA675 + kC675) - kE675) - kE675) - kD675);
    tmp3_8 = kB675 - kG675;
    // Op 676: dim3x1 mul
    gl64_t s0_676_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_676_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_676_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_676 = *(gl64_t*)&expressions_params[10][15];
    tmp3_0 = s0_676_0 * s1_676; tmp3_1 = s0_676_1 * s1_676; tmp3_2 = s0_676_2 * s1_676;
    // Op 677: dim3x1 add
    gl64_t s1_677 = *(gl64_t*)&expressions_params[10][14];
    tmp3_0 = tmp3_0 + s1_677; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 678: dim3x3 mul
    gl64_t s1_678_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_678_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_678_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA678 = (tmp3_0 + tmp3_1) * (s1_678_0 + s1_678_1);
    gl64_t kB678 = (tmp3_0 + tmp3_2) * (s1_678_0 + s1_678_2);
    gl64_t kC678 = (tmp3_1 + tmp3_2) * (s1_678_1 + s1_678_2);
    gl64_t kD678 = tmp3_0 * s1_678_0;
    gl64_t kE678 = tmp3_1 * s1_678_1;
    gl64_t kF678 = tmp3_2 * s1_678_2;
    gl64_t kG678 = kD678 - kE678;
    tmp3_0 = (kC678 + kG678) - kF678;
    tmp3_1 = ((((kA678 + kC678) - kE678) - kE678) - kD678);
    tmp3_2 = kB678 - kG678;
    // Op 679: dim3x1 add
    gl64_t s1_679 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_679; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 680: dim3x3 mul
    gl64_t s1_680_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_680_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_680_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA680 = (tmp3_0 + tmp3_1) * (s1_680_0 + s1_680_1);
    gl64_t kB680 = (tmp3_0 + tmp3_2) * (s1_680_0 + s1_680_2);
    gl64_t kC680 = (tmp3_1 + tmp3_2) * (s1_680_1 + s1_680_2);
    gl64_t kD680 = tmp3_0 * s1_680_0;
    gl64_t kE680 = tmp3_1 * s1_680_1;
    gl64_t kF680 = tmp3_2 * s1_680_2;
    gl64_t kG680 = kD680 - kE680;
    tmp3_0 = (kC680 + kG680) - kF680;
    tmp3_1 = ((((kA680 + kC680) - kE680) - kE680) - kD680);
    tmp3_2 = kB680 - kG680;
    // Op 681: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 682: dim3x3 mul
    gl64_t s1_682_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_682_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_682_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA682 = (tmp3_0 + tmp3_1) * (s1_682_0 + s1_682_1);
    gl64_t kB682 = (tmp3_0 + tmp3_2) * (s1_682_0 + s1_682_2);
    gl64_t kC682 = (tmp3_1 + tmp3_2) * (s1_682_1 + s1_682_2);
    gl64_t kD682 = tmp3_0 * s1_682_0;
    gl64_t kE682 = tmp3_1 * s1_682_1;
    gl64_t kF682 = tmp3_2 * s1_682_2;
    gl64_t kG682 = kD682 - kE682;
    tmp3_0 = (kC682 + kG682) - kF682;
    tmp3_1 = ((((kA682 + kC682) - kE682) - kE682) - kD682);
    tmp3_2 = kB682 - kG682;
    // Op 683: dim3x1 add
    gl64_t s1_683 = *(gl64_t*)&expressions_params[9][6];
    tmp3_0 = tmp3_0 + s1_683; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 684: dim3x3 mul
    gl64_t s1_684_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_684_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_684_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA684 = (tmp3_0 + tmp3_1) * (s1_684_0 + s1_684_1);
    gl64_t kB684 = (tmp3_0 + tmp3_2) * (s1_684_0 + s1_684_2);
    gl64_t kC684 = (tmp3_1 + tmp3_2) * (s1_684_1 + s1_684_2);
    gl64_t kD684 = tmp3_0 * s1_684_0;
    gl64_t kE684 = tmp3_1 * s1_684_1;
    gl64_t kF684 = tmp3_2 * s1_684_2;
    gl64_t kG684 = kD684 - kE684;
    tmp3_0 = (kC684 + kG684) - kF684;
    tmp3_1 = ((((kA684 + kC684) - kE684) - kE684) - kD684);
    tmp3_2 = kB684 - kG684;
    // Op 685: dim3x1 add
    gl64_t s1_685 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_685; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 686: dim3x3 mul
    gl64_t s1_686_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_686_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_686_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA686 = (tmp3_0 + tmp3_1) * (s1_686_0 + s1_686_1);
    gl64_t kB686 = (tmp3_0 + tmp3_2) * (s1_686_0 + s1_686_2);
    gl64_t kC686 = (tmp3_1 + tmp3_2) * (s1_686_1 + s1_686_2);
    gl64_t kD686 = tmp3_0 * s1_686_0;
    gl64_t kE686 = tmp3_1 * s1_686_1;
    gl64_t kF686 = tmp3_2 * s1_686_2;
    gl64_t kG686 = kD686 - kE686;
    tmp3_0 = (kC686 + kG686) - kF686;
    tmp3_1 = ((((kA686 + kC686) - kE686) - kE686) - kD686);
    tmp3_2 = kB686 - kG686;
    // Op 687: dim3x1 add
    gl64_t s1_687 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_687; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 688: dim3x3 add
    gl64_t s1_688_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_688_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_688_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_688_0; tmp3_1 = tmp3_1 + s1_688_1; tmp3_2 = tmp3_2 + s1_688_2;
    // Op 689: dim3x3 mul
    gl64_t s1_689_0 = *(gl64_t*)&expressions_params[10][140];
    gl64_t s1_689_1 = *(gl64_t*)&expressions_params[10][140+1];
    gl64_t s1_689_2 = *(gl64_t*)&expressions_params[10][140+2];
    gl64_t kA689 = (tmp3_0 + tmp3_1) * (s1_689_0 + s1_689_1);
    gl64_t kB689 = (tmp3_0 + tmp3_2) * (s1_689_0 + s1_689_2);
    gl64_t kC689 = (tmp3_1 + tmp3_2) * (s1_689_1 + s1_689_2);
    gl64_t kD689 = tmp3_0 * s1_689_0;
    gl64_t kE689 = tmp3_1 * s1_689_1;
    gl64_t kF689 = tmp3_2 * s1_689_2;
    gl64_t kG689 = kD689 - kE689;
    tmp3_0 = (kC689 + kG689) - kF689;
    tmp3_1 = ((((kA689 + kC689) - kE689) - kE689) - kD689);
    tmp3_2 = kB689 - kG689;
    // Op 690: dim1x1 sub
    gl64_t s0_690 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_690 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_690 - s1_690;
    // Op 691: dim1x1 sub_swap
    gl64_t s1_691 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_691 - tmp1_0;
    // Op 692: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 693: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 694: dim3x3 mul
    gl64_t s1_694_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_694_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_694_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA694 = (tmp3_0 + tmp3_1) * (s1_694_0 + s1_694_1);
    gl64_t kB694 = (tmp3_0 + tmp3_2) * (s1_694_0 + s1_694_2);
    gl64_t kC694 = (tmp3_1 + tmp3_2) * (s1_694_1 + s1_694_2);
    gl64_t kD694 = tmp3_0 * s1_694_0;
    gl64_t kE694 = tmp3_1 * s1_694_1;
    gl64_t kF694 = tmp3_2 * s1_694_2;
    gl64_t kG694 = kD694 - kE694;
    tmp3_6 = (kC694 + kG694) - kF694;
    tmp3_7 = ((((kA694 + kC694) - kE694) - kE694) - kD694);
    tmp3_8 = kB694 - kG694;
    // Op 695: dim1x1 sub
    gl64_t s1_695 = *(gl64_t*)&expressions_params[10][74];
    tmp1_0 = tmp1_4 - s1_695;
    // Op 696: dim1x1 sub
    gl64_t s1_696 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_696;
    // Op 697: dim3x1 mul
    gl64_t s0_697_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_697_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_697_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_697_0 * tmp1_0; tmp3_1 = s0_697_1 * tmp1_0; tmp3_2 = s0_697_2 * tmp1_0;
    // Op 698: dim3x1 add
    gl64_t s1_698 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_698; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 699: dim3x3 add
    gl64_t s1_699_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_699_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_699_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_699_0; tmp3_1 = tmp3_1 + s1_699_1; tmp3_2 = tmp3_2 + s1_699_2;
    // Op 700: dim3x3 mul
    gl64_t s1_700_0 = *(gl64_t*)&expressions_params[10][143];
    gl64_t s1_700_1 = *(gl64_t*)&expressions_params[10][143+1];
    gl64_t s1_700_2 = *(gl64_t*)&expressions_params[10][143+2];
    gl64_t kA700 = (tmp3_0 + tmp3_1) * (s1_700_0 + s1_700_1);
    gl64_t kB700 = (tmp3_0 + tmp3_2) * (s1_700_0 + s1_700_2);
    gl64_t kC700 = (tmp3_1 + tmp3_2) * (s1_700_1 + s1_700_2);
    gl64_t kD700 = tmp3_0 * s1_700_0;
    gl64_t kE700 = tmp3_1 * s1_700_1;
    gl64_t kF700 = tmp3_2 * s1_700_2;
    gl64_t kG700 = kD700 - kE700;
    tmp3_0 = (kC700 + kG700) - kF700;
    tmp3_1 = ((((kA700 + kC700) - kE700) - kE700) - kD700);
    tmp3_2 = kB700 - kG700;
    // Op 701: dim3x1 add
    gl64_t s1_701 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_701; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 702: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 703: dim3x3 mul
    gl64_t s1_703_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_703_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_703_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA703 = (tmp3_0 + tmp3_1) * (s1_703_0 + s1_703_1);
    gl64_t kB703 = (tmp3_0 + tmp3_2) * (s1_703_0 + s1_703_2);
    gl64_t kC703 = (tmp3_1 + tmp3_2) * (s1_703_1 + s1_703_2);
    gl64_t kD703 = tmp3_0 * s1_703_0;
    gl64_t kE703 = tmp3_1 * s1_703_1;
    gl64_t kF703 = tmp3_2 * s1_703_2;
    gl64_t kG703 = kD703 - kE703;
    tmp3_6 = (kC703 + kG703) - kF703;
    tmp3_7 = ((((kA703 + kC703) - kE703) - kE703) - kD703);
    tmp3_8 = kB703 - kG703;
    // Op 704: dim3x1 mul
    gl64_t s0_704_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_704_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_704_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_704 = *(gl64_t*)&expressions_params[10][17];
    tmp3_0 = s0_704_0 * s1_704; tmp3_1 = s0_704_1 * s1_704; tmp3_2 = s0_704_2 * s1_704;
    // Op 705: dim3x1 add
    gl64_t s1_705 = *(gl64_t*)&expressions_params[10][16];
    tmp3_0 = tmp3_0 + s1_705; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 706: dim3x3 mul
    gl64_t s1_706_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_706_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_706_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA706 = (tmp3_0 + tmp3_1) * (s1_706_0 + s1_706_1);
    gl64_t kB706 = (tmp3_0 + tmp3_2) * (s1_706_0 + s1_706_2);
    gl64_t kC706 = (tmp3_1 + tmp3_2) * (s1_706_1 + s1_706_2);
    gl64_t kD706 = tmp3_0 * s1_706_0;
    gl64_t kE706 = tmp3_1 * s1_706_1;
    gl64_t kF706 = tmp3_2 * s1_706_2;
    gl64_t kG706 = kD706 - kE706;
    tmp3_0 = (kC706 + kG706) - kF706;
    tmp3_1 = ((((kA706 + kC706) - kE706) - kE706) - kD706);
    tmp3_2 = kB706 - kG706;
    // Op 707: dim3x1 add
    gl64_t s1_707 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_707; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 708: dim3x3 mul
    gl64_t s1_708_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_708_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_708_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA708 = (tmp3_0 + tmp3_1) * (s1_708_0 + s1_708_1);
    gl64_t kB708 = (tmp3_0 + tmp3_2) * (s1_708_0 + s1_708_2);
    gl64_t kC708 = (tmp3_1 + tmp3_2) * (s1_708_1 + s1_708_2);
    gl64_t kD708 = tmp3_0 * s1_708_0;
    gl64_t kE708 = tmp3_1 * s1_708_1;
    gl64_t kF708 = tmp3_2 * s1_708_2;
    gl64_t kG708 = kD708 - kE708;
    tmp3_0 = (kC708 + kG708) - kF708;
    tmp3_1 = ((((kA708 + kC708) - kE708) - kE708) - kD708);
    tmp3_2 = kB708 - kG708;
    // Op 709: dim3x1 add
    gl64_t s1_709 = *(gl64_t*)&expressions_params[10][74];
    tmp3_0 = tmp3_0 + s1_709; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 710: dim3x3 mul
    gl64_t s1_710_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_710_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_710_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA710 = (tmp3_0 + tmp3_1) * (s1_710_0 + s1_710_1);
    gl64_t kB710 = (tmp3_0 + tmp3_2) * (s1_710_0 + s1_710_2);
    gl64_t kC710 = (tmp3_1 + tmp3_2) * (s1_710_1 + s1_710_2);
    gl64_t kD710 = tmp3_0 * s1_710_0;
    gl64_t kE710 = tmp3_1 * s1_710_1;
    gl64_t kF710 = tmp3_2 * s1_710_2;
    gl64_t kG710 = kD710 - kE710;
    tmp3_0 = (kC710 + kG710) - kF710;
    tmp3_1 = ((((kA710 + kC710) - kE710) - kE710) - kD710);
    tmp3_2 = kB710 - kG710;
    // Op 711: dim3x1 add
    gl64_t s1_711 = *(gl64_t*)&expressions_params[9][24];
    tmp3_0 = tmp3_0 + s1_711; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 712: dim3x3 mul
    gl64_t s1_712_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_712_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_712_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA712 = (tmp3_0 + tmp3_1) * (s1_712_0 + s1_712_1);
    gl64_t kB712 = (tmp3_0 + tmp3_2) * (s1_712_0 + s1_712_2);
    gl64_t kC712 = (tmp3_1 + tmp3_2) * (s1_712_1 + s1_712_2);
    gl64_t kD712 = tmp3_0 * s1_712_0;
    gl64_t kE712 = tmp3_1 * s1_712_1;
    gl64_t kF712 = tmp3_2 * s1_712_2;
    gl64_t kG712 = kD712 - kE712;
    tmp3_0 = (kC712 + kG712) - kF712;
    tmp3_1 = ((((kA712 + kC712) - kE712) - kE712) - kD712);
    tmp3_2 = kB712 - kG712;
    // Op 713: dim3x1 add
    gl64_t s1_713 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_713; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 714: dim3x3 mul
    gl64_t s1_714_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_714_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_714_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA714 = (tmp3_0 + tmp3_1) * (s1_714_0 + s1_714_1);
    gl64_t kB714 = (tmp3_0 + tmp3_2) * (s1_714_0 + s1_714_2);
    gl64_t kC714 = (tmp3_1 + tmp3_2) * (s1_714_1 + s1_714_2);
    gl64_t kD714 = tmp3_0 * s1_714_0;
    gl64_t kE714 = tmp3_1 * s1_714_1;
    gl64_t kF714 = tmp3_2 * s1_714_2;
    gl64_t kG714 = kD714 - kE714;
    tmp3_0 = (kC714 + kG714) - kF714;
    tmp3_1 = ((((kA714 + kC714) - kE714) - kE714) - kD714);
    tmp3_2 = kB714 - kG714;
    // Op 715: dim3x1 add
    gl64_t s1_715 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_715; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 716: dim3x3 add
    gl64_t s1_716_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_716_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_716_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_716_0; tmp3_1 = tmp3_1 + s1_716_1; tmp3_2 = tmp3_2 + s1_716_2;
    // Op 717: dim3x3 mul
    gl64_t s1_717_0 = *(gl64_t*)&expressions_params[10][146];
    gl64_t s1_717_1 = *(gl64_t*)&expressions_params[10][146+1];
    gl64_t s1_717_2 = *(gl64_t*)&expressions_params[10][146+2];
    gl64_t kA717 = (tmp3_0 + tmp3_1) * (s1_717_0 + s1_717_1);
    gl64_t kB717 = (tmp3_0 + tmp3_2) * (s1_717_0 + s1_717_2);
    gl64_t kC717 = (tmp3_1 + tmp3_2) * (s1_717_1 + s1_717_2);
    gl64_t kD717 = tmp3_0 * s1_717_0;
    gl64_t kE717 = tmp3_1 * s1_717_1;
    gl64_t kF717 = tmp3_2 * s1_717_2;
    gl64_t kG717 = kD717 - kE717;
    tmp3_0 = (kC717 + kG717) - kF717;
    tmp3_1 = ((((kA717 + kC717) - kE717) - kE717) - kD717);
    tmp3_2 = kB717 - kG717;
    // Op 718: dim3x1 sub
    gl64_t s1_718 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_718; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 719: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 720: dim3x3 mul
    gl64_t s1_720_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_720_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_720_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA720 = (tmp3_0 + tmp3_1) * (s1_720_0 + s1_720_1);
    gl64_t kB720 = (tmp3_0 + tmp3_2) * (s1_720_0 + s1_720_2);
    gl64_t kC720 = (tmp3_1 + tmp3_2) * (s1_720_1 + s1_720_2);
    gl64_t kD720 = tmp3_0 * s1_720_0;
    gl64_t kE720 = tmp3_1 * s1_720_1;
    gl64_t kF720 = tmp3_2 * s1_720_2;
    gl64_t kG720 = kD720 - kE720;
    tmp3_6 = (kC720 + kG720) - kF720;
    tmp3_7 = ((((kA720 + kC720) - kE720) - kE720) - kD720);
    tmp3_8 = kB720 - kG720;
    // Op 721: dim3x1 mul
    gl64_t s0_721_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_721_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_721_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_721 = *(gl64_t*)&expressions_params[10][17];
    tmp3_0 = s0_721_0 * s1_721; tmp3_1 = s0_721_1 * s1_721; tmp3_2 = s0_721_2 * s1_721;
    // Op 722: dim3x1 add
    gl64_t s1_722 = *(gl64_t*)&expressions_params[10][16];
    tmp3_0 = tmp3_0 + s1_722; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 723: dim3x3 mul
    gl64_t s1_723_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_723_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_723_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA723 = (tmp3_0 + tmp3_1) * (s1_723_0 + s1_723_1);
    gl64_t kB723 = (tmp3_0 + tmp3_2) * (s1_723_0 + s1_723_2);
    gl64_t kC723 = (tmp3_1 + tmp3_2) * (s1_723_1 + s1_723_2);
    gl64_t kD723 = tmp3_0 * s1_723_0;
    gl64_t kE723 = tmp3_1 * s1_723_1;
    gl64_t kF723 = tmp3_2 * s1_723_2;
    gl64_t kG723 = kD723 - kE723;
    tmp3_0 = (kC723 + kG723) - kF723;
    tmp3_1 = ((((kA723 + kC723) - kE723) - kE723) - kD723);
    tmp3_2 = kB723 - kG723;
    // Op 724: dim3x1 add
    gl64_t s1_724 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_724; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 725: dim3x3 mul
    gl64_t s1_725_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_725_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_725_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA725 = (tmp3_0 + tmp3_1) * (s1_725_0 + s1_725_1);
    gl64_t kB725 = (tmp3_0 + tmp3_2) * (s1_725_0 + s1_725_2);
    gl64_t kC725 = (tmp3_1 + tmp3_2) * (s1_725_1 + s1_725_2);
    gl64_t kD725 = tmp3_0 * s1_725_0;
    gl64_t kE725 = tmp3_1 * s1_725_1;
    gl64_t kF725 = tmp3_2 * s1_725_2;
    gl64_t kG725 = kD725 - kE725;
    tmp3_0 = (kC725 + kG725) - kF725;
    tmp3_1 = ((((kA725 + kC725) - kE725) - kE725) - kD725);
    tmp3_2 = kB725 - kG725;
    // Op 726: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 727: dim3x3 mul
    gl64_t s1_727_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_727_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_727_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA727 = (tmp3_0 + tmp3_1) * (s1_727_0 + s1_727_1);
    gl64_t kB727 = (tmp3_0 + tmp3_2) * (s1_727_0 + s1_727_2);
    gl64_t kC727 = (tmp3_1 + tmp3_2) * (s1_727_1 + s1_727_2);
    gl64_t kD727 = tmp3_0 * s1_727_0;
    gl64_t kE727 = tmp3_1 * s1_727_1;
    gl64_t kF727 = tmp3_2 * s1_727_2;
    gl64_t kG727 = kD727 - kE727;
    tmp3_0 = (kC727 + kG727) - kF727;
    tmp3_1 = ((((kA727 + kC727) - kE727) - kE727) - kD727);
    tmp3_2 = kB727 - kG727;
    // Op 728: dim3x1 add
    gl64_t s1_728 = *(gl64_t*)&expressions_params[9][24];
    tmp3_0 = tmp3_0 + s1_728; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 729: dim3x3 mul
    gl64_t s1_729_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_729_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_729_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA729 = (tmp3_0 + tmp3_1) * (s1_729_0 + s1_729_1);
    gl64_t kB729 = (tmp3_0 + tmp3_2) * (s1_729_0 + s1_729_2);
    gl64_t kC729 = (tmp3_1 + tmp3_2) * (s1_729_1 + s1_729_2);
    gl64_t kD729 = tmp3_0 * s1_729_0;
    gl64_t kE729 = tmp3_1 * s1_729_1;
    gl64_t kF729 = tmp3_2 * s1_729_2;
    gl64_t kG729 = kD729 - kE729;
    tmp3_0 = (kC729 + kG729) - kF729;
    tmp3_1 = ((((kA729 + kC729) - kE729) - kE729) - kD729);
    tmp3_2 = kB729 - kG729;
    // Op 730: dim3x1 add
    gl64_t s1_730 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_730; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 731: dim3x3 mul
    gl64_t s1_731_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_731_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_731_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA731 = (tmp3_0 + tmp3_1) * (s1_731_0 + s1_731_1);
    gl64_t kB731 = (tmp3_0 + tmp3_2) * (s1_731_0 + s1_731_2);
    gl64_t kC731 = (tmp3_1 + tmp3_2) * (s1_731_1 + s1_731_2);
    gl64_t kD731 = tmp3_0 * s1_731_0;
    gl64_t kE731 = tmp3_1 * s1_731_1;
    gl64_t kF731 = tmp3_2 * s1_731_2;
    gl64_t kG731 = kD731 - kE731;
    tmp3_0 = (kC731 + kG731) - kF731;
    tmp3_1 = ((((kA731 + kC731) - kE731) - kE731) - kD731);
    tmp3_2 = kB731 - kG731;
    // Op 732: dim3x1 add
    gl64_t s1_732 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_732; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 733: dim3x3 add
    gl64_t s1_733_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_733_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_733_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_733_0; tmp3_1 = tmp3_1 + s1_733_1; tmp3_2 = tmp3_2 + s1_733_2;
    // Op 734: dim3x3 mul
    gl64_t s1_734_0 = *(gl64_t*)&expressions_params[10][149];
    gl64_t s1_734_1 = *(gl64_t*)&expressions_params[10][149+1];
    gl64_t s1_734_2 = *(gl64_t*)&expressions_params[10][149+2];
    gl64_t kA734 = (tmp3_0 + tmp3_1) * (s1_734_0 + s1_734_1);
    gl64_t kB734 = (tmp3_0 + tmp3_2) * (s1_734_0 + s1_734_2);
    gl64_t kC734 = (tmp3_1 + tmp3_2) * (s1_734_1 + s1_734_2);
    gl64_t kD734 = tmp3_0 * s1_734_0;
    gl64_t kE734 = tmp3_1 * s1_734_1;
    gl64_t kF734 = tmp3_2 * s1_734_2;
    gl64_t kG734 = kD734 - kE734;
    tmp3_0 = (kC734 + kG734) - kF734;
    tmp3_1 = ((((kA734 + kC734) - kE734) - kE734) - kD734);
    tmp3_2 = kB734 - kG734;
    // Op 735: dim1x1 sub
    gl64_t s0_735 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_735 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_735 - s1_735;
    // Op 736: dim1x1 sub_swap
    gl64_t s1_736 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_736 - tmp1_0;
    // Op 737: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 738: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 739: dim3x3 mul
    gl64_t s1_739_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_739_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_739_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA739 = (tmp3_0 + tmp3_1) * (s1_739_0 + s1_739_1);
    gl64_t kB739 = (tmp3_0 + tmp3_2) * (s1_739_0 + s1_739_2);
    gl64_t kC739 = (tmp3_1 + tmp3_2) * (s1_739_1 + s1_739_2);
    gl64_t kD739 = tmp3_0 * s1_739_0;
    gl64_t kE739 = tmp3_1 * s1_739_1;
    gl64_t kF739 = tmp3_2 * s1_739_2;
    gl64_t kG739 = kD739 - kE739;
    tmp3_6 = (kC739 + kG739) - kF739;
    tmp3_7 = ((((kA739 + kC739) - kE739) - kE739) - kD739);
    tmp3_8 = kB739 - kG739;
    // Op 740: dim1x1 sub
    gl64_t s1_740 = *(gl64_t*)&expressions_params[10][75];
    tmp1_0 = tmp1_4 - s1_740;
    // Op 741: dim1x1 sub
    gl64_t s1_741 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_741;
    // Op 742: dim3x1 mul
    gl64_t s0_742_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_742_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_742_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_742_0 * tmp1_0; tmp3_1 = s0_742_1 * tmp1_0; tmp3_2 = s0_742_2 * tmp1_0;
    // Op 743: dim3x1 add
    gl64_t s1_743 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_743; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 744: dim3x3 add
    gl64_t s1_744_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_744_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_744_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_744_0; tmp3_1 = tmp3_1 + s1_744_1; tmp3_2 = tmp3_2 + s1_744_2;
    // Op 745: dim3x3 mul
    gl64_t s1_745_0 = *(gl64_t*)&expressions_params[10][152];
    gl64_t s1_745_1 = *(gl64_t*)&expressions_params[10][152+1];
    gl64_t s1_745_2 = *(gl64_t*)&expressions_params[10][152+2];
    gl64_t kA745 = (tmp3_0 + tmp3_1) * (s1_745_0 + s1_745_1);
    gl64_t kB745 = (tmp3_0 + tmp3_2) * (s1_745_0 + s1_745_2);
    gl64_t kC745 = (tmp3_1 + tmp3_2) * (s1_745_1 + s1_745_2);
    gl64_t kD745 = tmp3_0 * s1_745_0;
    gl64_t kE745 = tmp3_1 * s1_745_1;
    gl64_t kF745 = tmp3_2 * s1_745_2;
    gl64_t kG745 = kD745 - kE745;
    tmp3_0 = (kC745 + kG745) - kF745;
    tmp3_1 = ((((kA745 + kC745) - kE745) - kE745) - kD745);
    tmp3_2 = kB745 - kG745;
    // Op 746: dim3x1 add
    gl64_t s1_746 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_746; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 747: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 748: dim3x3 mul
    gl64_t s1_748_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_748_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_748_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA748 = (tmp3_0 + tmp3_1) * (s1_748_0 + s1_748_1);
    gl64_t kB748 = (tmp3_0 + tmp3_2) * (s1_748_0 + s1_748_2);
    gl64_t kC748 = (tmp3_1 + tmp3_2) * (s1_748_1 + s1_748_2);
    gl64_t kD748 = tmp3_0 * s1_748_0;
    gl64_t kE748 = tmp3_1 * s1_748_1;
    gl64_t kF748 = tmp3_2 * s1_748_2;
    gl64_t kG748 = kD748 - kE748;
    tmp3_6 = (kC748 + kG748) - kF748;
    tmp3_7 = ((((kA748 + kC748) - kE748) - kE748) - kD748);
    tmp3_8 = kB748 - kG748;
    // Op 749: dim3x1 mul
    gl64_t s0_749_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_749_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_749_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_749 = *(gl64_t*)&expressions_params[10][19];
    tmp3_0 = s0_749_0 * s1_749; tmp3_1 = s0_749_1 * s1_749; tmp3_2 = s0_749_2 * s1_749;
    // Op 750: dim3x1 add
    gl64_t s1_750 = *(gl64_t*)&expressions_params[10][18];
    tmp3_0 = tmp3_0 + s1_750; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 751: dim3x3 mul
    gl64_t s1_751_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_751_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_751_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA751 = (tmp3_0 + tmp3_1) * (s1_751_0 + s1_751_1);
    gl64_t kB751 = (tmp3_0 + tmp3_2) * (s1_751_0 + s1_751_2);
    gl64_t kC751 = (tmp3_1 + tmp3_2) * (s1_751_1 + s1_751_2);
    gl64_t kD751 = tmp3_0 * s1_751_0;
    gl64_t kE751 = tmp3_1 * s1_751_1;
    gl64_t kF751 = tmp3_2 * s1_751_2;
    gl64_t kG751 = kD751 - kE751;
    tmp3_0 = (kC751 + kG751) - kF751;
    tmp3_1 = ((((kA751 + kC751) - kE751) - kE751) - kD751);
    tmp3_2 = kB751 - kG751;
    // Op 752: dim3x1 add
    gl64_t s1_752 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_752; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 753: dim3x3 mul
    gl64_t s1_753_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_753_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_753_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA753 = (tmp3_0 + tmp3_1) * (s1_753_0 + s1_753_1);
    gl64_t kB753 = (tmp3_0 + tmp3_2) * (s1_753_0 + s1_753_2);
    gl64_t kC753 = (tmp3_1 + tmp3_2) * (s1_753_1 + s1_753_2);
    gl64_t kD753 = tmp3_0 * s1_753_0;
    gl64_t kE753 = tmp3_1 * s1_753_1;
    gl64_t kF753 = tmp3_2 * s1_753_2;
    gl64_t kG753 = kD753 - kE753;
    tmp3_0 = (kC753 + kG753) - kF753;
    tmp3_1 = ((((kA753 + kC753) - kE753) - kE753) - kD753);
    tmp3_2 = kB753 - kG753;
    // Op 754: dim3x1 add
    gl64_t s1_754 = *(gl64_t*)&expressions_params[10][75];
    tmp3_0 = tmp3_0 + s1_754; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 755: dim3x3 mul
    gl64_t s1_755_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_755_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_755_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA755 = (tmp3_0 + tmp3_1) * (s1_755_0 + s1_755_1);
    gl64_t kB755 = (tmp3_0 + tmp3_2) * (s1_755_0 + s1_755_2);
    gl64_t kC755 = (tmp3_1 + tmp3_2) * (s1_755_1 + s1_755_2);
    gl64_t kD755 = tmp3_0 * s1_755_0;
    gl64_t kE755 = tmp3_1 * s1_755_1;
    gl64_t kF755 = tmp3_2 * s1_755_2;
    gl64_t kG755 = kD755 - kE755;
    tmp3_0 = (kC755 + kG755) - kF755;
    tmp3_1 = ((((kA755 + kC755) - kE755) - kE755) - kD755);
    tmp3_2 = kB755 - kG755;
    // Op 756: dim3x1 add
    gl64_t s1_756 = *(gl64_t*)&expressions_params[9][25];
    tmp3_0 = tmp3_0 + s1_756; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 757: dim3x3 mul
    gl64_t s1_757_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_757_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_757_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA757 = (tmp3_0 + tmp3_1) * (s1_757_0 + s1_757_1);
    gl64_t kB757 = (tmp3_0 + tmp3_2) * (s1_757_0 + s1_757_2);
    gl64_t kC757 = (tmp3_1 + tmp3_2) * (s1_757_1 + s1_757_2);
    gl64_t kD757 = tmp3_0 * s1_757_0;
    gl64_t kE757 = tmp3_1 * s1_757_1;
    gl64_t kF757 = tmp3_2 * s1_757_2;
    gl64_t kG757 = kD757 - kE757;
    tmp3_0 = (kC757 + kG757) - kF757;
    tmp3_1 = ((((kA757 + kC757) - kE757) - kE757) - kD757);
    tmp3_2 = kB757 - kG757;
    // Op 758: dim3x1 add
    gl64_t s1_758 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_758; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 759: dim3x3 mul
    gl64_t s1_759_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_759_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_759_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA759 = (tmp3_0 + tmp3_1) * (s1_759_0 + s1_759_1);
    gl64_t kB759 = (tmp3_0 + tmp3_2) * (s1_759_0 + s1_759_2);
    gl64_t kC759 = (tmp3_1 + tmp3_2) * (s1_759_1 + s1_759_2);
    gl64_t kD759 = tmp3_0 * s1_759_0;
    gl64_t kE759 = tmp3_1 * s1_759_1;
    gl64_t kF759 = tmp3_2 * s1_759_2;
    gl64_t kG759 = kD759 - kE759;
    tmp3_0 = (kC759 + kG759) - kF759;
    tmp3_1 = ((((kA759 + kC759) - kE759) - kE759) - kD759);
    tmp3_2 = kB759 - kG759;
    // Op 760: dim3x1 add
    gl64_t s1_760 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_760; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 761: dim3x3 add
    gl64_t s1_761_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_761_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_761_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_761_0; tmp3_1 = tmp3_1 + s1_761_1; tmp3_2 = tmp3_2 + s1_761_2;
    // Op 762: dim3x3 mul
    gl64_t s1_762_0 = *(gl64_t*)&expressions_params[10][155];
    gl64_t s1_762_1 = *(gl64_t*)&expressions_params[10][155+1];
    gl64_t s1_762_2 = *(gl64_t*)&expressions_params[10][155+2];
    gl64_t kA762 = (tmp3_0 + tmp3_1) * (s1_762_0 + s1_762_1);
    gl64_t kB762 = (tmp3_0 + tmp3_2) * (s1_762_0 + s1_762_2);
    gl64_t kC762 = (tmp3_1 + tmp3_2) * (s1_762_1 + s1_762_2);
    gl64_t kD762 = tmp3_0 * s1_762_0;
    gl64_t kE762 = tmp3_1 * s1_762_1;
    gl64_t kF762 = tmp3_2 * s1_762_2;
    gl64_t kG762 = kD762 - kE762;
    tmp3_0 = (kC762 + kG762) - kF762;
    tmp3_1 = ((((kA762 + kC762) - kE762) - kE762) - kD762);
    tmp3_2 = kB762 - kG762;
    // Op 763: dim3x1 sub
    gl64_t s1_763 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_763; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 764: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 765: dim3x3 mul
    gl64_t s1_765_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_765_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_765_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA765 = (tmp3_0 + tmp3_1) * (s1_765_0 + s1_765_1);
    gl64_t kB765 = (tmp3_0 + tmp3_2) * (s1_765_0 + s1_765_2);
    gl64_t kC765 = (tmp3_1 + tmp3_2) * (s1_765_1 + s1_765_2);
    gl64_t kD765 = tmp3_0 * s1_765_0;
    gl64_t kE765 = tmp3_1 * s1_765_1;
    gl64_t kF765 = tmp3_2 * s1_765_2;
    gl64_t kG765 = kD765 - kE765;
    tmp3_6 = (kC765 + kG765) - kF765;
    tmp3_7 = ((((kA765 + kC765) - kE765) - kE765) - kD765);
    tmp3_8 = kB765 - kG765;
    // Op 766: dim3x1 mul
    gl64_t s0_766_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_766_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_766_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_766 = *(gl64_t*)&expressions_params[10][19];
    tmp3_0 = s0_766_0 * s1_766; tmp3_1 = s0_766_1 * s1_766; tmp3_2 = s0_766_2 * s1_766;
    // Op 767: dim3x1 add
    gl64_t s1_767 = *(gl64_t*)&expressions_params[10][18];
    tmp3_0 = tmp3_0 + s1_767; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 768: dim3x3 mul
    gl64_t s1_768_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_768_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_768_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA768 = (tmp3_0 + tmp3_1) * (s1_768_0 + s1_768_1);
    gl64_t kB768 = (tmp3_0 + tmp3_2) * (s1_768_0 + s1_768_2);
    gl64_t kC768 = (tmp3_1 + tmp3_2) * (s1_768_1 + s1_768_2);
    gl64_t kD768 = tmp3_0 * s1_768_0;
    gl64_t kE768 = tmp3_1 * s1_768_1;
    gl64_t kF768 = tmp3_2 * s1_768_2;
    gl64_t kG768 = kD768 - kE768;
    tmp3_0 = (kC768 + kG768) - kF768;
    tmp3_1 = ((((kA768 + kC768) - kE768) - kE768) - kD768);
    tmp3_2 = kB768 - kG768;
    // Op 769: dim3x1 add
    gl64_t s1_769 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_769; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 770: dim3x3 mul
    gl64_t s1_770_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_770_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_770_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA770 = (tmp3_0 + tmp3_1) * (s1_770_0 + s1_770_1);
    gl64_t kB770 = (tmp3_0 + tmp3_2) * (s1_770_0 + s1_770_2);
    gl64_t kC770 = (tmp3_1 + tmp3_2) * (s1_770_1 + s1_770_2);
    gl64_t kD770 = tmp3_0 * s1_770_0;
    gl64_t kE770 = tmp3_1 * s1_770_1;
    gl64_t kF770 = tmp3_2 * s1_770_2;
    gl64_t kG770 = kD770 - kE770;
    tmp3_0 = (kC770 + kG770) - kF770;
    tmp3_1 = ((((kA770 + kC770) - kE770) - kE770) - kD770);
    tmp3_2 = kB770 - kG770;
    // Op 771: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 772: dim3x3 mul
    gl64_t s1_772_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_772_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_772_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA772 = (tmp3_0 + tmp3_1) * (s1_772_0 + s1_772_1);
    gl64_t kB772 = (tmp3_0 + tmp3_2) * (s1_772_0 + s1_772_2);
    gl64_t kC772 = (tmp3_1 + tmp3_2) * (s1_772_1 + s1_772_2);
    gl64_t kD772 = tmp3_0 * s1_772_0;
    gl64_t kE772 = tmp3_1 * s1_772_1;
    gl64_t kF772 = tmp3_2 * s1_772_2;
    gl64_t kG772 = kD772 - kE772;
    tmp3_0 = (kC772 + kG772) - kF772;
    tmp3_1 = ((((kA772 + kC772) - kE772) - kE772) - kD772);
    tmp3_2 = kB772 - kG772;
    // Op 773: dim3x1 add
    gl64_t s1_773 = *(gl64_t*)&expressions_params[9][25];
    tmp3_0 = tmp3_0 + s1_773; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 774: dim3x3 mul
    gl64_t s1_774_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_774_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_774_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA774 = (tmp3_0 + tmp3_1) * (s1_774_0 + s1_774_1);
    gl64_t kB774 = (tmp3_0 + tmp3_2) * (s1_774_0 + s1_774_2);
    gl64_t kC774 = (tmp3_1 + tmp3_2) * (s1_774_1 + s1_774_2);
    gl64_t kD774 = tmp3_0 * s1_774_0;
    gl64_t kE774 = tmp3_1 * s1_774_1;
    gl64_t kF774 = tmp3_2 * s1_774_2;
    gl64_t kG774 = kD774 - kE774;
    tmp3_0 = (kC774 + kG774) - kF774;
    tmp3_1 = ((((kA774 + kC774) - kE774) - kE774) - kD774);
    tmp3_2 = kB774 - kG774;
    // Op 775: dim3x1 add
    gl64_t s1_775 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_775; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 776: dim3x3 mul
    gl64_t s1_776_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_776_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_776_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA776 = (tmp3_0 + tmp3_1) * (s1_776_0 + s1_776_1);
    gl64_t kB776 = (tmp3_0 + tmp3_2) * (s1_776_0 + s1_776_2);
    gl64_t kC776 = (tmp3_1 + tmp3_2) * (s1_776_1 + s1_776_2);
    gl64_t kD776 = tmp3_0 * s1_776_0;
    gl64_t kE776 = tmp3_1 * s1_776_1;
    gl64_t kF776 = tmp3_2 * s1_776_2;
    gl64_t kG776 = kD776 - kE776;
    tmp3_0 = (kC776 + kG776) - kF776;
    tmp3_1 = ((((kA776 + kC776) - kE776) - kE776) - kD776);
    tmp3_2 = kB776 - kG776;
    // Op 777: dim3x1 add
    gl64_t s1_777 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_777; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 778: dim3x3 add
    gl64_t s1_778_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_778_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_778_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_778_0; tmp3_1 = tmp3_1 + s1_778_1; tmp3_2 = tmp3_2 + s1_778_2;
    // Op 779: dim3x3 mul
    gl64_t s1_779_0 = *(gl64_t*)&expressions_params[10][158];
    gl64_t s1_779_1 = *(gl64_t*)&expressions_params[10][158+1];
    gl64_t s1_779_2 = *(gl64_t*)&expressions_params[10][158+2];
    gl64_t kA779 = (tmp3_0 + tmp3_1) * (s1_779_0 + s1_779_1);
    gl64_t kB779 = (tmp3_0 + tmp3_2) * (s1_779_0 + s1_779_2);
    gl64_t kC779 = (tmp3_1 + tmp3_2) * (s1_779_1 + s1_779_2);
    gl64_t kD779 = tmp3_0 * s1_779_0;
    gl64_t kE779 = tmp3_1 * s1_779_1;
    gl64_t kF779 = tmp3_2 * s1_779_2;
    gl64_t kG779 = kD779 - kE779;
    tmp3_0 = (kC779 + kG779) - kF779;
    tmp3_1 = ((((kA779 + kC779) - kE779) - kE779) - kD779);
    tmp3_2 = kB779 - kG779;
    // Op 780: dim1x1 sub
    gl64_t s0_780 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_780 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_780 - s1_780;
    // Op 781: dim1x1 sub_swap
    gl64_t s1_781 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_781 - tmp1_0;
    // Op 782: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 783: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 784: dim3x3 mul
    gl64_t s1_784_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_784_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_784_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA784 = (tmp3_0 + tmp3_1) * (s1_784_0 + s1_784_1);
    gl64_t kB784 = (tmp3_0 + tmp3_2) * (s1_784_0 + s1_784_2);
    gl64_t kC784 = (tmp3_1 + tmp3_2) * (s1_784_1 + s1_784_2);
    gl64_t kD784 = tmp3_0 * s1_784_0;
    gl64_t kE784 = tmp3_1 * s1_784_1;
    gl64_t kF784 = tmp3_2 * s1_784_2;
    gl64_t kG784 = kD784 - kE784;
    tmp3_6 = (kC784 + kG784) - kF784;
    tmp3_7 = ((((kA784 + kC784) - kE784) - kE784) - kD784);
    tmp3_8 = kB784 - kG784;
    // Op 785: dim1x1 sub
    gl64_t s1_785 = *(gl64_t*)&expressions_params[10][76];
    tmp1_0 = tmp1_4 - s1_785;
    // Op 786: dim1x1 sub
    gl64_t s1_786 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_786;
    // Op 787: dim3x1 mul
    gl64_t s0_787_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_787_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_787_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_787_0 * tmp1_0; tmp3_1 = s0_787_1 * tmp1_0; tmp3_2 = s0_787_2 * tmp1_0;
    // Op 788: dim3x1 add
    gl64_t s1_788 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_788; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 789: dim3x3 add
    gl64_t s1_789_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_789_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_789_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_789_0; tmp3_1 = tmp3_1 + s1_789_1; tmp3_2 = tmp3_2 + s1_789_2;
    // Op 790: dim3x3 mul
    gl64_t s1_790_0 = *(gl64_t*)&expressions_params[10][161];
    gl64_t s1_790_1 = *(gl64_t*)&expressions_params[10][161+1];
    gl64_t s1_790_2 = *(gl64_t*)&expressions_params[10][161+2];
    gl64_t kA790 = (tmp3_0 + tmp3_1) * (s1_790_0 + s1_790_1);
    gl64_t kB790 = (tmp3_0 + tmp3_2) * (s1_790_0 + s1_790_2);
    gl64_t kC790 = (tmp3_1 + tmp3_2) * (s1_790_1 + s1_790_2);
    gl64_t kD790 = tmp3_0 * s1_790_0;
    gl64_t kE790 = tmp3_1 * s1_790_1;
    gl64_t kF790 = tmp3_2 * s1_790_2;
    gl64_t kG790 = kD790 - kE790;
    tmp3_0 = (kC790 + kG790) - kF790;
    tmp3_1 = ((((kA790 + kC790) - kE790) - kE790) - kD790);
    tmp3_2 = kB790 - kG790;
    // Op 791: dim3x1 add
    gl64_t s1_791 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_791; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 792: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 793: dim3x3 mul
    gl64_t s1_793_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_793_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_793_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA793 = (tmp3_0 + tmp3_1) * (s1_793_0 + s1_793_1);
    gl64_t kB793 = (tmp3_0 + tmp3_2) * (s1_793_0 + s1_793_2);
    gl64_t kC793 = (tmp3_1 + tmp3_2) * (s1_793_1 + s1_793_2);
    gl64_t kD793 = tmp3_0 * s1_793_0;
    gl64_t kE793 = tmp3_1 * s1_793_1;
    gl64_t kF793 = tmp3_2 * s1_793_2;
    gl64_t kG793 = kD793 - kE793;
    tmp3_6 = (kC793 + kG793) - kF793;
    tmp3_7 = ((((kA793 + kC793) - kE793) - kE793) - kD793);
    tmp3_8 = kB793 - kG793;
    // Op 794: dim3x1 mul
    gl64_t s0_794_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_794_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_794_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_794 = *(gl64_t*)&expressions_params[10][21];
    tmp3_0 = s0_794_0 * s1_794; tmp3_1 = s0_794_1 * s1_794; tmp3_2 = s0_794_2 * s1_794;
    // Op 795: dim3x1 add
    gl64_t s1_795 = *(gl64_t*)&expressions_params[10][20];
    tmp3_0 = tmp3_0 + s1_795; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 796: dim3x3 mul
    gl64_t s1_796_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_796_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_796_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA796 = (tmp3_0 + tmp3_1) * (s1_796_0 + s1_796_1);
    gl64_t kB796 = (tmp3_0 + tmp3_2) * (s1_796_0 + s1_796_2);
    gl64_t kC796 = (tmp3_1 + tmp3_2) * (s1_796_1 + s1_796_2);
    gl64_t kD796 = tmp3_0 * s1_796_0;
    gl64_t kE796 = tmp3_1 * s1_796_1;
    gl64_t kF796 = tmp3_2 * s1_796_2;
    gl64_t kG796 = kD796 - kE796;
    tmp3_0 = (kC796 + kG796) - kF796;
    tmp3_1 = ((((kA796 + kC796) - kE796) - kE796) - kD796);
    tmp3_2 = kB796 - kG796;
    // Op 797: dim3x1 add
    gl64_t s1_797 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_797; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 798: dim3x3 mul
    gl64_t s1_798_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_798_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_798_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA798 = (tmp3_0 + tmp3_1) * (s1_798_0 + s1_798_1);
    gl64_t kB798 = (tmp3_0 + tmp3_2) * (s1_798_0 + s1_798_2);
    gl64_t kC798 = (tmp3_1 + tmp3_2) * (s1_798_1 + s1_798_2);
    gl64_t kD798 = tmp3_0 * s1_798_0;
    gl64_t kE798 = tmp3_1 * s1_798_1;
    gl64_t kF798 = tmp3_2 * s1_798_2;
    gl64_t kG798 = kD798 - kE798;
    tmp3_0 = (kC798 + kG798) - kF798;
    tmp3_1 = ((((kA798 + kC798) - kE798) - kE798) - kD798);
    tmp3_2 = kB798 - kG798;
    // Op 799: dim3x1 add
    gl64_t s1_799 = *(gl64_t*)&expressions_params[10][76];
    tmp3_0 = tmp3_0 + s1_799; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 800: dim3x3 mul
    gl64_t s1_800_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_800_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_800_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA800 = (tmp3_0 + tmp3_1) * (s1_800_0 + s1_800_1);
    gl64_t kB800 = (tmp3_0 + tmp3_2) * (s1_800_0 + s1_800_2);
    gl64_t kC800 = (tmp3_1 + tmp3_2) * (s1_800_1 + s1_800_2);
    gl64_t kD800 = tmp3_0 * s1_800_0;
    gl64_t kE800 = tmp3_1 * s1_800_1;
    gl64_t kF800 = tmp3_2 * s1_800_2;
    gl64_t kG800 = kD800 - kE800;
    tmp3_0 = (kC800 + kG800) - kF800;
    tmp3_1 = ((((kA800 + kC800) - kE800) - kE800) - kD800);
    tmp3_2 = kB800 - kG800;
    // Op 801: dim3x1 add
    gl64_t s1_801 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_801; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 802: dim3x3 mul
    gl64_t s1_802_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_802_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_802_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA802 = (tmp3_0 + tmp3_1) * (s1_802_0 + s1_802_1);
    gl64_t kB802 = (tmp3_0 + tmp3_2) * (s1_802_0 + s1_802_2);
    gl64_t kC802 = (tmp3_1 + tmp3_2) * (s1_802_1 + s1_802_2);
    gl64_t kD802 = tmp3_0 * s1_802_0;
    gl64_t kE802 = tmp3_1 * s1_802_1;
    gl64_t kF802 = tmp3_2 * s1_802_2;
    gl64_t kG802 = kD802 - kE802;
    tmp3_0 = (kC802 + kG802) - kF802;
    tmp3_1 = ((((kA802 + kC802) - kE802) - kE802) - kD802);
    tmp3_2 = kB802 - kG802;
    // Op 803: dim3x1 add
    gl64_t s1_803 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_803; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 804: dim3x3 mul
    gl64_t s1_804_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_804_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_804_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA804 = (tmp3_0 + tmp3_1) * (s1_804_0 + s1_804_1);
    gl64_t kB804 = (tmp3_0 + tmp3_2) * (s1_804_0 + s1_804_2);
    gl64_t kC804 = (tmp3_1 + tmp3_2) * (s1_804_1 + s1_804_2);
    gl64_t kD804 = tmp3_0 * s1_804_0;
    gl64_t kE804 = tmp3_1 * s1_804_1;
    gl64_t kF804 = tmp3_2 * s1_804_2;
    gl64_t kG804 = kD804 - kE804;
    tmp3_0 = (kC804 + kG804) - kF804;
    tmp3_1 = ((((kA804 + kC804) - kE804) - kE804) - kD804);
    tmp3_2 = kB804 - kG804;
    // Op 805: dim3x1 add
    gl64_t s1_805 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_805; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 806: dim3x3 add
    gl64_t s1_806_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_806_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_806_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_806_0; tmp3_1 = tmp3_1 + s1_806_1; tmp3_2 = tmp3_2 + s1_806_2;
    // Op 807: dim3x3 mul
    gl64_t s1_807_0 = *(gl64_t*)&expressions_params[10][164];
    gl64_t s1_807_1 = *(gl64_t*)&expressions_params[10][164+1];
    gl64_t s1_807_2 = *(gl64_t*)&expressions_params[10][164+2];
    gl64_t kA807 = (tmp3_0 + tmp3_1) * (s1_807_0 + s1_807_1);
    gl64_t kB807 = (tmp3_0 + tmp3_2) * (s1_807_0 + s1_807_2);
    gl64_t kC807 = (tmp3_1 + tmp3_2) * (s1_807_1 + s1_807_2);
    gl64_t kD807 = tmp3_0 * s1_807_0;
    gl64_t kE807 = tmp3_1 * s1_807_1;
    gl64_t kF807 = tmp3_2 * s1_807_2;
    gl64_t kG807 = kD807 - kE807;
    tmp3_0 = (kC807 + kG807) - kF807;
    tmp3_1 = ((((kA807 + kC807) - kE807) - kE807) - kD807);
    tmp3_2 = kB807 - kG807;
    // Op 808: dim3x1 sub
    gl64_t s1_808 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_808; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 809: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 810: dim3x3 mul
    gl64_t s1_810_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_810_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_810_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA810 = (tmp3_0 + tmp3_1) * (s1_810_0 + s1_810_1);
    gl64_t kB810 = (tmp3_0 + tmp3_2) * (s1_810_0 + s1_810_2);
    gl64_t kC810 = (tmp3_1 + tmp3_2) * (s1_810_1 + s1_810_2);
    gl64_t kD810 = tmp3_0 * s1_810_0;
    gl64_t kE810 = tmp3_1 * s1_810_1;
    gl64_t kF810 = tmp3_2 * s1_810_2;
    gl64_t kG810 = kD810 - kE810;
    tmp3_6 = (kC810 + kG810) - kF810;
    tmp3_7 = ((((kA810 + kC810) - kE810) - kE810) - kD810);
    tmp3_8 = kB810 - kG810;
    // Op 811: dim3x1 mul
    gl64_t s0_811_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_811_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_811_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_811 = *(gl64_t*)&expressions_params[10][21];
    tmp3_0 = s0_811_0 * s1_811; tmp3_1 = s0_811_1 * s1_811; tmp3_2 = s0_811_2 * s1_811;
    // Op 812: dim3x1 add
    gl64_t s1_812 = *(gl64_t*)&expressions_params[10][20];
    tmp3_0 = tmp3_0 + s1_812; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 813: dim3x3 mul
    gl64_t s1_813_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_813_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_813_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA813 = (tmp3_0 + tmp3_1) * (s1_813_0 + s1_813_1);
    gl64_t kB813 = (tmp3_0 + tmp3_2) * (s1_813_0 + s1_813_2);
    gl64_t kC813 = (tmp3_1 + tmp3_2) * (s1_813_1 + s1_813_2);
    gl64_t kD813 = tmp3_0 * s1_813_0;
    gl64_t kE813 = tmp3_1 * s1_813_1;
    gl64_t kF813 = tmp3_2 * s1_813_2;
    gl64_t kG813 = kD813 - kE813;
    tmp3_0 = (kC813 + kG813) - kF813;
    tmp3_1 = ((((kA813 + kC813) - kE813) - kE813) - kD813);
    tmp3_2 = kB813 - kG813;
    // Op 814: dim3x1 add
    gl64_t s1_814 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_814; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 815: dim3x3 mul
    gl64_t s1_815_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_815_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_815_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA815 = (tmp3_0 + tmp3_1) * (s1_815_0 + s1_815_1);
    gl64_t kB815 = (tmp3_0 + tmp3_2) * (s1_815_0 + s1_815_2);
    gl64_t kC815 = (tmp3_1 + tmp3_2) * (s1_815_1 + s1_815_2);
    gl64_t kD815 = tmp3_0 * s1_815_0;
    gl64_t kE815 = tmp3_1 * s1_815_1;
    gl64_t kF815 = tmp3_2 * s1_815_2;
    gl64_t kG815 = kD815 - kE815;
    tmp3_0 = (kC815 + kG815) - kF815;
    tmp3_1 = ((((kA815 + kC815) - kE815) - kE815) - kD815);
    tmp3_2 = kB815 - kG815;
    // Op 816: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 817: dim3x3 mul
    gl64_t s1_817_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_817_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_817_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA817 = (tmp3_0 + tmp3_1) * (s1_817_0 + s1_817_1);
    gl64_t kB817 = (tmp3_0 + tmp3_2) * (s1_817_0 + s1_817_2);
    gl64_t kC817 = (tmp3_1 + tmp3_2) * (s1_817_1 + s1_817_2);
    gl64_t kD817 = tmp3_0 * s1_817_0;
    gl64_t kE817 = tmp3_1 * s1_817_1;
    gl64_t kF817 = tmp3_2 * s1_817_2;
    gl64_t kG817 = kD817 - kE817;
    tmp3_0 = (kC817 + kG817) - kF817;
    tmp3_1 = ((((kA817 + kC817) - kE817) - kE817) - kD817);
    tmp3_2 = kB817 - kG817;
    // Op 818: dim3x1 add
    gl64_t s1_818 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_818; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 819: dim3x3 mul
    gl64_t s1_819_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_819_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_819_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA819 = (tmp3_0 + tmp3_1) * (s1_819_0 + s1_819_1);
    gl64_t kB819 = (tmp3_0 + tmp3_2) * (s1_819_0 + s1_819_2);
    gl64_t kC819 = (tmp3_1 + tmp3_2) * (s1_819_1 + s1_819_2);
    gl64_t kD819 = tmp3_0 * s1_819_0;
    gl64_t kE819 = tmp3_1 * s1_819_1;
    gl64_t kF819 = tmp3_2 * s1_819_2;
    gl64_t kG819 = kD819 - kE819;
    tmp3_0 = (kC819 + kG819) - kF819;
    tmp3_1 = ((((kA819 + kC819) - kE819) - kE819) - kD819);
    tmp3_2 = kB819 - kG819;
    // Op 820: dim3x1 add
    gl64_t s1_820 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_820; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 821: dim3x3 mul
    gl64_t s1_821_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_821_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_821_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA821 = (tmp3_0 + tmp3_1) * (s1_821_0 + s1_821_1);
    gl64_t kB821 = (tmp3_0 + tmp3_2) * (s1_821_0 + s1_821_2);
    gl64_t kC821 = (tmp3_1 + tmp3_2) * (s1_821_1 + s1_821_2);
    gl64_t kD821 = tmp3_0 * s1_821_0;
    gl64_t kE821 = tmp3_1 * s1_821_1;
    gl64_t kF821 = tmp3_2 * s1_821_2;
    gl64_t kG821 = kD821 - kE821;
    tmp3_0 = (kC821 + kG821) - kF821;
    tmp3_1 = ((((kA821 + kC821) - kE821) - kE821) - kD821);
    tmp3_2 = kB821 - kG821;
    // Op 822: dim3x1 add
    gl64_t s1_822 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_822; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 823: dim3x3 add
    gl64_t s1_823_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_823_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_823_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_823_0; tmp3_1 = tmp3_1 + s1_823_1; tmp3_2 = tmp3_2 + s1_823_2;
    // Op 824: dim3x3 mul
    gl64_t s1_824_0 = *(gl64_t*)&expressions_params[10][167];
    gl64_t s1_824_1 = *(gl64_t*)&expressions_params[10][167+1];
    gl64_t s1_824_2 = *(gl64_t*)&expressions_params[10][167+2];
    gl64_t kA824 = (tmp3_0 + tmp3_1) * (s1_824_0 + s1_824_1);
    gl64_t kB824 = (tmp3_0 + tmp3_2) * (s1_824_0 + s1_824_2);
    gl64_t kC824 = (tmp3_1 + tmp3_2) * (s1_824_1 + s1_824_2);
    gl64_t kD824 = tmp3_0 * s1_824_0;
    gl64_t kE824 = tmp3_1 * s1_824_1;
    gl64_t kF824 = tmp3_2 * s1_824_2;
    gl64_t kG824 = kD824 - kE824;
    tmp3_0 = (kC824 + kG824) - kF824;
    tmp3_1 = ((((kA824 + kC824) - kE824) - kE824) - kD824);
    tmp3_2 = kB824 - kG824;
    // Op 825: dim1x1 sub
    gl64_t s0_825 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_825 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_825 - s1_825;
    // Op 826: dim1x1 sub_swap
    gl64_t s1_826 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_826 - tmp1_0;
    // Op 827: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 828: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 829: dim3x3 mul
    gl64_t s1_829_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_829_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_829_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA829 = (tmp3_0 + tmp3_1) * (s1_829_0 + s1_829_1);
    gl64_t kB829 = (tmp3_0 + tmp3_2) * (s1_829_0 + s1_829_2);
    gl64_t kC829 = (tmp3_1 + tmp3_2) * (s1_829_1 + s1_829_2);
    gl64_t kD829 = tmp3_0 * s1_829_0;
    gl64_t kE829 = tmp3_1 * s1_829_1;
    gl64_t kF829 = tmp3_2 * s1_829_2;
    gl64_t kG829 = kD829 - kE829;
    tmp3_6 = (kC829 + kG829) - kF829;
    tmp3_7 = ((((kA829 + kC829) - kE829) - kE829) - kD829);
    tmp3_8 = kB829 - kG829;
    // Op 830: dim1x1 sub
    gl64_t s1_830 = *(gl64_t*)&expressions_params[10][77];
    tmp1_0 = tmp1_4 - s1_830;
    // Op 831: dim1x1 sub
    gl64_t s1_831 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_831;
    // Op 832: dim3x1 mul
    gl64_t s0_832_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_832_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_832_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_832_0 * tmp1_0; tmp3_1 = s0_832_1 * tmp1_0; tmp3_2 = s0_832_2 * tmp1_0;
    // Op 833: dim3x1 add
    gl64_t s1_833 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_833; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 834: dim3x3 add
    gl64_t s1_834_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_834_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_834_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_834_0; tmp3_1 = tmp3_1 + s1_834_1; tmp3_2 = tmp3_2 + s1_834_2;
    // Op 835: dim3x3 mul
    gl64_t s1_835_0 = *(gl64_t*)&expressions_params[10][170];
    gl64_t s1_835_1 = *(gl64_t*)&expressions_params[10][170+1];
    gl64_t s1_835_2 = *(gl64_t*)&expressions_params[10][170+2];
    gl64_t kA835 = (tmp3_0 + tmp3_1) * (s1_835_0 + s1_835_1);
    gl64_t kB835 = (tmp3_0 + tmp3_2) * (s1_835_0 + s1_835_2);
    gl64_t kC835 = (tmp3_1 + tmp3_2) * (s1_835_1 + s1_835_2);
    gl64_t kD835 = tmp3_0 * s1_835_0;
    gl64_t kE835 = tmp3_1 * s1_835_1;
    gl64_t kF835 = tmp3_2 * s1_835_2;
    gl64_t kG835 = kD835 - kE835;
    tmp3_0 = (kC835 + kG835) - kF835;
    tmp3_1 = ((((kA835 + kC835) - kE835) - kE835) - kD835);
    tmp3_2 = kB835 - kG835;
    // Op 836: dim3x1 add
    gl64_t s1_836 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_836; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 837: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 838: dim3x3 mul
    gl64_t s1_838_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_838_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_838_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA838 = (tmp3_0 + tmp3_1) * (s1_838_0 + s1_838_1);
    gl64_t kB838 = (tmp3_0 + tmp3_2) * (s1_838_0 + s1_838_2);
    gl64_t kC838 = (tmp3_1 + tmp3_2) * (s1_838_1 + s1_838_2);
    gl64_t kD838 = tmp3_0 * s1_838_0;
    gl64_t kE838 = tmp3_1 * s1_838_1;
    gl64_t kF838 = tmp3_2 * s1_838_2;
    gl64_t kG838 = kD838 - kE838;
    tmp3_6 = (kC838 + kG838) - kF838;
    tmp3_7 = ((((kA838 + kC838) - kE838) - kE838) - kD838);
    tmp3_8 = kB838 - kG838;
    // Op 839: dim3x1 mul
    gl64_t s0_839_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_839_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_839_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_839 = *(gl64_t*)&expressions_params[10][23];
    tmp3_0 = s0_839_0 * s1_839; tmp3_1 = s0_839_1 * s1_839; tmp3_2 = s0_839_2 * s1_839;
    // Op 840: dim3x1 add
    gl64_t s1_840 = *(gl64_t*)&expressions_params[10][22];
    tmp3_0 = tmp3_0 + s1_840; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 841: dim3x3 mul
    gl64_t s1_841_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_841_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_841_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA841 = (tmp3_0 + tmp3_1) * (s1_841_0 + s1_841_1);
    gl64_t kB841 = (tmp3_0 + tmp3_2) * (s1_841_0 + s1_841_2);
    gl64_t kC841 = (tmp3_1 + tmp3_2) * (s1_841_1 + s1_841_2);
    gl64_t kD841 = tmp3_0 * s1_841_0;
    gl64_t kE841 = tmp3_1 * s1_841_1;
    gl64_t kF841 = tmp3_2 * s1_841_2;
    gl64_t kG841 = kD841 - kE841;
    tmp3_0 = (kC841 + kG841) - kF841;
    tmp3_1 = ((((kA841 + kC841) - kE841) - kE841) - kD841);
    tmp3_2 = kB841 - kG841;
    // Op 842: dim3x1 add
    gl64_t s1_842 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_842; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 843: dim3x3 mul
    gl64_t s1_843_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_843_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_843_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA843 = (tmp3_0 + tmp3_1) * (s1_843_0 + s1_843_1);
    gl64_t kB843 = (tmp3_0 + tmp3_2) * (s1_843_0 + s1_843_2);
    gl64_t kC843 = (tmp3_1 + tmp3_2) * (s1_843_1 + s1_843_2);
    gl64_t kD843 = tmp3_0 * s1_843_0;
    gl64_t kE843 = tmp3_1 * s1_843_1;
    gl64_t kF843 = tmp3_2 * s1_843_2;
    gl64_t kG843 = kD843 - kE843;
    tmp3_0 = (kC843 + kG843) - kF843;
    tmp3_1 = ((((kA843 + kC843) - kE843) - kE843) - kD843);
    tmp3_2 = kB843 - kG843;
    // Op 844: dim3x1 add
    gl64_t s1_844 = *(gl64_t*)&expressions_params[10][77];
    tmp3_0 = tmp3_0 + s1_844; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 845: dim3x3 mul
    gl64_t s1_845_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_845_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_845_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA845 = (tmp3_0 + tmp3_1) * (s1_845_0 + s1_845_1);
    gl64_t kB845 = (tmp3_0 + tmp3_2) * (s1_845_0 + s1_845_2);
    gl64_t kC845 = (tmp3_1 + tmp3_2) * (s1_845_1 + s1_845_2);
    gl64_t kD845 = tmp3_0 * s1_845_0;
    gl64_t kE845 = tmp3_1 * s1_845_1;
    gl64_t kF845 = tmp3_2 * s1_845_2;
    gl64_t kG845 = kD845 - kE845;
    tmp3_0 = (kC845 + kG845) - kF845;
    tmp3_1 = ((((kA845 + kC845) - kE845) - kE845) - kD845);
    tmp3_2 = kB845 - kG845;
    // Op 846: dim3x1 add
    gl64_t s1_846 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_846; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 847: dim3x3 mul
    gl64_t s1_847_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_847_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_847_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA847 = (tmp3_0 + tmp3_1) * (s1_847_0 + s1_847_1);
    gl64_t kB847 = (tmp3_0 + tmp3_2) * (s1_847_0 + s1_847_2);
    gl64_t kC847 = (tmp3_1 + tmp3_2) * (s1_847_1 + s1_847_2);
    gl64_t kD847 = tmp3_0 * s1_847_0;
    gl64_t kE847 = tmp3_1 * s1_847_1;
    gl64_t kF847 = tmp3_2 * s1_847_2;
    gl64_t kG847 = kD847 - kE847;
    tmp3_0 = (kC847 + kG847) - kF847;
    tmp3_1 = ((((kA847 + kC847) - kE847) - kE847) - kD847);
    tmp3_2 = kB847 - kG847;
    // Op 848: dim3x1 add
    gl64_t s1_848 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_848; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 849: dim3x3 mul
    gl64_t s1_849_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_849_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_849_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA849 = (tmp3_0 + tmp3_1) * (s1_849_0 + s1_849_1);
    gl64_t kB849 = (tmp3_0 + tmp3_2) * (s1_849_0 + s1_849_2);
    gl64_t kC849 = (tmp3_1 + tmp3_2) * (s1_849_1 + s1_849_2);
    gl64_t kD849 = tmp3_0 * s1_849_0;
    gl64_t kE849 = tmp3_1 * s1_849_1;
    gl64_t kF849 = tmp3_2 * s1_849_2;
    gl64_t kG849 = kD849 - kE849;
    tmp3_0 = (kC849 + kG849) - kF849;
    tmp3_1 = ((((kA849 + kC849) - kE849) - kE849) - kD849);
    tmp3_2 = kB849 - kG849;
    // Op 850: dim3x1 add
    gl64_t s1_850 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_850; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 851: dim3x3 add
    gl64_t s1_851_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_851_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_851_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_851_0; tmp3_1 = tmp3_1 + s1_851_1; tmp3_2 = tmp3_2 + s1_851_2;
    // Op 852: dim3x3 mul
    gl64_t s1_852_0 = *(gl64_t*)&expressions_params[10][173];
    gl64_t s1_852_1 = *(gl64_t*)&expressions_params[10][173+1];
    gl64_t s1_852_2 = *(gl64_t*)&expressions_params[10][173+2];
    gl64_t kA852 = (tmp3_0 + tmp3_1) * (s1_852_0 + s1_852_1);
    gl64_t kB852 = (tmp3_0 + tmp3_2) * (s1_852_0 + s1_852_2);
    gl64_t kC852 = (tmp3_1 + tmp3_2) * (s1_852_1 + s1_852_2);
    gl64_t kD852 = tmp3_0 * s1_852_0;
    gl64_t kE852 = tmp3_1 * s1_852_1;
    gl64_t kF852 = tmp3_2 * s1_852_2;
    gl64_t kG852 = kD852 - kE852;
    tmp3_0 = (kC852 + kG852) - kF852;
    tmp3_1 = ((((kA852 + kC852) - kE852) - kE852) - kD852);
    tmp3_2 = kB852 - kG852;
    // Op 853: dim3x1 sub
    gl64_t s1_853 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_853; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 854: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 855: dim3x3 mul
    gl64_t s1_855_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_855_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_855_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA855 = (tmp3_0 + tmp3_1) * (s1_855_0 + s1_855_1);
    gl64_t kB855 = (tmp3_0 + tmp3_2) * (s1_855_0 + s1_855_2);
    gl64_t kC855 = (tmp3_1 + tmp3_2) * (s1_855_1 + s1_855_2);
    gl64_t kD855 = tmp3_0 * s1_855_0;
    gl64_t kE855 = tmp3_1 * s1_855_1;
    gl64_t kF855 = tmp3_2 * s1_855_2;
    gl64_t kG855 = kD855 - kE855;
    tmp3_6 = (kC855 + kG855) - kF855;
    tmp3_7 = ((((kA855 + kC855) - kE855) - kE855) - kD855);
    tmp3_8 = kB855 - kG855;
    // Op 856: dim3x1 mul
    gl64_t s0_856_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_856_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_856_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_856 = *(gl64_t*)&expressions_params[10][23];
    tmp3_0 = s0_856_0 * s1_856; tmp3_1 = s0_856_1 * s1_856; tmp3_2 = s0_856_2 * s1_856;
    // Op 857: dim3x1 add
    gl64_t s1_857 = *(gl64_t*)&expressions_params[10][22];
    tmp3_0 = tmp3_0 + s1_857; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 858: dim3x3 mul
    gl64_t s1_858_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_858_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_858_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA858 = (tmp3_0 + tmp3_1) * (s1_858_0 + s1_858_1);
    gl64_t kB858 = (tmp3_0 + tmp3_2) * (s1_858_0 + s1_858_2);
    gl64_t kC858 = (tmp3_1 + tmp3_2) * (s1_858_1 + s1_858_2);
    gl64_t kD858 = tmp3_0 * s1_858_0;
    gl64_t kE858 = tmp3_1 * s1_858_1;
    gl64_t kF858 = tmp3_2 * s1_858_2;
    gl64_t kG858 = kD858 - kE858;
    tmp3_0 = (kC858 + kG858) - kF858;
    tmp3_1 = ((((kA858 + kC858) - kE858) - kE858) - kD858);
    tmp3_2 = kB858 - kG858;
    // Op 859: dim3x1 add
    gl64_t s1_859 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_859; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 860: dim3x3 mul
    gl64_t s1_860_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_860_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_860_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA860 = (tmp3_0 + tmp3_1) * (s1_860_0 + s1_860_1);
    gl64_t kB860 = (tmp3_0 + tmp3_2) * (s1_860_0 + s1_860_2);
    gl64_t kC860 = (tmp3_1 + tmp3_2) * (s1_860_1 + s1_860_2);
    gl64_t kD860 = tmp3_0 * s1_860_0;
    gl64_t kE860 = tmp3_1 * s1_860_1;
    gl64_t kF860 = tmp3_2 * s1_860_2;
    gl64_t kG860 = kD860 - kE860;
    tmp3_0 = (kC860 + kG860) - kF860;
    tmp3_1 = ((((kA860 + kC860) - kE860) - kE860) - kD860);
    tmp3_2 = kB860 - kG860;
    // Op 861: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 862: dim3x3 mul
    gl64_t s1_862_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_862_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_862_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA862 = (tmp3_0 + tmp3_1) * (s1_862_0 + s1_862_1);
    gl64_t kB862 = (tmp3_0 + tmp3_2) * (s1_862_0 + s1_862_2);
    gl64_t kC862 = (tmp3_1 + tmp3_2) * (s1_862_1 + s1_862_2);
    gl64_t kD862 = tmp3_0 * s1_862_0;
    gl64_t kE862 = tmp3_1 * s1_862_1;
    gl64_t kF862 = tmp3_2 * s1_862_2;
    gl64_t kG862 = kD862 - kE862;
    tmp3_0 = (kC862 + kG862) - kF862;
    tmp3_1 = ((((kA862 + kC862) - kE862) - kE862) - kD862);
    tmp3_2 = kB862 - kG862;
    // Op 863: dim3x1 add
    gl64_t s1_863 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_863; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 864: dim3x3 mul
    gl64_t s1_864_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_864_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_864_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA864 = (tmp3_0 + tmp3_1) * (s1_864_0 + s1_864_1);
    gl64_t kB864 = (tmp3_0 + tmp3_2) * (s1_864_0 + s1_864_2);
    gl64_t kC864 = (tmp3_1 + tmp3_2) * (s1_864_1 + s1_864_2);
    gl64_t kD864 = tmp3_0 * s1_864_0;
    gl64_t kE864 = tmp3_1 * s1_864_1;
    gl64_t kF864 = tmp3_2 * s1_864_2;
    gl64_t kG864 = kD864 - kE864;
    tmp3_0 = (kC864 + kG864) - kF864;
    tmp3_1 = ((((kA864 + kC864) - kE864) - kE864) - kD864);
    tmp3_2 = kB864 - kG864;
    // Op 865: dim3x1 add
    gl64_t s1_865 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_865; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 866: dim3x3 mul
    gl64_t s1_866_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_866_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_866_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA866 = (tmp3_0 + tmp3_1) * (s1_866_0 + s1_866_1);
    gl64_t kB866 = (tmp3_0 + tmp3_2) * (s1_866_0 + s1_866_2);
    gl64_t kC866 = (tmp3_1 + tmp3_2) * (s1_866_1 + s1_866_2);
    gl64_t kD866 = tmp3_0 * s1_866_0;
    gl64_t kE866 = tmp3_1 * s1_866_1;
    gl64_t kF866 = tmp3_2 * s1_866_2;
    gl64_t kG866 = kD866 - kE866;
    tmp3_0 = (kC866 + kG866) - kF866;
    tmp3_1 = ((((kA866 + kC866) - kE866) - kE866) - kD866);
    tmp3_2 = kB866 - kG866;
    // Op 867: dim3x1 add
    gl64_t s1_867 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_867; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 868: dim3x3 add
    gl64_t s1_868_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_868_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_868_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_868_0; tmp3_1 = tmp3_1 + s1_868_1; tmp3_2 = tmp3_2 + s1_868_2;
    // Op 869: dim3x3 mul
    gl64_t s1_869_0 = *(gl64_t*)&expressions_params[10][176];
    gl64_t s1_869_1 = *(gl64_t*)&expressions_params[10][176+1];
    gl64_t s1_869_2 = *(gl64_t*)&expressions_params[10][176+2];
    gl64_t kA869 = (tmp3_0 + tmp3_1) * (s1_869_0 + s1_869_1);
    gl64_t kB869 = (tmp3_0 + tmp3_2) * (s1_869_0 + s1_869_2);
    gl64_t kC869 = (tmp3_1 + tmp3_2) * (s1_869_1 + s1_869_2);
    gl64_t kD869 = tmp3_0 * s1_869_0;
    gl64_t kE869 = tmp3_1 * s1_869_1;
    gl64_t kF869 = tmp3_2 * s1_869_2;
    gl64_t kG869 = kD869 - kE869;
    tmp3_0 = (kC869 + kG869) - kF869;
    tmp3_1 = ((((kA869 + kC869) - kE869) - kE869) - kD869);
    tmp3_2 = kB869 - kG869;
    // Op 870: dim1x1 sub
    gl64_t s0_870 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_870 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_870 - s1_870;
    // Op 871: dim1x1 sub_swap
    gl64_t s1_871 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_871 - tmp1_0;
    // Op 872: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 873: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 874: dim3x3 mul
    gl64_t s1_874_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_874_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_874_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA874 = (tmp3_0 + tmp3_1) * (s1_874_0 + s1_874_1);
    gl64_t kB874 = (tmp3_0 + tmp3_2) * (s1_874_0 + s1_874_2);
    gl64_t kC874 = (tmp3_1 + tmp3_2) * (s1_874_1 + s1_874_2);
    gl64_t kD874 = tmp3_0 * s1_874_0;
    gl64_t kE874 = tmp3_1 * s1_874_1;
    gl64_t kF874 = tmp3_2 * s1_874_2;
    gl64_t kG874 = kD874 - kE874;
    tmp3_6 = (kC874 + kG874) - kF874;
    tmp3_7 = ((((kA874 + kC874) - kE874) - kE874) - kD874);
    tmp3_8 = kB874 - kG874;
    // Op 875: dim1x1 sub
    gl64_t s1_875 = *(gl64_t*)&expressions_params[10][78];
    tmp1_0 = tmp1_4 - s1_875;
    // Op 876: dim1x1 sub
    gl64_t s1_876 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_876;
    // Op 877: dim3x1 mul
    gl64_t s0_877_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_877_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_877_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_877_0 * tmp1_0; tmp3_1 = s0_877_1 * tmp1_0; tmp3_2 = s0_877_2 * tmp1_0;
    // Op 878: dim3x1 add
    gl64_t s1_878 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_878; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 879: dim3x3 add
    gl64_t s1_879_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_879_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_879_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_879_0; tmp3_1 = tmp3_1 + s1_879_1; tmp3_2 = tmp3_2 + s1_879_2;
    // Op 880: dim3x3 mul
    gl64_t s1_880_0 = *(gl64_t*)&expressions_params[10][179];
    gl64_t s1_880_1 = *(gl64_t*)&expressions_params[10][179+1];
    gl64_t s1_880_2 = *(gl64_t*)&expressions_params[10][179+2];
    gl64_t kA880 = (tmp3_0 + tmp3_1) * (s1_880_0 + s1_880_1);
    gl64_t kB880 = (tmp3_0 + tmp3_2) * (s1_880_0 + s1_880_2);
    gl64_t kC880 = (tmp3_1 + tmp3_2) * (s1_880_1 + s1_880_2);
    gl64_t kD880 = tmp3_0 * s1_880_0;
    gl64_t kE880 = tmp3_1 * s1_880_1;
    gl64_t kF880 = tmp3_2 * s1_880_2;
    gl64_t kG880 = kD880 - kE880;
    tmp3_0 = (kC880 + kG880) - kF880;
    tmp3_1 = ((((kA880 + kC880) - kE880) - kE880) - kD880);
    tmp3_2 = kB880 - kG880;
    // Op 881: dim3x1 add
    gl64_t s1_881 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_881; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 882: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 883: dim3x3 mul
    gl64_t s1_883_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_883_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_883_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA883 = (tmp3_0 + tmp3_1) * (s1_883_0 + s1_883_1);
    gl64_t kB883 = (tmp3_0 + tmp3_2) * (s1_883_0 + s1_883_2);
    gl64_t kC883 = (tmp3_1 + tmp3_2) * (s1_883_1 + s1_883_2);
    gl64_t kD883 = tmp3_0 * s1_883_0;
    gl64_t kE883 = tmp3_1 * s1_883_1;
    gl64_t kF883 = tmp3_2 * s1_883_2;
    gl64_t kG883 = kD883 - kE883;
    tmp3_6 = (kC883 + kG883) - kF883;
    tmp3_7 = ((((kA883 + kC883) - kE883) - kE883) - kD883);
    tmp3_8 = kB883 - kG883;
    // Op 884: dim3x1 mul
    gl64_t s0_884_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_884_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_884_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_884 = *(gl64_t*)&expressions_params[10][25];
    tmp3_0 = s0_884_0 * s1_884; tmp3_1 = s0_884_1 * s1_884; tmp3_2 = s0_884_2 * s1_884;
    // Op 885: dim3x1 add
    gl64_t s1_885 = *(gl64_t*)&expressions_params[10][24];
    tmp3_0 = tmp3_0 + s1_885; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 886: dim3x3 mul
    gl64_t s1_886_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_886_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_886_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA886 = (tmp3_0 + tmp3_1) * (s1_886_0 + s1_886_1);
    gl64_t kB886 = (tmp3_0 + tmp3_2) * (s1_886_0 + s1_886_2);
    gl64_t kC886 = (tmp3_1 + tmp3_2) * (s1_886_1 + s1_886_2);
    gl64_t kD886 = tmp3_0 * s1_886_0;
    gl64_t kE886 = tmp3_1 * s1_886_1;
    gl64_t kF886 = tmp3_2 * s1_886_2;
    gl64_t kG886 = kD886 - kE886;
    tmp3_0 = (kC886 + kG886) - kF886;
    tmp3_1 = ((((kA886 + kC886) - kE886) - kE886) - kD886);
    tmp3_2 = kB886 - kG886;
    // Op 887: dim3x1 add
    gl64_t s1_887 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_887; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 888: dim3x3 mul
    gl64_t s1_888_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_888_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_888_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA888 = (tmp3_0 + tmp3_1) * (s1_888_0 + s1_888_1);
    gl64_t kB888 = (tmp3_0 + tmp3_2) * (s1_888_0 + s1_888_2);
    gl64_t kC888 = (tmp3_1 + tmp3_2) * (s1_888_1 + s1_888_2);
    gl64_t kD888 = tmp3_0 * s1_888_0;
    gl64_t kE888 = tmp3_1 * s1_888_1;
    gl64_t kF888 = tmp3_2 * s1_888_2;
    gl64_t kG888 = kD888 - kE888;
    tmp3_0 = (kC888 + kG888) - kF888;
    tmp3_1 = ((((kA888 + kC888) - kE888) - kE888) - kD888);
    tmp3_2 = kB888 - kG888;
    // Op 889: dim3x1 add
    gl64_t s1_889 = *(gl64_t*)&expressions_params[10][78];
    tmp3_0 = tmp3_0 + s1_889; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 890: dim3x3 mul
    gl64_t s1_890_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_890_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_890_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA890 = (tmp3_0 + tmp3_1) * (s1_890_0 + s1_890_1);
    gl64_t kB890 = (tmp3_0 + tmp3_2) * (s1_890_0 + s1_890_2);
    gl64_t kC890 = (tmp3_1 + tmp3_2) * (s1_890_1 + s1_890_2);
    gl64_t kD890 = tmp3_0 * s1_890_0;
    gl64_t kE890 = tmp3_1 * s1_890_1;
    gl64_t kF890 = tmp3_2 * s1_890_2;
    gl64_t kG890 = kD890 - kE890;
    tmp3_0 = (kC890 + kG890) - kF890;
    tmp3_1 = ((((kA890 + kC890) - kE890) - kE890) - kD890);
    tmp3_2 = kB890 - kG890;
    // Op 891: dim3x1 add
    gl64_t s1_891 = *(gl64_t*)&expressions_params[9][27];
    tmp3_0 = tmp3_0 + s1_891; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 892: dim3x3 mul
    gl64_t s1_892_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_892_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_892_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA892 = (tmp3_0 + tmp3_1) * (s1_892_0 + s1_892_1);
    gl64_t kB892 = (tmp3_0 + tmp3_2) * (s1_892_0 + s1_892_2);
    gl64_t kC892 = (tmp3_1 + tmp3_2) * (s1_892_1 + s1_892_2);
    gl64_t kD892 = tmp3_0 * s1_892_0;
    gl64_t kE892 = tmp3_1 * s1_892_1;
    gl64_t kF892 = tmp3_2 * s1_892_2;
    gl64_t kG892 = kD892 - kE892;
    tmp3_0 = (kC892 + kG892) - kF892;
    tmp3_1 = ((((kA892 + kC892) - kE892) - kE892) - kD892);
    tmp3_2 = kB892 - kG892;
    // Op 893: dim3x1 add
    gl64_t s1_893 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_893; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 894: dim3x3 mul
    gl64_t s1_894_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_894_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_894_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA894 = (tmp3_0 + tmp3_1) * (s1_894_0 + s1_894_1);
    gl64_t kB894 = (tmp3_0 + tmp3_2) * (s1_894_0 + s1_894_2);
    gl64_t kC894 = (tmp3_1 + tmp3_2) * (s1_894_1 + s1_894_2);
    gl64_t kD894 = tmp3_0 * s1_894_0;
    gl64_t kE894 = tmp3_1 * s1_894_1;
    gl64_t kF894 = tmp3_2 * s1_894_2;
    gl64_t kG894 = kD894 - kE894;
    tmp3_0 = (kC894 + kG894) - kF894;
    tmp3_1 = ((((kA894 + kC894) - kE894) - kE894) - kD894);
    tmp3_2 = kB894 - kG894;
    // Op 895: dim3x1 add
    gl64_t s1_895 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_895; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 896: dim3x3 add
    gl64_t s1_896_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_896_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_896_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_896_0; tmp3_1 = tmp3_1 + s1_896_1; tmp3_2 = tmp3_2 + s1_896_2;
    // Op 897: dim3x3 mul
    gl64_t s1_897_0 = *(gl64_t*)&expressions_params[10][182];
    gl64_t s1_897_1 = *(gl64_t*)&expressions_params[10][182+1];
    gl64_t s1_897_2 = *(gl64_t*)&expressions_params[10][182+2];
    gl64_t kA897 = (tmp3_0 + tmp3_1) * (s1_897_0 + s1_897_1);
    gl64_t kB897 = (tmp3_0 + tmp3_2) * (s1_897_0 + s1_897_2);
    gl64_t kC897 = (tmp3_1 + tmp3_2) * (s1_897_1 + s1_897_2);
    gl64_t kD897 = tmp3_0 * s1_897_0;
    gl64_t kE897 = tmp3_1 * s1_897_1;
    gl64_t kF897 = tmp3_2 * s1_897_2;
    gl64_t kG897 = kD897 - kE897;
    tmp3_0 = (kC897 + kG897) - kF897;
    tmp3_1 = ((((kA897 + kC897) - kE897) - kE897) - kD897);
    tmp3_2 = kB897 - kG897;
    // Op 898: dim3x1 sub
    gl64_t s1_898 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_898; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 899: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 900: dim3x3 mul
    gl64_t s1_900_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_900_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_900_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA900 = (tmp3_0 + tmp3_1) * (s1_900_0 + s1_900_1);
    gl64_t kB900 = (tmp3_0 + tmp3_2) * (s1_900_0 + s1_900_2);
    gl64_t kC900 = (tmp3_1 + tmp3_2) * (s1_900_1 + s1_900_2);
    gl64_t kD900 = tmp3_0 * s1_900_0;
    gl64_t kE900 = tmp3_1 * s1_900_1;
    gl64_t kF900 = tmp3_2 * s1_900_2;
    gl64_t kG900 = kD900 - kE900;
    tmp3_6 = (kC900 + kG900) - kF900;
    tmp3_7 = ((((kA900 + kC900) - kE900) - kE900) - kD900);
    tmp3_8 = kB900 - kG900;
    // Op 901: dim3x1 mul
    gl64_t s0_901_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_901_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_901_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_901 = *(gl64_t*)&expressions_params[10][25];
    tmp3_0 = s0_901_0 * s1_901; tmp3_1 = s0_901_1 * s1_901; tmp3_2 = s0_901_2 * s1_901;
    // Op 902: dim3x1 add
    gl64_t s1_902 = *(gl64_t*)&expressions_params[10][24];
    tmp3_0 = tmp3_0 + s1_902; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 903: dim3x3 mul
    gl64_t s1_903_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_903_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_903_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA903 = (tmp3_0 + tmp3_1) * (s1_903_0 + s1_903_1);
    gl64_t kB903 = (tmp3_0 + tmp3_2) * (s1_903_0 + s1_903_2);
    gl64_t kC903 = (tmp3_1 + tmp3_2) * (s1_903_1 + s1_903_2);
    gl64_t kD903 = tmp3_0 * s1_903_0;
    gl64_t kE903 = tmp3_1 * s1_903_1;
    gl64_t kF903 = tmp3_2 * s1_903_2;
    gl64_t kG903 = kD903 - kE903;
    tmp3_0 = (kC903 + kG903) - kF903;
    tmp3_1 = ((((kA903 + kC903) - kE903) - kE903) - kD903);
    tmp3_2 = kB903 - kG903;
    // Op 904: dim3x1 add
    gl64_t s1_904 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_904; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 905: dim3x3 mul
    gl64_t s1_905_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_905_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_905_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA905 = (tmp3_0 + tmp3_1) * (s1_905_0 + s1_905_1);
    gl64_t kB905 = (tmp3_0 + tmp3_2) * (s1_905_0 + s1_905_2);
    gl64_t kC905 = (tmp3_1 + tmp3_2) * (s1_905_1 + s1_905_2);
    gl64_t kD905 = tmp3_0 * s1_905_0;
    gl64_t kE905 = tmp3_1 * s1_905_1;
    gl64_t kF905 = tmp3_2 * s1_905_2;
    gl64_t kG905 = kD905 - kE905;
    tmp3_0 = (kC905 + kG905) - kF905;
    tmp3_1 = ((((kA905 + kC905) - kE905) - kE905) - kD905);
    tmp3_2 = kB905 - kG905;
    // Op 906: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 907: dim3x3 mul
    gl64_t s1_907_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_907_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_907_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA907 = (tmp3_0 + tmp3_1) * (s1_907_0 + s1_907_1);
    gl64_t kB907 = (tmp3_0 + tmp3_2) * (s1_907_0 + s1_907_2);
    gl64_t kC907 = (tmp3_1 + tmp3_2) * (s1_907_1 + s1_907_2);
    gl64_t kD907 = tmp3_0 * s1_907_0;
    gl64_t kE907 = tmp3_1 * s1_907_1;
    gl64_t kF907 = tmp3_2 * s1_907_2;
    gl64_t kG907 = kD907 - kE907;
    tmp3_0 = (kC907 + kG907) - kF907;
    tmp3_1 = ((((kA907 + kC907) - kE907) - kE907) - kD907);
    tmp3_2 = kB907 - kG907;
    // Op 908: dim3x1 add
    gl64_t s1_908 = *(gl64_t*)&expressions_params[9][27];
    tmp3_0 = tmp3_0 + s1_908; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 909: dim3x3 mul
    gl64_t s1_909_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_909_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_909_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA909 = (tmp3_0 + tmp3_1) * (s1_909_0 + s1_909_1);
    gl64_t kB909 = (tmp3_0 + tmp3_2) * (s1_909_0 + s1_909_2);
    gl64_t kC909 = (tmp3_1 + tmp3_2) * (s1_909_1 + s1_909_2);
    gl64_t kD909 = tmp3_0 * s1_909_0;
    gl64_t kE909 = tmp3_1 * s1_909_1;
    gl64_t kF909 = tmp3_2 * s1_909_2;
    gl64_t kG909 = kD909 - kE909;
    tmp3_0 = (kC909 + kG909) - kF909;
    tmp3_1 = ((((kA909 + kC909) - kE909) - kE909) - kD909);
    tmp3_2 = kB909 - kG909;
    // Op 910: dim3x1 add
    gl64_t s1_910 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_910; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 911: dim3x3 mul
    gl64_t s1_911_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_911_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_911_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA911 = (tmp3_0 + tmp3_1) * (s1_911_0 + s1_911_1);
    gl64_t kB911 = (tmp3_0 + tmp3_2) * (s1_911_0 + s1_911_2);
    gl64_t kC911 = (tmp3_1 + tmp3_2) * (s1_911_1 + s1_911_2);
    gl64_t kD911 = tmp3_0 * s1_911_0;
    gl64_t kE911 = tmp3_1 * s1_911_1;
    gl64_t kF911 = tmp3_2 * s1_911_2;
    gl64_t kG911 = kD911 - kE911;
    tmp3_0 = (kC911 + kG911) - kF911;
    tmp3_1 = ((((kA911 + kC911) - kE911) - kE911) - kD911);
    tmp3_2 = kB911 - kG911;
    // Op 912: dim3x1 add
    gl64_t s1_912 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_912; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 913: dim3x3 add
    gl64_t s1_913_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_913_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_913_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_913_0; tmp3_1 = tmp3_1 + s1_913_1; tmp3_2 = tmp3_2 + s1_913_2;
    // Op 914: dim3x3 mul
    gl64_t s1_914_0 = *(gl64_t*)&expressions_params[10][185];
    gl64_t s1_914_1 = *(gl64_t*)&expressions_params[10][185+1];
    gl64_t s1_914_2 = *(gl64_t*)&expressions_params[10][185+2];
    gl64_t kA914 = (tmp3_0 + tmp3_1) * (s1_914_0 + s1_914_1);
    gl64_t kB914 = (tmp3_0 + tmp3_2) * (s1_914_0 + s1_914_2);
    gl64_t kC914 = (tmp3_1 + tmp3_2) * (s1_914_1 + s1_914_2);
    gl64_t kD914 = tmp3_0 * s1_914_0;
    gl64_t kE914 = tmp3_1 * s1_914_1;
    gl64_t kF914 = tmp3_2 * s1_914_2;
    gl64_t kG914 = kD914 - kE914;
    tmp3_0 = (kC914 + kG914) - kF914;
    tmp3_1 = ((((kA914 + kC914) - kE914) - kE914) - kD914);
    tmp3_2 = kB914 - kG914;
    // Op 915: dim1x1 sub
    gl64_t s0_915 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_915 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_915 - s1_915;
    // Op 916: dim1x1 sub_swap
    gl64_t s1_916 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_916 - tmp1_0;
    // Op 917: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 918: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 919: dim3x3 mul
    gl64_t s1_919_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_919_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_919_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA919 = (tmp3_0 + tmp3_1) * (s1_919_0 + s1_919_1);
    gl64_t kB919 = (tmp3_0 + tmp3_2) * (s1_919_0 + s1_919_2);
    gl64_t kC919 = (tmp3_1 + tmp3_2) * (s1_919_1 + s1_919_2);
    gl64_t kD919 = tmp3_0 * s1_919_0;
    gl64_t kE919 = tmp3_1 * s1_919_1;
    gl64_t kF919 = tmp3_2 * s1_919_2;
    gl64_t kG919 = kD919 - kE919;
    tmp3_6 = (kC919 + kG919) - kF919;
    tmp3_7 = ((((kA919 + kC919) - kE919) - kE919) - kD919);
    tmp3_8 = kB919 - kG919;
    // Op 920: dim1x1 sub
    gl64_t s1_920 = *(gl64_t*)&expressions_params[10][79];
    tmp1_0 = tmp1_4 - s1_920;
    // Op 921: dim1x1 sub
    gl64_t s1_921 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_921;
    // Op 922: dim3x1 mul
    gl64_t s0_922_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_922_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_922_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_922_0 * tmp1_0; tmp3_1 = s0_922_1 * tmp1_0; tmp3_2 = s0_922_2 * tmp1_0;
    // Op 923: dim3x1 add
    gl64_t s1_923 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_923; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 924: dim3x3 add
    gl64_t s1_924_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_924_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_924_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_924_0; tmp3_1 = tmp3_1 + s1_924_1; tmp3_2 = tmp3_2 + s1_924_2;
    // Op 925: dim3x3 mul
    gl64_t s1_925_0 = *(gl64_t*)&expressions_params[10][188];
    gl64_t s1_925_1 = *(gl64_t*)&expressions_params[10][188+1];
    gl64_t s1_925_2 = *(gl64_t*)&expressions_params[10][188+2];
    gl64_t kA925 = (tmp3_0 + tmp3_1) * (s1_925_0 + s1_925_1);
    gl64_t kB925 = (tmp3_0 + tmp3_2) * (s1_925_0 + s1_925_2);
    gl64_t kC925 = (tmp3_1 + tmp3_2) * (s1_925_1 + s1_925_2);
    gl64_t kD925 = tmp3_0 * s1_925_0;
    gl64_t kE925 = tmp3_1 * s1_925_1;
    gl64_t kF925 = tmp3_2 * s1_925_2;
    gl64_t kG925 = kD925 - kE925;
    tmp3_0 = (kC925 + kG925) - kF925;
    tmp3_1 = ((((kA925 + kC925) - kE925) - kE925) - kD925);
    tmp3_2 = kB925 - kG925;
    // Op 926: dim3x1 add
    gl64_t s1_926 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_926; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 927: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 928: dim3x3 mul
    gl64_t s1_928_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_928_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_928_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA928 = (tmp3_0 + tmp3_1) * (s1_928_0 + s1_928_1);
    gl64_t kB928 = (tmp3_0 + tmp3_2) * (s1_928_0 + s1_928_2);
    gl64_t kC928 = (tmp3_1 + tmp3_2) * (s1_928_1 + s1_928_2);
    gl64_t kD928 = tmp3_0 * s1_928_0;
    gl64_t kE928 = tmp3_1 * s1_928_1;
    gl64_t kF928 = tmp3_2 * s1_928_2;
    gl64_t kG928 = kD928 - kE928;
    tmp3_6 = (kC928 + kG928) - kF928;
    tmp3_7 = ((((kA928 + kC928) - kE928) - kE928) - kD928);
    tmp3_8 = kB928 - kG928;
    // Op 929: dim3x1 mul
    gl64_t s0_929_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_929_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_929_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_929 = *(gl64_t*)&expressions_params[10][27];
    tmp3_0 = s0_929_0 * s1_929; tmp3_1 = s0_929_1 * s1_929; tmp3_2 = s0_929_2 * s1_929;
    // Op 930: dim3x1 add
    gl64_t s1_930 = *(gl64_t*)&expressions_params[10][26];
    tmp3_0 = tmp3_0 + s1_930; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 931: dim3x3 mul
    gl64_t s1_931_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_931_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_931_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA931 = (tmp3_0 + tmp3_1) * (s1_931_0 + s1_931_1);
    gl64_t kB931 = (tmp3_0 + tmp3_2) * (s1_931_0 + s1_931_2);
    gl64_t kC931 = (tmp3_1 + tmp3_2) * (s1_931_1 + s1_931_2);
    gl64_t kD931 = tmp3_0 * s1_931_0;
    gl64_t kE931 = tmp3_1 * s1_931_1;
    gl64_t kF931 = tmp3_2 * s1_931_2;
    gl64_t kG931 = kD931 - kE931;
    tmp3_0 = (kC931 + kG931) - kF931;
    tmp3_1 = ((((kA931 + kC931) - kE931) - kE931) - kD931);
    tmp3_2 = kB931 - kG931;
    // Op 932: dim3x1 add
    gl64_t s1_932 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_932; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 933: dim3x3 mul
    gl64_t s1_933_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_933_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_933_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA933 = (tmp3_0 + tmp3_1) * (s1_933_0 + s1_933_1);
    gl64_t kB933 = (tmp3_0 + tmp3_2) * (s1_933_0 + s1_933_2);
    gl64_t kC933 = (tmp3_1 + tmp3_2) * (s1_933_1 + s1_933_2);
    gl64_t kD933 = tmp3_0 * s1_933_0;
    gl64_t kE933 = tmp3_1 * s1_933_1;
    gl64_t kF933 = tmp3_2 * s1_933_2;
    gl64_t kG933 = kD933 - kE933;
    tmp3_0 = (kC933 + kG933) - kF933;
    tmp3_1 = ((((kA933 + kC933) - kE933) - kE933) - kD933);
    tmp3_2 = kB933 - kG933;
    // Op 934: dim3x1 add
    gl64_t s1_934 = *(gl64_t*)&expressions_params[10][79];
    tmp3_0 = tmp3_0 + s1_934; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 935: dim3x3 mul
    gl64_t s1_935_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_935_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_935_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA935 = (tmp3_0 + tmp3_1) * (s1_935_0 + s1_935_1);
    gl64_t kB935 = (tmp3_0 + tmp3_2) * (s1_935_0 + s1_935_2);
    gl64_t kC935 = (tmp3_1 + tmp3_2) * (s1_935_1 + s1_935_2);
    gl64_t kD935 = tmp3_0 * s1_935_0;
    gl64_t kE935 = tmp3_1 * s1_935_1;
    gl64_t kF935 = tmp3_2 * s1_935_2;
    gl64_t kG935 = kD935 - kE935;
    tmp3_0 = (kC935 + kG935) - kF935;
    tmp3_1 = ((((kA935 + kC935) - kE935) - kE935) - kD935);
    tmp3_2 = kB935 - kG935;
    // Op 936: dim3x1 add
    gl64_t s1_936 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_936; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 937: dim3x3 mul
    gl64_t s1_937_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_937_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_937_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA937 = (tmp3_0 + tmp3_1) * (s1_937_0 + s1_937_1);
    gl64_t kB937 = (tmp3_0 + tmp3_2) * (s1_937_0 + s1_937_2);
    gl64_t kC937 = (tmp3_1 + tmp3_2) * (s1_937_1 + s1_937_2);
    gl64_t kD937 = tmp3_0 * s1_937_0;
    gl64_t kE937 = tmp3_1 * s1_937_1;
    gl64_t kF937 = tmp3_2 * s1_937_2;
    gl64_t kG937 = kD937 - kE937;
    tmp3_0 = (kC937 + kG937) - kF937;
    tmp3_1 = ((((kA937 + kC937) - kE937) - kE937) - kD937);
    tmp3_2 = kB937 - kG937;
    // Op 938: dim3x1 add
    gl64_t s1_938 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_938; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 939: dim3x3 mul
    gl64_t s1_939_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_939_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_939_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA939 = (tmp3_0 + tmp3_1) * (s1_939_0 + s1_939_1);
    gl64_t kB939 = (tmp3_0 + tmp3_2) * (s1_939_0 + s1_939_2);
    gl64_t kC939 = (tmp3_1 + tmp3_2) * (s1_939_1 + s1_939_2);
    gl64_t kD939 = tmp3_0 * s1_939_0;
    gl64_t kE939 = tmp3_1 * s1_939_1;
    gl64_t kF939 = tmp3_2 * s1_939_2;
    gl64_t kG939 = kD939 - kE939;
    tmp3_0 = (kC939 + kG939) - kF939;
    tmp3_1 = ((((kA939 + kC939) - kE939) - kE939) - kD939);
    tmp3_2 = kB939 - kG939;
    // Op 940: dim3x1 add
    gl64_t s1_940 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_940; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 941: dim3x3 add
    gl64_t s1_941_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_941_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_941_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_941_0; tmp3_1 = tmp3_1 + s1_941_1; tmp3_2 = tmp3_2 + s1_941_2;
    // Op 942: dim3x3 mul
    gl64_t s1_942_0 = *(gl64_t*)&expressions_params[10][191];
    gl64_t s1_942_1 = *(gl64_t*)&expressions_params[10][191+1];
    gl64_t s1_942_2 = *(gl64_t*)&expressions_params[10][191+2];
    gl64_t kA942 = (tmp3_0 + tmp3_1) * (s1_942_0 + s1_942_1);
    gl64_t kB942 = (tmp3_0 + tmp3_2) * (s1_942_0 + s1_942_2);
    gl64_t kC942 = (tmp3_1 + tmp3_2) * (s1_942_1 + s1_942_2);
    gl64_t kD942 = tmp3_0 * s1_942_0;
    gl64_t kE942 = tmp3_1 * s1_942_1;
    gl64_t kF942 = tmp3_2 * s1_942_2;
    gl64_t kG942 = kD942 - kE942;
    tmp3_0 = (kC942 + kG942) - kF942;
    tmp3_1 = ((((kA942 + kC942) - kE942) - kE942) - kD942);
    tmp3_2 = kB942 - kG942;
    // Op 943: dim3x1 sub
    gl64_t s1_943 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_943; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 944: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 945: dim3x3 mul
    gl64_t s1_945_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_945_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_945_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA945 = (tmp3_0 + tmp3_1) * (s1_945_0 + s1_945_1);
    gl64_t kB945 = (tmp3_0 + tmp3_2) * (s1_945_0 + s1_945_2);
    gl64_t kC945 = (tmp3_1 + tmp3_2) * (s1_945_1 + s1_945_2);
    gl64_t kD945 = tmp3_0 * s1_945_0;
    gl64_t kE945 = tmp3_1 * s1_945_1;
    gl64_t kF945 = tmp3_2 * s1_945_2;
    gl64_t kG945 = kD945 - kE945;
    tmp3_6 = (kC945 + kG945) - kF945;
    tmp3_7 = ((((kA945 + kC945) - kE945) - kE945) - kD945);
    tmp3_8 = kB945 - kG945;
    // Op 946: dim3x1 mul
    gl64_t s0_946_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_946_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_946_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_946 = *(gl64_t*)&expressions_params[10][27];
    tmp3_0 = s0_946_0 * s1_946; tmp3_1 = s0_946_1 * s1_946; tmp3_2 = s0_946_2 * s1_946;
    // Op 947: dim3x1 add
    gl64_t s1_947 = *(gl64_t*)&expressions_params[10][26];
    tmp3_0 = tmp3_0 + s1_947; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 948: dim3x3 mul
    gl64_t s1_948_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_948_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_948_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA948 = (tmp3_0 + tmp3_1) * (s1_948_0 + s1_948_1);
    gl64_t kB948 = (tmp3_0 + tmp3_2) * (s1_948_0 + s1_948_2);
    gl64_t kC948 = (tmp3_1 + tmp3_2) * (s1_948_1 + s1_948_2);
    gl64_t kD948 = tmp3_0 * s1_948_0;
    gl64_t kE948 = tmp3_1 * s1_948_1;
    gl64_t kF948 = tmp3_2 * s1_948_2;
    gl64_t kG948 = kD948 - kE948;
    tmp3_0 = (kC948 + kG948) - kF948;
    tmp3_1 = ((((kA948 + kC948) - kE948) - kE948) - kD948);
    tmp3_2 = kB948 - kG948;
    // Op 949: dim3x1 add
    gl64_t s1_949 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_949; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 950: dim3x3 mul
    gl64_t s1_950_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_950_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_950_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA950 = (tmp3_0 + tmp3_1) * (s1_950_0 + s1_950_1);
    gl64_t kB950 = (tmp3_0 + tmp3_2) * (s1_950_0 + s1_950_2);
    gl64_t kC950 = (tmp3_1 + tmp3_2) * (s1_950_1 + s1_950_2);
    gl64_t kD950 = tmp3_0 * s1_950_0;
    gl64_t kE950 = tmp3_1 * s1_950_1;
    gl64_t kF950 = tmp3_2 * s1_950_2;
    gl64_t kG950 = kD950 - kE950;
    tmp3_0 = (kC950 + kG950) - kF950;
    tmp3_1 = ((((kA950 + kC950) - kE950) - kE950) - kD950);
    tmp3_2 = kB950 - kG950;
    // Op 951: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 952: dim3x3 mul
    gl64_t s1_952_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_952_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_952_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA952 = (tmp3_0 + tmp3_1) * (s1_952_0 + s1_952_1);
    gl64_t kB952 = (tmp3_0 + tmp3_2) * (s1_952_0 + s1_952_2);
    gl64_t kC952 = (tmp3_1 + tmp3_2) * (s1_952_1 + s1_952_2);
    gl64_t kD952 = tmp3_0 * s1_952_0;
    gl64_t kE952 = tmp3_1 * s1_952_1;
    gl64_t kF952 = tmp3_2 * s1_952_2;
    gl64_t kG952 = kD952 - kE952;
    tmp3_0 = (kC952 + kG952) - kF952;
    tmp3_1 = ((((kA952 + kC952) - kE952) - kE952) - kD952);
    tmp3_2 = kB952 - kG952;
    // Op 953: dim3x1 add
    gl64_t s1_953 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_953; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 954: dim3x3 mul
    gl64_t s1_954_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_954_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_954_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA954 = (tmp3_0 + tmp3_1) * (s1_954_0 + s1_954_1);
    gl64_t kB954 = (tmp3_0 + tmp3_2) * (s1_954_0 + s1_954_2);
    gl64_t kC954 = (tmp3_1 + tmp3_2) * (s1_954_1 + s1_954_2);
    gl64_t kD954 = tmp3_0 * s1_954_0;
    gl64_t kE954 = tmp3_1 * s1_954_1;
    gl64_t kF954 = tmp3_2 * s1_954_2;
    gl64_t kG954 = kD954 - kE954;
    tmp3_0 = (kC954 + kG954) - kF954;
    tmp3_1 = ((((kA954 + kC954) - kE954) - kE954) - kD954);
    tmp3_2 = kB954 - kG954;
    // Op 955: dim3x1 add
    gl64_t s1_955 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_955; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 956: dim3x3 mul
    gl64_t s1_956_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_956_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_956_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA956 = (tmp3_0 + tmp3_1) * (s1_956_0 + s1_956_1);
    gl64_t kB956 = (tmp3_0 + tmp3_2) * (s1_956_0 + s1_956_2);
    gl64_t kC956 = (tmp3_1 + tmp3_2) * (s1_956_1 + s1_956_2);
    gl64_t kD956 = tmp3_0 * s1_956_0;
    gl64_t kE956 = tmp3_1 * s1_956_1;
    gl64_t kF956 = tmp3_2 * s1_956_2;
    gl64_t kG956 = kD956 - kE956;
    tmp3_0 = (kC956 + kG956) - kF956;
    tmp3_1 = ((((kA956 + kC956) - kE956) - kE956) - kD956);
    tmp3_2 = kB956 - kG956;
    // Op 957: dim3x1 add
    gl64_t s1_957 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_957; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 958: dim3x3 add
    gl64_t s1_958_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_958_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_958_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_958_0; tmp3_1 = tmp3_1 + s1_958_1; tmp3_2 = tmp3_2 + s1_958_2;
    // Op 959: dim3x3 mul
    gl64_t s1_959_0 = *(gl64_t*)&expressions_params[10][194];
    gl64_t s1_959_1 = *(gl64_t*)&expressions_params[10][194+1];
    gl64_t s1_959_2 = *(gl64_t*)&expressions_params[10][194+2];
    gl64_t kA959 = (tmp3_0 + tmp3_1) * (s1_959_0 + s1_959_1);
    gl64_t kB959 = (tmp3_0 + tmp3_2) * (s1_959_0 + s1_959_2);
    gl64_t kC959 = (tmp3_1 + tmp3_2) * (s1_959_1 + s1_959_2);
    gl64_t kD959 = tmp3_0 * s1_959_0;
    gl64_t kE959 = tmp3_1 * s1_959_1;
    gl64_t kF959 = tmp3_2 * s1_959_2;
    gl64_t kG959 = kD959 - kE959;
    tmp3_0 = (kC959 + kG959) - kF959;
    tmp3_1 = ((((kA959 + kC959) - kE959) - kE959) - kD959);
    tmp3_2 = kB959 - kG959;
    // Op 960: dim1x1 sub
    gl64_t s0_960 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_960 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_960 - s1_960;
    // Op 961: dim1x1 sub_swap
    gl64_t s1_961 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_961 - tmp1_0;
    // Op 962: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 963: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 964: dim3x3 mul
    gl64_t s1_964_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_964_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_964_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA964 = (tmp3_0 + tmp3_1) * (s1_964_0 + s1_964_1);
    gl64_t kB964 = (tmp3_0 + tmp3_2) * (s1_964_0 + s1_964_2);
    gl64_t kC964 = (tmp3_1 + tmp3_2) * (s1_964_1 + s1_964_2);
    gl64_t kD964 = tmp3_0 * s1_964_0;
    gl64_t kE964 = tmp3_1 * s1_964_1;
    gl64_t kF964 = tmp3_2 * s1_964_2;
    gl64_t kG964 = kD964 - kE964;
    tmp3_6 = (kC964 + kG964) - kF964;
    tmp3_7 = ((((kA964 + kC964) - kE964) - kE964) - kD964);
    tmp3_8 = kB964 - kG964;
    // Op 965: dim1x1 sub
    gl64_t s1_965 = *(gl64_t*)&expressions_params[10][80];
    tmp1_0 = tmp1_4 - s1_965;
    // Op 966: dim1x1 sub
    gl64_t s1_966 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_966;
    // Op 967: dim3x1 mul
    gl64_t s0_967_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_967_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_967_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_967_0 * tmp1_0; tmp3_1 = s0_967_1 * tmp1_0; tmp3_2 = s0_967_2 * tmp1_0;
    // Op 968: dim3x1 add
    gl64_t s1_968 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_968; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 969: dim3x3 add
    gl64_t s1_969_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_969_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_969_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_969_0; tmp3_1 = tmp3_1 + s1_969_1; tmp3_2 = tmp3_2 + s1_969_2;
    // Op 970: dim3x3 mul
    gl64_t s1_970_0 = *(gl64_t*)&expressions_params[10][197];
    gl64_t s1_970_1 = *(gl64_t*)&expressions_params[10][197+1];
    gl64_t s1_970_2 = *(gl64_t*)&expressions_params[10][197+2];
    gl64_t kA970 = (tmp3_0 + tmp3_1) * (s1_970_0 + s1_970_1);
    gl64_t kB970 = (tmp3_0 + tmp3_2) * (s1_970_0 + s1_970_2);
    gl64_t kC970 = (tmp3_1 + tmp3_2) * (s1_970_1 + s1_970_2);
    gl64_t kD970 = tmp3_0 * s1_970_0;
    gl64_t kE970 = tmp3_1 * s1_970_1;
    gl64_t kF970 = tmp3_2 * s1_970_2;
    gl64_t kG970 = kD970 - kE970;
    tmp3_0 = (kC970 + kG970) - kF970;
    tmp3_1 = ((((kA970 + kC970) - kE970) - kE970) - kD970);
    tmp3_2 = kB970 - kG970;
    // Op 971: dim3x1 add
    gl64_t s1_971 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_971; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 972: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 973: dim3x3 mul
    gl64_t s1_973_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_973_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_973_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA973 = (tmp3_0 + tmp3_1) * (s1_973_0 + s1_973_1);
    gl64_t kB973 = (tmp3_0 + tmp3_2) * (s1_973_0 + s1_973_2);
    gl64_t kC973 = (tmp3_1 + tmp3_2) * (s1_973_1 + s1_973_2);
    gl64_t kD973 = tmp3_0 * s1_973_0;
    gl64_t kE973 = tmp3_1 * s1_973_1;
    gl64_t kF973 = tmp3_2 * s1_973_2;
    gl64_t kG973 = kD973 - kE973;
    tmp3_6 = (kC973 + kG973) - kF973;
    tmp3_7 = ((((kA973 + kC973) - kE973) - kE973) - kD973);
    tmp3_8 = kB973 - kG973;
    // Op 974: dim3x1 mul
    gl64_t s0_974_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_974_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_974_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_974 = *(gl64_t*)&expressions_params[10][29];
    tmp3_0 = s0_974_0 * s1_974; tmp3_1 = s0_974_1 * s1_974; tmp3_2 = s0_974_2 * s1_974;
    // Op 975: dim3x1 add
    gl64_t s1_975 = *(gl64_t*)&expressions_params[10][28];
    tmp3_0 = tmp3_0 + s1_975; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 976: dim3x3 mul
    gl64_t s1_976_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_976_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_976_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA976 = (tmp3_0 + tmp3_1) * (s1_976_0 + s1_976_1);
    gl64_t kB976 = (tmp3_0 + tmp3_2) * (s1_976_0 + s1_976_2);
    gl64_t kC976 = (tmp3_1 + tmp3_2) * (s1_976_1 + s1_976_2);
    gl64_t kD976 = tmp3_0 * s1_976_0;
    gl64_t kE976 = tmp3_1 * s1_976_1;
    gl64_t kF976 = tmp3_2 * s1_976_2;
    gl64_t kG976 = kD976 - kE976;
    tmp3_0 = (kC976 + kG976) - kF976;
    tmp3_1 = ((((kA976 + kC976) - kE976) - kE976) - kD976);
    tmp3_2 = kB976 - kG976;
    // Op 977: dim3x1 add
    gl64_t s1_977 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_977; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 978: dim3x3 mul
    gl64_t s1_978_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_978_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_978_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA978 = (tmp3_0 + tmp3_1) * (s1_978_0 + s1_978_1);
    gl64_t kB978 = (tmp3_0 + tmp3_2) * (s1_978_0 + s1_978_2);
    gl64_t kC978 = (tmp3_1 + tmp3_2) * (s1_978_1 + s1_978_2);
    gl64_t kD978 = tmp3_0 * s1_978_0;
    gl64_t kE978 = tmp3_1 * s1_978_1;
    gl64_t kF978 = tmp3_2 * s1_978_2;
    gl64_t kG978 = kD978 - kE978;
    tmp3_0 = (kC978 + kG978) - kF978;
    tmp3_1 = ((((kA978 + kC978) - kE978) - kE978) - kD978);
    tmp3_2 = kB978 - kG978;
    // Op 979: dim3x1 add
    gl64_t s1_979 = *(gl64_t*)&expressions_params[10][80];
    tmp3_0 = tmp3_0 + s1_979; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 980: dim3x3 mul
    gl64_t s1_980_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_980_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_980_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA980 = (tmp3_0 + tmp3_1) * (s1_980_0 + s1_980_1);
    gl64_t kB980 = (tmp3_0 + tmp3_2) * (s1_980_0 + s1_980_2);
    gl64_t kC980 = (tmp3_1 + tmp3_2) * (s1_980_1 + s1_980_2);
    gl64_t kD980 = tmp3_0 * s1_980_0;
    gl64_t kE980 = tmp3_1 * s1_980_1;
    gl64_t kF980 = tmp3_2 * s1_980_2;
    gl64_t kG980 = kD980 - kE980;
    tmp3_0 = (kC980 + kG980) - kF980;
    tmp3_1 = ((((kA980 + kC980) - kE980) - kE980) - kD980);
    tmp3_2 = kB980 - kG980;
    // Op 981: dim3x1 add
    gl64_t s1_981 = *(gl64_t*)&expressions_params[9][28];
    tmp3_0 = tmp3_0 + s1_981; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 982: dim3x3 mul
    gl64_t s1_982_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_982_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_982_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA982 = (tmp3_0 + tmp3_1) * (s1_982_0 + s1_982_1);
    gl64_t kB982 = (tmp3_0 + tmp3_2) * (s1_982_0 + s1_982_2);
    gl64_t kC982 = (tmp3_1 + tmp3_2) * (s1_982_1 + s1_982_2);
    gl64_t kD982 = tmp3_0 * s1_982_0;
    gl64_t kE982 = tmp3_1 * s1_982_1;
    gl64_t kF982 = tmp3_2 * s1_982_2;
    gl64_t kG982 = kD982 - kE982;
    tmp3_0 = (kC982 + kG982) - kF982;
    tmp3_1 = ((((kA982 + kC982) - kE982) - kE982) - kD982);
    tmp3_2 = kB982 - kG982;
    // Op 983: dim3x1 add
    gl64_t s1_983 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_983; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 984: dim3x3 mul
    gl64_t s1_984_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_984_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_984_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA984 = (tmp3_0 + tmp3_1) * (s1_984_0 + s1_984_1);
    gl64_t kB984 = (tmp3_0 + tmp3_2) * (s1_984_0 + s1_984_2);
    gl64_t kC984 = (tmp3_1 + tmp3_2) * (s1_984_1 + s1_984_2);
    gl64_t kD984 = tmp3_0 * s1_984_0;
    gl64_t kE984 = tmp3_1 * s1_984_1;
    gl64_t kF984 = tmp3_2 * s1_984_2;
    gl64_t kG984 = kD984 - kE984;
    tmp3_0 = (kC984 + kG984) - kF984;
    tmp3_1 = ((((kA984 + kC984) - kE984) - kE984) - kD984);
    tmp3_2 = kB984 - kG984;
    // Op 985: dim3x1 add
    gl64_t s1_985 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_985; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 986: dim3x3 add
    gl64_t s1_986_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_986_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_986_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_986_0; tmp3_1 = tmp3_1 + s1_986_1; tmp3_2 = tmp3_2 + s1_986_2;
    // Op 987: dim3x3 mul
    gl64_t s1_987_0 = *(gl64_t*)&expressions_params[10][200];
    gl64_t s1_987_1 = *(gl64_t*)&expressions_params[10][200+1];
    gl64_t s1_987_2 = *(gl64_t*)&expressions_params[10][200+2];
    gl64_t kA987 = (tmp3_0 + tmp3_1) * (s1_987_0 + s1_987_1);
    gl64_t kB987 = (tmp3_0 + tmp3_2) * (s1_987_0 + s1_987_2);
    gl64_t kC987 = (tmp3_1 + tmp3_2) * (s1_987_1 + s1_987_2);
    gl64_t kD987 = tmp3_0 * s1_987_0;
    gl64_t kE987 = tmp3_1 * s1_987_1;
    gl64_t kF987 = tmp3_2 * s1_987_2;
    gl64_t kG987 = kD987 - kE987;
    tmp3_0 = (kC987 + kG987) - kF987;
    tmp3_1 = ((((kA987 + kC987) - kE987) - kE987) - kD987);
    tmp3_2 = kB987 - kG987;
    // Op 988: dim3x1 sub
    gl64_t s1_988 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_988; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 989: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 990: dim3x3 mul
    gl64_t s1_990_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_990_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_990_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA990 = (tmp3_0 + tmp3_1) * (s1_990_0 + s1_990_1);
    gl64_t kB990 = (tmp3_0 + tmp3_2) * (s1_990_0 + s1_990_2);
    gl64_t kC990 = (tmp3_1 + tmp3_2) * (s1_990_1 + s1_990_2);
    gl64_t kD990 = tmp3_0 * s1_990_0;
    gl64_t kE990 = tmp3_1 * s1_990_1;
    gl64_t kF990 = tmp3_2 * s1_990_2;
    gl64_t kG990 = kD990 - kE990;
    tmp3_6 = (kC990 + kG990) - kF990;
    tmp3_7 = ((((kA990 + kC990) - kE990) - kE990) - kD990);
    tmp3_8 = kB990 - kG990;
    // Op 991: dim3x1 mul
    gl64_t s0_991_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_991_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_991_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_991 = *(gl64_t*)&expressions_params[10][29];
    tmp3_0 = s0_991_0 * s1_991; tmp3_1 = s0_991_1 * s1_991; tmp3_2 = s0_991_2 * s1_991;
    // Op 992: dim3x1 add
    gl64_t s1_992 = *(gl64_t*)&expressions_params[10][28];
    tmp3_0 = tmp3_0 + s1_992; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 993: dim3x3 mul
    gl64_t s1_993_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_993_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_993_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA993 = (tmp3_0 + tmp3_1) * (s1_993_0 + s1_993_1);
    gl64_t kB993 = (tmp3_0 + tmp3_2) * (s1_993_0 + s1_993_2);
    gl64_t kC993 = (tmp3_1 + tmp3_2) * (s1_993_1 + s1_993_2);
    gl64_t kD993 = tmp3_0 * s1_993_0;
    gl64_t kE993 = tmp3_1 * s1_993_1;
    gl64_t kF993 = tmp3_2 * s1_993_2;
    gl64_t kG993 = kD993 - kE993;
    tmp3_0 = (kC993 + kG993) - kF993;
    tmp3_1 = ((((kA993 + kC993) - kE993) - kE993) - kD993);
    tmp3_2 = kB993 - kG993;
    // Op 994: dim3x1 add
    gl64_t s1_994 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_994; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 995: dim3x3 mul
    gl64_t s1_995_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_995_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_995_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA995 = (tmp3_0 + tmp3_1) * (s1_995_0 + s1_995_1);
    gl64_t kB995 = (tmp3_0 + tmp3_2) * (s1_995_0 + s1_995_2);
    gl64_t kC995 = (tmp3_1 + tmp3_2) * (s1_995_1 + s1_995_2);
    gl64_t kD995 = tmp3_0 * s1_995_0;
    gl64_t kE995 = tmp3_1 * s1_995_1;
    gl64_t kF995 = tmp3_2 * s1_995_2;
    gl64_t kG995 = kD995 - kE995;
    tmp3_0 = (kC995 + kG995) - kF995;
    tmp3_1 = ((((kA995 + kC995) - kE995) - kE995) - kD995);
    tmp3_2 = kB995 - kG995;
    // Op 996: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 997: dim3x3 mul
    gl64_t s1_997_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_997_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_997_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA997 = (tmp3_0 + tmp3_1) * (s1_997_0 + s1_997_1);
    gl64_t kB997 = (tmp3_0 + tmp3_2) * (s1_997_0 + s1_997_2);
    gl64_t kC997 = (tmp3_1 + tmp3_2) * (s1_997_1 + s1_997_2);
    gl64_t kD997 = tmp3_0 * s1_997_0;
    gl64_t kE997 = tmp3_1 * s1_997_1;
    gl64_t kF997 = tmp3_2 * s1_997_2;
    gl64_t kG997 = kD997 - kE997;
    tmp3_0 = (kC997 + kG997) - kF997;
    tmp3_1 = ((((kA997 + kC997) - kE997) - kE997) - kD997);
    tmp3_2 = kB997 - kG997;
    // Op 998: dim3x1 add
    gl64_t s1_998 = *(gl64_t*)&expressions_params[9][28];
    tmp3_0 = tmp3_0 + s1_998; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 999: dim3x3 mul
    gl64_t s1_999_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_999_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_999_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA999 = (tmp3_0 + tmp3_1) * (s1_999_0 + s1_999_1);
    gl64_t kB999 = (tmp3_0 + tmp3_2) * (s1_999_0 + s1_999_2);
    gl64_t kC999 = (tmp3_1 + tmp3_2) * (s1_999_1 + s1_999_2);
    gl64_t kD999 = tmp3_0 * s1_999_0;
    gl64_t kE999 = tmp3_1 * s1_999_1;
    gl64_t kF999 = tmp3_2 * s1_999_2;
    gl64_t kG999 = kD999 - kE999;
    tmp3_0 = (kC999 + kG999) - kF999;
    tmp3_1 = ((((kA999 + kC999) - kE999) - kE999) - kD999);
    tmp3_2 = kB999 - kG999;
    // Op 1000: dim3x1 add
    gl64_t s1_1000 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1000; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1001: dim3x3 mul
    gl64_t s1_1001_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1001_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1001_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1001 = (tmp3_0 + tmp3_1) * (s1_1001_0 + s1_1001_1);
    gl64_t kB1001 = (tmp3_0 + tmp3_2) * (s1_1001_0 + s1_1001_2);
    gl64_t kC1001 = (tmp3_1 + tmp3_2) * (s1_1001_1 + s1_1001_2);
    gl64_t kD1001 = tmp3_0 * s1_1001_0;
    gl64_t kE1001 = tmp3_1 * s1_1001_1;
    gl64_t kF1001 = tmp3_2 * s1_1001_2;
    gl64_t kG1001 = kD1001 - kE1001;
    tmp3_0 = (kC1001 + kG1001) - kF1001;
    tmp3_1 = ((((kA1001 + kC1001) - kE1001) - kE1001) - kD1001);
    tmp3_2 = kB1001 - kG1001;
    // Op 1002: dim3x1 add
    gl64_t s1_1002 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1002; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1003: dim3x3 add
    gl64_t s1_1003_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1003_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1003_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1003_0; tmp3_1 = tmp3_1 + s1_1003_1; tmp3_2 = tmp3_2 + s1_1003_2;
    // Op 1004: dim3x3 mul
    gl64_t s1_1004_0 = *(gl64_t*)&expressions_params[10][203];
    gl64_t s1_1004_1 = *(gl64_t*)&expressions_params[10][203+1];
    gl64_t s1_1004_2 = *(gl64_t*)&expressions_params[10][203+2];
    gl64_t kA1004 = (tmp3_0 + tmp3_1) * (s1_1004_0 + s1_1004_1);
    gl64_t kB1004 = (tmp3_0 + tmp3_2) * (s1_1004_0 + s1_1004_2);
    gl64_t kC1004 = (tmp3_1 + tmp3_2) * (s1_1004_1 + s1_1004_2);
    gl64_t kD1004 = tmp3_0 * s1_1004_0;
    gl64_t kE1004 = tmp3_1 * s1_1004_1;
    gl64_t kF1004 = tmp3_2 * s1_1004_2;
    gl64_t kG1004 = kD1004 - kE1004;
    tmp3_0 = (kC1004 + kG1004) - kF1004;
    tmp3_1 = ((((kA1004 + kC1004) - kE1004) - kE1004) - kD1004);
    tmp3_2 = kB1004 - kG1004;
    // Op 1005: dim1x1 sub
    gl64_t s0_1005 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1005 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1005 - s1_1005;
    // Op 1006: dim1x1 sub_swap
    gl64_t s1_1006 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1006 - tmp1_0;
    // Op 1007: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1008: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1009: dim3x3 mul
    gl64_t s1_1009_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1009_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1009_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1009 = (tmp3_0 + tmp3_1) * (s1_1009_0 + s1_1009_1);
    gl64_t kB1009 = (tmp3_0 + tmp3_2) * (s1_1009_0 + s1_1009_2);
    gl64_t kC1009 = (tmp3_1 + tmp3_2) * (s1_1009_1 + s1_1009_2);
    gl64_t kD1009 = tmp3_0 * s1_1009_0;
    gl64_t kE1009 = tmp3_1 * s1_1009_1;
    gl64_t kF1009 = tmp3_2 * s1_1009_2;
    gl64_t kG1009 = kD1009 - kE1009;
    tmp3_6 = (kC1009 + kG1009) - kF1009;
    tmp3_7 = ((((kA1009 + kC1009) - kE1009) - kE1009) - kD1009);
    tmp3_8 = kB1009 - kG1009;
    // Op 1010: dim1x1 sub
    gl64_t s1_1010 = *(gl64_t*)&expressions_params[10][81];
    tmp1_0 = tmp1_4 - s1_1010;
    // Op 1011: dim1x1 sub
    gl64_t s1_1011 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1011;
    // Op 1012: dim3x1 mul
    gl64_t s0_1012_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1012_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1012_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1012_0 * tmp1_0; tmp3_1 = s0_1012_1 * tmp1_0; tmp3_2 = s0_1012_2 * tmp1_0;
    // Op 1013: dim3x1 add
    gl64_t s1_1013 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1013; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1014: dim3x3 add
    gl64_t s1_1014_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1014_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1014_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1014_0; tmp3_1 = tmp3_1 + s1_1014_1; tmp3_2 = tmp3_2 + s1_1014_2;
    // Op 1015: dim3x3 mul
    gl64_t s1_1015_0 = *(gl64_t*)&expressions_params[10][206];
    gl64_t s1_1015_1 = *(gl64_t*)&expressions_params[10][206+1];
    gl64_t s1_1015_2 = *(gl64_t*)&expressions_params[10][206+2];
    gl64_t kA1015 = (tmp3_0 + tmp3_1) * (s1_1015_0 + s1_1015_1);
    gl64_t kB1015 = (tmp3_0 + tmp3_2) * (s1_1015_0 + s1_1015_2);
    gl64_t kC1015 = (tmp3_1 + tmp3_2) * (s1_1015_1 + s1_1015_2);
    gl64_t kD1015 = tmp3_0 * s1_1015_0;
    gl64_t kE1015 = tmp3_1 * s1_1015_1;
    gl64_t kF1015 = tmp3_2 * s1_1015_2;
    gl64_t kG1015 = kD1015 - kE1015;
    tmp3_0 = (kC1015 + kG1015) - kF1015;
    tmp3_1 = ((((kA1015 + kC1015) - kE1015) - kE1015) - kD1015);
    tmp3_2 = kB1015 - kG1015;
    // Op 1016: dim3x1 add
    gl64_t s1_1016 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1016; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1017: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1018: dim3x3 mul
    gl64_t s1_1018_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1018_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1018_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1018 = (tmp3_0 + tmp3_1) * (s1_1018_0 + s1_1018_1);
    gl64_t kB1018 = (tmp3_0 + tmp3_2) * (s1_1018_0 + s1_1018_2);
    gl64_t kC1018 = (tmp3_1 + tmp3_2) * (s1_1018_1 + s1_1018_2);
    gl64_t kD1018 = tmp3_0 * s1_1018_0;
    gl64_t kE1018 = tmp3_1 * s1_1018_1;
    gl64_t kF1018 = tmp3_2 * s1_1018_2;
    gl64_t kG1018 = kD1018 - kE1018;
    tmp3_6 = (kC1018 + kG1018) - kF1018;
    tmp3_7 = ((((kA1018 + kC1018) - kE1018) - kE1018) - kD1018);
    tmp3_8 = kB1018 - kG1018;
    // Op 1019: dim3x1 mul
    gl64_t s0_1019_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1019_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1019_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1019 = *(gl64_t*)&expressions_params[10][31];
    tmp3_0 = s0_1019_0 * s1_1019; tmp3_1 = s0_1019_1 * s1_1019; tmp3_2 = s0_1019_2 * s1_1019;
    // Op 1020: dim3x1 add
    gl64_t s1_1020 = *(gl64_t*)&expressions_params[10][30];
    tmp3_0 = tmp3_0 + s1_1020; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1021: dim3x3 mul
    gl64_t s1_1021_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1021_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1021_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1021 = (tmp3_0 + tmp3_1) * (s1_1021_0 + s1_1021_1);
    gl64_t kB1021 = (tmp3_0 + tmp3_2) * (s1_1021_0 + s1_1021_2);
    gl64_t kC1021 = (tmp3_1 + tmp3_2) * (s1_1021_1 + s1_1021_2);
    gl64_t kD1021 = tmp3_0 * s1_1021_0;
    gl64_t kE1021 = tmp3_1 * s1_1021_1;
    gl64_t kF1021 = tmp3_2 * s1_1021_2;
    gl64_t kG1021 = kD1021 - kE1021;
    tmp3_0 = (kC1021 + kG1021) - kF1021;
    tmp3_1 = ((((kA1021 + kC1021) - kE1021) - kE1021) - kD1021);
    tmp3_2 = kB1021 - kG1021;
    // Op 1022: dim3x1 add
    gl64_t s1_1022 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1022; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1023: dim3x3 mul
    gl64_t s1_1023_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1023_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1023_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1023 = (tmp3_0 + tmp3_1) * (s1_1023_0 + s1_1023_1);
    gl64_t kB1023 = (tmp3_0 + tmp3_2) * (s1_1023_0 + s1_1023_2);
    gl64_t kC1023 = (tmp3_1 + tmp3_2) * (s1_1023_1 + s1_1023_2);
    gl64_t kD1023 = tmp3_0 * s1_1023_0;
    gl64_t kE1023 = tmp3_1 * s1_1023_1;
    gl64_t kF1023 = tmp3_2 * s1_1023_2;
    gl64_t kG1023 = kD1023 - kE1023;
    tmp3_0 = (kC1023 + kG1023) - kF1023;
    tmp3_1 = ((((kA1023 + kC1023) - kE1023) - kE1023) - kD1023);
    tmp3_2 = kB1023 - kG1023;
    // Op 1024: dim3x1 add
    gl64_t s1_1024 = *(gl64_t*)&expressions_params[10][81];
    tmp3_0 = tmp3_0 + s1_1024; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1025: dim3x3 mul
    gl64_t s1_1025_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1025_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1025_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1025 = (tmp3_0 + tmp3_1) * (s1_1025_0 + s1_1025_1);
    gl64_t kB1025 = (tmp3_0 + tmp3_2) * (s1_1025_0 + s1_1025_2);
    gl64_t kC1025 = (tmp3_1 + tmp3_2) * (s1_1025_1 + s1_1025_2);
    gl64_t kD1025 = tmp3_0 * s1_1025_0;
    gl64_t kE1025 = tmp3_1 * s1_1025_1;
    gl64_t kF1025 = tmp3_2 * s1_1025_2;
    gl64_t kG1025 = kD1025 - kE1025;
    tmp3_0 = (kC1025 + kG1025) - kF1025;
    tmp3_1 = ((((kA1025 + kC1025) - kE1025) - kE1025) - kD1025);
    tmp3_2 = kB1025 - kG1025;
    // Op 1026: dim3x1 add
    gl64_t s1_1026 = *(gl64_t*)&expressions_params[9][29];
    tmp3_0 = tmp3_0 + s1_1026; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1027: dim3x3 mul
    gl64_t s1_1027_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1027_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1027_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1027 = (tmp3_0 + tmp3_1) * (s1_1027_0 + s1_1027_1);
    gl64_t kB1027 = (tmp3_0 + tmp3_2) * (s1_1027_0 + s1_1027_2);
    gl64_t kC1027 = (tmp3_1 + tmp3_2) * (s1_1027_1 + s1_1027_2);
    gl64_t kD1027 = tmp3_0 * s1_1027_0;
    gl64_t kE1027 = tmp3_1 * s1_1027_1;
    gl64_t kF1027 = tmp3_2 * s1_1027_2;
    gl64_t kG1027 = kD1027 - kE1027;
    tmp3_0 = (kC1027 + kG1027) - kF1027;
    tmp3_1 = ((((kA1027 + kC1027) - kE1027) - kE1027) - kD1027);
    tmp3_2 = kB1027 - kG1027;
    // Op 1028: dim3x1 add
    gl64_t s1_1028 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1028; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1029: dim3x3 mul
    gl64_t s1_1029_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1029_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1029_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1029 = (tmp3_0 + tmp3_1) * (s1_1029_0 + s1_1029_1);
    gl64_t kB1029 = (tmp3_0 + tmp3_2) * (s1_1029_0 + s1_1029_2);
    gl64_t kC1029 = (tmp3_1 + tmp3_2) * (s1_1029_1 + s1_1029_2);
    gl64_t kD1029 = tmp3_0 * s1_1029_0;
    gl64_t kE1029 = tmp3_1 * s1_1029_1;
    gl64_t kF1029 = tmp3_2 * s1_1029_2;
    gl64_t kG1029 = kD1029 - kE1029;
    tmp3_0 = (kC1029 + kG1029) - kF1029;
    tmp3_1 = ((((kA1029 + kC1029) - kE1029) - kE1029) - kD1029);
    tmp3_2 = kB1029 - kG1029;
    // Op 1030: dim3x1 add
    gl64_t s1_1030 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1030; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1031: dim3x3 add
    gl64_t s1_1031_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1031_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1031_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1031_0; tmp3_1 = tmp3_1 + s1_1031_1; tmp3_2 = tmp3_2 + s1_1031_2;
    // Op 1032: dim3x3 mul
    gl64_t s1_1032_0 = *(gl64_t*)&expressions_params[10][209];
    gl64_t s1_1032_1 = *(gl64_t*)&expressions_params[10][209+1];
    gl64_t s1_1032_2 = *(gl64_t*)&expressions_params[10][209+2];
    gl64_t kA1032 = (tmp3_0 + tmp3_1) * (s1_1032_0 + s1_1032_1);
    gl64_t kB1032 = (tmp3_0 + tmp3_2) * (s1_1032_0 + s1_1032_2);
    gl64_t kC1032 = (tmp3_1 + tmp3_2) * (s1_1032_1 + s1_1032_2);
    gl64_t kD1032 = tmp3_0 * s1_1032_0;
    gl64_t kE1032 = tmp3_1 * s1_1032_1;
    gl64_t kF1032 = tmp3_2 * s1_1032_2;
    gl64_t kG1032 = kD1032 - kE1032;
    tmp3_0 = (kC1032 + kG1032) - kF1032;
    tmp3_1 = ((((kA1032 + kC1032) - kE1032) - kE1032) - kD1032);
    tmp3_2 = kB1032 - kG1032;
    // Op 1033: dim3x1 sub
    gl64_t s1_1033 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1033; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1034: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1035: dim3x3 mul
    gl64_t s1_1035_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1035_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1035_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1035 = (tmp3_0 + tmp3_1) * (s1_1035_0 + s1_1035_1);
    gl64_t kB1035 = (tmp3_0 + tmp3_2) * (s1_1035_0 + s1_1035_2);
    gl64_t kC1035 = (tmp3_1 + tmp3_2) * (s1_1035_1 + s1_1035_2);
    gl64_t kD1035 = tmp3_0 * s1_1035_0;
    gl64_t kE1035 = tmp3_1 * s1_1035_1;
    gl64_t kF1035 = tmp3_2 * s1_1035_2;
    gl64_t kG1035 = kD1035 - kE1035;
    tmp3_6 = (kC1035 + kG1035) - kF1035;
    tmp3_7 = ((((kA1035 + kC1035) - kE1035) - kE1035) - kD1035);
    tmp3_8 = kB1035 - kG1035;
    // Op 1036: dim3x1 mul
    gl64_t s0_1036_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1036_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1036_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1036 = *(gl64_t*)&expressions_params[10][31];
    tmp3_0 = s0_1036_0 * s1_1036; tmp3_1 = s0_1036_1 * s1_1036; tmp3_2 = s0_1036_2 * s1_1036;
    // Op 1037: dim3x1 add
    gl64_t s1_1037 = *(gl64_t*)&expressions_params[10][30];
    tmp3_0 = tmp3_0 + s1_1037; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1038: dim3x3 mul
    gl64_t s1_1038_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1038_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1038_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1038 = (tmp3_0 + tmp3_1) * (s1_1038_0 + s1_1038_1);
    gl64_t kB1038 = (tmp3_0 + tmp3_2) * (s1_1038_0 + s1_1038_2);
    gl64_t kC1038 = (tmp3_1 + tmp3_2) * (s1_1038_1 + s1_1038_2);
    gl64_t kD1038 = tmp3_0 * s1_1038_0;
    gl64_t kE1038 = tmp3_1 * s1_1038_1;
    gl64_t kF1038 = tmp3_2 * s1_1038_2;
    gl64_t kG1038 = kD1038 - kE1038;
    tmp3_0 = (kC1038 + kG1038) - kF1038;
    tmp3_1 = ((((kA1038 + kC1038) - kE1038) - kE1038) - kD1038);
    tmp3_2 = kB1038 - kG1038;
    // Op 1039: dim3x1 add
    gl64_t s1_1039 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1039; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1040: dim3x3 mul
    gl64_t s1_1040_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1040_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1040_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1040 = (tmp3_0 + tmp3_1) * (s1_1040_0 + s1_1040_1);
    gl64_t kB1040 = (tmp3_0 + tmp3_2) * (s1_1040_0 + s1_1040_2);
    gl64_t kC1040 = (tmp3_1 + tmp3_2) * (s1_1040_1 + s1_1040_2);
    gl64_t kD1040 = tmp3_0 * s1_1040_0;
    gl64_t kE1040 = tmp3_1 * s1_1040_1;
    gl64_t kF1040 = tmp3_2 * s1_1040_2;
    gl64_t kG1040 = kD1040 - kE1040;
    tmp3_0 = (kC1040 + kG1040) - kF1040;
    tmp3_1 = ((((kA1040 + kC1040) - kE1040) - kE1040) - kD1040);
    tmp3_2 = kB1040 - kG1040;
    // Op 1041: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1042: dim3x3 mul
    gl64_t s1_1042_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1042_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1042_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1042 = (tmp3_0 + tmp3_1) * (s1_1042_0 + s1_1042_1);
    gl64_t kB1042 = (tmp3_0 + tmp3_2) * (s1_1042_0 + s1_1042_2);
    gl64_t kC1042 = (tmp3_1 + tmp3_2) * (s1_1042_1 + s1_1042_2);
    gl64_t kD1042 = tmp3_0 * s1_1042_0;
    gl64_t kE1042 = tmp3_1 * s1_1042_1;
    gl64_t kF1042 = tmp3_2 * s1_1042_2;
    gl64_t kG1042 = kD1042 - kE1042;
    tmp3_0 = (kC1042 + kG1042) - kF1042;
    tmp3_1 = ((((kA1042 + kC1042) - kE1042) - kE1042) - kD1042);
    tmp3_2 = kB1042 - kG1042;
    // Op 1043: dim3x1 add
    gl64_t s1_1043 = *(gl64_t*)&expressions_params[9][29];
    tmp3_0 = tmp3_0 + s1_1043; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1044: dim3x3 mul
    gl64_t s1_1044_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1044_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1044_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1044 = (tmp3_0 + tmp3_1) * (s1_1044_0 + s1_1044_1);
    gl64_t kB1044 = (tmp3_0 + tmp3_2) * (s1_1044_0 + s1_1044_2);
    gl64_t kC1044 = (tmp3_1 + tmp3_2) * (s1_1044_1 + s1_1044_2);
    gl64_t kD1044 = tmp3_0 * s1_1044_0;
    gl64_t kE1044 = tmp3_1 * s1_1044_1;
    gl64_t kF1044 = tmp3_2 * s1_1044_2;
    gl64_t kG1044 = kD1044 - kE1044;
    tmp3_0 = (kC1044 + kG1044) - kF1044;
    tmp3_1 = ((((kA1044 + kC1044) - kE1044) - kE1044) - kD1044);
    tmp3_2 = kB1044 - kG1044;
    // Op 1045: dim3x1 add
    gl64_t s1_1045 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1045; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1046: dim3x3 mul
    gl64_t s1_1046_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1046_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1046_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1046 = (tmp3_0 + tmp3_1) * (s1_1046_0 + s1_1046_1);
    gl64_t kB1046 = (tmp3_0 + tmp3_2) * (s1_1046_0 + s1_1046_2);
    gl64_t kC1046 = (tmp3_1 + tmp3_2) * (s1_1046_1 + s1_1046_2);
    gl64_t kD1046 = tmp3_0 * s1_1046_0;
    gl64_t kE1046 = tmp3_1 * s1_1046_1;
    gl64_t kF1046 = tmp3_2 * s1_1046_2;
    gl64_t kG1046 = kD1046 - kE1046;
    tmp3_0 = (kC1046 + kG1046) - kF1046;
    tmp3_1 = ((((kA1046 + kC1046) - kE1046) - kE1046) - kD1046);
    tmp3_2 = kB1046 - kG1046;
    // Op 1047: dim3x1 add
    gl64_t s1_1047 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1047; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1048: dim3x3 add
    gl64_t s1_1048_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1048_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1048_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1048_0; tmp3_1 = tmp3_1 + s1_1048_1; tmp3_2 = tmp3_2 + s1_1048_2;
    // Op 1049: dim3x3 mul
    gl64_t s1_1049_0 = *(gl64_t*)&expressions_params[10][212];
    gl64_t s1_1049_1 = *(gl64_t*)&expressions_params[10][212+1];
    gl64_t s1_1049_2 = *(gl64_t*)&expressions_params[10][212+2];
    gl64_t kA1049 = (tmp3_0 + tmp3_1) * (s1_1049_0 + s1_1049_1);
    gl64_t kB1049 = (tmp3_0 + tmp3_2) * (s1_1049_0 + s1_1049_2);
    gl64_t kC1049 = (tmp3_1 + tmp3_2) * (s1_1049_1 + s1_1049_2);
    gl64_t kD1049 = tmp3_0 * s1_1049_0;
    gl64_t kE1049 = tmp3_1 * s1_1049_1;
    gl64_t kF1049 = tmp3_2 * s1_1049_2;
    gl64_t kG1049 = kD1049 - kE1049;
    tmp3_0 = (kC1049 + kG1049) - kF1049;
    tmp3_1 = ((((kA1049 + kC1049) - kE1049) - kE1049) - kD1049);
    tmp3_2 = kB1049 - kG1049;
    // Op 1050: dim1x1 sub
    gl64_t s0_1050 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1050 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1050 - s1_1050;
    // Op 1051: dim1x1 sub_swap
    gl64_t s1_1051 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1051 - tmp1_0;
    // Op 1052: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1053: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1054: dim3x3 mul
    gl64_t s1_1054_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1054_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1054_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1054 = (tmp3_0 + tmp3_1) * (s1_1054_0 + s1_1054_1);
    gl64_t kB1054 = (tmp3_0 + tmp3_2) * (s1_1054_0 + s1_1054_2);
    gl64_t kC1054 = (tmp3_1 + tmp3_2) * (s1_1054_1 + s1_1054_2);
    gl64_t kD1054 = tmp3_0 * s1_1054_0;
    gl64_t kE1054 = tmp3_1 * s1_1054_1;
    gl64_t kF1054 = tmp3_2 * s1_1054_2;
    gl64_t kG1054 = kD1054 - kE1054;
    tmp3_6 = (kC1054 + kG1054) - kF1054;
    tmp3_7 = ((((kA1054 + kC1054) - kE1054) - kE1054) - kD1054);
    tmp3_8 = kB1054 - kG1054;
    // Op 1055: dim1x1 sub
    gl64_t s1_1055 = *(gl64_t*)&expressions_params[10][82];
    tmp1_0 = tmp1_4 - s1_1055;
    // Op 1056: dim1x1 sub
    gl64_t s1_1056 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1056;
    // Op 1057: dim3x1 mul
    gl64_t s0_1057_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1057_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1057_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1057_0 * tmp1_0; tmp3_1 = s0_1057_1 * tmp1_0; tmp3_2 = s0_1057_2 * tmp1_0;
    // Op 1058: dim3x1 add
    gl64_t s1_1058 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1058; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1059: dim3x3 add
    gl64_t s1_1059_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1059_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1059_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1059_0; tmp3_1 = tmp3_1 + s1_1059_1; tmp3_2 = tmp3_2 + s1_1059_2;
    // Op 1060: dim3x3 mul
    gl64_t s1_1060_0 = *(gl64_t*)&expressions_params[10][215];
    gl64_t s1_1060_1 = *(gl64_t*)&expressions_params[10][215+1];
    gl64_t s1_1060_2 = *(gl64_t*)&expressions_params[10][215+2];
    gl64_t kA1060 = (tmp3_0 + tmp3_1) * (s1_1060_0 + s1_1060_1);
    gl64_t kB1060 = (tmp3_0 + tmp3_2) * (s1_1060_0 + s1_1060_2);
    gl64_t kC1060 = (tmp3_1 + tmp3_2) * (s1_1060_1 + s1_1060_2);
    gl64_t kD1060 = tmp3_0 * s1_1060_0;
    gl64_t kE1060 = tmp3_1 * s1_1060_1;
    gl64_t kF1060 = tmp3_2 * s1_1060_2;
    gl64_t kG1060 = kD1060 - kE1060;
    tmp3_0 = (kC1060 + kG1060) - kF1060;
    tmp3_1 = ((((kA1060 + kC1060) - kE1060) - kE1060) - kD1060);
    tmp3_2 = kB1060 - kG1060;
    // Op 1061: dim3x1 add
    gl64_t s1_1061 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1061; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1062: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1063: dim3x3 mul
    gl64_t s1_1063_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1063_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1063_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1063 = (tmp3_0 + tmp3_1) * (s1_1063_0 + s1_1063_1);
    gl64_t kB1063 = (tmp3_0 + tmp3_2) * (s1_1063_0 + s1_1063_2);
    gl64_t kC1063 = (tmp3_1 + tmp3_2) * (s1_1063_1 + s1_1063_2);
    gl64_t kD1063 = tmp3_0 * s1_1063_0;
    gl64_t kE1063 = tmp3_1 * s1_1063_1;
    gl64_t kF1063 = tmp3_2 * s1_1063_2;
    gl64_t kG1063 = kD1063 - kE1063;
    tmp3_6 = (kC1063 + kG1063) - kF1063;
    tmp3_7 = ((((kA1063 + kC1063) - kE1063) - kE1063) - kD1063);
    tmp3_8 = kB1063 - kG1063;
    // Op 1064: dim3x1 mul
    gl64_t s0_1064_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1064_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1064_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1064 = *(gl64_t*)&expressions_params[10][33];
    tmp3_0 = s0_1064_0 * s1_1064; tmp3_1 = s0_1064_1 * s1_1064; tmp3_2 = s0_1064_2 * s1_1064;
    // Op 1065: dim3x1 add
    gl64_t s1_1065 = *(gl64_t*)&expressions_params[10][32];
    tmp3_0 = tmp3_0 + s1_1065; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1066: dim3x3 mul
    gl64_t s1_1066_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1066_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1066_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1066 = (tmp3_0 + tmp3_1) * (s1_1066_0 + s1_1066_1);
    gl64_t kB1066 = (tmp3_0 + tmp3_2) * (s1_1066_0 + s1_1066_2);
    gl64_t kC1066 = (tmp3_1 + tmp3_2) * (s1_1066_1 + s1_1066_2);
    gl64_t kD1066 = tmp3_0 * s1_1066_0;
    gl64_t kE1066 = tmp3_1 * s1_1066_1;
    gl64_t kF1066 = tmp3_2 * s1_1066_2;
    gl64_t kG1066 = kD1066 - kE1066;
    tmp3_0 = (kC1066 + kG1066) - kF1066;
    tmp3_1 = ((((kA1066 + kC1066) - kE1066) - kE1066) - kD1066);
    tmp3_2 = kB1066 - kG1066;
    // Op 1067: dim3x1 add
    gl64_t s1_1067 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1067; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1068: dim3x3 mul
    gl64_t s1_1068_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1068_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1068_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1068 = (tmp3_0 + tmp3_1) * (s1_1068_0 + s1_1068_1);
    gl64_t kB1068 = (tmp3_0 + tmp3_2) * (s1_1068_0 + s1_1068_2);
    gl64_t kC1068 = (tmp3_1 + tmp3_2) * (s1_1068_1 + s1_1068_2);
    gl64_t kD1068 = tmp3_0 * s1_1068_0;
    gl64_t kE1068 = tmp3_1 * s1_1068_1;
    gl64_t kF1068 = tmp3_2 * s1_1068_2;
    gl64_t kG1068 = kD1068 - kE1068;
    tmp3_0 = (kC1068 + kG1068) - kF1068;
    tmp3_1 = ((((kA1068 + kC1068) - kE1068) - kE1068) - kD1068);
    tmp3_2 = kB1068 - kG1068;
    // Op 1069: dim3x1 add
    gl64_t s1_1069 = *(gl64_t*)&expressions_params[10][82];
    tmp3_0 = tmp3_0 + s1_1069; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1070: dim3x3 mul
    gl64_t s1_1070_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1070_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1070_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1070 = (tmp3_0 + tmp3_1) * (s1_1070_0 + s1_1070_1);
    gl64_t kB1070 = (tmp3_0 + tmp3_2) * (s1_1070_0 + s1_1070_2);
    gl64_t kC1070 = (tmp3_1 + tmp3_2) * (s1_1070_1 + s1_1070_2);
    gl64_t kD1070 = tmp3_0 * s1_1070_0;
    gl64_t kE1070 = tmp3_1 * s1_1070_1;
    gl64_t kF1070 = tmp3_2 * s1_1070_2;
    gl64_t kG1070 = kD1070 - kE1070;
    tmp3_0 = (kC1070 + kG1070) - kF1070;
    tmp3_1 = ((((kA1070 + kC1070) - kE1070) - kE1070) - kD1070);
    tmp3_2 = kB1070 - kG1070;
    // Op 1071: dim3x1 add
    gl64_t s1_1071 = *(gl64_t*)&expressions_params[9][30];
    tmp3_0 = tmp3_0 + s1_1071; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1072: dim3x3 mul
    gl64_t s1_1072_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1072_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1072_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1072 = (tmp3_0 + tmp3_1) * (s1_1072_0 + s1_1072_1);
    gl64_t kB1072 = (tmp3_0 + tmp3_2) * (s1_1072_0 + s1_1072_2);
    gl64_t kC1072 = (tmp3_1 + tmp3_2) * (s1_1072_1 + s1_1072_2);
    gl64_t kD1072 = tmp3_0 * s1_1072_0;
    gl64_t kE1072 = tmp3_1 * s1_1072_1;
    gl64_t kF1072 = tmp3_2 * s1_1072_2;
    gl64_t kG1072 = kD1072 - kE1072;
    tmp3_0 = (kC1072 + kG1072) - kF1072;
    tmp3_1 = ((((kA1072 + kC1072) - kE1072) - kE1072) - kD1072);
    tmp3_2 = kB1072 - kG1072;
    // Op 1073: dim3x1 add
    gl64_t s1_1073 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1073; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1074: dim3x3 mul
    gl64_t s1_1074_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1074_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1074_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1074 = (tmp3_0 + tmp3_1) * (s1_1074_0 + s1_1074_1);
    gl64_t kB1074 = (tmp3_0 + tmp3_2) * (s1_1074_0 + s1_1074_2);
    gl64_t kC1074 = (tmp3_1 + tmp3_2) * (s1_1074_1 + s1_1074_2);
    gl64_t kD1074 = tmp3_0 * s1_1074_0;
    gl64_t kE1074 = tmp3_1 * s1_1074_1;
    gl64_t kF1074 = tmp3_2 * s1_1074_2;
    gl64_t kG1074 = kD1074 - kE1074;
    tmp3_0 = (kC1074 + kG1074) - kF1074;
    tmp3_1 = ((((kA1074 + kC1074) - kE1074) - kE1074) - kD1074);
    tmp3_2 = kB1074 - kG1074;
    // Op 1075: dim3x1 add
    gl64_t s1_1075 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1075; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1076: dim3x3 add
    gl64_t s1_1076_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1076_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1076_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1076_0; tmp3_1 = tmp3_1 + s1_1076_1; tmp3_2 = tmp3_2 + s1_1076_2;
    // Op 1077: dim3x3 mul
    gl64_t s1_1077_0 = *(gl64_t*)&expressions_params[10][218];
    gl64_t s1_1077_1 = *(gl64_t*)&expressions_params[10][218+1];
    gl64_t s1_1077_2 = *(gl64_t*)&expressions_params[10][218+2];
    gl64_t kA1077 = (tmp3_0 + tmp3_1) * (s1_1077_0 + s1_1077_1);
    gl64_t kB1077 = (tmp3_0 + tmp3_2) * (s1_1077_0 + s1_1077_2);
    gl64_t kC1077 = (tmp3_1 + tmp3_2) * (s1_1077_1 + s1_1077_2);
    gl64_t kD1077 = tmp3_0 * s1_1077_0;
    gl64_t kE1077 = tmp3_1 * s1_1077_1;
    gl64_t kF1077 = tmp3_2 * s1_1077_2;
    gl64_t kG1077 = kD1077 - kE1077;
    tmp3_0 = (kC1077 + kG1077) - kF1077;
    tmp3_1 = ((((kA1077 + kC1077) - kE1077) - kE1077) - kD1077);
    tmp3_2 = kB1077 - kG1077;
    // Op 1078: dim3x1 sub
    gl64_t s1_1078 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1078; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1079: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1080: dim3x3 mul
    gl64_t s1_1080_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1080_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1080_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1080 = (tmp3_0 + tmp3_1) * (s1_1080_0 + s1_1080_1);
    gl64_t kB1080 = (tmp3_0 + tmp3_2) * (s1_1080_0 + s1_1080_2);
    gl64_t kC1080 = (tmp3_1 + tmp3_2) * (s1_1080_1 + s1_1080_2);
    gl64_t kD1080 = tmp3_0 * s1_1080_0;
    gl64_t kE1080 = tmp3_1 * s1_1080_1;
    gl64_t kF1080 = tmp3_2 * s1_1080_2;
    gl64_t kG1080 = kD1080 - kE1080;
    tmp3_6 = (kC1080 + kG1080) - kF1080;
    tmp3_7 = ((((kA1080 + kC1080) - kE1080) - kE1080) - kD1080);
    tmp3_8 = kB1080 - kG1080;
    // Op 1081: dim3x1 mul
    gl64_t s0_1081_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1081_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1081_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1081 = *(gl64_t*)&expressions_params[10][33];
    tmp3_0 = s0_1081_0 * s1_1081; tmp3_1 = s0_1081_1 * s1_1081; tmp3_2 = s0_1081_2 * s1_1081;
    // Op 1082: dim3x1 add
    gl64_t s1_1082 = *(gl64_t*)&expressions_params[10][32];
    tmp3_0 = tmp3_0 + s1_1082; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1083: dim3x3 mul
    gl64_t s1_1083_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1083_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1083_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1083 = (tmp3_0 + tmp3_1) * (s1_1083_0 + s1_1083_1);
    gl64_t kB1083 = (tmp3_0 + tmp3_2) * (s1_1083_0 + s1_1083_2);
    gl64_t kC1083 = (tmp3_1 + tmp3_2) * (s1_1083_1 + s1_1083_2);
    gl64_t kD1083 = tmp3_0 * s1_1083_0;
    gl64_t kE1083 = tmp3_1 * s1_1083_1;
    gl64_t kF1083 = tmp3_2 * s1_1083_2;
    gl64_t kG1083 = kD1083 - kE1083;
    tmp3_0 = (kC1083 + kG1083) - kF1083;
    tmp3_1 = ((((kA1083 + kC1083) - kE1083) - kE1083) - kD1083);
    tmp3_2 = kB1083 - kG1083;
    // Op 1084: dim3x1 add
    gl64_t s1_1084 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1084; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1085: dim3x3 mul
    gl64_t s1_1085_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1085_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1085_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1085 = (tmp3_0 + tmp3_1) * (s1_1085_0 + s1_1085_1);
    gl64_t kB1085 = (tmp3_0 + tmp3_2) * (s1_1085_0 + s1_1085_2);
    gl64_t kC1085 = (tmp3_1 + tmp3_2) * (s1_1085_1 + s1_1085_2);
    gl64_t kD1085 = tmp3_0 * s1_1085_0;
    gl64_t kE1085 = tmp3_1 * s1_1085_1;
    gl64_t kF1085 = tmp3_2 * s1_1085_2;
    gl64_t kG1085 = kD1085 - kE1085;
    tmp3_0 = (kC1085 + kG1085) - kF1085;
    tmp3_1 = ((((kA1085 + kC1085) - kE1085) - kE1085) - kD1085);
    tmp3_2 = kB1085 - kG1085;
    // Op 1086: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1087: dim3x3 mul
    gl64_t s1_1087_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1087_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1087_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1087 = (tmp3_0 + tmp3_1) * (s1_1087_0 + s1_1087_1);
    gl64_t kB1087 = (tmp3_0 + tmp3_2) * (s1_1087_0 + s1_1087_2);
    gl64_t kC1087 = (tmp3_1 + tmp3_2) * (s1_1087_1 + s1_1087_2);
    gl64_t kD1087 = tmp3_0 * s1_1087_0;
    gl64_t kE1087 = tmp3_1 * s1_1087_1;
    gl64_t kF1087 = tmp3_2 * s1_1087_2;
    gl64_t kG1087 = kD1087 - kE1087;
    tmp3_0 = (kC1087 + kG1087) - kF1087;
    tmp3_1 = ((((kA1087 + kC1087) - kE1087) - kE1087) - kD1087);
    tmp3_2 = kB1087 - kG1087;
    // Op 1088: dim3x1 add
    gl64_t s1_1088 = *(gl64_t*)&expressions_params[9][30];
    tmp3_0 = tmp3_0 + s1_1088; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1089: dim3x3 mul
    gl64_t s1_1089_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1089_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1089_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1089 = (tmp3_0 + tmp3_1) * (s1_1089_0 + s1_1089_1);
    gl64_t kB1089 = (tmp3_0 + tmp3_2) * (s1_1089_0 + s1_1089_2);
    gl64_t kC1089 = (tmp3_1 + tmp3_2) * (s1_1089_1 + s1_1089_2);
    gl64_t kD1089 = tmp3_0 * s1_1089_0;
    gl64_t kE1089 = tmp3_1 * s1_1089_1;
    gl64_t kF1089 = tmp3_2 * s1_1089_2;
    gl64_t kG1089 = kD1089 - kE1089;
    tmp3_0 = (kC1089 + kG1089) - kF1089;
    tmp3_1 = ((((kA1089 + kC1089) - kE1089) - kE1089) - kD1089);
    tmp3_2 = kB1089 - kG1089;
    // Op 1090: dim3x1 add
    gl64_t s1_1090 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1090; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1091: dim3x3 mul
    gl64_t s1_1091_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1091_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1091_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1091 = (tmp3_0 + tmp3_1) * (s1_1091_0 + s1_1091_1);
    gl64_t kB1091 = (tmp3_0 + tmp3_2) * (s1_1091_0 + s1_1091_2);
    gl64_t kC1091 = (tmp3_1 + tmp3_2) * (s1_1091_1 + s1_1091_2);
    gl64_t kD1091 = tmp3_0 * s1_1091_0;
    gl64_t kE1091 = tmp3_1 * s1_1091_1;
    gl64_t kF1091 = tmp3_2 * s1_1091_2;
    gl64_t kG1091 = kD1091 - kE1091;
    tmp3_0 = (kC1091 + kG1091) - kF1091;
    tmp3_1 = ((((kA1091 + kC1091) - kE1091) - kE1091) - kD1091);
    tmp3_2 = kB1091 - kG1091;
    // Op 1092: dim3x1 add
    gl64_t s1_1092 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1092; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1093: dim3x3 add
    gl64_t s1_1093_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1093_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1093_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1093_0; tmp3_1 = tmp3_1 + s1_1093_1; tmp3_2 = tmp3_2 + s1_1093_2;
    // Op 1094: dim3x3 mul
    gl64_t s1_1094_0 = *(gl64_t*)&expressions_params[10][221];
    gl64_t s1_1094_1 = *(gl64_t*)&expressions_params[10][221+1];
    gl64_t s1_1094_2 = *(gl64_t*)&expressions_params[10][221+2];
    gl64_t kA1094 = (tmp3_0 + tmp3_1) * (s1_1094_0 + s1_1094_1);
    gl64_t kB1094 = (tmp3_0 + tmp3_2) * (s1_1094_0 + s1_1094_2);
    gl64_t kC1094 = (tmp3_1 + tmp3_2) * (s1_1094_1 + s1_1094_2);
    gl64_t kD1094 = tmp3_0 * s1_1094_0;
    gl64_t kE1094 = tmp3_1 * s1_1094_1;
    gl64_t kF1094 = tmp3_2 * s1_1094_2;
    gl64_t kG1094 = kD1094 - kE1094;
    tmp3_0 = (kC1094 + kG1094) - kF1094;
    tmp3_1 = ((((kA1094 + kC1094) - kE1094) - kE1094) - kD1094);
    tmp3_2 = kB1094 - kG1094;
    // Op 1095: dim1x1 sub
    gl64_t s0_1095 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1095 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1095 - s1_1095;
    // Op 1096: dim1x1 sub_swap
    gl64_t s1_1096 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1096 - tmp1_0;
    // Op 1097: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1098: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1099: dim3x3 mul
    gl64_t s1_1099_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1099_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1099_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1099 = (tmp3_0 + tmp3_1) * (s1_1099_0 + s1_1099_1);
    gl64_t kB1099 = (tmp3_0 + tmp3_2) * (s1_1099_0 + s1_1099_2);
    gl64_t kC1099 = (tmp3_1 + tmp3_2) * (s1_1099_1 + s1_1099_2);
    gl64_t kD1099 = tmp3_0 * s1_1099_0;
    gl64_t kE1099 = tmp3_1 * s1_1099_1;
    gl64_t kF1099 = tmp3_2 * s1_1099_2;
    gl64_t kG1099 = kD1099 - kE1099;
    tmp3_6 = (kC1099 + kG1099) - kF1099;
    tmp3_7 = ((((kA1099 + kC1099) - kE1099) - kE1099) - kD1099);
    tmp3_8 = kB1099 - kG1099;
    // Op 1100: dim1x1 sub
    gl64_t s1_1100 = *(gl64_t*)&expressions_params[10][83];
    tmp1_0 = tmp1_4 - s1_1100;
    // Op 1101: dim1x1 sub
    gl64_t s1_1101 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1101;
    // Op 1102: dim3x1 mul
    gl64_t s0_1102_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1102_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1102_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1102_0 * tmp1_0; tmp3_1 = s0_1102_1 * tmp1_0; tmp3_2 = s0_1102_2 * tmp1_0;
    // Op 1103: dim3x1 add
    gl64_t s1_1103 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1103; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1104: dim3x3 add
    gl64_t s1_1104_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1104_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1104_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1104_0; tmp3_1 = tmp3_1 + s1_1104_1; tmp3_2 = tmp3_2 + s1_1104_2;
    // Op 1105: dim3x3 mul
    gl64_t s1_1105_0 = *(gl64_t*)&expressions_params[10][224];
    gl64_t s1_1105_1 = *(gl64_t*)&expressions_params[10][224+1];
    gl64_t s1_1105_2 = *(gl64_t*)&expressions_params[10][224+2];
    gl64_t kA1105 = (tmp3_0 + tmp3_1) * (s1_1105_0 + s1_1105_1);
    gl64_t kB1105 = (tmp3_0 + tmp3_2) * (s1_1105_0 + s1_1105_2);
    gl64_t kC1105 = (tmp3_1 + tmp3_2) * (s1_1105_1 + s1_1105_2);
    gl64_t kD1105 = tmp3_0 * s1_1105_0;
    gl64_t kE1105 = tmp3_1 * s1_1105_1;
    gl64_t kF1105 = tmp3_2 * s1_1105_2;
    gl64_t kG1105 = kD1105 - kE1105;
    tmp3_0 = (kC1105 + kG1105) - kF1105;
    tmp3_1 = ((((kA1105 + kC1105) - kE1105) - kE1105) - kD1105);
    tmp3_2 = kB1105 - kG1105;
    // Op 1106: dim3x1 add
    gl64_t s1_1106 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1106; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1107: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1108: dim3x3 mul
    gl64_t s1_1108_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1108_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1108_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1108 = (tmp3_0 + tmp3_1) * (s1_1108_0 + s1_1108_1);
    gl64_t kB1108 = (tmp3_0 + tmp3_2) * (s1_1108_0 + s1_1108_2);
    gl64_t kC1108 = (tmp3_1 + tmp3_2) * (s1_1108_1 + s1_1108_2);
    gl64_t kD1108 = tmp3_0 * s1_1108_0;
    gl64_t kE1108 = tmp3_1 * s1_1108_1;
    gl64_t kF1108 = tmp3_2 * s1_1108_2;
    gl64_t kG1108 = kD1108 - kE1108;
    tmp3_6 = (kC1108 + kG1108) - kF1108;
    tmp3_7 = ((((kA1108 + kC1108) - kE1108) - kE1108) - kD1108);
    tmp3_8 = kB1108 - kG1108;
    // Op 1109: dim3x1 mul
    gl64_t s0_1109_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1109_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1109_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1109 = *(gl64_t*)&expressions_params[10][35];
    tmp3_0 = s0_1109_0 * s1_1109; tmp3_1 = s0_1109_1 * s1_1109; tmp3_2 = s0_1109_2 * s1_1109;
    // Op 1110: dim3x1 add
    gl64_t s1_1110 = *(gl64_t*)&expressions_params[10][34];
    tmp3_0 = tmp3_0 + s1_1110; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1111: dim3x3 mul
    gl64_t s1_1111_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1111_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1111_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1111 = (tmp3_0 + tmp3_1) * (s1_1111_0 + s1_1111_1);
    gl64_t kB1111 = (tmp3_0 + tmp3_2) * (s1_1111_0 + s1_1111_2);
    gl64_t kC1111 = (tmp3_1 + tmp3_2) * (s1_1111_1 + s1_1111_2);
    gl64_t kD1111 = tmp3_0 * s1_1111_0;
    gl64_t kE1111 = tmp3_1 * s1_1111_1;
    gl64_t kF1111 = tmp3_2 * s1_1111_2;
    gl64_t kG1111 = kD1111 - kE1111;
    tmp3_0 = (kC1111 + kG1111) - kF1111;
    tmp3_1 = ((((kA1111 + kC1111) - kE1111) - kE1111) - kD1111);
    tmp3_2 = kB1111 - kG1111;
    // Op 1112: dim3x1 add
    gl64_t s1_1112 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1112; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1113: dim3x3 mul
    gl64_t s1_1113_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1113_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1113_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1113 = (tmp3_0 + tmp3_1) * (s1_1113_0 + s1_1113_1);
    gl64_t kB1113 = (tmp3_0 + tmp3_2) * (s1_1113_0 + s1_1113_2);
    gl64_t kC1113 = (tmp3_1 + tmp3_2) * (s1_1113_1 + s1_1113_2);
    gl64_t kD1113 = tmp3_0 * s1_1113_0;
    gl64_t kE1113 = tmp3_1 * s1_1113_1;
    gl64_t kF1113 = tmp3_2 * s1_1113_2;
    gl64_t kG1113 = kD1113 - kE1113;
    tmp3_0 = (kC1113 + kG1113) - kF1113;
    tmp3_1 = ((((kA1113 + kC1113) - kE1113) - kE1113) - kD1113);
    tmp3_2 = kB1113 - kG1113;
    // Op 1114: dim3x1 add
    gl64_t s1_1114 = *(gl64_t*)&expressions_params[10][83];
    tmp3_0 = tmp3_0 + s1_1114; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1115: dim3x3 mul
    gl64_t s1_1115_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1115_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1115_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1115 = (tmp3_0 + tmp3_1) * (s1_1115_0 + s1_1115_1);
    gl64_t kB1115 = (tmp3_0 + tmp3_2) * (s1_1115_0 + s1_1115_2);
    gl64_t kC1115 = (tmp3_1 + tmp3_2) * (s1_1115_1 + s1_1115_2);
    gl64_t kD1115 = tmp3_0 * s1_1115_0;
    gl64_t kE1115 = tmp3_1 * s1_1115_1;
    gl64_t kF1115 = tmp3_2 * s1_1115_2;
    gl64_t kG1115 = kD1115 - kE1115;
    tmp3_0 = (kC1115 + kG1115) - kF1115;
    tmp3_1 = ((((kA1115 + kC1115) - kE1115) - kE1115) - kD1115);
    tmp3_2 = kB1115 - kG1115;
    // Op 1116: dim3x1 add
    gl64_t s1_1116 = *(gl64_t*)&expressions_params[9][31];
    tmp3_0 = tmp3_0 + s1_1116; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1117: dim3x3 mul
    gl64_t s1_1117_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1117_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1117_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1117 = (tmp3_0 + tmp3_1) * (s1_1117_0 + s1_1117_1);
    gl64_t kB1117 = (tmp3_0 + tmp3_2) * (s1_1117_0 + s1_1117_2);
    gl64_t kC1117 = (tmp3_1 + tmp3_2) * (s1_1117_1 + s1_1117_2);
    gl64_t kD1117 = tmp3_0 * s1_1117_0;
    gl64_t kE1117 = tmp3_1 * s1_1117_1;
    gl64_t kF1117 = tmp3_2 * s1_1117_2;
    gl64_t kG1117 = kD1117 - kE1117;
    tmp3_0 = (kC1117 + kG1117) - kF1117;
    tmp3_1 = ((((kA1117 + kC1117) - kE1117) - kE1117) - kD1117);
    tmp3_2 = kB1117 - kG1117;
    // Op 1118: dim3x1 add
    gl64_t s1_1118 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1118; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1119: dim3x3 mul
    gl64_t s1_1119_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1119_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1119_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1119 = (tmp3_0 + tmp3_1) * (s1_1119_0 + s1_1119_1);
    gl64_t kB1119 = (tmp3_0 + tmp3_2) * (s1_1119_0 + s1_1119_2);
    gl64_t kC1119 = (tmp3_1 + tmp3_2) * (s1_1119_1 + s1_1119_2);
    gl64_t kD1119 = tmp3_0 * s1_1119_0;
    gl64_t kE1119 = tmp3_1 * s1_1119_1;
    gl64_t kF1119 = tmp3_2 * s1_1119_2;
    gl64_t kG1119 = kD1119 - kE1119;
    tmp3_0 = (kC1119 + kG1119) - kF1119;
    tmp3_1 = ((((kA1119 + kC1119) - kE1119) - kE1119) - kD1119);
    tmp3_2 = kB1119 - kG1119;
    // Op 1120: dim3x1 add
    gl64_t s1_1120 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1120; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1121: dim3x3 add
    gl64_t s1_1121_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1121_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1121_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1121_0; tmp3_1 = tmp3_1 + s1_1121_1; tmp3_2 = tmp3_2 + s1_1121_2;
    // Op 1122: dim3x3 mul
    gl64_t s1_1122_0 = *(gl64_t*)&expressions_params[10][227];
    gl64_t s1_1122_1 = *(gl64_t*)&expressions_params[10][227+1];
    gl64_t s1_1122_2 = *(gl64_t*)&expressions_params[10][227+2];
    gl64_t kA1122 = (tmp3_0 + tmp3_1) * (s1_1122_0 + s1_1122_1);
    gl64_t kB1122 = (tmp3_0 + tmp3_2) * (s1_1122_0 + s1_1122_2);
    gl64_t kC1122 = (tmp3_1 + tmp3_2) * (s1_1122_1 + s1_1122_2);
    gl64_t kD1122 = tmp3_0 * s1_1122_0;
    gl64_t kE1122 = tmp3_1 * s1_1122_1;
    gl64_t kF1122 = tmp3_2 * s1_1122_2;
    gl64_t kG1122 = kD1122 - kE1122;
    tmp3_0 = (kC1122 + kG1122) - kF1122;
    tmp3_1 = ((((kA1122 + kC1122) - kE1122) - kE1122) - kD1122);
    tmp3_2 = kB1122 - kG1122;
    // Op 1123: dim3x1 sub
    gl64_t s1_1123 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1123; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1124: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1125: dim3x3 mul
    gl64_t s1_1125_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1125_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1125_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1125 = (tmp3_0 + tmp3_1) * (s1_1125_0 + s1_1125_1);
    gl64_t kB1125 = (tmp3_0 + tmp3_2) * (s1_1125_0 + s1_1125_2);
    gl64_t kC1125 = (tmp3_1 + tmp3_2) * (s1_1125_1 + s1_1125_2);
    gl64_t kD1125 = tmp3_0 * s1_1125_0;
    gl64_t kE1125 = tmp3_1 * s1_1125_1;
    gl64_t kF1125 = tmp3_2 * s1_1125_2;
    gl64_t kG1125 = kD1125 - kE1125;
    tmp3_6 = (kC1125 + kG1125) - kF1125;
    tmp3_7 = ((((kA1125 + kC1125) - kE1125) - kE1125) - kD1125);
    tmp3_8 = kB1125 - kG1125;
    // Op 1126: dim3x1 mul
    gl64_t s0_1126_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1126_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1126_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1126 = *(gl64_t*)&expressions_params[10][35];
    tmp3_0 = s0_1126_0 * s1_1126; tmp3_1 = s0_1126_1 * s1_1126; tmp3_2 = s0_1126_2 * s1_1126;
    // Op 1127: dim3x1 add
    gl64_t s1_1127 = *(gl64_t*)&expressions_params[10][34];
    tmp3_0 = tmp3_0 + s1_1127; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1128: dim3x3 mul
    gl64_t s1_1128_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1128_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1128_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1128 = (tmp3_0 + tmp3_1) * (s1_1128_0 + s1_1128_1);
    gl64_t kB1128 = (tmp3_0 + tmp3_2) * (s1_1128_0 + s1_1128_2);
    gl64_t kC1128 = (tmp3_1 + tmp3_2) * (s1_1128_1 + s1_1128_2);
    gl64_t kD1128 = tmp3_0 * s1_1128_0;
    gl64_t kE1128 = tmp3_1 * s1_1128_1;
    gl64_t kF1128 = tmp3_2 * s1_1128_2;
    gl64_t kG1128 = kD1128 - kE1128;
    tmp3_0 = (kC1128 + kG1128) - kF1128;
    tmp3_1 = ((((kA1128 + kC1128) - kE1128) - kE1128) - kD1128);
    tmp3_2 = kB1128 - kG1128;
    // Op 1129: dim3x1 add
    gl64_t s1_1129 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1129; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1130: dim3x3 mul
    gl64_t s1_1130_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1130_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1130_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1130 = (tmp3_0 + tmp3_1) * (s1_1130_0 + s1_1130_1);
    gl64_t kB1130 = (tmp3_0 + tmp3_2) * (s1_1130_0 + s1_1130_2);
    gl64_t kC1130 = (tmp3_1 + tmp3_2) * (s1_1130_1 + s1_1130_2);
    gl64_t kD1130 = tmp3_0 * s1_1130_0;
    gl64_t kE1130 = tmp3_1 * s1_1130_1;
    gl64_t kF1130 = tmp3_2 * s1_1130_2;
    gl64_t kG1130 = kD1130 - kE1130;
    tmp3_0 = (kC1130 + kG1130) - kF1130;
    tmp3_1 = ((((kA1130 + kC1130) - kE1130) - kE1130) - kD1130);
    tmp3_2 = kB1130 - kG1130;
    // Op 1131: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1132: dim3x3 mul
    gl64_t s1_1132_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1132_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1132_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1132 = (tmp3_0 + tmp3_1) * (s1_1132_0 + s1_1132_1);
    gl64_t kB1132 = (tmp3_0 + tmp3_2) * (s1_1132_0 + s1_1132_2);
    gl64_t kC1132 = (tmp3_1 + tmp3_2) * (s1_1132_1 + s1_1132_2);
    gl64_t kD1132 = tmp3_0 * s1_1132_0;
    gl64_t kE1132 = tmp3_1 * s1_1132_1;
    gl64_t kF1132 = tmp3_2 * s1_1132_2;
    gl64_t kG1132 = kD1132 - kE1132;
    tmp3_0 = (kC1132 + kG1132) - kF1132;
    tmp3_1 = ((((kA1132 + kC1132) - kE1132) - kE1132) - kD1132);
    tmp3_2 = kB1132 - kG1132;
    // Op 1133: dim3x1 add
    gl64_t s1_1133 = *(gl64_t*)&expressions_params[9][31];
    tmp3_0 = tmp3_0 + s1_1133; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1134: dim3x3 mul
    gl64_t s1_1134_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1134_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1134_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1134 = (tmp3_0 + tmp3_1) * (s1_1134_0 + s1_1134_1);
    gl64_t kB1134 = (tmp3_0 + tmp3_2) * (s1_1134_0 + s1_1134_2);
    gl64_t kC1134 = (tmp3_1 + tmp3_2) * (s1_1134_1 + s1_1134_2);
    gl64_t kD1134 = tmp3_0 * s1_1134_0;
    gl64_t kE1134 = tmp3_1 * s1_1134_1;
    gl64_t kF1134 = tmp3_2 * s1_1134_2;
    gl64_t kG1134 = kD1134 - kE1134;
    tmp3_0 = (kC1134 + kG1134) - kF1134;
    tmp3_1 = ((((kA1134 + kC1134) - kE1134) - kE1134) - kD1134);
    tmp3_2 = kB1134 - kG1134;
    // Op 1135: dim3x1 add
    gl64_t s1_1135 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1135; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1136: dim3x3 mul
    gl64_t s1_1136_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1136_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1136_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1136 = (tmp3_0 + tmp3_1) * (s1_1136_0 + s1_1136_1);
    gl64_t kB1136 = (tmp3_0 + tmp3_2) * (s1_1136_0 + s1_1136_2);
    gl64_t kC1136 = (tmp3_1 + tmp3_2) * (s1_1136_1 + s1_1136_2);
    gl64_t kD1136 = tmp3_0 * s1_1136_0;
    gl64_t kE1136 = tmp3_1 * s1_1136_1;
    gl64_t kF1136 = tmp3_2 * s1_1136_2;
    gl64_t kG1136 = kD1136 - kE1136;
    tmp3_0 = (kC1136 + kG1136) - kF1136;
    tmp3_1 = ((((kA1136 + kC1136) - kE1136) - kE1136) - kD1136);
    tmp3_2 = kB1136 - kG1136;
    // Op 1137: dim3x1 add
    gl64_t s1_1137 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1137; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1138: dim3x3 add
    gl64_t s1_1138_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1138_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1138_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1138_0; tmp3_1 = tmp3_1 + s1_1138_1; tmp3_2 = tmp3_2 + s1_1138_2;
    // Op 1139: dim3x3 mul
    gl64_t s1_1139_0 = *(gl64_t*)&expressions_params[10][230];
    gl64_t s1_1139_1 = *(gl64_t*)&expressions_params[10][230+1];
    gl64_t s1_1139_2 = *(gl64_t*)&expressions_params[10][230+2];
    gl64_t kA1139 = (tmp3_0 + tmp3_1) * (s1_1139_0 + s1_1139_1);
    gl64_t kB1139 = (tmp3_0 + tmp3_2) * (s1_1139_0 + s1_1139_2);
    gl64_t kC1139 = (tmp3_1 + tmp3_2) * (s1_1139_1 + s1_1139_2);
    gl64_t kD1139 = tmp3_0 * s1_1139_0;
    gl64_t kE1139 = tmp3_1 * s1_1139_1;
    gl64_t kF1139 = tmp3_2 * s1_1139_2;
    gl64_t kG1139 = kD1139 - kE1139;
    tmp3_0 = (kC1139 + kG1139) - kF1139;
    tmp3_1 = ((((kA1139 + kC1139) - kE1139) - kE1139) - kD1139);
    tmp3_2 = kB1139 - kG1139;
    // Op 1140: dim1x1 sub
    gl64_t s0_1140 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1140 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1140 - s1_1140;
    // Op 1141: dim1x1 sub_swap
    gl64_t s1_1141 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1141 - tmp1_0;
    // Op 1142: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1143: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1144: dim3x3 mul
    gl64_t s1_1144_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1144_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1144_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1144 = (tmp3_0 + tmp3_1) * (s1_1144_0 + s1_1144_1);
    gl64_t kB1144 = (tmp3_0 + tmp3_2) * (s1_1144_0 + s1_1144_2);
    gl64_t kC1144 = (tmp3_1 + tmp3_2) * (s1_1144_1 + s1_1144_2);
    gl64_t kD1144 = tmp3_0 * s1_1144_0;
    gl64_t kE1144 = tmp3_1 * s1_1144_1;
    gl64_t kF1144 = tmp3_2 * s1_1144_2;
    gl64_t kG1144 = kD1144 - kE1144;
    tmp3_6 = (kC1144 + kG1144) - kF1144;
    tmp3_7 = ((((kA1144 + kC1144) - kE1144) - kE1144) - kD1144);
    tmp3_8 = kB1144 - kG1144;
    // Op 1145: dim1x1 sub
    gl64_t s1_1145 = *(gl64_t*)&expressions_params[10][84];
    tmp1_0 = tmp1_4 - s1_1145;
    // Op 1146: dim1x1 sub
    gl64_t s1_1146 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1146;
    // Op 1147: dim3x1 mul
    gl64_t s0_1147_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1147_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1147_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1147_0 * tmp1_0; tmp3_1 = s0_1147_1 * tmp1_0; tmp3_2 = s0_1147_2 * tmp1_0;
    // Op 1148: dim3x1 add
    gl64_t s1_1148 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1148; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1149: dim3x3 add
    gl64_t s1_1149_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1149_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1149_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1149_0; tmp3_1 = tmp3_1 + s1_1149_1; tmp3_2 = tmp3_2 + s1_1149_2;
    // Op 1150: dim3x3 mul
    gl64_t s1_1150_0 = *(gl64_t*)&expressions_params[10][233];
    gl64_t s1_1150_1 = *(gl64_t*)&expressions_params[10][233+1];
    gl64_t s1_1150_2 = *(gl64_t*)&expressions_params[10][233+2];
    gl64_t kA1150 = (tmp3_0 + tmp3_1) * (s1_1150_0 + s1_1150_1);
    gl64_t kB1150 = (tmp3_0 + tmp3_2) * (s1_1150_0 + s1_1150_2);
    gl64_t kC1150 = (tmp3_1 + tmp3_2) * (s1_1150_1 + s1_1150_2);
    gl64_t kD1150 = tmp3_0 * s1_1150_0;
    gl64_t kE1150 = tmp3_1 * s1_1150_1;
    gl64_t kF1150 = tmp3_2 * s1_1150_2;
    gl64_t kG1150 = kD1150 - kE1150;
    tmp3_0 = (kC1150 + kG1150) - kF1150;
    tmp3_1 = ((((kA1150 + kC1150) - kE1150) - kE1150) - kD1150);
    tmp3_2 = kB1150 - kG1150;
    // Op 1151: dim3x1 add
    gl64_t s1_1151 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1151; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1152: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1153: dim3x3 mul
    gl64_t s1_1153_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1153_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1153_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1153 = (tmp3_0 + tmp3_1) * (s1_1153_0 + s1_1153_1);
    gl64_t kB1153 = (tmp3_0 + tmp3_2) * (s1_1153_0 + s1_1153_2);
    gl64_t kC1153 = (tmp3_1 + tmp3_2) * (s1_1153_1 + s1_1153_2);
    gl64_t kD1153 = tmp3_0 * s1_1153_0;
    gl64_t kE1153 = tmp3_1 * s1_1153_1;
    gl64_t kF1153 = tmp3_2 * s1_1153_2;
    gl64_t kG1153 = kD1153 - kE1153;
    tmp3_6 = (kC1153 + kG1153) - kF1153;
    tmp3_7 = ((((kA1153 + kC1153) - kE1153) - kE1153) - kD1153);
    tmp3_8 = kB1153 - kG1153;
    // Op 1154: dim3x1 mul
    gl64_t s0_1154_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1154_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1154_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1154 = *(gl64_t*)&expressions_params[10][37];
    tmp3_0 = s0_1154_0 * s1_1154; tmp3_1 = s0_1154_1 * s1_1154; tmp3_2 = s0_1154_2 * s1_1154;
    // Op 1155: dim3x1 add
    gl64_t s1_1155 = *(gl64_t*)&expressions_params[10][36];
    tmp3_0 = tmp3_0 + s1_1155; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1156: dim3x3 mul
    gl64_t s1_1156_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1156_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1156_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1156 = (tmp3_0 + tmp3_1) * (s1_1156_0 + s1_1156_1);
    gl64_t kB1156 = (tmp3_0 + tmp3_2) * (s1_1156_0 + s1_1156_2);
    gl64_t kC1156 = (tmp3_1 + tmp3_2) * (s1_1156_1 + s1_1156_2);
    gl64_t kD1156 = tmp3_0 * s1_1156_0;
    gl64_t kE1156 = tmp3_1 * s1_1156_1;
    gl64_t kF1156 = tmp3_2 * s1_1156_2;
    gl64_t kG1156 = kD1156 - kE1156;
    tmp3_0 = (kC1156 + kG1156) - kF1156;
    tmp3_1 = ((((kA1156 + kC1156) - kE1156) - kE1156) - kD1156);
    tmp3_2 = kB1156 - kG1156;
    // Op 1157: dim3x1 add
    gl64_t s1_1157 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1157; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1158: dim3x3 mul
    gl64_t s1_1158_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1158_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1158_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1158 = (tmp3_0 + tmp3_1) * (s1_1158_0 + s1_1158_1);
    gl64_t kB1158 = (tmp3_0 + tmp3_2) * (s1_1158_0 + s1_1158_2);
    gl64_t kC1158 = (tmp3_1 + tmp3_2) * (s1_1158_1 + s1_1158_2);
    gl64_t kD1158 = tmp3_0 * s1_1158_0;
    gl64_t kE1158 = tmp3_1 * s1_1158_1;
    gl64_t kF1158 = tmp3_2 * s1_1158_2;
    gl64_t kG1158 = kD1158 - kE1158;
    tmp3_0 = (kC1158 + kG1158) - kF1158;
    tmp3_1 = ((((kA1158 + kC1158) - kE1158) - kE1158) - kD1158);
    tmp3_2 = kB1158 - kG1158;
    // Op 1159: dim3x1 add
    gl64_t s1_1159 = *(gl64_t*)&expressions_params[10][84];
    tmp3_0 = tmp3_0 + s1_1159; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1160: dim3x3 mul
    gl64_t s1_1160_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1160_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1160_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1160 = (tmp3_0 + tmp3_1) * (s1_1160_0 + s1_1160_1);
    gl64_t kB1160 = (tmp3_0 + tmp3_2) * (s1_1160_0 + s1_1160_2);
    gl64_t kC1160 = (tmp3_1 + tmp3_2) * (s1_1160_1 + s1_1160_2);
    gl64_t kD1160 = tmp3_0 * s1_1160_0;
    gl64_t kE1160 = tmp3_1 * s1_1160_1;
    gl64_t kF1160 = tmp3_2 * s1_1160_2;
    gl64_t kG1160 = kD1160 - kE1160;
    tmp3_0 = (kC1160 + kG1160) - kF1160;
    tmp3_1 = ((((kA1160 + kC1160) - kE1160) - kE1160) - kD1160);
    tmp3_2 = kB1160 - kG1160;
    // Op 1161: dim3x1 add
    gl64_t s1_1161 = *(gl64_t*)&expressions_params[9][32];
    tmp3_0 = tmp3_0 + s1_1161; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1162: dim3x3 mul
    gl64_t s1_1162_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1162_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1162_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1162 = (tmp3_0 + tmp3_1) * (s1_1162_0 + s1_1162_1);
    gl64_t kB1162 = (tmp3_0 + tmp3_2) * (s1_1162_0 + s1_1162_2);
    gl64_t kC1162 = (tmp3_1 + tmp3_2) * (s1_1162_1 + s1_1162_2);
    gl64_t kD1162 = tmp3_0 * s1_1162_0;
    gl64_t kE1162 = tmp3_1 * s1_1162_1;
    gl64_t kF1162 = tmp3_2 * s1_1162_2;
    gl64_t kG1162 = kD1162 - kE1162;
    tmp3_0 = (kC1162 + kG1162) - kF1162;
    tmp3_1 = ((((kA1162 + kC1162) - kE1162) - kE1162) - kD1162);
    tmp3_2 = kB1162 - kG1162;
    // Op 1163: dim3x1 add
    gl64_t s1_1163 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1163; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1164: dim3x3 mul
    gl64_t s1_1164_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1164_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1164_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1164 = (tmp3_0 + tmp3_1) * (s1_1164_0 + s1_1164_1);
    gl64_t kB1164 = (tmp3_0 + tmp3_2) * (s1_1164_0 + s1_1164_2);
    gl64_t kC1164 = (tmp3_1 + tmp3_2) * (s1_1164_1 + s1_1164_2);
    gl64_t kD1164 = tmp3_0 * s1_1164_0;
    gl64_t kE1164 = tmp3_1 * s1_1164_1;
    gl64_t kF1164 = tmp3_2 * s1_1164_2;
    gl64_t kG1164 = kD1164 - kE1164;
    tmp3_0 = (kC1164 + kG1164) - kF1164;
    tmp3_1 = ((((kA1164 + kC1164) - kE1164) - kE1164) - kD1164);
    tmp3_2 = kB1164 - kG1164;
    // Op 1165: dim3x1 add
    gl64_t s1_1165 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1165; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1166: dim3x3 add
    gl64_t s1_1166_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1166_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1166_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1166_0; tmp3_1 = tmp3_1 + s1_1166_1; tmp3_2 = tmp3_2 + s1_1166_2;
    // Op 1167: dim3x3 mul
    gl64_t s1_1167_0 = *(gl64_t*)&expressions_params[10][236];
    gl64_t s1_1167_1 = *(gl64_t*)&expressions_params[10][236+1];
    gl64_t s1_1167_2 = *(gl64_t*)&expressions_params[10][236+2];
    gl64_t kA1167 = (tmp3_0 + tmp3_1) * (s1_1167_0 + s1_1167_1);
    gl64_t kB1167 = (tmp3_0 + tmp3_2) * (s1_1167_0 + s1_1167_2);
    gl64_t kC1167 = (tmp3_1 + tmp3_2) * (s1_1167_1 + s1_1167_2);
    gl64_t kD1167 = tmp3_0 * s1_1167_0;
    gl64_t kE1167 = tmp3_1 * s1_1167_1;
    gl64_t kF1167 = tmp3_2 * s1_1167_2;
    gl64_t kG1167 = kD1167 - kE1167;
    tmp3_0 = (kC1167 + kG1167) - kF1167;
    tmp3_1 = ((((kA1167 + kC1167) - kE1167) - kE1167) - kD1167);
    tmp3_2 = kB1167 - kG1167;
    // Op 1168: dim3x1 sub
    gl64_t s1_1168 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1168; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1169: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1170: dim3x3 mul
    gl64_t s1_1170_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1170_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1170_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1170 = (tmp3_0 + tmp3_1) * (s1_1170_0 + s1_1170_1);
    gl64_t kB1170 = (tmp3_0 + tmp3_2) * (s1_1170_0 + s1_1170_2);
    gl64_t kC1170 = (tmp3_1 + tmp3_2) * (s1_1170_1 + s1_1170_2);
    gl64_t kD1170 = tmp3_0 * s1_1170_0;
    gl64_t kE1170 = tmp3_1 * s1_1170_1;
    gl64_t kF1170 = tmp3_2 * s1_1170_2;
    gl64_t kG1170 = kD1170 - kE1170;
    tmp3_6 = (kC1170 + kG1170) - kF1170;
    tmp3_7 = ((((kA1170 + kC1170) - kE1170) - kE1170) - kD1170);
    tmp3_8 = kB1170 - kG1170;
    // Op 1171: dim3x1 mul
    gl64_t s0_1171_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1171_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1171_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1171 = *(gl64_t*)&expressions_params[10][37];
    tmp3_0 = s0_1171_0 * s1_1171; tmp3_1 = s0_1171_1 * s1_1171; tmp3_2 = s0_1171_2 * s1_1171;
    // Op 1172: dim3x1 add
    gl64_t s1_1172 = *(gl64_t*)&expressions_params[10][36];
    tmp3_0 = tmp3_0 + s1_1172; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1173: dim3x3 mul
    gl64_t s1_1173_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1173_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1173_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1173 = (tmp3_0 + tmp3_1) * (s1_1173_0 + s1_1173_1);
    gl64_t kB1173 = (tmp3_0 + tmp3_2) * (s1_1173_0 + s1_1173_2);
    gl64_t kC1173 = (tmp3_1 + tmp3_2) * (s1_1173_1 + s1_1173_2);
    gl64_t kD1173 = tmp3_0 * s1_1173_0;
    gl64_t kE1173 = tmp3_1 * s1_1173_1;
    gl64_t kF1173 = tmp3_2 * s1_1173_2;
    gl64_t kG1173 = kD1173 - kE1173;
    tmp3_0 = (kC1173 + kG1173) - kF1173;
    tmp3_1 = ((((kA1173 + kC1173) - kE1173) - kE1173) - kD1173);
    tmp3_2 = kB1173 - kG1173;
    // Op 1174: dim3x1 add
    gl64_t s1_1174 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1174; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1175: dim3x3 mul
    gl64_t s1_1175_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1175_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1175_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1175 = (tmp3_0 + tmp3_1) * (s1_1175_0 + s1_1175_1);
    gl64_t kB1175 = (tmp3_0 + tmp3_2) * (s1_1175_0 + s1_1175_2);
    gl64_t kC1175 = (tmp3_1 + tmp3_2) * (s1_1175_1 + s1_1175_2);
    gl64_t kD1175 = tmp3_0 * s1_1175_0;
    gl64_t kE1175 = tmp3_1 * s1_1175_1;
    gl64_t kF1175 = tmp3_2 * s1_1175_2;
    gl64_t kG1175 = kD1175 - kE1175;
    tmp3_0 = (kC1175 + kG1175) - kF1175;
    tmp3_1 = ((((kA1175 + kC1175) - kE1175) - kE1175) - kD1175);
    tmp3_2 = kB1175 - kG1175;
    // Op 1176: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1177: dim3x3 mul
    gl64_t s1_1177_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1177_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1177_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1177 = (tmp3_0 + tmp3_1) * (s1_1177_0 + s1_1177_1);
    gl64_t kB1177 = (tmp3_0 + tmp3_2) * (s1_1177_0 + s1_1177_2);
    gl64_t kC1177 = (tmp3_1 + tmp3_2) * (s1_1177_1 + s1_1177_2);
    gl64_t kD1177 = tmp3_0 * s1_1177_0;
    gl64_t kE1177 = tmp3_1 * s1_1177_1;
    gl64_t kF1177 = tmp3_2 * s1_1177_2;
    gl64_t kG1177 = kD1177 - kE1177;
    tmp3_0 = (kC1177 + kG1177) - kF1177;
    tmp3_1 = ((((kA1177 + kC1177) - kE1177) - kE1177) - kD1177);
    tmp3_2 = kB1177 - kG1177;
    // Op 1178: dim3x1 add
    gl64_t s1_1178 = *(gl64_t*)&expressions_params[9][32];
    tmp3_0 = tmp3_0 + s1_1178; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1179: dim3x3 mul
    gl64_t s1_1179_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1179_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1179_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1179 = (tmp3_0 + tmp3_1) * (s1_1179_0 + s1_1179_1);
    gl64_t kB1179 = (tmp3_0 + tmp3_2) * (s1_1179_0 + s1_1179_2);
    gl64_t kC1179 = (tmp3_1 + tmp3_2) * (s1_1179_1 + s1_1179_2);
    gl64_t kD1179 = tmp3_0 * s1_1179_0;
    gl64_t kE1179 = tmp3_1 * s1_1179_1;
    gl64_t kF1179 = tmp3_2 * s1_1179_2;
    gl64_t kG1179 = kD1179 - kE1179;
    tmp3_0 = (kC1179 + kG1179) - kF1179;
    tmp3_1 = ((((kA1179 + kC1179) - kE1179) - kE1179) - kD1179);
    tmp3_2 = kB1179 - kG1179;
    // Op 1180: dim3x1 add
    gl64_t s1_1180 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1180; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1181: dim3x3 mul
    gl64_t s1_1181_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1181_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1181_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1181 = (tmp3_0 + tmp3_1) * (s1_1181_0 + s1_1181_1);
    gl64_t kB1181 = (tmp3_0 + tmp3_2) * (s1_1181_0 + s1_1181_2);
    gl64_t kC1181 = (tmp3_1 + tmp3_2) * (s1_1181_1 + s1_1181_2);
    gl64_t kD1181 = tmp3_0 * s1_1181_0;
    gl64_t kE1181 = tmp3_1 * s1_1181_1;
    gl64_t kF1181 = tmp3_2 * s1_1181_2;
    gl64_t kG1181 = kD1181 - kE1181;
    tmp3_0 = (kC1181 + kG1181) - kF1181;
    tmp3_1 = ((((kA1181 + kC1181) - kE1181) - kE1181) - kD1181);
    tmp3_2 = kB1181 - kG1181;
    // Op 1182: dim3x1 add
    gl64_t s1_1182 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1182; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1183: dim3x3 add
    gl64_t s1_1183_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1183_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1183_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1183_0; tmp3_1 = tmp3_1 + s1_1183_1; tmp3_2 = tmp3_2 + s1_1183_2;
    // Op 1184: dim3x3 mul
    gl64_t s1_1184_0 = *(gl64_t*)&expressions_params[10][239];
    gl64_t s1_1184_1 = *(gl64_t*)&expressions_params[10][239+1];
    gl64_t s1_1184_2 = *(gl64_t*)&expressions_params[10][239+2];
    gl64_t kA1184 = (tmp3_0 + tmp3_1) * (s1_1184_0 + s1_1184_1);
    gl64_t kB1184 = (tmp3_0 + tmp3_2) * (s1_1184_0 + s1_1184_2);
    gl64_t kC1184 = (tmp3_1 + tmp3_2) * (s1_1184_1 + s1_1184_2);
    gl64_t kD1184 = tmp3_0 * s1_1184_0;
    gl64_t kE1184 = tmp3_1 * s1_1184_1;
    gl64_t kF1184 = tmp3_2 * s1_1184_2;
    gl64_t kG1184 = kD1184 - kE1184;
    tmp3_0 = (kC1184 + kG1184) - kF1184;
    tmp3_1 = ((((kA1184 + kC1184) - kE1184) - kE1184) - kD1184);
    tmp3_2 = kB1184 - kG1184;
    // Op 1185: dim1x1 sub
    gl64_t s0_1185 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1185 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1185 - s1_1185;
    // Op 1186: dim1x1 sub_swap
    gl64_t s1_1186 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1186 - tmp1_0;
    // Op 1187: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1188: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1189: dim3x3 mul
    gl64_t s1_1189_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1189_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1189_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1189 = (tmp3_0 + tmp3_1) * (s1_1189_0 + s1_1189_1);
    gl64_t kB1189 = (tmp3_0 + tmp3_2) * (s1_1189_0 + s1_1189_2);
    gl64_t kC1189 = (tmp3_1 + tmp3_2) * (s1_1189_1 + s1_1189_2);
    gl64_t kD1189 = tmp3_0 * s1_1189_0;
    gl64_t kE1189 = tmp3_1 * s1_1189_1;
    gl64_t kF1189 = tmp3_2 * s1_1189_2;
    gl64_t kG1189 = kD1189 - kE1189;
    tmp3_6 = (kC1189 + kG1189) - kF1189;
    tmp3_7 = ((((kA1189 + kC1189) - kE1189) - kE1189) - kD1189);
    tmp3_8 = kB1189 - kG1189;
    // Op 1190: dim1x1 sub
    gl64_t s1_1190 = *(gl64_t*)&expressions_params[10][85];
    tmp1_0 = tmp1_4 - s1_1190;
    // Op 1191: dim1x1 sub
    gl64_t s1_1191 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1191;
    // Op 1192: dim3x1 mul
    gl64_t s0_1192_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1192_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1192_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1192_0 * tmp1_0; tmp3_1 = s0_1192_1 * tmp1_0; tmp3_2 = s0_1192_2 * tmp1_0;
    // Op 1193: dim3x1 add
    gl64_t s1_1193 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1193; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1194: dim3x3 add
    gl64_t s1_1194_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1194_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1194_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1194_0; tmp3_1 = tmp3_1 + s1_1194_1; tmp3_2 = tmp3_2 + s1_1194_2;
    // Op 1195: dim3x3 mul
    gl64_t s1_1195_0 = *(gl64_t*)&expressions_params[10][242];
    gl64_t s1_1195_1 = *(gl64_t*)&expressions_params[10][242+1];
    gl64_t s1_1195_2 = *(gl64_t*)&expressions_params[10][242+2];
    gl64_t kA1195 = (tmp3_0 + tmp3_1) * (s1_1195_0 + s1_1195_1);
    gl64_t kB1195 = (tmp3_0 + tmp3_2) * (s1_1195_0 + s1_1195_2);
    gl64_t kC1195 = (tmp3_1 + tmp3_2) * (s1_1195_1 + s1_1195_2);
    gl64_t kD1195 = tmp3_0 * s1_1195_0;
    gl64_t kE1195 = tmp3_1 * s1_1195_1;
    gl64_t kF1195 = tmp3_2 * s1_1195_2;
    gl64_t kG1195 = kD1195 - kE1195;
    tmp3_0 = (kC1195 + kG1195) - kF1195;
    tmp3_1 = ((((kA1195 + kC1195) - kE1195) - kE1195) - kD1195);
    tmp3_2 = kB1195 - kG1195;
    // Op 1196: dim3x1 add
    gl64_t s1_1196 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1196; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1197: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1198: dim3x3 mul
    gl64_t s1_1198_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1198_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1198_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1198 = (tmp3_0 + tmp3_1) * (s1_1198_0 + s1_1198_1);
    gl64_t kB1198 = (tmp3_0 + tmp3_2) * (s1_1198_0 + s1_1198_2);
    gl64_t kC1198 = (tmp3_1 + tmp3_2) * (s1_1198_1 + s1_1198_2);
    gl64_t kD1198 = tmp3_0 * s1_1198_0;
    gl64_t kE1198 = tmp3_1 * s1_1198_1;
    gl64_t kF1198 = tmp3_2 * s1_1198_2;
    gl64_t kG1198 = kD1198 - kE1198;
    tmp3_6 = (kC1198 + kG1198) - kF1198;
    tmp3_7 = ((((kA1198 + kC1198) - kE1198) - kE1198) - kD1198);
    tmp3_8 = kB1198 - kG1198;
    // Op 1199: dim3x1 mul
    gl64_t s0_1199_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1199_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1199_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1199 = *(gl64_t*)&expressions_params[10][39];
    tmp3_0 = s0_1199_0 * s1_1199; tmp3_1 = s0_1199_1 * s1_1199; tmp3_2 = s0_1199_2 * s1_1199;
    // Op 1200: dim3x1 add
    gl64_t s1_1200 = *(gl64_t*)&expressions_params[10][38];
    tmp3_0 = tmp3_0 + s1_1200; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1201: dim3x3 mul
    gl64_t s1_1201_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1201_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1201_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1201 = (tmp3_0 + tmp3_1) * (s1_1201_0 + s1_1201_1);
    gl64_t kB1201 = (tmp3_0 + tmp3_2) * (s1_1201_0 + s1_1201_2);
    gl64_t kC1201 = (tmp3_1 + tmp3_2) * (s1_1201_1 + s1_1201_2);
    gl64_t kD1201 = tmp3_0 * s1_1201_0;
    gl64_t kE1201 = tmp3_1 * s1_1201_1;
    gl64_t kF1201 = tmp3_2 * s1_1201_2;
    gl64_t kG1201 = kD1201 - kE1201;
    tmp3_0 = (kC1201 + kG1201) - kF1201;
    tmp3_1 = ((((kA1201 + kC1201) - kE1201) - kE1201) - kD1201);
    tmp3_2 = kB1201 - kG1201;
    // Op 1202: dim3x1 add
    gl64_t s1_1202 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1202; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1203: dim3x3 mul
    gl64_t s1_1203_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1203_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1203_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1203 = (tmp3_0 + tmp3_1) * (s1_1203_0 + s1_1203_1);
    gl64_t kB1203 = (tmp3_0 + tmp3_2) * (s1_1203_0 + s1_1203_2);
    gl64_t kC1203 = (tmp3_1 + tmp3_2) * (s1_1203_1 + s1_1203_2);
    gl64_t kD1203 = tmp3_0 * s1_1203_0;
    gl64_t kE1203 = tmp3_1 * s1_1203_1;
    gl64_t kF1203 = tmp3_2 * s1_1203_2;
    gl64_t kG1203 = kD1203 - kE1203;
    tmp3_0 = (kC1203 + kG1203) - kF1203;
    tmp3_1 = ((((kA1203 + kC1203) - kE1203) - kE1203) - kD1203);
    tmp3_2 = kB1203 - kG1203;
    // Op 1204: dim3x1 add
    gl64_t s1_1204 = *(gl64_t*)&expressions_params[10][85];
    tmp3_0 = tmp3_0 + s1_1204; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1205: dim3x3 mul
    gl64_t s1_1205_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1205_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1205_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1205 = (tmp3_0 + tmp3_1) * (s1_1205_0 + s1_1205_1);
    gl64_t kB1205 = (tmp3_0 + tmp3_2) * (s1_1205_0 + s1_1205_2);
    gl64_t kC1205 = (tmp3_1 + tmp3_2) * (s1_1205_1 + s1_1205_2);
    gl64_t kD1205 = tmp3_0 * s1_1205_0;
    gl64_t kE1205 = tmp3_1 * s1_1205_1;
    gl64_t kF1205 = tmp3_2 * s1_1205_2;
    gl64_t kG1205 = kD1205 - kE1205;
    tmp3_0 = (kC1205 + kG1205) - kF1205;
    tmp3_1 = ((((kA1205 + kC1205) - kE1205) - kE1205) - kD1205);
    tmp3_2 = kB1205 - kG1205;
    // Op 1206: dim3x1 add
    gl64_t s1_1206 = *(gl64_t*)&expressions_params[9][9];
    tmp3_0 = tmp3_0 + s1_1206; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1207: dim3x3 mul
    gl64_t s1_1207_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1207_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1207_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1207 = (tmp3_0 + tmp3_1) * (s1_1207_0 + s1_1207_1);
    gl64_t kB1207 = (tmp3_0 + tmp3_2) * (s1_1207_0 + s1_1207_2);
    gl64_t kC1207 = (tmp3_1 + tmp3_2) * (s1_1207_1 + s1_1207_2);
    gl64_t kD1207 = tmp3_0 * s1_1207_0;
    gl64_t kE1207 = tmp3_1 * s1_1207_1;
    gl64_t kF1207 = tmp3_2 * s1_1207_2;
    gl64_t kG1207 = kD1207 - kE1207;
    tmp3_0 = (kC1207 + kG1207) - kF1207;
    tmp3_1 = ((((kA1207 + kC1207) - kE1207) - kE1207) - kD1207);
    tmp3_2 = kB1207 - kG1207;
    // Op 1208: dim3x1 add
    gl64_t s1_1208 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1208; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1209: dim3x3 mul
    gl64_t s1_1209_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1209_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1209_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1209 = (tmp3_0 + tmp3_1) * (s1_1209_0 + s1_1209_1);
    gl64_t kB1209 = (tmp3_0 + tmp3_2) * (s1_1209_0 + s1_1209_2);
    gl64_t kC1209 = (tmp3_1 + tmp3_2) * (s1_1209_1 + s1_1209_2);
    gl64_t kD1209 = tmp3_0 * s1_1209_0;
    gl64_t kE1209 = tmp3_1 * s1_1209_1;
    gl64_t kF1209 = tmp3_2 * s1_1209_2;
    gl64_t kG1209 = kD1209 - kE1209;
    tmp3_0 = (kC1209 + kG1209) - kF1209;
    tmp3_1 = ((((kA1209 + kC1209) - kE1209) - kE1209) - kD1209);
    tmp3_2 = kB1209 - kG1209;
    // Op 1210: dim3x1 add
    gl64_t s1_1210 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1210; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1211: dim3x3 add
    gl64_t s1_1211_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1211_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1211_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1211_0; tmp3_1 = tmp3_1 + s1_1211_1; tmp3_2 = tmp3_2 + s1_1211_2;
    // Op 1212: dim3x3 mul
    gl64_t s1_1212_0 = *(gl64_t*)&expressions_params[10][245];
    gl64_t s1_1212_1 = *(gl64_t*)&expressions_params[10][245+1];
    gl64_t s1_1212_2 = *(gl64_t*)&expressions_params[10][245+2];
    gl64_t kA1212 = (tmp3_0 + tmp3_1) * (s1_1212_0 + s1_1212_1);
    gl64_t kB1212 = (tmp3_0 + tmp3_2) * (s1_1212_0 + s1_1212_2);
    gl64_t kC1212 = (tmp3_1 + tmp3_2) * (s1_1212_1 + s1_1212_2);
    gl64_t kD1212 = tmp3_0 * s1_1212_0;
    gl64_t kE1212 = tmp3_1 * s1_1212_1;
    gl64_t kF1212 = tmp3_2 * s1_1212_2;
    gl64_t kG1212 = kD1212 - kE1212;
    tmp3_0 = (kC1212 + kG1212) - kF1212;
    tmp3_1 = ((((kA1212 + kC1212) - kE1212) - kE1212) - kD1212);
    tmp3_2 = kB1212 - kG1212;
    // Op 1213: dim3x1 sub
    gl64_t s1_1213 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1213; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1214: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1215: dim3x3 mul
    gl64_t s1_1215_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1215_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1215_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1215 = (tmp3_0 + tmp3_1) * (s1_1215_0 + s1_1215_1);
    gl64_t kB1215 = (tmp3_0 + tmp3_2) * (s1_1215_0 + s1_1215_2);
    gl64_t kC1215 = (tmp3_1 + tmp3_2) * (s1_1215_1 + s1_1215_2);
    gl64_t kD1215 = tmp3_0 * s1_1215_0;
    gl64_t kE1215 = tmp3_1 * s1_1215_1;
    gl64_t kF1215 = tmp3_2 * s1_1215_2;
    gl64_t kG1215 = kD1215 - kE1215;
    tmp3_6 = (kC1215 + kG1215) - kF1215;
    tmp3_7 = ((((kA1215 + kC1215) - kE1215) - kE1215) - kD1215);
    tmp3_8 = kB1215 - kG1215;
    // Op 1216: dim3x1 mul
    gl64_t s0_1216_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1216_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1216_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1216 = *(gl64_t*)&expressions_params[10][39];
    tmp3_0 = s0_1216_0 * s1_1216; tmp3_1 = s0_1216_1 * s1_1216; tmp3_2 = s0_1216_2 * s1_1216;
    // Op 1217: dim3x1 add
    gl64_t s1_1217 = *(gl64_t*)&expressions_params[10][38];
    tmp3_0 = tmp3_0 + s1_1217; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1218: dim3x3 mul
    gl64_t s1_1218_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1218_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1218_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1218 = (tmp3_0 + tmp3_1) * (s1_1218_0 + s1_1218_1);
    gl64_t kB1218 = (tmp3_0 + tmp3_2) * (s1_1218_0 + s1_1218_2);
    gl64_t kC1218 = (tmp3_1 + tmp3_2) * (s1_1218_1 + s1_1218_2);
    gl64_t kD1218 = tmp3_0 * s1_1218_0;
    gl64_t kE1218 = tmp3_1 * s1_1218_1;
    gl64_t kF1218 = tmp3_2 * s1_1218_2;
    gl64_t kG1218 = kD1218 - kE1218;
    tmp3_0 = (kC1218 + kG1218) - kF1218;
    tmp3_1 = ((((kA1218 + kC1218) - kE1218) - kE1218) - kD1218);
    tmp3_2 = kB1218 - kG1218;
    // Op 1219: dim3x1 add
    gl64_t s1_1219 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1219; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1220: dim3x3 mul
    gl64_t s1_1220_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1220_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1220_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1220 = (tmp3_0 + tmp3_1) * (s1_1220_0 + s1_1220_1);
    gl64_t kB1220 = (tmp3_0 + tmp3_2) * (s1_1220_0 + s1_1220_2);
    gl64_t kC1220 = (tmp3_1 + tmp3_2) * (s1_1220_1 + s1_1220_2);
    gl64_t kD1220 = tmp3_0 * s1_1220_0;
    gl64_t kE1220 = tmp3_1 * s1_1220_1;
    gl64_t kF1220 = tmp3_2 * s1_1220_2;
    gl64_t kG1220 = kD1220 - kE1220;
    tmp3_0 = (kC1220 + kG1220) - kF1220;
    tmp3_1 = ((((kA1220 + kC1220) - kE1220) - kE1220) - kD1220);
    tmp3_2 = kB1220 - kG1220;
    // Op 1221: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1222: dim3x3 mul
    gl64_t s1_1222_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1222_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1222_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1222 = (tmp3_0 + tmp3_1) * (s1_1222_0 + s1_1222_1);
    gl64_t kB1222 = (tmp3_0 + tmp3_2) * (s1_1222_0 + s1_1222_2);
    gl64_t kC1222 = (tmp3_1 + tmp3_2) * (s1_1222_1 + s1_1222_2);
    gl64_t kD1222 = tmp3_0 * s1_1222_0;
    gl64_t kE1222 = tmp3_1 * s1_1222_1;
    gl64_t kF1222 = tmp3_2 * s1_1222_2;
    gl64_t kG1222 = kD1222 - kE1222;
    tmp3_0 = (kC1222 + kG1222) - kF1222;
    tmp3_1 = ((((kA1222 + kC1222) - kE1222) - kE1222) - kD1222);
    tmp3_2 = kB1222 - kG1222;
    // Op 1223: dim3x1 add
    gl64_t s1_1223 = *(gl64_t*)&expressions_params[9][9];
    tmp3_0 = tmp3_0 + s1_1223; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1224: dim3x3 mul
    gl64_t s1_1224_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1224_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1224_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1224 = (tmp3_0 + tmp3_1) * (s1_1224_0 + s1_1224_1);
    gl64_t kB1224 = (tmp3_0 + tmp3_2) * (s1_1224_0 + s1_1224_2);
    gl64_t kC1224 = (tmp3_1 + tmp3_2) * (s1_1224_1 + s1_1224_2);
    gl64_t kD1224 = tmp3_0 * s1_1224_0;
    gl64_t kE1224 = tmp3_1 * s1_1224_1;
    gl64_t kF1224 = tmp3_2 * s1_1224_2;
    gl64_t kG1224 = kD1224 - kE1224;
    tmp3_0 = (kC1224 + kG1224) - kF1224;
    tmp3_1 = ((((kA1224 + kC1224) - kE1224) - kE1224) - kD1224);
    tmp3_2 = kB1224 - kG1224;
    // Op 1225: dim3x1 add
    gl64_t s1_1225 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1225; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1226: dim3x3 mul
    gl64_t s1_1226_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1226_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1226_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1226 = (tmp3_0 + tmp3_1) * (s1_1226_0 + s1_1226_1);
    gl64_t kB1226 = (tmp3_0 + tmp3_2) * (s1_1226_0 + s1_1226_2);
    gl64_t kC1226 = (tmp3_1 + tmp3_2) * (s1_1226_1 + s1_1226_2);
    gl64_t kD1226 = tmp3_0 * s1_1226_0;
    gl64_t kE1226 = tmp3_1 * s1_1226_1;
    gl64_t kF1226 = tmp3_2 * s1_1226_2;
    gl64_t kG1226 = kD1226 - kE1226;
    tmp3_0 = (kC1226 + kG1226) - kF1226;
    tmp3_1 = ((((kA1226 + kC1226) - kE1226) - kE1226) - kD1226);
    tmp3_2 = kB1226 - kG1226;
    // Op 1227: dim3x1 add
    gl64_t s1_1227 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1227; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1228: dim3x3 add
    gl64_t s1_1228_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1228_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1228_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1228_0; tmp3_1 = tmp3_1 + s1_1228_1; tmp3_2 = tmp3_2 + s1_1228_2;
    // Op 1229: dim3x3 mul
    gl64_t s1_1229_0 = *(gl64_t*)&expressions_params[10][248];
    gl64_t s1_1229_1 = *(gl64_t*)&expressions_params[10][248+1];
    gl64_t s1_1229_2 = *(gl64_t*)&expressions_params[10][248+2];
    gl64_t kA1229 = (tmp3_0 + tmp3_1) * (s1_1229_0 + s1_1229_1);
    gl64_t kB1229 = (tmp3_0 + tmp3_2) * (s1_1229_0 + s1_1229_2);
    gl64_t kC1229 = (tmp3_1 + tmp3_2) * (s1_1229_1 + s1_1229_2);
    gl64_t kD1229 = tmp3_0 * s1_1229_0;
    gl64_t kE1229 = tmp3_1 * s1_1229_1;
    gl64_t kF1229 = tmp3_2 * s1_1229_2;
    gl64_t kG1229 = kD1229 - kE1229;
    tmp3_0 = (kC1229 + kG1229) - kF1229;
    tmp3_1 = ((((kA1229 + kC1229) - kE1229) - kE1229) - kD1229);
    tmp3_2 = kB1229 - kG1229;
    // Op 1230: dim1x1 sub
    gl64_t s0_1230 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1230 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1230 - s1_1230;
    // Op 1231: dim1x1 sub_swap
    gl64_t s1_1231 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1231 - tmp1_0;
    // Op 1232: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1233: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1234: dim3x3 mul
    gl64_t s1_1234_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1234_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1234_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1234 = (tmp3_0 + tmp3_1) * (s1_1234_0 + s1_1234_1);
    gl64_t kB1234 = (tmp3_0 + tmp3_2) * (s1_1234_0 + s1_1234_2);
    gl64_t kC1234 = (tmp3_1 + tmp3_2) * (s1_1234_1 + s1_1234_2);
    gl64_t kD1234 = tmp3_0 * s1_1234_0;
    gl64_t kE1234 = tmp3_1 * s1_1234_1;
    gl64_t kF1234 = tmp3_2 * s1_1234_2;
    gl64_t kG1234 = kD1234 - kE1234;
    tmp3_6 = (kC1234 + kG1234) - kF1234;
    tmp3_7 = ((((kA1234 + kC1234) - kE1234) - kE1234) - kD1234);
    tmp3_8 = kB1234 - kG1234;
    // Op 1235: dim1x1 sub
    gl64_t s1_1235 = *(gl64_t*)&expressions_params[10][86];
    tmp1_0 = tmp1_4 - s1_1235;
    // Op 1236: dim1x1 sub
    gl64_t s1_1236 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1236;
    // Op 1237: dim3x1 mul
    gl64_t s0_1237_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1237_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1237_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1237_0 * tmp1_0; tmp3_1 = s0_1237_1 * tmp1_0; tmp3_2 = s0_1237_2 * tmp1_0;
    // Op 1238: dim3x1 add
    gl64_t s1_1238 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1238; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1239: dim3x3 add
    gl64_t s1_1239_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1239_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1239_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1239_0; tmp3_1 = tmp3_1 + s1_1239_1; tmp3_2 = tmp3_2 + s1_1239_2;
    // Op 1240: dim3x3 mul
    gl64_t s1_1240_0 = *(gl64_t*)&expressions_params[10][251];
    gl64_t s1_1240_1 = *(gl64_t*)&expressions_params[10][251+1];
    gl64_t s1_1240_2 = *(gl64_t*)&expressions_params[10][251+2];
    gl64_t kA1240 = (tmp3_0 + tmp3_1) * (s1_1240_0 + s1_1240_1);
    gl64_t kB1240 = (tmp3_0 + tmp3_2) * (s1_1240_0 + s1_1240_2);
    gl64_t kC1240 = (tmp3_1 + tmp3_2) * (s1_1240_1 + s1_1240_2);
    gl64_t kD1240 = tmp3_0 * s1_1240_0;
    gl64_t kE1240 = tmp3_1 * s1_1240_1;
    gl64_t kF1240 = tmp3_2 * s1_1240_2;
    gl64_t kG1240 = kD1240 - kE1240;
    tmp3_0 = (kC1240 + kG1240) - kF1240;
    tmp3_1 = ((((kA1240 + kC1240) - kE1240) - kE1240) - kD1240);
    tmp3_2 = kB1240 - kG1240;
    // Op 1241: dim3x1 add
    gl64_t s1_1241 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1241; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1242: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1243: dim3x3 mul
    gl64_t s1_1243_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1243_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1243_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1243 = (tmp3_0 + tmp3_1) * (s1_1243_0 + s1_1243_1);
    gl64_t kB1243 = (tmp3_0 + tmp3_2) * (s1_1243_0 + s1_1243_2);
    gl64_t kC1243 = (tmp3_1 + tmp3_2) * (s1_1243_1 + s1_1243_2);
    gl64_t kD1243 = tmp3_0 * s1_1243_0;
    gl64_t kE1243 = tmp3_1 * s1_1243_1;
    gl64_t kF1243 = tmp3_2 * s1_1243_2;
    gl64_t kG1243 = kD1243 - kE1243;
    tmp3_6 = (kC1243 + kG1243) - kF1243;
    tmp3_7 = ((((kA1243 + kC1243) - kE1243) - kE1243) - kD1243);
    tmp3_8 = kB1243 - kG1243;
    // Op 1244: dim3x1 mul
    gl64_t s0_1244_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1244_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1244_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1244 = *(gl64_t*)&expressions_params[10][41];
    tmp3_0 = s0_1244_0 * s1_1244; tmp3_1 = s0_1244_1 * s1_1244; tmp3_2 = s0_1244_2 * s1_1244;
    // Op 1245: dim3x1 add
    gl64_t s1_1245 = *(gl64_t*)&expressions_params[10][40];
    tmp3_0 = tmp3_0 + s1_1245; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1246: dim3x3 mul
    gl64_t s1_1246_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1246_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1246_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1246 = (tmp3_0 + tmp3_1) * (s1_1246_0 + s1_1246_1);
    gl64_t kB1246 = (tmp3_0 + tmp3_2) * (s1_1246_0 + s1_1246_2);
    gl64_t kC1246 = (tmp3_1 + tmp3_2) * (s1_1246_1 + s1_1246_2);
    gl64_t kD1246 = tmp3_0 * s1_1246_0;
    gl64_t kE1246 = tmp3_1 * s1_1246_1;
    gl64_t kF1246 = tmp3_2 * s1_1246_2;
    gl64_t kG1246 = kD1246 - kE1246;
    tmp3_0 = (kC1246 + kG1246) - kF1246;
    tmp3_1 = ((((kA1246 + kC1246) - kE1246) - kE1246) - kD1246);
    tmp3_2 = kB1246 - kG1246;
    // Op 1247: dim3x1 add
    gl64_t s1_1247 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1247; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1248: dim3x3 mul
    gl64_t s1_1248_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1248_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1248_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1248 = (tmp3_0 + tmp3_1) * (s1_1248_0 + s1_1248_1);
    gl64_t kB1248 = (tmp3_0 + tmp3_2) * (s1_1248_0 + s1_1248_2);
    gl64_t kC1248 = (tmp3_1 + tmp3_2) * (s1_1248_1 + s1_1248_2);
    gl64_t kD1248 = tmp3_0 * s1_1248_0;
    gl64_t kE1248 = tmp3_1 * s1_1248_1;
    gl64_t kF1248 = tmp3_2 * s1_1248_2;
    gl64_t kG1248 = kD1248 - kE1248;
    tmp3_0 = (kC1248 + kG1248) - kF1248;
    tmp3_1 = ((((kA1248 + kC1248) - kE1248) - kE1248) - kD1248);
    tmp3_2 = kB1248 - kG1248;
    // Op 1249: dim3x1 add
    gl64_t s1_1249 = *(gl64_t*)&expressions_params[10][86];
    tmp3_0 = tmp3_0 + s1_1249; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1250: dim3x3 mul
    gl64_t s1_1250_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1250_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1250_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1250 = (tmp3_0 + tmp3_1) * (s1_1250_0 + s1_1250_1);
    gl64_t kB1250 = (tmp3_0 + tmp3_2) * (s1_1250_0 + s1_1250_2);
    gl64_t kC1250 = (tmp3_1 + tmp3_2) * (s1_1250_1 + s1_1250_2);
    gl64_t kD1250 = tmp3_0 * s1_1250_0;
    gl64_t kE1250 = tmp3_1 * s1_1250_1;
    gl64_t kF1250 = tmp3_2 * s1_1250_2;
    gl64_t kG1250 = kD1250 - kE1250;
    tmp3_0 = (kC1250 + kG1250) - kF1250;
    tmp3_1 = ((((kA1250 + kC1250) - kE1250) - kE1250) - kD1250);
    tmp3_2 = kB1250 - kG1250;
    // Op 1251: dim3x1 add
    gl64_t s1_1251 = *(gl64_t*)&expressions_params[9][33];
    tmp3_0 = tmp3_0 + s1_1251; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1252: dim3x3 mul
    gl64_t s1_1252_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1252_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1252_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1252 = (tmp3_0 + tmp3_1) * (s1_1252_0 + s1_1252_1);
    gl64_t kB1252 = (tmp3_0 + tmp3_2) * (s1_1252_0 + s1_1252_2);
    gl64_t kC1252 = (tmp3_1 + tmp3_2) * (s1_1252_1 + s1_1252_2);
    gl64_t kD1252 = tmp3_0 * s1_1252_0;
    gl64_t kE1252 = tmp3_1 * s1_1252_1;
    gl64_t kF1252 = tmp3_2 * s1_1252_2;
    gl64_t kG1252 = kD1252 - kE1252;
    tmp3_0 = (kC1252 + kG1252) - kF1252;
    tmp3_1 = ((((kA1252 + kC1252) - kE1252) - kE1252) - kD1252);
    tmp3_2 = kB1252 - kG1252;
    // Op 1253: dim3x1 add
    gl64_t s1_1253 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1253; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1254: dim3x3 mul
    gl64_t s1_1254_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1254_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1254_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1254 = (tmp3_0 + tmp3_1) * (s1_1254_0 + s1_1254_1);
    gl64_t kB1254 = (tmp3_0 + tmp3_2) * (s1_1254_0 + s1_1254_2);
    gl64_t kC1254 = (tmp3_1 + tmp3_2) * (s1_1254_1 + s1_1254_2);
    gl64_t kD1254 = tmp3_0 * s1_1254_0;
    gl64_t kE1254 = tmp3_1 * s1_1254_1;
    gl64_t kF1254 = tmp3_2 * s1_1254_2;
    gl64_t kG1254 = kD1254 - kE1254;
    tmp3_0 = (kC1254 + kG1254) - kF1254;
    tmp3_1 = ((((kA1254 + kC1254) - kE1254) - kE1254) - kD1254);
    tmp3_2 = kB1254 - kG1254;
    // Op 1255: dim3x1 add
    gl64_t s1_1255 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1255; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1256: dim3x3 add
    gl64_t s1_1256_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1256_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1256_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1256_0; tmp3_1 = tmp3_1 + s1_1256_1; tmp3_2 = tmp3_2 + s1_1256_2;
    // Op 1257: dim3x3 mul
    gl64_t s1_1257_0 = *(gl64_t*)&expressions_params[10][254];
    gl64_t s1_1257_1 = *(gl64_t*)&expressions_params[10][254+1];
    gl64_t s1_1257_2 = *(gl64_t*)&expressions_params[10][254+2];
    gl64_t kA1257 = (tmp3_0 + tmp3_1) * (s1_1257_0 + s1_1257_1);
    gl64_t kB1257 = (tmp3_0 + tmp3_2) * (s1_1257_0 + s1_1257_2);
    gl64_t kC1257 = (tmp3_1 + tmp3_2) * (s1_1257_1 + s1_1257_2);
    gl64_t kD1257 = tmp3_0 * s1_1257_0;
    gl64_t kE1257 = tmp3_1 * s1_1257_1;
    gl64_t kF1257 = tmp3_2 * s1_1257_2;
    gl64_t kG1257 = kD1257 - kE1257;
    tmp3_0 = (kC1257 + kG1257) - kF1257;
    tmp3_1 = ((((kA1257 + kC1257) - kE1257) - kE1257) - kD1257);
    tmp3_2 = kB1257 - kG1257;
    // Op 1258: dim3x1 sub
    gl64_t s1_1258 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1258; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1259: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1260: dim3x3 mul
    gl64_t s1_1260_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1260_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1260_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1260 = (tmp3_0 + tmp3_1) * (s1_1260_0 + s1_1260_1);
    gl64_t kB1260 = (tmp3_0 + tmp3_2) * (s1_1260_0 + s1_1260_2);
    gl64_t kC1260 = (tmp3_1 + tmp3_2) * (s1_1260_1 + s1_1260_2);
    gl64_t kD1260 = tmp3_0 * s1_1260_0;
    gl64_t kE1260 = tmp3_1 * s1_1260_1;
    gl64_t kF1260 = tmp3_2 * s1_1260_2;
    gl64_t kG1260 = kD1260 - kE1260;
    tmp3_6 = (kC1260 + kG1260) - kF1260;
    tmp3_7 = ((((kA1260 + kC1260) - kE1260) - kE1260) - kD1260);
    tmp3_8 = kB1260 - kG1260;
    // Op 1261: dim3x1 mul
    gl64_t s0_1261_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1261_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1261_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1261 = *(gl64_t*)&expressions_params[10][41];
    tmp3_0 = s0_1261_0 * s1_1261; tmp3_1 = s0_1261_1 * s1_1261; tmp3_2 = s0_1261_2 * s1_1261;
    // Op 1262: dim3x1 add
    gl64_t s1_1262 = *(gl64_t*)&expressions_params[10][40];
    tmp3_0 = tmp3_0 + s1_1262; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1263: dim3x3 mul
    gl64_t s1_1263_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1263_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1263_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1263 = (tmp3_0 + tmp3_1) * (s1_1263_0 + s1_1263_1);
    gl64_t kB1263 = (tmp3_0 + tmp3_2) * (s1_1263_0 + s1_1263_2);
    gl64_t kC1263 = (tmp3_1 + tmp3_2) * (s1_1263_1 + s1_1263_2);
    gl64_t kD1263 = tmp3_0 * s1_1263_0;
    gl64_t kE1263 = tmp3_1 * s1_1263_1;
    gl64_t kF1263 = tmp3_2 * s1_1263_2;
    gl64_t kG1263 = kD1263 - kE1263;
    tmp3_0 = (kC1263 + kG1263) - kF1263;
    tmp3_1 = ((((kA1263 + kC1263) - kE1263) - kE1263) - kD1263);
    tmp3_2 = kB1263 - kG1263;
    // Op 1264: dim3x1 add
    gl64_t s1_1264 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1264; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1265: dim3x3 mul
    gl64_t s1_1265_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1265_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1265_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1265 = (tmp3_0 + tmp3_1) * (s1_1265_0 + s1_1265_1);
    gl64_t kB1265 = (tmp3_0 + tmp3_2) * (s1_1265_0 + s1_1265_2);
    gl64_t kC1265 = (tmp3_1 + tmp3_2) * (s1_1265_1 + s1_1265_2);
    gl64_t kD1265 = tmp3_0 * s1_1265_0;
    gl64_t kE1265 = tmp3_1 * s1_1265_1;
    gl64_t kF1265 = tmp3_2 * s1_1265_2;
    gl64_t kG1265 = kD1265 - kE1265;
    tmp3_0 = (kC1265 + kG1265) - kF1265;
    tmp3_1 = ((((kA1265 + kC1265) - kE1265) - kE1265) - kD1265);
    tmp3_2 = kB1265 - kG1265;
    // Op 1266: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1267: dim3x3 mul
    gl64_t s1_1267_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1267_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1267_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1267 = (tmp3_0 + tmp3_1) * (s1_1267_0 + s1_1267_1);
    gl64_t kB1267 = (tmp3_0 + tmp3_2) * (s1_1267_0 + s1_1267_2);
    gl64_t kC1267 = (tmp3_1 + tmp3_2) * (s1_1267_1 + s1_1267_2);
    gl64_t kD1267 = tmp3_0 * s1_1267_0;
    gl64_t kE1267 = tmp3_1 * s1_1267_1;
    gl64_t kF1267 = tmp3_2 * s1_1267_2;
    gl64_t kG1267 = kD1267 - kE1267;
    tmp3_0 = (kC1267 + kG1267) - kF1267;
    tmp3_1 = ((((kA1267 + kC1267) - kE1267) - kE1267) - kD1267);
    tmp3_2 = kB1267 - kG1267;
    // Op 1268: dim3x1 add
    gl64_t s1_1268 = *(gl64_t*)&expressions_params[9][33];
    tmp3_0 = tmp3_0 + s1_1268; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1269: dim3x3 mul
    gl64_t s1_1269_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1269_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1269_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1269 = (tmp3_0 + tmp3_1) * (s1_1269_0 + s1_1269_1);
    gl64_t kB1269 = (tmp3_0 + tmp3_2) * (s1_1269_0 + s1_1269_2);
    gl64_t kC1269 = (tmp3_1 + tmp3_2) * (s1_1269_1 + s1_1269_2);
    gl64_t kD1269 = tmp3_0 * s1_1269_0;
    gl64_t kE1269 = tmp3_1 * s1_1269_1;
    gl64_t kF1269 = tmp3_2 * s1_1269_2;
    gl64_t kG1269 = kD1269 - kE1269;
    tmp3_0 = (kC1269 + kG1269) - kF1269;
    tmp3_1 = ((((kA1269 + kC1269) - kE1269) - kE1269) - kD1269);
    tmp3_2 = kB1269 - kG1269;
    // Op 1270: dim3x1 add
    gl64_t s1_1270 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1270; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1271: dim3x3 mul
    gl64_t s1_1271_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1271_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1271_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1271 = (tmp3_0 + tmp3_1) * (s1_1271_0 + s1_1271_1);
    gl64_t kB1271 = (tmp3_0 + tmp3_2) * (s1_1271_0 + s1_1271_2);
    gl64_t kC1271 = (tmp3_1 + tmp3_2) * (s1_1271_1 + s1_1271_2);
    gl64_t kD1271 = tmp3_0 * s1_1271_0;
    gl64_t kE1271 = tmp3_1 * s1_1271_1;
    gl64_t kF1271 = tmp3_2 * s1_1271_2;
    gl64_t kG1271 = kD1271 - kE1271;
    tmp3_0 = (kC1271 + kG1271) - kF1271;
    tmp3_1 = ((((kA1271 + kC1271) - kE1271) - kE1271) - kD1271);
    tmp3_2 = kB1271 - kG1271;
    // Op 1272: dim3x1 add
    gl64_t s1_1272 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1272; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1273: dim3x3 add
    gl64_t s1_1273_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1273_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1273_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1273_0; tmp3_1 = tmp3_1 + s1_1273_1; tmp3_2 = tmp3_2 + s1_1273_2;
    // Op 1274: dim3x3 mul
    gl64_t s1_1274_0 = *(gl64_t*)&expressions_params[10][257];
    gl64_t s1_1274_1 = *(gl64_t*)&expressions_params[10][257+1];
    gl64_t s1_1274_2 = *(gl64_t*)&expressions_params[10][257+2];
    gl64_t kA1274 = (tmp3_0 + tmp3_1) * (s1_1274_0 + s1_1274_1);
    gl64_t kB1274 = (tmp3_0 + tmp3_2) * (s1_1274_0 + s1_1274_2);
    gl64_t kC1274 = (tmp3_1 + tmp3_2) * (s1_1274_1 + s1_1274_2);
    gl64_t kD1274 = tmp3_0 * s1_1274_0;
    gl64_t kE1274 = tmp3_1 * s1_1274_1;
    gl64_t kF1274 = tmp3_2 * s1_1274_2;
    gl64_t kG1274 = kD1274 - kE1274;
    tmp3_0 = (kC1274 + kG1274) - kF1274;
    tmp3_1 = ((((kA1274 + kC1274) - kE1274) - kE1274) - kD1274);
    tmp3_2 = kB1274 - kG1274;
    // Op 1275: dim1x1 sub
    gl64_t s0_1275 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1275 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1275 - s1_1275;
    // Op 1276: dim1x1 sub_swap
    gl64_t s1_1276 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1276 - tmp1_0;
    // Op 1277: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1278: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1279: dim3x3 mul
    gl64_t s1_1279_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1279_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1279_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1279 = (tmp3_0 + tmp3_1) * (s1_1279_0 + s1_1279_1);
    gl64_t kB1279 = (tmp3_0 + tmp3_2) * (s1_1279_0 + s1_1279_2);
    gl64_t kC1279 = (tmp3_1 + tmp3_2) * (s1_1279_1 + s1_1279_2);
    gl64_t kD1279 = tmp3_0 * s1_1279_0;
    gl64_t kE1279 = tmp3_1 * s1_1279_1;
    gl64_t kF1279 = tmp3_2 * s1_1279_2;
    gl64_t kG1279 = kD1279 - kE1279;
    tmp3_6 = (kC1279 + kG1279) - kF1279;
    tmp3_7 = ((((kA1279 + kC1279) - kE1279) - kE1279) - kD1279);
    tmp3_8 = kB1279 - kG1279;
    // Op 1280: dim1x1 sub
    gl64_t s1_1280 = *(gl64_t*)&expressions_params[10][87];
    tmp1_0 = tmp1_4 - s1_1280;
    // Op 1281: dim1x1 sub
    gl64_t s1_1281 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1281;
    // Op 1282: dim3x1 mul
    gl64_t s0_1282_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1282_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1282_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1282_0 * tmp1_0; tmp3_1 = s0_1282_1 * tmp1_0; tmp3_2 = s0_1282_2 * tmp1_0;
    // Op 1283: dim3x1 add
    gl64_t s1_1283 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1283; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1284: dim3x3 add
    gl64_t s1_1284_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1284_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1284_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1284_0; tmp3_1 = tmp3_1 + s1_1284_1; tmp3_2 = tmp3_2 + s1_1284_2;
    // Op 1285: dim3x3 mul
    gl64_t s1_1285_0 = *(gl64_t*)&expressions_params[10][260];
    gl64_t s1_1285_1 = *(gl64_t*)&expressions_params[10][260+1];
    gl64_t s1_1285_2 = *(gl64_t*)&expressions_params[10][260+2];
    gl64_t kA1285 = (tmp3_0 + tmp3_1) * (s1_1285_0 + s1_1285_1);
    gl64_t kB1285 = (tmp3_0 + tmp3_2) * (s1_1285_0 + s1_1285_2);
    gl64_t kC1285 = (tmp3_1 + tmp3_2) * (s1_1285_1 + s1_1285_2);
    gl64_t kD1285 = tmp3_0 * s1_1285_0;
    gl64_t kE1285 = tmp3_1 * s1_1285_1;
    gl64_t kF1285 = tmp3_2 * s1_1285_2;
    gl64_t kG1285 = kD1285 - kE1285;
    tmp3_0 = (kC1285 + kG1285) - kF1285;
    tmp3_1 = ((((kA1285 + kC1285) - kE1285) - kE1285) - kD1285);
    tmp3_2 = kB1285 - kG1285;
    // Op 1286: dim3x1 add
    gl64_t s1_1286 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1286; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1287: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1288: dim3x3 mul
    gl64_t s1_1288_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1288_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1288_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1288 = (tmp3_0 + tmp3_1) * (s1_1288_0 + s1_1288_1);
    gl64_t kB1288 = (tmp3_0 + tmp3_2) * (s1_1288_0 + s1_1288_2);
    gl64_t kC1288 = (tmp3_1 + tmp3_2) * (s1_1288_1 + s1_1288_2);
    gl64_t kD1288 = tmp3_0 * s1_1288_0;
    gl64_t kE1288 = tmp3_1 * s1_1288_1;
    gl64_t kF1288 = tmp3_2 * s1_1288_2;
    gl64_t kG1288 = kD1288 - kE1288;
    tmp3_6 = (kC1288 + kG1288) - kF1288;
    tmp3_7 = ((((kA1288 + kC1288) - kE1288) - kE1288) - kD1288);
    tmp3_8 = kB1288 - kG1288;
    // Op 1289: dim3x1 mul
    gl64_t s0_1289_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1289_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1289_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1289 = *(gl64_t*)&expressions_params[10][43];
    tmp3_0 = s0_1289_0 * s1_1289; tmp3_1 = s0_1289_1 * s1_1289; tmp3_2 = s0_1289_2 * s1_1289;
    // Op 1290: dim3x1 add
    gl64_t s1_1290 = *(gl64_t*)&expressions_params[10][42];
    tmp3_0 = tmp3_0 + s1_1290; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1291: dim3x3 mul
    gl64_t s1_1291_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1291_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1291_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1291 = (tmp3_0 + tmp3_1) * (s1_1291_0 + s1_1291_1);
    gl64_t kB1291 = (tmp3_0 + tmp3_2) * (s1_1291_0 + s1_1291_2);
    gl64_t kC1291 = (tmp3_1 + tmp3_2) * (s1_1291_1 + s1_1291_2);
    gl64_t kD1291 = tmp3_0 * s1_1291_0;
    gl64_t kE1291 = tmp3_1 * s1_1291_1;
    gl64_t kF1291 = tmp3_2 * s1_1291_2;
    gl64_t kG1291 = kD1291 - kE1291;
    tmp3_0 = (kC1291 + kG1291) - kF1291;
    tmp3_1 = ((((kA1291 + kC1291) - kE1291) - kE1291) - kD1291);
    tmp3_2 = kB1291 - kG1291;
    // Op 1292: dim3x1 add
    gl64_t s1_1292 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1292; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1293: dim3x3 mul
    gl64_t s1_1293_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1293_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1293_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1293 = (tmp3_0 + tmp3_1) * (s1_1293_0 + s1_1293_1);
    gl64_t kB1293 = (tmp3_0 + tmp3_2) * (s1_1293_0 + s1_1293_2);
    gl64_t kC1293 = (tmp3_1 + tmp3_2) * (s1_1293_1 + s1_1293_2);
    gl64_t kD1293 = tmp3_0 * s1_1293_0;
    gl64_t kE1293 = tmp3_1 * s1_1293_1;
    gl64_t kF1293 = tmp3_2 * s1_1293_2;
    gl64_t kG1293 = kD1293 - kE1293;
    tmp3_0 = (kC1293 + kG1293) - kF1293;
    tmp3_1 = ((((kA1293 + kC1293) - kE1293) - kE1293) - kD1293);
    tmp3_2 = kB1293 - kG1293;
    // Op 1294: dim3x1 add
    gl64_t s1_1294 = *(gl64_t*)&expressions_params[10][87];
    tmp3_0 = tmp3_0 + s1_1294; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1295: dim3x3 mul
    gl64_t s1_1295_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1295_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1295_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1295 = (tmp3_0 + tmp3_1) * (s1_1295_0 + s1_1295_1);
    gl64_t kB1295 = (tmp3_0 + tmp3_2) * (s1_1295_0 + s1_1295_2);
    gl64_t kC1295 = (tmp3_1 + tmp3_2) * (s1_1295_1 + s1_1295_2);
    gl64_t kD1295 = tmp3_0 * s1_1295_0;
    gl64_t kE1295 = tmp3_1 * s1_1295_1;
    gl64_t kF1295 = tmp3_2 * s1_1295_2;
    gl64_t kG1295 = kD1295 - kE1295;
    tmp3_0 = (kC1295 + kG1295) - kF1295;
    tmp3_1 = ((((kA1295 + kC1295) - kE1295) - kE1295) - kD1295);
    tmp3_2 = kB1295 - kG1295;
    // Op 1296: dim3x1 add
    gl64_t s1_1296 = *(gl64_t*)&expressions_params[9][34];
    tmp3_0 = tmp3_0 + s1_1296; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1297: dim3x3 mul
    gl64_t s1_1297_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1297_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1297_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1297 = (tmp3_0 + tmp3_1) * (s1_1297_0 + s1_1297_1);
    gl64_t kB1297 = (tmp3_0 + tmp3_2) * (s1_1297_0 + s1_1297_2);
    gl64_t kC1297 = (tmp3_1 + tmp3_2) * (s1_1297_1 + s1_1297_2);
    gl64_t kD1297 = tmp3_0 * s1_1297_0;
    gl64_t kE1297 = tmp3_1 * s1_1297_1;
    gl64_t kF1297 = tmp3_2 * s1_1297_2;
    gl64_t kG1297 = kD1297 - kE1297;
    tmp3_0 = (kC1297 + kG1297) - kF1297;
    tmp3_1 = ((((kA1297 + kC1297) - kE1297) - kE1297) - kD1297);
    tmp3_2 = kB1297 - kG1297;
    // Op 1298: dim3x1 add
    gl64_t s1_1298 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1298; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1299: dim3x3 mul
    gl64_t s1_1299_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1299_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1299_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1299 = (tmp3_0 + tmp3_1) * (s1_1299_0 + s1_1299_1);
    gl64_t kB1299 = (tmp3_0 + tmp3_2) * (s1_1299_0 + s1_1299_2);
    gl64_t kC1299 = (tmp3_1 + tmp3_2) * (s1_1299_1 + s1_1299_2);
    gl64_t kD1299 = tmp3_0 * s1_1299_0;
    gl64_t kE1299 = tmp3_1 * s1_1299_1;
    gl64_t kF1299 = tmp3_2 * s1_1299_2;
    gl64_t kG1299 = kD1299 - kE1299;
    tmp3_0 = (kC1299 + kG1299) - kF1299;
    tmp3_1 = ((((kA1299 + kC1299) - kE1299) - kE1299) - kD1299);
    tmp3_2 = kB1299 - kG1299;
    // Op 1300: dim3x1 add
    gl64_t s1_1300 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1300; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1301: dim3x3 add
    gl64_t s1_1301_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1301_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1301_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1301_0; tmp3_1 = tmp3_1 + s1_1301_1; tmp3_2 = tmp3_2 + s1_1301_2;
    // Op 1302: dim3x3 mul
    gl64_t s1_1302_0 = *(gl64_t*)&expressions_params[10][263];
    gl64_t s1_1302_1 = *(gl64_t*)&expressions_params[10][263+1];
    gl64_t s1_1302_2 = *(gl64_t*)&expressions_params[10][263+2];
    gl64_t kA1302 = (tmp3_0 + tmp3_1) * (s1_1302_0 + s1_1302_1);
    gl64_t kB1302 = (tmp3_0 + tmp3_2) * (s1_1302_0 + s1_1302_2);
    gl64_t kC1302 = (tmp3_1 + tmp3_2) * (s1_1302_1 + s1_1302_2);
    gl64_t kD1302 = tmp3_0 * s1_1302_0;
    gl64_t kE1302 = tmp3_1 * s1_1302_1;
    gl64_t kF1302 = tmp3_2 * s1_1302_2;
    gl64_t kG1302 = kD1302 - kE1302;
    tmp3_0 = (kC1302 + kG1302) - kF1302;
    tmp3_1 = ((((kA1302 + kC1302) - kE1302) - kE1302) - kD1302);
    tmp3_2 = kB1302 - kG1302;
    // Op 1303: dim3x1 sub
    gl64_t s1_1303 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1303; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1304: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1305: dim3x3 mul
    gl64_t s1_1305_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1305_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1305_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1305 = (tmp3_0 + tmp3_1) * (s1_1305_0 + s1_1305_1);
    gl64_t kB1305 = (tmp3_0 + tmp3_2) * (s1_1305_0 + s1_1305_2);
    gl64_t kC1305 = (tmp3_1 + tmp3_2) * (s1_1305_1 + s1_1305_2);
    gl64_t kD1305 = tmp3_0 * s1_1305_0;
    gl64_t kE1305 = tmp3_1 * s1_1305_1;
    gl64_t kF1305 = tmp3_2 * s1_1305_2;
    gl64_t kG1305 = kD1305 - kE1305;
    tmp3_6 = (kC1305 + kG1305) - kF1305;
    tmp3_7 = ((((kA1305 + kC1305) - kE1305) - kE1305) - kD1305);
    tmp3_8 = kB1305 - kG1305;
    // Op 1306: dim3x1 mul
    gl64_t s0_1306_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1306_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1306_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1306 = *(gl64_t*)&expressions_params[10][43];
    tmp3_0 = s0_1306_0 * s1_1306; tmp3_1 = s0_1306_1 * s1_1306; tmp3_2 = s0_1306_2 * s1_1306;
    // Op 1307: dim3x1 add
    gl64_t s1_1307 = *(gl64_t*)&expressions_params[10][42];
    tmp3_0 = tmp3_0 + s1_1307; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1308: dim3x3 mul
    gl64_t s1_1308_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1308_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1308_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1308 = (tmp3_0 + tmp3_1) * (s1_1308_0 + s1_1308_1);
    gl64_t kB1308 = (tmp3_0 + tmp3_2) * (s1_1308_0 + s1_1308_2);
    gl64_t kC1308 = (tmp3_1 + tmp3_2) * (s1_1308_1 + s1_1308_2);
    gl64_t kD1308 = tmp3_0 * s1_1308_0;
    gl64_t kE1308 = tmp3_1 * s1_1308_1;
    gl64_t kF1308 = tmp3_2 * s1_1308_2;
    gl64_t kG1308 = kD1308 - kE1308;
    tmp3_0 = (kC1308 + kG1308) - kF1308;
    tmp3_1 = ((((kA1308 + kC1308) - kE1308) - kE1308) - kD1308);
    tmp3_2 = kB1308 - kG1308;
    // Op 1309: dim3x1 add
    gl64_t s1_1309 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1309; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1310: dim3x3 mul
    gl64_t s1_1310_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1310_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1310_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1310 = (tmp3_0 + tmp3_1) * (s1_1310_0 + s1_1310_1);
    gl64_t kB1310 = (tmp3_0 + tmp3_2) * (s1_1310_0 + s1_1310_2);
    gl64_t kC1310 = (tmp3_1 + tmp3_2) * (s1_1310_1 + s1_1310_2);
    gl64_t kD1310 = tmp3_0 * s1_1310_0;
    gl64_t kE1310 = tmp3_1 * s1_1310_1;
    gl64_t kF1310 = tmp3_2 * s1_1310_2;
    gl64_t kG1310 = kD1310 - kE1310;
    tmp3_0 = (kC1310 + kG1310) - kF1310;
    tmp3_1 = ((((kA1310 + kC1310) - kE1310) - kE1310) - kD1310);
    tmp3_2 = kB1310 - kG1310;
    // Op 1311: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1312: dim3x3 mul
    gl64_t s1_1312_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1312_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1312_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1312 = (tmp3_0 + tmp3_1) * (s1_1312_0 + s1_1312_1);
    gl64_t kB1312 = (tmp3_0 + tmp3_2) * (s1_1312_0 + s1_1312_2);
    gl64_t kC1312 = (tmp3_1 + tmp3_2) * (s1_1312_1 + s1_1312_2);
    gl64_t kD1312 = tmp3_0 * s1_1312_0;
    gl64_t kE1312 = tmp3_1 * s1_1312_1;
    gl64_t kF1312 = tmp3_2 * s1_1312_2;
    gl64_t kG1312 = kD1312 - kE1312;
    tmp3_0 = (kC1312 + kG1312) - kF1312;
    tmp3_1 = ((((kA1312 + kC1312) - kE1312) - kE1312) - kD1312);
    tmp3_2 = kB1312 - kG1312;
    // Op 1313: dim3x1 add
    gl64_t s1_1313 = *(gl64_t*)&expressions_params[9][34];
    tmp3_0 = tmp3_0 + s1_1313; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1314: dim3x3 mul
    gl64_t s1_1314_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1314_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1314_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1314 = (tmp3_0 + tmp3_1) * (s1_1314_0 + s1_1314_1);
    gl64_t kB1314 = (tmp3_0 + tmp3_2) * (s1_1314_0 + s1_1314_2);
    gl64_t kC1314 = (tmp3_1 + tmp3_2) * (s1_1314_1 + s1_1314_2);
    gl64_t kD1314 = tmp3_0 * s1_1314_0;
    gl64_t kE1314 = tmp3_1 * s1_1314_1;
    gl64_t kF1314 = tmp3_2 * s1_1314_2;
    gl64_t kG1314 = kD1314 - kE1314;
    tmp3_0 = (kC1314 + kG1314) - kF1314;
    tmp3_1 = ((((kA1314 + kC1314) - kE1314) - kE1314) - kD1314);
    tmp3_2 = kB1314 - kG1314;
    // Op 1315: dim3x1 add
    gl64_t s1_1315 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1315; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1316: dim3x3 mul
    gl64_t s1_1316_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1316_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1316_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1316 = (tmp3_0 + tmp3_1) * (s1_1316_0 + s1_1316_1);
    gl64_t kB1316 = (tmp3_0 + tmp3_2) * (s1_1316_0 + s1_1316_2);
    gl64_t kC1316 = (tmp3_1 + tmp3_2) * (s1_1316_1 + s1_1316_2);
    gl64_t kD1316 = tmp3_0 * s1_1316_0;
    gl64_t kE1316 = tmp3_1 * s1_1316_1;
    gl64_t kF1316 = tmp3_2 * s1_1316_2;
    gl64_t kG1316 = kD1316 - kE1316;
    tmp3_0 = (kC1316 + kG1316) - kF1316;
    tmp3_1 = ((((kA1316 + kC1316) - kE1316) - kE1316) - kD1316);
    tmp3_2 = kB1316 - kG1316;
    // Op 1317: dim3x1 add
    gl64_t s1_1317 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1317; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1318: dim3x3 add
    gl64_t s1_1318_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1318_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1318_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1318_0; tmp3_1 = tmp3_1 + s1_1318_1; tmp3_2 = tmp3_2 + s1_1318_2;
    // Op 1319: dim3x3 mul
    gl64_t s1_1319_0 = *(gl64_t*)&expressions_params[10][266];
    gl64_t s1_1319_1 = *(gl64_t*)&expressions_params[10][266+1];
    gl64_t s1_1319_2 = *(gl64_t*)&expressions_params[10][266+2];
    gl64_t kA1319 = (tmp3_0 + tmp3_1) * (s1_1319_0 + s1_1319_1);
    gl64_t kB1319 = (tmp3_0 + tmp3_2) * (s1_1319_0 + s1_1319_2);
    gl64_t kC1319 = (tmp3_1 + tmp3_2) * (s1_1319_1 + s1_1319_2);
    gl64_t kD1319 = tmp3_0 * s1_1319_0;
    gl64_t kE1319 = tmp3_1 * s1_1319_1;
    gl64_t kF1319 = tmp3_2 * s1_1319_2;
    gl64_t kG1319 = kD1319 - kE1319;
    tmp3_0 = (kC1319 + kG1319) - kF1319;
    tmp3_1 = ((((kA1319 + kC1319) - kE1319) - kE1319) - kD1319);
    tmp3_2 = kB1319 - kG1319;
    // Op 1320: dim1x1 sub
    gl64_t s0_1320 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1320 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1320 - s1_1320;
    // Op 1321: dim1x1 sub_swap
    gl64_t s1_1321 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1321 - tmp1_0;
    // Op 1322: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1323: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1324: dim3x3 mul
    gl64_t s1_1324_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1324_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1324_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1324 = (tmp3_0 + tmp3_1) * (s1_1324_0 + s1_1324_1);
    gl64_t kB1324 = (tmp3_0 + tmp3_2) * (s1_1324_0 + s1_1324_2);
    gl64_t kC1324 = (tmp3_1 + tmp3_2) * (s1_1324_1 + s1_1324_2);
    gl64_t kD1324 = tmp3_0 * s1_1324_0;
    gl64_t kE1324 = tmp3_1 * s1_1324_1;
    gl64_t kF1324 = tmp3_2 * s1_1324_2;
    gl64_t kG1324 = kD1324 - kE1324;
    tmp3_6 = (kC1324 + kG1324) - kF1324;
    tmp3_7 = ((((kA1324 + kC1324) - kE1324) - kE1324) - kD1324);
    tmp3_8 = kB1324 - kG1324;
    // Op 1325: dim1x1 sub
    gl64_t s1_1325 = *(gl64_t*)&expressions_params[10][88];
    tmp1_0 = tmp1_4 - s1_1325;
    // Op 1326: dim1x1 sub
    gl64_t s1_1326 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1326;
    // Op 1327: dim3x1 mul
    gl64_t s0_1327_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1327_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1327_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1327_0 * tmp1_0; tmp3_1 = s0_1327_1 * tmp1_0; tmp3_2 = s0_1327_2 * tmp1_0;
    // Op 1328: dim3x1 add
    gl64_t s1_1328 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1328; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1329: dim3x3 add
    gl64_t s1_1329_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1329_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1329_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1329_0; tmp3_1 = tmp3_1 + s1_1329_1; tmp3_2 = tmp3_2 + s1_1329_2;
    // Op 1330: dim3x3 mul
    gl64_t s1_1330_0 = *(gl64_t*)&expressions_params[10][269];
    gl64_t s1_1330_1 = *(gl64_t*)&expressions_params[10][269+1];
    gl64_t s1_1330_2 = *(gl64_t*)&expressions_params[10][269+2];
    gl64_t kA1330 = (tmp3_0 + tmp3_1) * (s1_1330_0 + s1_1330_1);
    gl64_t kB1330 = (tmp3_0 + tmp3_2) * (s1_1330_0 + s1_1330_2);
    gl64_t kC1330 = (tmp3_1 + tmp3_2) * (s1_1330_1 + s1_1330_2);
    gl64_t kD1330 = tmp3_0 * s1_1330_0;
    gl64_t kE1330 = tmp3_1 * s1_1330_1;
    gl64_t kF1330 = tmp3_2 * s1_1330_2;
    gl64_t kG1330 = kD1330 - kE1330;
    tmp3_0 = (kC1330 + kG1330) - kF1330;
    tmp3_1 = ((((kA1330 + kC1330) - kE1330) - kE1330) - kD1330);
    tmp3_2 = kB1330 - kG1330;
    // Op 1331: dim3x1 add
    gl64_t s1_1331 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1331; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1332: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1333: dim3x3 mul
    gl64_t s1_1333_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1333_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1333_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1333 = (tmp3_0 + tmp3_1) * (s1_1333_0 + s1_1333_1);
    gl64_t kB1333 = (tmp3_0 + tmp3_2) * (s1_1333_0 + s1_1333_2);
    gl64_t kC1333 = (tmp3_1 + tmp3_2) * (s1_1333_1 + s1_1333_2);
    gl64_t kD1333 = tmp3_0 * s1_1333_0;
    gl64_t kE1333 = tmp3_1 * s1_1333_1;
    gl64_t kF1333 = tmp3_2 * s1_1333_2;
    gl64_t kG1333 = kD1333 - kE1333;
    tmp3_6 = (kC1333 + kG1333) - kF1333;
    tmp3_7 = ((((kA1333 + kC1333) - kE1333) - kE1333) - kD1333);
    tmp3_8 = kB1333 - kG1333;
    // Op 1334: dim3x1 mul
    gl64_t s0_1334_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1334_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1334_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1334 = *(gl64_t*)&expressions_params[10][45];
    tmp3_0 = s0_1334_0 * s1_1334; tmp3_1 = s0_1334_1 * s1_1334; tmp3_2 = s0_1334_2 * s1_1334;
    // Op 1335: dim3x1 add
    gl64_t s1_1335 = *(gl64_t*)&expressions_params[10][44];
    tmp3_0 = tmp3_0 + s1_1335; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1336: dim3x3 mul
    gl64_t s1_1336_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1336_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1336_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1336 = (tmp3_0 + tmp3_1) * (s1_1336_0 + s1_1336_1);
    gl64_t kB1336 = (tmp3_0 + tmp3_2) * (s1_1336_0 + s1_1336_2);
    gl64_t kC1336 = (tmp3_1 + tmp3_2) * (s1_1336_1 + s1_1336_2);
    gl64_t kD1336 = tmp3_0 * s1_1336_0;
    gl64_t kE1336 = tmp3_1 * s1_1336_1;
    gl64_t kF1336 = tmp3_2 * s1_1336_2;
    gl64_t kG1336 = kD1336 - kE1336;
    tmp3_0 = (kC1336 + kG1336) - kF1336;
    tmp3_1 = ((((kA1336 + kC1336) - kE1336) - kE1336) - kD1336);
    tmp3_2 = kB1336 - kG1336;
    // Op 1337: dim3x1 add
    gl64_t s1_1337 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1337; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1338: dim3x3 mul
    gl64_t s1_1338_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1338_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1338_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1338 = (tmp3_0 + tmp3_1) * (s1_1338_0 + s1_1338_1);
    gl64_t kB1338 = (tmp3_0 + tmp3_2) * (s1_1338_0 + s1_1338_2);
    gl64_t kC1338 = (tmp3_1 + tmp3_2) * (s1_1338_1 + s1_1338_2);
    gl64_t kD1338 = tmp3_0 * s1_1338_0;
    gl64_t kE1338 = tmp3_1 * s1_1338_1;
    gl64_t kF1338 = tmp3_2 * s1_1338_2;
    gl64_t kG1338 = kD1338 - kE1338;
    tmp3_0 = (kC1338 + kG1338) - kF1338;
    tmp3_1 = ((((kA1338 + kC1338) - kE1338) - kE1338) - kD1338);
    tmp3_2 = kB1338 - kG1338;
    // Op 1339: dim3x1 add
    gl64_t s1_1339 = *(gl64_t*)&expressions_params[10][88];
    tmp3_0 = tmp3_0 + s1_1339; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1340: dim3x3 mul
    gl64_t s1_1340_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1340_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1340_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1340 = (tmp3_0 + tmp3_1) * (s1_1340_0 + s1_1340_1);
    gl64_t kB1340 = (tmp3_0 + tmp3_2) * (s1_1340_0 + s1_1340_2);
    gl64_t kC1340 = (tmp3_1 + tmp3_2) * (s1_1340_1 + s1_1340_2);
    gl64_t kD1340 = tmp3_0 * s1_1340_0;
    gl64_t kE1340 = tmp3_1 * s1_1340_1;
    gl64_t kF1340 = tmp3_2 * s1_1340_2;
    gl64_t kG1340 = kD1340 - kE1340;
    tmp3_0 = (kC1340 + kG1340) - kF1340;
    tmp3_1 = ((((kA1340 + kC1340) - kE1340) - kE1340) - kD1340);
    tmp3_2 = kB1340 - kG1340;
    // Op 1341: dim3x1 add
    gl64_t s1_1341 = *(gl64_t*)&expressions_params[9][35];
    tmp3_0 = tmp3_0 + s1_1341; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1342: dim3x3 mul
    gl64_t s1_1342_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1342_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1342_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1342 = (tmp3_0 + tmp3_1) * (s1_1342_0 + s1_1342_1);
    gl64_t kB1342 = (tmp3_0 + tmp3_2) * (s1_1342_0 + s1_1342_2);
    gl64_t kC1342 = (tmp3_1 + tmp3_2) * (s1_1342_1 + s1_1342_2);
    gl64_t kD1342 = tmp3_0 * s1_1342_0;
    gl64_t kE1342 = tmp3_1 * s1_1342_1;
    gl64_t kF1342 = tmp3_2 * s1_1342_2;
    gl64_t kG1342 = kD1342 - kE1342;
    tmp3_0 = (kC1342 + kG1342) - kF1342;
    tmp3_1 = ((((kA1342 + kC1342) - kE1342) - kE1342) - kD1342);
    tmp3_2 = kB1342 - kG1342;
    // Op 1343: dim3x1 add
    gl64_t s1_1343 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1343; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1344: dim3x3 mul
    gl64_t s1_1344_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1344_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1344_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1344 = (tmp3_0 + tmp3_1) * (s1_1344_0 + s1_1344_1);
    gl64_t kB1344 = (tmp3_0 + tmp3_2) * (s1_1344_0 + s1_1344_2);
    gl64_t kC1344 = (tmp3_1 + tmp3_2) * (s1_1344_1 + s1_1344_2);
    gl64_t kD1344 = tmp3_0 * s1_1344_0;
    gl64_t kE1344 = tmp3_1 * s1_1344_1;
    gl64_t kF1344 = tmp3_2 * s1_1344_2;
    gl64_t kG1344 = kD1344 - kE1344;
    tmp3_0 = (kC1344 + kG1344) - kF1344;
    tmp3_1 = ((((kA1344 + kC1344) - kE1344) - kE1344) - kD1344);
    tmp3_2 = kB1344 - kG1344;
    // Op 1345: dim3x1 add
    gl64_t s1_1345 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1345; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1346: dim3x3 add
    gl64_t s1_1346_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1346_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1346_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1346_0; tmp3_1 = tmp3_1 + s1_1346_1; tmp3_2 = tmp3_2 + s1_1346_2;
    // Op 1347: dim3x3 mul
    gl64_t s1_1347_0 = *(gl64_t*)&expressions_params[10][272];
    gl64_t s1_1347_1 = *(gl64_t*)&expressions_params[10][272+1];
    gl64_t s1_1347_2 = *(gl64_t*)&expressions_params[10][272+2];
    gl64_t kA1347 = (tmp3_0 + tmp3_1) * (s1_1347_0 + s1_1347_1);
    gl64_t kB1347 = (tmp3_0 + tmp3_2) * (s1_1347_0 + s1_1347_2);
    gl64_t kC1347 = (tmp3_1 + tmp3_2) * (s1_1347_1 + s1_1347_2);
    gl64_t kD1347 = tmp3_0 * s1_1347_0;
    gl64_t kE1347 = tmp3_1 * s1_1347_1;
    gl64_t kF1347 = tmp3_2 * s1_1347_2;
    gl64_t kG1347 = kD1347 - kE1347;
    tmp3_0 = (kC1347 + kG1347) - kF1347;
    tmp3_1 = ((((kA1347 + kC1347) - kE1347) - kE1347) - kD1347);
    tmp3_2 = kB1347 - kG1347;
    // Op 1348: dim3x1 sub
    gl64_t s1_1348 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1348; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1349: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1350: dim3x3 mul
    gl64_t s1_1350_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1350_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1350_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1350 = (tmp3_0 + tmp3_1) * (s1_1350_0 + s1_1350_1);
    gl64_t kB1350 = (tmp3_0 + tmp3_2) * (s1_1350_0 + s1_1350_2);
    gl64_t kC1350 = (tmp3_1 + tmp3_2) * (s1_1350_1 + s1_1350_2);
    gl64_t kD1350 = tmp3_0 * s1_1350_0;
    gl64_t kE1350 = tmp3_1 * s1_1350_1;
    gl64_t kF1350 = tmp3_2 * s1_1350_2;
    gl64_t kG1350 = kD1350 - kE1350;
    tmp3_6 = (kC1350 + kG1350) - kF1350;
    tmp3_7 = ((((kA1350 + kC1350) - kE1350) - kE1350) - kD1350);
    tmp3_8 = kB1350 - kG1350;
    // Op 1351: dim3x1 mul
    gl64_t s0_1351_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1351_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1351_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1351 = *(gl64_t*)&expressions_params[10][45];
    tmp3_0 = s0_1351_0 * s1_1351; tmp3_1 = s0_1351_1 * s1_1351; tmp3_2 = s0_1351_2 * s1_1351;
    // Op 1352: dim3x1 add
    gl64_t s1_1352 = *(gl64_t*)&expressions_params[10][44];
    tmp3_0 = tmp3_0 + s1_1352; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1353: dim3x3 mul
    gl64_t s1_1353_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1353_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1353_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1353 = (tmp3_0 + tmp3_1) * (s1_1353_0 + s1_1353_1);
    gl64_t kB1353 = (tmp3_0 + tmp3_2) * (s1_1353_0 + s1_1353_2);
    gl64_t kC1353 = (tmp3_1 + tmp3_2) * (s1_1353_1 + s1_1353_2);
    gl64_t kD1353 = tmp3_0 * s1_1353_0;
    gl64_t kE1353 = tmp3_1 * s1_1353_1;
    gl64_t kF1353 = tmp3_2 * s1_1353_2;
    gl64_t kG1353 = kD1353 - kE1353;
    tmp3_0 = (kC1353 + kG1353) - kF1353;
    tmp3_1 = ((((kA1353 + kC1353) - kE1353) - kE1353) - kD1353);
    tmp3_2 = kB1353 - kG1353;
    // Op 1354: dim3x1 add
    gl64_t s1_1354 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1354; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1355: dim3x3 mul
    gl64_t s1_1355_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1355_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1355_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1355 = (tmp3_0 + tmp3_1) * (s1_1355_0 + s1_1355_1);
    gl64_t kB1355 = (tmp3_0 + tmp3_2) * (s1_1355_0 + s1_1355_2);
    gl64_t kC1355 = (tmp3_1 + tmp3_2) * (s1_1355_1 + s1_1355_2);
    gl64_t kD1355 = tmp3_0 * s1_1355_0;
    gl64_t kE1355 = tmp3_1 * s1_1355_1;
    gl64_t kF1355 = tmp3_2 * s1_1355_2;
    gl64_t kG1355 = kD1355 - kE1355;
    tmp3_0 = (kC1355 + kG1355) - kF1355;
    tmp3_1 = ((((kA1355 + kC1355) - kE1355) - kE1355) - kD1355);
    tmp3_2 = kB1355 - kG1355;
    // Op 1356: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1357: dim3x3 mul
    gl64_t s1_1357_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1357_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1357_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1357 = (tmp3_0 + tmp3_1) * (s1_1357_0 + s1_1357_1);
    gl64_t kB1357 = (tmp3_0 + tmp3_2) * (s1_1357_0 + s1_1357_2);
    gl64_t kC1357 = (tmp3_1 + tmp3_2) * (s1_1357_1 + s1_1357_2);
    gl64_t kD1357 = tmp3_0 * s1_1357_0;
    gl64_t kE1357 = tmp3_1 * s1_1357_1;
    gl64_t kF1357 = tmp3_2 * s1_1357_2;
    gl64_t kG1357 = kD1357 - kE1357;
    tmp3_0 = (kC1357 + kG1357) - kF1357;
    tmp3_1 = ((((kA1357 + kC1357) - kE1357) - kE1357) - kD1357);
    tmp3_2 = kB1357 - kG1357;
    // Op 1358: dim3x1 add
    gl64_t s1_1358 = *(gl64_t*)&expressions_params[9][35];
    tmp3_0 = tmp3_0 + s1_1358; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1359: dim3x3 mul
    gl64_t s1_1359_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1359_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1359_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1359 = (tmp3_0 + tmp3_1) * (s1_1359_0 + s1_1359_1);
    gl64_t kB1359 = (tmp3_0 + tmp3_2) * (s1_1359_0 + s1_1359_2);
    gl64_t kC1359 = (tmp3_1 + tmp3_2) * (s1_1359_1 + s1_1359_2);
    gl64_t kD1359 = tmp3_0 * s1_1359_0;
    gl64_t kE1359 = tmp3_1 * s1_1359_1;
    gl64_t kF1359 = tmp3_2 * s1_1359_2;
    gl64_t kG1359 = kD1359 - kE1359;
    tmp3_0 = (kC1359 + kG1359) - kF1359;
    tmp3_1 = ((((kA1359 + kC1359) - kE1359) - kE1359) - kD1359);
    tmp3_2 = kB1359 - kG1359;
    // Op 1360: dim3x1 add
    gl64_t s1_1360 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1360; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1361: dim3x3 mul
    gl64_t s1_1361_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1361_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1361_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1361 = (tmp3_0 + tmp3_1) * (s1_1361_0 + s1_1361_1);
    gl64_t kB1361 = (tmp3_0 + tmp3_2) * (s1_1361_0 + s1_1361_2);
    gl64_t kC1361 = (tmp3_1 + tmp3_2) * (s1_1361_1 + s1_1361_2);
    gl64_t kD1361 = tmp3_0 * s1_1361_0;
    gl64_t kE1361 = tmp3_1 * s1_1361_1;
    gl64_t kF1361 = tmp3_2 * s1_1361_2;
    gl64_t kG1361 = kD1361 - kE1361;
    tmp3_0 = (kC1361 + kG1361) - kF1361;
    tmp3_1 = ((((kA1361 + kC1361) - kE1361) - kE1361) - kD1361);
    tmp3_2 = kB1361 - kG1361;
    // Op 1362: dim3x1 add
    gl64_t s1_1362 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1362; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1363: dim3x3 add
    gl64_t s1_1363_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1363_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1363_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1363_0; tmp3_1 = tmp3_1 + s1_1363_1; tmp3_2 = tmp3_2 + s1_1363_2;
    // Op 1364: dim3x3 mul
    gl64_t s1_1364_0 = *(gl64_t*)&expressions_params[10][275];
    gl64_t s1_1364_1 = *(gl64_t*)&expressions_params[10][275+1];
    gl64_t s1_1364_2 = *(gl64_t*)&expressions_params[10][275+2];
    gl64_t kA1364 = (tmp3_0 + tmp3_1) * (s1_1364_0 + s1_1364_1);
    gl64_t kB1364 = (tmp3_0 + tmp3_2) * (s1_1364_0 + s1_1364_2);
    gl64_t kC1364 = (tmp3_1 + tmp3_2) * (s1_1364_1 + s1_1364_2);
    gl64_t kD1364 = tmp3_0 * s1_1364_0;
    gl64_t kE1364 = tmp3_1 * s1_1364_1;
    gl64_t kF1364 = tmp3_2 * s1_1364_2;
    gl64_t kG1364 = kD1364 - kE1364;
    tmp3_0 = (kC1364 + kG1364) - kF1364;
    tmp3_1 = ((((kA1364 + kC1364) - kE1364) - kE1364) - kD1364);
    tmp3_2 = kB1364 - kG1364;
    // Op 1365: dim1x1 sub
    gl64_t s0_1365 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1365 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1365 - s1_1365;
    // Op 1366: dim1x1 sub_swap
    gl64_t s1_1366 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1366 - tmp1_0;
    // Op 1367: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1368: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1369: dim3x3 mul
    gl64_t s1_1369_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1369_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1369_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1369 = (tmp3_0 + tmp3_1) * (s1_1369_0 + s1_1369_1);
    gl64_t kB1369 = (tmp3_0 + tmp3_2) * (s1_1369_0 + s1_1369_2);
    gl64_t kC1369 = (tmp3_1 + tmp3_2) * (s1_1369_1 + s1_1369_2);
    gl64_t kD1369 = tmp3_0 * s1_1369_0;
    gl64_t kE1369 = tmp3_1 * s1_1369_1;
    gl64_t kF1369 = tmp3_2 * s1_1369_2;
    gl64_t kG1369 = kD1369 - kE1369;
    tmp3_6 = (kC1369 + kG1369) - kF1369;
    tmp3_7 = ((((kA1369 + kC1369) - kE1369) - kE1369) - kD1369);
    tmp3_8 = kB1369 - kG1369;
    // Op 1370: dim1x1 sub
    gl64_t s1_1370 = *(gl64_t*)&expressions_params[10][89];
    tmp1_0 = tmp1_4 - s1_1370;
    // Op 1371: dim1x1 sub
    gl64_t s1_1371 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1371;
    // Op 1372: dim3x1 mul
    gl64_t s0_1372_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1372_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1372_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1372_0 * tmp1_0; tmp3_1 = s0_1372_1 * tmp1_0; tmp3_2 = s0_1372_2 * tmp1_0;
    // Op 1373: dim3x1 add
    gl64_t s1_1373 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1373; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1374: dim3x3 add
    gl64_t s1_1374_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1374_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1374_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1374_0; tmp3_1 = tmp3_1 + s1_1374_1; tmp3_2 = tmp3_2 + s1_1374_2;
    // Op 1375: dim3x3 mul
    gl64_t s1_1375_0 = *(gl64_t*)&expressions_params[10][278];
    gl64_t s1_1375_1 = *(gl64_t*)&expressions_params[10][278+1];
    gl64_t s1_1375_2 = *(gl64_t*)&expressions_params[10][278+2];
    gl64_t kA1375 = (tmp3_0 + tmp3_1) * (s1_1375_0 + s1_1375_1);
    gl64_t kB1375 = (tmp3_0 + tmp3_2) * (s1_1375_0 + s1_1375_2);
    gl64_t kC1375 = (tmp3_1 + tmp3_2) * (s1_1375_1 + s1_1375_2);
    gl64_t kD1375 = tmp3_0 * s1_1375_0;
    gl64_t kE1375 = tmp3_1 * s1_1375_1;
    gl64_t kF1375 = tmp3_2 * s1_1375_2;
    gl64_t kG1375 = kD1375 - kE1375;
    tmp3_0 = (kC1375 + kG1375) - kF1375;
    tmp3_1 = ((((kA1375 + kC1375) - kE1375) - kE1375) - kD1375);
    tmp3_2 = kB1375 - kG1375;
    // Op 1376: dim3x1 add
    gl64_t s1_1376 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1376; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1377: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1378: dim3x3 mul
    gl64_t s1_1378_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1378_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1378_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1378 = (tmp3_0 + tmp3_1) * (s1_1378_0 + s1_1378_1);
    gl64_t kB1378 = (tmp3_0 + tmp3_2) * (s1_1378_0 + s1_1378_2);
    gl64_t kC1378 = (tmp3_1 + tmp3_2) * (s1_1378_1 + s1_1378_2);
    gl64_t kD1378 = tmp3_0 * s1_1378_0;
    gl64_t kE1378 = tmp3_1 * s1_1378_1;
    gl64_t kF1378 = tmp3_2 * s1_1378_2;
    gl64_t kG1378 = kD1378 - kE1378;
    tmp3_6 = (kC1378 + kG1378) - kF1378;
    tmp3_7 = ((((kA1378 + kC1378) - kE1378) - kE1378) - kD1378);
    tmp3_8 = kB1378 - kG1378;
    // Op 1379: dim3x1 mul
    gl64_t s0_1379_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1379_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1379_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1379 = *(gl64_t*)&expressions_params[10][47];
    tmp3_0 = s0_1379_0 * s1_1379; tmp3_1 = s0_1379_1 * s1_1379; tmp3_2 = s0_1379_2 * s1_1379;
    // Op 1380: dim3x1 add
    gl64_t s1_1380 = *(gl64_t*)&expressions_params[10][46];
    tmp3_0 = tmp3_0 + s1_1380; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1381: dim3x3 mul
    gl64_t s1_1381_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1381_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1381_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1381 = (tmp3_0 + tmp3_1) * (s1_1381_0 + s1_1381_1);
    gl64_t kB1381 = (tmp3_0 + tmp3_2) * (s1_1381_0 + s1_1381_2);
    gl64_t kC1381 = (tmp3_1 + tmp3_2) * (s1_1381_1 + s1_1381_2);
    gl64_t kD1381 = tmp3_0 * s1_1381_0;
    gl64_t kE1381 = tmp3_1 * s1_1381_1;
    gl64_t kF1381 = tmp3_2 * s1_1381_2;
    gl64_t kG1381 = kD1381 - kE1381;
    tmp3_0 = (kC1381 + kG1381) - kF1381;
    tmp3_1 = ((((kA1381 + kC1381) - kE1381) - kE1381) - kD1381);
    tmp3_2 = kB1381 - kG1381;
    // Op 1382: dim3x1 add
    gl64_t s1_1382 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1382; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1383: dim3x3 mul
    gl64_t s1_1383_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1383_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1383_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1383 = (tmp3_0 + tmp3_1) * (s1_1383_0 + s1_1383_1);
    gl64_t kB1383 = (tmp3_0 + tmp3_2) * (s1_1383_0 + s1_1383_2);
    gl64_t kC1383 = (tmp3_1 + tmp3_2) * (s1_1383_1 + s1_1383_2);
    gl64_t kD1383 = tmp3_0 * s1_1383_0;
    gl64_t kE1383 = tmp3_1 * s1_1383_1;
    gl64_t kF1383 = tmp3_2 * s1_1383_2;
    gl64_t kG1383 = kD1383 - kE1383;
    tmp3_0 = (kC1383 + kG1383) - kF1383;
    tmp3_1 = ((((kA1383 + kC1383) - kE1383) - kE1383) - kD1383);
    tmp3_2 = kB1383 - kG1383;
    // Op 1384: dim3x1 add
    gl64_t s1_1384 = *(gl64_t*)&expressions_params[10][89];
    tmp3_0 = tmp3_0 + s1_1384; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1385: dim3x3 mul
    gl64_t s1_1385_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1385_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1385_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1385 = (tmp3_0 + tmp3_1) * (s1_1385_0 + s1_1385_1);
    gl64_t kB1385 = (tmp3_0 + tmp3_2) * (s1_1385_0 + s1_1385_2);
    gl64_t kC1385 = (tmp3_1 + tmp3_2) * (s1_1385_1 + s1_1385_2);
    gl64_t kD1385 = tmp3_0 * s1_1385_0;
    gl64_t kE1385 = tmp3_1 * s1_1385_1;
    gl64_t kF1385 = tmp3_2 * s1_1385_2;
    gl64_t kG1385 = kD1385 - kE1385;
    tmp3_0 = (kC1385 + kG1385) - kF1385;
    tmp3_1 = ((((kA1385 + kC1385) - kE1385) - kE1385) - kD1385);
    tmp3_2 = kB1385 - kG1385;
    // Op 1386: dim3x1 add
    gl64_t s1_1386 = *(gl64_t*)&expressions_params[9][36];
    tmp3_0 = tmp3_0 + s1_1386; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1387: dim3x3 mul
    gl64_t s1_1387_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1387_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1387_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1387 = (tmp3_0 + tmp3_1) * (s1_1387_0 + s1_1387_1);
    gl64_t kB1387 = (tmp3_0 + tmp3_2) * (s1_1387_0 + s1_1387_2);
    gl64_t kC1387 = (tmp3_1 + tmp3_2) * (s1_1387_1 + s1_1387_2);
    gl64_t kD1387 = tmp3_0 * s1_1387_0;
    gl64_t kE1387 = tmp3_1 * s1_1387_1;
    gl64_t kF1387 = tmp3_2 * s1_1387_2;
    gl64_t kG1387 = kD1387 - kE1387;
    tmp3_0 = (kC1387 + kG1387) - kF1387;
    tmp3_1 = ((((kA1387 + kC1387) - kE1387) - kE1387) - kD1387);
    tmp3_2 = kB1387 - kG1387;
    // Op 1388: dim3x1 add
    gl64_t s1_1388 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1388; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1389: dim3x3 mul
    gl64_t s1_1389_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1389_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1389_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1389 = (tmp3_0 + tmp3_1) * (s1_1389_0 + s1_1389_1);
    gl64_t kB1389 = (tmp3_0 + tmp3_2) * (s1_1389_0 + s1_1389_2);
    gl64_t kC1389 = (tmp3_1 + tmp3_2) * (s1_1389_1 + s1_1389_2);
    gl64_t kD1389 = tmp3_0 * s1_1389_0;
    gl64_t kE1389 = tmp3_1 * s1_1389_1;
    gl64_t kF1389 = tmp3_2 * s1_1389_2;
    gl64_t kG1389 = kD1389 - kE1389;
    tmp3_0 = (kC1389 + kG1389) - kF1389;
    tmp3_1 = ((((kA1389 + kC1389) - kE1389) - kE1389) - kD1389);
    tmp3_2 = kB1389 - kG1389;
    // Op 1390: dim3x1 add
    gl64_t s1_1390 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1390; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1391: dim3x3 add
    gl64_t s1_1391_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1391_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1391_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1391_0; tmp3_1 = tmp3_1 + s1_1391_1; tmp3_2 = tmp3_2 + s1_1391_2;
    // Op 1392: dim3x3 mul
    gl64_t s1_1392_0 = *(gl64_t*)&expressions_params[10][281];
    gl64_t s1_1392_1 = *(gl64_t*)&expressions_params[10][281+1];
    gl64_t s1_1392_2 = *(gl64_t*)&expressions_params[10][281+2];
    gl64_t kA1392 = (tmp3_0 + tmp3_1) * (s1_1392_0 + s1_1392_1);
    gl64_t kB1392 = (tmp3_0 + tmp3_2) * (s1_1392_0 + s1_1392_2);
    gl64_t kC1392 = (tmp3_1 + tmp3_2) * (s1_1392_1 + s1_1392_2);
    gl64_t kD1392 = tmp3_0 * s1_1392_0;
    gl64_t kE1392 = tmp3_1 * s1_1392_1;
    gl64_t kF1392 = tmp3_2 * s1_1392_2;
    gl64_t kG1392 = kD1392 - kE1392;
    tmp3_0 = (kC1392 + kG1392) - kF1392;
    tmp3_1 = ((((kA1392 + kC1392) - kE1392) - kE1392) - kD1392);
    tmp3_2 = kB1392 - kG1392;
    // Op 1393: dim3x1 sub
    gl64_t s1_1393 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1393; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1394: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1395: dim3x3 mul
    gl64_t s1_1395_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1395_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1395_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1395 = (tmp3_0 + tmp3_1) * (s1_1395_0 + s1_1395_1);
    gl64_t kB1395 = (tmp3_0 + tmp3_2) * (s1_1395_0 + s1_1395_2);
    gl64_t kC1395 = (tmp3_1 + tmp3_2) * (s1_1395_1 + s1_1395_2);
    gl64_t kD1395 = tmp3_0 * s1_1395_0;
    gl64_t kE1395 = tmp3_1 * s1_1395_1;
    gl64_t kF1395 = tmp3_2 * s1_1395_2;
    gl64_t kG1395 = kD1395 - kE1395;
    tmp3_6 = (kC1395 + kG1395) - kF1395;
    tmp3_7 = ((((kA1395 + kC1395) - kE1395) - kE1395) - kD1395);
    tmp3_8 = kB1395 - kG1395;
    // Op 1396: dim3x1 mul
    gl64_t s0_1396_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1396_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1396_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1396 = *(gl64_t*)&expressions_params[10][47];
    tmp3_0 = s0_1396_0 * s1_1396; tmp3_1 = s0_1396_1 * s1_1396; tmp3_2 = s0_1396_2 * s1_1396;
    // Op 1397: dim3x1 add
    gl64_t s1_1397 = *(gl64_t*)&expressions_params[10][46];
    tmp3_0 = tmp3_0 + s1_1397; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1398: dim3x3 mul
    gl64_t s1_1398_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1398_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1398_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1398 = (tmp3_0 + tmp3_1) * (s1_1398_0 + s1_1398_1);
    gl64_t kB1398 = (tmp3_0 + tmp3_2) * (s1_1398_0 + s1_1398_2);
    gl64_t kC1398 = (tmp3_1 + tmp3_2) * (s1_1398_1 + s1_1398_2);
    gl64_t kD1398 = tmp3_0 * s1_1398_0;
    gl64_t kE1398 = tmp3_1 * s1_1398_1;
    gl64_t kF1398 = tmp3_2 * s1_1398_2;
    gl64_t kG1398 = kD1398 - kE1398;
    tmp3_0 = (kC1398 + kG1398) - kF1398;
    tmp3_1 = ((((kA1398 + kC1398) - kE1398) - kE1398) - kD1398);
    tmp3_2 = kB1398 - kG1398;
    // Op 1399: dim3x1 add
    gl64_t s1_1399 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1399; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1400: dim3x3 mul
    gl64_t s1_1400_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1400_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1400_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1400 = (tmp3_0 + tmp3_1) * (s1_1400_0 + s1_1400_1);
    gl64_t kB1400 = (tmp3_0 + tmp3_2) * (s1_1400_0 + s1_1400_2);
    gl64_t kC1400 = (tmp3_1 + tmp3_2) * (s1_1400_1 + s1_1400_2);
    gl64_t kD1400 = tmp3_0 * s1_1400_0;
    gl64_t kE1400 = tmp3_1 * s1_1400_1;
    gl64_t kF1400 = tmp3_2 * s1_1400_2;
    gl64_t kG1400 = kD1400 - kE1400;
    tmp3_0 = (kC1400 + kG1400) - kF1400;
    tmp3_1 = ((((kA1400 + kC1400) - kE1400) - kE1400) - kD1400);
    tmp3_2 = kB1400 - kG1400;
    // Op 1401: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1402: dim3x3 mul
    gl64_t s1_1402_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1402_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1402_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1402 = (tmp3_0 + tmp3_1) * (s1_1402_0 + s1_1402_1);
    gl64_t kB1402 = (tmp3_0 + tmp3_2) * (s1_1402_0 + s1_1402_2);
    gl64_t kC1402 = (tmp3_1 + tmp3_2) * (s1_1402_1 + s1_1402_2);
    gl64_t kD1402 = tmp3_0 * s1_1402_0;
    gl64_t kE1402 = tmp3_1 * s1_1402_1;
    gl64_t kF1402 = tmp3_2 * s1_1402_2;
    gl64_t kG1402 = kD1402 - kE1402;
    tmp3_0 = (kC1402 + kG1402) - kF1402;
    tmp3_1 = ((((kA1402 + kC1402) - kE1402) - kE1402) - kD1402);
    tmp3_2 = kB1402 - kG1402;
    // Op 1403: dim3x1 add
    gl64_t s1_1403 = *(gl64_t*)&expressions_params[9][36];
    tmp3_0 = tmp3_0 + s1_1403; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1404: dim3x3 mul
    gl64_t s1_1404_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1404_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1404_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1404 = (tmp3_0 + tmp3_1) * (s1_1404_0 + s1_1404_1);
    gl64_t kB1404 = (tmp3_0 + tmp3_2) * (s1_1404_0 + s1_1404_2);
    gl64_t kC1404 = (tmp3_1 + tmp3_2) * (s1_1404_1 + s1_1404_2);
    gl64_t kD1404 = tmp3_0 * s1_1404_0;
    gl64_t kE1404 = tmp3_1 * s1_1404_1;
    gl64_t kF1404 = tmp3_2 * s1_1404_2;
    gl64_t kG1404 = kD1404 - kE1404;
    tmp3_0 = (kC1404 + kG1404) - kF1404;
    tmp3_1 = ((((kA1404 + kC1404) - kE1404) - kE1404) - kD1404);
    tmp3_2 = kB1404 - kG1404;
    // Op 1405: dim3x1 add
    gl64_t s1_1405 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1405; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1406: dim3x3 mul
    gl64_t s1_1406_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1406_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1406_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1406 = (tmp3_0 + tmp3_1) * (s1_1406_0 + s1_1406_1);
    gl64_t kB1406 = (tmp3_0 + tmp3_2) * (s1_1406_0 + s1_1406_2);
    gl64_t kC1406 = (tmp3_1 + tmp3_2) * (s1_1406_1 + s1_1406_2);
    gl64_t kD1406 = tmp3_0 * s1_1406_0;
    gl64_t kE1406 = tmp3_1 * s1_1406_1;
    gl64_t kF1406 = tmp3_2 * s1_1406_2;
    gl64_t kG1406 = kD1406 - kE1406;
    tmp3_0 = (kC1406 + kG1406) - kF1406;
    tmp3_1 = ((((kA1406 + kC1406) - kE1406) - kE1406) - kD1406);
    tmp3_2 = kB1406 - kG1406;
    // Op 1407: dim3x1 add
    gl64_t s1_1407 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1407; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1408: dim3x3 add
    gl64_t s1_1408_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1408_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1408_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1408_0; tmp3_1 = tmp3_1 + s1_1408_1; tmp3_2 = tmp3_2 + s1_1408_2;
    // Op 1409: dim3x3 mul
    gl64_t s1_1409_0 = *(gl64_t*)&expressions_params[10][284];
    gl64_t s1_1409_1 = *(gl64_t*)&expressions_params[10][284+1];
    gl64_t s1_1409_2 = *(gl64_t*)&expressions_params[10][284+2];
    gl64_t kA1409 = (tmp3_0 + tmp3_1) * (s1_1409_0 + s1_1409_1);
    gl64_t kB1409 = (tmp3_0 + tmp3_2) * (s1_1409_0 + s1_1409_2);
    gl64_t kC1409 = (tmp3_1 + tmp3_2) * (s1_1409_1 + s1_1409_2);
    gl64_t kD1409 = tmp3_0 * s1_1409_0;
    gl64_t kE1409 = tmp3_1 * s1_1409_1;
    gl64_t kF1409 = tmp3_2 * s1_1409_2;
    gl64_t kG1409 = kD1409 - kE1409;
    tmp3_0 = (kC1409 + kG1409) - kF1409;
    tmp3_1 = ((((kA1409 + kC1409) - kE1409) - kE1409) - kD1409);
    tmp3_2 = kB1409 - kG1409;
    // Op 1410: dim1x1 sub
    gl64_t s0_1410 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1410 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1410 - s1_1410;
    // Op 1411: dim1x1 sub_swap
    gl64_t s1_1411 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1411 - tmp1_0;
    // Op 1412: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1413: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1414: dim3x3 mul
    gl64_t s1_1414_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1414_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1414_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1414 = (tmp3_0 + tmp3_1) * (s1_1414_0 + s1_1414_1);
    gl64_t kB1414 = (tmp3_0 + tmp3_2) * (s1_1414_0 + s1_1414_2);
    gl64_t kC1414 = (tmp3_1 + tmp3_2) * (s1_1414_1 + s1_1414_2);
    gl64_t kD1414 = tmp3_0 * s1_1414_0;
    gl64_t kE1414 = tmp3_1 * s1_1414_1;
    gl64_t kF1414 = tmp3_2 * s1_1414_2;
    gl64_t kG1414 = kD1414 - kE1414;
    tmp3_6 = (kC1414 + kG1414) - kF1414;
    tmp3_7 = ((((kA1414 + kC1414) - kE1414) - kE1414) - kD1414);
    tmp3_8 = kB1414 - kG1414;
    // Op 1415: dim1x1 sub
    gl64_t s1_1415 = *(gl64_t*)&expressions_params[10][90];
    tmp1_0 = tmp1_4 - s1_1415;
    // Op 1416: dim1x1 sub
    gl64_t s1_1416 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1416;
    // Op 1417: dim3x1 mul
    gl64_t s0_1417_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1417_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1417_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1417_0 * tmp1_0; tmp3_1 = s0_1417_1 * tmp1_0; tmp3_2 = s0_1417_2 * tmp1_0;
    // Op 1418: dim3x1 add
    gl64_t s1_1418 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1418; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1419: dim3x3 add
    gl64_t s1_1419_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1419_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1419_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1419_0; tmp3_1 = tmp3_1 + s1_1419_1; tmp3_2 = tmp3_2 + s1_1419_2;
    // Op 1420: dim3x3 mul
    gl64_t s1_1420_0 = *(gl64_t*)&expressions_params[10][287];
    gl64_t s1_1420_1 = *(gl64_t*)&expressions_params[10][287+1];
    gl64_t s1_1420_2 = *(gl64_t*)&expressions_params[10][287+2];
    gl64_t kA1420 = (tmp3_0 + tmp3_1) * (s1_1420_0 + s1_1420_1);
    gl64_t kB1420 = (tmp3_0 + tmp3_2) * (s1_1420_0 + s1_1420_2);
    gl64_t kC1420 = (tmp3_1 + tmp3_2) * (s1_1420_1 + s1_1420_2);
    gl64_t kD1420 = tmp3_0 * s1_1420_0;
    gl64_t kE1420 = tmp3_1 * s1_1420_1;
    gl64_t kF1420 = tmp3_2 * s1_1420_2;
    gl64_t kG1420 = kD1420 - kE1420;
    tmp3_0 = (kC1420 + kG1420) - kF1420;
    tmp3_1 = ((((kA1420 + kC1420) - kE1420) - kE1420) - kD1420);
    tmp3_2 = kB1420 - kG1420;
    // Op 1421: dim3x1 add
    gl64_t s1_1421 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1421; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1422: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1423: dim3x3 mul
    gl64_t s1_1423_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1423_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1423_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1423 = (tmp3_0 + tmp3_1) * (s1_1423_0 + s1_1423_1);
    gl64_t kB1423 = (tmp3_0 + tmp3_2) * (s1_1423_0 + s1_1423_2);
    gl64_t kC1423 = (tmp3_1 + tmp3_2) * (s1_1423_1 + s1_1423_2);
    gl64_t kD1423 = tmp3_0 * s1_1423_0;
    gl64_t kE1423 = tmp3_1 * s1_1423_1;
    gl64_t kF1423 = tmp3_2 * s1_1423_2;
    gl64_t kG1423 = kD1423 - kE1423;
    tmp3_6 = (kC1423 + kG1423) - kF1423;
    tmp3_7 = ((((kA1423 + kC1423) - kE1423) - kE1423) - kD1423);
    tmp3_8 = kB1423 - kG1423;
    // Op 1424: dim3x1 mul
    gl64_t s0_1424_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1424_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1424_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1424 = *(gl64_t*)&expressions_params[10][49];
    tmp3_0 = s0_1424_0 * s1_1424; tmp3_1 = s0_1424_1 * s1_1424; tmp3_2 = s0_1424_2 * s1_1424;
    // Op 1425: dim3x1 add
    gl64_t s1_1425 = *(gl64_t*)&expressions_params[10][48];
    tmp3_0 = tmp3_0 + s1_1425; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1426: dim3x3 mul
    gl64_t s1_1426_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1426_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1426_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1426 = (tmp3_0 + tmp3_1) * (s1_1426_0 + s1_1426_1);
    gl64_t kB1426 = (tmp3_0 + tmp3_2) * (s1_1426_0 + s1_1426_2);
    gl64_t kC1426 = (tmp3_1 + tmp3_2) * (s1_1426_1 + s1_1426_2);
    gl64_t kD1426 = tmp3_0 * s1_1426_0;
    gl64_t kE1426 = tmp3_1 * s1_1426_1;
    gl64_t kF1426 = tmp3_2 * s1_1426_2;
    gl64_t kG1426 = kD1426 - kE1426;
    tmp3_0 = (kC1426 + kG1426) - kF1426;
    tmp3_1 = ((((kA1426 + kC1426) - kE1426) - kE1426) - kD1426);
    tmp3_2 = kB1426 - kG1426;
    // Op 1427: dim3x1 add
    gl64_t s1_1427 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1427; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1428: dim3x3 mul
    gl64_t s1_1428_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1428_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1428_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1428 = (tmp3_0 + tmp3_1) * (s1_1428_0 + s1_1428_1);
    gl64_t kB1428 = (tmp3_0 + tmp3_2) * (s1_1428_0 + s1_1428_2);
    gl64_t kC1428 = (tmp3_1 + tmp3_2) * (s1_1428_1 + s1_1428_2);
    gl64_t kD1428 = tmp3_0 * s1_1428_0;
    gl64_t kE1428 = tmp3_1 * s1_1428_1;
    gl64_t kF1428 = tmp3_2 * s1_1428_2;
    gl64_t kG1428 = kD1428 - kE1428;
    tmp3_0 = (kC1428 + kG1428) - kF1428;
    tmp3_1 = ((((kA1428 + kC1428) - kE1428) - kE1428) - kD1428);
    tmp3_2 = kB1428 - kG1428;
    // Op 1429: dim3x1 add
    gl64_t s1_1429 = *(gl64_t*)&expressions_params[10][90];
    tmp3_0 = tmp3_0 + s1_1429; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1430: dim3x3 mul
    gl64_t s1_1430_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1430_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1430_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1430 = (tmp3_0 + tmp3_1) * (s1_1430_0 + s1_1430_1);
    gl64_t kB1430 = (tmp3_0 + tmp3_2) * (s1_1430_0 + s1_1430_2);
    gl64_t kC1430 = (tmp3_1 + tmp3_2) * (s1_1430_1 + s1_1430_2);
    gl64_t kD1430 = tmp3_0 * s1_1430_0;
    gl64_t kE1430 = tmp3_1 * s1_1430_1;
    gl64_t kF1430 = tmp3_2 * s1_1430_2;
    gl64_t kG1430 = kD1430 - kE1430;
    tmp3_0 = (kC1430 + kG1430) - kF1430;
    tmp3_1 = ((((kA1430 + kC1430) - kE1430) - kE1430) - kD1430);
    tmp3_2 = kB1430 - kG1430;
    // Op 1431: dim3x1 add
    gl64_t s1_1431 = *(gl64_t*)&expressions_params[9][37];
    tmp3_0 = tmp3_0 + s1_1431; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1432: dim3x3 mul
    gl64_t s1_1432_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1432_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1432_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1432 = (tmp3_0 + tmp3_1) * (s1_1432_0 + s1_1432_1);
    gl64_t kB1432 = (tmp3_0 + tmp3_2) * (s1_1432_0 + s1_1432_2);
    gl64_t kC1432 = (tmp3_1 + tmp3_2) * (s1_1432_1 + s1_1432_2);
    gl64_t kD1432 = tmp3_0 * s1_1432_0;
    gl64_t kE1432 = tmp3_1 * s1_1432_1;
    gl64_t kF1432 = tmp3_2 * s1_1432_2;
    gl64_t kG1432 = kD1432 - kE1432;
    tmp3_0 = (kC1432 + kG1432) - kF1432;
    tmp3_1 = ((((kA1432 + kC1432) - kE1432) - kE1432) - kD1432);
    tmp3_2 = kB1432 - kG1432;
    // Op 1433: dim3x1 add
    gl64_t s1_1433 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1433; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1434: dim3x3 mul
    gl64_t s1_1434_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1434_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1434_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1434 = (tmp3_0 + tmp3_1) * (s1_1434_0 + s1_1434_1);
    gl64_t kB1434 = (tmp3_0 + tmp3_2) * (s1_1434_0 + s1_1434_2);
    gl64_t kC1434 = (tmp3_1 + tmp3_2) * (s1_1434_1 + s1_1434_2);
    gl64_t kD1434 = tmp3_0 * s1_1434_0;
    gl64_t kE1434 = tmp3_1 * s1_1434_1;
    gl64_t kF1434 = tmp3_2 * s1_1434_2;
    gl64_t kG1434 = kD1434 - kE1434;
    tmp3_0 = (kC1434 + kG1434) - kF1434;
    tmp3_1 = ((((kA1434 + kC1434) - kE1434) - kE1434) - kD1434);
    tmp3_2 = kB1434 - kG1434;
    // Op 1435: dim3x1 add
    gl64_t s1_1435 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1435; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1436: dim3x3 add
    gl64_t s1_1436_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1436_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1436_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1436_0; tmp3_1 = tmp3_1 + s1_1436_1; tmp3_2 = tmp3_2 + s1_1436_2;
    // Op 1437: dim3x3 mul
    gl64_t s1_1437_0 = *(gl64_t*)&expressions_params[10][290];
    gl64_t s1_1437_1 = *(gl64_t*)&expressions_params[10][290+1];
    gl64_t s1_1437_2 = *(gl64_t*)&expressions_params[10][290+2];
    gl64_t kA1437 = (tmp3_0 + tmp3_1) * (s1_1437_0 + s1_1437_1);
    gl64_t kB1437 = (tmp3_0 + tmp3_2) * (s1_1437_0 + s1_1437_2);
    gl64_t kC1437 = (tmp3_1 + tmp3_2) * (s1_1437_1 + s1_1437_2);
    gl64_t kD1437 = tmp3_0 * s1_1437_0;
    gl64_t kE1437 = tmp3_1 * s1_1437_1;
    gl64_t kF1437 = tmp3_2 * s1_1437_2;
    gl64_t kG1437 = kD1437 - kE1437;
    tmp3_0 = (kC1437 + kG1437) - kF1437;
    tmp3_1 = ((((kA1437 + kC1437) - kE1437) - kE1437) - kD1437);
    tmp3_2 = kB1437 - kG1437;
    // Op 1438: dim3x1 sub
    gl64_t s1_1438 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1438; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1439: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1440: dim3x3 mul
    gl64_t s1_1440_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1440_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1440_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1440 = (tmp3_0 + tmp3_1) * (s1_1440_0 + s1_1440_1);
    gl64_t kB1440 = (tmp3_0 + tmp3_2) * (s1_1440_0 + s1_1440_2);
    gl64_t kC1440 = (tmp3_1 + tmp3_2) * (s1_1440_1 + s1_1440_2);
    gl64_t kD1440 = tmp3_0 * s1_1440_0;
    gl64_t kE1440 = tmp3_1 * s1_1440_1;
    gl64_t kF1440 = tmp3_2 * s1_1440_2;
    gl64_t kG1440 = kD1440 - kE1440;
    tmp3_6 = (kC1440 + kG1440) - kF1440;
    tmp3_7 = ((((kA1440 + kC1440) - kE1440) - kE1440) - kD1440);
    tmp3_8 = kB1440 - kG1440;
    // Op 1441: dim3x1 mul
    gl64_t s0_1441_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1441_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1441_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1441 = *(gl64_t*)&expressions_params[10][49];
    tmp3_0 = s0_1441_0 * s1_1441; tmp3_1 = s0_1441_1 * s1_1441; tmp3_2 = s0_1441_2 * s1_1441;
    // Op 1442: dim3x1 add
    gl64_t s1_1442 = *(gl64_t*)&expressions_params[10][48];
    tmp3_0 = tmp3_0 + s1_1442; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1443: dim3x3 mul
    gl64_t s1_1443_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1443_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1443_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1443 = (tmp3_0 + tmp3_1) * (s1_1443_0 + s1_1443_1);
    gl64_t kB1443 = (tmp3_0 + tmp3_2) * (s1_1443_0 + s1_1443_2);
    gl64_t kC1443 = (tmp3_1 + tmp3_2) * (s1_1443_1 + s1_1443_2);
    gl64_t kD1443 = tmp3_0 * s1_1443_0;
    gl64_t kE1443 = tmp3_1 * s1_1443_1;
    gl64_t kF1443 = tmp3_2 * s1_1443_2;
    gl64_t kG1443 = kD1443 - kE1443;
    tmp3_0 = (kC1443 + kG1443) - kF1443;
    tmp3_1 = ((((kA1443 + kC1443) - kE1443) - kE1443) - kD1443);
    tmp3_2 = kB1443 - kG1443;
    // Op 1444: dim3x1 add
    gl64_t s1_1444 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1444; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1445: dim3x3 mul
    gl64_t s1_1445_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1445_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1445_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1445 = (tmp3_0 + tmp3_1) * (s1_1445_0 + s1_1445_1);
    gl64_t kB1445 = (tmp3_0 + tmp3_2) * (s1_1445_0 + s1_1445_2);
    gl64_t kC1445 = (tmp3_1 + tmp3_2) * (s1_1445_1 + s1_1445_2);
    gl64_t kD1445 = tmp3_0 * s1_1445_0;
    gl64_t kE1445 = tmp3_1 * s1_1445_1;
    gl64_t kF1445 = tmp3_2 * s1_1445_2;
    gl64_t kG1445 = kD1445 - kE1445;
    tmp3_0 = (kC1445 + kG1445) - kF1445;
    tmp3_1 = ((((kA1445 + kC1445) - kE1445) - kE1445) - kD1445);
    tmp3_2 = kB1445 - kG1445;
    // Op 1446: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1447: dim3x3 mul
    gl64_t s1_1447_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1447_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1447_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1447 = (tmp3_0 + tmp3_1) * (s1_1447_0 + s1_1447_1);
    gl64_t kB1447 = (tmp3_0 + tmp3_2) * (s1_1447_0 + s1_1447_2);
    gl64_t kC1447 = (tmp3_1 + tmp3_2) * (s1_1447_1 + s1_1447_2);
    gl64_t kD1447 = tmp3_0 * s1_1447_0;
    gl64_t kE1447 = tmp3_1 * s1_1447_1;
    gl64_t kF1447 = tmp3_2 * s1_1447_2;
    gl64_t kG1447 = kD1447 - kE1447;
    tmp3_0 = (kC1447 + kG1447) - kF1447;
    tmp3_1 = ((((kA1447 + kC1447) - kE1447) - kE1447) - kD1447);
    tmp3_2 = kB1447 - kG1447;
    // Op 1448: dim3x1 add
    gl64_t s1_1448 = *(gl64_t*)&expressions_params[9][37];
    tmp3_0 = tmp3_0 + s1_1448; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1449: dim3x3 mul
    gl64_t s1_1449_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1449_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1449_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1449 = (tmp3_0 + tmp3_1) * (s1_1449_0 + s1_1449_1);
    gl64_t kB1449 = (tmp3_0 + tmp3_2) * (s1_1449_0 + s1_1449_2);
    gl64_t kC1449 = (tmp3_1 + tmp3_2) * (s1_1449_1 + s1_1449_2);
    gl64_t kD1449 = tmp3_0 * s1_1449_0;
    gl64_t kE1449 = tmp3_1 * s1_1449_1;
    gl64_t kF1449 = tmp3_2 * s1_1449_2;
    gl64_t kG1449 = kD1449 - kE1449;
    tmp3_0 = (kC1449 + kG1449) - kF1449;
    tmp3_1 = ((((kA1449 + kC1449) - kE1449) - kE1449) - kD1449);
    tmp3_2 = kB1449 - kG1449;
    // Op 1450: dim3x1 add
    gl64_t s1_1450 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1450; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1451: dim3x3 mul
    gl64_t s1_1451_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1451_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1451_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1451 = (tmp3_0 + tmp3_1) * (s1_1451_0 + s1_1451_1);
    gl64_t kB1451 = (tmp3_0 + tmp3_2) * (s1_1451_0 + s1_1451_2);
    gl64_t kC1451 = (tmp3_1 + tmp3_2) * (s1_1451_1 + s1_1451_2);
    gl64_t kD1451 = tmp3_0 * s1_1451_0;
    gl64_t kE1451 = tmp3_1 * s1_1451_1;
    gl64_t kF1451 = tmp3_2 * s1_1451_2;
    gl64_t kG1451 = kD1451 - kE1451;
    tmp3_0 = (kC1451 + kG1451) - kF1451;
    tmp3_1 = ((((kA1451 + kC1451) - kE1451) - kE1451) - kD1451);
    tmp3_2 = kB1451 - kG1451;
    // Op 1452: dim3x1 add
    gl64_t s1_1452 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1452; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1453: dim3x3 add
    gl64_t s1_1453_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1453_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1453_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1453_0; tmp3_1 = tmp3_1 + s1_1453_1; tmp3_2 = tmp3_2 + s1_1453_2;
    // Op 1454: dim3x3 mul
    gl64_t s1_1454_0 = *(gl64_t*)&expressions_params[10][293];
    gl64_t s1_1454_1 = *(gl64_t*)&expressions_params[10][293+1];
    gl64_t s1_1454_2 = *(gl64_t*)&expressions_params[10][293+2];
    gl64_t kA1454 = (tmp3_0 + tmp3_1) * (s1_1454_0 + s1_1454_1);
    gl64_t kB1454 = (tmp3_0 + tmp3_2) * (s1_1454_0 + s1_1454_2);
    gl64_t kC1454 = (tmp3_1 + tmp3_2) * (s1_1454_1 + s1_1454_2);
    gl64_t kD1454 = tmp3_0 * s1_1454_0;
    gl64_t kE1454 = tmp3_1 * s1_1454_1;
    gl64_t kF1454 = tmp3_2 * s1_1454_2;
    gl64_t kG1454 = kD1454 - kE1454;
    tmp3_0 = (kC1454 + kG1454) - kF1454;
    tmp3_1 = ((((kA1454 + kC1454) - kE1454) - kE1454) - kD1454);
    tmp3_2 = kB1454 - kG1454;
    // Op 1455: dim1x1 sub
    gl64_t s0_1455 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1455 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1455 - s1_1455;
    // Op 1456: dim1x1 sub_swap
    gl64_t s1_1456 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1456 - tmp1_0;
    // Op 1457: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1458: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1459: dim3x3 mul
    gl64_t s1_1459_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1459_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1459_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1459 = (tmp3_0 + tmp3_1) * (s1_1459_0 + s1_1459_1);
    gl64_t kB1459 = (tmp3_0 + tmp3_2) * (s1_1459_0 + s1_1459_2);
    gl64_t kC1459 = (tmp3_1 + tmp3_2) * (s1_1459_1 + s1_1459_2);
    gl64_t kD1459 = tmp3_0 * s1_1459_0;
    gl64_t kE1459 = tmp3_1 * s1_1459_1;
    gl64_t kF1459 = tmp3_2 * s1_1459_2;
    gl64_t kG1459 = kD1459 - kE1459;
    tmp3_6 = (kC1459 + kG1459) - kF1459;
    tmp3_7 = ((((kA1459 + kC1459) - kE1459) - kE1459) - kD1459);
    tmp3_8 = kB1459 - kG1459;
    // Op 1460: dim1x1 sub
    gl64_t s1_1460 = *(gl64_t*)&expressions_params[10][91];
    tmp1_0 = tmp1_4 - s1_1460;
    // Op 1461: dim1x1 sub
    gl64_t s1_1461 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1461;
    // Op 1462: dim3x1 mul
    gl64_t s0_1462_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1462_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1462_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1462_0 * tmp1_0; tmp3_1 = s0_1462_1 * tmp1_0; tmp3_2 = s0_1462_2 * tmp1_0;
    // Op 1463: dim3x1 add
    gl64_t s1_1463 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1463; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1464: dim3x3 add
    gl64_t s1_1464_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1464_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1464_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1464_0; tmp3_1 = tmp3_1 + s1_1464_1; tmp3_2 = tmp3_2 + s1_1464_2;
    // Op 1465: dim3x3 mul
    gl64_t s1_1465_0 = *(gl64_t*)&expressions_params[10][296];
    gl64_t s1_1465_1 = *(gl64_t*)&expressions_params[10][296+1];
    gl64_t s1_1465_2 = *(gl64_t*)&expressions_params[10][296+2];
    gl64_t kA1465 = (tmp3_0 + tmp3_1) * (s1_1465_0 + s1_1465_1);
    gl64_t kB1465 = (tmp3_0 + tmp3_2) * (s1_1465_0 + s1_1465_2);
    gl64_t kC1465 = (tmp3_1 + tmp3_2) * (s1_1465_1 + s1_1465_2);
    gl64_t kD1465 = tmp3_0 * s1_1465_0;
    gl64_t kE1465 = tmp3_1 * s1_1465_1;
    gl64_t kF1465 = tmp3_2 * s1_1465_2;
    gl64_t kG1465 = kD1465 - kE1465;
    tmp3_0 = (kC1465 + kG1465) - kF1465;
    tmp3_1 = ((((kA1465 + kC1465) - kE1465) - kE1465) - kD1465);
    tmp3_2 = kB1465 - kG1465;
    // Op 1466: dim3x1 add
    gl64_t s1_1466 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1466; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1467: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1468: dim3x3 mul
    gl64_t s1_1468_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1468_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1468_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1468 = (tmp3_0 + tmp3_1) * (s1_1468_0 + s1_1468_1);
    gl64_t kB1468 = (tmp3_0 + tmp3_2) * (s1_1468_0 + s1_1468_2);
    gl64_t kC1468 = (tmp3_1 + tmp3_2) * (s1_1468_1 + s1_1468_2);
    gl64_t kD1468 = tmp3_0 * s1_1468_0;
    gl64_t kE1468 = tmp3_1 * s1_1468_1;
    gl64_t kF1468 = tmp3_2 * s1_1468_2;
    gl64_t kG1468 = kD1468 - kE1468;
    tmp3_6 = (kC1468 + kG1468) - kF1468;
    tmp3_7 = ((((kA1468 + kC1468) - kE1468) - kE1468) - kD1468);
    tmp3_8 = kB1468 - kG1468;
    // Op 1469: dim3x1 mul
    gl64_t s0_1469_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1469_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1469_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1469 = *(gl64_t*)&expressions_params[10][51];
    tmp3_0 = s0_1469_0 * s1_1469; tmp3_1 = s0_1469_1 * s1_1469; tmp3_2 = s0_1469_2 * s1_1469;
    // Op 1470: dim3x1 add
    gl64_t s1_1470 = *(gl64_t*)&expressions_params[10][50];
    tmp3_0 = tmp3_0 + s1_1470; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1471: dim3x3 mul
    gl64_t s1_1471_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1471_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1471_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1471 = (tmp3_0 + tmp3_1) * (s1_1471_0 + s1_1471_1);
    gl64_t kB1471 = (tmp3_0 + tmp3_2) * (s1_1471_0 + s1_1471_2);
    gl64_t kC1471 = (tmp3_1 + tmp3_2) * (s1_1471_1 + s1_1471_2);
    gl64_t kD1471 = tmp3_0 * s1_1471_0;
    gl64_t kE1471 = tmp3_1 * s1_1471_1;
    gl64_t kF1471 = tmp3_2 * s1_1471_2;
    gl64_t kG1471 = kD1471 - kE1471;
    tmp3_0 = (kC1471 + kG1471) - kF1471;
    tmp3_1 = ((((kA1471 + kC1471) - kE1471) - kE1471) - kD1471);
    tmp3_2 = kB1471 - kG1471;
    // Op 1472: dim3x1 add
    gl64_t s1_1472 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1472; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1473: dim3x3 mul
    gl64_t s1_1473_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1473_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1473_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1473 = (tmp3_0 + tmp3_1) * (s1_1473_0 + s1_1473_1);
    gl64_t kB1473 = (tmp3_0 + tmp3_2) * (s1_1473_0 + s1_1473_2);
    gl64_t kC1473 = (tmp3_1 + tmp3_2) * (s1_1473_1 + s1_1473_2);
    gl64_t kD1473 = tmp3_0 * s1_1473_0;
    gl64_t kE1473 = tmp3_1 * s1_1473_1;
    gl64_t kF1473 = tmp3_2 * s1_1473_2;
    gl64_t kG1473 = kD1473 - kE1473;
    tmp3_0 = (kC1473 + kG1473) - kF1473;
    tmp3_1 = ((((kA1473 + kC1473) - kE1473) - kE1473) - kD1473);
    tmp3_2 = kB1473 - kG1473;
    // Op 1474: dim3x1 add
    gl64_t s1_1474 = *(gl64_t*)&expressions_params[10][91];
    tmp3_0 = tmp3_0 + s1_1474; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1475: dim3x3 mul
    gl64_t s1_1475_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1475_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1475_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1475 = (tmp3_0 + tmp3_1) * (s1_1475_0 + s1_1475_1);
    gl64_t kB1475 = (tmp3_0 + tmp3_2) * (s1_1475_0 + s1_1475_2);
    gl64_t kC1475 = (tmp3_1 + tmp3_2) * (s1_1475_1 + s1_1475_2);
    gl64_t kD1475 = tmp3_0 * s1_1475_0;
    gl64_t kE1475 = tmp3_1 * s1_1475_1;
    gl64_t kF1475 = tmp3_2 * s1_1475_2;
    gl64_t kG1475 = kD1475 - kE1475;
    tmp3_0 = (kC1475 + kG1475) - kF1475;
    tmp3_1 = ((((kA1475 + kC1475) - kE1475) - kE1475) - kD1475);
    tmp3_2 = kB1475 - kG1475;
    // Op 1476: dim3x1 add
    gl64_t s1_1476 = *(gl64_t*)&expressions_params[9][38];
    tmp3_0 = tmp3_0 + s1_1476; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1477: dim3x3 mul
    gl64_t s1_1477_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1477_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1477_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1477 = (tmp3_0 + tmp3_1) * (s1_1477_0 + s1_1477_1);
    gl64_t kB1477 = (tmp3_0 + tmp3_2) * (s1_1477_0 + s1_1477_2);
    gl64_t kC1477 = (tmp3_1 + tmp3_2) * (s1_1477_1 + s1_1477_2);
    gl64_t kD1477 = tmp3_0 * s1_1477_0;
    gl64_t kE1477 = tmp3_1 * s1_1477_1;
    gl64_t kF1477 = tmp3_2 * s1_1477_2;
    gl64_t kG1477 = kD1477 - kE1477;
    tmp3_0 = (kC1477 + kG1477) - kF1477;
    tmp3_1 = ((((kA1477 + kC1477) - kE1477) - kE1477) - kD1477);
    tmp3_2 = kB1477 - kG1477;
    // Op 1478: dim3x1 add
    gl64_t s1_1478 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1478; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1479: dim3x3 mul
    gl64_t s1_1479_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1479_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1479_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1479 = (tmp3_0 + tmp3_1) * (s1_1479_0 + s1_1479_1);
    gl64_t kB1479 = (tmp3_0 + tmp3_2) * (s1_1479_0 + s1_1479_2);
    gl64_t kC1479 = (tmp3_1 + tmp3_2) * (s1_1479_1 + s1_1479_2);
    gl64_t kD1479 = tmp3_0 * s1_1479_0;
    gl64_t kE1479 = tmp3_1 * s1_1479_1;
    gl64_t kF1479 = tmp3_2 * s1_1479_2;
    gl64_t kG1479 = kD1479 - kE1479;
    tmp3_0 = (kC1479 + kG1479) - kF1479;
    tmp3_1 = ((((kA1479 + kC1479) - kE1479) - kE1479) - kD1479);
    tmp3_2 = kB1479 - kG1479;
    // Op 1480: dim3x1 add
    gl64_t s1_1480 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1480; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1481: dim3x3 add
    gl64_t s1_1481_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1481_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1481_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1481_0; tmp3_1 = tmp3_1 + s1_1481_1; tmp3_2 = tmp3_2 + s1_1481_2;
    // Op 1482: dim3x3 mul
    gl64_t s1_1482_0 = *(gl64_t*)&expressions_params[10][299];
    gl64_t s1_1482_1 = *(gl64_t*)&expressions_params[10][299+1];
    gl64_t s1_1482_2 = *(gl64_t*)&expressions_params[10][299+2];
    gl64_t kA1482 = (tmp3_0 + tmp3_1) * (s1_1482_0 + s1_1482_1);
    gl64_t kB1482 = (tmp3_0 + tmp3_2) * (s1_1482_0 + s1_1482_2);
    gl64_t kC1482 = (tmp3_1 + tmp3_2) * (s1_1482_1 + s1_1482_2);
    gl64_t kD1482 = tmp3_0 * s1_1482_0;
    gl64_t kE1482 = tmp3_1 * s1_1482_1;
    gl64_t kF1482 = tmp3_2 * s1_1482_2;
    gl64_t kG1482 = kD1482 - kE1482;
    tmp3_0 = (kC1482 + kG1482) - kF1482;
    tmp3_1 = ((((kA1482 + kC1482) - kE1482) - kE1482) - kD1482);
    tmp3_2 = kB1482 - kG1482;
    // Op 1483: dim3x1 sub
    gl64_t s1_1483 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1483; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1484: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1485: dim3x3 mul
    gl64_t s1_1485_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1485_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1485_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1485 = (tmp3_0 + tmp3_1) * (s1_1485_0 + s1_1485_1);
    gl64_t kB1485 = (tmp3_0 + tmp3_2) * (s1_1485_0 + s1_1485_2);
    gl64_t kC1485 = (tmp3_1 + tmp3_2) * (s1_1485_1 + s1_1485_2);
    gl64_t kD1485 = tmp3_0 * s1_1485_0;
    gl64_t kE1485 = tmp3_1 * s1_1485_1;
    gl64_t kF1485 = tmp3_2 * s1_1485_2;
    gl64_t kG1485 = kD1485 - kE1485;
    tmp3_6 = (kC1485 + kG1485) - kF1485;
    tmp3_7 = ((((kA1485 + kC1485) - kE1485) - kE1485) - kD1485);
    tmp3_8 = kB1485 - kG1485;
    // Op 1486: dim3x1 mul
    gl64_t s0_1486_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1486_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1486_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1486 = *(gl64_t*)&expressions_params[10][51];
    tmp3_0 = s0_1486_0 * s1_1486; tmp3_1 = s0_1486_1 * s1_1486; tmp3_2 = s0_1486_2 * s1_1486;
    // Op 1487: dim3x1 add
    gl64_t s1_1487 = *(gl64_t*)&expressions_params[10][50];
    tmp3_0 = tmp3_0 + s1_1487; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1488: dim3x3 mul
    gl64_t s1_1488_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1488_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1488_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1488 = (tmp3_0 + tmp3_1) * (s1_1488_0 + s1_1488_1);
    gl64_t kB1488 = (tmp3_0 + tmp3_2) * (s1_1488_0 + s1_1488_2);
    gl64_t kC1488 = (tmp3_1 + tmp3_2) * (s1_1488_1 + s1_1488_2);
    gl64_t kD1488 = tmp3_0 * s1_1488_0;
    gl64_t kE1488 = tmp3_1 * s1_1488_1;
    gl64_t kF1488 = tmp3_2 * s1_1488_2;
    gl64_t kG1488 = kD1488 - kE1488;
    tmp3_0 = (kC1488 + kG1488) - kF1488;
    tmp3_1 = ((((kA1488 + kC1488) - kE1488) - kE1488) - kD1488);
    tmp3_2 = kB1488 - kG1488;
    // Op 1489: dim3x1 add
    gl64_t s1_1489 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1489; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1490: dim3x3 mul
    gl64_t s1_1490_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1490_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1490_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1490 = (tmp3_0 + tmp3_1) * (s1_1490_0 + s1_1490_1);
    gl64_t kB1490 = (tmp3_0 + tmp3_2) * (s1_1490_0 + s1_1490_2);
    gl64_t kC1490 = (tmp3_1 + tmp3_2) * (s1_1490_1 + s1_1490_2);
    gl64_t kD1490 = tmp3_0 * s1_1490_0;
    gl64_t kE1490 = tmp3_1 * s1_1490_1;
    gl64_t kF1490 = tmp3_2 * s1_1490_2;
    gl64_t kG1490 = kD1490 - kE1490;
    tmp3_0 = (kC1490 + kG1490) - kF1490;
    tmp3_1 = ((((kA1490 + kC1490) - kE1490) - kE1490) - kD1490);
    tmp3_2 = kB1490 - kG1490;
    // Op 1491: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1492: dim3x3 mul
    gl64_t s1_1492_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1492_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1492_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1492 = (tmp3_0 + tmp3_1) * (s1_1492_0 + s1_1492_1);
    gl64_t kB1492 = (tmp3_0 + tmp3_2) * (s1_1492_0 + s1_1492_2);
    gl64_t kC1492 = (tmp3_1 + tmp3_2) * (s1_1492_1 + s1_1492_2);
    gl64_t kD1492 = tmp3_0 * s1_1492_0;
    gl64_t kE1492 = tmp3_1 * s1_1492_1;
    gl64_t kF1492 = tmp3_2 * s1_1492_2;
    gl64_t kG1492 = kD1492 - kE1492;
    tmp3_0 = (kC1492 + kG1492) - kF1492;
    tmp3_1 = ((((kA1492 + kC1492) - kE1492) - kE1492) - kD1492);
    tmp3_2 = kB1492 - kG1492;
    // Op 1493: dim3x1 add
    gl64_t s1_1493 = *(gl64_t*)&expressions_params[9][38];
    tmp3_0 = tmp3_0 + s1_1493; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1494: dim3x3 mul
    gl64_t s1_1494_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1494_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1494_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1494 = (tmp3_0 + tmp3_1) * (s1_1494_0 + s1_1494_1);
    gl64_t kB1494 = (tmp3_0 + tmp3_2) * (s1_1494_0 + s1_1494_2);
    gl64_t kC1494 = (tmp3_1 + tmp3_2) * (s1_1494_1 + s1_1494_2);
    gl64_t kD1494 = tmp3_0 * s1_1494_0;
    gl64_t kE1494 = tmp3_1 * s1_1494_1;
    gl64_t kF1494 = tmp3_2 * s1_1494_2;
    gl64_t kG1494 = kD1494 - kE1494;
    tmp3_0 = (kC1494 + kG1494) - kF1494;
    tmp3_1 = ((((kA1494 + kC1494) - kE1494) - kE1494) - kD1494);
    tmp3_2 = kB1494 - kG1494;
    // Op 1495: dim3x1 add
    gl64_t s1_1495 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1495; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1496: dim3x3 mul
    gl64_t s1_1496_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1496_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1496_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1496 = (tmp3_0 + tmp3_1) * (s1_1496_0 + s1_1496_1);
    gl64_t kB1496 = (tmp3_0 + tmp3_2) * (s1_1496_0 + s1_1496_2);
    gl64_t kC1496 = (tmp3_1 + tmp3_2) * (s1_1496_1 + s1_1496_2);
    gl64_t kD1496 = tmp3_0 * s1_1496_0;
    gl64_t kE1496 = tmp3_1 * s1_1496_1;
    gl64_t kF1496 = tmp3_2 * s1_1496_2;
    gl64_t kG1496 = kD1496 - kE1496;
    tmp3_0 = (kC1496 + kG1496) - kF1496;
    tmp3_1 = ((((kA1496 + kC1496) - kE1496) - kE1496) - kD1496);
    tmp3_2 = kB1496 - kG1496;
    // Op 1497: dim3x1 add
    gl64_t s1_1497 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1497; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1498: dim3x3 add
    gl64_t s1_1498_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1498_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1498_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1498_0; tmp3_1 = tmp3_1 + s1_1498_1; tmp3_2 = tmp3_2 + s1_1498_2;
    // Op 1499: dim3x3 mul
    gl64_t s1_1499_0 = *(gl64_t*)&expressions_params[10][302];
    gl64_t s1_1499_1 = *(gl64_t*)&expressions_params[10][302+1];
    gl64_t s1_1499_2 = *(gl64_t*)&expressions_params[10][302+2];
    gl64_t kA1499 = (tmp3_0 + tmp3_1) * (s1_1499_0 + s1_1499_1);
    gl64_t kB1499 = (tmp3_0 + tmp3_2) * (s1_1499_0 + s1_1499_2);
    gl64_t kC1499 = (tmp3_1 + tmp3_2) * (s1_1499_1 + s1_1499_2);
    gl64_t kD1499 = tmp3_0 * s1_1499_0;
    gl64_t kE1499 = tmp3_1 * s1_1499_1;
    gl64_t kF1499 = tmp3_2 * s1_1499_2;
    gl64_t kG1499 = kD1499 - kE1499;
    tmp3_0 = (kC1499 + kG1499) - kF1499;
    tmp3_1 = ((((kA1499 + kC1499) - kE1499) - kE1499) - kD1499);
    tmp3_2 = kB1499 - kG1499;
    // Op 1500: dim1x1 sub
    gl64_t s0_1500 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1500 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1500 - s1_1500;
    // Op 1501: dim1x1 sub_swap
    gl64_t s1_1501 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1501 - tmp1_0;
    // Op 1502: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1503: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1504: dim3x3 mul
    gl64_t s1_1504_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1504_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1504_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1504 = (tmp3_0 + tmp3_1) * (s1_1504_0 + s1_1504_1);
    gl64_t kB1504 = (tmp3_0 + tmp3_2) * (s1_1504_0 + s1_1504_2);
    gl64_t kC1504 = (tmp3_1 + tmp3_2) * (s1_1504_1 + s1_1504_2);
    gl64_t kD1504 = tmp3_0 * s1_1504_0;
    gl64_t kE1504 = tmp3_1 * s1_1504_1;
    gl64_t kF1504 = tmp3_2 * s1_1504_2;
    gl64_t kG1504 = kD1504 - kE1504;
    tmp3_6 = (kC1504 + kG1504) - kF1504;
    tmp3_7 = ((((kA1504 + kC1504) - kE1504) - kE1504) - kD1504);
    tmp3_8 = kB1504 - kG1504;
    // Op 1505: dim1x1 sub
    gl64_t s1_1505 = *(gl64_t*)&expressions_params[10][92];
    tmp1_0 = tmp1_4 - s1_1505;
    // Op 1506: dim1x1 sub
    gl64_t s1_1506 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1506;
    // Op 1507: dim3x1 mul
    gl64_t s0_1507_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1507_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1507_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1507_0 * tmp1_0; tmp3_1 = s0_1507_1 * tmp1_0; tmp3_2 = s0_1507_2 * tmp1_0;
    // Op 1508: dim3x1 add
    gl64_t s1_1508 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1508; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1509: dim3x3 add
    gl64_t s1_1509_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1509_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1509_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1509_0; tmp3_1 = tmp3_1 + s1_1509_1; tmp3_2 = tmp3_2 + s1_1509_2;
    // Op 1510: dim3x3 mul
    gl64_t s1_1510_0 = *(gl64_t*)&expressions_params[10][305];
    gl64_t s1_1510_1 = *(gl64_t*)&expressions_params[10][305+1];
    gl64_t s1_1510_2 = *(gl64_t*)&expressions_params[10][305+2];
    gl64_t kA1510 = (tmp3_0 + tmp3_1) * (s1_1510_0 + s1_1510_1);
    gl64_t kB1510 = (tmp3_0 + tmp3_2) * (s1_1510_0 + s1_1510_2);
    gl64_t kC1510 = (tmp3_1 + tmp3_2) * (s1_1510_1 + s1_1510_2);
    gl64_t kD1510 = tmp3_0 * s1_1510_0;
    gl64_t kE1510 = tmp3_1 * s1_1510_1;
    gl64_t kF1510 = tmp3_2 * s1_1510_2;
    gl64_t kG1510 = kD1510 - kE1510;
    tmp3_0 = (kC1510 + kG1510) - kF1510;
    tmp3_1 = ((((kA1510 + kC1510) - kE1510) - kE1510) - kD1510);
    tmp3_2 = kB1510 - kG1510;
    // Op 1511: dim3x1 add
    gl64_t s1_1511 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1511; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1512: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1513: dim3x3 mul
    gl64_t s1_1513_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1513_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1513_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1513 = (tmp3_0 + tmp3_1) * (s1_1513_0 + s1_1513_1);
    gl64_t kB1513 = (tmp3_0 + tmp3_2) * (s1_1513_0 + s1_1513_2);
    gl64_t kC1513 = (tmp3_1 + tmp3_2) * (s1_1513_1 + s1_1513_2);
    gl64_t kD1513 = tmp3_0 * s1_1513_0;
    gl64_t kE1513 = tmp3_1 * s1_1513_1;
    gl64_t kF1513 = tmp3_2 * s1_1513_2;
    gl64_t kG1513 = kD1513 - kE1513;
    tmp3_6 = (kC1513 + kG1513) - kF1513;
    tmp3_7 = ((((kA1513 + kC1513) - kE1513) - kE1513) - kD1513);
    tmp3_8 = kB1513 - kG1513;
    // Op 1514: dim3x1 mul
    gl64_t s0_1514_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1514_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1514_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1514 = *(gl64_t*)&expressions_params[10][53];
    tmp3_0 = s0_1514_0 * s1_1514; tmp3_1 = s0_1514_1 * s1_1514; tmp3_2 = s0_1514_2 * s1_1514;
    // Op 1515: dim3x1 add
    gl64_t s1_1515 = *(gl64_t*)&expressions_params[10][52];
    tmp3_0 = tmp3_0 + s1_1515; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1516: dim3x3 mul
    gl64_t s1_1516_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1516_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1516_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1516 = (tmp3_0 + tmp3_1) * (s1_1516_0 + s1_1516_1);
    gl64_t kB1516 = (tmp3_0 + tmp3_2) * (s1_1516_0 + s1_1516_2);
    gl64_t kC1516 = (tmp3_1 + tmp3_2) * (s1_1516_1 + s1_1516_2);
    gl64_t kD1516 = tmp3_0 * s1_1516_0;
    gl64_t kE1516 = tmp3_1 * s1_1516_1;
    gl64_t kF1516 = tmp3_2 * s1_1516_2;
    gl64_t kG1516 = kD1516 - kE1516;
    tmp3_0 = (kC1516 + kG1516) - kF1516;
    tmp3_1 = ((((kA1516 + kC1516) - kE1516) - kE1516) - kD1516);
    tmp3_2 = kB1516 - kG1516;
    // Op 1517: dim3x1 add
    gl64_t s1_1517 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1517; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1518: dim3x3 mul
    gl64_t s1_1518_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1518_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1518_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1518 = (tmp3_0 + tmp3_1) * (s1_1518_0 + s1_1518_1);
    gl64_t kB1518 = (tmp3_0 + tmp3_2) * (s1_1518_0 + s1_1518_2);
    gl64_t kC1518 = (tmp3_1 + tmp3_2) * (s1_1518_1 + s1_1518_2);
    gl64_t kD1518 = tmp3_0 * s1_1518_0;
    gl64_t kE1518 = tmp3_1 * s1_1518_1;
    gl64_t kF1518 = tmp3_2 * s1_1518_2;
    gl64_t kG1518 = kD1518 - kE1518;
    tmp3_0 = (kC1518 + kG1518) - kF1518;
    tmp3_1 = ((((kA1518 + kC1518) - kE1518) - kE1518) - kD1518);
    tmp3_2 = kB1518 - kG1518;
    // Op 1519: dim3x1 add
    gl64_t s1_1519 = *(gl64_t*)&expressions_params[10][92];
    tmp3_0 = tmp3_0 + s1_1519; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1520: dim3x3 mul
    gl64_t s1_1520_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1520_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1520_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1520 = (tmp3_0 + tmp3_1) * (s1_1520_0 + s1_1520_1);
    gl64_t kB1520 = (tmp3_0 + tmp3_2) * (s1_1520_0 + s1_1520_2);
    gl64_t kC1520 = (tmp3_1 + tmp3_2) * (s1_1520_1 + s1_1520_2);
    gl64_t kD1520 = tmp3_0 * s1_1520_0;
    gl64_t kE1520 = tmp3_1 * s1_1520_1;
    gl64_t kF1520 = tmp3_2 * s1_1520_2;
    gl64_t kG1520 = kD1520 - kE1520;
    tmp3_0 = (kC1520 + kG1520) - kF1520;
    tmp3_1 = ((((kA1520 + kC1520) - kE1520) - kE1520) - kD1520);
    tmp3_2 = kB1520 - kG1520;
    // Op 1521: dim3x1 add
    gl64_t s1_1521 = *(gl64_t*)&expressions_params[9][39];
    tmp3_0 = tmp3_0 + s1_1521; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1522: dim3x3 mul
    gl64_t s1_1522_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1522_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1522_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1522 = (tmp3_0 + tmp3_1) * (s1_1522_0 + s1_1522_1);
    gl64_t kB1522 = (tmp3_0 + tmp3_2) * (s1_1522_0 + s1_1522_2);
    gl64_t kC1522 = (tmp3_1 + tmp3_2) * (s1_1522_1 + s1_1522_2);
    gl64_t kD1522 = tmp3_0 * s1_1522_0;
    gl64_t kE1522 = tmp3_1 * s1_1522_1;
    gl64_t kF1522 = tmp3_2 * s1_1522_2;
    gl64_t kG1522 = kD1522 - kE1522;
    tmp3_0 = (kC1522 + kG1522) - kF1522;
    tmp3_1 = ((((kA1522 + kC1522) - kE1522) - kE1522) - kD1522);
    tmp3_2 = kB1522 - kG1522;
    // Op 1523: dim3x1 add
    gl64_t s1_1523 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1523; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1524: dim3x3 mul
    gl64_t s1_1524_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1524_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1524_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1524 = (tmp3_0 + tmp3_1) * (s1_1524_0 + s1_1524_1);
    gl64_t kB1524 = (tmp3_0 + tmp3_2) * (s1_1524_0 + s1_1524_2);
    gl64_t kC1524 = (tmp3_1 + tmp3_2) * (s1_1524_1 + s1_1524_2);
    gl64_t kD1524 = tmp3_0 * s1_1524_0;
    gl64_t kE1524 = tmp3_1 * s1_1524_1;
    gl64_t kF1524 = tmp3_2 * s1_1524_2;
    gl64_t kG1524 = kD1524 - kE1524;
    tmp3_0 = (kC1524 + kG1524) - kF1524;
    tmp3_1 = ((((kA1524 + kC1524) - kE1524) - kE1524) - kD1524);
    tmp3_2 = kB1524 - kG1524;
    // Op 1525: dim3x1 add
    gl64_t s1_1525 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1525; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1526: dim3x3 add
    gl64_t s1_1526_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1526_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1526_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1526_0; tmp3_1 = tmp3_1 + s1_1526_1; tmp3_2 = tmp3_2 + s1_1526_2;
    // Op 1527: dim3x3 mul
    gl64_t s1_1527_0 = *(gl64_t*)&expressions_params[10][308];
    gl64_t s1_1527_1 = *(gl64_t*)&expressions_params[10][308+1];
    gl64_t s1_1527_2 = *(gl64_t*)&expressions_params[10][308+2];
    gl64_t kA1527 = (tmp3_0 + tmp3_1) * (s1_1527_0 + s1_1527_1);
    gl64_t kB1527 = (tmp3_0 + tmp3_2) * (s1_1527_0 + s1_1527_2);
    gl64_t kC1527 = (tmp3_1 + tmp3_2) * (s1_1527_1 + s1_1527_2);
    gl64_t kD1527 = tmp3_0 * s1_1527_0;
    gl64_t kE1527 = tmp3_1 * s1_1527_1;
    gl64_t kF1527 = tmp3_2 * s1_1527_2;
    gl64_t kG1527 = kD1527 - kE1527;
    tmp3_0 = (kC1527 + kG1527) - kF1527;
    tmp3_1 = ((((kA1527 + kC1527) - kE1527) - kE1527) - kD1527);
    tmp3_2 = kB1527 - kG1527;
    // Op 1528: dim3x1 sub
    gl64_t s1_1528 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1528; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1529: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1530: dim3x3 mul
    gl64_t s1_1530_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1530_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1530_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1530 = (tmp3_0 + tmp3_1) * (s1_1530_0 + s1_1530_1);
    gl64_t kB1530 = (tmp3_0 + tmp3_2) * (s1_1530_0 + s1_1530_2);
    gl64_t kC1530 = (tmp3_1 + tmp3_2) * (s1_1530_1 + s1_1530_2);
    gl64_t kD1530 = tmp3_0 * s1_1530_0;
    gl64_t kE1530 = tmp3_1 * s1_1530_1;
    gl64_t kF1530 = tmp3_2 * s1_1530_2;
    gl64_t kG1530 = kD1530 - kE1530;
    tmp3_6 = (kC1530 + kG1530) - kF1530;
    tmp3_7 = ((((kA1530 + kC1530) - kE1530) - kE1530) - kD1530);
    tmp3_8 = kB1530 - kG1530;
    // Op 1531: dim3x1 mul
    gl64_t s0_1531_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1531_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1531_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1531 = *(gl64_t*)&expressions_params[10][53];
    tmp3_0 = s0_1531_0 * s1_1531; tmp3_1 = s0_1531_1 * s1_1531; tmp3_2 = s0_1531_2 * s1_1531;
    // Op 1532: dim3x1 add
    gl64_t s1_1532 = *(gl64_t*)&expressions_params[10][52];
    tmp3_0 = tmp3_0 + s1_1532; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1533: dim3x3 mul
    gl64_t s1_1533_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1533_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1533_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1533 = (tmp3_0 + tmp3_1) * (s1_1533_0 + s1_1533_1);
    gl64_t kB1533 = (tmp3_0 + tmp3_2) * (s1_1533_0 + s1_1533_2);
    gl64_t kC1533 = (tmp3_1 + tmp3_2) * (s1_1533_1 + s1_1533_2);
    gl64_t kD1533 = tmp3_0 * s1_1533_0;
    gl64_t kE1533 = tmp3_1 * s1_1533_1;
    gl64_t kF1533 = tmp3_2 * s1_1533_2;
    gl64_t kG1533 = kD1533 - kE1533;
    tmp3_0 = (kC1533 + kG1533) - kF1533;
    tmp3_1 = ((((kA1533 + kC1533) - kE1533) - kE1533) - kD1533);
    tmp3_2 = kB1533 - kG1533;
    // Op 1534: dim3x1 add
    gl64_t s1_1534 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1534; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1535: dim3x3 mul
    gl64_t s1_1535_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1535_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1535_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1535 = (tmp3_0 + tmp3_1) * (s1_1535_0 + s1_1535_1);
    gl64_t kB1535 = (tmp3_0 + tmp3_2) * (s1_1535_0 + s1_1535_2);
    gl64_t kC1535 = (tmp3_1 + tmp3_2) * (s1_1535_1 + s1_1535_2);
    gl64_t kD1535 = tmp3_0 * s1_1535_0;
    gl64_t kE1535 = tmp3_1 * s1_1535_1;
    gl64_t kF1535 = tmp3_2 * s1_1535_2;
    gl64_t kG1535 = kD1535 - kE1535;
    tmp3_0 = (kC1535 + kG1535) - kF1535;
    tmp3_1 = ((((kA1535 + kC1535) - kE1535) - kE1535) - kD1535);
    tmp3_2 = kB1535 - kG1535;
    // Op 1536: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1537: dim3x3 mul
    gl64_t s1_1537_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1537_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1537_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1537 = (tmp3_0 + tmp3_1) * (s1_1537_0 + s1_1537_1);
    gl64_t kB1537 = (tmp3_0 + tmp3_2) * (s1_1537_0 + s1_1537_2);
    gl64_t kC1537 = (tmp3_1 + tmp3_2) * (s1_1537_1 + s1_1537_2);
    gl64_t kD1537 = tmp3_0 * s1_1537_0;
    gl64_t kE1537 = tmp3_1 * s1_1537_1;
    gl64_t kF1537 = tmp3_2 * s1_1537_2;
    gl64_t kG1537 = kD1537 - kE1537;
    tmp3_0 = (kC1537 + kG1537) - kF1537;
    tmp3_1 = ((((kA1537 + kC1537) - kE1537) - kE1537) - kD1537);
    tmp3_2 = kB1537 - kG1537;
    // Op 1538: dim3x1 add
    gl64_t s1_1538 = *(gl64_t*)&expressions_params[9][39];
    tmp3_0 = tmp3_0 + s1_1538; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1539: dim3x3 mul
    gl64_t s1_1539_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1539_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1539_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1539 = (tmp3_0 + tmp3_1) * (s1_1539_0 + s1_1539_1);
    gl64_t kB1539 = (tmp3_0 + tmp3_2) * (s1_1539_0 + s1_1539_2);
    gl64_t kC1539 = (tmp3_1 + tmp3_2) * (s1_1539_1 + s1_1539_2);
    gl64_t kD1539 = tmp3_0 * s1_1539_0;
    gl64_t kE1539 = tmp3_1 * s1_1539_1;
    gl64_t kF1539 = tmp3_2 * s1_1539_2;
    gl64_t kG1539 = kD1539 - kE1539;
    tmp3_0 = (kC1539 + kG1539) - kF1539;
    tmp3_1 = ((((kA1539 + kC1539) - kE1539) - kE1539) - kD1539);
    tmp3_2 = kB1539 - kG1539;
    // Op 1540: dim3x1 add
    gl64_t s1_1540 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1540; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1541: dim3x3 mul
    gl64_t s1_1541_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1541_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1541_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1541 = (tmp3_0 + tmp3_1) * (s1_1541_0 + s1_1541_1);
    gl64_t kB1541 = (tmp3_0 + tmp3_2) * (s1_1541_0 + s1_1541_2);
    gl64_t kC1541 = (tmp3_1 + tmp3_2) * (s1_1541_1 + s1_1541_2);
    gl64_t kD1541 = tmp3_0 * s1_1541_0;
    gl64_t kE1541 = tmp3_1 * s1_1541_1;
    gl64_t kF1541 = tmp3_2 * s1_1541_2;
    gl64_t kG1541 = kD1541 - kE1541;
    tmp3_0 = (kC1541 + kG1541) - kF1541;
    tmp3_1 = ((((kA1541 + kC1541) - kE1541) - kE1541) - kD1541);
    tmp3_2 = kB1541 - kG1541;
    // Op 1542: dim3x1 add
    gl64_t s1_1542 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1542; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1543: dim3x3 add
    gl64_t s1_1543_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1543_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1543_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1543_0; tmp3_1 = tmp3_1 + s1_1543_1; tmp3_2 = tmp3_2 + s1_1543_2;
    // Op 1544: dim3x3 mul
    gl64_t s1_1544_0 = *(gl64_t*)&expressions_params[10][311];
    gl64_t s1_1544_1 = *(gl64_t*)&expressions_params[10][311+1];
    gl64_t s1_1544_2 = *(gl64_t*)&expressions_params[10][311+2];
    gl64_t kA1544 = (tmp3_0 + tmp3_1) * (s1_1544_0 + s1_1544_1);
    gl64_t kB1544 = (tmp3_0 + tmp3_2) * (s1_1544_0 + s1_1544_2);
    gl64_t kC1544 = (tmp3_1 + tmp3_2) * (s1_1544_1 + s1_1544_2);
    gl64_t kD1544 = tmp3_0 * s1_1544_0;
    gl64_t kE1544 = tmp3_1 * s1_1544_1;
    gl64_t kF1544 = tmp3_2 * s1_1544_2;
    gl64_t kG1544 = kD1544 - kE1544;
    tmp3_0 = (kC1544 + kG1544) - kF1544;
    tmp3_1 = ((((kA1544 + kC1544) - kE1544) - kE1544) - kD1544);
    tmp3_2 = kB1544 - kG1544;
    // Op 1545: dim1x1 sub
    gl64_t s0_1545 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1545 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1545 - s1_1545;
    // Op 1546: dim1x1 sub_swap
    gl64_t s1_1546 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1546 - tmp1_0;
    // Op 1547: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1548: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1549: dim3x3 mul
    gl64_t s1_1549_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1549_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1549_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1549 = (tmp3_0 + tmp3_1) * (s1_1549_0 + s1_1549_1);
    gl64_t kB1549 = (tmp3_0 + tmp3_2) * (s1_1549_0 + s1_1549_2);
    gl64_t kC1549 = (tmp3_1 + tmp3_2) * (s1_1549_1 + s1_1549_2);
    gl64_t kD1549 = tmp3_0 * s1_1549_0;
    gl64_t kE1549 = tmp3_1 * s1_1549_1;
    gl64_t kF1549 = tmp3_2 * s1_1549_2;
    gl64_t kG1549 = kD1549 - kE1549;
    tmp3_6 = (kC1549 + kG1549) - kF1549;
    tmp3_7 = ((((kA1549 + kC1549) - kE1549) - kE1549) - kD1549);
    tmp3_8 = kB1549 - kG1549;
    // Op 1550: dim1x1 sub
    gl64_t s1_1550 = *(gl64_t*)&expressions_params[10][93];
    tmp1_0 = tmp1_4 - s1_1550;
    // Op 1551: dim1x1 sub
    gl64_t s1_1551 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1551;
    // Op 1552: dim3x1 mul
    gl64_t s0_1552_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1552_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1552_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1552_0 * tmp1_0; tmp3_1 = s0_1552_1 * tmp1_0; tmp3_2 = s0_1552_2 * tmp1_0;
    // Op 1553: dim3x1 add
    gl64_t s1_1553 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1553; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1554: dim3x3 add
    gl64_t s1_1554_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1554_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1554_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1554_0; tmp3_1 = tmp3_1 + s1_1554_1; tmp3_2 = tmp3_2 + s1_1554_2;
    // Op 1555: dim3x3 mul
    gl64_t s1_1555_0 = *(gl64_t*)&expressions_params[10][314];
    gl64_t s1_1555_1 = *(gl64_t*)&expressions_params[10][314+1];
    gl64_t s1_1555_2 = *(gl64_t*)&expressions_params[10][314+2];
    gl64_t kA1555 = (tmp3_0 + tmp3_1) * (s1_1555_0 + s1_1555_1);
    gl64_t kB1555 = (tmp3_0 + tmp3_2) * (s1_1555_0 + s1_1555_2);
    gl64_t kC1555 = (tmp3_1 + tmp3_2) * (s1_1555_1 + s1_1555_2);
    gl64_t kD1555 = tmp3_0 * s1_1555_0;
    gl64_t kE1555 = tmp3_1 * s1_1555_1;
    gl64_t kF1555 = tmp3_2 * s1_1555_2;
    gl64_t kG1555 = kD1555 - kE1555;
    tmp3_0 = (kC1555 + kG1555) - kF1555;
    tmp3_1 = ((((kA1555 + kC1555) - kE1555) - kE1555) - kD1555);
    tmp3_2 = kB1555 - kG1555;
    // Op 1556: dim3x1 add
    gl64_t s1_1556 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1556; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1557: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1558: dim3x3 mul
    gl64_t s1_1558_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1558_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1558_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1558 = (tmp3_0 + tmp3_1) * (s1_1558_0 + s1_1558_1);
    gl64_t kB1558 = (tmp3_0 + tmp3_2) * (s1_1558_0 + s1_1558_2);
    gl64_t kC1558 = (tmp3_1 + tmp3_2) * (s1_1558_1 + s1_1558_2);
    gl64_t kD1558 = tmp3_0 * s1_1558_0;
    gl64_t kE1558 = tmp3_1 * s1_1558_1;
    gl64_t kF1558 = tmp3_2 * s1_1558_2;
    gl64_t kG1558 = kD1558 - kE1558;
    tmp3_6 = (kC1558 + kG1558) - kF1558;
    tmp3_7 = ((((kA1558 + kC1558) - kE1558) - kE1558) - kD1558);
    tmp3_8 = kB1558 - kG1558;
    // Op 1559: dim3x1 mul
    gl64_t s0_1559_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1559_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1559_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1559 = *(gl64_t*)&expressions_params[10][55];
    tmp3_0 = s0_1559_0 * s1_1559; tmp3_1 = s0_1559_1 * s1_1559; tmp3_2 = s0_1559_2 * s1_1559;
    // Op 1560: dim3x1 add
    gl64_t s1_1560 = *(gl64_t*)&expressions_params[10][54];
    tmp3_0 = tmp3_0 + s1_1560; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1561: dim3x3 mul
    gl64_t s1_1561_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1561_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1561_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1561 = (tmp3_0 + tmp3_1) * (s1_1561_0 + s1_1561_1);
    gl64_t kB1561 = (tmp3_0 + tmp3_2) * (s1_1561_0 + s1_1561_2);
    gl64_t kC1561 = (tmp3_1 + tmp3_2) * (s1_1561_1 + s1_1561_2);
    gl64_t kD1561 = tmp3_0 * s1_1561_0;
    gl64_t kE1561 = tmp3_1 * s1_1561_1;
    gl64_t kF1561 = tmp3_2 * s1_1561_2;
    gl64_t kG1561 = kD1561 - kE1561;
    tmp3_0 = (kC1561 + kG1561) - kF1561;
    tmp3_1 = ((((kA1561 + kC1561) - kE1561) - kE1561) - kD1561);
    tmp3_2 = kB1561 - kG1561;
    // Op 1562: dim3x1 add
    gl64_t s1_1562 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1562; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1563: dim3x3 mul
    gl64_t s1_1563_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1563_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1563_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1563 = (tmp3_0 + tmp3_1) * (s1_1563_0 + s1_1563_1);
    gl64_t kB1563 = (tmp3_0 + tmp3_2) * (s1_1563_0 + s1_1563_2);
    gl64_t kC1563 = (tmp3_1 + tmp3_2) * (s1_1563_1 + s1_1563_2);
    gl64_t kD1563 = tmp3_0 * s1_1563_0;
    gl64_t kE1563 = tmp3_1 * s1_1563_1;
    gl64_t kF1563 = tmp3_2 * s1_1563_2;
    gl64_t kG1563 = kD1563 - kE1563;
    tmp3_0 = (kC1563 + kG1563) - kF1563;
    tmp3_1 = ((((kA1563 + kC1563) - kE1563) - kE1563) - kD1563);
    tmp3_2 = kB1563 - kG1563;
    // Op 1564: dim3x1 add
    gl64_t s1_1564 = *(gl64_t*)&expressions_params[10][93];
    tmp3_0 = tmp3_0 + s1_1564; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1565: dim3x3 mul
    gl64_t s1_1565_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1565_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1565_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1565 = (tmp3_0 + tmp3_1) * (s1_1565_0 + s1_1565_1);
    gl64_t kB1565 = (tmp3_0 + tmp3_2) * (s1_1565_0 + s1_1565_2);
    gl64_t kC1565 = (tmp3_1 + tmp3_2) * (s1_1565_1 + s1_1565_2);
    gl64_t kD1565 = tmp3_0 * s1_1565_0;
    gl64_t kE1565 = tmp3_1 * s1_1565_1;
    gl64_t kF1565 = tmp3_2 * s1_1565_2;
    gl64_t kG1565 = kD1565 - kE1565;
    tmp3_0 = (kC1565 + kG1565) - kF1565;
    tmp3_1 = ((((kA1565 + kC1565) - kE1565) - kE1565) - kD1565);
    tmp3_2 = kB1565 - kG1565;
    // Op 1566: dim3x1 add
    gl64_t s1_1566 = *(gl64_t*)&expressions_params[9][40];
    tmp3_0 = tmp3_0 + s1_1566; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1567: dim3x3 mul
    gl64_t s1_1567_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1567_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1567_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1567 = (tmp3_0 + tmp3_1) * (s1_1567_0 + s1_1567_1);
    gl64_t kB1567 = (tmp3_0 + tmp3_2) * (s1_1567_0 + s1_1567_2);
    gl64_t kC1567 = (tmp3_1 + tmp3_2) * (s1_1567_1 + s1_1567_2);
    gl64_t kD1567 = tmp3_0 * s1_1567_0;
    gl64_t kE1567 = tmp3_1 * s1_1567_1;
    gl64_t kF1567 = tmp3_2 * s1_1567_2;
    gl64_t kG1567 = kD1567 - kE1567;
    tmp3_0 = (kC1567 + kG1567) - kF1567;
    tmp3_1 = ((((kA1567 + kC1567) - kE1567) - kE1567) - kD1567);
    tmp3_2 = kB1567 - kG1567;
    // Op 1568: dim3x1 add
    gl64_t s1_1568 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1568; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1569: dim3x3 mul
    gl64_t s1_1569_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1569_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1569_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1569 = (tmp3_0 + tmp3_1) * (s1_1569_0 + s1_1569_1);
    gl64_t kB1569 = (tmp3_0 + tmp3_2) * (s1_1569_0 + s1_1569_2);
    gl64_t kC1569 = (tmp3_1 + tmp3_2) * (s1_1569_1 + s1_1569_2);
    gl64_t kD1569 = tmp3_0 * s1_1569_0;
    gl64_t kE1569 = tmp3_1 * s1_1569_1;
    gl64_t kF1569 = tmp3_2 * s1_1569_2;
    gl64_t kG1569 = kD1569 - kE1569;
    tmp3_0 = (kC1569 + kG1569) - kF1569;
    tmp3_1 = ((((kA1569 + kC1569) - kE1569) - kE1569) - kD1569);
    tmp3_2 = kB1569 - kG1569;
    // Op 1570: dim3x1 add
    gl64_t s1_1570 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1570; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1571: dim3x3 add
    gl64_t s1_1571_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1571_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1571_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1571_0; tmp3_1 = tmp3_1 + s1_1571_1; tmp3_2 = tmp3_2 + s1_1571_2;
    // Op 1572: dim3x3 mul
    gl64_t s1_1572_0 = *(gl64_t*)&expressions_params[10][317];
    gl64_t s1_1572_1 = *(gl64_t*)&expressions_params[10][317+1];
    gl64_t s1_1572_2 = *(gl64_t*)&expressions_params[10][317+2];
    gl64_t kA1572 = (tmp3_0 + tmp3_1) * (s1_1572_0 + s1_1572_1);
    gl64_t kB1572 = (tmp3_0 + tmp3_2) * (s1_1572_0 + s1_1572_2);
    gl64_t kC1572 = (tmp3_1 + tmp3_2) * (s1_1572_1 + s1_1572_2);
    gl64_t kD1572 = tmp3_0 * s1_1572_0;
    gl64_t kE1572 = tmp3_1 * s1_1572_1;
    gl64_t kF1572 = tmp3_2 * s1_1572_2;
    gl64_t kG1572 = kD1572 - kE1572;
    tmp3_0 = (kC1572 + kG1572) - kF1572;
    tmp3_1 = ((((kA1572 + kC1572) - kE1572) - kE1572) - kD1572);
    tmp3_2 = kB1572 - kG1572;
    // Op 1573: dim3x1 sub
    gl64_t s1_1573 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1573; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1574: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1575: dim3x3 mul
    gl64_t s1_1575_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1575_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1575_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1575 = (tmp3_0 + tmp3_1) * (s1_1575_0 + s1_1575_1);
    gl64_t kB1575 = (tmp3_0 + tmp3_2) * (s1_1575_0 + s1_1575_2);
    gl64_t kC1575 = (tmp3_1 + tmp3_2) * (s1_1575_1 + s1_1575_2);
    gl64_t kD1575 = tmp3_0 * s1_1575_0;
    gl64_t kE1575 = tmp3_1 * s1_1575_1;
    gl64_t kF1575 = tmp3_2 * s1_1575_2;
    gl64_t kG1575 = kD1575 - kE1575;
    tmp3_6 = (kC1575 + kG1575) - kF1575;
    tmp3_7 = ((((kA1575 + kC1575) - kE1575) - kE1575) - kD1575);
    tmp3_8 = kB1575 - kG1575;
    // Op 1576: dim3x1 mul
    gl64_t s0_1576_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1576_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1576_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1576 = *(gl64_t*)&expressions_params[10][55];
    tmp3_0 = s0_1576_0 * s1_1576; tmp3_1 = s0_1576_1 * s1_1576; tmp3_2 = s0_1576_2 * s1_1576;
    // Op 1577: dim3x1 add
    gl64_t s1_1577 = *(gl64_t*)&expressions_params[10][54];
    tmp3_0 = tmp3_0 + s1_1577; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1578: dim3x3 mul
    gl64_t s1_1578_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1578_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1578_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1578 = (tmp3_0 + tmp3_1) * (s1_1578_0 + s1_1578_1);
    gl64_t kB1578 = (tmp3_0 + tmp3_2) * (s1_1578_0 + s1_1578_2);
    gl64_t kC1578 = (tmp3_1 + tmp3_2) * (s1_1578_1 + s1_1578_2);
    gl64_t kD1578 = tmp3_0 * s1_1578_0;
    gl64_t kE1578 = tmp3_1 * s1_1578_1;
    gl64_t kF1578 = tmp3_2 * s1_1578_2;
    gl64_t kG1578 = kD1578 - kE1578;
    tmp3_0 = (kC1578 + kG1578) - kF1578;
    tmp3_1 = ((((kA1578 + kC1578) - kE1578) - kE1578) - kD1578);
    tmp3_2 = kB1578 - kG1578;
    // Op 1579: dim3x1 add
    gl64_t s1_1579 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1579; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1580: dim3x3 mul
    gl64_t s1_1580_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1580_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1580_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1580 = (tmp3_0 + tmp3_1) * (s1_1580_0 + s1_1580_1);
    gl64_t kB1580 = (tmp3_0 + tmp3_2) * (s1_1580_0 + s1_1580_2);
    gl64_t kC1580 = (tmp3_1 + tmp3_2) * (s1_1580_1 + s1_1580_2);
    gl64_t kD1580 = tmp3_0 * s1_1580_0;
    gl64_t kE1580 = tmp3_1 * s1_1580_1;
    gl64_t kF1580 = tmp3_2 * s1_1580_2;
    gl64_t kG1580 = kD1580 - kE1580;
    tmp3_0 = (kC1580 + kG1580) - kF1580;
    tmp3_1 = ((((kA1580 + kC1580) - kE1580) - kE1580) - kD1580);
    tmp3_2 = kB1580 - kG1580;
    // Op 1581: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1582: dim3x3 mul
    gl64_t s1_1582_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1582_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1582_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1582 = (tmp3_0 + tmp3_1) * (s1_1582_0 + s1_1582_1);
    gl64_t kB1582 = (tmp3_0 + tmp3_2) * (s1_1582_0 + s1_1582_2);
    gl64_t kC1582 = (tmp3_1 + tmp3_2) * (s1_1582_1 + s1_1582_2);
    gl64_t kD1582 = tmp3_0 * s1_1582_0;
    gl64_t kE1582 = tmp3_1 * s1_1582_1;
    gl64_t kF1582 = tmp3_2 * s1_1582_2;
    gl64_t kG1582 = kD1582 - kE1582;
    tmp3_0 = (kC1582 + kG1582) - kF1582;
    tmp3_1 = ((((kA1582 + kC1582) - kE1582) - kE1582) - kD1582);
    tmp3_2 = kB1582 - kG1582;
    // Op 1583: dim3x1 add
    gl64_t s1_1583 = *(gl64_t*)&expressions_params[9][40];
    tmp3_0 = tmp3_0 + s1_1583; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1584: dim3x3 mul
    gl64_t s1_1584_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1584_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1584_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1584 = (tmp3_0 + tmp3_1) * (s1_1584_0 + s1_1584_1);
    gl64_t kB1584 = (tmp3_0 + tmp3_2) * (s1_1584_0 + s1_1584_2);
    gl64_t kC1584 = (tmp3_1 + tmp3_2) * (s1_1584_1 + s1_1584_2);
    gl64_t kD1584 = tmp3_0 * s1_1584_0;
    gl64_t kE1584 = tmp3_1 * s1_1584_1;
    gl64_t kF1584 = tmp3_2 * s1_1584_2;
    gl64_t kG1584 = kD1584 - kE1584;
    tmp3_0 = (kC1584 + kG1584) - kF1584;
    tmp3_1 = ((((kA1584 + kC1584) - kE1584) - kE1584) - kD1584);
    tmp3_2 = kB1584 - kG1584;
    // Op 1585: dim3x1 add
    gl64_t s1_1585 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1585; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1586: dim3x3 mul
    gl64_t s1_1586_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1586_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1586_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1586 = (tmp3_0 + tmp3_1) * (s1_1586_0 + s1_1586_1);
    gl64_t kB1586 = (tmp3_0 + tmp3_2) * (s1_1586_0 + s1_1586_2);
    gl64_t kC1586 = (tmp3_1 + tmp3_2) * (s1_1586_1 + s1_1586_2);
    gl64_t kD1586 = tmp3_0 * s1_1586_0;
    gl64_t kE1586 = tmp3_1 * s1_1586_1;
    gl64_t kF1586 = tmp3_2 * s1_1586_2;
    gl64_t kG1586 = kD1586 - kE1586;
    tmp3_0 = (kC1586 + kG1586) - kF1586;
    tmp3_1 = ((((kA1586 + kC1586) - kE1586) - kE1586) - kD1586);
    tmp3_2 = kB1586 - kG1586;
    // Op 1587: dim3x1 add
    gl64_t s1_1587 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1587; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1588: dim3x3 add
    gl64_t s1_1588_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1588_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1588_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1588_0; tmp3_1 = tmp3_1 + s1_1588_1; tmp3_2 = tmp3_2 + s1_1588_2;
    // Op 1589: dim3x3 mul
    gl64_t s1_1589_0 = *(gl64_t*)&expressions_params[10][320];
    gl64_t s1_1589_1 = *(gl64_t*)&expressions_params[10][320+1];
    gl64_t s1_1589_2 = *(gl64_t*)&expressions_params[10][320+2];
    gl64_t kA1589 = (tmp3_0 + tmp3_1) * (s1_1589_0 + s1_1589_1);
    gl64_t kB1589 = (tmp3_0 + tmp3_2) * (s1_1589_0 + s1_1589_2);
    gl64_t kC1589 = (tmp3_1 + tmp3_2) * (s1_1589_1 + s1_1589_2);
    gl64_t kD1589 = tmp3_0 * s1_1589_0;
    gl64_t kE1589 = tmp3_1 * s1_1589_1;
    gl64_t kF1589 = tmp3_2 * s1_1589_2;
    gl64_t kG1589 = kD1589 - kE1589;
    tmp3_0 = (kC1589 + kG1589) - kF1589;
    tmp3_1 = ((((kA1589 + kC1589) - kE1589) - kE1589) - kD1589);
    tmp3_2 = kB1589 - kG1589;
    // Op 1590: dim1x1 sub
    gl64_t s0_1590 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1590 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1590 - s1_1590;
    // Op 1591: dim1x1 sub_swap
    gl64_t s1_1591 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1591 - tmp1_0;
    // Op 1592: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1593: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1594: dim3x3 mul
    gl64_t s1_1594_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1594_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1594_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1594 = (tmp3_0 + tmp3_1) * (s1_1594_0 + s1_1594_1);
    gl64_t kB1594 = (tmp3_0 + tmp3_2) * (s1_1594_0 + s1_1594_2);
    gl64_t kC1594 = (tmp3_1 + tmp3_2) * (s1_1594_1 + s1_1594_2);
    gl64_t kD1594 = tmp3_0 * s1_1594_0;
    gl64_t kE1594 = tmp3_1 * s1_1594_1;
    gl64_t kF1594 = tmp3_2 * s1_1594_2;
    gl64_t kG1594 = kD1594 - kE1594;
    tmp3_6 = (kC1594 + kG1594) - kF1594;
    tmp3_7 = ((((kA1594 + kC1594) - kE1594) - kE1594) - kD1594);
    tmp3_8 = kB1594 - kG1594;
    // Op 1595: dim1x1 sub
    gl64_t s1_1595 = *(gl64_t*)&expressions_params[10][94];
    tmp1_0 = tmp1_4 - s1_1595;
    // Op 1596: dim1x1 sub
    gl64_t s1_1596 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1596;
    // Op 1597: dim3x1 mul
    gl64_t s0_1597_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1597_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1597_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1597_0 * tmp1_0; tmp3_1 = s0_1597_1 * tmp1_0; tmp3_2 = s0_1597_2 * tmp1_0;
    // Op 1598: dim3x1 add
    gl64_t s1_1598 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1598; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1599: dim3x3 add
    gl64_t s1_1599_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1599_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1599_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1599_0; tmp3_1 = tmp3_1 + s1_1599_1; tmp3_2 = tmp3_2 + s1_1599_2;
    // Op 1600: dim3x3 mul
    gl64_t s1_1600_0 = *(gl64_t*)&expressions_params[10][323];
    gl64_t s1_1600_1 = *(gl64_t*)&expressions_params[10][323+1];
    gl64_t s1_1600_2 = *(gl64_t*)&expressions_params[10][323+2];
    gl64_t kA1600 = (tmp3_0 + tmp3_1) * (s1_1600_0 + s1_1600_1);
    gl64_t kB1600 = (tmp3_0 + tmp3_2) * (s1_1600_0 + s1_1600_2);
    gl64_t kC1600 = (tmp3_1 + tmp3_2) * (s1_1600_1 + s1_1600_2);
    gl64_t kD1600 = tmp3_0 * s1_1600_0;
    gl64_t kE1600 = tmp3_1 * s1_1600_1;
    gl64_t kF1600 = tmp3_2 * s1_1600_2;
    gl64_t kG1600 = kD1600 - kE1600;
    tmp3_0 = (kC1600 + kG1600) - kF1600;
    tmp3_1 = ((((kA1600 + kC1600) - kE1600) - kE1600) - kD1600);
    tmp3_2 = kB1600 - kG1600;
    // Op 1601: dim3x1 add
    gl64_t s1_1601 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1601; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1602: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1603: dim3x3 mul
    gl64_t s1_1603_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1603_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1603_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1603 = (tmp3_0 + tmp3_1) * (s1_1603_0 + s1_1603_1);
    gl64_t kB1603 = (tmp3_0 + tmp3_2) * (s1_1603_0 + s1_1603_2);
    gl64_t kC1603 = (tmp3_1 + tmp3_2) * (s1_1603_1 + s1_1603_2);
    gl64_t kD1603 = tmp3_0 * s1_1603_0;
    gl64_t kE1603 = tmp3_1 * s1_1603_1;
    gl64_t kF1603 = tmp3_2 * s1_1603_2;
    gl64_t kG1603 = kD1603 - kE1603;
    tmp3_6 = (kC1603 + kG1603) - kF1603;
    tmp3_7 = ((((kA1603 + kC1603) - kE1603) - kE1603) - kD1603);
    tmp3_8 = kB1603 - kG1603;
    // Op 1604: dim3x1 mul
    gl64_t s0_1604_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1604_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1604_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1604 = *(gl64_t*)&expressions_params[10][57];
    tmp3_0 = s0_1604_0 * s1_1604; tmp3_1 = s0_1604_1 * s1_1604; tmp3_2 = s0_1604_2 * s1_1604;
    // Op 1605: dim3x1 add
    gl64_t s1_1605 = *(gl64_t*)&expressions_params[10][56];
    tmp3_0 = tmp3_0 + s1_1605; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1606: dim3x3 mul
    gl64_t s1_1606_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1606_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1606_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1606 = (tmp3_0 + tmp3_1) * (s1_1606_0 + s1_1606_1);
    gl64_t kB1606 = (tmp3_0 + tmp3_2) * (s1_1606_0 + s1_1606_2);
    gl64_t kC1606 = (tmp3_1 + tmp3_2) * (s1_1606_1 + s1_1606_2);
    gl64_t kD1606 = tmp3_0 * s1_1606_0;
    gl64_t kE1606 = tmp3_1 * s1_1606_1;
    gl64_t kF1606 = tmp3_2 * s1_1606_2;
    gl64_t kG1606 = kD1606 - kE1606;
    tmp3_0 = (kC1606 + kG1606) - kF1606;
    tmp3_1 = ((((kA1606 + kC1606) - kE1606) - kE1606) - kD1606);
    tmp3_2 = kB1606 - kG1606;
    // Op 1607: dim3x1 add
    gl64_t s1_1607 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1607; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1608: dim3x3 mul
    gl64_t s1_1608_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1608_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1608_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1608 = (tmp3_0 + tmp3_1) * (s1_1608_0 + s1_1608_1);
    gl64_t kB1608 = (tmp3_0 + tmp3_2) * (s1_1608_0 + s1_1608_2);
    gl64_t kC1608 = (tmp3_1 + tmp3_2) * (s1_1608_1 + s1_1608_2);
    gl64_t kD1608 = tmp3_0 * s1_1608_0;
    gl64_t kE1608 = tmp3_1 * s1_1608_1;
    gl64_t kF1608 = tmp3_2 * s1_1608_2;
    gl64_t kG1608 = kD1608 - kE1608;
    tmp3_0 = (kC1608 + kG1608) - kF1608;
    tmp3_1 = ((((kA1608 + kC1608) - kE1608) - kE1608) - kD1608);
    tmp3_2 = kB1608 - kG1608;
    // Op 1609: dim3x1 add
    gl64_t s1_1609 = *(gl64_t*)&expressions_params[10][94];
    tmp3_0 = tmp3_0 + s1_1609; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1610: dim3x3 mul
    gl64_t s1_1610_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1610_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1610_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1610 = (tmp3_0 + tmp3_1) * (s1_1610_0 + s1_1610_1);
    gl64_t kB1610 = (tmp3_0 + tmp3_2) * (s1_1610_0 + s1_1610_2);
    gl64_t kC1610 = (tmp3_1 + tmp3_2) * (s1_1610_1 + s1_1610_2);
    gl64_t kD1610 = tmp3_0 * s1_1610_0;
    gl64_t kE1610 = tmp3_1 * s1_1610_1;
    gl64_t kF1610 = tmp3_2 * s1_1610_2;
    gl64_t kG1610 = kD1610 - kE1610;
    tmp3_0 = (kC1610 + kG1610) - kF1610;
    tmp3_1 = ((((kA1610 + kC1610) - kE1610) - kE1610) - kD1610);
    tmp3_2 = kB1610 - kG1610;
    // Op 1611: dim3x1 add
    gl64_t s1_1611 = *(gl64_t*)&expressions_params[9][41];
    tmp3_0 = tmp3_0 + s1_1611; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1612: dim3x3 mul
    gl64_t s1_1612_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1612_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1612_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1612 = (tmp3_0 + tmp3_1) * (s1_1612_0 + s1_1612_1);
    gl64_t kB1612 = (tmp3_0 + tmp3_2) * (s1_1612_0 + s1_1612_2);
    gl64_t kC1612 = (tmp3_1 + tmp3_2) * (s1_1612_1 + s1_1612_2);
    gl64_t kD1612 = tmp3_0 * s1_1612_0;
    gl64_t kE1612 = tmp3_1 * s1_1612_1;
    gl64_t kF1612 = tmp3_2 * s1_1612_2;
    gl64_t kG1612 = kD1612 - kE1612;
    tmp3_0 = (kC1612 + kG1612) - kF1612;
    tmp3_1 = ((((kA1612 + kC1612) - kE1612) - kE1612) - kD1612);
    tmp3_2 = kB1612 - kG1612;
    // Op 1613: dim3x1 add
    gl64_t s1_1613 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1613; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1614: dim3x3 mul
    gl64_t s1_1614_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1614_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1614_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1614 = (tmp3_0 + tmp3_1) * (s1_1614_0 + s1_1614_1);
    gl64_t kB1614 = (tmp3_0 + tmp3_2) * (s1_1614_0 + s1_1614_2);
    gl64_t kC1614 = (tmp3_1 + tmp3_2) * (s1_1614_1 + s1_1614_2);
    gl64_t kD1614 = tmp3_0 * s1_1614_0;
    gl64_t kE1614 = tmp3_1 * s1_1614_1;
    gl64_t kF1614 = tmp3_2 * s1_1614_2;
    gl64_t kG1614 = kD1614 - kE1614;
    tmp3_0 = (kC1614 + kG1614) - kF1614;
    tmp3_1 = ((((kA1614 + kC1614) - kE1614) - kE1614) - kD1614);
    tmp3_2 = kB1614 - kG1614;
    // Op 1615: dim3x1 add
    gl64_t s1_1615 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1615; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1616: dim3x3 add
    gl64_t s1_1616_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1616_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1616_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1616_0; tmp3_1 = tmp3_1 + s1_1616_1; tmp3_2 = tmp3_2 + s1_1616_2;
    // Op 1617: dim3x3 mul
    gl64_t s1_1617_0 = *(gl64_t*)&expressions_params[10][326];
    gl64_t s1_1617_1 = *(gl64_t*)&expressions_params[10][326+1];
    gl64_t s1_1617_2 = *(gl64_t*)&expressions_params[10][326+2];
    gl64_t kA1617 = (tmp3_0 + tmp3_1) * (s1_1617_0 + s1_1617_1);
    gl64_t kB1617 = (tmp3_0 + tmp3_2) * (s1_1617_0 + s1_1617_2);
    gl64_t kC1617 = (tmp3_1 + tmp3_2) * (s1_1617_1 + s1_1617_2);
    gl64_t kD1617 = tmp3_0 * s1_1617_0;
    gl64_t kE1617 = tmp3_1 * s1_1617_1;
    gl64_t kF1617 = tmp3_2 * s1_1617_2;
    gl64_t kG1617 = kD1617 - kE1617;
    tmp3_0 = (kC1617 + kG1617) - kF1617;
    tmp3_1 = ((((kA1617 + kC1617) - kE1617) - kE1617) - kD1617);
    tmp3_2 = kB1617 - kG1617;
    // Op 1618: dim3x1 sub
    gl64_t s1_1618 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1618; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1619: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1620: dim3x3 mul
    gl64_t s1_1620_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1620_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1620_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1620 = (tmp3_0 + tmp3_1) * (s1_1620_0 + s1_1620_1);
    gl64_t kB1620 = (tmp3_0 + tmp3_2) * (s1_1620_0 + s1_1620_2);
    gl64_t kC1620 = (tmp3_1 + tmp3_2) * (s1_1620_1 + s1_1620_2);
    gl64_t kD1620 = tmp3_0 * s1_1620_0;
    gl64_t kE1620 = tmp3_1 * s1_1620_1;
    gl64_t kF1620 = tmp3_2 * s1_1620_2;
    gl64_t kG1620 = kD1620 - kE1620;
    tmp3_6 = (kC1620 + kG1620) - kF1620;
    tmp3_7 = ((((kA1620 + kC1620) - kE1620) - kE1620) - kD1620);
    tmp3_8 = kB1620 - kG1620;
    // Op 1621: dim3x1 mul
    gl64_t s0_1621_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1621_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1621_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1621 = *(gl64_t*)&expressions_params[10][57];
    tmp3_0 = s0_1621_0 * s1_1621; tmp3_1 = s0_1621_1 * s1_1621; tmp3_2 = s0_1621_2 * s1_1621;
    // Op 1622: dim3x1 add
    gl64_t s1_1622 = *(gl64_t*)&expressions_params[10][56];
    tmp3_0 = tmp3_0 + s1_1622; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1623: dim3x3 mul
    gl64_t s1_1623_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1623_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1623_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1623 = (tmp3_0 + tmp3_1) * (s1_1623_0 + s1_1623_1);
    gl64_t kB1623 = (tmp3_0 + tmp3_2) * (s1_1623_0 + s1_1623_2);
    gl64_t kC1623 = (tmp3_1 + tmp3_2) * (s1_1623_1 + s1_1623_2);
    gl64_t kD1623 = tmp3_0 * s1_1623_0;
    gl64_t kE1623 = tmp3_1 * s1_1623_1;
    gl64_t kF1623 = tmp3_2 * s1_1623_2;
    gl64_t kG1623 = kD1623 - kE1623;
    tmp3_0 = (kC1623 + kG1623) - kF1623;
    tmp3_1 = ((((kA1623 + kC1623) - kE1623) - kE1623) - kD1623);
    tmp3_2 = kB1623 - kG1623;
    // Op 1624: dim3x1 add
    gl64_t s1_1624 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1624; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1625: dim3x3 mul
    gl64_t s1_1625_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1625_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1625_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1625 = (tmp3_0 + tmp3_1) * (s1_1625_0 + s1_1625_1);
    gl64_t kB1625 = (tmp3_0 + tmp3_2) * (s1_1625_0 + s1_1625_2);
    gl64_t kC1625 = (tmp3_1 + tmp3_2) * (s1_1625_1 + s1_1625_2);
    gl64_t kD1625 = tmp3_0 * s1_1625_0;
    gl64_t kE1625 = tmp3_1 * s1_1625_1;
    gl64_t kF1625 = tmp3_2 * s1_1625_2;
    gl64_t kG1625 = kD1625 - kE1625;
    tmp3_0 = (kC1625 + kG1625) - kF1625;
    tmp3_1 = ((((kA1625 + kC1625) - kE1625) - kE1625) - kD1625);
    tmp3_2 = kB1625 - kG1625;
    // Op 1626: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1627: dim3x3 mul
    gl64_t s1_1627_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1627_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1627_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1627 = (tmp3_0 + tmp3_1) * (s1_1627_0 + s1_1627_1);
    gl64_t kB1627 = (tmp3_0 + tmp3_2) * (s1_1627_0 + s1_1627_2);
    gl64_t kC1627 = (tmp3_1 + tmp3_2) * (s1_1627_1 + s1_1627_2);
    gl64_t kD1627 = tmp3_0 * s1_1627_0;
    gl64_t kE1627 = tmp3_1 * s1_1627_1;
    gl64_t kF1627 = tmp3_2 * s1_1627_2;
    gl64_t kG1627 = kD1627 - kE1627;
    tmp3_0 = (kC1627 + kG1627) - kF1627;
    tmp3_1 = ((((kA1627 + kC1627) - kE1627) - kE1627) - kD1627);
    tmp3_2 = kB1627 - kG1627;
    // Op 1628: dim3x1 add
    gl64_t s1_1628 = *(gl64_t*)&expressions_params[9][41];
    tmp3_0 = tmp3_0 + s1_1628; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1629: dim3x3 mul
    gl64_t s1_1629_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1629_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1629_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1629 = (tmp3_0 + tmp3_1) * (s1_1629_0 + s1_1629_1);
    gl64_t kB1629 = (tmp3_0 + tmp3_2) * (s1_1629_0 + s1_1629_2);
    gl64_t kC1629 = (tmp3_1 + tmp3_2) * (s1_1629_1 + s1_1629_2);
    gl64_t kD1629 = tmp3_0 * s1_1629_0;
    gl64_t kE1629 = tmp3_1 * s1_1629_1;
    gl64_t kF1629 = tmp3_2 * s1_1629_2;
    gl64_t kG1629 = kD1629 - kE1629;
    tmp3_0 = (kC1629 + kG1629) - kF1629;
    tmp3_1 = ((((kA1629 + kC1629) - kE1629) - kE1629) - kD1629);
    tmp3_2 = kB1629 - kG1629;
    // Op 1630: dim3x1 add
    gl64_t s1_1630 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1630; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1631: dim3x3 mul
    gl64_t s1_1631_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1631_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1631_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1631 = (tmp3_0 + tmp3_1) * (s1_1631_0 + s1_1631_1);
    gl64_t kB1631 = (tmp3_0 + tmp3_2) * (s1_1631_0 + s1_1631_2);
    gl64_t kC1631 = (tmp3_1 + tmp3_2) * (s1_1631_1 + s1_1631_2);
    gl64_t kD1631 = tmp3_0 * s1_1631_0;
    gl64_t kE1631 = tmp3_1 * s1_1631_1;
    gl64_t kF1631 = tmp3_2 * s1_1631_2;
    gl64_t kG1631 = kD1631 - kE1631;
    tmp3_0 = (kC1631 + kG1631) - kF1631;
    tmp3_1 = ((((kA1631 + kC1631) - kE1631) - kE1631) - kD1631);
    tmp3_2 = kB1631 - kG1631;
    // Op 1632: dim3x1 add
    gl64_t s1_1632 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1632; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1633: dim3x3 add
    gl64_t s1_1633_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1633_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1633_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1633_0; tmp3_1 = tmp3_1 + s1_1633_1; tmp3_2 = tmp3_2 + s1_1633_2;
    // Op 1634: dim3x3 mul
    gl64_t s1_1634_0 = *(gl64_t*)&expressions_params[10][329];
    gl64_t s1_1634_1 = *(gl64_t*)&expressions_params[10][329+1];
    gl64_t s1_1634_2 = *(gl64_t*)&expressions_params[10][329+2];
    gl64_t kA1634 = (tmp3_0 + tmp3_1) * (s1_1634_0 + s1_1634_1);
    gl64_t kB1634 = (tmp3_0 + tmp3_2) * (s1_1634_0 + s1_1634_2);
    gl64_t kC1634 = (tmp3_1 + tmp3_2) * (s1_1634_1 + s1_1634_2);
    gl64_t kD1634 = tmp3_0 * s1_1634_0;
    gl64_t kE1634 = tmp3_1 * s1_1634_1;
    gl64_t kF1634 = tmp3_2 * s1_1634_2;
    gl64_t kG1634 = kD1634 - kE1634;
    tmp3_0 = (kC1634 + kG1634) - kF1634;
    tmp3_1 = ((((kA1634 + kC1634) - kE1634) - kE1634) - kD1634);
    tmp3_2 = kB1634 - kG1634;
    // Op 1635: dim1x1 sub
    gl64_t s0_1635 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1635 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1635 - s1_1635;
    // Op 1636: dim1x1 sub_swap
    gl64_t s1_1636 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1636 - tmp1_0;
    // Op 1637: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1638: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1639: dim3x3 mul
    gl64_t s1_1639_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1639_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1639_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1639 = (tmp3_0 + tmp3_1) * (s1_1639_0 + s1_1639_1);
    gl64_t kB1639 = (tmp3_0 + tmp3_2) * (s1_1639_0 + s1_1639_2);
    gl64_t kC1639 = (tmp3_1 + tmp3_2) * (s1_1639_1 + s1_1639_2);
    gl64_t kD1639 = tmp3_0 * s1_1639_0;
    gl64_t kE1639 = tmp3_1 * s1_1639_1;
    gl64_t kF1639 = tmp3_2 * s1_1639_2;
    gl64_t kG1639 = kD1639 - kE1639;
    tmp3_6 = (kC1639 + kG1639) - kF1639;
    tmp3_7 = ((((kA1639 + kC1639) - kE1639) - kE1639) - kD1639);
    tmp3_8 = kB1639 - kG1639;
    // Op 1640: dim1x1 sub
    gl64_t s1_1640 = *(gl64_t*)&expressions_params[10][95];
    tmp1_0 = tmp1_4 - s1_1640;
    // Op 1641: dim1x1 sub
    gl64_t s1_1641 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1641;
    // Op 1642: dim3x1 mul
    gl64_t s0_1642_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1642_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1642_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1642_0 * tmp1_0; tmp3_1 = s0_1642_1 * tmp1_0; tmp3_2 = s0_1642_2 * tmp1_0;
    // Op 1643: dim3x1 add
    gl64_t s1_1643 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1643; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1644: dim3x3 add
    gl64_t s1_1644_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1644_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1644_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1644_0; tmp3_1 = tmp3_1 + s1_1644_1; tmp3_2 = tmp3_2 + s1_1644_2;
    // Op 1645: dim3x3 mul
    gl64_t s1_1645_0 = *(gl64_t*)&expressions_params[10][332];
    gl64_t s1_1645_1 = *(gl64_t*)&expressions_params[10][332+1];
    gl64_t s1_1645_2 = *(gl64_t*)&expressions_params[10][332+2];
    gl64_t kA1645 = (tmp3_0 + tmp3_1) * (s1_1645_0 + s1_1645_1);
    gl64_t kB1645 = (tmp3_0 + tmp3_2) * (s1_1645_0 + s1_1645_2);
    gl64_t kC1645 = (tmp3_1 + tmp3_2) * (s1_1645_1 + s1_1645_2);
    gl64_t kD1645 = tmp3_0 * s1_1645_0;
    gl64_t kE1645 = tmp3_1 * s1_1645_1;
    gl64_t kF1645 = tmp3_2 * s1_1645_2;
    gl64_t kG1645 = kD1645 - kE1645;
    tmp3_0 = (kC1645 + kG1645) - kF1645;
    tmp3_1 = ((((kA1645 + kC1645) - kE1645) - kE1645) - kD1645);
    tmp3_2 = kB1645 - kG1645;
    // Op 1646: dim3x1 add
    gl64_t s1_1646 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1646; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1647: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1648: dim3x3 mul
    gl64_t s1_1648_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1648_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1648_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1648 = (tmp3_0 + tmp3_1) * (s1_1648_0 + s1_1648_1);
    gl64_t kB1648 = (tmp3_0 + tmp3_2) * (s1_1648_0 + s1_1648_2);
    gl64_t kC1648 = (tmp3_1 + tmp3_2) * (s1_1648_1 + s1_1648_2);
    gl64_t kD1648 = tmp3_0 * s1_1648_0;
    gl64_t kE1648 = tmp3_1 * s1_1648_1;
    gl64_t kF1648 = tmp3_2 * s1_1648_2;
    gl64_t kG1648 = kD1648 - kE1648;
    tmp3_6 = (kC1648 + kG1648) - kF1648;
    tmp3_7 = ((((kA1648 + kC1648) - kE1648) - kE1648) - kD1648);
    tmp3_8 = kB1648 - kG1648;
    // Op 1649: dim3x1 mul
    gl64_t s0_1649_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1649_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1649_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1649 = *(gl64_t*)&expressions_params[10][59];
    tmp3_0 = s0_1649_0 * s1_1649; tmp3_1 = s0_1649_1 * s1_1649; tmp3_2 = s0_1649_2 * s1_1649;
    // Op 1650: dim3x1 add
    gl64_t s1_1650 = *(gl64_t*)&expressions_params[10][58];
    tmp3_0 = tmp3_0 + s1_1650; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1651: dim3x3 mul
    gl64_t s1_1651_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1651_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1651_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1651 = (tmp3_0 + tmp3_1) * (s1_1651_0 + s1_1651_1);
    gl64_t kB1651 = (tmp3_0 + tmp3_2) * (s1_1651_0 + s1_1651_2);
    gl64_t kC1651 = (tmp3_1 + tmp3_2) * (s1_1651_1 + s1_1651_2);
    gl64_t kD1651 = tmp3_0 * s1_1651_0;
    gl64_t kE1651 = tmp3_1 * s1_1651_1;
    gl64_t kF1651 = tmp3_2 * s1_1651_2;
    gl64_t kG1651 = kD1651 - kE1651;
    tmp3_0 = (kC1651 + kG1651) - kF1651;
    tmp3_1 = ((((kA1651 + kC1651) - kE1651) - kE1651) - kD1651);
    tmp3_2 = kB1651 - kG1651;
    // Op 1652: dim3x1 add
    gl64_t s1_1652 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1652; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1653: dim3x3 mul
    gl64_t s1_1653_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1653_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1653_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1653 = (tmp3_0 + tmp3_1) * (s1_1653_0 + s1_1653_1);
    gl64_t kB1653 = (tmp3_0 + tmp3_2) * (s1_1653_0 + s1_1653_2);
    gl64_t kC1653 = (tmp3_1 + tmp3_2) * (s1_1653_1 + s1_1653_2);
    gl64_t kD1653 = tmp3_0 * s1_1653_0;
    gl64_t kE1653 = tmp3_1 * s1_1653_1;
    gl64_t kF1653 = tmp3_2 * s1_1653_2;
    gl64_t kG1653 = kD1653 - kE1653;
    tmp3_0 = (kC1653 + kG1653) - kF1653;
    tmp3_1 = ((((kA1653 + kC1653) - kE1653) - kE1653) - kD1653);
    tmp3_2 = kB1653 - kG1653;
    // Op 1654: dim3x1 add
    gl64_t s1_1654 = *(gl64_t*)&expressions_params[10][95];
    tmp3_0 = tmp3_0 + s1_1654; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1655: dim3x3 mul
    gl64_t s1_1655_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1655_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1655_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1655 = (tmp3_0 + tmp3_1) * (s1_1655_0 + s1_1655_1);
    gl64_t kB1655 = (tmp3_0 + tmp3_2) * (s1_1655_0 + s1_1655_2);
    gl64_t kC1655 = (tmp3_1 + tmp3_2) * (s1_1655_1 + s1_1655_2);
    gl64_t kD1655 = tmp3_0 * s1_1655_0;
    gl64_t kE1655 = tmp3_1 * s1_1655_1;
    gl64_t kF1655 = tmp3_2 * s1_1655_2;
    gl64_t kG1655 = kD1655 - kE1655;
    tmp3_0 = (kC1655 + kG1655) - kF1655;
    tmp3_1 = ((((kA1655 + kC1655) - kE1655) - kE1655) - kD1655);
    tmp3_2 = kB1655 - kG1655;
    // Op 1656: dim3x1 add
    gl64_t s1_1656 = *(gl64_t*)&expressions_params[9][42];
    tmp3_0 = tmp3_0 + s1_1656; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1657: dim3x3 mul
    gl64_t s1_1657_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1657_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1657_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1657 = (tmp3_0 + tmp3_1) * (s1_1657_0 + s1_1657_1);
    gl64_t kB1657 = (tmp3_0 + tmp3_2) * (s1_1657_0 + s1_1657_2);
    gl64_t kC1657 = (tmp3_1 + tmp3_2) * (s1_1657_1 + s1_1657_2);
    gl64_t kD1657 = tmp3_0 * s1_1657_0;
    gl64_t kE1657 = tmp3_1 * s1_1657_1;
    gl64_t kF1657 = tmp3_2 * s1_1657_2;
    gl64_t kG1657 = kD1657 - kE1657;
    tmp3_0 = (kC1657 + kG1657) - kF1657;
    tmp3_1 = ((((kA1657 + kC1657) - kE1657) - kE1657) - kD1657);
    tmp3_2 = kB1657 - kG1657;
    // Op 1658: dim3x1 add
    gl64_t s1_1658 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1658; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1659: dim3x3 mul
    gl64_t s1_1659_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1659_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1659_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1659 = (tmp3_0 + tmp3_1) * (s1_1659_0 + s1_1659_1);
    gl64_t kB1659 = (tmp3_0 + tmp3_2) * (s1_1659_0 + s1_1659_2);
    gl64_t kC1659 = (tmp3_1 + tmp3_2) * (s1_1659_1 + s1_1659_2);
    gl64_t kD1659 = tmp3_0 * s1_1659_0;
    gl64_t kE1659 = tmp3_1 * s1_1659_1;
    gl64_t kF1659 = tmp3_2 * s1_1659_2;
    gl64_t kG1659 = kD1659 - kE1659;
    tmp3_0 = (kC1659 + kG1659) - kF1659;
    tmp3_1 = ((((kA1659 + kC1659) - kE1659) - kE1659) - kD1659);
    tmp3_2 = kB1659 - kG1659;
    // Op 1660: dim3x1 add
    gl64_t s1_1660 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1660; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1661: dim3x3 add
    gl64_t s1_1661_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1661_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1661_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1661_0; tmp3_1 = tmp3_1 + s1_1661_1; tmp3_2 = tmp3_2 + s1_1661_2;
    // Op 1662: dim3x3 mul
    gl64_t s1_1662_0 = *(gl64_t*)&expressions_params[10][335];
    gl64_t s1_1662_1 = *(gl64_t*)&expressions_params[10][335+1];
    gl64_t s1_1662_2 = *(gl64_t*)&expressions_params[10][335+2];
    gl64_t kA1662 = (tmp3_0 + tmp3_1) * (s1_1662_0 + s1_1662_1);
    gl64_t kB1662 = (tmp3_0 + tmp3_2) * (s1_1662_0 + s1_1662_2);
    gl64_t kC1662 = (tmp3_1 + tmp3_2) * (s1_1662_1 + s1_1662_2);
    gl64_t kD1662 = tmp3_0 * s1_1662_0;
    gl64_t kE1662 = tmp3_1 * s1_1662_1;
    gl64_t kF1662 = tmp3_2 * s1_1662_2;
    gl64_t kG1662 = kD1662 - kE1662;
    tmp3_0 = (kC1662 + kG1662) - kF1662;
    tmp3_1 = ((((kA1662 + kC1662) - kE1662) - kE1662) - kD1662);
    tmp3_2 = kB1662 - kG1662;
    // Op 1663: dim3x1 sub
    gl64_t s1_1663 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1663; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1664: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1665: dim3x3 mul
    gl64_t s1_1665_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1665_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1665_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1665 = (tmp3_0 + tmp3_1) * (s1_1665_0 + s1_1665_1);
    gl64_t kB1665 = (tmp3_0 + tmp3_2) * (s1_1665_0 + s1_1665_2);
    gl64_t kC1665 = (tmp3_1 + tmp3_2) * (s1_1665_1 + s1_1665_2);
    gl64_t kD1665 = tmp3_0 * s1_1665_0;
    gl64_t kE1665 = tmp3_1 * s1_1665_1;
    gl64_t kF1665 = tmp3_2 * s1_1665_2;
    gl64_t kG1665 = kD1665 - kE1665;
    tmp3_6 = (kC1665 + kG1665) - kF1665;
    tmp3_7 = ((((kA1665 + kC1665) - kE1665) - kE1665) - kD1665);
    tmp3_8 = kB1665 - kG1665;
    // Op 1666: dim3x1 mul
    gl64_t s0_1666_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1666_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1666_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1666 = *(gl64_t*)&expressions_params[10][59];
    tmp3_0 = s0_1666_0 * s1_1666; tmp3_1 = s0_1666_1 * s1_1666; tmp3_2 = s0_1666_2 * s1_1666;
    // Op 1667: dim3x1 add
    gl64_t s1_1667 = *(gl64_t*)&expressions_params[10][58];
    tmp3_0 = tmp3_0 + s1_1667; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1668: dim3x3 mul
    gl64_t s1_1668_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1668_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1668_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1668 = (tmp3_0 + tmp3_1) * (s1_1668_0 + s1_1668_1);
    gl64_t kB1668 = (tmp3_0 + tmp3_2) * (s1_1668_0 + s1_1668_2);
    gl64_t kC1668 = (tmp3_1 + tmp3_2) * (s1_1668_1 + s1_1668_2);
    gl64_t kD1668 = tmp3_0 * s1_1668_0;
    gl64_t kE1668 = tmp3_1 * s1_1668_1;
    gl64_t kF1668 = tmp3_2 * s1_1668_2;
    gl64_t kG1668 = kD1668 - kE1668;
    tmp3_0 = (kC1668 + kG1668) - kF1668;
    tmp3_1 = ((((kA1668 + kC1668) - kE1668) - kE1668) - kD1668);
    tmp3_2 = kB1668 - kG1668;
    // Op 1669: dim3x1 add
    gl64_t s1_1669 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1669; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1670: dim3x3 mul
    gl64_t s1_1670_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1670_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1670_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1670 = (tmp3_0 + tmp3_1) * (s1_1670_0 + s1_1670_1);
    gl64_t kB1670 = (tmp3_0 + tmp3_2) * (s1_1670_0 + s1_1670_2);
    gl64_t kC1670 = (tmp3_1 + tmp3_2) * (s1_1670_1 + s1_1670_2);
    gl64_t kD1670 = tmp3_0 * s1_1670_0;
    gl64_t kE1670 = tmp3_1 * s1_1670_1;
    gl64_t kF1670 = tmp3_2 * s1_1670_2;
    gl64_t kG1670 = kD1670 - kE1670;
    tmp3_0 = (kC1670 + kG1670) - kF1670;
    tmp3_1 = ((((kA1670 + kC1670) - kE1670) - kE1670) - kD1670);
    tmp3_2 = kB1670 - kG1670;
    // Op 1671: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1672: dim3x3 mul
    gl64_t s1_1672_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1672_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1672_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1672 = (tmp3_0 + tmp3_1) * (s1_1672_0 + s1_1672_1);
    gl64_t kB1672 = (tmp3_0 + tmp3_2) * (s1_1672_0 + s1_1672_2);
    gl64_t kC1672 = (tmp3_1 + tmp3_2) * (s1_1672_1 + s1_1672_2);
    gl64_t kD1672 = tmp3_0 * s1_1672_0;
    gl64_t kE1672 = tmp3_1 * s1_1672_1;
    gl64_t kF1672 = tmp3_2 * s1_1672_2;
    gl64_t kG1672 = kD1672 - kE1672;
    tmp3_0 = (kC1672 + kG1672) - kF1672;
    tmp3_1 = ((((kA1672 + kC1672) - kE1672) - kE1672) - kD1672);
    tmp3_2 = kB1672 - kG1672;
    // Op 1673: dim3x1 add
    gl64_t s1_1673 = *(gl64_t*)&expressions_params[9][42];
    tmp3_0 = tmp3_0 + s1_1673; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1674: dim3x3 mul
    gl64_t s1_1674_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1674_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1674_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1674 = (tmp3_0 + tmp3_1) * (s1_1674_0 + s1_1674_1);
    gl64_t kB1674 = (tmp3_0 + tmp3_2) * (s1_1674_0 + s1_1674_2);
    gl64_t kC1674 = (tmp3_1 + tmp3_2) * (s1_1674_1 + s1_1674_2);
    gl64_t kD1674 = tmp3_0 * s1_1674_0;
    gl64_t kE1674 = tmp3_1 * s1_1674_1;
    gl64_t kF1674 = tmp3_2 * s1_1674_2;
    gl64_t kG1674 = kD1674 - kE1674;
    tmp3_0 = (kC1674 + kG1674) - kF1674;
    tmp3_1 = ((((kA1674 + kC1674) - kE1674) - kE1674) - kD1674);
    tmp3_2 = kB1674 - kG1674;
    // Op 1675: dim3x1 add
    gl64_t s1_1675 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1675; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1676: dim3x3 mul
    gl64_t s1_1676_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1676_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1676_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1676 = (tmp3_0 + tmp3_1) * (s1_1676_0 + s1_1676_1);
    gl64_t kB1676 = (tmp3_0 + tmp3_2) * (s1_1676_0 + s1_1676_2);
    gl64_t kC1676 = (tmp3_1 + tmp3_2) * (s1_1676_1 + s1_1676_2);
    gl64_t kD1676 = tmp3_0 * s1_1676_0;
    gl64_t kE1676 = tmp3_1 * s1_1676_1;
    gl64_t kF1676 = tmp3_2 * s1_1676_2;
    gl64_t kG1676 = kD1676 - kE1676;
    tmp3_0 = (kC1676 + kG1676) - kF1676;
    tmp3_1 = ((((kA1676 + kC1676) - kE1676) - kE1676) - kD1676);
    tmp3_2 = kB1676 - kG1676;
    // Op 1677: dim3x1 add
    gl64_t s1_1677 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1677; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1678: dim3x3 add
    gl64_t s1_1678_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1678_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1678_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1678_0; tmp3_1 = tmp3_1 + s1_1678_1; tmp3_2 = tmp3_2 + s1_1678_2;
    // Op 1679: dim3x3 mul
    gl64_t s1_1679_0 = *(gl64_t*)&expressions_params[10][338];
    gl64_t s1_1679_1 = *(gl64_t*)&expressions_params[10][338+1];
    gl64_t s1_1679_2 = *(gl64_t*)&expressions_params[10][338+2];
    gl64_t kA1679 = (tmp3_0 + tmp3_1) * (s1_1679_0 + s1_1679_1);
    gl64_t kB1679 = (tmp3_0 + tmp3_2) * (s1_1679_0 + s1_1679_2);
    gl64_t kC1679 = (tmp3_1 + tmp3_2) * (s1_1679_1 + s1_1679_2);
    gl64_t kD1679 = tmp3_0 * s1_1679_0;
    gl64_t kE1679 = tmp3_1 * s1_1679_1;
    gl64_t kF1679 = tmp3_2 * s1_1679_2;
    gl64_t kG1679 = kD1679 - kE1679;
    tmp3_0 = (kC1679 + kG1679) - kF1679;
    tmp3_1 = ((((kA1679 + kC1679) - kE1679) - kE1679) - kD1679);
    tmp3_2 = kB1679 - kG1679;
    // Op 1680: dim1x1 sub
    gl64_t s0_1680 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1680 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1680 - s1_1680;
    // Op 1681: dim1x1 sub_swap
    gl64_t s1_1681 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1681 - tmp1_0;
    // Op 1682: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1683: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1684: dim3x3 mul
    gl64_t s1_1684_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1684_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1684_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1684 = (tmp3_0 + tmp3_1) * (s1_1684_0 + s1_1684_1);
    gl64_t kB1684 = (tmp3_0 + tmp3_2) * (s1_1684_0 + s1_1684_2);
    gl64_t kC1684 = (tmp3_1 + tmp3_2) * (s1_1684_1 + s1_1684_2);
    gl64_t kD1684 = tmp3_0 * s1_1684_0;
    gl64_t kE1684 = tmp3_1 * s1_1684_1;
    gl64_t kF1684 = tmp3_2 * s1_1684_2;
    gl64_t kG1684 = kD1684 - kE1684;
    tmp3_6 = (kC1684 + kG1684) - kF1684;
    tmp3_7 = ((((kA1684 + kC1684) - kE1684) - kE1684) - kD1684);
    tmp3_8 = kB1684 - kG1684;
    // Op 1685: dim1x1 sub
    gl64_t s1_1685 = *(gl64_t*)&expressions_params[10][96];
    tmp1_0 = tmp1_4 - s1_1685;
    // Op 1686: dim1x1 sub
    gl64_t s1_1686 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1686;
    // Op 1687: dim3x1 mul
    gl64_t s0_1687_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1687_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1687_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1687_0 * tmp1_0; tmp3_1 = s0_1687_1 * tmp1_0; tmp3_2 = s0_1687_2 * tmp1_0;
    // Op 1688: dim3x1 add
    gl64_t s1_1688 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1688; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1689: dim3x3 add
    gl64_t s1_1689_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1689_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1689_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1689_0; tmp3_1 = tmp3_1 + s1_1689_1; tmp3_2 = tmp3_2 + s1_1689_2;
    // Op 1690: dim3x3 mul
    gl64_t s1_1690_0 = *(gl64_t*)&expressions_params[10][341];
    gl64_t s1_1690_1 = *(gl64_t*)&expressions_params[10][341+1];
    gl64_t s1_1690_2 = *(gl64_t*)&expressions_params[10][341+2];
    gl64_t kA1690 = (tmp3_0 + tmp3_1) * (s1_1690_0 + s1_1690_1);
    gl64_t kB1690 = (tmp3_0 + tmp3_2) * (s1_1690_0 + s1_1690_2);
    gl64_t kC1690 = (tmp3_1 + tmp3_2) * (s1_1690_1 + s1_1690_2);
    gl64_t kD1690 = tmp3_0 * s1_1690_0;
    gl64_t kE1690 = tmp3_1 * s1_1690_1;
    gl64_t kF1690 = tmp3_2 * s1_1690_2;
    gl64_t kG1690 = kD1690 - kE1690;
    tmp3_0 = (kC1690 + kG1690) - kF1690;
    tmp3_1 = ((((kA1690 + kC1690) - kE1690) - kE1690) - kD1690);
    tmp3_2 = kB1690 - kG1690;
    // Op 1691: dim3x1 add
    gl64_t s1_1691 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1691; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1692: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1693: dim3x3 mul
    gl64_t s1_1693_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1693_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1693_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1693 = (tmp3_0 + tmp3_1) * (s1_1693_0 + s1_1693_1);
    gl64_t kB1693 = (tmp3_0 + tmp3_2) * (s1_1693_0 + s1_1693_2);
    gl64_t kC1693 = (tmp3_1 + tmp3_2) * (s1_1693_1 + s1_1693_2);
    gl64_t kD1693 = tmp3_0 * s1_1693_0;
    gl64_t kE1693 = tmp3_1 * s1_1693_1;
    gl64_t kF1693 = tmp3_2 * s1_1693_2;
    gl64_t kG1693 = kD1693 - kE1693;
    tmp3_6 = (kC1693 + kG1693) - kF1693;
    tmp3_7 = ((((kA1693 + kC1693) - kE1693) - kE1693) - kD1693);
    tmp3_8 = kB1693 - kG1693;
    // Op 1694: dim3x1 mul
    gl64_t s0_1694_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1694_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1694_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1694 = *(gl64_t*)&expressions_params[10][61];
    tmp3_0 = s0_1694_0 * s1_1694; tmp3_1 = s0_1694_1 * s1_1694; tmp3_2 = s0_1694_2 * s1_1694;
    // Op 1695: dim3x1 add
    gl64_t s1_1695 = *(gl64_t*)&expressions_params[10][60];
    tmp3_0 = tmp3_0 + s1_1695; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1696: dim3x3 mul
    gl64_t s1_1696_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1696_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1696_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1696 = (tmp3_0 + tmp3_1) * (s1_1696_0 + s1_1696_1);
    gl64_t kB1696 = (tmp3_0 + tmp3_2) * (s1_1696_0 + s1_1696_2);
    gl64_t kC1696 = (tmp3_1 + tmp3_2) * (s1_1696_1 + s1_1696_2);
    gl64_t kD1696 = tmp3_0 * s1_1696_0;
    gl64_t kE1696 = tmp3_1 * s1_1696_1;
    gl64_t kF1696 = tmp3_2 * s1_1696_2;
    gl64_t kG1696 = kD1696 - kE1696;
    tmp3_0 = (kC1696 + kG1696) - kF1696;
    tmp3_1 = ((((kA1696 + kC1696) - kE1696) - kE1696) - kD1696);
    tmp3_2 = kB1696 - kG1696;
    // Op 1697: dim3x1 add
    gl64_t s1_1697 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1697; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1698: dim3x3 mul
    gl64_t s1_1698_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1698_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1698_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1698 = (tmp3_0 + tmp3_1) * (s1_1698_0 + s1_1698_1);
    gl64_t kB1698 = (tmp3_0 + tmp3_2) * (s1_1698_0 + s1_1698_2);
    gl64_t kC1698 = (tmp3_1 + tmp3_2) * (s1_1698_1 + s1_1698_2);
    gl64_t kD1698 = tmp3_0 * s1_1698_0;
    gl64_t kE1698 = tmp3_1 * s1_1698_1;
    gl64_t kF1698 = tmp3_2 * s1_1698_2;
    gl64_t kG1698 = kD1698 - kE1698;
    tmp3_0 = (kC1698 + kG1698) - kF1698;
    tmp3_1 = ((((kA1698 + kC1698) - kE1698) - kE1698) - kD1698);
    tmp3_2 = kB1698 - kG1698;
    // Op 1699: dim3x1 add
    gl64_t s1_1699 = *(gl64_t*)&expressions_params[10][96];
    tmp3_0 = tmp3_0 + s1_1699; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1700: dim3x3 mul
    gl64_t s1_1700_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1700_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1700_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1700 = (tmp3_0 + tmp3_1) * (s1_1700_0 + s1_1700_1);
    gl64_t kB1700 = (tmp3_0 + tmp3_2) * (s1_1700_0 + s1_1700_2);
    gl64_t kC1700 = (tmp3_1 + tmp3_2) * (s1_1700_1 + s1_1700_2);
    gl64_t kD1700 = tmp3_0 * s1_1700_0;
    gl64_t kE1700 = tmp3_1 * s1_1700_1;
    gl64_t kF1700 = tmp3_2 * s1_1700_2;
    gl64_t kG1700 = kD1700 - kE1700;
    tmp3_0 = (kC1700 + kG1700) - kF1700;
    tmp3_1 = ((((kA1700 + kC1700) - kE1700) - kE1700) - kD1700);
    tmp3_2 = kB1700 - kG1700;
    // Op 1701: dim3x1 add
    gl64_t s1_1701 = *(gl64_t*)&expressions_params[9][43];
    tmp3_0 = tmp3_0 + s1_1701; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1702: dim3x3 mul
    gl64_t s1_1702_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1702_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1702_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1702 = (tmp3_0 + tmp3_1) * (s1_1702_0 + s1_1702_1);
    gl64_t kB1702 = (tmp3_0 + tmp3_2) * (s1_1702_0 + s1_1702_2);
    gl64_t kC1702 = (tmp3_1 + tmp3_2) * (s1_1702_1 + s1_1702_2);
    gl64_t kD1702 = tmp3_0 * s1_1702_0;
    gl64_t kE1702 = tmp3_1 * s1_1702_1;
    gl64_t kF1702 = tmp3_2 * s1_1702_2;
    gl64_t kG1702 = kD1702 - kE1702;
    tmp3_0 = (kC1702 + kG1702) - kF1702;
    tmp3_1 = ((((kA1702 + kC1702) - kE1702) - kE1702) - kD1702);
    tmp3_2 = kB1702 - kG1702;
    // Op 1703: dim3x1 add
    gl64_t s1_1703 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1703; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1704: dim3x3 mul
    gl64_t s1_1704_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1704_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1704_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1704 = (tmp3_0 + tmp3_1) * (s1_1704_0 + s1_1704_1);
    gl64_t kB1704 = (tmp3_0 + tmp3_2) * (s1_1704_0 + s1_1704_2);
    gl64_t kC1704 = (tmp3_1 + tmp3_2) * (s1_1704_1 + s1_1704_2);
    gl64_t kD1704 = tmp3_0 * s1_1704_0;
    gl64_t kE1704 = tmp3_1 * s1_1704_1;
    gl64_t kF1704 = tmp3_2 * s1_1704_2;
    gl64_t kG1704 = kD1704 - kE1704;
    tmp3_0 = (kC1704 + kG1704) - kF1704;
    tmp3_1 = ((((kA1704 + kC1704) - kE1704) - kE1704) - kD1704);
    tmp3_2 = kB1704 - kG1704;
    // Op 1705: dim3x1 add
    gl64_t s1_1705 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1705; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1706: dim3x3 add
    gl64_t s1_1706_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1706_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1706_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1706_0; tmp3_1 = tmp3_1 + s1_1706_1; tmp3_2 = tmp3_2 + s1_1706_2;
    // Op 1707: dim3x3 mul
    gl64_t s1_1707_0 = *(gl64_t*)&expressions_params[10][344];
    gl64_t s1_1707_1 = *(gl64_t*)&expressions_params[10][344+1];
    gl64_t s1_1707_2 = *(gl64_t*)&expressions_params[10][344+2];
    gl64_t kA1707 = (tmp3_0 + tmp3_1) * (s1_1707_0 + s1_1707_1);
    gl64_t kB1707 = (tmp3_0 + tmp3_2) * (s1_1707_0 + s1_1707_2);
    gl64_t kC1707 = (tmp3_1 + tmp3_2) * (s1_1707_1 + s1_1707_2);
    gl64_t kD1707 = tmp3_0 * s1_1707_0;
    gl64_t kE1707 = tmp3_1 * s1_1707_1;
    gl64_t kF1707 = tmp3_2 * s1_1707_2;
    gl64_t kG1707 = kD1707 - kE1707;
    tmp3_0 = (kC1707 + kG1707) - kF1707;
    tmp3_1 = ((((kA1707 + kC1707) - kE1707) - kE1707) - kD1707);
    tmp3_2 = kB1707 - kG1707;
    // Op 1708: dim3x1 sub
    gl64_t s1_1708 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1708; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1709: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1710: dim3x3 mul
    gl64_t s1_1710_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1710_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1710_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1710 = (tmp3_0 + tmp3_1) * (s1_1710_0 + s1_1710_1);
    gl64_t kB1710 = (tmp3_0 + tmp3_2) * (s1_1710_0 + s1_1710_2);
    gl64_t kC1710 = (tmp3_1 + tmp3_2) * (s1_1710_1 + s1_1710_2);
    gl64_t kD1710 = tmp3_0 * s1_1710_0;
    gl64_t kE1710 = tmp3_1 * s1_1710_1;
    gl64_t kF1710 = tmp3_2 * s1_1710_2;
    gl64_t kG1710 = kD1710 - kE1710;
    tmp3_6 = (kC1710 + kG1710) - kF1710;
    tmp3_7 = ((((kA1710 + kC1710) - kE1710) - kE1710) - kD1710);
    tmp3_8 = kB1710 - kG1710;
    // Op 1711: dim3x1 mul
    gl64_t s0_1711_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1711_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1711_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1711 = *(gl64_t*)&expressions_params[10][61];
    tmp3_0 = s0_1711_0 * s1_1711; tmp3_1 = s0_1711_1 * s1_1711; tmp3_2 = s0_1711_2 * s1_1711;
    // Op 1712: dim3x1 add
    gl64_t s1_1712 = *(gl64_t*)&expressions_params[10][60];
    tmp3_0 = tmp3_0 + s1_1712; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1713: dim3x3 mul
    gl64_t s1_1713_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1713_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1713_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1713 = (tmp3_0 + tmp3_1) * (s1_1713_0 + s1_1713_1);
    gl64_t kB1713 = (tmp3_0 + tmp3_2) * (s1_1713_0 + s1_1713_2);
    gl64_t kC1713 = (tmp3_1 + tmp3_2) * (s1_1713_1 + s1_1713_2);
    gl64_t kD1713 = tmp3_0 * s1_1713_0;
    gl64_t kE1713 = tmp3_1 * s1_1713_1;
    gl64_t kF1713 = tmp3_2 * s1_1713_2;
    gl64_t kG1713 = kD1713 - kE1713;
    tmp3_0 = (kC1713 + kG1713) - kF1713;
    tmp3_1 = ((((kA1713 + kC1713) - kE1713) - kE1713) - kD1713);
    tmp3_2 = kB1713 - kG1713;
    // Op 1714: dim3x1 add
    gl64_t s1_1714 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1714; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1715: dim3x3 mul
    gl64_t s1_1715_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1715_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1715_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1715 = (tmp3_0 + tmp3_1) * (s1_1715_0 + s1_1715_1);
    gl64_t kB1715 = (tmp3_0 + tmp3_2) * (s1_1715_0 + s1_1715_2);
    gl64_t kC1715 = (tmp3_1 + tmp3_2) * (s1_1715_1 + s1_1715_2);
    gl64_t kD1715 = tmp3_0 * s1_1715_0;
    gl64_t kE1715 = tmp3_1 * s1_1715_1;
    gl64_t kF1715 = tmp3_2 * s1_1715_2;
    gl64_t kG1715 = kD1715 - kE1715;
    tmp3_0 = (kC1715 + kG1715) - kF1715;
    tmp3_1 = ((((kA1715 + kC1715) - kE1715) - kE1715) - kD1715);
    tmp3_2 = kB1715 - kG1715;
    // Op 1716: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1717: dim3x3 mul
    gl64_t s1_1717_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1717_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1717_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1717 = (tmp3_0 + tmp3_1) * (s1_1717_0 + s1_1717_1);
    gl64_t kB1717 = (tmp3_0 + tmp3_2) * (s1_1717_0 + s1_1717_2);
    gl64_t kC1717 = (tmp3_1 + tmp3_2) * (s1_1717_1 + s1_1717_2);
    gl64_t kD1717 = tmp3_0 * s1_1717_0;
    gl64_t kE1717 = tmp3_1 * s1_1717_1;
    gl64_t kF1717 = tmp3_2 * s1_1717_2;
    gl64_t kG1717 = kD1717 - kE1717;
    tmp3_0 = (kC1717 + kG1717) - kF1717;
    tmp3_1 = ((((kA1717 + kC1717) - kE1717) - kE1717) - kD1717);
    tmp3_2 = kB1717 - kG1717;
    // Op 1718: dim3x1 add
    gl64_t s1_1718 = *(gl64_t*)&expressions_params[9][43];
    tmp3_0 = tmp3_0 + s1_1718; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1719: dim3x3 mul
    gl64_t s1_1719_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1719_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1719_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1719 = (tmp3_0 + tmp3_1) * (s1_1719_0 + s1_1719_1);
    gl64_t kB1719 = (tmp3_0 + tmp3_2) * (s1_1719_0 + s1_1719_2);
    gl64_t kC1719 = (tmp3_1 + tmp3_2) * (s1_1719_1 + s1_1719_2);
    gl64_t kD1719 = tmp3_0 * s1_1719_0;
    gl64_t kE1719 = tmp3_1 * s1_1719_1;
    gl64_t kF1719 = tmp3_2 * s1_1719_2;
    gl64_t kG1719 = kD1719 - kE1719;
    tmp3_0 = (kC1719 + kG1719) - kF1719;
    tmp3_1 = ((((kA1719 + kC1719) - kE1719) - kE1719) - kD1719);
    tmp3_2 = kB1719 - kG1719;
    // Op 1720: dim3x1 add
    gl64_t s1_1720 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1720; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1721: dim3x3 mul
    gl64_t s1_1721_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1721_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1721_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1721 = (tmp3_0 + tmp3_1) * (s1_1721_0 + s1_1721_1);
    gl64_t kB1721 = (tmp3_0 + tmp3_2) * (s1_1721_0 + s1_1721_2);
    gl64_t kC1721 = (tmp3_1 + tmp3_2) * (s1_1721_1 + s1_1721_2);
    gl64_t kD1721 = tmp3_0 * s1_1721_0;
    gl64_t kE1721 = tmp3_1 * s1_1721_1;
    gl64_t kF1721 = tmp3_2 * s1_1721_2;
    gl64_t kG1721 = kD1721 - kE1721;
    tmp3_0 = (kC1721 + kG1721) - kF1721;
    tmp3_1 = ((((kA1721 + kC1721) - kE1721) - kE1721) - kD1721);
    tmp3_2 = kB1721 - kG1721;
    // Op 1722: dim3x1 add
    gl64_t s1_1722 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1722; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1723: dim3x3 add
    gl64_t s1_1723_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1723_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1723_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1723_0; tmp3_1 = tmp3_1 + s1_1723_1; tmp3_2 = tmp3_2 + s1_1723_2;
    // Op 1724: dim3x3 mul
    gl64_t s1_1724_0 = *(gl64_t*)&expressions_params[10][347];
    gl64_t s1_1724_1 = *(gl64_t*)&expressions_params[10][347+1];
    gl64_t s1_1724_2 = *(gl64_t*)&expressions_params[10][347+2];
    gl64_t kA1724 = (tmp3_0 + tmp3_1) * (s1_1724_0 + s1_1724_1);
    gl64_t kB1724 = (tmp3_0 + tmp3_2) * (s1_1724_0 + s1_1724_2);
    gl64_t kC1724 = (tmp3_1 + tmp3_2) * (s1_1724_1 + s1_1724_2);
    gl64_t kD1724 = tmp3_0 * s1_1724_0;
    gl64_t kE1724 = tmp3_1 * s1_1724_1;
    gl64_t kF1724 = tmp3_2 * s1_1724_2;
    gl64_t kG1724 = kD1724 - kE1724;
    tmp3_0 = (kC1724 + kG1724) - kF1724;
    tmp3_1 = ((((kA1724 + kC1724) - kE1724) - kE1724) - kD1724);
    tmp3_2 = kB1724 - kG1724;
    // Op 1725: dim1x1 sub
    gl64_t s0_1725 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1725 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1725 - s1_1725;
    // Op 1726: dim1x1 sub_swap
    gl64_t s1_1726 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1726 - tmp1_0;
    // Op 1727: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1728: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1729: dim3x3 mul
    gl64_t s1_1729_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1729_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1729_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1729 = (tmp3_0 + tmp3_1) * (s1_1729_0 + s1_1729_1);
    gl64_t kB1729 = (tmp3_0 + tmp3_2) * (s1_1729_0 + s1_1729_2);
    gl64_t kC1729 = (tmp3_1 + tmp3_2) * (s1_1729_1 + s1_1729_2);
    gl64_t kD1729 = tmp3_0 * s1_1729_0;
    gl64_t kE1729 = tmp3_1 * s1_1729_1;
    gl64_t kF1729 = tmp3_2 * s1_1729_2;
    gl64_t kG1729 = kD1729 - kE1729;
    tmp3_6 = (kC1729 + kG1729) - kF1729;
    tmp3_7 = ((((kA1729 + kC1729) - kE1729) - kE1729) - kD1729);
    tmp3_8 = kB1729 - kG1729;
    // Op 1730: dim1x1 sub
    gl64_t s1_1730 = *(gl64_t*)&expressions_params[10][97];
    tmp1_0 = tmp1_4 - s1_1730;
    // Op 1731: dim1x1 sub
    gl64_t s1_1731 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1731;
    // Op 1732: dim3x1 mul
    gl64_t s0_1732_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1732_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1732_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1732_0 * tmp1_0; tmp3_1 = s0_1732_1 * tmp1_0; tmp3_2 = s0_1732_2 * tmp1_0;
    // Op 1733: dim3x1 add
    gl64_t s1_1733 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1733; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1734: dim3x3 add
    gl64_t s1_1734_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1734_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1734_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1734_0; tmp3_1 = tmp3_1 + s1_1734_1; tmp3_2 = tmp3_2 + s1_1734_2;
    // Op 1735: dim3x3 mul
    gl64_t s1_1735_0 = *(gl64_t*)&expressions_params[10][350];
    gl64_t s1_1735_1 = *(gl64_t*)&expressions_params[10][350+1];
    gl64_t s1_1735_2 = *(gl64_t*)&expressions_params[10][350+2];
    gl64_t kA1735 = (tmp3_0 + tmp3_1) * (s1_1735_0 + s1_1735_1);
    gl64_t kB1735 = (tmp3_0 + tmp3_2) * (s1_1735_0 + s1_1735_2);
    gl64_t kC1735 = (tmp3_1 + tmp3_2) * (s1_1735_1 + s1_1735_2);
    gl64_t kD1735 = tmp3_0 * s1_1735_0;
    gl64_t kE1735 = tmp3_1 * s1_1735_1;
    gl64_t kF1735 = tmp3_2 * s1_1735_2;
    gl64_t kG1735 = kD1735 - kE1735;
    tmp3_0 = (kC1735 + kG1735) - kF1735;
    tmp3_1 = ((((kA1735 + kC1735) - kE1735) - kE1735) - kD1735);
    tmp3_2 = kB1735 - kG1735;
    // Op 1736: dim3x1 add
    gl64_t s1_1736 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1736; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1737: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1738: dim3x3 mul
    gl64_t s1_1738_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1738_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1738_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1738 = (tmp3_0 + tmp3_1) * (s1_1738_0 + s1_1738_1);
    gl64_t kB1738 = (tmp3_0 + tmp3_2) * (s1_1738_0 + s1_1738_2);
    gl64_t kC1738 = (tmp3_1 + tmp3_2) * (s1_1738_1 + s1_1738_2);
    gl64_t kD1738 = tmp3_0 * s1_1738_0;
    gl64_t kE1738 = tmp3_1 * s1_1738_1;
    gl64_t kF1738 = tmp3_2 * s1_1738_2;
    gl64_t kG1738 = kD1738 - kE1738;
    tmp3_6 = (kC1738 + kG1738) - kF1738;
    tmp3_7 = ((((kA1738 + kC1738) - kE1738) - kE1738) - kD1738);
    tmp3_8 = kB1738 - kG1738;
    // Op 1739: dim3x1 mul
    gl64_t s0_1739_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1739_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1739_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1739 = *(gl64_t*)&expressions_params[10][63];
    tmp3_0 = s0_1739_0 * s1_1739; tmp3_1 = s0_1739_1 * s1_1739; tmp3_2 = s0_1739_2 * s1_1739;
    // Op 1740: dim3x1 add
    gl64_t s1_1740 = *(gl64_t*)&expressions_params[10][62];
    tmp3_0 = tmp3_0 + s1_1740; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1741: dim3x3 mul
    gl64_t s1_1741_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1741_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1741_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1741 = (tmp3_0 + tmp3_1) * (s1_1741_0 + s1_1741_1);
    gl64_t kB1741 = (tmp3_0 + tmp3_2) * (s1_1741_0 + s1_1741_2);
    gl64_t kC1741 = (tmp3_1 + tmp3_2) * (s1_1741_1 + s1_1741_2);
    gl64_t kD1741 = tmp3_0 * s1_1741_0;
    gl64_t kE1741 = tmp3_1 * s1_1741_1;
    gl64_t kF1741 = tmp3_2 * s1_1741_2;
    gl64_t kG1741 = kD1741 - kE1741;
    tmp3_0 = (kC1741 + kG1741) - kF1741;
    tmp3_1 = ((((kA1741 + kC1741) - kE1741) - kE1741) - kD1741);
    tmp3_2 = kB1741 - kG1741;
    // Op 1742: dim3x1 add
    gl64_t s1_1742 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1742; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1743: dim3x3 mul
    gl64_t s1_1743_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1743_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1743_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1743 = (tmp3_0 + tmp3_1) * (s1_1743_0 + s1_1743_1);
    gl64_t kB1743 = (tmp3_0 + tmp3_2) * (s1_1743_0 + s1_1743_2);
    gl64_t kC1743 = (tmp3_1 + tmp3_2) * (s1_1743_1 + s1_1743_2);
    gl64_t kD1743 = tmp3_0 * s1_1743_0;
    gl64_t kE1743 = tmp3_1 * s1_1743_1;
    gl64_t kF1743 = tmp3_2 * s1_1743_2;
    gl64_t kG1743 = kD1743 - kE1743;
    tmp3_0 = (kC1743 + kG1743) - kF1743;
    tmp3_1 = ((((kA1743 + kC1743) - kE1743) - kE1743) - kD1743);
    tmp3_2 = kB1743 - kG1743;
    // Op 1744: dim3x1 add
    gl64_t s1_1744 = *(gl64_t*)&expressions_params[10][97];
    tmp3_0 = tmp3_0 + s1_1744; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1745: dim3x3 mul
    gl64_t s1_1745_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1745_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1745_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1745 = (tmp3_0 + tmp3_1) * (s1_1745_0 + s1_1745_1);
    gl64_t kB1745 = (tmp3_0 + tmp3_2) * (s1_1745_0 + s1_1745_2);
    gl64_t kC1745 = (tmp3_1 + tmp3_2) * (s1_1745_1 + s1_1745_2);
    gl64_t kD1745 = tmp3_0 * s1_1745_0;
    gl64_t kE1745 = tmp3_1 * s1_1745_1;
    gl64_t kF1745 = tmp3_2 * s1_1745_2;
    gl64_t kG1745 = kD1745 - kE1745;
    tmp3_0 = (kC1745 + kG1745) - kF1745;
    tmp3_1 = ((((kA1745 + kC1745) - kE1745) - kE1745) - kD1745);
    tmp3_2 = kB1745 - kG1745;
    // Op 1746: dim3x1 add
    gl64_t s1_1746 = *(gl64_t*)&expressions_params[9][44];
    tmp3_0 = tmp3_0 + s1_1746; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1747: dim3x3 mul
    gl64_t s1_1747_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1747_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1747_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1747 = (tmp3_0 + tmp3_1) * (s1_1747_0 + s1_1747_1);
    gl64_t kB1747 = (tmp3_0 + tmp3_2) * (s1_1747_0 + s1_1747_2);
    gl64_t kC1747 = (tmp3_1 + tmp3_2) * (s1_1747_1 + s1_1747_2);
    gl64_t kD1747 = tmp3_0 * s1_1747_0;
    gl64_t kE1747 = tmp3_1 * s1_1747_1;
    gl64_t kF1747 = tmp3_2 * s1_1747_2;
    gl64_t kG1747 = kD1747 - kE1747;
    tmp3_0 = (kC1747 + kG1747) - kF1747;
    tmp3_1 = ((((kA1747 + kC1747) - kE1747) - kE1747) - kD1747);
    tmp3_2 = kB1747 - kG1747;
    // Op 1748: dim3x1 add
    gl64_t s1_1748 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1748; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1749: dim3x3 mul
    gl64_t s1_1749_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1749_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1749_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1749 = (tmp3_0 + tmp3_1) * (s1_1749_0 + s1_1749_1);
    gl64_t kB1749 = (tmp3_0 + tmp3_2) * (s1_1749_0 + s1_1749_2);
    gl64_t kC1749 = (tmp3_1 + tmp3_2) * (s1_1749_1 + s1_1749_2);
    gl64_t kD1749 = tmp3_0 * s1_1749_0;
    gl64_t kE1749 = tmp3_1 * s1_1749_1;
    gl64_t kF1749 = tmp3_2 * s1_1749_2;
    gl64_t kG1749 = kD1749 - kE1749;
    tmp3_0 = (kC1749 + kG1749) - kF1749;
    tmp3_1 = ((((kA1749 + kC1749) - kE1749) - kE1749) - kD1749);
    tmp3_2 = kB1749 - kG1749;
    // Op 1750: dim3x1 add
    gl64_t s1_1750 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1750; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1751: dim3x3 add
    gl64_t s1_1751_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1751_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1751_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1751_0; tmp3_1 = tmp3_1 + s1_1751_1; tmp3_2 = tmp3_2 + s1_1751_2;
    // Op 1752: dim3x3 mul
    gl64_t s1_1752_0 = *(gl64_t*)&expressions_params[10][353];
    gl64_t s1_1752_1 = *(gl64_t*)&expressions_params[10][353+1];
    gl64_t s1_1752_2 = *(gl64_t*)&expressions_params[10][353+2];
    gl64_t kA1752 = (tmp3_0 + tmp3_1) * (s1_1752_0 + s1_1752_1);
    gl64_t kB1752 = (tmp3_0 + tmp3_2) * (s1_1752_0 + s1_1752_2);
    gl64_t kC1752 = (tmp3_1 + tmp3_2) * (s1_1752_1 + s1_1752_2);
    gl64_t kD1752 = tmp3_0 * s1_1752_0;
    gl64_t kE1752 = tmp3_1 * s1_1752_1;
    gl64_t kF1752 = tmp3_2 * s1_1752_2;
    gl64_t kG1752 = kD1752 - kE1752;
    tmp3_0 = (kC1752 + kG1752) - kF1752;
    tmp3_1 = ((((kA1752 + kC1752) - kE1752) - kE1752) - kD1752);
    tmp3_2 = kB1752 - kG1752;
    // Op 1753: dim3x1 sub
    gl64_t s1_1753 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1753; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1754: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1755: dim3x3 mul
    gl64_t s1_1755_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1755_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1755_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1755 = (tmp3_0 + tmp3_1) * (s1_1755_0 + s1_1755_1);
    gl64_t kB1755 = (tmp3_0 + tmp3_2) * (s1_1755_0 + s1_1755_2);
    gl64_t kC1755 = (tmp3_1 + tmp3_2) * (s1_1755_1 + s1_1755_2);
    gl64_t kD1755 = tmp3_0 * s1_1755_0;
    gl64_t kE1755 = tmp3_1 * s1_1755_1;
    gl64_t kF1755 = tmp3_2 * s1_1755_2;
    gl64_t kG1755 = kD1755 - kE1755;
    tmp3_6 = (kC1755 + kG1755) - kF1755;
    tmp3_7 = ((((kA1755 + kC1755) - kE1755) - kE1755) - kD1755);
    tmp3_8 = kB1755 - kG1755;
    // Op 1756: dim3x1 mul
    gl64_t s0_1756_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1756_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1756_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1756 = *(gl64_t*)&expressions_params[10][63];
    tmp3_0 = s0_1756_0 * s1_1756; tmp3_1 = s0_1756_1 * s1_1756; tmp3_2 = s0_1756_2 * s1_1756;
    // Op 1757: dim3x1 add
    gl64_t s1_1757 = *(gl64_t*)&expressions_params[10][62];
    tmp3_0 = tmp3_0 + s1_1757; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1758: dim3x3 mul
    gl64_t s1_1758_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1758_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1758_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1758 = (tmp3_0 + tmp3_1) * (s1_1758_0 + s1_1758_1);
    gl64_t kB1758 = (tmp3_0 + tmp3_2) * (s1_1758_0 + s1_1758_2);
    gl64_t kC1758 = (tmp3_1 + tmp3_2) * (s1_1758_1 + s1_1758_2);
    gl64_t kD1758 = tmp3_0 * s1_1758_0;
    gl64_t kE1758 = tmp3_1 * s1_1758_1;
    gl64_t kF1758 = tmp3_2 * s1_1758_2;
    gl64_t kG1758 = kD1758 - kE1758;
    tmp3_0 = (kC1758 + kG1758) - kF1758;
    tmp3_1 = ((((kA1758 + kC1758) - kE1758) - kE1758) - kD1758);
    tmp3_2 = kB1758 - kG1758;
    // Op 1759: dim3x1 add
    gl64_t s1_1759 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1759; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1760: dim3x3 mul
    gl64_t s1_1760_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1760_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1760_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1760 = (tmp3_0 + tmp3_1) * (s1_1760_0 + s1_1760_1);
    gl64_t kB1760 = (tmp3_0 + tmp3_2) * (s1_1760_0 + s1_1760_2);
    gl64_t kC1760 = (tmp3_1 + tmp3_2) * (s1_1760_1 + s1_1760_2);
    gl64_t kD1760 = tmp3_0 * s1_1760_0;
    gl64_t kE1760 = tmp3_1 * s1_1760_1;
    gl64_t kF1760 = tmp3_2 * s1_1760_2;
    gl64_t kG1760 = kD1760 - kE1760;
    tmp3_0 = (kC1760 + kG1760) - kF1760;
    tmp3_1 = ((((kA1760 + kC1760) - kE1760) - kE1760) - kD1760);
    tmp3_2 = kB1760 - kG1760;
    // Op 1761: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1762: dim3x3 mul
    gl64_t s1_1762_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1762_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1762_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1762 = (tmp3_0 + tmp3_1) * (s1_1762_0 + s1_1762_1);
    gl64_t kB1762 = (tmp3_0 + tmp3_2) * (s1_1762_0 + s1_1762_2);
    gl64_t kC1762 = (tmp3_1 + tmp3_2) * (s1_1762_1 + s1_1762_2);
    gl64_t kD1762 = tmp3_0 * s1_1762_0;
    gl64_t kE1762 = tmp3_1 * s1_1762_1;
    gl64_t kF1762 = tmp3_2 * s1_1762_2;
    gl64_t kG1762 = kD1762 - kE1762;
    tmp3_0 = (kC1762 + kG1762) - kF1762;
    tmp3_1 = ((((kA1762 + kC1762) - kE1762) - kE1762) - kD1762);
    tmp3_2 = kB1762 - kG1762;
    // Op 1763: dim3x1 add
    gl64_t s1_1763 = *(gl64_t*)&expressions_params[9][44];
    tmp3_0 = tmp3_0 + s1_1763; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1764: dim3x3 mul
    gl64_t s1_1764_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1764_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1764_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1764 = (tmp3_0 + tmp3_1) * (s1_1764_0 + s1_1764_1);
    gl64_t kB1764 = (tmp3_0 + tmp3_2) * (s1_1764_0 + s1_1764_2);
    gl64_t kC1764 = (tmp3_1 + tmp3_2) * (s1_1764_1 + s1_1764_2);
    gl64_t kD1764 = tmp3_0 * s1_1764_0;
    gl64_t kE1764 = tmp3_1 * s1_1764_1;
    gl64_t kF1764 = tmp3_2 * s1_1764_2;
    gl64_t kG1764 = kD1764 - kE1764;
    tmp3_0 = (kC1764 + kG1764) - kF1764;
    tmp3_1 = ((((kA1764 + kC1764) - kE1764) - kE1764) - kD1764);
    tmp3_2 = kB1764 - kG1764;
    // Op 1765: dim3x1 add
    gl64_t s1_1765 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1765; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1766: dim3x3 mul
    gl64_t s1_1766_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1766_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1766_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1766 = (tmp3_0 + tmp3_1) * (s1_1766_0 + s1_1766_1);
    gl64_t kB1766 = (tmp3_0 + tmp3_2) * (s1_1766_0 + s1_1766_2);
    gl64_t kC1766 = (tmp3_1 + tmp3_2) * (s1_1766_1 + s1_1766_2);
    gl64_t kD1766 = tmp3_0 * s1_1766_0;
    gl64_t kE1766 = tmp3_1 * s1_1766_1;
    gl64_t kF1766 = tmp3_2 * s1_1766_2;
    gl64_t kG1766 = kD1766 - kE1766;
    tmp3_0 = (kC1766 + kG1766) - kF1766;
    tmp3_1 = ((((kA1766 + kC1766) - kE1766) - kE1766) - kD1766);
    tmp3_2 = kB1766 - kG1766;
    // Op 1767: dim3x1 add
    gl64_t s1_1767 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1767; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1768: dim3x3 add
    gl64_t s1_1768_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1768_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1768_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1768_0; tmp3_1 = tmp3_1 + s1_1768_1; tmp3_2 = tmp3_2 + s1_1768_2;
    // Op 1769: dim3x3 mul
    gl64_t s1_1769_0 = *(gl64_t*)&expressions_params[10][356];
    gl64_t s1_1769_1 = *(gl64_t*)&expressions_params[10][356+1];
    gl64_t s1_1769_2 = *(gl64_t*)&expressions_params[10][356+2];
    gl64_t kA1769 = (tmp3_0 + tmp3_1) * (s1_1769_0 + s1_1769_1);
    gl64_t kB1769 = (tmp3_0 + tmp3_2) * (s1_1769_0 + s1_1769_2);
    gl64_t kC1769 = (tmp3_1 + tmp3_2) * (s1_1769_1 + s1_1769_2);
    gl64_t kD1769 = tmp3_0 * s1_1769_0;
    gl64_t kE1769 = tmp3_1 * s1_1769_1;
    gl64_t kF1769 = tmp3_2 * s1_1769_2;
    gl64_t kG1769 = kD1769 - kE1769;
    tmp3_0 = (kC1769 + kG1769) - kF1769;
    tmp3_1 = ((((kA1769 + kC1769) - kE1769) - kE1769) - kD1769);
    tmp3_2 = kB1769 - kG1769;
    // Op 1770: dim1x1 sub
    gl64_t s0_1770 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1770 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1770 - s1_1770;
    // Op 1771: dim1x1 sub_swap
    gl64_t s1_1771 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1771 - tmp1_0;
    // Op 1772: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1773: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1774: dim3x3 mul
    gl64_t s1_1774_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1774_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1774_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1774 = (tmp3_0 + tmp3_1) * (s1_1774_0 + s1_1774_1);
    gl64_t kB1774 = (tmp3_0 + tmp3_2) * (s1_1774_0 + s1_1774_2);
    gl64_t kC1774 = (tmp3_1 + tmp3_2) * (s1_1774_1 + s1_1774_2);
    gl64_t kD1774 = tmp3_0 * s1_1774_0;
    gl64_t kE1774 = tmp3_1 * s1_1774_1;
    gl64_t kF1774 = tmp3_2 * s1_1774_2;
    gl64_t kG1774 = kD1774 - kE1774;
    tmp3_6 = (kC1774 + kG1774) - kF1774;
    tmp3_7 = ((((kA1774 + kC1774) - kE1774) - kE1774) - kD1774);
    tmp3_8 = kB1774 - kG1774;
    // Op 1775: dim1x1 sub
    gl64_t s1_1775 = *(gl64_t*)&expressions_params[10][98];
    tmp1_0 = tmp1_4 - s1_1775;
    // Op 1776: dim1x1 sub
    gl64_t s1_1776 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1776;
    // Op 1777: dim3x1 mul
    gl64_t s0_1777_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1777_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1777_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1777_0 * tmp1_0; tmp3_1 = s0_1777_1 * tmp1_0; tmp3_2 = s0_1777_2 * tmp1_0;
    // Op 1778: dim3x1 add
    gl64_t s1_1778 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1778; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1779: dim3x3 add
    gl64_t s1_1779_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1779_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1779_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1779_0; tmp3_1 = tmp3_1 + s1_1779_1; tmp3_2 = tmp3_2 + s1_1779_2;
    // Op 1780: dim3x3 mul
    gl64_t s1_1780_0 = *(gl64_t*)&expressions_params[10][359];
    gl64_t s1_1780_1 = *(gl64_t*)&expressions_params[10][359+1];
    gl64_t s1_1780_2 = *(gl64_t*)&expressions_params[10][359+2];
    gl64_t kA1780 = (tmp3_0 + tmp3_1) * (s1_1780_0 + s1_1780_1);
    gl64_t kB1780 = (tmp3_0 + tmp3_2) * (s1_1780_0 + s1_1780_2);
    gl64_t kC1780 = (tmp3_1 + tmp3_2) * (s1_1780_1 + s1_1780_2);
    gl64_t kD1780 = tmp3_0 * s1_1780_0;
    gl64_t kE1780 = tmp3_1 * s1_1780_1;
    gl64_t kF1780 = tmp3_2 * s1_1780_2;
    gl64_t kG1780 = kD1780 - kE1780;
    tmp3_0 = (kC1780 + kG1780) - kF1780;
    tmp3_1 = ((((kA1780 + kC1780) - kE1780) - kE1780) - kD1780);
    tmp3_2 = kB1780 - kG1780;
    // Op 1781: dim3x1 add
    gl64_t s1_1781 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1781; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1782: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1783: dim3x3 mul
    gl64_t s1_1783_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1783_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1783_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1783 = (tmp3_0 + tmp3_1) * (s1_1783_0 + s1_1783_1);
    gl64_t kB1783 = (tmp3_0 + tmp3_2) * (s1_1783_0 + s1_1783_2);
    gl64_t kC1783 = (tmp3_1 + tmp3_2) * (s1_1783_1 + s1_1783_2);
    gl64_t kD1783 = tmp3_0 * s1_1783_0;
    gl64_t kE1783 = tmp3_1 * s1_1783_1;
    gl64_t kF1783 = tmp3_2 * s1_1783_2;
    gl64_t kG1783 = kD1783 - kE1783;
    tmp3_6 = (kC1783 + kG1783) - kF1783;
    tmp3_7 = ((((kA1783 + kC1783) - kE1783) - kE1783) - kD1783);
    tmp3_8 = kB1783 - kG1783;
    // Op 1784: dim3x1 mul
    gl64_t s0_1784_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1784_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1784_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1784 = *(gl64_t*)&expressions_params[10][65];
    tmp3_0 = s0_1784_0 * s1_1784; tmp3_1 = s0_1784_1 * s1_1784; tmp3_2 = s0_1784_2 * s1_1784;
    // Op 1785: dim3x1 add
    gl64_t s1_1785 = *(gl64_t*)&expressions_params[10][64];
    tmp3_0 = tmp3_0 + s1_1785; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1786: dim3x3 mul
    gl64_t s1_1786_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1786_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1786_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1786 = (tmp3_0 + tmp3_1) * (s1_1786_0 + s1_1786_1);
    gl64_t kB1786 = (tmp3_0 + tmp3_2) * (s1_1786_0 + s1_1786_2);
    gl64_t kC1786 = (tmp3_1 + tmp3_2) * (s1_1786_1 + s1_1786_2);
    gl64_t kD1786 = tmp3_0 * s1_1786_0;
    gl64_t kE1786 = tmp3_1 * s1_1786_1;
    gl64_t kF1786 = tmp3_2 * s1_1786_2;
    gl64_t kG1786 = kD1786 - kE1786;
    tmp3_0 = (kC1786 + kG1786) - kF1786;
    tmp3_1 = ((((kA1786 + kC1786) - kE1786) - kE1786) - kD1786);
    tmp3_2 = kB1786 - kG1786;
    // Op 1787: dim3x1 add
    gl64_t s1_1787 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1787; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1788: dim3x3 mul
    gl64_t s1_1788_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1788_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1788_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1788 = (tmp3_0 + tmp3_1) * (s1_1788_0 + s1_1788_1);
    gl64_t kB1788 = (tmp3_0 + tmp3_2) * (s1_1788_0 + s1_1788_2);
    gl64_t kC1788 = (tmp3_1 + tmp3_2) * (s1_1788_1 + s1_1788_2);
    gl64_t kD1788 = tmp3_0 * s1_1788_0;
    gl64_t kE1788 = tmp3_1 * s1_1788_1;
    gl64_t kF1788 = tmp3_2 * s1_1788_2;
    gl64_t kG1788 = kD1788 - kE1788;
    tmp3_0 = (kC1788 + kG1788) - kF1788;
    tmp3_1 = ((((kA1788 + kC1788) - kE1788) - kE1788) - kD1788);
    tmp3_2 = kB1788 - kG1788;
    // Op 1789: dim3x1 add
    gl64_t s1_1789 = *(gl64_t*)&expressions_params[10][98];
    tmp3_0 = tmp3_0 + s1_1789; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1790: dim3x3 mul
    gl64_t s1_1790_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1790_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1790_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1790 = (tmp3_0 + tmp3_1) * (s1_1790_0 + s1_1790_1);
    gl64_t kB1790 = (tmp3_0 + tmp3_2) * (s1_1790_0 + s1_1790_2);
    gl64_t kC1790 = (tmp3_1 + tmp3_2) * (s1_1790_1 + s1_1790_2);
    gl64_t kD1790 = tmp3_0 * s1_1790_0;
    gl64_t kE1790 = tmp3_1 * s1_1790_1;
    gl64_t kF1790 = tmp3_2 * s1_1790_2;
    gl64_t kG1790 = kD1790 - kE1790;
    tmp3_0 = (kC1790 + kG1790) - kF1790;
    tmp3_1 = ((((kA1790 + kC1790) - kE1790) - kE1790) - kD1790);
    tmp3_2 = kB1790 - kG1790;
    // Op 1791: dim3x1 add
    gl64_t s1_1791 = *(gl64_t*)&expressions_params[9][45];
    tmp3_0 = tmp3_0 + s1_1791; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1792: dim3x3 mul
    gl64_t s1_1792_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1792_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1792_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1792 = (tmp3_0 + tmp3_1) * (s1_1792_0 + s1_1792_1);
    gl64_t kB1792 = (tmp3_0 + tmp3_2) * (s1_1792_0 + s1_1792_2);
    gl64_t kC1792 = (tmp3_1 + tmp3_2) * (s1_1792_1 + s1_1792_2);
    gl64_t kD1792 = tmp3_0 * s1_1792_0;
    gl64_t kE1792 = tmp3_1 * s1_1792_1;
    gl64_t kF1792 = tmp3_2 * s1_1792_2;
    gl64_t kG1792 = kD1792 - kE1792;
    tmp3_0 = (kC1792 + kG1792) - kF1792;
    tmp3_1 = ((((kA1792 + kC1792) - kE1792) - kE1792) - kD1792);
    tmp3_2 = kB1792 - kG1792;
    // Op 1793: dim3x1 add
    gl64_t s1_1793 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1793; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1794: dim3x3 mul
    gl64_t s1_1794_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1794_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1794_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1794 = (tmp3_0 + tmp3_1) * (s1_1794_0 + s1_1794_1);
    gl64_t kB1794 = (tmp3_0 + tmp3_2) * (s1_1794_0 + s1_1794_2);
    gl64_t kC1794 = (tmp3_1 + tmp3_2) * (s1_1794_1 + s1_1794_2);
    gl64_t kD1794 = tmp3_0 * s1_1794_0;
    gl64_t kE1794 = tmp3_1 * s1_1794_1;
    gl64_t kF1794 = tmp3_2 * s1_1794_2;
    gl64_t kG1794 = kD1794 - kE1794;
    tmp3_0 = (kC1794 + kG1794) - kF1794;
    tmp3_1 = ((((kA1794 + kC1794) - kE1794) - kE1794) - kD1794);
    tmp3_2 = kB1794 - kG1794;
    // Op 1795: dim3x1 add
    gl64_t s1_1795 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1795; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1796: dim3x3 add
    gl64_t s1_1796_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1796_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1796_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1796_0; tmp3_1 = tmp3_1 + s1_1796_1; tmp3_2 = tmp3_2 + s1_1796_2;
    // Op 1797: dim3x3 mul
    gl64_t s1_1797_0 = *(gl64_t*)&expressions_params[10][362];
    gl64_t s1_1797_1 = *(gl64_t*)&expressions_params[10][362+1];
    gl64_t s1_1797_2 = *(gl64_t*)&expressions_params[10][362+2];
    gl64_t kA1797 = (tmp3_0 + tmp3_1) * (s1_1797_0 + s1_1797_1);
    gl64_t kB1797 = (tmp3_0 + tmp3_2) * (s1_1797_0 + s1_1797_2);
    gl64_t kC1797 = (tmp3_1 + tmp3_2) * (s1_1797_1 + s1_1797_2);
    gl64_t kD1797 = tmp3_0 * s1_1797_0;
    gl64_t kE1797 = tmp3_1 * s1_1797_1;
    gl64_t kF1797 = tmp3_2 * s1_1797_2;
    gl64_t kG1797 = kD1797 - kE1797;
    tmp3_0 = (kC1797 + kG1797) - kF1797;
    tmp3_1 = ((((kA1797 + kC1797) - kE1797) - kE1797) - kD1797);
    tmp3_2 = kB1797 - kG1797;
    // Op 1798: dim3x1 sub
    gl64_t s1_1798 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1798; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1799: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1800: dim3x3 mul
    gl64_t s1_1800_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1800_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1800_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1800 = (tmp3_0 + tmp3_1) * (s1_1800_0 + s1_1800_1);
    gl64_t kB1800 = (tmp3_0 + tmp3_2) * (s1_1800_0 + s1_1800_2);
    gl64_t kC1800 = (tmp3_1 + tmp3_2) * (s1_1800_1 + s1_1800_2);
    gl64_t kD1800 = tmp3_0 * s1_1800_0;
    gl64_t kE1800 = tmp3_1 * s1_1800_1;
    gl64_t kF1800 = tmp3_2 * s1_1800_2;
    gl64_t kG1800 = kD1800 - kE1800;
    tmp3_6 = (kC1800 + kG1800) - kF1800;
    tmp3_7 = ((((kA1800 + kC1800) - kE1800) - kE1800) - kD1800);
    tmp3_8 = kB1800 - kG1800;
    // Op 1801: dim3x1 mul
    gl64_t s0_1801_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1801_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1801_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1801 = *(gl64_t*)&expressions_params[10][65];
    tmp3_0 = s0_1801_0 * s1_1801; tmp3_1 = s0_1801_1 * s1_1801; tmp3_2 = s0_1801_2 * s1_1801;
    // Op 1802: dim3x1 add
    gl64_t s1_1802 = *(gl64_t*)&expressions_params[10][64];
    tmp3_0 = tmp3_0 + s1_1802; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1803: dim3x3 mul
    gl64_t s1_1803_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1803_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1803_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1803 = (tmp3_0 + tmp3_1) * (s1_1803_0 + s1_1803_1);
    gl64_t kB1803 = (tmp3_0 + tmp3_2) * (s1_1803_0 + s1_1803_2);
    gl64_t kC1803 = (tmp3_1 + tmp3_2) * (s1_1803_1 + s1_1803_2);
    gl64_t kD1803 = tmp3_0 * s1_1803_0;
    gl64_t kE1803 = tmp3_1 * s1_1803_1;
    gl64_t kF1803 = tmp3_2 * s1_1803_2;
    gl64_t kG1803 = kD1803 - kE1803;
    tmp3_0 = (kC1803 + kG1803) - kF1803;
    tmp3_1 = ((((kA1803 + kC1803) - kE1803) - kE1803) - kD1803);
    tmp3_2 = kB1803 - kG1803;
    // Op 1804: dim3x1 add
    gl64_t s1_1804 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1804; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1805: dim3x3 mul
    gl64_t s1_1805_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1805_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1805_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1805 = (tmp3_0 + tmp3_1) * (s1_1805_0 + s1_1805_1);
    gl64_t kB1805 = (tmp3_0 + tmp3_2) * (s1_1805_0 + s1_1805_2);
    gl64_t kC1805 = (tmp3_1 + tmp3_2) * (s1_1805_1 + s1_1805_2);
    gl64_t kD1805 = tmp3_0 * s1_1805_0;
    gl64_t kE1805 = tmp3_1 * s1_1805_1;
    gl64_t kF1805 = tmp3_2 * s1_1805_2;
    gl64_t kG1805 = kD1805 - kE1805;
    tmp3_0 = (kC1805 + kG1805) - kF1805;
    tmp3_1 = ((((kA1805 + kC1805) - kE1805) - kE1805) - kD1805);
    tmp3_2 = kB1805 - kG1805;
    // Op 1806: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1807: dim3x3 mul
    gl64_t s1_1807_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1807_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1807_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1807 = (tmp3_0 + tmp3_1) * (s1_1807_0 + s1_1807_1);
    gl64_t kB1807 = (tmp3_0 + tmp3_2) * (s1_1807_0 + s1_1807_2);
    gl64_t kC1807 = (tmp3_1 + tmp3_2) * (s1_1807_1 + s1_1807_2);
    gl64_t kD1807 = tmp3_0 * s1_1807_0;
    gl64_t kE1807 = tmp3_1 * s1_1807_1;
    gl64_t kF1807 = tmp3_2 * s1_1807_2;
    gl64_t kG1807 = kD1807 - kE1807;
    tmp3_0 = (kC1807 + kG1807) - kF1807;
    tmp3_1 = ((((kA1807 + kC1807) - kE1807) - kE1807) - kD1807);
    tmp3_2 = kB1807 - kG1807;
    // Op 1808: dim3x1 add
    gl64_t s1_1808 = *(gl64_t*)&expressions_params[9][45];
    tmp3_0 = tmp3_0 + s1_1808; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1809: dim3x3 mul
    gl64_t s1_1809_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1809_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1809_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1809 = (tmp3_0 + tmp3_1) * (s1_1809_0 + s1_1809_1);
    gl64_t kB1809 = (tmp3_0 + tmp3_2) * (s1_1809_0 + s1_1809_2);
    gl64_t kC1809 = (tmp3_1 + tmp3_2) * (s1_1809_1 + s1_1809_2);
    gl64_t kD1809 = tmp3_0 * s1_1809_0;
    gl64_t kE1809 = tmp3_1 * s1_1809_1;
    gl64_t kF1809 = tmp3_2 * s1_1809_2;
    gl64_t kG1809 = kD1809 - kE1809;
    tmp3_0 = (kC1809 + kG1809) - kF1809;
    tmp3_1 = ((((kA1809 + kC1809) - kE1809) - kE1809) - kD1809);
    tmp3_2 = kB1809 - kG1809;
    // Op 1810: dim3x1 add
    gl64_t s1_1810 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1810; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1811: dim3x3 mul
    gl64_t s1_1811_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1811_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1811_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1811 = (tmp3_0 + tmp3_1) * (s1_1811_0 + s1_1811_1);
    gl64_t kB1811 = (tmp3_0 + tmp3_2) * (s1_1811_0 + s1_1811_2);
    gl64_t kC1811 = (tmp3_1 + tmp3_2) * (s1_1811_1 + s1_1811_2);
    gl64_t kD1811 = tmp3_0 * s1_1811_0;
    gl64_t kE1811 = tmp3_1 * s1_1811_1;
    gl64_t kF1811 = tmp3_2 * s1_1811_2;
    gl64_t kG1811 = kD1811 - kE1811;
    tmp3_0 = (kC1811 + kG1811) - kF1811;
    tmp3_1 = ((((kA1811 + kC1811) - kE1811) - kE1811) - kD1811);
    tmp3_2 = kB1811 - kG1811;
    // Op 1812: dim3x1 add
    gl64_t s1_1812 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1812; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1813: dim3x3 add
    gl64_t s1_1813_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1813_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1813_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1813_0; tmp3_1 = tmp3_1 + s1_1813_1; tmp3_2 = tmp3_2 + s1_1813_2;
    // Op 1814: dim3x3 mul
    gl64_t s1_1814_0 = *(gl64_t*)&expressions_params[10][365];
    gl64_t s1_1814_1 = *(gl64_t*)&expressions_params[10][365+1];
    gl64_t s1_1814_2 = *(gl64_t*)&expressions_params[10][365+2];
    gl64_t kA1814 = (tmp3_0 + tmp3_1) * (s1_1814_0 + s1_1814_1);
    gl64_t kB1814 = (tmp3_0 + tmp3_2) * (s1_1814_0 + s1_1814_2);
    gl64_t kC1814 = (tmp3_1 + tmp3_2) * (s1_1814_1 + s1_1814_2);
    gl64_t kD1814 = tmp3_0 * s1_1814_0;
    gl64_t kE1814 = tmp3_1 * s1_1814_1;
    gl64_t kF1814 = tmp3_2 * s1_1814_2;
    gl64_t kG1814 = kD1814 - kE1814;
    tmp3_0 = (kC1814 + kG1814) - kF1814;
    tmp3_1 = ((((kA1814 + kC1814) - kE1814) - kE1814) - kD1814);
    tmp3_2 = kB1814 - kG1814;
    // Op 1815: dim1x1 sub
    gl64_t s0_1815 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1815 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1815 - s1_1815;
    // Op 1816: dim1x1 sub_swap
    gl64_t s1_1816 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1816 - tmp1_0;
    // Op 1817: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1818: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1819: dim3x3 mul
    gl64_t s1_1819_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1819_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1819_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1819 = (tmp3_0 + tmp3_1) * (s1_1819_0 + s1_1819_1);
    gl64_t kB1819 = (tmp3_0 + tmp3_2) * (s1_1819_0 + s1_1819_2);
    gl64_t kC1819 = (tmp3_1 + tmp3_2) * (s1_1819_1 + s1_1819_2);
    gl64_t kD1819 = tmp3_0 * s1_1819_0;
    gl64_t kE1819 = tmp3_1 * s1_1819_1;
    gl64_t kF1819 = tmp3_2 * s1_1819_2;
    gl64_t kG1819 = kD1819 - kE1819;
    tmp3_6 = (kC1819 + kG1819) - kF1819;
    tmp3_7 = ((((kA1819 + kC1819) - kE1819) - kE1819) - kD1819);
    tmp3_8 = kB1819 - kG1819;
    // Op 1820: dim1x1 sub
    gl64_t s1_1820 = *(gl64_t*)&expressions_params[10][99];
    tmp1_0 = tmp1_4 - s1_1820;
    // Op 1821: dim1x1 sub
    gl64_t s1_1821 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1821;
    // Op 1822: dim3x1 mul
    gl64_t s0_1822_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1822_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1822_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1822_0 * tmp1_0; tmp3_1 = s0_1822_1 * tmp1_0; tmp3_2 = s0_1822_2 * tmp1_0;
    // Op 1823: dim3x1 add
    gl64_t s1_1823 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1823; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1824: dim3x3 add
    gl64_t s1_1824_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1824_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1824_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1824_0; tmp3_1 = tmp3_1 + s1_1824_1; tmp3_2 = tmp3_2 + s1_1824_2;
    // Op 1825: dim3x3 mul
    gl64_t s1_1825_0 = *(gl64_t*)&expressions_params[10][368];
    gl64_t s1_1825_1 = *(gl64_t*)&expressions_params[10][368+1];
    gl64_t s1_1825_2 = *(gl64_t*)&expressions_params[10][368+2];
    gl64_t kA1825 = (tmp3_0 + tmp3_1) * (s1_1825_0 + s1_1825_1);
    gl64_t kB1825 = (tmp3_0 + tmp3_2) * (s1_1825_0 + s1_1825_2);
    gl64_t kC1825 = (tmp3_1 + tmp3_2) * (s1_1825_1 + s1_1825_2);
    gl64_t kD1825 = tmp3_0 * s1_1825_0;
    gl64_t kE1825 = tmp3_1 * s1_1825_1;
    gl64_t kF1825 = tmp3_2 * s1_1825_2;
    gl64_t kG1825 = kD1825 - kE1825;
    tmp3_0 = (kC1825 + kG1825) - kF1825;
    tmp3_1 = ((((kA1825 + kC1825) - kE1825) - kE1825) - kD1825);
    tmp3_2 = kB1825 - kG1825;
    // Op 1826: dim3x1 add
    gl64_t s1_1826 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1826; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1827: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1828: dim3x3 mul
    gl64_t s1_1828_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1828_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1828_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1828 = (tmp3_0 + tmp3_1) * (s1_1828_0 + s1_1828_1);
    gl64_t kB1828 = (tmp3_0 + tmp3_2) * (s1_1828_0 + s1_1828_2);
    gl64_t kC1828 = (tmp3_1 + tmp3_2) * (s1_1828_1 + s1_1828_2);
    gl64_t kD1828 = tmp3_0 * s1_1828_0;
    gl64_t kE1828 = tmp3_1 * s1_1828_1;
    gl64_t kF1828 = tmp3_2 * s1_1828_2;
    gl64_t kG1828 = kD1828 - kE1828;
    tmp3_6 = (kC1828 + kG1828) - kF1828;
    tmp3_7 = ((((kA1828 + kC1828) - kE1828) - kE1828) - kD1828);
    tmp3_8 = kB1828 - kG1828;
    // Op 1829: dim3x1 mul
    gl64_t s0_1829_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1829_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1829_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1829 = *(gl64_t*)&expressions_params[10][67];
    tmp3_0 = s0_1829_0 * s1_1829; tmp3_1 = s0_1829_1 * s1_1829; tmp3_2 = s0_1829_2 * s1_1829;
    // Op 1830: dim3x1 add
    gl64_t s1_1830 = *(gl64_t*)&expressions_params[10][66];
    tmp3_0 = tmp3_0 + s1_1830; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1831: dim3x3 mul
    gl64_t s1_1831_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1831_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1831_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1831 = (tmp3_0 + tmp3_1) * (s1_1831_0 + s1_1831_1);
    gl64_t kB1831 = (tmp3_0 + tmp3_2) * (s1_1831_0 + s1_1831_2);
    gl64_t kC1831 = (tmp3_1 + tmp3_2) * (s1_1831_1 + s1_1831_2);
    gl64_t kD1831 = tmp3_0 * s1_1831_0;
    gl64_t kE1831 = tmp3_1 * s1_1831_1;
    gl64_t kF1831 = tmp3_2 * s1_1831_2;
    gl64_t kG1831 = kD1831 - kE1831;
    tmp3_0 = (kC1831 + kG1831) - kF1831;
    tmp3_1 = ((((kA1831 + kC1831) - kE1831) - kE1831) - kD1831);
    tmp3_2 = kB1831 - kG1831;
    // Op 1832: dim3x1 add
    gl64_t s1_1832 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1832; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1833: dim3x3 mul
    gl64_t s1_1833_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1833_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1833_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1833 = (tmp3_0 + tmp3_1) * (s1_1833_0 + s1_1833_1);
    gl64_t kB1833 = (tmp3_0 + tmp3_2) * (s1_1833_0 + s1_1833_2);
    gl64_t kC1833 = (tmp3_1 + tmp3_2) * (s1_1833_1 + s1_1833_2);
    gl64_t kD1833 = tmp3_0 * s1_1833_0;
    gl64_t kE1833 = tmp3_1 * s1_1833_1;
    gl64_t kF1833 = tmp3_2 * s1_1833_2;
    gl64_t kG1833 = kD1833 - kE1833;
    tmp3_0 = (kC1833 + kG1833) - kF1833;
    tmp3_1 = ((((kA1833 + kC1833) - kE1833) - kE1833) - kD1833);
    tmp3_2 = kB1833 - kG1833;
    // Op 1834: dim3x1 add
    gl64_t s1_1834 = *(gl64_t*)&expressions_params[10][99];
    tmp3_0 = tmp3_0 + s1_1834; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1835: dim3x3 mul
    gl64_t s1_1835_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1835_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1835_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1835 = (tmp3_0 + tmp3_1) * (s1_1835_0 + s1_1835_1);
    gl64_t kB1835 = (tmp3_0 + tmp3_2) * (s1_1835_0 + s1_1835_2);
    gl64_t kC1835 = (tmp3_1 + tmp3_2) * (s1_1835_1 + s1_1835_2);
    gl64_t kD1835 = tmp3_0 * s1_1835_0;
    gl64_t kE1835 = tmp3_1 * s1_1835_1;
    gl64_t kF1835 = tmp3_2 * s1_1835_2;
    gl64_t kG1835 = kD1835 - kE1835;
    tmp3_0 = (kC1835 + kG1835) - kF1835;
    tmp3_1 = ((((kA1835 + kC1835) - kE1835) - kE1835) - kD1835);
    tmp3_2 = kB1835 - kG1835;
    // Op 1836: dim3x1 add
    gl64_t s1_1836 = *(gl64_t*)&expressions_params[9][46];
    tmp3_0 = tmp3_0 + s1_1836; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1837: dim3x3 mul
    gl64_t s1_1837_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1837_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1837_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1837 = (tmp3_0 + tmp3_1) * (s1_1837_0 + s1_1837_1);
    gl64_t kB1837 = (tmp3_0 + tmp3_2) * (s1_1837_0 + s1_1837_2);
    gl64_t kC1837 = (tmp3_1 + tmp3_2) * (s1_1837_1 + s1_1837_2);
    gl64_t kD1837 = tmp3_0 * s1_1837_0;
    gl64_t kE1837 = tmp3_1 * s1_1837_1;
    gl64_t kF1837 = tmp3_2 * s1_1837_2;
    gl64_t kG1837 = kD1837 - kE1837;
    tmp3_0 = (kC1837 + kG1837) - kF1837;
    tmp3_1 = ((((kA1837 + kC1837) - kE1837) - kE1837) - kD1837);
    tmp3_2 = kB1837 - kG1837;
    // Op 1838: dim3x1 add
    gl64_t s1_1838 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1838; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1839: dim3x3 mul
    gl64_t s1_1839_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1839_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1839_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1839 = (tmp3_0 + tmp3_1) * (s1_1839_0 + s1_1839_1);
    gl64_t kB1839 = (tmp3_0 + tmp3_2) * (s1_1839_0 + s1_1839_2);
    gl64_t kC1839 = (tmp3_1 + tmp3_2) * (s1_1839_1 + s1_1839_2);
    gl64_t kD1839 = tmp3_0 * s1_1839_0;
    gl64_t kE1839 = tmp3_1 * s1_1839_1;
    gl64_t kF1839 = tmp3_2 * s1_1839_2;
    gl64_t kG1839 = kD1839 - kE1839;
    tmp3_0 = (kC1839 + kG1839) - kF1839;
    tmp3_1 = ((((kA1839 + kC1839) - kE1839) - kE1839) - kD1839);
    tmp3_2 = kB1839 - kG1839;
    // Op 1840: dim3x1 add
    gl64_t s1_1840 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1840; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1841: dim3x3 add
    gl64_t s1_1841_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1841_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1841_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1841_0; tmp3_1 = tmp3_1 + s1_1841_1; tmp3_2 = tmp3_2 + s1_1841_2;
    // Op 1842: dim3x3 mul
    gl64_t s1_1842_0 = *(gl64_t*)&expressions_params[10][371];
    gl64_t s1_1842_1 = *(gl64_t*)&expressions_params[10][371+1];
    gl64_t s1_1842_2 = *(gl64_t*)&expressions_params[10][371+2];
    gl64_t kA1842 = (tmp3_0 + tmp3_1) * (s1_1842_0 + s1_1842_1);
    gl64_t kB1842 = (tmp3_0 + tmp3_2) * (s1_1842_0 + s1_1842_2);
    gl64_t kC1842 = (tmp3_1 + tmp3_2) * (s1_1842_1 + s1_1842_2);
    gl64_t kD1842 = tmp3_0 * s1_1842_0;
    gl64_t kE1842 = tmp3_1 * s1_1842_1;
    gl64_t kF1842 = tmp3_2 * s1_1842_2;
    gl64_t kG1842 = kD1842 - kE1842;
    tmp3_0 = (kC1842 + kG1842) - kF1842;
    tmp3_1 = ((((kA1842 + kC1842) - kE1842) - kE1842) - kD1842);
    tmp3_2 = kB1842 - kG1842;
    // Op 1843: dim3x1 sub
    gl64_t s1_1843 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1843; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1844: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1845: dim3x3 mul
    gl64_t s1_1845_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1845_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1845_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1845 = (tmp3_0 + tmp3_1) * (s1_1845_0 + s1_1845_1);
    gl64_t kB1845 = (tmp3_0 + tmp3_2) * (s1_1845_0 + s1_1845_2);
    gl64_t kC1845 = (tmp3_1 + tmp3_2) * (s1_1845_1 + s1_1845_2);
    gl64_t kD1845 = tmp3_0 * s1_1845_0;
    gl64_t kE1845 = tmp3_1 * s1_1845_1;
    gl64_t kF1845 = tmp3_2 * s1_1845_2;
    gl64_t kG1845 = kD1845 - kE1845;
    tmp3_6 = (kC1845 + kG1845) - kF1845;
    tmp3_7 = ((((kA1845 + kC1845) - kE1845) - kE1845) - kD1845);
    tmp3_8 = kB1845 - kG1845;
    // Op 1846: dim3x1 mul
    gl64_t s0_1846_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1846_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1846_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1846 = *(gl64_t*)&expressions_params[10][67];
    tmp3_0 = s0_1846_0 * s1_1846; tmp3_1 = s0_1846_1 * s1_1846; tmp3_2 = s0_1846_2 * s1_1846;
    // Op 1847: dim3x1 add
    gl64_t s1_1847 = *(gl64_t*)&expressions_params[10][66];
    tmp3_0 = tmp3_0 + s1_1847; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1848: dim3x3 mul
    gl64_t s1_1848_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1848_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1848_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1848 = (tmp3_0 + tmp3_1) * (s1_1848_0 + s1_1848_1);
    gl64_t kB1848 = (tmp3_0 + tmp3_2) * (s1_1848_0 + s1_1848_2);
    gl64_t kC1848 = (tmp3_1 + tmp3_2) * (s1_1848_1 + s1_1848_2);
    gl64_t kD1848 = tmp3_0 * s1_1848_0;
    gl64_t kE1848 = tmp3_1 * s1_1848_1;
    gl64_t kF1848 = tmp3_2 * s1_1848_2;
    gl64_t kG1848 = kD1848 - kE1848;
    tmp3_0 = (kC1848 + kG1848) - kF1848;
    tmp3_1 = ((((kA1848 + kC1848) - kE1848) - kE1848) - kD1848);
    tmp3_2 = kB1848 - kG1848;
    // Op 1849: dim3x1 add
    gl64_t s1_1849 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1849; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1850: dim3x3 mul
    gl64_t s1_1850_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1850_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1850_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1850 = (tmp3_0 + tmp3_1) * (s1_1850_0 + s1_1850_1);
    gl64_t kB1850 = (tmp3_0 + tmp3_2) * (s1_1850_0 + s1_1850_2);
    gl64_t kC1850 = (tmp3_1 + tmp3_2) * (s1_1850_1 + s1_1850_2);
    gl64_t kD1850 = tmp3_0 * s1_1850_0;
    gl64_t kE1850 = tmp3_1 * s1_1850_1;
    gl64_t kF1850 = tmp3_2 * s1_1850_2;
    gl64_t kG1850 = kD1850 - kE1850;
    tmp3_0 = (kC1850 + kG1850) - kF1850;
    tmp3_1 = ((((kA1850 + kC1850) - kE1850) - kE1850) - kD1850);
    tmp3_2 = kB1850 - kG1850;
    // Op 1851: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1852: dim3x3 mul
    gl64_t s1_1852_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1852_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1852_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1852 = (tmp3_0 + tmp3_1) * (s1_1852_0 + s1_1852_1);
    gl64_t kB1852 = (tmp3_0 + tmp3_2) * (s1_1852_0 + s1_1852_2);
    gl64_t kC1852 = (tmp3_1 + tmp3_2) * (s1_1852_1 + s1_1852_2);
    gl64_t kD1852 = tmp3_0 * s1_1852_0;
    gl64_t kE1852 = tmp3_1 * s1_1852_1;
    gl64_t kF1852 = tmp3_2 * s1_1852_2;
    gl64_t kG1852 = kD1852 - kE1852;
    tmp3_0 = (kC1852 + kG1852) - kF1852;
    tmp3_1 = ((((kA1852 + kC1852) - kE1852) - kE1852) - kD1852);
    tmp3_2 = kB1852 - kG1852;
    // Op 1853: dim3x1 add
    gl64_t s1_1853 = *(gl64_t*)&expressions_params[9][46];
    tmp3_0 = tmp3_0 + s1_1853; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1854: dim3x3 mul
    gl64_t s1_1854_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1854_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1854_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1854 = (tmp3_0 + tmp3_1) * (s1_1854_0 + s1_1854_1);
    gl64_t kB1854 = (tmp3_0 + tmp3_2) * (s1_1854_0 + s1_1854_2);
    gl64_t kC1854 = (tmp3_1 + tmp3_2) * (s1_1854_1 + s1_1854_2);
    gl64_t kD1854 = tmp3_0 * s1_1854_0;
    gl64_t kE1854 = tmp3_1 * s1_1854_1;
    gl64_t kF1854 = tmp3_2 * s1_1854_2;
    gl64_t kG1854 = kD1854 - kE1854;
    tmp3_0 = (kC1854 + kG1854) - kF1854;
    tmp3_1 = ((((kA1854 + kC1854) - kE1854) - kE1854) - kD1854);
    tmp3_2 = kB1854 - kG1854;
    // Op 1855: dim3x1 add
    gl64_t s1_1855 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1855; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1856: dim3x3 mul
    gl64_t s1_1856_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1856_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1856_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1856 = (tmp3_0 + tmp3_1) * (s1_1856_0 + s1_1856_1);
    gl64_t kB1856 = (tmp3_0 + tmp3_2) * (s1_1856_0 + s1_1856_2);
    gl64_t kC1856 = (tmp3_1 + tmp3_2) * (s1_1856_1 + s1_1856_2);
    gl64_t kD1856 = tmp3_0 * s1_1856_0;
    gl64_t kE1856 = tmp3_1 * s1_1856_1;
    gl64_t kF1856 = tmp3_2 * s1_1856_2;
    gl64_t kG1856 = kD1856 - kE1856;
    tmp3_0 = (kC1856 + kG1856) - kF1856;
    tmp3_1 = ((((kA1856 + kC1856) - kE1856) - kE1856) - kD1856);
    tmp3_2 = kB1856 - kG1856;
    // Op 1857: dim3x1 add
    gl64_t s1_1857 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1857; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1858: dim3x3 add
    gl64_t s1_1858_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1858_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1858_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1858_0; tmp3_1 = tmp3_1 + s1_1858_1; tmp3_2 = tmp3_2 + s1_1858_2;
    // Op 1859: dim3x3 mul
    gl64_t s1_1859_0 = *(gl64_t*)&expressions_params[10][374];
    gl64_t s1_1859_1 = *(gl64_t*)&expressions_params[10][374+1];
    gl64_t s1_1859_2 = *(gl64_t*)&expressions_params[10][374+2];
    gl64_t kA1859 = (tmp3_0 + tmp3_1) * (s1_1859_0 + s1_1859_1);
    gl64_t kB1859 = (tmp3_0 + tmp3_2) * (s1_1859_0 + s1_1859_2);
    gl64_t kC1859 = (tmp3_1 + tmp3_2) * (s1_1859_1 + s1_1859_2);
    gl64_t kD1859 = tmp3_0 * s1_1859_0;
    gl64_t kE1859 = tmp3_1 * s1_1859_1;
    gl64_t kF1859 = tmp3_2 * s1_1859_2;
    gl64_t kG1859 = kD1859 - kE1859;
    tmp3_0 = (kC1859 + kG1859) - kF1859;
    tmp3_1 = ((((kA1859 + kC1859) - kE1859) - kE1859) - kD1859);
    tmp3_2 = kB1859 - kG1859;
    // Op 1860: dim1x1 sub
    gl64_t s0_1860 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1860 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1860 - s1_1860;
    // Op 1861: dim1x1 sub_swap
    gl64_t s1_1861 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1861 - tmp1_0;
    // Op 1862: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1863: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1864: dim3x3 mul
    gl64_t s1_1864_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1864_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1864_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1864 = (tmp3_0 + tmp3_1) * (s1_1864_0 + s1_1864_1);
    gl64_t kB1864 = (tmp3_0 + tmp3_2) * (s1_1864_0 + s1_1864_2);
    gl64_t kC1864 = (tmp3_1 + tmp3_2) * (s1_1864_1 + s1_1864_2);
    gl64_t kD1864 = tmp3_0 * s1_1864_0;
    gl64_t kE1864 = tmp3_1 * s1_1864_1;
    gl64_t kF1864 = tmp3_2 * s1_1864_2;
    gl64_t kG1864 = kD1864 - kE1864;
    tmp3_6 = (kC1864 + kG1864) - kF1864;
    tmp3_7 = ((((kA1864 + kC1864) - kE1864) - kE1864) - kD1864);
    tmp3_8 = kB1864 - kG1864;
    // Op 1865: dim1x1 sub
    gl64_t s1_1865 = *(gl64_t*)&expressions_params[10][100];
    tmp1_0 = tmp1_4 - s1_1865;
    // Op 1866: dim1x1 sub
    gl64_t s1_1866 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1866;
    // Op 1867: dim3x1 mul
    gl64_t s0_1867_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1867_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1867_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1867_0 * tmp1_0; tmp3_1 = s0_1867_1 * tmp1_0; tmp3_2 = s0_1867_2 * tmp1_0;
    // Op 1868: dim3x1 add
    gl64_t s1_1868 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1868; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1869: dim3x3 add
    gl64_t s1_1869_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1869_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1869_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1869_0; tmp3_1 = tmp3_1 + s1_1869_1; tmp3_2 = tmp3_2 + s1_1869_2;
    // Op 1870: dim3x3 mul
    gl64_t s1_1870_0 = *(gl64_t*)&expressions_params[10][377];
    gl64_t s1_1870_1 = *(gl64_t*)&expressions_params[10][377+1];
    gl64_t s1_1870_2 = *(gl64_t*)&expressions_params[10][377+2];
    gl64_t kA1870 = (tmp3_0 + tmp3_1) * (s1_1870_0 + s1_1870_1);
    gl64_t kB1870 = (tmp3_0 + tmp3_2) * (s1_1870_0 + s1_1870_2);
    gl64_t kC1870 = (tmp3_1 + tmp3_2) * (s1_1870_1 + s1_1870_2);
    gl64_t kD1870 = tmp3_0 * s1_1870_0;
    gl64_t kE1870 = tmp3_1 * s1_1870_1;
    gl64_t kF1870 = tmp3_2 * s1_1870_2;
    gl64_t kG1870 = kD1870 - kE1870;
    tmp3_0 = (kC1870 + kG1870) - kF1870;
    tmp3_1 = ((((kA1870 + kC1870) - kE1870) - kE1870) - kD1870);
    tmp3_2 = kB1870 - kG1870;
    // Op 1871: dim3x1 add
    gl64_t s1_1871 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1871; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1872: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1873: dim3x3 mul
    gl64_t s1_1873_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1873_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1873_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1873 = (tmp3_0 + tmp3_1) * (s1_1873_0 + s1_1873_1);
    gl64_t kB1873 = (tmp3_0 + tmp3_2) * (s1_1873_0 + s1_1873_2);
    gl64_t kC1873 = (tmp3_1 + tmp3_2) * (s1_1873_1 + s1_1873_2);
    gl64_t kD1873 = tmp3_0 * s1_1873_0;
    gl64_t kE1873 = tmp3_1 * s1_1873_1;
    gl64_t kF1873 = tmp3_2 * s1_1873_2;
    gl64_t kG1873 = kD1873 - kE1873;
    tmp3_6 = (kC1873 + kG1873) - kF1873;
    tmp3_7 = ((((kA1873 + kC1873) - kE1873) - kE1873) - kD1873);
    tmp3_8 = kB1873 - kG1873;
    // Op 1874: dim3x1 mul
    gl64_t s0_1874_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1874_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1874_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1874 = *(gl64_t*)&expressions_params[10][69];
    tmp3_0 = s0_1874_0 * s1_1874; tmp3_1 = s0_1874_1 * s1_1874; tmp3_2 = s0_1874_2 * s1_1874;
    // Op 1875: dim3x1 add
    gl64_t s1_1875 = *(gl64_t*)&expressions_params[10][68];
    tmp3_0 = tmp3_0 + s1_1875; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1876: dim3x3 mul
    gl64_t s1_1876_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1876_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1876_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1876 = (tmp3_0 + tmp3_1) * (s1_1876_0 + s1_1876_1);
    gl64_t kB1876 = (tmp3_0 + tmp3_2) * (s1_1876_0 + s1_1876_2);
    gl64_t kC1876 = (tmp3_1 + tmp3_2) * (s1_1876_1 + s1_1876_2);
    gl64_t kD1876 = tmp3_0 * s1_1876_0;
    gl64_t kE1876 = tmp3_1 * s1_1876_1;
    gl64_t kF1876 = tmp3_2 * s1_1876_2;
    gl64_t kG1876 = kD1876 - kE1876;
    tmp3_0 = (kC1876 + kG1876) - kF1876;
    tmp3_1 = ((((kA1876 + kC1876) - kE1876) - kE1876) - kD1876);
    tmp3_2 = kB1876 - kG1876;
    // Op 1877: dim3x1 add
    gl64_t s1_1877 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1877; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1878: dim3x3 mul
    gl64_t s1_1878_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1878_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1878_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1878 = (tmp3_0 + tmp3_1) * (s1_1878_0 + s1_1878_1);
    gl64_t kB1878 = (tmp3_0 + tmp3_2) * (s1_1878_0 + s1_1878_2);
    gl64_t kC1878 = (tmp3_1 + tmp3_2) * (s1_1878_1 + s1_1878_2);
    gl64_t kD1878 = tmp3_0 * s1_1878_0;
    gl64_t kE1878 = tmp3_1 * s1_1878_1;
    gl64_t kF1878 = tmp3_2 * s1_1878_2;
    gl64_t kG1878 = kD1878 - kE1878;
    tmp3_0 = (kC1878 + kG1878) - kF1878;
    tmp3_1 = ((((kA1878 + kC1878) - kE1878) - kE1878) - kD1878);
    tmp3_2 = kB1878 - kG1878;
    // Op 1879: dim3x1 add
    gl64_t s1_1879 = *(gl64_t*)&expressions_params[10][100];
    tmp3_0 = tmp3_0 + s1_1879; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1880: dim3x3 mul
    gl64_t s1_1880_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1880_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1880_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1880 = (tmp3_0 + tmp3_1) * (s1_1880_0 + s1_1880_1);
    gl64_t kB1880 = (tmp3_0 + tmp3_2) * (s1_1880_0 + s1_1880_2);
    gl64_t kC1880 = (tmp3_1 + tmp3_2) * (s1_1880_1 + s1_1880_2);
    gl64_t kD1880 = tmp3_0 * s1_1880_0;
    gl64_t kE1880 = tmp3_1 * s1_1880_1;
    gl64_t kF1880 = tmp3_2 * s1_1880_2;
    gl64_t kG1880 = kD1880 - kE1880;
    tmp3_0 = (kC1880 + kG1880) - kF1880;
    tmp3_1 = ((((kA1880 + kC1880) - kE1880) - kE1880) - kD1880);
    tmp3_2 = kB1880 - kG1880;
    // Op 1881: dim3x1 add
    gl64_t s1_1881 = *(gl64_t*)&expressions_params[9][47];
    tmp3_0 = tmp3_0 + s1_1881; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1882: dim3x3 mul
    gl64_t s1_1882_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1882_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1882_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1882 = (tmp3_0 + tmp3_1) * (s1_1882_0 + s1_1882_1);
    gl64_t kB1882 = (tmp3_0 + tmp3_2) * (s1_1882_0 + s1_1882_2);
    gl64_t kC1882 = (tmp3_1 + tmp3_2) * (s1_1882_1 + s1_1882_2);
    gl64_t kD1882 = tmp3_0 * s1_1882_0;
    gl64_t kE1882 = tmp3_1 * s1_1882_1;
    gl64_t kF1882 = tmp3_2 * s1_1882_2;
    gl64_t kG1882 = kD1882 - kE1882;
    tmp3_0 = (kC1882 + kG1882) - kF1882;
    tmp3_1 = ((((kA1882 + kC1882) - kE1882) - kE1882) - kD1882);
    tmp3_2 = kB1882 - kG1882;
    // Op 1883: dim3x1 add
    gl64_t s1_1883 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1883; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1884: dim3x3 mul
    gl64_t s1_1884_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1884_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1884_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1884 = (tmp3_0 + tmp3_1) * (s1_1884_0 + s1_1884_1);
    gl64_t kB1884 = (tmp3_0 + tmp3_2) * (s1_1884_0 + s1_1884_2);
    gl64_t kC1884 = (tmp3_1 + tmp3_2) * (s1_1884_1 + s1_1884_2);
    gl64_t kD1884 = tmp3_0 * s1_1884_0;
    gl64_t kE1884 = tmp3_1 * s1_1884_1;
    gl64_t kF1884 = tmp3_2 * s1_1884_2;
    gl64_t kG1884 = kD1884 - kE1884;
    tmp3_0 = (kC1884 + kG1884) - kF1884;
    tmp3_1 = ((((kA1884 + kC1884) - kE1884) - kE1884) - kD1884);
    tmp3_2 = kB1884 - kG1884;
    // Op 1885: dim3x1 add
    gl64_t s1_1885 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1885; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1886: dim3x3 add
    gl64_t s1_1886_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1886_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1886_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1886_0; tmp3_1 = tmp3_1 + s1_1886_1; tmp3_2 = tmp3_2 + s1_1886_2;
    // Op 1887: dim3x3 mul
    gl64_t s1_1887_0 = *(gl64_t*)&expressions_params[10][380];
    gl64_t s1_1887_1 = *(gl64_t*)&expressions_params[10][380+1];
    gl64_t s1_1887_2 = *(gl64_t*)&expressions_params[10][380+2];
    gl64_t kA1887 = (tmp3_0 + tmp3_1) * (s1_1887_0 + s1_1887_1);
    gl64_t kB1887 = (tmp3_0 + tmp3_2) * (s1_1887_0 + s1_1887_2);
    gl64_t kC1887 = (tmp3_1 + tmp3_2) * (s1_1887_1 + s1_1887_2);
    gl64_t kD1887 = tmp3_0 * s1_1887_0;
    gl64_t kE1887 = tmp3_1 * s1_1887_1;
    gl64_t kF1887 = tmp3_2 * s1_1887_2;
    gl64_t kG1887 = kD1887 - kE1887;
    tmp3_0 = (kC1887 + kG1887) - kF1887;
    tmp3_1 = ((((kA1887 + kC1887) - kE1887) - kE1887) - kD1887);
    tmp3_2 = kB1887 - kG1887;
    // Op 1888: dim3x1 sub
    gl64_t s1_1888 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1888; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1889: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1890: dim3x3 mul
    gl64_t s1_1890_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1890_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1890_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1890 = (tmp3_0 + tmp3_1) * (s1_1890_0 + s1_1890_1);
    gl64_t kB1890 = (tmp3_0 + tmp3_2) * (s1_1890_0 + s1_1890_2);
    gl64_t kC1890 = (tmp3_1 + tmp3_2) * (s1_1890_1 + s1_1890_2);
    gl64_t kD1890 = tmp3_0 * s1_1890_0;
    gl64_t kE1890 = tmp3_1 * s1_1890_1;
    gl64_t kF1890 = tmp3_2 * s1_1890_2;
    gl64_t kG1890 = kD1890 - kE1890;
    tmp3_6 = (kC1890 + kG1890) - kF1890;
    tmp3_7 = ((((kA1890 + kC1890) - kE1890) - kE1890) - kD1890);
    tmp3_8 = kB1890 - kG1890;
    // Op 1891: dim3x1 mul
    gl64_t s0_1891_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1891_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1891_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1891 = *(gl64_t*)&expressions_params[10][69];
    tmp3_0 = s0_1891_0 * s1_1891; tmp3_1 = s0_1891_1 * s1_1891; tmp3_2 = s0_1891_2 * s1_1891;
    // Op 1892: dim3x1 add
    gl64_t s1_1892 = *(gl64_t*)&expressions_params[10][68];
    tmp3_0 = tmp3_0 + s1_1892; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1893: dim3x3 mul
    gl64_t s1_1893_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1893_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1893_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1893 = (tmp3_0 + tmp3_1) * (s1_1893_0 + s1_1893_1);
    gl64_t kB1893 = (tmp3_0 + tmp3_2) * (s1_1893_0 + s1_1893_2);
    gl64_t kC1893 = (tmp3_1 + tmp3_2) * (s1_1893_1 + s1_1893_2);
    gl64_t kD1893 = tmp3_0 * s1_1893_0;
    gl64_t kE1893 = tmp3_1 * s1_1893_1;
    gl64_t kF1893 = tmp3_2 * s1_1893_2;
    gl64_t kG1893 = kD1893 - kE1893;
    tmp3_0 = (kC1893 + kG1893) - kF1893;
    tmp3_1 = ((((kA1893 + kC1893) - kE1893) - kE1893) - kD1893);
    tmp3_2 = kB1893 - kG1893;
    // Op 1894: dim3x1 add
    gl64_t s1_1894 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1894; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1895: dim3x3 mul
    gl64_t s1_1895_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1895_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1895_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1895 = (tmp3_0 + tmp3_1) * (s1_1895_0 + s1_1895_1);
    gl64_t kB1895 = (tmp3_0 + tmp3_2) * (s1_1895_0 + s1_1895_2);
    gl64_t kC1895 = (tmp3_1 + tmp3_2) * (s1_1895_1 + s1_1895_2);
    gl64_t kD1895 = tmp3_0 * s1_1895_0;
    gl64_t kE1895 = tmp3_1 * s1_1895_1;
    gl64_t kF1895 = tmp3_2 * s1_1895_2;
    gl64_t kG1895 = kD1895 - kE1895;
    tmp3_0 = (kC1895 + kG1895) - kF1895;
    tmp3_1 = ((((kA1895 + kC1895) - kE1895) - kE1895) - kD1895);
    tmp3_2 = kB1895 - kG1895;
    // Op 1896: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1897: dim3x3 mul
    gl64_t s1_1897_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1897_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1897_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1897 = (tmp3_0 + tmp3_1) * (s1_1897_0 + s1_1897_1);
    gl64_t kB1897 = (tmp3_0 + tmp3_2) * (s1_1897_0 + s1_1897_2);
    gl64_t kC1897 = (tmp3_1 + tmp3_2) * (s1_1897_1 + s1_1897_2);
    gl64_t kD1897 = tmp3_0 * s1_1897_0;
    gl64_t kE1897 = tmp3_1 * s1_1897_1;
    gl64_t kF1897 = tmp3_2 * s1_1897_2;
    gl64_t kG1897 = kD1897 - kE1897;
    tmp3_0 = (kC1897 + kG1897) - kF1897;
    tmp3_1 = ((((kA1897 + kC1897) - kE1897) - kE1897) - kD1897);
    tmp3_2 = kB1897 - kG1897;
    // Op 1898: dim3x1 add
    gl64_t s1_1898 = *(gl64_t*)&expressions_params[9][47];
    tmp3_0 = tmp3_0 + s1_1898; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1899: dim3x3 mul
    gl64_t s1_1899_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1899_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1899_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1899 = (tmp3_0 + tmp3_1) * (s1_1899_0 + s1_1899_1);
    gl64_t kB1899 = (tmp3_0 + tmp3_2) * (s1_1899_0 + s1_1899_2);
    gl64_t kC1899 = (tmp3_1 + tmp3_2) * (s1_1899_1 + s1_1899_2);
    gl64_t kD1899 = tmp3_0 * s1_1899_0;
    gl64_t kE1899 = tmp3_1 * s1_1899_1;
    gl64_t kF1899 = tmp3_2 * s1_1899_2;
    gl64_t kG1899 = kD1899 - kE1899;
    tmp3_0 = (kC1899 + kG1899) - kF1899;
    tmp3_1 = ((((kA1899 + kC1899) - kE1899) - kE1899) - kD1899);
    tmp3_2 = kB1899 - kG1899;
    // Op 1900: dim3x1 add
    gl64_t s1_1900 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1900; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1901: dim3x3 mul
    gl64_t s1_1901_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1901_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1901_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1901 = (tmp3_0 + tmp3_1) * (s1_1901_0 + s1_1901_1);
    gl64_t kB1901 = (tmp3_0 + tmp3_2) * (s1_1901_0 + s1_1901_2);
    gl64_t kC1901 = (tmp3_1 + tmp3_2) * (s1_1901_1 + s1_1901_2);
    gl64_t kD1901 = tmp3_0 * s1_1901_0;
    gl64_t kE1901 = tmp3_1 * s1_1901_1;
    gl64_t kF1901 = tmp3_2 * s1_1901_2;
    gl64_t kG1901 = kD1901 - kE1901;
    tmp3_0 = (kC1901 + kG1901) - kF1901;
    tmp3_1 = ((((kA1901 + kC1901) - kE1901) - kE1901) - kD1901);
    tmp3_2 = kB1901 - kG1901;
    // Op 1902: dim3x1 add
    gl64_t s1_1902 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1902; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1903: dim3x3 add
    gl64_t s1_1903_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1903_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1903_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1903_0; tmp3_1 = tmp3_1 + s1_1903_1; tmp3_2 = tmp3_2 + s1_1903_2;
    // Op 1904: dim3x3 mul
    gl64_t s1_1904_0 = *(gl64_t*)&expressions_params[10][383];
    gl64_t s1_1904_1 = *(gl64_t*)&expressions_params[10][383+1];
    gl64_t s1_1904_2 = *(gl64_t*)&expressions_params[10][383+2];
    gl64_t kA1904 = (tmp3_0 + tmp3_1) * (s1_1904_0 + s1_1904_1);
    gl64_t kB1904 = (tmp3_0 + tmp3_2) * (s1_1904_0 + s1_1904_2);
    gl64_t kC1904 = (tmp3_1 + tmp3_2) * (s1_1904_1 + s1_1904_2);
    gl64_t kD1904 = tmp3_0 * s1_1904_0;
    gl64_t kE1904 = tmp3_1 * s1_1904_1;
    gl64_t kF1904 = tmp3_2 * s1_1904_2;
    gl64_t kG1904 = kD1904 - kE1904;
    tmp3_0 = (kC1904 + kG1904) - kF1904;
    tmp3_1 = ((((kA1904 + kC1904) - kE1904) - kE1904) - kD1904);
    tmp3_2 = kB1904 - kG1904;
    // Op 1905: dim1x1 sub
    gl64_t s0_1905 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1905 = *(gl64_t*)&expressions_params[10][0];
    tmp1_4 = s0_1905 - s1_1905;
    // Op 1906: dim1x1 sub_swap
    gl64_t s1_1906 = *(gl64_t*)&expressions_params[9][1];
    tmp1_4 = s1_1906 - tmp1_4;
    // Op 1907: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1908: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1909: dim3x3 mul
    gl64_t s1_1909_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1909_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1909_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1909 = (tmp3_0 + tmp3_1) * (s1_1909_0 + s1_1909_1);
    gl64_t kB1909 = (tmp3_0 + tmp3_2) * (s1_1909_0 + s1_1909_2);
    gl64_t kC1909 = (tmp3_1 + tmp3_2) * (s1_1909_1 + s1_1909_2);
    gl64_t kD1909 = tmp3_0 * s1_1909_0;
    gl64_t kE1909 = tmp3_1 * s1_1909_1;
    gl64_t kF1909 = tmp3_2 * s1_1909_2;
    gl64_t kG1909 = kD1909 - kE1909;
    tmp3_6 = (kC1909 + kG1909) - kF1909;
    tmp3_7 = ((((kA1909 + kC1909) - kE1909) - kE1909) - kD1909);
    tmp3_8 = kB1909 - kG1909;
    // Op 1910: dim3x1 mul
    gl64_t s0_1910_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1910_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1910_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1910 = *(gl64_t*)&expressions_params[10][1];
    tmp3_0 = s0_1910_0 * s1_1910; tmp3_1 = s0_1910_1 * s1_1910; tmp3_2 = s0_1910_2 * s1_1910;
    // Op 1911: dim3x1 add
    gl64_t s1_1911 = *(gl64_t*)&expressions_params[9][48];
    tmp3_0 = tmp3_0 + s1_1911; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1912: dim3x3 add
    gl64_t s1_1912_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1912_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1912_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1912_0; tmp3_1 = tmp3_1 + s1_1912_1; tmp3_2 = tmp3_2 + s1_1912_2;
    // Op 1913: dim3x3 mul
    gl64_t s1_1913_0 = *(gl64_t*)&expressions_params[10][386];
    gl64_t s1_1913_1 = *(gl64_t*)&expressions_params[10][386+1];
    gl64_t s1_1913_2 = *(gl64_t*)&expressions_params[10][386+2];
    gl64_t kA1913 = (tmp3_0 + tmp3_1) * (s1_1913_0 + s1_1913_1);
    gl64_t kB1913 = (tmp3_0 + tmp3_2) * (s1_1913_0 + s1_1913_2);
    gl64_t kC1913 = (tmp3_1 + tmp3_2) * (s1_1913_1 + s1_1913_2);
    gl64_t kD1913 = tmp3_0 * s1_1913_0;
    gl64_t kE1913 = tmp3_1 * s1_1913_1;
    gl64_t kF1913 = tmp3_2 * s1_1913_2;
    gl64_t kG1913 = kD1913 - kE1913;
    tmp3_0 = (kC1913 + kG1913) - kF1913;
    tmp3_1 = ((((kA1913 + kC1913) - kE1913) - kE1913) - kD1913);
    tmp3_2 = kB1913 - kG1913;
    // Op 1914: dim3x1 add
    gl64_t s1_1914 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1914; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1915: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1916: dim3x3 mul
    gl64_t s1_1916_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1916_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1916_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1916 = (tmp3_0 + tmp3_1) * (s1_1916_0 + s1_1916_1);
    gl64_t kB1916 = (tmp3_0 + tmp3_2) * (s1_1916_0 + s1_1916_2);
    gl64_t kC1916 = (tmp3_1 + tmp3_2) * (s1_1916_1 + s1_1916_2);
    gl64_t kD1916 = tmp3_0 * s1_1916_0;
    gl64_t kE1916 = tmp3_1 * s1_1916_1;
    gl64_t kF1916 = tmp3_2 * s1_1916_2;
    gl64_t kG1916 = kD1916 - kE1916;
    tmp3_12 = (kC1916 + kG1916) - kF1916;
    tmp3_13 = ((((kA1916 + kC1916) - kE1916) - kE1916) - kD1916);
    tmp3_14 = kB1916 - kG1916;
    // Op 1917: dim3x3 sub_swap
    uint64_t s0_1917_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_1917_0 = *(gl64_t*)&dParams->aux_trace[s0_1917_pos];
    gl64_t s0_1917_1 = *(gl64_t*)&dParams->aux_trace[s0_1917_pos + TILE_HEIGHT];
    gl64_t s0_1917_2 = *(gl64_t*)&dParams->aux_trace[s0_1917_pos + 2*TILE_HEIGHT];
    gl64_t s1_1917_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_1917_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_1917_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_6 = s1_1917_0 - s0_1917_0; tmp3_7 = s1_1917_1 - s0_1917_1; tmp3_8 = s1_1917_2 - s0_1917_2;
    // Op 1918: dim3x3 add
    gl64_t s0_1918_0 = *(gl64_t*)&expressions_params[10][101];
    gl64_t s0_1918_1 = *(gl64_t*)&expressions_params[10][101+1];
    gl64_t s0_1918_2 = *(gl64_t*)&expressions_params[10][101+2];
    gl64_t s1_1918_0 = *(gl64_t*)&expressions_params[10][104];
    gl64_t s1_1918_1 = *(gl64_t*)&expressions_params[10][104+1];
    gl64_t s1_1918_2 = *(gl64_t*)&expressions_params[10][104+2];
    tmp3_0 = s0_1918_0 + s1_1918_0; tmp3_1 = s0_1918_1 + s1_1918_1; tmp3_2 = s0_1918_2 + s1_1918_2;
    // Op 1919: dim3x3 add
    gl64_t s1_1919_0 = *(gl64_t*)&expressions_params[10][107];
    gl64_t s1_1919_1 = *(gl64_t*)&expressions_params[10][107+1];
    gl64_t s1_1919_2 = *(gl64_t*)&expressions_params[10][107+2];
    tmp3_0 = tmp3_0 + s1_1919_0; tmp3_1 = tmp3_1 + s1_1919_1; tmp3_2 = tmp3_2 + s1_1919_2;
    // Op 1920: dim3x3 add
    gl64_t s1_1920_0 = *(gl64_t*)&expressions_params[10][110];
    gl64_t s1_1920_1 = *(gl64_t*)&expressions_params[10][110+1];
    gl64_t s1_1920_2 = *(gl64_t*)&expressions_params[10][110+2];
    tmp3_0 = tmp3_0 + s1_1920_0; tmp3_1 = tmp3_1 + s1_1920_1; tmp3_2 = tmp3_2 + s1_1920_2;
    // Op 1921: dim3x3 add
    gl64_t s1_1921_0 = *(gl64_t*)&expressions_params[10][113];
    gl64_t s1_1921_1 = *(gl64_t*)&expressions_params[10][113+1];
    gl64_t s1_1921_2 = *(gl64_t*)&expressions_params[10][113+2];
    tmp3_0 = tmp3_0 + s1_1921_0; tmp3_1 = tmp3_1 + s1_1921_1; tmp3_2 = tmp3_2 + s1_1921_2;
    // Op 1922: dim3x3 add
    gl64_t s1_1922_0 = *(gl64_t*)&expressions_params[10][116];
    gl64_t s1_1922_1 = *(gl64_t*)&expressions_params[10][116+1];
    gl64_t s1_1922_2 = *(gl64_t*)&expressions_params[10][116+2];
    tmp3_0 = tmp3_0 + s1_1922_0; tmp3_1 = tmp3_1 + s1_1922_1; tmp3_2 = tmp3_2 + s1_1922_2;
    // Op 1923: dim3x3 add
    gl64_t s1_1923_0 = *(gl64_t*)&expressions_params[10][119];
    gl64_t s1_1923_1 = *(gl64_t*)&expressions_params[10][119+1];
    gl64_t s1_1923_2 = *(gl64_t*)&expressions_params[10][119+2];
    tmp3_0 = tmp3_0 + s1_1923_0; tmp3_1 = tmp3_1 + s1_1923_1; tmp3_2 = tmp3_2 + s1_1923_2;
    // Op 1924: dim3x3 add
    gl64_t s1_1924_0 = *(gl64_t*)&expressions_params[10][122];
    gl64_t s1_1924_1 = *(gl64_t*)&expressions_params[10][122+1];
    gl64_t s1_1924_2 = *(gl64_t*)&expressions_params[10][122+2];
    tmp3_0 = tmp3_0 + s1_1924_0; tmp3_1 = tmp3_1 + s1_1924_1; tmp3_2 = tmp3_2 + s1_1924_2;
    // Op 1925: dim3x3 add
    gl64_t s1_1925_0 = *(gl64_t*)&expressions_params[10][125];
    gl64_t s1_1925_1 = *(gl64_t*)&expressions_params[10][125+1];
    gl64_t s1_1925_2 = *(gl64_t*)&expressions_params[10][125+2];
    tmp3_0 = tmp3_0 + s1_1925_0; tmp3_1 = tmp3_1 + s1_1925_1; tmp3_2 = tmp3_2 + s1_1925_2;
    // Op 1926: dim3x3 add
    gl64_t s1_1926_0 = *(gl64_t*)&expressions_params[10][128];
    gl64_t s1_1926_1 = *(gl64_t*)&expressions_params[10][128+1];
    gl64_t s1_1926_2 = *(gl64_t*)&expressions_params[10][128+2];
    tmp3_0 = tmp3_0 + s1_1926_0; tmp3_1 = tmp3_1 + s1_1926_1; tmp3_2 = tmp3_2 + s1_1926_2;
    // Op 1927: dim3x3 add
    gl64_t s1_1927_0 = *(gl64_t*)&expressions_params[10][131];
    gl64_t s1_1927_1 = *(gl64_t*)&expressions_params[10][131+1];
    gl64_t s1_1927_2 = *(gl64_t*)&expressions_params[10][131+2];
    tmp3_0 = tmp3_0 + s1_1927_0; tmp3_1 = tmp3_1 + s1_1927_1; tmp3_2 = tmp3_2 + s1_1927_2;
    // Op 1928: dim3x3 add
    gl64_t s1_1928_0 = *(gl64_t*)&expressions_params[10][134];
    gl64_t s1_1928_1 = *(gl64_t*)&expressions_params[10][134+1];
    gl64_t s1_1928_2 = *(gl64_t*)&expressions_params[10][134+2];
    tmp3_0 = tmp3_0 + s1_1928_0; tmp3_1 = tmp3_1 + s1_1928_1; tmp3_2 = tmp3_2 + s1_1928_2;
    // Op 1929: dim3x3 add
    gl64_t s1_1929_0 = *(gl64_t*)&expressions_params[10][137];
    gl64_t s1_1929_1 = *(gl64_t*)&expressions_params[10][137+1];
    gl64_t s1_1929_2 = *(gl64_t*)&expressions_params[10][137+2];
    tmp3_0 = tmp3_0 + s1_1929_0; tmp3_1 = tmp3_1 + s1_1929_1; tmp3_2 = tmp3_2 + s1_1929_2;
    // Op 1930: dim3x3 add
    gl64_t s1_1930_0 = *(gl64_t*)&expressions_params[10][140];
    gl64_t s1_1930_1 = *(gl64_t*)&expressions_params[10][140+1];
    gl64_t s1_1930_2 = *(gl64_t*)&expressions_params[10][140+2];
    tmp3_0 = tmp3_0 + s1_1930_0; tmp3_1 = tmp3_1 + s1_1930_1; tmp3_2 = tmp3_2 + s1_1930_2;
    // Op 1931: dim3x3 add
    gl64_t s1_1931_0 = *(gl64_t*)&expressions_params[10][143];
    gl64_t s1_1931_1 = *(gl64_t*)&expressions_params[10][143+1];
    gl64_t s1_1931_2 = *(gl64_t*)&expressions_params[10][143+2];
    tmp3_0 = tmp3_0 + s1_1931_0; tmp3_1 = tmp3_1 + s1_1931_1; tmp3_2 = tmp3_2 + s1_1931_2;
    // Op 1932: dim3x3 add
    gl64_t s1_1932_0 = *(gl64_t*)&expressions_params[10][146];
    gl64_t s1_1932_1 = *(gl64_t*)&expressions_params[10][146+1];
    gl64_t s1_1932_2 = *(gl64_t*)&expressions_params[10][146+2];
    tmp3_0 = tmp3_0 + s1_1932_0; tmp3_1 = tmp3_1 + s1_1932_1; tmp3_2 = tmp3_2 + s1_1932_2;
    // Op 1933: dim3x3 add
    gl64_t s1_1933_0 = *(gl64_t*)&expressions_params[10][149];
    gl64_t s1_1933_1 = *(gl64_t*)&expressions_params[10][149+1];
    gl64_t s1_1933_2 = *(gl64_t*)&expressions_params[10][149+2];
    tmp3_0 = tmp3_0 + s1_1933_0; tmp3_1 = tmp3_1 + s1_1933_1; tmp3_2 = tmp3_2 + s1_1933_2;
    // Op 1934: dim3x3 add
    gl64_t s1_1934_0 = *(gl64_t*)&expressions_params[10][152];
    gl64_t s1_1934_1 = *(gl64_t*)&expressions_params[10][152+1];
    gl64_t s1_1934_2 = *(gl64_t*)&expressions_params[10][152+2];
    tmp3_0 = tmp3_0 + s1_1934_0; tmp3_1 = tmp3_1 + s1_1934_1; tmp3_2 = tmp3_2 + s1_1934_2;
    // Op 1935: dim3x3 add
    gl64_t s1_1935_0 = *(gl64_t*)&expressions_params[10][155];
    gl64_t s1_1935_1 = *(gl64_t*)&expressions_params[10][155+1];
    gl64_t s1_1935_2 = *(gl64_t*)&expressions_params[10][155+2];
    tmp3_0 = tmp3_0 + s1_1935_0; tmp3_1 = tmp3_1 + s1_1935_1; tmp3_2 = tmp3_2 + s1_1935_2;
    // Op 1936: dim3x3 add
    gl64_t s1_1936_0 = *(gl64_t*)&expressions_params[10][158];
    gl64_t s1_1936_1 = *(gl64_t*)&expressions_params[10][158+1];
    gl64_t s1_1936_2 = *(gl64_t*)&expressions_params[10][158+2];
    tmp3_0 = tmp3_0 + s1_1936_0; tmp3_1 = tmp3_1 + s1_1936_1; tmp3_2 = tmp3_2 + s1_1936_2;
    // Op 1937: dim3x3 add
    gl64_t s1_1937_0 = *(gl64_t*)&expressions_params[10][161];
    gl64_t s1_1937_1 = *(gl64_t*)&expressions_params[10][161+1];
    gl64_t s1_1937_2 = *(gl64_t*)&expressions_params[10][161+2];
    tmp3_0 = tmp3_0 + s1_1937_0; tmp3_1 = tmp3_1 + s1_1937_1; tmp3_2 = tmp3_2 + s1_1937_2;
    // Op 1938: dim3x3 add
    gl64_t s1_1938_0 = *(gl64_t*)&expressions_params[10][164];
    gl64_t s1_1938_1 = *(gl64_t*)&expressions_params[10][164+1];
    gl64_t s1_1938_2 = *(gl64_t*)&expressions_params[10][164+2];
    tmp3_0 = tmp3_0 + s1_1938_0; tmp3_1 = tmp3_1 + s1_1938_1; tmp3_2 = tmp3_2 + s1_1938_2;
    // Op 1939: dim3x3 add
    gl64_t s1_1939_0 = *(gl64_t*)&expressions_params[10][167];
    gl64_t s1_1939_1 = *(gl64_t*)&expressions_params[10][167+1];
    gl64_t s1_1939_2 = *(gl64_t*)&expressions_params[10][167+2];
    tmp3_0 = tmp3_0 + s1_1939_0; tmp3_1 = tmp3_1 + s1_1939_1; tmp3_2 = tmp3_2 + s1_1939_2;
    // Op 1940: dim3x3 add
    gl64_t s1_1940_0 = *(gl64_t*)&expressions_params[10][170];
    gl64_t s1_1940_1 = *(gl64_t*)&expressions_params[10][170+1];
    gl64_t s1_1940_2 = *(gl64_t*)&expressions_params[10][170+2];
    tmp3_0 = tmp3_0 + s1_1940_0; tmp3_1 = tmp3_1 + s1_1940_1; tmp3_2 = tmp3_2 + s1_1940_2;
    // Op 1941: dim3x3 add
    gl64_t s1_1941_0 = *(gl64_t*)&expressions_params[10][173];
    gl64_t s1_1941_1 = *(gl64_t*)&expressions_params[10][173+1];
    gl64_t s1_1941_2 = *(gl64_t*)&expressions_params[10][173+2];
    tmp3_0 = tmp3_0 + s1_1941_0; tmp3_1 = tmp3_1 + s1_1941_1; tmp3_2 = tmp3_2 + s1_1941_2;
    // Op 1942: dim3x3 add
    gl64_t s1_1942_0 = *(gl64_t*)&expressions_params[10][176];
    gl64_t s1_1942_1 = *(gl64_t*)&expressions_params[10][176+1];
    gl64_t s1_1942_2 = *(gl64_t*)&expressions_params[10][176+2];
    tmp3_0 = tmp3_0 + s1_1942_0; tmp3_1 = tmp3_1 + s1_1942_1; tmp3_2 = tmp3_2 + s1_1942_2;
    // Op 1943: dim3x3 add
    gl64_t s1_1943_0 = *(gl64_t*)&expressions_params[10][179];
    gl64_t s1_1943_1 = *(gl64_t*)&expressions_params[10][179+1];
    gl64_t s1_1943_2 = *(gl64_t*)&expressions_params[10][179+2];
    tmp3_0 = tmp3_0 + s1_1943_0; tmp3_1 = tmp3_1 + s1_1943_1; tmp3_2 = tmp3_2 + s1_1943_2;
    // Op 1944: dim3x3 add
    gl64_t s1_1944_0 = *(gl64_t*)&expressions_params[10][182];
    gl64_t s1_1944_1 = *(gl64_t*)&expressions_params[10][182+1];
    gl64_t s1_1944_2 = *(gl64_t*)&expressions_params[10][182+2];
    tmp3_0 = tmp3_0 + s1_1944_0; tmp3_1 = tmp3_1 + s1_1944_1; tmp3_2 = tmp3_2 + s1_1944_2;
    // Op 1945: dim3x3 add
    gl64_t s1_1945_0 = *(gl64_t*)&expressions_params[10][185];
    gl64_t s1_1945_1 = *(gl64_t*)&expressions_params[10][185+1];
    gl64_t s1_1945_2 = *(gl64_t*)&expressions_params[10][185+2];
    tmp3_0 = tmp3_0 + s1_1945_0; tmp3_1 = tmp3_1 + s1_1945_1; tmp3_2 = tmp3_2 + s1_1945_2;
    // Op 1946: dim3x3 add
    gl64_t s1_1946_0 = *(gl64_t*)&expressions_params[10][188];
    gl64_t s1_1946_1 = *(gl64_t*)&expressions_params[10][188+1];
    gl64_t s1_1946_2 = *(gl64_t*)&expressions_params[10][188+2];
    tmp3_0 = tmp3_0 + s1_1946_0; tmp3_1 = tmp3_1 + s1_1946_1; tmp3_2 = tmp3_2 + s1_1946_2;
    // Op 1947: dim3x3 add
    gl64_t s1_1947_0 = *(gl64_t*)&expressions_params[10][191];
    gl64_t s1_1947_1 = *(gl64_t*)&expressions_params[10][191+1];
    gl64_t s1_1947_2 = *(gl64_t*)&expressions_params[10][191+2];
    tmp3_0 = tmp3_0 + s1_1947_0; tmp3_1 = tmp3_1 + s1_1947_1; tmp3_2 = tmp3_2 + s1_1947_2;
    // Op 1948: dim3x3 add
    gl64_t s1_1948_0 = *(gl64_t*)&expressions_params[10][194];
    gl64_t s1_1948_1 = *(gl64_t*)&expressions_params[10][194+1];
    gl64_t s1_1948_2 = *(gl64_t*)&expressions_params[10][194+2];
    tmp3_0 = tmp3_0 + s1_1948_0; tmp3_1 = tmp3_1 + s1_1948_1; tmp3_2 = tmp3_2 + s1_1948_2;
    // Op 1949: dim3x3 add
    gl64_t s1_1949_0 = *(gl64_t*)&expressions_params[10][197];
    gl64_t s1_1949_1 = *(gl64_t*)&expressions_params[10][197+1];
    gl64_t s1_1949_2 = *(gl64_t*)&expressions_params[10][197+2];
    tmp3_0 = tmp3_0 + s1_1949_0; tmp3_1 = tmp3_1 + s1_1949_1; tmp3_2 = tmp3_2 + s1_1949_2;
    // Op 1950: dim3x3 add
    gl64_t s1_1950_0 = *(gl64_t*)&expressions_params[10][200];
    gl64_t s1_1950_1 = *(gl64_t*)&expressions_params[10][200+1];
    gl64_t s1_1950_2 = *(gl64_t*)&expressions_params[10][200+2];
    tmp3_0 = tmp3_0 + s1_1950_0; tmp3_1 = tmp3_1 + s1_1950_1; tmp3_2 = tmp3_2 + s1_1950_2;
    // Op 1951: dim3x3 add
    gl64_t s1_1951_0 = *(gl64_t*)&expressions_params[10][203];
    gl64_t s1_1951_1 = *(gl64_t*)&expressions_params[10][203+1];
    gl64_t s1_1951_2 = *(gl64_t*)&expressions_params[10][203+2];
    tmp3_0 = tmp3_0 + s1_1951_0; tmp3_1 = tmp3_1 + s1_1951_1; tmp3_2 = tmp3_2 + s1_1951_2;
    // Op 1952: dim3x3 add
    gl64_t s1_1952_0 = *(gl64_t*)&expressions_params[10][206];
    gl64_t s1_1952_1 = *(gl64_t*)&expressions_params[10][206+1];
    gl64_t s1_1952_2 = *(gl64_t*)&expressions_params[10][206+2];
    tmp3_0 = tmp3_0 + s1_1952_0; tmp3_1 = tmp3_1 + s1_1952_1; tmp3_2 = tmp3_2 + s1_1952_2;
    // Op 1953: dim3x3 add
    gl64_t s1_1953_0 = *(gl64_t*)&expressions_params[10][209];
    gl64_t s1_1953_1 = *(gl64_t*)&expressions_params[10][209+1];
    gl64_t s1_1953_2 = *(gl64_t*)&expressions_params[10][209+2];
    tmp3_0 = tmp3_0 + s1_1953_0; tmp3_1 = tmp3_1 + s1_1953_1; tmp3_2 = tmp3_2 + s1_1953_2;
    // Op 1954: dim3x3 add
    gl64_t s1_1954_0 = *(gl64_t*)&expressions_params[10][212];
    gl64_t s1_1954_1 = *(gl64_t*)&expressions_params[10][212+1];
    gl64_t s1_1954_2 = *(gl64_t*)&expressions_params[10][212+2];
    tmp3_0 = tmp3_0 + s1_1954_0; tmp3_1 = tmp3_1 + s1_1954_1; tmp3_2 = tmp3_2 + s1_1954_2;
    // Op 1955: dim3x3 add
    gl64_t s1_1955_0 = *(gl64_t*)&expressions_params[10][215];
    gl64_t s1_1955_1 = *(gl64_t*)&expressions_params[10][215+1];
    gl64_t s1_1955_2 = *(gl64_t*)&expressions_params[10][215+2];
    tmp3_0 = tmp3_0 + s1_1955_0; tmp3_1 = tmp3_1 + s1_1955_1; tmp3_2 = tmp3_2 + s1_1955_2;
    // Op 1956: dim3x3 add
    gl64_t s1_1956_0 = *(gl64_t*)&expressions_params[10][218];
    gl64_t s1_1956_1 = *(gl64_t*)&expressions_params[10][218+1];
    gl64_t s1_1956_2 = *(gl64_t*)&expressions_params[10][218+2];
    tmp3_0 = tmp3_0 + s1_1956_0; tmp3_1 = tmp3_1 + s1_1956_1; tmp3_2 = tmp3_2 + s1_1956_2;
    // Op 1957: dim3x3 add
    gl64_t s1_1957_0 = *(gl64_t*)&expressions_params[10][221];
    gl64_t s1_1957_1 = *(gl64_t*)&expressions_params[10][221+1];
    gl64_t s1_1957_2 = *(gl64_t*)&expressions_params[10][221+2];
    tmp3_0 = tmp3_0 + s1_1957_0; tmp3_1 = tmp3_1 + s1_1957_1; tmp3_2 = tmp3_2 + s1_1957_2;
    // Op 1958: dim3x3 add
    gl64_t s1_1958_0 = *(gl64_t*)&expressions_params[10][224];
    gl64_t s1_1958_1 = *(gl64_t*)&expressions_params[10][224+1];
    gl64_t s1_1958_2 = *(gl64_t*)&expressions_params[10][224+2];
    tmp3_0 = tmp3_0 + s1_1958_0; tmp3_1 = tmp3_1 + s1_1958_1; tmp3_2 = tmp3_2 + s1_1958_2;
    // Op 1959: dim3x3 add
    gl64_t s1_1959_0 = *(gl64_t*)&expressions_params[10][227];
    gl64_t s1_1959_1 = *(gl64_t*)&expressions_params[10][227+1];
    gl64_t s1_1959_2 = *(gl64_t*)&expressions_params[10][227+2];
    tmp3_0 = tmp3_0 + s1_1959_0; tmp3_1 = tmp3_1 + s1_1959_1; tmp3_2 = tmp3_2 + s1_1959_2;
    // Op 1960: dim3x3 add
    gl64_t s1_1960_0 = *(gl64_t*)&expressions_params[10][230];
    gl64_t s1_1960_1 = *(gl64_t*)&expressions_params[10][230+1];
    gl64_t s1_1960_2 = *(gl64_t*)&expressions_params[10][230+2];
    tmp3_0 = tmp3_0 + s1_1960_0; tmp3_1 = tmp3_1 + s1_1960_1; tmp3_2 = tmp3_2 + s1_1960_2;
    // Op 1961: dim3x3 add
    gl64_t s1_1961_0 = *(gl64_t*)&expressions_params[10][233];
    gl64_t s1_1961_1 = *(gl64_t*)&expressions_params[10][233+1];
    gl64_t s1_1961_2 = *(gl64_t*)&expressions_params[10][233+2];
    tmp3_0 = tmp3_0 + s1_1961_0; tmp3_1 = tmp3_1 + s1_1961_1; tmp3_2 = tmp3_2 + s1_1961_2;
    // Op 1962: dim3x3 add
    gl64_t s1_1962_0 = *(gl64_t*)&expressions_params[10][236];
    gl64_t s1_1962_1 = *(gl64_t*)&expressions_params[10][236+1];
    gl64_t s1_1962_2 = *(gl64_t*)&expressions_params[10][236+2];
    tmp3_0 = tmp3_0 + s1_1962_0; tmp3_1 = tmp3_1 + s1_1962_1; tmp3_2 = tmp3_2 + s1_1962_2;
    // Op 1963: dim3x3 add
    gl64_t s1_1963_0 = *(gl64_t*)&expressions_params[10][239];
    gl64_t s1_1963_1 = *(gl64_t*)&expressions_params[10][239+1];
    gl64_t s1_1963_2 = *(gl64_t*)&expressions_params[10][239+2];
    tmp3_0 = tmp3_0 + s1_1963_0; tmp3_1 = tmp3_1 + s1_1963_1; tmp3_2 = tmp3_2 + s1_1963_2;
    // Op 1964: dim3x3 add
    gl64_t s1_1964_0 = *(gl64_t*)&expressions_params[10][242];
    gl64_t s1_1964_1 = *(gl64_t*)&expressions_params[10][242+1];
    gl64_t s1_1964_2 = *(gl64_t*)&expressions_params[10][242+2];
    tmp3_0 = tmp3_0 + s1_1964_0; tmp3_1 = tmp3_1 + s1_1964_1; tmp3_2 = tmp3_2 + s1_1964_2;
    // Op 1965: dim3x3 add
    gl64_t s1_1965_0 = *(gl64_t*)&expressions_params[10][245];
    gl64_t s1_1965_1 = *(gl64_t*)&expressions_params[10][245+1];
    gl64_t s1_1965_2 = *(gl64_t*)&expressions_params[10][245+2];
    tmp3_0 = tmp3_0 + s1_1965_0; tmp3_1 = tmp3_1 + s1_1965_1; tmp3_2 = tmp3_2 + s1_1965_2;
    // Op 1966: dim3x3 add
    gl64_t s1_1966_0 = *(gl64_t*)&expressions_params[10][248];
    gl64_t s1_1966_1 = *(gl64_t*)&expressions_params[10][248+1];
    gl64_t s1_1966_2 = *(gl64_t*)&expressions_params[10][248+2];
    tmp3_0 = tmp3_0 + s1_1966_0; tmp3_1 = tmp3_1 + s1_1966_1; tmp3_2 = tmp3_2 + s1_1966_2;
    // Op 1967: dim3x3 add
    gl64_t s1_1967_0 = *(gl64_t*)&expressions_params[10][251];
    gl64_t s1_1967_1 = *(gl64_t*)&expressions_params[10][251+1];
    gl64_t s1_1967_2 = *(gl64_t*)&expressions_params[10][251+2];
    tmp3_0 = tmp3_0 + s1_1967_0; tmp3_1 = tmp3_1 + s1_1967_1; tmp3_2 = tmp3_2 + s1_1967_2;
    // Op 1968: dim3x3 add
    gl64_t s1_1968_0 = *(gl64_t*)&expressions_params[10][254];
    gl64_t s1_1968_1 = *(gl64_t*)&expressions_params[10][254+1];
    gl64_t s1_1968_2 = *(gl64_t*)&expressions_params[10][254+2];
    tmp3_0 = tmp3_0 + s1_1968_0; tmp3_1 = tmp3_1 + s1_1968_1; tmp3_2 = tmp3_2 + s1_1968_2;
    // Op 1969: dim3x3 add
    gl64_t s1_1969_0 = *(gl64_t*)&expressions_params[10][257];
    gl64_t s1_1969_1 = *(gl64_t*)&expressions_params[10][257+1];
    gl64_t s1_1969_2 = *(gl64_t*)&expressions_params[10][257+2];
    tmp3_0 = tmp3_0 + s1_1969_0; tmp3_1 = tmp3_1 + s1_1969_1; tmp3_2 = tmp3_2 + s1_1969_2;
    // Op 1970: dim3x3 add
    gl64_t s1_1970_0 = *(gl64_t*)&expressions_params[10][260];
    gl64_t s1_1970_1 = *(gl64_t*)&expressions_params[10][260+1];
    gl64_t s1_1970_2 = *(gl64_t*)&expressions_params[10][260+2];
    tmp3_0 = tmp3_0 + s1_1970_0; tmp3_1 = tmp3_1 + s1_1970_1; tmp3_2 = tmp3_2 + s1_1970_2;
    // Op 1971: dim3x3 add
    gl64_t s1_1971_0 = *(gl64_t*)&expressions_params[10][263];
    gl64_t s1_1971_1 = *(gl64_t*)&expressions_params[10][263+1];
    gl64_t s1_1971_2 = *(gl64_t*)&expressions_params[10][263+2];
    tmp3_0 = tmp3_0 + s1_1971_0; tmp3_1 = tmp3_1 + s1_1971_1; tmp3_2 = tmp3_2 + s1_1971_2;
    // Op 1972: dim3x3 add
    gl64_t s1_1972_0 = *(gl64_t*)&expressions_params[10][266];
    gl64_t s1_1972_1 = *(gl64_t*)&expressions_params[10][266+1];
    gl64_t s1_1972_2 = *(gl64_t*)&expressions_params[10][266+2];
    tmp3_0 = tmp3_0 + s1_1972_0; tmp3_1 = tmp3_1 + s1_1972_1; tmp3_2 = tmp3_2 + s1_1972_2;
    // Op 1973: dim3x3 add
    gl64_t s1_1973_0 = *(gl64_t*)&expressions_params[10][269];
    gl64_t s1_1973_1 = *(gl64_t*)&expressions_params[10][269+1];
    gl64_t s1_1973_2 = *(gl64_t*)&expressions_params[10][269+2];
    tmp3_0 = tmp3_0 + s1_1973_0; tmp3_1 = tmp3_1 + s1_1973_1; tmp3_2 = tmp3_2 + s1_1973_2;
    // Op 1974: dim3x3 add
    gl64_t s1_1974_0 = *(gl64_t*)&expressions_params[10][272];
    gl64_t s1_1974_1 = *(gl64_t*)&expressions_params[10][272+1];
    gl64_t s1_1974_2 = *(gl64_t*)&expressions_params[10][272+2];
    tmp3_0 = tmp3_0 + s1_1974_0; tmp3_1 = tmp3_1 + s1_1974_1; tmp3_2 = tmp3_2 + s1_1974_2;
    // Op 1975: dim3x3 add
    gl64_t s1_1975_0 = *(gl64_t*)&expressions_params[10][275];
    gl64_t s1_1975_1 = *(gl64_t*)&expressions_params[10][275+1];
    gl64_t s1_1975_2 = *(gl64_t*)&expressions_params[10][275+2];
    tmp3_0 = tmp3_0 + s1_1975_0; tmp3_1 = tmp3_1 + s1_1975_1; tmp3_2 = tmp3_2 + s1_1975_2;
    // Op 1976: dim3x3 add
    gl64_t s1_1976_0 = *(gl64_t*)&expressions_params[10][278];
    gl64_t s1_1976_1 = *(gl64_t*)&expressions_params[10][278+1];
    gl64_t s1_1976_2 = *(gl64_t*)&expressions_params[10][278+2];
    tmp3_0 = tmp3_0 + s1_1976_0; tmp3_1 = tmp3_1 + s1_1976_1; tmp3_2 = tmp3_2 + s1_1976_2;
    // Op 1977: dim3x3 add
    gl64_t s1_1977_0 = *(gl64_t*)&expressions_params[10][281];
    gl64_t s1_1977_1 = *(gl64_t*)&expressions_params[10][281+1];
    gl64_t s1_1977_2 = *(gl64_t*)&expressions_params[10][281+2];
    tmp3_0 = tmp3_0 + s1_1977_0; tmp3_1 = tmp3_1 + s1_1977_1; tmp3_2 = tmp3_2 + s1_1977_2;
    // Op 1978: dim3x3 add
    gl64_t s1_1978_0 = *(gl64_t*)&expressions_params[10][284];
    gl64_t s1_1978_1 = *(gl64_t*)&expressions_params[10][284+1];
    gl64_t s1_1978_2 = *(gl64_t*)&expressions_params[10][284+2];
    tmp3_0 = tmp3_0 + s1_1978_0; tmp3_1 = tmp3_1 + s1_1978_1; tmp3_2 = tmp3_2 + s1_1978_2;
    // Op 1979: dim3x3 add
    gl64_t s1_1979_0 = *(gl64_t*)&expressions_params[10][287];
    gl64_t s1_1979_1 = *(gl64_t*)&expressions_params[10][287+1];
    gl64_t s1_1979_2 = *(gl64_t*)&expressions_params[10][287+2];
    tmp3_0 = tmp3_0 + s1_1979_0; tmp3_1 = tmp3_1 + s1_1979_1; tmp3_2 = tmp3_2 + s1_1979_2;
    // Op 1980: dim3x3 add
    gl64_t s1_1980_0 = *(gl64_t*)&expressions_params[10][290];
    gl64_t s1_1980_1 = *(gl64_t*)&expressions_params[10][290+1];
    gl64_t s1_1980_2 = *(gl64_t*)&expressions_params[10][290+2];
    tmp3_0 = tmp3_0 + s1_1980_0; tmp3_1 = tmp3_1 + s1_1980_1; tmp3_2 = tmp3_2 + s1_1980_2;
    // Op 1981: dim3x3 add
    gl64_t s1_1981_0 = *(gl64_t*)&expressions_params[10][293];
    gl64_t s1_1981_1 = *(gl64_t*)&expressions_params[10][293+1];
    gl64_t s1_1981_2 = *(gl64_t*)&expressions_params[10][293+2];
    tmp3_0 = tmp3_0 + s1_1981_0; tmp3_1 = tmp3_1 + s1_1981_1; tmp3_2 = tmp3_2 + s1_1981_2;
    // Op 1982: dim3x3 add
    gl64_t s1_1982_0 = *(gl64_t*)&expressions_params[10][296];
    gl64_t s1_1982_1 = *(gl64_t*)&expressions_params[10][296+1];
    gl64_t s1_1982_2 = *(gl64_t*)&expressions_params[10][296+2];
    tmp3_0 = tmp3_0 + s1_1982_0; tmp3_1 = tmp3_1 + s1_1982_1; tmp3_2 = tmp3_2 + s1_1982_2;
    // Op 1983: dim3x3 add
    gl64_t s1_1983_0 = *(gl64_t*)&expressions_params[10][299];
    gl64_t s1_1983_1 = *(gl64_t*)&expressions_params[10][299+1];
    gl64_t s1_1983_2 = *(gl64_t*)&expressions_params[10][299+2];
    tmp3_0 = tmp3_0 + s1_1983_0; tmp3_1 = tmp3_1 + s1_1983_1; tmp3_2 = tmp3_2 + s1_1983_2;
    // Op 1984: dim3x3 add
    gl64_t s1_1984_0 = *(gl64_t*)&expressions_params[10][302];
    gl64_t s1_1984_1 = *(gl64_t*)&expressions_params[10][302+1];
    gl64_t s1_1984_2 = *(gl64_t*)&expressions_params[10][302+2];
    tmp3_0 = tmp3_0 + s1_1984_0; tmp3_1 = tmp3_1 + s1_1984_1; tmp3_2 = tmp3_2 + s1_1984_2;
    // Op 1985: dim3x3 add
    gl64_t s1_1985_0 = *(gl64_t*)&expressions_params[10][305];
    gl64_t s1_1985_1 = *(gl64_t*)&expressions_params[10][305+1];
    gl64_t s1_1985_2 = *(gl64_t*)&expressions_params[10][305+2];
    tmp3_0 = tmp3_0 + s1_1985_0; tmp3_1 = tmp3_1 + s1_1985_1; tmp3_2 = tmp3_2 + s1_1985_2;
    // Op 1986: dim3x3 add
    gl64_t s1_1986_0 = *(gl64_t*)&expressions_params[10][308];
    gl64_t s1_1986_1 = *(gl64_t*)&expressions_params[10][308+1];
    gl64_t s1_1986_2 = *(gl64_t*)&expressions_params[10][308+2];
    tmp3_0 = tmp3_0 + s1_1986_0; tmp3_1 = tmp3_1 + s1_1986_1; tmp3_2 = tmp3_2 + s1_1986_2;
    // Op 1987: dim3x3 add
    gl64_t s1_1987_0 = *(gl64_t*)&expressions_params[10][311];
    gl64_t s1_1987_1 = *(gl64_t*)&expressions_params[10][311+1];
    gl64_t s1_1987_2 = *(gl64_t*)&expressions_params[10][311+2];
    tmp3_0 = tmp3_0 + s1_1987_0; tmp3_1 = tmp3_1 + s1_1987_1; tmp3_2 = tmp3_2 + s1_1987_2;
    // Op 1988: dim3x3 add
    gl64_t s1_1988_0 = *(gl64_t*)&expressions_params[10][314];
    gl64_t s1_1988_1 = *(gl64_t*)&expressions_params[10][314+1];
    gl64_t s1_1988_2 = *(gl64_t*)&expressions_params[10][314+2];
    tmp3_0 = tmp3_0 + s1_1988_0; tmp3_1 = tmp3_1 + s1_1988_1; tmp3_2 = tmp3_2 + s1_1988_2;
    // Op 1989: dim3x3 add
    gl64_t s1_1989_0 = *(gl64_t*)&expressions_params[10][317];
    gl64_t s1_1989_1 = *(gl64_t*)&expressions_params[10][317+1];
    gl64_t s1_1989_2 = *(gl64_t*)&expressions_params[10][317+2];
    tmp3_0 = tmp3_0 + s1_1989_0; tmp3_1 = tmp3_1 + s1_1989_1; tmp3_2 = tmp3_2 + s1_1989_2;
    // Op 1990: dim3x3 add
    gl64_t s1_1990_0 = *(gl64_t*)&expressions_params[10][320];
    gl64_t s1_1990_1 = *(gl64_t*)&expressions_params[10][320+1];
    gl64_t s1_1990_2 = *(gl64_t*)&expressions_params[10][320+2];
    tmp3_0 = tmp3_0 + s1_1990_0; tmp3_1 = tmp3_1 + s1_1990_1; tmp3_2 = tmp3_2 + s1_1990_2;
    // Op 1991: dim3x3 add
    gl64_t s1_1991_0 = *(gl64_t*)&expressions_params[10][323];
    gl64_t s1_1991_1 = *(gl64_t*)&expressions_params[10][323+1];
    gl64_t s1_1991_2 = *(gl64_t*)&expressions_params[10][323+2];
    tmp3_0 = tmp3_0 + s1_1991_0; tmp3_1 = tmp3_1 + s1_1991_1; tmp3_2 = tmp3_2 + s1_1991_2;
    // Op 1992: dim3x3 add
    gl64_t s1_1992_0 = *(gl64_t*)&expressions_params[10][326];
    gl64_t s1_1992_1 = *(gl64_t*)&expressions_params[10][326+1];
    gl64_t s1_1992_2 = *(gl64_t*)&expressions_params[10][326+2];
    tmp3_0 = tmp3_0 + s1_1992_0; tmp3_1 = tmp3_1 + s1_1992_1; tmp3_2 = tmp3_2 + s1_1992_2;
    // Op 1993: dim3x3 add
    gl64_t s1_1993_0 = *(gl64_t*)&expressions_params[10][329];
    gl64_t s1_1993_1 = *(gl64_t*)&expressions_params[10][329+1];
    gl64_t s1_1993_2 = *(gl64_t*)&expressions_params[10][329+2];
    tmp3_0 = tmp3_0 + s1_1993_0; tmp3_1 = tmp3_1 + s1_1993_1; tmp3_2 = tmp3_2 + s1_1993_2;
    // Op 1994: dim3x3 add
    gl64_t s1_1994_0 = *(gl64_t*)&expressions_params[10][332];
    gl64_t s1_1994_1 = *(gl64_t*)&expressions_params[10][332+1];
    gl64_t s1_1994_2 = *(gl64_t*)&expressions_params[10][332+2];
    tmp3_0 = tmp3_0 + s1_1994_0; tmp3_1 = tmp3_1 + s1_1994_1; tmp3_2 = tmp3_2 + s1_1994_2;
    // Op 1995: dim3x3 add
    gl64_t s1_1995_0 = *(gl64_t*)&expressions_params[10][335];
    gl64_t s1_1995_1 = *(gl64_t*)&expressions_params[10][335+1];
    gl64_t s1_1995_2 = *(gl64_t*)&expressions_params[10][335+2];
    tmp3_0 = tmp3_0 + s1_1995_0; tmp3_1 = tmp3_1 + s1_1995_1; tmp3_2 = tmp3_2 + s1_1995_2;
    // Op 1996: dim3x3 add
    gl64_t s1_1996_0 = *(gl64_t*)&expressions_params[10][338];
    gl64_t s1_1996_1 = *(gl64_t*)&expressions_params[10][338+1];
    gl64_t s1_1996_2 = *(gl64_t*)&expressions_params[10][338+2];
    tmp3_0 = tmp3_0 + s1_1996_0; tmp3_1 = tmp3_1 + s1_1996_1; tmp3_2 = tmp3_2 + s1_1996_2;
    // Op 1997: dim3x3 add
    gl64_t s1_1997_0 = *(gl64_t*)&expressions_params[10][341];
    gl64_t s1_1997_1 = *(gl64_t*)&expressions_params[10][341+1];
    gl64_t s1_1997_2 = *(gl64_t*)&expressions_params[10][341+2];
    tmp3_0 = tmp3_0 + s1_1997_0; tmp3_1 = tmp3_1 + s1_1997_1; tmp3_2 = tmp3_2 + s1_1997_2;
    // Op 1998: dim3x3 add
    gl64_t s1_1998_0 = *(gl64_t*)&expressions_params[10][344];
    gl64_t s1_1998_1 = *(gl64_t*)&expressions_params[10][344+1];
    gl64_t s1_1998_2 = *(gl64_t*)&expressions_params[10][344+2];
    tmp3_0 = tmp3_0 + s1_1998_0; tmp3_1 = tmp3_1 + s1_1998_1; tmp3_2 = tmp3_2 + s1_1998_2;
    // Op 1999: dim3x3 add
    gl64_t s1_1999_0 = *(gl64_t*)&expressions_params[10][347];
    gl64_t s1_1999_1 = *(gl64_t*)&expressions_params[10][347+1];
    gl64_t s1_1999_2 = *(gl64_t*)&expressions_params[10][347+2];
    tmp3_0 = tmp3_0 + s1_1999_0; tmp3_1 = tmp3_1 + s1_1999_1; tmp3_2 = tmp3_2 + s1_1999_2;
    // Op 2000: dim3x3 add
    gl64_t s1_2000_0 = *(gl64_t*)&expressions_params[10][350];
    gl64_t s1_2000_1 = *(gl64_t*)&expressions_params[10][350+1];
    gl64_t s1_2000_2 = *(gl64_t*)&expressions_params[10][350+2];
    tmp3_0 = tmp3_0 + s1_2000_0; tmp3_1 = tmp3_1 + s1_2000_1; tmp3_2 = tmp3_2 + s1_2000_2;
    // Op 2001: dim3x3 add
    gl64_t s1_2001_0 = *(gl64_t*)&expressions_params[10][353];
    gl64_t s1_2001_1 = *(gl64_t*)&expressions_params[10][353+1];
    gl64_t s1_2001_2 = *(gl64_t*)&expressions_params[10][353+2];
    tmp3_0 = tmp3_0 + s1_2001_0; tmp3_1 = tmp3_1 + s1_2001_1; tmp3_2 = tmp3_2 + s1_2001_2;
    // Op 2002: dim3x3 add
    gl64_t s1_2002_0 = *(gl64_t*)&expressions_params[10][356];
    gl64_t s1_2002_1 = *(gl64_t*)&expressions_params[10][356+1];
    gl64_t s1_2002_2 = *(gl64_t*)&expressions_params[10][356+2];
    tmp3_0 = tmp3_0 + s1_2002_0; tmp3_1 = tmp3_1 + s1_2002_1; tmp3_2 = tmp3_2 + s1_2002_2;
    // Op 2003: dim3x3 add
    gl64_t s1_2003_0 = *(gl64_t*)&expressions_params[10][359];
    gl64_t s1_2003_1 = *(gl64_t*)&expressions_params[10][359+1];
    gl64_t s1_2003_2 = *(gl64_t*)&expressions_params[10][359+2];
    tmp3_0 = tmp3_0 + s1_2003_0; tmp3_1 = tmp3_1 + s1_2003_1; tmp3_2 = tmp3_2 + s1_2003_2;
    // Op 2004: dim3x3 add
    gl64_t s1_2004_0 = *(gl64_t*)&expressions_params[10][362];
    gl64_t s1_2004_1 = *(gl64_t*)&expressions_params[10][362+1];
    gl64_t s1_2004_2 = *(gl64_t*)&expressions_params[10][362+2];
    tmp3_0 = tmp3_0 + s1_2004_0; tmp3_1 = tmp3_1 + s1_2004_1; tmp3_2 = tmp3_2 + s1_2004_2;
    // Op 2005: dim3x3 add
    gl64_t s1_2005_0 = *(gl64_t*)&expressions_params[10][365];
    gl64_t s1_2005_1 = *(gl64_t*)&expressions_params[10][365+1];
    gl64_t s1_2005_2 = *(gl64_t*)&expressions_params[10][365+2];
    tmp3_0 = tmp3_0 + s1_2005_0; tmp3_1 = tmp3_1 + s1_2005_1; tmp3_2 = tmp3_2 + s1_2005_2;
    // Op 2006: dim3x3 add
    gl64_t s1_2006_0 = *(gl64_t*)&expressions_params[10][368];
    gl64_t s1_2006_1 = *(gl64_t*)&expressions_params[10][368+1];
    gl64_t s1_2006_2 = *(gl64_t*)&expressions_params[10][368+2];
    tmp3_0 = tmp3_0 + s1_2006_0; tmp3_1 = tmp3_1 + s1_2006_1; tmp3_2 = tmp3_2 + s1_2006_2;
    // Op 2007: dim3x3 add
    gl64_t s1_2007_0 = *(gl64_t*)&expressions_params[10][371];
    gl64_t s1_2007_1 = *(gl64_t*)&expressions_params[10][371+1];
    gl64_t s1_2007_2 = *(gl64_t*)&expressions_params[10][371+2];
    tmp3_0 = tmp3_0 + s1_2007_0; tmp3_1 = tmp3_1 + s1_2007_1; tmp3_2 = tmp3_2 + s1_2007_2;
    // Op 2008: dim3x3 add
    gl64_t s1_2008_0 = *(gl64_t*)&expressions_params[10][374];
    gl64_t s1_2008_1 = *(gl64_t*)&expressions_params[10][374+1];
    gl64_t s1_2008_2 = *(gl64_t*)&expressions_params[10][374+2];
    tmp3_0 = tmp3_0 + s1_2008_0; tmp3_1 = tmp3_1 + s1_2008_1; tmp3_2 = tmp3_2 + s1_2008_2;
    // Op 2009: dim3x3 add
    gl64_t s1_2009_0 = *(gl64_t*)&expressions_params[10][377];
    gl64_t s1_2009_1 = *(gl64_t*)&expressions_params[10][377+1];
    gl64_t s1_2009_2 = *(gl64_t*)&expressions_params[10][377+2];
    tmp3_0 = tmp3_0 + s1_2009_0; tmp3_1 = tmp3_1 + s1_2009_1; tmp3_2 = tmp3_2 + s1_2009_2;
    // Op 2010: dim3x3 add
    gl64_t s1_2010_0 = *(gl64_t*)&expressions_params[10][380];
    gl64_t s1_2010_1 = *(gl64_t*)&expressions_params[10][380+1];
    gl64_t s1_2010_2 = *(gl64_t*)&expressions_params[10][380+2];
    tmp3_0 = tmp3_0 + s1_2010_0; tmp3_1 = tmp3_1 + s1_2010_1; tmp3_2 = tmp3_2 + s1_2010_2;
    // Op 2011: dim3x3 add
    gl64_t s1_2011_0 = *(gl64_t*)&expressions_params[10][383];
    gl64_t s1_2011_1 = *(gl64_t*)&expressions_params[10][383+1];
    gl64_t s1_2011_2 = *(gl64_t*)&expressions_params[10][383+2];
    tmp3_0 = tmp3_0 + s1_2011_0; tmp3_1 = tmp3_1 + s1_2011_1; tmp3_2 = tmp3_2 + s1_2011_2;
    // Op 2012: dim3x3 add
    gl64_t s1_2012_0 = *(gl64_t*)&expressions_params[10][386];
    gl64_t s1_2012_1 = *(gl64_t*)&expressions_params[10][386+1];
    gl64_t s1_2012_2 = *(gl64_t*)&expressions_params[10][386+2];
    tmp3_0 = tmp3_0 + s1_2012_0; tmp3_1 = tmp3_1 + s1_2012_1; tmp3_2 = tmp3_2 + s1_2012_2;
    // Op 2013: dim3x3 sub
    tmp3_0 = tmp3_6 - tmp3_0; tmp3_1 = tmp3_7 - tmp3_1; tmp3_2 = tmp3_8 - tmp3_2;
    // Op 2014: dim3x1 mul
    gl64_t s1_2014 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_2014; tmp3_1 = tmp3_1 * s1_2014; tmp3_2 = tmp3_2 * s1_2014;
    // Op 2015: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 2016: dim3x1 mul
    gl64_t s1_2016 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_2016; tmp3_1 = tmp3_1 * s1_2016; tmp3_2 = tmp3_2 * s1_2016;

    storePolynomial3__((ExpsArguments*)dExpsArgs, tmp3_0, tmp3_1, tmp3_2, row);
}
