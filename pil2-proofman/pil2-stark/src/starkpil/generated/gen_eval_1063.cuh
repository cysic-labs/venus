// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: 9a908cf0  nOps=842 nTemp1=5 nTemp3=5
#define GENERATED_EVAL_NOPS_9a908cf0 842
#define GENERATED_EVAL_NTEMP1_9a908cf0 5
#define GENERATED_EVAL_NTEMP3_9a908cf0 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_9a908cf0(
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
    gl64_t s0_140 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_140 = *(gl64_t*)&expressions_params[9][1];
    tmp1_2 = s1_140 - s0_140;
    // Op 141: dim1x1 sub_swap
    gl64_t s0_141 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_141 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_141 - s0_141;
    // Op 142: dim1x1 mul
    gl64_t s0_142 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_142 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s0_142 * s1_142;
    // Op 143: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_1;
    // Op 144: dim1x1 mul
    tmp1_1 = tmp1_2 * tmp1_0;
    // Op 145: dim1x1 add
    gl64_t s0_145 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_145 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp1_0 = s0_145 + s1_145;
    // Op 146: dim1x1 add
    gl64_t s0_146 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_146 + tmp1_0;
    // Op 147: dim1x1 add
    gl64_t s0_147 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp1_2 = s0_147 + tmp1_0;
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
    // Op 151: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 152: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
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
    gl64_t s0_155 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_155 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_155 - s0_155;
    // Op 156: dim1x1 mul
    gl64_t s0_156 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 45, domainSize, nCols_2))];
    tmp1_1 = s0_156 * tmp1_0;
    // Op 157: dim1x1 add
    gl64_t s0_157 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_157 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_157 + s1_157;
    // Op 158: dim1x1 add
    gl64_t s0_158 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_158 + tmp1_0;
    // Op 159: dim1x1 add
    gl64_t s0_159 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_159 + tmp1_0;
    // Op 160: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
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
    // Op 163: dim1x1 add
    gl64_t s0_163 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_163 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_0 = s0_163 + s1_163;
    // Op 164: dim1x1 add
    gl64_t s0_164 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_164 + tmp1_0;
    // Op 165: dim1x1 add
    gl64_t s0_165 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_165 + tmp1_0;
    // Op 166: dim1x1 mul
    gl64_t s0_166 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 46, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 46, domainSize, nCols_2))];
    tmp1_0 = s0_166 * tmp1_0;
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
    gl64_t s1_169 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_169 * s1_169;
    // Op 170: dim1x1 mul
    gl64_t s0_170 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_0 = s0_170 * tmp1_0;
    // Op 171: dim1x1 sub_swap
    gl64_t s0_171 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_1 = tmp1_0 - s0_171;
    // Op 172: dim1x1 mul
    gl64_t s0_172 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_172 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_172 * s1_172;
    // Op 173: dim1x1 mul
    gl64_t s0_173 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_0 = s0_173 * tmp1_0;
    // Op 174: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 175: dim1x1 mul
    gl64_t s0_175 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_175 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_1 = s0_175 * s1_175;
    // Op 176: dim1x1 add
    tmp1_1 = tmp1_0 + tmp1_1;
    // Op 177: dim1x1 mul
    gl64_t s0_177 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_177 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_177 * s1_177;
    // Op 178: dim1x1 mul
    gl64_t s0_178 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_0 = s0_178 * tmp1_0;
    // Op 179: dim1x1 sub
    tmp1_0 = tmp1_1 - tmp1_0;
    // Op 180: dim1x1 mul
    gl64_t s0_180 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_180 = *(gl64_t*)&expressions_params[9][19];
    tmp1_1 = s0_180 * s1_180;
    // Op 181: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_1;
    // Op 182: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 183: dim3x3 mul
    gl64_t s1_183_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_183_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_183_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 184: dim1x1 mul
    gl64_t s0_184 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_184 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_184 * s1_184;
    // Op 185: dim1x1 mul
    gl64_t s0_185 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_1 = s0_185 * tmp1_0;
    // Op 186: dim1x1 mul
    gl64_t s0_186 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_186 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_186 * s1_186;
    // Op 187: dim1x1 mul
    gl64_t s0_187 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_187 * tmp1_0;
    // Op 188: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 189: dim1x1 sub_swap
    gl64_t s0_189 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp1_1 = tmp1_0 - s0_189;
    // Op 190: dim1x1 mul
    gl64_t s0_190 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_190 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_190 * s1_190;
    // Op 191: dim1x1 mul
    gl64_t s0_191 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp1_0 = s0_191 * tmp1_0;
    // Op 192: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 193: dim1x1 mul
    gl64_t s0_193 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_193 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_1 = s0_193 * s1_193;
    // Op 194: dim1x1 add
    tmp1_1 = tmp1_0 + tmp1_1;
    // Op 195: dim1x1 mul
    gl64_t s0_195 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_195 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_195 * s1_195;
    // Op 196: dim1x1 mul
    gl64_t s0_196 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_0 = s0_196 * tmp1_0;
    // Op 197: dim1x1 sub
    tmp1_0 = tmp1_1 - tmp1_0;
    // Op 198: dim1x1 add
    gl64_t s0_198 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_198 + tmp1_0;
    // Op 199: dim1x1 mul
    gl64_t s0_199 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_199 = *(gl64_t*)&expressions_params[9][19];
    tmp1_1 = s0_199 * s1_199;
    // Op 200: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_1;
    // Op 201: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 202: dim3x3 mul
    gl64_t s1_202_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_202_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_202_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 203: dim1x1 mul
    gl64_t s0_203 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_203 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_203 * s1_203;
    // Op 204: dim1x1 mul
    gl64_t s0_204 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_1 = s0_204 * tmp1_0;
    // Op 205: dim1x1 mul
    gl64_t s0_205 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_205 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_205 * s1_205;
    // Op 206: dim1x1 mul
    gl64_t s0_206 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_206 * tmp1_0;
    // Op 207: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 208: dim1x1 mul
    gl64_t s0_208 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_208 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_208 * s1_208;
    // Op 209: dim1x1 mul
    gl64_t s0_209 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_209 * tmp1_0;
    // Op 210: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 211: dim1x1 mul
    gl64_t s0_211 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_211 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp1_0 = s0_211 * s1_211;
    // Op 212: dim1x1 mul
    gl64_t s0_212 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_212 * tmp1_0;
    // Op 213: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 214: dim1x1 mul
    gl64_t s0_214 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_214 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp1_0 = s0_214 * s1_214;
    // Op 215: dim1x1 mul
    gl64_t s0_215 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_215 * tmp1_0;
    // Op 216: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 217: dim1x1 sub_swap
    gl64_t s0_217 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_1 = tmp1_0 - s0_217;
    // Op 218: dim1x1 mul
    gl64_t s0_218 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_218 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_218 * s1_218;
    // Op 219: dim1x1 mul
    gl64_t s0_219 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_219 * tmp1_0;
    // Op 220: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 221: dim1x1 mul
    gl64_t s0_221 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_221 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_1 = s0_221 * s1_221;
    // Op 222: dim1x1 add
    tmp1_1 = tmp1_0 + tmp1_1;
    // Op 223: dim1x1 mul
    gl64_t s0_223 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_223 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_223 * s1_223;
    // Op 224: dim1x1 mul
    gl64_t s0_224 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_224 * tmp1_0;
    // Op 225: dim1x1 sub
    tmp1_1 = tmp1_1 - tmp1_0;
    // Op 226: dim1x1 mul
    gl64_t s0_226 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_226 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp1_0 = s0_226 * s1_226;
    // Op 227: dim1x1 mul
    gl64_t s0_227 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_227 * tmp1_0;
    // Op 228: dim1x1 sub
    tmp1_0 = tmp1_1 - tmp1_0;
    // Op 229: dim1x1 mul
    gl64_t s0_229 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_229 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_1 = s0_229 * s1_229;
    // Op 230: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 231: dim1x1 add
    gl64_t s0_231 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_231 + tmp1_0;
    // Op 232: dim1x1 mul
    gl64_t s0_232 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_232 = *(gl64_t*)&expressions_params[9][19];
    tmp1_1 = s0_232 * s1_232;
    // Op 233: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_1;
    // Op 234: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC235 + kG235) - kF235;
    tmp3_1 = ((((kA235 + kC235) - kE235) - kE235) - kD235);
    tmp3_2 = kB235 - kG235;
    // Op 236: dim1x1 mul
    gl64_t s0_236 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_236 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_236 * s1_236;
    // Op 237: dim1x1 mul
    gl64_t s0_237 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_1 = s0_237 * tmp1_0;
    // Op 238: dim1x1 mul
    gl64_t s0_238 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_238 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_238 * s1_238;
    // Op 239: dim1x1 mul
    gl64_t s0_239 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_239 * tmp1_0;
    // Op 240: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 241: dim1x1 mul
    gl64_t s0_241 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_241 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_241 * s1_241;
    // Op 242: dim1x1 mul
    gl64_t s0_242 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_242 * tmp1_0;
    // Op 243: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 244: dim1x1 mul
    gl64_t s0_244 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_244 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_244 * s1_244;
    // Op 245: dim1x1 mul
    gl64_t s0_245 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_245 * tmp1_0;
    // Op 246: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 247: dim1x1 mul
    gl64_t s0_247 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_247 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp1_0 = s0_247 * s1_247;
    // Op 248: dim1x1 mul
    gl64_t s0_248 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_248 * tmp1_0;
    // Op 249: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 250: dim1x1 mul
    gl64_t s0_250 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_250 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp1_0 = s0_250 * s1_250;
    // Op 251: dim1x1 mul
    gl64_t s0_251 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_251 * tmp1_0;
    // Op 252: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 253: dim1x1 sub_swap
    gl64_t s0_253 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp1_1 = tmp1_0 - s0_253;
    // Op 254: dim1x1 mul
    gl64_t s0_254 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_254 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_254 * s1_254;
    // Op 255: dim1x1 mul
    gl64_t s0_255 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp1_0 = s0_255 * tmp1_0;
    // Op 256: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 257: dim1x1 mul
    gl64_t s0_257 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_257 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_1 = s0_257 * s1_257;
    // Op 258: dim1x1 add
    tmp1_1 = tmp1_0 + tmp1_1;
    // Op 259: dim1x1 mul
    gl64_t s0_259 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_259 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_259 * s1_259;
    // Op 260: dim1x1 mul
    gl64_t s0_260 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_260 * tmp1_0;
    // Op 261: dim1x1 sub
    tmp1_0 = tmp1_1 - tmp1_0;
    // Op 262: dim1x1 add
    gl64_t s0_262 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_262 + tmp1_0;
    // Op 263: dim1x1 mul
    gl64_t s0_263 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_263 = *(gl64_t*)&expressions_params[9][19];
    tmp1_1 = s0_263 * s1_263;
    // Op 264: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_1;
    // Op 265: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 266: dim3x3 mul
    gl64_t s1_266_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_266_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_266_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA266 = (tmp3_0 + tmp3_1) * (s1_266_0 + s1_266_1);
    gl64_t kB266 = (tmp3_0 + tmp3_2) * (s1_266_0 + s1_266_2);
    gl64_t kC266 = (tmp3_1 + tmp3_2) * (s1_266_1 + s1_266_2);
    gl64_t kD266 = tmp3_0 * s1_266_0;
    gl64_t kE266 = tmp3_1 * s1_266_1;
    gl64_t kF266 = tmp3_2 * s1_266_2;
    gl64_t kG266 = kD266 - kE266;
    tmp3_0 = (kC266 + kG266) - kF266;
    tmp3_1 = ((((kA266 + kC266) - kE266) - kE266) - kD266);
    tmp3_2 = kB266 - kG266;
    // Op 267: dim1x1 mul
    gl64_t s0_267 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_267 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_267 * s1_267;
    // Op 268: dim1x1 mul
    gl64_t s0_268 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_1 = s0_268 * tmp1_0;
    // Op 269: dim1x1 mul
    gl64_t s0_269 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_269 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_269 * s1_269;
    // Op 270: dim1x1 mul
    gl64_t s0_270 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_270 * tmp1_0;
    // Op 271: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 272: dim1x1 mul
    gl64_t s0_272 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_272 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_272 * s1_272;
    // Op 273: dim1x1 mul
    gl64_t s0_273 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_273 * tmp1_0;
    // Op 274: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 275: dim1x1 mul
    gl64_t s0_275 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_275 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_275 * s1_275;
    // Op 276: dim1x1 mul
    gl64_t s0_276 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_276 * tmp1_0;
    // Op 277: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 278: dim1x1 mul
    gl64_t s0_278 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_278 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp1_0 = s0_278 * s1_278;
    // Op 279: dim1x1 sub_swap
    gl64_t s0_279 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_279 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_279 - s0_279;
    // Op 280: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 281: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 282: dim1x1 mul
    gl64_t s0_282 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_282 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp1_0 = s0_282 * s1_282;
    // Op 283: dim1x1 sub_swap
    gl64_t s0_283 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_283 = *(gl64_t*)&expressions_params[9][1];
    tmp1_2 = s1_283 - s0_283;
    // Op 284: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_2;
    // Op 285: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 286: dim1x1 mul
    gl64_t s0_286 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_286 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_286 * s1_286;
    // Op 287: dim1x1 sub_swap
    gl64_t s0_287 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_287 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_287 - s0_287;
    // Op 288: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 289: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_0;
    // Op 290: dim1x1 sub_swap
    gl64_t s0_290 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_290 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_290 - s0_290;
    // Op 291: dim1x1 mul
    gl64_t s0_291 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_291 * tmp1_0;
    // Op 292: dim1x1 mul
    gl64_t s0_292 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp1_0 = s0_292 * tmp1_0;
    // Op 293: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_0;
    // Op 294: dim1x1 sub_swap
    gl64_t s0_294 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_294 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_294 - s0_294;
    // Op 295: dim1x1 mul
    gl64_t s0_295 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_0 = s0_295 * tmp1_0;
    // Op 296: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_0;
    // Op 297: dim1x1 sub_swap
    gl64_t s0_297 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_297 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_297 - s0_297;
    // Op 298: dim1x1 mul
    gl64_t s0_298 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_0 = s0_298 * tmp1_0;
    // Op 299: dim1x1 sub
    tmp1_1 = tmp1_2 - tmp1_0;
    // Op 300: dim1x1 mul
    gl64_t s0_300 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_300 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_300 * s1_300;
    // Op 301: dim1x1 mul
    gl64_t s0_301 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_0 = s0_301 * tmp1_0;
    // Op 302: dim1x1 sub_swap
    gl64_t s0_302 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_302 = *(gl64_t*)&expressions_params[9][1];
    tmp1_2 = s1_302 - s0_302;
    // Op 303: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_2;
    // Op 304: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 305: dim1x1 add
    gl64_t s0_305 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_305 + tmp1_0;
    // Op 306: dim1x1 mul
    gl64_t s0_306 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_306 = *(gl64_t*)&expressions_params[9][19];
    tmp1_1 = s0_306 * s1_306;
    // Op 307: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_1;
    // Op 308: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 309: dim3x3 mul
    gl64_t s1_309_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_309_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_309_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA309 = (tmp3_0 + tmp3_1) * (s1_309_0 + s1_309_1);
    gl64_t kB309 = (tmp3_0 + tmp3_2) * (s1_309_0 + s1_309_2);
    gl64_t kC309 = (tmp3_1 + tmp3_2) * (s1_309_1 + s1_309_2);
    gl64_t kD309 = tmp3_0 * s1_309_0;
    gl64_t kE309 = tmp3_1 * s1_309_1;
    gl64_t kF309 = tmp3_2 * s1_309_2;
    gl64_t kG309 = kD309 - kE309;
    tmp3_0 = (kC309 + kG309) - kF309;
    tmp3_1 = ((((kA309 + kC309) - kE309) - kE309) - kD309);
    tmp3_2 = kB309 - kG309;
    // Op 310: dim1x1 mul
    gl64_t s0_310 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_310 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_310 * s1_310;
    // Op 311: dim1x1 mul
    gl64_t s0_311 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_1 = s0_311 * tmp1_0;
    // Op 312: dim1x1 mul
    gl64_t s0_312 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_312 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_312 * s1_312;
    // Op 313: dim1x1 mul
    gl64_t s0_313 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_313 * tmp1_0;
    // Op 314: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 315: dim1x1 mul
    gl64_t s0_315 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_315 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp1_0 = s0_315 * s1_315;
    // Op 316: dim1x1 sub_swap
    gl64_t s0_316 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_316 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_316 - s0_316;
    // Op 317: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 318: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 319: dim1x1 mul
    gl64_t s0_319 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_319 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp1_0 = s0_319 * s1_319;
    // Op 320: dim1x1 sub_swap
    gl64_t s0_320 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_320 = *(gl64_t*)&expressions_params[9][1];
    tmp1_2 = s1_320 - s0_320;
    // Op 321: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_2;
    // Op 322: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 323: dim1x1 sub_swap
    gl64_t s0_323 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_323 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_323 - s0_323;
    // Op 324: dim1x1 mul
    gl64_t s0_324 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_0 = s0_324 * tmp1_0;
    // Op 325: dim1x1 sub
    tmp1_2 = tmp1_1 - tmp1_0;
    // Op 326: dim1x1 mul
    gl64_t s0_326 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_326 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_326 * s1_326;
    // Op 327: dim1x1 mul
    gl64_t s0_327 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_327 * tmp1_0;
    // Op 328: dim1x1 sub_swap
    gl64_t s0_328 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_328 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_328 - s0_328;
    // Op 329: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 330: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 331: dim1x1 add
    gl64_t s0_331 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_331 + tmp1_0;
    // Op 332: dim1x1 mul
    gl64_t s0_332 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_332 = *(gl64_t*)&expressions_params[9][19];
    tmp1_2 = s0_332 * s1_332;
    // Op 333: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_2;
    // Op 334: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 335: dim3x3 mul
    gl64_t s1_335_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_335_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_335_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 336: dim1x1 mul
    gl64_t s0_336 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_1))];
    gl64_t s1_336 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_336 * s1_336;
    // Op 337: dim1x1 mul
    gl64_t s0_337 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_1 = s0_337 * tmp1_0;
    // Op 338: dim1x1 mul
    gl64_t s0_338 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_338 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp1_0 = s0_338 * s1_338;
    // Op 339: dim1x1 sub_swap
    gl64_t s0_339 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_339 = *(gl64_t*)&expressions_params[9][1];
    tmp1_2 = s1_339 - s0_339;
    // Op 340: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_2;
    // Op 341: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 342: dim1x1 mul
    gl64_t s0_342 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_342 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp1_0 = s0_342 * s1_342;
    // Op 343: dim1x1 sub_swap
    gl64_t s0_343 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_343 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_343 - s0_343;
    // Op 344: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 345: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_0;
    // Op 346: dim1x1 sub_swap
    gl64_t s0_346 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_346 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_346 - s0_346;
    // Op 347: dim1x1 mul
    gl64_t s0_347 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_347 * tmp1_0;
    // Op 348: dim1x1 sub
    tmp1_1 = tmp1_2 - tmp1_0;
    // Op 349: dim1x1 mul
    gl64_t s0_349 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_349 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_349 * s1_349;
    // Op 350: dim1x1 mul
    gl64_t s0_350 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_350 * tmp1_0;
    // Op 351: dim1x1 sub_swap
    gl64_t s0_351 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_351 = *(gl64_t*)&expressions_params[9][1];
    tmp1_2 = s1_351 - s0_351;
    // Op 352: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_2;
    // Op 353: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 354: dim1x1 add
    gl64_t s0_354 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_354 + tmp1_0;
    // Op 355: dim1x1 mul
    gl64_t s0_355 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_355 = *(gl64_t*)&expressions_params[9][19];
    tmp1_1 = s0_355 * s1_355;
    // Op 356: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_1;
    // Op 357: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 358: dim3x3 mul
    gl64_t s1_358_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_358_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_358_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA358 = (tmp3_0 + tmp3_1) * (s1_358_0 + s1_358_1);
    gl64_t kB358 = (tmp3_0 + tmp3_2) * (s1_358_0 + s1_358_2);
    gl64_t kC358 = (tmp3_1 + tmp3_2) * (s1_358_1 + s1_358_2);
    gl64_t kD358 = tmp3_0 * s1_358_0;
    gl64_t kE358 = tmp3_1 * s1_358_1;
    gl64_t kF358 = tmp3_2 * s1_358_2;
    gl64_t kG358 = kD358 - kE358;
    tmp3_0 = (kC358 + kG358) - kF358;
    tmp3_1 = ((((kA358 + kC358) - kE358) - kE358) - kD358);
    tmp3_2 = kB358 - kG358;
    // Op 359: dim1x1 mul
    gl64_t s0_359 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_359 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_359 * s1_359;
    // Op 360: dim1x1 mul
    gl64_t s0_360 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_360 * tmp1_0;
    // Op 361: dim1x1 sub_swap
    gl64_t s0_361 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_361 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_361 - s0_361;
    // Op 362: dim1x1 mul
    tmp1_2 = tmp1_0 * tmp1_1;
    // Op 363: dim1x1 mul
    gl64_t s0_363 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_363 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_1))];
    tmp1_0 = s0_363 * s1_363;
    // Op 364: dim1x1 sub_swap
    gl64_t s0_364 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_364 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_364 - s0_364;
    // Op 365: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 366: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 367: dim1x1 mul
    gl64_t s0_367 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_367 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_1))];
    tmp1_0 = s0_367 * s1_367;
    // Op 368: dim1x1 sub_swap
    gl64_t s0_368 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_368 = *(gl64_t*)&expressions_params[9][1];
    tmp1_2 = s1_368 - s0_368;
    // Op 369: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_2;
    // Op 370: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 371: dim1x1 mul
    gl64_t s0_371 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_371 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_371 * s1_371;
    // Op 372: dim1x1 sub_swap
    gl64_t s0_372 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_372 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_372 - s0_372;
    // Op 373: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 374: dim1x1 sub_swap
    gl64_t s0_374 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_374 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_374 - s0_374;
    // Op 375: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 376: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_0;
    // Op 377: dim1x1 sub_swap
    gl64_t s0_377 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_377 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_377 - s0_377;
    // Op 378: dim1x1 mul
    gl64_t s0_378 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_378 * tmp1_0;
    // Op 379: dim1x1 sub
    tmp1_1 = tmp1_2 - tmp1_0;
    // Op 380: dim1x1 mul
    gl64_t s0_380 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_380 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_380 * s1_380;
    // Op 381: dim1x1 mul
    gl64_t s0_381 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_381 * tmp1_0;
    // Op 382: dim1x1 sub_swap
    gl64_t s0_382 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_382 = *(gl64_t*)&expressions_params[9][1];
    tmp1_2 = s1_382 - s0_382;
    // Op 383: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_2;
    // Op 384: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 385: dim1x1 add
    gl64_t s0_385 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_385 + tmp1_0;
    // Op 386: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 387: dim3x3 mul
    gl64_t s1_387_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_387_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_387_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA387 = (tmp3_0 + tmp3_1) * (s1_387_0 + s1_387_1);
    gl64_t kB387 = (tmp3_0 + tmp3_2) * (s1_387_0 + s1_387_2);
    gl64_t kC387 = (tmp3_1 + tmp3_2) * (s1_387_1 + s1_387_2);
    gl64_t kD387 = tmp3_0 * s1_387_0;
    gl64_t kE387 = tmp3_1 * s1_387_1;
    gl64_t kF387 = tmp3_2 * s1_387_2;
    gl64_t kG387 = kD387 - kE387;
    tmp3_0 = (kC387 + kG387) - kF387;
    tmp3_1 = ((((kA387 + kC387) - kE387) - kE387) - kD387);
    tmp3_2 = kB387 - kG387;
    // Op 388: dim1x1 sub_swap
    gl64_t s0_388 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_388 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_388 - s0_388;
    // Op 389: dim1x1 mul
    gl64_t s0_389 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp1_0 = s0_389 * tmp1_0;
    // Op 390: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 391: dim3x3 mul
    gl64_t s1_391_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_391_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_391_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA391 = (tmp3_0 + tmp3_1) * (s1_391_0 + s1_391_1);
    gl64_t kB391 = (tmp3_0 + tmp3_2) * (s1_391_0 + s1_391_2);
    gl64_t kC391 = (tmp3_1 + tmp3_2) * (s1_391_1 + s1_391_2);
    gl64_t kD391 = tmp3_0 * s1_391_0;
    gl64_t kE391 = tmp3_1 * s1_391_1;
    gl64_t kF391 = tmp3_2 * s1_391_2;
    gl64_t kG391 = kD391 - kE391;
    tmp3_0 = (kC391 + kG391) - kF391;
    tmp3_1 = ((((kA391 + kC391) - kE391) - kE391) - kD391);
    tmp3_2 = kB391 - kG391;
    // Op 392: dim1x1 sub_swap
    gl64_t s0_392 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_392 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_392 - s0_392;
    // Op 393: dim1x1 mul
    gl64_t s0_393 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_393 * tmp1_0;
    // Op 394: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 395: dim3x3 mul
    gl64_t s1_395_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_395_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_395_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 396: dim1x1 sub_swap
    gl64_t s0_396 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_396 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_396 - s0_396;
    // Op 397: dim1x1 mul
    gl64_t s0_397 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = s0_397 * tmp1_0;
    // Op 398: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 399: dim3x3 mul
    gl64_t s1_399_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_399_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_399_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA399 = (tmp3_0 + tmp3_1) * (s1_399_0 + s1_399_1);
    gl64_t kB399 = (tmp3_0 + tmp3_2) * (s1_399_0 + s1_399_2);
    gl64_t kC399 = (tmp3_1 + tmp3_2) * (s1_399_1 + s1_399_2);
    gl64_t kD399 = tmp3_0 * s1_399_0;
    gl64_t kE399 = tmp3_1 * s1_399_1;
    gl64_t kF399 = tmp3_2 * s1_399_2;
    gl64_t kG399 = kD399 - kE399;
    tmp3_0 = (kC399 + kG399) - kF399;
    tmp3_1 = ((((kA399 + kC399) - kE399) - kE399) - kD399);
    tmp3_2 = kB399 - kG399;
    // Op 400: dim1x1 sub_swap
    gl64_t s0_400 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_400 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_400 - s0_400;
    // Op 401: dim1x1 mul
    gl64_t s0_401 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_401 * tmp1_0;
    // Op 402: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 403: dim3x3 mul
    gl64_t s1_403_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_403_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_403_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA403 = (tmp3_0 + tmp3_1) * (s1_403_0 + s1_403_1);
    gl64_t kB403 = (tmp3_0 + tmp3_2) * (s1_403_0 + s1_403_2);
    gl64_t kC403 = (tmp3_1 + tmp3_2) * (s1_403_1 + s1_403_2);
    gl64_t kD403 = tmp3_0 * s1_403_0;
    gl64_t kE403 = tmp3_1 * s1_403_1;
    gl64_t kF403 = tmp3_2 * s1_403_2;
    gl64_t kG403 = kD403 - kE403;
    tmp3_0 = (kC403 + kG403) - kF403;
    tmp3_1 = ((((kA403 + kC403) - kE403) - kE403) - kD403);
    tmp3_2 = kB403 - kG403;
    // Op 404: dim1x1 sub_swap
    gl64_t s0_404 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_404 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_404 - s0_404;
    // Op 405: dim1x1 mul
    gl64_t s0_405 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_0 = s0_405 * tmp1_0;
    // Op 406: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 407: dim3x3 mul
    gl64_t s1_407_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_407_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_407_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 408: dim1x1 sub_swap
    gl64_t s0_408 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_408 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_408 - s0_408;
    // Op 409: dim1x1 mul
    gl64_t s0_409 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_409 * tmp1_0;
    // Op 410: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 411: dim3x3 mul
    gl64_t s1_411_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_411_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_411_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA411 = (tmp3_0 + tmp3_1) * (s1_411_0 + s1_411_1);
    gl64_t kB411 = (tmp3_0 + tmp3_2) * (s1_411_0 + s1_411_2);
    gl64_t kC411 = (tmp3_1 + tmp3_2) * (s1_411_1 + s1_411_2);
    gl64_t kD411 = tmp3_0 * s1_411_0;
    gl64_t kE411 = tmp3_1 * s1_411_1;
    gl64_t kF411 = tmp3_2 * s1_411_2;
    gl64_t kG411 = kD411 - kE411;
    tmp3_0 = (kC411 + kG411) - kF411;
    tmp3_1 = ((((kA411 + kC411) - kE411) - kE411) - kD411);
    tmp3_2 = kB411 - kG411;
    // Op 412: dim1x1 sub_swap
    gl64_t s0_412 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    gl64_t s1_412 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_412 - s0_412;
    // Op 413: dim1x1 mul
    gl64_t s0_413 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp1_0 = s0_413 * tmp1_0;
    // Op 414: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 415: dim3x3 mul
    gl64_t s1_415_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_415_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_415_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA415 = (tmp3_0 + tmp3_1) * (s1_415_0 + s1_415_1);
    gl64_t kB415 = (tmp3_0 + tmp3_2) * (s1_415_0 + s1_415_2);
    gl64_t kC415 = (tmp3_1 + tmp3_2) * (s1_415_1 + s1_415_2);
    gl64_t kD415 = tmp3_0 * s1_415_0;
    gl64_t kE415 = tmp3_1 * s1_415_1;
    gl64_t kF415 = tmp3_2 * s1_415_2;
    gl64_t kG415 = kD415 - kE415;
    tmp3_0 = (kC415 + kG415) - kF415;
    tmp3_1 = ((((kA415 + kC415) - kE415) - kE415) - kD415);
    tmp3_2 = kB415 - kG415;
    // Op 416: dim1x1 mul
    gl64_t s0_416 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    gl64_t s1_416 = *(gl64_t*)&expressions_params[9][21];
    tmp1_3 = s0_416 * s1_416;
    // Op 417: dim1x1 sub_swap
    gl64_t s0_417 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_417 = *(gl64_t*)&expressions_params[9][1];
    tmp1_2 = s1_417 - s0_417;
    // Op 418: dim1x1 sub_swap
    gl64_t s0_418 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    gl64_t s1_418 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_418 - s0_418;
    // Op 419: dim1x1 sub_swap
    gl64_t s0_419 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    tmp1_4 = tmp1_0 - s0_419;
    // Op 420: dim1x1 mul
    gl64_t s0_420 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_420 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_420 * s1_420;
    // Op 421: dim1x1 add
    gl64_t s0_421 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_421 + tmp1_0;
    // Op 422: dim1x1 mul
    tmp1_1 = tmp1_4 * tmp1_0;
    // Op 423: dim1x1 mul
    gl64_t s0_423 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    gl64_t s1_423 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_423 * s1_423;
    // Op 424: dim1x1 add
    gl64_t s0_424 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_424 + tmp1_0;
    // Op 425: dim1x1 mul
    gl64_t s0_425 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    tmp1_0 = s0_425 * tmp1_0;
    // Op 426: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 427: dim1x1 mul
    gl64_t s0_427 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_427 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_427 * s1_427;
    // Op 428: dim1x1 add
    gl64_t s0_428 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_428 + tmp1_0;
    // Op 429: dim1x1 mul
    gl64_t s0_429 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    tmp1_0 = s0_429 * tmp1_0;
    // Op 430: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 431: dim1x1 mul
    tmp1_0 = tmp1_2 * tmp1_0;
    // Op 432: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_0;
    // Op 433: dim1x1 sub
    gl64_t s0_433 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 40, domainSize, nCols_1))];
    tmp1_0 = s0_433 - tmp1_0;
    // Op 434: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 435: dim3x3 mul
    gl64_t s1_435_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_435_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_435_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA435 = (tmp3_0 + tmp3_1) * (s1_435_0 + s1_435_1);
    gl64_t kB435 = (tmp3_0 + tmp3_2) * (s1_435_0 + s1_435_2);
    gl64_t kC435 = (tmp3_1 + tmp3_2) * (s1_435_1 + s1_435_2);
    gl64_t kD435 = tmp3_0 * s1_435_0;
    gl64_t kE435 = tmp3_1 * s1_435_1;
    gl64_t kF435 = tmp3_2 * s1_435_2;
    gl64_t kG435 = kD435 - kE435;
    tmp3_0 = (kC435 + kG435) - kF435;
    tmp3_1 = ((((kA435 + kC435) - kE435) - kE435) - kD435);
    tmp3_2 = kB435 - kG435;
    // Op 436: dim1x1 mul
    gl64_t s0_436 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    gl64_t s1_436 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_436 * s1_436;
    // Op 437: dim1x1 add
    gl64_t s0_437 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_437 + tmp1_0;
    // Op 438: dim1x1 mul
    gl64_t s0_438 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp1_2 = s0_438 * tmp1_0;
    // Op 439: dim1x1 sub_swap
    gl64_t s0_439 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_439 = *(gl64_t*)&expressions_params[9][1];
    tmp1_3 = s1_439 - s0_439;
    // Op 440: dim1x1 mul
    gl64_t s0_440 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_440 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_440 * s1_440;
    // Op 441: dim1x1 add
    gl64_t s0_441 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_441 + tmp1_0;
    // Op 442: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 443: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 444: dim1x1 mul
    gl64_t s0_444 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_444 * tmp1_1;
    // Op 445: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 446: dim3x3 mul
    gl64_t s1_446_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_446_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_446_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA446 = (tmp3_0 + tmp3_1) * (s1_446_0 + s1_446_1);
    gl64_t kB446 = (tmp3_0 + tmp3_2) * (s1_446_0 + s1_446_2);
    gl64_t kC446 = (tmp3_1 + tmp3_2) * (s1_446_1 + s1_446_2);
    gl64_t kD446 = tmp3_0 * s1_446_0;
    gl64_t kE446 = tmp3_1 * s1_446_1;
    gl64_t kF446 = tmp3_2 * s1_446_2;
    gl64_t kG446 = kD446 - kE446;
    tmp3_0 = (kC446 + kG446) - kF446;
    tmp3_1 = ((((kA446 + kC446) - kE446) - kE446) - kD446);
    tmp3_2 = kB446 - kG446;
    // Op 447: dim1x1 mul
    gl64_t s0_447 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_447 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_447 * s1_447;
    // Op 448: dim1x1 add
    gl64_t s0_448 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_3 = s0_448 + tmp1_0;
    // Op 449: dim1x1 mul
    gl64_t s0_449 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_449 * tmp1_3;
    // Op 450: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_12 = (kC451 + kG451) - kF451;
    tmp3_13 = ((((kA451 + kC451) - kE451) - kE451) - kD451);
    tmp3_14 = kB451 - kG451;
    // Op 452: dim3x1 mul
    gl64_t s0_452_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_452_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_452_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_452 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp3_0 = s0_452_0 * s1_452; tmp3_1 = s0_452_1 * s1_452; tmp3_2 = s0_452_2 * s1_452;
    // Op 453: dim3x1 add
    gl64_t s1_453 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_453; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 454: dim3x3 mul
    gl64_t s1_454_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_454_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_454_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA454 = (tmp3_0 + tmp3_1) * (s1_454_0 + s1_454_1);
    gl64_t kB454 = (tmp3_0 + tmp3_2) * (s1_454_0 + s1_454_2);
    gl64_t kC454 = (tmp3_1 + tmp3_2) * (s1_454_1 + s1_454_2);
    gl64_t kD454 = tmp3_0 * s1_454_0;
    gl64_t kE454 = tmp3_1 * s1_454_1;
    gl64_t kF454 = tmp3_2 * s1_454_2;
    gl64_t kG454 = kD454 - kE454;
    tmp3_0 = (kC454 + kG454) - kF454;
    tmp3_1 = ((((kA454 + kC454) - kE454) - kE454) - kD454);
    tmp3_2 = kB454 - kG454;
    // Op 455: dim3x1 add
    gl64_t s1_455 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_455; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 456: dim3x3 add
    gl64_t s1_456_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_456_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_456_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_456_0; tmp3_4 = tmp3_10 + s1_456_1; tmp3_5 = tmp3_11 + s1_456_2;
    // Op 457: dim3x1 mul
    gl64_t s0_457_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_457_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_457_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_457 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
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
    tmp3_6 = tmp3_0 + s1_460; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 461: dim3x3 add
    gl64_t s1_461_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_461_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_461_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_461_0; tmp3_1 = tmp3_7 + s1_461_1; tmp3_2 = tmp3_8 + s1_461_2;
    // Op 462: dim3x3 mul
    gl64_t kA462 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB462 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC462 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD462 = tmp3_3 * tmp3_0;
    gl64_t kE462 = tmp3_4 * tmp3_1;
    gl64_t kF462 = tmp3_5 * tmp3_2;
    gl64_t kG462 = kD462 - kE462;
    tmp3_0 = (kC462 + kG462) - kF462;
    tmp3_1 = ((((kA462 + kC462) - kE462) - kE462) - kD462);
    tmp3_2 = kB462 - kG462;
    // Op 463: dim3x3 mul
    gl64_t s0_463_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_463_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_463_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA463 = (s0_463_0 + s0_463_1) * (tmp3_0 + tmp3_1);
    gl64_t kB463 = (s0_463_0 + s0_463_2) * (tmp3_0 + tmp3_2);
    gl64_t kC463 = (s0_463_1 + s0_463_2) * (tmp3_1 + tmp3_2);
    gl64_t kD463 = s0_463_0 * tmp3_0;
    gl64_t kE463 = s0_463_1 * tmp3_1;
    gl64_t kF463 = s0_463_2 * tmp3_2;
    gl64_t kG463 = kD463 - kE463;
    tmp3_0 = (kC463 + kG463) - kF463;
    tmp3_1 = ((((kA463 + kC463) - kE463) - kE463) - kD463);
    tmp3_2 = kB463 - kG463;
    // Op 464: dim3x3 add
    gl64_t s1_464_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_464_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_464_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_464_0; tmp3_7 = tmp3_7 + s1_464_1; tmp3_8 = tmp3_8 + s1_464_2;
    // Op 465: dim3x1 mul
    gl64_t s1_465 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_6 * s1_465; tmp3_7 = tmp3_7 * s1_465; tmp3_8 = tmp3_8 * s1_465;
    // Op 466: dim3x3 add
    gl64_t s1_466_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_466_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_466_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_466_0; tmp3_10 = tmp3_10 + s1_466_1; tmp3_11 = tmp3_11 + s1_466_2;
    // Op 467: dim3x1 mul
    gl64_t s1_467 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_9 * s1_467; tmp3_10 = tmp3_10 * s1_467; tmp3_11 = tmp3_11 * s1_467;
    // Op 468: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 469: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 470: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 471: dim3x3 mul
    gl64_t s1_471_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_471_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_471_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA471 = (tmp3_0 + tmp3_1) * (s1_471_0 + s1_471_1);
    gl64_t kB471 = (tmp3_0 + tmp3_2) * (s1_471_0 + s1_471_2);
    gl64_t kC471 = (tmp3_1 + tmp3_2) * (s1_471_1 + s1_471_2);
    gl64_t kD471 = tmp3_0 * s1_471_0;
    gl64_t kE471 = tmp3_1 * s1_471_1;
    gl64_t kF471 = tmp3_2 * s1_471_2;
    gl64_t kG471 = kD471 - kE471;
    tmp3_3 = (kC471 + kG471) - kF471;
    tmp3_4 = ((((kA471 + kC471) - kE471) - kE471) - kD471);
    tmp3_5 = kB471 - kG471;
    // Op 472: dim3x1 mul
    gl64_t s0_472_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_472_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_472_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_472 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp3_0 = s0_472_0 * s1_472; tmp3_1 = s0_472_1 * s1_472; tmp3_2 = s0_472_2 * s1_472;
    // Op 473: dim3x1 add
    gl64_t s1_473 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_473; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 474: dim3x3 mul
    gl64_t s1_474_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_474_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_474_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA474 = (tmp3_0 + tmp3_1) * (s1_474_0 + s1_474_1);
    gl64_t kB474 = (tmp3_0 + tmp3_2) * (s1_474_0 + s1_474_2);
    gl64_t kC474 = (tmp3_1 + tmp3_2) * (s1_474_1 + s1_474_2);
    gl64_t kD474 = tmp3_0 * s1_474_0;
    gl64_t kE474 = tmp3_1 * s1_474_1;
    gl64_t kF474 = tmp3_2 * s1_474_2;
    gl64_t kG474 = kD474 - kE474;
    tmp3_0 = (kC474 + kG474) - kF474;
    tmp3_1 = ((((kA474 + kC474) - kE474) - kE474) - kD474);
    tmp3_2 = kB474 - kG474;
    // Op 475: dim3x1 add
    gl64_t s1_475 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_475; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 476: dim3x3 add
    gl64_t s1_476_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_476_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_476_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_476_0; tmp3_13 = tmp3_10 + s1_476_1; tmp3_14 = tmp3_11 + s1_476_2;
    // Op 477: dim3x1 mul
    gl64_t s0_477_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_477_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_477_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_477 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
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
    tmp3_6 = tmp3_0 + s1_480; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 481: dim3x3 add
    gl64_t s1_481_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_481_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_481_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_481_0; tmp3_1 = tmp3_7 + s1_481_1; tmp3_2 = tmp3_8 + s1_481_2;
    // Op 482: dim3x3 mul
    gl64_t kA482 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB482 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC482 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD482 = tmp3_12 * tmp3_0;
    gl64_t kE482 = tmp3_13 * tmp3_1;
    gl64_t kF482 = tmp3_14 * tmp3_2;
    gl64_t kG482 = kD482 - kE482;
    tmp3_0 = (kC482 + kG482) - kF482;
    tmp3_1 = ((((kA482 + kC482) - kE482) - kE482) - kD482);
    tmp3_2 = kB482 - kG482;
    // Op 483: dim3x3 mul
    gl64_t s0_483_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_483_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_483_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA483 = (s0_483_0 + s0_483_1) * (tmp3_0 + tmp3_1);
    gl64_t kB483 = (s0_483_0 + s0_483_2) * (tmp3_0 + tmp3_2);
    gl64_t kC483 = (s0_483_1 + s0_483_2) * (tmp3_1 + tmp3_2);
    gl64_t kD483 = s0_483_0 * tmp3_0;
    gl64_t kE483 = s0_483_1 * tmp3_1;
    gl64_t kF483 = s0_483_2 * tmp3_2;
    gl64_t kG483 = kD483 - kE483;
    tmp3_0 = (kC483 + kG483) - kF483;
    tmp3_1 = ((((kA483 + kC483) - kE483) - kE483) - kD483);
    tmp3_2 = kB483 - kG483;
    // Op 484: dim3x3 add
    gl64_t s1_484_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_484_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_484_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_484_0; tmp3_7 = tmp3_7 + s1_484_1; tmp3_8 = tmp3_8 + s1_484_2;
    // Op 485: dim3x1 mul
    gl64_t s1_485 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_6 * s1_485; tmp3_7 = tmp3_7 * s1_485; tmp3_8 = tmp3_8 * s1_485;
    // Op 486: dim3x3 add
    gl64_t s1_486_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_486_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_486_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_486_0; tmp3_10 = tmp3_10 + s1_486_1; tmp3_11 = tmp3_11 + s1_486_2;
    // Op 487: dim3x1 mul
    gl64_t s1_487 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_9 * s1_487; tmp3_10 = tmp3_10 * s1_487; tmp3_11 = tmp3_11 * s1_487;
    // Op 488: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 489: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 490: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 491: dim3x3 mul
    gl64_t s1_491_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_491_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_491_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA491 = (tmp3_0 + tmp3_1) * (s1_491_0 + s1_491_1);
    gl64_t kB491 = (tmp3_0 + tmp3_2) * (s1_491_0 + s1_491_2);
    gl64_t kC491 = (tmp3_1 + tmp3_2) * (s1_491_1 + s1_491_2);
    gl64_t kD491 = tmp3_0 * s1_491_0;
    gl64_t kE491 = tmp3_1 * s1_491_1;
    gl64_t kF491 = tmp3_2 * s1_491_2;
    gl64_t kG491 = kD491 - kE491;
    tmp3_12 = (kC491 + kG491) - kF491;
    tmp3_13 = ((((kA491 + kC491) - kE491) - kE491) - kD491);
    tmp3_14 = kB491 - kG491;
    // Op 492: dim3x1 mul
    gl64_t s0_492_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_492_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_492_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_492 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp3_0 = s0_492_0 * s1_492; tmp3_1 = s0_492_1 * s1_492; tmp3_2 = s0_492_2 * s1_492;
    // Op 493: dim3x1 add
    gl64_t s1_493 = *(gl64_t*)&expressions_params[9][2];
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
    gl64_t s1_495 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_495; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 496: dim3x3 add
    gl64_t s1_496_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_496_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_496_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_496_0; tmp3_4 = tmp3_10 + s1_496_1; tmp3_5 = tmp3_11 + s1_496_2;
    // Op 497: dim3x1 mul
    gl64_t s0_497_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_497_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_497_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_497 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp3_0 = s0_497_0 * s1_497; tmp3_1 = s0_497_1 * s1_497; tmp3_2 = s0_497_2 * s1_497;
    // Op 498: dim3x1 add
    gl64_t s1_498 = *(gl64_t*)&expressions_params[9][2];
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
    // Op 500: dim3x1 add
    gl64_t s1_500 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_0 + s1_500; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 501: dim3x3 add
    gl64_t s1_501_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_501_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_501_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_501_0; tmp3_1 = tmp3_7 + s1_501_1; tmp3_2 = tmp3_8 + s1_501_2;
    // Op 502: dim3x3 mul
    gl64_t kA502 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB502 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC502 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD502 = tmp3_3 * tmp3_0;
    gl64_t kE502 = tmp3_4 * tmp3_1;
    gl64_t kF502 = tmp3_5 * tmp3_2;
    gl64_t kG502 = kD502 - kE502;
    tmp3_0 = (kC502 + kG502) - kF502;
    tmp3_1 = ((((kA502 + kC502) - kE502) - kE502) - kD502);
    tmp3_2 = kB502 - kG502;
    // Op 503: dim3x3 mul
    uint64_t s0_503_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_503_0 = *(gl64_t*)&dParams->aux_trace[s0_503_pos];
    gl64_t s0_503_1 = *(gl64_t*)&dParams->aux_trace[s0_503_pos + TILE_HEIGHT];
    gl64_t s0_503_2 = *(gl64_t*)&dParams->aux_trace[s0_503_pos + 2*TILE_HEIGHT];
    gl64_t kA503 = (s0_503_0 + s0_503_1) * (tmp3_0 + tmp3_1);
    gl64_t kB503 = (s0_503_0 + s0_503_2) * (tmp3_0 + tmp3_2);
    gl64_t kC503 = (s0_503_1 + s0_503_2) * (tmp3_1 + tmp3_2);
    gl64_t kD503 = s0_503_0 * tmp3_0;
    gl64_t kE503 = s0_503_1 * tmp3_1;
    gl64_t kF503 = s0_503_2 * tmp3_2;
    gl64_t kG503 = kD503 - kE503;
    tmp3_0 = (kC503 + kG503) - kF503;
    tmp3_1 = ((((kA503 + kC503) - kE503) - kE503) - kD503);
    tmp3_2 = kB503 - kG503;
    // Op 504: dim3x3 add
    gl64_t s1_504_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_504_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_504_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_504_0; tmp3_7 = tmp3_7 + s1_504_1; tmp3_8 = tmp3_8 + s1_504_2;
    // Op 505: dim3x1 mul
    gl64_t s1_505 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_6 * s1_505; tmp3_7 = tmp3_7 * s1_505; tmp3_8 = tmp3_8 * s1_505;
    // Op 506: dim3x3 add
    gl64_t s1_506_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_506_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_506_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_506_0; tmp3_10 = tmp3_10 + s1_506_1; tmp3_11 = tmp3_11 + s1_506_2;
    // Op 507: dim3x1 mul
    gl64_t s1_507 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_9 * s1_507; tmp3_10 = tmp3_10 * s1_507; tmp3_11 = tmp3_11 * s1_507;
    // Op 508: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 509: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 510: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 511: dim3x3 mul
    gl64_t s1_511_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_511_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_511_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA511 = (tmp3_0 + tmp3_1) * (s1_511_0 + s1_511_1);
    gl64_t kB511 = (tmp3_0 + tmp3_2) * (s1_511_0 + s1_511_2);
    gl64_t kC511 = (tmp3_1 + tmp3_2) * (s1_511_1 + s1_511_2);
    gl64_t kD511 = tmp3_0 * s1_511_0;
    gl64_t kE511 = tmp3_1 * s1_511_1;
    gl64_t kF511 = tmp3_2 * s1_511_2;
    gl64_t kG511 = kD511 - kE511;
    tmp3_3 = (kC511 + kG511) - kF511;
    tmp3_4 = ((((kA511 + kC511) - kE511) - kE511) - kD511);
    tmp3_5 = kB511 - kG511;
    // Op 512: dim3x1 mul
    gl64_t s0_512_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_512_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_512_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_512 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 43, domainSize, nCols_1))];
    tmp3_0 = s0_512_0 * s1_512; tmp3_1 = s0_512_1 * s1_512; tmp3_2 = s0_512_2 * s1_512;
    // Op 513: dim3x1 add
    gl64_t s1_513 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 42, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_513; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 514: dim3x3 mul
    gl64_t s1_514_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_514_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_514_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA514 = (tmp3_0 + tmp3_1) * (s1_514_0 + s1_514_1);
    gl64_t kB514 = (tmp3_0 + tmp3_2) * (s1_514_0 + s1_514_2);
    gl64_t kC514 = (tmp3_1 + tmp3_2) * (s1_514_1 + s1_514_2);
    gl64_t kD514 = tmp3_0 * s1_514_0;
    gl64_t kE514 = tmp3_1 * s1_514_1;
    gl64_t kF514 = tmp3_2 * s1_514_2;
    gl64_t kG514 = kD514 - kE514;
    tmp3_0 = (kC514 + kG514) - kF514;
    tmp3_1 = ((((kA514 + kC514) - kE514) - kE514) - kD514);
    tmp3_2 = kB514 - kG514;
    // Op 515: dim1x1 mul
    gl64_t s0_515 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_515 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_515 * s1_515;
    // Op 516: dim1x1 add
    gl64_t s0_516 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_516 + tmp1_0;
    // Op 517: dim1x1 mul
    gl64_t s0_517 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_517 = *(gl64_t*)&expressions_params[9][6];
    tmp1_2 = s0_517 * s1_517;
    // Op 518: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 519: dim1x1 mul
    gl64_t s0_519 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_519 = *(gl64_t*)&expressions_params[9][7];
    tmp1_2 = s0_519 * s1_519;
    // Op 520: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 521: dim1x1 mul
    gl64_t s0_521 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_521 = *(gl64_t*)&expressions_params[9][8];
    tmp1_2 = s0_521 * s1_521;
    // Op 522: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 523: dim1x1 mul
    gl64_t s0_523 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_523 = *(gl64_t*)&expressions_params[9][9];
    tmp1_2 = s0_523 * s1_523;
    // Op 524: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 525: dim1x1 mul
    gl64_t s0_525 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    gl64_t s1_525 = *(gl64_t*)&expressions_params[9][10];
    tmp1_2 = s0_525 * s1_525;
    // Op 526: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 527: dim1x1 mul
    gl64_t s0_527 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    gl64_t s1_527 = *(gl64_t*)&expressions_params[9][11];
    tmp1_2 = s0_527 * s1_527;
    // Op 528: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 529: dim1x1 mul
    gl64_t s0_529 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_1))];
    gl64_t s1_529 = *(gl64_t*)&expressions_params[9][12];
    tmp1_2 = s0_529 * s1_529;
    // Op 530: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 531: dim1x1 mul
    gl64_t s0_531 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    gl64_t s1_531 = *(gl64_t*)&expressions_params[9][13];
    tmp1_2 = s0_531 * s1_531;
    // Op 532: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 533: dim1x1 mul
    gl64_t s0_533 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    gl64_t s1_533 = *(gl64_t*)&expressions_params[9][14];
    tmp1_2 = s0_533 * s1_533;
    // Op 534: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 535: dim1x1 mul
    gl64_t s0_535 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_1))];
    gl64_t s1_535 = *(gl64_t*)&expressions_params[9][15];
    tmp1_2 = s0_535 * s1_535;
    // Op 536: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 537: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 538: dim3x3 mul
    gl64_t s1_538_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_538_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_538_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA538 = (tmp3_0 + tmp3_1) * (s1_538_0 + s1_538_1);
    gl64_t kB538 = (tmp3_0 + tmp3_2) * (s1_538_0 + s1_538_2);
    gl64_t kC538 = (tmp3_1 + tmp3_2) * (s1_538_1 + s1_538_2);
    gl64_t kD538 = tmp3_0 * s1_538_0;
    gl64_t kE538 = tmp3_1 * s1_538_1;
    gl64_t kF538 = tmp3_2 * s1_538_2;
    gl64_t kG538 = kD538 - kE538;
    tmp3_0 = (kC538 + kG538) - kF538;
    tmp3_1 = ((((kA538 + kC538) - kE538) - kE538) - kD538);
    tmp3_2 = kB538 - kG538;
    // Op 539: dim3x1 add
    gl64_t s1_539 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 39, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_539; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 540: dim3x3 mul
    gl64_t s1_540_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_540_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_540_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 541: dim3x1 add
    gl64_t s1_541 = *(gl64_t*)&expressions_params[9][16];
    tmp3_9 = tmp3_0 + s1_541; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 542: dim3x3 add
    gl64_t s1_542_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_542_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_542_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_542_0; tmp3_13 = tmp3_10 + s1_542_1; tmp3_14 = tmp3_11 + s1_542_2;
    // Op 543: dim3x1 mul
    gl64_t s0_543_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_543_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_543_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_543 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp3_0 = s0_543_0 * s1_543; tmp3_1 = s0_543_1 * s1_543; tmp3_2 = s0_543_2 * s1_543;
    // Op 544: dim1x1 add
    gl64_t s0_544 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 42, domainSize, nCols_1))];
    gl64_t s1_544 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_544 + s1_544;
    // Op 545: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_547 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_0 + s1_547; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 548: dim3x3 add
    gl64_t s1_548_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_548_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_548_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_548_0; tmp3_1 = tmp3_7 + s1_548_1; tmp3_2 = tmp3_8 + s1_548_2;
    // Op 549: dim3x3 mul
    gl64_t kA549 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB549 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC549 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD549 = tmp3_12 * tmp3_0;
    gl64_t kE549 = tmp3_13 * tmp3_1;
    gl64_t kF549 = tmp3_14 * tmp3_2;
    gl64_t kG549 = kD549 - kE549;
    tmp3_0 = (kC549 + kG549) - kF549;
    tmp3_1 = ((((kA549 + kC549) - kE549) - kE549) - kD549);
    tmp3_2 = kB549 - kG549;
    // Op 550: dim3x3 mul
    uint64_t s0_550_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_550_0 = *(gl64_t*)&dParams->aux_trace[s0_550_pos];
    gl64_t s0_550_1 = *(gl64_t*)&dParams->aux_trace[s0_550_pos + TILE_HEIGHT];
    gl64_t s0_550_2 = *(gl64_t*)&dParams->aux_trace[s0_550_pos + 2*TILE_HEIGHT];
    gl64_t kA550 = (s0_550_0 + s0_550_1) * (tmp3_0 + tmp3_1);
    gl64_t kB550 = (s0_550_0 + s0_550_2) * (tmp3_0 + tmp3_2);
    gl64_t kC550 = (s0_550_1 + s0_550_2) * (tmp3_1 + tmp3_2);
    gl64_t kD550 = s0_550_0 * tmp3_0;
    gl64_t kE550 = s0_550_1 * tmp3_1;
    gl64_t kF550 = s0_550_2 * tmp3_2;
    gl64_t kG550 = kD550 - kE550;
    tmp3_0 = (kC550 + kG550) - kF550;
    tmp3_1 = ((((kA550 + kC550) - kE550) - kE550) - kD550);
    tmp3_2 = kB550 - kG550;
    // Op 551: dim3x3 add
    gl64_t s1_551_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_551_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_551_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_551_0; tmp3_7 = tmp3_7 + s1_551_1; tmp3_8 = tmp3_8 + s1_551_2;
    // Op 552: dim3x1 mul
    gl64_t s1_552 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_6 * s1_552; tmp3_7 = tmp3_7 * s1_552; tmp3_8 = tmp3_8 * s1_552;
    // Op 553: dim3x3 add
    gl64_t s1_553_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_553_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_553_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_553_0; tmp3_10 = tmp3_10 + s1_553_1; tmp3_11 = tmp3_11 + s1_553_2;
    // Op 554: dim3x1 mul
    gl64_t s1_554 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_9 * s1_554; tmp3_10 = tmp3_10 * s1_554; tmp3_11 = tmp3_11 * s1_554;
    // Op 555: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 556: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 557: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 558: dim3x3 mul
    gl64_t s1_558_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_558_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_558_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA558 = (tmp3_0 + tmp3_1) * (s1_558_0 + s1_558_1);
    gl64_t kB558 = (tmp3_0 + tmp3_2) * (s1_558_0 + s1_558_2);
    gl64_t kC558 = (tmp3_1 + tmp3_2) * (s1_558_1 + s1_558_2);
    gl64_t kD558 = tmp3_0 * s1_558_0;
    gl64_t kE558 = tmp3_1 * s1_558_1;
    gl64_t kF558 = tmp3_2 * s1_558_2;
    gl64_t kG558 = kD558 - kE558;
    tmp3_12 = (kC558 + kG558) - kF558;
    tmp3_13 = ((((kA558 + kC558) - kE558) - kE558) - kD558);
    tmp3_14 = kB558 - kG558;
    // Op 559: dim3x1 mul
    gl64_t s0_559_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_559_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_559_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_559 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp3_0 = s0_559_0 * s1_559; tmp3_1 = s0_559_1 * s1_559; tmp3_2 = s0_559_2 * s1_559;
    // Op 560: dim1x1 add
    gl64_t s0_560 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 42, domainSize, nCols_1))];
    gl64_t s1_560 = *(gl64_t*)&expressions_params[9][17];
    tmp1_0 = s0_560 + s1_560;
    // Op 561: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 562: dim3x3 mul
    gl64_t s1_562_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_562_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_562_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA562 = (tmp3_0 + tmp3_1) * (s1_562_0 + s1_562_1);
    gl64_t kB562 = (tmp3_0 + tmp3_2) * (s1_562_0 + s1_562_2);
    gl64_t kC562 = (tmp3_1 + tmp3_2) * (s1_562_1 + s1_562_2);
    gl64_t kD562 = tmp3_0 * s1_562_0;
    gl64_t kE562 = tmp3_1 * s1_562_1;
    gl64_t kF562 = tmp3_2 * s1_562_2;
    gl64_t kG562 = kD562 - kE562;
    tmp3_0 = (kC562 + kG562) - kF562;
    tmp3_1 = ((((kA562 + kC562) - kE562) - kE562) - kD562);
    tmp3_2 = kB562 - kG562;
    // Op 563: dim3x1 add
    gl64_t s1_563 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_563; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 564: dim3x3 add
    gl64_t s1_564_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_564_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_564_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_564_0; tmp3_4 = tmp3_10 + s1_564_1; tmp3_5 = tmp3_11 + s1_564_2;
    // Op 565: dim3x1 mul
    gl64_t s0_565_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_565_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_565_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_565 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp3_0 = s0_565_0 * s1_565; tmp3_1 = s0_565_1 * s1_565; tmp3_2 = s0_565_2 * s1_565;
    // Op 566: dim1x1 add
    gl64_t s0_566 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 43, domainSize, nCols_1))];
    gl64_t s1_566 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_566 + s1_566;
    // Op 567: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 568: dim3x3 mul
    gl64_t s1_568_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_568_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_568_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    gl64_t s1_569 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_0 + s1_569; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 570: dim3x3 add
    gl64_t s1_570_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_570_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_570_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_570_0; tmp3_1 = tmp3_7 + s1_570_1; tmp3_2 = tmp3_8 + s1_570_2;
    // Op 571: dim3x3 mul
    gl64_t kA571 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB571 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC571 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD571 = tmp3_3 * tmp3_0;
    gl64_t kE571 = tmp3_4 * tmp3_1;
    gl64_t kF571 = tmp3_5 * tmp3_2;
    gl64_t kG571 = kD571 - kE571;
    tmp3_0 = (kC571 + kG571) - kF571;
    tmp3_1 = ((((kA571 + kC571) - kE571) - kE571) - kD571);
    tmp3_2 = kB571 - kG571;
    // Op 572: dim3x3 mul
    gl64_t s0_572_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_572_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_572_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    gl64_t kA572 = (s0_572_0 + s0_572_1) * (tmp3_0 + tmp3_1);
    gl64_t kB572 = (s0_572_0 + s0_572_2) * (tmp3_0 + tmp3_2);
    gl64_t kC572 = (s0_572_1 + s0_572_2) * (tmp3_1 + tmp3_2);
    gl64_t kD572 = s0_572_0 * tmp3_0;
    gl64_t kE572 = s0_572_1 * tmp3_1;
    gl64_t kF572 = s0_572_2 * tmp3_2;
    gl64_t kG572 = kD572 - kE572;
    tmp3_0 = (kC572 + kG572) - kF572;
    tmp3_1 = ((((kA572 + kC572) - kE572) - kE572) - kD572);
    tmp3_2 = kB572 - kG572;
    // Op 573: dim3x3 add
    gl64_t s1_573_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_573_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_573_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_573_0; tmp3_7 = tmp3_7 + s1_573_1; tmp3_8 = tmp3_8 + s1_573_2;
    // Op 574: dim3x1 mul
    gl64_t s1_574 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_6 * s1_574; tmp3_7 = tmp3_7 * s1_574; tmp3_8 = tmp3_8 * s1_574;
    // Op 575: dim3x3 add
    gl64_t s1_575_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_575_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_575_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_575_0; tmp3_10 = tmp3_10 + s1_575_1; tmp3_11 = tmp3_11 + s1_575_2;
    // Op 576: dim3x1 mul
    gl64_t s1_576 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_9 * s1_576; tmp3_10 = tmp3_10 * s1_576; tmp3_11 = tmp3_11 * s1_576;
    // Op 577: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 578: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 579: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 580: dim3x3 mul
    gl64_t s1_580_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_580_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_580_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA580 = (tmp3_0 + tmp3_1) * (s1_580_0 + s1_580_1);
    gl64_t kB580 = (tmp3_0 + tmp3_2) * (s1_580_0 + s1_580_2);
    gl64_t kC580 = (tmp3_1 + tmp3_2) * (s1_580_1 + s1_580_2);
    gl64_t kD580 = tmp3_0 * s1_580_0;
    gl64_t kE580 = tmp3_1 * s1_580_1;
    gl64_t kF580 = tmp3_2 * s1_580_2;
    gl64_t kG580 = kD580 - kE580;
    tmp3_3 = (kC580 + kG580) - kF580;
    tmp3_4 = ((((kA580 + kC580) - kE580) - kE580) - kD580);
    tmp3_5 = kB580 - kG580;
    // Op 581: dim3x1 mul
    gl64_t s0_581_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_581_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_581_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_581 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp3_0 = s0_581_0 * s1_581; tmp3_1 = s0_581_1 * s1_581; tmp3_2 = s0_581_2 * s1_581;
    // Op 582: dim1x1 add
    gl64_t s0_582 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 43, domainSize, nCols_1))];
    gl64_t s1_582 = *(gl64_t*)&expressions_params[9][17];
    tmp1_0 = s0_582 + s1_582;
    // Op 583: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 584: dim3x3 mul
    gl64_t s1_584_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_584_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_584_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA584 = (tmp3_0 + tmp3_1) * (s1_584_0 + s1_584_1);
    gl64_t kB584 = (tmp3_0 + tmp3_2) * (s1_584_0 + s1_584_2);
    gl64_t kC584 = (tmp3_1 + tmp3_2) * (s1_584_1 + s1_584_2);
    gl64_t kD584 = tmp3_0 * s1_584_0;
    gl64_t kE584 = tmp3_1 * s1_584_1;
    gl64_t kF584 = tmp3_2 * s1_584_2;
    gl64_t kG584 = kD584 - kE584;
    tmp3_0 = (kC584 + kG584) - kF584;
    tmp3_1 = ((((kA584 + kC584) - kE584) - kE584) - kD584);
    tmp3_2 = kB584 - kG584;
    // Op 585: dim3x1 add
    gl64_t s1_585 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_585; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 586: dim3x3 add
    gl64_t s1_586_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_586_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_586_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_586_0; tmp3_13 = tmp3_10 + s1_586_1; tmp3_14 = tmp3_11 + s1_586_2;
    // Op 587: dim3x1 mul
    gl64_t s0_587_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_587_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_587_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_587 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp3_0 = s0_587_0 * s1_587; tmp3_1 = s0_587_1 * s1_587; tmp3_2 = s0_587_2 * s1_587;
    // Op 588: dim3x1 add
    gl64_t s1_588 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 42, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_588; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 589: dim3x3 mul
    gl64_t s1_589_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_589_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_589_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA589 = (tmp3_0 + tmp3_1) * (s1_589_0 + s1_589_1);
    gl64_t kB589 = (tmp3_0 + tmp3_2) * (s1_589_0 + s1_589_2);
    gl64_t kC589 = (tmp3_1 + tmp3_2) * (s1_589_1 + s1_589_2);
    gl64_t kD589 = tmp3_0 * s1_589_0;
    gl64_t kE589 = tmp3_1 * s1_589_1;
    gl64_t kF589 = tmp3_2 * s1_589_2;
    gl64_t kG589 = kD589 - kE589;
    tmp3_0 = (kC589 + kG589) - kF589;
    tmp3_1 = ((((kA589 + kC589) - kE589) - kE589) - kD589);
    tmp3_2 = kB589 - kG589;
    // Op 590: dim3x1 add
    gl64_t s1_590 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_0 + s1_590; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 591: dim3x3 add
    gl64_t s1_591_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_591_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_591_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_591_0; tmp3_1 = tmp3_7 + s1_591_1; tmp3_2 = tmp3_8 + s1_591_2;
    // Op 592: dim3x3 mul
    gl64_t kA592 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB592 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC592 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD592 = tmp3_12 * tmp3_0;
    gl64_t kE592 = tmp3_13 * tmp3_1;
    gl64_t kF592 = tmp3_14 * tmp3_2;
    gl64_t kG592 = kD592 - kE592;
    tmp3_0 = (kC592 + kG592) - kF592;
    tmp3_1 = ((((kA592 + kC592) - kE592) - kE592) - kD592);
    tmp3_2 = kB592 - kG592;
    // Op 593: dim3x3 mul
    gl64_t s0_593_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+0, domainSize, nCols_2))];
    gl64_t s0_593_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+1, domainSize, nCols_2))];
    gl64_t s0_593_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+2, domainSize, nCols_2))];
    gl64_t kA593 = (s0_593_0 + s0_593_1) * (tmp3_0 + tmp3_1);
    gl64_t kB593 = (s0_593_0 + s0_593_2) * (tmp3_0 + tmp3_2);
    gl64_t kC593 = (s0_593_1 + s0_593_2) * (tmp3_1 + tmp3_2);
    gl64_t kD593 = s0_593_0 * tmp3_0;
    gl64_t kE593 = s0_593_1 * tmp3_1;
    gl64_t kF593 = s0_593_2 * tmp3_2;
    gl64_t kG593 = kD593 - kE593;
    tmp3_0 = (kC593 + kG593) - kF593;
    tmp3_1 = ((((kA593 + kC593) - kE593) - kE593) - kD593);
    tmp3_2 = kB593 - kG593;
    // Op 594: dim3x3 add
    gl64_t s1_594_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_594_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_594_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_594_0; tmp3_7 = tmp3_7 + s1_594_1; tmp3_8 = tmp3_8 + s1_594_2;
    // Op 595: dim3x1 mul
    gl64_t s1_595 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_6 * s1_595; tmp3_7 = tmp3_7 * s1_595; tmp3_8 = tmp3_8 * s1_595;
    // Op 596: dim3x3 add
    gl64_t s1_596_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_596_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_596_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_596_0; tmp3_10 = tmp3_10 + s1_596_1; tmp3_11 = tmp3_11 + s1_596_2;
    // Op 597: dim3x1 mul
    gl64_t s1_597 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_9 * s1_597; tmp3_10 = tmp3_10 * s1_597; tmp3_11 = tmp3_11 * s1_597;
    // Op 598: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 599: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 600: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 601: dim3x3 mul
    gl64_t s1_601_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_601_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_601_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA601 = (tmp3_0 + tmp3_1) * (s1_601_0 + s1_601_1);
    gl64_t kB601 = (tmp3_0 + tmp3_2) * (s1_601_0 + s1_601_2);
    gl64_t kC601 = (tmp3_1 + tmp3_2) * (s1_601_1 + s1_601_2);
    gl64_t kD601 = tmp3_0 * s1_601_0;
    gl64_t kE601 = tmp3_1 * s1_601_1;
    gl64_t kF601 = tmp3_2 * s1_601_2;
    gl64_t kG601 = kD601 - kE601;
    tmp3_12 = (kC601 + kG601) - kF601;
    tmp3_13 = ((((kA601 + kC601) - kE601) - kE601) - kD601);
    tmp3_14 = kB601 - kG601;
    // Op 602: dim3x1 mul
    gl64_t s0_602_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_602_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_602_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_602 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp3_0 = s0_602_0 * s1_602; tmp3_1 = s0_602_1 * s1_602; tmp3_2 = s0_602_2 * s1_602;
    // Op 603: dim1x1 add
    gl64_t s0_603 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 42, domainSize, nCols_1))];
    gl64_t s1_603 = *(gl64_t*)&expressions_params[9][18];
    tmp1_0 = s0_603 + s1_603;
    // Op 604: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 605: dim3x3 mul
    gl64_t s1_605_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_605_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_605_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA605 = (tmp3_0 + tmp3_1) * (s1_605_0 + s1_605_1);
    gl64_t kB605 = (tmp3_0 + tmp3_2) * (s1_605_0 + s1_605_2);
    gl64_t kC605 = (tmp3_1 + tmp3_2) * (s1_605_1 + s1_605_2);
    gl64_t kD605 = tmp3_0 * s1_605_0;
    gl64_t kE605 = tmp3_1 * s1_605_1;
    gl64_t kF605 = tmp3_2 * s1_605_2;
    gl64_t kG605 = kD605 - kE605;
    tmp3_0 = (kC605 + kG605) - kF605;
    tmp3_1 = ((((kA605 + kC605) - kE605) - kE605) - kD605);
    tmp3_2 = kB605 - kG605;
    // Op 606: dim3x1 add
    gl64_t s1_606 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_606; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 607: dim3x3 add
    gl64_t s1_607_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_607_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_607_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_607_0; tmp3_4 = tmp3_10 + s1_607_1; tmp3_5 = tmp3_11 + s1_607_2;
    // Op 608: dim3x1 mul
    gl64_t s0_608_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_608_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_608_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_608 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp3_0 = s0_608_0 * s1_608; tmp3_1 = s0_608_1 * s1_608; tmp3_2 = s0_608_2 * s1_608;
    // Op 609: dim3x1 add
    gl64_t s1_609 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 43, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_609; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 610: dim3x3 mul
    gl64_t s1_610_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_610_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_610_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    gl64_t s1_611 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_0 + s1_611; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 612: dim3x3 add
    gl64_t s1_612_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_612_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_612_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_612_0; tmp3_1 = tmp3_7 + s1_612_1; tmp3_2 = tmp3_8 + s1_612_2;
    // Op 613: dim3x3 mul
    gl64_t kA613 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB613 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC613 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD613 = tmp3_3 * tmp3_0;
    gl64_t kE613 = tmp3_4 * tmp3_1;
    gl64_t kF613 = tmp3_5 * tmp3_2;
    gl64_t kG613 = kD613 - kE613;
    tmp3_0 = (kC613 + kG613) - kF613;
    tmp3_1 = ((((kA613 + kC613) - kE613) - kE613) - kD613);
    tmp3_2 = kB613 - kG613;
    // Op 614: dim3x3 mul
    uint64_t s0_614_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_2));
    gl64_t s0_614_0 = *(gl64_t*)&dParams->aux_trace[s0_614_pos];
    gl64_t s0_614_1 = *(gl64_t*)&dParams->aux_trace[s0_614_pos + TILE_HEIGHT];
    gl64_t s0_614_2 = *(gl64_t*)&dParams->aux_trace[s0_614_pos + 2*TILE_HEIGHT];
    gl64_t kA614 = (s0_614_0 + s0_614_1) * (tmp3_0 + tmp3_1);
    gl64_t kB614 = (s0_614_0 + s0_614_2) * (tmp3_0 + tmp3_2);
    gl64_t kC614 = (s0_614_1 + s0_614_2) * (tmp3_1 + tmp3_2);
    gl64_t kD614 = s0_614_0 * tmp3_0;
    gl64_t kE614 = s0_614_1 * tmp3_1;
    gl64_t kF614 = s0_614_2 * tmp3_2;
    gl64_t kG614 = kD614 - kE614;
    tmp3_0 = (kC614 + kG614) - kF614;
    tmp3_1 = ((((kA614 + kC614) - kE614) - kE614) - kD614);
    tmp3_2 = kB614 - kG614;
    // Op 615: dim3x3 add
    gl64_t s1_615_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_615_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_615_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_615_0; tmp3_7 = tmp3_7 + s1_615_1; tmp3_8 = tmp3_8 + s1_615_2;
    // Op 616: dim3x1 mul
    gl64_t s1_616 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_6 * s1_616; tmp3_7 = tmp3_7 * s1_616; tmp3_8 = tmp3_8 * s1_616;
    // Op 617: dim3x3 add
    gl64_t s1_617_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_617_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_617_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_617_0; tmp3_10 = tmp3_10 + s1_617_1; tmp3_11 = tmp3_11 + s1_617_2;
    // Op 618: dim3x1 mul
    gl64_t s1_618 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_9 * s1_618; tmp3_10 = tmp3_10 * s1_618; tmp3_11 = tmp3_11 * s1_618;
    // Op 619: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 620: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 621: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 622: dim3x3 mul
    gl64_t s1_622_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_622_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_622_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA622 = (tmp3_0 + tmp3_1) * (s1_622_0 + s1_622_1);
    gl64_t kB622 = (tmp3_0 + tmp3_2) * (s1_622_0 + s1_622_2);
    gl64_t kC622 = (tmp3_1 + tmp3_2) * (s1_622_1 + s1_622_2);
    gl64_t kD622 = tmp3_0 * s1_622_0;
    gl64_t kE622 = tmp3_1 * s1_622_1;
    gl64_t kF622 = tmp3_2 * s1_622_2;
    gl64_t kG622 = kD622 - kE622;
    tmp3_3 = (kC622 + kG622) - kF622;
    tmp3_4 = ((((kA622 + kC622) - kE622) - kE622) - kD622);
    tmp3_5 = kB622 - kG622;
    // Op 623: dim3x1 mul
    gl64_t s0_623_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_623_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_623_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_623 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp3_0 = s0_623_0 * s1_623; tmp3_1 = s0_623_1 * s1_623; tmp3_2 = s0_623_2 * s1_623;
    // Op 624: dim1x1 add
    gl64_t s0_624 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 43, domainSize, nCols_1))];
    gl64_t s1_624 = *(gl64_t*)&expressions_params[9][18];
    tmp1_0 = s0_624 + s1_624;
    // Op 625: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 626: dim3x3 mul
    gl64_t s1_626_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_626_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_626_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA626 = (tmp3_0 + tmp3_1) * (s1_626_0 + s1_626_1);
    gl64_t kB626 = (tmp3_0 + tmp3_2) * (s1_626_0 + s1_626_2);
    gl64_t kC626 = (tmp3_1 + tmp3_2) * (s1_626_1 + s1_626_2);
    gl64_t kD626 = tmp3_0 * s1_626_0;
    gl64_t kE626 = tmp3_1 * s1_626_1;
    gl64_t kF626 = tmp3_2 * s1_626_2;
    gl64_t kG626 = kD626 - kE626;
    tmp3_0 = (kC626 + kG626) - kF626;
    tmp3_1 = ((((kA626 + kC626) - kE626) - kE626) - kD626);
    tmp3_2 = kB626 - kG626;
    // Op 627: dim3x1 add
    gl64_t s1_627 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_627; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 628: dim3x3 add
    gl64_t s1_628_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_628_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_628_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_628_0; tmp3_13 = tmp3_10 + s1_628_1; tmp3_14 = tmp3_11 + s1_628_2;
    // Op 629: dim3x1 mul
    gl64_t s0_629_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_629_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_629_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_629 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp3_0 = s0_629_0 * s1_629; tmp3_1 = s0_629_1 * s1_629; tmp3_2 = s0_629_2 * s1_629;
    // Op 630: dim3x3 mul
    gl64_t s1_630_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_630_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_630_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 631: dim3x1 add
    gl64_t s1_631 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_0 + s1_631; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 632: dim3x3 add
    gl64_t s1_632_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_632_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_632_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_632_0; tmp3_1 = tmp3_7 + s1_632_1; tmp3_2 = tmp3_8 + s1_632_2;
    // Op 633: dim3x3 mul
    gl64_t kA633 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB633 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC633 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD633 = tmp3_12 * tmp3_0;
    gl64_t kE633 = tmp3_13 * tmp3_1;
    gl64_t kF633 = tmp3_14 * tmp3_2;
    gl64_t kG633 = kD633 - kE633;
    tmp3_0 = (kC633 + kG633) - kF633;
    tmp3_1 = ((((kA633 + kC633) - kE633) - kE633) - kD633);
    tmp3_2 = kB633 - kG633;
    // Op 634: dim3x3 mul
    uint64_t s0_634_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_2));
    gl64_t s0_634_0 = *(gl64_t*)&dParams->aux_trace[s0_634_pos];
    gl64_t s0_634_1 = *(gl64_t*)&dParams->aux_trace[s0_634_pos + TILE_HEIGHT];
    gl64_t s0_634_2 = *(gl64_t*)&dParams->aux_trace[s0_634_pos + 2*TILE_HEIGHT];
    gl64_t kA634 = (s0_634_0 + s0_634_1) * (tmp3_0 + tmp3_1);
    gl64_t kB634 = (s0_634_0 + s0_634_2) * (tmp3_0 + tmp3_2);
    gl64_t kC634 = (s0_634_1 + s0_634_2) * (tmp3_1 + tmp3_2);
    gl64_t kD634 = s0_634_0 * tmp3_0;
    gl64_t kE634 = s0_634_1 * tmp3_1;
    gl64_t kF634 = s0_634_2 * tmp3_2;
    gl64_t kG634 = kD634 - kE634;
    tmp3_0 = (kC634 + kG634) - kF634;
    tmp3_1 = ((((kA634 + kC634) - kE634) - kE634) - kD634);
    tmp3_2 = kB634 - kG634;
    // Op 635: dim3x3 add
    gl64_t s1_635_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_635_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_635_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_635_0; tmp3_7 = tmp3_7 + s1_635_1; tmp3_8 = tmp3_8 + s1_635_2;
    // Op 636: dim3x1 mul
    gl64_t s1_636 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_6 * s1_636; tmp3_7 = tmp3_7 * s1_636; tmp3_8 = tmp3_8 * s1_636;
    // Op 637: dim3x3 add
    gl64_t s1_637_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_637_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_637_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_637_0; tmp3_10 = tmp3_10 + s1_637_1; tmp3_11 = tmp3_11 + s1_637_2;
    // Op 638: dim3x1 mul
    gl64_t s1_638 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_9 * s1_638; tmp3_10 = tmp3_10 * s1_638; tmp3_11 = tmp3_11 * s1_638;
    // Op 639: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 640: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 641: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 642: dim3x3 mul
    gl64_t s1_642_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_642_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_642_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA642 = (tmp3_0 + tmp3_1) * (s1_642_0 + s1_642_1);
    gl64_t kB642 = (tmp3_0 + tmp3_2) * (s1_642_0 + s1_642_2);
    gl64_t kC642 = (tmp3_1 + tmp3_2) * (s1_642_1 + s1_642_2);
    gl64_t kD642 = tmp3_0 * s1_642_0;
    gl64_t kE642 = tmp3_1 * s1_642_1;
    gl64_t kF642 = tmp3_2 * s1_642_2;
    gl64_t kG642 = kD642 - kE642;
    tmp3_12 = (kC642 + kG642) - kF642;
    tmp3_13 = ((((kA642 + kC642) - kE642) - kE642) - kD642);
    tmp3_14 = kB642 - kG642;
    // Op 643: dim3x1 mul
    gl64_t s0_643_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_643_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_643_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_643 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp3_0 = s0_643_0 * s1_643; tmp3_1 = s0_643_1 * s1_643; tmp3_2 = s0_643_2 * s1_643;
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
    gl64_t s1_645 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_645; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 646: dim3x3 add
    gl64_t s1_646_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_646_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_646_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_646_0; tmp3_4 = tmp3_10 + s1_646_1; tmp3_5 = tmp3_11 + s1_646_2;
    // Op 647: dim3x1 mul
    gl64_t s0_647_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_647_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_647_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_647 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp3_0 = s0_647_0 * s1_647; tmp3_1 = s0_647_1 * s1_647; tmp3_2 = s0_647_2 * s1_647;
    // Op 648: dim3x3 mul
    gl64_t s1_648_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_648_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_648_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA648 = (tmp3_0 + tmp3_1) * (s1_648_0 + s1_648_1);
    gl64_t kB648 = (tmp3_0 + tmp3_2) * (s1_648_0 + s1_648_2);
    gl64_t kC648 = (tmp3_1 + tmp3_2) * (s1_648_1 + s1_648_2);
    gl64_t kD648 = tmp3_0 * s1_648_0;
    gl64_t kE648 = tmp3_1 * s1_648_1;
    gl64_t kF648 = tmp3_2 * s1_648_2;
    gl64_t kG648 = kD648 - kE648;
    tmp3_0 = (kC648 + kG648) - kF648;
    tmp3_1 = ((((kA648 + kC648) - kE648) - kE648) - kD648);
    tmp3_2 = kB648 - kG648;
    // Op 649: dim3x1 add
    gl64_t s1_649 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_0 + s1_649; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 650: dim3x3 add
    gl64_t s1_650_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_650_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_650_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_650_0; tmp3_1 = tmp3_7 + s1_650_1; tmp3_2 = tmp3_8 + s1_650_2;
    // Op 651: dim3x3 mul
    gl64_t kA651 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB651 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC651 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD651 = tmp3_3 * tmp3_0;
    gl64_t kE651 = tmp3_4 * tmp3_1;
    gl64_t kF651 = tmp3_5 * tmp3_2;
    gl64_t kG651 = kD651 - kE651;
    tmp3_0 = (kC651 + kG651) - kF651;
    tmp3_1 = ((((kA651 + kC651) - kE651) - kE651) - kD651);
    tmp3_2 = kB651 - kG651;
    // Op 652: dim3x3 mul
    gl64_t s0_652_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+0, domainSize, nCols_2))];
    gl64_t s0_652_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+1, domainSize, nCols_2))];
    gl64_t s0_652_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+2, domainSize, nCols_2))];
    gl64_t kA652 = (s0_652_0 + s0_652_1) * (tmp3_0 + tmp3_1);
    gl64_t kB652 = (s0_652_0 + s0_652_2) * (tmp3_0 + tmp3_2);
    gl64_t kC652 = (s0_652_1 + s0_652_2) * (tmp3_1 + tmp3_2);
    gl64_t kD652 = s0_652_0 * tmp3_0;
    gl64_t kE652 = s0_652_1 * tmp3_1;
    gl64_t kF652 = s0_652_2 * tmp3_2;
    gl64_t kG652 = kD652 - kE652;
    tmp3_0 = (kC652 + kG652) - kF652;
    tmp3_1 = ((((kA652 + kC652) - kE652) - kE652) - kD652);
    tmp3_2 = kB652 - kG652;
    // Op 653: dim3x3 add
    gl64_t s1_653_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_653_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_653_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_653_0; tmp3_7 = tmp3_7 + s1_653_1; tmp3_8 = tmp3_8 + s1_653_2;
    // Op 654: dim3x1 mul
    gl64_t s1_654 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_6 * s1_654; tmp3_7 = tmp3_7 * s1_654; tmp3_8 = tmp3_8 * s1_654;
    // Op 655: dim3x3 add
    gl64_t s1_655_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_655_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_655_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_655_0; tmp3_10 = tmp3_10 + s1_655_1; tmp3_11 = tmp3_11 + s1_655_2;
    // Op 656: dim3x1 mul
    gl64_t s1_656 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_9 * s1_656; tmp3_10 = tmp3_10 * s1_656; tmp3_11 = tmp3_11 * s1_656;
    // Op 657: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 658: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 659: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 660: dim3x3 mul
    gl64_t s1_660_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_660_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_660_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA660 = (tmp3_0 + tmp3_1) * (s1_660_0 + s1_660_1);
    gl64_t kB660 = (tmp3_0 + tmp3_2) * (s1_660_0 + s1_660_2);
    gl64_t kC660 = (tmp3_1 + tmp3_2) * (s1_660_1 + s1_660_2);
    gl64_t kD660 = tmp3_0 * s1_660_0;
    gl64_t kE660 = tmp3_1 * s1_660_1;
    gl64_t kF660 = tmp3_2 * s1_660_2;
    gl64_t kG660 = kD660 - kE660;
    tmp3_3 = (kC660 + kG660) - kF660;
    tmp3_4 = ((((kA660 + kC660) - kE660) - kE660) - kD660);
    tmp3_5 = kB660 - kG660;
    // Op 661: dim3x1 mul
    gl64_t s0_661_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_661_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_661_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_661 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp3_0 = s0_661_0 * s1_661; tmp3_1 = s0_661_1 * s1_661; tmp3_2 = s0_661_2 * s1_661;
    // Op 662: dim3x3 mul
    gl64_t s1_662_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_662_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_662_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA662 = (tmp3_0 + tmp3_1) * (s1_662_0 + s1_662_1);
    gl64_t kB662 = (tmp3_0 + tmp3_2) * (s1_662_0 + s1_662_2);
    gl64_t kC662 = (tmp3_1 + tmp3_2) * (s1_662_1 + s1_662_2);
    gl64_t kD662 = tmp3_0 * s1_662_0;
    gl64_t kE662 = tmp3_1 * s1_662_1;
    gl64_t kF662 = tmp3_2 * s1_662_2;
    gl64_t kG662 = kD662 - kE662;
    tmp3_0 = (kC662 + kG662) - kF662;
    tmp3_1 = ((((kA662 + kC662) - kE662) - kE662) - kD662);
    tmp3_2 = kB662 - kG662;
    // Op 663: dim3x1 add
    gl64_t s1_663 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_663; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 664: dim3x3 add
    gl64_t s1_664_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_664_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_664_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_664_0; tmp3_13 = tmp3_10 + s1_664_1; tmp3_14 = tmp3_11 + s1_664_2;
    // Op 665: dim3x1 mul
    gl64_t s0_665_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_665_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_665_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_665 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp3_0 = s0_665_0 * s1_665; tmp3_1 = s0_665_1 * s1_665; tmp3_2 = s0_665_2 * s1_665;
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
    gl64_t s1_667 = *(gl64_t*)&expressions_params[9][3];
    tmp3_6 = tmp3_0 + s1_667; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 668: dim3x3 add
    gl64_t s1_668_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_668_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_668_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_668_0; tmp3_1 = tmp3_7 + s1_668_1; tmp3_2 = tmp3_8 + s1_668_2;
    // Op 669: dim3x3 mul
    gl64_t kA669 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB669 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC669 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD669 = tmp3_12 * tmp3_0;
    gl64_t kE669 = tmp3_13 * tmp3_1;
    gl64_t kF669 = tmp3_14 * tmp3_2;
    gl64_t kG669 = kD669 - kE669;
    tmp3_0 = (kC669 + kG669) - kF669;
    tmp3_1 = ((((kA669 + kC669) - kE669) - kE669) - kD669);
    tmp3_2 = kB669 - kG669;
    // Op 670: dim3x3 mul
    gl64_t s0_670_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 30+0, domainSize, nCols_2))];
    gl64_t s0_670_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 30+1, domainSize, nCols_2))];
    gl64_t s0_670_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 30+2, domainSize, nCols_2))];
    gl64_t kA670 = (s0_670_0 + s0_670_1) * (tmp3_0 + tmp3_1);
    gl64_t kB670 = (s0_670_0 + s0_670_2) * (tmp3_0 + tmp3_2);
    gl64_t kC670 = (s0_670_1 + s0_670_2) * (tmp3_1 + tmp3_2);
    gl64_t kD670 = s0_670_0 * tmp3_0;
    gl64_t kE670 = s0_670_1 * tmp3_1;
    gl64_t kF670 = s0_670_2 * tmp3_2;
    gl64_t kG670 = kD670 - kE670;
    tmp3_0 = (kC670 + kG670) - kF670;
    tmp3_1 = ((((kA670 + kC670) - kE670) - kE670) - kD670);
    tmp3_2 = kB670 - kG670;
    // Op 671: dim3x3 add
    gl64_t s1_671_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_671_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_671_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_671_0; tmp3_7 = tmp3_7 + s1_671_1; tmp3_8 = tmp3_8 + s1_671_2;
    // Op 672: dim3x1 mul
    gl64_t s1_672 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_6 * s1_672; tmp3_7 = tmp3_7 * s1_672; tmp3_8 = tmp3_8 * s1_672;
    // Op 673: dim3x3 add
    gl64_t s1_673_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_673_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_673_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_673_0; tmp3_10 = tmp3_10 + s1_673_1; tmp3_11 = tmp3_11 + s1_673_2;
    // Op 674: dim3x1 mul
    gl64_t s1_674 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_9 * s1_674; tmp3_10 = tmp3_10 * s1_674; tmp3_11 = tmp3_11 * s1_674;
    // Op 675: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 676: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 677: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
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
    tmp3_12 = (kC678 + kG678) - kF678;
    tmp3_13 = ((((kA678 + kC678) - kE678) - kE678) - kD678);
    tmp3_14 = kB678 - kG678;
    // Op 679: dim3x1 mul
    gl64_t s0_679_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_679_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_679_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_679 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp3_0 = s0_679_0 * s1_679; tmp3_1 = s0_679_1 * s1_679; tmp3_2 = s0_679_2 * s1_679;
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
    gl64_t s1_681 = *(gl64_t*)&expressions_params[9][3];
    tmp3_9 = tmp3_0 + s1_681; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 682: dim3x3 add
    gl64_t s1_682_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_682_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_682_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_682_0; tmp3_4 = tmp3_10 + s1_682_1; tmp3_5 = tmp3_11 + s1_682_2;
    // Op 683: dim3x1 mul
    gl64_t s0_683_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_683_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_683_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_683 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp3_0 = s0_683_0 * s1_683; tmp3_1 = s0_683_1 * s1_683; tmp3_2 = s0_683_2 * s1_683;
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
    tmp3_6 = tmp3_0 + s1_685; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 686: dim3x3 add
    gl64_t s1_686_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_686_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_686_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_686_0; tmp3_1 = tmp3_7 + s1_686_1; tmp3_2 = tmp3_8 + s1_686_2;
    // Op 687: dim3x3 mul
    gl64_t kA687 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB687 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC687 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD687 = tmp3_3 * tmp3_0;
    gl64_t kE687 = tmp3_4 * tmp3_1;
    gl64_t kF687 = tmp3_5 * tmp3_2;
    gl64_t kG687 = kD687 - kE687;
    tmp3_0 = (kC687 + kG687) - kF687;
    tmp3_1 = ((((kA687 + kC687) - kE687) - kE687) - kD687);
    tmp3_2 = kB687 - kG687;
    // Op 688: dim3x3 mul
    uint64_t s0_688_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_2));
    gl64_t s0_688_0 = *(gl64_t*)&dParams->aux_trace[s0_688_pos];
    gl64_t s0_688_1 = *(gl64_t*)&dParams->aux_trace[s0_688_pos + TILE_HEIGHT];
    gl64_t s0_688_2 = *(gl64_t*)&dParams->aux_trace[s0_688_pos + 2*TILE_HEIGHT];
    gl64_t kA688 = (s0_688_0 + s0_688_1) * (tmp3_0 + tmp3_1);
    gl64_t kB688 = (s0_688_0 + s0_688_2) * (tmp3_0 + tmp3_2);
    gl64_t kC688 = (s0_688_1 + s0_688_2) * (tmp3_1 + tmp3_2);
    gl64_t kD688 = s0_688_0 * tmp3_0;
    gl64_t kE688 = s0_688_1 * tmp3_1;
    gl64_t kF688 = s0_688_2 * tmp3_2;
    gl64_t kG688 = kD688 - kE688;
    tmp3_0 = (kC688 + kG688) - kF688;
    tmp3_1 = ((((kA688 + kC688) - kE688) - kE688) - kD688);
    tmp3_2 = kB688 - kG688;
    // Op 689: dim3x3 add
    gl64_t s1_689_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_689_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_689_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_689_0; tmp3_7 = tmp3_7 + s1_689_1; tmp3_8 = tmp3_8 + s1_689_2;
    // Op 690: dim3x1 mul
    gl64_t s1_690 = *(gl64_t*)&expressions_params[9][4];
    tmp3_6 = tmp3_6 * s1_690; tmp3_7 = tmp3_7 * s1_690; tmp3_8 = tmp3_8 * s1_690;
    // Op 691: dim3x3 add
    gl64_t s1_691_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_691_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_691_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_691_0; tmp3_10 = tmp3_10 + s1_691_1; tmp3_11 = tmp3_11 + s1_691_2;
    // Op 692: dim3x1 mul
    gl64_t s1_692 = *(gl64_t*)&expressions_params[9][4];
    tmp3_9 = tmp3_9 * s1_692; tmp3_10 = tmp3_10 * s1_692; tmp3_11 = tmp3_11 * s1_692;
    // Op 693: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 694: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 695: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 696: dim3x3 mul
    gl64_t s1_696_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_696_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_696_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA696 = (tmp3_0 + tmp3_1) * (s1_696_0 + s1_696_1);
    gl64_t kB696 = (tmp3_0 + tmp3_2) * (s1_696_0 + s1_696_2);
    gl64_t kC696 = (tmp3_1 + tmp3_2) * (s1_696_1 + s1_696_2);
    gl64_t kD696 = tmp3_0 * s1_696_0;
    gl64_t kE696 = tmp3_1 * s1_696_1;
    gl64_t kF696 = tmp3_2 * s1_696_2;
    gl64_t kG696 = kD696 - kE696;
    tmp3_12 = (kC696 + kG696) - kF696;
    tmp3_13 = ((((kA696 + kC696) - kE696) - kE696) - kD696);
    tmp3_14 = kB696 - kG696;
    // Op 697: dim3x1 mul
    gl64_t s0_697_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_697_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_697_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_697 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp3_0 = s0_697_0 * s1_697; tmp3_1 = s0_697_1 * s1_697; tmp3_2 = s0_697_2 * s1_697;
    // Op 698: dim3x3 mul
    gl64_t s1_698_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_698_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_698_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA698 = (tmp3_0 + tmp3_1) * (s1_698_0 + s1_698_1);
    gl64_t kB698 = (tmp3_0 + tmp3_2) * (s1_698_0 + s1_698_2);
    gl64_t kC698 = (tmp3_1 + tmp3_2) * (s1_698_1 + s1_698_2);
    gl64_t kD698 = tmp3_0 * s1_698_0;
    gl64_t kE698 = tmp3_1 * s1_698_1;
    gl64_t kF698 = tmp3_2 * s1_698_2;
    gl64_t kG698 = kD698 - kE698;
    tmp3_0 = (kC698 + kG698) - kF698;
    tmp3_1 = ((((kA698 + kC698) - kE698) - kE698) - kD698);
    tmp3_2 = kB698 - kG698;
    // Op 699: dim3x1 add
    gl64_t s1_699 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_699; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 700: dim3x3 add
    gl64_t s1_700_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_700_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_700_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_700_0; tmp3_1 = tmp3_1 + s1_700_1; tmp3_2 = tmp3_2 + s1_700_2;
    // Op 701: dim3x3 mul
    uint64_t s0_701_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_2));
    gl64_t s0_701_0 = *(gl64_t*)&dParams->aux_trace[s0_701_pos];
    gl64_t s0_701_1 = *(gl64_t*)&dParams->aux_trace[s0_701_pos + TILE_HEIGHT];
    gl64_t s0_701_2 = *(gl64_t*)&dParams->aux_trace[s0_701_pos + 2*TILE_HEIGHT];
    gl64_t kA701 = (s0_701_0 + s0_701_1) * (tmp3_0 + tmp3_1);
    gl64_t kB701 = (s0_701_0 + s0_701_2) * (tmp3_0 + tmp3_2);
    gl64_t kC701 = (s0_701_1 + s0_701_2) * (tmp3_1 + tmp3_2);
    gl64_t kD701 = s0_701_0 * tmp3_0;
    gl64_t kE701 = s0_701_1 * tmp3_1;
    gl64_t kF701 = s0_701_2 * tmp3_2;
    gl64_t kG701 = kD701 - kE701;
    tmp3_0 = (kC701 + kG701) - kF701;
    tmp3_1 = ((((kA701 + kC701) - kE701) - kE701) - kD701);
    tmp3_2 = kB701 - kG701;
    // Op 702: dim3x1 add
    gl64_t s1_702 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_702; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 703: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 704: dim3x3 mul
    gl64_t s1_704_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_704_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_704_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA704 = (tmp3_0 + tmp3_1) * (s1_704_0 + s1_704_1);
    gl64_t kB704 = (tmp3_0 + tmp3_2) * (s1_704_0 + s1_704_2);
    gl64_t kC704 = (tmp3_1 + tmp3_2) * (s1_704_1 + s1_704_2);
    gl64_t kD704 = tmp3_0 * s1_704_0;
    gl64_t kE704 = tmp3_1 * s1_704_1;
    gl64_t kF704 = tmp3_2 * s1_704_2;
    gl64_t kG704 = kD704 - kE704;
    tmp3_12 = (kC704 + kG704) - kF704;
    tmp3_13 = ((((kA704 + kC704) - kE704) - kE704) - kD704);
    tmp3_14 = kB704 - kG704;
    // Op 705: dim3x1 mul
    gl64_t s0_705_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_705_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_705_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_705 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    tmp3_0 = s0_705_0 * s1_705; tmp3_1 = s0_705_1 * s1_705; tmp3_2 = s0_705_2 * s1_705;
    // Op 706: dim3x1 add
    gl64_t s1_706 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 40, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_706; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s0_708 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_708 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_708 * s1_708;
    // Op 709: dim1x1 add
    gl64_t s0_709 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_0 = s0_709 + tmp1_0;
    // Op 710: dim1x1 mul
    tmp1_4 = tmp1_4 * tmp1_0;
    // Op 711: dim1x1 mul
    gl64_t s0_711 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    gl64_t s1_711 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_711 * s1_711;
    // Op 712: dim1x1 add
    gl64_t s0_712 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_0 = s0_712 + tmp1_0;
    // Op 713: dim1x1 mul
    gl64_t s0_713 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_1))];
    tmp1_0 = s0_713 * tmp1_0;
    // Op 714: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_0;
    // Op 715: dim1x1 mul
    gl64_t s0_715 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_715 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_715 * s1_715;
    // Op 716: dim1x1 add
    gl64_t s0_716 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_716 + tmp1_0;
    // Op 717: dim1x1 mul
    gl64_t s0_717 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    tmp1_0 = s0_717 * tmp1_0;
    // Op 718: dim1x1 add
    tmp1_0 = tmp1_4 + tmp1_0;
    // Op 719: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 720: dim3x3 mul
    gl64_t s1_720_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_720_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_720_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 721: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_3; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 722: dim3x3 mul
    gl64_t s1_722_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_722_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_722_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA722 = (tmp3_0 + tmp3_1) * (s1_722_0 + s1_722_1);
    gl64_t kB722 = (tmp3_0 + tmp3_2) * (s1_722_0 + s1_722_2);
    gl64_t kC722 = (tmp3_1 + tmp3_2) * (s1_722_1 + s1_722_2);
    gl64_t kD722 = tmp3_0 * s1_722_0;
    gl64_t kE722 = tmp3_1 * s1_722_1;
    gl64_t kF722 = tmp3_2 * s1_722_2;
    gl64_t kG722 = kD722 - kE722;
    tmp3_0 = (kC722 + kG722) - kF722;
    tmp3_1 = ((((kA722 + kC722) - kE722) - kE722) - kD722);
    tmp3_2 = kB722 - kG722;
    // Op 723: dim1x1 mul
    gl64_t s0_723 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_723 = *(gl64_t*)&expressions_params[9][19];
    tmp1_3 = s0_723 * s1_723;
    // Op 724: dim1x1 add
    gl64_t s0_724 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_3 = s0_724 + tmp1_3;
    // Op 725: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_3; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 729: dim1x1 mul
    gl64_t s0_729 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    gl64_t s1_729 = *(gl64_t*)&expressions_params[9][19];
    tmp1_1 = s0_729 * s1_729;
    // Op 730: dim1x1 add
    gl64_t s0_730 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_1 = s0_730 + tmp1_1;
    // Op 731: dim1x1 mul
    gl64_t s0_731 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp1_0 = s0_731 * tmp1_1;
    // Op 732: dim1x1 sub_swap
    gl64_t s0_732 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_732 = *(gl64_t*)&expressions_params[9][1];
    tmp1_3 = s1_732 - s0_732;
    // Op 733: dim1x1 mul
    gl64_t s0_733 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_733 = *(gl64_t*)&expressions_params[9][19];
    tmp1_1 = s0_733 * s1_733;
    // Op 734: dim1x1 add
    gl64_t s0_734 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_1 = s0_734 + tmp1_1;
    // Op 735: dim1x1 mul
    tmp1_1 = tmp1_3 * tmp1_1;
    // Op 736: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 737: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 738: dim3x3 mul
    gl64_t s1_738_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_738_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_738_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA738 = (tmp3_0 + tmp3_1) * (s1_738_0 + s1_738_1);
    gl64_t kB738 = (tmp3_0 + tmp3_2) * (s1_738_0 + s1_738_2);
    gl64_t kC738 = (tmp3_1 + tmp3_2) * (s1_738_1 + s1_738_2);
    gl64_t kD738 = tmp3_0 * s1_738_0;
    gl64_t kE738 = tmp3_1 * s1_738_1;
    gl64_t kF738 = tmp3_2 * s1_738_2;
    gl64_t kG738 = kD738 - kE738;
    tmp3_0 = (kC738 + kG738) - kF738;
    tmp3_1 = ((((kA738 + kC738) - kE738) - kE738) - kD738);
    tmp3_2 = kB738 - kG738;
    // Op 739: dim3x1 add
    gl64_t s1_739 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 39, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_739; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 740: dim3x3 mul
    gl64_t s1_740_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_740_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_740_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA740 = (tmp3_0 + tmp3_1) * (s1_740_0 + s1_740_1);
    gl64_t kB740 = (tmp3_0 + tmp3_2) * (s1_740_0 + s1_740_2);
    gl64_t kC740 = (tmp3_1 + tmp3_2) * (s1_740_1 + s1_740_2);
    gl64_t kD740 = tmp3_0 * s1_740_0;
    gl64_t kE740 = tmp3_1 * s1_740_1;
    gl64_t kF740 = tmp3_2 * s1_740_2;
    gl64_t kG740 = kD740 - kE740;
    tmp3_0 = (kC740 + kG740) - kF740;
    tmp3_1 = ((((kA740 + kC740) - kE740) - kE740) - kD740);
    tmp3_2 = kB740 - kG740;
    // Op 741: dim3x1 add
    gl64_t s1_741 = *(gl64_t*)&expressions_params[9][20];
    tmp3_0 = tmp3_0 + s1_741; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 742: dim3x3 add
    gl64_t s1_742_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_742_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_742_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_742_0; tmp3_1 = tmp3_1 + s1_742_1; tmp3_2 = tmp3_2 + s1_742_2;
    // Op 743: dim3x3 mul
    gl64_t s0_743_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 39+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 39+0, domainSize, nCols_2))];
    gl64_t s0_743_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 39+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 39+1, domainSize, nCols_2))];
    gl64_t s0_743_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 39+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 39+2, domainSize, nCols_2))];
    gl64_t kA743 = (s0_743_0 + s0_743_1) * (tmp3_0 + tmp3_1);
    gl64_t kB743 = (s0_743_0 + s0_743_2) * (tmp3_0 + tmp3_2);
    gl64_t kC743 = (s0_743_1 + s0_743_2) * (tmp3_1 + tmp3_2);
    gl64_t kD743 = s0_743_0 * tmp3_0;
    gl64_t kE743 = s0_743_1 * tmp3_1;
    gl64_t kF743 = s0_743_2 * tmp3_2;
    gl64_t kG743 = kD743 - kE743;
    tmp3_0 = (kC743 + kG743) - kF743;
    tmp3_1 = ((((kA743 + kC743) - kE743) - kE743) - kD743);
    tmp3_2 = kB743 - kG743;
    // Op 744: dim3x1 sub
    gl64_t s1_744 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 41, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 41, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 - s1_744; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 745: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 746: dim3x3 mul
    gl64_t s1_746_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_746_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_746_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA746 = (tmp3_0 + tmp3_1) * (s1_746_0 + s1_746_1);
    gl64_t kB746 = (tmp3_0 + tmp3_2) * (s1_746_0 + s1_746_2);
    gl64_t kC746 = (tmp3_1 + tmp3_2) * (s1_746_1 + s1_746_2);
    gl64_t kD746 = tmp3_0 * s1_746_0;
    gl64_t kE746 = tmp3_1 * s1_746_1;
    gl64_t kF746 = tmp3_2 * s1_746_2;
    gl64_t kG746 = kD746 - kE746;
    tmp3_12 = (kC746 + kG746) - kF746;
    tmp3_13 = ((((kA746 + kC746) - kE746) - kE746) - kD746);
    tmp3_14 = kB746 - kG746;
    // Op 747: dim3x3 mul
    gl64_t s0_747_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_747_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_747_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_747_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_747_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_747_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA747 = (s0_747_0 + s0_747_1) * (s1_747_0 + s1_747_1);
    gl64_t kB747 = (s0_747_0 + s0_747_2) * (s1_747_0 + s1_747_2);
    gl64_t kC747 = (s0_747_1 + s0_747_2) * (s1_747_1 + s1_747_2);
    gl64_t kD747 = s0_747_0 * s1_747_0;
    gl64_t kE747 = s0_747_1 * s1_747_1;
    gl64_t kF747 = s0_747_2 * s1_747_2;
    gl64_t kG747 = kD747 - kE747;
    tmp3_0 = (kC747 + kG747) - kF747;
    tmp3_1 = ((((kA747 + kC747) - kE747) - kE747) - kD747);
    tmp3_2 = kB747 - kG747;
    // Op 748: dim3x1 add
    gl64_t s1_748 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_748; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 749: dim3x3 mul
    gl64_t s1_749_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_749_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_749_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA749 = (tmp3_0 + tmp3_1) * (s1_749_0 + s1_749_1);
    gl64_t kB749 = (tmp3_0 + tmp3_2) * (s1_749_0 + s1_749_2);
    gl64_t kC749 = (tmp3_1 + tmp3_2) * (s1_749_1 + s1_749_2);
    gl64_t kD749 = tmp3_0 * s1_749_0;
    gl64_t kE749 = tmp3_1 * s1_749_1;
    gl64_t kF749 = tmp3_2 * s1_749_2;
    gl64_t kG749 = kD749 - kE749;
    tmp3_0 = (kC749 + kG749) - kF749;
    tmp3_1 = ((((kA749 + kC749) - kE749) - kE749) - kD749);
    tmp3_2 = kB749 - kG749;
    // Op 750: dim1x1 mul
    gl64_t s0_750 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_750 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_750 * s1_750;
    // Op 751: dim1x1 add
    gl64_t s0_751 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_1 = s0_751 + tmp1_0;
    // Op 752: dim1x1 mul
    gl64_t s0_752 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_752 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_752 * s1_752;
    // Op 753: dim1x1 mul
    gl64_t s1_753 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = tmp1_0 * s1_753;
    // Op 754: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
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
    // Op 757: dim1x1 mul
    gl64_t s0_757 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_757 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_757 * s1_757;
    // Op 758: dim1x1 add
    gl64_t s0_758 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_0 = s0_758 + tmp1_0;
    // Op 759: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 761: dim1x1 mul
    gl64_t s0_761 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_761 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_761 * s1_761;
    // Op 762: dim1x1 add
    gl64_t s0_762 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_1 = s0_762 + tmp1_0;
    // Op 763: dim1x1 mul
    gl64_t s0_763 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    gl64_t s1_763 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_0 = s0_763 * s1_763;
    // Op 764: dim1x1 mul
    gl64_t s1_764 = *(gl64_t*)&expressions_params[9][21];
    tmp1_0 = tmp1_0 * s1_764;
    // Op 765: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 766: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 767: dim3x3 mul
    gl64_t s1_767_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_767_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_767_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA767 = (tmp3_0 + tmp3_1) * (s1_767_0 + s1_767_1);
    gl64_t kB767 = (tmp3_0 + tmp3_2) * (s1_767_0 + s1_767_2);
    gl64_t kC767 = (tmp3_1 + tmp3_2) * (s1_767_1 + s1_767_2);
    gl64_t kD767 = tmp3_0 * s1_767_0;
    gl64_t kE767 = tmp3_1 * s1_767_1;
    gl64_t kF767 = tmp3_2 * s1_767_2;
    gl64_t kG767 = kD767 - kE767;
    tmp3_0 = (kC767 + kG767) - kF767;
    tmp3_1 = ((((kA767 + kC767) - kE767) - kE767) - kD767);
    tmp3_2 = kB767 - kG767;
    // Op 768: dim1x1 mul
    gl64_t s0_768 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_768 = *(gl64_t*)&expressions_params[9][19];
    tmp1_0 = s0_768 * s1_768;
    // Op 769: dim1x1 add
    gl64_t s0_769 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_0 = s0_769 + tmp1_0;
    // Op 770: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 772: dim1x1 sub_swap
    gl64_t s0_772 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_772 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_772 - s0_772;
    // Op 773: dim1x1 sub_swap
    gl64_t s0_773 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_773 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_773 - s0_773;
    // Op 774: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 775: dim1x1 mul
    gl64_t s1_775 = *(gl64_t*)&expressions_params[9][22];
    tmp1_1 = tmp1_0 * s1_775;
    // Op 776: dim1x1 sub_swap
    gl64_t s0_776 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    gl64_t s1_776 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_776 - s0_776;
    // Op 777: dim1x1 mul
    gl64_t s0_777 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_0 = s0_777 * tmp1_0;
    // Op 778: dim1x1 mul
    gl64_t s1_778 = *(gl64_t*)&expressions_params[9][23];
    tmp1_0 = tmp1_0 * s1_778;
    // Op 779: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 780: dim1x1 sub_swap
    gl64_t s0_780 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_780 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_780 - s0_780;
    // Op 781: dim1x1 mul
    gl64_t s0_781 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_781 * tmp1_0;
    // Op 782: dim1x1 mul
    gl64_t s1_782 = *(gl64_t*)&expressions_params[9][24];
    tmp1_0 = tmp1_0 * s1_782;
    // Op 783: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_0;
    // Op 784: dim1x1 mul
    gl64_t s0_784 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_784 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_784 * s1_784;
    // Op 785: dim1x1 mul
    gl64_t s1_785 = *(gl64_t*)&expressions_params[9][7];
    tmp1_0 = tmp1_0 * s1_785;
    // Op 786: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 787: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 788: dim3x3 mul
    gl64_t s1_788_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_788_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_788_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA788 = (tmp3_0 + tmp3_1) * (s1_788_0 + s1_788_1);
    gl64_t kB788 = (tmp3_0 + tmp3_2) * (s1_788_0 + s1_788_2);
    gl64_t kC788 = (tmp3_1 + tmp3_2) * (s1_788_1 + s1_788_2);
    gl64_t kD788 = tmp3_0 * s1_788_0;
    gl64_t kE788 = tmp3_1 * s1_788_1;
    gl64_t kF788 = tmp3_2 * s1_788_2;
    gl64_t kG788 = kD788 - kE788;
    tmp3_0 = (kC788 + kG788) - kF788;
    tmp3_1 = ((((kA788 + kC788) - kE788) - kE788) - kD788);
    tmp3_2 = kB788 - kG788;
    // Op 789: dim3x1 add
    gl64_t s1_789 = *(gl64_t*)&expressions_params[9][20];
    tmp3_0 = tmp3_0 + s1_789; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 790: dim3x3 add
    gl64_t s1_790_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_790_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_790_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_790_0; tmp3_1 = tmp3_1 + s1_790_1; tmp3_2 = tmp3_2 + s1_790_2;
    // Op 791: dim3x3 mul
    gl64_t s0_791_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 42+0, domainSize, nCols_2))];
    gl64_t s0_791_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 42+1, domainSize, nCols_2))];
    gl64_t s0_791_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 42+2, domainSize, nCols_2))];
    gl64_t kA791 = (s0_791_0 + s0_791_1) * (tmp3_0 + tmp3_1);
    gl64_t kB791 = (s0_791_0 + s0_791_2) * (tmp3_0 + tmp3_2);
    gl64_t kC791 = (s0_791_1 + s0_791_2) * (tmp3_1 + tmp3_2);
    gl64_t kD791 = s0_791_0 * tmp3_0;
    gl64_t kE791 = s0_791_1 * tmp3_1;
    gl64_t kF791 = s0_791_2 * tmp3_2;
    gl64_t kG791 = kD791 - kE791;
    tmp3_0 = (kC791 + kG791) - kF791;
    tmp3_1 = ((((kA791 + kC791) - kE791) - kE791) - kD791);
    tmp3_2 = kB791 - kG791;
    // Op 792: dim1x1 sub_swap
    gl64_t s0_792 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_1))];
    gl64_t s1_792 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_792 - s0_792;
    // Op 793: dim1x1 mul
    gl64_t s0_793 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    tmp1_0 = s0_793 * tmp1_0;
    // Op 794: dim1x1 sub_swap
    gl64_t s1_794 = *(gl64_t*)&expressions_params[9][25];
    tmp1_0 = s1_794 - tmp1_0;
    // Op 795: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 796: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 797: dim3x3 mul
    gl64_t s1_797_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_797_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_797_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA797 = (tmp3_0 + tmp3_1) * (s1_797_0 + s1_797_1);
    gl64_t kB797 = (tmp3_0 + tmp3_2) * (s1_797_0 + s1_797_2);
    gl64_t kC797 = (tmp3_1 + tmp3_2) * (s1_797_1 + s1_797_2);
    gl64_t kD797 = tmp3_0 * s1_797_0;
    gl64_t kE797 = tmp3_1 * s1_797_1;
    gl64_t kF797 = tmp3_2 * s1_797_2;
    gl64_t kG797 = kD797 - kE797;
    tmp3_6 = (kC797 + kG797) - kF797;
    tmp3_7 = ((((kA797 + kC797) - kE797) - kE797) - kD797);
    tmp3_8 = kB797 - kG797;
    // Op 798: dim1x1 sub_swap
    gl64_t s0_798 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_798 = *(gl64_t*)&expressions_params[9][1];
    tmp1_0 = s1_798 - s0_798;
    // Op 799: dim3x1 mul
    uint64_t s0_799_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_799_0 = *(gl64_t*)&dParams->aux_trace[s0_799_pos];
    gl64_t s0_799_1 = *(gl64_t*)&dParams->aux_trace[s0_799_pos + TILE_HEIGHT];
    gl64_t s0_799_2 = *(gl64_t*)&dParams->aux_trace[s0_799_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_799_0 * tmp1_0; tmp3_1 = s0_799_1 * tmp1_0; tmp3_2 = s0_799_2 * tmp1_0;
    // Op 800: dim3x3 sub
    uint64_t s0_800_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_800_0 = *(gl64_t*)&dParams->aux_trace[s0_800_pos];
    gl64_t s0_800_1 = *(gl64_t*)&dParams->aux_trace[s0_800_pos + TILE_HEIGHT];
    gl64_t s0_800_2 = *(gl64_t*)&dParams->aux_trace[s0_800_pos + 2*TILE_HEIGHT];
    tmp3_12 = s0_800_0 - tmp3_0; tmp3_13 = s0_800_1 - tmp3_1; tmp3_14 = s0_800_2 - tmp3_2;
    // Op 801: dim3x3 add
    gl64_t s0_801_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_801_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_801_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_801_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_801_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_801_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_0 = s0_801_0 + s1_801_0; tmp3_1 = s0_801_1 + s1_801_1; tmp3_2 = s0_801_2 + s1_801_2;
    // Op 802: dim3x3 add
    uint64_t s0_802_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_802_0 = *(gl64_t*)&dParams->aux_trace[s0_802_pos];
    gl64_t s0_802_1 = *(gl64_t*)&dParams->aux_trace[s0_802_pos + TILE_HEIGHT];
    gl64_t s0_802_2 = *(gl64_t*)&dParams->aux_trace[s0_802_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_802_0 + tmp3_0; tmp3_1 = s0_802_1 + tmp3_1; tmp3_2 = s0_802_2 + tmp3_2;
    // Op 803: dim3x3 add
    uint64_t s0_803_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_803_0 = *(gl64_t*)&dParams->aux_trace[s0_803_pos];
    gl64_t s0_803_1 = *(gl64_t*)&dParams->aux_trace[s0_803_pos + TILE_HEIGHT];
    gl64_t s0_803_2 = *(gl64_t*)&dParams->aux_trace[s0_803_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_803_0 + tmp3_0; tmp3_1 = s0_803_1 + tmp3_1; tmp3_2 = s0_803_2 + tmp3_2;
    // Op 804: dim3x3 add
    gl64_t s0_804_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_804_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_804_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    tmp3_0 = s0_804_0 + tmp3_0; tmp3_1 = s0_804_1 + tmp3_1; tmp3_2 = s0_804_2 + tmp3_2;
    // Op 805: dim3x3 add
    gl64_t s0_805_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+0, domainSize, nCols_2))];
    gl64_t s0_805_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+1, domainSize, nCols_2))];
    gl64_t s0_805_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18+2, domainSize, nCols_2))];
    tmp3_0 = s0_805_0 + tmp3_0; tmp3_1 = s0_805_1 + tmp3_1; tmp3_2 = s0_805_2 + tmp3_2;
    // Op 806: dim3x3 add
    uint64_t s0_806_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_2));
    gl64_t s0_806_0 = *(gl64_t*)&dParams->aux_trace[s0_806_pos];
    gl64_t s0_806_1 = *(gl64_t*)&dParams->aux_trace[s0_806_pos + TILE_HEIGHT];
    gl64_t s0_806_2 = *(gl64_t*)&dParams->aux_trace[s0_806_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_806_0 + tmp3_0; tmp3_1 = s0_806_1 + tmp3_1; tmp3_2 = s0_806_2 + tmp3_2;
    // Op 807: dim3x3 add
    uint64_t s0_807_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_2));
    gl64_t s0_807_0 = *(gl64_t*)&dParams->aux_trace[s0_807_pos];
    gl64_t s0_807_1 = *(gl64_t*)&dParams->aux_trace[s0_807_pos + TILE_HEIGHT];
    gl64_t s0_807_2 = *(gl64_t*)&dParams->aux_trace[s0_807_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_807_0 + tmp3_0; tmp3_1 = s0_807_1 + tmp3_1; tmp3_2 = s0_807_2 + tmp3_2;
    // Op 808: dim3x3 add
    gl64_t s0_808_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+0, domainSize, nCols_2))];
    gl64_t s0_808_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+1, domainSize, nCols_2))];
    gl64_t s0_808_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 27+2, domainSize, nCols_2))];
    tmp3_0 = s0_808_0 + tmp3_0; tmp3_1 = s0_808_1 + tmp3_1; tmp3_2 = s0_808_2 + tmp3_2;
    // Op 809: dim3x3 add
    gl64_t s0_809_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 30+0, domainSize, nCols_2))];
    gl64_t s0_809_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 30+1, domainSize, nCols_2))];
    gl64_t s0_809_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 30+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 30+2, domainSize, nCols_2))];
    tmp3_0 = s0_809_0 + tmp3_0; tmp3_1 = s0_809_1 + tmp3_1; tmp3_2 = s0_809_2 + tmp3_2;
    // Op 810: dim3x3 add
    uint64_t s0_810_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_2));
    gl64_t s0_810_0 = *(gl64_t*)&dParams->aux_trace[s0_810_pos];
    gl64_t s0_810_1 = *(gl64_t*)&dParams->aux_trace[s0_810_pos + TILE_HEIGHT];
    gl64_t s0_810_2 = *(gl64_t*)&dParams->aux_trace[s0_810_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_810_0 + tmp3_0; tmp3_1 = s0_810_1 + tmp3_1; tmp3_2 = s0_810_2 + tmp3_2;
    // Op 811: dim3x3 add
    uint64_t s0_811_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_2));
    gl64_t s0_811_0 = *(gl64_t*)&dParams->aux_trace[s0_811_pos];
    gl64_t s0_811_1 = *(gl64_t*)&dParams->aux_trace[s0_811_pos + TILE_HEIGHT];
    gl64_t s0_811_2 = *(gl64_t*)&dParams->aux_trace[s0_811_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_811_0 + tmp3_0; tmp3_1 = s0_811_1 + tmp3_1; tmp3_2 = s0_811_2 + tmp3_2;
    // Op 812: dim3x3 add
    gl64_t s0_812_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 39+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 39+0, domainSize, nCols_2))];
    gl64_t s0_812_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 39+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 39+1, domainSize, nCols_2))];
    gl64_t s0_812_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 39+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 39+2, domainSize, nCols_2))];
    tmp3_0 = s0_812_0 + tmp3_0; tmp3_1 = s0_812_1 + tmp3_1; tmp3_2 = s0_812_2 + tmp3_2;
    // Op 813: dim3x3 add
    gl64_t s0_813_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 42+0, domainSize, nCols_2))];
    gl64_t s0_813_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 42+1, domainSize, nCols_2))];
    gl64_t s0_813_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 42+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 42+2, domainSize, nCols_2))];
    tmp3_0 = s0_813_0 + tmp3_0; tmp3_1 = s0_813_1 + tmp3_1; tmp3_2 = s0_813_2 + tmp3_2;
    // Op 814: dim3x3 sub
    tmp3_12 = tmp3_12 - tmp3_0; tmp3_13 = tmp3_13 - tmp3_1; tmp3_14 = tmp3_14 - tmp3_2;
    // Op 815: dim3x1 mul
    gl64_t s0_815_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_815_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_815_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_815 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp3_0 = s0_815_0 * s1_815; tmp3_1 = s0_815_1 * s1_815; tmp3_2 = s0_815_2 * s1_815;
    // Op 816: dim3x1 add
    gl64_t s1_816 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_816; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_818 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_818; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 819: dim3x3 add
    gl64_t s1_819_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_819_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_819_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_819_0; tmp3_1 = tmp3_1 + s1_819_1; tmp3_2 = tmp3_2 + s1_819_2;
    // Op 820: dim3x3 mul
    gl64_t kA820 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB820 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC820 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD820 = tmp3_12 * tmp3_0;
    gl64_t kE820 = tmp3_13 * tmp3_1;
    gl64_t kF820 = tmp3_14 * tmp3_2;
    gl64_t kG820 = kD820 - kE820;
    tmp3_0 = (kC820 + kG820) - kF820;
    tmp3_1 = ((((kA820 + kC820) - kE820) - kE820) - kD820);
    tmp3_2 = kB820 - kG820;
    // Op 821: dim3x1 add
    gl64_t s1_821 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_821; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 822: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 823: dim3x3 mul
    gl64_t s1_823_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_823_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_823_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA823 = (tmp3_0 + tmp3_1) * (s1_823_0 + s1_823_1);
    gl64_t kB823 = (tmp3_0 + tmp3_2) * (s1_823_0 + s1_823_2);
    gl64_t kC823 = (tmp3_1 + tmp3_2) * (s1_823_1 + s1_823_2);
    gl64_t kD823 = tmp3_0 * s1_823_0;
    gl64_t kE823 = tmp3_1 * s1_823_1;
    gl64_t kF823 = tmp3_2 * s1_823_2;
    gl64_t kG823 = kD823 - kE823;
    tmp3_6 = (kC823 + kG823) - kF823;
    tmp3_7 = ((((kA823 + kC823) - kE823) - kE823) - kD823);
    tmp3_8 = kB823 - kG823;
    // Op 824: dim3x3 sub_swap
    uint64_t s0_824_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_824_0 = *(gl64_t*)&dParams->aux_trace[s0_824_pos];
    gl64_t s0_824_1 = *(gl64_t*)&dParams->aux_trace[s0_824_pos + TILE_HEIGHT];
    gl64_t s0_824_2 = *(gl64_t*)&dParams->aux_trace[s0_824_pos + 2*TILE_HEIGHT];
    gl64_t s1_824_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_824_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_824_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_0 = s1_824_0 - s0_824_0; tmp3_1 = s1_824_1 - s0_824_1; tmp3_2 = s1_824_2 - s0_824_2;
    // Op 825: dim3x1 mul
    gl64_t s1_825 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_825; tmp3_1 = tmp3_1 * s1_825; tmp3_2 = tmp3_2 * s1_825;
    // Op 826: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 827: dim3x3 mul
    gl64_t s1_827_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_827_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_827_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 828: dim1x1 add
    gl64_t s0_828 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_828 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_1 = s0_828 + s1_828;
    // Op 829: dim1x1 mul
    gl64_t s0_829 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_829 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_829 * s1_829;
    // Op 830: dim1x1 mul
    gl64_t s0_830 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_830 * tmp1_0;
    // Op 831: dim1x1 sub
    tmp1_0 = tmp1_1 - tmp1_0;
    // Op 832: dim1x1 mul
    gl64_t s0_832 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_1))];
    tmp1_0 = s0_832 * tmp1_0;
    // Op 833: dim1x1 sub
    gl64_t s0_833 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 45, domainSize, nCols_2))];
    tmp1_0 = s0_833 - tmp1_0;
    // Op 834: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 835: dim3x3 mul
    gl64_t s1_835_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_835_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_835_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 836: dim1x1 mul
    gl64_t s0_836 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_1))];
    gl64_t s1_836 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_836 * s1_836;
    // Op 837: dim1x1 sub_swap
    gl64_t s0_837 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    gl64_t s1_837 = *(gl64_t*)&expressions_params[9][1];
    tmp1_1 = s1_837 - s0_837;
    // Op 838: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 839: dim1x1 sub
    gl64_t s0_839 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 46, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 46, domainSize, nCols_2))];
    tmp1_0 = s0_839 - tmp1_0;
    // Op 840: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 841: dim3x1 mul
    gl64_t s1_841 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_841; tmp3_1 = tmp3_1 * s1_841; tmp3_2 = tmp3_2 * s1_841;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
