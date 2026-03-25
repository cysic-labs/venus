// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: 3f3558d8  nOps=146 nTemp1=4 nTemp3=5
#define GENERATED_EVAL_NOPS_3f3558d8 146
#define GENERATED_EVAL_NTEMP1_3f3558d8 4
#define GENERATED_EVAL_NTEMP3_3f3558d8 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_3f3558d8(
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

    // Register-resident temporaries: 4 tmp1 + 15 tmp3 slots
    gl64_t tmp1_0 = gl64_t(uint64_t(0));
    gl64_t tmp1_1 = gl64_t(uint64_t(0));
    gl64_t tmp1_2 = gl64_t(uint64_t(0));
    gl64_t tmp1_3 = gl64_t(uint64_t(0));
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

    // Op 0: dim1x1 sub_swap
    gl64_t s0_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_0 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s1_0 - s0_0;
    // Op 1: dim1x1 mul
    gl64_t s0_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_1 * tmp1_0;
    // Op 2: dim3x1 mul
    gl64_t s0_2_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s0_2_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s0_2_2 = *(gl64_t*)&expressions_params[13][6+2];
    tmp3_0 = s0_2_0 * tmp1_0; tmp3_1 = s0_2_1 * tmp1_0; tmp3_2 = s0_2_2 * tmp1_0;
    // Op 3: dim1x1 sub_swap
    gl64_t s0_3 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_3 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s1_3 - s0_3;
    // Op 4: dim1x1 mul
    gl64_t s0_4 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
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
    // Op 7: dim1x1 sub_swap
    gl64_t s0_7 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_7 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s1_7 - s0_7;
    // Op 8: dim1x1 mul
    gl64_t s0_8 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_8 * tmp1_0;
    // Op 9: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 10: dim3x3 mul
    gl64_t s1_10_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_10_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_10_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 11: dim1x1 mul
    gl64_t s0_11 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_11 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = s0_11 * s1_11;
    // Op 12: dim1x1 mul
    gl64_t s0_12 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_2 = s0_12 * tmp1_0;
    // Op 13: dim1x1 mul
    gl64_t s0_13 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_13 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_13 * s1_13;
    // Op 14: dim1x1 sub_swap
    gl64_t s0_14 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_14 = *(gl64_t*)&expressions_params[9][4];
    tmp1_1 = s1_14 - s0_14;
    // Op 15: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 16: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_0;
    // Op 17: dim1x1 sub_swap
    gl64_t s0_17 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_17 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s1_17 - s0_17;
    // Op 18: dim1x1 mul
    gl64_t s1_18 = *(gl64_t*)&expressions_params[9][11];
    tmp1_0 = tmp1_0 * s1_18;
    // Op 19: dim1x1 mul
    gl64_t s0_19 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_19 * tmp1_0;
    // Op 20: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 21: dim1x1 sub_swap
    gl64_t s0_21 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_21 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s1_21 - s0_21;
    // Op 22: dim1x1 sub_swap
    gl64_t s0_22 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_22 = *(gl64_t*)&expressions_params[9][4];
    tmp1_2 = s1_22 - s0_22;
    // Op 23: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_2;
    // Op 24: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 25: dim1x1 mul
    gl64_t s0_25 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_3 = s0_25 * tmp1_0;
    // Op 26: dim1x1 mul
    gl64_t s0_26 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_26 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = s0_26 * s1_26;
    // Op 27: dim1x1 sub_swap
    gl64_t s0_27 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_27 = *(gl64_t*)&expressions_params[9][4];
    tmp1_1 = s1_27 - s0_27;
    // Op 28: dim1x1 mul
    tmp1_1 = tmp1_0 * tmp1_1;
    // Op 29: dim1x1 mul
    gl64_t s0_29 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_29 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_29 * s1_29;
    // Op 30: dim1x1 mul
    gl64_t s0_30 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_30 * tmp1_0;
    // Op 31: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 32: dim1x1 sub_swap
    gl64_t s0_32 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_32 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s1_32 - s0_32;
    // Op 33: dim1x1 mul
    gl64_t s1_33 = *(gl64_t*)&expressions_params[9][11];
    tmp1_0 = tmp1_0 * s1_33;
    // Op 34: dim1x1 sub_swap
    gl64_t s0_34 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    gl64_t s1_34 = *(gl64_t*)&expressions_params[9][4];
    tmp1_1 = s1_34 - s0_34;
    // Op 35: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 36: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_0;
    // Op 37: dim1x1 sub_swap
    gl64_t s0_37 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_37 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s1_37 - s0_37;
    // Op 38: dim1x1 mul
    gl64_t s0_38 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_38 * tmp1_0;
    // Op 39: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 40: dim1x1 mul
    gl64_t s0_40 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_40 * tmp1_0;
    // Op 41: dim1x1 add
    tmp1_3 = tmp1_3 + tmp1_0;
    // Op 42: dim1x1 sub_swap
    gl64_t s0_42 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_42 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s1_42 - s0_42;
    // Op 43: dim1x1 mul
    gl64_t s1_43 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = tmp1_0 * s1_43;
    // Op 44: dim1x1 add
    gl64_t s0_44 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_44 + tmp1_0;
    // Op 45: dim1x1 mul
    gl64_t s0_45 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_45 * tmp1_0;
    // Op 46: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_0;
    // Op 47: dim1x1 sub
    gl64_t s0_47 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_47 - tmp1_0;
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
    tmp3_12 = (kC49 + kG49) - kF49;
    tmp3_13 = ((((kA49 + kC49) - kE49) - kE49) - kD49);
    tmp3_14 = kB49 - kG49;
    // Op 50: dim3x1 mul
    gl64_t s0_50_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_50_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_50_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_50 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp3_0 = s0_50_0 * s1_50; tmp3_1 = s0_50_1 * s1_50; tmp3_2 = s0_50_2 * s1_50;
    // Op 51: dim3x1 add
    gl64_t s1_51 = *(gl64_t*)&expressions_params[9][2];
    tmp3_9 = tmp3_0 + s1_51; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 52: dim3x3 add
    gl64_t s1_52_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_52_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_52_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_52_0; tmp3_4 = tmp3_10 + s1_52_1; tmp3_5 = tmp3_11 + s1_52_2;
    // Op 53: dim3x1 mul
    gl64_t s0_53_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_53_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_53_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_53 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp3_0 = s0_53_0 * s1_53; tmp3_1 = s0_53_1 * s1_53; tmp3_2 = s0_53_2 * s1_53;
    // Op 54: dim3x1 add
    gl64_t s1_54 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_54; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 55: dim3x3 mul
    gl64_t s1_55_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_55_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_55_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 56: dim3x1 add
    gl64_t s1_56 = *(gl64_t*)&expressions_params[9][0];
    tmp3_6 = tmp3_0 + s1_56; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 57: dim3x3 add
    gl64_t s1_57_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_57_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_57_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_57_0; tmp3_1 = tmp3_7 + s1_57_1; tmp3_2 = tmp3_8 + s1_57_2;
    // Op 58: dim3x3 mul
    gl64_t kA58 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB58 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC58 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD58 = tmp3_3 * tmp3_0;
    gl64_t kE58 = tmp3_4 * tmp3_1;
    gl64_t kF58 = tmp3_5 * tmp3_2;
    gl64_t kG58 = kD58 - kE58;
    tmp3_0 = (kC58 + kG58) - kF58;
    tmp3_1 = ((((kA58 + kC58) - kE58) - kE58) - kD58);
    tmp3_2 = kB58 - kG58;
    // Op 59: dim3x3 mul
    gl64_t s0_59_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_59_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_59_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA59 = (s0_59_0 + s0_59_1) * (tmp3_0 + tmp3_1);
    gl64_t kB59 = (s0_59_0 + s0_59_2) * (tmp3_0 + tmp3_2);
    gl64_t kC59 = (s0_59_1 + s0_59_2) * (tmp3_1 + tmp3_2);
    gl64_t kD59 = s0_59_0 * tmp3_0;
    gl64_t kE59 = s0_59_1 * tmp3_1;
    gl64_t kF59 = s0_59_2 * tmp3_2;
    gl64_t kG59 = kD59 - kE59;
    tmp3_0 = (kC59 + kG59) - kF59;
    tmp3_1 = ((((kA59 + kC59) - kE59) - kE59) - kD59);
    tmp3_2 = kB59 - kG59;
    // Op 60: dim3x3 add
    gl64_t s1_60_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_60_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_60_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_60_0; tmp3_7 = tmp3_7 + s1_60_1; tmp3_8 = tmp3_8 + s1_60_2;
    // Op 61: dim3x1 mul
    gl64_t s1_61 = *(gl64_t*)&expressions_params[9][1];
    tmp3_6 = tmp3_6 * s1_61; tmp3_7 = tmp3_7 * s1_61; tmp3_8 = tmp3_8 * s1_61;
    // Op 62: dim3x3 add
    gl64_t s1_62_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_62_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_62_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_62_0; tmp3_10 = tmp3_10 + s1_62_1; tmp3_11 = tmp3_11 + s1_62_2;
    // Op 63: dim3x1 mul
    gl64_t s1_63 = *(gl64_t*)&expressions_params[9][1];
    tmp3_9 = tmp3_9 * s1_63; tmp3_10 = tmp3_10 * s1_63; tmp3_11 = tmp3_11 * s1_63;
    // Op 64: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 65: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 66: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 67: dim3x3 mul
    gl64_t s1_67_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_67_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_67_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA67 = (tmp3_0 + tmp3_1) * (s1_67_0 + s1_67_1);
    gl64_t kB67 = (tmp3_0 + tmp3_2) * (s1_67_0 + s1_67_2);
    gl64_t kC67 = (tmp3_1 + tmp3_2) * (s1_67_1 + s1_67_2);
    gl64_t kD67 = tmp3_0 * s1_67_0;
    gl64_t kE67 = tmp3_1 * s1_67_1;
    gl64_t kF67 = tmp3_2 * s1_67_2;
    gl64_t kG67 = kD67 - kE67;
    tmp3_12 = (kC67 + kG67) - kF67;
    tmp3_13 = ((((kA67 + kC67) - kE67) - kE67) - kD67);
    tmp3_14 = kB67 - kG67;
    // Op 68: dim1x1 sub
    gl64_t s0_68 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    gl64_t s1_68 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_68 - s1_68;
    // Op 69: dim1x1 mul
    gl64_t s0_69 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_69 * tmp1_0;
    // Op 70: dim1x1 add
    gl64_t s0_70 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_0 = s0_70 + tmp1_0;
    // Op 71: dim3x1 mul
    gl64_t s0_71_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_71_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_71_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_71_0 * tmp1_0; tmp3_1 = s0_71_1 * tmp1_0; tmp3_2 = s0_71_2 * tmp1_0;
    // Op 72: dim1x1 sub
    gl64_t s0_72 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_72 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_72 - s1_72;
    // Op 73: dim1x1 mul
    gl64_t s0_73 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp1_0 = s0_73 * tmp1_0;
    // Op 74: dim1x1 add
    gl64_t s0_74 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_74 + tmp1_0;
    // Op 75: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 76: dim3x3 mul
    gl64_t s1_76_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_76_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_76_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA76 = (tmp3_0 + tmp3_1) * (s1_76_0 + s1_76_1);
    gl64_t kB76 = (tmp3_0 + tmp3_2) * (s1_76_0 + s1_76_2);
    gl64_t kC76 = (tmp3_1 + tmp3_2) * (s1_76_1 + s1_76_2);
    gl64_t kD76 = tmp3_0 * s1_76_0;
    gl64_t kE76 = tmp3_1 * s1_76_1;
    gl64_t kF76 = tmp3_2 * s1_76_2;
    gl64_t kG76 = kD76 - kE76;
    tmp3_0 = (kC76 + kG76) - kF76;
    tmp3_1 = ((((kA76 + kC76) - kE76) - kE76) - kD76);
    tmp3_2 = kB76 - kG76;
    // Op 77: dim3x1 add
    gl64_t s1_77 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = tmp3_0 + s1_77; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 78: dim3x3 mul
    gl64_t s1_78_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_78_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_78_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 79: dim3x1 add
    gl64_t s1_79 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_79; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 80: dim3x3 mul
    gl64_t s1_80_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_80_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_80_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 81: dim1x1 mul
    gl64_t s0_81 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_81 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_81 * s1_81;
    // Op 82: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 83: dim3x3 mul
    gl64_t s1_83_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_83_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_83_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 84: dim3x1 add
    gl64_t s1_84 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_84; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 85: dim3x3 mul
    gl64_t s1_85_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_85_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_85_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA85 = (tmp3_0 + tmp3_1) * (s1_85_0 + s1_85_1);
    gl64_t kB85 = (tmp3_0 + tmp3_2) * (s1_85_0 + s1_85_2);
    gl64_t kC85 = (tmp3_1 + tmp3_2) * (s1_85_1 + s1_85_2);
    gl64_t kD85 = tmp3_0 * s1_85_0;
    gl64_t kE85 = tmp3_1 * s1_85_1;
    gl64_t kF85 = tmp3_2 * s1_85_2;
    gl64_t kG85 = kD85 - kE85;
    tmp3_0 = (kC85 + kG85) - kF85;
    tmp3_1 = ((((kA85 + kC85) - kE85) - kE85) - kD85);
    tmp3_2 = kB85 - kG85;
    // Op 86: dim3x1 add
    gl64_t s1_86 = *(gl64_t*)&expressions_params[9][5];
    tmp3_0 = tmp3_0 + s1_86; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 87: dim3x3 add
    gl64_t s1_87_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_87_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_87_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_87_0; tmp3_1 = tmp3_1 + s1_87_1; tmp3_2 = tmp3_2 + s1_87_2;
    // Op 88: dim3x3 mul
    gl64_t s0_88_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_88_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_88_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA88 = (s0_88_0 + s0_88_1) * (tmp3_0 + tmp3_1);
    gl64_t kB88 = (s0_88_0 + s0_88_2) * (tmp3_0 + tmp3_2);
    gl64_t kC88 = (s0_88_1 + s0_88_2) * (tmp3_1 + tmp3_2);
    gl64_t kD88 = s0_88_0 * tmp3_0;
    gl64_t kE88 = s0_88_1 * tmp3_1;
    gl64_t kF88 = s0_88_2 * tmp3_2;
    gl64_t kG88 = kD88 - kE88;
    tmp3_0 = (kC88 + kG88) - kF88;
    tmp3_1 = ((((kA88 + kC88) - kE88) - kE88) - kD88);
    tmp3_2 = kB88 - kG88;
    // Op 89: dim3x1 add
    gl64_t s1_89 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_89; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 90: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 91: dim3x3 mul
    gl64_t s1_91_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_91_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_91_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA91 = (tmp3_0 + tmp3_1) * (s1_91_0 + s1_91_1);
    gl64_t kB91 = (tmp3_0 + tmp3_2) * (s1_91_0 + s1_91_2);
    gl64_t kC91 = (tmp3_1 + tmp3_2) * (s1_91_1 + s1_91_2);
    gl64_t kD91 = tmp3_0 * s1_91_0;
    gl64_t kE91 = tmp3_1 * s1_91_1;
    gl64_t kF91 = tmp3_2 * s1_91_2;
    gl64_t kG91 = kD91 - kE91;
    tmp3_6 = (kC91 + kG91) - kF91;
    tmp3_7 = ((((kA91 + kC91) - kE91) - kE91) - kD91);
    tmp3_8 = kB91 - kG91;
    // Op 92: dim1x1 sub_swap
    gl64_t s0_92 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_92 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s1_92 - s0_92;
    // Op 93: dim3x1 mul
    uint64_t s0_93_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_93_0 = *(gl64_t*)&dParams->aux_trace[s0_93_pos];
    gl64_t s0_93_1 = *(gl64_t*)&dParams->aux_trace[s0_93_pos + TILE_HEIGHT];
    gl64_t s0_93_2 = *(gl64_t*)&dParams->aux_trace[s0_93_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_93_0 * tmp1_0; tmp3_1 = s0_93_1 * tmp1_0; tmp3_2 = s0_93_2 * tmp1_0;
    // Op 94: dim3x3 sub
    uint64_t s0_94_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_94_0 = *(gl64_t*)&dParams->aux_trace[s0_94_pos];
    gl64_t s0_94_1 = *(gl64_t*)&dParams->aux_trace[s0_94_pos + TILE_HEIGHT];
    gl64_t s0_94_2 = *(gl64_t*)&dParams->aux_trace[s0_94_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_94_0 - tmp3_0; tmp3_1 = s0_94_1 - tmp3_1; tmp3_2 = s0_94_2 - tmp3_2;
    // Op 95: dim3x3 add
    gl64_t s0_95_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_95_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_95_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_95_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_95_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_95_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_12 = s0_95_0 + s1_95_0; tmp3_13 = s0_95_1 + s1_95_1; tmp3_14 = s0_95_2 + s1_95_2;
    // Op 96: dim3x3 sub
    tmp3_12 = tmp3_0 - tmp3_12; tmp3_13 = tmp3_1 - tmp3_13; tmp3_14 = tmp3_2 - tmp3_14;
    // Op 97: dim3x1 mul
    gl64_t s0_97_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_97_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_97_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_97 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp3_0 = s0_97_0 * s1_97; tmp3_1 = s0_97_1 * s1_97; tmp3_2 = s0_97_2 * s1_97;
    // Op 98: dim3x1 add
    gl64_t s1_98 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_98; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 99: dim3x3 mul
    gl64_t s1_99_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_99_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_99_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 100: dim3x1 add
    gl64_t s1_100 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_100; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 101: dim3x3 mul
    gl64_t s1_101_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_101_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_101_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA101 = (tmp3_0 + tmp3_1) * (s1_101_0 + s1_101_1);
    gl64_t kB101 = (tmp3_0 + tmp3_2) * (s1_101_0 + s1_101_2);
    gl64_t kC101 = (tmp3_1 + tmp3_2) * (s1_101_1 + s1_101_2);
    gl64_t kD101 = tmp3_0 * s1_101_0;
    gl64_t kE101 = tmp3_1 * s1_101_1;
    gl64_t kF101 = tmp3_2 * s1_101_2;
    gl64_t kG101 = kD101 - kE101;
    tmp3_0 = (kC101 + kG101) - kF101;
    tmp3_1 = ((((kA101 + kC101) - kE101) - kE101) - kD101);
    tmp3_2 = kB101 - kG101;
    // Op 102: dim1x1 mul
    gl64_t s0_102 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_102 = *(gl64_t*)&expressions_params[9][3];
    tmp1_2 = s0_102 * s1_102;
    // Op 103: dim1x1 mul
    gl64_t s0_103 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_103 = *(gl64_t*)&expressions_params[9][6];
    tmp1_0 = s0_103 * s1_103;
    // Op 104: dim1x1 mul
    gl64_t s0_104 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    gl64_t s1_104 = *(gl64_t*)&expressions_params[9][7];
    tmp1_3 = s0_104 * s1_104;
    // Op 105: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 106: dim1x1 add
    gl64_t s0_106 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp1_0 = s0_106 + tmp1_0;
    // Op 107: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
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
    gl64_t s1_112 = *(gl64_t*)&expressions_params[9][5];
    tmp3_0 = tmp3_0 + s1_112; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 113: dim3x3 add
    gl64_t s1_113_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_113_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_113_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_113_0; tmp3_1 = tmp3_1 + s1_113_1; tmp3_2 = tmp3_2 + s1_113_2;
    // Op 114: dim3x3 mul
    gl64_t kA114 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB114 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC114 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD114 = tmp3_12 * tmp3_0;
    gl64_t kE114 = tmp3_13 * tmp3_1;
    gl64_t kF114 = tmp3_14 * tmp3_2;
    gl64_t kG114 = kD114 - kE114;
    tmp3_0 = (kC114 + kG114) - kF114;
    tmp3_1 = ((((kA114 + kC114) - kE114) - kE114) - kD114);
    tmp3_2 = kB114 - kG114;
    // Op 115: dim3x1 sub
    gl64_t s1_115 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 - s1_115; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 116: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    tmp3_6 = (kC117 + kG117) - kF117;
    tmp3_7 = ((((kA117 + kC117) - kE117) - kE117) - kD117);
    tmp3_8 = kB117 - kG117;
    // Op 118: dim3x1 mul
    gl64_t s0_118_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_118_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_118_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_118 = *(gl64_t*)&expressions_params[9][3];
    tmp3_0 = s0_118_0 * s1_118; tmp3_1 = s0_118_1 * s1_118; tmp3_2 = s0_118_2 * s1_118;
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
    // Op 120: dim3x3 mul
    gl64_t s1_120_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_120_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_120_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA120 = (tmp3_0 + tmp3_1) * (s1_120_0 + s1_120_1);
    gl64_t kB120 = (tmp3_0 + tmp3_2) * (s1_120_0 + s1_120_2);
    gl64_t kC120 = (tmp3_1 + tmp3_2) * (s1_120_1 + s1_120_2);
    gl64_t kD120 = tmp3_0 * s1_120_0;
    gl64_t kE120 = tmp3_1 * s1_120_1;
    gl64_t kF120 = tmp3_2 * s1_120_2;
    gl64_t kG120 = kD120 - kE120;
    tmp3_0 = (kC120 + kG120) - kF120;
    tmp3_1 = ((((kA120 + kC120) - kE120) - kE120) - kD120);
    tmp3_2 = kB120 - kG120;
    // Op 121: dim3x1 add
    gl64_t s1_121 = *(gl64_t*)&expressions_params[9][4];
    tmp3_0 = tmp3_0 + s1_121; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 122: dim3x3 mul
    gl64_t s1_122_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_122_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_122_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 123: dim3x1 add
    gl64_t s1_123 = *(gl64_t*)&expressions_params[9][5];
    tmp3_0 = tmp3_0 + s1_123; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 124: dim3x3 add
    gl64_t s1_124_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_124_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_124_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_124_0; tmp3_1 = tmp3_1 + s1_124_1; tmp3_2 = tmp3_2 + s1_124_2;
    // Op 125: dim3x3 mul
    gl64_t s1_125_0 = *(gl64_t*)&expressions_params[10][1];
    gl64_t s1_125_1 = *(gl64_t*)&expressions_params[10][1+1];
    gl64_t s1_125_2 = *(gl64_t*)&expressions_params[10][1+2];
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
    // Op 126: dim3x1 sub
    gl64_t s1_126 = *(gl64_t*)&expressions_params[10][0];
    tmp3_0 = tmp3_0 - s1_126; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 127: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 128: dim3x3 mul
    gl64_t s1_128_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_128_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_128_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA128 = (tmp3_0 + tmp3_1) * (s1_128_0 + s1_128_1);
    gl64_t kB128 = (tmp3_0 + tmp3_2) * (s1_128_0 + s1_128_2);
    gl64_t kC128 = (tmp3_1 + tmp3_2) * (s1_128_1 + s1_128_2);
    gl64_t kD128 = tmp3_0 * s1_128_0;
    gl64_t kE128 = tmp3_1 * s1_128_1;
    gl64_t kF128 = tmp3_2 * s1_128_2;
    gl64_t kG128 = kD128 - kE128;
    tmp3_6 = (kC128 + kG128) - kF128;
    tmp3_7 = ((((kA128 + kC128) - kE128) - kE128) - kD128);
    tmp3_8 = kB128 - kG128;
    // Op 129: dim3x3 mul
    gl64_t s0_129_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_129_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_129_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_129_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_129_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_129_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA129 = (s0_129_0 + s0_129_1) * (s1_129_0 + s1_129_1);
    gl64_t kB129 = (s0_129_0 + s0_129_2) * (s1_129_0 + s1_129_2);
    gl64_t kC129 = (s0_129_1 + s0_129_2) * (s1_129_1 + s1_129_2);
    gl64_t kD129 = s0_129_0 * s1_129_0;
    gl64_t kE129 = s0_129_1 * s1_129_1;
    gl64_t kF129 = s0_129_2 * s1_129_2;
    gl64_t kG129 = kD129 - kE129;
    tmp3_0 = (kC129 + kG129) - kF129;
    tmp3_1 = ((((kA129 + kC129) - kE129) - kE129) - kD129);
    tmp3_2 = kB129 - kG129;
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
    gl64_t s1_131 = *(gl64_t*)&expressions_params[9][4];
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
    gl64_t s1_133 = *(gl64_t*)&expressions_params[9][5];
    tmp3_0 = tmp3_0 + s1_133; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 134: dim3x3 add
    gl64_t s1_134_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_134_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_134_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_134_0; tmp3_1 = tmp3_1 + s1_134_1; tmp3_2 = tmp3_2 + s1_134_2;
    // Op 135: dim3x3 mul
    gl64_t s1_135_0 = *(gl64_t*)&expressions_params[10][4];
    gl64_t s1_135_1 = *(gl64_t*)&expressions_params[10][4+1];
    gl64_t s1_135_2 = *(gl64_t*)&expressions_params[10][4+2];
    gl64_t kA135 = (tmp3_0 + tmp3_1) * (s1_135_0 + s1_135_1);
    gl64_t kB135 = (tmp3_0 + tmp3_2) * (s1_135_0 + s1_135_2);
    gl64_t kC135 = (tmp3_1 + tmp3_2) * (s1_135_1 + s1_135_2);
    gl64_t kD135 = tmp3_0 * s1_135_0;
    gl64_t kE135 = tmp3_1 * s1_135_1;
    gl64_t kF135 = tmp3_2 * s1_135_2;
    gl64_t kG135 = kD135 - kE135;
    tmp3_0 = (kC135 + kG135) - kF135;
    tmp3_1 = ((((kA135 + kC135) - kE135) - kE135) - kD135);
    tmp3_2 = kB135 - kG135;
    // Op 136: dim1x1 sub
    gl64_t s0_136 = *(gl64_t*)&expressions_params[9][8];
    gl64_t s1_136 = *(gl64_t*)&expressions_params[10][0];
    tmp1_0 = s0_136 - s1_136;
    // Op 137: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 138: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    tmp3_12 = (kC139 + kG139) - kF139;
    tmp3_13 = ((((kA139 + kC139) - kE139) - kE139) - kD139);
    tmp3_14 = kB139 - kG139;
    // Op 140: dim3x3 sub_swap
    uint64_t s0_140_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_140_0 = *(gl64_t*)&dParams->aux_trace[s0_140_pos];
    gl64_t s0_140_1 = *(gl64_t*)&dParams->aux_trace[s0_140_pos + TILE_HEIGHT];
    gl64_t s0_140_2 = *(gl64_t*)&dParams->aux_trace[s0_140_pos + 2*TILE_HEIGHT];
    gl64_t s1_140_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_140_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_140_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_0 = s1_140_0 - s0_140_0; tmp3_1 = s1_140_1 - s0_140_1; tmp3_2 = s1_140_2 - s0_140_2;
    // Op 141: dim3x3 add
    gl64_t s0_141_0 = *(gl64_t*)&expressions_params[10][1];
    gl64_t s0_141_1 = *(gl64_t*)&expressions_params[10][1+1];
    gl64_t s0_141_2 = *(gl64_t*)&expressions_params[10][1+2];
    gl64_t s1_141_0 = *(gl64_t*)&expressions_params[10][4];
    gl64_t s1_141_1 = *(gl64_t*)&expressions_params[10][4+1];
    gl64_t s1_141_2 = *(gl64_t*)&expressions_params[10][4+2];
    tmp3_6 = s0_141_0 + s1_141_0; tmp3_7 = s0_141_1 + s1_141_1; tmp3_8 = s0_141_2 + s1_141_2;
    // Op 142: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 143: dim3x1 mul
    gl64_t s1_143 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_143; tmp3_1 = tmp3_1 * s1_143; tmp3_2 = tmp3_2 * s1_143;
    // Op 144: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 145: dim3x1 mul
    gl64_t s1_145 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_145; tmp3_1 = tmp3_1 * s1_145; tmp3_2 = tmp3_2 * s1_145;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
