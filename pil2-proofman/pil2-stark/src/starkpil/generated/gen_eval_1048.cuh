// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: 9066233d  nOps=827 nTemp1=5 nTemp3=5
#define GENERATED_EVAL_NOPS_9066233d 827
#define GENERATED_EVAL_NTEMP1_9066233d 5
#define GENERATED_EVAL_NTEMP3_9066233d 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_9066233d(
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
    gl64_t s0_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    gl64_t s1_0 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s0_0 - s1_0;
    // Op 1: dim1x1 mul
    gl64_t s0_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    tmp1_0 = s0_1 * tmp1_0;
    // Op 2: dim3x1 mul
    gl64_t s0_2_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s0_2_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s0_2_2 = *(gl64_t*)&expressions_params[13][6+2];
    tmp3_0 = s0_2_0 * tmp1_0; tmp3_1 = s0_2_1 * tmp1_0; tmp3_2 = s0_2_2 * tmp1_0;
    // Op 3: dim1x1 sub
    gl64_t s0_3 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    gl64_t s1_3 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s0_3 - s1_3;
    // Op 4: dim1x1 mul
    gl64_t s0_4 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    tmp1_0 = s0_4 * tmp1_0;
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
    gl64_t s0_7 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    gl64_t s1_7 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
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
    gl64_t s0_10 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    gl64_t s1_10 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_10 - s0_10;
    // Op 11: dim1x1 mul
    gl64_t s0_11 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
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
    gl64_t s0_14 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    gl64_t s1_14 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_14 - s0_14;
    // Op 15: dim1x1 mul
    gl64_t s0_15 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
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
    gl64_t s0_18 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    gl64_t s1_18 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_18 - s0_18;
    // Op 19: dim1x1 mul
    gl64_t s0_19 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
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
    // Op 22: dim1x1 mul
    gl64_t s0_22 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_22 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_22 * s1_22;
    // Op 23: dim1x1 sub_swap
    gl64_t s1_23 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_23 - tmp1_0;
    // Op 24: dim1x1 mul
    gl64_t s0_24 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_24 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s0_24 * s1_24;
    // Op 25: dim1x1 sub
    tmp1_1 = tmp1_0 - tmp1_1;
    // Op 26: dim1x1 mul
    gl64_t s0_26 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_26 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = s0_26 * s1_26;
    // Op 27: dim1x1 mul
    gl64_t s0_27 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_27 * tmp1_0;
    // Op 28: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 29: dim1x1 sub
    gl64_t s0_29 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    tmp1_0 = s0_29 - tmp1_0;
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
    gl64_t s0_32 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_32 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_32 * s1_32;
    // Op 33: dim1x1 sub_swap
    gl64_t s1_33 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_33 - tmp1_0;
    // Op 34: dim1x1 mul
    gl64_t s0_34 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = s0_34 * tmp1_0;
    // Op 35: dim1x1 sub
    gl64_t s0_35 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp1_0 = s0_35 - tmp1_0;
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
    // Op 38: dim1x1 mul
    gl64_t s0_38 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_38 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_38 * s1_38;
    // Op 39: dim1x1 sub_swap
    gl64_t s1_39 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_39 - tmp1_0;
    // Op 40: dim1x1 mul
    gl64_t s0_40 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_40 * tmp1_0;
    // Op 41: dim1x1 sub
    gl64_t s0_41 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp1_0 = s0_41 - tmp1_0;
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
    // Op 44: dim1x1 mul
    gl64_t s0_44 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    gl64_t s1_44 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_0 = s0_44 * s1_44;
    // Op 45: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC46 + kG46) - kF46;
    tmp3_1 = ((((kA46 + kC46) - kE46) - kE46) - kD46);
    tmp3_2 = kB46 - kG46;
    // Op 47: dim1x1 mul
    gl64_t s0_47 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    gl64_t s1_47 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_47 * s1_47;
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
    // Op 50: dim1x1 mul
    gl64_t s0_50 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    gl64_t s1_50 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_50 * s1_50;
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
    // Op 53: dim1x1 mul
    gl64_t s0_53 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    gl64_t s1_53 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_53 * s1_53;
    // Op 54: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 55: dim3x3 mul
    gl64_t s1_55_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_55_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_55_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA55 = (tmp3_0 + tmp3_1) * (s1_55_0 + s1_55_1);
    gl64_t kB55 = (tmp3_0 + tmp3_2) * (s1_55_0 + s1_55_2);
    gl64_t kC55 = (tmp3_1 + tmp3_2) * (s1_55_1 + s1_55_2);
    gl64_t kD55 = tmp3_0 * s1_55_0;
    gl64_t kE55 = tmp3_1 * s1_55_1;
    gl64_t kF55 = tmp3_2 * s1_55_2;
    gl64_t kG55 = kD55 - kE55;
    tmp3_0 = (kC55 + kG55) - kF55;
    tmp3_1 = ((((kA55 + kC55) - kE55) - kE55) - kD55);
    tmp3_2 = kB55 - kG55;
    // Op 56: dim1x1 sub
    gl64_t s0_56 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_56 = *(gl64_t*)&expressions_params[9][26];
    tmp1_0 = s0_56 - s1_56;
    // Op 57: dim1x1 mul
    gl64_t s0_57 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    tmp1_0 = s0_57 * tmp1_0;
    // Op 58: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 59: dim3x3 mul
    gl64_t s1_59_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_59_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_59_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA59 = (tmp3_0 + tmp3_1) * (s1_59_0 + s1_59_1);
    gl64_t kB59 = (tmp3_0 + tmp3_2) * (s1_59_0 + s1_59_2);
    gl64_t kC59 = (tmp3_1 + tmp3_2) * (s1_59_1 + s1_59_2);
    gl64_t kD59 = tmp3_0 * s1_59_0;
    gl64_t kE59 = tmp3_1 * s1_59_1;
    gl64_t kF59 = tmp3_2 * s1_59_2;
    gl64_t kG59 = kD59 - kE59;
    tmp3_0 = (kC59 + kG59) - kF59;
    tmp3_1 = ((((kA59 + kC59) - kE59) - kE59) - kD59);
    tmp3_2 = kB59 - kG59;
    // Op 60: dim1x1 sub
    gl64_t s0_60 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_60 = *(gl64_t*)&expressions_params[9][26];
    tmp1_0 = s0_60 - s1_60;
    // Op 61: dim1x1 mul
    gl64_t s0_61 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    tmp1_0 = s0_61 * tmp1_0;
    // Op 62: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 63: dim3x3 mul
    gl64_t s1_63_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_63_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_63_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA63 = (tmp3_0 + tmp3_1) * (s1_63_0 + s1_63_1);
    gl64_t kB63 = (tmp3_0 + tmp3_2) * (s1_63_0 + s1_63_2);
    gl64_t kC63 = (tmp3_1 + tmp3_2) * (s1_63_1 + s1_63_2);
    gl64_t kD63 = tmp3_0 * s1_63_0;
    gl64_t kE63 = tmp3_1 * s1_63_1;
    gl64_t kF63 = tmp3_2 * s1_63_2;
    gl64_t kG63 = kD63 - kE63;
    tmp3_0 = (kC63 + kG63) - kF63;
    tmp3_1 = ((((kA63 + kC63) - kE63) - kE63) - kD63);
    tmp3_2 = kB63 - kG63;
    // Op 64: dim1x1 sub_swap
    gl64_t s0_64 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_64 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_64 - s0_64;
    // Op 65: dim1x1 mul
    gl64_t s1_65 = *(gl64_t*)&expressions_params[9][26];
    tmp1_0 = tmp1_0 * s1_65;
    // Op 66: dim1x1 sub
    gl64_t s0_66 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_66 - tmp1_0;
    // Op 67: dim1x1 mul
    gl64_t s0_67 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    tmp1_0 = s0_67 * tmp1_0;
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
    // Op 70: dim1x1 sub_swap
    gl64_t s0_70 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_70 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_70 - s0_70;
    // Op 71: dim1x1 mul
    gl64_t s1_71 = *(gl64_t*)&expressions_params[9][26];
    tmp1_0 = tmp1_0 * s1_71;
    // Op 72: dim1x1 sub
    gl64_t s0_72 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_72 - tmp1_0;
    // Op 73: dim1x1 mul
    gl64_t s0_73 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    tmp1_0 = s0_73 * tmp1_0;
    // Op 74: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 75: dim3x3 mul
    gl64_t s1_75_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_75_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_75_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 76: dim1x1 sub
    gl64_t s0_76 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_76 = *(gl64_t*)&expressions_params[9][26];
    tmp1_0 = s0_76 - s1_76;
    // Op 77: dim1x1 mul
    gl64_t s0_77 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
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
    // Op 80: dim1x1 sub
    gl64_t s0_80 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_80 = *(gl64_t*)&expressions_params[9][26];
    tmp1_0 = s0_80 - s1_80;
    // Op 81: dim1x1 mul
    gl64_t s0_81 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
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
    tmp3_0 = (kC83 + kG83) - kF83;
    tmp3_1 = ((((kA83 + kC83) - kE83) - kE83) - kD83);
    tmp3_2 = kB83 - kG83;
    // Op 84: dim1x1 sub_swap
    gl64_t s0_84 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_84 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_84 - s0_84;
    // Op 85: dim1x1 mul
    gl64_t s1_85 = *(gl64_t*)&expressions_params[9][26];
    tmp1_0 = tmp1_0 * s1_85;
    // Op 86: dim1x1 sub
    gl64_t s0_86 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_86 - tmp1_0;
    // Op 87: dim1x1 mul
    gl64_t s0_87 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    tmp1_0 = s0_87 * tmp1_0;
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
    // Op 90: dim1x1 sub_swap
    gl64_t s0_90 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_90 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_90 - s0_90;
    // Op 91: dim1x1 mul
    gl64_t s1_91 = *(gl64_t*)&expressions_params[9][26];
    tmp1_0 = tmp1_0 * s1_91;
    // Op 92: dim1x1 sub
    gl64_t s0_92 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_92 - tmp1_0;
    // Op 93: dim1x1 mul
    gl64_t s0_93 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    tmp1_0 = s0_93 * tmp1_0;
    // Op 94: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s0_96 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    gl64_t s1_96 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_0 = s0_96 * s1_96;
    // Op 97: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 99: dim1x1 mul
    gl64_t s0_99 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_99 = *(gl64_t*)&expressions_params[9][27];
    tmp1_0 = s0_99 * s1_99;
    // Op 100: dim1x1 sub
    gl64_t s0_100 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp1_0 = s0_100 - tmp1_0;
    // Op 101: dim1x1 mul
    gl64_t s0_101 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    tmp1_0 = s0_101 * tmp1_0;
    // Op 102: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 103: dim3x3 mul
    gl64_t s1_103_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_103_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_103_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA103 = (tmp3_0 + tmp3_1) * (s1_103_0 + s1_103_1);
    gl64_t kB103 = (tmp3_0 + tmp3_2) * (s1_103_0 + s1_103_2);
    gl64_t kC103 = (tmp3_1 + tmp3_2) * (s1_103_1 + s1_103_2);
    gl64_t kD103 = tmp3_0 * s1_103_0;
    gl64_t kE103 = tmp3_1 * s1_103_1;
    gl64_t kF103 = tmp3_2 * s1_103_2;
    gl64_t kG103 = kD103 - kE103;
    tmp3_0 = (kC103 + kG103) - kF103;
    tmp3_1 = ((((kA103 + kC103) - kE103) - kE103) - kD103);
    tmp3_2 = kB103 - kG103;
    // Op 104: dim1x1 mul
    gl64_t s0_104 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    gl64_t s1_104 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_104 * s1_104;
    // Op 105: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 106: dim3x3 mul
    gl64_t s1_106_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_106_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_106_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 107: dim1x1 sub_swap
    gl64_t s0_107 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_107 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_107 - s0_107;
    // Op 108: dim1x1 mul
    gl64_t s1_108 = *(gl64_t*)&expressions_params[9][27];
    tmp1_0 = tmp1_0 * s1_108;
    // Op 109: dim1x1 sub
    gl64_t s0_109 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp1_0 = s0_109 - tmp1_0;
    // Op 110: dim1x1 mul
    gl64_t s0_110 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
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
    // Op 113: dim1x1 sub
    gl64_t s0_113 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_113 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    tmp1_1 = s0_113 - s1_113;
    // Op 114: dim1x1 add
    gl64_t s0_114 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_114 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_114 + s1_114;
    // Op 115: dim1x1 add
    gl64_t s0_115 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_115 + tmp1_0;
    // Op 116: dim1x1 add
    gl64_t s0_116 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_116 + tmp1_0;
    // Op 117: dim1x1 mul
    gl64_t s0_117 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 38, domainSize, nCols_1))];
    tmp1_0 = s0_117 * tmp1_0;
    // Op 118: dim1x1 sub_swap
    gl64_t s1_118 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_118 - tmp1_0;
    // Op 119: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 120: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC121 + kG121) - kF121;
    tmp3_1 = ((((kA121 + kC121) - kE121) - kE121) - kD121);
    tmp3_2 = kB121 - kG121;
    // Op 122: dim1x1 sub_swap
    gl64_t s0_122 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_122 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_122 - s0_122;
    // Op 123: dim1x1 mul
    gl64_t s0_123 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
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
    gl64_t s0_126 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_126 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_126 - s0_126;
    // Op 127: dim1x1 mul
    gl64_t s0_127 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
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
    gl64_t s0_130 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    gl64_t s1_130 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_130 - s0_130;
    // Op 131: dim1x1 mul
    gl64_t s0_131 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
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
    // Op 134: dim1x1 mul
    gl64_t s0_134 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    gl64_t s1_134 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    tmp1_0 = s0_134 * s1_134;
    // Op 135: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 136: dim3x3 mul
    gl64_t s1_136_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_136_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_136_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA136 = (tmp3_0 + tmp3_1) * (s1_136_0 + s1_136_1);
    gl64_t kB136 = (tmp3_0 + tmp3_2) * (s1_136_0 + s1_136_2);
    gl64_t kC136 = (tmp3_1 + tmp3_2) * (s1_136_1 + s1_136_2);
    gl64_t kD136 = tmp3_0 * s1_136_0;
    gl64_t kE136 = tmp3_1 * s1_136_1;
    gl64_t kF136 = tmp3_2 * s1_136_2;
    gl64_t kG136 = kD136 - kE136;
    tmp3_0 = (kC136 + kG136) - kF136;
    tmp3_1 = ((((kA136 + kC136) - kE136) - kE136) - kD136);
    tmp3_2 = kB136 - kG136;
    // Op 137: dim1x1 mul
    gl64_t s0_137 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    gl64_t s1_137 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    tmp1_0 = s0_137 * s1_137;
    // Op 138: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 139: dim3x3 mul
    gl64_t s1_139_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_139_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_139_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA139 = (tmp3_0 + tmp3_1) * (s1_139_0 + s1_139_1);
    gl64_t kB139 = (tmp3_0 + tmp3_2) * (s1_139_0 + s1_139_2);
    gl64_t kC139 = (tmp3_1 + tmp3_2) * (s1_139_1 + s1_139_2);
    gl64_t kD139 = tmp3_0 * s1_139_0;
    gl64_t kE139 = tmp3_1 * s1_139_1;
    gl64_t kF139 = tmp3_2 * s1_139_2;
    gl64_t kG139 = kD139 - kE139;
    tmp3_0 = (kC139 + kG139) - kF139;
    tmp3_1 = ((((kA139 + kC139) - kE139) - kE139) - kD139);
    tmp3_2 = kB139 - kG139;
    // Op 140: dim1x1 sub_swap
    gl64_t s0_140 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_140 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_140 - s0_140;
    // Op 141: dim1x1 mul
    gl64_t s0_141 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 45, domainSize, nCols_2))];
    tmp1_1 = s0_141 * tmp1_0;
    // Op 142: dim1x1 add
    gl64_t s0_142 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_142 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_142 + s1_142;
    // Op 143: dim1x1 add
    gl64_t s0_143 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_143 + tmp1_0;
    // Op 144: dim1x1 add
    gl64_t s0_144 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_144 + tmp1_0;
    // Op 145: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 146: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC147 + kG147) - kF147;
    tmp3_1 = ((((kA147 + kC147) - kE147) - kE147) - kD147);
    tmp3_2 = kB147 - kG147;
    // Op 148: dim1x1 add
    gl64_t s0_148 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_148 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_0 = s0_148 + s1_148;
    // Op 149: dim1x1 add
    gl64_t s0_149 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_149 + tmp1_0;
    // Op 150: dim1x1 add
    gl64_t s0_150 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_150 + tmp1_0;
    // Op 151: dim1x1 mul
    gl64_t s0_151 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 46, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 46, domainSize, nCols_2))];
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
    // Op 154: dim1x1 mul
    gl64_t s0_154 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_154 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_154 * s1_154;
    // Op 155: dim1x1 mul
    gl64_t s0_155 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_0 = s0_155 * tmp1_0;
    // Op 156: dim1x1 sub_swap
    gl64_t s0_156 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_1 = tmp1_0 - s0_156;
    // Op 157: dim1x1 mul
    gl64_t s0_157 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_157 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_157 * s1_157;
    // Op 158: dim1x1 mul
    gl64_t s0_158 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_0 = s0_158 * tmp1_0;
    // Op 159: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 160: dim1x1 mul
    gl64_t s0_160 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_160 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_1 = s0_160 * s1_160;
    // Op 161: dim1x1 add
    tmp1_1 = tmp1_0 + tmp1_1;
    // Op 162: dim1x1 mul
    gl64_t s0_162 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_162 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_162 * s1_162;
    // Op 163: dim1x1 mul
    gl64_t s0_163 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_0 = s0_163 * tmp1_0;
    // Op 164: dim1x1 sub
    tmp1_0 = tmp1_1 - tmp1_0;
    // Op 165: dim1x1 mul
    gl64_t s0_165 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_165 = *(gl64_t*)&expressions_params[9][19];
    tmp1_1 = s0_165 * s1_165;
    // Op 166: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_1;
    // Op 167: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 168: dim3x3 mul
    gl64_t s1_168_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_168_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_168_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 169: dim1x1 mul
    gl64_t s0_169 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_169 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_169 * s1_169;
    // Op 170: dim1x1 mul
    gl64_t s0_170 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_1 = s0_170 * tmp1_0;
    // Op 171: dim1x1 mul
    gl64_t s0_171 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_171 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_171 * s1_171;
    // Op 172: dim1x1 mul
    gl64_t s0_172 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_172 * tmp1_0;
    // Op 173: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 174: dim1x1 sub_swap
    gl64_t s0_174 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp1_1 = tmp1_0 - s0_174;
    // Op 175: dim1x1 mul
    gl64_t s0_175 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_175 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_175 * s1_175;
    // Op 176: dim1x1 mul
    gl64_t s0_176 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp1_0 = s0_176 * tmp1_0;
    // Op 177: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 178: dim1x1 mul
    gl64_t s0_178 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_178 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_1 = s0_178 * s1_178;
    // Op 179: dim1x1 add
    tmp1_1 = tmp1_0 + tmp1_1;
    // Op 180: dim1x1 mul
    gl64_t s0_180 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_180 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_180 * s1_180;
    // Op 181: dim1x1 mul
    gl64_t s0_181 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_0 = s0_181 * tmp1_0;
    // Op 182: dim1x1 sub
    tmp1_0 = tmp1_1 - tmp1_0;
    // Op 183: dim1x1 add
    gl64_t s0_183 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_183 + tmp1_0;
    // Op 184: dim1x1 mul
    gl64_t s0_184 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_184 = *(gl64_t*)&expressions_params[9][19];
    tmp1_1 = s0_184 * s1_184;
    // Op 185: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_1;
    // Op 186: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC187 + kG187) - kF187;
    tmp3_1 = ((((kA187 + kC187) - kE187) - kE187) - kD187);
    tmp3_2 = kB187 - kG187;
    // Op 188: dim1x1 mul
    gl64_t s0_188 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_188 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_188 * s1_188;
    // Op 189: dim1x1 mul
    gl64_t s0_189 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_1 = s0_189 * tmp1_0;
    // Op 190: dim1x1 mul
    gl64_t s0_190 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_190 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_190 * s1_190;
    // Op 191: dim1x1 mul
    gl64_t s0_191 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_191 * tmp1_0;
    // Op 192: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 193: dim1x1 mul
    gl64_t s0_193 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_193 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_193 * s1_193;
    // Op 194: dim1x1 mul
    gl64_t s0_194 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_194 * tmp1_0;
    // Op 195: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 196: dim1x1 mul
    gl64_t s0_196 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_196 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp1_0 = s0_196 * s1_196;
    // Op 197: dim1x1 mul
    gl64_t s0_197 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_197 * tmp1_0;
    // Op 198: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 199: dim1x1 mul
    gl64_t s0_199 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_199 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp1_0 = s0_199 * s1_199;
    // Op 200: dim1x1 mul
    gl64_t s0_200 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_200 * tmp1_0;
    // Op 201: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 202: dim1x1 sub_swap
    gl64_t s0_202 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_1 = tmp1_0 - s0_202;
    // Op 203: dim1x1 mul
    gl64_t s0_203 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_203 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_203 * s1_203;
    // Op 204: dim1x1 mul
    gl64_t s0_204 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_204 * tmp1_0;
    // Op 205: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 206: dim1x1 mul
    gl64_t s0_206 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_206 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_1 = s0_206 * s1_206;
    // Op 207: dim1x1 add
    tmp1_1 = tmp1_0 + tmp1_1;
    // Op 208: dim1x1 mul
    gl64_t s0_208 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_208 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_208 * s1_208;
    // Op 209: dim1x1 mul
    gl64_t s0_209 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_209 * tmp1_0;
    // Op 210: dim1x1 sub
    tmp1_1 = tmp1_1 - tmp1_0;
    // Op 211: dim1x1 mul
    gl64_t s0_211 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_211 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp1_0 = s0_211 * s1_211;
    // Op 212: dim1x1 mul
    gl64_t s0_212 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_212 * tmp1_0;
    // Op 213: dim1x1 sub
    tmp1_0 = tmp1_1 - tmp1_0;
    // Op 214: dim1x1 mul
    gl64_t s0_214 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_214 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_1 = s0_214 * s1_214;
    // Op 215: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 216: dim1x1 add
    gl64_t s0_216 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_216 + tmp1_0;
    // Op 217: dim1x1 mul
    gl64_t s0_217 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_217 = *(gl64_t*)&expressions_params[9][19];
    tmp1_1 = s0_217 * s1_217;
    // Op 218: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_1;
    // Op 219: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC220 + kG220) - kF220;
    tmp3_1 = ((((kA220 + kC220) - kE220) - kE220) - kD220);
    tmp3_2 = kB220 - kG220;
    // Op 221: dim1x1 mul
    gl64_t s0_221 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_221 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_221 * s1_221;
    // Op 222: dim1x1 mul
    gl64_t s0_222 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_1 = s0_222 * tmp1_0;
    // Op 223: dim1x1 mul
    gl64_t s0_223 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_223 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_223 * s1_223;
    // Op 224: dim1x1 mul
    gl64_t s0_224 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_224 * tmp1_0;
    // Op 225: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 226: dim1x1 mul
    gl64_t s0_226 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_226 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_226 * s1_226;
    // Op 227: dim1x1 mul
    gl64_t s0_227 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_227 * tmp1_0;
    // Op 228: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 229: dim1x1 mul
    gl64_t s0_229 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_229 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_229 * s1_229;
    // Op 230: dim1x1 mul
    gl64_t s0_230 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_230 * tmp1_0;
    // Op 231: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 232: dim1x1 mul
    gl64_t s0_232 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_232 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp1_0 = s0_232 * s1_232;
    // Op 233: dim1x1 mul
    gl64_t s0_233 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_233 * tmp1_0;
    // Op 234: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 235: dim1x1 mul
    gl64_t s0_235 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_235 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp1_0 = s0_235 * s1_235;
    // Op 236: dim1x1 mul
    gl64_t s0_236 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_236 * tmp1_0;
    // Op 237: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 238: dim1x1 sub_swap
    gl64_t s0_238 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp1_1 = tmp1_0 - s0_238;
    // Op 239: dim1x1 mul
    gl64_t s0_239 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_239 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_239 * s1_239;
    // Op 240: dim1x1 mul
    gl64_t s0_240 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp1_0 = s0_240 * tmp1_0;
    // Op 241: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 242: dim1x1 mul
    gl64_t s0_242 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_242 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_1 = s0_242 * s1_242;
    // Op 243: dim1x1 add
    tmp1_1 = tmp1_0 + tmp1_1;
    // Op 244: dim1x1 mul
    gl64_t s0_244 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_244 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_244 * s1_244;
    // Op 245: dim1x1 mul
    gl64_t s0_245 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_245 * tmp1_0;
    // Op 246: dim1x1 sub
    tmp1_0 = tmp1_1 - tmp1_0;
    // Op 247: dim1x1 add
    gl64_t s0_247 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_247 + tmp1_0;
    // Op 248: dim1x1 mul
    gl64_t s0_248 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_248 = *(gl64_t*)&expressions_params[9][19];
    tmp1_1 = s0_248 * s1_248;
    // Op 249: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_1;
    // Op 250: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 251: dim3x3 mul
    gl64_t s1_251_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_251_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_251_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 252: dim1x1 mul
    gl64_t s0_252 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_252 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_252 * s1_252;
    // Op 253: dim1x1 mul
    gl64_t s0_253 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_1 = s0_253 * tmp1_0;
    // Op 254: dim1x1 mul
    gl64_t s0_254 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_254 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_254 * s1_254;
    // Op 255: dim1x1 mul
    gl64_t s0_255 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_255 * tmp1_0;
    // Op 256: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 257: dim1x1 mul
    gl64_t s0_257 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_257 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_257 * s1_257;
    // Op 258: dim1x1 mul
    gl64_t s0_258 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_258 * tmp1_0;
    // Op 259: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 260: dim1x1 mul
    gl64_t s0_260 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_260 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_260 * s1_260;
    // Op 261: dim1x1 mul
    gl64_t s0_261 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_261 * tmp1_0;
    // Op 262: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 263: dim1x1 mul
    gl64_t s0_263 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_263 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp1_0 = s0_263 * s1_263;
    // Op 264: dim1x1 sub_swap
    gl64_t s0_264 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_264 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_264 - s0_264;
    // Op 265: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 266: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 267: dim1x1 mul
    gl64_t s0_267 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_267 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp1_0 = s0_267 * s1_267;
    // Op 268: dim1x1 sub_swap
    gl64_t s0_268 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_268 = *(gl64_t*)&expressions_params[9][1];
    tmp1_2 = s1_268 - s0_268;
    // Op 269: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_2;
    // Op 270: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 271: dim1x1 mul
    gl64_t s0_271 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_271 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_271 * s1_271;
    // Op 272: dim1x1 sub_swap
    gl64_t s0_272 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_272 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_272 - s0_272;
    // Op 273: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 274: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_0;
    // Op 275: dim1x1 sub_swap
    gl64_t s0_275 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_275 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_275 - s0_275;
    // Op 276: dim1x1 mul
    gl64_t s0_276 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_276 * tmp1_0;
    // Op 277: dim1x1 mul
    gl64_t s0_277 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp1_0 = s0_277 * tmp1_0;
    // Op 278: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_0;
    // Op 279: dim1x1 sub_swap
    gl64_t s0_279 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_279 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_279 - s0_279;
    // Op 280: dim1x1 mul
    gl64_t s0_280 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_0 = s0_280 * tmp1_0;
    // Op 281: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_0;
    // Op 282: dim1x1 sub_swap
    gl64_t s0_282 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_282 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_282 - s0_282;
    // Op 283: dim1x1 mul
    gl64_t s0_283 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_0 = s0_283 * tmp1_0;
    // Op 284: dim1x1 sub
    tmp1_1 = tmp1_2 - tmp1_0;
    // Op 285: dim1x1 mul
    gl64_t s0_285 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_285 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_285 * s1_285;
    // Op 286: dim1x1 mul
    gl64_t s0_286 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_0 = s0_286 * tmp1_0;
    // Op 287: dim1x1 sub_swap
    gl64_t s0_287 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_287 = *(gl64_t*)&expressions_params[9][1];
    tmp1_2 = s1_287 - s0_287;
    // Op 288: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_2;
    // Op 289: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 290: dim1x1 add
    gl64_t s0_290 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_290 + tmp1_0;
    // Op 291: dim1x1 mul
    gl64_t s0_291 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_291 = *(gl64_t*)&expressions_params[9][19];
    tmp1_1 = s0_291 * s1_291;
    // Op 292: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_1;
    // Op 293: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 294: dim3x3 mul
    gl64_t s1_294_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_294_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_294_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA294 = (tmp3_0 + tmp3_1) * (s1_294_0 + s1_294_1);
    gl64_t kB294 = (tmp3_0 + tmp3_2) * (s1_294_0 + s1_294_2);
    gl64_t kC294 = (tmp3_1 + tmp3_2) * (s1_294_1 + s1_294_2);
    gl64_t kD294 = tmp3_0 * s1_294_0;
    gl64_t kE294 = tmp3_1 * s1_294_1;
    gl64_t kF294 = tmp3_2 * s1_294_2;
    gl64_t kG294 = kD294 - kE294;
    tmp3_0 = (kC294 + kG294) - kF294;
    tmp3_1 = ((((kA294 + kC294) - kE294) - kE294) - kD294);
    tmp3_2 = kB294 - kG294;
    // Op 295: dim1x1 mul
    gl64_t s0_295 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_295 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_295 * s1_295;
    // Op 296: dim1x1 mul
    gl64_t s0_296 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_1 = s0_296 * tmp1_0;
    // Op 297: dim1x1 mul
    gl64_t s0_297 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_297 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_297 * s1_297;
    // Op 298: dim1x1 mul
    gl64_t s0_298 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_298 * tmp1_0;
    // Op 299: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 300: dim1x1 mul
    gl64_t s0_300 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_300 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp1_0 = s0_300 * s1_300;
    // Op 301: dim1x1 sub_swap
    gl64_t s0_301 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_301 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_301 - s0_301;
    // Op 302: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 303: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 304: dim1x1 mul
    gl64_t s0_304 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_304 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp1_0 = s0_304 * s1_304;
    // Op 305: dim1x1 sub_swap
    gl64_t s0_305 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_305 = *(gl64_t*)&expressions_params[9][1];
    tmp1_2 = s1_305 - s0_305;
    // Op 306: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_2;
    // Op 307: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 308: dim1x1 sub_swap
    gl64_t s0_308 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_308 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_308 - s0_308;
    // Op 309: dim1x1 mul
    gl64_t s0_309 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_0 = s0_309 * tmp1_0;
    // Op 310: dim1x1 sub
    tmp1_2 = tmp1_1 - tmp1_0;
    // Op 311: dim1x1 mul
    gl64_t s0_311 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_311 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_311 * s1_311;
    // Op 312: dim1x1 mul
    gl64_t s0_312 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_312 * tmp1_0;
    // Op 313: dim1x1 sub_swap
    gl64_t s0_313 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_313 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_313 - s0_313;
    // Op 314: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 315: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 316: dim1x1 add
    gl64_t s0_316 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_316 + tmp1_0;
    // Op 317: dim1x1 mul
    gl64_t s0_317 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_317 = *(gl64_t*)&expressions_params[9][19];
    tmp1_2 = s0_317 * s1_317;
    // Op 318: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_2;
    // Op 319: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 320: dim3x3 mul
    gl64_t s1_320_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_320_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_320_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA320 = (tmp3_0 + tmp3_1) * (s1_320_0 + s1_320_1);
    gl64_t kB320 = (tmp3_0 + tmp3_2) * (s1_320_0 + s1_320_2);
    gl64_t kC320 = (tmp3_1 + tmp3_2) * (s1_320_1 + s1_320_2);
    gl64_t kD320 = tmp3_0 * s1_320_0;
    gl64_t kE320 = tmp3_1 * s1_320_1;
    gl64_t kF320 = tmp3_2 * s1_320_2;
    gl64_t kG320 = kD320 - kE320;
    tmp3_0 = (kC320 + kG320) - kF320;
    tmp3_1 = ((((kA320 + kC320) - kE320) - kE320) - kD320);
    tmp3_2 = kB320 - kG320;
    // Op 321: dim1x1 mul
    gl64_t s0_321 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_321 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_321 * s1_321;
    // Op 322: dim1x1 mul
    gl64_t s0_322 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_1 = s0_322 * tmp1_0;
    // Op 323: dim1x1 mul
    gl64_t s0_323 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_323 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp1_0 = s0_323 * s1_323;
    // Op 324: dim1x1 sub_swap
    gl64_t s0_324 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_324 = *(gl64_t*)&expressions_params[9][1];
    tmp1_2 = s1_324 - s0_324;
    // Op 325: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_2;
    // Op 326: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 327: dim1x1 mul
    gl64_t s0_327 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_327 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp1_0 = s0_327 * s1_327;
    // Op 328: dim1x1 sub_swap
    gl64_t s0_328 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_328 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_328 - s0_328;
    // Op 329: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 330: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_0;
    // Op 331: dim1x1 sub_swap
    gl64_t s0_331 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_331 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_331 - s0_331;
    // Op 332: dim1x1 mul
    gl64_t s0_332 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_332 * tmp1_0;
    // Op 333: dim1x1 sub
    tmp1_1 = tmp1_2 - tmp1_0;
    // Op 334: dim1x1 mul
    gl64_t s0_334 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_334 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_334 * s1_334;
    // Op 335: dim1x1 mul
    gl64_t s0_335 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_335 * tmp1_0;
    // Op 336: dim1x1 sub_swap
    gl64_t s0_336 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_336 = *(gl64_t*)&expressions_params[9][1];
    tmp1_2 = s1_336 - s0_336;
    // Op 337: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_2;
    // Op 338: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 339: dim1x1 add
    gl64_t s0_339 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_339 + tmp1_0;
    // Op 340: dim1x1 mul
    gl64_t s0_340 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_340 = *(gl64_t*)&expressions_params[9][19];
    tmp1_1 = s0_340 * s1_340;
    // Op 341: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_1;
    // Op 342: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 343: dim3x3 mul
    gl64_t s1_343_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_343_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_343_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 344: dim1x1 mul
    gl64_t s0_344 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_344 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_344 * s1_344;
    // Op 345: dim1x1 mul
    gl64_t s0_345 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_345 * tmp1_0;
    // Op 346: dim1x1 sub_swap
    gl64_t s0_346 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_346 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_346 - s0_346;
    // Op 347: dim1x1 mul
    tmp1_2 = tmp1_0 * tmp1_1;
    // Op 348: dim1x1 mul
    gl64_t s0_348 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_348 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp1_0 = s0_348 * s1_348;
    // Op 349: dim1x1 sub_swap
    gl64_t s0_349 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_349 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_349 - s0_349;
    // Op 350: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 351: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 352: dim1x1 mul
    gl64_t s0_352 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_352 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp1_0 = s0_352 * s1_352;
    // Op 353: dim1x1 sub_swap
    gl64_t s0_353 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_353 = *(gl64_t*)&expressions_params[9][1];
    tmp1_2 = s1_353 - s0_353;
    // Op 354: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_2;
    // Op 355: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 356: dim1x1 mul
    gl64_t s0_356 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_356 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_356 * s1_356;
    // Op 357: dim1x1 sub_swap
    gl64_t s0_357 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_357 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_357 - s0_357;
    // Op 358: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 359: dim1x1 sub_swap
    gl64_t s0_359 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_359 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_359 - s0_359;
    // Op 360: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 361: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_0;
    // Op 362: dim1x1 sub_swap
    gl64_t s0_362 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_362 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_362 - s0_362;
    // Op 363: dim1x1 mul
    gl64_t s0_363 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_363 * tmp1_0;
    // Op 364: dim1x1 sub
    tmp1_1 = tmp1_2 - tmp1_0;
    // Op 365: dim1x1 mul
    gl64_t s0_365 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_365 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_365 * s1_365;
    // Op 366: dim1x1 mul
    gl64_t s0_366 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_366 * tmp1_0;
    // Op 367: dim1x1 sub_swap
    gl64_t s0_367 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_367 = *(gl64_t*)&expressions_params[9][1];
    tmp1_2 = s1_367 - s0_367;
    // Op 368: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_2;
    // Op 369: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 370: dim1x1 add
    gl64_t s0_370 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_370 + tmp1_0;
    // Op 371: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 372: dim3x3 mul
    gl64_t s1_372_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_372_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_372_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA372 = (tmp3_0 + tmp3_1) * (s1_372_0 + s1_372_1);
    gl64_t kB372 = (tmp3_0 + tmp3_2) * (s1_372_0 + s1_372_2);
    gl64_t kC372 = (tmp3_1 + tmp3_2) * (s1_372_1 + s1_372_2);
    gl64_t kD372 = tmp3_0 * s1_372_0;
    gl64_t kE372 = tmp3_1 * s1_372_1;
    gl64_t kF372 = tmp3_2 * s1_372_2;
    gl64_t kG372 = kD372 - kE372;
    tmp3_0 = (kC372 + kG372) - kF372;
    tmp3_1 = ((((kA372 + kC372) - kE372) - kE372) - kD372);
    tmp3_2 = kB372 - kG372;
    // Op 373: dim1x1 sub_swap
    gl64_t s0_373 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_373 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_373 - s0_373;
    // Op 374: dim1x1 mul
    gl64_t s0_374 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp1_0 = s0_374 * tmp1_0;
    // Op 375: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 376: dim3x3 mul
    gl64_t s1_376_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_376_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_376_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 377: dim1x1 sub_swap
    gl64_t s0_377 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_377 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_377 - s0_377;
    // Op 378: dim1x1 mul
    gl64_t s0_378 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_378 * tmp1_0;
    // Op 379: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 380: dim3x3 mul
    gl64_t s1_380_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_380_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_380_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA380 = (tmp3_0 + tmp3_1) * (s1_380_0 + s1_380_1);
    gl64_t kB380 = (tmp3_0 + tmp3_2) * (s1_380_0 + s1_380_2);
    gl64_t kC380 = (tmp3_1 + tmp3_2) * (s1_380_1 + s1_380_2);
    gl64_t kD380 = tmp3_0 * s1_380_0;
    gl64_t kE380 = tmp3_1 * s1_380_1;
    gl64_t kF380 = tmp3_2 * s1_380_2;
    gl64_t kG380 = kD380 - kE380;
    tmp3_0 = (kC380 + kG380) - kF380;
    tmp3_1 = ((((kA380 + kC380) - kE380) - kE380) - kD380);
    tmp3_2 = kB380 - kG380;
    // Op 381: dim1x1 sub_swap
    gl64_t s0_381 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_381 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_381 - s0_381;
    // Op 382: dim1x1 mul
    gl64_t s0_382 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = s0_382 * tmp1_0;
    // Op 383: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC384 + kG384) - kF384;
    tmp3_1 = ((((kA384 + kC384) - kE384) - kE384) - kD384);
    tmp3_2 = kB384 - kG384;
    // Op 385: dim1x1 sub_swap
    gl64_t s0_385 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_385 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_385 - s0_385;
    // Op 386: dim1x1 mul
    gl64_t s0_386 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_386 * tmp1_0;
    // Op 387: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 388: dim3x3 mul
    gl64_t s1_388_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_388_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_388_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA388 = (tmp3_0 + tmp3_1) * (s1_388_0 + s1_388_1);
    gl64_t kB388 = (tmp3_0 + tmp3_2) * (s1_388_0 + s1_388_2);
    gl64_t kC388 = (tmp3_1 + tmp3_2) * (s1_388_1 + s1_388_2);
    gl64_t kD388 = tmp3_0 * s1_388_0;
    gl64_t kE388 = tmp3_1 * s1_388_1;
    gl64_t kF388 = tmp3_2 * s1_388_2;
    gl64_t kG388 = kD388 - kE388;
    tmp3_0 = (kC388 + kG388) - kF388;
    tmp3_1 = ((((kA388 + kC388) - kE388) - kE388) - kD388);
    tmp3_2 = kB388 - kG388;
    // Op 389: dim1x1 sub_swap
    gl64_t s0_389 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_389 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_389 - s0_389;
    // Op 390: dim1x1 mul
    gl64_t s0_390 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_0 = s0_390 * tmp1_0;
    // Op 391: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 392: dim3x3 mul
    gl64_t s1_392_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_392_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_392_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA392 = (tmp3_0 + tmp3_1) * (s1_392_0 + s1_392_1);
    gl64_t kB392 = (tmp3_0 + tmp3_2) * (s1_392_0 + s1_392_2);
    gl64_t kC392 = (tmp3_1 + tmp3_2) * (s1_392_1 + s1_392_2);
    gl64_t kD392 = tmp3_0 * s1_392_0;
    gl64_t kE392 = tmp3_1 * s1_392_1;
    gl64_t kF392 = tmp3_2 * s1_392_2;
    gl64_t kG392 = kD392 - kE392;
    tmp3_0 = (kC392 + kG392) - kF392;
    tmp3_1 = ((((kA392 + kC392) - kE392) - kE392) - kD392);
    tmp3_2 = kB392 - kG392;
    // Op 393: dim1x1 sub_swap
    gl64_t s0_393 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_393 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_393 - s0_393;
    // Op 394: dim1x1 mul
    gl64_t s0_394 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_394 * tmp1_0;
    // Op 395: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 396: dim3x3 mul
    gl64_t s1_396_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_396_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_396_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA396 = (tmp3_0 + tmp3_1) * (s1_396_0 + s1_396_1);
    gl64_t kB396 = (tmp3_0 + tmp3_2) * (s1_396_0 + s1_396_2);
    gl64_t kC396 = (tmp3_1 + tmp3_2) * (s1_396_1 + s1_396_2);
    gl64_t kD396 = tmp3_0 * s1_396_0;
    gl64_t kE396 = tmp3_1 * s1_396_1;
    gl64_t kF396 = tmp3_2 * s1_396_2;
    gl64_t kG396 = kD396 - kE396;
    tmp3_0 = (kC396 + kG396) - kF396;
    tmp3_1 = ((((kA396 + kC396) - kE396) - kE396) - kD396);
    tmp3_2 = kB396 - kG396;
    // Op 397: dim1x1 sub_swap
    gl64_t s0_397 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    gl64_t s1_397 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_397 - s0_397;
    // Op 398: dim1x1 mul
    gl64_t s0_398 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp1_0 = s0_398 * tmp1_0;
    // Op 399: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 400: dim3x3 mul
    gl64_t s1_400_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_400_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_400_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    gl64_t s0_401 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    gl64_t s1_401 = *(gl64_t*)&expressions_params[9][21];
    tmp1_3 = s0_401 * s1_401;
    // Op 402: dim1x1 sub_swap
    gl64_t s0_402 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_402 = *(gl64_t*)&expressions_params[9][1];
    tmp1_2 = s1_402 - s0_402;
    // Op 403: dim1x1 sub_swap
    gl64_t s0_403 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    gl64_t s1_403 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_403 - s0_403;
    // Op 404: dim1x1 sub_swap
    gl64_t s0_404 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    tmp1_4 = tmp1_0 - s0_404;
    // Op 405: dim1x1 mul
    gl64_t s0_405 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_405 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_405 * s1_405;
    // Op 406: dim1x1 add
    gl64_t s0_406 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_406 + tmp1_0;
    // Op 407: dim1x1 mul
    tmp1_1 = tmp1_4 * tmp1_0;
    // Op 408: dim1x1 mul
    gl64_t s0_408 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    gl64_t s1_408 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_408 * s1_408;
    // Op 409: dim1x1 add
    gl64_t s0_409 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_409 + tmp1_0;
    // Op 410: dim1x1 mul
    gl64_t s0_410 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    tmp1_0 = s0_410 * tmp1_0;
    // Op 411: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 412: dim1x1 mul
    gl64_t s0_412 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_412 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_412 * s1_412;
    // Op 413: dim1x1 add
    gl64_t s0_413 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_413 + tmp1_0;
    // Op 414: dim1x1 mul
    gl64_t s0_414 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    tmp1_0 = s0_414 * tmp1_0;
    // Op 415: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 416: dim1x1 mul
    tmp1_0 = tmp1_2 * tmp1_0;
    // Op 417: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_0;
    // Op 418: dim1x1 sub
    gl64_t s0_418 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 40, domainSize, nCols_1))];
    tmp1_0 = s0_418 - tmp1_0;
    // Op 419: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 420: dim3x3 mul
    gl64_t s1_420_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_420_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_420_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA420 = (tmp3_0 + tmp3_1) * (s1_420_0 + s1_420_1);
    gl64_t kB420 = (tmp3_0 + tmp3_2) * (s1_420_0 + s1_420_2);
    gl64_t kC420 = (tmp3_1 + tmp3_2) * (s1_420_1 + s1_420_2);
    gl64_t kD420 = tmp3_0 * s1_420_0;
    gl64_t kE420 = tmp3_1 * s1_420_1;
    gl64_t kF420 = tmp3_2 * s1_420_2;
    gl64_t kG420 = kD420 - kE420;
    tmp3_0 = (kC420 + kG420) - kF420;
    tmp3_1 = ((((kA420 + kC420) - kE420) - kE420) - kD420);
    tmp3_2 = kB420 - kG420;
    // Op 421: dim1x1 mul
    gl64_t s0_421 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    gl64_t s1_421 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_421 * s1_421;
    // Op 422: dim1x1 add
    gl64_t s0_422 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_422 + tmp1_0;
    // Op 423: dim1x1 mul
    gl64_t s0_423 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp1_2 = s0_423 * tmp1_0;
    // Op 424: dim1x1 sub_swap
    gl64_t s0_424 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_424 = *(gl64_t*)&expressions_params[9][1];
    tmp1_3 = s1_424 - s0_424;
    // Op 425: dim1x1 mul
    gl64_t s0_425 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_425 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_425 * s1_425;
    // Op 426: dim1x1 add
    gl64_t s0_426 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_426 + tmp1_0;
    // Op 427: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 428: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 429: dim1x1 mul
    gl64_t s0_429 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_429 * tmp1_1;
    // Op 430: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 431: dim3x3 mul
    gl64_t s1_431_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_431_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_431_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 432: dim1x1 mul
    gl64_t s0_432 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_432 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_432 * s1_432;
    // Op 433: dim1x1 add
    gl64_t s0_433 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_3 = s0_433 + tmp1_0;
    // Op 434: dim1x1 mul
    gl64_t s0_434 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_434 * tmp1_3;
    // Op 435: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 436: dim3x3 mul
    gl64_t s1_436_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_436_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_436_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA436 = (tmp3_0 + tmp3_1) * (s1_436_0 + s1_436_1);
    gl64_t kB436 = (tmp3_0 + tmp3_2) * (s1_436_0 + s1_436_2);
    gl64_t kC436 = (tmp3_1 + tmp3_2) * (s1_436_1 + s1_436_2);
    gl64_t kD436 = tmp3_0 * s1_436_0;
    gl64_t kE436 = tmp3_1 * s1_436_1;
    gl64_t kF436 = tmp3_2 * s1_436_2;
    gl64_t kG436 = kD436 - kE436;
    tmp3_12 = (kC436 + kG436) - kF436;
    tmp3_13 = ((((kA436 + kC436) - kE436) - kE436) - kD436);
    tmp3_14 = kB436 - kG436;
    // Op 437: dim3x1 mul
    gl64_t s0_437_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_437_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_437_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_437 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp3_0 = s0_437_0 * s1_437; tmp3_1 = s0_437_1 * s1_437; tmp3_2 = s0_437_2 * s1_437;
    // Op 438: dim3x1 add
    gl64_t s1_438 = *(gl64_t*)&expressions_params[9][2];
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
    gl64_t s1_440 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_440; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 441: dim3x3 add
    gl64_t s1_441_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_441_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_441_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_441_0; tmp3_4 = tmp3_10 + s1_441_1; tmp3_5 = tmp3_11 + s1_441_2;
    // Op 442: dim3x1 mul
    gl64_t s0_442_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_442_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_442_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_442 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_0 = s0_442_0 * s1_442; tmp3_1 = s0_442_1 * s1_442; tmp3_2 = s0_442_2 * s1_442;
    // Op 443: dim3x1 add
    gl64_t s1_443 = *(gl64_t*)&expressions_params[9][2];
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
    gl64_t s1_445 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_0 + s1_445; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 446: dim3x3 add
    gl64_t s1_446_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_446_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_446_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_446_0; tmp3_1 = tmp3_7 + s1_446_1; tmp3_2 = tmp3_8 + s1_446_2;
    // Op 447: dim3x3 mul
    gl64_t kA447 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB447 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC447 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD447 = tmp3_3 * tmp3_0;
    gl64_t kE447 = tmp3_4 * tmp3_1;
    gl64_t kF447 = tmp3_5 * tmp3_2;
    gl64_t kG447 = kD447 - kE447;
    tmp3_0 = (kC447 + kG447) - kF447;
    tmp3_1 = ((((kA447 + kC447) - kE447) - kE447) - kD447);
    tmp3_2 = kB447 - kG447;
    // Op 448: dim3x3 mul
    gl64_t s0_448_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_448_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_448_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA448 = (s0_448_0 + s0_448_1) * (tmp3_0 + tmp3_1);
    gl64_t kB448 = (s0_448_0 + s0_448_2) * (tmp3_0 + tmp3_2);
    gl64_t kC448 = (s0_448_1 + s0_448_2) * (tmp3_1 + tmp3_2);
    gl64_t kD448 = s0_448_0 * tmp3_0;
    gl64_t kE448 = s0_448_1 * tmp3_1;
    gl64_t kF448 = s0_448_2 * tmp3_2;
    gl64_t kG448 = kD448 - kE448;
    tmp3_0 = (kC448 + kG448) - kF448;
    tmp3_1 = ((((kA448 + kC448) - kE448) - kE448) - kD448);
    tmp3_2 = kB448 - kG448;
    // Op 449: dim3x3 add
    gl64_t s1_449_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_449_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_449_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_449_0; tmp3_7 = tmp3_7 + s1_449_1; tmp3_8 = tmp3_8 + s1_449_2;
    // Op 450: dim3x1 mul
    gl64_t s1_450 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_6 * s1_450; tmp3_7 = tmp3_7 * s1_450; tmp3_8 = tmp3_8 * s1_450;
    // Op 451: dim3x3 add
    gl64_t s1_451_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_451_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_451_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_451_0; tmp3_10 = tmp3_10 + s1_451_1; tmp3_11 = tmp3_11 + s1_451_2;
    // Op 452: dim3x1 mul
    gl64_t s1_452 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_9 * s1_452; tmp3_10 = tmp3_10 * s1_452; tmp3_11 = tmp3_11 * s1_452;
    // Op 453: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 454: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 455: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 456: dim3x3 mul
    gl64_t s1_456_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_456_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_456_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA456 = (tmp3_0 + tmp3_1) * (s1_456_0 + s1_456_1);
    gl64_t kB456 = (tmp3_0 + tmp3_2) * (s1_456_0 + s1_456_2);
    gl64_t kC456 = (tmp3_1 + tmp3_2) * (s1_456_1 + s1_456_2);
    gl64_t kD456 = tmp3_0 * s1_456_0;
    gl64_t kE456 = tmp3_1 * s1_456_1;
    gl64_t kF456 = tmp3_2 * s1_456_2;
    gl64_t kG456 = kD456 - kE456;
    tmp3_3 = (kC456 + kG456) - kF456;
    tmp3_4 = ((((kA456 + kC456) - kE456) - kE456) - kD456);
    tmp3_5 = kB456 - kG456;
    // Op 457: dim3x1 mul
    gl64_t s0_457_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_457_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_457_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_457 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp3_0 = s0_457_0 * s1_457; tmp3_1 = s0_457_1 * s1_457; tmp3_2 = s0_457_2 * s1_457;
    // Op 458: dim3x1 add
    gl64_t s1_458 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_458; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 459: dim3x3 mul
    gl64_t s1_459_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_459_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_459_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA459 = (tmp3_0 + tmp3_1) * (s1_459_0 + s1_459_1);
    gl64_t kB459 = (tmp3_0 + tmp3_2) * (s1_459_0 + s1_459_2);
    gl64_t kC459 = (tmp3_1 + tmp3_2) * (s1_459_1 + s1_459_2);
    gl64_t kD459 = tmp3_0 * s1_459_0;
    gl64_t kE459 = tmp3_1 * s1_459_1;
    gl64_t kF459 = tmp3_2 * s1_459_2;
    gl64_t kG459 = kD459 - kE459;
    tmp3_0 = (kC459 + kG459) - kF459;
    tmp3_1 = ((((kA459 + kC459) - kE459) - kE459) - kD459);
    tmp3_2 = kB459 - kG459;
    // Op 460: dim3x1 add
    gl64_t s1_460 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_460; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 461: dim3x3 add
    gl64_t s1_461_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_461_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_461_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_461_0; tmp3_13 = tmp3_10 + s1_461_1; tmp3_14 = tmp3_11 + s1_461_2;
    // Op 462: dim3x1 mul
    gl64_t s0_462_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_462_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_462_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_462 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp3_0 = s0_462_0 * s1_462; tmp3_1 = s0_462_1 * s1_462; tmp3_2 = s0_462_2 * s1_462;
    // Op 463: dim3x1 add
    gl64_t s1_463 = *(gl64_t*)&expressions_params[9][2];
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
    gl64_t s1_465 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_0 + s1_465; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 466: dim3x3 add
    gl64_t s1_466_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_466_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_466_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_466_0; tmp3_1 = tmp3_7 + s1_466_1; tmp3_2 = tmp3_8 + s1_466_2;
    // Op 467: dim3x3 mul
    gl64_t kA467 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB467 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC467 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD467 = tmp3_12 * tmp3_0;
    gl64_t kE467 = tmp3_13 * tmp3_1;
    gl64_t kF467 = tmp3_14 * tmp3_2;
    gl64_t kG467 = kD467 - kE467;
    tmp3_0 = (kC467 + kG467) - kF467;
    tmp3_1 = ((((kA467 + kC467) - kE467) - kE467) - kD467);
    tmp3_2 = kB467 - kG467;
    // Op 468: dim3x3 mul
    gl64_t s0_468_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_468_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_468_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA468 = (s0_468_0 + s0_468_1) * (tmp3_0 + tmp3_1);
    gl64_t kB468 = (s0_468_0 + s0_468_2) * (tmp3_0 + tmp3_2);
    gl64_t kC468 = (s0_468_1 + s0_468_2) * (tmp3_1 + tmp3_2);
    gl64_t kD468 = s0_468_0 * tmp3_0;
    gl64_t kE468 = s0_468_1 * tmp3_1;
    gl64_t kF468 = s0_468_2 * tmp3_2;
    gl64_t kG468 = kD468 - kE468;
    tmp3_0 = (kC468 + kG468) - kF468;
    tmp3_1 = ((((kA468 + kC468) - kE468) - kE468) - kD468);
    tmp3_2 = kB468 - kG468;
    // Op 469: dim3x3 add
    gl64_t s1_469_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_469_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_469_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_469_0; tmp3_7 = tmp3_7 + s1_469_1; tmp3_8 = tmp3_8 + s1_469_2;
    // Op 470: dim3x1 mul
    gl64_t s1_470 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_6 * s1_470; tmp3_7 = tmp3_7 * s1_470; tmp3_8 = tmp3_8 * s1_470;
    // Op 471: dim3x3 add
    gl64_t s1_471_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_471_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_471_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_471_0; tmp3_10 = tmp3_10 + s1_471_1; tmp3_11 = tmp3_11 + s1_471_2;
    // Op 472: dim3x1 mul
    gl64_t s1_472 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_9 * s1_472; tmp3_10 = tmp3_10 * s1_472; tmp3_11 = tmp3_11 * s1_472;
    // Op 473: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 474: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 475: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 476: dim3x3 mul
    gl64_t s1_476_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_476_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_476_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA476 = (tmp3_0 + tmp3_1) * (s1_476_0 + s1_476_1);
    gl64_t kB476 = (tmp3_0 + tmp3_2) * (s1_476_0 + s1_476_2);
    gl64_t kC476 = (tmp3_1 + tmp3_2) * (s1_476_1 + s1_476_2);
    gl64_t kD476 = tmp3_0 * s1_476_0;
    gl64_t kE476 = tmp3_1 * s1_476_1;
    gl64_t kF476 = tmp3_2 * s1_476_2;
    gl64_t kG476 = kD476 - kE476;
    tmp3_12 = (kC476 + kG476) - kF476;
    tmp3_13 = ((((kA476 + kC476) - kE476) - kE476) - kD476);
    tmp3_14 = kB476 - kG476;
    // Op 477: dim3x1 mul
    gl64_t s0_477_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_477_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_477_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_477 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp3_0 = s0_477_0 * s1_477; tmp3_1 = s0_477_1 * s1_477; tmp3_2 = s0_477_2 * s1_477;
    // Op 478: dim3x1 add
    gl64_t s1_478 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_478; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 479: dim3x3 mul
    gl64_t s1_479_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_479_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_479_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA479 = (tmp3_0 + tmp3_1) * (s1_479_0 + s1_479_1);
    gl64_t kB479 = (tmp3_0 + tmp3_2) * (s1_479_0 + s1_479_2);
    gl64_t kC479 = (tmp3_1 + tmp3_2) * (s1_479_1 + s1_479_2);
    gl64_t kD479 = tmp3_0 * s1_479_0;
    gl64_t kE479 = tmp3_1 * s1_479_1;
    gl64_t kF479 = tmp3_2 * s1_479_2;
    gl64_t kG479 = kD479 - kE479;
    tmp3_0 = (kC479 + kG479) - kF479;
    tmp3_1 = ((((kA479 + kC479) - kE479) - kE479) - kD479);
    tmp3_2 = kB479 - kG479;
    // Op 480: dim3x1 add
    gl64_t s1_480 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_480; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 481: dim3x3 add
    gl64_t s1_481_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_481_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_481_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_481_0; tmp3_4 = tmp3_10 + s1_481_1; tmp3_5 = tmp3_11 + s1_481_2;
    // Op 482: dim3x1 mul
    gl64_t s0_482_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_482_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_482_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_482 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp3_0 = s0_482_0 * s1_482; tmp3_1 = s0_482_1 * s1_482; tmp3_2 = s0_482_2 * s1_482;
    // Op 483: dim3x1 add
    gl64_t s1_483 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_483; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_485 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_0 + s1_485; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 486: dim3x3 add
    gl64_t s1_486_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_486_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_486_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_486_0; tmp3_1 = tmp3_7 + s1_486_1; tmp3_2 = tmp3_8 + s1_486_2;
    // Op 487: dim3x3 mul
    gl64_t kA487 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB487 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC487 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD487 = tmp3_3 * tmp3_0;
    gl64_t kE487 = tmp3_4 * tmp3_1;
    gl64_t kF487 = tmp3_5 * tmp3_2;
    gl64_t kG487 = kD487 - kE487;
    tmp3_0 = (kC487 + kG487) - kF487;
    tmp3_1 = ((((kA487 + kC487) - kE487) - kE487) - kD487);
    tmp3_2 = kB487 - kG487;
    // Op 488: dim3x3 mul
    uint64_t s0_488_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_488_0 = *(gl64_t*)&dParams->aux_trace[s0_488_pos];
    gl64_t s0_488_1 = *(gl64_t*)&dParams->aux_trace[s0_488_pos + TILE_HEIGHT];
    gl64_t s0_488_2 = *(gl64_t*)&dParams->aux_trace[s0_488_pos + 2*TILE_HEIGHT];
    gl64_t kA488 = (s0_488_0 + s0_488_1) * (tmp3_0 + tmp3_1);
    gl64_t kB488 = (s0_488_0 + s0_488_2) * (tmp3_0 + tmp3_2);
    gl64_t kC488 = (s0_488_1 + s0_488_2) * (tmp3_1 + tmp3_2);
    gl64_t kD488 = s0_488_0 * tmp3_0;
    gl64_t kE488 = s0_488_1 * tmp3_1;
    gl64_t kF488 = s0_488_2 * tmp3_2;
    gl64_t kG488 = kD488 - kE488;
    tmp3_0 = (kC488 + kG488) - kF488;
    tmp3_1 = ((((kA488 + kC488) - kE488) - kE488) - kD488);
    tmp3_2 = kB488 - kG488;
    // Op 489: dim3x3 add
    gl64_t s1_489_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_489_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_489_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_489_0; tmp3_7 = tmp3_7 + s1_489_1; tmp3_8 = tmp3_8 + s1_489_2;
    // Op 490: dim3x1 mul
    gl64_t s1_490 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_6 * s1_490; tmp3_7 = tmp3_7 * s1_490; tmp3_8 = tmp3_8 * s1_490;
    // Op 491: dim3x3 add
    gl64_t s1_491_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_491_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_491_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_491_0; tmp3_10 = tmp3_10 + s1_491_1; tmp3_11 = tmp3_11 + s1_491_2;
    // Op 492: dim3x1 mul
    gl64_t s1_492 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_9 * s1_492; tmp3_10 = tmp3_10 * s1_492; tmp3_11 = tmp3_11 * s1_492;
    // Op 493: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 494: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 495: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 496: dim3x3 mul
    gl64_t s1_496_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_496_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_496_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA496 = (tmp3_0 + tmp3_1) * (s1_496_0 + s1_496_1);
    gl64_t kB496 = (tmp3_0 + tmp3_2) * (s1_496_0 + s1_496_2);
    gl64_t kC496 = (tmp3_1 + tmp3_2) * (s1_496_1 + s1_496_2);
    gl64_t kD496 = tmp3_0 * s1_496_0;
    gl64_t kE496 = tmp3_1 * s1_496_1;
    gl64_t kF496 = tmp3_2 * s1_496_2;
    gl64_t kG496 = kD496 - kE496;
    tmp3_3 = (kC496 + kG496) - kF496;
    tmp3_4 = ((((kA496 + kC496) - kE496) - kE496) - kD496);
    tmp3_5 = kB496 - kG496;
    // Op 497: dim3x1 mul
    gl64_t s0_497_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_497_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_497_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_497 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 43, domainSize, nCols_1))];
    tmp3_0 = s0_497_0 * s1_497; tmp3_1 = s0_497_1 * s1_497; tmp3_2 = s0_497_2 * s1_497;
    // Op 498: dim3x1 add
    gl64_t s1_498 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 42, domainSize, nCols_1))];
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
    // Op 500: dim1x1 mul
    gl64_t s0_500 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_500 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_500 * s1_500;
    // Op 501: dim1x1 add
    gl64_t s0_501 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_501 + tmp1_0;
    // Op 502: dim1x1 mul
    gl64_t s0_502 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_502 = *(gl64_t*)&expressions_params[9][6];
    tmp1_2 = s0_502 * s1_502;
    // Op 503: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 504: dim1x1 mul
    gl64_t s0_504 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_504 = *(gl64_t*)&expressions_params[9][7];
    tmp1_2 = s0_504 * s1_504;
    // Op 505: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 506: dim1x1 mul
    gl64_t s0_506 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_506 = *(gl64_t*)&expressions_params[9][8];
    tmp1_2 = s0_506 * s1_506;
    // Op 507: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 508: dim1x1 mul
    gl64_t s0_508 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_508 = *(gl64_t*)&expressions_params[9][9];
    tmp1_2 = s0_508 * s1_508;
    // Op 509: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 510: dim1x1 mul
    gl64_t s0_510 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    gl64_t s1_510 = *(gl64_t*)&expressions_params[9][10];
    tmp1_2 = s0_510 * s1_510;
    // Op 511: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 512: dim1x1 mul
    gl64_t s0_512 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    gl64_t s1_512 = *(gl64_t*)&expressions_params[9][11];
    tmp1_2 = s0_512 * s1_512;
    // Op 513: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 514: dim1x1 mul
    gl64_t s0_514 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    gl64_t s1_514 = *(gl64_t*)&expressions_params[9][12];
    tmp1_2 = s0_514 * s1_514;
    // Op 515: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 516: dim1x1 mul
    gl64_t s0_516 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    gl64_t s1_516 = *(gl64_t*)&expressions_params[9][13];
    tmp1_2 = s0_516 * s1_516;
    // Op 517: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 518: dim1x1 mul
    gl64_t s0_518 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    gl64_t s1_518 = *(gl64_t*)&expressions_params[9][14];
    tmp1_2 = s0_518 * s1_518;
    // Op 519: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 520: dim1x1 mul
    gl64_t s0_520 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    gl64_t s1_520 = *(gl64_t*)&expressions_params[9][15];
    tmp1_2 = s0_520 * s1_520;
    // Op 521: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 522: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 523: dim3x3 mul
    gl64_t s1_523_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_523_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_523_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    gl64_t s1_524 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 39, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_524; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 525: dim3x3 mul
    gl64_t s1_525_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_525_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_525_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA525 = (tmp3_0 + tmp3_1) * (s1_525_0 + s1_525_1);
    gl64_t kB525 = (tmp3_0 + tmp3_2) * (s1_525_0 + s1_525_2);
    gl64_t kC525 = (tmp3_1 + tmp3_2) * (s1_525_1 + s1_525_2);
    gl64_t kD525 = tmp3_0 * s1_525_0;
    gl64_t kE525 = tmp3_1 * s1_525_1;
    gl64_t kF525 = tmp3_2 * s1_525_2;
    gl64_t kG525 = kD525 - kE525;
    tmp3_0 = (kC525 + kG525) - kF525;
    tmp3_1 = ((((kA525 + kC525) - kE525) - kE525) - kD525);
    tmp3_2 = kB525 - kG525;
    // Op 526: dim3x1 add
    gl64_t s1_526 = *(gl64_t*)&expressions_params[9][16];
    tmp3_9 = tmp3_0 + s1_526; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 527: dim3x3 add
    gl64_t s1_527_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_527_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_527_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_527_0; tmp3_13 = tmp3_10 + s1_527_1; tmp3_14 = tmp3_11 + s1_527_2;
    // Op 528: dim3x1 mul
    gl64_t s0_528_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_528_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_528_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_528 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp3_0 = s0_528_0 * s1_528; tmp3_1 = s0_528_1 * s1_528; tmp3_2 = s0_528_2 * s1_528;
    // Op 529: dim1x1 add
    gl64_t s0_529 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 42, domainSize, nCols_1))];
    gl64_t s1_529 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_529 + s1_529;
    // Op 530: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_532 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_0 + s1_532; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 533: dim3x3 add
    gl64_t s1_533_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_533_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_533_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_533_0; tmp3_1 = tmp3_7 + s1_533_1; tmp3_2 = tmp3_8 + s1_533_2;
    // Op 534: dim3x3 mul
    gl64_t kA534 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB534 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC534 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD534 = tmp3_12 * tmp3_0;
    gl64_t kE534 = tmp3_13 * tmp3_1;
    gl64_t kF534 = tmp3_14 * tmp3_2;
    gl64_t kG534 = kD534 - kE534;
    tmp3_0 = (kC534 + kG534) - kF534;
    tmp3_1 = ((((kA534 + kC534) - kE534) - kE534) - kD534);
    tmp3_2 = kB534 - kG534;
    // Op 535: dim3x3 mul
    uint64_t s0_535_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_535_0 = *(gl64_t*)&dParams->aux_trace[s0_535_pos];
    gl64_t s0_535_1 = *(gl64_t*)&dParams->aux_trace[s0_535_pos + TILE_HEIGHT];
    gl64_t s0_535_2 = *(gl64_t*)&dParams->aux_trace[s0_535_pos + 2*TILE_HEIGHT];
    gl64_t kA535 = (s0_535_0 + s0_535_1) * (tmp3_0 + tmp3_1);
    gl64_t kB535 = (s0_535_0 + s0_535_2) * (tmp3_0 + tmp3_2);
    gl64_t kC535 = (s0_535_1 + s0_535_2) * (tmp3_1 + tmp3_2);
    gl64_t kD535 = s0_535_0 * tmp3_0;
    gl64_t kE535 = s0_535_1 * tmp3_1;
    gl64_t kF535 = s0_535_2 * tmp3_2;
    gl64_t kG535 = kD535 - kE535;
    tmp3_0 = (kC535 + kG535) - kF535;
    tmp3_1 = ((((kA535 + kC535) - kE535) - kE535) - kD535);
    tmp3_2 = kB535 - kG535;
    // Op 536: dim3x3 add
    gl64_t s1_536_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_536_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_536_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_536_0; tmp3_7 = tmp3_7 + s1_536_1; tmp3_8 = tmp3_8 + s1_536_2;
    // Op 537: dim3x1 mul
    gl64_t s1_537 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_6 * s1_537; tmp3_7 = tmp3_7 * s1_537; tmp3_8 = tmp3_8 * s1_537;
    // Op 538: dim3x3 add
    gl64_t s1_538_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_538_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_538_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_538_0; tmp3_10 = tmp3_10 + s1_538_1; tmp3_11 = tmp3_11 + s1_538_2;
    // Op 539: dim3x1 mul
    gl64_t s1_539 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_9 * s1_539; tmp3_10 = tmp3_10 * s1_539; tmp3_11 = tmp3_11 * s1_539;
    // Op 540: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 541: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 542: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
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
    tmp3_12 = (kC543 + kG543) - kF543;
    tmp3_13 = ((((kA543 + kC543) - kE543) - kE543) - kD543);
    tmp3_14 = kB543 - kG543;
    // Op 544: dim3x1 mul
    gl64_t s0_544_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_544_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_544_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_544 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp3_0 = s0_544_0 * s1_544; tmp3_1 = s0_544_1 * s1_544; tmp3_2 = s0_544_2 * s1_544;
    // Op 545: dim1x1 add
    gl64_t s0_545 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 42, domainSize, nCols_1))];
    gl64_t s1_545 = *(gl64_t*)&expressions_params[9][17];
    tmp1_0 = s0_545 + s1_545;
    // Op 546: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_548 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_548; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 549: dim3x3 add
    gl64_t s1_549_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_549_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_549_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_549_0; tmp3_4 = tmp3_10 + s1_549_1; tmp3_5 = tmp3_11 + s1_549_2;
    // Op 550: dim3x1 mul
    gl64_t s0_550_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_550_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_550_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_550 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp3_0 = s0_550_0 * s1_550; tmp3_1 = s0_550_1 * s1_550; tmp3_2 = s0_550_2 * s1_550;
    // Op 551: dim1x1 add
    gl64_t s0_551 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 43, domainSize, nCols_1))];
    gl64_t s1_551 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_551 + s1_551;
    // Op 552: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 553: dim3x3 mul
    gl64_t s1_553_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_553_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_553_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA553 = (tmp3_0 + tmp3_1) * (s1_553_0 + s1_553_1);
    gl64_t kB553 = (tmp3_0 + tmp3_2) * (s1_553_0 + s1_553_2);
    gl64_t kC553 = (tmp3_1 + tmp3_2) * (s1_553_1 + s1_553_2);
    gl64_t kD553 = tmp3_0 * s1_553_0;
    gl64_t kE553 = tmp3_1 * s1_553_1;
    gl64_t kF553 = tmp3_2 * s1_553_2;
    gl64_t kG553 = kD553 - kE553;
    tmp3_0 = (kC553 + kG553) - kF553;
    tmp3_1 = ((((kA553 + kC553) - kE553) - kE553) - kD553);
    tmp3_2 = kB553 - kG553;
    // Op 554: dim3x1 add
    gl64_t s1_554 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_0 + s1_554; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 555: dim3x3 add
    gl64_t s1_555_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_555_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_555_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_555_0; tmp3_1 = tmp3_7 + s1_555_1; tmp3_2 = tmp3_8 + s1_555_2;
    // Op 556: dim3x3 mul
    gl64_t kA556 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB556 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC556 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD556 = tmp3_3 * tmp3_0;
    gl64_t kE556 = tmp3_4 * tmp3_1;
    gl64_t kF556 = tmp3_5 * tmp3_2;
    gl64_t kG556 = kD556 - kE556;
    tmp3_0 = (kC556 + kG556) - kF556;
    tmp3_1 = ((((kA556 + kC556) - kE556) - kE556) - kD556);
    tmp3_2 = kB556 - kG556;
    // Op 557: dim3x3 mul
    gl64_t s0_557_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_557_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_557_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    gl64_t kA557 = (s0_557_0 + s0_557_1) * (tmp3_0 + tmp3_1);
    gl64_t kB557 = (s0_557_0 + s0_557_2) * (tmp3_0 + tmp3_2);
    gl64_t kC557 = (s0_557_1 + s0_557_2) * (tmp3_1 + tmp3_2);
    gl64_t kD557 = s0_557_0 * tmp3_0;
    gl64_t kE557 = s0_557_1 * tmp3_1;
    gl64_t kF557 = s0_557_2 * tmp3_2;
    gl64_t kG557 = kD557 - kE557;
    tmp3_0 = (kC557 + kG557) - kF557;
    tmp3_1 = ((((kA557 + kC557) - kE557) - kE557) - kD557);
    tmp3_2 = kB557 - kG557;
    // Op 558: dim3x3 add
    gl64_t s1_558_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_558_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_558_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_558_0; tmp3_7 = tmp3_7 + s1_558_1; tmp3_8 = tmp3_8 + s1_558_2;
    // Op 559: dim3x1 mul
    gl64_t s1_559 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_6 * s1_559; tmp3_7 = tmp3_7 * s1_559; tmp3_8 = tmp3_8 * s1_559;
    // Op 560: dim3x3 add
    gl64_t s1_560_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_560_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_560_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_560_0; tmp3_10 = tmp3_10 + s1_560_1; tmp3_11 = tmp3_11 + s1_560_2;
    // Op 561: dim3x1 mul
    gl64_t s1_561 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_9 * s1_561; tmp3_10 = tmp3_10 * s1_561; tmp3_11 = tmp3_11 * s1_561;
    // Op 562: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 563: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 564: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 565: dim3x3 mul
    gl64_t s1_565_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_565_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_565_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA565 = (tmp3_0 + tmp3_1) * (s1_565_0 + s1_565_1);
    gl64_t kB565 = (tmp3_0 + tmp3_2) * (s1_565_0 + s1_565_2);
    gl64_t kC565 = (tmp3_1 + tmp3_2) * (s1_565_1 + s1_565_2);
    gl64_t kD565 = tmp3_0 * s1_565_0;
    gl64_t kE565 = tmp3_1 * s1_565_1;
    gl64_t kF565 = tmp3_2 * s1_565_2;
    gl64_t kG565 = kD565 - kE565;
    tmp3_3 = (kC565 + kG565) - kF565;
    tmp3_4 = ((((kA565 + kC565) - kE565) - kE565) - kD565);
    tmp3_5 = kB565 - kG565;
    // Op 566: dim3x1 mul
    gl64_t s0_566_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_566_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_566_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_566 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp3_0 = s0_566_0 * s1_566; tmp3_1 = s0_566_1 * s1_566; tmp3_2 = s0_566_2 * s1_566;
    // Op 567: dim1x1 add
    gl64_t s0_567 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 43, domainSize, nCols_1))];
    gl64_t s1_567 = *(gl64_t*)&expressions_params[9][17];
    tmp1_0 = s0_567 + s1_567;
    // Op 568: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 569: dim3x3 mul
    gl64_t s1_569_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_569_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_569_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA569 = (tmp3_0 + tmp3_1) * (s1_569_0 + s1_569_1);
    gl64_t kB569 = (tmp3_0 + tmp3_2) * (s1_569_0 + s1_569_2);
    gl64_t kC569 = (tmp3_1 + tmp3_2) * (s1_569_1 + s1_569_2);
    gl64_t kD569 = tmp3_0 * s1_569_0;
    gl64_t kE569 = tmp3_1 * s1_569_1;
    gl64_t kF569 = tmp3_2 * s1_569_2;
    gl64_t kG569 = kD569 - kE569;
    tmp3_0 = (kC569 + kG569) - kF569;
    tmp3_1 = ((((kA569 + kC569) - kE569) - kE569) - kD569);
    tmp3_2 = kB569 - kG569;
    // Op 570: dim3x1 add
    gl64_t s1_570 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_570; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 571: dim3x3 add
    gl64_t s1_571_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_571_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_571_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_571_0; tmp3_13 = tmp3_10 + s1_571_1; tmp3_14 = tmp3_11 + s1_571_2;
    // Op 572: dim3x1 mul
    gl64_t s0_572_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_572_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_572_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_572 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp3_0 = s0_572_0 * s1_572; tmp3_1 = s0_572_1 * s1_572; tmp3_2 = s0_572_2 * s1_572;
    // Op 573: dim3x1 add
    gl64_t s1_573 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 42, domainSize, nCols_1))];
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
    gl64_t s1_575 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_0 + s1_575; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 576: dim3x3 add
    gl64_t s1_576_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_576_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_576_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_576_0; tmp3_1 = tmp3_7 + s1_576_1; tmp3_2 = tmp3_8 + s1_576_2;
    // Op 577: dim3x3 mul
    gl64_t kA577 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB577 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC577 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD577 = tmp3_12 * tmp3_0;
    gl64_t kE577 = tmp3_13 * tmp3_1;
    gl64_t kF577 = tmp3_14 * tmp3_2;
    gl64_t kG577 = kD577 - kE577;
    tmp3_0 = (kC577 + kG577) - kF577;
    tmp3_1 = ((((kA577 + kC577) - kE577) - kE577) - kD577);
    tmp3_2 = kB577 - kG577;
    // Op 578: dim3x3 mul
    gl64_t s0_578_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+0, domainSize, nCols_2))];
    gl64_t s0_578_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+1, domainSize, nCols_2))];
    gl64_t s0_578_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+2, domainSize, nCols_2))];
    gl64_t kA578 = (s0_578_0 + s0_578_1) * (tmp3_0 + tmp3_1);
    gl64_t kB578 = (s0_578_0 + s0_578_2) * (tmp3_0 + tmp3_2);
    gl64_t kC578 = (s0_578_1 + s0_578_2) * (tmp3_1 + tmp3_2);
    gl64_t kD578 = s0_578_0 * tmp3_0;
    gl64_t kE578 = s0_578_1 * tmp3_1;
    gl64_t kF578 = s0_578_2 * tmp3_2;
    gl64_t kG578 = kD578 - kE578;
    tmp3_0 = (kC578 + kG578) - kF578;
    tmp3_1 = ((((kA578 + kC578) - kE578) - kE578) - kD578);
    tmp3_2 = kB578 - kG578;
    // Op 579: dim3x3 add
    gl64_t s1_579_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_579_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_579_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_579_0; tmp3_7 = tmp3_7 + s1_579_1; tmp3_8 = tmp3_8 + s1_579_2;
    // Op 580: dim3x1 mul
    gl64_t s1_580 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_6 * s1_580; tmp3_7 = tmp3_7 * s1_580; tmp3_8 = tmp3_8 * s1_580;
    // Op 581: dim3x3 add
    gl64_t s1_581_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_581_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_581_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_581_0; tmp3_10 = tmp3_10 + s1_581_1; tmp3_11 = tmp3_11 + s1_581_2;
    // Op 582: dim3x1 mul
    gl64_t s1_582 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_9 * s1_582; tmp3_10 = tmp3_10 * s1_582; tmp3_11 = tmp3_11 * s1_582;
    // Op 583: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 584: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 585: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 586: dim3x3 mul
    gl64_t s1_586_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_586_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_586_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA586 = (tmp3_0 + tmp3_1) * (s1_586_0 + s1_586_1);
    gl64_t kB586 = (tmp3_0 + tmp3_2) * (s1_586_0 + s1_586_2);
    gl64_t kC586 = (tmp3_1 + tmp3_2) * (s1_586_1 + s1_586_2);
    gl64_t kD586 = tmp3_0 * s1_586_0;
    gl64_t kE586 = tmp3_1 * s1_586_1;
    gl64_t kF586 = tmp3_2 * s1_586_2;
    gl64_t kG586 = kD586 - kE586;
    tmp3_12 = (kC586 + kG586) - kF586;
    tmp3_13 = ((((kA586 + kC586) - kE586) - kE586) - kD586);
    tmp3_14 = kB586 - kG586;
    // Op 587: dim3x1 mul
    gl64_t s0_587_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_587_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_587_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_587 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp3_0 = s0_587_0 * s1_587; tmp3_1 = s0_587_1 * s1_587; tmp3_2 = s0_587_2 * s1_587;
    // Op 588: dim1x1 add
    gl64_t s0_588 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 42, domainSize, nCols_1))];
    gl64_t s1_588 = *(gl64_t*)&expressions_params[9][18];
    tmp1_0 = s0_588 + s1_588;
    // Op 589: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_591 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_591; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 592: dim3x3 add
    gl64_t s1_592_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_592_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_592_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_592_0; tmp3_4 = tmp3_10 + s1_592_1; tmp3_5 = tmp3_11 + s1_592_2;
    // Op 593: dim3x1 mul
    gl64_t s0_593_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_593_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_593_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_593 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp3_0 = s0_593_0 * s1_593; tmp3_1 = s0_593_1 * s1_593; tmp3_2 = s0_593_2 * s1_593;
    // Op 594: dim3x1 add
    gl64_t s1_594 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 43, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_594; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_596 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_0 + s1_596; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 597: dim3x3 add
    gl64_t s1_597_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_597_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_597_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_597_0; tmp3_1 = tmp3_7 + s1_597_1; tmp3_2 = tmp3_8 + s1_597_2;
    // Op 598: dim3x3 mul
    gl64_t kA598 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB598 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC598 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD598 = tmp3_3 * tmp3_0;
    gl64_t kE598 = tmp3_4 * tmp3_1;
    gl64_t kF598 = tmp3_5 * tmp3_2;
    gl64_t kG598 = kD598 - kE598;
    tmp3_0 = (kC598 + kG598) - kF598;
    tmp3_1 = ((((kA598 + kC598) - kE598) - kE598) - kD598);
    tmp3_2 = kB598 - kG598;
    // Op 599: dim3x3 mul
    uint64_t s0_599_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_2));
    gl64_t s0_599_0 = *(gl64_t*)&dParams->aux_trace[s0_599_pos];
    gl64_t s0_599_1 = *(gl64_t*)&dParams->aux_trace[s0_599_pos + TILE_HEIGHT];
    gl64_t s0_599_2 = *(gl64_t*)&dParams->aux_trace[s0_599_pos + 2*TILE_HEIGHT];
    gl64_t kA599 = (s0_599_0 + s0_599_1) * (tmp3_0 + tmp3_1);
    gl64_t kB599 = (s0_599_0 + s0_599_2) * (tmp3_0 + tmp3_2);
    gl64_t kC599 = (s0_599_1 + s0_599_2) * (tmp3_1 + tmp3_2);
    gl64_t kD599 = s0_599_0 * tmp3_0;
    gl64_t kE599 = s0_599_1 * tmp3_1;
    gl64_t kF599 = s0_599_2 * tmp3_2;
    gl64_t kG599 = kD599 - kE599;
    tmp3_0 = (kC599 + kG599) - kF599;
    tmp3_1 = ((((kA599 + kC599) - kE599) - kE599) - kD599);
    tmp3_2 = kB599 - kG599;
    // Op 600: dim3x3 add
    gl64_t s1_600_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_600_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_600_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_600_0; tmp3_7 = tmp3_7 + s1_600_1; tmp3_8 = tmp3_8 + s1_600_2;
    // Op 601: dim3x1 mul
    gl64_t s1_601 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_6 * s1_601; tmp3_7 = tmp3_7 * s1_601; tmp3_8 = tmp3_8 * s1_601;
    // Op 602: dim3x3 add
    gl64_t s1_602_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_602_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_602_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_602_0; tmp3_10 = tmp3_10 + s1_602_1; tmp3_11 = tmp3_11 + s1_602_2;
    // Op 603: dim3x1 mul
    gl64_t s1_603 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_9 * s1_603; tmp3_10 = tmp3_10 * s1_603; tmp3_11 = tmp3_11 * s1_603;
    // Op 604: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 605: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 606: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
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
    tmp3_3 = (kC607 + kG607) - kF607;
    tmp3_4 = ((((kA607 + kC607) - kE607) - kE607) - kD607);
    tmp3_5 = kB607 - kG607;
    // Op 608: dim3x1 mul
    gl64_t s0_608_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_608_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_608_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_608 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp3_0 = s0_608_0 * s1_608; tmp3_1 = s0_608_1 * s1_608; tmp3_2 = s0_608_2 * s1_608;
    // Op 609: dim1x1 add
    gl64_t s0_609 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 43, domainSize, nCols_1))];
    gl64_t s1_609 = *(gl64_t*)&expressions_params[9][18];
    tmp1_0 = s0_609 + s1_609;
    // Op 610: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 611: dim3x3 mul
    gl64_t s1_611_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_611_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_611_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA611 = (tmp3_0 + tmp3_1) * (s1_611_0 + s1_611_1);
    gl64_t kB611 = (tmp3_0 + tmp3_2) * (s1_611_0 + s1_611_2);
    gl64_t kC611 = (tmp3_1 + tmp3_2) * (s1_611_1 + s1_611_2);
    gl64_t kD611 = tmp3_0 * s1_611_0;
    gl64_t kE611 = tmp3_1 * s1_611_1;
    gl64_t kF611 = tmp3_2 * s1_611_2;
    gl64_t kG611 = kD611 - kE611;
    tmp3_0 = (kC611 + kG611) - kF611;
    tmp3_1 = ((((kA611 + kC611) - kE611) - kE611) - kD611);
    tmp3_2 = kB611 - kG611;
    // Op 612: dim3x1 add
    gl64_t s1_612 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_612; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 613: dim3x3 add
    gl64_t s1_613_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_613_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_613_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_613_0; tmp3_13 = tmp3_10 + s1_613_1; tmp3_14 = tmp3_11 + s1_613_2;
    // Op 614: dim3x1 mul
    gl64_t s0_614_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_614_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_614_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_614 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp3_0 = s0_614_0 * s1_614; tmp3_1 = s0_614_1 * s1_614; tmp3_2 = s0_614_2 * s1_614;
    // Op 615: dim3x3 mul
    gl64_t s1_615_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_615_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_615_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA615 = (tmp3_0 + tmp3_1) * (s1_615_0 + s1_615_1);
    gl64_t kB615 = (tmp3_0 + tmp3_2) * (s1_615_0 + s1_615_2);
    gl64_t kC615 = (tmp3_1 + tmp3_2) * (s1_615_1 + s1_615_2);
    gl64_t kD615 = tmp3_0 * s1_615_0;
    gl64_t kE615 = tmp3_1 * s1_615_1;
    gl64_t kF615 = tmp3_2 * s1_615_2;
    gl64_t kG615 = kD615 - kE615;
    tmp3_0 = (kC615 + kG615) - kF615;
    tmp3_1 = ((((kA615 + kC615) - kE615) - kE615) - kD615);
    tmp3_2 = kB615 - kG615;
    // Op 616: dim3x1 add
    gl64_t s1_616 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_0 + s1_616; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 617: dim3x3 add
    gl64_t s1_617_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_617_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_617_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_617_0; tmp3_1 = tmp3_7 + s1_617_1; tmp3_2 = tmp3_8 + s1_617_2;
    // Op 618: dim3x3 mul
    gl64_t kA618 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB618 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC618 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD618 = tmp3_12 * tmp3_0;
    gl64_t kE618 = tmp3_13 * tmp3_1;
    gl64_t kF618 = tmp3_14 * tmp3_2;
    gl64_t kG618 = kD618 - kE618;
    tmp3_0 = (kC618 + kG618) - kF618;
    tmp3_1 = ((((kA618 + kC618) - kE618) - kE618) - kD618);
    tmp3_2 = kB618 - kG618;
    // Op 619: dim3x3 mul
    uint64_t s0_619_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_2));
    gl64_t s0_619_0 = *(gl64_t*)&dParams->aux_trace[s0_619_pos];
    gl64_t s0_619_1 = *(gl64_t*)&dParams->aux_trace[s0_619_pos + TILE_HEIGHT];
    gl64_t s0_619_2 = *(gl64_t*)&dParams->aux_trace[s0_619_pos + 2*TILE_HEIGHT];
    gl64_t kA619 = (s0_619_0 + s0_619_1) * (tmp3_0 + tmp3_1);
    gl64_t kB619 = (s0_619_0 + s0_619_2) * (tmp3_0 + tmp3_2);
    gl64_t kC619 = (s0_619_1 + s0_619_2) * (tmp3_1 + tmp3_2);
    gl64_t kD619 = s0_619_0 * tmp3_0;
    gl64_t kE619 = s0_619_1 * tmp3_1;
    gl64_t kF619 = s0_619_2 * tmp3_2;
    gl64_t kG619 = kD619 - kE619;
    tmp3_0 = (kC619 + kG619) - kF619;
    tmp3_1 = ((((kA619 + kC619) - kE619) - kE619) - kD619);
    tmp3_2 = kB619 - kG619;
    // Op 620: dim3x3 add
    gl64_t s1_620_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_620_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_620_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_620_0; tmp3_7 = tmp3_7 + s1_620_1; tmp3_8 = tmp3_8 + s1_620_2;
    // Op 621: dim3x1 mul
    gl64_t s1_621 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_6 * s1_621; tmp3_7 = tmp3_7 * s1_621; tmp3_8 = tmp3_8 * s1_621;
    // Op 622: dim3x3 add
    gl64_t s1_622_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_622_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_622_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_622_0; tmp3_10 = tmp3_10 + s1_622_1; tmp3_11 = tmp3_11 + s1_622_2;
    // Op 623: dim3x1 mul
    gl64_t s1_623 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_9 * s1_623; tmp3_10 = tmp3_10 * s1_623; tmp3_11 = tmp3_11 * s1_623;
    // Op 624: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 625: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 626: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 627: dim3x3 mul
    gl64_t s1_627_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_627_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_627_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA627 = (tmp3_0 + tmp3_1) * (s1_627_0 + s1_627_1);
    gl64_t kB627 = (tmp3_0 + tmp3_2) * (s1_627_0 + s1_627_2);
    gl64_t kC627 = (tmp3_1 + tmp3_2) * (s1_627_1 + s1_627_2);
    gl64_t kD627 = tmp3_0 * s1_627_0;
    gl64_t kE627 = tmp3_1 * s1_627_1;
    gl64_t kF627 = tmp3_2 * s1_627_2;
    gl64_t kG627 = kD627 - kE627;
    tmp3_12 = (kC627 + kG627) - kF627;
    tmp3_13 = ((((kA627 + kC627) - kE627) - kE627) - kD627);
    tmp3_14 = kB627 - kG627;
    // Op 628: dim3x1 mul
    gl64_t s0_628_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_628_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_628_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_628 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp3_0 = s0_628_0 * s1_628; tmp3_1 = s0_628_1 * s1_628; tmp3_2 = s0_628_2 * s1_628;
    // Op 629: dim3x3 mul
    gl64_t s1_629_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_629_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_629_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA629 = (tmp3_0 + tmp3_1) * (s1_629_0 + s1_629_1);
    gl64_t kB629 = (tmp3_0 + tmp3_2) * (s1_629_0 + s1_629_2);
    gl64_t kC629 = (tmp3_1 + tmp3_2) * (s1_629_1 + s1_629_2);
    gl64_t kD629 = tmp3_0 * s1_629_0;
    gl64_t kE629 = tmp3_1 * s1_629_1;
    gl64_t kF629 = tmp3_2 * s1_629_2;
    gl64_t kG629 = kD629 - kE629;
    tmp3_0 = (kC629 + kG629) - kF629;
    tmp3_1 = ((((kA629 + kC629) - kE629) - kE629) - kD629);
    tmp3_2 = kB629 - kG629;
    // Op 630: dim3x1 add
    gl64_t s1_630 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_630; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 631: dim3x3 add
    gl64_t s1_631_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_631_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_631_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_631_0; tmp3_4 = tmp3_10 + s1_631_1; tmp3_5 = tmp3_11 + s1_631_2;
    // Op 632: dim3x1 mul
    gl64_t s0_632_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_632_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_632_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_632 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp3_0 = s0_632_0 * s1_632; tmp3_1 = s0_632_1 * s1_632; tmp3_2 = s0_632_2 * s1_632;
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
    gl64_t s1_634 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_0 + s1_634; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 635: dim3x3 add
    gl64_t s1_635_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_635_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_635_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_635_0; tmp3_1 = tmp3_7 + s1_635_1; tmp3_2 = tmp3_8 + s1_635_2;
    // Op 636: dim3x3 mul
    gl64_t kA636 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB636 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC636 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD636 = tmp3_3 * tmp3_0;
    gl64_t kE636 = tmp3_4 * tmp3_1;
    gl64_t kF636 = tmp3_5 * tmp3_2;
    gl64_t kG636 = kD636 - kE636;
    tmp3_0 = (kC636 + kG636) - kF636;
    tmp3_1 = ((((kA636 + kC636) - kE636) - kE636) - kD636);
    tmp3_2 = kB636 - kG636;
    // Op 637: dim3x3 mul
    gl64_t s0_637_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+0, domainSize, nCols_2))];
    gl64_t s0_637_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+1, domainSize, nCols_2))];
    gl64_t s0_637_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+2, domainSize, nCols_2))];
    gl64_t kA637 = (s0_637_0 + s0_637_1) * (tmp3_0 + tmp3_1);
    gl64_t kB637 = (s0_637_0 + s0_637_2) * (tmp3_0 + tmp3_2);
    gl64_t kC637 = (s0_637_1 + s0_637_2) * (tmp3_1 + tmp3_2);
    gl64_t kD637 = s0_637_0 * tmp3_0;
    gl64_t kE637 = s0_637_1 * tmp3_1;
    gl64_t kF637 = s0_637_2 * tmp3_2;
    gl64_t kG637 = kD637 - kE637;
    tmp3_0 = (kC637 + kG637) - kF637;
    tmp3_1 = ((((kA637 + kC637) - kE637) - kE637) - kD637);
    tmp3_2 = kB637 - kG637;
    // Op 638: dim3x3 add
    gl64_t s1_638_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_638_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_638_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_638_0; tmp3_7 = tmp3_7 + s1_638_1; tmp3_8 = tmp3_8 + s1_638_2;
    // Op 639: dim3x1 mul
    gl64_t s1_639 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_6 * s1_639; tmp3_7 = tmp3_7 * s1_639; tmp3_8 = tmp3_8 * s1_639;
    // Op 640: dim3x3 add
    gl64_t s1_640_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_640_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_640_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_640_0; tmp3_10 = tmp3_10 + s1_640_1; tmp3_11 = tmp3_11 + s1_640_2;
    // Op 641: dim3x1 mul
    gl64_t s1_641 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_9 * s1_641; tmp3_10 = tmp3_10 * s1_641; tmp3_11 = tmp3_11 * s1_641;
    // Op 642: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 643: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 644: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 645: dim3x3 mul
    gl64_t s1_645_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_645_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_645_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA645 = (tmp3_0 + tmp3_1) * (s1_645_0 + s1_645_1);
    gl64_t kB645 = (tmp3_0 + tmp3_2) * (s1_645_0 + s1_645_2);
    gl64_t kC645 = (tmp3_1 + tmp3_2) * (s1_645_1 + s1_645_2);
    gl64_t kD645 = tmp3_0 * s1_645_0;
    gl64_t kE645 = tmp3_1 * s1_645_1;
    gl64_t kF645 = tmp3_2 * s1_645_2;
    gl64_t kG645 = kD645 - kE645;
    tmp3_3 = (kC645 + kG645) - kF645;
    tmp3_4 = ((((kA645 + kC645) - kE645) - kE645) - kD645);
    tmp3_5 = kB645 - kG645;
    // Op 646: dim3x1 mul
    gl64_t s0_646_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_646_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_646_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_646 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp3_0 = s0_646_0 * s1_646; tmp3_1 = s0_646_1 * s1_646; tmp3_2 = s0_646_2 * s1_646;
    // Op 647: dim3x3 mul
    gl64_t s1_647_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_647_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_647_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 648: dim3x1 add
    gl64_t s1_648 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_648; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 649: dim3x3 add
    gl64_t s1_649_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_649_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_649_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_649_0; tmp3_13 = tmp3_10 + s1_649_1; tmp3_14 = tmp3_11 + s1_649_2;
    // Op 650: dim3x1 mul
    gl64_t s0_650_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_650_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_650_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_650 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp3_0 = s0_650_0 * s1_650; tmp3_1 = s0_650_1 * s1_650; tmp3_2 = s0_650_2 * s1_650;
    // Op 651: dim3x3 mul
    gl64_t s1_651_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_651_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_651_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA651 = (tmp3_0 + tmp3_1) * (s1_651_0 + s1_651_1);
    gl64_t kB651 = (tmp3_0 + tmp3_2) * (s1_651_0 + s1_651_2);
    gl64_t kC651 = (tmp3_1 + tmp3_2) * (s1_651_1 + s1_651_2);
    gl64_t kD651 = tmp3_0 * s1_651_0;
    gl64_t kE651 = tmp3_1 * s1_651_1;
    gl64_t kF651 = tmp3_2 * s1_651_2;
    gl64_t kG651 = kD651 - kE651;
    tmp3_0 = (kC651 + kG651) - kF651;
    tmp3_1 = ((((kA651 + kC651) - kE651) - kE651) - kD651);
    tmp3_2 = kB651 - kG651;
    // Op 652: dim3x1 add
    gl64_t s1_652 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_0 + s1_652; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 653: dim3x3 add
    gl64_t s1_653_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_653_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_653_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_653_0; tmp3_1 = tmp3_7 + s1_653_1; tmp3_2 = tmp3_8 + s1_653_2;
    // Op 654: dim3x3 mul
    gl64_t kA654 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB654 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC654 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD654 = tmp3_12 * tmp3_0;
    gl64_t kE654 = tmp3_13 * tmp3_1;
    gl64_t kF654 = tmp3_14 * tmp3_2;
    gl64_t kG654 = kD654 - kE654;
    tmp3_0 = (kC654 + kG654) - kF654;
    tmp3_1 = ((((kA654 + kC654) - kE654) - kE654) - kD654);
    tmp3_2 = kB654 - kG654;
    // Op 655: dim3x3 mul
    gl64_t s0_655_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 30+0, domainSize, nCols_2))];
    gl64_t s0_655_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 30+1, domainSize, nCols_2))];
    gl64_t s0_655_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 30+2, domainSize, nCols_2))];
    gl64_t kA655 = (s0_655_0 + s0_655_1) * (tmp3_0 + tmp3_1);
    gl64_t kB655 = (s0_655_0 + s0_655_2) * (tmp3_0 + tmp3_2);
    gl64_t kC655 = (s0_655_1 + s0_655_2) * (tmp3_1 + tmp3_2);
    gl64_t kD655 = s0_655_0 * tmp3_0;
    gl64_t kE655 = s0_655_1 * tmp3_1;
    gl64_t kF655 = s0_655_2 * tmp3_2;
    gl64_t kG655 = kD655 - kE655;
    tmp3_0 = (kC655 + kG655) - kF655;
    tmp3_1 = ((((kA655 + kC655) - kE655) - kE655) - kD655);
    tmp3_2 = kB655 - kG655;
    // Op 656: dim3x3 add
    gl64_t s1_656_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_656_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_656_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_656_0; tmp3_7 = tmp3_7 + s1_656_1; tmp3_8 = tmp3_8 + s1_656_2;
    // Op 657: dim3x1 mul
    gl64_t s1_657 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_6 * s1_657; tmp3_7 = tmp3_7 * s1_657; tmp3_8 = tmp3_8 * s1_657;
    // Op 658: dim3x3 add
    gl64_t s1_658_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_658_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_658_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_658_0; tmp3_10 = tmp3_10 + s1_658_1; tmp3_11 = tmp3_11 + s1_658_2;
    // Op 659: dim3x1 mul
    gl64_t s1_659 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_9 * s1_659; tmp3_10 = tmp3_10 * s1_659; tmp3_11 = tmp3_11 * s1_659;
    // Op 660: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 661: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 662: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 663: dim3x3 mul
    gl64_t s1_663_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_663_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_663_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA663 = (tmp3_0 + tmp3_1) * (s1_663_0 + s1_663_1);
    gl64_t kB663 = (tmp3_0 + tmp3_2) * (s1_663_0 + s1_663_2);
    gl64_t kC663 = (tmp3_1 + tmp3_2) * (s1_663_1 + s1_663_2);
    gl64_t kD663 = tmp3_0 * s1_663_0;
    gl64_t kE663 = tmp3_1 * s1_663_1;
    gl64_t kF663 = tmp3_2 * s1_663_2;
    gl64_t kG663 = kD663 - kE663;
    tmp3_12 = (kC663 + kG663) - kF663;
    tmp3_13 = ((((kA663 + kC663) - kE663) - kE663) - kD663);
    tmp3_14 = kB663 - kG663;
    // Op 664: dim3x1 mul
    gl64_t s0_664_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_664_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_664_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_664 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp3_0 = s0_664_0 * s1_664; tmp3_1 = s0_664_1 * s1_664; tmp3_2 = s0_664_2 * s1_664;
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
    gl64_t s1_666 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_666; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 667: dim3x3 add
    gl64_t s1_667_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_667_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_667_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_667_0; tmp3_4 = tmp3_10 + s1_667_1; tmp3_5 = tmp3_11 + s1_667_2;
    // Op 668: dim3x1 mul
    gl64_t s0_668_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_668_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_668_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_668 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp3_0 = s0_668_0 * s1_668; tmp3_1 = s0_668_1 * s1_668; tmp3_2 = s0_668_2 * s1_668;
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
    gl64_t s1_670 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_0 + s1_670; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 671: dim3x3 add
    gl64_t s1_671_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_671_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_671_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_671_0; tmp3_1 = tmp3_7 + s1_671_1; tmp3_2 = tmp3_8 + s1_671_2;
    // Op 672: dim3x3 mul
    gl64_t kA672 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB672 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC672 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD672 = tmp3_3 * tmp3_0;
    gl64_t kE672 = tmp3_4 * tmp3_1;
    gl64_t kF672 = tmp3_5 * tmp3_2;
    gl64_t kG672 = kD672 - kE672;
    tmp3_0 = (kC672 + kG672) - kF672;
    tmp3_1 = ((((kA672 + kC672) - kE672) - kE672) - kD672);
    tmp3_2 = kB672 - kG672;
    // Op 673: dim3x3 mul
    uint64_t s0_673_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_2));
    gl64_t s0_673_0 = *(gl64_t*)&dParams->aux_trace[s0_673_pos];
    gl64_t s0_673_1 = *(gl64_t*)&dParams->aux_trace[s0_673_pos + TILE_HEIGHT];
    gl64_t s0_673_2 = *(gl64_t*)&dParams->aux_trace[s0_673_pos + 2*TILE_HEIGHT];
    gl64_t kA673 = (s0_673_0 + s0_673_1) * (tmp3_0 + tmp3_1);
    gl64_t kB673 = (s0_673_0 + s0_673_2) * (tmp3_0 + tmp3_2);
    gl64_t kC673 = (s0_673_1 + s0_673_2) * (tmp3_1 + tmp3_2);
    gl64_t kD673 = s0_673_0 * tmp3_0;
    gl64_t kE673 = s0_673_1 * tmp3_1;
    gl64_t kF673 = s0_673_2 * tmp3_2;
    gl64_t kG673 = kD673 - kE673;
    tmp3_0 = (kC673 + kG673) - kF673;
    tmp3_1 = ((((kA673 + kC673) - kE673) - kE673) - kD673);
    tmp3_2 = kB673 - kG673;
    // Op 674: dim3x3 add
    gl64_t s1_674_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_674_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_674_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_674_0; tmp3_7 = tmp3_7 + s1_674_1; tmp3_8 = tmp3_8 + s1_674_2;
    // Op 675: dim3x1 mul
    gl64_t s1_675 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_6 * s1_675; tmp3_7 = tmp3_7 * s1_675; tmp3_8 = tmp3_8 * s1_675;
    // Op 676: dim3x3 add
    gl64_t s1_676_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_676_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_676_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_676_0; tmp3_10 = tmp3_10 + s1_676_1; tmp3_11 = tmp3_11 + s1_676_2;
    // Op 677: dim3x1 mul
    gl64_t s1_677 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_9 * s1_677; tmp3_10 = tmp3_10 * s1_677; tmp3_11 = tmp3_11 * s1_677;
    // Op 678: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 679: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 680: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 681: dim3x3 mul
    gl64_t s1_681_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_681_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_681_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA681 = (tmp3_0 + tmp3_1) * (s1_681_0 + s1_681_1);
    gl64_t kB681 = (tmp3_0 + tmp3_2) * (s1_681_0 + s1_681_2);
    gl64_t kC681 = (tmp3_1 + tmp3_2) * (s1_681_1 + s1_681_2);
    gl64_t kD681 = tmp3_0 * s1_681_0;
    gl64_t kE681 = tmp3_1 * s1_681_1;
    gl64_t kF681 = tmp3_2 * s1_681_2;
    gl64_t kG681 = kD681 - kE681;
    tmp3_12 = (kC681 + kG681) - kF681;
    tmp3_13 = ((((kA681 + kC681) - kE681) - kE681) - kD681);
    tmp3_14 = kB681 - kG681;
    // Op 682: dim3x1 mul
    gl64_t s0_682_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_682_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_682_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_682 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp3_0 = s0_682_0 * s1_682; tmp3_1 = s0_682_1 * s1_682; tmp3_2 = s0_682_2 * s1_682;
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
    gl64_t s1_684 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_684; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 685: dim3x3 add
    gl64_t s1_685_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_685_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_685_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_685_0; tmp3_1 = tmp3_1 + s1_685_1; tmp3_2 = tmp3_2 + s1_685_2;
    // Op 686: dim3x3 mul
    uint64_t s0_686_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_2));
    gl64_t s0_686_0 = *(gl64_t*)&dParams->aux_trace[s0_686_pos];
    gl64_t s0_686_1 = *(gl64_t*)&dParams->aux_trace[s0_686_pos + TILE_HEIGHT];
    gl64_t s0_686_2 = *(gl64_t*)&dParams->aux_trace[s0_686_pos + 2*TILE_HEIGHT];
    gl64_t kA686 = (s0_686_0 + s0_686_1) * (tmp3_0 + tmp3_1);
    gl64_t kB686 = (s0_686_0 + s0_686_2) * (tmp3_0 + tmp3_2);
    gl64_t kC686 = (s0_686_1 + s0_686_2) * (tmp3_1 + tmp3_2);
    gl64_t kD686 = s0_686_0 * tmp3_0;
    gl64_t kE686 = s0_686_1 * tmp3_1;
    gl64_t kF686 = s0_686_2 * tmp3_2;
    gl64_t kG686 = kD686 - kE686;
    tmp3_0 = (kC686 + kG686) - kF686;
    tmp3_1 = ((((kA686 + kC686) - kE686) - kE686) - kD686);
    tmp3_2 = kB686 - kG686;
    // Op 687: dim3x1 add
    gl64_t s1_687 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_687; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 688: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 689: dim3x3 mul
    gl64_t s1_689_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_689_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_689_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA689 = (tmp3_0 + tmp3_1) * (s1_689_0 + s1_689_1);
    gl64_t kB689 = (tmp3_0 + tmp3_2) * (s1_689_0 + s1_689_2);
    gl64_t kC689 = (tmp3_1 + tmp3_2) * (s1_689_1 + s1_689_2);
    gl64_t kD689 = tmp3_0 * s1_689_0;
    gl64_t kE689 = tmp3_1 * s1_689_1;
    gl64_t kF689 = tmp3_2 * s1_689_2;
    gl64_t kG689 = kD689 - kE689;
    tmp3_12 = (kC689 + kG689) - kF689;
    tmp3_13 = ((((kA689 + kC689) - kE689) - kE689) - kD689);
    tmp3_14 = kB689 - kG689;
    // Op 690: dim3x1 mul
    gl64_t s0_690_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_690_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_690_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_690 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    tmp3_0 = s0_690_0 * s1_690; tmp3_1 = s0_690_1 * s1_690; tmp3_2 = s0_690_2 * s1_690;
    // Op 691: dim3x1 add
    gl64_t s1_691 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 40, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_691; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 692: dim3x3 mul
    gl64_t s1_692_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_692_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_692_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 693: dim1x1 mul
    gl64_t s0_693 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_693 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_693 * s1_693;
    // Op 694: dim1x1 add
    gl64_t s0_694 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_0 = s0_694 + tmp1_0;
    // Op 695: dim1x1 mul
    tmp1_4 = tmp1_4 * tmp1_0;
    // Op 696: dim1x1 mul
    gl64_t s0_696 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    gl64_t s1_696 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_696 * s1_696;
    // Op 697: dim1x1 add
    gl64_t s0_697 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_0 = s0_697 + tmp1_0;
    // Op 698: dim1x1 mul
    gl64_t s0_698 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    tmp1_0 = s0_698 * tmp1_0;
    // Op 699: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_0;
    // Op 700: dim1x1 mul
    gl64_t s0_700 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_700 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_700 * s1_700;
    // Op 701: dim1x1 add
    gl64_t s0_701 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_701 + tmp1_0;
    // Op 702: dim1x1 mul
    gl64_t s0_702 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    tmp1_0 = s0_702 * tmp1_0;
    // Op 703: dim1x1 add
    tmp1_0 = tmp1_4 + tmp1_0;
    // Op 704: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 705: dim3x3 mul
    gl64_t s1_705_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_705_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_705_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA705 = (tmp3_0 + tmp3_1) * (s1_705_0 + s1_705_1);
    gl64_t kB705 = (tmp3_0 + tmp3_2) * (s1_705_0 + s1_705_2);
    gl64_t kC705 = (tmp3_1 + tmp3_2) * (s1_705_1 + s1_705_2);
    gl64_t kD705 = tmp3_0 * s1_705_0;
    gl64_t kE705 = tmp3_1 * s1_705_1;
    gl64_t kF705 = tmp3_2 * s1_705_2;
    gl64_t kG705 = kD705 - kE705;
    tmp3_0 = (kC705 + kG705) - kF705;
    tmp3_1 = ((((kA705 + kC705) - kE705) - kE705) - kD705);
    tmp3_2 = kB705 - kG705;
    // Op 706: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_3; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 707: dim3x3 mul
    gl64_t s1_707_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_707_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_707_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA707 = (tmp3_0 + tmp3_1) * (s1_707_0 + s1_707_1);
    gl64_t kB707 = (tmp3_0 + tmp3_2) * (s1_707_0 + s1_707_2);
    gl64_t kC707 = (tmp3_1 + tmp3_2) * (s1_707_1 + s1_707_2);
    gl64_t kD707 = tmp3_0 * s1_707_0;
    gl64_t kE707 = tmp3_1 * s1_707_1;
    gl64_t kF707 = tmp3_2 * s1_707_2;
    gl64_t kG707 = kD707 - kE707;
    tmp3_0 = (kC707 + kG707) - kF707;
    tmp3_1 = ((((kA707 + kC707) - kE707) - kE707) - kD707);
    tmp3_2 = kB707 - kG707;
    // Op 708: dim1x1 mul
    gl64_t s0_708 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_708 = *(gl64_t*)&expressions_params[9][19];
    tmp1_3 = s0_708 * s1_708;
    // Op 709: dim1x1 add
    gl64_t s0_709 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_3 = s0_709 + tmp1_3;
    // Op 710: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_3; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 714: dim1x1 mul
    gl64_t s0_714 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    gl64_t s1_714 = *(gl64_t*)&expressions_params[9][19];
    tmp1_1 = s0_714 * s1_714;
    // Op 715: dim1x1 add
    gl64_t s0_715 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_1 = s0_715 + tmp1_1;
    // Op 716: dim1x1 mul
    gl64_t s0_716 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp1_0 = s0_716 * tmp1_1;
    // Op 717: dim1x1 sub_swap
    gl64_t s0_717 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_717 = *(gl64_t*)&expressions_params[9][1];
    tmp1_3 = s1_717 - s0_717;
    // Op 718: dim1x1 mul
    gl64_t s0_718 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_718 = *(gl64_t*)&expressions_params[9][19];
    tmp1_1 = s0_718 * s1_718;
    // Op 719: dim1x1 add
    gl64_t s0_719 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_1 = s0_719 + tmp1_1;
    // Op 720: dim1x1 mul
    tmp1_1 = tmp1_3 * tmp1_1;
    // Op 721: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 722: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_724 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 39, domainSize, nCols_1))];
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
    gl64_t s1_726 = *(gl64_t*)&expressions_params[9][20];
    tmp3_0 = tmp3_0 + s1_726; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 727: dim3x3 add
    gl64_t s1_727_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_727_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_727_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_727_0; tmp3_1 = tmp3_1 + s1_727_1; tmp3_2 = tmp3_2 + s1_727_2;
    // Op 728: dim3x3 mul
    gl64_t s0_728_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 39+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 39+0, domainSize, nCols_2))];
    gl64_t s0_728_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 39+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 39+1, domainSize, nCols_2))];
    gl64_t s0_728_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 39+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 39+2, domainSize, nCols_2))];
    gl64_t kA728 = (s0_728_0 + s0_728_1) * (tmp3_0 + tmp3_1);
    gl64_t kB728 = (s0_728_0 + s0_728_2) * (tmp3_0 + tmp3_2);
    gl64_t kC728 = (s0_728_1 + s0_728_2) * (tmp3_1 + tmp3_2);
    gl64_t kD728 = s0_728_0 * tmp3_0;
    gl64_t kE728 = s0_728_1 * tmp3_1;
    gl64_t kF728 = s0_728_2 * tmp3_2;
    gl64_t kG728 = kD728 - kE728;
    tmp3_0 = (kC728 + kG728) - kF728;
    tmp3_1 = ((((kA728 + kC728) - kE728) - kE728) - kD728);
    tmp3_2 = kB728 - kG728;
    // Op 729: dim3x1 sub
    gl64_t s1_729 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 41, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 41, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 - s1_729; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 730: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 731: dim3x3 mul
    gl64_t s1_731_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_731_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_731_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA731 = (tmp3_0 + tmp3_1) * (s1_731_0 + s1_731_1);
    gl64_t kB731 = (tmp3_0 + tmp3_2) * (s1_731_0 + s1_731_2);
    gl64_t kC731 = (tmp3_1 + tmp3_2) * (s1_731_1 + s1_731_2);
    gl64_t kD731 = tmp3_0 * s1_731_0;
    gl64_t kE731 = tmp3_1 * s1_731_1;
    gl64_t kF731 = tmp3_2 * s1_731_2;
    gl64_t kG731 = kD731 - kE731;
    tmp3_12 = (kC731 + kG731) - kF731;
    tmp3_13 = ((((kA731 + kC731) - kE731) - kE731) - kD731);
    tmp3_14 = kB731 - kG731;
    // Op 732: dim3x3 mul
    gl64_t s0_732_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_732_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_732_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_732_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_732_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_732_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA732 = (s0_732_0 + s0_732_1) * (s1_732_0 + s1_732_1);
    gl64_t kB732 = (s0_732_0 + s0_732_2) * (s1_732_0 + s1_732_2);
    gl64_t kC732 = (s0_732_1 + s0_732_2) * (s1_732_1 + s1_732_2);
    gl64_t kD732 = s0_732_0 * s1_732_0;
    gl64_t kE732 = s0_732_1 * s1_732_1;
    gl64_t kF732 = s0_732_2 * s1_732_2;
    gl64_t kG732 = kD732 - kE732;
    tmp3_0 = (kC732 + kG732) - kF732;
    tmp3_1 = ((((kA732 + kC732) - kE732) - kE732) - kD732);
    tmp3_2 = kB732 - kG732;
    // Op 733: dim3x1 add
    gl64_t s1_733 = *(gl64_t*)&expressions_params[9][1];
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
    // Op 735: dim1x1 mul
    gl64_t s0_735 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_735 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_735 * s1_735;
    // Op 736: dim1x1 add
    gl64_t s0_736 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_1 = s0_736 + tmp1_0;
    // Op 737: dim1x1 mul
    gl64_t s0_737 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_737 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_737 * s1_737;
    // Op 738: dim1x1 mul
    gl64_t s1_738 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = tmp1_0 * s1_738;
    // Op 739: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 740: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 741: dim3x3 mul
    gl64_t s1_741_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_741_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_741_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA741 = (tmp3_0 + tmp3_1) * (s1_741_0 + s1_741_1);
    gl64_t kB741 = (tmp3_0 + tmp3_2) * (s1_741_0 + s1_741_2);
    gl64_t kC741 = (tmp3_1 + tmp3_2) * (s1_741_1 + s1_741_2);
    gl64_t kD741 = tmp3_0 * s1_741_0;
    gl64_t kE741 = tmp3_1 * s1_741_1;
    gl64_t kF741 = tmp3_2 * s1_741_2;
    gl64_t kG741 = kD741 - kE741;
    tmp3_0 = (kC741 + kG741) - kF741;
    tmp3_1 = ((((kA741 + kC741) - kE741) - kE741) - kD741);
    tmp3_2 = kB741 - kG741;
    // Op 742: dim1x1 mul
    gl64_t s0_742 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_742 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_742 * s1_742;
    // Op 743: dim1x1 add
    gl64_t s0_743 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_0 = s0_743 + tmp1_0;
    // Op 744: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 745: dim3x3 mul
    gl64_t s1_745_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_745_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_745_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 746: dim1x1 mul
    gl64_t s0_746 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_746 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_746 * s1_746;
    // Op 747: dim1x1 add
    gl64_t s0_747 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_1 = s0_747 + tmp1_0;
    // Op 748: dim1x1 mul
    gl64_t s0_748 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_748 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_0 = s0_748 * s1_748;
    // Op 749: dim1x1 mul
    gl64_t s1_749 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = tmp1_0 * s1_749;
    // Op 750: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 751: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 752: dim3x3 mul
    gl64_t s1_752_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_752_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_752_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA752 = (tmp3_0 + tmp3_1) * (s1_752_0 + s1_752_1);
    gl64_t kB752 = (tmp3_0 + tmp3_2) * (s1_752_0 + s1_752_2);
    gl64_t kC752 = (tmp3_1 + tmp3_2) * (s1_752_1 + s1_752_2);
    gl64_t kD752 = tmp3_0 * s1_752_0;
    gl64_t kE752 = tmp3_1 * s1_752_1;
    gl64_t kF752 = tmp3_2 * s1_752_2;
    gl64_t kG752 = kD752 - kE752;
    tmp3_0 = (kC752 + kG752) - kF752;
    tmp3_1 = ((((kA752 + kC752) - kE752) - kE752) - kD752);
    tmp3_2 = kB752 - kG752;
    // Op 753: dim1x1 mul
    gl64_t s0_753 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_753 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_753 * s1_753;
    // Op 754: dim1x1 add
    gl64_t s0_754 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_0 = s0_754 + tmp1_0;
    // Op 755: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 757: dim1x1 sub_swap
    gl64_t s0_757 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_757 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_757 - s0_757;
    // Op 758: dim1x1 sub_swap
    gl64_t s0_758 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_758 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_758 - s0_758;
    // Op 759: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 760: dim1x1 mul
    gl64_t s1_760 = *(gl64_t*)&expressions_params[9][22];
    tmp1_1 = tmp1_0 * s1_760;
    // Op 761: dim1x1 sub_swap
    gl64_t s0_761 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_761 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_761 - s0_761;
    // Op 762: dim1x1 mul
    gl64_t s0_762 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_0 = s0_762 * tmp1_0;
    // Op 763: dim1x1 mul
    gl64_t s1_763 = *(gl64_t*)&expressions_params[9][23];
    tmp1_0 = tmp1_0 * s1_763;
    // Op 764: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 765: dim1x1 sub_swap
    gl64_t s0_765 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_765 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_765 - s0_765;
    // Op 766: dim1x1 mul
    gl64_t s0_766 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_766 * tmp1_0;
    // Op 767: dim1x1 mul
    gl64_t s1_767 = *(gl64_t*)&expressions_params[9][24];
    tmp1_0 = tmp1_0 * s1_767;
    // Op 768: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 769: dim1x1 mul
    gl64_t s0_769 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_769 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_769 * s1_769;
    // Op 770: dim1x1 mul
    gl64_t s1_770 = *(gl64_t*)&expressions_params[9][7];
    tmp1_0 = tmp1_0 * s1_770;
    // Op 771: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 772: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_774 = *(gl64_t*)&expressions_params[9][20];
    tmp3_0 = tmp3_0 + s1_774; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 775: dim3x3 add
    gl64_t s1_775_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_775_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_775_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_775_0; tmp3_1 = tmp3_1 + s1_775_1; tmp3_2 = tmp3_2 + s1_775_2;
    // Op 776: dim3x3 mul
    gl64_t s0_776_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 42+0, domainSize, nCols_2))];
    gl64_t s0_776_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 42+1, domainSize, nCols_2))];
    gl64_t s0_776_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 42+2, domainSize, nCols_2))];
    gl64_t kA776 = (s0_776_0 + s0_776_1) * (tmp3_0 + tmp3_1);
    gl64_t kB776 = (s0_776_0 + s0_776_2) * (tmp3_0 + tmp3_2);
    gl64_t kC776 = (s0_776_1 + s0_776_2) * (tmp3_1 + tmp3_2);
    gl64_t kD776 = s0_776_0 * tmp3_0;
    gl64_t kE776 = s0_776_1 * tmp3_1;
    gl64_t kF776 = s0_776_2 * tmp3_2;
    gl64_t kG776 = kD776 - kE776;
    tmp3_0 = (kC776 + kG776) - kF776;
    tmp3_1 = ((((kA776 + kC776) - kE776) - kE776) - kD776);
    tmp3_2 = kB776 - kG776;
    // Op 777: dim1x1 sub_swap
    gl64_t s0_777 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    gl64_t s1_777 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_777 - s0_777;
    // Op 778: dim1x1 mul
    gl64_t s0_778 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp1_0 = s0_778 * tmp1_0;
    // Op 779: dim1x1 sub_swap
    gl64_t s1_779 = *(gl64_t*)&expressions_params[9][25];
    tmp1_0 = s1_779 - tmp1_0;
    // Op 780: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 781: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 782: dim3x3 mul
    gl64_t s1_782_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_782_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_782_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA782 = (tmp3_0 + tmp3_1) * (s1_782_0 + s1_782_1);
    gl64_t kB782 = (tmp3_0 + tmp3_2) * (s1_782_0 + s1_782_2);
    gl64_t kC782 = (tmp3_1 + tmp3_2) * (s1_782_1 + s1_782_2);
    gl64_t kD782 = tmp3_0 * s1_782_0;
    gl64_t kE782 = tmp3_1 * s1_782_1;
    gl64_t kF782 = tmp3_2 * s1_782_2;
    gl64_t kG782 = kD782 - kE782;
    tmp3_6 = (kC782 + kG782) - kF782;
    tmp3_7 = ((((kA782 + kC782) - kE782) - kE782) - kD782);
    tmp3_8 = kB782 - kG782;
    // Op 783: dim1x1 sub_swap
    gl64_t s0_783 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_783 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_783 - s0_783;
    // Op 784: dim3x1 mul
    uint64_t s0_784_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_784_0 = *(gl64_t*)&dParams->aux_trace[s0_784_pos];
    gl64_t s0_784_1 = *(gl64_t*)&dParams->aux_trace[s0_784_pos + TILE_HEIGHT];
    gl64_t s0_784_2 = *(gl64_t*)&dParams->aux_trace[s0_784_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_784_0 * tmp1_0; tmp3_1 = s0_784_1 * tmp1_0; tmp3_2 = s0_784_2 * tmp1_0;
    // Op 785: dim3x3 sub
    uint64_t s0_785_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_785_0 = *(gl64_t*)&dParams->aux_trace[s0_785_pos];
    gl64_t s0_785_1 = *(gl64_t*)&dParams->aux_trace[s0_785_pos + TILE_HEIGHT];
    gl64_t s0_785_2 = *(gl64_t*)&dParams->aux_trace[s0_785_pos + 2*TILE_HEIGHT];
    tmp3_12 = s0_785_0 - tmp3_0; tmp3_13 = s0_785_1 - tmp3_1; tmp3_14 = s0_785_2 - tmp3_2;
    // Op 786: dim3x3 add
    gl64_t s0_786_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_786_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_786_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_786_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_786_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_786_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_0 = s0_786_0 + s1_786_0; tmp3_1 = s0_786_1 + s1_786_1; tmp3_2 = s0_786_2 + s1_786_2;
    // Op 787: dim3x3 add
    uint64_t s0_787_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_787_0 = *(gl64_t*)&dParams->aux_trace[s0_787_pos];
    gl64_t s0_787_1 = *(gl64_t*)&dParams->aux_trace[s0_787_pos + TILE_HEIGHT];
    gl64_t s0_787_2 = *(gl64_t*)&dParams->aux_trace[s0_787_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_787_0 + tmp3_0; tmp3_1 = s0_787_1 + tmp3_1; tmp3_2 = s0_787_2 + tmp3_2;
    // Op 788: dim3x3 add
    uint64_t s0_788_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_788_0 = *(gl64_t*)&dParams->aux_trace[s0_788_pos];
    gl64_t s0_788_1 = *(gl64_t*)&dParams->aux_trace[s0_788_pos + TILE_HEIGHT];
    gl64_t s0_788_2 = *(gl64_t*)&dParams->aux_trace[s0_788_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_788_0 + tmp3_0; tmp3_1 = s0_788_1 + tmp3_1; tmp3_2 = s0_788_2 + tmp3_2;
    // Op 789: dim3x3 add
    gl64_t s0_789_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_789_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_789_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    tmp3_0 = s0_789_0 + tmp3_0; tmp3_1 = s0_789_1 + tmp3_1; tmp3_2 = s0_789_2 + tmp3_2;
    // Op 790: dim3x3 add
    gl64_t s0_790_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+0, domainSize, nCols_2))];
    gl64_t s0_790_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+1, domainSize, nCols_2))];
    gl64_t s0_790_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+2, domainSize, nCols_2))];
    tmp3_0 = s0_790_0 + tmp3_0; tmp3_1 = s0_790_1 + tmp3_1; tmp3_2 = s0_790_2 + tmp3_2;
    // Op 791: dim3x3 add
    uint64_t s0_791_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_2));
    gl64_t s0_791_0 = *(gl64_t*)&dParams->aux_trace[s0_791_pos];
    gl64_t s0_791_1 = *(gl64_t*)&dParams->aux_trace[s0_791_pos + TILE_HEIGHT];
    gl64_t s0_791_2 = *(gl64_t*)&dParams->aux_trace[s0_791_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_791_0 + tmp3_0; tmp3_1 = s0_791_1 + tmp3_1; tmp3_2 = s0_791_2 + tmp3_2;
    // Op 792: dim3x3 add
    uint64_t s0_792_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_2));
    gl64_t s0_792_0 = *(gl64_t*)&dParams->aux_trace[s0_792_pos];
    gl64_t s0_792_1 = *(gl64_t*)&dParams->aux_trace[s0_792_pos + TILE_HEIGHT];
    gl64_t s0_792_2 = *(gl64_t*)&dParams->aux_trace[s0_792_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_792_0 + tmp3_0; tmp3_1 = s0_792_1 + tmp3_1; tmp3_2 = s0_792_2 + tmp3_2;
    // Op 793: dim3x3 add
    gl64_t s0_793_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+0, domainSize, nCols_2))];
    gl64_t s0_793_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+1, domainSize, nCols_2))];
    gl64_t s0_793_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+2, domainSize, nCols_2))];
    tmp3_0 = s0_793_0 + tmp3_0; tmp3_1 = s0_793_1 + tmp3_1; tmp3_2 = s0_793_2 + tmp3_2;
    // Op 794: dim3x3 add
    gl64_t s0_794_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 30+0, domainSize, nCols_2))];
    gl64_t s0_794_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 30+1, domainSize, nCols_2))];
    gl64_t s0_794_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 30+2, domainSize, nCols_2))];
    tmp3_0 = s0_794_0 + tmp3_0; tmp3_1 = s0_794_1 + tmp3_1; tmp3_2 = s0_794_2 + tmp3_2;
    // Op 795: dim3x3 add
    uint64_t s0_795_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_2));
    gl64_t s0_795_0 = *(gl64_t*)&dParams->aux_trace[s0_795_pos];
    gl64_t s0_795_1 = *(gl64_t*)&dParams->aux_trace[s0_795_pos + TILE_HEIGHT];
    gl64_t s0_795_2 = *(gl64_t*)&dParams->aux_trace[s0_795_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_795_0 + tmp3_0; tmp3_1 = s0_795_1 + tmp3_1; tmp3_2 = s0_795_2 + tmp3_2;
    // Op 796: dim3x3 add
    uint64_t s0_796_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_2));
    gl64_t s0_796_0 = *(gl64_t*)&dParams->aux_trace[s0_796_pos];
    gl64_t s0_796_1 = *(gl64_t*)&dParams->aux_trace[s0_796_pos + TILE_HEIGHT];
    gl64_t s0_796_2 = *(gl64_t*)&dParams->aux_trace[s0_796_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_796_0 + tmp3_0; tmp3_1 = s0_796_1 + tmp3_1; tmp3_2 = s0_796_2 + tmp3_2;
    // Op 797: dim3x3 add
    gl64_t s0_797_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 39+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 39+0, domainSize, nCols_2))];
    gl64_t s0_797_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 39+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 39+1, domainSize, nCols_2))];
    gl64_t s0_797_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 39+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 39+2, domainSize, nCols_2))];
    tmp3_0 = s0_797_0 + tmp3_0; tmp3_1 = s0_797_1 + tmp3_1; tmp3_2 = s0_797_2 + tmp3_2;
    // Op 798: dim3x3 add
    gl64_t s0_798_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 42+0, domainSize, nCols_2))];
    gl64_t s0_798_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 42+1, domainSize, nCols_2))];
    gl64_t s0_798_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 42+2, domainSize, nCols_2))];
    tmp3_0 = s0_798_0 + tmp3_0; tmp3_1 = s0_798_1 + tmp3_1; tmp3_2 = s0_798_2 + tmp3_2;
    // Op 799: dim3x3 sub
    tmp3_12 = tmp3_12 - tmp3_0; tmp3_13 = tmp3_13 - tmp3_1; tmp3_14 = tmp3_14 - tmp3_2;
    // Op 800: dim3x1 mul
    gl64_t s0_800_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_800_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_800_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_800 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp3_0 = s0_800_0 * s1_800; tmp3_1 = s0_800_1 * s1_800; tmp3_2 = s0_800_2 * s1_800;
    // Op 801: dim3x1 add
    gl64_t s1_801 = *(gl64_t*)&expressions_params[9][2];
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
    // Op 804: dim3x3 add
    gl64_t s1_804_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_804_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_804_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_804_0; tmp3_1 = tmp3_1 + s1_804_1; tmp3_2 = tmp3_2 + s1_804_2;
    // Op 805: dim3x3 mul
    gl64_t kA805 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB805 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC805 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD805 = tmp3_12 * tmp3_0;
    gl64_t kE805 = tmp3_13 * tmp3_1;
    gl64_t kF805 = tmp3_14 * tmp3_2;
    gl64_t kG805 = kD805 - kE805;
    tmp3_0 = (kC805 + kG805) - kF805;
    tmp3_1 = ((((kA805 + kC805) - kE805) - kE805) - kD805);
    tmp3_2 = kB805 - kG805;
    // Op 806: dim3x1 add
    gl64_t s1_806 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_806; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 807: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 808: dim3x3 mul
    gl64_t s1_808_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_808_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_808_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA808 = (tmp3_0 + tmp3_1) * (s1_808_0 + s1_808_1);
    gl64_t kB808 = (tmp3_0 + tmp3_2) * (s1_808_0 + s1_808_2);
    gl64_t kC808 = (tmp3_1 + tmp3_2) * (s1_808_1 + s1_808_2);
    gl64_t kD808 = tmp3_0 * s1_808_0;
    gl64_t kE808 = tmp3_1 * s1_808_1;
    gl64_t kF808 = tmp3_2 * s1_808_2;
    gl64_t kG808 = kD808 - kE808;
    tmp3_6 = (kC808 + kG808) - kF808;
    tmp3_7 = ((((kA808 + kC808) - kE808) - kE808) - kD808);
    tmp3_8 = kB808 - kG808;
    // Op 809: dim3x3 sub_swap
    uint64_t s0_809_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_809_0 = *(gl64_t*)&dParams->aux_trace[s0_809_pos];
    gl64_t s0_809_1 = *(gl64_t*)&dParams->aux_trace[s0_809_pos + TILE_HEIGHT];
    gl64_t s0_809_2 = *(gl64_t*)&dParams->aux_trace[s0_809_pos + 2*TILE_HEIGHT];
    gl64_t s1_809_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_809_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_809_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_0 = s1_809_0 - s0_809_0; tmp3_1 = s1_809_1 - s0_809_1; tmp3_2 = s1_809_2 - s0_809_2;
    // Op 810: dim3x1 mul
    gl64_t s1_810 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_810; tmp3_1 = tmp3_1 * s1_810; tmp3_2 = tmp3_2 * s1_810;
    // Op 811: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 812: dim3x3 mul
    gl64_t s1_812_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_812_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_812_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA812 = (tmp3_0 + tmp3_1) * (s1_812_0 + s1_812_1);
    gl64_t kB812 = (tmp3_0 + tmp3_2) * (s1_812_0 + s1_812_2);
    gl64_t kC812 = (tmp3_1 + tmp3_2) * (s1_812_1 + s1_812_2);
    gl64_t kD812 = tmp3_0 * s1_812_0;
    gl64_t kE812 = tmp3_1 * s1_812_1;
    gl64_t kF812 = tmp3_2 * s1_812_2;
    gl64_t kG812 = kD812 - kE812;
    tmp3_0 = (kC812 + kG812) - kF812;
    tmp3_1 = ((((kA812 + kC812) - kE812) - kE812) - kD812);
    tmp3_2 = kB812 - kG812;
    // Op 813: dim1x1 add
    gl64_t s0_813 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_813 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_1 = s0_813 + s1_813;
    // Op 814: dim1x1 mul
    gl64_t s0_814 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_814 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_814 * s1_814;
    // Op 815: dim1x1 mul
    gl64_t s0_815 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_815 * tmp1_0;
    // Op 816: dim1x1 sub
    tmp1_0 = tmp1_1 - tmp1_0;
    // Op 817: dim1x1 mul
    gl64_t s0_817 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    tmp1_0 = s0_817 * tmp1_0;
    // Op 818: dim1x1 sub
    gl64_t s0_818 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 45, domainSize, nCols_2))];
    tmp1_0 = s0_818 - tmp1_0;
    // Op 819: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 820: dim3x3 mul
    gl64_t s1_820_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_820_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_820_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 821: dim1x1 mul
    gl64_t s0_821 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_821 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_821 * s1_821;
    // Op 822: dim1x1 sub_swap
    gl64_t s0_822 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_822 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_822 - s0_822;
    // Op 823: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 824: dim1x1 sub
    gl64_t s0_824 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 46, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 46, domainSize, nCols_2))];
    tmp1_0 = s0_824 - tmp1_0;
    // Op 825: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 826: dim3x1 mul
    gl64_t s1_826 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_826; tmp3_1 = tmp3_1 * s1_826; tmp3_2 = tmp3_2 * s1_826;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
