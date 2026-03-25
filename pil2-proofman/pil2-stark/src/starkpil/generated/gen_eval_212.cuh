// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: 13b25f36  nOps=171 nTemp1=3 nTemp3=3
#define GENERATED_EVAL_NOPS_13b25f36 171
#define GENERATED_EVAL_NTEMP1_13b25f36 3
#define GENERATED_EVAL_NTEMP3_13b25f36 3

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_13b25f36(
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

    // Register-resident temporaries: 3 tmp1 + 9 tmp3 slots
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
    gl64_t s0_18 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_18 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_18 - s0_18;
    // Op 19: dim1x1 mul
    gl64_t s0_19 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_19 * tmp1_0;
    // Op 20: dim1x1 mul
    gl64_t s0_20 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_20 * tmp1_0;
    // Op 21: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 22: dim3x3 mul
    gl64_t s1_22_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_22_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_22_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA22 = (tmp3_0 + tmp3_1) * (s1_22_0 + s1_22_1);
    gl64_t kB22 = (tmp3_0 + tmp3_2) * (s1_22_0 + s1_22_2);
    gl64_t kC22 = (tmp3_1 + tmp3_2) * (s1_22_1 + s1_22_2);
    gl64_t kD22 = tmp3_0 * s1_22_0;
    gl64_t kE22 = tmp3_1 * s1_22_1;
    gl64_t kF22 = tmp3_2 * s1_22_2;
    gl64_t kG22 = kD22 - kE22;
    tmp3_0 = (kC22 + kG22) - kF22;
    tmp3_1 = ((((kA22 + kC22) - kE22) - kE22) - kD22);
    tmp3_2 = kB22 - kG22;
    // Op 23: dim1x1 sub_swap
    gl64_t s0_23 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_23 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_23 - s0_23;
    // Op 24: dim1x1 mul
    gl64_t s0_24 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_24 * tmp1_0;
    // Op 25: dim1x1 mul
    gl64_t s0_25 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_25 * tmp1_0;
    // Op 26: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 27: dim3x3 mul
    gl64_t s1_27_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_27_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_27_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 28: dim1x1 sub
    gl64_t s0_28 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_28 = *(gl64_t*)&expressions_params[10][7];
    tmp1_0 = s0_28 - s1_28;
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
    // Op 32: dim1x1 sub
    gl64_t s0_32 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_32 = *(gl64_t*)&expressions_params[10][8];
    tmp1_0 = s0_32 - s1_32;
    // Op 33: dim1x1 mul
    gl64_t s0_33 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_33 * tmp1_0;
    // Op 34: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 35: dim3x3 mul
    gl64_t s1_35_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_35_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_35_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA35 = (tmp3_0 + tmp3_1) * (s1_35_0 + s1_35_1);
    gl64_t kB35 = (tmp3_0 + tmp3_2) * (s1_35_0 + s1_35_2);
    gl64_t kC35 = (tmp3_1 + tmp3_2) * (s1_35_1 + s1_35_2);
    gl64_t kD35 = tmp3_0 * s1_35_0;
    gl64_t kE35 = tmp3_1 * s1_35_1;
    gl64_t kF35 = tmp3_2 * s1_35_2;
    gl64_t kG35 = kD35 - kE35;
    tmp3_0 = (kC35 + kG35) - kF35;
    tmp3_1 = ((((kA35 + kC35) - kE35) - kE35) - kD35);
    tmp3_2 = kB35 - kG35;
    // Op 36: dim1x1 sub
    gl64_t s0_36 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_36 = *(gl64_t*)&expressions_params[10][10];
    tmp1_0 = s0_36 - s1_36;
    // Op 37: dim1x1 mul
    gl64_t s0_37 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp1_0 = s0_37 * tmp1_0;
    // Op 38: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 39: dim3x3 mul
    gl64_t s1_39_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_39_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_39_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA39 = (tmp3_0 + tmp3_1) * (s1_39_0 + s1_39_1);
    gl64_t kB39 = (tmp3_0 + tmp3_2) * (s1_39_0 + s1_39_2);
    gl64_t kC39 = (tmp3_1 + tmp3_2) * (s1_39_1 + s1_39_2);
    gl64_t kD39 = tmp3_0 * s1_39_0;
    gl64_t kE39 = tmp3_1 * s1_39_1;
    gl64_t kF39 = tmp3_2 * s1_39_2;
    gl64_t kG39 = kD39 - kE39;
    tmp3_0 = (kC39 + kG39) - kF39;
    tmp3_1 = ((((kA39 + kC39) - kE39) - kE39) - kD39);
    tmp3_2 = kB39 - kG39;
    // Op 40: dim1x1 sub
    gl64_t s0_40 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_40 = *(gl64_t*)&expressions_params[10][9];
    tmp1_0 = s0_40 - s1_40;
    // Op 41: dim1x1 mul
    gl64_t s0_41 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
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
    gl64_t s0_44 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_44 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s1_44 - s0_44;
    // Op 45: dim1x1 sub
    gl64_t s0_45 = *(gl64_t*)&expressions_params[10][6];
    gl64_t s1_45 = *(gl64_t*)&expressions_params[10][1];
    tmp1_0 = s0_45 - s1_45;
    // Op 46: dim1x1 sub_swap
    gl64_t s0_46 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_1))];
    tmp1_0 = tmp1_0 - s0_46;
    // Op 47: dim1x1 mul
    gl64_t s0_47 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_0 = s0_47 * tmp1_0;
    // Op 48: dim1x1 add
    gl64_t s0_48 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_1))];
    tmp1_2 = s0_48 + tmp1_0;
    // Op 49: dim1x1 sub
    gl64_t s0_49 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_49 - tmp1_2;
    // Op 50: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
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
    gl64_t s0_53 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_53 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_53 - s0_53;
    // Op 54: dim1x1 sub
    gl64_t s0_54 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_1 = s0_54 - tmp1_2;
    // Op 55: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
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
    gl64_t s0_59 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 4, domainSize, nCols_1))];
    gl64_t s1_59 = *(gl64_t*)&expressions_params[10][3];
    tmp1_0 = s1_59 - s0_59;
    // Op 60: dim1x1 mul
    gl64_t s0_60 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_0 = s0_60 * tmp1_0;
    // Op 61: dim1x1 add
    gl64_t s0_61 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 4, domainSize, nCols_1))];
    tmp1_0 = s0_61 + tmp1_0;
    // Op 62: dim1x1 sub
    gl64_t s0_62 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_62 - tmp1_0;
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
    tmp1_1 = s1_66 - s0_66;
    // Op 67: dim1x1 sub_swap
    gl64_t s0_67 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 5, domainSize, nCols_1))];
    gl64_t s1_67 = *(gl64_t*)&expressions_params[10][4];
    tmp1_0 = s1_67 - s0_67;
    // Op 68: dim1x1 mul
    gl64_t s0_68 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp1_0 = s0_68 * tmp1_0;
    // Op 69: dim1x1 add
    gl64_t s0_69 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 5, domainSize, nCols_1))];
    tmp1_0 = s0_69 + tmp1_0;
    // Op 70: dim1x1 sub
    gl64_t s0_70 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_70 - tmp1_0;
    // Op 71: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
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
    tmp3_3 = (kC73 + kG73) - kF73;
    tmp3_4 = ((((kA73 + kC73) - kE73) - kE73) - kD73);
    tmp3_5 = kB73 - kG73;
    // Op 74: dim1x1 sub
    gl64_t s0_74 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_2 = s0_74 - tmp1_2;
    // Op 75: dim1x1 sub
    gl64_t s1_75 = *(gl64_t*)&expressions_params[9][0];
    tmp1_2 = tmp1_2 - s1_75;
    // Op 76: dim3x1 mul
    gl64_t s0_76_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_76_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_76_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_76_0 * tmp1_2; tmp3_1 = s0_76_1 * tmp1_2; tmp3_2 = s0_76_2 * tmp1_2;
    // Op 77: dim3x1 add
    gl64_t s1_77 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_77; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 78: dim3x3 add
    gl64_t s1_78_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_78_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_78_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_78_0; tmp3_1 = tmp3_1 + s1_78_1; tmp3_2 = tmp3_2 + s1_78_2;
    // Op 79: dim3x3 mul
    gl64_t s0_79_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_79_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_79_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA79 = (s0_79_0 + s0_79_1) * (tmp3_0 + tmp3_1);
    gl64_t kB79 = (s0_79_0 + s0_79_2) * (tmp3_0 + tmp3_2);
    gl64_t kC79 = (s0_79_1 + s0_79_2) * (tmp3_1 + tmp3_2);
    gl64_t kD79 = s0_79_0 * tmp3_0;
    gl64_t kE79 = s0_79_1 * tmp3_1;
    gl64_t kF79 = s0_79_2 * tmp3_2;
    gl64_t kG79 = kD79 - kE79;
    tmp3_0 = (kC79 + kG79) - kF79;
    tmp3_1 = ((((kA79 + kC79) - kE79) - kE79) - kD79);
    tmp3_2 = kB79 - kG79;
    // Op 80: dim1x1 sub_swap
    gl64_t s0_80 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_80 = *(gl64_t*)&expressions_params[9][8];
    tmp1_2 = s1_80 - s0_80;
    // Op 81: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 82: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
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
    tmp3_3 = (kC83 + kG83) - kF83;
    tmp3_4 = ((((kA83 + kC83) - kE83) - kE83) - kD83);
    tmp3_5 = kB83 - kG83;
    // Op 84: dim3x1 mul
    gl64_t s0_84_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_84_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_84_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_84 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp3_0 = s0_84_0 * s1_84; tmp3_1 = s0_84_1 * s1_84; tmp3_2 = s0_84_2 * s1_84;
    // Op 85: dim3x1 add
    gl64_t s1_85 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_85; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 86: dim3x3 mul
    gl64_t s1_86_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_86_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_86_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA86 = (tmp3_0 + tmp3_1) * (s1_86_0 + s1_86_1);
    gl64_t kB86 = (tmp3_0 + tmp3_2) * (s1_86_0 + s1_86_2);
    gl64_t kC86 = (tmp3_1 + tmp3_2) * (s1_86_1 + s1_86_2);
    gl64_t kD86 = tmp3_0 * s1_86_0;
    gl64_t kE86 = tmp3_1 * s1_86_1;
    gl64_t kF86 = tmp3_2 * s1_86_2;
    gl64_t kG86 = kD86 - kE86;
    tmp3_0 = (kC86 + kG86) - kF86;
    tmp3_1 = ((((kA86 + kC86) - kE86) - kE86) - kD86);
    tmp3_2 = kB86 - kG86;
    // Op 87: dim3x1 add
    gl64_t s1_87 = *(gl64_t*)&expressions_params[9][2];
    tmp3_0 = tmp3_0 + s1_87; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 88: dim3x3 mul
    gl64_t s1_88_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_88_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_88_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA88 = (tmp3_0 + tmp3_1) * (s1_88_0 + s1_88_1);
    gl64_t kB88 = (tmp3_0 + tmp3_2) * (s1_88_0 + s1_88_2);
    gl64_t kC88 = (tmp3_1 + tmp3_2) * (s1_88_1 + s1_88_2);
    gl64_t kD88 = tmp3_0 * s1_88_0;
    gl64_t kE88 = tmp3_1 * s1_88_1;
    gl64_t kF88 = tmp3_2 * s1_88_2;
    gl64_t kG88 = kD88 - kE88;
    tmp3_0 = (kC88 + kG88) - kF88;
    tmp3_1 = ((((kA88 + kC88) - kE88) - kE88) - kD88);
    tmp3_2 = kB88 - kG88;
    // Op 89: dim3x1 add
    gl64_t s1_89 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_89; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 90: dim3x3 mul
    gl64_t s1_90_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_90_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_90_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA90 = (tmp3_0 + tmp3_1) * (s1_90_0 + s1_90_1);
    gl64_t kB90 = (tmp3_0 + tmp3_2) * (s1_90_0 + s1_90_2);
    gl64_t kC90 = (tmp3_1 + tmp3_2) * (s1_90_1 + s1_90_2);
    gl64_t kD90 = tmp3_0 * s1_90_0;
    gl64_t kE90 = tmp3_1 * s1_90_1;
    gl64_t kF90 = tmp3_2 * s1_90_2;
    gl64_t kG90 = kD90 - kE90;
    tmp3_0 = (kC90 + kG90) - kF90;
    tmp3_1 = ((((kA90 + kC90) - kE90) - kE90) - kD90);
    tmp3_2 = kB90 - kG90;
    // Op 91: dim1x1 mul
    gl64_t s0_91 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_91 = *(gl64_t*)&expressions_params[9][2];
    tmp1_2 = s0_91 * s1_91;
    // Op 92: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 93: dim3x3 mul
    gl64_t s1_93_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_93_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_93_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA93 = (tmp3_0 + tmp3_1) * (s1_93_0 + s1_93_1);
    gl64_t kB93 = (tmp3_0 + tmp3_2) * (s1_93_0 + s1_93_2);
    gl64_t kC93 = (tmp3_1 + tmp3_2) * (s1_93_1 + s1_93_2);
    gl64_t kD93 = tmp3_0 * s1_93_0;
    gl64_t kE93 = tmp3_1 * s1_93_1;
    gl64_t kF93 = tmp3_2 * s1_93_2;
    gl64_t kG93 = kD93 - kE93;
    tmp3_0 = (kC93 + kG93) - kF93;
    tmp3_1 = ((((kA93 + kC93) - kE93) - kE93) - kD93);
    tmp3_2 = kB93 - kG93;
    // Op 94: dim1x1 mul
    gl64_t s0_94 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_94 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_2 = s0_94 * s1_94;
    // Op 95: dim1x1 add
    gl64_t s1_95 = *(gl64_t*)&expressions_params[9][0];
    tmp1_2 = tmp1_2 + s1_95;
    // Op 96: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 97: dim3x3 mul
    gl64_t s1_97_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_97_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_97_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA97 = (tmp3_0 + tmp3_1) * (s1_97_0 + s1_97_1);
    gl64_t kB97 = (tmp3_0 + tmp3_2) * (s1_97_0 + s1_97_2);
    gl64_t kC97 = (tmp3_1 + tmp3_2) * (s1_97_1 + s1_97_2);
    gl64_t kD97 = tmp3_0 * s1_97_0;
    gl64_t kE97 = tmp3_1 * s1_97_1;
    gl64_t kF97 = tmp3_2 * s1_97_2;
    gl64_t kG97 = kD97 - kE97;
    tmp3_0 = (kC97 + kG97) - kF97;
    tmp3_1 = ((((kA97 + kC97) - kE97) - kE97) - kD97);
    tmp3_2 = kB97 - kG97;
    // Op 98: dim3x1 add
    gl64_t s1_98 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_98; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 99: dim3x3 add
    gl64_t s1_99_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_99_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_99_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_99_0; tmp3_1 = tmp3_1 + s1_99_1; tmp3_2 = tmp3_2 + s1_99_2;
    // Op 100: dim3x3 mul
    gl64_t s0_100_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_100_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_100_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA100 = (s0_100_0 + s0_100_1) * (tmp3_0 + tmp3_1);
    gl64_t kB100 = (s0_100_0 + s0_100_2) * (tmp3_0 + tmp3_2);
    gl64_t kC100 = (s0_100_1 + s0_100_2) * (tmp3_1 + tmp3_2);
    gl64_t kD100 = s0_100_0 * tmp3_0;
    gl64_t kE100 = s0_100_1 * tmp3_1;
    gl64_t kF100 = s0_100_2 * tmp3_2;
    gl64_t kG100 = kD100 - kE100;
    tmp3_0 = (kC100 + kG100) - kF100;
    tmp3_1 = ((((kA100 + kC100) - kE100) - kE100) - kD100);
    tmp3_2 = kB100 - kG100;
    // Op 101: dim3x1 sub
    gl64_t s1_101 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 - s1_101; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 102: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
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
    tmp3_6 = (kC103 + kG103) - kF103;
    tmp3_7 = ((((kA103 + kC103) - kE103) - kE103) - kD103);
    tmp3_8 = kB103 - kG103;
    // Op 104: dim1x1 sub_swap
    gl64_t s0_104 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_0)];
    gl64_t s1_104 = *(gl64_t*)&expressions_params[9][0];
    tmp1_2 = s1_104 - s0_104;
    // Op 105: dim3x1 mul
    uint64_t s0_105_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_105_0 = *(gl64_t*)&dParams->aux_trace[s0_105_pos];
    gl64_t s0_105_1 = *(gl64_t*)&dParams->aux_trace[s0_105_pos + TILE_HEIGHT];
    gl64_t s0_105_2 = *(gl64_t*)&dParams->aux_trace[s0_105_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_105_0 * tmp1_2; tmp3_1 = s0_105_1 * tmp1_2; tmp3_2 = s0_105_2 * tmp1_2;
    // Op 106: dim3x3 sub
    uint64_t s0_106_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_106_0 = *(gl64_t*)&dParams->aux_trace[s0_106_pos];
    gl64_t s0_106_1 = *(gl64_t*)&dParams->aux_trace[s0_106_pos + TILE_HEIGHT];
    gl64_t s0_106_2 = *(gl64_t*)&dParams->aux_trace[s0_106_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_106_0 - tmp3_0; tmp3_1 = s0_106_1 - tmp3_1; tmp3_2 = s0_106_2 - tmp3_2;
    // Op 107: dim3x3 add
    gl64_t s0_107_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_107_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_107_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_107_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_107_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_107_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_3 = s0_107_0 + s1_107_0; tmp3_4 = s0_107_1 + s1_107_1; tmp3_5 = s0_107_2 + s1_107_2;
    // Op 108: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_3; tmp3_1 = tmp3_1 - tmp3_4; tmp3_2 = tmp3_2 - tmp3_5;
    // Op 109: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    tmp3_6 = (kC110 + kG110) - kF110;
    tmp3_7 = ((((kA110 + kC110) - kE110) - kE110) - kD110);
    tmp3_8 = kB110 - kG110;
    // Op 111: dim3x1 mul
    gl64_t s0_111_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_111_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_111_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_111 = *(gl64_t*)&expressions_params[10][4];
    tmp3_0 = s0_111_0 * s1_111; tmp3_1 = s0_111_1 * s1_111; tmp3_2 = s0_111_2 * s1_111;
    // Op 112: dim3x1 add
    gl64_t s1_112 = *(gl64_t*)&expressions_params[10][3];
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
    // Op 114: dim3x1 add
    gl64_t s1_114 = *(gl64_t*)&expressions_params[10][5];
    tmp3_0 = tmp3_0 + s1_114; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 115: dim3x3 mul
    gl64_t s1_115_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_115_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_115_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA115 = (tmp3_0 + tmp3_1) * (s1_115_0 + s1_115_1);
    gl64_t kB115 = (tmp3_0 + tmp3_2) * (s1_115_0 + s1_115_2);
    gl64_t kC115 = (tmp3_1 + tmp3_2) * (s1_115_1 + s1_115_2);
    gl64_t kD115 = tmp3_0 * s1_115_0;
    gl64_t kE115 = tmp3_1 * s1_115_1;
    gl64_t kF115 = tmp3_2 * s1_115_2;
    gl64_t kG115 = kD115 - kE115;
    tmp3_0 = (kC115 + kG115) - kF115;
    tmp3_1 = ((((kA115 + kC115) - kE115) - kE115) - kD115);
    tmp3_2 = kB115 - kG115;
    // Op 116: dim3x1 add
    gl64_t s1_116 = *(gl64_t*)&expressions_params[10][6];
    tmp3_0 = tmp3_0 + s1_116; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 117: dim3x3 mul
    gl64_t s1_117_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_117_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_117_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 118: dim3x1 add
    gl64_t s1_118 = *(gl64_t*)&expressions_params[10][0];
    tmp3_0 = tmp3_0 + s1_118; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 119: dim3x3 mul
    gl64_t s1_119_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_119_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_119_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA119 = (tmp3_0 + tmp3_1) * (s1_119_0 + s1_119_1);
    gl64_t kB119 = (tmp3_0 + tmp3_2) * (s1_119_0 + s1_119_2);
    gl64_t kC119 = (tmp3_1 + tmp3_2) * (s1_119_1 + s1_119_2);
    gl64_t kD119 = tmp3_0 * s1_119_0;
    gl64_t kE119 = tmp3_1 * s1_119_1;
    gl64_t kF119 = tmp3_2 * s1_119_2;
    gl64_t kG119 = kD119 - kE119;
    tmp3_0 = (kC119 + kG119) - kF119;
    tmp3_1 = ((((kA119 + kC119) - kE119) - kE119) - kD119);
    tmp3_2 = kB119 - kG119;
    // Op 120: dim3x1 add
    gl64_t s1_120 = *(gl64_t*)&expressions_params[9][4];
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
    gl64_t s1_122 = *(gl64_t*)&expressions_params[9][5];
    tmp3_0 = tmp3_0 + s1_122; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 123: dim3x3 add
    gl64_t s1_123_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_123_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_123_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_123_0; tmp3_1 = tmp3_1 + s1_123_1; tmp3_2 = tmp3_2 + s1_123_2;
    // Op 124: dim3x3 mul
    gl64_t s1_124_0 = *(gl64_t*)&expressions_params[10][11];
    gl64_t s1_124_1 = *(gl64_t*)&expressions_params[10][11+1];
    gl64_t s1_124_2 = *(gl64_t*)&expressions_params[10][11+2];
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
    // Op 125: dim3x1 add
    gl64_t s1_125 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_125; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 126: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 127: dim3x3 mul
    gl64_t s1_127_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_127_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_127_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA127 = (tmp3_0 + tmp3_1) * (s1_127_0 + s1_127_1);
    gl64_t kB127 = (tmp3_0 + tmp3_2) * (s1_127_0 + s1_127_2);
    gl64_t kC127 = (tmp3_1 + tmp3_2) * (s1_127_1 + s1_127_2);
    gl64_t kD127 = tmp3_0 * s1_127_0;
    gl64_t kE127 = tmp3_1 * s1_127_1;
    gl64_t kF127 = tmp3_2 * s1_127_2;
    gl64_t kG127 = kD127 - kE127;
    tmp3_6 = (kC127 + kG127) - kF127;
    tmp3_7 = ((((kA127 + kC127) - kE127) - kE127) - kD127);
    tmp3_8 = kB127 - kG127;
    // Op 128: dim3x1 mul
    gl64_t s0_128_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_128_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_128_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_128 = *(gl64_t*)&expressions_params[10][8];
    tmp3_0 = s0_128_0 * s1_128; tmp3_1 = s0_128_1 * s1_128; tmp3_2 = s0_128_2 * s1_128;
    // Op 129: dim3x1 add
    gl64_t s1_129 = *(gl64_t*)&expressions_params[10][7];
    tmp3_0 = tmp3_0 + s1_129; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 130: dim3x3 mul
    gl64_t s1_130_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_130_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_130_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 131: dim3x1 add
    gl64_t s1_131 = *(gl64_t*)&expressions_params[10][9];
    tmp3_0 = tmp3_0 + s1_131; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 132: dim3x3 mul
    gl64_t s1_132_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_132_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_132_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA132 = (tmp3_0 + tmp3_1) * (s1_132_0 + s1_132_1);
    gl64_t kB132 = (tmp3_0 + tmp3_2) * (s1_132_0 + s1_132_2);
    gl64_t kC132 = (tmp3_1 + tmp3_2) * (s1_132_1 + s1_132_2);
    gl64_t kD132 = tmp3_0 * s1_132_0;
    gl64_t kE132 = tmp3_1 * s1_132_1;
    gl64_t kF132 = tmp3_2 * s1_132_2;
    gl64_t kG132 = kD132 - kE132;
    tmp3_0 = (kC132 + kG132) - kF132;
    tmp3_1 = ((((kA132 + kC132) - kE132) - kE132) - kD132);
    tmp3_2 = kB132 - kG132;
    // Op 133: dim3x1 add
    gl64_t s1_133 = *(gl64_t*)&expressions_params[10][10];
    tmp3_0 = tmp3_0 + s1_133; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 134: dim3x3 mul
    gl64_t s1_134_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_134_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_134_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 135: dim1x1 add
    gl64_t s0_135 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_135 = *(gl64_t*)&expressions_params[10][0];
    tmp1_2 = s0_135 + s1_135;
    // Op 136: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 137: dim3x3 mul
    gl64_t s1_137_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_137_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_137_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 138: dim3x1 add
    gl64_t s1_138 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_138; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 139: dim3x3 mul
    gl64_t s1_139_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_139_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_139_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 140: dim3x1 add
    gl64_t s1_140 = *(gl64_t*)&expressions_params[9][5];
    tmp3_0 = tmp3_0 + s1_140; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 141: dim3x3 add
    gl64_t s1_141_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_141_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_141_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_141_0; tmp3_1 = tmp3_1 + s1_141_1; tmp3_2 = tmp3_2 + s1_141_2;
    // Op 142: dim3x3 mul
    gl64_t s1_142_0 = *(gl64_t*)&expressions_params[10][14];
    gl64_t s1_142_1 = *(gl64_t*)&expressions_params[10][14+1];
    gl64_t s1_142_2 = *(gl64_t*)&expressions_params[10][14+2];
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
    // Op 143: dim1x1 sub
    gl64_t s0_143 = *(gl64_t*)&expressions_params[9][0];
    gl64_t s1_143 = *(gl64_t*)&expressions_params[10][2];
    tmp1_2 = s0_143 - s1_143;
    // Op 144: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 145: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    tmp3_6 = (kC146 + kG146) - kF146;
    tmp3_7 = ((((kA146 + kC146) - kE146) - kE146) - kD146);
    tmp3_8 = kB146 - kG146;
    // Op 147: dim1x1 sub_swap
    gl64_t s0_147 = *(gl64_t*)&expressions_params[9][6];
    gl64_t s1_147 = *(gl64_t*)&expressions_params[10][6];
    tmp1_2 = s1_147 - s0_147;
    // Op 148: dim3x1 mul
    gl64_t s0_148_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_148_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_148_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_148_0 * tmp1_2; tmp3_1 = s0_148_1 * tmp1_2; tmp3_2 = s0_148_2 * tmp1_2;
    // Op 149: dim3x1 add
    gl64_t s1_149 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_149; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 150: dim3x3 add
    gl64_t s1_150_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_150_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_150_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_150_0; tmp3_1 = tmp3_1 + s1_150_1; tmp3_2 = tmp3_2 + s1_150_2;
    // Op 151: dim3x3 mul
    gl64_t s1_151_0 = *(gl64_t*)&expressions_params[10][17];
    gl64_t s1_151_1 = *(gl64_t*)&expressions_params[10][17+1];
    gl64_t s1_151_2 = *(gl64_t*)&expressions_params[10][17+2];
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
    gl64_t s1_152 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_152; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 153: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    tmp3_6 = (kC154 + kG154) - kF154;
    tmp3_7 = ((((kA154 + kC154) - kE154) - kE154) - kD154);
    tmp3_8 = kB154 - kG154;
    // Op 155: dim1x1 sub
    gl64_t s0_155 = *(gl64_t*)&expressions_params[9][7];
    gl64_t s1_155 = *(gl64_t*)&expressions_params[10][10];
    tmp1_2 = s0_155 - s1_155;
    // Op 156: dim3x1 mul
    gl64_t s0_156_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_156_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_156_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_156_0 * tmp1_2; tmp3_1 = s0_156_1 * tmp1_2; tmp3_2 = s0_156_2 * tmp1_2;
    // Op 157: dim3x1 add
    gl64_t s1_157 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_157; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 158: dim3x3 add
    gl64_t s1_158_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_158_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_158_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_158_0; tmp3_1 = tmp3_1 + s1_158_1; tmp3_2 = tmp3_2 + s1_158_2;
    // Op 159: dim3x3 mul
    gl64_t s1_159_0 = *(gl64_t*)&expressions_params[10][20];
    gl64_t s1_159_1 = *(gl64_t*)&expressions_params[10][20+1];
    gl64_t s1_159_2 = *(gl64_t*)&expressions_params[10][20+2];
    gl64_t kA159 = (tmp3_0 + tmp3_1) * (s1_159_0 + s1_159_1);
    gl64_t kB159 = (tmp3_0 + tmp3_2) * (s1_159_0 + s1_159_2);
    gl64_t kC159 = (tmp3_1 + tmp3_2) * (s1_159_1 + s1_159_2);
    gl64_t kD159 = tmp3_0 * s1_159_0;
    gl64_t kE159 = tmp3_1 * s1_159_1;
    gl64_t kF159 = tmp3_2 * s1_159_2;
    gl64_t kG159 = kD159 - kE159;
    tmp3_0 = (kC159 + kG159) - kF159;
    tmp3_1 = ((((kA159 + kC159) - kE159) - kE159) - kD159);
    tmp3_2 = kB159 - kG159;
    // Op 160: dim3x1 add
    gl64_t s1_160 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_160; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 161: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    tmp3_3 = (kC162 + kG162) - kF162;
    tmp3_4 = ((((kA162 + kC162) - kE162) - kE162) - kD162);
    tmp3_5 = kB162 - kG162;
    // Op 163: dim3x3 sub_swap
    uint64_t s0_163_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_163_0 = *(gl64_t*)&dParams->aux_trace[s0_163_pos];
    gl64_t s0_163_1 = *(gl64_t*)&dParams->aux_trace[s0_163_pos + TILE_HEIGHT];
    gl64_t s0_163_2 = *(gl64_t*)&dParams->aux_trace[s0_163_pos + 2*TILE_HEIGHT];
    gl64_t s1_163_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_163_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_163_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_6 = s1_163_0 - s0_163_0; tmp3_7 = s1_163_1 - s0_163_1; tmp3_8 = s1_163_2 - s0_163_2;
    // Op 164: dim3x3 add
    gl64_t s0_164_0 = *(gl64_t*)&expressions_params[10][11];
    gl64_t s0_164_1 = *(gl64_t*)&expressions_params[10][11+1];
    gl64_t s0_164_2 = *(gl64_t*)&expressions_params[10][11+2];
    gl64_t s1_164_0 = *(gl64_t*)&expressions_params[10][14];
    gl64_t s1_164_1 = *(gl64_t*)&expressions_params[10][14+1];
    gl64_t s1_164_2 = *(gl64_t*)&expressions_params[10][14+2];
    tmp3_0 = s0_164_0 + s1_164_0; tmp3_1 = s0_164_1 + s1_164_1; tmp3_2 = s0_164_2 + s1_164_2;
    // Op 165: dim3x3 add
    gl64_t s1_165_0 = *(gl64_t*)&expressions_params[10][17];
    gl64_t s1_165_1 = *(gl64_t*)&expressions_params[10][17+1];
    gl64_t s1_165_2 = *(gl64_t*)&expressions_params[10][17+2];
    tmp3_0 = tmp3_0 + s1_165_0; tmp3_1 = tmp3_1 + s1_165_1; tmp3_2 = tmp3_2 + s1_165_2;
    // Op 166: dim3x3 add
    gl64_t s1_166_0 = *(gl64_t*)&expressions_params[10][20];
    gl64_t s1_166_1 = *(gl64_t*)&expressions_params[10][20+1];
    gl64_t s1_166_2 = *(gl64_t*)&expressions_params[10][20+2];
    tmp3_0 = tmp3_0 + s1_166_0; tmp3_1 = tmp3_1 + s1_166_1; tmp3_2 = tmp3_2 + s1_166_2;
    // Op 167: dim3x3 sub
    tmp3_0 = tmp3_6 - tmp3_0; tmp3_1 = tmp3_7 - tmp3_1; tmp3_2 = tmp3_8 - tmp3_2;
    // Op 168: dim3x1 mul
    gl64_t s1_168 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_168; tmp3_1 = tmp3_1 * s1_168; tmp3_2 = tmp3_2 * s1_168;
    // Op 169: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 170: dim3x1 mul
    gl64_t s1_170 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_170; tmp3_1 = tmp3_1 * s1_170; tmp3_2 = tmp3_2 * s1_170;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
