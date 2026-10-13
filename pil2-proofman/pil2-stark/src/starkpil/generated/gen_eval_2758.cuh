// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: b9824128  nOps=2020 nTemp1=5 nTemp3=5
#define GENERATED_EVAL_NOPS_b9824128 2020
#define GENERATED_EVAL_NTEMP1_b9824128 5
#define GENERATED_EVAL_NTEMP3_b9824128 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_b9824128(
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
    // Op 96: dim1x1 mul
    gl64_t s0_96 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_96 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_1 = s0_96 * s1_96;
    // Op 97: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 98: dim3x3 mul
    gl64_t s1_98_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_98_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_98_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 99: dim1x1 sub_swap
    gl64_t s0_99 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_99 = *(gl64_t*)&expressions_params[9][0];
    tmp1_2 = s1_99 - s0_99;
    // Op 100: dim1x1 add
    gl64_t s0_100 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 4, domainSize, nCols_1))];
    gl64_t s1_100 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 26, domainSize, nCols_1))];
    tmp1_1 = s0_100 + s1_100;
    // Op 101: dim1x1 mul
    gl64_t s0_101 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 25, domainSize, nCols_1))];
    tmp1_0 = s0_101 * tmp1_1;
    // Op 102: dim1x1 sub_swap
    gl64_t s0_102 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 25, domainSize, nCols_1))];
    gl64_t s1_102 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s1_102 - s0_102;
    // Op 103: dim1x1 add
    gl64_t s0_103 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 7, domainSize, nCols_1))];
    gl64_t s1_103 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 27, domainSize, nCols_1))];
    tmp1_3 = s0_103 + s1_103;
    // Op 104: dim1x1 mul
    tmp1_1 = tmp1_1 * tmp1_3;
    // Op 105: dim1x1 add
    tmp1_1 = tmp1_0 + tmp1_1;
    // Op 106: dim1x1 sub
    gl64_t s0_106 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 26, domainSize, nCols_1))];
    gl64_t s1_106 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 27, domainSize, nCols_1))];
    tmp1_0 = s0_106 - s1_106;
    // Op 107: dim1x1 mul
    gl64_t s0_107 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 6, domainSize, nCols_1))];
    tmp1_0 = s0_107 * tmp1_0;
    // Op 108: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 109: dim1x1 sub
    gl64_t s0_109 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_109 - tmp1_0;
    // Op 110: dim1x1 mul
    tmp1_0 = tmp1_2 * tmp1_0;
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
    // Op 113: dim1x1 add
    gl64_t s0_113 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_113 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_113 + s1_113;
    // Op 114: dim1x1 mul
    gl64_t s0_114 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_1 = s0_114 * tmp1_0;
    // Op 115: dim1x1 sub_swap
    gl64_t s0_115 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_115 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_115 - s0_115;
    // Op 116: dim1x1 add
    gl64_t s0_116 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_116 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp1_2 = s0_116 + s1_116;
    // Op 117: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_2;
    // Op 118: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 119: dim1x1 sub
    gl64_t s0_119 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_119 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp1_0 = s0_119 - s1_119;
    // Op 120: dim1x1 mul
    gl64_t s0_120 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_120 * tmp1_0;
    // Op 121: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 122: dim1x1 sub_swap
    gl64_t s1_122 = *(gl64_t*)&expressions_params[10][5];
    tmp1_0 = s1_122 - tmp1_0;
    // Op 123: dim1x1 mul
    gl64_t s0_123 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_123 * tmp1_0;
    // Op 124: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 125: dim3x3 mul
    gl64_t s1_125_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_125_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_125_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 126: dim1x1 sub_swap
    gl64_t s0_126 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_126 = *(gl64_t*)&expressions_params[10][6];
    tmp1_0 = s1_126 - s0_126;
    // Op 127: dim1x1 mul
    gl64_t s0_127 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
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
    gl64_t s0_130 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_130 = *(gl64_t*)&expressions_params[10][7];
    tmp1_0 = s1_130 - s0_130;
    // Op 131: dim1x1 mul
    gl64_t s0_131 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_131 * tmp1_0;
    // Op 132: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 133: dim3x3 mul
    gl64_t s1_133_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_133_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_133_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA133 = (tmp3_0 + tmp3_1) * (s1_133_0 + s1_133_1);
    gl64_t kB133 = (tmp3_0 + tmp3_2) * (s1_133_0 + s1_133_2);
    gl64_t kC133 = (tmp3_1 + tmp3_2) * (s1_133_1 + s1_133_2);
    gl64_t kD133 = tmp3_0 * s1_133_0;
    gl64_t kE133 = tmp3_1 * s1_133_1;
    gl64_t kF133 = tmp3_2 * s1_133_2;
    gl64_t kG133 = kD133 - kE133;
    tmp3_0 = (kC133 + kG133) - kF133;
    tmp3_1 = ((((kA133 + kC133) - kE133) - kE133) - kD133);
    tmp3_2 = kB133 - kG133;
    // Op 134: dim1x1 sub_swap
    gl64_t s0_134 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_134 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_134 - s0_134;
    // Op 135: dim1x1 mul
    gl64_t s0_135 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_135 * tmp1_0;
    // Op 136: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC137 + kG137) - kF137;
    tmp3_1 = ((((kA137 + kC137) - kE137) - kE137) - kD137);
    tmp3_2 = kB137 - kG137;
    // Op 138: dim1x1 sub_swap
    gl64_t s0_138 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_138 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_138 - s0_138;
    // Op 139: dim1x1 mul
    gl64_t s0_139 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_139 * tmp1_0;
    // Op 140: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 141: dim3x3 mul
    gl64_t s1_141_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_141_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_141_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA141 = (tmp3_0 + tmp3_1) * (s1_141_0 + s1_141_1);
    gl64_t kB141 = (tmp3_0 + tmp3_2) * (s1_141_0 + s1_141_2);
    gl64_t kC141 = (tmp3_1 + tmp3_2) * (s1_141_1 + s1_141_2);
    gl64_t kD141 = tmp3_0 * s1_141_0;
    gl64_t kE141 = tmp3_1 * s1_141_1;
    gl64_t kF141 = tmp3_2 * s1_141_2;
    gl64_t kG141 = kD141 - kE141;
    tmp3_0 = (kC141 + kG141) - kF141;
    tmp3_1 = ((((kA141 + kC141) - kE141) - kE141) - kD141);
    tmp3_2 = kB141 - kG141;
    // Op 142: dim1x1 sub_swap
    gl64_t s0_142 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_142 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_142 - s0_142;
    // Op 143: dim1x1 mul
    gl64_t s0_143 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_143 * tmp1_0;
    // Op 144: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC145 + kG145) - kF145;
    tmp3_1 = ((((kA145 + kC145) - kE145) - kE145) - kD145);
    tmp3_2 = kB145 - kG145;
    // Op 146: dim1x1 sub_swap
    gl64_t s0_146 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_146 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_146 - s0_146;
    // Op 147: dim1x1 mul
    gl64_t s0_147 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_147 * tmp1_0;
    // Op 148: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 149: dim3x3 mul
    gl64_t s1_149_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_149_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_149_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA149 = (tmp3_0 + tmp3_1) * (s1_149_0 + s1_149_1);
    gl64_t kB149 = (tmp3_0 + tmp3_2) * (s1_149_0 + s1_149_2);
    gl64_t kC149 = (tmp3_1 + tmp3_2) * (s1_149_1 + s1_149_2);
    gl64_t kD149 = tmp3_0 * s1_149_0;
    gl64_t kE149 = tmp3_1 * s1_149_1;
    gl64_t kF149 = tmp3_2 * s1_149_2;
    gl64_t kG149 = kD149 - kE149;
    tmp3_0 = (kC149 + kG149) - kF149;
    tmp3_1 = ((((kA149 + kC149) - kE149) - kE149) - kD149);
    tmp3_2 = kB149 - kG149;
    // Op 150: dim1x1 sub_swap
    gl64_t s0_150 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_150 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_150 - s0_150;
    // Op 151: dim1x1 mul
    gl64_t s0_151 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_151 * tmp1_0;
    // Op 152: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC153 + kG153) - kF153;
    tmp3_1 = ((((kA153 + kC153) - kE153) - kE153) - kD153);
    tmp3_2 = kB153 - kG153;
    // Op 154: dim1x1 sub_swap
    gl64_t s0_154 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_154 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_154 - s0_154;
    // Op 155: dim1x1 mul
    gl64_t s0_155 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_155 * tmp1_0;
    // Op 156: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 157: dim3x3 mul
    gl64_t s1_157_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_157_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_157_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA157 = (tmp3_0 + tmp3_1) * (s1_157_0 + s1_157_1);
    gl64_t kB157 = (tmp3_0 + tmp3_2) * (s1_157_0 + s1_157_2);
    gl64_t kC157 = (tmp3_1 + tmp3_2) * (s1_157_1 + s1_157_2);
    gl64_t kD157 = tmp3_0 * s1_157_0;
    gl64_t kE157 = tmp3_1 * s1_157_1;
    gl64_t kF157 = tmp3_2 * s1_157_2;
    gl64_t kG157 = kD157 - kE157;
    tmp3_0 = (kC157 + kG157) - kF157;
    tmp3_1 = ((((kA157 + kC157) - kE157) - kE157) - kD157);
    tmp3_2 = kB157 - kG157;
    // Op 158: dim1x1 sub_swap
    gl64_t s0_158 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_158 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_158 - s0_158;
    // Op 159: dim1x1 mul
    gl64_t s0_159 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_0 = s0_159 * tmp1_0;
    // Op 160: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 161: dim3x3 mul
    gl64_t s1_161_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_161_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_161_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 162: dim1x1 sub_swap
    gl64_t s0_162 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    gl64_t s1_162 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_162 - s0_162;
    // Op 163: dim1x1 mul
    gl64_t s0_163 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_163 * tmp1_0;
    // Op 164: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 165: dim3x3 mul
    gl64_t s1_165_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_165_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_165_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 166: dim1x1 sub_swap
    gl64_t s0_166 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_166 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_166 - s0_166;
    // Op 167: dim1x1 mul
    gl64_t s0_167 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_167 * tmp1_0;
    // Op 168: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 169: dim3x3 mul
    gl64_t s1_169_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_169_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_169_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 170: dim1x1 sub_swap
    gl64_t s0_170 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_170 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_170 - s0_170;
    // Op 171: dim1x1 mul
    gl64_t s0_171 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = s0_171 * tmp1_0;
    // Op 172: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 173: dim3x3 mul
    gl64_t s1_173_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_173_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_173_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 174: dim1x1 sub_swap
    gl64_t s0_174 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_174 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_174 - s0_174;
    // Op 175: dim1x1 mul
    gl64_t s0_175 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_0 = s0_175 * tmp1_0;
    // Op 176: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 177: dim3x3 mul
    gl64_t s1_177_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_177_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_177_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 178: dim1x1 sub_swap
    gl64_t s0_178 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_178 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_178 - s0_178;
    // Op 179: dim1x1 mul
    gl64_t s0_179 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_179 * tmp1_0;
    // Op 180: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 181: dim3x3 mul
    gl64_t s1_181_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_181_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_181_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 182: dim1x1 sub_swap
    gl64_t s0_182 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    gl64_t s1_182 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_182 - s0_182;
    // Op 183: dim1x1 mul
    gl64_t s0_183 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_183 * tmp1_0;
    // Op 184: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 185: dim3x3 mul
    gl64_t s1_185_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_185_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_185_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 186: dim1x1 sub_swap
    gl64_t s0_186 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    gl64_t s1_186 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_186 - s0_186;
    // Op 187: dim1x1 mul
    gl64_t s0_187 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    tmp1_0 = s0_187 * tmp1_0;
    // Op 188: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 189: dim3x3 mul
    gl64_t s1_189_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_189_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_189_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA189 = (tmp3_0 + tmp3_1) * (s1_189_0 + s1_189_1);
    gl64_t kB189 = (tmp3_0 + tmp3_2) * (s1_189_0 + s1_189_2);
    gl64_t kC189 = (tmp3_1 + tmp3_2) * (s1_189_1 + s1_189_2);
    gl64_t kD189 = tmp3_0 * s1_189_0;
    gl64_t kE189 = tmp3_1 * s1_189_1;
    gl64_t kF189 = tmp3_2 * s1_189_2;
    gl64_t kG189 = kD189 - kE189;
    tmp3_0 = (kC189 + kG189) - kF189;
    tmp3_1 = ((((kA189 + kC189) - kE189) - kE189) - kD189);
    tmp3_2 = kB189 - kG189;
    // Op 190: dim1x1 sub_swap
    gl64_t s0_190 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    gl64_t s1_190 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_190 - s0_190;
    // Op 191: dim1x1 mul
    gl64_t s0_191 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    tmp1_0 = s0_191 * tmp1_0;
    // Op 192: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 193: dim3x3 mul
    gl64_t s1_193_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_193_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_193_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA193 = (tmp3_0 + tmp3_1) * (s1_193_0 + s1_193_1);
    gl64_t kB193 = (tmp3_0 + tmp3_2) * (s1_193_0 + s1_193_2);
    gl64_t kC193 = (tmp3_1 + tmp3_2) * (s1_193_1 + s1_193_2);
    gl64_t kD193 = tmp3_0 * s1_193_0;
    gl64_t kE193 = tmp3_1 * s1_193_1;
    gl64_t kF193 = tmp3_2 * s1_193_2;
    gl64_t kG193 = kD193 - kE193;
    tmp3_0 = (kC193 + kG193) - kF193;
    tmp3_1 = ((((kA193 + kC193) - kE193) - kE193) - kD193);
    tmp3_2 = kB193 - kG193;
    // Op 194: dim1x1 sub_swap
    gl64_t s0_194 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    gl64_t s1_194 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_194 - s0_194;
    // Op 195: dim1x1 mul
    gl64_t s0_195 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    tmp1_0 = s0_195 * tmp1_0;
    // Op 196: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 197: dim3x3 mul
    gl64_t s1_197_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_197_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_197_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA197 = (tmp3_0 + tmp3_1) * (s1_197_0 + s1_197_1);
    gl64_t kB197 = (tmp3_0 + tmp3_2) * (s1_197_0 + s1_197_2);
    gl64_t kC197 = (tmp3_1 + tmp3_2) * (s1_197_1 + s1_197_2);
    gl64_t kD197 = tmp3_0 * s1_197_0;
    gl64_t kE197 = tmp3_1 * s1_197_1;
    gl64_t kF197 = tmp3_2 * s1_197_2;
    gl64_t kG197 = kD197 - kE197;
    tmp3_0 = (kC197 + kG197) - kF197;
    tmp3_1 = ((((kA197 + kC197) - kE197) - kE197) - kD197);
    tmp3_2 = kB197 - kG197;
    // Op 198: dim1x1 sub_swap
    gl64_t s0_198 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_198 = *(gl64_t*)&expressions_params[10][2];
    tmp1_0 = s1_198 - s0_198;
    // Op 199: dim1x1 mul
    gl64_t s0_199 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_0 = s0_199 * tmp1_0;
    // Op 200: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_12 = (kC201 + kG201) - kF201;
    tmp3_13 = ((((kA201 + kC201) - kE201) - kE201) - kD201);
    tmp3_14 = kB201 - kG201;
    // Op 202: dim3x1 mul
    gl64_t s0_202_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_202_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_202_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_202 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp3_0 = s0_202_0 * s1_202; tmp3_1 = s0_202_1 * s1_202; tmp3_2 = s0_202_2 * s1_202;
    // Op 203: dim3x1 add
    gl64_t s1_203 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
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
    gl64_t s1_205 = *(gl64_t*)&expressions_params[9][2];
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
    // Op 207: dim1x1 mul
    gl64_t s0_207 = *(gl64_t*)&expressions_params[9][5];
    gl64_t s1_207 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_207 * s1_207;
    // Op 208: dim1x1 add
    gl64_t s0_208 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_0)];
    tmp1_4 = s0_208 + tmp1_0;
    // Op 209: dim1x1 mul
    gl64_t s1_209 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = tmp1_4 * s1_209;
    // Op 210: dim1x1 add
    gl64_t s1_210 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = tmp1_0 + s1_210;
    // Op 211: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 212: dim3x3 mul
    gl64_t s1_212_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_212_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_212_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    gl64_t s1_213 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_213; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 214: dim3x3 mul
    gl64_t s1_214_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_214_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_214_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA214 = (tmp3_0 + tmp3_1) * (s1_214_0 + s1_214_1);
    gl64_t kB214 = (tmp3_0 + tmp3_2) * (s1_214_0 + s1_214_2);
    gl64_t kC214 = (tmp3_1 + tmp3_2) * (s1_214_1 + s1_214_2);
    gl64_t kD214 = tmp3_0 * s1_214_0;
    gl64_t kE214 = tmp3_1 * s1_214_1;
    gl64_t kF214 = tmp3_2 * s1_214_2;
    gl64_t kG214 = kD214 - kE214;
    tmp3_0 = (kC214 + kG214) - kF214;
    tmp3_1 = ((((kA214 + kC214) - kE214) - kE214) - kD214);
    tmp3_2 = kB214 - kG214;
    // Op 215: dim1x1 mul
    gl64_t s0_215 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    gl64_t s1_215 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_215 * s1_215;
    // Op 216: dim1x1 add
    gl64_t s0_216 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_216 + tmp1_0;
    // Op 217: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 218: dim3x3 mul
    gl64_t s1_218_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_218_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_218_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA218 = (tmp3_0 + tmp3_1) * (s1_218_0 + s1_218_1);
    gl64_t kB218 = (tmp3_0 + tmp3_2) * (s1_218_0 + s1_218_2);
    gl64_t kC218 = (tmp3_1 + tmp3_2) * (s1_218_1 + s1_218_2);
    gl64_t kD218 = tmp3_0 * s1_218_0;
    gl64_t kE218 = tmp3_1 * s1_218_1;
    gl64_t kF218 = tmp3_2 * s1_218_2;
    gl64_t kG218 = kD218 - kE218;
    tmp3_0 = (kC218 + kG218) - kF218;
    tmp3_1 = ((((kA218 + kC218) - kE218) - kE218) - kD218);
    tmp3_2 = kB218 - kG218;
    // Op 219: dim3x1 add
    gl64_t s1_219 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_0 + s1_219; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 220: dim3x3 add
    gl64_t s1_220_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_220_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_220_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_220_0; tmp3_4 = tmp3_10 + s1_220_1; tmp3_5 = tmp3_11 + s1_220_2;
    // Op 221: dim3x1 mul
    gl64_t s0_221_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_221_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_221_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_221 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp3_0 = s0_221_0 * s1_221; tmp3_1 = s0_221_1 * s1_221; tmp3_2 = s0_221_2 * s1_221;
    // Op 222: dim3x1 add
    gl64_t s1_222 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
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
    // Op 224: dim3x1 add
    gl64_t s1_224 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_224; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 225: dim3x3 mul
    gl64_t s1_225_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_225_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_225_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA225 = (tmp3_0 + tmp3_1) * (s1_225_0 + s1_225_1);
    gl64_t kB225 = (tmp3_0 + tmp3_2) * (s1_225_0 + s1_225_2);
    gl64_t kC225 = (tmp3_1 + tmp3_2) * (s1_225_1 + s1_225_2);
    gl64_t kD225 = tmp3_0 * s1_225_0;
    gl64_t kE225 = tmp3_1 * s1_225_1;
    gl64_t kF225 = tmp3_2 * s1_225_2;
    gl64_t kG225 = kD225 - kE225;
    tmp3_0 = (kC225 + kG225) - kF225;
    tmp3_1 = ((((kA225 + kC225) - kE225) - kE225) - kD225);
    tmp3_2 = kB225 - kG225;
    // Op 226: dim3x1 add
    gl64_t s1_226 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_226; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 227: dim3x3 mul
    gl64_t s1_227_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_227_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_227_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA227 = (tmp3_0 + tmp3_1) * (s1_227_0 + s1_227_1);
    gl64_t kB227 = (tmp3_0 + tmp3_2) * (s1_227_0 + s1_227_2);
    gl64_t kC227 = (tmp3_1 + tmp3_2) * (s1_227_1 + s1_227_2);
    gl64_t kD227 = tmp3_0 * s1_227_0;
    gl64_t kE227 = tmp3_1 * s1_227_1;
    gl64_t kF227 = tmp3_2 * s1_227_2;
    gl64_t kG227 = kD227 - kE227;
    tmp3_0 = (kC227 + kG227) - kF227;
    tmp3_1 = ((((kA227 + kC227) - kE227) - kE227) - kD227);
    tmp3_2 = kB227 - kG227;
    // Op 228: dim3x1 add
    gl64_t s1_228 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_228; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 229: dim3x3 mul
    gl64_t s1_229_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_229_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_229_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA229 = (tmp3_0 + tmp3_1) * (s1_229_0 + s1_229_1);
    gl64_t kB229 = (tmp3_0 + tmp3_2) * (s1_229_0 + s1_229_2);
    gl64_t kC229 = (tmp3_1 + tmp3_2) * (s1_229_1 + s1_229_2);
    gl64_t kD229 = tmp3_0 * s1_229_0;
    gl64_t kE229 = tmp3_1 * s1_229_1;
    gl64_t kF229 = tmp3_2 * s1_229_2;
    gl64_t kG229 = kD229 - kE229;
    tmp3_0 = (kC229 + kG229) - kF229;
    tmp3_1 = ((((kA229 + kC229) - kE229) - kE229) - kD229);
    tmp3_2 = kB229 - kG229;
    // Op 230: dim3x1 add
    gl64_t s1_230 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_230; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 232: dim3x1 add
    gl64_t s1_232 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_0 + s1_232; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 233: dim3x3 add
    gl64_t s1_233_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_233_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_233_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_233_0; tmp3_1 = tmp3_7 + s1_233_1; tmp3_2 = tmp3_8 + s1_233_2;
    // Op 234: dim3x3 mul
    gl64_t kA234 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB234 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC234 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD234 = tmp3_3 * tmp3_0;
    gl64_t kE234 = tmp3_4 * tmp3_1;
    gl64_t kF234 = tmp3_5 * tmp3_2;
    gl64_t kG234 = kD234 - kE234;
    tmp3_0 = (kC234 + kG234) - kF234;
    tmp3_1 = ((((kA234 + kC234) - kE234) - kE234) - kD234);
    tmp3_2 = kB234 - kG234;
    // Op 235: dim3x3 mul
    gl64_t s0_235_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_235_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_235_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA235 = (s0_235_0 + s0_235_1) * (tmp3_0 + tmp3_1);
    gl64_t kB235 = (s0_235_0 + s0_235_2) * (tmp3_0 + tmp3_2);
    gl64_t kC235 = (s0_235_1 + s0_235_2) * (tmp3_1 + tmp3_2);
    gl64_t kD235 = s0_235_0 * tmp3_0;
    gl64_t kE235 = s0_235_1 * tmp3_1;
    gl64_t kF235 = s0_235_2 * tmp3_2;
    gl64_t kG235 = kD235 - kE235;
    tmp3_0 = (kC235 + kG235) - kF235;
    tmp3_1 = ((((kA235 + kC235) - kE235) - kE235) - kD235);
    tmp3_2 = kB235 - kG235;
    // Op 236: dim1x1 add
    gl64_t s0_236 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_236 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    tmp1_0 = s0_236 + s1_236;
    // Op 237: dim1x1 sub_swap
    gl64_t s1_237 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_237 - tmp1_0;
    // Op 238: dim3x3 add
    gl64_t s1_238_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_238_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_238_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_238_0; tmp3_7 = tmp3_7 + s1_238_1; tmp3_8 = tmp3_8 + s1_238_2;
    // Op 239: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_0; tmp3_7 = tmp3_7 * tmp1_0; tmp3_8 = tmp3_8 * tmp1_0;
    // Op 240: dim3x3 add
    gl64_t s1_240_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_240_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_240_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_240_0; tmp3_10 = tmp3_10 + s1_240_1; tmp3_11 = tmp3_11 + s1_240_2;
    // Op 241: dim3x1 mul
    gl64_t s1_241 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_241; tmp3_10 = tmp3_10 * s1_241; tmp3_11 = tmp3_11 * s1_241;
    // Op 242: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 243: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 244: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 245: dim3x3 mul
    gl64_t s1_245_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_245_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_245_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA245 = (tmp3_0 + tmp3_1) * (s1_245_0 + s1_245_1);
    gl64_t kB245 = (tmp3_0 + tmp3_2) * (s1_245_0 + s1_245_2);
    gl64_t kC245 = (tmp3_1 + tmp3_2) * (s1_245_1 + s1_245_2);
    gl64_t kD245 = tmp3_0 * s1_245_0;
    gl64_t kE245 = tmp3_1 * s1_245_1;
    gl64_t kF245 = tmp3_2 * s1_245_2;
    gl64_t kG245 = kD245 - kE245;
    tmp3_3 = (kC245 + kG245) - kF245;
    tmp3_4 = ((((kA245 + kC245) - kE245) - kE245) - kD245);
    tmp3_5 = kB245 - kG245;
    // Op 246: dim3x1 mul
    gl64_t s0_246_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_246_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_246_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_246 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    tmp3_0 = s0_246_0 * s1_246; tmp3_1 = s0_246_1 * s1_246; tmp3_2 = s0_246_2 * s1_246;
    // Op 247: dim3x1 add
    gl64_t s1_247 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_247; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_249 = *(gl64_t*)&expressions_params[9][2];
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
    gl64_t s1_251 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_251; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 252: dim3x3 mul
    gl64_t s1_252_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_252_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_252_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA252 = (tmp3_0 + tmp3_1) * (s1_252_0 + s1_252_1);
    gl64_t kB252 = (tmp3_0 + tmp3_2) * (s1_252_0 + s1_252_2);
    gl64_t kC252 = (tmp3_1 + tmp3_2) * (s1_252_1 + s1_252_2);
    gl64_t kD252 = tmp3_0 * s1_252_0;
    gl64_t kE252 = tmp3_1 * s1_252_1;
    gl64_t kF252 = tmp3_2 * s1_252_2;
    gl64_t kG252 = kD252 - kE252;
    tmp3_0 = (kC252 + kG252) - kF252;
    tmp3_1 = ((((kA252 + kC252) - kE252) - kE252) - kD252);
    tmp3_2 = kB252 - kG252;
    // Op 253: dim3x1 add
    gl64_t s1_253 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_253; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 254: dim3x3 mul
    gl64_t s1_254_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_254_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_254_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    gl64_t s1_255 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_255; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 256: dim3x3 mul
    gl64_t s1_256_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_256_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_256_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA256 = (tmp3_0 + tmp3_1) * (s1_256_0 + s1_256_1);
    gl64_t kB256 = (tmp3_0 + tmp3_2) * (s1_256_0 + s1_256_2);
    gl64_t kC256 = (tmp3_1 + tmp3_2) * (s1_256_1 + s1_256_2);
    gl64_t kD256 = tmp3_0 * s1_256_0;
    gl64_t kE256 = tmp3_1 * s1_256_1;
    gl64_t kF256 = tmp3_2 * s1_256_2;
    gl64_t kG256 = kD256 - kE256;
    tmp3_0 = (kC256 + kG256) - kF256;
    tmp3_1 = ((((kA256 + kC256) - kE256) - kE256) - kD256);
    tmp3_2 = kB256 - kG256;
    // Op 257: dim3x1 add
    gl64_t s1_257 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_0 + s1_257; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 258: dim3x3 add
    gl64_t s1_258_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_258_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_258_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_258_0; tmp3_13 = tmp3_10 + s1_258_1; tmp3_14 = tmp3_11 + s1_258_2;
    // Op 259: dim1x1 sub_swap
    gl64_t s0_259 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    tmp1_1 = tmp1_1 - s0_259;
    // Op 260: dim1x1 sub
    gl64_t s1_260 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = tmp1_1 - s1_260;
    // Op 261: dim3x1 mul
    gl64_t s0_261_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_261_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_261_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_261_0 * tmp1_1; tmp3_1 = s0_261_1 * tmp1_1; tmp3_2 = s0_261_2 * tmp1_1;
    // Op 262: dim3x1 add
    gl64_t s1_262 = *(gl64_t*)&expressions_params[9][7];
    tmp3_6 = tmp3_0 + s1_262; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 263: dim3x3 add
    gl64_t s1_263_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_263_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_263_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_263_0; tmp3_1 = tmp3_7 + s1_263_1; tmp3_2 = tmp3_8 + s1_263_2;
    // Op 264: dim3x3 mul
    gl64_t kA264 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB264 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC264 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD264 = tmp3_12 * tmp3_0;
    gl64_t kE264 = tmp3_13 * tmp3_1;
    gl64_t kF264 = tmp3_14 * tmp3_2;
    gl64_t kG264 = kD264 - kE264;
    tmp3_0 = (kC264 + kG264) - kF264;
    tmp3_1 = ((((kA264 + kC264) - kE264) - kE264) - kD264);
    tmp3_2 = kB264 - kG264;
    // Op 265: dim3x3 mul
    gl64_t s0_265_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_265_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_265_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA265 = (s0_265_0 + s0_265_1) * (tmp3_0 + tmp3_1);
    gl64_t kB265 = (s0_265_0 + s0_265_2) * (tmp3_0 + tmp3_2);
    gl64_t kC265 = (s0_265_1 + s0_265_2) * (tmp3_1 + tmp3_2);
    gl64_t kD265 = s0_265_0 * tmp3_0;
    gl64_t kE265 = s0_265_1 * tmp3_1;
    gl64_t kF265 = s0_265_2 * tmp3_2;
    gl64_t kG265 = kD265 - kE265;
    tmp3_0 = (kC265 + kG265) - kF265;
    tmp3_1 = ((((kA265 + kC265) - kE265) - kE265) - kD265);
    tmp3_2 = kB265 - kG265;
    // Op 266: dim3x3 add
    gl64_t s1_266_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_266_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_266_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_266_0; tmp3_7 = tmp3_7 + s1_266_1; tmp3_8 = tmp3_8 + s1_266_2;
    // Op 267: dim3x1 mul
    gl64_t s1_267 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    tmp3_6 = tmp3_6 * s1_267; tmp3_7 = tmp3_7 * s1_267; tmp3_8 = tmp3_8 * s1_267;
    // Op 268: dim1x1 sub_swap
    gl64_t s0_268 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    gl64_t s1_268 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_268 - s0_268;
    // Op 269: dim3x3 add
    gl64_t s1_269_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_269_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_269_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_269_0; tmp3_10 = tmp3_10 + s1_269_1; tmp3_11 = tmp3_11 + s1_269_2;
    // Op 270: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_1; tmp3_10 = tmp3_10 * tmp1_1; tmp3_11 = tmp3_11 * tmp1_1;
    // Op 271: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 272: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 273: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 274: dim3x3 mul
    gl64_t s1_274_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_274_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_274_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA274 = (tmp3_0 + tmp3_1) * (s1_274_0 + s1_274_1);
    gl64_t kB274 = (tmp3_0 + tmp3_2) * (s1_274_0 + s1_274_2);
    gl64_t kC274 = (tmp3_1 + tmp3_2) * (s1_274_1 + s1_274_2);
    gl64_t kD274 = tmp3_0 * s1_274_0;
    gl64_t kE274 = tmp3_1 * s1_274_1;
    gl64_t kF274 = tmp3_2 * s1_274_2;
    gl64_t kG274 = kD274 - kE274;
    tmp3_12 = (kC274 + kG274) - kF274;
    tmp3_13 = ((((kA274 + kC274) - kE274) - kE274) - kD274);
    tmp3_14 = kB274 - kG274;
    // Op 275: dim1x1 mul
    gl64_t s1_275 = *(gl64_t*)&expressions_params[9][6];
    tmp1_1 = tmp1_4 * s1_275;
    // Op 276: dim1x1 add
    gl64_t s1_276 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = tmp1_1 + s1_276;
    // Op 277: dim1x1 add
    gl64_t s1_277 = *(gl64_t*)&expressions_params[9][0];
    tmp1_2 = tmp1_1 + s1_277;
    // Op 278: dim1x1 sub_swap
    gl64_t s0_278 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp1_1 = tmp1_2 - s0_278;
    // Op 279: dim1x1 sub
    gl64_t s1_279 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = tmp1_1 - s1_279;
    // Op 280: dim3x1 mul
    gl64_t s0_280_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_280_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_280_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_280_0 * tmp1_1; tmp3_1 = s0_280_1 * tmp1_1; tmp3_2 = s0_280_2 * tmp1_1;
    // Op 281: dim3x1 add
    gl64_t s1_281 = *(gl64_t*)&expressions_params[9][7];
    tmp3_9 = tmp3_0 + s1_281; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 282: dim3x3 add
    gl64_t s1_282_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_282_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_282_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_282_0; tmp3_4 = tmp3_10 + s1_282_1; tmp3_5 = tmp3_11 + s1_282_2;
    // Op 283: dim1x1 mul
    gl64_t s1_283 = *(gl64_t*)&expressions_params[9][6];
    tmp1_1 = tmp1_4 * s1_283;
    // Op 284: dim1x1 add
    gl64_t s1_284 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = tmp1_1 + s1_284;
    // Op 285: dim1x1 add
    gl64_t s1_285 = *(gl64_t*)&expressions_params[9][8];
    tmp1_3 = tmp1_1 + s1_285;
    // Op 286: dim1x1 sub_swap
    gl64_t s0_286 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp1_1 = tmp1_3 - s0_286;
    // Op 287: dim1x1 sub
    gl64_t s1_287 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = tmp1_1 - s1_287;
    // Op 288: dim3x1 mul
    gl64_t s0_288_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_288_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_288_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_288_0 * tmp1_1; tmp3_1 = s0_288_1 * tmp1_1; tmp3_2 = s0_288_2 * tmp1_1;
    // Op 289: dim3x1 add
    gl64_t s1_289 = *(gl64_t*)&expressions_params[9][7];
    tmp3_6 = tmp3_0 + s1_289; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 290: dim3x3 add
    gl64_t s1_290_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_290_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_290_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_290_0; tmp3_1 = tmp3_7 + s1_290_1; tmp3_2 = tmp3_8 + s1_290_2;
    // Op 291: dim3x3 mul
    gl64_t kA291 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB291 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC291 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD291 = tmp3_3 * tmp3_0;
    gl64_t kE291 = tmp3_4 * tmp3_1;
    gl64_t kF291 = tmp3_5 * tmp3_2;
    gl64_t kG291 = kD291 - kE291;
    tmp3_0 = (kC291 + kG291) - kF291;
    tmp3_1 = ((((kA291 + kC291) - kE291) - kE291) - kD291);
    tmp3_2 = kB291 - kG291;
    // Op 292: dim3x3 mul
    uint64_t s0_292_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_292_0 = *(gl64_t*)&dParams->aux_trace[s0_292_pos];
    gl64_t s0_292_1 = *(gl64_t*)&dParams->aux_trace[s0_292_pos + TILE_HEIGHT];
    gl64_t s0_292_2 = *(gl64_t*)&dParams->aux_trace[s0_292_pos + 2*TILE_HEIGHT];
    gl64_t kA292 = (s0_292_0 + s0_292_1) * (tmp3_0 + tmp3_1);
    gl64_t kB292 = (s0_292_0 + s0_292_2) * (tmp3_0 + tmp3_2);
    gl64_t kC292 = (s0_292_1 + s0_292_2) * (tmp3_1 + tmp3_2);
    gl64_t kD292 = s0_292_0 * tmp3_0;
    gl64_t kE292 = s0_292_1 * tmp3_1;
    gl64_t kF292 = s0_292_2 * tmp3_2;
    gl64_t kG292 = kD292 - kE292;
    tmp3_0 = (kC292 + kG292) - kF292;
    tmp3_1 = ((((kA292 + kC292) - kE292) - kE292) - kD292);
    tmp3_2 = kB292 - kG292;
    // Op 293: dim1x1 sub_swap
    gl64_t s0_293 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    gl64_t s1_293 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_293 - s0_293;
    // Op 294: dim3x3 add
    gl64_t s1_294_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_294_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_294_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_294_0; tmp3_7 = tmp3_7 + s1_294_1; tmp3_8 = tmp3_8 + s1_294_2;
    // Op 295: dim3x1 mul
    tmp3_6 = tmp3_6 * tmp1_1; tmp3_7 = tmp3_7 * tmp1_1; tmp3_8 = tmp3_8 * tmp1_1;
    // Op 296: dim1x1 sub_swap
    gl64_t s0_296 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    gl64_t s1_296 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_296 - s0_296;
    // Op 297: dim3x3 add
    gl64_t s1_297_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_297_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_297_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_297_0; tmp3_10 = tmp3_10 + s1_297_1; tmp3_11 = tmp3_11 + s1_297_2;
    // Op 298: dim3x1 mul
    tmp3_9 = tmp3_9 * tmp1_1; tmp3_10 = tmp3_10 * tmp1_1; tmp3_11 = tmp3_11 * tmp1_1;
    // Op 299: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 300: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 301: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 302: dim3x3 mul
    gl64_t s1_302_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_302_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_302_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA302 = (tmp3_0 + tmp3_1) * (s1_302_0 + s1_302_1);
    gl64_t kB302 = (tmp3_0 + tmp3_2) * (s1_302_0 + s1_302_2);
    gl64_t kC302 = (tmp3_1 + tmp3_2) * (s1_302_1 + s1_302_2);
    gl64_t kD302 = tmp3_0 * s1_302_0;
    gl64_t kE302 = tmp3_1 * s1_302_1;
    gl64_t kF302 = tmp3_2 * s1_302_2;
    gl64_t kG302 = kD302 - kE302;
    tmp3_12 = (kC302 + kG302) - kF302;
    tmp3_13 = ((((kA302 + kC302) - kE302) - kE302) - kD302);
    tmp3_14 = kB302 - kG302;
    // Op 303: dim1x1 mul
    gl64_t s0_303 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_303 = *(gl64_t*)&expressions_params[9][8];
    tmp1_1 = s0_303 * s1_303;
    // Op 304: dim1x1 add
    gl64_t s1_304 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = tmp1_1 + s1_304;
    // Op 305: dim1x1 mul
    gl64_t s0_305 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_305 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = s0_305 * s1_305;
    // Op 306: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 307: dim1x1 mul
    gl64_t s0_307 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_307 = *(gl64_t*)&expressions_params[9][2];
    tmp1_1 = s0_307 * s1_307;
    // Op 308: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 309: dim1x1 mul
    gl64_t s0_309 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_309 = *(gl64_t*)&expressions_params[9][9];
    tmp1_1 = s0_309 * s1_309;
    // Op 310: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 311: dim1x1 mul
    gl64_t s0_311 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_311 = *(gl64_t*)&expressions_params[9][10];
    tmp1_1 = s0_311 * s1_311;
    // Op 312: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 313: dim1x1 mul
    gl64_t s0_313 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_313 = *(gl64_t*)&expressions_params[9][11];
    tmp1_1 = s0_313 * s1_313;
    // Op 314: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 315: dim1x1 mul
    gl64_t s0_315 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    gl64_t s1_315 = *(gl64_t*)&expressions_params[9][12];
    tmp1_1 = s0_315 * s1_315;
    // Op 316: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 317: dim1x1 mul
    gl64_t s0_317 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_317 = *(gl64_t*)&expressions_params[9][13];
    tmp1_1 = s0_317 * s1_317;
    // Op 318: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 319: dim1x1 mul
    gl64_t s0_319 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_319 = *(gl64_t*)&expressions_params[9][14];
    tmp1_1 = s0_319 * s1_319;
    // Op 320: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 321: dim1x1 mul
    gl64_t s0_321 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_321 = *(gl64_t*)&expressions_params[9][15];
    tmp1_1 = s0_321 * s1_321;
    // Op 322: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 323: dim1x1 mul
    gl64_t s0_323 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_323 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_323 * s1_323;
    // Op 324: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 325: dim1x1 mul
    gl64_t s0_325 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    gl64_t s1_325 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_325 * s1_325;
    // Op 326: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 327: dim1x1 mul
    gl64_t s0_327 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    gl64_t s1_327 = *(gl64_t*)&expressions_params[9][18];
    tmp1_1 = s0_327 * s1_327;
    // Op 328: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 329: dim1x1 mul
    gl64_t s0_329 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    gl64_t s1_329 = *(gl64_t*)&expressions_params[9][19];
    tmp1_1 = s0_329 * s1_329;
    // Op 330: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 331: dim1x1 mul
    gl64_t s0_331 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    gl64_t s1_331 = *(gl64_t*)&expressions_params[9][20];
    tmp1_1 = s0_331 * s1_331;
    // Op 332: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 333: dim3x1 mul
    gl64_t s0_333_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_333_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_333_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_333_0 * tmp1_0; tmp3_1 = s0_333_1 * tmp1_0; tmp3_2 = s0_333_2 * tmp1_0;
    // Op 334: dim3x1 add
    gl64_t s1_334 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_334; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 335: dim3x3 mul
    gl64_t s1_335_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_335_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_335_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA335 = (tmp3_0 + tmp3_1) * (s1_335_0 + s1_335_1);
    gl64_t kB335 = (tmp3_0 + tmp3_2) * (s1_335_0 + s1_335_2);
    gl64_t kC335 = (tmp3_1 + tmp3_2) * (s1_335_1 + s1_335_2);
    gl64_t kD335 = tmp3_0 * s1_335_0;
    gl64_t kE335 = tmp3_1 * s1_335_1;
    gl64_t kF335 = tmp3_2 * s1_335_2;
    gl64_t kG335 = kD335 - kE335;
    tmp3_0 = (kC335 + kG335) - kF335;
    tmp3_1 = ((((kA335 + kC335) - kE335) - kE335) - kD335);
    tmp3_2 = kB335 - kG335;
    // Op 336: dim3x1 add
    gl64_t s1_336 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_336; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 337: dim3x3 mul
    gl64_t s1_337_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_337_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_337_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA337 = (tmp3_0 + tmp3_1) * (s1_337_0 + s1_337_1);
    gl64_t kB337 = (tmp3_0 + tmp3_2) * (s1_337_0 + s1_337_2);
    gl64_t kC337 = (tmp3_1 + tmp3_2) * (s1_337_1 + s1_337_2);
    gl64_t kD337 = tmp3_0 * s1_337_0;
    gl64_t kE337 = tmp3_1 * s1_337_1;
    gl64_t kF337 = tmp3_2 * s1_337_2;
    gl64_t kG337 = kD337 - kE337;
    tmp3_0 = (kC337 + kG337) - kF337;
    tmp3_1 = ((((kA337 + kC337) - kE337) - kE337) - kD337);
    tmp3_2 = kB337 - kG337;
    // Op 338: dim3x1 add
    gl64_t s1_338 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_338; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 339: dim3x3 mul
    gl64_t s1_339_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_339_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_339_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA339 = (tmp3_0 + tmp3_1) * (s1_339_0 + s1_339_1);
    gl64_t kB339 = (tmp3_0 + tmp3_2) * (s1_339_0 + s1_339_2);
    gl64_t kC339 = (tmp3_1 + tmp3_2) * (s1_339_1 + s1_339_2);
    gl64_t kD339 = tmp3_0 * s1_339_0;
    gl64_t kE339 = tmp3_1 * s1_339_1;
    gl64_t kF339 = tmp3_2 * s1_339_2;
    gl64_t kG339 = kD339 - kE339;
    tmp3_0 = (kC339 + kG339) - kF339;
    tmp3_1 = ((((kA339 + kC339) - kE339) - kE339) - kD339);
    tmp3_2 = kB339 - kG339;
    // Op 340: dim3x1 add
    gl64_t s1_340 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_340; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 341: dim3x3 mul
    gl64_t s1_341_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_341_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_341_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA341 = (tmp3_0 + tmp3_1) * (s1_341_0 + s1_341_1);
    gl64_t kB341 = (tmp3_0 + tmp3_2) * (s1_341_0 + s1_341_2);
    gl64_t kC341 = (tmp3_1 + tmp3_2) * (s1_341_1 + s1_341_2);
    gl64_t kD341 = tmp3_0 * s1_341_0;
    gl64_t kE341 = tmp3_1 * s1_341_1;
    gl64_t kF341 = tmp3_2 * s1_341_2;
    gl64_t kG341 = kD341 - kE341;
    tmp3_0 = (kC341 + kG341) - kF341;
    tmp3_1 = ((((kA341 + kC341) - kE341) - kE341) - kD341);
    tmp3_2 = kB341 - kG341;
    // Op 342: dim3x1 add
    gl64_t s1_342 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_342; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 343: dim3x3 mul
    gl64_t s1_343_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_343_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_343_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA343 = (tmp3_0 + tmp3_1) * (s1_343_0 + s1_343_1);
    gl64_t kB343 = (tmp3_0 + tmp3_2) * (s1_343_0 + s1_343_2);
    gl64_t kC343 = (tmp3_1 + tmp3_2) * (s1_343_1 + s1_343_2);
    gl64_t kD343 = tmp3_0 * s1_343_0;
    gl64_t kE343 = tmp3_1 * s1_343_1;
    gl64_t kF343 = tmp3_2 * s1_343_2;
    gl64_t kG343 = kD343 - kE343;
    tmp3_0 = (kC343 + kG343) - kF343;
    tmp3_1 = ((((kA343 + kC343) - kE343) - kE343) - kD343);
    tmp3_2 = kB343 - kG343;
    // Op 344: dim3x1 add
    gl64_t s1_344 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_344; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 345: dim3x3 mul
    gl64_t s1_345_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_345_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_345_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA345 = (tmp3_0 + tmp3_1) * (s1_345_0 + s1_345_1);
    gl64_t kB345 = (tmp3_0 + tmp3_2) * (s1_345_0 + s1_345_2);
    gl64_t kC345 = (tmp3_1 + tmp3_2) * (s1_345_1 + s1_345_2);
    gl64_t kD345 = tmp3_0 * s1_345_0;
    gl64_t kE345 = tmp3_1 * s1_345_1;
    gl64_t kF345 = tmp3_2 * s1_345_2;
    gl64_t kG345 = kD345 - kE345;
    tmp3_0 = (kC345 + kG345) - kF345;
    tmp3_1 = ((((kA345 + kC345) - kE345) - kE345) - kD345);
    tmp3_2 = kB345 - kG345;
    // Op 346: dim3x1 add
    gl64_t s1_346 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_346; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 347: dim3x3 mul
    gl64_t s1_347_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_347_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_347_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA347 = (tmp3_0 + tmp3_1) * (s1_347_0 + s1_347_1);
    gl64_t kB347 = (tmp3_0 + tmp3_2) * (s1_347_0 + s1_347_2);
    gl64_t kC347 = (tmp3_1 + tmp3_2) * (s1_347_1 + s1_347_2);
    gl64_t kD347 = tmp3_0 * s1_347_0;
    gl64_t kE347 = tmp3_1 * s1_347_1;
    gl64_t kF347 = tmp3_2 * s1_347_2;
    gl64_t kG347 = kD347 - kE347;
    tmp3_0 = (kC347 + kG347) - kF347;
    tmp3_1 = ((((kA347 + kC347) - kE347) - kE347) - kD347);
    tmp3_2 = kB347 - kG347;
    // Op 348: dim3x1 add
    gl64_t s1_348 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_348; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 349: dim3x3 mul
    gl64_t s1_349_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_349_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_349_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA349 = (tmp3_0 + tmp3_1) * (s1_349_0 + s1_349_1);
    gl64_t kB349 = (tmp3_0 + tmp3_2) * (s1_349_0 + s1_349_2);
    gl64_t kC349 = (tmp3_1 + tmp3_2) * (s1_349_1 + s1_349_2);
    gl64_t kD349 = tmp3_0 * s1_349_0;
    gl64_t kE349 = tmp3_1 * s1_349_1;
    gl64_t kF349 = tmp3_2 * s1_349_2;
    gl64_t kG349 = kD349 - kE349;
    tmp3_0 = (kC349 + kG349) - kF349;
    tmp3_1 = ((((kA349 + kC349) - kE349) - kE349) - kD349);
    tmp3_2 = kB349 - kG349;
    // Op 350: dim3x1 add
    gl64_t s1_350 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_350; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 351: dim3x3 mul
    gl64_t s1_351_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_351_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_351_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA351 = (tmp3_0 + tmp3_1) * (s1_351_0 + s1_351_1);
    gl64_t kB351 = (tmp3_0 + tmp3_2) * (s1_351_0 + s1_351_2);
    gl64_t kC351 = (tmp3_1 + tmp3_2) * (s1_351_1 + s1_351_2);
    gl64_t kD351 = tmp3_0 * s1_351_0;
    gl64_t kE351 = tmp3_1 * s1_351_1;
    gl64_t kF351 = tmp3_2 * s1_351_2;
    gl64_t kG351 = kD351 - kE351;
    tmp3_0 = (kC351 + kG351) - kF351;
    tmp3_1 = ((((kA351 + kC351) - kE351) - kE351) - kD351);
    tmp3_2 = kB351 - kG351;
    // Op 352: dim3x1 add
    gl64_t s1_352 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_352; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 353: dim3x3 mul
    gl64_t s1_353_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_353_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_353_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA353 = (tmp3_0 + tmp3_1) * (s1_353_0 + s1_353_1);
    gl64_t kB353 = (tmp3_0 + tmp3_2) * (s1_353_0 + s1_353_2);
    gl64_t kC353 = (tmp3_1 + tmp3_2) * (s1_353_1 + s1_353_2);
    gl64_t kD353 = tmp3_0 * s1_353_0;
    gl64_t kE353 = tmp3_1 * s1_353_1;
    gl64_t kF353 = tmp3_2 * s1_353_2;
    gl64_t kG353 = kD353 - kE353;
    tmp3_0 = (kC353 + kG353) - kF353;
    tmp3_1 = ((((kA353 + kC353) - kE353) - kE353) - kD353);
    tmp3_2 = kB353 - kG353;
    // Op 354: dim3x1 add
    gl64_t s1_354 = *(gl64_t*)&expressions_params[9][21];
    tmp3_0 = tmp3_0 + s1_354; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 355: dim3x3 add
    gl64_t s1_355_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_355_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_355_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_355_0; tmp3_1 = tmp3_1 + s1_355_1; tmp3_2 = tmp3_2 + s1_355_2;
    // Op 356: dim3x3 mul
    uint64_t s0_356_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_356_0 = *(gl64_t*)&dParams->aux_trace[s0_356_pos];
    gl64_t s0_356_1 = *(gl64_t*)&dParams->aux_trace[s0_356_pos + TILE_HEIGHT];
    gl64_t s0_356_2 = *(gl64_t*)&dParams->aux_trace[s0_356_pos + 2*TILE_HEIGHT];
    gl64_t kA356 = (s0_356_0 + s0_356_1) * (tmp3_0 + tmp3_1);
    gl64_t kB356 = (s0_356_0 + s0_356_2) * (tmp3_0 + tmp3_2);
    gl64_t kC356 = (s0_356_1 + s0_356_2) * (tmp3_1 + tmp3_2);
    gl64_t kD356 = s0_356_0 * tmp3_0;
    gl64_t kE356 = s0_356_1 * tmp3_1;
    gl64_t kF356 = s0_356_2 * tmp3_2;
    gl64_t kG356 = kD356 - kE356;
    tmp3_0 = (kC356 + kG356) - kF356;
    tmp3_1 = ((((kA356 + kC356) - kE356) - kE356) - kD356);
    tmp3_2 = kB356 - kG356;
    // Op 357: dim3x1 add
    gl64_t s1_357 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_357; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 358: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 359: dim3x3 mul
    gl64_t s1_359_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_359_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_359_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA359 = (tmp3_0 + tmp3_1) * (s1_359_0 + s1_359_1);
    gl64_t kB359 = (tmp3_0 + tmp3_2) * (s1_359_0 + s1_359_2);
    gl64_t kC359 = (tmp3_1 + tmp3_2) * (s1_359_1 + s1_359_2);
    gl64_t kD359 = tmp3_0 * s1_359_0;
    gl64_t kE359 = tmp3_1 * s1_359_1;
    gl64_t kF359 = tmp3_2 * s1_359_2;
    gl64_t kG359 = kD359 - kE359;
    tmp3_12 = (kC359 + kG359) - kF359;
    tmp3_13 = ((((kA359 + kC359) - kE359) - kE359) - kD359);
    tmp3_14 = kB359 - kG359;
    // Op 360: dim3x1 mul
    gl64_t s0_360_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_360_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_360_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_360 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp3_0 = s0_360_0 * s1_360; tmp3_1 = s0_360_1 * s1_360; tmp3_2 = s0_360_2 * s1_360;
    // Op 361: dim3x1 add
    gl64_t s1_361 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_361; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 362: dim3x3 mul
    gl64_t s1_362_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_362_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_362_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA362 = (tmp3_0 + tmp3_1) * (s1_362_0 + s1_362_1);
    gl64_t kB362 = (tmp3_0 + tmp3_2) * (s1_362_0 + s1_362_2);
    gl64_t kC362 = (tmp3_1 + tmp3_2) * (s1_362_1 + s1_362_2);
    gl64_t kD362 = tmp3_0 * s1_362_0;
    gl64_t kE362 = tmp3_1 * s1_362_1;
    gl64_t kF362 = tmp3_2 * s1_362_2;
    gl64_t kG362 = kD362 - kE362;
    tmp3_0 = (kC362 + kG362) - kF362;
    tmp3_1 = ((((kA362 + kC362) - kE362) - kE362) - kD362);
    tmp3_2 = kB362 - kG362;
    // Op 363: dim1x1 sub
    gl64_t s0_363 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    gl64_t s1_363 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_363 - s1_363;
    // Op 364: dim1x1 mul
    gl64_t s0_364 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_364 * tmp1_0;
    // Op 365: dim1x1 add
    gl64_t s1_365 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = tmp1_0 + s1_365;
    // Op 366: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 367: dim3x3 mul
    gl64_t s1_367_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_367_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_367_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA367 = (tmp3_0 + tmp3_1) * (s1_367_0 + s1_367_1);
    gl64_t kB367 = (tmp3_0 + tmp3_2) * (s1_367_0 + s1_367_2);
    gl64_t kC367 = (tmp3_1 + tmp3_2) * (s1_367_1 + s1_367_2);
    gl64_t kD367 = tmp3_0 * s1_367_0;
    gl64_t kE367 = tmp3_1 * s1_367_1;
    gl64_t kF367 = tmp3_2 * s1_367_2;
    gl64_t kG367 = kD367 - kE367;
    tmp3_0 = (kC367 + kG367) - kF367;
    tmp3_1 = ((((kA367 + kC367) - kE367) - kE367) - kD367);
    tmp3_2 = kB367 - kG367;
    // Op 368: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 369: dim3x3 mul
    gl64_t s1_369_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_369_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_369_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA369 = (tmp3_0 + tmp3_1) * (s1_369_0 + s1_369_1);
    gl64_t kB369 = (tmp3_0 + tmp3_2) * (s1_369_0 + s1_369_2);
    gl64_t kC369 = (tmp3_1 + tmp3_2) * (s1_369_1 + s1_369_2);
    gl64_t kD369 = tmp3_0 * s1_369_0;
    gl64_t kE369 = tmp3_1 * s1_369_1;
    gl64_t kF369 = tmp3_2 * s1_369_2;
    gl64_t kG369 = kD369 - kE369;
    tmp3_0 = (kC369 + kG369) - kF369;
    tmp3_1 = ((((kA369 + kC369) - kE369) - kE369) - kD369);
    tmp3_2 = kB369 - kG369;
    // Op 370: dim3x1 add
    gl64_t s1_370 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_370; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 371: dim3x3 mul
    gl64_t s1_371_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_371_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_371_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA371 = (tmp3_0 + tmp3_1) * (s1_371_0 + s1_371_1);
    gl64_t kB371 = (tmp3_0 + tmp3_2) * (s1_371_0 + s1_371_2);
    gl64_t kC371 = (tmp3_1 + tmp3_2) * (s1_371_1 + s1_371_2);
    gl64_t kD371 = tmp3_0 * s1_371_0;
    gl64_t kE371 = tmp3_1 * s1_371_1;
    gl64_t kF371 = tmp3_2 * s1_371_2;
    gl64_t kG371 = kD371 - kE371;
    tmp3_0 = (kC371 + kG371) - kF371;
    tmp3_1 = ((((kA371 + kC371) - kE371) - kE371) - kD371);
    tmp3_2 = kB371 - kG371;
    // Op 372: dim1x1 add
    gl64_t s0_372 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_372 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_372 + s1_372;
    // Op 373: dim1x1 mul
    gl64_t s0_373 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    gl64_t s1_373 = *(gl64_t*)&expressions_params[9][3];
    tmp1_2 = s0_373 * s1_373;
    // Op 374: dim1x1 add
    tmp1_2 = tmp1_0 + tmp1_2;
    // Op 375: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 376: dim3x3 mul
    gl64_t s1_376_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_376_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_376_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA376 = (tmp3_0 + tmp3_1) * (s1_376_0 + s1_376_1);
    gl64_t kB376 = (tmp3_0 + tmp3_2) * (s1_376_0 + s1_376_2);
    gl64_t kC376 = (tmp3_1 + tmp3_2) * (s1_376_1 + s1_376_2);
    gl64_t kD376 = tmp3_0 * s1_376_0;
    gl64_t kE376 = tmp3_1 * s1_376_1;
    gl64_t kF376 = tmp3_2 * s1_376_2;
    gl64_t kG376 = kD376 - kE376;
    tmp3_0 = (kC376 + kG376) - kF376;
    tmp3_1 = ((((kA376 + kC376) - kE376) - kE376) - kD376);
    tmp3_2 = kB376 - kG376;
    // Op 377: dim3x1 add
    gl64_t s1_377 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_377; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 378: dim3x3 add
    gl64_t s1_378_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_378_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_378_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_378_0; tmp3_1 = tmp3_1 + s1_378_1; tmp3_2 = tmp3_2 + s1_378_2;
    // Op 379: dim3x3 mul
    gl64_t s0_379_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_379_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_379_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    gl64_t kA379 = (s0_379_0 + s0_379_1) * (tmp3_0 + tmp3_1);
    gl64_t kB379 = (s0_379_0 + s0_379_2) * (tmp3_0 + tmp3_2);
    gl64_t kC379 = (s0_379_1 + s0_379_2) * (tmp3_1 + tmp3_2);
    gl64_t kD379 = s0_379_0 * tmp3_0;
    gl64_t kE379 = s0_379_1 * tmp3_1;
    gl64_t kF379 = s0_379_2 * tmp3_2;
    gl64_t kG379 = kD379 - kE379;
    tmp3_0 = (kC379 + kG379) - kF379;
    tmp3_1 = ((((kA379 + kC379) - kE379) - kE379) - kD379);
    tmp3_2 = kB379 - kG379;
    // Op 380: dim1x1 add
    gl64_t s0_380 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    tmp1_0 = s0_380 + tmp1_0;
    // Op 381: dim1x1 sub_swap
    gl64_t s1_381 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_381 - tmp1_0;
    // Op 382: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 383: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 384: dim3x3 mul
    gl64_t s1_384_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_384_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_384_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA384 = (tmp3_0 + tmp3_1) * (s1_384_0 + s1_384_1);
    gl64_t kB384 = (tmp3_0 + tmp3_2) * (s1_384_0 + s1_384_2);
    gl64_t kC384 = (tmp3_1 + tmp3_2) * (s1_384_1 + s1_384_2);
    gl64_t kD384 = tmp3_0 * s1_384_0;
    gl64_t kE384 = tmp3_1 * s1_384_1;
    gl64_t kF384 = tmp3_2 * s1_384_2;
    gl64_t kG384 = kD384 - kE384;
    tmp3_12 = (kC384 + kG384) - kF384;
    tmp3_13 = ((((kA384 + kC384) - kE384) - kE384) - kD384);
    tmp3_14 = kB384 - kG384;
    // Op 385: dim1x1 sub_swap
    gl64_t s0_385 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    gl64_t s1_385 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_385 - s0_385;
    // Op 386: dim1x1 mul
    gl64_t s0_386 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_386 * tmp1_0;
    // Op 387: dim3x1 mul
    gl64_t s0_387_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_387_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_387_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_387_0 * tmp1_0; tmp3_1 = s0_387_1 * tmp1_0; tmp3_2 = s0_387_2 * tmp1_0;
    // Op 388: dim1x1 add
    gl64_t s0_388 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_388 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp1_0 = s0_388 + s1_388;
    // Op 389: dim1x1 sub_swap
    gl64_t s0_389 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = tmp1_0 - s0_389;
    // Op 390: dim1x1 mul
    gl64_t s0_390 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_390 * tmp1_0;
    // Op 391: dim1x1 add
    gl64_t s0_391 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_391 + tmp1_0;
    // Op 392: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 393: dim3x3 mul
    gl64_t s1_393_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_393_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_393_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA393 = (tmp3_0 + tmp3_1) * (s1_393_0 + s1_393_1);
    gl64_t kB393 = (tmp3_0 + tmp3_2) * (s1_393_0 + s1_393_2);
    gl64_t kC393 = (tmp3_1 + tmp3_2) * (s1_393_1 + s1_393_2);
    gl64_t kD393 = tmp3_0 * s1_393_0;
    gl64_t kE393 = tmp3_1 * s1_393_1;
    gl64_t kF393 = tmp3_2 * s1_393_2;
    gl64_t kG393 = kD393 - kE393;
    tmp3_0 = (kC393 + kG393) - kF393;
    tmp3_1 = ((((kA393 + kC393) - kE393) - kE393) - kD393);
    tmp3_2 = kB393 - kG393;
    // Op 394: dim1x1 sub
    gl64_t s0_394 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    gl64_t s1_394 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_394 - s1_394;
    // Op 395: dim1x1 mul
    gl64_t s0_395 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = s0_395 * tmp1_0;
    // Op 396: dim1x1 add
    gl64_t s1_396 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = tmp1_0 + s1_396;
    // Op 397: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 398: dim3x3 mul
    gl64_t s1_398_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_398_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_398_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA398 = (tmp3_0 + tmp3_1) * (s1_398_0 + s1_398_1);
    gl64_t kB398 = (tmp3_0 + tmp3_2) * (s1_398_0 + s1_398_2);
    gl64_t kC398 = (tmp3_1 + tmp3_2) * (s1_398_1 + s1_398_2);
    gl64_t kD398 = tmp3_0 * s1_398_0;
    gl64_t kE398 = tmp3_1 * s1_398_1;
    gl64_t kF398 = tmp3_2 * s1_398_2;
    gl64_t kG398 = kD398 - kE398;
    tmp3_0 = (kC398 + kG398) - kF398;
    tmp3_1 = ((((kA398 + kC398) - kE398) - kE398) - kD398);
    tmp3_2 = kB398 - kG398;
    // Op 399: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_3; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 400: dim3x3 mul
    gl64_t s1_400_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_400_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_400_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA400 = (tmp3_0 + tmp3_1) * (s1_400_0 + s1_400_1);
    gl64_t kB400 = (tmp3_0 + tmp3_2) * (s1_400_0 + s1_400_2);
    gl64_t kC400 = (tmp3_1 + tmp3_2) * (s1_400_1 + s1_400_2);
    gl64_t kD400 = tmp3_0 * s1_400_0;
    gl64_t kE400 = tmp3_1 * s1_400_1;
    gl64_t kF400 = tmp3_2 * s1_400_2;
    gl64_t kG400 = kD400 - kE400;
    tmp3_0 = (kC400 + kG400) - kF400;
    tmp3_1 = ((((kA400 + kC400) - kE400) - kE400) - kD400);
    tmp3_2 = kB400 - kG400;
    // Op 401: dim1x1 mul
    gl64_t s0_401 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_401 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_3 = s0_401 * s1_401;
    // Op 402: dim1x1 add
    gl64_t s0_402 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_3 = s0_402 + tmp1_3;
    // Op 403: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_3; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 404: dim3x3 mul
    gl64_t s1_404_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_404_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_404_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA404 = (tmp3_0 + tmp3_1) * (s1_404_0 + s1_404_1);
    gl64_t kB404 = (tmp3_0 + tmp3_2) * (s1_404_0 + s1_404_2);
    gl64_t kC404 = (tmp3_1 + tmp3_2) * (s1_404_1 + s1_404_2);
    gl64_t kD404 = tmp3_0 * s1_404_0;
    gl64_t kE404 = tmp3_1 * s1_404_1;
    gl64_t kF404 = tmp3_2 * s1_404_2;
    gl64_t kG404 = kD404 - kE404;
    tmp3_0 = (kC404 + kG404) - kF404;
    tmp3_1 = ((((kA404 + kC404) - kE404) - kE404) - kD404);
    tmp3_2 = kB404 - kG404;
    // Op 405: dim1x1 add
    gl64_t s0_405 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_405 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_3 = s0_405 + s1_405;
    // Op 406: dim1x1 mul
    gl64_t s1_406 = *(gl64_t*)&expressions_params[9][8];
    tmp1_3 = tmp1_3 * s1_406;
    // Op 407: dim1x1 mul
    gl64_t s0_407 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    gl64_t s1_407 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_407 * s1_407;
    // Op 408: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_0;
    // Op 409: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 410: dim3x3 mul
    gl64_t s1_410_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_410_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_410_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA410 = (tmp3_0 + tmp3_1) * (s1_410_0 + s1_410_1);
    gl64_t kB410 = (tmp3_0 + tmp3_2) * (s1_410_0 + s1_410_2);
    gl64_t kC410 = (tmp3_1 + tmp3_2) * (s1_410_1 + s1_410_2);
    gl64_t kD410 = tmp3_0 * s1_410_0;
    gl64_t kE410 = tmp3_1 * s1_410_1;
    gl64_t kF410 = tmp3_2 * s1_410_2;
    gl64_t kG410 = kD410 - kE410;
    tmp3_0 = (kC410 + kG410) - kF410;
    tmp3_1 = ((((kA410 + kC410) - kE410) - kE410) - kD410);
    tmp3_2 = kB410 - kG410;
    // Op 411: dim3x1 add
    gl64_t s1_411 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_411; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 412: dim3x3 add
    gl64_t s1_412_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_412_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_412_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_412_0; tmp3_1 = tmp3_1 + s1_412_1; tmp3_2 = tmp3_2 + s1_412_2;
    // Op 413: dim3x3 mul
    gl64_t s0_413_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+0, domainSize, nCols_2))];
    gl64_t s0_413_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+1, domainSize, nCols_2))];
    gl64_t s0_413_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+2, domainSize, nCols_2))];
    gl64_t kA413 = (s0_413_0 + s0_413_1) * (tmp3_0 + tmp3_1);
    gl64_t kB413 = (s0_413_0 + s0_413_2) * (tmp3_0 + tmp3_2);
    gl64_t kC413 = (s0_413_1 + s0_413_2) * (tmp3_1 + tmp3_2);
    gl64_t kD413 = s0_413_0 * tmp3_0;
    gl64_t kE413 = s0_413_1 * tmp3_1;
    gl64_t kF413 = s0_413_2 * tmp3_2;
    gl64_t kG413 = kD413 - kE413;
    tmp3_0 = (kC413 + kG413) - kF413;
    tmp3_1 = ((((kA413 + kC413) - kE413) - kE413) - kD413);
    tmp3_2 = kB413 - kG413;
    // Op 414: dim1x1 add
    gl64_t s0_414 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_414 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = s0_414 + s1_414;
    // Op 415: dim1x1 add
    gl64_t s0_415 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    tmp1_0 = s0_415 + tmp1_0;
    // Op 416: dim1x1 sub_swap
    gl64_t s1_416 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_416 - tmp1_0;
    // Op 417: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 418: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 419: dim3x3 mul
    gl64_t s1_419_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_419_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_419_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA419 = (tmp3_0 + tmp3_1) * (s1_419_0 + s1_419_1);
    gl64_t kB419 = (tmp3_0 + tmp3_2) * (s1_419_0 + s1_419_2);
    gl64_t kC419 = (tmp3_1 + tmp3_2) * (s1_419_1 + s1_419_2);
    gl64_t kD419 = tmp3_0 * s1_419_0;
    gl64_t kE419 = tmp3_1 * s1_419_1;
    gl64_t kF419 = tmp3_2 * s1_419_2;
    gl64_t kG419 = kD419 - kE419;
    tmp3_12 = (kC419 + kG419) - kF419;
    tmp3_13 = ((((kA419 + kC419) - kE419) - kE419) - kD419);
    tmp3_14 = kB419 - kG419;
    // Op 420: dim1x1 mul
    gl64_t s0_420 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_420 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_420 * s1_420;
    // Op 421: dim3x1 mul
    gl64_t s0_421_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_421_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_421_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_421_0 * tmp1_0; tmp3_1 = s0_421_1 * tmp1_0; tmp3_2 = s0_421_2 * tmp1_0;
    // Op 422: dim1x1 mul
    gl64_t s0_422 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_4 = s0_422 * tmp1_4;
    // Op 423: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 424: dim3x3 mul
    gl64_t s1_424_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_424_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_424_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA424 = (tmp3_0 + tmp3_1) * (s1_424_0 + s1_424_1);
    gl64_t kB424 = (tmp3_0 + tmp3_2) * (s1_424_0 + s1_424_2);
    gl64_t kC424 = (tmp3_1 + tmp3_2) * (s1_424_1 + s1_424_2);
    gl64_t kD424 = tmp3_0 * s1_424_0;
    gl64_t kE424 = tmp3_1 * s1_424_1;
    gl64_t kF424 = tmp3_2 * s1_424_2;
    gl64_t kG424 = kD424 - kE424;
    tmp3_0 = (kC424 + kG424) - kF424;
    tmp3_1 = ((((kA424 + kC424) - kE424) - kE424) - kD424);
    tmp3_2 = kB424 - kG424;
    // Op 425: dim3x1 add
    gl64_t s1_425 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_425; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 426: dim3x3 mul
    gl64_t s1_426_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_426_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_426_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA426 = (tmp3_0 + tmp3_1) * (s1_426_0 + s1_426_1);
    gl64_t kB426 = (tmp3_0 + tmp3_2) * (s1_426_0 + s1_426_2);
    gl64_t kC426 = (tmp3_1 + tmp3_2) * (s1_426_1 + s1_426_2);
    gl64_t kD426 = tmp3_0 * s1_426_0;
    gl64_t kE426 = tmp3_1 * s1_426_1;
    gl64_t kF426 = tmp3_2 * s1_426_2;
    gl64_t kG426 = kD426 - kE426;
    tmp3_0 = (kC426 + kG426) - kF426;
    tmp3_1 = ((((kA426 + kC426) - kE426) - kE426) - kD426);
    tmp3_2 = kB426 - kG426;
    // Op 427: dim3x1 add
    gl64_t s1_427 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_427; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 428: dim3x3 mul
    gl64_t s1_428_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_428_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_428_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA428 = (tmp3_0 + tmp3_1) * (s1_428_0 + s1_428_1);
    gl64_t kB428 = (tmp3_0 + tmp3_2) * (s1_428_0 + s1_428_2);
    gl64_t kC428 = (tmp3_1 + tmp3_2) * (s1_428_1 + s1_428_2);
    gl64_t kD428 = tmp3_0 * s1_428_0;
    gl64_t kE428 = tmp3_1 * s1_428_1;
    gl64_t kF428 = tmp3_2 * s1_428_2;
    gl64_t kG428 = kD428 - kE428;
    tmp3_0 = (kC428 + kG428) - kF428;
    tmp3_1 = ((((kA428 + kC428) - kE428) - kE428) - kD428);
    tmp3_2 = kB428 - kG428;
    // Op 429: dim3x1 add
    gl64_t s1_429 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_429; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 430: dim3x3 mul
    gl64_t s1_430_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_430_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_430_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA430 = (tmp3_0 + tmp3_1) * (s1_430_0 + s1_430_1);
    gl64_t kB430 = (tmp3_0 + tmp3_2) * (s1_430_0 + s1_430_2);
    gl64_t kC430 = (tmp3_1 + tmp3_2) * (s1_430_1 + s1_430_2);
    gl64_t kD430 = tmp3_0 * s1_430_0;
    gl64_t kE430 = tmp3_1 * s1_430_1;
    gl64_t kF430 = tmp3_2 * s1_430_2;
    gl64_t kG430 = kD430 - kE430;
    tmp3_0 = (kC430 + kG430) - kF430;
    tmp3_1 = ((((kA430 + kC430) - kE430) - kE430) - kD430);
    tmp3_2 = kB430 - kG430;
    // Op 431: dim1x1 sub_swap
    gl64_t s0_431 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_431 = *(gl64_t*)&expressions_params[9][0];
    tmp1_4 = s1_431 - s0_431;
    // Op 432: dim1x1 mul
    gl64_t s0_432 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_4 = s0_432 * tmp1_4;
    // Op 433: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 434: dim3x3 mul
    gl64_t s1_434_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_434_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_434_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA434 = (tmp3_0 + tmp3_1) * (s1_434_0 + s1_434_1);
    gl64_t kB434 = (tmp3_0 + tmp3_2) * (s1_434_0 + s1_434_2);
    gl64_t kC434 = (tmp3_1 + tmp3_2) * (s1_434_1 + s1_434_2);
    gl64_t kD434 = tmp3_0 * s1_434_0;
    gl64_t kE434 = tmp3_1 * s1_434_1;
    gl64_t kF434 = tmp3_2 * s1_434_2;
    gl64_t kG434 = kD434 - kE434;
    tmp3_0 = (kC434 + kG434) - kF434;
    tmp3_1 = ((((kA434 + kC434) - kE434) - kE434) - kD434);
    tmp3_2 = kB434 - kG434;
    // Op 435: dim3x1 add
    gl64_t s1_435 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_435; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 436: dim3x3 mul
    gl64_t s1_436_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_436_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_436_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA436 = (tmp3_0 + tmp3_1) * (s1_436_0 + s1_436_1);
    gl64_t kB436 = (tmp3_0 + tmp3_2) * (s1_436_0 + s1_436_2);
    gl64_t kC436 = (tmp3_1 + tmp3_2) * (s1_436_1 + s1_436_2);
    gl64_t kD436 = tmp3_0 * s1_436_0;
    gl64_t kE436 = tmp3_1 * s1_436_1;
    gl64_t kF436 = tmp3_2 * s1_436_2;
    gl64_t kG436 = kD436 - kE436;
    tmp3_0 = (kC436 + kG436) - kF436;
    tmp3_1 = ((((kA436 + kC436) - kE436) - kE436) - kD436);
    tmp3_2 = kB436 - kG436;
    // Op 437: dim1x1 sub_swap
    gl64_t s0_437 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_437 = *(gl64_t*)&expressions_params[9][0];
    tmp1_4 = s1_437 - s0_437;
    // Op 438: dim1x1 mul
    gl64_t s0_438 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_4 = s0_438 * tmp1_4;
    // Op 439: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 440: dim3x3 mul
    gl64_t s1_440_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_440_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_440_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA440 = (tmp3_0 + tmp3_1) * (s1_440_0 + s1_440_1);
    gl64_t kB440 = (tmp3_0 + tmp3_2) * (s1_440_0 + s1_440_2);
    gl64_t kC440 = (tmp3_1 + tmp3_2) * (s1_440_1 + s1_440_2);
    gl64_t kD440 = tmp3_0 * s1_440_0;
    gl64_t kE440 = tmp3_1 * s1_440_1;
    gl64_t kF440 = tmp3_2 * s1_440_2;
    gl64_t kG440 = kD440 - kE440;
    tmp3_0 = (kC440 + kG440) - kF440;
    tmp3_1 = ((((kA440 + kC440) - kE440) - kE440) - kD440);
    tmp3_2 = kB440 - kG440;
    // Op 441: dim3x1 add
    gl64_t s1_441 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_441; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 442: dim3x3 mul
    gl64_t s1_442_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_442_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_442_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA442 = (tmp3_0 + tmp3_1) * (s1_442_0 + s1_442_1);
    gl64_t kB442 = (tmp3_0 + tmp3_2) * (s1_442_0 + s1_442_2);
    gl64_t kC442 = (tmp3_1 + tmp3_2) * (s1_442_1 + s1_442_2);
    gl64_t kD442 = tmp3_0 * s1_442_0;
    gl64_t kE442 = tmp3_1 * s1_442_1;
    gl64_t kF442 = tmp3_2 * s1_442_2;
    gl64_t kG442 = kD442 - kE442;
    tmp3_0 = (kC442 + kG442) - kF442;
    tmp3_1 = ((((kA442 + kC442) - kE442) - kE442) - kD442);
    tmp3_2 = kB442 - kG442;
    // Op 443: dim3x1 add
    gl64_t s1_443 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_443; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 444: dim3x3 mul
    gl64_t s1_444_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_444_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_444_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA444 = (tmp3_0 + tmp3_1) * (s1_444_0 + s1_444_1);
    gl64_t kB444 = (tmp3_0 + tmp3_2) * (s1_444_0 + s1_444_2);
    gl64_t kC444 = (tmp3_1 + tmp3_2) * (s1_444_1 + s1_444_2);
    gl64_t kD444 = tmp3_0 * s1_444_0;
    gl64_t kE444 = tmp3_1 * s1_444_1;
    gl64_t kF444 = tmp3_2 * s1_444_2;
    gl64_t kG444 = kD444 - kE444;
    tmp3_0 = (kC444 + kG444) - kF444;
    tmp3_1 = ((((kA444 + kC444) - kE444) - kE444) - kD444);
    tmp3_2 = kB444 - kG444;
    // Op 445: dim3x1 add
    gl64_t s1_445 = *(gl64_t*)&expressions_params[9][22];
    tmp3_0 = tmp3_0 + s1_445; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 446: dim3x3 add
    gl64_t s1_446_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_446_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_446_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_446_0; tmp3_1 = tmp3_1 + s1_446_1; tmp3_2 = tmp3_2 + s1_446_2;
    // Op 447: dim3x3 mul
    uint64_t s0_447_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_2));
    gl64_t s0_447_0 = *(gl64_t*)&dParams->aux_trace[s0_447_pos];
    gl64_t s0_447_1 = *(gl64_t*)&dParams->aux_trace[s0_447_pos + TILE_HEIGHT];
    gl64_t s0_447_2 = *(gl64_t*)&dParams->aux_trace[s0_447_pos + 2*TILE_HEIGHT];
    gl64_t kA447 = (s0_447_0 + s0_447_1) * (tmp3_0 + tmp3_1);
    gl64_t kB447 = (s0_447_0 + s0_447_2) * (tmp3_0 + tmp3_2);
    gl64_t kC447 = (s0_447_1 + s0_447_2) * (tmp3_1 + tmp3_2);
    gl64_t kD447 = s0_447_0 * tmp3_0;
    gl64_t kE447 = s0_447_1 * tmp3_1;
    gl64_t kF447 = s0_447_2 * tmp3_2;
    gl64_t kG447 = kD447 - kE447;
    tmp3_0 = (kC447 + kG447) - kF447;
    tmp3_1 = ((((kA447 + kC447) - kE447) - kE447) - kD447);
    tmp3_2 = kB447 - kG447;
    // Op 448: dim1x1 sub_swap
    gl64_t s0_448 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_448 = *(gl64_t*)&expressions_params[9][1];
    tmp1_4 = s1_448 - s0_448;
    // Op 449: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 450: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 451: dim3x3 mul
    gl64_t s1_451_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_451_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_451_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA451 = (tmp3_0 + tmp3_1) * (s1_451_0 + s1_451_1);
    gl64_t kB451 = (tmp3_0 + tmp3_2) * (s1_451_0 + s1_451_2);
    gl64_t kC451 = (tmp3_1 + tmp3_2) * (s1_451_1 + s1_451_2);
    gl64_t kD451 = tmp3_0 * s1_451_0;
    gl64_t kE451 = tmp3_1 * s1_451_1;
    gl64_t kF451 = tmp3_2 * s1_451_2;
    gl64_t kG451 = kD451 - kE451;
    tmp3_6 = (kC451 + kG451) - kF451;
    tmp3_7 = ((((kA451 + kC451) - kE451) - kE451) - kD451);
    tmp3_8 = kB451 - kG451;
    // Op 452: dim1x1 sub_swap
    gl64_t s0_452 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_0)];
    gl64_t s1_452 = *(gl64_t*)&expressions_params[9][0];
    tmp1_4 = s1_452 - s0_452;
    // Op 453: dim3x1 mul
    uint64_t s0_453_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_453_0 = *(gl64_t*)&dParams->aux_trace[s0_453_pos];
    gl64_t s0_453_1 = *(gl64_t*)&dParams->aux_trace[s0_453_pos + TILE_HEIGHT];
    gl64_t s0_453_2 = *(gl64_t*)&dParams->aux_trace[s0_453_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_453_0 * tmp1_4; tmp3_1 = s0_453_1 * tmp1_4; tmp3_2 = s0_453_2 * tmp1_4;
    // Op 454: dim3x3 sub
    uint64_t s0_454_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_454_0 = *(gl64_t*)&dParams->aux_trace[s0_454_pos];
    gl64_t s0_454_1 = *(gl64_t*)&dParams->aux_trace[s0_454_pos + TILE_HEIGHT];
    gl64_t s0_454_2 = *(gl64_t*)&dParams->aux_trace[s0_454_pos + 2*TILE_HEIGHT];
    tmp3_12 = s0_454_0 - tmp3_0; tmp3_13 = s0_454_1 - tmp3_1; tmp3_14 = s0_454_2 - tmp3_2;
    // Op 455: dim3x3 add
    gl64_t s0_455_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_455_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_455_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_455_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_455_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_455_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_0 = s0_455_0 + s1_455_0; tmp3_1 = s0_455_1 + s1_455_1; tmp3_2 = s0_455_2 + s1_455_2;
    // Op 456: dim3x3 add
    uint64_t s0_456_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_456_0 = *(gl64_t*)&dParams->aux_trace[s0_456_pos];
    gl64_t s0_456_1 = *(gl64_t*)&dParams->aux_trace[s0_456_pos + TILE_HEIGHT];
    gl64_t s0_456_2 = *(gl64_t*)&dParams->aux_trace[s0_456_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_456_0 + tmp3_0; tmp3_1 = s0_456_1 + tmp3_1; tmp3_2 = s0_456_2 + tmp3_2;
    // Op 457: dim3x3 add
    uint64_t s0_457_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_457_0 = *(gl64_t*)&dParams->aux_trace[s0_457_pos];
    gl64_t s0_457_1 = *(gl64_t*)&dParams->aux_trace[s0_457_pos + TILE_HEIGHT];
    gl64_t s0_457_2 = *(gl64_t*)&dParams->aux_trace[s0_457_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_457_0 + tmp3_0; tmp3_1 = s0_457_1 + tmp3_1; tmp3_2 = s0_457_2 + tmp3_2;
    // Op 458: dim3x3 add
    gl64_t s0_458_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_458_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_458_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    tmp3_0 = s0_458_0 + tmp3_0; tmp3_1 = s0_458_1 + tmp3_1; tmp3_2 = s0_458_2 + tmp3_2;
    // Op 459: dim3x3 add
    gl64_t s0_459_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+0, domainSize, nCols_2))];
    gl64_t s0_459_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+1, domainSize, nCols_2))];
    gl64_t s0_459_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+2, domainSize, nCols_2))];
    tmp3_0 = s0_459_0 + tmp3_0; tmp3_1 = s0_459_1 + tmp3_1; tmp3_2 = s0_459_2 + tmp3_2;
    // Op 460: dim3x3 add
    uint64_t s0_460_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_2));
    gl64_t s0_460_0 = *(gl64_t*)&dParams->aux_trace[s0_460_pos];
    gl64_t s0_460_1 = *(gl64_t*)&dParams->aux_trace[s0_460_pos + TILE_HEIGHT];
    gl64_t s0_460_2 = *(gl64_t*)&dParams->aux_trace[s0_460_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_460_0 + tmp3_0; tmp3_1 = s0_460_1 + tmp3_1; tmp3_2 = s0_460_2 + tmp3_2;
    // Op 461: dim3x3 sub
    tmp3_12 = tmp3_12 - tmp3_0; tmp3_13 = tmp3_13 - tmp3_1; tmp3_14 = tmp3_14 - tmp3_2;
    // Op 462: dim3x1 mul
    gl64_t s0_462_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_462_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_462_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_462 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp3_0 = s0_462_0 * s1_462; tmp3_1 = s0_462_1 * s1_462; tmp3_2 = s0_462_2 * s1_462;
    // Op 463: dim3x1 add
    gl64_t s1_463 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_463; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 464: dim3x3 mul
    gl64_t s1_464_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_464_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_464_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA464 = (tmp3_0 + tmp3_1) * (s1_464_0 + s1_464_1);
    gl64_t kB464 = (tmp3_0 + tmp3_2) * (s1_464_0 + s1_464_2);
    gl64_t kC464 = (tmp3_1 + tmp3_2) * (s1_464_1 + s1_464_2);
    gl64_t kD464 = tmp3_0 * s1_464_0;
    gl64_t kE464 = tmp3_1 * s1_464_1;
    gl64_t kF464 = tmp3_2 * s1_464_2;
    gl64_t kG464 = kD464 - kE464;
    tmp3_0 = (kC464 + kG464) - kF464;
    tmp3_1 = ((((kA464 + kC464) - kE464) - kE464) - kD464);
    tmp3_2 = kB464 - kG464;
    // Op 465: dim3x1 add
    gl64_t s1_465 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_465; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 466: dim3x3 mul
    gl64_t s1_466_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_466_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_466_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA466 = (tmp3_0 + tmp3_1) * (s1_466_0 + s1_466_1);
    gl64_t kB466 = (tmp3_0 + tmp3_2) * (s1_466_0 + s1_466_2);
    gl64_t kC466 = (tmp3_1 + tmp3_2) * (s1_466_1 + s1_466_2);
    gl64_t kD466 = tmp3_0 * s1_466_0;
    gl64_t kE466 = tmp3_1 * s1_466_1;
    gl64_t kF466 = tmp3_2 * s1_466_2;
    gl64_t kG466 = kD466 - kE466;
    tmp3_0 = (kC466 + kG466) - kF466;
    tmp3_1 = ((((kA466 + kC466) - kE466) - kE466) - kD466);
    tmp3_2 = kB466 - kG466;
    // Op 467: dim3x1 add
    gl64_t s1_467 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_467; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 468: dim3x3 mul
    gl64_t s1_468_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_468_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_468_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA468 = (tmp3_0 + tmp3_1) * (s1_468_0 + s1_468_1);
    gl64_t kB468 = (tmp3_0 + tmp3_2) * (s1_468_0 + s1_468_2);
    gl64_t kC468 = (tmp3_1 + tmp3_2) * (s1_468_1 + s1_468_2);
    gl64_t kD468 = tmp3_0 * s1_468_0;
    gl64_t kE468 = tmp3_1 * s1_468_1;
    gl64_t kF468 = tmp3_2 * s1_468_2;
    gl64_t kG468 = kD468 - kE468;
    tmp3_0 = (kC468 + kG468) - kF468;
    tmp3_1 = ((((kA468 + kC468) - kE468) - kE468) - kD468);
    tmp3_2 = kB468 - kG468;
    // Op 469: dim3x1 add
    gl64_t s1_469 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_469; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 470: dim3x3 mul
    gl64_t s1_470_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_470_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_470_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA470 = (tmp3_0 + tmp3_1) * (s1_470_0 + s1_470_1);
    gl64_t kB470 = (tmp3_0 + tmp3_2) * (s1_470_0 + s1_470_2);
    gl64_t kC470 = (tmp3_1 + tmp3_2) * (s1_470_1 + s1_470_2);
    gl64_t kD470 = tmp3_0 * s1_470_0;
    gl64_t kE470 = tmp3_1 * s1_470_1;
    gl64_t kF470 = tmp3_2 * s1_470_2;
    gl64_t kG470 = kD470 - kE470;
    tmp3_0 = (kC470 + kG470) - kF470;
    tmp3_1 = ((((kA470 + kC470) - kE470) - kE470) - kD470);
    tmp3_2 = kB470 - kG470;
    // Op 471: dim3x1 add
    gl64_t s1_471 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_471; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 472: dim3x3 mul
    gl64_t s1_472_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_472_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_472_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA472 = (tmp3_0 + tmp3_1) * (s1_472_0 + s1_472_1);
    gl64_t kB472 = (tmp3_0 + tmp3_2) * (s1_472_0 + s1_472_2);
    gl64_t kC472 = (tmp3_1 + tmp3_2) * (s1_472_1 + s1_472_2);
    gl64_t kD472 = tmp3_0 * s1_472_0;
    gl64_t kE472 = tmp3_1 * s1_472_1;
    gl64_t kF472 = tmp3_2 * s1_472_2;
    gl64_t kG472 = kD472 - kE472;
    tmp3_0 = (kC472 + kG472) - kF472;
    tmp3_1 = ((((kA472 + kC472) - kE472) - kE472) - kD472);
    tmp3_2 = kB472 - kG472;
    // Op 473: dim3x1 add
    gl64_t s1_473 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_473; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 474: dim3x3 add
    gl64_t s1_474_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_474_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_474_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_474_0; tmp3_1 = tmp3_1 + s1_474_1; tmp3_2 = tmp3_2 + s1_474_2;
    // Op 475: dim3x3 mul
    gl64_t kA475 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB475 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC475 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD475 = tmp3_12 * tmp3_0;
    gl64_t kE475 = tmp3_13 * tmp3_1;
    gl64_t kF475 = tmp3_14 * tmp3_2;
    gl64_t kG475 = kD475 - kE475;
    tmp3_0 = (kC475 + kG475) - kF475;
    tmp3_1 = ((((kA475 + kC475) - kE475) - kE475) - kD475);
    tmp3_2 = kB475 - kG475;
    // Op 476: dim3x1 sub
    gl64_t s1_476 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 - s1_476; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 477: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 478: dim3x3 mul
    gl64_t s1_478_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_478_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_478_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA478 = (tmp3_0 + tmp3_1) * (s1_478_0 + s1_478_1);
    gl64_t kB478 = (tmp3_0 + tmp3_2) * (s1_478_0 + s1_478_2);
    gl64_t kC478 = (tmp3_1 + tmp3_2) * (s1_478_1 + s1_478_2);
    gl64_t kD478 = tmp3_0 * s1_478_0;
    gl64_t kE478 = tmp3_1 * s1_478_1;
    gl64_t kF478 = tmp3_2 * s1_478_2;
    gl64_t kG478 = kD478 - kE478;
    tmp3_6 = (kC478 + kG478) - kF478;
    tmp3_7 = ((((kA478 + kC478) - kE478) - kE478) - kD478);
    tmp3_8 = kB478 - kG478;
    // Op 479: dim3x1 mul
    gl64_t s0_479_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_479_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_479_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_479 = *(gl64_t*)&expressions_params[10][4];
    tmp3_0 = s0_479_0 * s1_479; tmp3_1 = s0_479_1 * s1_479; tmp3_2 = s0_479_2 * s1_479;
    // Op 480: dim3x1 add
    gl64_t s1_480 = *(gl64_t*)&expressions_params[10][3];
    tmp3_0 = tmp3_0 + s1_480; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_482 = *(gl64_t*)&expressions_params[10][2];
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
    // Op 484: dim3x3 mul
    gl64_t s1_484_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_484_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_484_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA484 = (tmp3_0 + tmp3_1) * (s1_484_0 + s1_484_1);
    gl64_t kB484 = (tmp3_0 + tmp3_2) * (s1_484_0 + s1_484_2);
    gl64_t kC484 = (tmp3_1 + tmp3_2) * (s1_484_1 + s1_484_2);
    gl64_t kD484 = tmp3_0 * s1_484_0;
    gl64_t kE484 = tmp3_1 * s1_484_1;
    gl64_t kF484 = tmp3_2 * s1_484_2;
    gl64_t kG484 = kD484 - kE484;
    tmp3_0 = (kC484 + kG484) - kF484;
    tmp3_1 = ((((kA484 + kC484) - kE484) - kE484) - kD484);
    tmp3_2 = kB484 - kG484;
    // Op 485: dim3x1 add
    gl64_t s1_485 = *(gl64_t*)&expressions_params[10][1];
    tmp3_0 = tmp3_0 + s1_485; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 486: dim3x3 mul
    gl64_t s1_486_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_486_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_486_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    gl64_t s1_487 = *(gl64_t*)&expressions_params[9][23];
    tmp3_0 = tmp3_0 + s1_487; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 488: dim3x3 add
    gl64_t s1_488_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_488_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_488_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_488_0; tmp3_1 = tmp3_1 + s1_488_1; tmp3_2 = tmp3_2 + s1_488_2;
    // Op 489: dim3x3 mul
    gl64_t s1_489_0 = *(gl64_t*)&expressions_params[10][101];
    gl64_t s1_489_1 = *(gl64_t*)&expressions_params[10][101+1];
    gl64_t s1_489_2 = *(gl64_t*)&expressions_params[10][101+2];
    gl64_t kA489 = (tmp3_0 + tmp3_1) * (s1_489_0 + s1_489_1);
    gl64_t kB489 = (tmp3_0 + tmp3_2) * (s1_489_0 + s1_489_2);
    gl64_t kC489 = (tmp3_1 + tmp3_2) * (s1_489_1 + s1_489_2);
    gl64_t kD489 = tmp3_0 * s1_489_0;
    gl64_t kE489 = tmp3_1 * s1_489_1;
    gl64_t kF489 = tmp3_2 * s1_489_2;
    gl64_t kG489 = kD489 - kE489;
    tmp3_0 = (kC489 + kG489) - kF489;
    tmp3_1 = ((((kA489 + kC489) - kE489) - kE489) - kD489);
    tmp3_2 = kB489 - kG489;
    // Op 490: dim3x1 add
    gl64_t s1_490 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_490; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 491: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 492: dim3x3 mul
    gl64_t s1_492_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_492_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_492_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA492 = (tmp3_0 + tmp3_1) * (s1_492_0 + s1_492_1);
    gl64_t kB492 = (tmp3_0 + tmp3_2) * (s1_492_0 + s1_492_2);
    gl64_t kC492 = (tmp3_1 + tmp3_2) * (s1_492_1 + s1_492_2);
    gl64_t kD492 = tmp3_0 * s1_492_0;
    gl64_t kE492 = tmp3_1 * s1_492_1;
    gl64_t kF492 = tmp3_2 * s1_492_2;
    gl64_t kG492 = kD492 - kE492;
    tmp3_6 = (kC492 + kG492) - kF492;
    tmp3_7 = ((((kA492 + kC492) - kE492) - kE492) - kD492);
    tmp3_8 = kB492 - kG492;
    // Op 493: dim3x1 mul
    gl64_t s0_493_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_493_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_493_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_493 = *(gl64_t*)&expressions_params[10][7];
    tmp3_0 = s0_493_0 * s1_493; tmp3_1 = s0_493_1 * s1_493; tmp3_2 = s0_493_2 * s1_493;
    // Op 494: dim3x1 add
    gl64_t s1_494 = *(gl64_t*)&expressions_params[10][6];
    tmp3_0 = tmp3_0 + s1_494; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 495: dim3x3 mul
    gl64_t s1_495_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_495_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_495_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA495 = (tmp3_0 + tmp3_1) * (s1_495_0 + s1_495_1);
    gl64_t kB495 = (tmp3_0 + tmp3_2) * (s1_495_0 + s1_495_2);
    gl64_t kC495 = (tmp3_1 + tmp3_2) * (s1_495_1 + s1_495_2);
    gl64_t kD495 = tmp3_0 * s1_495_0;
    gl64_t kE495 = tmp3_1 * s1_495_1;
    gl64_t kF495 = tmp3_2 * s1_495_2;
    gl64_t kG495 = kD495 - kE495;
    tmp3_0 = (kC495 + kG495) - kF495;
    tmp3_1 = ((((kA495 + kC495) - kE495) - kE495) - kD495);
    tmp3_2 = kB495 - kG495;
    // Op 496: dim3x1 add
    gl64_t s1_496 = *(gl64_t*)&expressions_params[10][5];
    tmp3_0 = tmp3_0 + s1_496; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 497: dim3x3 mul
    gl64_t s1_497_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_497_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_497_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA497 = (tmp3_0 + tmp3_1) * (s1_497_0 + s1_497_1);
    gl64_t kB497 = (tmp3_0 + tmp3_2) * (s1_497_0 + s1_497_2);
    gl64_t kC497 = (tmp3_1 + tmp3_2) * (s1_497_1 + s1_497_2);
    gl64_t kD497 = tmp3_0 * s1_497_0;
    gl64_t kE497 = tmp3_1 * s1_497_1;
    gl64_t kF497 = tmp3_2 * s1_497_2;
    gl64_t kG497 = kD497 - kE497;
    tmp3_0 = (kC497 + kG497) - kF497;
    tmp3_1 = ((((kA497 + kC497) - kE497) - kE497) - kD497);
    tmp3_2 = kB497 - kG497;
    // Op 498: dim3x1 add
    gl64_t s1_498 = *(gl64_t*)&expressions_params[10][0];
    tmp3_0 = tmp3_0 + s1_498; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 499: dim3x3 mul
    gl64_t s1_499_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_499_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_499_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA499 = (tmp3_0 + tmp3_1) * (s1_499_0 + s1_499_1);
    gl64_t kB499 = (tmp3_0 + tmp3_2) * (s1_499_0 + s1_499_2);
    gl64_t kC499 = (tmp3_1 + tmp3_2) * (s1_499_1 + s1_499_2);
    gl64_t kD499 = tmp3_0 * s1_499_0;
    gl64_t kE499 = tmp3_1 * s1_499_1;
    gl64_t kF499 = tmp3_2 * s1_499_2;
    gl64_t kG499 = kD499 - kE499;
    tmp3_0 = (kC499 + kG499) - kF499;
    tmp3_1 = ((((kA499 + kC499) - kE499) - kE499) - kD499);
    tmp3_2 = kB499 - kG499;
    // Op 500: dim1x1 add
    gl64_t s0_500 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_500 = *(gl64_t*)&expressions_params[10][1];
    tmp1_4 = s0_500 + s1_500;
    // Op 501: dim1x1 sub
    gl64_t s0_501 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_501 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_501 - s1_501;
    // Op 502: dim1x1 mul
    tmp1_0 = tmp1_4 * tmp1_0;
    // Op 503: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 504: dim3x3 mul
    gl64_t s1_504_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_504_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_504_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 505: dim3x1 add
    gl64_t s1_505 = *(gl64_t*)&expressions_params[9][23];
    tmp3_0 = tmp3_0 + s1_505; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 506: dim3x3 add
    gl64_t s1_506_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_506_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_506_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_506_0; tmp3_1 = tmp3_1 + s1_506_1; tmp3_2 = tmp3_2 + s1_506_2;
    // Op 507: dim3x3 mul
    gl64_t s1_507_0 = *(gl64_t*)&expressions_params[10][104];
    gl64_t s1_507_1 = *(gl64_t*)&expressions_params[10][104+1];
    gl64_t s1_507_2 = *(gl64_t*)&expressions_params[10][104+2];
    gl64_t kA507 = (tmp3_0 + tmp3_1) * (s1_507_0 + s1_507_1);
    gl64_t kB507 = (tmp3_0 + tmp3_2) * (s1_507_0 + s1_507_2);
    gl64_t kC507 = (tmp3_1 + tmp3_2) * (s1_507_1 + s1_507_2);
    gl64_t kD507 = tmp3_0 * s1_507_0;
    gl64_t kE507 = tmp3_1 * s1_507_1;
    gl64_t kF507 = tmp3_2 * s1_507_2;
    gl64_t kG507 = kD507 - kE507;
    tmp3_0 = (kC507 + kG507) - kF507;
    tmp3_1 = ((((kA507 + kC507) - kE507) - kE507) - kD507);
    tmp3_2 = kB507 - kG507;
    // Op 508: dim3x1 sub
    gl64_t s1_508 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_508; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 509: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 510: dim3x3 mul
    gl64_t s1_510_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_510_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_510_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA510 = (tmp3_0 + tmp3_1) * (s1_510_0 + s1_510_1);
    gl64_t kB510 = (tmp3_0 + tmp3_2) * (s1_510_0 + s1_510_2);
    gl64_t kC510 = (tmp3_1 + tmp3_2) * (s1_510_1 + s1_510_2);
    gl64_t kD510 = tmp3_0 * s1_510_0;
    gl64_t kE510 = tmp3_1 * s1_510_1;
    gl64_t kF510 = tmp3_2 * s1_510_2;
    gl64_t kG510 = kD510 - kE510;
    tmp3_6 = (kC510 + kG510) - kF510;
    tmp3_7 = ((((kA510 + kC510) - kE510) - kE510) - kD510);
    tmp3_8 = kB510 - kG510;
    // Op 511: dim1x1 add
    gl64_t s0_511 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_511 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_511 + s1_511;
    // Op 512: dim1x1 mul
    gl64_t s1_512 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = tmp1_0 * s1_512;
    // Op 513: dim1x1 sub
    gl64_t s1_513 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_513;
    // Op 514: dim1x1 mul
    gl64_t s1_514 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = tmp1_0 * s1_514;
    // Op 515: dim1x1 add
    gl64_t s1_515 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_515;
    // Op 516: dim1x1 add
    gl64_t s1_516 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = tmp1_0 + s1_516;
    // Op 517: dim1x1 sub
    gl64_t s1_517 = *(gl64_t*)&expressions_params[9][0];
    tmp1_4 = tmp1_0 - s1_517;
    // Op 518: dim1x1 sub
    gl64_t s1_518 = *(gl64_t*)&expressions_params[10][70];
    tmp1_0 = tmp1_4 - s1_518;
    // Op 519: dim1x1 sub
    gl64_t s1_519 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_519;
    // Op 520: dim3x1 mul
    gl64_t s0_520_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_520_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_520_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_520_0 * tmp1_0; tmp3_1 = s0_520_1 * tmp1_0; tmp3_2 = s0_520_2 * tmp1_0;
    // Op 521: dim3x1 add
    gl64_t s1_521 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_521; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 522: dim3x3 add
    gl64_t s1_522_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_522_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_522_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_522_0; tmp3_1 = tmp3_1 + s1_522_1; tmp3_2 = tmp3_2 + s1_522_2;
    // Op 523: dim3x3 mul
    gl64_t s1_523_0 = *(gl64_t*)&expressions_params[10][107];
    gl64_t s1_523_1 = *(gl64_t*)&expressions_params[10][107+1];
    gl64_t s1_523_2 = *(gl64_t*)&expressions_params[10][107+2];
    gl64_t kA523 = (tmp3_0 + tmp3_1) * (s1_523_0 + s1_523_1);
    gl64_t kB523 = (tmp3_0 + tmp3_2) * (s1_523_0 + s1_523_2);
    gl64_t kC523 = (tmp3_1 + tmp3_2) * (s1_523_1 + s1_523_2);
    gl64_t kD523 = tmp3_0 * s1_523_0;
    gl64_t kE523 = tmp3_1 * s1_523_1;
    gl64_t kF523 = tmp3_2 * s1_523_2;
    gl64_t kG523 = kD523 - kE523;
    tmp3_0 = (kC523 + kG523) - kF523;
    tmp3_1 = ((((kA523 + kC523) - kE523) - kE523) - kD523);
    tmp3_2 = kB523 - kG523;
    // Op 524: dim3x1 add
    gl64_t s1_524 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_524; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 525: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 526: dim3x3 mul
    gl64_t s1_526_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_526_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_526_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA526 = (tmp3_0 + tmp3_1) * (s1_526_0 + s1_526_1);
    gl64_t kB526 = (tmp3_0 + tmp3_2) * (s1_526_0 + s1_526_2);
    gl64_t kC526 = (tmp3_1 + tmp3_2) * (s1_526_1 + s1_526_2);
    gl64_t kD526 = tmp3_0 * s1_526_0;
    gl64_t kE526 = tmp3_1 * s1_526_1;
    gl64_t kF526 = tmp3_2 * s1_526_2;
    gl64_t kG526 = kD526 - kE526;
    tmp3_6 = (kC526 + kG526) - kF526;
    tmp3_7 = ((((kA526 + kC526) - kE526) - kE526) - kD526);
    tmp3_8 = kB526 - kG526;
    // Op 527: dim3x1 mul
    gl64_t s0_527_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_527_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_527_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_527 = *(gl64_t*)&expressions_params[10][9];
    tmp3_0 = s0_527_0 * s1_527; tmp3_1 = s0_527_1 * s1_527; tmp3_2 = s0_527_2 * s1_527;
    // Op 528: dim3x1 add
    gl64_t s1_528 = *(gl64_t*)&expressions_params[10][8];
    tmp3_0 = tmp3_0 + s1_528; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 529: dim3x3 mul
    gl64_t s1_529_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_529_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_529_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA529 = (tmp3_0 + tmp3_1) * (s1_529_0 + s1_529_1);
    gl64_t kB529 = (tmp3_0 + tmp3_2) * (s1_529_0 + s1_529_2);
    gl64_t kC529 = (tmp3_1 + tmp3_2) * (s1_529_1 + s1_529_2);
    gl64_t kD529 = tmp3_0 * s1_529_0;
    gl64_t kE529 = tmp3_1 * s1_529_1;
    gl64_t kF529 = tmp3_2 * s1_529_2;
    gl64_t kG529 = kD529 - kE529;
    tmp3_0 = (kC529 + kG529) - kF529;
    tmp3_1 = ((((kA529 + kC529) - kE529) - kE529) - kD529);
    tmp3_2 = kB529 - kG529;
    // Op 530: dim3x1 add
    gl64_t s1_530 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_530; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 531: dim3x3 mul
    gl64_t s1_531_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_531_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_531_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA531 = (tmp3_0 + tmp3_1) * (s1_531_0 + s1_531_1);
    gl64_t kB531 = (tmp3_0 + tmp3_2) * (s1_531_0 + s1_531_2);
    gl64_t kC531 = (tmp3_1 + tmp3_2) * (s1_531_1 + s1_531_2);
    gl64_t kD531 = tmp3_0 * s1_531_0;
    gl64_t kE531 = tmp3_1 * s1_531_1;
    gl64_t kF531 = tmp3_2 * s1_531_2;
    gl64_t kG531 = kD531 - kE531;
    tmp3_0 = (kC531 + kG531) - kF531;
    tmp3_1 = ((((kA531 + kC531) - kE531) - kE531) - kD531);
    tmp3_2 = kB531 - kG531;
    // Op 532: dim3x1 add
    gl64_t s1_532 = *(gl64_t*)&expressions_params[10][70];
    tmp3_0 = tmp3_0 + s1_532; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 533: dim3x3 mul
    gl64_t s1_533_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_533_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_533_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA533 = (tmp3_0 + tmp3_1) * (s1_533_0 + s1_533_1);
    gl64_t kB533 = (tmp3_0 + tmp3_2) * (s1_533_0 + s1_533_2);
    gl64_t kC533 = (tmp3_1 + tmp3_2) * (s1_533_1 + s1_533_2);
    gl64_t kD533 = tmp3_0 * s1_533_0;
    gl64_t kE533 = tmp3_1 * s1_533_1;
    gl64_t kF533 = tmp3_2 * s1_533_2;
    gl64_t kG533 = kD533 - kE533;
    tmp3_0 = (kC533 + kG533) - kF533;
    tmp3_1 = ((((kA533 + kC533) - kE533) - kE533) - kD533);
    tmp3_2 = kB533 - kG533;
    // Op 534: dim3x1 add
    gl64_t s1_534 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_534; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 535: dim3x3 mul
    gl64_t s1_535_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_535_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_535_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA535 = (tmp3_0 + tmp3_1) * (s1_535_0 + s1_535_1);
    gl64_t kB535 = (tmp3_0 + tmp3_2) * (s1_535_0 + s1_535_2);
    gl64_t kC535 = (tmp3_1 + tmp3_2) * (s1_535_1 + s1_535_2);
    gl64_t kD535 = tmp3_0 * s1_535_0;
    gl64_t kE535 = tmp3_1 * s1_535_1;
    gl64_t kF535 = tmp3_2 * s1_535_2;
    gl64_t kG535 = kD535 - kE535;
    tmp3_0 = (kC535 + kG535) - kF535;
    tmp3_1 = ((((kA535 + kC535) - kE535) - kE535) - kD535);
    tmp3_2 = kB535 - kG535;
    // Op 536: dim3x1 add
    gl64_t s1_536 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_536; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 537: dim3x3 mul
    gl64_t s1_537_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_537_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_537_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 538: dim3x1 add
    gl64_t s1_538 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_538; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 539: dim3x3 add
    gl64_t s1_539_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_539_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_539_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_539_0; tmp3_1 = tmp3_1 + s1_539_1; tmp3_2 = tmp3_2 + s1_539_2;
    // Op 540: dim3x3 mul
    gl64_t s1_540_0 = *(gl64_t*)&expressions_params[10][110];
    gl64_t s1_540_1 = *(gl64_t*)&expressions_params[10][110+1];
    gl64_t s1_540_2 = *(gl64_t*)&expressions_params[10][110+2];
    gl64_t kA540 = (tmp3_0 + tmp3_1) * (s1_540_0 + s1_540_1);
    gl64_t kB540 = (tmp3_0 + tmp3_2) * (s1_540_0 + s1_540_2);
    gl64_t kC540 = (tmp3_1 + tmp3_2) * (s1_540_1 + s1_540_2);
    gl64_t kD540 = tmp3_0 * s1_540_0;
    gl64_t kE540 = tmp3_1 * s1_540_1;
    gl64_t kF540 = tmp3_2 * s1_540_2;
    gl64_t kG540 = kD540 - kE540;
    tmp3_0 = (kC540 + kG540) - kF540;
    tmp3_1 = ((((kA540 + kC540) - kE540) - kE540) - kD540);
    tmp3_2 = kB540 - kG540;
    // Op 541: dim3x1 sub
    gl64_t s1_541 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_541; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 542: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 543: dim3x3 mul
    gl64_t s1_543_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_543_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_543_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA543 = (tmp3_0 + tmp3_1) * (s1_543_0 + s1_543_1);
    gl64_t kB543 = (tmp3_0 + tmp3_2) * (s1_543_0 + s1_543_2);
    gl64_t kC543 = (tmp3_1 + tmp3_2) * (s1_543_1 + s1_543_2);
    gl64_t kD543 = tmp3_0 * s1_543_0;
    gl64_t kE543 = tmp3_1 * s1_543_1;
    gl64_t kF543 = tmp3_2 * s1_543_2;
    gl64_t kG543 = kD543 - kE543;
    tmp3_6 = (kC543 + kG543) - kF543;
    tmp3_7 = ((((kA543 + kC543) - kE543) - kE543) - kD543);
    tmp3_8 = kB543 - kG543;
    // Op 544: dim3x1 mul
    gl64_t s0_544_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_544_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_544_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_544 = *(gl64_t*)&expressions_params[10][9];
    tmp3_0 = s0_544_0 * s1_544; tmp3_1 = s0_544_1 * s1_544; tmp3_2 = s0_544_2 * s1_544;
    // Op 545: dim3x1 add
    gl64_t s1_545 = *(gl64_t*)&expressions_params[10][8];
    tmp3_0 = tmp3_0 + s1_545; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 546: dim3x3 mul
    gl64_t s1_546_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_546_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_546_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA546 = (tmp3_0 + tmp3_1) * (s1_546_0 + s1_546_1);
    gl64_t kB546 = (tmp3_0 + tmp3_2) * (s1_546_0 + s1_546_2);
    gl64_t kC546 = (tmp3_1 + tmp3_2) * (s1_546_1 + s1_546_2);
    gl64_t kD546 = tmp3_0 * s1_546_0;
    gl64_t kE546 = tmp3_1 * s1_546_1;
    gl64_t kF546 = tmp3_2 * s1_546_2;
    gl64_t kG546 = kD546 - kE546;
    tmp3_0 = (kC546 + kG546) - kF546;
    tmp3_1 = ((((kA546 + kC546) - kE546) - kE546) - kD546);
    tmp3_2 = kB546 - kG546;
    // Op 547: dim3x1 add
    gl64_t s1_547 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_547; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 548: dim3x3 mul
    gl64_t s1_548_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_548_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_548_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA548 = (tmp3_0 + tmp3_1) * (s1_548_0 + s1_548_1);
    gl64_t kB548 = (tmp3_0 + tmp3_2) * (s1_548_0 + s1_548_2);
    gl64_t kC548 = (tmp3_1 + tmp3_2) * (s1_548_1 + s1_548_2);
    gl64_t kD548 = tmp3_0 * s1_548_0;
    gl64_t kE548 = tmp3_1 * s1_548_1;
    gl64_t kF548 = tmp3_2 * s1_548_2;
    gl64_t kG548 = kD548 - kE548;
    tmp3_0 = (kC548 + kG548) - kF548;
    tmp3_1 = ((((kA548 + kC548) - kE548) - kE548) - kD548);
    tmp3_2 = kB548 - kG548;
    // Op 549: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 550: dim3x3 mul
    gl64_t s1_550_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_550_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_550_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA550 = (tmp3_0 + tmp3_1) * (s1_550_0 + s1_550_1);
    gl64_t kB550 = (tmp3_0 + tmp3_2) * (s1_550_0 + s1_550_2);
    gl64_t kC550 = (tmp3_1 + tmp3_2) * (s1_550_1 + s1_550_2);
    gl64_t kD550 = tmp3_0 * s1_550_0;
    gl64_t kE550 = tmp3_1 * s1_550_1;
    gl64_t kF550 = tmp3_2 * s1_550_2;
    gl64_t kG550 = kD550 - kE550;
    tmp3_0 = (kC550 + kG550) - kF550;
    tmp3_1 = ((((kA550 + kC550) - kE550) - kE550) - kD550);
    tmp3_2 = kB550 - kG550;
    // Op 551: dim3x1 add
    gl64_t s1_551 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_551; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 552: dim3x3 mul
    gl64_t s1_552_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_552_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_552_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA552 = (tmp3_0 + tmp3_1) * (s1_552_0 + s1_552_1);
    gl64_t kB552 = (tmp3_0 + tmp3_2) * (s1_552_0 + s1_552_2);
    gl64_t kC552 = (tmp3_1 + tmp3_2) * (s1_552_1 + s1_552_2);
    gl64_t kD552 = tmp3_0 * s1_552_0;
    gl64_t kE552 = tmp3_1 * s1_552_1;
    gl64_t kF552 = tmp3_2 * s1_552_2;
    gl64_t kG552 = kD552 - kE552;
    tmp3_0 = (kC552 + kG552) - kF552;
    tmp3_1 = ((((kA552 + kC552) - kE552) - kE552) - kD552);
    tmp3_2 = kB552 - kG552;
    // Op 553: dim3x1 add
    gl64_t s1_553 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_553; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 554: dim3x3 mul
    gl64_t s1_554_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_554_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_554_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 555: dim3x1 add
    gl64_t s1_555 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_555; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 556: dim3x3 add
    gl64_t s1_556_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_556_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_556_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_556_0; tmp3_1 = tmp3_1 + s1_556_1; tmp3_2 = tmp3_2 + s1_556_2;
    // Op 557: dim3x3 mul
    gl64_t s1_557_0 = *(gl64_t*)&expressions_params[10][113];
    gl64_t s1_557_1 = *(gl64_t*)&expressions_params[10][113+1];
    gl64_t s1_557_2 = *(gl64_t*)&expressions_params[10][113+2];
    gl64_t kA557 = (tmp3_0 + tmp3_1) * (s1_557_0 + s1_557_1);
    gl64_t kB557 = (tmp3_0 + tmp3_2) * (s1_557_0 + s1_557_2);
    gl64_t kC557 = (tmp3_1 + tmp3_2) * (s1_557_1 + s1_557_2);
    gl64_t kD557 = tmp3_0 * s1_557_0;
    gl64_t kE557 = tmp3_1 * s1_557_1;
    gl64_t kF557 = tmp3_2 * s1_557_2;
    gl64_t kG557 = kD557 - kE557;
    tmp3_0 = (kC557 + kG557) - kF557;
    tmp3_1 = ((((kA557 + kC557) - kE557) - kE557) - kD557);
    tmp3_2 = kB557 - kG557;
    // Op 558: dim1x1 sub
    gl64_t s0_558 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_558 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_558 - s1_558;
    // Op 559: dim1x1 sub_swap
    gl64_t s1_559 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_559 - tmp1_0;
    // Op 560: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 561: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 562: dim3x3 mul
    gl64_t s1_562_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_562_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_562_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA562 = (tmp3_0 + tmp3_1) * (s1_562_0 + s1_562_1);
    gl64_t kB562 = (tmp3_0 + tmp3_2) * (s1_562_0 + s1_562_2);
    gl64_t kC562 = (tmp3_1 + tmp3_2) * (s1_562_1 + s1_562_2);
    gl64_t kD562 = tmp3_0 * s1_562_0;
    gl64_t kE562 = tmp3_1 * s1_562_1;
    gl64_t kF562 = tmp3_2 * s1_562_2;
    gl64_t kG562 = kD562 - kE562;
    tmp3_6 = (kC562 + kG562) - kF562;
    tmp3_7 = ((((kA562 + kC562) - kE562) - kE562) - kD562);
    tmp3_8 = kB562 - kG562;
    // Op 563: dim1x1 sub
    gl64_t s1_563 = *(gl64_t*)&expressions_params[10][71];
    tmp1_0 = tmp1_4 - s1_563;
    // Op 564: dim1x1 sub
    gl64_t s1_564 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_564;
    // Op 565: dim3x1 mul
    gl64_t s0_565_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_565_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_565_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_565_0 * tmp1_0; tmp3_1 = s0_565_1 * tmp1_0; tmp3_2 = s0_565_2 * tmp1_0;
    // Op 566: dim3x1 add
    gl64_t s1_566 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_566; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 567: dim3x3 add
    gl64_t s1_567_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_567_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_567_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_567_0; tmp3_1 = tmp3_1 + s1_567_1; tmp3_2 = tmp3_2 + s1_567_2;
    // Op 568: dim3x3 mul
    gl64_t s1_568_0 = *(gl64_t*)&expressions_params[10][116];
    gl64_t s1_568_1 = *(gl64_t*)&expressions_params[10][116+1];
    gl64_t s1_568_2 = *(gl64_t*)&expressions_params[10][116+2];
    gl64_t kA568 = (tmp3_0 + tmp3_1) * (s1_568_0 + s1_568_1);
    gl64_t kB568 = (tmp3_0 + tmp3_2) * (s1_568_0 + s1_568_2);
    gl64_t kC568 = (tmp3_1 + tmp3_2) * (s1_568_1 + s1_568_2);
    gl64_t kD568 = tmp3_0 * s1_568_0;
    gl64_t kE568 = tmp3_1 * s1_568_1;
    gl64_t kF568 = tmp3_2 * s1_568_2;
    gl64_t kG568 = kD568 - kE568;
    tmp3_0 = (kC568 + kG568) - kF568;
    tmp3_1 = ((((kA568 + kC568) - kE568) - kE568) - kD568);
    tmp3_2 = kB568 - kG568;
    // Op 569: dim3x1 add
    gl64_t s1_569 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_569; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 570: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 571: dim3x3 mul
    gl64_t s1_571_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_571_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_571_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA571 = (tmp3_0 + tmp3_1) * (s1_571_0 + s1_571_1);
    gl64_t kB571 = (tmp3_0 + tmp3_2) * (s1_571_0 + s1_571_2);
    gl64_t kC571 = (tmp3_1 + tmp3_2) * (s1_571_1 + s1_571_2);
    gl64_t kD571 = tmp3_0 * s1_571_0;
    gl64_t kE571 = tmp3_1 * s1_571_1;
    gl64_t kF571 = tmp3_2 * s1_571_2;
    gl64_t kG571 = kD571 - kE571;
    tmp3_6 = (kC571 + kG571) - kF571;
    tmp3_7 = ((((kA571 + kC571) - kE571) - kE571) - kD571);
    tmp3_8 = kB571 - kG571;
    // Op 572: dim3x1 mul
    gl64_t s0_572_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_572_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_572_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_572 = *(gl64_t*)&expressions_params[10][11];
    tmp3_0 = s0_572_0 * s1_572; tmp3_1 = s0_572_1 * s1_572; tmp3_2 = s0_572_2 * s1_572;
    // Op 573: dim3x1 add
    gl64_t s1_573 = *(gl64_t*)&expressions_params[10][10];
    tmp3_0 = tmp3_0 + s1_573; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 574: dim3x3 mul
    gl64_t s1_574_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_574_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_574_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA574 = (tmp3_0 + tmp3_1) * (s1_574_0 + s1_574_1);
    gl64_t kB574 = (tmp3_0 + tmp3_2) * (s1_574_0 + s1_574_2);
    gl64_t kC574 = (tmp3_1 + tmp3_2) * (s1_574_1 + s1_574_2);
    gl64_t kD574 = tmp3_0 * s1_574_0;
    gl64_t kE574 = tmp3_1 * s1_574_1;
    gl64_t kF574 = tmp3_2 * s1_574_2;
    gl64_t kG574 = kD574 - kE574;
    tmp3_0 = (kC574 + kG574) - kF574;
    tmp3_1 = ((((kA574 + kC574) - kE574) - kE574) - kD574);
    tmp3_2 = kB574 - kG574;
    // Op 575: dim3x1 add
    gl64_t s1_575 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_575; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 576: dim3x3 mul
    gl64_t s1_576_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_576_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_576_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA576 = (tmp3_0 + tmp3_1) * (s1_576_0 + s1_576_1);
    gl64_t kB576 = (tmp3_0 + tmp3_2) * (s1_576_0 + s1_576_2);
    gl64_t kC576 = (tmp3_1 + tmp3_2) * (s1_576_1 + s1_576_2);
    gl64_t kD576 = tmp3_0 * s1_576_0;
    gl64_t kE576 = tmp3_1 * s1_576_1;
    gl64_t kF576 = tmp3_2 * s1_576_2;
    gl64_t kG576 = kD576 - kE576;
    tmp3_0 = (kC576 + kG576) - kF576;
    tmp3_1 = ((((kA576 + kC576) - kE576) - kE576) - kD576);
    tmp3_2 = kB576 - kG576;
    // Op 577: dim3x1 add
    gl64_t s1_577 = *(gl64_t*)&expressions_params[10][71];
    tmp3_0 = tmp3_0 + s1_577; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 578: dim3x3 mul
    gl64_t s1_578_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_578_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_578_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA578 = (tmp3_0 + tmp3_1) * (s1_578_0 + s1_578_1);
    gl64_t kB578 = (tmp3_0 + tmp3_2) * (s1_578_0 + s1_578_2);
    gl64_t kC578 = (tmp3_1 + tmp3_2) * (s1_578_1 + s1_578_2);
    gl64_t kD578 = tmp3_0 * s1_578_0;
    gl64_t kE578 = tmp3_1 * s1_578_1;
    gl64_t kF578 = tmp3_2 * s1_578_2;
    gl64_t kG578 = kD578 - kE578;
    tmp3_0 = (kC578 + kG578) - kF578;
    tmp3_1 = ((((kA578 + kC578) - kE578) - kE578) - kD578);
    tmp3_2 = kB578 - kG578;
    // Op 579: dim3x1 add
    gl64_t s1_579 = *(gl64_t*)&expressions_params[9][8];
    tmp3_0 = tmp3_0 + s1_579; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 580: dim3x3 mul
    gl64_t s1_580_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_580_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_580_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA580 = (tmp3_0 + tmp3_1) * (s1_580_0 + s1_580_1);
    gl64_t kB580 = (tmp3_0 + tmp3_2) * (s1_580_0 + s1_580_2);
    gl64_t kC580 = (tmp3_1 + tmp3_2) * (s1_580_1 + s1_580_2);
    gl64_t kD580 = tmp3_0 * s1_580_0;
    gl64_t kE580 = tmp3_1 * s1_580_1;
    gl64_t kF580 = tmp3_2 * s1_580_2;
    gl64_t kG580 = kD580 - kE580;
    tmp3_0 = (kC580 + kG580) - kF580;
    tmp3_1 = ((((kA580 + kC580) - kE580) - kE580) - kD580);
    tmp3_2 = kB580 - kG580;
    // Op 581: dim3x1 add
    gl64_t s1_581 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_581; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 582: dim3x3 mul
    gl64_t s1_582_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_582_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_582_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 583: dim3x1 add
    gl64_t s1_583 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_583; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 584: dim3x3 add
    gl64_t s1_584_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_584_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_584_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_584_0; tmp3_1 = tmp3_1 + s1_584_1; tmp3_2 = tmp3_2 + s1_584_2;
    // Op 585: dim3x3 mul
    gl64_t s1_585_0 = *(gl64_t*)&expressions_params[10][119];
    gl64_t s1_585_1 = *(gl64_t*)&expressions_params[10][119+1];
    gl64_t s1_585_2 = *(gl64_t*)&expressions_params[10][119+2];
    gl64_t kA585 = (tmp3_0 + tmp3_1) * (s1_585_0 + s1_585_1);
    gl64_t kB585 = (tmp3_0 + tmp3_2) * (s1_585_0 + s1_585_2);
    gl64_t kC585 = (tmp3_1 + tmp3_2) * (s1_585_1 + s1_585_2);
    gl64_t kD585 = tmp3_0 * s1_585_0;
    gl64_t kE585 = tmp3_1 * s1_585_1;
    gl64_t kF585 = tmp3_2 * s1_585_2;
    gl64_t kG585 = kD585 - kE585;
    tmp3_0 = (kC585 + kG585) - kF585;
    tmp3_1 = ((((kA585 + kC585) - kE585) - kE585) - kD585);
    tmp3_2 = kB585 - kG585;
    // Op 586: dim3x1 sub
    gl64_t s1_586 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_586; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 587: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 588: dim3x3 mul
    gl64_t s1_588_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_588_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_588_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA588 = (tmp3_0 + tmp3_1) * (s1_588_0 + s1_588_1);
    gl64_t kB588 = (tmp3_0 + tmp3_2) * (s1_588_0 + s1_588_2);
    gl64_t kC588 = (tmp3_1 + tmp3_2) * (s1_588_1 + s1_588_2);
    gl64_t kD588 = tmp3_0 * s1_588_0;
    gl64_t kE588 = tmp3_1 * s1_588_1;
    gl64_t kF588 = tmp3_2 * s1_588_2;
    gl64_t kG588 = kD588 - kE588;
    tmp3_6 = (kC588 + kG588) - kF588;
    tmp3_7 = ((((kA588 + kC588) - kE588) - kE588) - kD588);
    tmp3_8 = kB588 - kG588;
    // Op 589: dim3x1 mul
    gl64_t s0_589_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_589_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_589_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_589 = *(gl64_t*)&expressions_params[10][11];
    tmp3_0 = s0_589_0 * s1_589; tmp3_1 = s0_589_1 * s1_589; tmp3_2 = s0_589_2 * s1_589;
    // Op 590: dim3x1 add
    gl64_t s1_590 = *(gl64_t*)&expressions_params[10][10];
    tmp3_0 = tmp3_0 + s1_590; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 591: dim3x3 mul
    gl64_t s1_591_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_591_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_591_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA591 = (tmp3_0 + tmp3_1) * (s1_591_0 + s1_591_1);
    gl64_t kB591 = (tmp3_0 + tmp3_2) * (s1_591_0 + s1_591_2);
    gl64_t kC591 = (tmp3_1 + tmp3_2) * (s1_591_1 + s1_591_2);
    gl64_t kD591 = tmp3_0 * s1_591_0;
    gl64_t kE591 = tmp3_1 * s1_591_1;
    gl64_t kF591 = tmp3_2 * s1_591_2;
    gl64_t kG591 = kD591 - kE591;
    tmp3_0 = (kC591 + kG591) - kF591;
    tmp3_1 = ((((kA591 + kC591) - kE591) - kE591) - kD591);
    tmp3_2 = kB591 - kG591;
    // Op 592: dim3x1 add
    gl64_t s1_592 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_592; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 593: dim3x3 mul
    gl64_t s1_593_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_593_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_593_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA593 = (tmp3_0 + tmp3_1) * (s1_593_0 + s1_593_1);
    gl64_t kB593 = (tmp3_0 + tmp3_2) * (s1_593_0 + s1_593_2);
    gl64_t kC593 = (tmp3_1 + tmp3_2) * (s1_593_1 + s1_593_2);
    gl64_t kD593 = tmp3_0 * s1_593_0;
    gl64_t kE593 = tmp3_1 * s1_593_1;
    gl64_t kF593 = tmp3_2 * s1_593_2;
    gl64_t kG593 = kD593 - kE593;
    tmp3_0 = (kC593 + kG593) - kF593;
    tmp3_1 = ((((kA593 + kC593) - kE593) - kE593) - kD593);
    tmp3_2 = kB593 - kG593;
    // Op 594: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 595: dim3x3 mul
    gl64_t s1_595_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_595_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_595_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA595 = (tmp3_0 + tmp3_1) * (s1_595_0 + s1_595_1);
    gl64_t kB595 = (tmp3_0 + tmp3_2) * (s1_595_0 + s1_595_2);
    gl64_t kC595 = (tmp3_1 + tmp3_2) * (s1_595_1 + s1_595_2);
    gl64_t kD595 = tmp3_0 * s1_595_0;
    gl64_t kE595 = tmp3_1 * s1_595_1;
    gl64_t kF595 = tmp3_2 * s1_595_2;
    gl64_t kG595 = kD595 - kE595;
    tmp3_0 = (kC595 + kG595) - kF595;
    tmp3_1 = ((((kA595 + kC595) - kE595) - kE595) - kD595);
    tmp3_2 = kB595 - kG595;
    // Op 596: dim3x1 add
    gl64_t s1_596 = *(gl64_t*)&expressions_params[9][8];
    tmp3_0 = tmp3_0 + s1_596; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 597: dim3x3 mul
    gl64_t s1_597_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_597_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_597_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA597 = (tmp3_0 + tmp3_1) * (s1_597_0 + s1_597_1);
    gl64_t kB597 = (tmp3_0 + tmp3_2) * (s1_597_0 + s1_597_2);
    gl64_t kC597 = (tmp3_1 + tmp3_2) * (s1_597_1 + s1_597_2);
    gl64_t kD597 = tmp3_0 * s1_597_0;
    gl64_t kE597 = tmp3_1 * s1_597_1;
    gl64_t kF597 = tmp3_2 * s1_597_2;
    gl64_t kG597 = kD597 - kE597;
    tmp3_0 = (kC597 + kG597) - kF597;
    tmp3_1 = ((((kA597 + kC597) - kE597) - kE597) - kD597);
    tmp3_2 = kB597 - kG597;
    // Op 598: dim3x1 add
    gl64_t s1_598 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_598; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 599: dim3x3 mul
    gl64_t s1_599_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_599_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_599_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 600: dim3x1 add
    gl64_t s1_600 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_600; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 601: dim3x3 add
    gl64_t s1_601_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_601_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_601_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_601_0; tmp3_1 = tmp3_1 + s1_601_1; tmp3_2 = tmp3_2 + s1_601_2;
    // Op 602: dim3x3 mul
    gl64_t s1_602_0 = *(gl64_t*)&expressions_params[10][122];
    gl64_t s1_602_1 = *(gl64_t*)&expressions_params[10][122+1];
    gl64_t s1_602_2 = *(gl64_t*)&expressions_params[10][122+2];
    gl64_t kA602 = (tmp3_0 + tmp3_1) * (s1_602_0 + s1_602_1);
    gl64_t kB602 = (tmp3_0 + tmp3_2) * (s1_602_0 + s1_602_2);
    gl64_t kC602 = (tmp3_1 + tmp3_2) * (s1_602_1 + s1_602_2);
    gl64_t kD602 = tmp3_0 * s1_602_0;
    gl64_t kE602 = tmp3_1 * s1_602_1;
    gl64_t kF602 = tmp3_2 * s1_602_2;
    gl64_t kG602 = kD602 - kE602;
    tmp3_0 = (kC602 + kG602) - kF602;
    tmp3_1 = ((((kA602 + kC602) - kE602) - kE602) - kD602);
    tmp3_2 = kB602 - kG602;
    // Op 603: dim1x1 sub
    gl64_t s0_603 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_603 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_603 - s1_603;
    // Op 604: dim1x1 sub_swap
    gl64_t s1_604 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_604 - tmp1_0;
    // Op 605: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 606: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 607: dim3x3 mul
    gl64_t s1_607_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_607_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_607_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA607 = (tmp3_0 + tmp3_1) * (s1_607_0 + s1_607_1);
    gl64_t kB607 = (tmp3_0 + tmp3_2) * (s1_607_0 + s1_607_2);
    gl64_t kC607 = (tmp3_1 + tmp3_2) * (s1_607_1 + s1_607_2);
    gl64_t kD607 = tmp3_0 * s1_607_0;
    gl64_t kE607 = tmp3_1 * s1_607_1;
    gl64_t kF607 = tmp3_2 * s1_607_2;
    gl64_t kG607 = kD607 - kE607;
    tmp3_6 = (kC607 + kG607) - kF607;
    tmp3_7 = ((((kA607 + kC607) - kE607) - kE607) - kD607);
    tmp3_8 = kB607 - kG607;
    // Op 608: dim1x1 sub
    gl64_t s1_608 = *(gl64_t*)&expressions_params[10][72];
    tmp1_0 = tmp1_4 - s1_608;
    // Op 609: dim1x1 sub
    gl64_t s1_609 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_609;
    // Op 610: dim3x1 mul
    gl64_t s0_610_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_610_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_610_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_610_0 * tmp1_0; tmp3_1 = s0_610_1 * tmp1_0; tmp3_2 = s0_610_2 * tmp1_0;
    // Op 611: dim3x1 add
    gl64_t s1_611 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_611; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 612: dim3x3 add
    gl64_t s1_612_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_612_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_612_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_612_0; tmp3_1 = tmp3_1 + s1_612_1; tmp3_2 = tmp3_2 + s1_612_2;
    // Op 613: dim3x3 mul
    gl64_t s1_613_0 = *(gl64_t*)&expressions_params[10][125];
    gl64_t s1_613_1 = *(gl64_t*)&expressions_params[10][125+1];
    gl64_t s1_613_2 = *(gl64_t*)&expressions_params[10][125+2];
    gl64_t kA613 = (tmp3_0 + tmp3_1) * (s1_613_0 + s1_613_1);
    gl64_t kB613 = (tmp3_0 + tmp3_2) * (s1_613_0 + s1_613_2);
    gl64_t kC613 = (tmp3_1 + tmp3_2) * (s1_613_1 + s1_613_2);
    gl64_t kD613 = tmp3_0 * s1_613_0;
    gl64_t kE613 = tmp3_1 * s1_613_1;
    gl64_t kF613 = tmp3_2 * s1_613_2;
    gl64_t kG613 = kD613 - kE613;
    tmp3_0 = (kC613 + kG613) - kF613;
    tmp3_1 = ((((kA613 + kC613) - kE613) - kE613) - kD613);
    tmp3_2 = kB613 - kG613;
    // Op 614: dim3x1 add
    gl64_t s1_614 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_614; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 615: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 616: dim3x3 mul
    gl64_t s1_616_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_616_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_616_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA616 = (tmp3_0 + tmp3_1) * (s1_616_0 + s1_616_1);
    gl64_t kB616 = (tmp3_0 + tmp3_2) * (s1_616_0 + s1_616_2);
    gl64_t kC616 = (tmp3_1 + tmp3_2) * (s1_616_1 + s1_616_2);
    gl64_t kD616 = tmp3_0 * s1_616_0;
    gl64_t kE616 = tmp3_1 * s1_616_1;
    gl64_t kF616 = tmp3_2 * s1_616_2;
    gl64_t kG616 = kD616 - kE616;
    tmp3_6 = (kC616 + kG616) - kF616;
    tmp3_7 = ((((kA616 + kC616) - kE616) - kE616) - kD616);
    tmp3_8 = kB616 - kG616;
    // Op 617: dim3x1 mul
    gl64_t s0_617_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_617_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_617_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_617 = *(gl64_t*)&expressions_params[10][13];
    tmp3_0 = s0_617_0 * s1_617; tmp3_1 = s0_617_1 * s1_617; tmp3_2 = s0_617_2 * s1_617;
    // Op 618: dim3x1 add
    gl64_t s1_618 = *(gl64_t*)&expressions_params[10][12];
    tmp3_0 = tmp3_0 + s1_618; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 619: dim3x3 mul
    gl64_t s1_619_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_619_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_619_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA619 = (tmp3_0 + tmp3_1) * (s1_619_0 + s1_619_1);
    gl64_t kB619 = (tmp3_0 + tmp3_2) * (s1_619_0 + s1_619_2);
    gl64_t kC619 = (tmp3_1 + tmp3_2) * (s1_619_1 + s1_619_2);
    gl64_t kD619 = tmp3_0 * s1_619_0;
    gl64_t kE619 = tmp3_1 * s1_619_1;
    gl64_t kF619 = tmp3_2 * s1_619_2;
    gl64_t kG619 = kD619 - kE619;
    tmp3_0 = (kC619 + kG619) - kF619;
    tmp3_1 = ((((kA619 + kC619) - kE619) - kE619) - kD619);
    tmp3_2 = kB619 - kG619;
    // Op 620: dim3x1 add
    gl64_t s1_620 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_620; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 621: dim3x3 mul
    gl64_t s1_621_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_621_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_621_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA621 = (tmp3_0 + tmp3_1) * (s1_621_0 + s1_621_1);
    gl64_t kB621 = (tmp3_0 + tmp3_2) * (s1_621_0 + s1_621_2);
    gl64_t kC621 = (tmp3_1 + tmp3_2) * (s1_621_1 + s1_621_2);
    gl64_t kD621 = tmp3_0 * s1_621_0;
    gl64_t kE621 = tmp3_1 * s1_621_1;
    gl64_t kF621 = tmp3_2 * s1_621_2;
    gl64_t kG621 = kD621 - kE621;
    tmp3_0 = (kC621 + kG621) - kF621;
    tmp3_1 = ((((kA621 + kC621) - kE621) - kE621) - kD621);
    tmp3_2 = kB621 - kG621;
    // Op 622: dim3x1 add
    gl64_t s1_622 = *(gl64_t*)&expressions_params[10][72];
    tmp3_0 = tmp3_0 + s1_622; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 623: dim3x3 mul
    gl64_t s1_623_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_623_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_623_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA623 = (tmp3_0 + tmp3_1) * (s1_623_0 + s1_623_1);
    gl64_t kB623 = (tmp3_0 + tmp3_2) * (s1_623_0 + s1_623_2);
    gl64_t kC623 = (tmp3_1 + tmp3_2) * (s1_623_1 + s1_623_2);
    gl64_t kD623 = tmp3_0 * s1_623_0;
    gl64_t kE623 = tmp3_1 * s1_623_1;
    gl64_t kF623 = tmp3_2 * s1_623_2;
    gl64_t kG623 = kD623 - kE623;
    tmp3_0 = (kC623 + kG623) - kF623;
    tmp3_1 = ((((kA623 + kC623) - kE623) - kE623) - kD623);
    tmp3_2 = kB623 - kG623;
    // Op 624: dim3x1 add
    gl64_t s1_624 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_624; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 625: dim3x3 mul
    gl64_t s1_625_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_625_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_625_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA625 = (tmp3_0 + tmp3_1) * (s1_625_0 + s1_625_1);
    gl64_t kB625 = (tmp3_0 + tmp3_2) * (s1_625_0 + s1_625_2);
    gl64_t kC625 = (tmp3_1 + tmp3_2) * (s1_625_1 + s1_625_2);
    gl64_t kD625 = tmp3_0 * s1_625_0;
    gl64_t kE625 = tmp3_1 * s1_625_1;
    gl64_t kF625 = tmp3_2 * s1_625_2;
    gl64_t kG625 = kD625 - kE625;
    tmp3_0 = (kC625 + kG625) - kF625;
    tmp3_1 = ((((kA625 + kC625) - kE625) - kE625) - kD625);
    tmp3_2 = kB625 - kG625;
    // Op 626: dim3x1 add
    gl64_t s1_626 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_626; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 627: dim3x3 mul
    gl64_t s1_627_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_627_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_627_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 628: dim3x1 add
    gl64_t s1_628 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_628; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 629: dim3x3 add
    gl64_t s1_629_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_629_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_629_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_629_0; tmp3_1 = tmp3_1 + s1_629_1; tmp3_2 = tmp3_2 + s1_629_2;
    // Op 630: dim3x3 mul
    gl64_t s1_630_0 = *(gl64_t*)&expressions_params[10][128];
    gl64_t s1_630_1 = *(gl64_t*)&expressions_params[10][128+1];
    gl64_t s1_630_2 = *(gl64_t*)&expressions_params[10][128+2];
    gl64_t kA630 = (tmp3_0 + tmp3_1) * (s1_630_0 + s1_630_1);
    gl64_t kB630 = (tmp3_0 + tmp3_2) * (s1_630_0 + s1_630_2);
    gl64_t kC630 = (tmp3_1 + tmp3_2) * (s1_630_1 + s1_630_2);
    gl64_t kD630 = tmp3_0 * s1_630_0;
    gl64_t kE630 = tmp3_1 * s1_630_1;
    gl64_t kF630 = tmp3_2 * s1_630_2;
    gl64_t kG630 = kD630 - kE630;
    tmp3_0 = (kC630 + kG630) - kF630;
    tmp3_1 = ((((kA630 + kC630) - kE630) - kE630) - kD630);
    tmp3_2 = kB630 - kG630;
    // Op 631: dim3x1 sub
    gl64_t s1_631 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_631; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 632: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 633: dim3x3 mul
    gl64_t s1_633_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_633_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_633_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA633 = (tmp3_0 + tmp3_1) * (s1_633_0 + s1_633_1);
    gl64_t kB633 = (tmp3_0 + tmp3_2) * (s1_633_0 + s1_633_2);
    gl64_t kC633 = (tmp3_1 + tmp3_2) * (s1_633_1 + s1_633_2);
    gl64_t kD633 = tmp3_0 * s1_633_0;
    gl64_t kE633 = tmp3_1 * s1_633_1;
    gl64_t kF633 = tmp3_2 * s1_633_2;
    gl64_t kG633 = kD633 - kE633;
    tmp3_6 = (kC633 + kG633) - kF633;
    tmp3_7 = ((((kA633 + kC633) - kE633) - kE633) - kD633);
    tmp3_8 = kB633 - kG633;
    // Op 634: dim3x1 mul
    gl64_t s0_634_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_634_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_634_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_634 = *(gl64_t*)&expressions_params[10][13];
    tmp3_0 = s0_634_0 * s1_634; tmp3_1 = s0_634_1 * s1_634; tmp3_2 = s0_634_2 * s1_634;
    // Op 635: dim3x1 add
    gl64_t s1_635 = *(gl64_t*)&expressions_params[10][12];
    tmp3_0 = tmp3_0 + s1_635; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 636: dim3x3 mul
    gl64_t s1_636_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_636_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_636_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA636 = (tmp3_0 + tmp3_1) * (s1_636_0 + s1_636_1);
    gl64_t kB636 = (tmp3_0 + tmp3_2) * (s1_636_0 + s1_636_2);
    gl64_t kC636 = (tmp3_1 + tmp3_2) * (s1_636_1 + s1_636_2);
    gl64_t kD636 = tmp3_0 * s1_636_0;
    gl64_t kE636 = tmp3_1 * s1_636_1;
    gl64_t kF636 = tmp3_2 * s1_636_2;
    gl64_t kG636 = kD636 - kE636;
    tmp3_0 = (kC636 + kG636) - kF636;
    tmp3_1 = ((((kA636 + kC636) - kE636) - kE636) - kD636);
    tmp3_2 = kB636 - kG636;
    // Op 637: dim3x1 add
    gl64_t s1_637 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_637; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 638: dim3x3 mul
    gl64_t s1_638_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_638_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_638_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA638 = (tmp3_0 + tmp3_1) * (s1_638_0 + s1_638_1);
    gl64_t kB638 = (tmp3_0 + tmp3_2) * (s1_638_0 + s1_638_2);
    gl64_t kC638 = (tmp3_1 + tmp3_2) * (s1_638_1 + s1_638_2);
    gl64_t kD638 = tmp3_0 * s1_638_0;
    gl64_t kE638 = tmp3_1 * s1_638_1;
    gl64_t kF638 = tmp3_2 * s1_638_2;
    gl64_t kG638 = kD638 - kE638;
    tmp3_0 = (kC638 + kG638) - kF638;
    tmp3_1 = ((((kA638 + kC638) - kE638) - kE638) - kD638);
    tmp3_2 = kB638 - kG638;
    // Op 639: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 640: dim3x3 mul
    gl64_t s1_640_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_640_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_640_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA640 = (tmp3_0 + tmp3_1) * (s1_640_0 + s1_640_1);
    gl64_t kB640 = (tmp3_0 + tmp3_2) * (s1_640_0 + s1_640_2);
    gl64_t kC640 = (tmp3_1 + tmp3_2) * (s1_640_1 + s1_640_2);
    gl64_t kD640 = tmp3_0 * s1_640_0;
    gl64_t kE640 = tmp3_1 * s1_640_1;
    gl64_t kF640 = tmp3_2 * s1_640_2;
    gl64_t kG640 = kD640 - kE640;
    tmp3_0 = (kC640 + kG640) - kF640;
    tmp3_1 = ((((kA640 + kC640) - kE640) - kE640) - kD640);
    tmp3_2 = kB640 - kG640;
    // Op 641: dim3x1 add
    gl64_t s1_641 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_641; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 642: dim3x3 mul
    gl64_t s1_642_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_642_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_642_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA642 = (tmp3_0 + tmp3_1) * (s1_642_0 + s1_642_1);
    gl64_t kB642 = (tmp3_0 + tmp3_2) * (s1_642_0 + s1_642_2);
    gl64_t kC642 = (tmp3_1 + tmp3_2) * (s1_642_1 + s1_642_2);
    gl64_t kD642 = tmp3_0 * s1_642_0;
    gl64_t kE642 = tmp3_1 * s1_642_1;
    gl64_t kF642 = tmp3_2 * s1_642_2;
    gl64_t kG642 = kD642 - kE642;
    tmp3_0 = (kC642 + kG642) - kF642;
    tmp3_1 = ((((kA642 + kC642) - kE642) - kE642) - kD642);
    tmp3_2 = kB642 - kG642;
    // Op 643: dim3x1 add
    gl64_t s1_643 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_643; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 644: dim3x3 mul
    gl64_t s1_644_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_644_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_644_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 645: dim3x1 add
    gl64_t s1_645 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_645; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 646: dim3x3 add
    gl64_t s1_646_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_646_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_646_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_646_0; tmp3_1 = tmp3_1 + s1_646_1; tmp3_2 = tmp3_2 + s1_646_2;
    // Op 647: dim3x3 mul
    gl64_t s1_647_0 = *(gl64_t*)&expressions_params[10][131];
    gl64_t s1_647_1 = *(gl64_t*)&expressions_params[10][131+1];
    gl64_t s1_647_2 = *(gl64_t*)&expressions_params[10][131+2];
    gl64_t kA647 = (tmp3_0 + tmp3_1) * (s1_647_0 + s1_647_1);
    gl64_t kB647 = (tmp3_0 + tmp3_2) * (s1_647_0 + s1_647_2);
    gl64_t kC647 = (tmp3_1 + tmp3_2) * (s1_647_1 + s1_647_2);
    gl64_t kD647 = tmp3_0 * s1_647_0;
    gl64_t kE647 = tmp3_1 * s1_647_1;
    gl64_t kF647 = tmp3_2 * s1_647_2;
    gl64_t kG647 = kD647 - kE647;
    tmp3_0 = (kC647 + kG647) - kF647;
    tmp3_1 = ((((kA647 + kC647) - kE647) - kE647) - kD647);
    tmp3_2 = kB647 - kG647;
    // Op 648: dim1x1 sub
    gl64_t s0_648 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_648 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_648 - s1_648;
    // Op 649: dim1x1 sub_swap
    gl64_t s1_649 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_649 - tmp1_0;
    // Op 650: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 651: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 652: dim3x3 mul
    gl64_t s1_652_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_652_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_652_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA652 = (tmp3_0 + tmp3_1) * (s1_652_0 + s1_652_1);
    gl64_t kB652 = (tmp3_0 + tmp3_2) * (s1_652_0 + s1_652_2);
    gl64_t kC652 = (tmp3_1 + tmp3_2) * (s1_652_1 + s1_652_2);
    gl64_t kD652 = tmp3_0 * s1_652_0;
    gl64_t kE652 = tmp3_1 * s1_652_1;
    gl64_t kF652 = tmp3_2 * s1_652_2;
    gl64_t kG652 = kD652 - kE652;
    tmp3_6 = (kC652 + kG652) - kF652;
    tmp3_7 = ((((kA652 + kC652) - kE652) - kE652) - kD652);
    tmp3_8 = kB652 - kG652;
    // Op 653: dim1x1 sub
    gl64_t s1_653 = *(gl64_t*)&expressions_params[10][73];
    tmp1_0 = tmp1_4 - s1_653;
    // Op 654: dim1x1 sub
    gl64_t s1_654 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_654;
    // Op 655: dim3x1 mul
    gl64_t s0_655_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_655_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_655_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_655_0 * tmp1_0; tmp3_1 = s0_655_1 * tmp1_0; tmp3_2 = s0_655_2 * tmp1_0;
    // Op 656: dim3x1 add
    gl64_t s1_656 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_656; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 657: dim3x3 add
    gl64_t s1_657_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_657_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_657_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_657_0; tmp3_1 = tmp3_1 + s1_657_1; tmp3_2 = tmp3_2 + s1_657_2;
    // Op 658: dim3x3 mul
    gl64_t s1_658_0 = *(gl64_t*)&expressions_params[10][134];
    gl64_t s1_658_1 = *(gl64_t*)&expressions_params[10][134+1];
    gl64_t s1_658_2 = *(gl64_t*)&expressions_params[10][134+2];
    gl64_t kA658 = (tmp3_0 + tmp3_1) * (s1_658_0 + s1_658_1);
    gl64_t kB658 = (tmp3_0 + tmp3_2) * (s1_658_0 + s1_658_2);
    gl64_t kC658 = (tmp3_1 + tmp3_2) * (s1_658_1 + s1_658_2);
    gl64_t kD658 = tmp3_0 * s1_658_0;
    gl64_t kE658 = tmp3_1 * s1_658_1;
    gl64_t kF658 = tmp3_2 * s1_658_2;
    gl64_t kG658 = kD658 - kE658;
    tmp3_0 = (kC658 + kG658) - kF658;
    tmp3_1 = ((((kA658 + kC658) - kE658) - kE658) - kD658);
    tmp3_2 = kB658 - kG658;
    // Op 659: dim3x1 add
    gl64_t s1_659 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_659; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 660: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 661: dim3x3 mul
    gl64_t s1_661_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_661_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_661_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA661 = (tmp3_0 + tmp3_1) * (s1_661_0 + s1_661_1);
    gl64_t kB661 = (tmp3_0 + tmp3_2) * (s1_661_0 + s1_661_2);
    gl64_t kC661 = (tmp3_1 + tmp3_2) * (s1_661_1 + s1_661_2);
    gl64_t kD661 = tmp3_0 * s1_661_0;
    gl64_t kE661 = tmp3_1 * s1_661_1;
    gl64_t kF661 = tmp3_2 * s1_661_2;
    gl64_t kG661 = kD661 - kE661;
    tmp3_6 = (kC661 + kG661) - kF661;
    tmp3_7 = ((((kA661 + kC661) - kE661) - kE661) - kD661);
    tmp3_8 = kB661 - kG661;
    // Op 662: dim3x1 mul
    gl64_t s0_662_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_662_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_662_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_662 = *(gl64_t*)&expressions_params[10][15];
    tmp3_0 = s0_662_0 * s1_662; tmp3_1 = s0_662_1 * s1_662; tmp3_2 = s0_662_2 * s1_662;
    // Op 663: dim3x1 add
    gl64_t s1_663 = *(gl64_t*)&expressions_params[10][14];
    tmp3_0 = tmp3_0 + s1_663; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 664: dim3x3 mul
    gl64_t s1_664_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_664_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_664_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA664 = (tmp3_0 + tmp3_1) * (s1_664_0 + s1_664_1);
    gl64_t kB664 = (tmp3_0 + tmp3_2) * (s1_664_0 + s1_664_2);
    gl64_t kC664 = (tmp3_1 + tmp3_2) * (s1_664_1 + s1_664_2);
    gl64_t kD664 = tmp3_0 * s1_664_0;
    gl64_t kE664 = tmp3_1 * s1_664_1;
    gl64_t kF664 = tmp3_2 * s1_664_2;
    gl64_t kG664 = kD664 - kE664;
    tmp3_0 = (kC664 + kG664) - kF664;
    tmp3_1 = ((((kA664 + kC664) - kE664) - kE664) - kD664);
    tmp3_2 = kB664 - kG664;
    // Op 665: dim3x1 add
    gl64_t s1_665 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_665; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 666: dim3x3 mul
    gl64_t s1_666_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_666_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_666_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA666 = (tmp3_0 + tmp3_1) * (s1_666_0 + s1_666_1);
    gl64_t kB666 = (tmp3_0 + tmp3_2) * (s1_666_0 + s1_666_2);
    gl64_t kC666 = (tmp3_1 + tmp3_2) * (s1_666_1 + s1_666_2);
    gl64_t kD666 = tmp3_0 * s1_666_0;
    gl64_t kE666 = tmp3_1 * s1_666_1;
    gl64_t kF666 = tmp3_2 * s1_666_2;
    gl64_t kG666 = kD666 - kE666;
    tmp3_0 = (kC666 + kG666) - kF666;
    tmp3_1 = ((((kA666 + kC666) - kE666) - kE666) - kD666);
    tmp3_2 = kB666 - kG666;
    // Op 667: dim3x1 add
    gl64_t s1_667 = *(gl64_t*)&expressions_params[10][73];
    tmp3_0 = tmp3_0 + s1_667; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 668: dim3x3 mul
    gl64_t s1_668_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_668_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_668_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA668 = (tmp3_0 + tmp3_1) * (s1_668_0 + s1_668_1);
    gl64_t kB668 = (tmp3_0 + tmp3_2) * (s1_668_0 + s1_668_2);
    gl64_t kC668 = (tmp3_1 + tmp3_2) * (s1_668_1 + s1_668_2);
    gl64_t kD668 = tmp3_0 * s1_668_0;
    gl64_t kE668 = tmp3_1 * s1_668_1;
    gl64_t kF668 = tmp3_2 * s1_668_2;
    gl64_t kG668 = kD668 - kE668;
    tmp3_0 = (kC668 + kG668) - kF668;
    tmp3_1 = ((((kA668 + kC668) - kE668) - kE668) - kD668);
    tmp3_2 = kB668 - kG668;
    // Op 669: dim3x1 add
    gl64_t s1_669 = *(gl64_t*)&expressions_params[9][6];
    tmp3_0 = tmp3_0 + s1_669; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 670: dim3x3 mul
    gl64_t s1_670_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_670_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_670_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA670 = (tmp3_0 + tmp3_1) * (s1_670_0 + s1_670_1);
    gl64_t kB670 = (tmp3_0 + tmp3_2) * (s1_670_0 + s1_670_2);
    gl64_t kC670 = (tmp3_1 + tmp3_2) * (s1_670_1 + s1_670_2);
    gl64_t kD670 = tmp3_0 * s1_670_0;
    gl64_t kE670 = tmp3_1 * s1_670_1;
    gl64_t kF670 = tmp3_2 * s1_670_2;
    gl64_t kG670 = kD670 - kE670;
    tmp3_0 = (kC670 + kG670) - kF670;
    tmp3_1 = ((((kA670 + kC670) - kE670) - kE670) - kD670);
    tmp3_2 = kB670 - kG670;
    // Op 671: dim3x1 add
    gl64_t s1_671 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_671; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 672: dim3x3 mul
    gl64_t s1_672_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_672_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_672_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 673: dim3x1 add
    gl64_t s1_673 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_673; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 674: dim3x3 add
    gl64_t s1_674_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_674_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_674_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_674_0; tmp3_1 = tmp3_1 + s1_674_1; tmp3_2 = tmp3_2 + s1_674_2;
    // Op 675: dim3x3 mul
    gl64_t s1_675_0 = *(gl64_t*)&expressions_params[10][137];
    gl64_t s1_675_1 = *(gl64_t*)&expressions_params[10][137+1];
    gl64_t s1_675_2 = *(gl64_t*)&expressions_params[10][137+2];
    gl64_t kA675 = (tmp3_0 + tmp3_1) * (s1_675_0 + s1_675_1);
    gl64_t kB675 = (tmp3_0 + tmp3_2) * (s1_675_0 + s1_675_2);
    gl64_t kC675 = (tmp3_1 + tmp3_2) * (s1_675_1 + s1_675_2);
    gl64_t kD675 = tmp3_0 * s1_675_0;
    gl64_t kE675 = tmp3_1 * s1_675_1;
    gl64_t kF675 = tmp3_2 * s1_675_2;
    gl64_t kG675 = kD675 - kE675;
    tmp3_0 = (kC675 + kG675) - kF675;
    tmp3_1 = ((((kA675 + kC675) - kE675) - kE675) - kD675);
    tmp3_2 = kB675 - kG675;
    // Op 676: dim3x1 sub
    gl64_t s1_676 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_676; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 677: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 678: dim3x3 mul
    gl64_t s1_678_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_678_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_678_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA678 = (tmp3_0 + tmp3_1) * (s1_678_0 + s1_678_1);
    gl64_t kB678 = (tmp3_0 + tmp3_2) * (s1_678_0 + s1_678_2);
    gl64_t kC678 = (tmp3_1 + tmp3_2) * (s1_678_1 + s1_678_2);
    gl64_t kD678 = tmp3_0 * s1_678_0;
    gl64_t kE678 = tmp3_1 * s1_678_1;
    gl64_t kF678 = tmp3_2 * s1_678_2;
    gl64_t kG678 = kD678 - kE678;
    tmp3_6 = (kC678 + kG678) - kF678;
    tmp3_7 = ((((kA678 + kC678) - kE678) - kE678) - kD678);
    tmp3_8 = kB678 - kG678;
    // Op 679: dim3x1 mul
    gl64_t s0_679_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_679_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_679_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_679 = *(gl64_t*)&expressions_params[10][15];
    tmp3_0 = s0_679_0 * s1_679; tmp3_1 = s0_679_1 * s1_679; tmp3_2 = s0_679_2 * s1_679;
    // Op 680: dim3x1 add
    gl64_t s1_680 = *(gl64_t*)&expressions_params[10][14];
    tmp3_0 = tmp3_0 + s1_680; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 681: dim3x3 mul
    gl64_t s1_681_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_681_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_681_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA681 = (tmp3_0 + tmp3_1) * (s1_681_0 + s1_681_1);
    gl64_t kB681 = (tmp3_0 + tmp3_2) * (s1_681_0 + s1_681_2);
    gl64_t kC681 = (tmp3_1 + tmp3_2) * (s1_681_1 + s1_681_2);
    gl64_t kD681 = tmp3_0 * s1_681_0;
    gl64_t kE681 = tmp3_1 * s1_681_1;
    gl64_t kF681 = tmp3_2 * s1_681_2;
    gl64_t kG681 = kD681 - kE681;
    tmp3_0 = (kC681 + kG681) - kF681;
    tmp3_1 = ((((kA681 + kC681) - kE681) - kE681) - kD681);
    tmp3_2 = kB681 - kG681;
    // Op 682: dim3x1 add
    gl64_t s1_682 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_682; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 683: dim3x3 mul
    gl64_t s1_683_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_683_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_683_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA683 = (tmp3_0 + tmp3_1) * (s1_683_0 + s1_683_1);
    gl64_t kB683 = (tmp3_0 + tmp3_2) * (s1_683_0 + s1_683_2);
    gl64_t kC683 = (tmp3_1 + tmp3_2) * (s1_683_1 + s1_683_2);
    gl64_t kD683 = tmp3_0 * s1_683_0;
    gl64_t kE683 = tmp3_1 * s1_683_1;
    gl64_t kF683 = tmp3_2 * s1_683_2;
    gl64_t kG683 = kD683 - kE683;
    tmp3_0 = (kC683 + kG683) - kF683;
    tmp3_1 = ((((kA683 + kC683) - kE683) - kE683) - kD683);
    tmp3_2 = kB683 - kG683;
    // Op 684: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 685: dim3x3 mul
    gl64_t s1_685_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_685_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_685_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA685 = (tmp3_0 + tmp3_1) * (s1_685_0 + s1_685_1);
    gl64_t kB685 = (tmp3_0 + tmp3_2) * (s1_685_0 + s1_685_2);
    gl64_t kC685 = (tmp3_1 + tmp3_2) * (s1_685_1 + s1_685_2);
    gl64_t kD685 = tmp3_0 * s1_685_0;
    gl64_t kE685 = tmp3_1 * s1_685_1;
    gl64_t kF685 = tmp3_2 * s1_685_2;
    gl64_t kG685 = kD685 - kE685;
    tmp3_0 = (kC685 + kG685) - kF685;
    tmp3_1 = ((((kA685 + kC685) - kE685) - kE685) - kD685);
    tmp3_2 = kB685 - kG685;
    // Op 686: dim3x1 add
    gl64_t s1_686 = *(gl64_t*)&expressions_params[9][6];
    tmp3_0 = tmp3_0 + s1_686; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 687: dim3x3 mul
    gl64_t s1_687_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_687_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_687_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA687 = (tmp3_0 + tmp3_1) * (s1_687_0 + s1_687_1);
    gl64_t kB687 = (tmp3_0 + tmp3_2) * (s1_687_0 + s1_687_2);
    gl64_t kC687 = (tmp3_1 + tmp3_2) * (s1_687_1 + s1_687_2);
    gl64_t kD687 = tmp3_0 * s1_687_0;
    gl64_t kE687 = tmp3_1 * s1_687_1;
    gl64_t kF687 = tmp3_2 * s1_687_2;
    gl64_t kG687 = kD687 - kE687;
    tmp3_0 = (kC687 + kG687) - kF687;
    tmp3_1 = ((((kA687 + kC687) - kE687) - kE687) - kD687);
    tmp3_2 = kB687 - kG687;
    // Op 688: dim3x1 add
    gl64_t s1_688 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_688; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 689: dim3x3 mul
    gl64_t s1_689_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_689_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_689_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 690: dim3x1 add
    gl64_t s1_690 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_690; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 691: dim3x3 add
    gl64_t s1_691_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_691_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_691_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_691_0; tmp3_1 = tmp3_1 + s1_691_1; tmp3_2 = tmp3_2 + s1_691_2;
    // Op 692: dim3x3 mul
    gl64_t s1_692_0 = *(gl64_t*)&expressions_params[10][140];
    gl64_t s1_692_1 = *(gl64_t*)&expressions_params[10][140+1];
    gl64_t s1_692_2 = *(gl64_t*)&expressions_params[10][140+2];
    gl64_t kA692 = (tmp3_0 + tmp3_1) * (s1_692_0 + s1_692_1);
    gl64_t kB692 = (tmp3_0 + tmp3_2) * (s1_692_0 + s1_692_2);
    gl64_t kC692 = (tmp3_1 + tmp3_2) * (s1_692_1 + s1_692_2);
    gl64_t kD692 = tmp3_0 * s1_692_0;
    gl64_t kE692 = tmp3_1 * s1_692_1;
    gl64_t kF692 = tmp3_2 * s1_692_2;
    gl64_t kG692 = kD692 - kE692;
    tmp3_0 = (kC692 + kG692) - kF692;
    tmp3_1 = ((((kA692 + kC692) - kE692) - kE692) - kD692);
    tmp3_2 = kB692 - kG692;
    // Op 693: dim1x1 sub
    gl64_t s0_693 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_693 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_693 - s1_693;
    // Op 694: dim1x1 sub_swap
    gl64_t s1_694 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_694 - tmp1_0;
    // Op 695: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 696: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 697: dim3x3 mul
    gl64_t s1_697_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_697_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_697_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA697 = (tmp3_0 + tmp3_1) * (s1_697_0 + s1_697_1);
    gl64_t kB697 = (tmp3_0 + tmp3_2) * (s1_697_0 + s1_697_2);
    gl64_t kC697 = (tmp3_1 + tmp3_2) * (s1_697_1 + s1_697_2);
    gl64_t kD697 = tmp3_0 * s1_697_0;
    gl64_t kE697 = tmp3_1 * s1_697_1;
    gl64_t kF697 = tmp3_2 * s1_697_2;
    gl64_t kG697 = kD697 - kE697;
    tmp3_6 = (kC697 + kG697) - kF697;
    tmp3_7 = ((((kA697 + kC697) - kE697) - kE697) - kD697);
    tmp3_8 = kB697 - kG697;
    // Op 698: dim1x1 sub
    gl64_t s1_698 = *(gl64_t*)&expressions_params[10][74];
    tmp1_0 = tmp1_4 - s1_698;
    // Op 699: dim1x1 sub
    gl64_t s1_699 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_699;
    // Op 700: dim3x1 mul
    gl64_t s0_700_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_700_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_700_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_700_0 * tmp1_0; tmp3_1 = s0_700_1 * tmp1_0; tmp3_2 = s0_700_2 * tmp1_0;
    // Op 701: dim3x1 add
    gl64_t s1_701 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_701; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 702: dim3x3 add
    gl64_t s1_702_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_702_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_702_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_702_0; tmp3_1 = tmp3_1 + s1_702_1; tmp3_2 = tmp3_2 + s1_702_2;
    // Op 703: dim3x3 mul
    gl64_t s1_703_0 = *(gl64_t*)&expressions_params[10][143];
    gl64_t s1_703_1 = *(gl64_t*)&expressions_params[10][143+1];
    gl64_t s1_703_2 = *(gl64_t*)&expressions_params[10][143+2];
    gl64_t kA703 = (tmp3_0 + tmp3_1) * (s1_703_0 + s1_703_1);
    gl64_t kB703 = (tmp3_0 + tmp3_2) * (s1_703_0 + s1_703_2);
    gl64_t kC703 = (tmp3_1 + tmp3_2) * (s1_703_1 + s1_703_2);
    gl64_t kD703 = tmp3_0 * s1_703_0;
    gl64_t kE703 = tmp3_1 * s1_703_1;
    gl64_t kF703 = tmp3_2 * s1_703_2;
    gl64_t kG703 = kD703 - kE703;
    tmp3_0 = (kC703 + kG703) - kF703;
    tmp3_1 = ((((kA703 + kC703) - kE703) - kE703) - kD703);
    tmp3_2 = kB703 - kG703;
    // Op 704: dim3x1 add
    gl64_t s1_704 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_704; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 705: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 706: dim3x3 mul
    gl64_t s1_706_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_706_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_706_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA706 = (tmp3_0 + tmp3_1) * (s1_706_0 + s1_706_1);
    gl64_t kB706 = (tmp3_0 + tmp3_2) * (s1_706_0 + s1_706_2);
    gl64_t kC706 = (tmp3_1 + tmp3_2) * (s1_706_1 + s1_706_2);
    gl64_t kD706 = tmp3_0 * s1_706_0;
    gl64_t kE706 = tmp3_1 * s1_706_1;
    gl64_t kF706 = tmp3_2 * s1_706_2;
    gl64_t kG706 = kD706 - kE706;
    tmp3_6 = (kC706 + kG706) - kF706;
    tmp3_7 = ((((kA706 + kC706) - kE706) - kE706) - kD706);
    tmp3_8 = kB706 - kG706;
    // Op 707: dim3x1 mul
    gl64_t s0_707_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_707_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_707_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_707 = *(gl64_t*)&expressions_params[10][17];
    tmp3_0 = s0_707_0 * s1_707; tmp3_1 = s0_707_1 * s1_707; tmp3_2 = s0_707_2 * s1_707;
    // Op 708: dim3x1 add
    gl64_t s1_708 = *(gl64_t*)&expressions_params[10][16];
    tmp3_0 = tmp3_0 + s1_708; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 709: dim3x3 mul
    gl64_t s1_709_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_709_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_709_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA709 = (tmp3_0 + tmp3_1) * (s1_709_0 + s1_709_1);
    gl64_t kB709 = (tmp3_0 + tmp3_2) * (s1_709_0 + s1_709_2);
    gl64_t kC709 = (tmp3_1 + tmp3_2) * (s1_709_1 + s1_709_2);
    gl64_t kD709 = tmp3_0 * s1_709_0;
    gl64_t kE709 = tmp3_1 * s1_709_1;
    gl64_t kF709 = tmp3_2 * s1_709_2;
    gl64_t kG709 = kD709 - kE709;
    tmp3_0 = (kC709 + kG709) - kF709;
    tmp3_1 = ((((kA709 + kC709) - kE709) - kE709) - kD709);
    tmp3_2 = kB709 - kG709;
    // Op 710: dim3x1 add
    gl64_t s1_710 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_710; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 711: dim3x3 mul
    gl64_t s1_711_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_711_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_711_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA711 = (tmp3_0 + tmp3_1) * (s1_711_0 + s1_711_1);
    gl64_t kB711 = (tmp3_0 + tmp3_2) * (s1_711_0 + s1_711_2);
    gl64_t kC711 = (tmp3_1 + tmp3_2) * (s1_711_1 + s1_711_2);
    gl64_t kD711 = tmp3_0 * s1_711_0;
    gl64_t kE711 = tmp3_1 * s1_711_1;
    gl64_t kF711 = tmp3_2 * s1_711_2;
    gl64_t kG711 = kD711 - kE711;
    tmp3_0 = (kC711 + kG711) - kF711;
    tmp3_1 = ((((kA711 + kC711) - kE711) - kE711) - kD711);
    tmp3_2 = kB711 - kG711;
    // Op 712: dim3x1 add
    gl64_t s1_712 = *(gl64_t*)&expressions_params[10][74];
    tmp3_0 = tmp3_0 + s1_712; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 713: dim3x3 mul
    gl64_t s1_713_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_713_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_713_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA713 = (tmp3_0 + tmp3_1) * (s1_713_0 + s1_713_1);
    gl64_t kB713 = (tmp3_0 + tmp3_2) * (s1_713_0 + s1_713_2);
    gl64_t kC713 = (tmp3_1 + tmp3_2) * (s1_713_1 + s1_713_2);
    gl64_t kD713 = tmp3_0 * s1_713_0;
    gl64_t kE713 = tmp3_1 * s1_713_1;
    gl64_t kF713 = tmp3_2 * s1_713_2;
    gl64_t kG713 = kD713 - kE713;
    tmp3_0 = (kC713 + kG713) - kF713;
    tmp3_1 = ((((kA713 + kC713) - kE713) - kE713) - kD713);
    tmp3_2 = kB713 - kG713;
    // Op 714: dim3x1 add
    gl64_t s1_714 = *(gl64_t*)&expressions_params[9][24];
    tmp3_0 = tmp3_0 + s1_714; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 715: dim3x3 mul
    gl64_t s1_715_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_715_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_715_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA715 = (tmp3_0 + tmp3_1) * (s1_715_0 + s1_715_1);
    gl64_t kB715 = (tmp3_0 + tmp3_2) * (s1_715_0 + s1_715_2);
    gl64_t kC715 = (tmp3_1 + tmp3_2) * (s1_715_1 + s1_715_2);
    gl64_t kD715 = tmp3_0 * s1_715_0;
    gl64_t kE715 = tmp3_1 * s1_715_1;
    gl64_t kF715 = tmp3_2 * s1_715_2;
    gl64_t kG715 = kD715 - kE715;
    tmp3_0 = (kC715 + kG715) - kF715;
    tmp3_1 = ((((kA715 + kC715) - kE715) - kE715) - kD715);
    tmp3_2 = kB715 - kG715;
    // Op 716: dim3x1 add
    gl64_t s1_716 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_716; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 717: dim3x3 mul
    gl64_t s1_717_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_717_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_717_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 718: dim3x1 add
    gl64_t s1_718 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_718; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 719: dim3x3 add
    gl64_t s1_719_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_719_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_719_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_719_0; tmp3_1 = tmp3_1 + s1_719_1; tmp3_2 = tmp3_2 + s1_719_2;
    // Op 720: dim3x3 mul
    gl64_t s1_720_0 = *(gl64_t*)&expressions_params[10][146];
    gl64_t s1_720_1 = *(gl64_t*)&expressions_params[10][146+1];
    gl64_t s1_720_2 = *(gl64_t*)&expressions_params[10][146+2];
    gl64_t kA720 = (tmp3_0 + tmp3_1) * (s1_720_0 + s1_720_1);
    gl64_t kB720 = (tmp3_0 + tmp3_2) * (s1_720_0 + s1_720_2);
    gl64_t kC720 = (tmp3_1 + tmp3_2) * (s1_720_1 + s1_720_2);
    gl64_t kD720 = tmp3_0 * s1_720_0;
    gl64_t kE720 = tmp3_1 * s1_720_1;
    gl64_t kF720 = tmp3_2 * s1_720_2;
    gl64_t kG720 = kD720 - kE720;
    tmp3_0 = (kC720 + kG720) - kF720;
    tmp3_1 = ((((kA720 + kC720) - kE720) - kE720) - kD720);
    tmp3_2 = kB720 - kG720;
    // Op 721: dim3x1 sub
    gl64_t s1_721 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_721; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 722: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 723: dim3x3 mul
    gl64_t s1_723_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_723_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_723_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA723 = (tmp3_0 + tmp3_1) * (s1_723_0 + s1_723_1);
    gl64_t kB723 = (tmp3_0 + tmp3_2) * (s1_723_0 + s1_723_2);
    gl64_t kC723 = (tmp3_1 + tmp3_2) * (s1_723_1 + s1_723_2);
    gl64_t kD723 = tmp3_0 * s1_723_0;
    gl64_t kE723 = tmp3_1 * s1_723_1;
    gl64_t kF723 = tmp3_2 * s1_723_2;
    gl64_t kG723 = kD723 - kE723;
    tmp3_6 = (kC723 + kG723) - kF723;
    tmp3_7 = ((((kA723 + kC723) - kE723) - kE723) - kD723);
    tmp3_8 = kB723 - kG723;
    // Op 724: dim3x1 mul
    gl64_t s0_724_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_724_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_724_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_724 = *(gl64_t*)&expressions_params[10][17];
    tmp3_0 = s0_724_0 * s1_724; tmp3_1 = s0_724_1 * s1_724; tmp3_2 = s0_724_2 * s1_724;
    // Op 725: dim3x1 add
    gl64_t s1_725 = *(gl64_t*)&expressions_params[10][16];
    tmp3_0 = tmp3_0 + s1_725; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 726: dim3x3 mul
    gl64_t s1_726_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_726_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_726_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA726 = (tmp3_0 + tmp3_1) * (s1_726_0 + s1_726_1);
    gl64_t kB726 = (tmp3_0 + tmp3_2) * (s1_726_0 + s1_726_2);
    gl64_t kC726 = (tmp3_1 + tmp3_2) * (s1_726_1 + s1_726_2);
    gl64_t kD726 = tmp3_0 * s1_726_0;
    gl64_t kE726 = tmp3_1 * s1_726_1;
    gl64_t kF726 = tmp3_2 * s1_726_2;
    gl64_t kG726 = kD726 - kE726;
    tmp3_0 = (kC726 + kG726) - kF726;
    tmp3_1 = ((((kA726 + kC726) - kE726) - kE726) - kD726);
    tmp3_2 = kB726 - kG726;
    // Op 727: dim3x1 add
    gl64_t s1_727 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_727; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 728: dim3x3 mul
    gl64_t s1_728_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_728_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_728_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA728 = (tmp3_0 + tmp3_1) * (s1_728_0 + s1_728_1);
    gl64_t kB728 = (tmp3_0 + tmp3_2) * (s1_728_0 + s1_728_2);
    gl64_t kC728 = (tmp3_1 + tmp3_2) * (s1_728_1 + s1_728_2);
    gl64_t kD728 = tmp3_0 * s1_728_0;
    gl64_t kE728 = tmp3_1 * s1_728_1;
    gl64_t kF728 = tmp3_2 * s1_728_2;
    gl64_t kG728 = kD728 - kE728;
    tmp3_0 = (kC728 + kG728) - kF728;
    tmp3_1 = ((((kA728 + kC728) - kE728) - kE728) - kD728);
    tmp3_2 = kB728 - kG728;
    // Op 729: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 730: dim3x3 mul
    gl64_t s1_730_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_730_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_730_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA730 = (tmp3_0 + tmp3_1) * (s1_730_0 + s1_730_1);
    gl64_t kB730 = (tmp3_0 + tmp3_2) * (s1_730_0 + s1_730_2);
    gl64_t kC730 = (tmp3_1 + tmp3_2) * (s1_730_1 + s1_730_2);
    gl64_t kD730 = tmp3_0 * s1_730_0;
    gl64_t kE730 = tmp3_1 * s1_730_1;
    gl64_t kF730 = tmp3_2 * s1_730_2;
    gl64_t kG730 = kD730 - kE730;
    tmp3_0 = (kC730 + kG730) - kF730;
    tmp3_1 = ((((kA730 + kC730) - kE730) - kE730) - kD730);
    tmp3_2 = kB730 - kG730;
    // Op 731: dim3x1 add
    gl64_t s1_731 = *(gl64_t*)&expressions_params[9][24];
    tmp3_0 = tmp3_0 + s1_731; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 732: dim3x3 mul
    gl64_t s1_732_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_732_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_732_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA732 = (tmp3_0 + tmp3_1) * (s1_732_0 + s1_732_1);
    gl64_t kB732 = (tmp3_0 + tmp3_2) * (s1_732_0 + s1_732_2);
    gl64_t kC732 = (tmp3_1 + tmp3_2) * (s1_732_1 + s1_732_2);
    gl64_t kD732 = tmp3_0 * s1_732_0;
    gl64_t kE732 = tmp3_1 * s1_732_1;
    gl64_t kF732 = tmp3_2 * s1_732_2;
    gl64_t kG732 = kD732 - kE732;
    tmp3_0 = (kC732 + kG732) - kF732;
    tmp3_1 = ((((kA732 + kC732) - kE732) - kE732) - kD732);
    tmp3_2 = kB732 - kG732;
    // Op 733: dim3x1 add
    gl64_t s1_733 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_733; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 734: dim3x3 mul
    gl64_t s1_734_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_734_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_734_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 735: dim3x1 add
    gl64_t s1_735 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_735; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 736: dim3x3 add
    gl64_t s1_736_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_736_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_736_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_736_0; tmp3_1 = tmp3_1 + s1_736_1; tmp3_2 = tmp3_2 + s1_736_2;
    // Op 737: dim3x3 mul
    gl64_t s1_737_0 = *(gl64_t*)&expressions_params[10][149];
    gl64_t s1_737_1 = *(gl64_t*)&expressions_params[10][149+1];
    gl64_t s1_737_2 = *(gl64_t*)&expressions_params[10][149+2];
    gl64_t kA737 = (tmp3_0 + tmp3_1) * (s1_737_0 + s1_737_1);
    gl64_t kB737 = (tmp3_0 + tmp3_2) * (s1_737_0 + s1_737_2);
    gl64_t kC737 = (tmp3_1 + tmp3_2) * (s1_737_1 + s1_737_2);
    gl64_t kD737 = tmp3_0 * s1_737_0;
    gl64_t kE737 = tmp3_1 * s1_737_1;
    gl64_t kF737 = tmp3_2 * s1_737_2;
    gl64_t kG737 = kD737 - kE737;
    tmp3_0 = (kC737 + kG737) - kF737;
    tmp3_1 = ((((kA737 + kC737) - kE737) - kE737) - kD737);
    tmp3_2 = kB737 - kG737;
    // Op 738: dim1x1 sub
    gl64_t s0_738 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_738 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_738 - s1_738;
    // Op 739: dim1x1 sub_swap
    gl64_t s1_739 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_739 - tmp1_0;
    // Op 740: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 741: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 742: dim3x3 mul
    gl64_t s1_742_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_742_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_742_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA742 = (tmp3_0 + tmp3_1) * (s1_742_0 + s1_742_1);
    gl64_t kB742 = (tmp3_0 + tmp3_2) * (s1_742_0 + s1_742_2);
    gl64_t kC742 = (tmp3_1 + tmp3_2) * (s1_742_1 + s1_742_2);
    gl64_t kD742 = tmp3_0 * s1_742_0;
    gl64_t kE742 = tmp3_1 * s1_742_1;
    gl64_t kF742 = tmp3_2 * s1_742_2;
    gl64_t kG742 = kD742 - kE742;
    tmp3_6 = (kC742 + kG742) - kF742;
    tmp3_7 = ((((kA742 + kC742) - kE742) - kE742) - kD742);
    tmp3_8 = kB742 - kG742;
    // Op 743: dim1x1 sub
    gl64_t s1_743 = *(gl64_t*)&expressions_params[10][75];
    tmp1_0 = tmp1_4 - s1_743;
    // Op 744: dim1x1 sub
    gl64_t s1_744 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_744;
    // Op 745: dim3x1 mul
    gl64_t s0_745_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_745_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_745_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_745_0 * tmp1_0; tmp3_1 = s0_745_1 * tmp1_0; tmp3_2 = s0_745_2 * tmp1_0;
    // Op 746: dim3x1 add
    gl64_t s1_746 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_746; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 747: dim3x3 add
    gl64_t s1_747_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_747_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_747_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_747_0; tmp3_1 = tmp3_1 + s1_747_1; tmp3_2 = tmp3_2 + s1_747_2;
    // Op 748: dim3x3 mul
    gl64_t s1_748_0 = *(gl64_t*)&expressions_params[10][152];
    gl64_t s1_748_1 = *(gl64_t*)&expressions_params[10][152+1];
    gl64_t s1_748_2 = *(gl64_t*)&expressions_params[10][152+2];
    gl64_t kA748 = (tmp3_0 + tmp3_1) * (s1_748_0 + s1_748_1);
    gl64_t kB748 = (tmp3_0 + tmp3_2) * (s1_748_0 + s1_748_2);
    gl64_t kC748 = (tmp3_1 + tmp3_2) * (s1_748_1 + s1_748_2);
    gl64_t kD748 = tmp3_0 * s1_748_0;
    gl64_t kE748 = tmp3_1 * s1_748_1;
    gl64_t kF748 = tmp3_2 * s1_748_2;
    gl64_t kG748 = kD748 - kE748;
    tmp3_0 = (kC748 + kG748) - kF748;
    tmp3_1 = ((((kA748 + kC748) - kE748) - kE748) - kD748);
    tmp3_2 = kB748 - kG748;
    // Op 749: dim3x1 add
    gl64_t s1_749 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_749; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 750: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 751: dim3x3 mul
    gl64_t s1_751_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_751_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_751_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA751 = (tmp3_0 + tmp3_1) * (s1_751_0 + s1_751_1);
    gl64_t kB751 = (tmp3_0 + tmp3_2) * (s1_751_0 + s1_751_2);
    gl64_t kC751 = (tmp3_1 + tmp3_2) * (s1_751_1 + s1_751_2);
    gl64_t kD751 = tmp3_0 * s1_751_0;
    gl64_t kE751 = tmp3_1 * s1_751_1;
    gl64_t kF751 = tmp3_2 * s1_751_2;
    gl64_t kG751 = kD751 - kE751;
    tmp3_6 = (kC751 + kG751) - kF751;
    tmp3_7 = ((((kA751 + kC751) - kE751) - kE751) - kD751);
    tmp3_8 = kB751 - kG751;
    // Op 752: dim3x1 mul
    gl64_t s0_752_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_752_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_752_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_752 = *(gl64_t*)&expressions_params[10][19];
    tmp3_0 = s0_752_0 * s1_752; tmp3_1 = s0_752_1 * s1_752; tmp3_2 = s0_752_2 * s1_752;
    // Op 753: dim3x1 add
    gl64_t s1_753 = *(gl64_t*)&expressions_params[10][18];
    tmp3_0 = tmp3_0 + s1_753; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 754: dim3x3 mul
    gl64_t s1_754_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_754_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_754_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA754 = (tmp3_0 + tmp3_1) * (s1_754_0 + s1_754_1);
    gl64_t kB754 = (tmp3_0 + tmp3_2) * (s1_754_0 + s1_754_2);
    gl64_t kC754 = (tmp3_1 + tmp3_2) * (s1_754_1 + s1_754_2);
    gl64_t kD754 = tmp3_0 * s1_754_0;
    gl64_t kE754 = tmp3_1 * s1_754_1;
    gl64_t kF754 = tmp3_2 * s1_754_2;
    gl64_t kG754 = kD754 - kE754;
    tmp3_0 = (kC754 + kG754) - kF754;
    tmp3_1 = ((((kA754 + kC754) - kE754) - kE754) - kD754);
    tmp3_2 = kB754 - kG754;
    // Op 755: dim3x1 add
    gl64_t s1_755 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_755; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 756: dim3x3 mul
    gl64_t s1_756_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_756_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_756_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA756 = (tmp3_0 + tmp3_1) * (s1_756_0 + s1_756_1);
    gl64_t kB756 = (tmp3_0 + tmp3_2) * (s1_756_0 + s1_756_2);
    gl64_t kC756 = (tmp3_1 + tmp3_2) * (s1_756_1 + s1_756_2);
    gl64_t kD756 = tmp3_0 * s1_756_0;
    gl64_t kE756 = tmp3_1 * s1_756_1;
    gl64_t kF756 = tmp3_2 * s1_756_2;
    gl64_t kG756 = kD756 - kE756;
    tmp3_0 = (kC756 + kG756) - kF756;
    tmp3_1 = ((((kA756 + kC756) - kE756) - kE756) - kD756);
    tmp3_2 = kB756 - kG756;
    // Op 757: dim3x1 add
    gl64_t s1_757 = *(gl64_t*)&expressions_params[10][75];
    tmp3_0 = tmp3_0 + s1_757; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 758: dim3x3 mul
    gl64_t s1_758_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_758_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_758_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA758 = (tmp3_0 + tmp3_1) * (s1_758_0 + s1_758_1);
    gl64_t kB758 = (tmp3_0 + tmp3_2) * (s1_758_0 + s1_758_2);
    gl64_t kC758 = (tmp3_1 + tmp3_2) * (s1_758_1 + s1_758_2);
    gl64_t kD758 = tmp3_0 * s1_758_0;
    gl64_t kE758 = tmp3_1 * s1_758_1;
    gl64_t kF758 = tmp3_2 * s1_758_2;
    gl64_t kG758 = kD758 - kE758;
    tmp3_0 = (kC758 + kG758) - kF758;
    tmp3_1 = ((((kA758 + kC758) - kE758) - kE758) - kD758);
    tmp3_2 = kB758 - kG758;
    // Op 759: dim3x1 add
    gl64_t s1_759 = *(gl64_t*)&expressions_params[9][25];
    tmp3_0 = tmp3_0 + s1_759; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 760: dim3x3 mul
    gl64_t s1_760_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_760_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_760_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA760 = (tmp3_0 + tmp3_1) * (s1_760_0 + s1_760_1);
    gl64_t kB760 = (tmp3_0 + tmp3_2) * (s1_760_0 + s1_760_2);
    gl64_t kC760 = (tmp3_1 + tmp3_2) * (s1_760_1 + s1_760_2);
    gl64_t kD760 = tmp3_0 * s1_760_0;
    gl64_t kE760 = tmp3_1 * s1_760_1;
    gl64_t kF760 = tmp3_2 * s1_760_2;
    gl64_t kG760 = kD760 - kE760;
    tmp3_0 = (kC760 + kG760) - kF760;
    tmp3_1 = ((((kA760 + kC760) - kE760) - kE760) - kD760);
    tmp3_2 = kB760 - kG760;
    // Op 761: dim3x1 add
    gl64_t s1_761 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_761; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 762: dim3x3 mul
    gl64_t s1_762_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_762_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_762_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 763: dim3x1 add
    gl64_t s1_763 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_763; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 764: dim3x3 add
    gl64_t s1_764_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_764_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_764_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_764_0; tmp3_1 = tmp3_1 + s1_764_1; tmp3_2 = tmp3_2 + s1_764_2;
    // Op 765: dim3x3 mul
    gl64_t s1_765_0 = *(gl64_t*)&expressions_params[10][155];
    gl64_t s1_765_1 = *(gl64_t*)&expressions_params[10][155+1];
    gl64_t s1_765_2 = *(gl64_t*)&expressions_params[10][155+2];
    gl64_t kA765 = (tmp3_0 + tmp3_1) * (s1_765_0 + s1_765_1);
    gl64_t kB765 = (tmp3_0 + tmp3_2) * (s1_765_0 + s1_765_2);
    gl64_t kC765 = (tmp3_1 + tmp3_2) * (s1_765_1 + s1_765_2);
    gl64_t kD765 = tmp3_0 * s1_765_0;
    gl64_t kE765 = tmp3_1 * s1_765_1;
    gl64_t kF765 = tmp3_2 * s1_765_2;
    gl64_t kG765 = kD765 - kE765;
    tmp3_0 = (kC765 + kG765) - kF765;
    tmp3_1 = ((((kA765 + kC765) - kE765) - kE765) - kD765);
    tmp3_2 = kB765 - kG765;
    // Op 766: dim3x1 sub
    gl64_t s1_766 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_766; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 767: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 768: dim3x3 mul
    gl64_t s1_768_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_768_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_768_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA768 = (tmp3_0 + tmp3_1) * (s1_768_0 + s1_768_1);
    gl64_t kB768 = (tmp3_0 + tmp3_2) * (s1_768_0 + s1_768_2);
    gl64_t kC768 = (tmp3_1 + tmp3_2) * (s1_768_1 + s1_768_2);
    gl64_t kD768 = tmp3_0 * s1_768_0;
    gl64_t kE768 = tmp3_1 * s1_768_1;
    gl64_t kF768 = tmp3_2 * s1_768_2;
    gl64_t kG768 = kD768 - kE768;
    tmp3_6 = (kC768 + kG768) - kF768;
    tmp3_7 = ((((kA768 + kC768) - kE768) - kE768) - kD768);
    tmp3_8 = kB768 - kG768;
    // Op 769: dim3x1 mul
    gl64_t s0_769_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_769_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_769_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_769 = *(gl64_t*)&expressions_params[10][19];
    tmp3_0 = s0_769_0 * s1_769; tmp3_1 = s0_769_1 * s1_769; tmp3_2 = s0_769_2 * s1_769;
    // Op 770: dim3x1 add
    gl64_t s1_770 = *(gl64_t*)&expressions_params[10][18];
    tmp3_0 = tmp3_0 + s1_770; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 771: dim3x3 mul
    gl64_t s1_771_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_771_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_771_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA771 = (tmp3_0 + tmp3_1) * (s1_771_0 + s1_771_1);
    gl64_t kB771 = (tmp3_0 + tmp3_2) * (s1_771_0 + s1_771_2);
    gl64_t kC771 = (tmp3_1 + tmp3_2) * (s1_771_1 + s1_771_2);
    gl64_t kD771 = tmp3_0 * s1_771_0;
    gl64_t kE771 = tmp3_1 * s1_771_1;
    gl64_t kF771 = tmp3_2 * s1_771_2;
    gl64_t kG771 = kD771 - kE771;
    tmp3_0 = (kC771 + kG771) - kF771;
    tmp3_1 = ((((kA771 + kC771) - kE771) - kE771) - kD771);
    tmp3_2 = kB771 - kG771;
    // Op 772: dim3x1 add
    gl64_t s1_772 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_772; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 773: dim3x3 mul
    gl64_t s1_773_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_773_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_773_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA773 = (tmp3_0 + tmp3_1) * (s1_773_0 + s1_773_1);
    gl64_t kB773 = (tmp3_0 + tmp3_2) * (s1_773_0 + s1_773_2);
    gl64_t kC773 = (tmp3_1 + tmp3_2) * (s1_773_1 + s1_773_2);
    gl64_t kD773 = tmp3_0 * s1_773_0;
    gl64_t kE773 = tmp3_1 * s1_773_1;
    gl64_t kF773 = tmp3_2 * s1_773_2;
    gl64_t kG773 = kD773 - kE773;
    tmp3_0 = (kC773 + kG773) - kF773;
    tmp3_1 = ((((kA773 + kC773) - kE773) - kE773) - kD773);
    tmp3_2 = kB773 - kG773;
    // Op 774: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 775: dim3x3 mul
    gl64_t s1_775_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_775_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_775_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA775 = (tmp3_0 + tmp3_1) * (s1_775_0 + s1_775_1);
    gl64_t kB775 = (tmp3_0 + tmp3_2) * (s1_775_0 + s1_775_2);
    gl64_t kC775 = (tmp3_1 + tmp3_2) * (s1_775_1 + s1_775_2);
    gl64_t kD775 = tmp3_0 * s1_775_0;
    gl64_t kE775 = tmp3_1 * s1_775_1;
    gl64_t kF775 = tmp3_2 * s1_775_2;
    gl64_t kG775 = kD775 - kE775;
    tmp3_0 = (kC775 + kG775) - kF775;
    tmp3_1 = ((((kA775 + kC775) - kE775) - kE775) - kD775);
    tmp3_2 = kB775 - kG775;
    // Op 776: dim3x1 add
    gl64_t s1_776 = *(gl64_t*)&expressions_params[9][25];
    tmp3_0 = tmp3_0 + s1_776; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 777: dim3x3 mul
    gl64_t s1_777_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_777_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_777_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA777 = (tmp3_0 + tmp3_1) * (s1_777_0 + s1_777_1);
    gl64_t kB777 = (tmp3_0 + tmp3_2) * (s1_777_0 + s1_777_2);
    gl64_t kC777 = (tmp3_1 + tmp3_2) * (s1_777_1 + s1_777_2);
    gl64_t kD777 = tmp3_0 * s1_777_0;
    gl64_t kE777 = tmp3_1 * s1_777_1;
    gl64_t kF777 = tmp3_2 * s1_777_2;
    gl64_t kG777 = kD777 - kE777;
    tmp3_0 = (kC777 + kG777) - kF777;
    tmp3_1 = ((((kA777 + kC777) - kE777) - kE777) - kD777);
    tmp3_2 = kB777 - kG777;
    // Op 778: dim3x1 add
    gl64_t s1_778 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_778; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 779: dim3x3 mul
    gl64_t s1_779_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_779_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_779_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 780: dim3x1 add
    gl64_t s1_780 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_780; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 781: dim3x3 add
    gl64_t s1_781_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_781_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_781_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_781_0; tmp3_1 = tmp3_1 + s1_781_1; tmp3_2 = tmp3_2 + s1_781_2;
    // Op 782: dim3x3 mul
    gl64_t s1_782_0 = *(gl64_t*)&expressions_params[10][158];
    gl64_t s1_782_1 = *(gl64_t*)&expressions_params[10][158+1];
    gl64_t s1_782_2 = *(gl64_t*)&expressions_params[10][158+2];
    gl64_t kA782 = (tmp3_0 + tmp3_1) * (s1_782_0 + s1_782_1);
    gl64_t kB782 = (tmp3_0 + tmp3_2) * (s1_782_0 + s1_782_2);
    gl64_t kC782 = (tmp3_1 + tmp3_2) * (s1_782_1 + s1_782_2);
    gl64_t kD782 = tmp3_0 * s1_782_0;
    gl64_t kE782 = tmp3_1 * s1_782_1;
    gl64_t kF782 = tmp3_2 * s1_782_2;
    gl64_t kG782 = kD782 - kE782;
    tmp3_0 = (kC782 + kG782) - kF782;
    tmp3_1 = ((((kA782 + kC782) - kE782) - kE782) - kD782);
    tmp3_2 = kB782 - kG782;
    // Op 783: dim1x1 sub
    gl64_t s0_783 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_783 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_783 - s1_783;
    // Op 784: dim1x1 sub_swap
    gl64_t s1_784 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_784 - tmp1_0;
    // Op 785: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 786: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 787: dim3x3 mul
    gl64_t s1_787_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_787_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_787_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA787 = (tmp3_0 + tmp3_1) * (s1_787_0 + s1_787_1);
    gl64_t kB787 = (tmp3_0 + tmp3_2) * (s1_787_0 + s1_787_2);
    gl64_t kC787 = (tmp3_1 + tmp3_2) * (s1_787_1 + s1_787_2);
    gl64_t kD787 = tmp3_0 * s1_787_0;
    gl64_t kE787 = tmp3_1 * s1_787_1;
    gl64_t kF787 = tmp3_2 * s1_787_2;
    gl64_t kG787 = kD787 - kE787;
    tmp3_6 = (kC787 + kG787) - kF787;
    tmp3_7 = ((((kA787 + kC787) - kE787) - kE787) - kD787);
    tmp3_8 = kB787 - kG787;
    // Op 788: dim1x1 sub
    gl64_t s1_788 = *(gl64_t*)&expressions_params[10][76];
    tmp1_0 = tmp1_4 - s1_788;
    // Op 789: dim1x1 sub
    gl64_t s1_789 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_789;
    // Op 790: dim3x1 mul
    gl64_t s0_790_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_790_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_790_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_790_0 * tmp1_0; tmp3_1 = s0_790_1 * tmp1_0; tmp3_2 = s0_790_2 * tmp1_0;
    // Op 791: dim3x1 add
    gl64_t s1_791 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_791; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 792: dim3x3 add
    gl64_t s1_792_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_792_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_792_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_792_0; tmp3_1 = tmp3_1 + s1_792_1; tmp3_2 = tmp3_2 + s1_792_2;
    // Op 793: dim3x3 mul
    gl64_t s1_793_0 = *(gl64_t*)&expressions_params[10][161];
    gl64_t s1_793_1 = *(gl64_t*)&expressions_params[10][161+1];
    gl64_t s1_793_2 = *(gl64_t*)&expressions_params[10][161+2];
    gl64_t kA793 = (tmp3_0 + tmp3_1) * (s1_793_0 + s1_793_1);
    gl64_t kB793 = (tmp3_0 + tmp3_2) * (s1_793_0 + s1_793_2);
    gl64_t kC793 = (tmp3_1 + tmp3_2) * (s1_793_1 + s1_793_2);
    gl64_t kD793 = tmp3_0 * s1_793_0;
    gl64_t kE793 = tmp3_1 * s1_793_1;
    gl64_t kF793 = tmp3_2 * s1_793_2;
    gl64_t kG793 = kD793 - kE793;
    tmp3_0 = (kC793 + kG793) - kF793;
    tmp3_1 = ((((kA793 + kC793) - kE793) - kE793) - kD793);
    tmp3_2 = kB793 - kG793;
    // Op 794: dim3x1 add
    gl64_t s1_794 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_794; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 795: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 796: dim3x3 mul
    gl64_t s1_796_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_796_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_796_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA796 = (tmp3_0 + tmp3_1) * (s1_796_0 + s1_796_1);
    gl64_t kB796 = (tmp3_0 + tmp3_2) * (s1_796_0 + s1_796_2);
    gl64_t kC796 = (tmp3_1 + tmp3_2) * (s1_796_1 + s1_796_2);
    gl64_t kD796 = tmp3_0 * s1_796_0;
    gl64_t kE796 = tmp3_1 * s1_796_1;
    gl64_t kF796 = tmp3_2 * s1_796_2;
    gl64_t kG796 = kD796 - kE796;
    tmp3_6 = (kC796 + kG796) - kF796;
    tmp3_7 = ((((kA796 + kC796) - kE796) - kE796) - kD796);
    tmp3_8 = kB796 - kG796;
    // Op 797: dim3x1 mul
    gl64_t s0_797_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_797_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_797_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_797 = *(gl64_t*)&expressions_params[10][21];
    tmp3_0 = s0_797_0 * s1_797; tmp3_1 = s0_797_1 * s1_797; tmp3_2 = s0_797_2 * s1_797;
    // Op 798: dim3x1 add
    gl64_t s1_798 = *(gl64_t*)&expressions_params[10][20];
    tmp3_0 = tmp3_0 + s1_798; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 799: dim3x3 mul
    gl64_t s1_799_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_799_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_799_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA799 = (tmp3_0 + tmp3_1) * (s1_799_0 + s1_799_1);
    gl64_t kB799 = (tmp3_0 + tmp3_2) * (s1_799_0 + s1_799_2);
    gl64_t kC799 = (tmp3_1 + tmp3_2) * (s1_799_1 + s1_799_2);
    gl64_t kD799 = tmp3_0 * s1_799_0;
    gl64_t kE799 = tmp3_1 * s1_799_1;
    gl64_t kF799 = tmp3_2 * s1_799_2;
    gl64_t kG799 = kD799 - kE799;
    tmp3_0 = (kC799 + kG799) - kF799;
    tmp3_1 = ((((kA799 + kC799) - kE799) - kE799) - kD799);
    tmp3_2 = kB799 - kG799;
    // Op 800: dim3x1 add
    gl64_t s1_800 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_800; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 801: dim3x3 mul
    gl64_t s1_801_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_801_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_801_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA801 = (tmp3_0 + tmp3_1) * (s1_801_0 + s1_801_1);
    gl64_t kB801 = (tmp3_0 + tmp3_2) * (s1_801_0 + s1_801_2);
    gl64_t kC801 = (tmp3_1 + tmp3_2) * (s1_801_1 + s1_801_2);
    gl64_t kD801 = tmp3_0 * s1_801_0;
    gl64_t kE801 = tmp3_1 * s1_801_1;
    gl64_t kF801 = tmp3_2 * s1_801_2;
    gl64_t kG801 = kD801 - kE801;
    tmp3_0 = (kC801 + kG801) - kF801;
    tmp3_1 = ((((kA801 + kC801) - kE801) - kE801) - kD801);
    tmp3_2 = kB801 - kG801;
    // Op 802: dim3x1 add
    gl64_t s1_802 = *(gl64_t*)&expressions_params[10][76];
    tmp3_0 = tmp3_0 + s1_802; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 803: dim3x3 mul
    gl64_t s1_803_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_803_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_803_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA803 = (tmp3_0 + tmp3_1) * (s1_803_0 + s1_803_1);
    gl64_t kB803 = (tmp3_0 + tmp3_2) * (s1_803_0 + s1_803_2);
    gl64_t kC803 = (tmp3_1 + tmp3_2) * (s1_803_1 + s1_803_2);
    gl64_t kD803 = tmp3_0 * s1_803_0;
    gl64_t kE803 = tmp3_1 * s1_803_1;
    gl64_t kF803 = tmp3_2 * s1_803_2;
    gl64_t kG803 = kD803 - kE803;
    tmp3_0 = (kC803 + kG803) - kF803;
    tmp3_1 = ((((kA803 + kC803) - kE803) - kE803) - kD803);
    tmp3_2 = kB803 - kG803;
    // Op 804: dim3x1 add
    gl64_t s1_804 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_804; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 805: dim3x3 mul
    gl64_t s1_805_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_805_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_805_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA805 = (tmp3_0 + tmp3_1) * (s1_805_0 + s1_805_1);
    gl64_t kB805 = (tmp3_0 + tmp3_2) * (s1_805_0 + s1_805_2);
    gl64_t kC805 = (tmp3_1 + tmp3_2) * (s1_805_1 + s1_805_2);
    gl64_t kD805 = tmp3_0 * s1_805_0;
    gl64_t kE805 = tmp3_1 * s1_805_1;
    gl64_t kF805 = tmp3_2 * s1_805_2;
    gl64_t kG805 = kD805 - kE805;
    tmp3_0 = (kC805 + kG805) - kF805;
    tmp3_1 = ((((kA805 + kC805) - kE805) - kE805) - kD805);
    tmp3_2 = kB805 - kG805;
    // Op 806: dim3x1 add
    gl64_t s1_806 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_806; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 807: dim3x3 mul
    gl64_t s1_807_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_807_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_807_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 808: dim3x1 add
    gl64_t s1_808 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_808; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 809: dim3x3 add
    gl64_t s1_809_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_809_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_809_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_809_0; tmp3_1 = tmp3_1 + s1_809_1; tmp3_2 = tmp3_2 + s1_809_2;
    // Op 810: dim3x3 mul
    gl64_t s1_810_0 = *(gl64_t*)&expressions_params[10][164];
    gl64_t s1_810_1 = *(gl64_t*)&expressions_params[10][164+1];
    gl64_t s1_810_2 = *(gl64_t*)&expressions_params[10][164+2];
    gl64_t kA810 = (tmp3_0 + tmp3_1) * (s1_810_0 + s1_810_1);
    gl64_t kB810 = (tmp3_0 + tmp3_2) * (s1_810_0 + s1_810_2);
    gl64_t kC810 = (tmp3_1 + tmp3_2) * (s1_810_1 + s1_810_2);
    gl64_t kD810 = tmp3_0 * s1_810_0;
    gl64_t kE810 = tmp3_1 * s1_810_1;
    gl64_t kF810 = tmp3_2 * s1_810_2;
    gl64_t kG810 = kD810 - kE810;
    tmp3_0 = (kC810 + kG810) - kF810;
    tmp3_1 = ((((kA810 + kC810) - kE810) - kE810) - kD810);
    tmp3_2 = kB810 - kG810;
    // Op 811: dim3x1 sub
    gl64_t s1_811 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_811; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 812: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 813: dim3x3 mul
    gl64_t s1_813_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_813_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_813_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA813 = (tmp3_0 + tmp3_1) * (s1_813_0 + s1_813_1);
    gl64_t kB813 = (tmp3_0 + tmp3_2) * (s1_813_0 + s1_813_2);
    gl64_t kC813 = (tmp3_1 + tmp3_2) * (s1_813_1 + s1_813_2);
    gl64_t kD813 = tmp3_0 * s1_813_0;
    gl64_t kE813 = tmp3_1 * s1_813_1;
    gl64_t kF813 = tmp3_2 * s1_813_2;
    gl64_t kG813 = kD813 - kE813;
    tmp3_6 = (kC813 + kG813) - kF813;
    tmp3_7 = ((((kA813 + kC813) - kE813) - kE813) - kD813);
    tmp3_8 = kB813 - kG813;
    // Op 814: dim3x1 mul
    gl64_t s0_814_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_814_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_814_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_814 = *(gl64_t*)&expressions_params[10][21];
    tmp3_0 = s0_814_0 * s1_814; tmp3_1 = s0_814_1 * s1_814; tmp3_2 = s0_814_2 * s1_814;
    // Op 815: dim3x1 add
    gl64_t s1_815 = *(gl64_t*)&expressions_params[10][20];
    tmp3_0 = tmp3_0 + s1_815; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 816: dim3x3 mul
    gl64_t s1_816_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_816_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_816_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA816 = (tmp3_0 + tmp3_1) * (s1_816_0 + s1_816_1);
    gl64_t kB816 = (tmp3_0 + tmp3_2) * (s1_816_0 + s1_816_2);
    gl64_t kC816 = (tmp3_1 + tmp3_2) * (s1_816_1 + s1_816_2);
    gl64_t kD816 = tmp3_0 * s1_816_0;
    gl64_t kE816 = tmp3_1 * s1_816_1;
    gl64_t kF816 = tmp3_2 * s1_816_2;
    gl64_t kG816 = kD816 - kE816;
    tmp3_0 = (kC816 + kG816) - kF816;
    tmp3_1 = ((((kA816 + kC816) - kE816) - kE816) - kD816);
    tmp3_2 = kB816 - kG816;
    // Op 817: dim3x1 add
    gl64_t s1_817 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_817; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 818: dim3x3 mul
    gl64_t s1_818_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_818_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_818_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA818 = (tmp3_0 + tmp3_1) * (s1_818_0 + s1_818_1);
    gl64_t kB818 = (tmp3_0 + tmp3_2) * (s1_818_0 + s1_818_2);
    gl64_t kC818 = (tmp3_1 + tmp3_2) * (s1_818_1 + s1_818_2);
    gl64_t kD818 = tmp3_0 * s1_818_0;
    gl64_t kE818 = tmp3_1 * s1_818_1;
    gl64_t kF818 = tmp3_2 * s1_818_2;
    gl64_t kG818 = kD818 - kE818;
    tmp3_0 = (kC818 + kG818) - kF818;
    tmp3_1 = ((((kA818 + kC818) - kE818) - kE818) - kD818);
    tmp3_2 = kB818 - kG818;
    // Op 819: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 820: dim3x3 mul
    gl64_t s1_820_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_820_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_820_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA820 = (tmp3_0 + tmp3_1) * (s1_820_0 + s1_820_1);
    gl64_t kB820 = (tmp3_0 + tmp3_2) * (s1_820_0 + s1_820_2);
    gl64_t kC820 = (tmp3_1 + tmp3_2) * (s1_820_1 + s1_820_2);
    gl64_t kD820 = tmp3_0 * s1_820_0;
    gl64_t kE820 = tmp3_1 * s1_820_1;
    gl64_t kF820 = tmp3_2 * s1_820_2;
    gl64_t kG820 = kD820 - kE820;
    tmp3_0 = (kC820 + kG820) - kF820;
    tmp3_1 = ((((kA820 + kC820) - kE820) - kE820) - kD820);
    tmp3_2 = kB820 - kG820;
    // Op 821: dim3x1 add
    gl64_t s1_821 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_821; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 822: dim3x3 mul
    gl64_t s1_822_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_822_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_822_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA822 = (tmp3_0 + tmp3_1) * (s1_822_0 + s1_822_1);
    gl64_t kB822 = (tmp3_0 + tmp3_2) * (s1_822_0 + s1_822_2);
    gl64_t kC822 = (tmp3_1 + tmp3_2) * (s1_822_1 + s1_822_2);
    gl64_t kD822 = tmp3_0 * s1_822_0;
    gl64_t kE822 = tmp3_1 * s1_822_1;
    gl64_t kF822 = tmp3_2 * s1_822_2;
    gl64_t kG822 = kD822 - kE822;
    tmp3_0 = (kC822 + kG822) - kF822;
    tmp3_1 = ((((kA822 + kC822) - kE822) - kE822) - kD822);
    tmp3_2 = kB822 - kG822;
    // Op 823: dim3x1 add
    gl64_t s1_823 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_823; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 824: dim3x3 mul
    gl64_t s1_824_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_824_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_824_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 825: dim3x1 add
    gl64_t s1_825 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_825; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 826: dim3x3 add
    gl64_t s1_826_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_826_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_826_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_826_0; tmp3_1 = tmp3_1 + s1_826_1; tmp3_2 = tmp3_2 + s1_826_2;
    // Op 827: dim3x3 mul
    gl64_t s1_827_0 = *(gl64_t*)&expressions_params[10][167];
    gl64_t s1_827_1 = *(gl64_t*)&expressions_params[10][167+1];
    gl64_t s1_827_2 = *(gl64_t*)&expressions_params[10][167+2];
    gl64_t kA827 = (tmp3_0 + tmp3_1) * (s1_827_0 + s1_827_1);
    gl64_t kB827 = (tmp3_0 + tmp3_2) * (s1_827_0 + s1_827_2);
    gl64_t kC827 = (tmp3_1 + tmp3_2) * (s1_827_1 + s1_827_2);
    gl64_t kD827 = tmp3_0 * s1_827_0;
    gl64_t kE827 = tmp3_1 * s1_827_1;
    gl64_t kF827 = tmp3_2 * s1_827_2;
    gl64_t kG827 = kD827 - kE827;
    tmp3_0 = (kC827 + kG827) - kF827;
    tmp3_1 = ((((kA827 + kC827) - kE827) - kE827) - kD827);
    tmp3_2 = kB827 - kG827;
    // Op 828: dim1x1 sub
    gl64_t s0_828 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_828 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_828 - s1_828;
    // Op 829: dim1x1 sub_swap
    gl64_t s1_829 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_829 - tmp1_0;
    // Op 830: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 831: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 832: dim3x3 mul
    gl64_t s1_832_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_832_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_832_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA832 = (tmp3_0 + tmp3_1) * (s1_832_0 + s1_832_1);
    gl64_t kB832 = (tmp3_0 + tmp3_2) * (s1_832_0 + s1_832_2);
    gl64_t kC832 = (tmp3_1 + tmp3_2) * (s1_832_1 + s1_832_2);
    gl64_t kD832 = tmp3_0 * s1_832_0;
    gl64_t kE832 = tmp3_1 * s1_832_1;
    gl64_t kF832 = tmp3_2 * s1_832_2;
    gl64_t kG832 = kD832 - kE832;
    tmp3_6 = (kC832 + kG832) - kF832;
    tmp3_7 = ((((kA832 + kC832) - kE832) - kE832) - kD832);
    tmp3_8 = kB832 - kG832;
    // Op 833: dim1x1 sub
    gl64_t s1_833 = *(gl64_t*)&expressions_params[10][77];
    tmp1_0 = tmp1_4 - s1_833;
    // Op 834: dim1x1 sub
    gl64_t s1_834 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_834;
    // Op 835: dim3x1 mul
    gl64_t s0_835_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_835_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_835_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_835_0 * tmp1_0; tmp3_1 = s0_835_1 * tmp1_0; tmp3_2 = s0_835_2 * tmp1_0;
    // Op 836: dim3x1 add
    gl64_t s1_836 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_836; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 837: dim3x3 add
    gl64_t s1_837_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_837_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_837_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_837_0; tmp3_1 = tmp3_1 + s1_837_1; tmp3_2 = tmp3_2 + s1_837_2;
    // Op 838: dim3x3 mul
    gl64_t s1_838_0 = *(gl64_t*)&expressions_params[10][170];
    gl64_t s1_838_1 = *(gl64_t*)&expressions_params[10][170+1];
    gl64_t s1_838_2 = *(gl64_t*)&expressions_params[10][170+2];
    gl64_t kA838 = (tmp3_0 + tmp3_1) * (s1_838_0 + s1_838_1);
    gl64_t kB838 = (tmp3_0 + tmp3_2) * (s1_838_0 + s1_838_2);
    gl64_t kC838 = (tmp3_1 + tmp3_2) * (s1_838_1 + s1_838_2);
    gl64_t kD838 = tmp3_0 * s1_838_0;
    gl64_t kE838 = tmp3_1 * s1_838_1;
    gl64_t kF838 = tmp3_2 * s1_838_2;
    gl64_t kG838 = kD838 - kE838;
    tmp3_0 = (kC838 + kG838) - kF838;
    tmp3_1 = ((((kA838 + kC838) - kE838) - kE838) - kD838);
    tmp3_2 = kB838 - kG838;
    // Op 839: dim3x1 add
    gl64_t s1_839 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_839; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 840: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 841: dim3x3 mul
    gl64_t s1_841_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_841_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_841_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA841 = (tmp3_0 + tmp3_1) * (s1_841_0 + s1_841_1);
    gl64_t kB841 = (tmp3_0 + tmp3_2) * (s1_841_0 + s1_841_2);
    gl64_t kC841 = (tmp3_1 + tmp3_2) * (s1_841_1 + s1_841_2);
    gl64_t kD841 = tmp3_0 * s1_841_0;
    gl64_t kE841 = tmp3_1 * s1_841_1;
    gl64_t kF841 = tmp3_2 * s1_841_2;
    gl64_t kG841 = kD841 - kE841;
    tmp3_6 = (kC841 + kG841) - kF841;
    tmp3_7 = ((((kA841 + kC841) - kE841) - kE841) - kD841);
    tmp3_8 = kB841 - kG841;
    // Op 842: dim3x1 mul
    gl64_t s0_842_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_842_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_842_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_842 = *(gl64_t*)&expressions_params[10][23];
    tmp3_0 = s0_842_0 * s1_842; tmp3_1 = s0_842_1 * s1_842; tmp3_2 = s0_842_2 * s1_842;
    // Op 843: dim3x1 add
    gl64_t s1_843 = *(gl64_t*)&expressions_params[10][22];
    tmp3_0 = tmp3_0 + s1_843; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 844: dim3x3 mul
    gl64_t s1_844_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_844_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_844_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA844 = (tmp3_0 + tmp3_1) * (s1_844_0 + s1_844_1);
    gl64_t kB844 = (tmp3_0 + tmp3_2) * (s1_844_0 + s1_844_2);
    gl64_t kC844 = (tmp3_1 + tmp3_2) * (s1_844_1 + s1_844_2);
    gl64_t kD844 = tmp3_0 * s1_844_0;
    gl64_t kE844 = tmp3_1 * s1_844_1;
    gl64_t kF844 = tmp3_2 * s1_844_2;
    gl64_t kG844 = kD844 - kE844;
    tmp3_0 = (kC844 + kG844) - kF844;
    tmp3_1 = ((((kA844 + kC844) - kE844) - kE844) - kD844);
    tmp3_2 = kB844 - kG844;
    // Op 845: dim3x1 add
    gl64_t s1_845 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_845; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 846: dim3x3 mul
    gl64_t s1_846_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_846_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_846_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA846 = (tmp3_0 + tmp3_1) * (s1_846_0 + s1_846_1);
    gl64_t kB846 = (tmp3_0 + tmp3_2) * (s1_846_0 + s1_846_2);
    gl64_t kC846 = (tmp3_1 + tmp3_2) * (s1_846_1 + s1_846_2);
    gl64_t kD846 = tmp3_0 * s1_846_0;
    gl64_t kE846 = tmp3_1 * s1_846_1;
    gl64_t kF846 = tmp3_2 * s1_846_2;
    gl64_t kG846 = kD846 - kE846;
    tmp3_0 = (kC846 + kG846) - kF846;
    tmp3_1 = ((((kA846 + kC846) - kE846) - kE846) - kD846);
    tmp3_2 = kB846 - kG846;
    // Op 847: dim3x1 add
    gl64_t s1_847 = *(gl64_t*)&expressions_params[10][77];
    tmp3_0 = tmp3_0 + s1_847; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 848: dim3x3 mul
    gl64_t s1_848_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_848_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_848_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA848 = (tmp3_0 + tmp3_1) * (s1_848_0 + s1_848_1);
    gl64_t kB848 = (tmp3_0 + tmp3_2) * (s1_848_0 + s1_848_2);
    gl64_t kC848 = (tmp3_1 + tmp3_2) * (s1_848_1 + s1_848_2);
    gl64_t kD848 = tmp3_0 * s1_848_0;
    gl64_t kE848 = tmp3_1 * s1_848_1;
    gl64_t kF848 = tmp3_2 * s1_848_2;
    gl64_t kG848 = kD848 - kE848;
    tmp3_0 = (kC848 + kG848) - kF848;
    tmp3_1 = ((((kA848 + kC848) - kE848) - kE848) - kD848);
    tmp3_2 = kB848 - kG848;
    // Op 849: dim3x1 add
    gl64_t s1_849 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_849; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 850: dim3x3 mul
    gl64_t s1_850_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_850_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_850_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA850 = (tmp3_0 + tmp3_1) * (s1_850_0 + s1_850_1);
    gl64_t kB850 = (tmp3_0 + tmp3_2) * (s1_850_0 + s1_850_2);
    gl64_t kC850 = (tmp3_1 + tmp3_2) * (s1_850_1 + s1_850_2);
    gl64_t kD850 = tmp3_0 * s1_850_0;
    gl64_t kE850 = tmp3_1 * s1_850_1;
    gl64_t kF850 = tmp3_2 * s1_850_2;
    gl64_t kG850 = kD850 - kE850;
    tmp3_0 = (kC850 + kG850) - kF850;
    tmp3_1 = ((((kA850 + kC850) - kE850) - kE850) - kD850);
    tmp3_2 = kB850 - kG850;
    // Op 851: dim3x1 add
    gl64_t s1_851 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_851; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 852: dim3x3 mul
    gl64_t s1_852_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_852_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_852_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 853: dim3x1 add
    gl64_t s1_853 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_853; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 854: dim3x3 add
    gl64_t s1_854_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_854_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_854_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_854_0; tmp3_1 = tmp3_1 + s1_854_1; tmp3_2 = tmp3_2 + s1_854_2;
    // Op 855: dim3x3 mul
    gl64_t s1_855_0 = *(gl64_t*)&expressions_params[10][173];
    gl64_t s1_855_1 = *(gl64_t*)&expressions_params[10][173+1];
    gl64_t s1_855_2 = *(gl64_t*)&expressions_params[10][173+2];
    gl64_t kA855 = (tmp3_0 + tmp3_1) * (s1_855_0 + s1_855_1);
    gl64_t kB855 = (tmp3_0 + tmp3_2) * (s1_855_0 + s1_855_2);
    gl64_t kC855 = (tmp3_1 + tmp3_2) * (s1_855_1 + s1_855_2);
    gl64_t kD855 = tmp3_0 * s1_855_0;
    gl64_t kE855 = tmp3_1 * s1_855_1;
    gl64_t kF855 = tmp3_2 * s1_855_2;
    gl64_t kG855 = kD855 - kE855;
    tmp3_0 = (kC855 + kG855) - kF855;
    tmp3_1 = ((((kA855 + kC855) - kE855) - kE855) - kD855);
    tmp3_2 = kB855 - kG855;
    // Op 856: dim3x1 sub
    gl64_t s1_856 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_856; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 857: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 858: dim3x3 mul
    gl64_t s1_858_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_858_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_858_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA858 = (tmp3_0 + tmp3_1) * (s1_858_0 + s1_858_1);
    gl64_t kB858 = (tmp3_0 + tmp3_2) * (s1_858_0 + s1_858_2);
    gl64_t kC858 = (tmp3_1 + tmp3_2) * (s1_858_1 + s1_858_2);
    gl64_t kD858 = tmp3_0 * s1_858_0;
    gl64_t kE858 = tmp3_1 * s1_858_1;
    gl64_t kF858 = tmp3_2 * s1_858_2;
    gl64_t kG858 = kD858 - kE858;
    tmp3_6 = (kC858 + kG858) - kF858;
    tmp3_7 = ((((kA858 + kC858) - kE858) - kE858) - kD858);
    tmp3_8 = kB858 - kG858;
    // Op 859: dim3x1 mul
    gl64_t s0_859_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_859_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_859_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_859 = *(gl64_t*)&expressions_params[10][23];
    tmp3_0 = s0_859_0 * s1_859; tmp3_1 = s0_859_1 * s1_859; tmp3_2 = s0_859_2 * s1_859;
    // Op 860: dim3x1 add
    gl64_t s1_860 = *(gl64_t*)&expressions_params[10][22];
    tmp3_0 = tmp3_0 + s1_860; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 861: dim3x3 mul
    gl64_t s1_861_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_861_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_861_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA861 = (tmp3_0 + tmp3_1) * (s1_861_0 + s1_861_1);
    gl64_t kB861 = (tmp3_0 + tmp3_2) * (s1_861_0 + s1_861_2);
    gl64_t kC861 = (tmp3_1 + tmp3_2) * (s1_861_1 + s1_861_2);
    gl64_t kD861 = tmp3_0 * s1_861_0;
    gl64_t kE861 = tmp3_1 * s1_861_1;
    gl64_t kF861 = tmp3_2 * s1_861_2;
    gl64_t kG861 = kD861 - kE861;
    tmp3_0 = (kC861 + kG861) - kF861;
    tmp3_1 = ((((kA861 + kC861) - kE861) - kE861) - kD861);
    tmp3_2 = kB861 - kG861;
    // Op 862: dim3x1 add
    gl64_t s1_862 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_862; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 863: dim3x3 mul
    gl64_t s1_863_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_863_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_863_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA863 = (tmp3_0 + tmp3_1) * (s1_863_0 + s1_863_1);
    gl64_t kB863 = (tmp3_0 + tmp3_2) * (s1_863_0 + s1_863_2);
    gl64_t kC863 = (tmp3_1 + tmp3_2) * (s1_863_1 + s1_863_2);
    gl64_t kD863 = tmp3_0 * s1_863_0;
    gl64_t kE863 = tmp3_1 * s1_863_1;
    gl64_t kF863 = tmp3_2 * s1_863_2;
    gl64_t kG863 = kD863 - kE863;
    tmp3_0 = (kC863 + kG863) - kF863;
    tmp3_1 = ((((kA863 + kC863) - kE863) - kE863) - kD863);
    tmp3_2 = kB863 - kG863;
    // Op 864: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 865: dim3x3 mul
    gl64_t s1_865_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_865_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_865_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA865 = (tmp3_0 + tmp3_1) * (s1_865_0 + s1_865_1);
    gl64_t kB865 = (tmp3_0 + tmp3_2) * (s1_865_0 + s1_865_2);
    gl64_t kC865 = (tmp3_1 + tmp3_2) * (s1_865_1 + s1_865_2);
    gl64_t kD865 = tmp3_0 * s1_865_0;
    gl64_t kE865 = tmp3_1 * s1_865_1;
    gl64_t kF865 = tmp3_2 * s1_865_2;
    gl64_t kG865 = kD865 - kE865;
    tmp3_0 = (kC865 + kG865) - kF865;
    tmp3_1 = ((((kA865 + kC865) - kE865) - kE865) - kD865);
    tmp3_2 = kB865 - kG865;
    // Op 866: dim3x1 add
    gl64_t s1_866 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_866; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 867: dim3x3 mul
    gl64_t s1_867_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_867_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_867_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA867 = (tmp3_0 + tmp3_1) * (s1_867_0 + s1_867_1);
    gl64_t kB867 = (tmp3_0 + tmp3_2) * (s1_867_0 + s1_867_2);
    gl64_t kC867 = (tmp3_1 + tmp3_2) * (s1_867_1 + s1_867_2);
    gl64_t kD867 = tmp3_0 * s1_867_0;
    gl64_t kE867 = tmp3_1 * s1_867_1;
    gl64_t kF867 = tmp3_2 * s1_867_2;
    gl64_t kG867 = kD867 - kE867;
    tmp3_0 = (kC867 + kG867) - kF867;
    tmp3_1 = ((((kA867 + kC867) - kE867) - kE867) - kD867);
    tmp3_2 = kB867 - kG867;
    // Op 868: dim3x1 add
    gl64_t s1_868 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_868; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 869: dim3x3 mul
    gl64_t s1_869_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_869_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_869_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 870: dim3x1 add
    gl64_t s1_870 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_870; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 871: dim3x3 add
    gl64_t s1_871_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_871_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_871_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_871_0; tmp3_1 = tmp3_1 + s1_871_1; tmp3_2 = tmp3_2 + s1_871_2;
    // Op 872: dim3x3 mul
    gl64_t s1_872_0 = *(gl64_t*)&expressions_params[10][176];
    gl64_t s1_872_1 = *(gl64_t*)&expressions_params[10][176+1];
    gl64_t s1_872_2 = *(gl64_t*)&expressions_params[10][176+2];
    gl64_t kA872 = (tmp3_0 + tmp3_1) * (s1_872_0 + s1_872_1);
    gl64_t kB872 = (tmp3_0 + tmp3_2) * (s1_872_0 + s1_872_2);
    gl64_t kC872 = (tmp3_1 + tmp3_2) * (s1_872_1 + s1_872_2);
    gl64_t kD872 = tmp3_0 * s1_872_0;
    gl64_t kE872 = tmp3_1 * s1_872_1;
    gl64_t kF872 = tmp3_2 * s1_872_2;
    gl64_t kG872 = kD872 - kE872;
    tmp3_0 = (kC872 + kG872) - kF872;
    tmp3_1 = ((((kA872 + kC872) - kE872) - kE872) - kD872);
    tmp3_2 = kB872 - kG872;
    // Op 873: dim1x1 sub
    gl64_t s0_873 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_873 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_873 - s1_873;
    // Op 874: dim1x1 sub_swap
    gl64_t s1_874 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_874 - tmp1_0;
    // Op 875: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 876: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 877: dim3x3 mul
    gl64_t s1_877_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_877_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_877_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA877 = (tmp3_0 + tmp3_1) * (s1_877_0 + s1_877_1);
    gl64_t kB877 = (tmp3_0 + tmp3_2) * (s1_877_0 + s1_877_2);
    gl64_t kC877 = (tmp3_1 + tmp3_2) * (s1_877_1 + s1_877_2);
    gl64_t kD877 = tmp3_0 * s1_877_0;
    gl64_t kE877 = tmp3_1 * s1_877_1;
    gl64_t kF877 = tmp3_2 * s1_877_2;
    gl64_t kG877 = kD877 - kE877;
    tmp3_6 = (kC877 + kG877) - kF877;
    tmp3_7 = ((((kA877 + kC877) - kE877) - kE877) - kD877);
    tmp3_8 = kB877 - kG877;
    // Op 878: dim1x1 sub
    gl64_t s1_878 = *(gl64_t*)&expressions_params[10][78];
    tmp1_0 = tmp1_4 - s1_878;
    // Op 879: dim1x1 sub
    gl64_t s1_879 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_879;
    // Op 880: dim3x1 mul
    gl64_t s0_880_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_880_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_880_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_880_0 * tmp1_0; tmp3_1 = s0_880_1 * tmp1_0; tmp3_2 = s0_880_2 * tmp1_0;
    // Op 881: dim3x1 add
    gl64_t s1_881 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_881; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 882: dim3x3 add
    gl64_t s1_882_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_882_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_882_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_882_0; tmp3_1 = tmp3_1 + s1_882_1; tmp3_2 = tmp3_2 + s1_882_2;
    // Op 883: dim3x3 mul
    gl64_t s1_883_0 = *(gl64_t*)&expressions_params[10][179];
    gl64_t s1_883_1 = *(gl64_t*)&expressions_params[10][179+1];
    gl64_t s1_883_2 = *(gl64_t*)&expressions_params[10][179+2];
    gl64_t kA883 = (tmp3_0 + tmp3_1) * (s1_883_0 + s1_883_1);
    gl64_t kB883 = (tmp3_0 + tmp3_2) * (s1_883_0 + s1_883_2);
    gl64_t kC883 = (tmp3_1 + tmp3_2) * (s1_883_1 + s1_883_2);
    gl64_t kD883 = tmp3_0 * s1_883_0;
    gl64_t kE883 = tmp3_1 * s1_883_1;
    gl64_t kF883 = tmp3_2 * s1_883_2;
    gl64_t kG883 = kD883 - kE883;
    tmp3_0 = (kC883 + kG883) - kF883;
    tmp3_1 = ((((kA883 + kC883) - kE883) - kE883) - kD883);
    tmp3_2 = kB883 - kG883;
    // Op 884: dim3x1 add
    gl64_t s1_884 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_884; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 885: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 886: dim3x3 mul
    gl64_t s1_886_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_886_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_886_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA886 = (tmp3_0 + tmp3_1) * (s1_886_0 + s1_886_1);
    gl64_t kB886 = (tmp3_0 + tmp3_2) * (s1_886_0 + s1_886_2);
    gl64_t kC886 = (tmp3_1 + tmp3_2) * (s1_886_1 + s1_886_2);
    gl64_t kD886 = tmp3_0 * s1_886_0;
    gl64_t kE886 = tmp3_1 * s1_886_1;
    gl64_t kF886 = tmp3_2 * s1_886_2;
    gl64_t kG886 = kD886 - kE886;
    tmp3_6 = (kC886 + kG886) - kF886;
    tmp3_7 = ((((kA886 + kC886) - kE886) - kE886) - kD886);
    tmp3_8 = kB886 - kG886;
    // Op 887: dim3x1 mul
    gl64_t s0_887_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_887_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_887_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_887 = *(gl64_t*)&expressions_params[10][25];
    tmp3_0 = s0_887_0 * s1_887; tmp3_1 = s0_887_1 * s1_887; tmp3_2 = s0_887_2 * s1_887;
    // Op 888: dim3x1 add
    gl64_t s1_888 = *(gl64_t*)&expressions_params[10][24];
    tmp3_0 = tmp3_0 + s1_888; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 889: dim3x3 mul
    gl64_t s1_889_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_889_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_889_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA889 = (tmp3_0 + tmp3_1) * (s1_889_0 + s1_889_1);
    gl64_t kB889 = (tmp3_0 + tmp3_2) * (s1_889_0 + s1_889_2);
    gl64_t kC889 = (tmp3_1 + tmp3_2) * (s1_889_1 + s1_889_2);
    gl64_t kD889 = tmp3_0 * s1_889_0;
    gl64_t kE889 = tmp3_1 * s1_889_1;
    gl64_t kF889 = tmp3_2 * s1_889_2;
    gl64_t kG889 = kD889 - kE889;
    tmp3_0 = (kC889 + kG889) - kF889;
    tmp3_1 = ((((kA889 + kC889) - kE889) - kE889) - kD889);
    tmp3_2 = kB889 - kG889;
    // Op 890: dim3x1 add
    gl64_t s1_890 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_890; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 891: dim3x3 mul
    gl64_t s1_891_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_891_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_891_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA891 = (tmp3_0 + tmp3_1) * (s1_891_0 + s1_891_1);
    gl64_t kB891 = (tmp3_0 + tmp3_2) * (s1_891_0 + s1_891_2);
    gl64_t kC891 = (tmp3_1 + tmp3_2) * (s1_891_1 + s1_891_2);
    gl64_t kD891 = tmp3_0 * s1_891_0;
    gl64_t kE891 = tmp3_1 * s1_891_1;
    gl64_t kF891 = tmp3_2 * s1_891_2;
    gl64_t kG891 = kD891 - kE891;
    tmp3_0 = (kC891 + kG891) - kF891;
    tmp3_1 = ((((kA891 + kC891) - kE891) - kE891) - kD891);
    tmp3_2 = kB891 - kG891;
    // Op 892: dim3x1 add
    gl64_t s1_892 = *(gl64_t*)&expressions_params[10][78];
    tmp3_0 = tmp3_0 + s1_892; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 893: dim3x3 mul
    gl64_t s1_893_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_893_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_893_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA893 = (tmp3_0 + tmp3_1) * (s1_893_0 + s1_893_1);
    gl64_t kB893 = (tmp3_0 + tmp3_2) * (s1_893_0 + s1_893_2);
    gl64_t kC893 = (tmp3_1 + tmp3_2) * (s1_893_1 + s1_893_2);
    gl64_t kD893 = tmp3_0 * s1_893_0;
    gl64_t kE893 = tmp3_1 * s1_893_1;
    gl64_t kF893 = tmp3_2 * s1_893_2;
    gl64_t kG893 = kD893 - kE893;
    tmp3_0 = (kC893 + kG893) - kF893;
    tmp3_1 = ((((kA893 + kC893) - kE893) - kE893) - kD893);
    tmp3_2 = kB893 - kG893;
    // Op 894: dim3x1 add
    gl64_t s1_894 = *(gl64_t*)&expressions_params[9][27];
    tmp3_0 = tmp3_0 + s1_894; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 895: dim3x3 mul
    gl64_t s1_895_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_895_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_895_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA895 = (tmp3_0 + tmp3_1) * (s1_895_0 + s1_895_1);
    gl64_t kB895 = (tmp3_0 + tmp3_2) * (s1_895_0 + s1_895_2);
    gl64_t kC895 = (tmp3_1 + tmp3_2) * (s1_895_1 + s1_895_2);
    gl64_t kD895 = tmp3_0 * s1_895_0;
    gl64_t kE895 = tmp3_1 * s1_895_1;
    gl64_t kF895 = tmp3_2 * s1_895_2;
    gl64_t kG895 = kD895 - kE895;
    tmp3_0 = (kC895 + kG895) - kF895;
    tmp3_1 = ((((kA895 + kC895) - kE895) - kE895) - kD895);
    tmp3_2 = kB895 - kG895;
    // Op 896: dim3x1 add
    gl64_t s1_896 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_896; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 897: dim3x3 mul
    gl64_t s1_897_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_897_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_897_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 898: dim3x1 add
    gl64_t s1_898 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_898; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 899: dim3x3 add
    gl64_t s1_899_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_899_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_899_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_899_0; tmp3_1 = tmp3_1 + s1_899_1; tmp3_2 = tmp3_2 + s1_899_2;
    // Op 900: dim3x3 mul
    gl64_t s1_900_0 = *(gl64_t*)&expressions_params[10][182];
    gl64_t s1_900_1 = *(gl64_t*)&expressions_params[10][182+1];
    gl64_t s1_900_2 = *(gl64_t*)&expressions_params[10][182+2];
    gl64_t kA900 = (tmp3_0 + tmp3_1) * (s1_900_0 + s1_900_1);
    gl64_t kB900 = (tmp3_0 + tmp3_2) * (s1_900_0 + s1_900_2);
    gl64_t kC900 = (tmp3_1 + tmp3_2) * (s1_900_1 + s1_900_2);
    gl64_t kD900 = tmp3_0 * s1_900_0;
    gl64_t kE900 = tmp3_1 * s1_900_1;
    gl64_t kF900 = tmp3_2 * s1_900_2;
    gl64_t kG900 = kD900 - kE900;
    tmp3_0 = (kC900 + kG900) - kF900;
    tmp3_1 = ((((kA900 + kC900) - kE900) - kE900) - kD900);
    tmp3_2 = kB900 - kG900;
    // Op 901: dim3x1 sub
    gl64_t s1_901 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_901; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 902: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 903: dim3x3 mul
    gl64_t s1_903_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_903_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_903_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA903 = (tmp3_0 + tmp3_1) * (s1_903_0 + s1_903_1);
    gl64_t kB903 = (tmp3_0 + tmp3_2) * (s1_903_0 + s1_903_2);
    gl64_t kC903 = (tmp3_1 + tmp3_2) * (s1_903_1 + s1_903_2);
    gl64_t kD903 = tmp3_0 * s1_903_0;
    gl64_t kE903 = tmp3_1 * s1_903_1;
    gl64_t kF903 = tmp3_2 * s1_903_2;
    gl64_t kG903 = kD903 - kE903;
    tmp3_6 = (kC903 + kG903) - kF903;
    tmp3_7 = ((((kA903 + kC903) - kE903) - kE903) - kD903);
    tmp3_8 = kB903 - kG903;
    // Op 904: dim3x1 mul
    gl64_t s0_904_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_904_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_904_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_904 = *(gl64_t*)&expressions_params[10][25];
    tmp3_0 = s0_904_0 * s1_904; tmp3_1 = s0_904_1 * s1_904; tmp3_2 = s0_904_2 * s1_904;
    // Op 905: dim3x1 add
    gl64_t s1_905 = *(gl64_t*)&expressions_params[10][24];
    tmp3_0 = tmp3_0 + s1_905; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 906: dim3x3 mul
    gl64_t s1_906_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_906_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_906_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA906 = (tmp3_0 + tmp3_1) * (s1_906_0 + s1_906_1);
    gl64_t kB906 = (tmp3_0 + tmp3_2) * (s1_906_0 + s1_906_2);
    gl64_t kC906 = (tmp3_1 + tmp3_2) * (s1_906_1 + s1_906_2);
    gl64_t kD906 = tmp3_0 * s1_906_0;
    gl64_t kE906 = tmp3_1 * s1_906_1;
    gl64_t kF906 = tmp3_2 * s1_906_2;
    gl64_t kG906 = kD906 - kE906;
    tmp3_0 = (kC906 + kG906) - kF906;
    tmp3_1 = ((((kA906 + kC906) - kE906) - kE906) - kD906);
    tmp3_2 = kB906 - kG906;
    // Op 907: dim3x1 add
    gl64_t s1_907 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_907; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 908: dim3x3 mul
    gl64_t s1_908_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_908_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_908_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA908 = (tmp3_0 + tmp3_1) * (s1_908_0 + s1_908_1);
    gl64_t kB908 = (tmp3_0 + tmp3_2) * (s1_908_0 + s1_908_2);
    gl64_t kC908 = (tmp3_1 + tmp3_2) * (s1_908_1 + s1_908_2);
    gl64_t kD908 = tmp3_0 * s1_908_0;
    gl64_t kE908 = tmp3_1 * s1_908_1;
    gl64_t kF908 = tmp3_2 * s1_908_2;
    gl64_t kG908 = kD908 - kE908;
    tmp3_0 = (kC908 + kG908) - kF908;
    tmp3_1 = ((((kA908 + kC908) - kE908) - kE908) - kD908);
    tmp3_2 = kB908 - kG908;
    // Op 909: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 910: dim3x3 mul
    gl64_t s1_910_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_910_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_910_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA910 = (tmp3_0 + tmp3_1) * (s1_910_0 + s1_910_1);
    gl64_t kB910 = (tmp3_0 + tmp3_2) * (s1_910_0 + s1_910_2);
    gl64_t kC910 = (tmp3_1 + tmp3_2) * (s1_910_1 + s1_910_2);
    gl64_t kD910 = tmp3_0 * s1_910_0;
    gl64_t kE910 = tmp3_1 * s1_910_1;
    gl64_t kF910 = tmp3_2 * s1_910_2;
    gl64_t kG910 = kD910 - kE910;
    tmp3_0 = (kC910 + kG910) - kF910;
    tmp3_1 = ((((kA910 + kC910) - kE910) - kE910) - kD910);
    tmp3_2 = kB910 - kG910;
    // Op 911: dim3x1 add
    gl64_t s1_911 = *(gl64_t*)&expressions_params[9][27];
    tmp3_0 = tmp3_0 + s1_911; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 912: dim3x3 mul
    gl64_t s1_912_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_912_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_912_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA912 = (tmp3_0 + tmp3_1) * (s1_912_0 + s1_912_1);
    gl64_t kB912 = (tmp3_0 + tmp3_2) * (s1_912_0 + s1_912_2);
    gl64_t kC912 = (tmp3_1 + tmp3_2) * (s1_912_1 + s1_912_2);
    gl64_t kD912 = tmp3_0 * s1_912_0;
    gl64_t kE912 = tmp3_1 * s1_912_1;
    gl64_t kF912 = tmp3_2 * s1_912_2;
    gl64_t kG912 = kD912 - kE912;
    tmp3_0 = (kC912 + kG912) - kF912;
    tmp3_1 = ((((kA912 + kC912) - kE912) - kE912) - kD912);
    tmp3_2 = kB912 - kG912;
    // Op 913: dim3x1 add
    gl64_t s1_913 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_913; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 914: dim3x3 mul
    gl64_t s1_914_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_914_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_914_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 915: dim3x1 add
    gl64_t s1_915 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_915; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 916: dim3x3 add
    gl64_t s1_916_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_916_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_916_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_916_0; tmp3_1 = tmp3_1 + s1_916_1; tmp3_2 = tmp3_2 + s1_916_2;
    // Op 917: dim3x3 mul
    gl64_t s1_917_0 = *(gl64_t*)&expressions_params[10][185];
    gl64_t s1_917_1 = *(gl64_t*)&expressions_params[10][185+1];
    gl64_t s1_917_2 = *(gl64_t*)&expressions_params[10][185+2];
    gl64_t kA917 = (tmp3_0 + tmp3_1) * (s1_917_0 + s1_917_1);
    gl64_t kB917 = (tmp3_0 + tmp3_2) * (s1_917_0 + s1_917_2);
    gl64_t kC917 = (tmp3_1 + tmp3_2) * (s1_917_1 + s1_917_2);
    gl64_t kD917 = tmp3_0 * s1_917_0;
    gl64_t kE917 = tmp3_1 * s1_917_1;
    gl64_t kF917 = tmp3_2 * s1_917_2;
    gl64_t kG917 = kD917 - kE917;
    tmp3_0 = (kC917 + kG917) - kF917;
    tmp3_1 = ((((kA917 + kC917) - kE917) - kE917) - kD917);
    tmp3_2 = kB917 - kG917;
    // Op 918: dim1x1 sub
    gl64_t s0_918 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_918 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_918 - s1_918;
    // Op 919: dim1x1 sub_swap
    gl64_t s1_919 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_919 - tmp1_0;
    // Op 920: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 921: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 922: dim3x3 mul
    gl64_t s1_922_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_922_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_922_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA922 = (tmp3_0 + tmp3_1) * (s1_922_0 + s1_922_1);
    gl64_t kB922 = (tmp3_0 + tmp3_2) * (s1_922_0 + s1_922_2);
    gl64_t kC922 = (tmp3_1 + tmp3_2) * (s1_922_1 + s1_922_2);
    gl64_t kD922 = tmp3_0 * s1_922_0;
    gl64_t kE922 = tmp3_1 * s1_922_1;
    gl64_t kF922 = tmp3_2 * s1_922_2;
    gl64_t kG922 = kD922 - kE922;
    tmp3_6 = (kC922 + kG922) - kF922;
    tmp3_7 = ((((kA922 + kC922) - kE922) - kE922) - kD922);
    tmp3_8 = kB922 - kG922;
    // Op 923: dim1x1 sub
    gl64_t s1_923 = *(gl64_t*)&expressions_params[10][79];
    tmp1_0 = tmp1_4 - s1_923;
    // Op 924: dim1x1 sub
    gl64_t s1_924 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_924;
    // Op 925: dim3x1 mul
    gl64_t s0_925_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_925_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_925_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_925_0 * tmp1_0; tmp3_1 = s0_925_1 * tmp1_0; tmp3_2 = s0_925_2 * tmp1_0;
    // Op 926: dim3x1 add
    gl64_t s1_926 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_926; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 927: dim3x3 add
    gl64_t s1_927_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_927_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_927_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_927_0; tmp3_1 = tmp3_1 + s1_927_1; tmp3_2 = tmp3_2 + s1_927_2;
    // Op 928: dim3x3 mul
    gl64_t s1_928_0 = *(gl64_t*)&expressions_params[10][188];
    gl64_t s1_928_1 = *(gl64_t*)&expressions_params[10][188+1];
    gl64_t s1_928_2 = *(gl64_t*)&expressions_params[10][188+2];
    gl64_t kA928 = (tmp3_0 + tmp3_1) * (s1_928_0 + s1_928_1);
    gl64_t kB928 = (tmp3_0 + tmp3_2) * (s1_928_0 + s1_928_2);
    gl64_t kC928 = (tmp3_1 + tmp3_2) * (s1_928_1 + s1_928_2);
    gl64_t kD928 = tmp3_0 * s1_928_0;
    gl64_t kE928 = tmp3_1 * s1_928_1;
    gl64_t kF928 = tmp3_2 * s1_928_2;
    gl64_t kG928 = kD928 - kE928;
    tmp3_0 = (kC928 + kG928) - kF928;
    tmp3_1 = ((((kA928 + kC928) - kE928) - kE928) - kD928);
    tmp3_2 = kB928 - kG928;
    // Op 929: dim3x1 add
    gl64_t s1_929 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_929; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 930: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 931: dim3x3 mul
    gl64_t s1_931_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_931_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_931_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA931 = (tmp3_0 + tmp3_1) * (s1_931_0 + s1_931_1);
    gl64_t kB931 = (tmp3_0 + tmp3_2) * (s1_931_0 + s1_931_2);
    gl64_t kC931 = (tmp3_1 + tmp3_2) * (s1_931_1 + s1_931_2);
    gl64_t kD931 = tmp3_0 * s1_931_0;
    gl64_t kE931 = tmp3_1 * s1_931_1;
    gl64_t kF931 = tmp3_2 * s1_931_2;
    gl64_t kG931 = kD931 - kE931;
    tmp3_6 = (kC931 + kG931) - kF931;
    tmp3_7 = ((((kA931 + kC931) - kE931) - kE931) - kD931);
    tmp3_8 = kB931 - kG931;
    // Op 932: dim3x1 mul
    gl64_t s0_932_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_932_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_932_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_932 = *(gl64_t*)&expressions_params[10][27];
    tmp3_0 = s0_932_0 * s1_932; tmp3_1 = s0_932_1 * s1_932; tmp3_2 = s0_932_2 * s1_932;
    // Op 933: dim3x1 add
    gl64_t s1_933 = *(gl64_t*)&expressions_params[10][26];
    tmp3_0 = tmp3_0 + s1_933; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 934: dim3x3 mul
    gl64_t s1_934_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_934_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_934_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA934 = (tmp3_0 + tmp3_1) * (s1_934_0 + s1_934_1);
    gl64_t kB934 = (tmp3_0 + tmp3_2) * (s1_934_0 + s1_934_2);
    gl64_t kC934 = (tmp3_1 + tmp3_2) * (s1_934_1 + s1_934_2);
    gl64_t kD934 = tmp3_0 * s1_934_0;
    gl64_t kE934 = tmp3_1 * s1_934_1;
    gl64_t kF934 = tmp3_2 * s1_934_2;
    gl64_t kG934 = kD934 - kE934;
    tmp3_0 = (kC934 + kG934) - kF934;
    tmp3_1 = ((((kA934 + kC934) - kE934) - kE934) - kD934);
    tmp3_2 = kB934 - kG934;
    // Op 935: dim3x1 add
    gl64_t s1_935 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_935; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 936: dim3x3 mul
    gl64_t s1_936_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_936_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_936_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA936 = (tmp3_0 + tmp3_1) * (s1_936_0 + s1_936_1);
    gl64_t kB936 = (tmp3_0 + tmp3_2) * (s1_936_0 + s1_936_2);
    gl64_t kC936 = (tmp3_1 + tmp3_2) * (s1_936_1 + s1_936_2);
    gl64_t kD936 = tmp3_0 * s1_936_0;
    gl64_t kE936 = tmp3_1 * s1_936_1;
    gl64_t kF936 = tmp3_2 * s1_936_2;
    gl64_t kG936 = kD936 - kE936;
    tmp3_0 = (kC936 + kG936) - kF936;
    tmp3_1 = ((((kA936 + kC936) - kE936) - kE936) - kD936);
    tmp3_2 = kB936 - kG936;
    // Op 937: dim3x1 add
    gl64_t s1_937 = *(gl64_t*)&expressions_params[10][79];
    tmp3_0 = tmp3_0 + s1_937; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 938: dim3x3 mul
    gl64_t s1_938_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_938_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_938_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA938 = (tmp3_0 + tmp3_1) * (s1_938_0 + s1_938_1);
    gl64_t kB938 = (tmp3_0 + tmp3_2) * (s1_938_0 + s1_938_2);
    gl64_t kC938 = (tmp3_1 + tmp3_2) * (s1_938_1 + s1_938_2);
    gl64_t kD938 = tmp3_0 * s1_938_0;
    gl64_t kE938 = tmp3_1 * s1_938_1;
    gl64_t kF938 = tmp3_2 * s1_938_2;
    gl64_t kG938 = kD938 - kE938;
    tmp3_0 = (kC938 + kG938) - kF938;
    tmp3_1 = ((((kA938 + kC938) - kE938) - kE938) - kD938);
    tmp3_2 = kB938 - kG938;
    // Op 939: dim3x1 add
    gl64_t s1_939 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_939; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 940: dim3x3 mul
    gl64_t s1_940_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_940_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_940_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA940 = (tmp3_0 + tmp3_1) * (s1_940_0 + s1_940_1);
    gl64_t kB940 = (tmp3_0 + tmp3_2) * (s1_940_0 + s1_940_2);
    gl64_t kC940 = (tmp3_1 + tmp3_2) * (s1_940_1 + s1_940_2);
    gl64_t kD940 = tmp3_0 * s1_940_0;
    gl64_t kE940 = tmp3_1 * s1_940_1;
    gl64_t kF940 = tmp3_2 * s1_940_2;
    gl64_t kG940 = kD940 - kE940;
    tmp3_0 = (kC940 + kG940) - kF940;
    tmp3_1 = ((((kA940 + kC940) - kE940) - kE940) - kD940);
    tmp3_2 = kB940 - kG940;
    // Op 941: dim3x1 add
    gl64_t s1_941 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_941; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 942: dim3x3 mul
    gl64_t s1_942_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_942_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_942_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 943: dim3x1 add
    gl64_t s1_943 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_943; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 944: dim3x3 add
    gl64_t s1_944_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_944_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_944_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_944_0; tmp3_1 = tmp3_1 + s1_944_1; tmp3_2 = tmp3_2 + s1_944_2;
    // Op 945: dim3x3 mul
    gl64_t s1_945_0 = *(gl64_t*)&expressions_params[10][191];
    gl64_t s1_945_1 = *(gl64_t*)&expressions_params[10][191+1];
    gl64_t s1_945_2 = *(gl64_t*)&expressions_params[10][191+2];
    gl64_t kA945 = (tmp3_0 + tmp3_1) * (s1_945_0 + s1_945_1);
    gl64_t kB945 = (tmp3_0 + tmp3_2) * (s1_945_0 + s1_945_2);
    gl64_t kC945 = (tmp3_1 + tmp3_2) * (s1_945_1 + s1_945_2);
    gl64_t kD945 = tmp3_0 * s1_945_0;
    gl64_t kE945 = tmp3_1 * s1_945_1;
    gl64_t kF945 = tmp3_2 * s1_945_2;
    gl64_t kG945 = kD945 - kE945;
    tmp3_0 = (kC945 + kG945) - kF945;
    tmp3_1 = ((((kA945 + kC945) - kE945) - kE945) - kD945);
    tmp3_2 = kB945 - kG945;
    // Op 946: dim3x1 sub
    gl64_t s1_946 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_946; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 947: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 948: dim3x3 mul
    gl64_t s1_948_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_948_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_948_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA948 = (tmp3_0 + tmp3_1) * (s1_948_0 + s1_948_1);
    gl64_t kB948 = (tmp3_0 + tmp3_2) * (s1_948_0 + s1_948_2);
    gl64_t kC948 = (tmp3_1 + tmp3_2) * (s1_948_1 + s1_948_2);
    gl64_t kD948 = tmp3_0 * s1_948_0;
    gl64_t kE948 = tmp3_1 * s1_948_1;
    gl64_t kF948 = tmp3_2 * s1_948_2;
    gl64_t kG948 = kD948 - kE948;
    tmp3_6 = (kC948 + kG948) - kF948;
    tmp3_7 = ((((kA948 + kC948) - kE948) - kE948) - kD948);
    tmp3_8 = kB948 - kG948;
    // Op 949: dim3x1 mul
    gl64_t s0_949_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_949_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_949_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_949 = *(gl64_t*)&expressions_params[10][27];
    tmp3_0 = s0_949_0 * s1_949; tmp3_1 = s0_949_1 * s1_949; tmp3_2 = s0_949_2 * s1_949;
    // Op 950: dim3x1 add
    gl64_t s1_950 = *(gl64_t*)&expressions_params[10][26];
    tmp3_0 = tmp3_0 + s1_950; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 951: dim3x3 mul
    gl64_t s1_951_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_951_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_951_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA951 = (tmp3_0 + tmp3_1) * (s1_951_0 + s1_951_1);
    gl64_t kB951 = (tmp3_0 + tmp3_2) * (s1_951_0 + s1_951_2);
    gl64_t kC951 = (tmp3_1 + tmp3_2) * (s1_951_1 + s1_951_2);
    gl64_t kD951 = tmp3_0 * s1_951_0;
    gl64_t kE951 = tmp3_1 * s1_951_1;
    gl64_t kF951 = tmp3_2 * s1_951_2;
    gl64_t kG951 = kD951 - kE951;
    tmp3_0 = (kC951 + kG951) - kF951;
    tmp3_1 = ((((kA951 + kC951) - kE951) - kE951) - kD951);
    tmp3_2 = kB951 - kG951;
    // Op 952: dim3x1 add
    gl64_t s1_952 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_952; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 953: dim3x3 mul
    gl64_t s1_953_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_953_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_953_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA953 = (tmp3_0 + tmp3_1) * (s1_953_0 + s1_953_1);
    gl64_t kB953 = (tmp3_0 + tmp3_2) * (s1_953_0 + s1_953_2);
    gl64_t kC953 = (tmp3_1 + tmp3_2) * (s1_953_1 + s1_953_2);
    gl64_t kD953 = tmp3_0 * s1_953_0;
    gl64_t kE953 = tmp3_1 * s1_953_1;
    gl64_t kF953 = tmp3_2 * s1_953_2;
    gl64_t kG953 = kD953 - kE953;
    tmp3_0 = (kC953 + kG953) - kF953;
    tmp3_1 = ((((kA953 + kC953) - kE953) - kE953) - kD953);
    tmp3_2 = kB953 - kG953;
    // Op 954: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 955: dim3x3 mul
    gl64_t s1_955_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_955_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_955_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA955 = (tmp3_0 + tmp3_1) * (s1_955_0 + s1_955_1);
    gl64_t kB955 = (tmp3_0 + tmp3_2) * (s1_955_0 + s1_955_2);
    gl64_t kC955 = (tmp3_1 + tmp3_2) * (s1_955_1 + s1_955_2);
    gl64_t kD955 = tmp3_0 * s1_955_0;
    gl64_t kE955 = tmp3_1 * s1_955_1;
    gl64_t kF955 = tmp3_2 * s1_955_2;
    gl64_t kG955 = kD955 - kE955;
    tmp3_0 = (kC955 + kG955) - kF955;
    tmp3_1 = ((((kA955 + kC955) - kE955) - kE955) - kD955);
    tmp3_2 = kB955 - kG955;
    // Op 956: dim3x1 add
    gl64_t s1_956 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_956; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 957: dim3x3 mul
    gl64_t s1_957_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_957_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_957_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA957 = (tmp3_0 + tmp3_1) * (s1_957_0 + s1_957_1);
    gl64_t kB957 = (tmp3_0 + tmp3_2) * (s1_957_0 + s1_957_2);
    gl64_t kC957 = (tmp3_1 + tmp3_2) * (s1_957_1 + s1_957_2);
    gl64_t kD957 = tmp3_0 * s1_957_0;
    gl64_t kE957 = tmp3_1 * s1_957_1;
    gl64_t kF957 = tmp3_2 * s1_957_2;
    gl64_t kG957 = kD957 - kE957;
    tmp3_0 = (kC957 + kG957) - kF957;
    tmp3_1 = ((((kA957 + kC957) - kE957) - kE957) - kD957);
    tmp3_2 = kB957 - kG957;
    // Op 958: dim3x1 add
    gl64_t s1_958 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_958; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 959: dim3x3 mul
    gl64_t s1_959_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_959_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_959_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 960: dim3x1 add
    gl64_t s1_960 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_960; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 961: dim3x3 add
    gl64_t s1_961_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_961_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_961_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_961_0; tmp3_1 = tmp3_1 + s1_961_1; tmp3_2 = tmp3_2 + s1_961_2;
    // Op 962: dim3x3 mul
    gl64_t s1_962_0 = *(gl64_t*)&expressions_params[10][194];
    gl64_t s1_962_1 = *(gl64_t*)&expressions_params[10][194+1];
    gl64_t s1_962_2 = *(gl64_t*)&expressions_params[10][194+2];
    gl64_t kA962 = (tmp3_0 + tmp3_1) * (s1_962_0 + s1_962_1);
    gl64_t kB962 = (tmp3_0 + tmp3_2) * (s1_962_0 + s1_962_2);
    gl64_t kC962 = (tmp3_1 + tmp3_2) * (s1_962_1 + s1_962_2);
    gl64_t kD962 = tmp3_0 * s1_962_0;
    gl64_t kE962 = tmp3_1 * s1_962_1;
    gl64_t kF962 = tmp3_2 * s1_962_2;
    gl64_t kG962 = kD962 - kE962;
    tmp3_0 = (kC962 + kG962) - kF962;
    tmp3_1 = ((((kA962 + kC962) - kE962) - kE962) - kD962);
    tmp3_2 = kB962 - kG962;
    // Op 963: dim1x1 sub
    gl64_t s0_963 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_963 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_963 - s1_963;
    // Op 964: dim1x1 sub_swap
    gl64_t s1_964 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_964 - tmp1_0;
    // Op 965: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 966: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 967: dim3x3 mul
    gl64_t s1_967_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_967_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_967_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA967 = (tmp3_0 + tmp3_1) * (s1_967_0 + s1_967_1);
    gl64_t kB967 = (tmp3_0 + tmp3_2) * (s1_967_0 + s1_967_2);
    gl64_t kC967 = (tmp3_1 + tmp3_2) * (s1_967_1 + s1_967_2);
    gl64_t kD967 = tmp3_0 * s1_967_0;
    gl64_t kE967 = tmp3_1 * s1_967_1;
    gl64_t kF967 = tmp3_2 * s1_967_2;
    gl64_t kG967 = kD967 - kE967;
    tmp3_6 = (kC967 + kG967) - kF967;
    tmp3_7 = ((((kA967 + kC967) - kE967) - kE967) - kD967);
    tmp3_8 = kB967 - kG967;
    // Op 968: dim1x1 sub
    gl64_t s1_968 = *(gl64_t*)&expressions_params[10][80];
    tmp1_0 = tmp1_4 - s1_968;
    // Op 969: dim1x1 sub
    gl64_t s1_969 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_969;
    // Op 970: dim3x1 mul
    gl64_t s0_970_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_970_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_970_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_970_0 * tmp1_0; tmp3_1 = s0_970_1 * tmp1_0; tmp3_2 = s0_970_2 * tmp1_0;
    // Op 971: dim3x1 add
    gl64_t s1_971 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_971; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 972: dim3x3 add
    gl64_t s1_972_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_972_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_972_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_972_0; tmp3_1 = tmp3_1 + s1_972_1; tmp3_2 = tmp3_2 + s1_972_2;
    // Op 973: dim3x3 mul
    gl64_t s1_973_0 = *(gl64_t*)&expressions_params[10][197];
    gl64_t s1_973_1 = *(gl64_t*)&expressions_params[10][197+1];
    gl64_t s1_973_2 = *(gl64_t*)&expressions_params[10][197+2];
    gl64_t kA973 = (tmp3_0 + tmp3_1) * (s1_973_0 + s1_973_1);
    gl64_t kB973 = (tmp3_0 + tmp3_2) * (s1_973_0 + s1_973_2);
    gl64_t kC973 = (tmp3_1 + tmp3_2) * (s1_973_1 + s1_973_2);
    gl64_t kD973 = tmp3_0 * s1_973_0;
    gl64_t kE973 = tmp3_1 * s1_973_1;
    gl64_t kF973 = tmp3_2 * s1_973_2;
    gl64_t kG973 = kD973 - kE973;
    tmp3_0 = (kC973 + kG973) - kF973;
    tmp3_1 = ((((kA973 + kC973) - kE973) - kE973) - kD973);
    tmp3_2 = kB973 - kG973;
    // Op 974: dim3x1 add
    gl64_t s1_974 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_974; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 975: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 976: dim3x3 mul
    gl64_t s1_976_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_976_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_976_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA976 = (tmp3_0 + tmp3_1) * (s1_976_0 + s1_976_1);
    gl64_t kB976 = (tmp3_0 + tmp3_2) * (s1_976_0 + s1_976_2);
    gl64_t kC976 = (tmp3_1 + tmp3_2) * (s1_976_1 + s1_976_2);
    gl64_t kD976 = tmp3_0 * s1_976_0;
    gl64_t kE976 = tmp3_1 * s1_976_1;
    gl64_t kF976 = tmp3_2 * s1_976_2;
    gl64_t kG976 = kD976 - kE976;
    tmp3_6 = (kC976 + kG976) - kF976;
    tmp3_7 = ((((kA976 + kC976) - kE976) - kE976) - kD976);
    tmp3_8 = kB976 - kG976;
    // Op 977: dim3x1 mul
    gl64_t s0_977_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_977_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_977_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_977 = *(gl64_t*)&expressions_params[10][29];
    tmp3_0 = s0_977_0 * s1_977; tmp3_1 = s0_977_1 * s1_977; tmp3_2 = s0_977_2 * s1_977;
    // Op 978: dim3x1 add
    gl64_t s1_978 = *(gl64_t*)&expressions_params[10][28];
    tmp3_0 = tmp3_0 + s1_978; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 979: dim3x3 mul
    gl64_t s1_979_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_979_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_979_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA979 = (tmp3_0 + tmp3_1) * (s1_979_0 + s1_979_1);
    gl64_t kB979 = (tmp3_0 + tmp3_2) * (s1_979_0 + s1_979_2);
    gl64_t kC979 = (tmp3_1 + tmp3_2) * (s1_979_1 + s1_979_2);
    gl64_t kD979 = tmp3_0 * s1_979_0;
    gl64_t kE979 = tmp3_1 * s1_979_1;
    gl64_t kF979 = tmp3_2 * s1_979_2;
    gl64_t kG979 = kD979 - kE979;
    tmp3_0 = (kC979 + kG979) - kF979;
    tmp3_1 = ((((kA979 + kC979) - kE979) - kE979) - kD979);
    tmp3_2 = kB979 - kG979;
    // Op 980: dim3x1 add
    gl64_t s1_980 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_980; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 981: dim3x3 mul
    gl64_t s1_981_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_981_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_981_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA981 = (tmp3_0 + tmp3_1) * (s1_981_0 + s1_981_1);
    gl64_t kB981 = (tmp3_0 + tmp3_2) * (s1_981_0 + s1_981_2);
    gl64_t kC981 = (tmp3_1 + tmp3_2) * (s1_981_1 + s1_981_2);
    gl64_t kD981 = tmp3_0 * s1_981_0;
    gl64_t kE981 = tmp3_1 * s1_981_1;
    gl64_t kF981 = tmp3_2 * s1_981_2;
    gl64_t kG981 = kD981 - kE981;
    tmp3_0 = (kC981 + kG981) - kF981;
    tmp3_1 = ((((kA981 + kC981) - kE981) - kE981) - kD981);
    tmp3_2 = kB981 - kG981;
    // Op 982: dim3x1 add
    gl64_t s1_982 = *(gl64_t*)&expressions_params[10][80];
    tmp3_0 = tmp3_0 + s1_982; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 983: dim3x3 mul
    gl64_t s1_983_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_983_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_983_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA983 = (tmp3_0 + tmp3_1) * (s1_983_0 + s1_983_1);
    gl64_t kB983 = (tmp3_0 + tmp3_2) * (s1_983_0 + s1_983_2);
    gl64_t kC983 = (tmp3_1 + tmp3_2) * (s1_983_1 + s1_983_2);
    gl64_t kD983 = tmp3_0 * s1_983_0;
    gl64_t kE983 = tmp3_1 * s1_983_1;
    gl64_t kF983 = tmp3_2 * s1_983_2;
    gl64_t kG983 = kD983 - kE983;
    tmp3_0 = (kC983 + kG983) - kF983;
    tmp3_1 = ((((kA983 + kC983) - kE983) - kE983) - kD983);
    tmp3_2 = kB983 - kG983;
    // Op 984: dim3x1 add
    gl64_t s1_984 = *(gl64_t*)&expressions_params[9][28];
    tmp3_0 = tmp3_0 + s1_984; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 985: dim3x3 mul
    gl64_t s1_985_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_985_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_985_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA985 = (tmp3_0 + tmp3_1) * (s1_985_0 + s1_985_1);
    gl64_t kB985 = (tmp3_0 + tmp3_2) * (s1_985_0 + s1_985_2);
    gl64_t kC985 = (tmp3_1 + tmp3_2) * (s1_985_1 + s1_985_2);
    gl64_t kD985 = tmp3_0 * s1_985_0;
    gl64_t kE985 = tmp3_1 * s1_985_1;
    gl64_t kF985 = tmp3_2 * s1_985_2;
    gl64_t kG985 = kD985 - kE985;
    tmp3_0 = (kC985 + kG985) - kF985;
    tmp3_1 = ((((kA985 + kC985) - kE985) - kE985) - kD985);
    tmp3_2 = kB985 - kG985;
    // Op 986: dim3x1 add
    gl64_t s1_986 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_986; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 987: dim3x3 mul
    gl64_t s1_987_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_987_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_987_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 988: dim3x1 add
    gl64_t s1_988 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_988; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 989: dim3x3 add
    gl64_t s1_989_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_989_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_989_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_989_0; tmp3_1 = tmp3_1 + s1_989_1; tmp3_2 = tmp3_2 + s1_989_2;
    // Op 990: dim3x3 mul
    gl64_t s1_990_0 = *(gl64_t*)&expressions_params[10][200];
    gl64_t s1_990_1 = *(gl64_t*)&expressions_params[10][200+1];
    gl64_t s1_990_2 = *(gl64_t*)&expressions_params[10][200+2];
    gl64_t kA990 = (tmp3_0 + tmp3_1) * (s1_990_0 + s1_990_1);
    gl64_t kB990 = (tmp3_0 + tmp3_2) * (s1_990_0 + s1_990_2);
    gl64_t kC990 = (tmp3_1 + tmp3_2) * (s1_990_1 + s1_990_2);
    gl64_t kD990 = tmp3_0 * s1_990_0;
    gl64_t kE990 = tmp3_1 * s1_990_1;
    gl64_t kF990 = tmp3_2 * s1_990_2;
    gl64_t kG990 = kD990 - kE990;
    tmp3_0 = (kC990 + kG990) - kF990;
    tmp3_1 = ((((kA990 + kC990) - kE990) - kE990) - kD990);
    tmp3_2 = kB990 - kG990;
    // Op 991: dim3x1 sub
    gl64_t s1_991 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_991; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 992: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 993: dim3x3 mul
    gl64_t s1_993_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_993_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_993_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA993 = (tmp3_0 + tmp3_1) * (s1_993_0 + s1_993_1);
    gl64_t kB993 = (tmp3_0 + tmp3_2) * (s1_993_0 + s1_993_2);
    gl64_t kC993 = (tmp3_1 + tmp3_2) * (s1_993_1 + s1_993_2);
    gl64_t kD993 = tmp3_0 * s1_993_0;
    gl64_t kE993 = tmp3_1 * s1_993_1;
    gl64_t kF993 = tmp3_2 * s1_993_2;
    gl64_t kG993 = kD993 - kE993;
    tmp3_6 = (kC993 + kG993) - kF993;
    tmp3_7 = ((((kA993 + kC993) - kE993) - kE993) - kD993);
    tmp3_8 = kB993 - kG993;
    // Op 994: dim3x1 mul
    gl64_t s0_994_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_994_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_994_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_994 = *(gl64_t*)&expressions_params[10][29];
    tmp3_0 = s0_994_0 * s1_994; tmp3_1 = s0_994_1 * s1_994; tmp3_2 = s0_994_2 * s1_994;
    // Op 995: dim3x1 add
    gl64_t s1_995 = *(gl64_t*)&expressions_params[10][28];
    tmp3_0 = tmp3_0 + s1_995; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 996: dim3x3 mul
    gl64_t s1_996_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_996_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_996_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA996 = (tmp3_0 + tmp3_1) * (s1_996_0 + s1_996_1);
    gl64_t kB996 = (tmp3_0 + tmp3_2) * (s1_996_0 + s1_996_2);
    gl64_t kC996 = (tmp3_1 + tmp3_2) * (s1_996_1 + s1_996_2);
    gl64_t kD996 = tmp3_0 * s1_996_0;
    gl64_t kE996 = tmp3_1 * s1_996_1;
    gl64_t kF996 = tmp3_2 * s1_996_2;
    gl64_t kG996 = kD996 - kE996;
    tmp3_0 = (kC996 + kG996) - kF996;
    tmp3_1 = ((((kA996 + kC996) - kE996) - kE996) - kD996);
    tmp3_2 = kB996 - kG996;
    // Op 997: dim3x1 add
    gl64_t s1_997 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_997; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 998: dim3x3 mul
    gl64_t s1_998_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_998_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_998_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA998 = (tmp3_0 + tmp3_1) * (s1_998_0 + s1_998_1);
    gl64_t kB998 = (tmp3_0 + tmp3_2) * (s1_998_0 + s1_998_2);
    gl64_t kC998 = (tmp3_1 + tmp3_2) * (s1_998_1 + s1_998_2);
    gl64_t kD998 = tmp3_0 * s1_998_0;
    gl64_t kE998 = tmp3_1 * s1_998_1;
    gl64_t kF998 = tmp3_2 * s1_998_2;
    gl64_t kG998 = kD998 - kE998;
    tmp3_0 = (kC998 + kG998) - kF998;
    tmp3_1 = ((((kA998 + kC998) - kE998) - kE998) - kD998);
    tmp3_2 = kB998 - kG998;
    // Op 999: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1000: dim3x3 mul
    gl64_t s1_1000_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1000_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1000_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1000 = (tmp3_0 + tmp3_1) * (s1_1000_0 + s1_1000_1);
    gl64_t kB1000 = (tmp3_0 + tmp3_2) * (s1_1000_0 + s1_1000_2);
    gl64_t kC1000 = (tmp3_1 + tmp3_2) * (s1_1000_1 + s1_1000_2);
    gl64_t kD1000 = tmp3_0 * s1_1000_0;
    gl64_t kE1000 = tmp3_1 * s1_1000_1;
    gl64_t kF1000 = tmp3_2 * s1_1000_2;
    gl64_t kG1000 = kD1000 - kE1000;
    tmp3_0 = (kC1000 + kG1000) - kF1000;
    tmp3_1 = ((((kA1000 + kC1000) - kE1000) - kE1000) - kD1000);
    tmp3_2 = kB1000 - kG1000;
    // Op 1001: dim3x1 add
    gl64_t s1_1001 = *(gl64_t*)&expressions_params[9][28];
    tmp3_0 = tmp3_0 + s1_1001; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1002: dim3x3 mul
    gl64_t s1_1002_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1002_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1002_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1002 = (tmp3_0 + tmp3_1) * (s1_1002_0 + s1_1002_1);
    gl64_t kB1002 = (tmp3_0 + tmp3_2) * (s1_1002_0 + s1_1002_2);
    gl64_t kC1002 = (tmp3_1 + tmp3_2) * (s1_1002_1 + s1_1002_2);
    gl64_t kD1002 = tmp3_0 * s1_1002_0;
    gl64_t kE1002 = tmp3_1 * s1_1002_1;
    gl64_t kF1002 = tmp3_2 * s1_1002_2;
    gl64_t kG1002 = kD1002 - kE1002;
    tmp3_0 = (kC1002 + kG1002) - kF1002;
    tmp3_1 = ((((kA1002 + kC1002) - kE1002) - kE1002) - kD1002);
    tmp3_2 = kB1002 - kG1002;
    // Op 1003: dim3x1 add
    gl64_t s1_1003 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1003; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1004: dim3x3 mul
    gl64_t s1_1004_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1004_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1004_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1005: dim3x1 add
    gl64_t s1_1005 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1005; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1006: dim3x3 add
    gl64_t s1_1006_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1006_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1006_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1006_0; tmp3_1 = tmp3_1 + s1_1006_1; tmp3_2 = tmp3_2 + s1_1006_2;
    // Op 1007: dim3x3 mul
    gl64_t s1_1007_0 = *(gl64_t*)&expressions_params[10][203];
    gl64_t s1_1007_1 = *(gl64_t*)&expressions_params[10][203+1];
    gl64_t s1_1007_2 = *(gl64_t*)&expressions_params[10][203+2];
    gl64_t kA1007 = (tmp3_0 + tmp3_1) * (s1_1007_0 + s1_1007_1);
    gl64_t kB1007 = (tmp3_0 + tmp3_2) * (s1_1007_0 + s1_1007_2);
    gl64_t kC1007 = (tmp3_1 + tmp3_2) * (s1_1007_1 + s1_1007_2);
    gl64_t kD1007 = tmp3_0 * s1_1007_0;
    gl64_t kE1007 = tmp3_1 * s1_1007_1;
    gl64_t kF1007 = tmp3_2 * s1_1007_2;
    gl64_t kG1007 = kD1007 - kE1007;
    tmp3_0 = (kC1007 + kG1007) - kF1007;
    tmp3_1 = ((((kA1007 + kC1007) - kE1007) - kE1007) - kD1007);
    tmp3_2 = kB1007 - kG1007;
    // Op 1008: dim1x1 sub
    gl64_t s0_1008 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1008 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1008 - s1_1008;
    // Op 1009: dim1x1 sub_swap
    gl64_t s1_1009 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1009 - tmp1_0;
    // Op 1010: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1011: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1012: dim3x3 mul
    gl64_t s1_1012_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1012_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1012_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1012 = (tmp3_0 + tmp3_1) * (s1_1012_0 + s1_1012_1);
    gl64_t kB1012 = (tmp3_0 + tmp3_2) * (s1_1012_0 + s1_1012_2);
    gl64_t kC1012 = (tmp3_1 + tmp3_2) * (s1_1012_1 + s1_1012_2);
    gl64_t kD1012 = tmp3_0 * s1_1012_0;
    gl64_t kE1012 = tmp3_1 * s1_1012_1;
    gl64_t kF1012 = tmp3_2 * s1_1012_2;
    gl64_t kG1012 = kD1012 - kE1012;
    tmp3_6 = (kC1012 + kG1012) - kF1012;
    tmp3_7 = ((((kA1012 + kC1012) - kE1012) - kE1012) - kD1012);
    tmp3_8 = kB1012 - kG1012;
    // Op 1013: dim1x1 sub
    gl64_t s1_1013 = *(gl64_t*)&expressions_params[10][81];
    tmp1_0 = tmp1_4 - s1_1013;
    // Op 1014: dim1x1 sub
    gl64_t s1_1014 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1014;
    // Op 1015: dim3x1 mul
    gl64_t s0_1015_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1015_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1015_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1015_0 * tmp1_0; tmp3_1 = s0_1015_1 * tmp1_0; tmp3_2 = s0_1015_2 * tmp1_0;
    // Op 1016: dim3x1 add
    gl64_t s1_1016 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1016; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1017: dim3x3 add
    gl64_t s1_1017_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1017_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1017_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1017_0; tmp3_1 = tmp3_1 + s1_1017_1; tmp3_2 = tmp3_2 + s1_1017_2;
    // Op 1018: dim3x3 mul
    gl64_t s1_1018_0 = *(gl64_t*)&expressions_params[10][206];
    gl64_t s1_1018_1 = *(gl64_t*)&expressions_params[10][206+1];
    gl64_t s1_1018_2 = *(gl64_t*)&expressions_params[10][206+2];
    gl64_t kA1018 = (tmp3_0 + tmp3_1) * (s1_1018_0 + s1_1018_1);
    gl64_t kB1018 = (tmp3_0 + tmp3_2) * (s1_1018_0 + s1_1018_2);
    gl64_t kC1018 = (tmp3_1 + tmp3_2) * (s1_1018_1 + s1_1018_2);
    gl64_t kD1018 = tmp3_0 * s1_1018_0;
    gl64_t kE1018 = tmp3_1 * s1_1018_1;
    gl64_t kF1018 = tmp3_2 * s1_1018_2;
    gl64_t kG1018 = kD1018 - kE1018;
    tmp3_0 = (kC1018 + kG1018) - kF1018;
    tmp3_1 = ((((kA1018 + kC1018) - kE1018) - kE1018) - kD1018);
    tmp3_2 = kB1018 - kG1018;
    // Op 1019: dim3x1 add
    gl64_t s1_1019 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1019; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1020: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1021: dim3x3 mul
    gl64_t s1_1021_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1021_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1021_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1021 = (tmp3_0 + tmp3_1) * (s1_1021_0 + s1_1021_1);
    gl64_t kB1021 = (tmp3_0 + tmp3_2) * (s1_1021_0 + s1_1021_2);
    gl64_t kC1021 = (tmp3_1 + tmp3_2) * (s1_1021_1 + s1_1021_2);
    gl64_t kD1021 = tmp3_0 * s1_1021_0;
    gl64_t kE1021 = tmp3_1 * s1_1021_1;
    gl64_t kF1021 = tmp3_2 * s1_1021_2;
    gl64_t kG1021 = kD1021 - kE1021;
    tmp3_6 = (kC1021 + kG1021) - kF1021;
    tmp3_7 = ((((kA1021 + kC1021) - kE1021) - kE1021) - kD1021);
    tmp3_8 = kB1021 - kG1021;
    // Op 1022: dim3x1 mul
    gl64_t s0_1022_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1022_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1022_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1022 = *(gl64_t*)&expressions_params[10][31];
    tmp3_0 = s0_1022_0 * s1_1022; tmp3_1 = s0_1022_1 * s1_1022; tmp3_2 = s0_1022_2 * s1_1022;
    // Op 1023: dim3x1 add
    gl64_t s1_1023 = *(gl64_t*)&expressions_params[10][30];
    tmp3_0 = tmp3_0 + s1_1023; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1024: dim3x3 mul
    gl64_t s1_1024_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1024_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1024_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1024 = (tmp3_0 + tmp3_1) * (s1_1024_0 + s1_1024_1);
    gl64_t kB1024 = (tmp3_0 + tmp3_2) * (s1_1024_0 + s1_1024_2);
    gl64_t kC1024 = (tmp3_1 + tmp3_2) * (s1_1024_1 + s1_1024_2);
    gl64_t kD1024 = tmp3_0 * s1_1024_0;
    gl64_t kE1024 = tmp3_1 * s1_1024_1;
    gl64_t kF1024 = tmp3_2 * s1_1024_2;
    gl64_t kG1024 = kD1024 - kE1024;
    tmp3_0 = (kC1024 + kG1024) - kF1024;
    tmp3_1 = ((((kA1024 + kC1024) - kE1024) - kE1024) - kD1024);
    tmp3_2 = kB1024 - kG1024;
    // Op 1025: dim3x1 add
    gl64_t s1_1025 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1025; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1026: dim3x3 mul
    gl64_t s1_1026_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1026_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1026_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1026 = (tmp3_0 + tmp3_1) * (s1_1026_0 + s1_1026_1);
    gl64_t kB1026 = (tmp3_0 + tmp3_2) * (s1_1026_0 + s1_1026_2);
    gl64_t kC1026 = (tmp3_1 + tmp3_2) * (s1_1026_1 + s1_1026_2);
    gl64_t kD1026 = tmp3_0 * s1_1026_0;
    gl64_t kE1026 = tmp3_1 * s1_1026_1;
    gl64_t kF1026 = tmp3_2 * s1_1026_2;
    gl64_t kG1026 = kD1026 - kE1026;
    tmp3_0 = (kC1026 + kG1026) - kF1026;
    tmp3_1 = ((((kA1026 + kC1026) - kE1026) - kE1026) - kD1026);
    tmp3_2 = kB1026 - kG1026;
    // Op 1027: dim3x1 add
    gl64_t s1_1027 = *(gl64_t*)&expressions_params[10][81];
    tmp3_0 = tmp3_0 + s1_1027; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1028: dim3x3 mul
    gl64_t s1_1028_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1028_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1028_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1028 = (tmp3_0 + tmp3_1) * (s1_1028_0 + s1_1028_1);
    gl64_t kB1028 = (tmp3_0 + tmp3_2) * (s1_1028_0 + s1_1028_2);
    gl64_t kC1028 = (tmp3_1 + tmp3_2) * (s1_1028_1 + s1_1028_2);
    gl64_t kD1028 = tmp3_0 * s1_1028_0;
    gl64_t kE1028 = tmp3_1 * s1_1028_1;
    gl64_t kF1028 = tmp3_2 * s1_1028_2;
    gl64_t kG1028 = kD1028 - kE1028;
    tmp3_0 = (kC1028 + kG1028) - kF1028;
    tmp3_1 = ((((kA1028 + kC1028) - kE1028) - kE1028) - kD1028);
    tmp3_2 = kB1028 - kG1028;
    // Op 1029: dim3x1 add
    gl64_t s1_1029 = *(gl64_t*)&expressions_params[9][29];
    tmp3_0 = tmp3_0 + s1_1029; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1030: dim3x3 mul
    gl64_t s1_1030_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1030_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1030_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1030 = (tmp3_0 + tmp3_1) * (s1_1030_0 + s1_1030_1);
    gl64_t kB1030 = (tmp3_0 + tmp3_2) * (s1_1030_0 + s1_1030_2);
    gl64_t kC1030 = (tmp3_1 + tmp3_2) * (s1_1030_1 + s1_1030_2);
    gl64_t kD1030 = tmp3_0 * s1_1030_0;
    gl64_t kE1030 = tmp3_1 * s1_1030_1;
    gl64_t kF1030 = tmp3_2 * s1_1030_2;
    gl64_t kG1030 = kD1030 - kE1030;
    tmp3_0 = (kC1030 + kG1030) - kF1030;
    tmp3_1 = ((((kA1030 + kC1030) - kE1030) - kE1030) - kD1030);
    tmp3_2 = kB1030 - kG1030;
    // Op 1031: dim3x1 add
    gl64_t s1_1031 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1031; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1032: dim3x3 mul
    gl64_t s1_1032_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1032_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1032_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1033: dim3x1 add
    gl64_t s1_1033 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1033; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1034: dim3x3 add
    gl64_t s1_1034_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1034_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1034_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1034_0; tmp3_1 = tmp3_1 + s1_1034_1; tmp3_2 = tmp3_2 + s1_1034_2;
    // Op 1035: dim3x3 mul
    gl64_t s1_1035_0 = *(gl64_t*)&expressions_params[10][209];
    gl64_t s1_1035_1 = *(gl64_t*)&expressions_params[10][209+1];
    gl64_t s1_1035_2 = *(gl64_t*)&expressions_params[10][209+2];
    gl64_t kA1035 = (tmp3_0 + tmp3_1) * (s1_1035_0 + s1_1035_1);
    gl64_t kB1035 = (tmp3_0 + tmp3_2) * (s1_1035_0 + s1_1035_2);
    gl64_t kC1035 = (tmp3_1 + tmp3_2) * (s1_1035_1 + s1_1035_2);
    gl64_t kD1035 = tmp3_0 * s1_1035_0;
    gl64_t kE1035 = tmp3_1 * s1_1035_1;
    gl64_t kF1035 = tmp3_2 * s1_1035_2;
    gl64_t kG1035 = kD1035 - kE1035;
    tmp3_0 = (kC1035 + kG1035) - kF1035;
    tmp3_1 = ((((kA1035 + kC1035) - kE1035) - kE1035) - kD1035);
    tmp3_2 = kB1035 - kG1035;
    // Op 1036: dim3x1 sub
    gl64_t s1_1036 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1036; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1037: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1038: dim3x3 mul
    gl64_t s1_1038_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1038_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1038_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1038 = (tmp3_0 + tmp3_1) * (s1_1038_0 + s1_1038_1);
    gl64_t kB1038 = (tmp3_0 + tmp3_2) * (s1_1038_0 + s1_1038_2);
    gl64_t kC1038 = (tmp3_1 + tmp3_2) * (s1_1038_1 + s1_1038_2);
    gl64_t kD1038 = tmp3_0 * s1_1038_0;
    gl64_t kE1038 = tmp3_1 * s1_1038_1;
    gl64_t kF1038 = tmp3_2 * s1_1038_2;
    gl64_t kG1038 = kD1038 - kE1038;
    tmp3_6 = (kC1038 + kG1038) - kF1038;
    tmp3_7 = ((((kA1038 + kC1038) - kE1038) - kE1038) - kD1038);
    tmp3_8 = kB1038 - kG1038;
    // Op 1039: dim3x1 mul
    gl64_t s0_1039_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1039_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1039_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1039 = *(gl64_t*)&expressions_params[10][31];
    tmp3_0 = s0_1039_0 * s1_1039; tmp3_1 = s0_1039_1 * s1_1039; tmp3_2 = s0_1039_2 * s1_1039;
    // Op 1040: dim3x1 add
    gl64_t s1_1040 = *(gl64_t*)&expressions_params[10][30];
    tmp3_0 = tmp3_0 + s1_1040; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1041: dim3x3 mul
    gl64_t s1_1041_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1041_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1041_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1041 = (tmp3_0 + tmp3_1) * (s1_1041_0 + s1_1041_1);
    gl64_t kB1041 = (tmp3_0 + tmp3_2) * (s1_1041_0 + s1_1041_2);
    gl64_t kC1041 = (tmp3_1 + tmp3_2) * (s1_1041_1 + s1_1041_2);
    gl64_t kD1041 = tmp3_0 * s1_1041_0;
    gl64_t kE1041 = tmp3_1 * s1_1041_1;
    gl64_t kF1041 = tmp3_2 * s1_1041_2;
    gl64_t kG1041 = kD1041 - kE1041;
    tmp3_0 = (kC1041 + kG1041) - kF1041;
    tmp3_1 = ((((kA1041 + kC1041) - kE1041) - kE1041) - kD1041);
    tmp3_2 = kB1041 - kG1041;
    // Op 1042: dim3x1 add
    gl64_t s1_1042 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1042; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1043: dim3x3 mul
    gl64_t s1_1043_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1043_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1043_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1043 = (tmp3_0 + tmp3_1) * (s1_1043_0 + s1_1043_1);
    gl64_t kB1043 = (tmp3_0 + tmp3_2) * (s1_1043_0 + s1_1043_2);
    gl64_t kC1043 = (tmp3_1 + tmp3_2) * (s1_1043_1 + s1_1043_2);
    gl64_t kD1043 = tmp3_0 * s1_1043_0;
    gl64_t kE1043 = tmp3_1 * s1_1043_1;
    gl64_t kF1043 = tmp3_2 * s1_1043_2;
    gl64_t kG1043 = kD1043 - kE1043;
    tmp3_0 = (kC1043 + kG1043) - kF1043;
    tmp3_1 = ((((kA1043 + kC1043) - kE1043) - kE1043) - kD1043);
    tmp3_2 = kB1043 - kG1043;
    // Op 1044: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1045: dim3x3 mul
    gl64_t s1_1045_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1045_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1045_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1045 = (tmp3_0 + tmp3_1) * (s1_1045_0 + s1_1045_1);
    gl64_t kB1045 = (tmp3_0 + tmp3_2) * (s1_1045_0 + s1_1045_2);
    gl64_t kC1045 = (tmp3_1 + tmp3_2) * (s1_1045_1 + s1_1045_2);
    gl64_t kD1045 = tmp3_0 * s1_1045_0;
    gl64_t kE1045 = tmp3_1 * s1_1045_1;
    gl64_t kF1045 = tmp3_2 * s1_1045_2;
    gl64_t kG1045 = kD1045 - kE1045;
    tmp3_0 = (kC1045 + kG1045) - kF1045;
    tmp3_1 = ((((kA1045 + kC1045) - kE1045) - kE1045) - kD1045);
    tmp3_2 = kB1045 - kG1045;
    // Op 1046: dim3x1 add
    gl64_t s1_1046 = *(gl64_t*)&expressions_params[9][29];
    tmp3_0 = tmp3_0 + s1_1046; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1047: dim3x3 mul
    gl64_t s1_1047_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1047_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1047_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1047 = (tmp3_0 + tmp3_1) * (s1_1047_0 + s1_1047_1);
    gl64_t kB1047 = (tmp3_0 + tmp3_2) * (s1_1047_0 + s1_1047_2);
    gl64_t kC1047 = (tmp3_1 + tmp3_2) * (s1_1047_1 + s1_1047_2);
    gl64_t kD1047 = tmp3_0 * s1_1047_0;
    gl64_t kE1047 = tmp3_1 * s1_1047_1;
    gl64_t kF1047 = tmp3_2 * s1_1047_2;
    gl64_t kG1047 = kD1047 - kE1047;
    tmp3_0 = (kC1047 + kG1047) - kF1047;
    tmp3_1 = ((((kA1047 + kC1047) - kE1047) - kE1047) - kD1047);
    tmp3_2 = kB1047 - kG1047;
    // Op 1048: dim3x1 add
    gl64_t s1_1048 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1048; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1049: dim3x3 mul
    gl64_t s1_1049_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1049_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1049_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1050: dim3x1 add
    gl64_t s1_1050 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1050; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1051: dim3x3 add
    gl64_t s1_1051_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1051_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1051_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1051_0; tmp3_1 = tmp3_1 + s1_1051_1; tmp3_2 = tmp3_2 + s1_1051_2;
    // Op 1052: dim3x3 mul
    gl64_t s1_1052_0 = *(gl64_t*)&expressions_params[10][212];
    gl64_t s1_1052_1 = *(gl64_t*)&expressions_params[10][212+1];
    gl64_t s1_1052_2 = *(gl64_t*)&expressions_params[10][212+2];
    gl64_t kA1052 = (tmp3_0 + tmp3_1) * (s1_1052_0 + s1_1052_1);
    gl64_t kB1052 = (tmp3_0 + tmp3_2) * (s1_1052_0 + s1_1052_2);
    gl64_t kC1052 = (tmp3_1 + tmp3_2) * (s1_1052_1 + s1_1052_2);
    gl64_t kD1052 = tmp3_0 * s1_1052_0;
    gl64_t kE1052 = tmp3_1 * s1_1052_1;
    gl64_t kF1052 = tmp3_2 * s1_1052_2;
    gl64_t kG1052 = kD1052 - kE1052;
    tmp3_0 = (kC1052 + kG1052) - kF1052;
    tmp3_1 = ((((kA1052 + kC1052) - kE1052) - kE1052) - kD1052);
    tmp3_2 = kB1052 - kG1052;
    // Op 1053: dim1x1 sub
    gl64_t s0_1053 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1053 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1053 - s1_1053;
    // Op 1054: dim1x1 sub_swap
    gl64_t s1_1054 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1054 - tmp1_0;
    // Op 1055: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1056: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1057: dim3x3 mul
    gl64_t s1_1057_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1057_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1057_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1057 = (tmp3_0 + tmp3_1) * (s1_1057_0 + s1_1057_1);
    gl64_t kB1057 = (tmp3_0 + tmp3_2) * (s1_1057_0 + s1_1057_2);
    gl64_t kC1057 = (tmp3_1 + tmp3_2) * (s1_1057_1 + s1_1057_2);
    gl64_t kD1057 = tmp3_0 * s1_1057_0;
    gl64_t kE1057 = tmp3_1 * s1_1057_1;
    gl64_t kF1057 = tmp3_2 * s1_1057_2;
    gl64_t kG1057 = kD1057 - kE1057;
    tmp3_6 = (kC1057 + kG1057) - kF1057;
    tmp3_7 = ((((kA1057 + kC1057) - kE1057) - kE1057) - kD1057);
    tmp3_8 = kB1057 - kG1057;
    // Op 1058: dim1x1 sub
    gl64_t s1_1058 = *(gl64_t*)&expressions_params[10][82];
    tmp1_0 = tmp1_4 - s1_1058;
    // Op 1059: dim1x1 sub
    gl64_t s1_1059 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1059;
    // Op 1060: dim3x1 mul
    gl64_t s0_1060_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1060_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1060_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1060_0 * tmp1_0; tmp3_1 = s0_1060_1 * tmp1_0; tmp3_2 = s0_1060_2 * tmp1_0;
    // Op 1061: dim3x1 add
    gl64_t s1_1061 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1061; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1062: dim3x3 add
    gl64_t s1_1062_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1062_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1062_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1062_0; tmp3_1 = tmp3_1 + s1_1062_1; tmp3_2 = tmp3_2 + s1_1062_2;
    // Op 1063: dim3x3 mul
    gl64_t s1_1063_0 = *(gl64_t*)&expressions_params[10][215];
    gl64_t s1_1063_1 = *(gl64_t*)&expressions_params[10][215+1];
    gl64_t s1_1063_2 = *(gl64_t*)&expressions_params[10][215+2];
    gl64_t kA1063 = (tmp3_0 + tmp3_1) * (s1_1063_0 + s1_1063_1);
    gl64_t kB1063 = (tmp3_0 + tmp3_2) * (s1_1063_0 + s1_1063_2);
    gl64_t kC1063 = (tmp3_1 + tmp3_2) * (s1_1063_1 + s1_1063_2);
    gl64_t kD1063 = tmp3_0 * s1_1063_0;
    gl64_t kE1063 = tmp3_1 * s1_1063_1;
    gl64_t kF1063 = tmp3_2 * s1_1063_2;
    gl64_t kG1063 = kD1063 - kE1063;
    tmp3_0 = (kC1063 + kG1063) - kF1063;
    tmp3_1 = ((((kA1063 + kC1063) - kE1063) - kE1063) - kD1063);
    tmp3_2 = kB1063 - kG1063;
    // Op 1064: dim3x1 add
    gl64_t s1_1064 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1064; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1065: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1066: dim3x3 mul
    gl64_t s1_1066_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1066_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1066_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1066 = (tmp3_0 + tmp3_1) * (s1_1066_0 + s1_1066_1);
    gl64_t kB1066 = (tmp3_0 + tmp3_2) * (s1_1066_0 + s1_1066_2);
    gl64_t kC1066 = (tmp3_1 + tmp3_2) * (s1_1066_1 + s1_1066_2);
    gl64_t kD1066 = tmp3_0 * s1_1066_0;
    gl64_t kE1066 = tmp3_1 * s1_1066_1;
    gl64_t kF1066 = tmp3_2 * s1_1066_2;
    gl64_t kG1066 = kD1066 - kE1066;
    tmp3_6 = (kC1066 + kG1066) - kF1066;
    tmp3_7 = ((((kA1066 + kC1066) - kE1066) - kE1066) - kD1066);
    tmp3_8 = kB1066 - kG1066;
    // Op 1067: dim3x1 mul
    gl64_t s0_1067_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1067_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1067_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1067 = *(gl64_t*)&expressions_params[10][33];
    tmp3_0 = s0_1067_0 * s1_1067; tmp3_1 = s0_1067_1 * s1_1067; tmp3_2 = s0_1067_2 * s1_1067;
    // Op 1068: dim3x1 add
    gl64_t s1_1068 = *(gl64_t*)&expressions_params[10][32];
    tmp3_0 = tmp3_0 + s1_1068; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1069: dim3x3 mul
    gl64_t s1_1069_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1069_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1069_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1069 = (tmp3_0 + tmp3_1) * (s1_1069_0 + s1_1069_1);
    gl64_t kB1069 = (tmp3_0 + tmp3_2) * (s1_1069_0 + s1_1069_2);
    gl64_t kC1069 = (tmp3_1 + tmp3_2) * (s1_1069_1 + s1_1069_2);
    gl64_t kD1069 = tmp3_0 * s1_1069_0;
    gl64_t kE1069 = tmp3_1 * s1_1069_1;
    gl64_t kF1069 = tmp3_2 * s1_1069_2;
    gl64_t kG1069 = kD1069 - kE1069;
    tmp3_0 = (kC1069 + kG1069) - kF1069;
    tmp3_1 = ((((kA1069 + kC1069) - kE1069) - kE1069) - kD1069);
    tmp3_2 = kB1069 - kG1069;
    // Op 1070: dim3x1 add
    gl64_t s1_1070 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1070; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1071: dim3x3 mul
    gl64_t s1_1071_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1071_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1071_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1071 = (tmp3_0 + tmp3_1) * (s1_1071_0 + s1_1071_1);
    gl64_t kB1071 = (tmp3_0 + tmp3_2) * (s1_1071_0 + s1_1071_2);
    gl64_t kC1071 = (tmp3_1 + tmp3_2) * (s1_1071_1 + s1_1071_2);
    gl64_t kD1071 = tmp3_0 * s1_1071_0;
    gl64_t kE1071 = tmp3_1 * s1_1071_1;
    gl64_t kF1071 = tmp3_2 * s1_1071_2;
    gl64_t kG1071 = kD1071 - kE1071;
    tmp3_0 = (kC1071 + kG1071) - kF1071;
    tmp3_1 = ((((kA1071 + kC1071) - kE1071) - kE1071) - kD1071);
    tmp3_2 = kB1071 - kG1071;
    // Op 1072: dim3x1 add
    gl64_t s1_1072 = *(gl64_t*)&expressions_params[10][82];
    tmp3_0 = tmp3_0 + s1_1072; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1073: dim3x3 mul
    gl64_t s1_1073_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1073_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1073_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1073 = (tmp3_0 + tmp3_1) * (s1_1073_0 + s1_1073_1);
    gl64_t kB1073 = (tmp3_0 + tmp3_2) * (s1_1073_0 + s1_1073_2);
    gl64_t kC1073 = (tmp3_1 + tmp3_2) * (s1_1073_1 + s1_1073_2);
    gl64_t kD1073 = tmp3_0 * s1_1073_0;
    gl64_t kE1073 = tmp3_1 * s1_1073_1;
    gl64_t kF1073 = tmp3_2 * s1_1073_2;
    gl64_t kG1073 = kD1073 - kE1073;
    tmp3_0 = (kC1073 + kG1073) - kF1073;
    tmp3_1 = ((((kA1073 + kC1073) - kE1073) - kE1073) - kD1073);
    tmp3_2 = kB1073 - kG1073;
    // Op 1074: dim3x1 add
    gl64_t s1_1074 = *(gl64_t*)&expressions_params[9][30];
    tmp3_0 = tmp3_0 + s1_1074; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1075: dim3x3 mul
    gl64_t s1_1075_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1075_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1075_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1075 = (tmp3_0 + tmp3_1) * (s1_1075_0 + s1_1075_1);
    gl64_t kB1075 = (tmp3_0 + tmp3_2) * (s1_1075_0 + s1_1075_2);
    gl64_t kC1075 = (tmp3_1 + tmp3_2) * (s1_1075_1 + s1_1075_2);
    gl64_t kD1075 = tmp3_0 * s1_1075_0;
    gl64_t kE1075 = tmp3_1 * s1_1075_1;
    gl64_t kF1075 = tmp3_2 * s1_1075_2;
    gl64_t kG1075 = kD1075 - kE1075;
    tmp3_0 = (kC1075 + kG1075) - kF1075;
    tmp3_1 = ((((kA1075 + kC1075) - kE1075) - kE1075) - kD1075);
    tmp3_2 = kB1075 - kG1075;
    // Op 1076: dim3x1 add
    gl64_t s1_1076 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1076; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1077: dim3x3 mul
    gl64_t s1_1077_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1077_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1077_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1078: dim3x1 add
    gl64_t s1_1078 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1078; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1079: dim3x3 add
    gl64_t s1_1079_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1079_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1079_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1079_0; tmp3_1 = tmp3_1 + s1_1079_1; tmp3_2 = tmp3_2 + s1_1079_2;
    // Op 1080: dim3x3 mul
    gl64_t s1_1080_0 = *(gl64_t*)&expressions_params[10][218];
    gl64_t s1_1080_1 = *(gl64_t*)&expressions_params[10][218+1];
    gl64_t s1_1080_2 = *(gl64_t*)&expressions_params[10][218+2];
    gl64_t kA1080 = (tmp3_0 + tmp3_1) * (s1_1080_0 + s1_1080_1);
    gl64_t kB1080 = (tmp3_0 + tmp3_2) * (s1_1080_0 + s1_1080_2);
    gl64_t kC1080 = (tmp3_1 + tmp3_2) * (s1_1080_1 + s1_1080_2);
    gl64_t kD1080 = tmp3_0 * s1_1080_0;
    gl64_t kE1080 = tmp3_1 * s1_1080_1;
    gl64_t kF1080 = tmp3_2 * s1_1080_2;
    gl64_t kG1080 = kD1080 - kE1080;
    tmp3_0 = (kC1080 + kG1080) - kF1080;
    tmp3_1 = ((((kA1080 + kC1080) - kE1080) - kE1080) - kD1080);
    tmp3_2 = kB1080 - kG1080;
    // Op 1081: dim3x1 sub
    gl64_t s1_1081 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1081; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1082: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1083: dim3x3 mul
    gl64_t s1_1083_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1083_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1083_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1083 = (tmp3_0 + tmp3_1) * (s1_1083_0 + s1_1083_1);
    gl64_t kB1083 = (tmp3_0 + tmp3_2) * (s1_1083_0 + s1_1083_2);
    gl64_t kC1083 = (tmp3_1 + tmp3_2) * (s1_1083_1 + s1_1083_2);
    gl64_t kD1083 = tmp3_0 * s1_1083_0;
    gl64_t kE1083 = tmp3_1 * s1_1083_1;
    gl64_t kF1083 = tmp3_2 * s1_1083_2;
    gl64_t kG1083 = kD1083 - kE1083;
    tmp3_6 = (kC1083 + kG1083) - kF1083;
    tmp3_7 = ((((kA1083 + kC1083) - kE1083) - kE1083) - kD1083);
    tmp3_8 = kB1083 - kG1083;
    // Op 1084: dim3x1 mul
    gl64_t s0_1084_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1084_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1084_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1084 = *(gl64_t*)&expressions_params[10][33];
    tmp3_0 = s0_1084_0 * s1_1084; tmp3_1 = s0_1084_1 * s1_1084; tmp3_2 = s0_1084_2 * s1_1084;
    // Op 1085: dim3x1 add
    gl64_t s1_1085 = *(gl64_t*)&expressions_params[10][32];
    tmp3_0 = tmp3_0 + s1_1085; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1086: dim3x3 mul
    gl64_t s1_1086_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1086_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1086_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1086 = (tmp3_0 + tmp3_1) * (s1_1086_0 + s1_1086_1);
    gl64_t kB1086 = (tmp3_0 + tmp3_2) * (s1_1086_0 + s1_1086_2);
    gl64_t kC1086 = (tmp3_1 + tmp3_2) * (s1_1086_1 + s1_1086_2);
    gl64_t kD1086 = tmp3_0 * s1_1086_0;
    gl64_t kE1086 = tmp3_1 * s1_1086_1;
    gl64_t kF1086 = tmp3_2 * s1_1086_2;
    gl64_t kG1086 = kD1086 - kE1086;
    tmp3_0 = (kC1086 + kG1086) - kF1086;
    tmp3_1 = ((((kA1086 + kC1086) - kE1086) - kE1086) - kD1086);
    tmp3_2 = kB1086 - kG1086;
    // Op 1087: dim3x1 add
    gl64_t s1_1087 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1087; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1088: dim3x3 mul
    gl64_t s1_1088_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1088_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1088_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1088 = (tmp3_0 + tmp3_1) * (s1_1088_0 + s1_1088_1);
    gl64_t kB1088 = (tmp3_0 + tmp3_2) * (s1_1088_0 + s1_1088_2);
    gl64_t kC1088 = (tmp3_1 + tmp3_2) * (s1_1088_1 + s1_1088_2);
    gl64_t kD1088 = tmp3_0 * s1_1088_0;
    gl64_t kE1088 = tmp3_1 * s1_1088_1;
    gl64_t kF1088 = tmp3_2 * s1_1088_2;
    gl64_t kG1088 = kD1088 - kE1088;
    tmp3_0 = (kC1088 + kG1088) - kF1088;
    tmp3_1 = ((((kA1088 + kC1088) - kE1088) - kE1088) - kD1088);
    tmp3_2 = kB1088 - kG1088;
    // Op 1089: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1090: dim3x3 mul
    gl64_t s1_1090_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1090_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1090_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1090 = (tmp3_0 + tmp3_1) * (s1_1090_0 + s1_1090_1);
    gl64_t kB1090 = (tmp3_0 + tmp3_2) * (s1_1090_0 + s1_1090_2);
    gl64_t kC1090 = (tmp3_1 + tmp3_2) * (s1_1090_1 + s1_1090_2);
    gl64_t kD1090 = tmp3_0 * s1_1090_0;
    gl64_t kE1090 = tmp3_1 * s1_1090_1;
    gl64_t kF1090 = tmp3_2 * s1_1090_2;
    gl64_t kG1090 = kD1090 - kE1090;
    tmp3_0 = (kC1090 + kG1090) - kF1090;
    tmp3_1 = ((((kA1090 + kC1090) - kE1090) - kE1090) - kD1090);
    tmp3_2 = kB1090 - kG1090;
    // Op 1091: dim3x1 add
    gl64_t s1_1091 = *(gl64_t*)&expressions_params[9][30];
    tmp3_0 = tmp3_0 + s1_1091; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1092: dim3x3 mul
    gl64_t s1_1092_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1092_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1092_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1092 = (tmp3_0 + tmp3_1) * (s1_1092_0 + s1_1092_1);
    gl64_t kB1092 = (tmp3_0 + tmp3_2) * (s1_1092_0 + s1_1092_2);
    gl64_t kC1092 = (tmp3_1 + tmp3_2) * (s1_1092_1 + s1_1092_2);
    gl64_t kD1092 = tmp3_0 * s1_1092_0;
    gl64_t kE1092 = tmp3_1 * s1_1092_1;
    gl64_t kF1092 = tmp3_2 * s1_1092_2;
    gl64_t kG1092 = kD1092 - kE1092;
    tmp3_0 = (kC1092 + kG1092) - kF1092;
    tmp3_1 = ((((kA1092 + kC1092) - kE1092) - kE1092) - kD1092);
    tmp3_2 = kB1092 - kG1092;
    // Op 1093: dim3x1 add
    gl64_t s1_1093 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1093; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1094: dim3x3 mul
    gl64_t s1_1094_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1094_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1094_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1095: dim3x1 add
    gl64_t s1_1095 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1095; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1096: dim3x3 add
    gl64_t s1_1096_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1096_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1096_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1096_0; tmp3_1 = tmp3_1 + s1_1096_1; tmp3_2 = tmp3_2 + s1_1096_2;
    // Op 1097: dim3x3 mul
    gl64_t s1_1097_0 = *(gl64_t*)&expressions_params[10][221];
    gl64_t s1_1097_1 = *(gl64_t*)&expressions_params[10][221+1];
    gl64_t s1_1097_2 = *(gl64_t*)&expressions_params[10][221+2];
    gl64_t kA1097 = (tmp3_0 + tmp3_1) * (s1_1097_0 + s1_1097_1);
    gl64_t kB1097 = (tmp3_0 + tmp3_2) * (s1_1097_0 + s1_1097_2);
    gl64_t kC1097 = (tmp3_1 + tmp3_2) * (s1_1097_1 + s1_1097_2);
    gl64_t kD1097 = tmp3_0 * s1_1097_0;
    gl64_t kE1097 = tmp3_1 * s1_1097_1;
    gl64_t kF1097 = tmp3_2 * s1_1097_2;
    gl64_t kG1097 = kD1097 - kE1097;
    tmp3_0 = (kC1097 + kG1097) - kF1097;
    tmp3_1 = ((((kA1097 + kC1097) - kE1097) - kE1097) - kD1097);
    tmp3_2 = kB1097 - kG1097;
    // Op 1098: dim1x1 sub
    gl64_t s0_1098 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1098 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1098 - s1_1098;
    // Op 1099: dim1x1 sub_swap
    gl64_t s1_1099 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1099 - tmp1_0;
    // Op 1100: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1101: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1102: dim3x3 mul
    gl64_t s1_1102_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1102_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1102_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1102 = (tmp3_0 + tmp3_1) * (s1_1102_0 + s1_1102_1);
    gl64_t kB1102 = (tmp3_0 + tmp3_2) * (s1_1102_0 + s1_1102_2);
    gl64_t kC1102 = (tmp3_1 + tmp3_2) * (s1_1102_1 + s1_1102_2);
    gl64_t kD1102 = tmp3_0 * s1_1102_0;
    gl64_t kE1102 = tmp3_1 * s1_1102_1;
    gl64_t kF1102 = tmp3_2 * s1_1102_2;
    gl64_t kG1102 = kD1102 - kE1102;
    tmp3_6 = (kC1102 + kG1102) - kF1102;
    tmp3_7 = ((((kA1102 + kC1102) - kE1102) - kE1102) - kD1102);
    tmp3_8 = kB1102 - kG1102;
    // Op 1103: dim1x1 sub
    gl64_t s1_1103 = *(gl64_t*)&expressions_params[10][83];
    tmp1_0 = tmp1_4 - s1_1103;
    // Op 1104: dim1x1 sub
    gl64_t s1_1104 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1104;
    // Op 1105: dim3x1 mul
    gl64_t s0_1105_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1105_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1105_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1105_0 * tmp1_0; tmp3_1 = s0_1105_1 * tmp1_0; tmp3_2 = s0_1105_2 * tmp1_0;
    // Op 1106: dim3x1 add
    gl64_t s1_1106 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1106; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1107: dim3x3 add
    gl64_t s1_1107_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1107_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1107_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1107_0; tmp3_1 = tmp3_1 + s1_1107_1; tmp3_2 = tmp3_2 + s1_1107_2;
    // Op 1108: dim3x3 mul
    gl64_t s1_1108_0 = *(gl64_t*)&expressions_params[10][224];
    gl64_t s1_1108_1 = *(gl64_t*)&expressions_params[10][224+1];
    gl64_t s1_1108_2 = *(gl64_t*)&expressions_params[10][224+2];
    gl64_t kA1108 = (tmp3_0 + tmp3_1) * (s1_1108_0 + s1_1108_1);
    gl64_t kB1108 = (tmp3_0 + tmp3_2) * (s1_1108_0 + s1_1108_2);
    gl64_t kC1108 = (tmp3_1 + tmp3_2) * (s1_1108_1 + s1_1108_2);
    gl64_t kD1108 = tmp3_0 * s1_1108_0;
    gl64_t kE1108 = tmp3_1 * s1_1108_1;
    gl64_t kF1108 = tmp3_2 * s1_1108_2;
    gl64_t kG1108 = kD1108 - kE1108;
    tmp3_0 = (kC1108 + kG1108) - kF1108;
    tmp3_1 = ((((kA1108 + kC1108) - kE1108) - kE1108) - kD1108);
    tmp3_2 = kB1108 - kG1108;
    // Op 1109: dim3x1 add
    gl64_t s1_1109 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1109; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1110: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1111: dim3x3 mul
    gl64_t s1_1111_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1111_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1111_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1111 = (tmp3_0 + tmp3_1) * (s1_1111_0 + s1_1111_1);
    gl64_t kB1111 = (tmp3_0 + tmp3_2) * (s1_1111_0 + s1_1111_2);
    gl64_t kC1111 = (tmp3_1 + tmp3_2) * (s1_1111_1 + s1_1111_2);
    gl64_t kD1111 = tmp3_0 * s1_1111_0;
    gl64_t kE1111 = tmp3_1 * s1_1111_1;
    gl64_t kF1111 = tmp3_2 * s1_1111_2;
    gl64_t kG1111 = kD1111 - kE1111;
    tmp3_6 = (kC1111 + kG1111) - kF1111;
    tmp3_7 = ((((kA1111 + kC1111) - kE1111) - kE1111) - kD1111);
    tmp3_8 = kB1111 - kG1111;
    // Op 1112: dim3x1 mul
    gl64_t s0_1112_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1112_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1112_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1112 = *(gl64_t*)&expressions_params[10][35];
    tmp3_0 = s0_1112_0 * s1_1112; tmp3_1 = s0_1112_1 * s1_1112; tmp3_2 = s0_1112_2 * s1_1112;
    // Op 1113: dim3x1 add
    gl64_t s1_1113 = *(gl64_t*)&expressions_params[10][34];
    tmp3_0 = tmp3_0 + s1_1113; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1114: dim3x3 mul
    gl64_t s1_1114_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1114_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1114_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1114 = (tmp3_0 + tmp3_1) * (s1_1114_0 + s1_1114_1);
    gl64_t kB1114 = (tmp3_0 + tmp3_2) * (s1_1114_0 + s1_1114_2);
    gl64_t kC1114 = (tmp3_1 + tmp3_2) * (s1_1114_1 + s1_1114_2);
    gl64_t kD1114 = tmp3_0 * s1_1114_0;
    gl64_t kE1114 = tmp3_1 * s1_1114_1;
    gl64_t kF1114 = tmp3_2 * s1_1114_2;
    gl64_t kG1114 = kD1114 - kE1114;
    tmp3_0 = (kC1114 + kG1114) - kF1114;
    tmp3_1 = ((((kA1114 + kC1114) - kE1114) - kE1114) - kD1114);
    tmp3_2 = kB1114 - kG1114;
    // Op 1115: dim3x1 add
    gl64_t s1_1115 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1115; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1116: dim3x3 mul
    gl64_t s1_1116_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1116_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1116_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1116 = (tmp3_0 + tmp3_1) * (s1_1116_0 + s1_1116_1);
    gl64_t kB1116 = (tmp3_0 + tmp3_2) * (s1_1116_0 + s1_1116_2);
    gl64_t kC1116 = (tmp3_1 + tmp3_2) * (s1_1116_1 + s1_1116_2);
    gl64_t kD1116 = tmp3_0 * s1_1116_0;
    gl64_t kE1116 = tmp3_1 * s1_1116_1;
    gl64_t kF1116 = tmp3_2 * s1_1116_2;
    gl64_t kG1116 = kD1116 - kE1116;
    tmp3_0 = (kC1116 + kG1116) - kF1116;
    tmp3_1 = ((((kA1116 + kC1116) - kE1116) - kE1116) - kD1116);
    tmp3_2 = kB1116 - kG1116;
    // Op 1117: dim3x1 add
    gl64_t s1_1117 = *(gl64_t*)&expressions_params[10][83];
    tmp3_0 = tmp3_0 + s1_1117; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1118: dim3x3 mul
    gl64_t s1_1118_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1118_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1118_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1118 = (tmp3_0 + tmp3_1) * (s1_1118_0 + s1_1118_1);
    gl64_t kB1118 = (tmp3_0 + tmp3_2) * (s1_1118_0 + s1_1118_2);
    gl64_t kC1118 = (tmp3_1 + tmp3_2) * (s1_1118_1 + s1_1118_2);
    gl64_t kD1118 = tmp3_0 * s1_1118_0;
    gl64_t kE1118 = tmp3_1 * s1_1118_1;
    gl64_t kF1118 = tmp3_2 * s1_1118_2;
    gl64_t kG1118 = kD1118 - kE1118;
    tmp3_0 = (kC1118 + kG1118) - kF1118;
    tmp3_1 = ((((kA1118 + kC1118) - kE1118) - kE1118) - kD1118);
    tmp3_2 = kB1118 - kG1118;
    // Op 1119: dim3x1 add
    gl64_t s1_1119 = *(gl64_t*)&expressions_params[9][31];
    tmp3_0 = tmp3_0 + s1_1119; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1120: dim3x3 mul
    gl64_t s1_1120_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1120_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1120_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1120 = (tmp3_0 + tmp3_1) * (s1_1120_0 + s1_1120_1);
    gl64_t kB1120 = (tmp3_0 + tmp3_2) * (s1_1120_0 + s1_1120_2);
    gl64_t kC1120 = (tmp3_1 + tmp3_2) * (s1_1120_1 + s1_1120_2);
    gl64_t kD1120 = tmp3_0 * s1_1120_0;
    gl64_t kE1120 = tmp3_1 * s1_1120_1;
    gl64_t kF1120 = tmp3_2 * s1_1120_2;
    gl64_t kG1120 = kD1120 - kE1120;
    tmp3_0 = (kC1120 + kG1120) - kF1120;
    tmp3_1 = ((((kA1120 + kC1120) - kE1120) - kE1120) - kD1120);
    tmp3_2 = kB1120 - kG1120;
    // Op 1121: dim3x1 add
    gl64_t s1_1121 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1121; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1122: dim3x3 mul
    gl64_t s1_1122_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1122_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1122_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1123: dim3x1 add
    gl64_t s1_1123 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1123; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1124: dim3x3 add
    gl64_t s1_1124_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1124_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1124_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1124_0; tmp3_1 = tmp3_1 + s1_1124_1; tmp3_2 = tmp3_2 + s1_1124_2;
    // Op 1125: dim3x3 mul
    gl64_t s1_1125_0 = *(gl64_t*)&expressions_params[10][227];
    gl64_t s1_1125_1 = *(gl64_t*)&expressions_params[10][227+1];
    gl64_t s1_1125_2 = *(gl64_t*)&expressions_params[10][227+2];
    gl64_t kA1125 = (tmp3_0 + tmp3_1) * (s1_1125_0 + s1_1125_1);
    gl64_t kB1125 = (tmp3_0 + tmp3_2) * (s1_1125_0 + s1_1125_2);
    gl64_t kC1125 = (tmp3_1 + tmp3_2) * (s1_1125_1 + s1_1125_2);
    gl64_t kD1125 = tmp3_0 * s1_1125_0;
    gl64_t kE1125 = tmp3_1 * s1_1125_1;
    gl64_t kF1125 = tmp3_2 * s1_1125_2;
    gl64_t kG1125 = kD1125 - kE1125;
    tmp3_0 = (kC1125 + kG1125) - kF1125;
    tmp3_1 = ((((kA1125 + kC1125) - kE1125) - kE1125) - kD1125);
    tmp3_2 = kB1125 - kG1125;
    // Op 1126: dim3x1 sub
    gl64_t s1_1126 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1126; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1127: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1128: dim3x3 mul
    gl64_t s1_1128_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1128_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1128_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1128 = (tmp3_0 + tmp3_1) * (s1_1128_0 + s1_1128_1);
    gl64_t kB1128 = (tmp3_0 + tmp3_2) * (s1_1128_0 + s1_1128_2);
    gl64_t kC1128 = (tmp3_1 + tmp3_2) * (s1_1128_1 + s1_1128_2);
    gl64_t kD1128 = tmp3_0 * s1_1128_0;
    gl64_t kE1128 = tmp3_1 * s1_1128_1;
    gl64_t kF1128 = tmp3_2 * s1_1128_2;
    gl64_t kG1128 = kD1128 - kE1128;
    tmp3_6 = (kC1128 + kG1128) - kF1128;
    tmp3_7 = ((((kA1128 + kC1128) - kE1128) - kE1128) - kD1128);
    tmp3_8 = kB1128 - kG1128;
    // Op 1129: dim3x1 mul
    gl64_t s0_1129_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1129_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1129_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1129 = *(gl64_t*)&expressions_params[10][35];
    tmp3_0 = s0_1129_0 * s1_1129; tmp3_1 = s0_1129_1 * s1_1129; tmp3_2 = s0_1129_2 * s1_1129;
    // Op 1130: dim3x1 add
    gl64_t s1_1130 = *(gl64_t*)&expressions_params[10][34];
    tmp3_0 = tmp3_0 + s1_1130; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1131: dim3x3 mul
    gl64_t s1_1131_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1131_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1131_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1131 = (tmp3_0 + tmp3_1) * (s1_1131_0 + s1_1131_1);
    gl64_t kB1131 = (tmp3_0 + tmp3_2) * (s1_1131_0 + s1_1131_2);
    gl64_t kC1131 = (tmp3_1 + tmp3_2) * (s1_1131_1 + s1_1131_2);
    gl64_t kD1131 = tmp3_0 * s1_1131_0;
    gl64_t kE1131 = tmp3_1 * s1_1131_1;
    gl64_t kF1131 = tmp3_2 * s1_1131_2;
    gl64_t kG1131 = kD1131 - kE1131;
    tmp3_0 = (kC1131 + kG1131) - kF1131;
    tmp3_1 = ((((kA1131 + kC1131) - kE1131) - kE1131) - kD1131);
    tmp3_2 = kB1131 - kG1131;
    // Op 1132: dim3x1 add
    gl64_t s1_1132 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1132; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1133: dim3x3 mul
    gl64_t s1_1133_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1133_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1133_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1133 = (tmp3_0 + tmp3_1) * (s1_1133_0 + s1_1133_1);
    gl64_t kB1133 = (tmp3_0 + tmp3_2) * (s1_1133_0 + s1_1133_2);
    gl64_t kC1133 = (tmp3_1 + tmp3_2) * (s1_1133_1 + s1_1133_2);
    gl64_t kD1133 = tmp3_0 * s1_1133_0;
    gl64_t kE1133 = tmp3_1 * s1_1133_1;
    gl64_t kF1133 = tmp3_2 * s1_1133_2;
    gl64_t kG1133 = kD1133 - kE1133;
    tmp3_0 = (kC1133 + kG1133) - kF1133;
    tmp3_1 = ((((kA1133 + kC1133) - kE1133) - kE1133) - kD1133);
    tmp3_2 = kB1133 - kG1133;
    // Op 1134: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1135: dim3x3 mul
    gl64_t s1_1135_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1135_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1135_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1135 = (tmp3_0 + tmp3_1) * (s1_1135_0 + s1_1135_1);
    gl64_t kB1135 = (tmp3_0 + tmp3_2) * (s1_1135_0 + s1_1135_2);
    gl64_t kC1135 = (tmp3_1 + tmp3_2) * (s1_1135_1 + s1_1135_2);
    gl64_t kD1135 = tmp3_0 * s1_1135_0;
    gl64_t kE1135 = tmp3_1 * s1_1135_1;
    gl64_t kF1135 = tmp3_2 * s1_1135_2;
    gl64_t kG1135 = kD1135 - kE1135;
    tmp3_0 = (kC1135 + kG1135) - kF1135;
    tmp3_1 = ((((kA1135 + kC1135) - kE1135) - kE1135) - kD1135);
    tmp3_2 = kB1135 - kG1135;
    // Op 1136: dim3x1 add
    gl64_t s1_1136 = *(gl64_t*)&expressions_params[9][31];
    tmp3_0 = tmp3_0 + s1_1136; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1137: dim3x3 mul
    gl64_t s1_1137_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1137_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1137_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1137 = (tmp3_0 + tmp3_1) * (s1_1137_0 + s1_1137_1);
    gl64_t kB1137 = (tmp3_0 + tmp3_2) * (s1_1137_0 + s1_1137_2);
    gl64_t kC1137 = (tmp3_1 + tmp3_2) * (s1_1137_1 + s1_1137_2);
    gl64_t kD1137 = tmp3_0 * s1_1137_0;
    gl64_t kE1137 = tmp3_1 * s1_1137_1;
    gl64_t kF1137 = tmp3_2 * s1_1137_2;
    gl64_t kG1137 = kD1137 - kE1137;
    tmp3_0 = (kC1137 + kG1137) - kF1137;
    tmp3_1 = ((((kA1137 + kC1137) - kE1137) - kE1137) - kD1137);
    tmp3_2 = kB1137 - kG1137;
    // Op 1138: dim3x1 add
    gl64_t s1_1138 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1138; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1139: dim3x3 mul
    gl64_t s1_1139_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1139_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1139_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1140: dim3x1 add
    gl64_t s1_1140 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1140; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1141: dim3x3 add
    gl64_t s1_1141_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1141_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1141_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1141_0; tmp3_1 = tmp3_1 + s1_1141_1; tmp3_2 = tmp3_2 + s1_1141_2;
    // Op 1142: dim3x3 mul
    gl64_t s1_1142_0 = *(gl64_t*)&expressions_params[10][230];
    gl64_t s1_1142_1 = *(gl64_t*)&expressions_params[10][230+1];
    gl64_t s1_1142_2 = *(gl64_t*)&expressions_params[10][230+2];
    gl64_t kA1142 = (tmp3_0 + tmp3_1) * (s1_1142_0 + s1_1142_1);
    gl64_t kB1142 = (tmp3_0 + tmp3_2) * (s1_1142_0 + s1_1142_2);
    gl64_t kC1142 = (tmp3_1 + tmp3_2) * (s1_1142_1 + s1_1142_2);
    gl64_t kD1142 = tmp3_0 * s1_1142_0;
    gl64_t kE1142 = tmp3_1 * s1_1142_1;
    gl64_t kF1142 = tmp3_2 * s1_1142_2;
    gl64_t kG1142 = kD1142 - kE1142;
    tmp3_0 = (kC1142 + kG1142) - kF1142;
    tmp3_1 = ((((kA1142 + kC1142) - kE1142) - kE1142) - kD1142);
    tmp3_2 = kB1142 - kG1142;
    // Op 1143: dim1x1 sub
    gl64_t s0_1143 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1143 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1143 - s1_1143;
    // Op 1144: dim1x1 sub_swap
    gl64_t s1_1144 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1144 - tmp1_0;
    // Op 1145: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1146: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1147: dim3x3 mul
    gl64_t s1_1147_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1147_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1147_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1147 = (tmp3_0 + tmp3_1) * (s1_1147_0 + s1_1147_1);
    gl64_t kB1147 = (tmp3_0 + tmp3_2) * (s1_1147_0 + s1_1147_2);
    gl64_t kC1147 = (tmp3_1 + tmp3_2) * (s1_1147_1 + s1_1147_2);
    gl64_t kD1147 = tmp3_0 * s1_1147_0;
    gl64_t kE1147 = tmp3_1 * s1_1147_1;
    gl64_t kF1147 = tmp3_2 * s1_1147_2;
    gl64_t kG1147 = kD1147 - kE1147;
    tmp3_6 = (kC1147 + kG1147) - kF1147;
    tmp3_7 = ((((kA1147 + kC1147) - kE1147) - kE1147) - kD1147);
    tmp3_8 = kB1147 - kG1147;
    // Op 1148: dim1x1 sub
    gl64_t s1_1148 = *(gl64_t*)&expressions_params[10][84];
    tmp1_0 = tmp1_4 - s1_1148;
    // Op 1149: dim1x1 sub
    gl64_t s1_1149 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1149;
    // Op 1150: dim3x1 mul
    gl64_t s0_1150_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1150_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1150_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1150_0 * tmp1_0; tmp3_1 = s0_1150_1 * tmp1_0; tmp3_2 = s0_1150_2 * tmp1_0;
    // Op 1151: dim3x1 add
    gl64_t s1_1151 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1151; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1152: dim3x3 add
    gl64_t s1_1152_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1152_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1152_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1152_0; tmp3_1 = tmp3_1 + s1_1152_1; tmp3_2 = tmp3_2 + s1_1152_2;
    // Op 1153: dim3x3 mul
    gl64_t s1_1153_0 = *(gl64_t*)&expressions_params[10][233];
    gl64_t s1_1153_1 = *(gl64_t*)&expressions_params[10][233+1];
    gl64_t s1_1153_2 = *(gl64_t*)&expressions_params[10][233+2];
    gl64_t kA1153 = (tmp3_0 + tmp3_1) * (s1_1153_0 + s1_1153_1);
    gl64_t kB1153 = (tmp3_0 + tmp3_2) * (s1_1153_0 + s1_1153_2);
    gl64_t kC1153 = (tmp3_1 + tmp3_2) * (s1_1153_1 + s1_1153_2);
    gl64_t kD1153 = tmp3_0 * s1_1153_0;
    gl64_t kE1153 = tmp3_1 * s1_1153_1;
    gl64_t kF1153 = tmp3_2 * s1_1153_2;
    gl64_t kG1153 = kD1153 - kE1153;
    tmp3_0 = (kC1153 + kG1153) - kF1153;
    tmp3_1 = ((((kA1153 + kC1153) - kE1153) - kE1153) - kD1153);
    tmp3_2 = kB1153 - kG1153;
    // Op 1154: dim3x1 add
    gl64_t s1_1154 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1154; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1155: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1156: dim3x3 mul
    gl64_t s1_1156_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1156_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1156_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1156 = (tmp3_0 + tmp3_1) * (s1_1156_0 + s1_1156_1);
    gl64_t kB1156 = (tmp3_0 + tmp3_2) * (s1_1156_0 + s1_1156_2);
    gl64_t kC1156 = (tmp3_1 + tmp3_2) * (s1_1156_1 + s1_1156_2);
    gl64_t kD1156 = tmp3_0 * s1_1156_0;
    gl64_t kE1156 = tmp3_1 * s1_1156_1;
    gl64_t kF1156 = tmp3_2 * s1_1156_2;
    gl64_t kG1156 = kD1156 - kE1156;
    tmp3_6 = (kC1156 + kG1156) - kF1156;
    tmp3_7 = ((((kA1156 + kC1156) - kE1156) - kE1156) - kD1156);
    tmp3_8 = kB1156 - kG1156;
    // Op 1157: dim3x1 mul
    gl64_t s0_1157_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1157_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1157_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1157 = *(gl64_t*)&expressions_params[10][37];
    tmp3_0 = s0_1157_0 * s1_1157; tmp3_1 = s0_1157_1 * s1_1157; tmp3_2 = s0_1157_2 * s1_1157;
    // Op 1158: dim3x1 add
    gl64_t s1_1158 = *(gl64_t*)&expressions_params[10][36];
    tmp3_0 = tmp3_0 + s1_1158; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1159: dim3x3 mul
    gl64_t s1_1159_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1159_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1159_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1159 = (tmp3_0 + tmp3_1) * (s1_1159_0 + s1_1159_1);
    gl64_t kB1159 = (tmp3_0 + tmp3_2) * (s1_1159_0 + s1_1159_2);
    gl64_t kC1159 = (tmp3_1 + tmp3_2) * (s1_1159_1 + s1_1159_2);
    gl64_t kD1159 = tmp3_0 * s1_1159_0;
    gl64_t kE1159 = tmp3_1 * s1_1159_1;
    gl64_t kF1159 = tmp3_2 * s1_1159_2;
    gl64_t kG1159 = kD1159 - kE1159;
    tmp3_0 = (kC1159 + kG1159) - kF1159;
    tmp3_1 = ((((kA1159 + kC1159) - kE1159) - kE1159) - kD1159);
    tmp3_2 = kB1159 - kG1159;
    // Op 1160: dim3x1 add
    gl64_t s1_1160 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1160; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1161: dim3x3 mul
    gl64_t s1_1161_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1161_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1161_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1161 = (tmp3_0 + tmp3_1) * (s1_1161_0 + s1_1161_1);
    gl64_t kB1161 = (tmp3_0 + tmp3_2) * (s1_1161_0 + s1_1161_2);
    gl64_t kC1161 = (tmp3_1 + tmp3_2) * (s1_1161_1 + s1_1161_2);
    gl64_t kD1161 = tmp3_0 * s1_1161_0;
    gl64_t kE1161 = tmp3_1 * s1_1161_1;
    gl64_t kF1161 = tmp3_2 * s1_1161_2;
    gl64_t kG1161 = kD1161 - kE1161;
    tmp3_0 = (kC1161 + kG1161) - kF1161;
    tmp3_1 = ((((kA1161 + kC1161) - kE1161) - kE1161) - kD1161);
    tmp3_2 = kB1161 - kG1161;
    // Op 1162: dim3x1 add
    gl64_t s1_1162 = *(gl64_t*)&expressions_params[10][84];
    tmp3_0 = tmp3_0 + s1_1162; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1163: dim3x3 mul
    gl64_t s1_1163_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1163_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1163_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1163 = (tmp3_0 + tmp3_1) * (s1_1163_0 + s1_1163_1);
    gl64_t kB1163 = (tmp3_0 + tmp3_2) * (s1_1163_0 + s1_1163_2);
    gl64_t kC1163 = (tmp3_1 + tmp3_2) * (s1_1163_1 + s1_1163_2);
    gl64_t kD1163 = tmp3_0 * s1_1163_0;
    gl64_t kE1163 = tmp3_1 * s1_1163_1;
    gl64_t kF1163 = tmp3_2 * s1_1163_2;
    gl64_t kG1163 = kD1163 - kE1163;
    tmp3_0 = (kC1163 + kG1163) - kF1163;
    tmp3_1 = ((((kA1163 + kC1163) - kE1163) - kE1163) - kD1163);
    tmp3_2 = kB1163 - kG1163;
    // Op 1164: dim3x1 add
    gl64_t s1_1164 = *(gl64_t*)&expressions_params[9][32];
    tmp3_0 = tmp3_0 + s1_1164; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1165: dim3x3 mul
    gl64_t s1_1165_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1165_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1165_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1165 = (tmp3_0 + tmp3_1) * (s1_1165_0 + s1_1165_1);
    gl64_t kB1165 = (tmp3_0 + tmp3_2) * (s1_1165_0 + s1_1165_2);
    gl64_t kC1165 = (tmp3_1 + tmp3_2) * (s1_1165_1 + s1_1165_2);
    gl64_t kD1165 = tmp3_0 * s1_1165_0;
    gl64_t kE1165 = tmp3_1 * s1_1165_1;
    gl64_t kF1165 = tmp3_2 * s1_1165_2;
    gl64_t kG1165 = kD1165 - kE1165;
    tmp3_0 = (kC1165 + kG1165) - kF1165;
    tmp3_1 = ((((kA1165 + kC1165) - kE1165) - kE1165) - kD1165);
    tmp3_2 = kB1165 - kG1165;
    // Op 1166: dim3x1 add
    gl64_t s1_1166 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1166; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1167: dim3x3 mul
    gl64_t s1_1167_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1167_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1167_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1168: dim3x1 add
    gl64_t s1_1168 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1168; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1169: dim3x3 add
    gl64_t s1_1169_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1169_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1169_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1169_0; tmp3_1 = tmp3_1 + s1_1169_1; tmp3_2 = tmp3_2 + s1_1169_2;
    // Op 1170: dim3x3 mul
    gl64_t s1_1170_0 = *(gl64_t*)&expressions_params[10][236];
    gl64_t s1_1170_1 = *(gl64_t*)&expressions_params[10][236+1];
    gl64_t s1_1170_2 = *(gl64_t*)&expressions_params[10][236+2];
    gl64_t kA1170 = (tmp3_0 + tmp3_1) * (s1_1170_0 + s1_1170_1);
    gl64_t kB1170 = (tmp3_0 + tmp3_2) * (s1_1170_0 + s1_1170_2);
    gl64_t kC1170 = (tmp3_1 + tmp3_2) * (s1_1170_1 + s1_1170_2);
    gl64_t kD1170 = tmp3_0 * s1_1170_0;
    gl64_t kE1170 = tmp3_1 * s1_1170_1;
    gl64_t kF1170 = tmp3_2 * s1_1170_2;
    gl64_t kG1170 = kD1170 - kE1170;
    tmp3_0 = (kC1170 + kG1170) - kF1170;
    tmp3_1 = ((((kA1170 + kC1170) - kE1170) - kE1170) - kD1170);
    tmp3_2 = kB1170 - kG1170;
    // Op 1171: dim3x1 sub
    gl64_t s1_1171 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1171; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1172: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1173: dim3x3 mul
    gl64_t s1_1173_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1173_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1173_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1173 = (tmp3_0 + tmp3_1) * (s1_1173_0 + s1_1173_1);
    gl64_t kB1173 = (tmp3_0 + tmp3_2) * (s1_1173_0 + s1_1173_2);
    gl64_t kC1173 = (tmp3_1 + tmp3_2) * (s1_1173_1 + s1_1173_2);
    gl64_t kD1173 = tmp3_0 * s1_1173_0;
    gl64_t kE1173 = tmp3_1 * s1_1173_1;
    gl64_t kF1173 = tmp3_2 * s1_1173_2;
    gl64_t kG1173 = kD1173 - kE1173;
    tmp3_6 = (kC1173 + kG1173) - kF1173;
    tmp3_7 = ((((kA1173 + kC1173) - kE1173) - kE1173) - kD1173);
    tmp3_8 = kB1173 - kG1173;
    // Op 1174: dim3x1 mul
    gl64_t s0_1174_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1174_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1174_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1174 = *(gl64_t*)&expressions_params[10][37];
    tmp3_0 = s0_1174_0 * s1_1174; tmp3_1 = s0_1174_1 * s1_1174; tmp3_2 = s0_1174_2 * s1_1174;
    // Op 1175: dim3x1 add
    gl64_t s1_1175 = *(gl64_t*)&expressions_params[10][36];
    tmp3_0 = tmp3_0 + s1_1175; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1176: dim3x3 mul
    gl64_t s1_1176_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1176_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1176_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1176 = (tmp3_0 + tmp3_1) * (s1_1176_0 + s1_1176_1);
    gl64_t kB1176 = (tmp3_0 + tmp3_2) * (s1_1176_0 + s1_1176_2);
    gl64_t kC1176 = (tmp3_1 + tmp3_2) * (s1_1176_1 + s1_1176_2);
    gl64_t kD1176 = tmp3_0 * s1_1176_0;
    gl64_t kE1176 = tmp3_1 * s1_1176_1;
    gl64_t kF1176 = tmp3_2 * s1_1176_2;
    gl64_t kG1176 = kD1176 - kE1176;
    tmp3_0 = (kC1176 + kG1176) - kF1176;
    tmp3_1 = ((((kA1176 + kC1176) - kE1176) - kE1176) - kD1176);
    tmp3_2 = kB1176 - kG1176;
    // Op 1177: dim3x1 add
    gl64_t s1_1177 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1177; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1178: dim3x3 mul
    gl64_t s1_1178_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1178_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1178_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1178 = (tmp3_0 + tmp3_1) * (s1_1178_0 + s1_1178_1);
    gl64_t kB1178 = (tmp3_0 + tmp3_2) * (s1_1178_0 + s1_1178_2);
    gl64_t kC1178 = (tmp3_1 + tmp3_2) * (s1_1178_1 + s1_1178_2);
    gl64_t kD1178 = tmp3_0 * s1_1178_0;
    gl64_t kE1178 = tmp3_1 * s1_1178_1;
    gl64_t kF1178 = tmp3_2 * s1_1178_2;
    gl64_t kG1178 = kD1178 - kE1178;
    tmp3_0 = (kC1178 + kG1178) - kF1178;
    tmp3_1 = ((((kA1178 + kC1178) - kE1178) - kE1178) - kD1178);
    tmp3_2 = kB1178 - kG1178;
    // Op 1179: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1180: dim3x3 mul
    gl64_t s1_1180_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1180_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1180_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1180 = (tmp3_0 + tmp3_1) * (s1_1180_0 + s1_1180_1);
    gl64_t kB1180 = (tmp3_0 + tmp3_2) * (s1_1180_0 + s1_1180_2);
    gl64_t kC1180 = (tmp3_1 + tmp3_2) * (s1_1180_1 + s1_1180_2);
    gl64_t kD1180 = tmp3_0 * s1_1180_0;
    gl64_t kE1180 = tmp3_1 * s1_1180_1;
    gl64_t kF1180 = tmp3_2 * s1_1180_2;
    gl64_t kG1180 = kD1180 - kE1180;
    tmp3_0 = (kC1180 + kG1180) - kF1180;
    tmp3_1 = ((((kA1180 + kC1180) - kE1180) - kE1180) - kD1180);
    tmp3_2 = kB1180 - kG1180;
    // Op 1181: dim3x1 add
    gl64_t s1_1181 = *(gl64_t*)&expressions_params[9][32];
    tmp3_0 = tmp3_0 + s1_1181; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1182: dim3x3 mul
    gl64_t s1_1182_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1182_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1182_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1182 = (tmp3_0 + tmp3_1) * (s1_1182_0 + s1_1182_1);
    gl64_t kB1182 = (tmp3_0 + tmp3_2) * (s1_1182_0 + s1_1182_2);
    gl64_t kC1182 = (tmp3_1 + tmp3_2) * (s1_1182_1 + s1_1182_2);
    gl64_t kD1182 = tmp3_0 * s1_1182_0;
    gl64_t kE1182 = tmp3_1 * s1_1182_1;
    gl64_t kF1182 = tmp3_2 * s1_1182_2;
    gl64_t kG1182 = kD1182 - kE1182;
    tmp3_0 = (kC1182 + kG1182) - kF1182;
    tmp3_1 = ((((kA1182 + kC1182) - kE1182) - kE1182) - kD1182);
    tmp3_2 = kB1182 - kG1182;
    // Op 1183: dim3x1 add
    gl64_t s1_1183 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1183; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1184: dim3x3 mul
    gl64_t s1_1184_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1184_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1184_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1185: dim3x1 add
    gl64_t s1_1185 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1185; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1186: dim3x3 add
    gl64_t s1_1186_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1186_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1186_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1186_0; tmp3_1 = tmp3_1 + s1_1186_1; tmp3_2 = tmp3_2 + s1_1186_2;
    // Op 1187: dim3x3 mul
    gl64_t s1_1187_0 = *(gl64_t*)&expressions_params[10][239];
    gl64_t s1_1187_1 = *(gl64_t*)&expressions_params[10][239+1];
    gl64_t s1_1187_2 = *(gl64_t*)&expressions_params[10][239+2];
    gl64_t kA1187 = (tmp3_0 + tmp3_1) * (s1_1187_0 + s1_1187_1);
    gl64_t kB1187 = (tmp3_0 + tmp3_2) * (s1_1187_0 + s1_1187_2);
    gl64_t kC1187 = (tmp3_1 + tmp3_2) * (s1_1187_1 + s1_1187_2);
    gl64_t kD1187 = tmp3_0 * s1_1187_0;
    gl64_t kE1187 = tmp3_1 * s1_1187_1;
    gl64_t kF1187 = tmp3_2 * s1_1187_2;
    gl64_t kG1187 = kD1187 - kE1187;
    tmp3_0 = (kC1187 + kG1187) - kF1187;
    tmp3_1 = ((((kA1187 + kC1187) - kE1187) - kE1187) - kD1187);
    tmp3_2 = kB1187 - kG1187;
    // Op 1188: dim1x1 sub
    gl64_t s0_1188 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1188 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1188 - s1_1188;
    // Op 1189: dim1x1 sub_swap
    gl64_t s1_1189 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1189 - tmp1_0;
    // Op 1190: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1191: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1192: dim3x3 mul
    gl64_t s1_1192_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1192_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1192_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1192 = (tmp3_0 + tmp3_1) * (s1_1192_0 + s1_1192_1);
    gl64_t kB1192 = (tmp3_0 + tmp3_2) * (s1_1192_0 + s1_1192_2);
    gl64_t kC1192 = (tmp3_1 + tmp3_2) * (s1_1192_1 + s1_1192_2);
    gl64_t kD1192 = tmp3_0 * s1_1192_0;
    gl64_t kE1192 = tmp3_1 * s1_1192_1;
    gl64_t kF1192 = tmp3_2 * s1_1192_2;
    gl64_t kG1192 = kD1192 - kE1192;
    tmp3_6 = (kC1192 + kG1192) - kF1192;
    tmp3_7 = ((((kA1192 + kC1192) - kE1192) - kE1192) - kD1192);
    tmp3_8 = kB1192 - kG1192;
    // Op 1193: dim1x1 sub
    gl64_t s1_1193 = *(gl64_t*)&expressions_params[10][85];
    tmp1_0 = tmp1_4 - s1_1193;
    // Op 1194: dim1x1 sub
    gl64_t s1_1194 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1194;
    // Op 1195: dim3x1 mul
    gl64_t s0_1195_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1195_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1195_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1195_0 * tmp1_0; tmp3_1 = s0_1195_1 * tmp1_0; tmp3_2 = s0_1195_2 * tmp1_0;
    // Op 1196: dim3x1 add
    gl64_t s1_1196 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1196; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1197: dim3x3 add
    gl64_t s1_1197_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1197_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1197_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1197_0; tmp3_1 = tmp3_1 + s1_1197_1; tmp3_2 = tmp3_2 + s1_1197_2;
    // Op 1198: dim3x3 mul
    gl64_t s1_1198_0 = *(gl64_t*)&expressions_params[10][242];
    gl64_t s1_1198_1 = *(gl64_t*)&expressions_params[10][242+1];
    gl64_t s1_1198_2 = *(gl64_t*)&expressions_params[10][242+2];
    gl64_t kA1198 = (tmp3_0 + tmp3_1) * (s1_1198_0 + s1_1198_1);
    gl64_t kB1198 = (tmp3_0 + tmp3_2) * (s1_1198_0 + s1_1198_2);
    gl64_t kC1198 = (tmp3_1 + tmp3_2) * (s1_1198_1 + s1_1198_2);
    gl64_t kD1198 = tmp3_0 * s1_1198_0;
    gl64_t kE1198 = tmp3_1 * s1_1198_1;
    gl64_t kF1198 = tmp3_2 * s1_1198_2;
    gl64_t kG1198 = kD1198 - kE1198;
    tmp3_0 = (kC1198 + kG1198) - kF1198;
    tmp3_1 = ((((kA1198 + kC1198) - kE1198) - kE1198) - kD1198);
    tmp3_2 = kB1198 - kG1198;
    // Op 1199: dim3x1 add
    gl64_t s1_1199 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1199; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1200: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1201: dim3x3 mul
    gl64_t s1_1201_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1201_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1201_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1201 = (tmp3_0 + tmp3_1) * (s1_1201_0 + s1_1201_1);
    gl64_t kB1201 = (tmp3_0 + tmp3_2) * (s1_1201_0 + s1_1201_2);
    gl64_t kC1201 = (tmp3_1 + tmp3_2) * (s1_1201_1 + s1_1201_2);
    gl64_t kD1201 = tmp3_0 * s1_1201_0;
    gl64_t kE1201 = tmp3_1 * s1_1201_1;
    gl64_t kF1201 = tmp3_2 * s1_1201_2;
    gl64_t kG1201 = kD1201 - kE1201;
    tmp3_6 = (kC1201 + kG1201) - kF1201;
    tmp3_7 = ((((kA1201 + kC1201) - kE1201) - kE1201) - kD1201);
    tmp3_8 = kB1201 - kG1201;
    // Op 1202: dim3x1 mul
    gl64_t s0_1202_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1202_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1202_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1202 = *(gl64_t*)&expressions_params[10][39];
    tmp3_0 = s0_1202_0 * s1_1202; tmp3_1 = s0_1202_1 * s1_1202; tmp3_2 = s0_1202_2 * s1_1202;
    // Op 1203: dim3x1 add
    gl64_t s1_1203 = *(gl64_t*)&expressions_params[10][38];
    tmp3_0 = tmp3_0 + s1_1203; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1204: dim3x3 mul
    gl64_t s1_1204_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1204_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1204_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1204 = (tmp3_0 + tmp3_1) * (s1_1204_0 + s1_1204_1);
    gl64_t kB1204 = (tmp3_0 + tmp3_2) * (s1_1204_0 + s1_1204_2);
    gl64_t kC1204 = (tmp3_1 + tmp3_2) * (s1_1204_1 + s1_1204_2);
    gl64_t kD1204 = tmp3_0 * s1_1204_0;
    gl64_t kE1204 = tmp3_1 * s1_1204_1;
    gl64_t kF1204 = tmp3_2 * s1_1204_2;
    gl64_t kG1204 = kD1204 - kE1204;
    tmp3_0 = (kC1204 + kG1204) - kF1204;
    tmp3_1 = ((((kA1204 + kC1204) - kE1204) - kE1204) - kD1204);
    tmp3_2 = kB1204 - kG1204;
    // Op 1205: dim3x1 add
    gl64_t s1_1205 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1205; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1206: dim3x3 mul
    gl64_t s1_1206_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1206_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1206_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1206 = (tmp3_0 + tmp3_1) * (s1_1206_0 + s1_1206_1);
    gl64_t kB1206 = (tmp3_0 + tmp3_2) * (s1_1206_0 + s1_1206_2);
    gl64_t kC1206 = (tmp3_1 + tmp3_2) * (s1_1206_1 + s1_1206_2);
    gl64_t kD1206 = tmp3_0 * s1_1206_0;
    gl64_t kE1206 = tmp3_1 * s1_1206_1;
    gl64_t kF1206 = tmp3_2 * s1_1206_2;
    gl64_t kG1206 = kD1206 - kE1206;
    tmp3_0 = (kC1206 + kG1206) - kF1206;
    tmp3_1 = ((((kA1206 + kC1206) - kE1206) - kE1206) - kD1206);
    tmp3_2 = kB1206 - kG1206;
    // Op 1207: dim3x1 add
    gl64_t s1_1207 = *(gl64_t*)&expressions_params[10][85];
    tmp3_0 = tmp3_0 + s1_1207; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1208: dim3x3 mul
    gl64_t s1_1208_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1208_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1208_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1208 = (tmp3_0 + tmp3_1) * (s1_1208_0 + s1_1208_1);
    gl64_t kB1208 = (tmp3_0 + tmp3_2) * (s1_1208_0 + s1_1208_2);
    gl64_t kC1208 = (tmp3_1 + tmp3_2) * (s1_1208_1 + s1_1208_2);
    gl64_t kD1208 = tmp3_0 * s1_1208_0;
    gl64_t kE1208 = tmp3_1 * s1_1208_1;
    gl64_t kF1208 = tmp3_2 * s1_1208_2;
    gl64_t kG1208 = kD1208 - kE1208;
    tmp3_0 = (kC1208 + kG1208) - kF1208;
    tmp3_1 = ((((kA1208 + kC1208) - kE1208) - kE1208) - kD1208);
    tmp3_2 = kB1208 - kG1208;
    // Op 1209: dim3x1 add
    gl64_t s1_1209 = *(gl64_t*)&expressions_params[9][9];
    tmp3_0 = tmp3_0 + s1_1209; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1210: dim3x3 mul
    gl64_t s1_1210_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1210_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1210_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1210 = (tmp3_0 + tmp3_1) * (s1_1210_0 + s1_1210_1);
    gl64_t kB1210 = (tmp3_0 + tmp3_2) * (s1_1210_0 + s1_1210_2);
    gl64_t kC1210 = (tmp3_1 + tmp3_2) * (s1_1210_1 + s1_1210_2);
    gl64_t kD1210 = tmp3_0 * s1_1210_0;
    gl64_t kE1210 = tmp3_1 * s1_1210_1;
    gl64_t kF1210 = tmp3_2 * s1_1210_2;
    gl64_t kG1210 = kD1210 - kE1210;
    tmp3_0 = (kC1210 + kG1210) - kF1210;
    tmp3_1 = ((((kA1210 + kC1210) - kE1210) - kE1210) - kD1210);
    tmp3_2 = kB1210 - kG1210;
    // Op 1211: dim3x1 add
    gl64_t s1_1211 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1211; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1212: dim3x3 mul
    gl64_t s1_1212_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1212_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1212_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1213: dim3x1 add
    gl64_t s1_1213 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1213; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1214: dim3x3 add
    gl64_t s1_1214_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1214_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1214_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1214_0; tmp3_1 = tmp3_1 + s1_1214_1; tmp3_2 = tmp3_2 + s1_1214_2;
    // Op 1215: dim3x3 mul
    gl64_t s1_1215_0 = *(gl64_t*)&expressions_params[10][245];
    gl64_t s1_1215_1 = *(gl64_t*)&expressions_params[10][245+1];
    gl64_t s1_1215_2 = *(gl64_t*)&expressions_params[10][245+2];
    gl64_t kA1215 = (tmp3_0 + tmp3_1) * (s1_1215_0 + s1_1215_1);
    gl64_t kB1215 = (tmp3_0 + tmp3_2) * (s1_1215_0 + s1_1215_2);
    gl64_t kC1215 = (tmp3_1 + tmp3_2) * (s1_1215_1 + s1_1215_2);
    gl64_t kD1215 = tmp3_0 * s1_1215_0;
    gl64_t kE1215 = tmp3_1 * s1_1215_1;
    gl64_t kF1215 = tmp3_2 * s1_1215_2;
    gl64_t kG1215 = kD1215 - kE1215;
    tmp3_0 = (kC1215 + kG1215) - kF1215;
    tmp3_1 = ((((kA1215 + kC1215) - kE1215) - kE1215) - kD1215);
    tmp3_2 = kB1215 - kG1215;
    // Op 1216: dim3x1 sub
    gl64_t s1_1216 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1216; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1217: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1218: dim3x3 mul
    gl64_t s1_1218_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1218_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1218_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1218 = (tmp3_0 + tmp3_1) * (s1_1218_0 + s1_1218_1);
    gl64_t kB1218 = (tmp3_0 + tmp3_2) * (s1_1218_0 + s1_1218_2);
    gl64_t kC1218 = (tmp3_1 + tmp3_2) * (s1_1218_1 + s1_1218_2);
    gl64_t kD1218 = tmp3_0 * s1_1218_0;
    gl64_t kE1218 = tmp3_1 * s1_1218_1;
    gl64_t kF1218 = tmp3_2 * s1_1218_2;
    gl64_t kG1218 = kD1218 - kE1218;
    tmp3_6 = (kC1218 + kG1218) - kF1218;
    tmp3_7 = ((((kA1218 + kC1218) - kE1218) - kE1218) - kD1218);
    tmp3_8 = kB1218 - kG1218;
    // Op 1219: dim3x1 mul
    gl64_t s0_1219_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1219_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1219_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1219 = *(gl64_t*)&expressions_params[10][39];
    tmp3_0 = s0_1219_0 * s1_1219; tmp3_1 = s0_1219_1 * s1_1219; tmp3_2 = s0_1219_2 * s1_1219;
    // Op 1220: dim3x1 add
    gl64_t s1_1220 = *(gl64_t*)&expressions_params[10][38];
    tmp3_0 = tmp3_0 + s1_1220; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1221: dim3x3 mul
    gl64_t s1_1221_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1221_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1221_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1221 = (tmp3_0 + tmp3_1) * (s1_1221_0 + s1_1221_1);
    gl64_t kB1221 = (tmp3_0 + tmp3_2) * (s1_1221_0 + s1_1221_2);
    gl64_t kC1221 = (tmp3_1 + tmp3_2) * (s1_1221_1 + s1_1221_2);
    gl64_t kD1221 = tmp3_0 * s1_1221_0;
    gl64_t kE1221 = tmp3_1 * s1_1221_1;
    gl64_t kF1221 = tmp3_2 * s1_1221_2;
    gl64_t kG1221 = kD1221 - kE1221;
    tmp3_0 = (kC1221 + kG1221) - kF1221;
    tmp3_1 = ((((kA1221 + kC1221) - kE1221) - kE1221) - kD1221);
    tmp3_2 = kB1221 - kG1221;
    // Op 1222: dim3x1 add
    gl64_t s1_1222 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1222; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1223: dim3x3 mul
    gl64_t s1_1223_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1223_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1223_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1223 = (tmp3_0 + tmp3_1) * (s1_1223_0 + s1_1223_1);
    gl64_t kB1223 = (tmp3_0 + tmp3_2) * (s1_1223_0 + s1_1223_2);
    gl64_t kC1223 = (tmp3_1 + tmp3_2) * (s1_1223_1 + s1_1223_2);
    gl64_t kD1223 = tmp3_0 * s1_1223_0;
    gl64_t kE1223 = tmp3_1 * s1_1223_1;
    gl64_t kF1223 = tmp3_2 * s1_1223_2;
    gl64_t kG1223 = kD1223 - kE1223;
    tmp3_0 = (kC1223 + kG1223) - kF1223;
    tmp3_1 = ((((kA1223 + kC1223) - kE1223) - kE1223) - kD1223);
    tmp3_2 = kB1223 - kG1223;
    // Op 1224: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1225: dim3x3 mul
    gl64_t s1_1225_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1225_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1225_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1225 = (tmp3_0 + tmp3_1) * (s1_1225_0 + s1_1225_1);
    gl64_t kB1225 = (tmp3_0 + tmp3_2) * (s1_1225_0 + s1_1225_2);
    gl64_t kC1225 = (tmp3_1 + tmp3_2) * (s1_1225_1 + s1_1225_2);
    gl64_t kD1225 = tmp3_0 * s1_1225_0;
    gl64_t kE1225 = tmp3_1 * s1_1225_1;
    gl64_t kF1225 = tmp3_2 * s1_1225_2;
    gl64_t kG1225 = kD1225 - kE1225;
    tmp3_0 = (kC1225 + kG1225) - kF1225;
    tmp3_1 = ((((kA1225 + kC1225) - kE1225) - kE1225) - kD1225);
    tmp3_2 = kB1225 - kG1225;
    // Op 1226: dim3x1 add
    gl64_t s1_1226 = *(gl64_t*)&expressions_params[9][9];
    tmp3_0 = tmp3_0 + s1_1226; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1227: dim3x3 mul
    gl64_t s1_1227_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1227_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1227_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1227 = (tmp3_0 + tmp3_1) * (s1_1227_0 + s1_1227_1);
    gl64_t kB1227 = (tmp3_0 + tmp3_2) * (s1_1227_0 + s1_1227_2);
    gl64_t kC1227 = (tmp3_1 + tmp3_2) * (s1_1227_1 + s1_1227_2);
    gl64_t kD1227 = tmp3_0 * s1_1227_0;
    gl64_t kE1227 = tmp3_1 * s1_1227_1;
    gl64_t kF1227 = tmp3_2 * s1_1227_2;
    gl64_t kG1227 = kD1227 - kE1227;
    tmp3_0 = (kC1227 + kG1227) - kF1227;
    tmp3_1 = ((((kA1227 + kC1227) - kE1227) - kE1227) - kD1227);
    tmp3_2 = kB1227 - kG1227;
    // Op 1228: dim3x1 add
    gl64_t s1_1228 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1228; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1229: dim3x3 mul
    gl64_t s1_1229_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1229_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1229_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1230: dim3x1 add
    gl64_t s1_1230 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1230; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1231: dim3x3 add
    gl64_t s1_1231_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1231_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1231_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1231_0; tmp3_1 = tmp3_1 + s1_1231_1; tmp3_2 = tmp3_2 + s1_1231_2;
    // Op 1232: dim3x3 mul
    gl64_t s1_1232_0 = *(gl64_t*)&expressions_params[10][248];
    gl64_t s1_1232_1 = *(gl64_t*)&expressions_params[10][248+1];
    gl64_t s1_1232_2 = *(gl64_t*)&expressions_params[10][248+2];
    gl64_t kA1232 = (tmp3_0 + tmp3_1) * (s1_1232_0 + s1_1232_1);
    gl64_t kB1232 = (tmp3_0 + tmp3_2) * (s1_1232_0 + s1_1232_2);
    gl64_t kC1232 = (tmp3_1 + tmp3_2) * (s1_1232_1 + s1_1232_2);
    gl64_t kD1232 = tmp3_0 * s1_1232_0;
    gl64_t kE1232 = tmp3_1 * s1_1232_1;
    gl64_t kF1232 = tmp3_2 * s1_1232_2;
    gl64_t kG1232 = kD1232 - kE1232;
    tmp3_0 = (kC1232 + kG1232) - kF1232;
    tmp3_1 = ((((kA1232 + kC1232) - kE1232) - kE1232) - kD1232);
    tmp3_2 = kB1232 - kG1232;
    // Op 1233: dim1x1 sub
    gl64_t s0_1233 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1233 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1233 - s1_1233;
    // Op 1234: dim1x1 sub_swap
    gl64_t s1_1234 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1234 - tmp1_0;
    // Op 1235: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1236: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1237: dim3x3 mul
    gl64_t s1_1237_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1237_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1237_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1237 = (tmp3_0 + tmp3_1) * (s1_1237_0 + s1_1237_1);
    gl64_t kB1237 = (tmp3_0 + tmp3_2) * (s1_1237_0 + s1_1237_2);
    gl64_t kC1237 = (tmp3_1 + tmp3_2) * (s1_1237_1 + s1_1237_2);
    gl64_t kD1237 = tmp3_0 * s1_1237_0;
    gl64_t kE1237 = tmp3_1 * s1_1237_1;
    gl64_t kF1237 = tmp3_2 * s1_1237_2;
    gl64_t kG1237 = kD1237 - kE1237;
    tmp3_6 = (kC1237 + kG1237) - kF1237;
    tmp3_7 = ((((kA1237 + kC1237) - kE1237) - kE1237) - kD1237);
    tmp3_8 = kB1237 - kG1237;
    // Op 1238: dim1x1 sub
    gl64_t s1_1238 = *(gl64_t*)&expressions_params[10][86];
    tmp1_0 = tmp1_4 - s1_1238;
    // Op 1239: dim1x1 sub
    gl64_t s1_1239 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1239;
    // Op 1240: dim3x1 mul
    gl64_t s0_1240_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1240_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1240_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1240_0 * tmp1_0; tmp3_1 = s0_1240_1 * tmp1_0; tmp3_2 = s0_1240_2 * tmp1_0;
    // Op 1241: dim3x1 add
    gl64_t s1_1241 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1241; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1242: dim3x3 add
    gl64_t s1_1242_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1242_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1242_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1242_0; tmp3_1 = tmp3_1 + s1_1242_1; tmp3_2 = tmp3_2 + s1_1242_2;
    // Op 1243: dim3x3 mul
    gl64_t s1_1243_0 = *(gl64_t*)&expressions_params[10][251];
    gl64_t s1_1243_1 = *(gl64_t*)&expressions_params[10][251+1];
    gl64_t s1_1243_2 = *(gl64_t*)&expressions_params[10][251+2];
    gl64_t kA1243 = (tmp3_0 + tmp3_1) * (s1_1243_0 + s1_1243_1);
    gl64_t kB1243 = (tmp3_0 + tmp3_2) * (s1_1243_0 + s1_1243_2);
    gl64_t kC1243 = (tmp3_1 + tmp3_2) * (s1_1243_1 + s1_1243_2);
    gl64_t kD1243 = tmp3_0 * s1_1243_0;
    gl64_t kE1243 = tmp3_1 * s1_1243_1;
    gl64_t kF1243 = tmp3_2 * s1_1243_2;
    gl64_t kG1243 = kD1243 - kE1243;
    tmp3_0 = (kC1243 + kG1243) - kF1243;
    tmp3_1 = ((((kA1243 + kC1243) - kE1243) - kE1243) - kD1243);
    tmp3_2 = kB1243 - kG1243;
    // Op 1244: dim3x1 add
    gl64_t s1_1244 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1244; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1245: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1246: dim3x3 mul
    gl64_t s1_1246_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1246_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1246_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1246 = (tmp3_0 + tmp3_1) * (s1_1246_0 + s1_1246_1);
    gl64_t kB1246 = (tmp3_0 + tmp3_2) * (s1_1246_0 + s1_1246_2);
    gl64_t kC1246 = (tmp3_1 + tmp3_2) * (s1_1246_1 + s1_1246_2);
    gl64_t kD1246 = tmp3_0 * s1_1246_0;
    gl64_t kE1246 = tmp3_1 * s1_1246_1;
    gl64_t kF1246 = tmp3_2 * s1_1246_2;
    gl64_t kG1246 = kD1246 - kE1246;
    tmp3_6 = (kC1246 + kG1246) - kF1246;
    tmp3_7 = ((((kA1246 + kC1246) - kE1246) - kE1246) - kD1246);
    tmp3_8 = kB1246 - kG1246;
    // Op 1247: dim3x1 mul
    gl64_t s0_1247_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1247_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1247_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1247 = *(gl64_t*)&expressions_params[10][41];
    tmp3_0 = s0_1247_0 * s1_1247; tmp3_1 = s0_1247_1 * s1_1247; tmp3_2 = s0_1247_2 * s1_1247;
    // Op 1248: dim3x1 add
    gl64_t s1_1248 = *(gl64_t*)&expressions_params[10][40];
    tmp3_0 = tmp3_0 + s1_1248; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1249: dim3x3 mul
    gl64_t s1_1249_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1249_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1249_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1249 = (tmp3_0 + tmp3_1) * (s1_1249_0 + s1_1249_1);
    gl64_t kB1249 = (tmp3_0 + tmp3_2) * (s1_1249_0 + s1_1249_2);
    gl64_t kC1249 = (tmp3_1 + tmp3_2) * (s1_1249_1 + s1_1249_2);
    gl64_t kD1249 = tmp3_0 * s1_1249_0;
    gl64_t kE1249 = tmp3_1 * s1_1249_1;
    gl64_t kF1249 = tmp3_2 * s1_1249_2;
    gl64_t kG1249 = kD1249 - kE1249;
    tmp3_0 = (kC1249 + kG1249) - kF1249;
    tmp3_1 = ((((kA1249 + kC1249) - kE1249) - kE1249) - kD1249);
    tmp3_2 = kB1249 - kG1249;
    // Op 1250: dim3x1 add
    gl64_t s1_1250 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1250; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1251: dim3x3 mul
    gl64_t s1_1251_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1251_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1251_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1251 = (tmp3_0 + tmp3_1) * (s1_1251_0 + s1_1251_1);
    gl64_t kB1251 = (tmp3_0 + tmp3_2) * (s1_1251_0 + s1_1251_2);
    gl64_t kC1251 = (tmp3_1 + tmp3_2) * (s1_1251_1 + s1_1251_2);
    gl64_t kD1251 = tmp3_0 * s1_1251_0;
    gl64_t kE1251 = tmp3_1 * s1_1251_1;
    gl64_t kF1251 = tmp3_2 * s1_1251_2;
    gl64_t kG1251 = kD1251 - kE1251;
    tmp3_0 = (kC1251 + kG1251) - kF1251;
    tmp3_1 = ((((kA1251 + kC1251) - kE1251) - kE1251) - kD1251);
    tmp3_2 = kB1251 - kG1251;
    // Op 1252: dim3x1 add
    gl64_t s1_1252 = *(gl64_t*)&expressions_params[10][86];
    tmp3_0 = tmp3_0 + s1_1252; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1253: dim3x3 mul
    gl64_t s1_1253_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1253_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1253_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1253 = (tmp3_0 + tmp3_1) * (s1_1253_0 + s1_1253_1);
    gl64_t kB1253 = (tmp3_0 + tmp3_2) * (s1_1253_0 + s1_1253_2);
    gl64_t kC1253 = (tmp3_1 + tmp3_2) * (s1_1253_1 + s1_1253_2);
    gl64_t kD1253 = tmp3_0 * s1_1253_0;
    gl64_t kE1253 = tmp3_1 * s1_1253_1;
    gl64_t kF1253 = tmp3_2 * s1_1253_2;
    gl64_t kG1253 = kD1253 - kE1253;
    tmp3_0 = (kC1253 + kG1253) - kF1253;
    tmp3_1 = ((((kA1253 + kC1253) - kE1253) - kE1253) - kD1253);
    tmp3_2 = kB1253 - kG1253;
    // Op 1254: dim3x1 add
    gl64_t s1_1254 = *(gl64_t*)&expressions_params[9][33];
    tmp3_0 = tmp3_0 + s1_1254; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1255: dim3x3 mul
    gl64_t s1_1255_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1255_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1255_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1255 = (tmp3_0 + tmp3_1) * (s1_1255_0 + s1_1255_1);
    gl64_t kB1255 = (tmp3_0 + tmp3_2) * (s1_1255_0 + s1_1255_2);
    gl64_t kC1255 = (tmp3_1 + tmp3_2) * (s1_1255_1 + s1_1255_2);
    gl64_t kD1255 = tmp3_0 * s1_1255_0;
    gl64_t kE1255 = tmp3_1 * s1_1255_1;
    gl64_t kF1255 = tmp3_2 * s1_1255_2;
    gl64_t kG1255 = kD1255 - kE1255;
    tmp3_0 = (kC1255 + kG1255) - kF1255;
    tmp3_1 = ((((kA1255 + kC1255) - kE1255) - kE1255) - kD1255);
    tmp3_2 = kB1255 - kG1255;
    // Op 1256: dim3x1 add
    gl64_t s1_1256 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1256; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1257: dim3x3 mul
    gl64_t s1_1257_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1257_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1257_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1258: dim3x1 add
    gl64_t s1_1258 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1258; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1259: dim3x3 add
    gl64_t s1_1259_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1259_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1259_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1259_0; tmp3_1 = tmp3_1 + s1_1259_1; tmp3_2 = tmp3_2 + s1_1259_2;
    // Op 1260: dim3x3 mul
    gl64_t s1_1260_0 = *(gl64_t*)&expressions_params[10][254];
    gl64_t s1_1260_1 = *(gl64_t*)&expressions_params[10][254+1];
    gl64_t s1_1260_2 = *(gl64_t*)&expressions_params[10][254+2];
    gl64_t kA1260 = (tmp3_0 + tmp3_1) * (s1_1260_0 + s1_1260_1);
    gl64_t kB1260 = (tmp3_0 + tmp3_2) * (s1_1260_0 + s1_1260_2);
    gl64_t kC1260 = (tmp3_1 + tmp3_2) * (s1_1260_1 + s1_1260_2);
    gl64_t kD1260 = tmp3_0 * s1_1260_0;
    gl64_t kE1260 = tmp3_1 * s1_1260_1;
    gl64_t kF1260 = tmp3_2 * s1_1260_2;
    gl64_t kG1260 = kD1260 - kE1260;
    tmp3_0 = (kC1260 + kG1260) - kF1260;
    tmp3_1 = ((((kA1260 + kC1260) - kE1260) - kE1260) - kD1260);
    tmp3_2 = kB1260 - kG1260;
    // Op 1261: dim3x1 sub
    gl64_t s1_1261 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1261; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1262: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1263: dim3x3 mul
    gl64_t s1_1263_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1263_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1263_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1263 = (tmp3_0 + tmp3_1) * (s1_1263_0 + s1_1263_1);
    gl64_t kB1263 = (tmp3_0 + tmp3_2) * (s1_1263_0 + s1_1263_2);
    gl64_t kC1263 = (tmp3_1 + tmp3_2) * (s1_1263_1 + s1_1263_2);
    gl64_t kD1263 = tmp3_0 * s1_1263_0;
    gl64_t kE1263 = tmp3_1 * s1_1263_1;
    gl64_t kF1263 = tmp3_2 * s1_1263_2;
    gl64_t kG1263 = kD1263 - kE1263;
    tmp3_6 = (kC1263 + kG1263) - kF1263;
    tmp3_7 = ((((kA1263 + kC1263) - kE1263) - kE1263) - kD1263);
    tmp3_8 = kB1263 - kG1263;
    // Op 1264: dim3x1 mul
    gl64_t s0_1264_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1264_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1264_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1264 = *(gl64_t*)&expressions_params[10][41];
    tmp3_0 = s0_1264_0 * s1_1264; tmp3_1 = s0_1264_1 * s1_1264; tmp3_2 = s0_1264_2 * s1_1264;
    // Op 1265: dim3x1 add
    gl64_t s1_1265 = *(gl64_t*)&expressions_params[10][40];
    tmp3_0 = tmp3_0 + s1_1265; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1266: dim3x3 mul
    gl64_t s1_1266_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1266_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1266_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1266 = (tmp3_0 + tmp3_1) * (s1_1266_0 + s1_1266_1);
    gl64_t kB1266 = (tmp3_0 + tmp3_2) * (s1_1266_0 + s1_1266_2);
    gl64_t kC1266 = (tmp3_1 + tmp3_2) * (s1_1266_1 + s1_1266_2);
    gl64_t kD1266 = tmp3_0 * s1_1266_0;
    gl64_t kE1266 = tmp3_1 * s1_1266_1;
    gl64_t kF1266 = tmp3_2 * s1_1266_2;
    gl64_t kG1266 = kD1266 - kE1266;
    tmp3_0 = (kC1266 + kG1266) - kF1266;
    tmp3_1 = ((((kA1266 + kC1266) - kE1266) - kE1266) - kD1266);
    tmp3_2 = kB1266 - kG1266;
    // Op 1267: dim3x1 add
    gl64_t s1_1267 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1267; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1268: dim3x3 mul
    gl64_t s1_1268_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1268_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1268_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1268 = (tmp3_0 + tmp3_1) * (s1_1268_0 + s1_1268_1);
    gl64_t kB1268 = (tmp3_0 + tmp3_2) * (s1_1268_0 + s1_1268_2);
    gl64_t kC1268 = (tmp3_1 + tmp3_2) * (s1_1268_1 + s1_1268_2);
    gl64_t kD1268 = tmp3_0 * s1_1268_0;
    gl64_t kE1268 = tmp3_1 * s1_1268_1;
    gl64_t kF1268 = tmp3_2 * s1_1268_2;
    gl64_t kG1268 = kD1268 - kE1268;
    tmp3_0 = (kC1268 + kG1268) - kF1268;
    tmp3_1 = ((((kA1268 + kC1268) - kE1268) - kE1268) - kD1268);
    tmp3_2 = kB1268 - kG1268;
    // Op 1269: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1270: dim3x3 mul
    gl64_t s1_1270_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1270_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1270_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1270 = (tmp3_0 + tmp3_1) * (s1_1270_0 + s1_1270_1);
    gl64_t kB1270 = (tmp3_0 + tmp3_2) * (s1_1270_0 + s1_1270_2);
    gl64_t kC1270 = (tmp3_1 + tmp3_2) * (s1_1270_1 + s1_1270_2);
    gl64_t kD1270 = tmp3_0 * s1_1270_0;
    gl64_t kE1270 = tmp3_1 * s1_1270_1;
    gl64_t kF1270 = tmp3_2 * s1_1270_2;
    gl64_t kG1270 = kD1270 - kE1270;
    tmp3_0 = (kC1270 + kG1270) - kF1270;
    tmp3_1 = ((((kA1270 + kC1270) - kE1270) - kE1270) - kD1270);
    tmp3_2 = kB1270 - kG1270;
    // Op 1271: dim3x1 add
    gl64_t s1_1271 = *(gl64_t*)&expressions_params[9][33];
    tmp3_0 = tmp3_0 + s1_1271; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1272: dim3x3 mul
    gl64_t s1_1272_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1272_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1272_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1272 = (tmp3_0 + tmp3_1) * (s1_1272_0 + s1_1272_1);
    gl64_t kB1272 = (tmp3_0 + tmp3_2) * (s1_1272_0 + s1_1272_2);
    gl64_t kC1272 = (tmp3_1 + tmp3_2) * (s1_1272_1 + s1_1272_2);
    gl64_t kD1272 = tmp3_0 * s1_1272_0;
    gl64_t kE1272 = tmp3_1 * s1_1272_1;
    gl64_t kF1272 = tmp3_2 * s1_1272_2;
    gl64_t kG1272 = kD1272 - kE1272;
    tmp3_0 = (kC1272 + kG1272) - kF1272;
    tmp3_1 = ((((kA1272 + kC1272) - kE1272) - kE1272) - kD1272);
    tmp3_2 = kB1272 - kG1272;
    // Op 1273: dim3x1 add
    gl64_t s1_1273 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1273; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1274: dim3x3 mul
    gl64_t s1_1274_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1274_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1274_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1275: dim3x1 add
    gl64_t s1_1275 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1275; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1276: dim3x3 add
    gl64_t s1_1276_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1276_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1276_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1276_0; tmp3_1 = tmp3_1 + s1_1276_1; tmp3_2 = tmp3_2 + s1_1276_2;
    // Op 1277: dim3x3 mul
    gl64_t s1_1277_0 = *(gl64_t*)&expressions_params[10][257];
    gl64_t s1_1277_1 = *(gl64_t*)&expressions_params[10][257+1];
    gl64_t s1_1277_2 = *(gl64_t*)&expressions_params[10][257+2];
    gl64_t kA1277 = (tmp3_0 + tmp3_1) * (s1_1277_0 + s1_1277_1);
    gl64_t kB1277 = (tmp3_0 + tmp3_2) * (s1_1277_0 + s1_1277_2);
    gl64_t kC1277 = (tmp3_1 + tmp3_2) * (s1_1277_1 + s1_1277_2);
    gl64_t kD1277 = tmp3_0 * s1_1277_0;
    gl64_t kE1277 = tmp3_1 * s1_1277_1;
    gl64_t kF1277 = tmp3_2 * s1_1277_2;
    gl64_t kG1277 = kD1277 - kE1277;
    tmp3_0 = (kC1277 + kG1277) - kF1277;
    tmp3_1 = ((((kA1277 + kC1277) - kE1277) - kE1277) - kD1277);
    tmp3_2 = kB1277 - kG1277;
    // Op 1278: dim1x1 sub
    gl64_t s0_1278 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1278 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1278 - s1_1278;
    // Op 1279: dim1x1 sub_swap
    gl64_t s1_1279 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1279 - tmp1_0;
    // Op 1280: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1281: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1282: dim3x3 mul
    gl64_t s1_1282_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1282_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1282_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1282 = (tmp3_0 + tmp3_1) * (s1_1282_0 + s1_1282_1);
    gl64_t kB1282 = (tmp3_0 + tmp3_2) * (s1_1282_0 + s1_1282_2);
    gl64_t kC1282 = (tmp3_1 + tmp3_2) * (s1_1282_1 + s1_1282_2);
    gl64_t kD1282 = tmp3_0 * s1_1282_0;
    gl64_t kE1282 = tmp3_1 * s1_1282_1;
    gl64_t kF1282 = tmp3_2 * s1_1282_2;
    gl64_t kG1282 = kD1282 - kE1282;
    tmp3_6 = (kC1282 + kG1282) - kF1282;
    tmp3_7 = ((((kA1282 + kC1282) - kE1282) - kE1282) - kD1282);
    tmp3_8 = kB1282 - kG1282;
    // Op 1283: dim1x1 sub
    gl64_t s1_1283 = *(gl64_t*)&expressions_params[10][87];
    tmp1_0 = tmp1_4 - s1_1283;
    // Op 1284: dim1x1 sub
    gl64_t s1_1284 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1284;
    // Op 1285: dim3x1 mul
    gl64_t s0_1285_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1285_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1285_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1285_0 * tmp1_0; tmp3_1 = s0_1285_1 * tmp1_0; tmp3_2 = s0_1285_2 * tmp1_0;
    // Op 1286: dim3x1 add
    gl64_t s1_1286 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1286; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1287: dim3x3 add
    gl64_t s1_1287_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1287_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1287_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1287_0; tmp3_1 = tmp3_1 + s1_1287_1; tmp3_2 = tmp3_2 + s1_1287_2;
    // Op 1288: dim3x3 mul
    gl64_t s1_1288_0 = *(gl64_t*)&expressions_params[10][260];
    gl64_t s1_1288_1 = *(gl64_t*)&expressions_params[10][260+1];
    gl64_t s1_1288_2 = *(gl64_t*)&expressions_params[10][260+2];
    gl64_t kA1288 = (tmp3_0 + tmp3_1) * (s1_1288_0 + s1_1288_1);
    gl64_t kB1288 = (tmp3_0 + tmp3_2) * (s1_1288_0 + s1_1288_2);
    gl64_t kC1288 = (tmp3_1 + tmp3_2) * (s1_1288_1 + s1_1288_2);
    gl64_t kD1288 = tmp3_0 * s1_1288_0;
    gl64_t kE1288 = tmp3_1 * s1_1288_1;
    gl64_t kF1288 = tmp3_2 * s1_1288_2;
    gl64_t kG1288 = kD1288 - kE1288;
    tmp3_0 = (kC1288 + kG1288) - kF1288;
    tmp3_1 = ((((kA1288 + kC1288) - kE1288) - kE1288) - kD1288);
    tmp3_2 = kB1288 - kG1288;
    // Op 1289: dim3x1 add
    gl64_t s1_1289 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1289; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1290: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1291: dim3x3 mul
    gl64_t s1_1291_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1291_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1291_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1291 = (tmp3_0 + tmp3_1) * (s1_1291_0 + s1_1291_1);
    gl64_t kB1291 = (tmp3_0 + tmp3_2) * (s1_1291_0 + s1_1291_2);
    gl64_t kC1291 = (tmp3_1 + tmp3_2) * (s1_1291_1 + s1_1291_2);
    gl64_t kD1291 = tmp3_0 * s1_1291_0;
    gl64_t kE1291 = tmp3_1 * s1_1291_1;
    gl64_t kF1291 = tmp3_2 * s1_1291_2;
    gl64_t kG1291 = kD1291 - kE1291;
    tmp3_6 = (kC1291 + kG1291) - kF1291;
    tmp3_7 = ((((kA1291 + kC1291) - kE1291) - kE1291) - kD1291);
    tmp3_8 = kB1291 - kG1291;
    // Op 1292: dim3x1 mul
    gl64_t s0_1292_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1292_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1292_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1292 = *(gl64_t*)&expressions_params[10][43];
    tmp3_0 = s0_1292_0 * s1_1292; tmp3_1 = s0_1292_1 * s1_1292; tmp3_2 = s0_1292_2 * s1_1292;
    // Op 1293: dim3x1 add
    gl64_t s1_1293 = *(gl64_t*)&expressions_params[10][42];
    tmp3_0 = tmp3_0 + s1_1293; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1294: dim3x3 mul
    gl64_t s1_1294_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1294_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1294_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1294 = (tmp3_0 + tmp3_1) * (s1_1294_0 + s1_1294_1);
    gl64_t kB1294 = (tmp3_0 + tmp3_2) * (s1_1294_0 + s1_1294_2);
    gl64_t kC1294 = (tmp3_1 + tmp3_2) * (s1_1294_1 + s1_1294_2);
    gl64_t kD1294 = tmp3_0 * s1_1294_0;
    gl64_t kE1294 = tmp3_1 * s1_1294_1;
    gl64_t kF1294 = tmp3_2 * s1_1294_2;
    gl64_t kG1294 = kD1294 - kE1294;
    tmp3_0 = (kC1294 + kG1294) - kF1294;
    tmp3_1 = ((((kA1294 + kC1294) - kE1294) - kE1294) - kD1294);
    tmp3_2 = kB1294 - kG1294;
    // Op 1295: dim3x1 add
    gl64_t s1_1295 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1295; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1296: dim3x3 mul
    gl64_t s1_1296_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1296_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1296_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1296 = (tmp3_0 + tmp3_1) * (s1_1296_0 + s1_1296_1);
    gl64_t kB1296 = (tmp3_0 + tmp3_2) * (s1_1296_0 + s1_1296_2);
    gl64_t kC1296 = (tmp3_1 + tmp3_2) * (s1_1296_1 + s1_1296_2);
    gl64_t kD1296 = tmp3_0 * s1_1296_0;
    gl64_t kE1296 = tmp3_1 * s1_1296_1;
    gl64_t kF1296 = tmp3_2 * s1_1296_2;
    gl64_t kG1296 = kD1296 - kE1296;
    tmp3_0 = (kC1296 + kG1296) - kF1296;
    tmp3_1 = ((((kA1296 + kC1296) - kE1296) - kE1296) - kD1296);
    tmp3_2 = kB1296 - kG1296;
    // Op 1297: dim3x1 add
    gl64_t s1_1297 = *(gl64_t*)&expressions_params[10][87];
    tmp3_0 = tmp3_0 + s1_1297; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1298: dim3x3 mul
    gl64_t s1_1298_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1298_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1298_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1298 = (tmp3_0 + tmp3_1) * (s1_1298_0 + s1_1298_1);
    gl64_t kB1298 = (tmp3_0 + tmp3_2) * (s1_1298_0 + s1_1298_2);
    gl64_t kC1298 = (tmp3_1 + tmp3_2) * (s1_1298_1 + s1_1298_2);
    gl64_t kD1298 = tmp3_0 * s1_1298_0;
    gl64_t kE1298 = tmp3_1 * s1_1298_1;
    gl64_t kF1298 = tmp3_2 * s1_1298_2;
    gl64_t kG1298 = kD1298 - kE1298;
    tmp3_0 = (kC1298 + kG1298) - kF1298;
    tmp3_1 = ((((kA1298 + kC1298) - kE1298) - kE1298) - kD1298);
    tmp3_2 = kB1298 - kG1298;
    // Op 1299: dim3x1 add
    gl64_t s1_1299 = *(gl64_t*)&expressions_params[9][34];
    tmp3_0 = tmp3_0 + s1_1299; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1300: dim3x3 mul
    gl64_t s1_1300_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1300_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1300_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1300 = (tmp3_0 + tmp3_1) * (s1_1300_0 + s1_1300_1);
    gl64_t kB1300 = (tmp3_0 + tmp3_2) * (s1_1300_0 + s1_1300_2);
    gl64_t kC1300 = (tmp3_1 + tmp3_2) * (s1_1300_1 + s1_1300_2);
    gl64_t kD1300 = tmp3_0 * s1_1300_0;
    gl64_t kE1300 = tmp3_1 * s1_1300_1;
    gl64_t kF1300 = tmp3_2 * s1_1300_2;
    gl64_t kG1300 = kD1300 - kE1300;
    tmp3_0 = (kC1300 + kG1300) - kF1300;
    tmp3_1 = ((((kA1300 + kC1300) - kE1300) - kE1300) - kD1300);
    tmp3_2 = kB1300 - kG1300;
    // Op 1301: dim3x1 add
    gl64_t s1_1301 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1301; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1302: dim3x3 mul
    gl64_t s1_1302_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1302_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1302_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1303: dim3x1 add
    gl64_t s1_1303 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1303; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1304: dim3x3 add
    gl64_t s1_1304_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1304_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1304_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1304_0; tmp3_1 = tmp3_1 + s1_1304_1; tmp3_2 = tmp3_2 + s1_1304_2;
    // Op 1305: dim3x3 mul
    gl64_t s1_1305_0 = *(gl64_t*)&expressions_params[10][263];
    gl64_t s1_1305_1 = *(gl64_t*)&expressions_params[10][263+1];
    gl64_t s1_1305_2 = *(gl64_t*)&expressions_params[10][263+2];
    gl64_t kA1305 = (tmp3_0 + tmp3_1) * (s1_1305_0 + s1_1305_1);
    gl64_t kB1305 = (tmp3_0 + tmp3_2) * (s1_1305_0 + s1_1305_2);
    gl64_t kC1305 = (tmp3_1 + tmp3_2) * (s1_1305_1 + s1_1305_2);
    gl64_t kD1305 = tmp3_0 * s1_1305_0;
    gl64_t kE1305 = tmp3_1 * s1_1305_1;
    gl64_t kF1305 = tmp3_2 * s1_1305_2;
    gl64_t kG1305 = kD1305 - kE1305;
    tmp3_0 = (kC1305 + kG1305) - kF1305;
    tmp3_1 = ((((kA1305 + kC1305) - kE1305) - kE1305) - kD1305);
    tmp3_2 = kB1305 - kG1305;
    // Op 1306: dim3x1 sub
    gl64_t s1_1306 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1306; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1307: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1308: dim3x3 mul
    gl64_t s1_1308_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1308_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1308_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1308 = (tmp3_0 + tmp3_1) * (s1_1308_0 + s1_1308_1);
    gl64_t kB1308 = (tmp3_0 + tmp3_2) * (s1_1308_0 + s1_1308_2);
    gl64_t kC1308 = (tmp3_1 + tmp3_2) * (s1_1308_1 + s1_1308_2);
    gl64_t kD1308 = tmp3_0 * s1_1308_0;
    gl64_t kE1308 = tmp3_1 * s1_1308_1;
    gl64_t kF1308 = tmp3_2 * s1_1308_2;
    gl64_t kG1308 = kD1308 - kE1308;
    tmp3_6 = (kC1308 + kG1308) - kF1308;
    tmp3_7 = ((((kA1308 + kC1308) - kE1308) - kE1308) - kD1308);
    tmp3_8 = kB1308 - kG1308;
    // Op 1309: dim3x1 mul
    gl64_t s0_1309_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1309_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1309_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1309 = *(gl64_t*)&expressions_params[10][43];
    tmp3_0 = s0_1309_0 * s1_1309; tmp3_1 = s0_1309_1 * s1_1309; tmp3_2 = s0_1309_2 * s1_1309;
    // Op 1310: dim3x1 add
    gl64_t s1_1310 = *(gl64_t*)&expressions_params[10][42];
    tmp3_0 = tmp3_0 + s1_1310; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1311: dim3x3 mul
    gl64_t s1_1311_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1311_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1311_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1311 = (tmp3_0 + tmp3_1) * (s1_1311_0 + s1_1311_1);
    gl64_t kB1311 = (tmp3_0 + tmp3_2) * (s1_1311_0 + s1_1311_2);
    gl64_t kC1311 = (tmp3_1 + tmp3_2) * (s1_1311_1 + s1_1311_2);
    gl64_t kD1311 = tmp3_0 * s1_1311_0;
    gl64_t kE1311 = tmp3_1 * s1_1311_1;
    gl64_t kF1311 = tmp3_2 * s1_1311_2;
    gl64_t kG1311 = kD1311 - kE1311;
    tmp3_0 = (kC1311 + kG1311) - kF1311;
    tmp3_1 = ((((kA1311 + kC1311) - kE1311) - kE1311) - kD1311);
    tmp3_2 = kB1311 - kG1311;
    // Op 1312: dim3x1 add
    gl64_t s1_1312 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1312; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1313: dim3x3 mul
    gl64_t s1_1313_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1313_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1313_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1313 = (tmp3_0 + tmp3_1) * (s1_1313_0 + s1_1313_1);
    gl64_t kB1313 = (tmp3_0 + tmp3_2) * (s1_1313_0 + s1_1313_2);
    gl64_t kC1313 = (tmp3_1 + tmp3_2) * (s1_1313_1 + s1_1313_2);
    gl64_t kD1313 = tmp3_0 * s1_1313_0;
    gl64_t kE1313 = tmp3_1 * s1_1313_1;
    gl64_t kF1313 = tmp3_2 * s1_1313_2;
    gl64_t kG1313 = kD1313 - kE1313;
    tmp3_0 = (kC1313 + kG1313) - kF1313;
    tmp3_1 = ((((kA1313 + kC1313) - kE1313) - kE1313) - kD1313);
    tmp3_2 = kB1313 - kG1313;
    // Op 1314: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1315: dim3x3 mul
    gl64_t s1_1315_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1315_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1315_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1315 = (tmp3_0 + tmp3_1) * (s1_1315_0 + s1_1315_1);
    gl64_t kB1315 = (tmp3_0 + tmp3_2) * (s1_1315_0 + s1_1315_2);
    gl64_t kC1315 = (tmp3_1 + tmp3_2) * (s1_1315_1 + s1_1315_2);
    gl64_t kD1315 = tmp3_0 * s1_1315_0;
    gl64_t kE1315 = tmp3_1 * s1_1315_1;
    gl64_t kF1315 = tmp3_2 * s1_1315_2;
    gl64_t kG1315 = kD1315 - kE1315;
    tmp3_0 = (kC1315 + kG1315) - kF1315;
    tmp3_1 = ((((kA1315 + kC1315) - kE1315) - kE1315) - kD1315);
    tmp3_2 = kB1315 - kG1315;
    // Op 1316: dim3x1 add
    gl64_t s1_1316 = *(gl64_t*)&expressions_params[9][34];
    tmp3_0 = tmp3_0 + s1_1316; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1317: dim3x3 mul
    gl64_t s1_1317_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1317_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1317_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1317 = (tmp3_0 + tmp3_1) * (s1_1317_0 + s1_1317_1);
    gl64_t kB1317 = (tmp3_0 + tmp3_2) * (s1_1317_0 + s1_1317_2);
    gl64_t kC1317 = (tmp3_1 + tmp3_2) * (s1_1317_1 + s1_1317_2);
    gl64_t kD1317 = tmp3_0 * s1_1317_0;
    gl64_t kE1317 = tmp3_1 * s1_1317_1;
    gl64_t kF1317 = tmp3_2 * s1_1317_2;
    gl64_t kG1317 = kD1317 - kE1317;
    tmp3_0 = (kC1317 + kG1317) - kF1317;
    tmp3_1 = ((((kA1317 + kC1317) - kE1317) - kE1317) - kD1317);
    tmp3_2 = kB1317 - kG1317;
    // Op 1318: dim3x1 add
    gl64_t s1_1318 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1318; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1319: dim3x3 mul
    gl64_t s1_1319_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1319_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1319_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1320: dim3x1 add
    gl64_t s1_1320 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1320; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1321: dim3x3 add
    gl64_t s1_1321_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1321_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1321_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1321_0; tmp3_1 = tmp3_1 + s1_1321_1; tmp3_2 = tmp3_2 + s1_1321_2;
    // Op 1322: dim3x3 mul
    gl64_t s1_1322_0 = *(gl64_t*)&expressions_params[10][266];
    gl64_t s1_1322_1 = *(gl64_t*)&expressions_params[10][266+1];
    gl64_t s1_1322_2 = *(gl64_t*)&expressions_params[10][266+2];
    gl64_t kA1322 = (tmp3_0 + tmp3_1) * (s1_1322_0 + s1_1322_1);
    gl64_t kB1322 = (tmp3_0 + tmp3_2) * (s1_1322_0 + s1_1322_2);
    gl64_t kC1322 = (tmp3_1 + tmp3_2) * (s1_1322_1 + s1_1322_2);
    gl64_t kD1322 = tmp3_0 * s1_1322_0;
    gl64_t kE1322 = tmp3_1 * s1_1322_1;
    gl64_t kF1322 = tmp3_2 * s1_1322_2;
    gl64_t kG1322 = kD1322 - kE1322;
    tmp3_0 = (kC1322 + kG1322) - kF1322;
    tmp3_1 = ((((kA1322 + kC1322) - kE1322) - kE1322) - kD1322);
    tmp3_2 = kB1322 - kG1322;
    // Op 1323: dim1x1 sub
    gl64_t s0_1323 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1323 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1323 - s1_1323;
    // Op 1324: dim1x1 sub_swap
    gl64_t s1_1324 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1324 - tmp1_0;
    // Op 1325: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1326: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1327: dim3x3 mul
    gl64_t s1_1327_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1327_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1327_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1327 = (tmp3_0 + tmp3_1) * (s1_1327_0 + s1_1327_1);
    gl64_t kB1327 = (tmp3_0 + tmp3_2) * (s1_1327_0 + s1_1327_2);
    gl64_t kC1327 = (tmp3_1 + tmp3_2) * (s1_1327_1 + s1_1327_2);
    gl64_t kD1327 = tmp3_0 * s1_1327_0;
    gl64_t kE1327 = tmp3_1 * s1_1327_1;
    gl64_t kF1327 = tmp3_2 * s1_1327_2;
    gl64_t kG1327 = kD1327 - kE1327;
    tmp3_6 = (kC1327 + kG1327) - kF1327;
    tmp3_7 = ((((kA1327 + kC1327) - kE1327) - kE1327) - kD1327);
    tmp3_8 = kB1327 - kG1327;
    // Op 1328: dim1x1 sub
    gl64_t s1_1328 = *(gl64_t*)&expressions_params[10][88];
    tmp1_0 = tmp1_4 - s1_1328;
    // Op 1329: dim1x1 sub
    gl64_t s1_1329 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1329;
    // Op 1330: dim3x1 mul
    gl64_t s0_1330_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1330_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1330_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1330_0 * tmp1_0; tmp3_1 = s0_1330_1 * tmp1_0; tmp3_2 = s0_1330_2 * tmp1_0;
    // Op 1331: dim3x1 add
    gl64_t s1_1331 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1331; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1332: dim3x3 add
    gl64_t s1_1332_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1332_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1332_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1332_0; tmp3_1 = tmp3_1 + s1_1332_1; tmp3_2 = tmp3_2 + s1_1332_2;
    // Op 1333: dim3x3 mul
    gl64_t s1_1333_0 = *(gl64_t*)&expressions_params[10][269];
    gl64_t s1_1333_1 = *(gl64_t*)&expressions_params[10][269+1];
    gl64_t s1_1333_2 = *(gl64_t*)&expressions_params[10][269+2];
    gl64_t kA1333 = (tmp3_0 + tmp3_1) * (s1_1333_0 + s1_1333_1);
    gl64_t kB1333 = (tmp3_0 + tmp3_2) * (s1_1333_0 + s1_1333_2);
    gl64_t kC1333 = (tmp3_1 + tmp3_2) * (s1_1333_1 + s1_1333_2);
    gl64_t kD1333 = tmp3_0 * s1_1333_0;
    gl64_t kE1333 = tmp3_1 * s1_1333_1;
    gl64_t kF1333 = tmp3_2 * s1_1333_2;
    gl64_t kG1333 = kD1333 - kE1333;
    tmp3_0 = (kC1333 + kG1333) - kF1333;
    tmp3_1 = ((((kA1333 + kC1333) - kE1333) - kE1333) - kD1333);
    tmp3_2 = kB1333 - kG1333;
    // Op 1334: dim3x1 add
    gl64_t s1_1334 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1334; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1335: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1336: dim3x3 mul
    gl64_t s1_1336_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1336_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1336_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1336 = (tmp3_0 + tmp3_1) * (s1_1336_0 + s1_1336_1);
    gl64_t kB1336 = (tmp3_0 + tmp3_2) * (s1_1336_0 + s1_1336_2);
    gl64_t kC1336 = (tmp3_1 + tmp3_2) * (s1_1336_1 + s1_1336_2);
    gl64_t kD1336 = tmp3_0 * s1_1336_0;
    gl64_t kE1336 = tmp3_1 * s1_1336_1;
    gl64_t kF1336 = tmp3_2 * s1_1336_2;
    gl64_t kG1336 = kD1336 - kE1336;
    tmp3_6 = (kC1336 + kG1336) - kF1336;
    tmp3_7 = ((((kA1336 + kC1336) - kE1336) - kE1336) - kD1336);
    tmp3_8 = kB1336 - kG1336;
    // Op 1337: dim3x1 mul
    gl64_t s0_1337_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1337_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1337_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1337 = *(gl64_t*)&expressions_params[10][45];
    tmp3_0 = s0_1337_0 * s1_1337; tmp3_1 = s0_1337_1 * s1_1337; tmp3_2 = s0_1337_2 * s1_1337;
    // Op 1338: dim3x1 add
    gl64_t s1_1338 = *(gl64_t*)&expressions_params[10][44];
    tmp3_0 = tmp3_0 + s1_1338; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1339: dim3x3 mul
    gl64_t s1_1339_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1339_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1339_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1339 = (tmp3_0 + tmp3_1) * (s1_1339_0 + s1_1339_1);
    gl64_t kB1339 = (tmp3_0 + tmp3_2) * (s1_1339_0 + s1_1339_2);
    gl64_t kC1339 = (tmp3_1 + tmp3_2) * (s1_1339_1 + s1_1339_2);
    gl64_t kD1339 = tmp3_0 * s1_1339_0;
    gl64_t kE1339 = tmp3_1 * s1_1339_1;
    gl64_t kF1339 = tmp3_2 * s1_1339_2;
    gl64_t kG1339 = kD1339 - kE1339;
    tmp3_0 = (kC1339 + kG1339) - kF1339;
    tmp3_1 = ((((kA1339 + kC1339) - kE1339) - kE1339) - kD1339);
    tmp3_2 = kB1339 - kG1339;
    // Op 1340: dim3x1 add
    gl64_t s1_1340 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1340; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1341: dim3x3 mul
    gl64_t s1_1341_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1341_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1341_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1341 = (tmp3_0 + tmp3_1) * (s1_1341_0 + s1_1341_1);
    gl64_t kB1341 = (tmp3_0 + tmp3_2) * (s1_1341_0 + s1_1341_2);
    gl64_t kC1341 = (tmp3_1 + tmp3_2) * (s1_1341_1 + s1_1341_2);
    gl64_t kD1341 = tmp3_0 * s1_1341_0;
    gl64_t kE1341 = tmp3_1 * s1_1341_1;
    gl64_t kF1341 = tmp3_2 * s1_1341_2;
    gl64_t kG1341 = kD1341 - kE1341;
    tmp3_0 = (kC1341 + kG1341) - kF1341;
    tmp3_1 = ((((kA1341 + kC1341) - kE1341) - kE1341) - kD1341);
    tmp3_2 = kB1341 - kG1341;
    // Op 1342: dim3x1 add
    gl64_t s1_1342 = *(gl64_t*)&expressions_params[10][88];
    tmp3_0 = tmp3_0 + s1_1342; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1343: dim3x3 mul
    gl64_t s1_1343_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1343_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1343_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1343 = (tmp3_0 + tmp3_1) * (s1_1343_0 + s1_1343_1);
    gl64_t kB1343 = (tmp3_0 + tmp3_2) * (s1_1343_0 + s1_1343_2);
    gl64_t kC1343 = (tmp3_1 + tmp3_2) * (s1_1343_1 + s1_1343_2);
    gl64_t kD1343 = tmp3_0 * s1_1343_0;
    gl64_t kE1343 = tmp3_1 * s1_1343_1;
    gl64_t kF1343 = tmp3_2 * s1_1343_2;
    gl64_t kG1343 = kD1343 - kE1343;
    tmp3_0 = (kC1343 + kG1343) - kF1343;
    tmp3_1 = ((((kA1343 + kC1343) - kE1343) - kE1343) - kD1343);
    tmp3_2 = kB1343 - kG1343;
    // Op 1344: dim3x1 add
    gl64_t s1_1344 = *(gl64_t*)&expressions_params[9][35];
    tmp3_0 = tmp3_0 + s1_1344; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1345: dim3x3 mul
    gl64_t s1_1345_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1345_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1345_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1345 = (tmp3_0 + tmp3_1) * (s1_1345_0 + s1_1345_1);
    gl64_t kB1345 = (tmp3_0 + tmp3_2) * (s1_1345_0 + s1_1345_2);
    gl64_t kC1345 = (tmp3_1 + tmp3_2) * (s1_1345_1 + s1_1345_2);
    gl64_t kD1345 = tmp3_0 * s1_1345_0;
    gl64_t kE1345 = tmp3_1 * s1_1345_1;
    gl64_t kF1345 = tmp3_2 * s1_1345_2;
    gl64_t kG1345 = kD1345 - kE1345;
    tmp3_0 = (kC1345 + kG1345) - kF1345;
    tmp3_1 = ((((kA1345 + kC1345) - kE1345) - kE1345) - kD1345);
    tmp3_2 = kB1345 - kG1345;
    // Op 1346: dim3x1 add
    gl64_t s1_1346 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1346; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1347: dim3x3 mul
    gl64_t s1_1347_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1347_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1347_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1348: dim3x1 add
    gl64_t s1_1348 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1348; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1349: dim3x3 add
    gl64_t s1_1349_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1349_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1349_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1349_0; tmp3_1 = tmp3_1 + s1_1349_1; tmp3_2 = tmp3_2 + s1_1349_2;
    // Op 1350: dim3x3 mul
    gl64_t s1_1350_0 = *(gl64_t*)&expressions_params[10][272];
    gl64_t s1_1350_1 = *(gl64_t*)&expressions_params[10][272+1];
    gl64_t s1_1350_2 = *(gl64_t*)&expressions_params[10][272+2];
    gl64_t kA1350 = (tmp3_0 + tmp3_1) * (s1_1350_0 + s1_1350_1);
    gl64_t kB1350 = (tmp3_0 + tmp3_2) * (s1_1350_0 + s1_1350_2);
    gl64_t kC1350 = (tmp3_1 + tmp3_2) * (s1_1350_1 + s1_1350_2);
    gl64_t kD1350 = tmp3_0 * s1_1350_0;
    gl64_t kE1350 = tmp3_1 * s1_1350_1;
    gl64_t kF1350 = tmp3_2 * s1_1350_2;
    gl64_t kG1350 = kD1350 - kE1350;
    tmp3_0 = (kC1350 + kG1350) - kF1350;
    tmp3_1 = ((((kA1350 + kC1350) - kE1350) - kE1350) - kD1350);
    tmp3_2 = kB1350 - kG1350;
    // Op 1351: dim3x1 sub
    gl64_t s1_1351 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1351; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1352: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1353: dim3x3 mul
    gl64_t s1_1353_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1353_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1353_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1353 = (tmp3_0 + tmp3_1) * (s1_1353_0 + s1_1353_1);
    gl64_t kB1353 = (tmp3_0 + tmp3_2) * (s1_1353_0 + s1_1353_2);
    gl64_t kC1353 = (tmp3_1 + tmp3_2) * (s1_1353_1 + s1_1353_2);
    gl64_t kD1353 = tmp3_0 * s1_1353_0;
    gl64_t kE1353 = tmp3_1 * s1_1353_1;
    gl64_t kF1353 = tmp3_2 * s1_1353_2;
    gl64_t kG1353 = kD1353 - kE1353;
    tmp3_6 = (kC1353 + kG1353) - kF1353;
    tmp3_7 = ((((kA1353 + kC1353) - kE1353) - kE1353) - kD1353);
    tmp3_8 = kB1353 - kG1353;
    // Op 1354: dim3x1 mul
    gl64_t s0_1354_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1354_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1354_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1354 = *(gl64_t*)&expressions_params[10][45];
    tmp3_0 = s0_1354_0 * s1_1354; tmp3_1 = s0_1354_1 * s1_1354; tmp3_2 = s0_1354_2 * s1_1354;
    // Op 1355: dim3x1 add
    gl64_t s1_1355 = *(gl64_t*)&expressions_params[10][44];
    tmp3_0 = tmp3_0 + s1_1355; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1356: dim3x3 mul
    gl64_t s1_1356_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1356_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1356_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1356 = (tmp3_0 + tmp3_1) * (s1_1356_0 + s1_1356_1);
    gl64_t kB1356 = (tmp3_0 + tmp3_2) * (s1_1356_0 + s1_1356_2);
    gl64_t kC1356 = (tmp3_1 + tmp3_2) * (s1_1356_1 + s1_1356_2);
    gl64_t kD1356 = tmp3_0 * s1_1356_0;
    gl64_t kE1356 = tmp3_1 * s1_1356_1;
    gl64_t kF1356 = tmp3_2 * s1_1356_2;
    gl64_t kG1356 = kD1356 - kE1356;
    tmp3_0 = (kC1356 + kG1356) - kF1356;
    tmp3_1 = ((((kA1356 + kC1356) - kE1356) - kE1356) - kD1356);
    tmp3_2 = kB1356 - kG1356;
    // Op 1357: dim3x1 add
    gl64_t s1_1357 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1357; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1358: dim3x3 mul
    gl64_t s1_1358_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1358_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1358_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1358 = (tmp3_0 + tmp3_1) * (s1_1358_0 + s1_1358_1);
    gl64_t kB1358 = (tmp3_0 + tmp3_2) * (s1_1358_0 + s1_1358_2);
    gl64_t kC1358 = (tmp3_1 + tmp3_2) * (s1_1358_1 + s1_1358_2);
    gl64_t kD1358 = tmp3_0 * s1_1358_0;
    gl64_t kE1358 = tmp3_1 * s1_1358_1;
    gl64_t kF1358 = tmp3_2 * s1_1358_2;
    gl64_t kG1358 = kD1358 - kE1358;
    tmp3_0 = (kC1358 + kG1358) - kF1358;
    tmp3_1 = ((((kA1358 + kC1358) - kE1358) - kE1358) - kD1358);
    tmp3_2 = kB1358 - kG1358;
    // Op 1359: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1360: dim3x3 mul
    gl64_t s1_1360_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1360_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1360_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1360 = (tmp3_0 + tmp3_1) * (s1_1360_0 + s1_1360_1);
    gl64_t kB1360 = (tmp3_0 + tmp3_2) * (s1_1360_0 + s1_1360_2);
    gl64_t kC1360 = (tmp3_1 + tmp3_2) * (s1_1360_1 + s1_1360_2);
    gl64_t kD1360 = tmp3_0 * s1_1360_0;
    gl64_t kE1360 = tmp3_1 * s1_1360_1;
    gl64_t kF1360 = tmp3_2 * s1_1360_2;
    gl64_t kG1360 = kD1360 - kE1360;
    tmp3_0 = (kC1360 + kG1360) - kF1360;
    tmp3_1 = ((((kA1360 + kC1360) - kE1360) - kE1360) - kD1360);
    tmp3_2 = kB1360 - kG1360;
    // Op 1361: dim3x1 add
    gl64_t s1_1361 = *(gl64_t*)&expressions_params[9][35];
    tmp3_0 = tmp3_0 + s1_1361; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1362: dim3x3 mul
    gl64_t s1_1362_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1362_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1362_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1362 = (tmp3_0 + tmp3_1) * (s1_1362_0 + s1_1362_1);
    gl64_t kB1362 = (tmp3_0 + tmp3_2) * (s1_1362_0 + s1_1362_2);
    gl64_t kC1362 = (tmp3_1 + tmp3_2) * (s1_1362_1 + s1_1362_2);
    gl64_t kD1362 = tmp3_0 * s1_1362_0;
    gl64_t kE1362 = tmp3_1 * s1_1362_1;
    gl64_t kF1362 = tmp3_2 * s1_1362_2;
    gl64_t kG1362 = kD1362 - kE1362;
    tmp3_0 = (kC1362 + kG1362) - kF1362;
    tmp3_1 = ((((kA1362 + kC1362) - kE1362) - kE1362) - kD1362);
    tmp3_2 = kB1362 - kG1362;
    // Op 1363: dim3x1 add
    gl64_t s1_1363 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1363; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1364: dim3x3 mul
    gl64_t s1_1364_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1364_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1364_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1365: dim3x1 add
    gl64_t s1_1365 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1365; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1366: dim3x3 add
    gl64_t s1_1366_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1366_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1366_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1366_0; tmp3_1 = tmp3_1 + s1_1366_1; tmp3_2 = tmp3_2 + s1_1366_2;
    // Op 1367: dim3x3 mul
    gl64_t s1_1367_0 = *(gl64_t*)&expressions_params[10][275];
    gl64_t s1_1367_1 = *(gl64_t*)&expressions_params[10][275+1];
    gl64_t s1_1367_2 = *(gl64_t*)&expressions_params[10][275+2];
    gl64_t kA1367 = (tmp3_0 + tmp3_1) * (s1_1367_0 + s1_1367_1);
    gl64_t kB1367 = (tmp3_0 + tmp3_2) * (s1_1367_0 + s1_1367_2);
    gl64_t kC1367 = (tmp3_1 + tmp3_2) * (s1_1367_1 + s1_1367_2);
    gl64_t kD1367 = tmp3_0 * s1_1367_0;
    gl64_t kE1367 = tmp3_1 * s1_1367_1;
    gl64_t kF1367 = tmp3_2 * s1_1367_2;
    gl64_t kG1367 = kD1367 - kE1367;
    tmp3_0 = (kC1367 + kG1367) - kF1367;
    tmp3_1 = ((((kA1367 + kC1367) - kE1367) - kE1367) - kD1367);
    tmp3_2 = kB1367 - kG1367;
    // Op 1368: dim1x1 sub
    gl64_t s0_1368 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1368 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1368 - s1_1368;
    // Op 1369: dim1x1 sub_swap
    gl64_t s1_1369 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1369 - tmp1_0;
    // Op 1370: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1371: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1372: dim3x3 mul
    gl64_t s1_1372_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1372_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1372_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1372 = (tmp3_0 + tmp3_1) * (s1_1372_0 + s1_1372_1);
    gl64_t kB1372 = (tmp3_0 + tmp3_2) * (s1_1372_0 + s1_1372_2);
    gl64_t kC1372 = (tmp3_1 + tmp3_2) * (s1_1372_1 + s1_1372_2);
    gl64_t kD1372 = tmp3_0 * s1_1372_0;
    gl64_t kE1372 = tmp3_1 * s1_1372_1;
    gl64_t kF1372 = tmp3_2 * s1_1372_2;
    gl64_t kG1372 = kD1372 - kE1372;
    tmp3_6 = (kC1372 + kG1372) - kF1372;
    tmp3_7 = ((((kA1372 + kC1372) - kE1372) - kE1372) - kD1372);
    tmp3_8 = kB1372 - kG1372;
    // Op 1373: dim1x1 sub
    gl64_t s1_1373 = *(gl64_t*)&expressions_params[10][89];
    tmp1_0 = tmp1_4 - s1_1373;
    // Op 1374: dim1x1 sub
    gl64_t s1_1374 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1374;
    // Op 1375: dim3x1 mul
    gl64_t s0_1375_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1375_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1375_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1375_0 * tmp1_0; tmp3_1 = s0_1375_1 * tmp1_0; tmp3_2 = s0_1375_2 * tmp1_0;
    // Op 1376: dim3x1 add
    gl64_t s1_1376 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1376; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1377: dim3x3 add
    gl64_t s1_1377_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1377_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1377_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1377_0; tmp3_1 = tmp3_1 + s1_1377_1; tmp3_2 = tmp3_2 + s1_1377_2;
    // Op 1378: dim3x3 mul
    gl64_t s1_1378_0 = *(gl64_t*)&expressions_params[10][278];
    gl64_t s1_1378_1 = *(gl64_t*)&expressions_params[10][278+1];
    gl64_t s1_1378_2 = *(gl64_t*)&expressions_params[10][278+2];
    gl64_t kA1378 = (tmp3_0 + tmp3_1) * (s1_1378_0 + s1_1378_1);
    gl64_t kB1378 = (tmp3_0 + tmp3_2) * (s1_1378_0 + s1_1378_2);
    gl64_t kC1378 = (tmp3_1 + tmp3_2) * (s1_1378_1 + s1_1378_2);
    gl64_t kD1378 = tmp3_0 * s1_1378_0;
    gl64_t kE1378 = tmp3_1 * s1_1378_1;
    gl64_t kF1378 = tmp3_2 * s1_1378_2;
    gl64_t kG1378 = kD1378 - kE1378;
    tmp3_0 = (kC1378 + kG1378) - kF1378;
    tmp3_1 = ((((kA1378 + kC1378) - kE1378) - kE1378) - kD1378);
    tmp3_2 = kB1378 - kG1378;
    // Op 1379: dim3x1 add
    gl64_t s1_1379 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1379; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1380: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1381: dim3x3 mul
    gl64_t s1_1381_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1381_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1381_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1381 = (tmp3_0 + tmp3_1) * (s1_1381_0 + s1_1381_1);
    gl64_t kB1381 = (tmp3_0 + tmp3_2) * (s1_1381_0 + s1_1381_2);
    gl64_t kC1381 = (tmp3_1 + tmp3_2) * (s1_1381_1 + s1_1381_2);
    gl64_t kD1381 = tmp3_0 * s1_1381_0;
    gl64_t kE1381 = tmp3_1 * s1_1381_1;
    gl64_t kF1381 = tmp3_2 * s1_1381_2;
    gl64_t kG1381 = kD1381 - kE1381;
    tmp3_6 = (kC1381 + kG1381) - kF1381;
    tmp3_7 = ((((kA1381 + kC1381) - kE1381) - kE1381) - kD1381);
    tmp3_8 = kB1381 - kG1381;
    // Op 1382: dim3x1 mul
    gl64_t s0_1382_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1382_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1382_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1382 = *(gl64_t*)&expressions_params[10][47];
    tmp3_0 = s0_1382_0 * s1_1382; tmp3_1 = s0_1382_1 * s1_1382; tmp3_2 = s0_1382_2 * s1_1382;
    // Op 1383: dim3x1 add
    gl64_t s1_1383 = *(gl64_t*)&expressions_params[10][46];
    tmp3_0 = tmp3_0 + s1_1383; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1384: dim3x3 mul
    gl64_t s1_1384_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1384_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1384_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1384 = (tmp3_0 + tmp3_1) * (s1_1384_0 + s1_1384_1);
    gl64_t kB1384 = (tmp3_0 + tmp3_2) * (s1_1384_0 + s1_1384_2);
    gl64_t kC1384 = (tmp3_1 + tmp3_2) * (s1_1384_1 + s1_1384_2);
    gl64_t kD1384 = tmp3_0 * s1_1384_0;
    gl64_t kE1384 = tmp3_1 * s1_1384_1;
    gl64_t kF1384 = tmp3_2 * s1_1384_2;
    gl64_t kG1384 = kD1384 - kE1384;
    tmp3_0 = (kC1384 + kG1384) - kF1384;
    tmp3_1 = ((((kA1384 + kC1384) - kE1384) - kE1384) - kD1384);
    tmp3_2 = kB1384 - kG1384;
    // Op 1385: dim3x1 add
    gl64_t s1_1385 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1385; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1386: dim3x3 mul
    gl64_t s1_1386_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1386_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1386_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1386 = (tmp3_0 + tmp3_1) * (s1_1386_0 + s1_1386_1);
    gl64_t kB1386 = (tmp3_0 + tmp3_2) * (s1_1386_0 + s1_1386_2);
    gl64_t kC1386 = (tmp3_1 + tmp3_2) * (s1_1386_1 + s1_1386_2);
    gl64_t kD1386 = tmp3_0 * s1_1386_0;
    gl64_t kE1386 = tmp3_1 * s1_1386_1;
    gl64_t kF1386 = tmp3_2 * s1_1386_2;
    gl64_t kG1386 = kD1386 - kE1386;
    tmp3_0 = (kC1386 + kG1386) - kF1386;
    tmp3_1 = ((((kA1386 + kC1386) - kE1386) - kE1386) - kD1386);
    tmp3_2 = kB1386 - kG1386;
    // Op 1387: dim3x1 add
    gl64_t s1_1387 = *(gl64_t*)&expressions_params[10][89];
    tmp3_0 = tmp3_0 + s1_1387; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1388: dim3x3 mul
    gl64_t s1_1388_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1388_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1388_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1388 = (tmp3_0 + tmp3_1) * (s1_1388_0 + s1_1388_1);
    gl64_t kB1388 = (tmp3_0 + tmp3_2) * (s1_1388_0 + s1_1388_2);
    gl64_t kC1388 = (tmp3_1 + tmp3_2) * (s1_1388_1 + s1_1388_2);
    gl64_t kD1388 = tmp3_0 * s1_1388_0;
    gl64_t kE1388 = tmp3_1 * s1_1388_1;
    gl64_t kF1388 = tmp3_2 * s1_1388_2;
    gl64_t kG1388 = kD1388 - kE1388;
    tmp3_0 = (kC1388 + kG1388) - kF1388;
    tmp3_1 = ((((kA1388 + kC1388) - kE1388) - kE1388) - kD1388);
    tmp3_2 = kB1388 - kG1388;
    // Op 1389: dim3x1 add
    gl64_t s1_1389 = *(gl64_t*)&expressions_params[9][36];
    tmp3_0 = tmp3_0 + s1_1389; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1390: dim3x3 mul
    gl64_t s1_1390_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1390_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1390_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1390 = (tmp3_0 + tmp3_1) * (s1_1390_0 + s1_1390_1);
    gl64_t kB1390 = (tmp3_0 + tmp3_2) * (s1_1390_0 + s1_1390_2);
    gl64_t kC1390 = (tmp3_1 + tmp3_2) * (s1_1390_1 + s1_1390_2);
    gl64_t kD1390 = tmp3_0 * s1_1390_0;
    gl64_t kE1390 = tmp3_1 * s1_1390_1;
    gl64_t kF1390 = tmp3_2 * s1_1390_2;
    gl64_t kG1390 = kD1390 - kE1390;
    tmp3_0 = (kC1390 + kG1390) - kF1390;
    tmp3_1 = ((((kA1390 + kC1390) - kE1390) - kE1390) - kD1390);
    tmp3_2 = kB1390 - kG1390;
    // Op 1391: dim3x1 add
    gl64_t s1_1391 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1391; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1392: dim3x3 mul
    gl64_t s1_1392_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1392_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1392_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1393: dim3x1 add
    gl64_t s1_1393 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1393; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1394: dim3x3 add
    gl64_t s1_1394_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1394_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1394_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1394_0; tmp3_1 = tmp3_1 + s1_1394_1; tmp3_2 = tmp3_2 + s1_1394_2;
    // Op 1395: dim3x3 mul
    gl64_t s1_1395_0 = *(gl64_t*)&expressions_params[10][281];
    gl64_t s1_1395_1 = *(gl64_t*)&expressions_params[10][281+1];
    gl64_t s1_1395_2 = *(gl64_t*)&expressions_params[10][281+2];
    gl64_t kA1395 = (tmp3_0 + tmp3_1) * (s1_1395_0 + s1_1395_1);
    gl64_t kB1395 = (tmp3_0 + tmp3_2) * (s1_1395_0 + s1_1395_2);
    gl64_t kC1395 = (tmp3_1 + tmp3_2) * (s1_1395_1 + s1_1395_2);
    gl64_t kD1395 = tmp3_0 * s1_1395_0;
    gl64_t kE1395 = tmp3_1 * s1_1395_1;
    gl64_t kF1395 = tmp3_2 * s1_1395_2;
    gl64_t kG1395 = kD1395 - kE1395;
    tmp3_0 = (kC1395 + kG1395) - kF1395;
    tmp3_1 = ((((kA1395 + kC1395) - kE1395) - kE1395) - kD1395);
    tmp3_2 = kB1395 - kG1395;
    // Op 1396: dim3x1 sub
    gl64_t s1_1396 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1396; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1397: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1398: dim3x3 mul
    gl64_t s1_1398_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1398_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1398_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1398 = (tmp3_0 + tmp3_1) * (s1_1398_0 + s1_1398_1);
    gl64_t kB1398 = (tmp3_0 + tmp3_2) * (s1_1398_0 + s1_1398_2);
    gl64_t kC1398 = (tmp3_1 + tmp3_2) * (s1_1398_1 + s1_1398_2);
    gl64_t kD1398 = tmp3_0 * s1_1398_0;
    gl64_t kE1398 = tmp3_1 * s1_1398_1;
    gl64_t kF1398 = tmp3_2 * s1_1398_2;
    gl64_t kG1398 = kD1398 - kE1398;
    tmp3_6 = (kC1398 + kG1398) - kF1398;
    tmp3_7 = ((((kA1398 + kC1398) - kE1398) - kE1398) - kD1398);
    tmp3_8 = kB1398 - kG1398;
    // Op 1399: dim3x1 mul
    gl64_t s0_1399_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1399_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1399_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1399 = *(gl64_t*)&expressions_params[10][47];
    tmp3_0 = s0_1399_0 * s1_1399; tmp3_1 = s0_1399_1 * s1_1399; tmp3_2 = s0_1399_2 * s1_1399;
    // Op 1400: dim3x1 add
    gl64_t s1_1400 = *(gl64_t*)&expressions_params[10][46];
    tmp3_0 = tmp3_0 + s1_1400; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1401: dim3x3 mul
    gl64_t s1_1401_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1401_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1401_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1401 = (tmp3_0 + tmp3_1) * (s1_1401_0 + s1_1401_1);
    gl64_t kB1401 = (tmp3_0 + tmp3_2) * (s1_1401_0 + s1_1401_2);
    gl64_t kC1401 = (tmp3_1 + tmp3_2) * (s1_1401_1 + s1_1401_2);
    gl64_t kD1401 = tmp3_0 * s1_1401_0;
    gl64_t kE1401 = tmp3_1 * s1_1401_1;
    gl64_t kF1401 = tmp3_2 * s1_1401_2;
    gl64_t kG1401 = kD1401 - kE1401;
    tmp3_0 = (kC1401 + kG1401) - kF1401;
    tmp3_1 = ((((kA1401 + kC1401) - kE1401) - kE1401) - kD1401);
    tmp3_2 = kB1401 - kG1401;
    // Op 1402: dim3x1 add
    gl64_t s1_1402 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1402; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1403: dim3x3 mul
    gl64_t s1_1403_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1403_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1403_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1403 = (tmp3_0 + tmp3_1) * (s1_1403_0 + s1_1403_1);
    gl64_t kB1403 = (tmp3_0 + tmp3_2) * (s1_1403_0 + s1_1403_2);
    gl64_t kC1403 = (tmp3_1 + tmp3_2) * (s1_1403_1 + s1_1403_2);
    gl64_t kD1403 = tmp3_0 * s1_1403_0;
    gl64_t kE1403 = tmp3_1 * s1_1403_1;
    gl64_t kF1403 = tmp3_2 * s1_1403_2;
    gl64_t kG1403 = kD1403 - kE1403;
    tmp3_0 = (kC1403 + kG1403) - kF1403;
    tmp3_1 = ((((kA1403 + kC1403) - kE1403) - kE1403) - kD1403);
    tmp3_2 = kB1403 - kG1403;
    // Op 1404: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1405: dim3x3 mul
    gl64_t s1_1405_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1405_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1405_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1405 = (tmp3_0 + tmp3_1) * (s1_1405_0 + s1_1405_1);
    gl64_t kB1405 = (tmp3_0 + tmp3_2) * (s1_1405_0 + s1_1405_2);
    gl64_t kC1405 = (tmp3_1 + tmp3_2) * (s1_1405_1 + s1_1405_2);
    gl64_t kD1405 = tmp3_0 * s1_1405_0;
    gl64_t kE1405 = tmp3_1 * s1_1405_1;
    gl64_t kF1405 = tmp3_2 * s1_1405_2;
    gl64_t kG1405 = kD1405 - kE1405;
    tmp3_0 = (kC1405 + kG1405) - kF1405;
    tmp3_1 = ((((kA1405 + kC1405) - kE1405) - kE1405) - kD1405);
    tmp3_2 = kB1405 - kG1405;
    // Op 1406: dim3x1 add
    gl64_t s1_1406 = *(gl64_t*)&expressions_params[9][36];
    tmp3_0 = tmp3_0 + s1_1406; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1407: dim3x3 mul
    gl64_t s1_1407_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1407_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1407_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1407 = (tmp3_0 + tmp3_1) * (s1_1407_0 + s1_1407_1);
    gl64_t kB1407 = (tmp3_0 + tmp3_2) * (s1_1407_0 + s1_1407_2);
    gl64_t kC1407 = (tmp3_1 + tmp3_2) * (s1_1407_1 + s1_1407_2);
    gl64_t kD1407 = tmp3_0 * s1_1407_0;
    gl64_t kE1407 = tmp3_1 * s1_1407_1;
    gl64_t kF1407 = tmp3_2 * s1_1407_2;
    gl64_t kG1407 = kD1407 - kE1407;
    tmp3_0 = (kC1407 + kG1407) - kF1407;
    tmp3_1 = ((((kA1407 + kC1407) - kE1407) - kE1407) - kD1407);
    tmp3_2 = kB1407 - kG1407;
    // Op 1408: dim3x1 add
    gl64_t s1_1408 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1408; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1409: dim3x3 mul
    gl64_t s1_1409_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1409_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1409_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1410: dim3x1 add
    gl64_t s1_1410 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1410; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1411: dim3x3 add
    gl64_t s1_1411_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1411_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1411_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1411_0; tmp3_1 = tmp3_1 + s1_1411_1; tmp3_2 = tmp3_2 + s1_1411_2;
    // Op 1412: dim3x3 mul
    gl64_t s1_1412_0 = *(gl64_t*)&expressions_params[10][284];
    gl64_t s1_1412_1 = *(gl64_t*)&expressions_params[10][284+1];
    gl64_t s1_1412_2 = *(gl64_t*)&expressions_params[10][284+2];
    gl64_t kA1412 = (tmp3_0 + tmp3_1) * (s1_1412_0 + s1_1412_1);
    gl64_t kB1412 = (tmp3_0 + tmp3_2) * (s1_1412_0 + s1_1412_2);
    gl64_t kC1412 = (tmp3_1 + tmp3_2) * (s1_1412_1 + s1_1412_2);
    gl64_t kD1412 = tmp3_0 * s1_1412_0;
    gl64_t kE1412 = tmp3_1 * s1_1412_1;
    gl64_t kF1412 = tmp3_2 * s1_1412_2;
    gl64_t kG1412 = kD1412 - kE1412;
    tmp3_0 = (kC1412 + kG1412) - kF1412;
    tmp3_1 = ((((kA1412 + kC1412) - kE1412) - kE1412) - kD1412);
    tmp3_2 = kB1412 - kG1412;
    // Op 1413: dim1x1 sub
    gl64_t s0_1413 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1413 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1413 - s1_1413;
    // Op 1414: dim1x1 sub_swap
    gl64_t s1_1414 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1414 - tmp1_0;
    // Op 1415: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1416: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1417: dim3x3 mul
    gl64_t s1_1417_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1417_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1417_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1417 = (tmp3_0 + tmp3_1) * (s1_1417_0 + s1_1417_1);
    gl64_t kB1417 = (tmp3_0 + tmp3_2) * (s1_1417_0 + s1_1417_2);
    gl64_t kC1417 = (tmp3_1 + tmp3_2) * (s1_1417_1 + s1_1417_2);
    gl64_t kD1417 = tmp3_0 * s1_1417_0;
    gl64_t kE1417 = tmp3_1 * s1_1417_1;
    gl64_t kF1417 = tmp3_2 * s1_1417_2;
    gl64_t kG1417 = kD1417 - kE1417;
    tmp3_6 = (kC1417 + kG1417) - kF1417;
    tmp3_7 = ((((kA1417 + kC1417) - kE1417) - kE1417) - kD1417);
    tmp3_8 = kB1417 - kG1417;
    // Op 1418: dim1x1 sub
    gl64_t s1_1418 = *(gl64_t*)&expressions_params[10][90];
    tmp1_0 = tmp1_4 - s1_1418;
    // Op 1419: dim1x1 sub
    gl64_t s1_1419 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1419;
    // Op 1420: dim3x1 mul
    gl64_t s0_1420_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1420_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1420_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1420_0 * tmp1_0; tmp3_1 = s0_1420_1 * tmp1_0; tmp3_2 = s0_1420_2 * tmp1_0;
    // Op 1421: dim3x1 add
    gl64_t s1_1421 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1421; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1422: dim3x3 add
    gl64_t s1_1422_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1422_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1422_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1422_0; tmp3_1 = tmp3_1 + s1_1422_1; tmp3_2 = tmp3_2 + s1_1422_2;
    // Op 1423: dim3x3 mul
    gl64_t s1_1423_0 = *(gl64_t*)&expressions_params[10][287];
    gl64_t s1_1423_1 = *(gl64_t*)&expressions_params[10][287+1];
    gl64_t s1_1423_2 = *(gl64_t*)&expressions_params[10][287+2];
    gl64_t kA1423 = (tmp3_0 + tmp3_1) * (s1_1423_0 + s1_1423_1);
    gl64_t kB1423 = (tmp3_0 + tmp3_2) * (s1_1423_0 + s1_1423_2);
    gl64_t kC1423 = (tmp3_1 + tmp3_2) * (s1_1423_1 + s1_1423_2);
    gl64_t kD1423 = tmp3_0 * s1_1423_0;
    gl64_t kE1423 = tmp3_1 * s1_1423_1;
    gl64_t kF1423 = tmp3_2 * s1_1423_2;
    gl64_t kG1423 = kD1423 - kE1423;
    tmp3_0 = (kC1423 + kG1423) - kF1423;
    tmp3_1 = ((((kA1423 + kC1423) - kE1423) - kE1423) - kD1423);
    tmp3_2 = kB1423 - kG1423;
    // Op 1424: dim3x1 add
    gl64_t s1_1424 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1424; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1425: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1426: dim3x3 mul
    gl64_t s1_1426_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1426_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1426_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1426 = (tmp3_0 + tmp3_1) * (s1_1426_0 + s1_1426_1);
    gl64_t kB1426 = (tmp3_0 + tmp3_2) * (s1_1426_0 + s1_1426_2);
    gl64_t kC1426 = (tmp3_1 + tmp3_2) * (s1_1426_1 + s1_1426_2);
    gl64_t kD1426 = tmp3_0 * s1_1426_0;
    gl64_t kE1426 = tmp3_1 * s1_1426_1;
    gl64_t kF1426 = tmp3_2 * s1_1426_2;
    gl64_t kG1426 = kD1426 - kE1426;
    tmp3_6 = (kC1426 + kG1426) - kF1426;
    tmp3_7 = ((((kA1426 + kC1426) - kE1426) - kE1426) - kD1426);
    tmp3_8 = kB1426 - kG1426;
    // Op 1427: dim3x1 mul
    gl64_t s0_1427_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1427_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1427_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1427 = *(gl64_t*)&expressions_params[10][49];
    tmp3_0 = s0_1427_0 * s1_1427; tmp3_1 = s0_1427_1 * s1_1427; tmp3_2 = s0_1427_2 * s1_1427;
    // Op 1428: dim3x1 add
    gl64_t s1_1428 = *(gl64_t*)&expressions_params[10][48];
    tmp3_0 = tmp3_0 + s1_1428; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1429: dim3x3 mul
    gl64_t s1_1429_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1429_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1429_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1429 = (tmp3_0 + tmp3_1) * (s1_1429_0 + s1_1429_1);
    gl64_t kB1429 = (tmp3_0 + tmp3_2) * (s1_1429_0 + s1_1429_2);
    gl64_t kC1429 = (tmp3_1 + tmp3_2) * (s1_1429_1 + s1_1429_2);
    gl64_t kD1429 = tmp3_0 * s1_1429_0;
    gl64_t kE1429 = tmp3_1 * s1_1429_1;
    gl64_t kF1429 = tmp3_2 * s1_1429_2;
    gl64_t kG1429 = kD1429 - kE1429;
    tmp3_0 = (kC1429 + kG1429) - kF1429;
    tmp3_1 = ((((kA1429 + kC1429) - kE1429) - kE1429) - kD1429);
    tmp3_2 = kB1429 - kG1429;
    // Op 1430: dim3x1 add
    gl64_t s1_1430 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1430; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1431: dim3x3 mul
    gl64_t s1_1431_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1431_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1431_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1431 = (tmp3_0 + tmp3_1) * (s1_1431_0 + s1_1431_1);
    gl64_t kB1431 = (tmp3_0 + tmp3_2) * (s1_1431_0 + s1_1431_2);
    gl64_t kC1431 = (tmp3_1 + tmp3_2) * (s1_1431_1 + s1_1431_2);
    gl64_t kD1431 = tmp3_0 * s1_1431_0;
    gl64_t kE1431 = tmp3_1 * s1_1431_1;
    gl64_t kF1431 = tmp3_2 * s1_1431_2;
    gl64_t kG1431 = kD1431 - kE1431;
    tmp3_0 = (kC1431 + kG1431) - kF1431;
    tmp3_1 = ((((kA1431 + kC1431) - kE1431) - kE1431) - kD1431);
    tmp3_2 = kB1431 - kG1431;
    // Op 1432: dim3x1 add
    gl64_t s1_1432 = *(gl64_t*)&expressions_params[10][90];
    tmp3_0 = tmp3_0 + s1_1432; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1433: dim3x3 mul
    gl64_t s1_1433_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1433_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1433_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1433 = (tmp3_0 + tmp3_1) * (s1_1433_0 + s1_1433_1);
    gl64_t kB1433 = (tmp3_0 + tmp3_2) * (s1_1433_0 + s1_1433_2);
    gl64_t kC1433 = (tmp3_1 + tmp3_2) * (s1_1433_1 + s1_1433_2);
    gl64_t kD1433 = tmp3_0 * s1_1433_0;
    gl64_t kE1433 = tmp3_1 * s1_1433_1;
    gl64_t kF1433 = tmp3_2 * s1_1433_2;
    gl64_t kG1433 = kD1433 - kE1433;
    tmp3_0 = (kC1433 + kG1433) - kF1433;
    tmp3_1 = ((((kA1433 + kC1433) - kE1433) - kE1433) - kD1433);
    tmp3_2 = kB1433 - kG1433;
    // Op 1434: dim3x1 add
    gl64_t s1_1434 = *(gl64_t*)&expressions_params[9][37];
    tmp3_0 = tmp3_0 + s1_1434; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1435: dim3x3 mul
    gl64_t s1_1435_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1435_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1435_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1435 = (tmp3_0 + tmp3_1) * (s1_1435_0 + s1_1435_1);
    gl64_t kB1435 = (tmp3_0 + tmp3_2) * (s1_1435_0 + s1_1435_2);
    gl64_t kC1435 = (tmp3_1 + tmp3_2) * (s1_1435_1 + s1_1435_2);
    gl64_t kD1435 = tmp3_0 * s1_1435_0;
    gl64_t kE1435 = tmp3_1 * s1_1435_1;
    gl64_t kF1435 = tmp3_2 * s1_1435_2;
    gl64_t kG1435 = kD1435 - kE1435;
    tmp3_0 = (kC1435 + kG1435) - kF1435;
    tmp3_1 = ((((kA1435 + kC1435) - kE1435) - kE1435) - kD1435);
    tmp3_2 = kB1435 - kG1435;
    // Op 1436: dim3x1 add
    gl64_t s1_1436 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1436; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1437: dim3x3 mul
    gl64_t s1_1437_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1437_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1437_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1438: dim3x1 add
    gl64_t s1_1438 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1438; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1439: dim3x3 add
    gl64_t s1_1439_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1439_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1439_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1439_0; tmp3_1 = tmp3_1 + s1_1439_1; tmp3_2 = tmp3_2 + s1_1439_2;
    // Op 1440: dim3x3 mul
    gl64_t s1_1440_0 = *(gl64_t*)&expressions_params[10][290];
    gl64_t s1_1440_1 = *(gl64_t*)&expressions_params[10][290+1];
    gl64_t s1_1440_2 = *(gl64_t*)&expressions_params[10][290+2];
    gl64_t kA1440 = (tmp3_0 + tmp3_1) * (s1_1440_0 + s1_1440_1);
    gl64_t kB1440 = (tmp3_0 + tmp3_2) * (s1_1440_0 + s1_1440_2);
    gl64_t kC1440 = (tmp3_1 + tmp3_2) * (s1_1440_1 + s1_1440_2);
    gl64_t kD1440 = tmp3_0 * s1_1440_0;
    gl64_t kE1440 = tmp3_1 * s1_1440_1;
    gl64_t kF1440 = tmp3_2 * s1_1440_2;
    gl64_t kG1440 = kD1440 - kE1440;
    tmp3_0 = (kC1440 + kG1440) - kF1440;
    tmp3_1 = ((((kA1440 + kC1440) - kE1440) - kE1440) - kD1440);
    tmp3_2 = kB1440 - kG1440;
    // Op 1441: dim3x1 sub
    gl64_t s1_1441 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1441; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1442: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1443: dim3x3 mul
    gl64_t s1_1443_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1443_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1443_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1443 = (tmp3_0 + tmp3_1) * (s1_1443_0 + s1_1443_1);
    gl64_t kB1443 = (tmp3_0 + tmp3_2) * (s1_1443_0 + s1_1443_2);
    gl64_t kC1443 = (tmp3_1 + tmp3_2) * (s1_1443_1 + s1_1443_2);
    gl64_t kD1443 = tmp3_0 * s1_1443_0;
    gl64_t kE1443 = tmp3_1 * s1_1443_1;
    gl64_t kF1443 = tmp3_2 * s1_1443_2;
    gl64_t kG1443 = kD1443 - kE1443;
    tmp3_6 = (kC1443 + kG1443) - kF1443;
    tmp3_7 = ((((kA1443 + kC1443) - kE1443) - kE1443) - kD1443);
    tmp3_8 = kB1443 - kG1443;
    // Op 1444: dim3x1 mul
    gl64_t s0_1444_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1444_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1444_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1444 = *(gl64_t*)&expressions_params[10][49];
    tmp3_0 = s0_1444_0 * s1_1444; tmp3_1 = s0_1444_1 * s1_1444; tmp3_2 = s0_1444_2 * s1_1444;
    // Op 1445: dim3x1 add
    gl64_t s1_1445 = *(gl64_t*)&expressions_params[10][48];
    tmp3_0 = tmp3_0 + s1_1445; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1446: dim3x3 mul
    gl64_t s1_1446_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1446_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1446_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1446 = (tmp3_0 + tmp3_1) * (s1_1446_0 + s1_1446_1);
    gl64_t kB1446 = (tmp3_0 + tmp3_2) * (s1_1446_0 + s1_1446_2);
    gl64_t kC1446 = (tmp3_1 + tmp3_2) * (s1_1446_1 + s1_1446_2);
    gl64_t kD1446 = tmp3_0 * s1_1446_0;
    gl64_t kE1446 = tmp3_1 * s1_1446_1;
    gl64_t kF1446 = tmp3_2 * s1_1446_2;
    gl64_t kG1446 = kD1446 - kE1446;
    tmp3_0 = (kC1446 + kG1446) - kF1446;
    tmp3_1 = ((((kA1446 + kC1446) - kE1446) - kE1446) - kD1446);
    tmp3_2 = kB1446 - kG1446;
    // Op 1447: dim3x1 add
    gl64_t s1_1447 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1447; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1448: dim3x3 mul
    gl64_t s1_1448_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1448_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1448_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1448 = (tmp3_0 + tmp3_1) * (s1_1448_0 + s1_1448_1);
    gl64_t kB1448 = (tmp3_0 + tmp3_2) * (s1_1448_0 + s1_1448_2);
    gl64_t kC1448 = (tmp3_1 + tmp3_2) * (s1_1448_1 + s1_1448_2);
    gl64_t kD1448 = tmp3_0 * s1_1448_0;
    gl64_t kE1448 = tmp3_1 * s1_1448_1;
    gl64_t kF1448 = tmp3_2 * s1_1448_2;
    gl64_t kG1448 = kD1448 - kE1448;
    tmp3_0 = (kC1448 + kG1448) - kF1448;
    tmp3_1 = ((((kA1448 + kC1448) - kE1448) - kE1448) - kD1448);
    tmp3_2 = kB1448 - kG1448;
    // Op 1449: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1450: dim3x3 mul
    gl64_t s1_1450_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1450_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1450_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1450 = (tmp3_0 + tmp3_1) * (s1_1450_0 + s1_1450_1);
    gl64_t kB1450 = (tmp3_0 + tmp3_2) * (s1_1450_0 + s1_1450_2);
    gl64_t kC1450 = (tmp3_1 + tmp3_2) * (s1_1450_1 + s1_1450_2);
    gl64_t kD1450 = tmp3_0 * s1_1450_0;
    gl64_t kE1450 = tmp3_1 * s1_1450_1;
    gl64_t kF1450 = tmp3_2 * s1_1450_2;
    gl64_t kG1450 = kD1450 - kE1450;
    tmp3_0 = (kC1450 + kG1450) - kF1450;
    tmp3_1 = ((((kA1450 + kC1450) - kE1450) - kE1450) - kD1450);
    tmp3_2 = kB1450 - kG1450;
    // Op 1451: dim3x1 add
    gl64_t s1_1451 = *(gl64_t*)&expressions_params[9][37];
    tmp3_0 = tmp3_0 + s1_1451; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1452: dim3x3 mul
    gl64_t s1_1452_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1452_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1452_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1452 = (tmp3_0 + tmp3_1) * (s1_1452_0 + s1_1452_1);
    gl64_t kB1452 = (tmp3_0 + tmp3_2) * (s1_1452_0 + s1_1452_2);
    gl64_t kC1452 = (tmp3_1 + tmp3_2) * (s1_1452_1 + s1_1452_2);
    gl64_t kD1452 = tmp3_0 * s1_1452_0;
    gl64_t kE1452 = tmp3_1 * s1_1452_1;
    gl64_t kF1452 = tmp3_2 * s1_1452_2;
    gl64_t kG1452 = kD1452 - kE1452;
    tmp3_0 = (kC1452 + kG1452) - kF1452;
    tmp3_1 = ((((kA1452 + kC1452) - kE1452) - kE1452) - kD1452);
    tmp3_2 = kB1452 - kG1452;
    // Op 1453: dim3x1 add
    gl64_t s1_1453 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1453; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1454: dim3x3 mul
    gl64_t s1_1454_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1454_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1454_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1455: dim3x1 add
    gl64_t s1_1455 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1455; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1456: dim3x3 add
    gl64_t s1_1456_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1456_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1456_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1456_0; tmp3_1 = tmp3_1 + s1_1456_1; tmp3_2 = tmp3_2 + s1_1456_2;
    // Op 1457: dim3x3 mul
    gl64_t s1_1457_0 = *(gl64_t*)&expressions_params[10][293];
    gl64_t s1_1457_1 = *(gl64_t*)&expressions_params[10][293+1];
    gl64_t s1_1457_2 = *(gl64_t*)&expressions_params[10][293+2];
    gl64_t kA1457 = (tmp3_0 + tmp3_1) * (s1_1457_0 + s1_1457_1);
    gl64_t kB1457 = (tmp3_0 + tmp3_2) * (s1_1457_0 + s1_1457_2);
    gl64_t kC1457 = (tmp3_1 + tmp3_2) * (s1_1457_1 + s1_1457_2);
    gl64_t kD1457 = tmp3_0 * s1_1457_0;
    gl64_t kE1457 = tmp3_1 * s1_1457_1;
    gl64_t kF1457 = tmp3_2 * s1_1457_2;
    gl64_t kG1457 = kD1457 - kE1457;
    tmp3_0 = (kC1457 + kG1457) - kF1457;
    tmp3_1 = ((((kA1457 + kC1457) - kE1457) - kE1457) - kD1457);
    tmp3_2 = kB1457 - kG1457;
    // Op 1458: dim1x1 sub
    gl64_t s0_1458 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1458 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1458 - s1_1458;
    // Op 1459: dim1x1 sub_swap
    gl64_t s1_1459 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1459 - tmp1_0;
    // Op 1460: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1461: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1462: dim3x3 mul
    gl64_t s1_1462_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1462_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1462_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1462 = (tmp3_0 + tmp3_1) * (s1_1462_0 + s1_1462_1);
    gl64_t kB1462 = (tmp3_0 + tmp3_2) * (s1_1462_0 + s1_1462_2);
    gl64_t kC1462 = (tmp3_1 + tmp3_2) * (s1_1462_1 + s1_1462_2);
    gl64_t kD1462 = tmp3_0 * s1_1462_0;
    gl64_t kE1462 = tmp3_1 * s1_1462_1;
    gl64_t kF1462 = tmp3_2 * s1_1462_2;
    gl64_t kG1462 = kD1462 - kE1462;
    tmp3_6 = (kC1462 + kG1462) - kF1462;
    tmp3_7 = ((((kA1462 + kC1462) - kE1462) - kE1462) - kD1462);
    tmp3_8 = kB1462 - kG1462;
    // Op 1463: dim1x1 sub
    gl64_t s1_1463 = *(gl64_t*)&expressions_params[10][91];
    tmp1_0 = tmp1_4 - s1_1463;
    // Op 1464: dim1x1 sub
    gl64_t s1_1464 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1464;
    // Op 1465: dim3x1 mul
    gl64_t s0_1465_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1465_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1465_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1465_0 * tmp1_0; tmp3_1 = s0_1465_1 * tmp1_0; tmp3_2 = s0_1465_2 * tmp1_0;
    // Op 1466: dim3x1 add
    gl64_t s1_1466 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1466; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1467: dim3x3 add
    gl64_t s1_1467_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1467_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1467_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1467_0; tmp3_1 = tmp3_1 + s1_1467_1; tmp3_2 = tmp3_2 + s1_1467_2;
    // Op 1468: dim3x3 mul
    gl64_t s1_1468_0 = *(gl64_t*)&expressions_params[10][296];
    gl64_t s1_1468_1 = *(gl64_t*)&expressions_params[10][296+1];
    gl64_t s1_1468_2 = *(gl64_t*)&expressions_params[10][296+2];
    gl64_t kA1468 = (tmp3_0 + tmp3_1) * (s1_1468_0 + s1_1468_1);
    gl64_t kB1468 = (tmp3_0 + tmp3_2) * (s1_1468_0 + s1_1468_2);
    gl64_t kC1468 = (tmp3_1 + tmp3_2) * (s1_1468_1 + s1_1468_2);
    gl64_t kD1468 = tmp3_0 * s1_1468_0;
    gl64_t kE1468 = tmp3_1 * s1_1468_1;
    gl64_t kF1468 = tmp3_2 * s1_1468_2;
    gl64_t kG1468 = kD1468 - kE1468;
    tmp3_0 = (kC1468 + kG1468) - kF1468;
    tmp3_1 = ((((kA1468 + kC1468) - kE1468) - kE1468) - kD1468);
    tmp3_2 = kB1468 - kG1468;
    // Op 1469: dim3x1 add
    gl64_t s1_1469 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1469; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1470: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1471: dim3x3 mul
    gl64_t s1_1471_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1471_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1471_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1471 = (tmp3_0 + tmp3_1) * (s1_1471_0 + s1_1471_1);
    gl64_t kB1471 = (tmp3_0 + tmp3_2) * (s1_1471_0 + s1_1471_2);
    gl64_t kC1471 = (tmp3_1 + tmp3_2) * (s1_1471_1 + s1_1471_2);
    gl64_t kD1471 = tmp3_0 * s1_1471_0;
    gl64_t kE1471 = tmp3_1 * s1_1471_1;
    gl64_t kF1471 = tmp3_2 * s1_1471_2;
    gl64_t kG1471 = kD1471 - kE1471;
    tmp3_6 = (kC1471 + kG1471) - kF1471;
    tmp3_7 = ((((kA1471 + kC1471) - kE1471) - kE1471) - kD1471);
    tmp3_8 = kB1471 - kG1471;
    // Op 1472: dim3x1 mul
    gl64_t s0_1472_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1472_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1472_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1472 = *(gl64_t*)&expressions_params[10][51];
    tmp3_0 = s0_1472_0 * s1_1472; tmp3_1 = s0_1472_1 * s1_1472; tmp3_2 = s0_1472_2 * s1_1472;
    // Op 1473: dim3x1 add
    gl64_t s1_1473 = *(gl64_t*)&expressions_params[10][50];
    tmp3_0 = tmp3_0 + s1_1473; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1474: dim3x3 mul
    gl64_t s1_1474_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1474_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1474_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1474 = (tmp3_0 + tmp3_1) * (s1_1474_0 + s1_1474_1);
    gl64_t kB1474 = (tmp3_0 + tmp3_2) * (s1_1474_0 + s1_1474_2);
    gl64_t kC1474 = (tmp3_1 + tmp3_2) * (s1_1474_1 + s1_1474_2);
    gl64_t kD1474 = tmp3_0 * s1_1474_0;
    gl64_t kE1474 = tmp3_1 * s1_1474_1;
    gl64_t kF1474 = tmp3_2 * s1_1474_2;
    gl64_t kG1474 = kD1474 - kE1474;
    tmp3_0 = (kC1474 + kG1474) - kF1474;
    tmp3_1 = ((((kA1474 + kC1474) - kE1474) - kE1474) - kD1474);
    tmp3_2 = kB1474 - kG1474;
    // Op 1475: dim3x1 add
    gl64_t s1_1475 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1475; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1476: dim3x3 mul
    gl64_t s1_1476_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1476_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1476_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1476 = (tmp3_0 + tmp3_1) * (s1_1476_0 + s1_1476_1);
    gl64_t kB1476 = (tmp3_0 + tmp3_2) * (s1_1476_0 + s1_1476_2);
    gl64_t kC1476 = (tmp3_1 + tmp3_2) * (s1_1476_1 + s1_1476_2);
    gl64_t kD1476 = tmp3_0 * s1_1476_0;
    gl64_t kE1476 = tmp3_1 * s1_1476_1;
    gl64_t kF1476 = tmp3_2 * s1_1476_2;
    gl64_t kG1476 = kD1476 - kE1476;
    tmp3_0 = (kC1476 + kG1476) - kF1476;
    tmp3_1 = ((((kA1476 + kC1476) - kE1476) - kE1476) - kD1476);
    tmp3_2 = kB1476 - kG1476;
    // Op 1477: dim3x1 add
    gl64_t s1_1477 = *(gl64_t*)&expressions_params[10][91];
    tmp3_0 = tmp3_0 + s1_1477; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1478: dim3x3 mul
    gl64_t s1_1478_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1478_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1478_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1478 = (tmp3_0 + tmp3_1) * (s1_1478_0 + s1_1478_1);
    gl64_t kB1478 = (tmp3_0 + tmp3_2) * (s1_1478_0 + s1_1478_2);
    gl64_t kC1478 = (tmp3_1 + tmp3_2) * (s1_1478_1 + s1_1478_2);
    gl64_t kD1478 = tmp3_0 * s1_1478_0;
    gl64_t kE1478 = tmp3_1 * s1_1478_1;
    gl64_t kF1478 = tmp3_2 * s1_1478_2;
    gl64_t kG1478 = kD1478 - kE1478;
    tmp3_0 = (kC1478 + kG1478) - kF1478;
    tmp3_1 = ((((kA1478 + kC1478) - kE1478) - kE1478) - kD1478);
    tmp3_2 = kB1478 - kG1478;
    // Op 1479: dim3x1 add
    gl64_t s1_1479 = *(gl64_t*)&expressions_params[9][38];
    tmp3_0 = tmp3_0 + s1_1479; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1480: dim3x3 mul
    gl64_t s1_1480_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1480_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1480_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1480 = (tmp3_0 + tmp3_1) * (s1_1480_0 + s1_1480_1);
    gl64_t kB1480 = (tmp3_0 + tmp3_2) * (s1_1480_0 + s1_1480_2);
    gl64_t kC1480 = (tmp3_1 + tmp3_2) * (s1_1480_1 + s1_1480_2);
    gl64_t kD1480 = tmp3_0 * s1_1480_0;
    gl64_t kE1480 = tmp3_1 * s1_1480_1;
    gl64_t kF1480 = tmp3_2 * s1_1480_2;
    gl64_t kG1480 = kD1480 - kE1480;
    tmp3_0 = (kC1480 + kG1480) - kF1480;
    tmp3_1 = ((((kA1480 + kC1480) - kE1480) - kE1480) - kD1480);
    tmp3_2 = kB1480 - kG1480;
    // Op 1481: dim3x1 add
    gl64_t s1_1481 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1481; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1482: dim3x3 mul
    gl64_t s1_1482_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1482_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1482_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1483: dim3x1 add
    gl64_t s1_1483 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1483; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1484: dim3x3 add
    gl64_t s1_1484_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1484_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1484_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1484_0; tmp3_1 = tmp3_1 + s1_1484_1; tmp3_2 = tmp3_2 + s1_1484_2;
    // Op 1485: dim3x3 mul
    gl64_t s1_1485_0 = *(gl64_t*)&expressions_params[10][299];
    gl64_t s1_1485_1 = *(gl64_t*)&expressions_params[10][299+1];
    gl64_t s1_1485_2 = *(gl64_t*)&expressions_params[10][299+2];
    gl64_t kA1485 = (tmp3_0 + tmp3_1) * (s1_1485_0 + s1_1485_1);
    gl64_t kB1485 = (tmp3_0 + tmp3_2) * (s1_1485_0 + s1_1485_2);
    gl64_t kC1485 = (tmp3_1 + tmp3_2) * (s1_1485_1 + s1_1485_2);
    gl64_t kD1485 = tmp3_0 * s1_1485_0;
    gl64_t kE1485 = tmp3_1 * s1_1485_1;
    gl64_t kF1485 = tmp3_2 * s1_1485_2;
    gl64_t kG1485 = kD1485 - kE1485;
    tmp3_0 = (kC1485 + kG1485) - kF1485;
    tmp3_1 = ((((kA1485 + kC1485) - kE1485) - kE1485) - kD1485);
    tmp3_2 = kB1485 - kG1485;
    // Op 1486: dim3x1 sub
    gl64_t s1_1486 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1486; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1487: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1488: dim3x3 mul
    gl64_t s1_1488_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1488_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1488_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1488 = (tmp3_0 + tmp3_1) * (s1_1488_0 + s1_1488_1);
    gl64_t kB1488 = (tmp3_0 + tmp3_2) * (s1_1488_0 + s1_1488_2);
    gl64_t kC1488 = (tmp3_1 + tmp3_2) * (s1_1488_1 + s1_1488_2);
    gl64_t kD1488 = tmp3_0 * s1_1488_0;
    gl64_t kE1488 = tmp3_1 * s1_1488_1;
    gl64_t kF1488 = tmp3_2 * s1_1488_2;
    gl64_t kG1488 = kD1488 - kE1488;
    tmp3_6 = (kC1488 + kG1488) - kF1488;
    tmp3_7 = ((((kA1488 + kC1488) - kE1488) - kE1488) - kD1488);
    tmp3_8 = kB1488 - kG1488;
    // Op 1489: dim3x1 mul
    gl64_t s0_1489_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1489_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1489_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1489 = *(gl64_t*)&expressions_params[10][51];
    tmp3_0 = s0_1489_0 * s1_1489; tmp3_1 = s0_1489_1 * s1_1489; tmp3_2 = s0_1489_2 * s1_1489;
    // Op 1490: dim3x1 add
    gl64_t s1_1490 = *(gl64_t*)&expressions_params[10][50];
    tmp3_0 = tmp3_0 + s1_1490; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1491: dim3x3 mul
    gl64_t s1_1491_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1491_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1491_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1491 = (tmp3_0 + tmp3_1) * (s1_1491_0 + s1_1491_1);
    gl64_t kB1491 = (tmp3_0 + tmp3_2) * (s1_1491_0 + s1_1491_2);
    gl64_t kC1491 = (tmp3_1 + tmp3_2) * (s1_1491_1 + s1_1491_2);
    gl64_t kD1491 = tmp3_0 * s1_1491_0;
    gl64_t kE1491 = tmp3_1 * s1_1491_1;
    gl64_t kF1491 = tmp3_2 * s1_1491_2;
    gl64_t kG1491 = kD1491 - kE1491;
    tmp3_0 = (kC1491 + kG1491) - kF1491;
    tmp3_1 = ((((kA1491 + kC1491) - kE1491) - kE1491) - kD1491);
    tmp3_2 = kB1491 - kG1491;
    // Op 1492: dim3x1 add
    gl64_t s1_1492 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1492; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1493: dim3x3 mul
    gl64_t s1_1493_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1493_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1493_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1493 = (tmp3_0 + tmp3_1) * (s1_1493_0 + s1_1493_1);
    gl64_t kB1493 = (tmp3_0 + tmp3_2) * (s1_1493_0 + s1_1493_2);
    gl64_t kC1493 = (tmp3_1 + tmp3_2) * (s1_1493_1 + s1_1493_2);
    gl64_t kD1493 = tmp3_0 * s1_1493_0;
    gl64_t kE1493 = tmp3_1 * s1_1493_1;
    gl64_t kF1493 = tmp3_2 * s1_1493_2;
    gl64_t kG1493 = kD1493 - kE1493;
    tmp3_0 = (kC1493 + kG1493) - kF1493;
    tmp3_1 = ((((kA1493 + kC1493) - kE1493) - kE1493) - kD1493);
    tmp3_2 = kB1493 - kG1493;
    // Op 1494: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1495: dim3x3 mul
    gl64_t s1_1495_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1495_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1495_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1495 = (tmp3_0 + tmp3_1) * (s1_1495_0 + s1_1495_1);
    gl64_t kB1495 = (tmp3_0 + tmp3_2) * (s1_1495_0 + s1_1495_2);
    gl64_t kC1495 = (tmp3_1 + tmp3_2) * (s1_1495_1 + s1_1495_2);
    gl64_t kD1495 = tmp3_0 * s1_1495_0;
    gl64_t kE1495 = tmp3_1 * s1_1495_1;
    gl64_t kF1495 = tmp3_2 * s1_1495_2;
    gl64_t kG1495 = kD1495 - kE1495;
    tmp3_0 = (kC1495 + kG1495) - kF1495;
    tmp3_1 = ((((kA1495 + kC1495) - kE1495) - kE1495) - kD1495);
    tmp3_2 = kB1495 - kG1495;
    // Op 1496: dim3x1 add
    gl64_t s1_1496 = *(gl64_t*)&expressions_params[9][38];
    tmp3_0 = tmp3_0 + s1_1496; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1497: dim3x3 mul
    gl64_t s1_1497_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1497_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1497_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1497 = (tmp3_0 + tmp3_1) * (s1_1497_0 + s1_1497_1);
    gl64_t kB1497 = (tmp3_0 + tmp3_2) * (s1_1497_0 + s1_1497_2);
    gl64_t kC1497 = (tmp3_1 + tmp3_2) * (s1_1497_1 + s1_1497_2);
    gl64_t kD1497 = tmp3_0 * s1_1497_0;
    gl64_t kE1497 = tmp3_1 * s1_1497_1;
    gl64_t kF1497 = tmp3_2 * s1_1497_2;
    gl64_t kG1497 = kD1497 - kE1497;
    tmp3_0 = (kC1497 + kG1497) - kF1497;
    tmp3_1 = ((((kA1497 + kC1497) - kE1497) - kE1497) - kD1497);
    tmp3_2 = kB1497 - kG1497;
    // Op 1498: dim3x1 add
    gl64_t s1_1498 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1498; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1499: dim3x3 mul
    gl64_t s1_1499_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1499_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1499_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1500: dim3x1 add
    gl64_t s1_1500 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1500; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1501: dim3x3 add
    gl64_t s1_1501_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1501_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1501_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1501_0; tmp3_1 = tmp3_1 + s1_1501_1; tmp3_2 = tmp3_2 + s1_1501_2;
    // Op 1502: dim3x3 mul
    gl64_t s1_1502_0 = *(gl64_t*)&expressions_params[10][302];
    gl64_t s1_1502_1 = *(gl64_t*)&expressions_params[10][302+1];
    gl64_t s1_1502_2 = *(gl64_t*)&expressions_params[10][302+2];
    gl64_t kA1502 = (tmp3_0 + tmp3_1) * (s1_1502_0 + s1_1502_1);
    gl64_t kB1502 = (tmp3_0 + tmp3_2) * (s1_1502_0 + s1_1502_2);
    gl64_t kC1502 = (tmp3_1 + tmp3_2) * (s1_1502_1 + s1_1502_2);
    gl64_t kD1502 = tmp3_0 * s1_1502_0;
    gl64_t kE1502 = tmp3_1 * s1_1502_1;
    gl64_t kF1502 = tmp3_2 * s1_1502_2;
    gl64_t kG1502 = kD1502 - kE1502;
    tmp3_0 = (kC1502 + kG1502) - kF1502;
    tmp3_1 = ((((kA1502 + kC1502) - kE1502) - kE1502) - kD1502);
    tmp3_2 = kB1502 - kG1502;
    // Op 1503: dim1x1 sub
    gl64_t s0_1503 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1503 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1503 - s1_1503;
    // Op 1504: dim1x1 sub_swap
    gl64_t s1_1504 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1504 - tmp1_0;
    // Op 1505: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1506: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1507: dim3x3 mul
    gl64_t s1_1507_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1507_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1507_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1507 = (tmp3_0 + tmp3_1) * (s1_1507_0 + s1_1507_1);
    gl64_t kB1507 = (tmp3_0 + tmp3_2) * (s1_1507_0 + s1_1507_2);
    gl64_t kC1507 = (tmp3_1 + tmp3_2) * (s1_1507_1 + s1_1507_2);
    gl64_t kD1507 = tmp3_0 * s1_1507_0;
    gl64_t kE1507 = tmp3_1 * s1_1507_1;
    gl64_t kF1507 = tmp3_2 * s1_1507_2;
    gl64_t kG1507 = kD1507 - kE1507;
    tmp3_6 = (kC1507 + kG1507) - kF1507;
    tmp3_7 = ((((kA1507 + kC1507) - kE1507) - kE1507) - kD1507);
    tmp3_8 = kB1507 - kG1507;
    // Op 1508: dim1x1 sub
    gl64_t s1_1508 = *(gl64_t*)&expressions_params[10][92];
    tmp1_0 = tmp1_4 - s1_1508;
    // Op 1509: dim1x1 sub
    gl64_t s1_1509 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1509;
    // Op 1510: dim3x1 mul
    gl64_t s0_1510_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1510_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1510_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1510_0 * tmp1_0; tmp3_1 = s0_1510_1 * tmp1_0; tmp3_2 = s0_1510_2 * tmp1_0;
    // Op 1511: dim3x1 add
    gl64_t s1_1511 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1511; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1512: dim3x3 add
    gl64_t s1_1512_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1512_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1512_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1512_0; tmp3_1 = tmp3_1 + s1_1512_1; tmp3_2 = tmp3_2 + s1_1512_2;
    // Op 1513: dim3x3 mul
    gl64_t s1_1513_0 = *(gl64_t*)&expressions_params[10][305];
    gl64_t s1_1513_1 = *(gl64_t*)&expressions_params[10][305+1];
    gl64_t s1_1513_2 = *(gl64_t*)&expressions_params[10][305+2];
    gl64_t kA1513 = (tmp3_0 + tmp3_1) * (s1_1513_0 + s1_1513_1);
    gl64_t kB1513 = (tmp3_0 + tmp3_2) * (s1_1513_0 + s1_1513_2);
    gl64_t kC1513 = (tmp3_1 + tmp3_2) * (s1_1513_1 + s1_1513_2);
    gl64_t kD1513 = tmp3_0 * s1_1513_0;
    gl64_t kE1513 = tmp3_1 * s1_1513_1;
    gl64_t kF1513 = tmp3_2 * s1_1513_2;
    gl64_t kG1513 = kD1513 - kE1513;
    tmp3_0 = (kC1513 + kG1513) - kF1513;
    tmp3_1 = ((((kA1513 + kC1513) - kE1513) - kE1513) - kD1513);
    tmp3_2 = kB1513 - kG1513;
    // Op 1514: dim3x1 add
    gl64_t s1_1514 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1514; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1515: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1516: dim3x3 mul
    gl64_t s1_1516_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1516_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1516_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1516 = (tmp3_0 + tmp3_1) * (s1_1516_0 + s1_1516_1);
    gl64_t kB1516 = (tmp3_0 + tmp3_2) * (s1_1516_0 + s1_1516_2);
    gl64_t kC1516 = (tmp3_1 + tmp3_2) * (s1_1516_1 + s1_1516_2);
    gl64_t kD1516 = tmp3_0 * s1_1516_0;
    gl64_t kE1516 = tmp3_1 * s1_1516_1;
    gl64_t kF1516 = tmp3_2 * s1_1516_2;
    gl64_t kG1516 = kD1516 - kE1516;
    tmp3_6 = (kC1516 + kG1516) - kF1516;
    tmp3_7 = ((((kA1516 + kC1516) - kE1516) - kE1516) - kD1516);
    tmp3_8 = kB1516 - kG1516;
    // Op 1517: dim3x1 mul
    gl64_t s0_1517_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1517_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1517_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1517 = *(gl64_t*)&expressions_params[10][53];
    tmp3_0 = s0_1517_0 * s1_1517; tmp3_1 = s0_1517_1 * s1_1517; tmp3_2 = s0_1517_2 * s1_1517;
    // Op 1518: dim3x1 add
    gl64_t s1_1518 = *(gl64_t*)&expressions_params[10][52];
    tmp3_0 = tmp3_0 + s1_1518; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1519: dim3x3 mul
    gl64_t s1_1519_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1519_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1519_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1519 = (tmp3_0 + tmp3_1) * (s1_1519_0 + s1_1519_1);
    gl64_t kB1519 = (tmp3_0 + tmp3_2) * (s1_1519_0 + s1_1519_2);
    gl64_t kC1519 = (tmp3_1 + tmp3_2) * (s1_1519_1 + s1_1519_2);
    gl64_t kD1519 = tmp3_0 * s1_1519_0;
    gl64_t kE1519 = tmp3_1 * s1_1519_1;
    gl64_t kF1519 = tmp3_2 * s1_1519_2;
    gl64_t kG1519 = kD1519 - kE1519;
    tmp3_0 = (kC1519 + kG1519) - kF1519;
    tmp3_1 = ((((kA1519 + kC1519) - kE1519) - kE1519) - kD1519);
    tmp3_2 = kB1519 - kG1519;
    // Op 1520: dim3x1 add
    gl64_t s1_1520 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1520; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1521: dim3x3 mul
    gl64_t s1_1521_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1521_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1521_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1521 = (tmp3_0 + tmp3_1) * (s1_1521_0 + s1_1521_1);
    gl64_t kB1521 = (tmp3_0 + tmp3_2) * (s1_1521_0 + s1_1521_2);
    gl64_t kC1521 = (tmp3_1 + tmp3_2) * (s1_1521_1 + s1_1521_2);
    gl64_t kD1521 = tmp3_0 * s1_1521_0;
    gl64_t kE1521 = tmp3_1 * s1_1521_1;
    gl64_t kF1521 = tmp3_2 * s1_1521_2;
    gl64_t kG1521 = kD1521 - kE1521;
    tmp3_0 = (kC1521 + kG1521) - kF1521;
    tmp3_1 = ((((kA1521 + kC1521) - kE1521) - kE1521) - kD1521);
    tmp3_2 = kB1521 - kG1521;
    // Op 1522: dim3x1 add
    gl64_t s1_1522 = *(gl64_t*)&expressions_params[10][92];
    tmp3_0 = tmp3_0 + s1_1522; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1523: dim3x3 mul
    gl64_t s1_1523_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1523_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1523_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1523 = (tmp3_0 + tmp3_1) * (s1_1523_0 + s1_1523_1);
    gl64_t kB1523 = (tmp3_0 + tmp3_2) * (s1_1523_0 + s1_1523_2);
    gl64_t kC1523 = (tmp3_1 + tmp3_2) * (s1_1523_1 + s1_1523_2);
    gl64_t kD1523 = tmp3_0 * s1_1523_0;
    gl64_t kE1523 = tmp3_1 * s1_1523_1;
    gl64_t kF1523 = tmp3_2 * s1_1523_2;
    gl64_t kG1523 = kD1523 - kE1523;
    tmp3_0 = (kC1523 + kG1523) - kF1523;
    tmp3_1 = ((((kA1523 + kC1523) - kE1523) - kE1523) - kD1523);
    tmp3_2 = kB1523 - kG1523;
    // Op 1524: dim3x1 add
    gl64_t s1_1524 = *(gl64_t*)&expressions_params[9][39];
    tmp3_0 = tmp3_0 + s1_1524; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1525: dim3x3 mul
    gl64_t s1_1525_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1525_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1525_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1525 = (tmp3_0 + tmp3_1) * (s1_1525_0 + s1_1525_1);
    gl64_t kB1525 = (tmp3_0 + tmp3_2) * (s1_1525_0 + s1_1525_2);
    gl64_t kC1525 = (tmp3_1 + tmp3_2) * (s1_1525_1 + s1_1525_2);
    gl64_t kD1525 = tmp3_0 * s1_1525_0;
    gl64_t kE1525 = tmp3_1 * s1_1525_1;
    gl64_t kF1525 = tmp3_2 * s1_1525_2;
    gl64_t kG1525 = kD1525 - kE1525;
    tmp3_0 = (kC1525 + kG1525) - kF1525;
    tmp3_1 = ((((kA1525 + kC1525) - kE1525) - kE1525) - kD1525);
    tmp3_2 = kB1525 - kG1525;
    // Op 1526: dim3x1 add
    gl64_t s1_1526 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1526; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1527: dim3x3 mul
    gl64_t s1_1527_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1527_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1527_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1528: dim3x1 add
    gl64_t s1_1528 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1528; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1529: dim3x3 add
    gl64_t s1_1529_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1529_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1529_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1529_0; tmp3_1 = tmp3_1 + s1_1529_1; tmp3_2 = tmp3_2 + s1_1529_2;
    // Op 1530: dim3x3 mul
    gl64_t s1_1530_0 = *(gl64_t*)&expressions_params[10][308];
    gl64_t s1_1530_1 = *(gl64_t*)&expressions_params[10][308+1];
    gl64_t s1_1530_2 = *(gl64_t*)&expressions_params[10][308+2];
    gl64_t kA1530 = (tmp3_0 + tmp3_1) * (s1_1530_0 + s1_1530_1);
    gl64_t kB1530 = (tmp3_0 + tmp3_2) * (s1_1530_0 + s1_1530_2);
    gl64_t kC1530 = (tmp3_1 + tmp3_2) * (s1_1530_1 + s1_1530_2);
    gl64_t kD1530 = tmp3_0 * s1_1530_0;
    gl64_t kE1530 = tmp3_1 * s1_1530_1;
    gl64_t kF1530 = tmp3_2 * s1_1530_2;
    gl64_t kG1530 = kD1530 - kE1530;
    tmp3_0 = (kC1530 + kG1530) - kF1530;
    tmp3_1 = ((((kA1530 + kC1530) - kE1530) - kE1530) - kD1530);
    tmp3_2 = kB1530 - kG1530;
    // Op 1531: dim3x1 sub
    gl64_t s1_1531 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1531; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1532: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1533: dim3x3 mul
    gl64_t s1_1533_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1533_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1533_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1533 = (tmp3_0 + tmp3_1) * (s1_1533_0 + s1_1533_1);
    gl64_t kB1533 = (tmp3_0 + tmp3_2) * (s1_1533_0 + s1_1533_2);
    gl64_t kC1533 = (tmp3_1 + tmp3_2) * (s1_1533_1 + s1_1533_2);
    gl64_t kD1533 = tmp3_0 * s1_1533_0;
    gl64_t kE1533 = tmp3_1 * s1_1533_1;
    gl64_t kF1533 = tmp3_2 * s1_1533_2;
    gl64_t kG1533 = kD1533 - kE1533;
    tmp3_6 = (kC1533 + kG1533) - kF1533;
    tmp3_7 = ((((kA1533 + kC1533) - kE1533) - kE1533) - kD1533);
    tmp3_8 = kB1533 - kG1533;
    // Op 1534: dim3x1 mul
    gl64_t s0_1534_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1534_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1534_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1534 = *(gl64_t*)&expressions_params[10][53];
    tmp3_0 = s0_1534_0 * s1_1534; tmp3_1 = s0_1534_1 * s1_1534; tmp3_2 = s0_1534_2 * s1_1534;
    // Op 1535: dim3x1 add
    gl64_t s1_1535 = *(gl64_t*)&expressions_params[10][52];
    tmp3_0 = tmp3_0 + s1_1535; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1536: dim3x3 mul
    gl64_t s1_1536_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1536_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1536_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1536 = (tmp3_0 + tmp3_1) * (s1_1536_0 + s1_1536_1);
    gl64_t kB1536 = (tmp3_0 + tmp3_2) * (s1_1536_0 + s1_1536_2);
    gl64_t kC1536 = (tmp3_1 + tmp3_2) * (s1_1536_1 + s1_1536_2);
    gl64_t kD1536 = tmp3_0 * s1_1536_0;
    gl64_t kE1536 = tmp3_1 * s1_1536_1;
    gl64_t kF1536 = tmp3_2 * s1_1536_2;
    gl64_t kG1536 = kD1536 - kE1536;
    tmp3_0 = (kC1536 + kG1536) - kF1536;
    tmp3_1 = ((((kA1536 + kC1536) - kE1536) - kE1536) - kD1536);
    tmp3_2 = kB1536 - kG1536;
    // Op 1537: dim3x1 add
    gl64_t s1_1537 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1537; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1538: dim3x3 mul
    gl64_t s1_1538_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1538_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1538_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1538 = (tmp3_0 + tmp3_1) * (s1_1538_0 + s1_1538_1);
    gl64_t kB1538 = (tmp3_0 + tmp3_2) * (s1_1538_0 + s1_1538_2);
    gl64_t kC1538 = (tmp3_1 + tmp3_2) * (s1_1538_1 + s1_1538_2);
    gl64_t kD1538 = tmp3_0 * s1_1538_0;
    gl64_t kE1538 = tmp3_1 * s1_1538_1;
    gl64_t kF1538 = tmp3_2 * s1_1538_2;
    gl64_t kG1538 = kD1538 - kE1538;
    tmp3_0 = (kC1538 + kG1538) - kF1538;
    tmp3_1 = ((((kA1538 + kC1538) - kE1538) - kE1538) - kD1538);
    tmp3_2 = kB1538 - kG1538;
    // Op 1539: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1540: dim3x3 mul
    gl64_t s1_1540_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1540_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1540_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1540 = (tmp3_0 + tmp3_1) * (s1_1540_0 + s1_1540_1);
    gl64_t kB1540 = (tmp3_0 + tmp3_2) * (s1_1540_0 + s1_1540_2);
    gl64_t kC1540 = (tmp3_1 + tmp3_2) * (s1_1540_1 + s1_1540_2);
    gl64_t kD1540 = tmp3_0 * s1_1540_0;
    gl64_t kE1540 = tmp3_1 * s1_1540_1;
    gl64_t kF1540 = tmp3_2 * s1_1540_2;
    gl64_t kG1540 = kD1540 - kE1540;
    tmp3_0 = (kC1540 + kG1540) - kF1540;
    tmp3_1 = ((((kA1540 + kC1540) - kE1540) - kE1540) - kD1540);
    tmp3_2 = kB1540 - kG1540;
    // Op 1541: dim3x1 add
    gl64_t s1_1541 = *(gl64_t*)&expressions_params[9][39];
    tmp3_0 = tmp3_0 + s1_1541; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1542: dim3x3 mul
    gl64_t s1_1542_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1542_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1542_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1542 = (tmp3_0 + tmp3_1) * (s1_1542_0 + s1_1542_1);
    gl64_t kB1542 = (tmp3_0 + tmp3_2) * (s1_1542_0 + s1_1542_2);
    gl64_t kC1542 = (tmp3_1 + tmp3_2) * (s1_1542_1 + s1_1542_2);
    gl64_t kD1542 = tmp3_0 * s1_1542_0;
    gl64_t kE1542 = tmp3_1 * s1_1542_1;
    gl64_t kF1542 = tmp3_2 * s1_1542_2;
    gl64_t kG1542 = kD1542 - kE1542;
    tmp3_0 = (kC1542 + kG1542) - kF1542;
    tmp3_1 = ((((kA1542 + kC1542) - kE1542) - kE1542) - kD1542);
    tmp3_2 = kB1542 - kG1542;
    // Op 1543: dim3x1 add
    gl64_t s1_1543 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1543; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1544: dim3x3 mul
    gl64_t s1_1544_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1544_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1544_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1545: dim3x1 add
    gl64_t s1_1545 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1545; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1546: dim3x3 add
    gl64_t s1_1546_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1546_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1546_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1546_0; tmp3_1 = tmp3_1 + s1_1546_1; tmp3_2 = tmp3_2 + s1_1546_2;
    // Op 1547: dim3x3 mul
    gl64_t s1_1547_0 = *(gl64_t*)&expressions_params[10][311];
    gl64_t s1_1547_1 = *(gl64_t*)&expressions_params[10][311+1];
    gl64_t s1_1547_2 = *(gl64_t*)&expressions_params[10][311+2];
    gl64_t kA1547 = (tmp3_0 + tmp3_1) * (s1_1547_0 + s1_1547_1);
    gl64_t kB1547 = (tmp3_0 + tmp3_2) * (s1_1547_0 + s1_1547_2);
    gl64_t kC1547 = (tmp3_1 + tmp3_2) * (s1_1547_1 + s1_1547_2);
    gl64_t kD1547 = tmp3_0 * s1_1547_0;
    gl64_t kE1547 = tmp3_1 * s1_1547_1;
    gl64_t kF1547 = tmp3_2 * s1_1547_2;
    gl64_t kG1547 = kD1547 - kE1547;
    tmp3_0 = (kC1547 + kG1547) - kF1547;
    tmp3_1 = ((((kA1547 + kC1547) - kE1547) - kE1547) - kD1547);
    tmp3_2 = kB1547 - kG1547;
    // Op 1548: dim1x1 sub
    gl64_t s0_1548 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1548 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1548 - s1_1548;
    // Op 1549: dim1x1 sub_swap
    gl64_t s1_1549 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1549 - tmp1_0;
    // Op 1550: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1551: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1552: dim3x3 mul
    gl64_t s1_1552_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1552_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1552_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1552 = (tmp3_0 + tmp3_1) * (s1_1552_0 + s1_1552_1);
    gl64_t kB1552 = (tmp3_0 + tmp3_2) * (s1_1552_0 + s1_1552_2);
    gl64_t kC1552 = (tmp3_1 + tmp3_2) * (s1_1552_1 + s1_1552_2);
    gl64_t kD1552 = tmp3_0 * s1_1552_0;
    gl64_t kE1552 = tmp3_1 * s1_1552_1;
    gl64_t kF1552 = tmp3_2 * s1_1552_2;
    gl64_t kG1552 = kD1552 - kE1552;
    tmp3_6 = (kC1552 + kG1552) - kF1552;
    tmp3_7 = ((((kA1552 + kC1552) - kE1552) - kE1552) - kD1552);
    tmp3_8 = kB1552 - kG1552;
    // Op 1553: dim1x1 sub
    gl64_t s1_1553 = *(gl64_t*)&expressions_params[10][93];
    tmp1_0 = tmp1_4 - s1_1553;
    // Op 1554: dim1x1 sub
    gl64_t s1_1554 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1554;
    // Op 1555: dim3x1 mul
    gl64_t s0_1555_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1555_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1555_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1555_0 * tmp1_0; tmp3_1 = s0_1555_1 * tmp1_0; tmp3_2 = s0_1555_2 * tmp1_0;
    // Op 1556: dim3x1 add
    gl64_t s1_1556 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1556; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1557: dim3x3 add
    gl64_t s1_1557_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1557_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1557_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1557_0; tmp3_1 = tmp3_1 + s1_1557_1; tmp3_2 = tmp3_2 + s1_1557_2;
    // Op 1558: dim3x3 mul
    gl64_t s1_1558_0 = *(gl64_t*)&expressions_params[10][314];
    gl64_t s1_1558_1 = *(gl64_t*)&expressions_params[10][314+1];
    gl64_t s1_1558_2 = *(gl64_t*)&expressions_params[10][314+2];
    gl64_t kA1558 = (tmp3_0 + tmp3_1) * (s1_1558_0 + s1_1558_1);
    gl64_t kB1558 = (tmp3_0 + tmp3_2) * (s1_1558_0 + s1_1558_2);
    gl64_t kC1558 = (tmp3_1 + tmp3_2) * (s1_1558_1 + s1_1558_2);
    gl64_t kD1558 = tmp3_0 * s1_1558_0;
    gl64_t kE1558 = tmp3_1 * s1_1558_1;
    gl64_t kF1558 = tmp3_2 * s1_1558_2;
    gl64_t kG1558 = kD1558 - kE1558;
    tmp3_0 = (kC1558 + kG1558) - kF1558;
    tmp3_1 = ((((kA1558 + kC1558) - kE1558) - kE1558) - kD1558);
    tmp3_2 = kB1558 - kG1558;
    // Op 1559: dim3x1 add
    gl64_t s1_1559 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1559; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1560: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1561: dim3x3 mul
    gl64_t s1_1561_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1561_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1561_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1561 = (tmp3_0 + tmp3_1) * (s1_1561_0 + s1_1561_1);
    gl64_t kB1561 = (tmp3_0 + tmp3_2) * (s1_1561_0 + s1_1561_2);
    gl64_t kC1561 = (tmp3_1 + tmp3_2) * (s1_1561_1 + s1_1561_2);
    gl64_t kD1561 = tmp3_0 * s1_1561_0;
    gl64_t kE1561 = tmp3_1 * s1_1561_1;
    gl64_t kF1561 = tmp3_2 * s1_1561_2;
    gl64_t kG1561 = kD1561 - kE1561;
    tmp3_6 = (kC1561 + kG1561) - kF1561;
    tmp3_7 = ((((kA1561 + kC1561) - kE1561) - kE1561) - kD1561);
    tmp3_8 = kB1561 - kG1561;
    // Op 1562: dim3x1 mul
    gl64_t s0_1562_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1562_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1562_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1562 = *(gl64_t*)&expressions_params[10][55];
    tmp3_0 = s0_1562_0 * s1_1562; tmp3_1 = s0_1562_1 * s1_1562; tmp3_2 = s0_1562_2 * s1_1562;
    // Op 1563: dim3x1 add
    gl64_t s1_1563 = *(gl64_t*)&expressions_params[10][54];
    tmp3_0 = tmp3_0 + s1_1563; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1564: dim3x3 mul
    gl64_t s1_1564_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1564_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1564_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1564 = (tmp3_0 + tmp3_1) * (s1_1564_0 + s1_1564_1);
    gl64_t kB1564 = (tmp3_0 + tmp3_2) * (s1_1564_0 + s1_1564_2);
    gl64_t kC1564 = (tmp3_1 + tmp3_2) * (s1_1564_1 + s1_1564_2);
    gl64_t kD1564 = tmp3_0 * s1_1564_0;
    gl64_t kE1564 = tmp3_1 * s1_1564_1;
    gl64_t kF1564 = tmp3_2 * s1_1564_2;
    gl64_t kG1564 = kD1564 - kE1564;
    tmp3_0 = (kC1564 + kG1564) - kF1564;
    tmp3_1 = ((((kA1564 + kC1564) - kE1564) - kE1564) - kD1564);
    tmp3_2 = kB1564 - kG1564;
    // Op 1565: dim3x1 add
    gl64_t s1_1565 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1565; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1566: dim3x3 mul
    gl64_t s1_1566_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1566_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1566_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1566 = (tmp3_0 + tmp3_1) * (s1_1566_0 + s1_1566_1);
    gl64_t kB1566 = (tmp3_0 + tmp3_2) * (s1_1566_0 + s1_1566_2);
    gl64_t kC1566 = (tmp3_1 + tmp3_2) * (s1_1566_1 + s1_1566_2);
    gl64_t kD1566 = tmp3_0 * s1_1566_0;
    gl64_t kE1566 = tmp3_1 * s1_1566_1;
    gl64_t kF1566 = tmp3_2 * s1_1566_2;
    gl64_t kG1566 = kD1566 - kE1566;
    tmp3_0 = (kC1566 + kG1566) - kF1566;
    tmp3_1 = ((((kA1566 + kC1566) - kE1566) - kE1566) - kD1566);
    tmp3_2 = kB1566 - kG1566;
    // Op 1567: dim3x1 add
    gl64_t s1_1567 = *(gl64_t*)&expressions_params[10][93];
    tmp3_0 = tmp3_0 + s1_1567; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1568: dim3x3 mul
    gl64_t s1_1568_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1568_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1568_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1568 = (tmp3_0 + tmp3_1) * (s1_1568_0 + s1_1568_1);
    gl64_t kB1568 = (tmp3_0 + tmp3_2) * (s1_1568_0 + s1_1568_2);
    gl64_t kC1568 = (tmp3_1 + tmp3_2) * (s1_1568_1 + s1_1568_2);
    gl64_t kD1568 = tmp3_0 * s1_1568_0;
    gl64_t kE1568 = tmp3_1 * s1_1568_1;
    gl64_t kF1568 = tmp3_2 * s1_1568_2;
    gl64_t kG1568 = kD1568 - kE1568;
    tmp3_0 = (kC1568 + kG1568) - kF1568;
    tmp3_1 = ((((kA1568 + kC1568) - kE1568) - kE1568) - kD1568);
    tmp3_2 = kB1568 - kG1568;
    // Op 1569: dim3x1 add
    gl64_t s1_1569 = *(gl64_t*)&expressions_params[9][40];
    tmp3_0 = tmp3_0 + s1_1569; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1570: dim3x3 mul
    gl64_t s1_1570_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1570_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1570_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1570 = (tmp3_0 + tmp3_1) * (s1_1570_0 + s1_1570_1);
    gl64_t kB1570 = (tmp3_0 + tmp3_2) * (s1_1570_0 + s1_1570_2);
    gl64_t kC1570 = (tmp3_1 + tmp3_2) * (s1_1570_1 + s1_1570_2);
    gl64_t kD1570 = tmp3_0 * s1_1570_0;
    gl64_t kE1570 = tmp3_1 * s1_1570_1;
    gl64_t kF1570 = tmp3_2 * s1_1570_2;
    gl64_t kG1570 = kD1570 - kE1570;
    tmp3_0 = (kC1570 + kG1570) - kF1570;
    tmp3_1 = ((((kA1570 + kC1570) - kE1570) - kE1570) - kD1570);
    tmp3_2 = kB1570 - kG1570;
    // Op 1571: dim3x1 add
    gl64_t s1_1571 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1571; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1572: dim3x3 mul
    gl64_t s1_1572_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1572_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1572_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1573: dim3x1 add
    gl64_t s1_1573 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1573; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1574: dim3x3 add
    gl64_t s1_1574_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1574_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1574_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1574_0; tmp3_1 = tmp3_1 + s1_1574_1; tmp3_2 = tmp3_2 + s1_1574_2;
    // Op 1575: dim3x3 mul
    gl64_t s1_1575_0 = *(gl64_t*)&expressions_params[10][317];
    gl64_t s1_1575_1 = *(gl64_t*)&expressions_params[10][317+1];
    gl64_t s1_1575_2 = *(gl64_t*)&expressions_params[10][317+2];
    gl64_t kA1575 = (tmp3_0 + tmp3_1) * (s1_1575_0 + s1_1575_1);
    gl64_t kB1575 = (tmp3_0 + tmp3_2) * (s1_1575_0 + s1_1575_2);
    gl64_t kC1575 = (tmp3_1 + tmp3_2) * (s1_1575_1 + s1_1575_2);
    gl64_t kD1575 = tmp3_0 * s1_1575_0;
    gl64_t kE1575 = tmp3_1 * s1_1575_1;
    gl64_t kF1575 = tmp3_2 * s1_1575_2;
    gl64_t kG1575 = kD1575 - kE1575;
    tmp3_0 = (kC1575 + kG1575) - kF1575;
    tmp3_1 = ((((kA1575 + kC1575) - kE1575) - kE1575) - kD1575);
    tmp3_2 = kB1575 - kG1575;
    // Op 1576: dim3x1 sub
    gl64_t s1_1576 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1576; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1577: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1578: dim3x3 mul
    gl64_t s1_1578_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1578_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1578_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1578 = (tmp3_0 + tmp3_1) * (s1_1578_0 + s1_1578_1);
    gl64_t kB1578 = (tmp3_0 + tmp3_2) * (s1_1578_0 + s1_1578_2);
    gl64_t kC1578 = (tmp3_1 + tmp3_2) * (s1_1578_1 + s1_1578_2);
    gl64_t kD1578 = tmp3_0 * s1_1578_0;
    gl64_t kE1578 = tmp3_1 * s1_1578_1;
    gl64_t kF1578 = tmp3_2 * s1_1578_2;
    gl64_t kG1578 = kD1578 - kE1578;
    tmp3_6 = (kC1578 + kG1578) - kF1578;
    tmp3_7 = ((((kA1578 + kC1578) - kE1578) - kE1578) - kD1578);
    tmp3_8 = kB1578 - kG1578;
    // Op 1579: dim3x1 mul
    gl64_t s0_1579_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1579_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1579_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1579 = *(gl64_t*)&expressions_params[10][55];
    tmp3_0 = s0_1579_0 * s1_1579; tmp3_1 = s0_1579_1 * s1_1579; tmp3_2 = s0_1579_2 * s1_1579;
    // Op 1580: dim3x1 add
    gl64_t s1_1580 = *(gl64_t*)&expressions_params[10][54];
    tmp3_0 = tmp3_0 + s1_1580; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1581: dim3x3 mul
    gl64_t s1_1581_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1581_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1581_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1581 = (tmp3_0 + tmp3_1) * (s1_1581_0 + s1_1581_1);
    gl64_t kB1581 = (tmp3_0 + tmp3_2) * (s1_1581_0 + s1_1581_2);
    gl64_t kC1581 = (tmp3_1 + tmp3_2) * (s1_1581_1 + s1_1581_2);
    gl64_t kD1581 = tmp3_0 * s1_1581_0;
    gl64_t kE1581 = tmp3_1 * s1_1581_1;
    gl64_t kF1581 = tmp3_2 * s1_1581_2;
    gl64_t kG1581 = kD1581 - kE1581;
    tmp3_0 = (kC1581 + kG1581) - kF1581;
    tmp3_1 = ((((kA1581 + kC1581) - kE1581) - kE1581) - kD1581);
    tmp3_2 = kB1581 - kG1581;
    // Op 1582: dim3x1 add
    gl64_t s1_1582 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1582; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1583: dim3x3 mul
    gl64_t s1_1583_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1583_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1583_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1583 = (tmp3_0 + tmp3_1) * (s1_1583_0 + s1_1583_1);
    gl64_t kB1583 = (tmp3_0 + tmp3_2) * (s1_1583_0 + s1_1583_2);
    gl64_t kC1583 = (tmp3_1 + tmp3_2) * (s1_1583_1 + s1_1583_2);
    gl64_t kD1583 = tmp3_0 * s1_1583_0;
    gl64_t kE1583 = tmp3_1 * s1_1583_1;
    gl64_t kF1583 = tmp3_2 * s1_1583_2;
    gl64_t kG1583 = kD1583 - kE1583;
    tmp3_0 = (kC1583 + kG1583) - kF1583;
    tmp3_1 = ((((kA1583 + kC1583) - kE1583) - kE1583) - kD1583);
    tmp3_2 = kB1583 - kG1583;
    // Op 1584: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1585: dim3x3 mul
    gl64_t s1_1585_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1585_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1585_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1585 = (tmp3_0 + tmp3_1) * (s1_1585_0 + s1_1585_1);
    gl64_t kB1585 = (tmp3_0 + tmp3_2) * (s1_1585_0 + s1_1585_2);
    gl64_t kC1585 = (tmp3_1 + tmp3_2) * (s1_1585_1 + s1_1585_2);
    gl64_t kD1585 = tmp3_0 * s1_1585_0;
    gl64_t kE1585 = tmp3_1 * s1_1585_1;
    gl64_t kF1585 = tmp3_2 * s1_1585_2;
    gl64_t kG1585 = kD1585 - kE1585;
    tmp3_0 = (kC1585 + kG1585) - kF1585;
    tmp3_1 = ((((kA1585 + kC1585) - kE1585) - kE1585) - kD1585);
    tmp3_2 = kB1585 - kG1585;
    // Op 1586: dim3x1 add
    gl64_t s1_1586 = *(gl64_t*)&expressions_params[9][40];
    tmp3_0 = tmp3_0 + s1_1586; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1587: dim3x3 mul
    gl64_t s1_1587_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1587_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1587_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1587 = (tmp3_0 + tmp3_1) * (s1_1587_0 + s1_1587_1);
    gl64_t kB1587 = (tmp3_0 + tmp3_2) * (s1_1587_0 + s1_1587_2);
    gl64_t kC1587 = (tmp3_1 + tmp3_2) * (s1_1587_1 + s1_1587_2);
    gl64_t kD1587 = tmp3_0 * s1_1587_0;
    gl64_t kE1587 = tmp3_1 * s1_1587_1;
    gl64_t kF1587 = tmp3_2 * s1_1587_2;
    gl64_t kG1587 = kD1587 - kE1587;
    tmp3_0 = (kC1587 + kG1587) - kF1587;
    tmp3_1 = ((((kA1587 + kC1587) - kE1587) - kE1587) - kD1587);
    tmp3_2 = kB1587 - kG1587;
    // Op 1588: dim3x1 add
    gl64_t s1_1588 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1588; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1589: dim3x3 mul
    gl64_t s1_1589_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1589_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1589_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1590: dim3x1 add
    gl64_t s1_1590 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1590; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1591: dim3x3 add
    gl64_t s1_1591_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1591_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1591_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1591_0; tmp3_1 = tmp3_1 + s1_1591_1; tmp3_2 = tmp3_2 + s1_1591_2;
    // Op 1592: dim3x3 mul
    gl64_t s1_1592_0 = *(gl64_t*)&expressions_params[10][320];
    gl64_t s1_1592_1 = *(gl64_t*)&expressions_params[10][320+1];
    gl64_t s1_1592_2 = *(gl64_t*)&expressions_params[10][320+2];
    gl64_t kA1592 = (tmp3_0 + tmp3_1) * (s1_1592_0 + s1_1592_1);
    gl64_t kB1592 = (tmp3_0 + tmp3_2) * (s1_1592_0 + s1_1592_2);
    gl64_t kC1592 = (tmp3_1 + tmp3_2) * (s1_1592_1 + s1_1592_2);
    gl64_t kD1592 = tmp3_0 * s1_1592_0;
    gl64_t kE1592 = tmp3_1 * s1_1592_1;
    gl64_t kF1592 = tmp3_2 * s1_1592_2;
    gl64_t kG1592 = kD1592 - kE1592;
    tmp3_0 = (kC1592 + kG1592) - kF1592;
    tmp3_1 = ((((kA1592 + kC1592) - kE1592) - kE1592) - kD1592);
    tmp3_2 = kB1592 - kG1592;
    // Op 1593: dim1x1 sub
    gl64_t s0_1593 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1593 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1593 - s1_1593;
    // Op 1594: dim1x1 sub_swap
    gl64_t s1_1594 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1594 - tmp1_0;
    // Op 1595: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1596: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1597: dim3x3 mul
    gl64_t s1_1597_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1597_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1597_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1597 = (tmp3_0 + tmp3_1) * (s1_1597_0 + s1_1597_1);
    gl64_t kB1597 = (tmp3_0 + tmp3_2) * (s1_1597_0 + s1_1597_2);
    gl64_t kC1597 = (tmp3_1 + tmp3_2) * (s1_1597_1 + s1_1597_2);
    gl64_t kD1597 = tmp3_0 * s1_1597_0;
    gl64_t kE1597 = tmp3_1 * s1_1597_1;
    gl64_t kF1597 = tmp3_2 * s1_1597_2;
    gl64_t kG1597 = kD1597 - kE1597;
    tmp3_6 = (kC1597 + kG1597) - kF1597;
    tmp3_7 = ((((kA1597 + kC1597) - kE1597) - kE1597) - kD1597);
    tmp3_8 = kB1597 - kG1597;
    // Op 1598: dim1x1 sub
    gl64_t s1_1598 = *(gl64_t*)&expressions_params[10][94];
    tmp1_0 = tmp1_4 - s1_1598;
    // Op 1599: dim1x1 sub
    gl64_t s1_1599 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1599;
    // Op 1600: dim3x1 mul
    gl64_t s0_1600_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1600_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1600_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1600_0 * tmp1_0; tmp3_1 = s0_1600_1 * tmp1_0; tmp3_2 = s0_1600_2 * tmp1_0;
    // Op 1601: dim3x1 add
    gl64_t s1_1601 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1601; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1602: dim3x3 add
    gl64_t s1_1602_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1602_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1602_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1602_0; tmp3_1 = tmp3_1 + s1_1602_1; tmp3_2 = tmp3_2 + s1_1602_2;
    // Op 1603: dim3x3 mul
    gl64_t s1_1603_0 = *(gl64_t*)&expressions_params[10][323];
    gl64_t s1_1603_1 = *(gl64_t*)&expressions_params[10][323+1];
    gl64_t s1_1603_2 = *(gl64_t*)&expressions_params[10][323+2];
    gl64_t kA1603 = (tmp3_0 + tmp3_1) * (s1_1603_0 + s1_1603_1);
    gl64_t kB1603 = (tmp3_0 + tmp3_2) * (s1_1603_0 + s1_1603_2);
    gl64_t kC1603 = (tmp3_1 + tmp3_2) * (s1_1603_1 + s1_1603_2);
    gl64_t kD1603 = tmp3_0 * s1_1603_0;
    gl64_t kE1603 = tmp3_1 * s1_1603_1;
    gl64_t kF1603 = tmp3_2 * s1_1603_2;
    gl64_t kG1603 = kD1603 - kE1603;
    tmp3_0 = (kC1603 + kG1603) - kF1603;
    tmp3_1 = ((((kA1603 + kC1603) - kE1603) - kE1603) - kD1603);
    tmp3_2 = kB1603 - kG1603;
    // Op 1604: dim3x1 add
    gl64_t s1_1604 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1604; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1605: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1606: dim3x3 mul
    gl64_t s1_1606_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1606_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1606_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1606 = (tmp3_0 + tmp3_1) * (s1_1606_0 + s1_1606_1);
    gl64_t kB1606 = (tmp3_0 + tmp3_2) * (s1_1606_0 + s1_1606_2);
    gl64_t kC1606 = (tmp3_1 + tmp3_2) * (s1_1606_1 + s1_1606_2);
    gl64_t kD1606 = tmp3_0 * s1_1606_0;
    gl64_t kE1606 = tmp3_1 * s1_1606_1;
    gl64_t kF1606 = tmp3_2 * s1_1606_2;
    gl64_t kG1606 = kD1606 - kE1606;
    tmp3_6 = (kC1606 + kG1606) - kF1606;
    tmp3_7 = ((((kA1606 + kC1606) - kE1606) - kE1606) - kD1606);
    tmp3_8 = kB1606 - kG1606;
    // Op 1607: dim3x1 mul
    gl64_t s0_1607_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1607_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1607_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1607 = *(gl64_t*)&expressions_params[10][57];
    tmp3_0 = s0_1607_0 * s1_1607; tmp3_1 = s0_1607_1 * s1_1607; tmp3_2 = s0_1607_2 * s1_1607;
    // Op 1608: dim3x1 add
    gl64_t s1_1608 = *(gl64_t*)&expressions_params[10][56];
    tmp3_0 = tmp3_0 + s1_1608; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1609: dim3x3 mul
    gl64_t s1_1609_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1609_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1609_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1609 = (tmp3_0 + tmp3_1) * (s1_1609_0 + s1_1609_1);
    gl64_t kB1609 = (tmp3_0 + tmp3_2) * (s1_1609_0 + s1_1609_2);
    gl64_t kC1609 = (tmp3_1 + tmp3_2) * (s1_1609_1 + s1_1609_2);
    gl64_t kD1609 = tmp3_0 * s1_1609_0;
    gl64_t kE1609 = tmp3_1 * s1_1609_1;
    gl64_t kF1609 = tmp3_2 * s1_1609_2;
    gl64_t kG1609 = kD1609 - kE1609;
    tmp3_0 = (kC1609 + kG1609) - kF1609;
    tmp3_1 = ((((kA1609 + kC1609) - kE1609) - kE1609) - kD1609);
    tmp3_2 = kB1609 - kG1609;
    // Op 1610: dim3x1 add
    gl64_t s1_1610 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1610; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1611: dim3x3 mul
    gl64_t s1_1611_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1611_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1611_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1611 = (tmp3_0 + tmp3_1) * (s1_1611_0 + s1_1611_1);
    gl64_t kB1611 = (tmp3_0 + tmp3_2) * (s1_1611_0 + s1_1611_2);
    gl64_t kC1611 = (tmp3_1 + tmp3_2) * (s1_1611_1 + s1_1611_2);
    gl64_t kD1611 = tmp3_0 * s1_1611_0;
    gl64_t kE1611 = tmp3_1 * s1_1611_1;
    gl64_t kF1611 = tmp3_2 * s1_1611_2;
    gl64_t kG1611 = kD1611 - kE1611;
    tmp3_0 = (kC1611 + kG1611) - kF1611;
    tmp3_1 = ((((kA1611 + kC1611) - kE1611) - kE1611) - kD1611);
    tmp3_2 = kB1611 - kG1611;
    // Op 1612: dim3x1 add
    gl64_t s1_1612 = *(gl64_t*)&expressions_params[10][94];
    tmp3_0 = tmp3_0 + s1_1612; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1613: dim3x3 mul
    gl64_t s1_1613_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1613_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1613_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1613 = (tmp3_0 + tmp3_1) * (s1_1613_0 + s1_1613_1);
    gl64_t kB1613 = (tmp3_0 + tmp3_2) * (s1_1613_0 + s1_1613_2);
    gl64_t kC1613 = (tmp3_1 + tmp3_2) * (s1_1613_1 + s1_1613_2);
    gl64_t kD1613 = tmp3_0 * s1_1613_0;
    gl64_t kE1613 = tmp3_1 * s1_1613_1;
    gl64_t kF1613 = tmp3_2 * s1_1613_2;
    gl64_t kG1613 = kD1613 - kE1613;
    tmp3_0 = (kC1613 + kG1613) - kF1613;
    tmp3_1 = ((((kA1613 + kC1613) - kE1613) - kE1613) - kD1613);
    tmp3_2 = kB1613 - kG1613;
    // Op 1614: dim3x1 add
    gl64_t s1_1614 = *(gl64_t*)&expressions_params[9][41];
    tmp3_0 = tmp3_0 + s1_1614; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1615: dim3x3 mul
    gl64_t s1_1615_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1615_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1615_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1615 = (tmp3_0 + tmp3_1) * (s1_1615_0 + s1_1615_1);
    gl64_t kB1615 = (tmp3_0 + tmp3_2) * (s1_1615_0 + s1_1615_2);
    gl64_t kC1615 = (tmp3_1 + tmp3_2) * (s1_1615_1 + s1_1615_2);
    gl64_t kD1615 = tmp3_0 * s1_1615_0;
    gl64_t kE1615 = tmp3_1 * s1_1615_1;
    gl64_t kF1615 = tmp3_2 * s1_1615_2;
    gl64_t kG1615 = kD1615 - kE1615;
    tmp3_0 = (kC1615 + kG1615) - kF1615;
    tmp3_1 = ((((kA1615 + kC1615) - kE1615) - kE1615) - kD1615);
    tmp3_2 = kB1615 - kG1615;
    // Op 1616: dim3x1 add
    gl64_t s1_1616 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1616; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1617: dim3x3 mul
    gl64_t s1_1617_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1617_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1617_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1618: dim3x1 add
    gl64_t s1_1618 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1618; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1619: dim3x3 add
    gl64_t s1_1619_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1619_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1619_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1619_0; tmp3_1 = tmp3_1 + s1_1619_1; tmp3_2 = tmp3_2 + s1_1619_2;
    // Op 1620: dim3x3 mul
    gl64_t s1_1620_0 = *(gl64_t*)&expressions_params[10][326];
    gl64_t s1_1620_1 = *(gl64_t*)&expressions_params[10][326+1];
    gl64_t s1_1620_2 = *(gl64_t*)&expressions_params[10][326+2];
    gl64_t kA1620 = (tmp3_0 + tmp3_1) * (s1_1620_0 + s1_1620_1);
    gl64_t kB1620 = (tmp3_0 + tmp3_2) * (s1_1620_0 + s1_1620_2);
    gl64_t kC1620 = (tmp3_1 + tmp3_2) * (s1_1620_1 + s1_1620_2);
    gl64_t kD1620 = tmp3_0 * s1_1620_0;
    gl64_t kE1620 = tmp3_1 * s1_1620_1;
    gl64_t kF1620 = tmp3_2 * s1_1620_2;
    gl64_t kG1620 = kD1620 - kE1620;
    tmp3_0 = (kC1620 + kG1620) - kF1620;
    tmp3_1 = ((((kA1620 + kC1620) - kE1620) - kE1620) - kD1620);
    tmp3_2 = kB1620 - kG1620;
    // Op 1621: dim3x1 sub
    gl64_t s1_1621 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1621; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1622: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1623: dim3x3 mul
    gl64_t s1_1623_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1623_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1623_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1623 = (tmp3_0 + tmp3_1) * (s1_1623_0 + s1_1623_1);
    gl64_t kB1623 = (tmp3_0 + tmp3_2) * (s1_1623_0 + s1_1623_2);
    gl64_t kC1623 = (tmp3_1 + tmp3_2) * (s1_1623_1 + s1_1623_2);
    gl64_t kD1623 = tmp3_0 * s1_1623_0;
    gl64_t kE1623 = tmp3_1 * s1_1623_1;
    gl64_t kF1623 = tmp3_2 * s1_1623_2;
    gl64_t kG1623 = kD1623 - kE1623;
    tmp3_6 = (kC1623 + kG1623) - kF1623;
    tmp3_7 = ((((kA1623 + kC1623) - kE1623) - kE1623) - kD1623);
    tmp3_8 = kB1623 - kG1623;
    // Op 1624: dim3x1 mul
    gl64_t s0_1624_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1624_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1624_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1624 = *(gl64_t*)&expressions_params[10][57];
    tmp3_0 = s0_1624_0 * s1_1624; tmp3_1 = s0_1624_1 * s1_1624; tmp3_2 = s0_1624_2 * s1_1624;
    // Op 1625: dim3x1 add
    gl64_t s1_1625 = *(gl64_t*)&expressions_params[10][56];
    tmp3_0 = tmp3_0 + s1_1625; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1626: dim3x3 mul
    gl64_t s1_1626_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1626_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1626_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1626 = (tmp3_0 + tmp3_1) * (s1_1626_0 + s1_1626_1);
    gl64_t kB1626 = (tmp3_0 + tmp3_2) * (s1_1626_0 + s1_1626_2);
    gl64_t kC1626 = (tmp3_1 + tmp3_2) * (s1_1626_1 + s1_1626_2);
    gl64_t kD1626 = tmp3_0 * s1_1626_0;
    gl64_t kE1626 = tmp3_1 * s1_1626_1;
    gl64_t kF1626 = tmp3_2 * s1_1626_2;
    gl64_t kG1626 = kD1626 - kE1626;
    tmp3_0 = (kC1626 + kG1626) - kF1626;
    tmp3_1 = ((((kA1626 + kC1626) - kE1626) - kE1626) - kD1626);
    tmp3_2 = kB1626 - kG1626;
    // Op 1627: dim3x1 add
    gl64_t s1_1627 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1627; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1628: dim3x3 mul
    gl64_t s1_1628_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1628_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1628_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1628 = (tmp3_0 + tmp3_1) * (s1_1628_0 + s1_1628_1);
    gl64_t kB1628 = (tmp3_0 + tmp3_2) * (s1_1628_0 + s1_1628_2);
    gl64_t kC1628 = (tmp3_1 + tmp3_2) * (s1_1628_1 + s1_1628_2);
    gl64_t kD1628 = tmp3_0 * s1_1628_0;
    gl64_t kE1628 = tmp3_1 * s1_1628_1;
    gl64_t kF1628 = tmp3_2 * s1_1628_2;
    gl64_t kG1628 = kD1628 - kE1628;
    tmp3_0 = (kC1628 + kG1628) - kF1628;
    tmp3_1 = ((((kA1628 + kC1628) - kE1628) - kE1628) - kD1628);
    tmp3_2 = kB1628 - kG1628;
    // Op 1629: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1630: dim3x3 mul
    gl64_t s1_1630_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1630_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1630_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1630 = (tmp3_0 + tmp3_1) * (s1_1630_0 + s1_1630_1);
    gl64_t kB1630 = (tmp3_0 + tmp3_2) * (s1_1630_0 + s1_1630_2);
    gl64_t kC1630 = (tmp3_1 + tmp3_2) * (s1_1630_1 + s1_1630_2);
    gl64_t kD1630 = tmp3_0 * s1_1630_0;
    gl64_t kE1630 = tmp3_1 * s1_1630_1;
    gl64_t kF1630 = tmp3_2 * s1_1630_2;
    gl64_t kG1630 = kD1630 - kE1630;
    tmp3_0 = (kC1630 + kG1630) - kF1630;
    tmp3_1 = ((((kA1630 + kC1630) - kE1630) - kE1630) - kD1630);
    tmp3_2 = kB1630 - kG1630;
    // Op 1631: dim3x1 add
    gl64_t s1_1631 = *(gl64_t*)&expressions_params[9][41];
    tmp3_0 = tmp3_0 + s1_1631; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1632: dim3x3 mul
    gl64_t s1_1632_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1632_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1632_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1632 = (tmp3_0 + tmp3_1) * (s1_1632_0 + s1_1632_1);
    gl64_t kB1632 = (tmp3_0 + tmp3_2) * (s1_1632_0 + s1_1632_2);
    gl64_t kC1632 = (tmp3_1 + tmp3_2) * (s1_1632_1 + s1_1632_2);
    gl64_t kD1632 = tmp3_0 * s1_1632_0;
    gl64_t kE1632 = tmp3_1 * s1_1632_1;
    gl64_t kF1632 = tmp3_2 * s1_1632_2;
    gl64_t kG1632 = kD1632 - kE1632;
    tmp3_0 = (kC1632 + kG1632) - kF1632;
    tmp3_1 = ((((kA1632 + kC1632) - kE1632) - kE1632) - kD1632);
    tmp3_2 = kB1632 - kG1632;
    // Op 1633: dim3x1 add
    gl64_t s1_1633 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1633; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1634: dim3x3 mul
    gl64_t s1_1634_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1634_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1634_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1635: dim3x1 add
    gl64_t s1_1635 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1635; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1636: dim3x3 add
    gl64_t s1_1636_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1636_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1636_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1636_0; tmp3_1 = tmp3_1 + s1_1636_1; tmp3_2 = tmp3_2 + s1_1636_2;
    // Op 1637: dim3x3 mul
    gl64_t s1_1637_0 = *(gl64_t*)&expressions_params[10][329];
    gl64_t s1_1637_1 = *(gl64_t*)&expressions_params[10][329+1];
    gl64_t s1_1637_2 = *(gl64_t*)&expressions_params[10][329+2];
    gl64_t kA1637 = (tmp3_0 + tmp3_1) * (s1_1637_0 + s1_1637_1);
    gl64_t kB1637 = (tmp3_0 + tmp3_2) * (s1_1637_0 + s1_1637_2);
    gl64_t kC1637 = (tmp3_1 + tmp3_2) * (s1_1637_1 + s1_1637_2);
    gl64_t kD1637 = tmp3_0 * s1_1637_0;
    gl64_t kE1637 = tmp3_1 * s1_1637_1;
    gl64_t kF1637 = tmp3_2 * s1_1637_2;
    gl64_t kG1637 = kD1637 - kE1637;
    tmp3_0 = (kC1637 + kG1637) - kF1637;
    tmp3_1 = ((((kA1637 + kC1637) - kE1637) - kE1637) - kD1637);
    tmp3_2 = kB1637 - kG1637;
    // Op 1638: dim1x1 sub
    gl64_t s0_1638 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1638 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1638 - s1_1638;
    // Op 1639: dim1x1 sub_swap
    gl64_t s1_1639 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1639 - tmp1_0;
    // Op 1640: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1641: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1642: dim3x3 mul
    gl64_t s1_1642_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1642_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1642_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1642 = (tmp3_0 + tmp3_1) * (s1_1642_0 + s1_1642_1);
    gl64_t kB1642 = (tmp3_0 + tmp3_2) * (s1_1642_0 + s1_1642_2);
    gl64_t kC1642 = (tmp3_1 + tmp3_2) * (s1_1642_1 + s1_1642_2);
    gl64_t kD1642 = tmp3_0 * s1_1642_0;
    gl64_t kE1642 = tmp3_1 * s1_1642_1;
    gl64_t kF1642 = tmp3_2 * s1_1642_2;
    gl64_t kG1642 = kD1642 - kE1642;
    tmp3_6 = (kC1642 + kG1642) - kF1642;
    tmp3_7 = ((((kA1642 + kC1642) - kE1642) - kE1642) - kD1642);
    tmp3_8 = kB1642 - kG1642;
    // Op 1643: dim1x1 sub
    gl64_t s1_1643 = *(gl64_t*)&expressions_params[10][95];
    tmp1_0 = tmp1_4 - s1_1643;
    // Op 1644: dim1x1 sub
    gl64_t s1_1644 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1644;
    // Op 1645: dim3x1 mul
    gl64_t s0_1645_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1645_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1645_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1645_0 * tmp1_0; tmp3_1 = s0_1645_1 * tmp1_0; tmp3_2 = s0_1645_2 * tmp1_0;
    // Op 1646: dim3x1 add
    gl64_t s1_1646 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1646; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1647: dim3x3 add
    gl64_t s1_1647_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1647_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1647_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1647_0; tmp3_1 = tmp3_1 + s1_1647_1; tmp3_2 = tmp3_2 + s1_1647_2;
    // Op 1648: dim3x3 mul
    gl64_t s1_1648_0 = *(gl64_t*)&expressions_params[10][332];
    gl64_t s1_1648_1 = *(gl64_t*)&expressions_params[10][332+1];
    gl64_t s1_1648_2 = *(gl64_t*)&expressions_params[10][332+2];
    gl64_t kA1648 = (tmp3_0 + tmp3_1) * (s1_1648_0 + s1_1648_1);
    gl64_t kB1648 = (tmp3_0 + tmp3_2) * (s1_1648_0 + s1_1648_2);
    gl64_t kC1648 = (tmp3_1 + tmp3_2) * (s1_1648_1 + s1_1648_2);
    gl64_t kD1648 = tmp3_0 * s1_1648_0;
    gl64_t kE1648 = tmp3_1 * s1_1648_1;
    gl64_t kF1648 = tmp3_2 * s1_1648_2;
    gl64_t kG1648 = kD1648 - kE1648;
    tmp3_0 = (kC1648 + kG1648) - kF1648;
    tmp3_1 = ((((kA1648 + kC1648) - kE1648) - kE1648) - kD1648);
    tmp3_2 = kB1648 - kG1648;
    // Op 1649: dim3x1 add
    gl64_t s1_1649 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1649; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1650: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1651: dim3x3 mul
    gl64_t s1_1651_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1651_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1651_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1651 = (tmp3_0 + tmp3_1) * (s1_1651_0 + s1_1651_1);
    gl64_t kB1651 = (tmp3_0 + tmp3_2) * (s1_1651_0 + s1_1651_2);
    gl64_t kC1651 = (tmp3_1 + tmp3_2) * (s1_1651_1 + s1_1651_2);
    gl64_t kD1651 = tmp3_0 * s1_1651_0;
    gl64_t kE1651 = tmp3_1 * s1_1651_1;
    gl64_t kF1651 = tmp3_2 * s1_1651_2;
    gl64_t kG1651 = kD1651 - kE1651;
    tmp3_6 = (kC1651 + kG1651) - kF1651;
    tmp3_7 = ((((kA1651 + kC1651) - kE1651) - kE1651) - kD1651);
    tmp3_8 = kB1651 - kG1651;
    // Op 1652: dim3x1 mul
    gl64_t s0_1652_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1652_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1652_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1652 = *(gl64_t*)&expressions_params[10][59];
    tmp3_0 = s0_1652_0 * s1_1652; tmp3_1 = s0_1652_1 * s1_1652; tmp3_2 = s0_1652_2 * s1_1652;
    // Op 1653: dim3x1 add
    gl64_t s1_1653 = *(gl64_t*)&expressions_params[10][58];
    tmp3_0 = tmp3_0 + s1_1653; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1654: dim3x3 mul
    gl64_t s1_1654_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1654_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1654_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1654 = (tmp3_0 + tmp3_1) * (s1_1654_0 + s1_1654_1);
    gl64_t kB1654 = (tmp3_0 + tmp3_2) * (s1_1654_0 + s1_1654_2);
    gl64_t kC1654 = (tmp3_1 + tmp3_2) * (s1_1654_1 + s1_1654_2);
    gl64_t kD1654 = tmp3_0 * s1_1654_0;
    gl64_t kE1654 = tmp3_1 * s1_1654_1;
    gl64_t kF1654 = tmp3_2 * s1_1654_2;
    gl64_t kG1654 = kD1654 - kE1654;
    tmp3_0 = (kC1654 + kG1654) - kF1654;
    tmp3_1 = ((((kA1654 + kC1654) - kE1654) - kE1654) - kD1654);
    tmp3_2 = kB1654 - kG1654;
    // Op 1655: dim3x1 add
    gl64_t s1_1655 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1655; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1656: dim3x3 mul
    gl64_t s1_1656_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1656_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1656_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1656 = (tmp3_0 + tmp3_1) * (s1_1656_0 + s1_1656_1);
    gl64_t kB1656 = (tmp3_0 + tmp3_2) * (s1_1656_0 + s1_1656_2);
    gl64_t kC1656 = (tmp3_1 + tmp3_2) * (s1_1656_1 + s1_1656_2);
    gl64_t kD1656 = tmp3_0 * s1_1656_0;
    gl64_t kE1656 = tmp3_1 * s1_1656_1;
    gl64_t kF1656 = tmp3_2 * s1_1656_2;
    gl64_t kG1656 = kD1656 - kE1656;
    tmp3_0 = (kC1656 + kG1656) - kF1656;
    tmp3_1 = ((((kA1656 + kC1656) - kE1656) - kE1656) - kD1656);
    tmp3_2 = kB1656 - kG1656;
    // Op 1657: dim3x1 add
    gl64_t s1_1657 = *(gl64_t*)&expressions_params[10][95];
    tmp3_0 = tmp3_0 + s1_1657; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1658: dim3x3 mul
    gl64_t s1_1658_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1658_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1658_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1658 = (tmp3_0 + tmp3_1) * (s1_1658_0 + s1_1658_1);
    gl64_t kB1658 = (tmp3_0 + tmp3_2) * (s1_1658_0 + s1_1658_2);
    gl64_t kC1658 = (tmp3_1 + tmp3_2) * (s1_1658_1 + s1_1658_2);
    gl64_t kD1658 = tmp3_0 * s1_1658_0;
    gl64_t kE1658 = tmp3_1 * s1_1658_1;
    gl64_t kF1658 = tmp3_2 * s1_1658_2;
    gl64_t kG1658 = kD1658 - kE1658;
    tmp3_0 = (kC1658 + kG1658) - kF1658;
    tmp3_1 = ((((kA1658 + kC1658) - kE1658) - kE1658) - kD1658);
    tmp3_2 = kB1658 - kG1658;
    // Op 1659: dim3x1 add
    gl64_t s1_1659 = *(gl64_t*)&expressions_params[9][42];
    tmp3_0 = tmp3_0 + s1_1659; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1660: dim3x3 mul
    gl64_t s1_1660_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1660_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1660_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1660 = (tmp3_0 + tmp3_1) * (s1_1660_0 + s1_1660_1);
    gl64_t kB1660 = (tmp3_0 + tmp3_2) * (s1_1660_0 + s1_1660_2);
    gl64_t kC1660 = (tmp3_1 + tmp3_2) * (s1_1660_1 + s1_1660_2);
    gl64_t kD1660 = tmp3_0 * s1_1660_0;
    gl64_t kE1660 = tmp3_1 * s1_1660_1;
    gl64_t kF1660 = tmp3_2 * s1_1660_2;
    gl64_t kG1660 = kD1660 - kE1660;
    tmp3_0 = (kC1660 + kG1660) - kF1660;
    tmp3_1 = ((((kA1660 + kC1660) - kE1660) - kE1660) - kD1660);
    tmp3_2 = kB1660 - kG1660;
    // Op 1661: dim3x1 add
    gl64_t s1_1661 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1661; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1662: dim3x3 mul
    gl64_t s1_1662_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1662_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1662_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1663: dim3x1 add
    gl64_t s1_1663 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1663; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1664: dim3x3 add
    gl64_t s1_1664_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1664_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1664_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1664_0; tmp3_1 = tmp3_1 + s1_1664_1; tmp3_2 = tmp3_2 + s1_1664_2;
    // Op 1665: dim3x3 mul
    gl64_t s1_1665_0 = *(gl64_t*)&expressions_params[10][335];
    gl64_t s1_1665_1 = *(gl64_t*)&expressions_params[10][335+1];
    gl64_t s1_1665_2 = *(gl64_t*)&expressions_params[10][335+2];
    gl64_t kA1665 = (tmp3_0 + tmp3_1) * (s1_1665_0 + s1_1665_1);
    gl64_t kB1665 = (tmp3_0 + tmp3_2) * (s1_1665_0 + s1_1665_2);
    gl64_t kC1665 = (tmp3_1 + tmp3_2) * (s1_1665_1 + s1_1665_2);
    gl64_t kD1665 = tmp3_0 * s1_1665_0;
    gl64_t kE1665 = tmp3_1 * s1_1665_1;
    gl64_t kF1665 = tmp3_2 * s1_1665_2;
    gl64_t kG1665 = kD1665 - kE1665;
    tmp3_0 = (kC1665 + kG1665) - kF1665;
    tmp3_1 = ((((kA1665 + kC1665) - kE1665) - kE1665) - kD1665);
    tmp3_2 = kB1665 - kG1665;
    // Op 1666: dim3x1 sub
    gl64_t s1_1666 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1666; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1667: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1668: dim3x3 mul
    gl64_t s1_1668_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1668_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1668_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1668 = (tmp3_0 + tmp3_1) * (s1_1668_0 + s1_1668_1);
    gl64_t kB1668 = (tmp3_0 + tmp3_2) * (s1_1668_0 + s1_1668_2);
    gl64_t kC1668 = (tmp3_1 + tmp3_2) * (s1_1668_1 + s1_1668_2);
    gl64_t kD1668 = tmp3_0 * s1_1668_0;
    gl64_t kE1668 = tmp3_1 * s1_1668_1;
    gl64_t kF1668 = tmp3_2 * s1_1668_2;
    gl64_t kG1668 = kD1668 - kE1668;
    tmp3_6 = (kC1668 + kG1668) - kF1668;
    tmp3_7 = ((((kA1668 + kC1668) - kE1668) - kE1668) - kD1668);
    tmp3_8 = kB1668 - kG1668;
    // Op 1669: dim3x1 mul
    gl64_t s0_1669_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1669_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1669_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1669 = *(gl64_t*)&expressions_params[10][59];
    tmp3_0 = s0_1669_0 * s1_1669; tmp3_1 = s0_1669_1 * s1_1669; tmp3_2 = s0_1669_2 * s1_1669;
    // Op 1670: dim3x1 add
    gl64_t s1_1670 = *(gl64_t*)&expressions_params[10][58];
    tmp3_0 = tmp3_0 + s1_1670; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1671: dim3x3 mul
    gl64_t s1_1671_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1671_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1671_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1671 = (tmp3_0 + tmp3_1) * (s1_1671_0 + s1_1671_1);
    gl64_t kB1671 = (tmp3_0 + tmp3_2) * (s1_1671_0 + s1_1671_2);
    gl64_t kC1671 = (tmp3_1 + tmp3_2) * (s1_1671_1 + s1_1671_2);
    gl64_t kD1671 = tmp3_0 * s1_1671_0;
    gl64_t kE1671 = tmp3_1 * s1_1671_1;
    gl64_t kF1671 = tmp3_2 * s1_1671_2;
    gl64_t kG1671 = kD1671 - kE1671;
    tmp3_0 = (kC1671 + kG1671) - kF1671;
    tmp3_1 = ((((kA1671 + kC1671) - kE1671) - kE1671) - kD1671);
    tmp3_2 = kB1671 - kG1671;
    // Op 1672: dim3x1 add
    gl64_t s1_1672 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1672; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1673: dim3x3 mul
    gl64_t s1_1673_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1673_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1673_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1673 = (tmp3_0 + tmp3_1) * (s1_1673_0 + s1_1673_1);
    gl64_t kB1673 = (tmp3_0 + tmp3_2) * (s1_1673_0 + s1_1673_2);
    gl64_t kC1673 = (tmp3_1 + tmp3_2) * (s1_1673_1 + s1_1673_2);
    gl64_t kD1673 = tmp3_0 * s1_1673_0;
    gl64_t kE1673 = tmp3_1 * s1_1673_1;
    gl64_t kF1673 = tmp3_2 * s1_1673_2;
    gl64_t kG1673 = kD1673 - kE1673;
    tmp3_0 = (kC1673 + kG1673) - kF1673;
    tmp3_1 = ((((kA1673 + kC1673) - kE1673) - kE1673) - kD1673);
    tmp3_2 = kB1673 - kG1673;
    // Op 1674: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1675: dim3x3 mul
    gl64_t s1_1675_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1675_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1675_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1675 = (tmp3_0 + tmp3_1) * (s1_1675_0 + s1_1675_1);
    gl64_t kB1675 = (tmp3_0 + tmp3_2) * (s1_1675_0 + s1_1675_2);
    gl64_t kC1675 = (tmp3_1 + tmp3_2) * (s1_1675_1 + s1_1675_2);
    gl64_t kD1675 = tmp3_0 * s1_1675_0;
    gl64_t kE1675 = tmp3_1 * s1_1675_1;
    gl64_t kF1675 = tmp3_2 * s1_1675_2;
    gl64_t kG1675 = kD1675 - kE1675;
    tmp3_0 = (kC1675 + kG1675) - kF1675;
    tmp3_1 = ((((kA1675 + kC1675) - kE1675) - kE1675) - kD1675);
    tmp3_2 = kB1675 - kG1675;
    // Op 1676: dim3x1 add
    gl64_t s1_1676 = *(gl64_t*)&expressions_params[9][42];
    tmp3_0 = tmp3_0 + s1_1676; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1677: dim3x3 mul
    gl64_t s1_1677_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1677_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1677_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1677 = (tmp3_0 + tmp3_1) * (s1_1677_0 + s1_1677_1);
    gl64_t kB1677 = (tmp3_0 + tmp3_2) * (s1_1677_0 + s1_1677_2);
    gl64_t kC1677 = (tmp3_1 + tmp3_2) * (s1_1677_1 + s1_1677_2);
    gl64_t kD1677 = tmp3_0 * s1_1677_0;
    gl64_t kE1677 = tmp3_1 * s1_1677_1;
    gl64_t kF1677 = tmp3_2 * s1_1677_2;
    gl64_t kG1677 = kD1677 - kE1677;
    tmp3_0 = (kC1677 + kG1677) - kF1677;
    tmp3_1 = ((((kA1677 + kC1677) - kE1677) - kE1677) - kD1677);
    tmp3_2 = kB1677 - kG1677;
    // Op 1678: dim3x1 add
    gl64_t s1_1678 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1678; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1679: dim3x3 mul
    gl64_t s1_1679_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1679_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1679_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1680: dim3x1 add
    gl64_t s1_1680 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1680; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1681: dim3x3 add
    gl64_t s1_1681_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1681_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1681_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1681_0; tmp3_1 = tmp3_1 + s1_1681_1; tmp3_2 = tmp3_2 + s1_1681_2;
    // Op 1682: dim3x3 mul
    gl64_t s1_1682_0 = *(gl64_t*)&expressions_params[10][338];
    gl64_t s1_1682_1 = *(gl64_t*)&expressions_params[10][338+1];
    gl64_t s1_1682_2 = *(gl64_t*)&expressions_params[10][338+2];
    gl64_t kA1682 = (tmp3_0 + tmp3_1) * (s1_1682_0 + s1_1682_1);
    gl64_t kB1682 = (tmp3_0 + tmp3_2) * (s1_1682_0 + s1_1682_2);
    gl64_t kC1682 = (tmp3_1 + tmp3_2) * (s1_1682_1 + s1_1682_2);
    gl64_t kD1682 = tmp3_0 * s1_1682_0;
    gl64_t kE1682 = tmp3_1 * s1_1682_1;
    gl64_t kF1682 = tmp3_2 * s1_1682_2;
    gl64_t kG1682 = kD1682 - kE1682;
    tmp3_0 = (kC1682 + kG1682) - kF1682;
    tmp3_1 = ((((kA1682 + kC1682) - kE1682) - kE1682) - kD1682);
    tmp3_2 = kB1682 - kG1682;
    // Op 1683: dim1x1 sub
    gl64_t s0_1683 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1683 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1683 - s1_1683;
    // Op 1684: dim1x1 sub_swap
    gl64_t s1_1684 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1684 - tmp1_0;
    // Op 1685: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1686: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1687: dim3x3 mul
    gl64_t s1_1687_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1687_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1687_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1687 = (tmp3_0 + tmp3_1) * (s1_1687_0 + s1_1687_1);
    gl64_t kB1687 = (tmp3_0 + tmp3_2) * (s1_1687_0 + s1_1687_2);
    gl64_t kC1687 = (tmp3_1 + tmp3_2) * (s1_1687_1 + s1_1687_2);
    gl64_t kD1687 = tmp3_0 * s1_1687_0;
    gl64_t kE1687 = tmp3_1 * s1_1687_1;
    gl64_t kF1687 = tmp3_2 * s1_1687_2;
    gl64_t kG1687 = kD1687 - kE1687;
    tmp3_6 = (kC1687 + kG1687) - kF1687;
    tmp3_7 = ((((kA1687 + kC1687) - kE1687) - kE1687) - kD1687);
    tmp3_8 = kB1687 - kG1687;
    // Op 1688: dim1x1 sub
    gl64_t s1_1688 = *(gl64_t*)&expressions_params[10][96];
    tmp1_0 = tmp1_4 - s1_1688;
    // Op 1689: dim1x1 sub
    gl64_t s1_1689 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1689;
    // Op 1690: dim3x1 mul
    gl64_t s0_1690_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1690_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1690_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1690_0 * tmp1_0; tmp3_1 = s0_1690_1 * tmp1_0; tmp3_2 = s0_1690_2 * tmp1_0;
    // Op 1691: dim3x1 add
    gl64_t s1_1691 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1691; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1692: dim3x3 add
    gl64_t s1_1692_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1692_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1692_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1692_0; tmp3_1 = tmp3_1 + s1_1692_1; tmp3_2 = tmp3_2 + s1_1692_2;
    // Op 1693: dim3x3 mul
    gl64_t s1_1693_0 = *(gl64_t*)&expressions_params[10][341];
    gl64_t s1_1693_1 = *(gl64_t*)&expressions_params[10][341+1];
    gl64_t s1_1693_2 = *(gl64_t*)&expressions_params[10][341+2];
    gl64_t kA1693 = (tmp3_0 + tmp3_1) * (s1_1693_0 + s1_1693_1);
    gl64_t kB1693 = (tmp3_0 + tmp3_2) * (s1_1693_0 + s1_1693_2);
    gl64_t kC1693 = (tmp3_1 + tmp3_2) * (s1_1693_1 + s1_1693_2);
    gl64_t kD1693 = tmp3_0 * s1_1693_0;
    gl64_t kE1693 = tmp3_1 * s1_1693_1;
    gl64_t kF1693 = tmp3_2 * s1_1693_2;
    gl64_t kG1693 = kD1693 - kE1693;
    tmp3_0 = (kC1693 + kG1693) - kF1693;
    tmp3_1 = ((((kA1693 + kC1693) - kE1693) - kE1693) - kD1693);
    tmp3_2 = kB1693 - kG1693;
    // Op 1694: dim3x1 add
    gl64_t s1_1694 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1694; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1695: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1696: dim3x3 mul
    gl64_t s1_1696_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1696_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1696_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1696 = (tmp3_0 + tmp3_1) * (s1_1696_0 + s1_1696_1);
    gl64_t kB1696 = (tmp3_0 + tmp3_2) * (s1_1696_0 + s1_1696_2);
    gl64_t kC1696 = (tmp3_1 + tmp3_2) * (s1_1696_1 + s1_1696_2);
    gl64_t kD1696 = tmp3_0 * s1_1696_0;
    gl64_t kE1696 = tmp3_1 * s1_1696_1;
    gl64_t kF1696 = tmp3_2 * s1_1696_2;
    gl64_t kG1696 = kD1696 - kE1696;
    tmp3_6 = (kC1696 + kG1696) - kF1696;
    tmp3_7 = ((((kA1696 + kC1696) - kE1696) - kE1696) - kD1696);
    tmp3_8 = kB1696 - kG1696;
    // Op 1697: dim3x1 mul
    gl64_t s0_1697_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1697_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1697_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1697 = *(gl64_t*)&expressions_params[10][61];
    tmp3_0 = s0_1697_0 * s1_1697; tmp3_1 = s0_1697_1 * s1_1697; tmp3_2 = s0_1697_2 * s1_1697;
    // Op 1698: dim3x1 add
    gl64_t s1_1698 = *(gl64_t*)&expressions_params[10][60];
    tmp3_0 = tmp3_0 + s1_1698; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1699: dim3x3 mul
    gl64_t s1_1699_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1699_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1699_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1699 = (tmp3_0 + tmp3_1) * (s1_1699_0 + s1_1699_1);
    gl64_t kB1699 = (tmp3_0 + tmp3_2) * (s1_1699_0 + s1_1699_2);
    gl64_t kC1699 = (tmp3_1 + tmp3_2) * (s1_1699_1 + s1_1699_2);
    gl64_t kD1699 = tmp3_0 * s1_1699_0;
    gl64_t kE1699 = tmp3_1 * s1_1699_1;
    gl64_t kF1699 = tmp3_2 * s1_1699_2;
    gl64_t kG1699 = kD1699 - kE1699;
    tmp3_0 = (kC1699 + kG1699) - kF1699;
    tmp3_1 = ((((kA1699 + kC1699) - kE1699) - kE1699) - kD1699);
    tmp3_2 = kB1699 - kG1699;
    // Op 1700: dim3x1 add
    gl64_t s1_1700 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1700; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1701: dim3x3 mul
    gl64_t s1_1701_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1701_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1701_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1701 = (tmp3_0 + tmp3_1) * (s1_1701_0 + s1_1701_1);
    gl64_t kB1701 = (tmp3_0 + tmp3_2) * (s1_1701_0 + s1_1701_2);
    gl64_t kC1701 = (tmp3_1 + tmp3_2) * (s1_1701_1 + s1_1701_2);
    gl64_t kD1701 = tmp3_0 * s1_1701_0;
    gl64_t kE1701 = tmp3_1 * s1_1701_1;
    gl64_t kF1701 = tmp3_2 * s1_1701_2;
    gl64_t kG1701 = kD1701 - kE1701;
    tmp3_0 = (kC1701 + kG1701) - kF1701;
    tmp3_1 = ((((kA1701 + kC1701) - kE1701) - kE1701) - kD1701);
    tmp3_2 = kB1701 - kG1701;
    // Op 1702: dim3x1 add
    gl64_t s1_1702 = *(gl64_t*)&expressions_params[10][96];
    tmp3_0 = tmp3_0 + s1_1702; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1703: dim3x3 mul
    gl64_t s1_1703_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1703_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1703_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1703 = (tmp3_0 + tmp3_1) * (s1_1703_0 + s1_1703_1);
    gl64_t kB1703 = (tmp3_0 + tmp3_2) * (s1_1703_0 + s1_1703_2);
    gl64_t kC1703 = (tmp3_1 + tmp3_2) * (s1_1703_1 + s1_1703_2);
    gl64_t kD1703 = tmp3_0 * s1_1703_0;
    gl64_t kE1703 = tmp3_1 * s1_1703_1;
    gl64_t kF1703 = tmp3_2 * s1_1703_2;
    gl64_t kG1703 = kD1703 - kE1703;
    tmp3_0 = (kC1703 + kG1703) - kF1703;
    tmp3_1 = ((((kA1703 + kC1703) - kE1703) - kE1703) - kD1703);
    tmp3_2 = kB1703 - kG1703;
    // Op 1704: dim3x1 add
    gl64_t s1_1704 = *(gl64_t*)&expressions_params[9][43];
    tmp3_0 = tmp3_0 + s1_1704; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1705: dim3x3 mul
    gl64_t s1_1705_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1705_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1705_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1705 = (tmp3_0 + tmp3_1) * (s1_1705_0 + s1_1705_1);
    gl64_t kB1705 = (tmp3_0 + tmp3_2) * (s1_1705_0 + s1_1705_2);
    gl64_t kC1705 = (tmp3_1 + tmp3_2) * (s1_1705_1 + s1_1705_2);
    gl64_t kD1705 = tmp3_0 * s1_1705_0;
    gl64_t kE1705 = tmp3_1 * s1_1705_1;
    gl64_t kF1705 = tmp3_2 * s1_1705_2;
    gl64_t kG1705 = kD1705 - kE1705;
    tmp3_0 = (kC1705 + kG1705) - kF1705;
    tmp3_1 = ((((kA1705 + kC1705) - kE1705) - kE1705) - kD1705);
    tmp3_2 = kB1705 - kG1705;
    // Op 1706: dim3x1 add
    gl64_t s1_1706 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1706; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1707: dim3x3 mul
    gl64_t s1_1707_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1707_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1707_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1708: dim3x1 add
    gl64_t s1_1708 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1708; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1709: dim3x3 add
    gl64_t s1_1709_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1709_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1709_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1709_0; tmp3_1 = tmp3_1 + s1_1709_1; tmp3_2 = tmp3_2 + s1_1709_2;
    // Op 1710: dim3x3 mul
    gl64_t s1_1710_0 = *(gl64_t*)&expressions_params[10][344];
    gl64_t s1_1710_1 = *(gl64_t*)&expressions_params[10][344+1];
    gl64_t s1_1710_2 = *(gl64_t*)&expressions_params[10][344+2];
    gl64_t kA1710 = (tmp3_0 + tmp3_1) * (s1_1710_0 + s1_1710_1);
    gl64_t kB1710 = (tmp3_0 + tmp3_2) * (s1_1710_0 + s1_1710_2);
    gl64_t kC1710 = (tmp3_1 + tmp3_2) * (s1_1710_1 + s1_1710_2);
    gl64_t kD1710 = tmp3_0 * s1_1710_0;
    gl64_t kE1710 = tmp3_1 * s1_1710_1;
    gl64_t kF1710 = tmp3_2 * s1_1710_2;
    gl64_t kG1710 = kD1710 - kE1710;
    tmp3_0 = (kC1710 + kG1710) - kF1710;
    tmp3_1 = ((((kA1710 + kC1710) - kE1710) - kE1710) - kD1710);
    tmp3_2 = kB1710 - kG1710;
    // Op 1711: dim3x1 sub
    gl64_t s1_1711 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1711; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1712: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1713: dim3x3 mul
    gl64_t s1_1713_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1713_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1713_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1713 = (tmp3_0 + tmp3_1) * (s1_1713_0 + s1_1713_1);
    gl64_t kB1713 = (tmp3_0 + tmp3_2) * (s1_1713_0 + s1_1713_2);
    gl64_t kC1713 = (tmp3_1 + tmp3_2) * (s1_1713_1 + s1_1713_2);
    gl64_t kD1713 = tmp3_0 * s1_1713_0;
    gl64_t kE1713 = tmp3_1 * s1_1713_1;
    gl64_t kF1713 = tmp3_2 * s1_1713_2;
    gl64_t kG1713 = kD1713 - kE1713;
    tmp3_6 = (kC1713 + kG1713) - kF1713;
    tmp3_7 = ((((kA1713 + kC1713) - kE1713) - kE1713) - kD1713);
    tmp3_8 = kB1713 - kG1713;
    // Op 1714: dim3x1 mul
    gl64_t s0_1714_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1714_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1714_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1714 = *(gl64_t*)&expressions_params[10][61];
    tmp3_0 = s0_1714_0 * s1_1714; tmp3_1 = s0_1714_1 * s1_1714; tmp3_2 = s0_1714_2 * s1_1714;
    // Op 1715: dim3x1 add
    gl64_t s1_1715 = *(gl64_t*)&expressions_params[10][60];
    tmp3_0 = tmp3_0 + s1_1715; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1716: dim3x3 mul
    gl64_t s1_1716_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1716_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1716_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1716 = (tmp3_0 + tmp3_1) * (s1_1716_0 + s1_1716_1);
    gl64_t kB1716 = (tmp3_0 + tmp3_2) * (s1_1716_0 + s1_1716_2);
    gl64_t kC1716 = (tmp3_1 + tmp3_2) * (s1_1716_1 + s1_1716_2);
    gl64_t kD1716 = tmp3_0 * s1_1716_0;
    gl64_t kE1716 = tmp3_1 * s1_1716_1;
    gl64_t kF1716 = tmp3_2 * s1_1716_2;
    gl64_t kG1716 = kD1716 - kE1716;
    tmp3_0 = (kC1716 + kG1716) - kF1716;
    tmp3_1 = ((((kA1716 + kC1716) - kE1716) - kE1716) - kD1716);
    tmp3_2 = kB1716 - kG1716;
    // Op 1717: dim3x1 add
    gl64_t s1_1717 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1717; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1718: dim3x3 mul
    gl64_t s1_1718_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1718_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1718_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1718 = (tmp3_0 + tmp3_1) * (s1_1718_0 + s1_1718_1);
    gl64_t kB1718 = (tmp3_0 + tmp3_2) * (s1_1718_0 + s1_1718_2);
    gl64_t kC1718 = (tmp3_1 + tmp3_2) * (s1_1718_1 + s1_1718_2);
    gl64_t kD1718 = tmp3_0 * s1_1718_0;
    gl64_t kE1718 = tmp3_1 * s1_1718_1;
    gl64_t kF1718 = tmp3_2 * s1_1718_2;
    gl64_t kG1718 = kD1718 - kE1718;
    tmp3_0 = (kC1718 + kG1718) - kF1718;
    tmp3_1 = ((((kA1718 + kC1718) - kE1718) - kE1718) - kD1718);
    tmp3_2 = kB1718 - kG1718;
    // Op 1719: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1720: dim3x3 mul
    gl64_t s1_1720_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1720_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1720_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1720 = (tmp3_0 + tmp3_1) * (s1_1720_0 + s1_1720_1);
    gl64_t kB1720 = (tmp3_0 + tmp3_2) * (s1_1720_0 + s1_1720_2);
    gl64_t kC1720 = (tmp3_1 + tmp3_2) * (s1_1720_1 + s1_1720_2);
    gl64_t kD1720 = tmp3_0 * s1_1720_0;
    gl64_t kE1720 = tmp3_1 * s1_1720_1;
    gl64_t kF1720 = tmp3_2 * s1_1720_2;
    gl64_t kG1720 = kD1720 - kE1720;
    tmp3_0 = (kC1720 + kG1720) - kF1720;
    tmp3_1 = ((((kA1720 + kC1720) - kE1720) - kE1720) - kD1720);
    tmp3_2 = kB1720 - kG1720;
    // Op 1721: dim3x1 add
    gl64_t s1_1721 = *(gl64_t*)&expressions_params[9][43];
    tmp3_0 = tmp3_0 + s1_1721; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1722: dim3x3 mul
    gl64_t s1_1722_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1722_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1722_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1722 = (tmp3_0 + tmp3_1) * (s1_1722_0 + s1_1722_1);
    gl64_t kB1722 = (tmp3_0 + tmp3_2) * (s1_1722_0 + s1_1722_2);
    gl64_t kC1722 = (tmp3_1 + tmp3_2) * (s1_1722_1 + s1_1722_2);
    gl64_t kD1722 = tmp3_0 * s1_1722_0;
    gl64_t kE1722 = tmp3_1 * s1_1722_1;
    gl64_t kF1722 = tmp3_2 * s1_1722_2;
    gl64_t kG1722 = kD1722 - kE1722;
    tmp3_0 = (kC1722 + kG1722) - kF1722;
    tmp3_1 = ((((kA1722 + kC1722) - kE1722) - kE1722) - kD1722);
    tmp3_2 = kB1722 - kG1722;
    // Op 1723: dim3x1 add
    gl64_t s1_1723 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1723; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1724: dim3x3 mul
    gl64_t s1_1724_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1724_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1724_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1725: dim3x1 add
    gl64_t s1_1725 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1725; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1726: dim3x3 add
    gl64_t s1_1726_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1726_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1726_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1726_0; tmp3_1 = tmp3_1 + s1_1726_1; tmp3_2 = tmp3_2 + s1_1726_2;
    // Op 1727: dim3x3 mul
    gl64_t s1_1727_0 = *(gl64_t*)&expressions_params[10][347];
    gl64_t s1_1727_1 = *(gl64_t*)&expressions_params[10][347+1];
    gl64_t s1_1727_2 = *(gl64_t*)&expressions_params[10][347+2];
    gl64_t kA1727 = (tmp3_0 + tmp3_1) * (s1_1727_0 + s1_1727_1);
    gl64_t kB1727 = (tmp3_0 + tmp3_2) * (s1_1727_0 + s1_1727_2);
    gl64_t kC1727 = (tmp3_1 + tmp3_2) * (s1_1727_1 + s1_1727_2);
    gl64_t kD1727 = tmp3_0 * s1_1727_0;
    gl64_t kE1727 = tmp3_1 * s1_1727_1;
    gl64_t kF1727 = tmp3_2 * s1_1727_2;
    gl64_t kG1727 = kD1727 - kE1727;
    tmp3_0 = (kC1727 + kG1727) - kF1727;
    tmp3_1 = ((((kA1727 + kC1727) - kE1727) - kE1727) - kD1727);
    tmp3_2 = kB1727 - kG1727;
    // Op 1728: dim1x1 sub
    gl64_t s0_1728 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1728 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1728 - s1_1728;
    // Op 1729: dim1x1 sub_swap
    gl64_t s1_1729 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1729 - tmp1_0;
    // Op 1730: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1731: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1732: dim3x3 mul
    gl64_t s1_1732_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1732_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1732_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1732 = (tmp3_0 + tmp3_1) * (s1_1732_0 + s1_1732_1);
    gl64_t kB1732 = (tmp3_0 + tmp3_2) * (s1_1732_0 + s1_1732_2);
    gl64_t kC1732 = (tmp3_1 + tmp3_2) * (s1_1732_1 + s1_1732_2);
    gl64_t kD1732 = tmp3_0 * s1_1732_0;
    gl64_t kE1732 = tmp3_1 * s1_1732_1;
    gl64_t kF1732 = tmp3_2 * s1_1732_2;
    gl64_t kG1732 = kD1732 - kE1732;
    tmp3_6 = (kC1732 + kG1732) - kF1732;
    tmp3_7 = ((((kA1732 + kC1732) - kE1732) - kE1732) - kD1732);
    tmp3_8 = kB1732 - kG1732;
    // Op 1733: dim1x1 sub
    gl64_t s1_1733 = *(gl64_t*)&expressions_params[10][97];
    tmp1_0 = tmp1_4 - s1_1733;
    // Op 1734: dim1x1 sub
    gl64_t s1_1734 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1734;
    // Op 1735: dim3x1 mul
    gl64_t s0_1735_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1735_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1735_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1735_0 * tmp1_0; tmp3_1 = s0_1735_1 * tmp1_0; tmp3_2 = s0_1735_2 * tmp1_0;
    // Op 1736: dim3x1 add
    gl64_t s1_1736 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1736; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1737: dim3x3 add
    gl64_t s1_1737_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1737_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1737_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1737_0; tmp3_1 = tmp3_1 + s1_1737_1; tmp3_2 = tmp3_2 + s1_1737_2;
    // Op 1738: dim3x3 mul
    gl64_t s1_1738_0 = *(gl64_t*)&expressions_params[10][350];
    gl64_t s1_1738_1 = *(gl64_t*)&expressions_params[10][350+1];
    gl64_t s1_1738_2 = *(gl64_t*)&expressions_params[10][350+2];
    gl64_t kA1738 = (tmp3_0 + tmp3_1) * (s1_1738_0 + s1_1738_1);
    gl64_t kB1738 = (tmp3_0 + tmp3_2) * (s1_1738_0 + s1_1738_2);
    gl64_t kC1738 = (tmp3_1 + tmp3_2) * (s1_1738_1 + s1_1738_2);
    gl64_t kD1738 = tmp3_0 * s1_1738_0;
    gl64_t kE1738 = tmp3_1 * s1_1738_1;
    gl64_t kF1738 = tmp3_2 * s1_1738_2;
    gl64_t kG1738 = kD1738 - kE1738;
    tmp3_0 = (kC1738 + kG1738) - kF1738;
    tmp3_1 = ((((kA1738 + kC1738) - kE1738) - kE1738) - kD1738);
    tmp3_2 = kB1738 - kG1738;
    // Op 1739: dim3x1 add
    gl64_t s1_1739 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1739; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1740: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1741: dim3x3 mul
    gl64_t s1_1741_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1741_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1741_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1741 = (tmp3_0 + tmp3_1) * (s1_1741_0 + s1_1741_1);
    gl64_t kB1741 = (tmp3_0 + tmp3_2) * (s1_1741_0 + s1_1741_2);
    gl64_t kC1741 = (tmp3_1 + tmp3_2) * (s1_1741_1 + s1_1741_2);
    gl64_t kD1741 = tmp3_0 * s1_1741_0;
    gl64_t kE1741 = tmp3_1 * s1_1741_1;
    gl64_t kF1741 = tmp3_2 * s1_1741_2;
    gl64_t kG1741 = kD1741 - kE1741;
    tmp3_6 = (kC1741 + kG1741) - kF1741;
    tmp3_7 = ((((kA1741 + kC1741) - kE1741) - kE1741) - kD1741);
    tmp3_8 = kB1741 - kG1741;
    // Op 1742: dim3x1 mul
    gl64_t s0_1742_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1742_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1742_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1742 = *(gl64_t*)&expressions_params[10][63];
    tmp3_0 = s0_1742_0 * s1_1742; tmp3_1 = s0_1742_1 * s1_1742; tmp3_2 = s0_1742_2 * s1_1742;
    // Op 1743: dim3x1 add
    gl64_t s1_1743 = *(gl64_t*)&expressions_params[10][62];
    tmp3_0 = tmp3_0 + s1_1743; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1744: dim3x3 mul
    gl64_t s1_1744_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1744_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1744_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1744 = (tmp3_0 + tmp3_1) * (s1_1744_0 + s1_1744_1);
    gl64_t kB1744 = (tmp3_0 + tmp3_2) * (s1_1744_0 + s1_1744_2);
    gl64_t kC1744 = (tmp3_1 + tmp3_2) * (s1_1744_1 + s1_1744_2);
    gl64_t kD1744 = tmp3_0 * s1_1744_0;
    gl64_t kE1744 = tmp3_1 * s1_1744_1;
    gl64_t kF1744 = tmp3_2 * s1_1744_2;
    gl64_t kG1744 = kD1744 - kE1744;
    tmp3_0 = (kC1744 + kG1744) - kF1744;
    tmp3_1 = ((((kA1744 + kC1744) - kE1744) - kE1744) - kD1744);
    tmp3_2 = kB1744 - kG1744;
    // Op 1745: dim3x1 add
    gl64_t s1_1745 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1745; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1746: dim3x3 mul
    gl64_t s1_1746_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1746_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1746_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1746 = (tmp3_0 + tmp3_1) * (s1_1746_0 + s1_1746_1);
    gl64_t kB1746 = (tmp3_0 + tmp3_2) * (s1_1746_0 + s1_1746_2);
    gl64_t kC1746 = (tmp3_1 + tmp3_2) * (s1_1746_1 + s1_1746_2);
    gl64_t kD1746 = tmp3_0 * s1_1746_0;
    gl64_t kE1746 = tmp3_1 * s1_1746_1;
    gl64_t kF1746 = tmp3_2 * s1_1746_2;
    gl64_t kG1746 = kD1746 - kE1746;
    tmp3_0 = (kC1746 + kG1746) - kF1746;
    tmp3_1 = ((((kA1746 + kC1746) - kE1746) - kE1746) - kD1746);
    tmp3_2 = kB1746 - kG1746;
    // Op 1747: dim3x1 add
    gl64_t s1_1747 = *(gl64_t*)&expressions_params[10][97];
    tmp3_0 = tmp3_0 + s1_1747; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1748: dim3x3 mul
    gl64_t s1_1748_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1748_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1748_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1748 = (tmp3_0 + tmp3_1) * (s1_1748_0 + s1_1748_1);
    gl64_t kB1748 = (tmp3_0 + tmp3_2) * (s1_1748_0 + s1_1748_2);
    gl64_t kC1748 = (tmp3_1 + tmp3_2) * (s1_1748_1 + s1_1748_2);
    gl64_t kD1748 = tmp3_0 * s1_1748_0;
    gl64_t kE1748 = tmp3_1 * s1_1748_1;
    gl64_t kF1748 = tmp3_2 * s1_1748_2;
    gl64_t kG1748 = kD1748 - kE1748;
    tmp3_0 = (kC1748 + kG1748) - kF1748;
    tmp3_1 = ((((kA1748 + kC1748) - kE1748) - kE1748) - kD1748);
    tmp3_2 = kB1748 - kG1748;
    // Op 1749: dim3x1 add
    gl64_t s1_1749 = *(gl64_t*)&expressions_params[9][44];
    tmp3_0 = tmp3_0 + s1_1749; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1750: dim3x3 mul
    gl64_t s1_1750_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1750_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1750_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1750 = (tmp3_0 + tmp3_1) * (s1_1750_0 + s1_1750_1);
    gl64_t kB1750 = (tmp3_0 + tmp3_2) * (s1_1750_0 + s1_1750_2);
    gl64_t kC1750 = (tmp3_1 + tmp3_2) * (s1_1750_1 + s1_1750_2);
    gl64_t kD1750 = tmp3_0 * s1_1750_0;
    gl64_t kE1750 = tmp3_1 * s1_1750_1;
    gl64_t kF1750 = tmp3_2 * s1_1750_2;
    gl64_t kG1750 = kD1750 - kE1750;
    tmp3_0 = (kC1750 + kG1750) - kF1750;
    tmp3_1 = ((((kA1750 + kC1750) - kE1750) - kE1750) - kD1750);
    tmp3_2 = kB1750 - kG1750;
    // Op 1751: dim3x1 add
    gl64_t s1_1751 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1751; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1752: dim3x3 mul
    gl64_t s1_1752_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1752_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1752_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1753: dim3x1 add
    gl64_t s1_1753 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1753; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1754: dim3x3 add
    gl64_t s1_1754_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1754_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1754_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1754_0; tmp3_1 = tmp3_1 + s1_1754_1; tmp3_2 = tmp3_2 + s1_1754_2;
    // Op 1755: dim3x3 mul
    gl64_t s1_1755_0 = *(gl64_t*)&expressions_params[10][353];
    gl64_t s1_1755_1 = *(gl64_t*)&expressions_params[10][353+1];
    gl64_t s1_1755_2 = *(gl64_t*)&expressions_params[10][353+2];
    gl64_t kA1755 = (tmp3_0 + tmp3_1) * (s1_1755_0 + s1_1755_1);
    gl64_t kB1755 = (tmp3_0 + tmp3_2) * (s1_1755_0 + s1_1755_2);
    gl64_t kC1755 = (tmp3_1 + tmp3_2) * (s1_1755_1 + s1_1755_2);
    gl64_t kD1755 = tmp3_0 * s1_1755_0;
    gl64_t kE1755 = tmp3_1 * s1_1755_1;
    gl64_t kF1755 = tmp3_2 * s1_1755_2;
    gl64_t kG1755 = kD1755 - kE1755;
    tmp3_0 = (kC1755 + kG1755) - kF1755;
    tmp3_1 = ((((kA1755 + kC1755) - kE1755) - kE1755) - kD1755);
    tmp3_2 = kB1755 - kG1755;
    // Op 1756: dim3x1 sub
    gl64_t s1_1756 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1756; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1757: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1758: dim3x3 mul
    gl64_t s1_1758_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1758_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1758_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1758 = (tmp3_0 + tmp3_1) * (s1_1758_0 + s1_1758_1);
    gl64_t kB1758 = (tmp3_0 + tmp3_2) * (s1_1758_0 + s1_1758_2);
    gl64_t kC1758 = (tmp3_1 + tmp3_2) * (s1_1758_1 + s1_1758_2);
    gl64_t kD1758 = tmp3_0 * s1_1758_0;
    gl64_t kE1758 = tmp3_1 * s1_1758_1;
    gl64_t kF1758 = tmp3_2 * s1_1758_2;
    gl64_t kG1758 = kD1758 - kE1758;
    tmp3_6 = (kC1758 + kG1758) - kF1758;
    tmp3_7 = ((((kA1758 + kC1758) - kE1758) - kE1758) - kD1758);
    tmp3_8 = kB1758 - kG1758;
    // Op 1759: dim3x1 mul
    gl64_t s0_1759_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1759_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1759_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1759 = *(gl64_t*)&expressions_params[10][63];
    tmp3_0 = s0_1759_0 * s1_1759; tmp3_1 = s0_1759_1 * s1_1759; tmp3_2 = s0_1759_2 * s1_1759;
    // Op 1760: dim3x1 add
    gl64_t s1_1760 = *(gl64_t*)&expressions_params[10][62];
    tmp3_0 = tmp3_0 + s1_1760; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1761: dim3x3 mul
    gl64_t s1_1761_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1761_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1761_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1761 = (tmp3_0 + tmp3_1) * (s1_1761_0 + s1_1761_1);
    gl64_t kB1761 = (tmp3_0 + tmp3_2) * (s1_1761_0 + s1_1761_2);
    gl64_t kC1761 = (tmp3_1 + tmp3_2) * (s1_1761_1 + s1_1761_2);
    gl64_t kD1761 = tmp3_0 * s1_1761_0;
    gl64_t kE1761 = tmp3_1 * s1_1761_1;
    gl64_t kF1761 = tmp3_2 * s1_1761_2;
    gl64_t kG1761 = kD1761 - kE1761;
    tmp3_0 = (kC1761 + kG1761) - kF1761;
    tmp3_1 = ((((kA1761 + kC1761) - kE1761) - kE1761) - kD1761);
    tmp3_2 = kB1761 - kG1761;
    // Op 1762: dim3x1 add
    gl64_t s1_1762 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1762; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1763: dim3x3 mul
    gl64_t s1_1763_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1763_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1763_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1763 = (tmp3_0 + tmp3_1) * (s1_1763_0 + s1_1763_1);
    gl64_t kB1763 = (tmp3_0 + tmp3_2) * (s1_1763_0 + s1_1763_2);
    gl64_t kC1763 = (tmp3_1 + tmp3_2) * (s1_1763_1 + s1_1763_2);
    gl64_t kD1763 = tmp3_0 * s1_1763_0;
    gl64_t kE1763 = tmp3_1 * s1_1763_1;
    gl64_t kF1763 = tmp3_2 * s1_1763_2;
    gl64_t kG1763 = kD1763 - kE1763;
    tmp3_0 = (kC1763 + kG1763) - kF1763;
    tmp3_1 = ((((kA1763 + kC1763) - kE1763) - kE1763) - kD1763);
    tmp3_2 = kB1763 - kG1763;
    // Op 1764: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1765: dim3x3 mul
    gl64_t s1_1765_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1765_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1765_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1765 = (tmp3_0 + tmp3_1) * (s1_1765_0 + s1_1765_1);
    gl64_t kB1765 = (tmp3_0 + tmp3_2) * (s1_1765_0 + s1_1765_2);
    gl64_t kC1765 = (tmp3_1 + tmp3_2) * (s1_1765_1 + s1_1765_2);
    gl64_t kD1765 = tmp3_0 * s1_1765_0;
    gl64_t kE1765 = tmp3_1 * s1_1765_1;
    gl64_t kF1765 = tmp3_2 * s1_1765_2;
    gl64_t kG1765 = kD1765 - kE1765;
    tmp3_0 = (kC1765 + kG1765) - kF1765;
    tmp3_1 = ((((kA1765 + kC1765) - kE1765) - kE1765) - kD1765);
    tmp3_2 = kB1765 - kG1765;
    // Op 1766: dim3x1 add
    gl64_t s1_1766 = *(gl64_t*)&expressions_params[9][44];
    tmp3_0 = tmp3_0 + s1_1766; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1767: dim3x3 mul
    gl64_t s1_1767_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1767_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1767_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1767 = (tmp3_0 + tmp3_1) * (s1_1767_0 + s1_1767_1);
    gl64_t kB1767 = (tmp3_0 + tmp3_2) * (s1_1767_0 + s1_1767_2);
    gl64_t kC1767 = (tmp3_1 + tmp3_2) * (s1_1767_1 + s1_1767_2);
    gl64_t kD1767 = tmp3_0 * s1_1767_0;
    gl64_t kE1767 = tmp3_1 * s1_1767_1;
    gl64_t kF1767 = tmp3_2 * s1_1767_2;
    gl64_t kG1767 = kD1767 - kE1767;
    tmp3_0 = (kC1767 + kG1767) - kF1767;
    tmp3_1 = ((((kA1767 + kC1767) - kE1767) - kE1767) - kD1767);
    tmp3_2 = kB1767 - kG1767;
    // Op 1768: dim3x1 add
    gl64_t s1_1768 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1768; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1769: dim3x3 mul
    gl64_t s1_1769_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1769_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1769_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1770: dim3x1 add
    gl64_t s1_1770 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1770; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1771: dim3x3 add
    gl64_t s1_1771_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1771_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1771_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1771_0; tmp3_1 = tmp3_1 + s1_1771_1; tmp3_2 = tmp3_2 + s1_1771_2;
    // Op 1772: dim3x3 mul
    gl64_t s1_1772_0 = *(gl64_t*)&expressions_params[10][356];
    gl64_t s1_1772_1 = *(gl64_t*)&expressions_params[10][356+1];
    gl64_t s1_1772_2 = *(gl64_t*)&expressions_params[10][356+2];
    gl64_t kA1772 = (tmp3_0 + tmp3_1) * (s1_1772_0 + s1_1772_1);
    gl64_t kB1772 = (tmp3_0 + tmp3_2) * (s1_1772_0 + s1_1772_2);
    gl64_t kC1772 = (tmp3_1 + tmp3_2) * (s1_1772_1 + s1_1772_2);
    gl64_t kD1772 = tmp3_0 * s1_1772_0;
    gl64_t kE1772 = tmp3_1 * s1_1772_1;
    gl64_t kF1772 = tmp3_2 * s1_1772_2;
    gl64_t kG1772 = kD1772 - kE1772;
    tmp3_0 = (kC1772 + kG1772) - kF1772;
    tmp3_1 = ((((kA1772 + kC1772) - kE1772) - kE1772) - kD1772);
    tmp3_2 = kB1772 - kG1772;
    // Op 1773: dim1x1 sub
    gl64_t s0_1773 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1773 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1773 - s1_1773;
    // Op 1774: dim1x1 sub_swap
    gl64_t s1_1774 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1774 - tmp1_0;
    // Op 1775: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1776: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1777: dim3x3 mul
    gl64_t s1_1777_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1777_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1777_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1777 = (tmp3_0 + tmp3_1) * (s1_1777_0 + s1_1777_1);
    gl64_t kB1777 = (tmp3_0 + tmp3_2) * (s1_1777_0 + s1_1777_2);
    gl64_t kC1777 = (tmp3_1 + tmp3_2) * (s1_1777_1 + s1_1777_2);
    gl64_t kD1777 = tmp3_0 * s1_1777_0;
    gl64_t kE1777 = tmp3_1 * s1_1777_1;
    gl64_t kF1777 = tmp3_2 * s1_1777_2;
    gl64_t kG1777 = kD1777 - kE1777;
    tmp3_6 = (kC1777 + kG1777) - kF1777;
    tmp3_7 = ((((kA1777 + kC1777) - kE1777) - kE1777) - kD1777);
    tmp3_8 = kB1777 - kG1777;
    // Op 1778: dim1x1 sub
    gl64_t s1_1778 = *(gl64_t*)&expressions_params[10][98];
    tmp1_0 = tmp1_4 - s1_1778;
    // Op 1779: dim1x1 sub
    gl64_t s1_1779 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1779;
    // Op 1780: dim3x1 mul
    gl64_t s0_1780_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1780_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1780_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1780_0 * tmp1_0; tmp3_1 = s0_1780_1 * tmp1_0; tmp3_2 = s0_1780_2 * tmp1_0;
    // Op 1781: dim3x1 add
    gl64_t s1_1781 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1781; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1782: dim3x3 add
    gl64_t s1_1782_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1782_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1782_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1782_0; tmp3_1 = tmp3_1 + s1_1782_1; tmp3_2 = tmp3_2 + s1_1782_2;
    // Op 1783: dim3x3 mul
    gl64_t s1_1783_0 = *(gl64_t*)&expressions_params[10][359];
    gl64_t s1_1783_1 = *(gl64_t*)&expressions_params[10][359+1];
    gl64_t s1_1783_2 = *(gl64_t*)&expressions_params[10][359+2];
    gl64_t kA1783 = (tmp3_0 + tmp3_1) * (s1_1783_0 + s1_1783_1);
    gl64_t kB1783 = (tmp3_0 + tmp3_2) * (s1_1783_0 + s1_1783_2);
    gl64_t kC1783 = (tmp3_1 + tmp3_2) * (s1_1783_1 + s1_1783_2);
    gl64_t kD1783 = tmp3_0 * s1_1783_0;
    gl64_t kE1783 = tmp3_1 * s1_1783_1;
    gl64_t kF1783 = tmp3_2 * s1_1783_2;
    gl64_t kG1783 = kD1783 - kE1783;
    tmp3_0 = (kC1783 + kG1783) - kF1783;
    tmp3_1 = ((((kA1783 + kC1783) - kE1783) - kE1783) - kD1783);
    tmp3_2 = kB1783 - kG1783;
    // Op 1784: dim3x1 add
    gl64_t s1_1784 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1784; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1785: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1786: dim3x3 mul
    gl64_t s1_1786_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1786_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1786_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1786 = (tmp3_0 + tmp3_1) * (s1_1786_0 + s1_1786_1);
    gl64_t kB1786 = (tmp3_0 + tmp3_2) * (s1_1786_0 + s1_1786_2);
    gl64_t kC1786 = (tmp3_1 + tmp3_2) * (s1_1786_1 + s1_1786_2);
    gl64_t kD1786 = tmp3_0 * s1_1786_0;
    gl64_t kE1786 = tmp3_1 * s1_1786_1;
    gl64_t kF1786 = tmp3_2 * s1_1786_2;
    gl64_t kG1786 = kD1786 - kE1786;
    tmp3_6 = (kC1786 + kG1786) - kF1786;
    tmp3_7 = ((((kA1786 + kC1786) - kE1786) - kE1786) - kD1786);
    tmp3_8 = kB1786 - kG1786;
    // Op 1787: dim3x1 mul
    gl64_t s0_1787_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1787_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1787_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1787 = *(gl64_t*)&expressions_params[10][65];
    tmp3_0 = s0_1787_0 * s1_1787; tmp3_1 = s0_1787_1 * s1_1787; tmp3_2 = s0_1787_2 * s1_1787;
    // Op 1788: dim3x1 add
    gl64_t s1_1788 = *(gl64_t*)&expressions_params[10][64];
    tmp3_0 = tmp3_0 + s1_1788; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1789: dim3x3 mul
    gl64_t s1_1789_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1789_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1789_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1789 = (tmp3_0 + tmp3_1) * (s1_1789_0 + s1_1789_1);
    gl64_t kB1789 = (tmp3_0 + tmp3_2) * (s1_1789_0 + s1_1789_2);
    gl64_t kC1789 = (tmp3_1 + tmp3_2) * (s1_1789_1 + s1_1789_2);
    gl64_t kD1789 = tmp3_0 * s1_1789_0;
    gl64_t kE1789 = tmp3_1 * s1_1789_1;
    gl64_t kF1789 = tmp3_2 * s1_1789_2;
    gl64_t kG1789 = kD1789 - kE1789;
    tmp3_0 = (kC1789 + kG1789) - kF1789;
    tmp3_1 = ((((kA1789 + kC1789) - kE1789) - kE1789) - kD1789);
    tmp3_2 = kB1789 - kG1789;
    // Op 1790: dim3x1 add
    gl64_t s1_1790 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1790; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1791: dim3x3 mul
    gl64_t s1_1791_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1791_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1791_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1791 = (tmp3_0 + tmp3_1) * (s1_1791_0 + s1_1791_1);
    gl64_t kB1791 = (tmp3_0 + tmp3_2) * (s1_1791_0 + s1_1791_2);
    gl64_t kC1791 = (tmp3_1 + tmp3_2) * (s1_1791_1 + s1_1791_2);
    gl64_t kD1791 = tmp3_0 * s1_1791_0;
    gl64_t kE1791 = tmp3_1 * s1_1791_1;
    gl64_t kF1791 = tmp3_2 * s1_1791_2;
    gl64_t kG1791 = kD1791 - kE1791;
    tmp3_0 = (kC1791 + kG1791) - kF1791;
    tmp3_1 = ((((kA1791 + kC1791) - kE1791) - kE1791) - kD1791);
    tmp3_2 = kB1791 - kG1791;
    // Op 1792: dim3x1 add
    gl64_t s1_1792 = *(gl64_t*)&expressions_params[10][98];
    tmp3_0 = tmp3_0 + s1_1792; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1793: dim3x3 mul
    gl64_t s1_1793_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1793_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1793_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1793 = (tmp3_0 + tmp3_1) * (s1_1793_0 + s1_1793_1);
    gl64_t kB1793 = (tmp3_0 + tmp3_2) * (s1_1793_0 + s1_1793_2);
    gl64_t kC1793 = (tmp3_1 + tmp3_2) * (s1_1793_1 + s1_1793_2);
    gl64_t kD1793 = tmp3_0 * s1_1793_0;
    gl64_t kE1793 = tmp3_1 * s1_1793_1;
    gl64_t kF1793 = tmp3_2 * s1_1793_2;
    gl64_t kG1793 = kD1793 - kE1793;
    tmp3_0 = (kC1793 + kG1793) - kF1793;
    tmp3_1 = ((((kA1793 + kC1793) - kE1793) - kE1793) - kD1793);
    tmp3_2 = kB1793 - kG1793;
    // Op 1794: dim3x1 add
    gl64_t s1_1794 = *(gl64_t*)&expressions_params[9][45];
    tmp3_0 = tmp3_0 + s1_1794; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1795: dim3x3 mul
    gl64_t s1_1795_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1795_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1795_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1795 = (tmp3_0 + tmp3_1) * (s1_1795_0 + s1_1795_1);
    gl64_t kB1795 = (tmp3_0 + tmp3_2) * (s1_1795_0 + s1_1795_2);
    gl64_t kC1795 = (tmp3_1 + tmp3_2) * (s1_1795_1 + s1_1795_2);
    gl64_t kD1795 = tmp3_0 * s1_1795_0;
    gl64_t kE1795 = tmp3_1 * s1_1795_1;
    gl64_t kF1795 = tmp3_2 * s1_1795_2;
    gl64_t kG1795 = kD1795 - kE1795;
    tmp3_0 = (kC1795 + kG1795) - kF1795;
    tmp3_1 = ((((kA1795 + kC1795) - kE1795) - kE1795) - kD1795);
    tmp3_2 = kB1795 - kG1795;
    // Op 1796: dim3x1 add
    gl64_t s1_1796 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1796; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1797: dim3x3 mul
    gl64_t s1_1797_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1797_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1797_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1798: dim3x1 add
    gl64_t s1_1798 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1798; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1799: dim3x3 add
    gl64_t s1_1799_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1799_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1799_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1799_0; tmp3_1 = tmp3_1 + s1_1799_1; tmp3_2 = tmp3_2 + s1_1799_2;
    // Op 1800: dim3x3 mul
    gl64_t s1_1800_0 = *(gl64_t*)&expressions_params[10][362];
    gl64_t s1_1800_1 = *(gl64_t*)&expressions_params[10][362+1];
    gl64_t s1_1800_2 = *(gl64_t*)&expressions_params[10][362+2];
    gl64_t kA1800 = (tmp3_0 + tmp3_1) * (s1_1800_0 + s1_1800_1);
    gl64_t kB1800 = (tmp3_0 + tmp3_2) * (s1_1800_0 + s1_1800_2);
    gl64_t kC1800 = (tmp3_1 + tmp3_2) * (s1_1800_1 + s1_1800_2);
    gl64_t kD1800 = tmp3_0 * s1_1800_0;
    gl64_t kE1800 = tmp3_1 * s1_1800_1;
    gl64_t kF1800 = tmp3_2 * s1_1800_2;
    gl64_t kG1800 = kD1800 - kE1800;
    tmp3_0 = (kC1800 + kG1800) - kF1800;
    tmp3_1 = ((((kA1800 + kC1800) - kE1800) - kE1800) - kD1800);
    tmp3_2 = kB1800 - kG1800;
    // Op 1801: dim3x1 sub
    gl64_t s1_1801 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1801; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1802: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1803: dim3x3 mul
    gl64_t s1_1803_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1803_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1803_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1803 = (tmp3_0 + tmp3_1) * (s1_1803_0 + s1_1803_1);
    gl64_t kB1803 = (tmp3_0 + tmp3_2) * (s1_1803_0 + s1_1803_2);
    gl64_t kC1803 = (tmp3_1 + tmp3_2) * (s1_1803_1 + s1_1803_2);
    gl64_t kD1803 = tmp3_0 * s1_1803_0;
    gl64_t kE1803 = tmp3_1 * s1_1803_1;
    gl64_t kF1803 = tmp3_2 * s1_1803_2;
    gl64_t kG1803 = kD1803 - kE1803;
    tmp3_6 = (kC1803 + kG1803) - kF1803;
    tmp3_7 = ((((kA1803 + kC1803) - kE1803) - kE1803) - kD1803);
    tmp3_8 = kB1803 - kG1803;
    // Op 1804: dim3x1 mul
    gl64_t s0_1804_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1804_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1804_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1804 = *(gl64_t*)&expressions_params[10][65];
    tmp3_0 = s0_1804_0 * s1_1804; tmp3_1 = s0_1804_1 * s1_1804; tmp3_2 = s0_1804_2 * s1_1804;
    // Op 1805: dim3x1 add
    gl64_t s1_1805 = *(gl64_t*)&expressions_params[10][64];
    tmp3_0 = tmp3_0 + s1_1805; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1806: dim3x3 mul
    gl64_t s1_1806_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1806_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1806_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1806 = (tmp3_0 + tmp3_1) * (s1_1806_0 + s1_1806_1);
    gl64_t kB1806 = (tmp3_0 + tmp3_2) * (s1_1806_0 + s1_1806_2);
    gl64_t kC1806 = (tmp3_1 + tmp3_2) * (s1_1806_1 + s1_1806_2);
    gl64_t kD1806 = tmp3_0 * s1_1806_0;
    gl64_t kE1806 = tmp3_1 * s1_1806_1;
    gl64_t kF1806 = tmp3_2 * s1_1806_2;
    gl64_t kG1806 = kD1806 - kE1806;
    tmp3_0 = (kC1806 + kG1806) - kF1806;
    tmp3_1 = ((((kA1806 + kC1806) - kE1806) - kE1806) - kD1806);
    tmp3_2 = kB1806 - kG1806;
    // Op 1807: dim3x1 add
    gl64_t s1_1807 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1807; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1808: dim3x3 mul
    gl64_t s1_1808_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1808_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1808_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1808 = (tmp3_0 + tmp3_1) * (s1_1808_0 + s1_1808_1);
    gl64_t kB1808 = (tmp3_0 + tmp3_2) * (s1_1808_0 + s1_1808_2);
    gl64_t kC1808 = (tmp3_1 + tmp3_2) * (s1_1808_1 + s1_1808_2);
    gl64_t kD1808 = tmp3_0 * s1_1808_0;
    gl64_t kE1808 = tmp3_1 * s1_1808_1;
    gl64_t kF1808 = tmp3_2 * s1_1808_2;
    gl64_t kG1808 = kD1808 - kE1808;
    tmp3_0 = (kC1808 + kG1808) - kF1808;
    tmp3_1 = ((((kA1808 + kC1808) - kE1808) - kE1808) - kD1808);
    tmp3_2 = kB1808 - kG1808;
    // Op 1809: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1810: dim3x3 mul
    gl64_t s1_1810_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1810_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1810_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1810 = (tmp3_0 + tmp3_1) * (s1_1810_0 + s1_1810_1);
    gl64_t kB1810 = (tmp3_0 + tmp3_2) * (s1_1810_0 + s1_1810_2);
    gl64_t kC1810 = (tmp3_1 + tmp3_2) * (s1_1810_1 + s1_1810_2);
    gl64_t kD1810 = tmp3_0 * s1_1810_0;
    gl64_t kE1810 = tmp3_1 * s1_1810_1;
    gl64_t kF1810 = tmp3_2 * s1_1810_2;
    gl64_t kG1810 = kD1810 - kE1810;
    tmp3_0 = (kC1810 + kG1810) - kF1810;
    tmp3_1 = ((((kA1810 + kC1810) - kE1810) - kE1810) - kD1810);
    tmp3_2 = kB1810 - kG1810;
    // Op 1811: dim3x1 add
    gl64_t s1_1811 = *(gl64_t*)&expressions_params[9][45];
    tmp3_0 = tmp3_0 + s1_1811; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1812: dim3x3 mul
    gl64_t s1_1812_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1812_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1812_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1812 = (tmp3_0 + tmp3_1) * (s1_1812_0 + s1_1812_1);
    gl64_t kB1812 = (tmp3_0 + tmp3_2) * (s1_1812_0 + s1_1812_2);
    gl64_t kC1812 = (tmp3_1 + tmp3_2) * (s1_1812_1 + s1_1812_2);
    gl64_t kD1812 = tmp3_0 * s1_1812_0;
    gl64_t kE1812 = tmp3_1 * s1_1812_1;
    gl64_t kF1812 = tmp3_2 * s1_1812_2;
    gl64_t kG1812 = kD1812 - kE1812;
    tmp3_0 = (kC1812 + kG1812) - kF1812;
    tmp3_1 = ((((kA1812 + kC1812) - kE1812) - kE1812) - kD1812);
    tmp3_2 = kB1812 - kG1812;
    // Op 1813: dim3x1 add
    gl64_t s1_1813 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1813; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1814: dim3x3 mul
    gl64_t s1_1814_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1814_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1814_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1815: dim3x1 add
    gl64_t s1_1815 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1815; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1816: dim3x3 add
    gl64_t s1_1816_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1816_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1816_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1816_0; tmp3_1 = tmp3_1 + s1_1816_1; tmp3_2 = tmp3_2 + s1_1816_2;
    // Op 1817: dim3x3 mul
    gl64_t s1_1817_0 = *(gl64_t*)&expressions_params[10][365];
    gl64_t s1_1817_1 = *(gl64_t*)&expressions_params[10][365+1];
    gl64_t s1_1817_2 = *(gl64_t*)&expressions_params[10][365+2];
    gl64_t kA1817 = (tmp3_0 + tmp3_1) * (s1_1817_0 + s1_1817_1);
    gl64_t kB1817 = (tmp3_0 + tmp3_2) * (s1_1817_0 + s1_1817_2);
    gl64_t kC1817 = (tmp3_1 + tmp3_2) * (s1_1817_1 + s1_1817_2);
    gl64_t kD1817 = tmp3_0 * s1_1817_0;
    gl64_t kE1817 = tmp3_1 * s1_1817_1;
    gl64_t kF1817 = tmp3_2 * s1_1817_2;
    gl64_t kG1817 = kD1817 - kE1817;
    tmp3_0 = (kC1817 + kG1817) - kF1817;
    tmp3_1 = ((((kA1817 + kC1817) - kE1817) - kE1817) - kD1817);
    tmp3_2 = kB1817 - kG1817;
    // Op 1818: dim1x1 sub
    gl64_t s0_1818 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1818 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1818 - s1_1818;
    // Op 1819: dim1x1 sub_swap
    gl64_t s1_1819 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1819 - tmp1_0;
    // Op 1820: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1821: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1822: dim3x3 mul
    gl64_t s1_1822_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1822_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1822_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1822 = (tmp3_0 + tmp3_1) * (s1_1822_0 + s1_1822_1);
    gl64_t kB1822 = (tmp3_0 + tmp3_2) * (s1_1822_0 + s1_1822_2);
    gl64_t kC1822 = (tmp3_1 + tmp3_2) * (s1_1822_1 + s1_1822_2);
    gl64_t kD1822 = tmp3_0 * s1_1822_0;
    gl64_t kE1822 = tmp3_1 * s1_1822_1;
    gl64_t kF1822 = tmp3_2 * s1_1822_2;
    gl64_t kG1822 = kD1822 - kE1822;
    tmp3_6 = (kC1822 + kG1822) - kF1822;
    tmp3_7 = ((((kA1822 + kC1822) - kE1822) - kE1822) - kD1822);
    tmp3_8 = kB1822 - kG1822;
    // Op 1823: dim1x1 sub
    gl64_t s1_1823 = *(gl64_t*)&expressions_params[10][99];
    tmp1_0 = tmp1_4 - s1_1823;
    // Op 1824: dim1x1 sub
    gl64_t s1_1824 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1824;
    // Op 1825: dim3x1 mul
    gl64_t s0_1825_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1825_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1825_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1825_0 * tmp1_0; tmp3_1 = s0_1825_1 * tmp1_0; tmp3_2 = s0_1825_2 * tmp1_0;
    // Op 1826: dim3x1 add
    gl64_t s1_1826 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1826; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1827: dim3x3 add
    gl64_t s1_1827_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1827_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1827_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1827_0; tmp3_1 = tmp3_1 + s1_1827_1; tmp3_2 = tmp3_2 + s1_1827_2;
    // Op 1828: dim3x3 mul
    gl64_t s1_1828_0 = *(gl64_t*)&expressions_params[10][368];
    gl64_t s1_1828_1 = *(gl64_t*)&expressions_params[10][368+1];
    gl64_t s1_1828_2 = *(gl64_t*)&expressions_params[10][368+2];
    gl64_t kA1828 = (tmp3_0 + tmp3_1) * (s1_1828_0 + s1_1828_1);
    gl64_t kB1828 = (tmp3_0 + tmp3_2) * (s1_1828_0 + s1_1828_2);
    gl64_t kC1828 = (tmp3_1 + tmp3_2) * (s1_1828_1 + s1_1828_2);
    gl64_t kD1828 = tmp3_0 * s1_1828_0;
    gl64_t kE1828 = tmp3_1 * s1_1828_1;
    gl64_t kF1828 = tmp3_2 * s1_1828_2;
    gl64_t kG1828 = kD1828 - kE1828;
    tmp3_0 = (kC1828 + kG1828) - kF1828;
    tmp3_1 = ((((kA1828 + kC1828) - kE1828) - kE1828) - kD1828);
    tmp3_2 = kB1828 - kG1828;
    // Op 1829: dim3x1 add
    gl64_t s1_1829 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1829; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1830: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1831: dim3x3 mul
    gl64_t s1_1831_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1831_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1831_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1831 = (tmp3_0 + tmp3_1) * (s1_1831_0 + s1_1831_1);
    gl64_t kB1831 = (tmp3_0 + tmp3_2) * (s1_1831_0 + s1_1831_2);
    gl64_t kC1831 = (tmp3_1 + tmp3_2) * (s1_1831_1 + s1_1831_2);
    gl64_t kD1831 = tmp3_0 * s1_1831_0;
    gl64_t kE1831 = tmp3_1 * s1_1831_1;
    gl64_t kF1831 = tmp3_2 * s1_1831_2;
    gl64_t kG1831 = kD1831 - kE1831;
    tmp3_6 = (kC1831 + kG1831) - kF1831;
    tmp3_7 = ((((kA1831 + kC1831) - kE1831) - kE1831) - kD1831);
    tmp3_8 = kB1831 - kG1831;
    // Op 1832: dim3x1 mul
    gl64_t s0_1832_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1832_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1832_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1832 = *(gl64_t*)&expressions_params[10][67];
    tmp3_0 = s0_1832_0 * s1_1832; tmp3_1 = s0_1832_1 * s1_1832; tmp3_2 = s0_1832_2 * s1_1832;
    // Op 1833: dim3x1 add
    gl64_t s1_1833 = *(gl64_t*)&expressions_params[10][66];
    tmp3_0 = tmp3_0 + s1_1833; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1834: dim3x3 mul
    gl64_t s1_1834_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1834_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1834_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1834 = (tmp3_0 + tmp3_1) * (s1_1834_0 + s1_1834_1);
    gl64_t kB1834 = (tmp3_0 + tmp3_2) * (s1_1834_0 + s1_1834_2);
    gl64_t kC1834 = (tmp3_1 + tmp3_2) * (s1_1834_1 + s1_1834_2);
    gl64_t kD1834 = tmp3_0 * s1_1834_0;
    gl64_t kE1834 = tmp3_1 * s1_1834_1;
    gl64_t kF1834 = tmp3_2 * s1_1834_2;
    gl64_t kG1834 = kD1834 - kE1834;
    tmp3_0 = (kC1834 + kG1834) - kF1834;
    tmp3_1 = ((((kA1834 + kC1834) - kE1834) - kE1834) - kD1834);
    tmp3_2 = kB1834 - kG1834;
    // Op 1835: dim3x1 add
    gl64_t s1_1835 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1835; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1836: dim3x3 mul
    gl64_t s1_1836_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1836_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1836_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1836 = (tmp3_0 + tmp3_1) * (s1_1836_0 + s1_1836_1);
    gl64_t kB1836 = (tmp3_0 + tmp3_2) * (s1_1836_0 + s1_1836_2);
    gl64_t kC1836 = (tmp3_1 + tmp3_2) * (s1_1836_1 + s1_1836_2);
    gl64_t kD1836 = tmp3_0 * s1_1836_0;
    gl64_t kE1836 = tmp3_1 * s1_1836_1;
    gl64_t kF1836 = tmp3_2 * s1_1836_2;
    gl64_t kG1836 = kD1836 - kE1836;
    tmp3_0 = (kC1836 + kG1836) - kF1836;
    tmp3_1 = ((((kA1836 + kC1836) - kE1836) - kE1836) - kD1836);
    tmp3_2 = kB1836 - kG1836;
    // Op 1837: dim3x1 add
    gl64_t s1_1837 = *(gl64_t*)&expressions_params[10][99];
    tmp3_0 = tmp3_0 + s1_1837; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1838: dim3x3 mul
    gl64_t s1_1838_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1838_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1838_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1838 = (tmp3_0 + tmp3_1) * (s1_1838_0 + s1_1838_1);
    gl64_t kB1838 = (tmp3_0 + tmp3_2) * (s1_1838_0 + s1_1838_2);
    gl64_t kC1838 = (tmp3_1 + tmp3_2) * (s1_1838_1 + s1_1838_2);
    gl64_t kD1838 = tmp3_0 * s1_1838_0;
    gl64_t kE1838 = tmp3_1 * s1_1838_1;
    gl64_t kF1838 = tmp3_2 * s1_1838_2;
    gl64_t kG1838 = kD1838 - kE1838;
    tmp3_0 = (kC1838 + kG1838) - kF1838;
    tmp3_1 = ((((kA1838 + kC1838) - kE1838) - kE1838) - kD1838);
    tmp3_2 = kB1838 - kG1838;
    // Op 1839: dim3x1 add
    gl64_t s1_1839 = *(gl64_t*)&expressions_params[9][46];
    tmp3_0 = tmp3_0 + s1_1839; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1840: dim3x3 mul
    gl64_t s1_1840_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1840_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1840_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1840 = (tmp3_0 + tmp3_1) * (s1_1840_0 + s1_1840_1);
    gl64_t kB1840 = (tmp3_0 + tmp3_2) * (s1_1840_0 + s1_1840_2);
    gl64_t kC1840 = (tmp3_1 + tmp3_2) * (s1_1840_1 + s1_1840_2);
    gl64_t kD1840 = tmp3_0 * s1_1840_0;
    gl64_t kE1840 = tmp3_1 * s1_1840_1;
    gl64_t kF1840 = tmp3_2 * s1_1840_2;
    gl64_t kG1840 = kD1840 - kE1840;
    tmp3_0 = (kC1840 + kG1840) - kF1840;
    tmp3_1 = ((((kA1840 + kC1840) - kE1840) - kE1840) - kD1840);
    tmp3_2 = kB1840 - kG1840;
    // Op 1841: dim3x1 add
    gl64_t s1_1841 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1841; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1842: dim3x3 mul
    gl64_t s1_1842_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1842_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1842_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1843: dim3x1 add
    gl64_t s1_1843 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1843; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1844: dim3x3 add
    gl64_t s1_1844_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1844_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1844_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1844_0; tmp3_1 = tmp3_1 + s1_1844_1; tmp3_2 = tmp3_2 + s1_1844_2;
    // Op 1845: dim3x3 mul
    gl64_t s1_1845_0 = *(gl64_t*)&expressions_params[10][371];
    gl64_t s1_1845_1 = *(gl64_t*)&expressions_params[10][371+1];
    gl64_t s1_1845_2 = *(gl64_t*)&expressions_params[10][371+2];
    gl64_t kA1845 = (tmp3_0 + tmp3_1) * (s1_1845_0 + s1_1845_1);
    gl64_t kB1845 = (tmp3_0 + tmp3_2) * (s1_1845_0 + s1_1845_2);
    gl64_t kC1845 = (tmp3_1 + tmp3_2) * (s1_1845_1 + s1_1845_2);
    gl64_t kD1845 = tmp3_0 * s1_1845_0;
    gl64_t kE1845 = tmp3_1 * s1_1845_1;
    gl64_t kF1845 = tmp3_2 * s1_1845_2;
    gl64_t kG1845 = kD1845 - kE1845;
    tmp3_0 = (kC1845 + kG1845) - kF1845;
    tmp3_1 = ((((kA1845 + kC1845) - kE1845) - kE1845) - kD1845);
    tmp3_2 = kB1845 - kG1845;
    // Op 1846: dim3x1 sub
    gl64_t s1_1846 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1846; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1847: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1848: dim3x3 mul
    gl64_t s1_1848_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1848_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1848_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1848 = (tmp3_0 + tmp3_1) * (s1_1848_0 + s1_1848_1);
    gl64_t kB1848 = (tmp3_0 + tmp3_2) * (s1_1848_0 + s1_1848_2);
    gl64_t kC1848 = (tmp3_1 + tmp3_2) * (s1_1848_1 + s1_1848_2);
    gl64_t kD1848 = tmp3_0 * s1_1848_0;
    gl64_t kE1848 = tmp3_1 * s1_1848_1;
    gl64_t kF1848 = tmp3_2 * s1_1848_2;
    gl64_t kG1848 = kD1848 - kE1848;
    tmp3_6 = (kC1848 + kG1848) - kF1848;
    tmp3_7 = ((((kA1848 + kC1848) - kE1848) - kE1848) - kD1848);
    tmp3_8 = kB1848 - kG1848;
    // Op 1849: dim3x1 mul
    gl64_t s0_1849_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1849_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1849_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1849 = *(gl64_t*)&expressions_params[10][67];
    tmp3_0 = s0_1849_0 * s1_1849; tmp3_1 = s0_1849_1 * s1_1849; tmp3_2 = s0_1849_2 * s1_1849;
    // Op 1850: dim3x1 add
    gl64_t s1_1850 = *(gl64_t*)&expressions_params[10][66];
    tmp3_0 = tmp3_0 + s1_1850; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1851: dim3x3 mul
    gl64_t s1_1851_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1851_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1851_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1851 = (tmp3_0 + tmp3_1) * (s1_1851_0 + s1_1851_1);
    gl64_t kB1851 = (tmp3_0 + tmp3_2) * (s1_1851_0 + s1_1851_2);
    gl64_t kC1851 = (tmp3_1 + tmp3_2) * (s1_1851_1 + s1_1851_2);
    gl64_t kD1851 = tmp3_0 * s1_1851_0;
    gl64_t kE1851 = tmp3_1 * s1_1851_1;
    gl64_t kF1851 = tmp3_2 * s1_1851_2;
    gl64_t kG1851 = kD1851 - kE1851;
    tmp3_0 = (kC1851 + kG1851) - kF1851;
    tmp3_1 = ((((kA1851 + kC1851) - kE1851) - kE1851) - kD1851);
    tmp3_2 = kB1851 - kG1851;
    // Op 1852: dim3x1 add
    gl64_t s1_1852 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1852; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1853: dim3x3 mul
    gl64_t s1_1853_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1853_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1853_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1853 = (tmp3_0 + tmp3_1) * (s1_1853_0 + s1_1853_1);
    gl64_t kB1853 = (tmp3_0 + tmp3_2) * (s1_1853_0 + s1_1853_2);
    gl64_t kC1853 = (tmp3_1 + tmp3_2) * (s1_1853_1 + s1_1853_2);
    gl64_t kD1853 = tmp3_0 * s1_1853_0;
    gl64_t kE1853 = tmp3_1 * s1_1853_1;
    gl64_t kF1853 = tmp3_2 * s1_1853_2;
    gl64_t kG1853 = kD1853 - kE1853;
    tmp3_0 = (kC1853 + kG1853) - kF1853;
    tmp3_1 = ((((kA1853 + kC1853) - kE1853) - kE1853) - kD1853);
    tmp3_2 = kB1853 - kG1853;
    // Op 1854: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1855: dim3x3 mul
    gl64_t s1_1855_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1855_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1855_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1855 = (tmp3_0 + tmp3_1) * (s1_1855_0 + s1_1855_1);
    gl64_t kB1855 = (tmp3_0 + tmp3_2) * (s1_1855_0 + s1_1855_2);
    gl64_t kC1855 = (tmp3_1 + tmp3_2) * (s1_1855_1 + s1_1855_2);
    gl64_t kD1855 = tmp3_0 * s1_1855_0;
    gl64_t kE1855 = tmp3_1 * s1_1855_1;
    gl64_t kF1855 = tmp3_2 * s1_1855_2;
    gl64_t kG1855 = kD1855 - kE1855;
    tmp3_0 = (kC1855 + kG1855) - kF1855;
    tmp3_1 = ((((kA1855 + kC1855) - kE1855) - kE1855) - kD1855);
    tmp3_2 = kB1855 - kG1855;
    // Op 1856: dim3x1 add
    gl64_t s1_1856 = *(gl64_t*)&expressions_params[9][46];
    tmp3_0 = tmp3_0 + s1_1856; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1857: dim3x3 mul
    gl64_t s1_1857_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1857_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1857_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1857 = (tmp3_0 + tmp3_1) * (s1_1857_0 + s1_1857_1);
    gl64_t kB1857 = (tmp3_0 + tmp3_2) * (s1_1857_0 + s1_1857_2);
    gl64_t kC1857 = (tmp3_1 + tmp3_2) * (s1_1857_1 + s1_1857_2);
    gl64_t kD1857 = tmp3_0 * s1_1857_0;
    gl64_t kE1857 = tmp3_1 * s1_1857_1;
    gl64_t kF1857 = tmp3_2 * s1_1857_2;
    gl64_t kG1857 = kD1857 - kE1857;
    tmp3_0 = (kC1857 + kG1857) - kF1857;
    tmp3_1 = ((((kA1857 + kC1857) - kE1857) - kE1857) - kD1857);
    tmp3_2 = kB1857 - kG1857;
    // Op 1858: dim3x1 add
    gl64_t s1_1858 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1858; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1859: dim3x3 mul
    gl64_t s1_1859_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1859_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1859_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1860: dim3x1 add
    gl64_t s1_1860 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1860; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1861: dim3x3 add
    gl64_t s1_1861_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1861_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1861_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1861_0; tmp3_1 = tmp3_1 + s1_1861_1; tmp3_2 = tmp3_2 + s1_1861_2;
    // Op 1862: dim3x3 mul
    gl64_t s1_1862_0 = *(gl64_t*)&expressions_params[10][374];
    gl64_t s1_1862_1 = *(gl64_t*)&expressions_params[10][374+1];
    gl64_t s1_1862_2 = *(gl64_t*)&expressions_params[10][374+2];
    gl64_t kA1862 = (tmp3_0 + tmp3_1) * (s1_1862_0 + s1_1862_1);
    gl64_t kB1862 = (tmp3_0 + tmp3_2) * (s1_1862_0 + s1_1862_2);
    gl64_t kC1862 = (tmp3_1 + tmp3_2) * (s1_1862_1 + s1_1862_2);
    gl64_t kD1862 = tmp3_0 * s1_1862_0;
    gl64_t kE1862 = tmp3_1 * s1_1862_1;
    gl64_t kF1862 = tmp3_2 * s1_1862_2;
    gl64_t kG1862 = kD1862 - kE1862;
    tmp3_0 = (kC1862 + kG1862) - kF1862;
    tmp3_1 = ((((kA1862 + kC1862) - kE1862) - kE1862) - kD1862);
    tmp3_2 = kB1862 - kG1862;
    // Op 1863: dim1x1 sub
    gl64_t s0_1863 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1863 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_1863 - s1_1863;
    // Op 1864: dim1x1 sub_swap
    gl64_t s1_1864 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_1864 - tmp1_0;
    // Op 1865: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1866: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1867: dim3x3 mul
    gl64_t s1_1867_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1867_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1867_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1867 = (tmp3_0 + tmp3_1) * (s1_1867_0 + s1_1867_1);
    gl64_t kB1867 = (tmp3_0 + tmp3_2) * (s1_1867_0 + s1_1867_2);
    gl64_t kC1867 = (tmp3_1 + tmp3_2) * (s1_1867_1 + s1_1867_2);
    gl64_t kD1867 = tmp3_0 * s1_1867_0;
    gl64_t kE1867 = tmp3_1 * s1_1867_1;
    gl64_t kF1867 = tmp3_2 * s1_1867_2;
    gl64_t kG1867 = kD1867 - kE1867;
    tmp3_6 = (kC1867 + kG1867) - kF1867;
    tmp3_7 = ((((kA1867 + kC1867) - kE1867) - kE1867) - kD1867);
    tmp3_8 = kB1867 - kG1867;
    // Op 1868: dim1x1 sub
    gl64_t s1_1868 = *(gl64_t*)&expressions_params[10][100];
    tmp1_0 = tmp1_4 - s1_1868;
    // Op 1869: dim1x1 sub
    gl64_t s1_1869 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_1869;
    // Op 1870: dim3x1 mul
    gl64_t s0_1870_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1870_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1870_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_1870_0 * tmp1_0; tmp3_1 = s0_1870_1 * tmp1_0; tmp3_2 = s0_1870_2 * tmp1_0;
    // Op 1871: dim3x1 add
    gl64_t s1_1871 = *(gl64_t*)&expressions_params[9][7];
    tmp3_0 = tmp3_0 + s1_1871; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1872: dim3x3 add
    gl64_t s1_1872_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1872_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1872_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1872_0; tmp3_1 = tmp3_1 + s1_1872_1; tmp3_2 = tmp3_2 + s1_1872_2;
    // Op 1873: dim3x3 mul
    gl64_t s1_1873_0 = *(gl64_t*)&expressions_params[10][377];
    gl64_t s1_1873_1 = *(gl64_t*)&expressions_params[10][377+1];
    gl64_t s1_1873_2 = *(gl64_t*)&expressions_params[10][377+2];
    gl64_t kA1873 = (tmp3_0 + tmp3_1) * (s1_1873_0 + s1_1873_1);
    gl64_t kB1873 = (tmp3_0 + tmp3_2) * (s1_1873_0 + s1_1873_2);
    gl64_t kC1873 = (tmp3_1 + tmp3_2) * (s1_1873_1 + s1_1873_2);
    gl64_t kD1873 = tmp3_0 * s1_1873_0;
    gl64_t kE1873 = tmp3_1 * s1_1873_1;
    gl64_t kF1873 = tmp3_2 * s1_1873_2;
    gl64_t kG1873 = kD1873 - kE1873;
    tmp3_0 = (kC1873 + kG1873) - kF1873;
    tmp3_1 = ((((kA1873 + kC1873) - kE1873) - kE1873) - kD1873);
    tmp3_2 = kB1873 - kG1873;
    // Op 1874: dim3x1 add
    gl64_t s1_1874 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1874; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1875: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1876: dim3x3 mul
    gl64_t s1_1876_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1876_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1876_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1876 = (tmp3_0 + tmp3_1) * (s1_1876_0 + s1_1876_1);
    gl64_t kB1876 = (tmp3_0 + tmp3_2) * (s1_1876_0 + s1_1876_2);
    gl64_t kC1876 = (tmp3_1 + tmp3_2) * (s1_1876_1 + s1_1876_2);
    gl64_t kD1876 = tmp3_0 * s1_1876_0;
    gl64_t kE1876 = tmp3_1 * s1_1876_1;
    gl64_t kF1876 = tmp3_2 * s1_1876_2;
    gl64_t kG1876 = kD1876 - kE1876;
    tmp3_6 = (kC1876 + kG1876) - kF1876;
    tmp3_7 = ((((kA1876 + kC1876) - kE1876) - kE1876) - kD1876);
    tmp3_8 = kB1876 - kG1876;
    // Op 1877: dim3x1 mul
    gl64_t s0_1877_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1877_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1877_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1877 = *(gl64_t*)&expressions_params[10][69];
    tmp3_0 = s0_1877_0 * s1_1877; tmp3_1 = s0_1877_1 * s1_1877; tmp3_2 = s0_1877_2 * s1_1877;
    // Op 1878: dim3x1 add
    gl64_t s1_1878 = *(gl64_t*)&expressions_params[10][68];
    tmp3_0 = tmp3_0 + s1_1878; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1879: dim3x3 mul
    gl64_t s1_1879_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1879_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1879_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1879 = (tmp3_0 + tmp3_1) * (s1_1879_0 + s1_1879_1);
    gl64_t kB1879 = (tmp3_0 + tmp3_2) * (s1_1879_0 + s1_1879_2);
    gl64_t kC1879 = (tmp3_1 + tmp3_2) * (s1_1879_1 + s1_1879_2);
    gl64_t kD1879 = tmp3_0 * s1_1879_0;
    gl64_t kE1879 = tmp3_1 * s1_1879_1;
    gl64_t kF1879 = tmp3_2 * s1_1879_2;
    gl64_t kG1879 = kD1879 - kE1879;
    tmp3_0 = (kC1879 + kG1879) - kF1879;
    tmp3_1 = ((((kA1879 + kC1879) - kE1879) - kE1879) - kD1879);
    tmp3_2 = kB1879 - kG1879;
    // Op 1880: dim3x1 add
    gl64_t s1_1880 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1880; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1881: dim3x3 mul
    gl64_t s1_1881_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1881_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1881_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1881 = (tmp3_0 + tmp3_1) * (s1_1881_0 + s1_1881_1);
    gl64_t kB1881 = (tmp3_0 + tmp3_2) * (s1_1881_0 + s1_1881_2);
    gl64_t kC1881 = (tmp3_1 + tmp3_2) * (s1_1881_1 + s1_1881_2);
    gl64_t kD1881 = tmp3_0 * s1_1881_0;
    gl64_t kE1881 = tmp3_1 * s1_1881_1;
    gl64_t kF1881 = tmp3_2 * s1_1881_2;
    gl64_t kG1881 = kD1881 - kE1881;
    tmp3_0 = (kC1881 + kG1881) - kF1881;
    tmp3_1 = ((((kA1881 + kC1881) - kE1881) - kE1881) - kD1881);
    tmp3_2 = kB1881 - kG1881;
    // Op 1882: dim3x1 add
    gl64_t s1_1882 = *(gl64_t*)&expressions_params[10][100];
    tmp3_0 = tmp3_0 + s1_1882; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1883: dim3x3 mul
    gl64_t s1_1883_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1883_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1883_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1883 = (tmp3_0 + tmp3_1) * (s1_1883_0 + s1_1883_1);
    gl64_t kB1883 = (tmp3_0 + tmp3_2) * (s1_1883_0 + s1_1883_2);
    gl64_t kC1883 = (tmp3_1 + tmp3_2) * (s1_1883_1 + s1_1883_2);
    gl64_t kD1883 = tmp3_0 * s1_1883_0;
    gl64_t kE1883 = tmp3_1 * s1_1883_1;
    gl64_t kF1883 = tmp3_2 * s1_1883_2;
    gl64_t kG1883 = kD1883 - kE1883;
    tmp3_0 = (kC1883 + kG1883) - kF1883;
    tmp3_1 = ((((kA1883 + kC1883) - kE1883) - kE1883) - kD1883);
    tmp3_2 = kB1883 - kG1883;
    // Op 1884: dim3x1 add
    gl64_t s1_1884 = *(gl64_t*)&expressions_params[9][47];
    tmp3_0 = tmp3_0 + s1_1884; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1885: dim3x3 mul
    gl64_t s1_1885_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1885_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1885_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1885 = (tmp3_0 + tmp3_1) * (s1_1885_0 + s1_1885_1);
    gl64_t kB1885 = (tmp3_0 + tmp3_2) * (s1_1885_0 + s1_1885_2);
    gl64_t kC1885 = (tmp3_1 + tmp3_2) * (s1_1885_1 + s1_1885_2);
    gl64_t kD1885 = tmp3_0 * s1_1885_0;
    gl64_t kE1885 = tmp3_1 * s1_1885_1;
    gl64_t kF1885 = tmp3_2 * s1_1885_2;
    gl64_t kG1885 = kD1885 - kE1885;
    tmp3_0 = (kC1885 + kG1885) - kF1885;
    tmp3_1 = ((((kA1885 + kC1885) - kE1885) - kE1885) - kD1885);
    tmp3_2 = kB1885 - kG1885;
    // Op 1886: dim3x1 add
    gl64_t s1_1886 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1886; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1887: dim3x3 mul
    gl64_t s1_1887_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1887_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1887_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1888: dim3x1 add
    gl64_t s1_1888 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1888; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1889: dim3x3 add
    gl64_t s1_1889_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1889_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1889_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1889_0; tmp3_1 = tmp3_1 + s1_1889_1; tmp3_2 = tmp3_2 + s1_1889_2;
    // Op 1890: dim3x3 mul
    gl64_t s1_1890_0 = *(gl64_t*)&expressions_params[10][380];
    gl64_t s1_1890_1 = *(gl64_t*)&expressions_params[10][380+1];
    gl64_t s1_1890_2 = *(gl64_t*)&expressions_params[10][380+2];
    gl64_t kA1890 = (tmp3_0 + tmp3_1) * (s1_1890_0 + s1_1890_1);
    gl64_t kB1890 = (tmp3_0 + tmp3_2) * (s1_1890_0 + s1_1890_2);
    gl64_t kC1890 = (tmp3_1 + tmp3_2) * (s1_1890_1 + s1_1890_2);
    gl64_t kD1890 = tmp3_0 * s1_1890_0;
    gl64_t kE1890 = tmp3_1 * s1_1890_1;
    gl64_t kF1890 = tmp3_2 * s1_1890_2;
    gl64_t kG1890 = kD1890 - kE1890;
    tmp3_0 = (kC1890 + kG1890) - kF1890;
    tmp3_1 = ((((kA1890 + kC1890) - kE1890) - kE1890) - kD1890);
    tmp3_2 = kB1890 - kG1890;
    // Op 1891: dim3x1 sub
    gl64_t s1_1891 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 - s1_1891; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1892: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1893: dim3x3 mul
    gl64_t s1_1893_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1893_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1893_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1893 = (tmp3_0 + tmp3_1) * (s1_1893_0 + s1_1893_1);
    gl64_t kB1893 = (tmp3_0 + tmp3_2) * (s1_1893_0 + s1_1893_2);
    gl64_t kC1893 = (tmp3_1 + tmp3_2) * (s1_1893_1 + s1_1893_2);
    gl64_t kD1893 = tmp3_0 * s1_1893_0;
    gl64_t kE1893 = tmp3_1 * s1_1893_1;
    gl64_t kF1893 = tmp3_2 * s1_1893_2;
    gl64_t kG1893 = kD1893 - kE1893;
    tmp3_6 = (kC1893 + kG1893) - kF1893;
    tmp3_7 = ((((kA1893 + kC1893) - kE1893) - kE1893) - kD1893);
    tmp3_8 = kB1893 - kG1893;
    // Op 1894: dim3x1 mul
    gl64_t s0_1894_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1894_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1894_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1894 = *(gl64_t*)&expressions_params[10][69];
    tmp3_0 = s0_1894_0 * s1_1894; tmp3_1 = s0_1894_1 * s1_1894; tmp3_2 = s0_1894_2 * s1_1894;
    // Op 1895: dim3x1 add
    gl64_t s1_1895 = *(gl64_t*)&expressions_params[10][68];
    tmp3_0 = tmp3_0 + s1_1895; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1896: dim3x3 mul
    gl64_t s1_1896_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1896_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1896_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1896 = (tmp3_0 + tmp3_1) * (s1_1896_0 + s1_1896_1);
    gl64_t kB1896 = (tmp3_0 + tmp3_2) * (s1_1896_0 + s1_1896_2);
    gl64_t kC1896 = (tmp3_1 + tmp3_2) * (s1_1896_1 + s1_1896_2);
    gl64_t kD1896 = tmp3_0 * s1_1896_0;
    gl64_t kE1896 = tmp3_1 * s1_1896_1;
    gl64_t kF1896 = tmp3_2 * s1_1896_2;
    gl64_t kG1896 = kD1896 - kE1896;
    tmp3_0 = (kC1896 + kG1896) - kF1896;
    tmp3_1 = ((((kA1896 + kC1896) - kE1896) - kE1896) - kD1896);
    tmp3_2 = kB1896 - kG1896;
    // Op 1897: dim3x1 add
    gl64_t s1_1897 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_1897; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1898: dim3x3 mul
    gl64_t s1_1898_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1898_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1898_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1898 = (tmp3_0 + tmp3_1) * (s1_1898_0 + s1_1898_1);
    gl64_t kB1898 = (tmp3_0 + tmp3_2) * (s1_1898_0 + s1_1898_2);
    gl64_t kC1898 = (tmp3_1 + tmp3_2) * (s1_1898_1 + s1_1898_2);
    gl64_t kD1898 = tmp3_0 * s1_1898_0;
    gl64_t kE1898 = tmp3_1 * s1_1898_1;
    gl64_t kF1898 = tmp3_2 * s1_1898_2;
    gl64_t kG1898 = kD1898 - kE1898;
    tmp3_0 = (kC1898 + kG1898) - kF1898;
    tmp3_1 = ((((kA1898 + kC1898) - kE1898) - kE1898) - kD1898);
    tmp3_2 = kB1898 - kG1898;
    // Op 1899: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1900: dim3x3 mul
    gl64_t s1_1900_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1900_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1900_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1900 = (tmp3_0 + tmp3_1) * (s1_1900_0 + s1_1900_1);
    gl64_t kB1900 = (tmp3_0 + tmp3_2) * (s1_1900_0 + s1_1900_2);
    gl64_t kC1900 = (tmp3_1 + tmp3_2) * (s1_1900_1 + s1_1900_2);
    gl64_t kD1900 = tmp3_0 * s1_1900_0;
    gl64_t kE1900 = tmp3_1 * s1_1900_1;
    gl64_t kF1900 = tmp3_2 * s1_1900_2;
    gl64_t kG1900 = kD1900 - kE1900;
    tmp3_0 = (kC1900 + kG1900) - kF1900;
    tmp3_1 = ((((kA1900 + kC1900) - kE1900) - kE1900) - kD1900);
    tmp3_2 = kB1900 - kG1900;
    // Op 1901: dim3x1 add
    gl64_t s1_1901 = *(gl64_t*)&expressions_params[9][47];
    tmp3_0 = tmp3_0 + s1_1901; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1902: dim3x3 mul
    gl64_t s1_1902_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1902_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1902_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA1902 = (tmp3_0 + tmp3_1) * (s1_1902_0 + s1_1902_1);
    gl64_t kB1902 = (tmp3_0 + tmp3_2) * (s1_1902_0 + s1_1902_2);
    gl64_t kC1902 = (tmp3_1 + tmp3_2) * (s1_1902_1 + s1_1902_2);
    gl64_t kD1902 = tmp3_0 * s1_1902_0;
    gl64_t kE1902 = tmp3_1 * s1_1902_1;
    gl64_t kF1902 = tmp3_2 * s1_1902_2;
    gl64_t kG1902 = kD1902 - kE1902;
    tmp3_0 = (kC1902 + kG1902) - kF1902;
    tmp3_1 = ((((kA1902 + kC1902) - kE1902) - kE1902) - kD1902);
    tmp3_2 = kB1902 - kG1902;
    // Op 1903: dim3x1 add
    gl64_t s1_1903 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_1903; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1904: dim3x3 mul
    gl64_t s1_1904_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_1904_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_1904_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 1905: dim3x1 add
    gl64_t s1_1905 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_1905; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1906: dim3x3 add
    gl64_t s1_1906_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1906_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1906_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1906_0; tmp3_1 = tmp3_1 + s1_1906_1; tmp3_2 = tmp3_2 + s1_1906_2;
    // Op 1907: dim3x3 mul
    gl64_t s1_1907_0 = *(gl64_t*)&expressions_params[10][383];
    gl64_t s1_1907_1 = *(gl64_t*)&expressions_params[10][383+1];
    gl64_t s1_1907_2 = *(gl64_t*)&expressions_params[10][383+2];
    gl64_t kA1907 = (tmp3_0 + tmp3_1) * (s1_1907_0 + s1_1907_1);
    gl64_t kB1907 = (tmp3_0 + tmp3_2) * (s1_1907_0 + s1_1907_2);
    gl64_t kC1907 = (tmp3_1 + tmp3_2) * (s1_1907_1 + s1_1907_2);
    gl64_t kD1907 = tmp3_0 * s1_1907_0;
    gl64_t kE1907 = tmp3_1 * s1_1907_1;
    gl64_t kF1907 = tmp3_2 * s1_1907_2;
    gl64_t kG1907 = kD1907 - kE1907;
    tmp3_0 = (kC1907 + kG1907) - kF1907;
    tmp3_1 = ((((kA1907 + kC1907) - kE1907) - kE1907) - kD1907);
    tmp3_2 = kB1907 - kG1907;
    // Op 1908: dim1x1 sub
    gl64_t s0_1908 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_1908 = *(gl64_t*)&expressions_params[10][0];
    tmp1_4 = s0_1908 - s1_1908;
    // Op 1909: dim1x1 sub_swap
    gl64_t s1_1909 = *(gl64_t*)&expressions_params[9][1];
    tmp1_4 = s1_1909 - tmp1_4;
    // Op 1910: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1911: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1912: dim3x3 mul
    gl64_t s1_1912_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1912_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1912_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1912 = (tmp3_0 + tmp3_1) * (s1_1912_0 + s1_1912_1);
    gl64_t kB1912 = (tmp3_0 + tmp3_2) * (s1_1912_0 + s1_1912_2);
    gl64_t kC1912 = (tmp3_1 + tmp3_2) * (s1_1912_1 + s1_1912_2);
    gl64_t kD1912 = tmp3_0 * s1_1912_0;
    gl64_t kE1912 = tmp3_1 * s1_1912_1;
    gl64_t kF1912 = tmp3_2 * s1_1912_2;
    gl64_t kG1912 = kD1912 - kE1912;
    tmp3_6 = (kC1912 + kG1912) - kF1912;
    tmp3_7 = ((((kA1912 + kC1912) - kE1912) - kE1912) - kD1912);
    tmp3_8 = kB1912 - kG1912;
    // Op 1913: dim3x1 mul
    gl64_t s0_1913_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_1913_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_1913_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_1913 = *(gl64_t*)&expressions_params[10][1];
    tmp3_0 = s0_1913_0 * s1_1913; tmp3_1 = s0_1913_1 * s1_1913; tmp3_2 = s0_1913_2 * s1_1913;
    // Op 1914: dim3x1 add
    gl64_t s1_1914 = *(gl64_t*)&expressions_params[9][48];
    tmp3_0 = tmp3_0 + s1_1914; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1915: dim3x3 add
    gl64_t s1_1915_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_1915_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_1915_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_1915_0; tmp3_1 = tmp3_1 + s1_1915_1; tmp3_2 = tmp3_2 + s1_1915_2;
    // Op 1916: dim3x3 mul
    gl64_t s1_1916_0 = *(gl64_t*)&expressions_params[10][386];
    gl64_t s1_1916_1 = *(gl64_t*)&expressions_params[10][386+1];
    gl64_t s1_1916_2 = *(gl64_t*)&expressions_params[10][386+2];
    gl64_t kA1916 = (tmp3_0 + tmp3_1) * (s1_1916_0 + s1_1916_1);
    gl64_t kB1916 = (tmp3_0 + tmp3_2) * (s1_1916_0 + s1_1916_2);
    gl64_t kC1916 = (tmp3_1 + tmp3_2) * (s1_1916_1 + s1_1916_2);
    gl64_t kD1916 = tmp3_0 * s1_1916_0;
    gl64_t kE1916 = tmp3_1 * s1_1916_1;
    gl64_t kF1916 = tmp3_2 * s1_1916_2;
    gl64_t kG1916 = kD1916 - kE1916;
    tmp3_0 = (kC1916 + kG1916) - kF1916;
    tmp3_1 = ((((kA1916 + kC1916) - kE1916) - kE1916) - kD1916);
    tmp3_2 = kB1916 - kG1916;
    // Op 1917: dim3x1 add
    gl64_t s1_1917 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_1917; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1918: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 1919: dim3x3 mul
    gl64_t s1_1919_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1919_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1919_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1919 = (tmp3_0 + tmp3_1) * (s1_1919_0 + s1_1919_1);
    gl64_t kB1919 = (tmp3_0 + tmp3_2) * (s1_1919_0 + s1_1919_2);
    gl64_t kC1919 = (tmp3_1 + tmp3_2) * (s1_1919_1 + s1_1919_2);
    gl64_t kD1919 = tmp3_0 * s1_1919_0;
    gl64_t kE1919 = tmp3_1 * s1_1919_1;
    gl64_t kF1919 = tmp3_2 * s1_1919_2;
    gl64_t kG1919 = kD1919 - kE1919;
    tmp3_12 = (kC1919 + kG1919) - kF1919;
    tmp3_13 = ((((kA1919 + kC1919) - kE1919) - kE1919) - kD1919);
    tmp3_14 = kB1919 - kG1919;
    // Op 1920: dim3x3 sub_swap
    uint64_t s0_1920_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_1920_0 = *(gl64_t*)&dParams->aux_trace[s0_1920_pos];
    gl64_t s0_1920_1 = *(gl64_t*)&dParams->aux_trace[s0_1920_pos + TILE_HEIGHT];
    gl64_t s0_1920_2 = *(gl64_t*)&dParams->aux_trace[s0_1920_pos + 2*TILE_HEIGHT];
    gl64_t s1_1920_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_1920_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_1920_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_6 = s1_1920_0 - s0_1920_0; tmp3_7 = s1_1920_1 - s0_1920_1; tmp3_8 = s1_1920_2 - s0_1920_2;
    // Ops 1921-2015: dim3x3 add chain over contiguous triplets of buffer 10.
    {
        gl64_t *values = (gl64_t*)expressions_params[10];
        tmp3_0 = values[101];
        tmp3_1 = values[102];
        tmp3_2 = values[103];
#pragma unroll 1
        for (int offset = 104; offset <= 386; offset += 3) {
            tmp3_0 = tmp3_0 + values[offset + 0];
            tmp3_1 = tmp3_1 + values[offset + 1];
            tmp3_2 = tmp3_2 + values[offset + 2];
        }
    }
    // Op 2016: dim3x3 sub
    tmp3_0 = tmp3_6 - tmp3_0; tmp3_1 = tmp3_7 - tmp3_1; tmp3_2 = tmp3_8 - tmp3_2;
    // Op 2017: dim3x1 mul
    gl64_t s1_2017 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_2017; tmp3_1 = tmp3_1 * s1_2017; tmp3_2 = tmp3_2 * s1_2017;
    // Op 2018: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 2019: dim3x1 mul
    gl64_t s1_2019 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_2019; tmp3_1 = tmp3_1 * s1_2019; tmp3_2 = tmp3_2 * s1_2019;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
