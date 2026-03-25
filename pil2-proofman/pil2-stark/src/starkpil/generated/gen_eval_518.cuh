// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: 5c75a2d5  nOps=427 nTemp1=4 nTemp3=5
#define GENERATED_EVAL_NOPS_5c75a2d5 427
#define GENERATED_EVAL_NTEMP1_5c75a2d5 4
#define GENERATED_EVAL_NTEMP3_5c75a2d5 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_5c75a2d5(
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

    // Op 0: dim1x1 sub
    gl64_t s0_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 8, domainSize, nCols_1))];
    gl64_t s1_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_0 - s1_0;
    // Op 1: dim1x1 mul
    gl64_t s0_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp1_0 = s0_1 * tmp1_0;
    // Op 2: dim1x1 mul
    gl64_t s0_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_2 * tmp1_0;
    // Op 3: dim3x1 mul
    gl64_t s0_3_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s0_3_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s0_3_2 = *(gl64_t*)&expressions_params[13][6+2];
    tmp3_0 = s0_3_0 * tmp1_0; tmp3_1 = s0_3_1 * tmp1_0; tmp3_2 = s0_3_2 * tmp1_0;
    // Op 4: dim1x1 sub
    gl64_t s0_4 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 8, domainSize, nCols_1))];
    gl64_t s1_4 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_4 - s1_4;
    // Op 5: dim1x1 mul
    gl64_t s0_5 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp1_0 = s0_5 * tmp1_0;
    // Op 6: dim1x1 mul
    gl64_t s0_6 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_6 * tmp1_0;
    // Op 7: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 8: dim3x3 mul
    gl64_t s1_8_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_8_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_8_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA8 = (tmp3_0 + tmp3_1) * (s1_8_0 + s1_8_1);
    gl64_t kB8 = (tmp3_0 + tmp3_2) * (s1_8_0 + s1_8_2);
    gl64_t kC8 = (tmp3_1 + tmp3_2) * (s1_8_1 + s1_8_2);
    gl64_t kD8 = tmp3_0 * s1_8_0;
    gl64_t kE8 = tmp3_1 * s1_8_1;
    gl64_t kF8 = tmp3_2 * s1_8_2;
    gl64_t kG8 = kD8 - kE8;
    tmp3_0 = (kC8 + kG8) - kF8;
    tmp3_1 = ((((kA8 + kC8) - kE8) - kE8) - kD8);
    tmp3_2 = kB8 - kG8;
    // Op 9: dim1x1 sub
    gl64_t s0_9 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    gl64_t s1_9 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_9 - s1_9;
    // Op 10: dim1x1 mul
    gl64_t s0_10 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_10 * tmp1_0;
    // Op 11: dim1x1 mul
    gl64_t s0_11 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
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
    // Op 14: dim1x1 sub
    gl64_t s0_14 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 9, domainSize, nCols_1))];
    gl64_t s1_14 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_14 - s1_14;
    // Op 15: dim1x1 mul
    gl64_t s0_15 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_15 * tmp1_0;
    // Op 16: dim1x1 mul
    gl64_t s0_16 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_16 * tmp1_0;
    // Op 17: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 18: dim3x3 mul
    gl64_t s1_18_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_18_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_18_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA18 = (tmp3_0 + tmp3_1) * (s1_18_0 + s1_18_1);
    gl64_t kB18 = (tmp3_0 + tmp3_2) * (s1_18_0 + s1_18_2);
    gl64_t kC18 = (tmp3_1 + tmp3_2) * (s1_18_1 + s1_18_2);
    gl64_t kD18 = tmp3_0 * s1_18_0;
    gl64_t kE18 = tmp3_1 * s1_18_1;
    gl64_t kF18 = tmp3_2 * s1_18_2;
    gl64_t kG18 = kD18 - kE18;
    tmp3_0 = (kC18 + kG18) - kF18;
    tmp3_1 = ((((kA18 + kC18) - kE18) - kE18) - kD18);
    tmp3_2 = kB18 - kG18;
    // Op 19: dim1x1 sub
    gl64_t s0_19 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 10, domainSize, nCols_1))];
    gl64_t s1_19 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_19 - s1_19;
    // Op 20: dim1x1 mul
    gl64_t s0_20 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp1_0 = s0_20 * tmp1_0;
    // Op 21: dim1x1 mul
    gl64_t s0_21 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_21 * tmp1_0;
    // Op 22: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 23: dim3x3 mul
    gl64_t s1_23_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_23_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_23_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA23 = (tmp3_0 + tmp3_1) * (s1_23_0 + s1_23_1);
    gl64_t kB23 = (tmp3_0 + tmp3_2) * (s1_23_0 + s1_23_2);
    gl64_t kC23 = (tmp3_1 + tmp3_2) * (s1_23_1 + s1_23_2);
    gl64_t kD23 = tmp3_0 * s1_23_0;
    gl64_t kE23 = tmp3_1 * s1_23_1;
    gl64_t kF23 = tmp3_2 * s1_23_2;
    gl64_t kG23 = kD23 - kE23;
    tmp3_0 = (kC23 + kG23) - kF23;
    tmp3_1 = ((((kA23 + kC23) - kE23) - kE23) - kD23);
    tmp3_2 = kB23 - kG23;
    // Op 24: dim1x1 sub
    gl64_t s0_24 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 10, domainSize, nCols_1))];
    gl64_t s1_24 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_24 - s1_24;
    // Op 25: dim1x1 mul
    gl64_t s0_25 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp1_0 = s0_25 * tmp1_0;
    // Op 26: dim1x1 mul
    gl64_t s0_26 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_26 * tmp1_0;
    // Op 27: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 28: dim3x3 mul
    gl64_t s1_28_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_28_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_28_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA28 = (tmp3_0 + tmp3_1) * (s1_28_0 + s1_28_1);
    gl64_t kB28 = (tmp3_0 + tmp3_2) * (s1_28_0 + s1_28_2);
    gl64_t kC28 = (tmp3_1 + tmp3_2) * (s1_28_1 + s1_28_2);
    gl64_t kD28 = tmp3_0 * s1_28_0;
    gl64_t kE28 = tmp3_1 * s1_28_1;
    gl64_t kF28 = tmp3_2 * s1_28_2;
    gl64_t kG28 = kD28 - kE28;
    tmp3_0 = (kC28 + kG28) - kF28;
    tmp3_1 = ((((kA28 + kC28) - kE28) - kE28) - kD28);
    tmp3_2 = kB28 - kG28;
    // Op 29: dim1x1 sub
    gl64_t s0_29 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    gl64_t s1_29 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_0 = s0_29 - s1_29;
    // Op 30: dim1x1 mul
    gl64_t s0_30 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_0 = s0_30 * tmp1_0;
    // Op 31: dim1x1 mul
    gl64_t s0_31 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
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
    gl64_t s0_34 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 11, domainSize, nCols_1))];
    gl64_t s1_34 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_0 = s0_34 - s1_34;
    // Op 35: dim1x1 mul
    gl64_t s0_35 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_0 = s0_35 * tmp1_0;
    // Op 36: dim1x1 mul
    gl64_t s0_36 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_36 * tmp1_0;
    // Op 37: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 38: dim3x3 mul
    gl64_t s1_38_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_38_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_38_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA38 = (tmp3_0 + tmp3_1) * (s1_38_0 + s1_38_1);
    gl64_t kB38 = (tmp3_0 + tmp3_2) * (s1_38_0 + s1_38_2);
    gl64_t kC38 = (tmp3_1 + tmp3_2) * (s1_38_1 + s1_38_2);
    gl64_t kD38 = tmp3_0 * s1_38_0;
    gl64_t kE38 = tmp3_1 * s1_38_1;
    gl64_t kF38 = tmp3_2 * s1_38_2;
    gl64_t kG38 = kD38 - kE38;
    tmp3_0 = (kC38 + kG38) - kF38;
    tmp3_1 = ((((kA38 + kC38) - kE38) - kE38) - kD38);
    tmp3_2 = kB38 - kG38;
    // Op 39: dim1x1 sub
    gl64_t s0_39 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_1))];
    gl64_t s1_39 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_39 - s1_39;
    // Op 40: dim1x1 mul
    gl64_t s0_40 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_0 = s0_40 * tmp1_0;
    // Op 41: dim1x1 mul
    gl64_t s0_41 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
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
    // Op 44: dim1x1 sub
    gl64_t s0_44 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 12, domainSize, nCols_1))];
    gl64_t s1_44 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_44 - s1_44;
    // Op 45: dim1x1 mul
    gl64_t s0_45 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_0 = s0_45 * tmp1_0;
    // Op 46: dim1x1 mul
    gl64_t s0_46 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_46 * tmp1_0;
    // Op 47: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 48: dim3x3 mul
    gl64_t s1_48_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_48_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_48_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA48 = (tmp3_0 + tmp3_1) * (s1_48_0 + s1_48_1);
    gl64_t kB48 = (tmp3_0 + tmp3_2) * (s1_48_0 + s1_48_2);
    gl64_t kC48 = (tmp3_1 + tmp3_2) * (s1_48_1 + s1_48_2);
    gl64_t kD48 = tmp3_0 * s1_48_0;
    gl64_t kE48 = tmp3_1 * s1_48_1;
    gl64_t kF48 = tmp3_2 * s1_48_2;
    gl64_t kG48 = kD48 - kE48;
    tmp3_0 = (kC48 + kG48) - kF48;
    tmp3_1 = ((((kA48 + kC48) - kE48) - kE48) - kD48);
    tmp3_2 = kB48 - kG48;
    // Op 49: dim1x1 sub
    gl64_t s0_49 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    gl64_t s1_49 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_49 - s1_49;
    // Op 50: dim1x1 mul
    gl64_t s0_50 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_50 * tmp1_0;
    // Op 51: dim1x1 mul
    gl64_t s0_51 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_51 * tmp1_0;
    // Op 52: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 53: dim3x3 mul
    gl64_t s1_53_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_53_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_53_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA53 = (tmp3_0 + tmp3_1) * (s1_53_0 + s1_53_1);
    gl64_t kB53 = (tmp3_0 + tmp3_2) * (s1_53_0 + s1_53_2);
    gl64_t kC53 = (tmp3_1 + tmp3_2) * (s1_53_1 + s1_53_2);
    gl64_t kD53 = tmp3_0 * s1_53_0;
    gl64_t kE53 = tmp3_1 * s1_53_1;
    gl64_t kF53 = tmp3_2 * s1_53_2;
    gl64_t kG53 = kD53 - kE53;
    tmp3_0 = (kC53 + kG53) - kF53;
    tmp3_1 = ((((kA53 + kC53) - kE53) - kE53) - kD53);
    tmp3_2 = kB53 - kG53;
    // Op 54: dim1x1 sub
    gl64_t s0_54 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 13, domainSize, nCols_1))];
    gl64_t s1_54 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_54 - s1_54;
    // Op 55: dim1x1 mul
    gl64_t s0_55 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_55 * tmp1_0;
    // Op 56: dim1x1 mul
    gl64_t s0_56 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_56 * tmp1_0;
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
    gl64_t s0_59 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    gl64_t s1_59 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_59 - s1_59;
    // Op 60: dim1x1 mul
    gl64_t s0_60 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_60 * tmp1_0;
    // Op 61: dim1x1 mul
    gl64_t s0_61 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
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
    // Op 64: dim1x1 sub
    gl64_t s0_64 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 14, domainSize, nCols_1))];
    gl64_t s1_64 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_64 - s1_64;
    // Op 65: dim1x1 mul
    gl64_t s0_65 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_65 * tmp1_0;
    // Op 66: dim1x1 mul
    gl64_t s0_66 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_66 * tmp1_0;
    // Op 67: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 69: dim1x1 sub
    gl64_t s0_69 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    gl64_t s1_69 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_0 = s0_69 - s1_69;
    // Op 70: dim1x1 mul
    gl64_t s0_70 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = s0_70 * tmp1_0;
    // Op 71: dim1x1 mul
    gl64_t s0_71 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp1_0 = s0_71 * tmp1_0;
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
    // Op 74: dim1x1 sub
    gl64_t s0_74 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 15, domainSize, nCols_1))];
    gl64_t s1_74 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_0 = s0_74 - s1_74;
    // Op 75: dim1x1 mul
    gl64_t s0_75 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = s0_75 * tmp1_0;
    // Op 76: dim1x1 mul
    gl64_t s0_76 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_0 = s0_76 * tmp1_0;
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
    gl64_t s0_79 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    gl64_t s1_79 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_79 * s1_79;
    // Op 80: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 81: dim3x3 mul
    gl64_t s1_81_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_81_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_81_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA81 = (tmp3_0 + tmp3_1) * (s1_81_0 + s1_81_1);
    gl64_t kB81 = (tmp3_0 + tmp3_2) * (s1_81_0 + s1_81_2);
    gl64_t kC81 = (tmp3_1 + tmp3_2) * (s1_81_1 + s1_81_2);
    gl64_t kD81 = tmp3_0 * s1_81_0;
    gl64_t kE81 = tmp3_1 * s1_81_1;
    gl64_t kF81 = tmp3_2 * s1_81_2;
    gl64_t kG81 = kD81 - kE81;
    tmp3_0 = (kC81 + kG81) - kF81;
    tmp3_1 = ((((kA81 + kC81) - kE81) - kE81) - kD81);
    tmp3_2 = kB81 - kG81;
    // Op 82: dim1x1 sub_swap
    gl64_t s0_82 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    gl64_t s1_82 = *(gl64_t*)&expressions_params[9][14];
    tmp1_0 = s1_82 - s0_82;
    // Op 83: dim1x1 mul
    gl64_t s0_83 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp1_0 = s0_83 * tmp1_0;
    // Op 84: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 85: dim3x3 mul
    gl64_t s1_85_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_85_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_85_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 86: dim1x1 sub_swap
    gl64_t s0_86 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    gl64_t s1_86 = *(gl64_t*)&expressions_params[9][14];
    tmp1_0 = s1_86 - s0_86;
    // Op 87: dim1x1 mul
    gl64_t s0_87 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
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
    gl64_t s0_90 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    gl64_t s1_90 = *(gl64_t*)&expressions_params[9][14];
    tmp1_0 = s1_90 - s0_90;
    // Op 91: dim1x1 mul
    gl64_t s0_91 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp1_0 = s0_91 * tmp1_0;
    // Op 92: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 93: dim3x3 mul
    gl64_t s1_93_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_93_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_93_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 94: dim1x1 sub_swap
    gl64_t s0_94 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_94 = *(gl64_t*)&expressions_params[9][14];
    tmp1_0 = s1_94 - s0_94;
    // Op 95: dim1x1 mul
    gl64_t s0_95 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_0 = s0_95 * tmp1_0;
    // Op 96: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 97: dim3x3 mul
    gl64_t s1_97_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_97_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_97_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 98: dim1x1 sub_swap
    gl64_t s0_98 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_98 = *(gl64_t*)&expressions_params[9][14];
    tmp1_0 = s1_98 - s0_98;
    // Op 99: dim1x1 mul
    gl64_t s0_99 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_0 = s0_99 * tmp1_0;
    // Op 100: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 101: dim3x3 mul
    gl64_t s1_101_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_101_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_101_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 102: dim1x1 sub_swap
    gl64_t s0_102 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    gl64_t s1_102 = *(gl64_t*)&expressions_params[9][14];
    tmp1_0 = s1_102 - s0_102;
    // Op 103: dim1x1 mul
    gl64_t s0_103 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_103 * tmp1_0;
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
    gl64_t s0_106 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_106 = *(gl64_t*)&expressions_params[9][14];
    tmp1_0 = s1_106 - s0_106;
    // Op 107: dim1x1 mul
    gl64_t s0_107 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_107 * tmp1_0;
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
    // Op 110: dim1x1 sub_swap
    gl64_t s0_110 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_110 = *(gl64_t*)&expressions_params[9][14];
    tmp1_0 = s1_110 - s0_110;
    // Op 111: dim1x1 mul
    gl64_t s0_111 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = s0_111 * tmp1_0;
    // Op 112: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 113: dim3x3 mul
    gl64_t s1_113_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_113_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_113_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 114: dim1x1 sub_swap
    gl64_t s0_114 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_114 = *(gl64_t*)&expressions_params[9][14];
    tmp1_0 = s1_114 - s0_114;
    // Op 115: dim1x1 mul
    gl64_t s0_115 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
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
    gl64_t s0_118 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_118 = *(gl64_t*)&expressions_params[9][14];
    tmp1_0 = s1_118 - s0_118;
    // Op 119: dim1x1 mul
    gl64_t s0_119 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_0 = s0_119 * tmp1_0;
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
    gl64_t s0_122 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_122 = *(gl64_t*)&expressions_params[9][14];
    tmp1_0 = s1_122 - s0_122;
    // Op 123: dim1x1 mul
    gl64_t s0_123 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
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
    gl64_t s0_126 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_126 = *(gl64_t*)&expressions_params[9][14];
    tmp1_0 = s1_126 - s0_126;
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
    tmp3_0 = (kC129 + kG129) - kF129;
    tmp3_1 = ((((kA129 + kC129) - kE129) - kE129) - kD129);
    tmp3_2 = kB129 - kG129;
    // Op 130: dim1x1 sub
    gl64_t s0_130 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_130 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_1))];
    tmp1_0 = s0_130 - s1_130;
    // Op 131: dim1x1 sub_swap
    gl64_t s0_131 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_131 = *(gl64_t*)&expressions_params[9][14];
    tmp1_1 = s1_131 - s0_131;
    // Op 132: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 133: dim1x1 sub
    gl64_t s0_133 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp1_0 = s0_133 - tmp1_0;
    // Op 134: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC135 + kG135) - kF135;
    tmp3_1 = ((((kA135 + kC135) - kE135) - kE135) - kD135);
    tmp3_2 = kB135 - kG135;
    // Op 136: dim1x1 add
    gl64_t s0_136 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_136 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_3 = s0_136 + s1_136;
    // Op 137: dim1x1 mul
    gl64_t s0_137 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_137 * tmp1_3;
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
    // Op 140: dim1x1 mul
    gl64_t s0_140 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_140 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = s0_140 * s1_140;
    // Op 141: dim1x1 add
    gl64_t s0_141 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_141 + tmp1_0;
    // Op 142: dim1x1 mul
    gl64_t s0_142 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_142 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_142 * s1_142;
    // Op 143: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 144: dim1x1 mul
    gl64_t s0_144 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_144 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_144 * s1_144;
    // Op 145: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 146: dim1x1 mul
    gl64_t s0_146 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp1_2 = s0_146 * tmp1_0;
    // Op 147: dim1x1 mul
    gl64_t s0_147 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_147 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = s0_147 * s1_147;
    // Op 148: dim1x1 add
    gl64_t s0_148 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_148 + tmp1_0;
    // Op 149: dim1x1 mul
    gl64_t s0_149 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_149 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_149 * s1_149;
    // Op 150: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 151: dim1x1 mul
    gl64_t s0_151 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_151 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_151 * s1_151;
    // Op 152: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 153: dim1x1 mul
    gl64_t s0_153 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_153 * tmp1_0;
    // Op 154: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 155: dim1x1 mul
    gl64_t s0_155 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_155 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = s0_155 * s1_155;
    // Op 156: dim1x1 add
    gl64_t s0_156 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_156 + tmp1_0;
    // Op 157: dim1x1 mul
    gl64_t s0_157 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_157 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_157 * s1_157;
    // Op 158: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 159: dim1x1 mul
    gl64_t s0_159 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_159 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_159 * s1_159;
    // Op 160: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 161: dim1x1 mul
    gl64_t s0_161 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp1_0 = s0_161 * tmp1_0;
    // Op 162: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 163: dim1x1 mul
    gl64_t s0_163 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_163 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = s0_163 * s1_163;
    // Op 164: dim1x1 add
    gl64_t s0_164 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_0 = s0_164 + tmp1_0;
    // Op 165: dim1x1 mul
    gl64_t s0_165 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_165 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_165 * s1_165;
    // Op 166: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 167: dim1x1 mul
    gl64_t s0_167 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_167 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_167 * s1_167;
    // Op 168: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 169: dim1x1 mul
    gl64_t s0_169 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_0 = s0_169 * tmp1_0;
    // Op 170: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 171: dim1x1 mul
    gl64_t s0_171 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_171 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = s0_171 * s1_171;
    // Op 172: dim1x1 add
    gl64_t s0_172 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_172 + tmp1_0;
    // Op 173: dim1x1 mul
    gl64_t s0_173 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_173 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_173 * s1_173;
    // Op 174: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 175: dim1x1 mul
    gl64_t s0_175 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_175 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_175 * s1_175;
    // Op 176: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 177: dim1x1 mul
    gl64_t s0_177 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_0 = s0_177 * tmp1_0;
    // Op 178: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 179: dim1x1 mul
    gl64_t s0_179 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_179 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = s0_179 * s1_179;
    // Op 180: dim1x1 add
    gl64_t s0_180 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_180 + tmp1_0;
    // Op 181: dim1x1 mul
    gl64_t s0_181 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_181 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_181 * s1_181;
    // Op 182: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 183: dim1x1 mul
    gl64_t s0_183 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_183 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_183 * s1_183;
    // Op 184: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 185: dim1x1 mul
    gl64_t s0_185 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_185 * tmp1_0;
    // Op 186: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 187: dim1x1 mul
    gl64_t s0_187 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_187 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = s0_187 * s1_187;
    // Op 188: dim1x1 add
    gl64_t s0_188 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_188 + tmp1_0;
    // Op 189: dim1x1 mul
    gl64_t s0_189 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_189 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_189 * s1_189;
    // Op 190: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 191: dim1x1 mul
    gl64_t s0_191 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_191 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_191 * s1_191;
    // Op 192: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 193: dim1x1 mul
    gl64_t s0_193 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_193 * tmp1_0;
    // Op 194: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 195: dim1x1 mul
    gl64_t s0_195 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_195 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = s0_195 * s1_195;
    // Op 196: dim1x1 add
    gl64_t s0_196 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_0 = s0_196 + tmp1_0;
    // Op 197: dim1x1 mul
    gl64_t s0_197 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_197 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_197 * s1_197;
    // Op 198: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 199: dim1x1 mul
    gl64_t s0_199 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_199 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_199 * s1_199;
    // Op 200: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 201: dim1x1 mul
    gl64_t s0_201 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = s0_201 * tmp1_0;
    // Op 202: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 203: dim1x1 mul
    gl64_t s0_203 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_1 = s0_203 * tmp1_0;
    // Op 204: dim1x1 mul
    gl64_t s0_204 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_204 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = s0_204 * s1_204;
    // Op 205: dim1x1 add
    gl64_t s0_205 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_205 + tmp1_0;
    // Op 206: dim1x1 mul
    gl64_t s0_206 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_206 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_206 * s1_206;
    // Op 207: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 208: dim1x1 mul
    gl64_t s0_208 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_208 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_208 * s1_208;
    // Op 209: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 210: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 211: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 212: dim1x1 sub
    gl64_t s0_212 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp1_0 = s0_212 - tmp1_0;
    // Op 213: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 214: dim3x3 mul
    gl64_t s1_214_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_214_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_214_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    gl64_t s0_215 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_215 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = s0_215 * s1_215;
    // Op 216: dim1x1 add
    gl64_t s0_216 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_216 + tmp1_0;
    // Op 217: dim1x1 mul
    gl64_t s0_217 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_217 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_217 * s1_217;
    // Op 218: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 219: dim1x1 mul
    gl64_t s0_219 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_219 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_219 * s1_219;
    // Op 220: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 221: dim1x1 mul
    gl64_t s0_221 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp1_2 = s0_221 * tmp1_0;
    // Op 222: dim1x1 mul
    gl64_t s0_222 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_222 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = s0_222 * s1_222;
    // Op 223: dim1x1 add
    gl64_t s0_223 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_223 + tmp1_0;
    // Op 224: dim1x1 mul
    gl64_t s0_224 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_224 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_224 * s1_224;
    // Op 225: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 226: dim1x1 mul
    gl64_t s0_226 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_226 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_226 * s1_226;
    // Op 227: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 228: dim1x1 mul
    gl64_t s0_228 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_228 * tmp1_0;
    // Op 229: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 230: dim1x1 mul
    gl64_t s0_230 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_230 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = s0_230 * s1_230;
    // Op 231: dim1x1 add
    gl64_t s0_231 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_231 + tmp1_0;
    // Op 232: dim1x1 mul
    gl64_t s0_232 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_232 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_232 * s1_232;
    // Op 233: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 234: dim1x1 mul
    gl64_t s0_234 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_234 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_234 * s1_234;
    // Op 235: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 236: dim1x1 mul
    gl64_t s0_236 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp1_0 = s0_236 * tmp1_0;
    // Op 237: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 238: dim1x1 mul
    gl64_t s0_238 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_238 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = s0_238 * s1_238;
    // Op 239: dim1x1 add
    gl64_t s0_239 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_0 = s0_239 + tmp1_0;
    // Op 240: dim1x1 mul
    gl64_t s0_240 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_240 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_240 * s1_240;
    // Op 241: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 242: dim1x1 mul
    gl64_t s0_242 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_242 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_242 * s1_242;
    // Op 243: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 244: dim1x1 mul
    gl64_t s0_244 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_0 = s0_244 * tmp1_0;
    // Op 245: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 246: dim1x1 mul
    gl64_t s0_246 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_246 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = s0_246 * s1_246;
    // Op 247: dim1x1 add
    gl64_t s0_247 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_247 + tmp1_0;
    // Op 248: dim1x1 mul
    gl64_t s0_248 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_248 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_248 * s1_248;
    // Op 249: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 250: dim1x1 mul
    gl64_t s0_250 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_250 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_250 * s1_250;
    // Op 251: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 252: dim1x1 mul
    gl64_t s0_252 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_0 = s0_252 * tmp1_0;
    // Op 253: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 254: dim1x1 mul
    gl64_t s0_254 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_254 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = s0_254 * s1_254;
    // Op 255: dim1x1 add
    gl64_t s0_255 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_255 + tmp1_0;
    // Op 256: dim1x1 mul
    gl64_t s0_256 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_256 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_256 * s1_256;
    // Op 257: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 258: dim1x1 mul
    gl64_t s0_258 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_258 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_258 * s1_258;
    // Op 259: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 260: dim1x1 mul
    gl64_t s0_260 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_260 * tmp1_0;
    // Op 261: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 262: dim1x1 mul
    gl64_t s0_262 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_262 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = s0_262 * s1_262;
    // Op 263: dim1x1 add
    gl64_t s0_263 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_263 + tmp1_0;
    // Op 264: dim1x1 mul
    gl64_t s0_264 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_264 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_264 * s1_264;
    // Op 265: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 266: dim1x1 mul
    gl64_t s0_266 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_266 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_266 * s1_266;
    // Op 267: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 268: dim1x1 mul
    gl64_t s0_268 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_268 * tmp1_0;
    // Op 269: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 270: dim1x1 mul
    gl64_t s0_270 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_270 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = s0_270 * s1_270;
    // Op 271: dim1x1 add
    gl64_t s0_271 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_0 = s0_271 + tmp1_0;
    // Op 272: dim1x1 mul
    gl64_t s0_272 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_272 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_272 * s1_272;
    // Op 273: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 274: dim1x1 mul
    gl64_t s0_274 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_274 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_274 * s1_274;
    // Op 275: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 276: dim1x1 mul
    gl64_t s0_276 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = s0_276 * tmp1_0;
    // Op 277: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 278: dim1x1 mul
    gl64_t s0_278 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_1 = s0_278 * tmp1_0;
    // Op 279: dim1x1 mul
    gl64_t s0_279 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_279 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = s0_279 * s1_279;
    // Op 280: dim1x1 add
    gl64_t s0_280 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_280 + tmp1_0;
    // Op 281: dim1x1 mul
    gl64_t s0_281 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_281 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_281 * s1_281;
    // Op 282: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 283: dim1x1 mul
    gl64_t s0_283 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_283 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_283 * s1_283;
    // Op 284: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 285: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 286: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 287: dim1x1 sub
    gl64_t s0_287 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_287 - tmp1_0;
    // Op 288: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 289: dim3x3 mul
    gl64_t s1_289_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_289_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_289_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA289 = (tmp3_0 + tmp3_1) * (s1_289_0 + s1_289_1);
    gl64_t kB289 = (tmp3_0 + tmp3_2) * (s1_289_0 + s1_289_2);
    gl64_t kC289 = (tmp3_1 + tmp3_2) * (s1_289_1 + s1_289_2);
    gl64_t kD289 = tmp3_0 * s1_289_0;
    gl64_t kE289 = tmp3_1 * s1_289_1;
    gl64_t kF289 = tmp3_2 * s1_289_2;
    gl64_t kG289 = kD289 - kE289;
    tmp3_12 = (kC289 + kG289) - kF289;
    tmp3_13 = ((((kA289 + kC289) - kE289) - kE289) - kD289);
    tmp3_14 = kB289 - kG289;
    // Op 290: dim3x1 mul
    gl64_t s0_290_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_290_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_290_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_290 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp3_0 = s0_290_0 * s1_290; tmp3_1 = s0_290_1 * s1_290; tmp3_2 = s0_290_2 * s1_290;
    // Op 291: dim3x1 add
    gl64_t s1_291 = *(gl64_t*)&expressions_params[9][0];
    tmp3_9 = tmp3_0 + s1_291; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 292: dim3x3 add
    gl64_t s1_292_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_292_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_292_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_292_0; tmp3_4 = tmp3_10 + s1_292_1; tmp3_5 = tmp3_11 + s1_292_2;
    // Op 293: dim3x1 mul
    gl64_t s0_293_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_293_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_293_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_293 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp3_0 = s0_293_0 * s1_293; tmp3_1 = s0_293_1 * s1_293; tmp3_2 = s0_293_2 * s1_293;
    // Op 294: dim3x1 add
    gl64_t s1_294 = *(gl64_t*)&expressions_params[9][0];
    tmp3_6 = tmp3_0 + s1_294; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 295: dim3x3 add
    gl64_t s1_295_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_295_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_295_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_295_0; tmp3_1 = tmp3_7 + s1_295_1; tmp3_2 = tmp3_8 + s1_295_2;
    // Op 296: dim3x3 mul
    gl64_t kA296 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB296 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC296 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD296 = tmp3_3 * tmp3_0;
    gl64_t kE296 = tmp3_4 * tmp3_1;
    gl64_t kF296 = tmp3_5 * tmp3_2;
    gl64_t kG296 = kD296 - kE296;
    tmp3_0 = (kC296 + kG296) - kF296;
    tmp3_1 = ((((kA296 + kC296) - kE296) - kE296) - kD296);
    tmp3_2 = kB296 - kG296;
    // Op 297: dim3x3 mul
    gl64_t s0_297_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_297_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_297_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA297 = (s0_297_0 + s0_297_1) * (tmp3_0 + tmp3_1);
    gl64_t kB297 = (s0_297_0 + s0_297_2) * (tmp3_0 + tmp3_2);
    gl64_t kC297 = (s0_297_1 + s0_297_2) * (tmp3_1 + tmp3_2);
    gl64_t kD297 = s0_297_0 * tmp3_0;
    gl64_t kE297 = s0_297_1 * tmp3_1;
    gl64_t kF297 = s0_297_2 * tmp3_2;
    gl64_t kG297 = kD297 - kE297;
    tmp3_0 = (kC297 + kG297) - kF297;
    tmp3_1 = ((((kA297 + kC297) - kE297) - kE297) - kD297);
    tmp3_2 = kB297 - kG297;
    // Op 298: dim3x3 add
    gl64_t s1_298_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_298_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_298_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_298_0; tmp3_7 = tmp3_7 + s1_298_1; tmp3_8 = tmp3_8 + s1_298_2;
    // Op 299: dim3x1 mul
    gl64_t s1_299 = *(gl64_t*)&expressions_params[9][1];
    tmp3_6 = tmp3_6 * s1_299; tmp3_7 = tmp3_7 * s1_299; tmp3_8 = tmp3_8 * s1_299;
    // Op 300: dim3x3 add
    gl64_t s1_300_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_300_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_300_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_300_0; tmp3_10 = tmp3_10 + s1_300_1; tmp3_11 = tmp3_11 + s1_300_2;
    // Op 301: dim3x1 mul
    gl64_t s1_301 = *(gl64_t*)&expressions_params[9][1];
    tmp3_9 = tmp3_9 * s1_301; tmp3_10 = tmp3_10 * s1_301; tmp3_11 = tmp3_11 * s1_301;
    // Op 302: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 303: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 304: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 305: dim3x3 mul
    gl64_t s1_305_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_305_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_305_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA305 = (tmp3_0 + tmp3_1) * (s1_305_0 + s1_305_1);
    gl64_t kB305 = (tmp3_0 + tmp3_2) * (s1_305_0 + s1_305_2);
    gl64_t kC305 = (tmp3_1 + tmp3_2) * (s1_305_1 + s1_305_2);
    gl64_t kD305 = tmp3_0 * s1_305_0;
    gl64_t kE305 = tmp3_1 * s1_305_1;
    gl64_t kF305 = tmp3_2 * s1_305_2;
    gl64_t kG305 = kD305 - kE305;
    tmp3_3 = (kC305 + kG305) - kF305;
    tmp3_4 = ((((kA305 + kC305) - kE305) - kE305) - kD305);
    tmp3_5 = kB305 - kG305;
    // Op 306: dim3x1 mul
    gl64_t s0_306_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_306_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_306_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_306 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp3_0 = s0_306_0 * s1_306; tmp3_1 = s0_306_1 * s1_306; tmp3_2 = s0_306_2 * s1_306;
    // Op 307: dim3x1 add
    gl64_t s1_307 = *(gl64_t*)&expressions_params[9][0];
    tmp3_9 = tmp3_0 + s1_307; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 308: dim3x3 add
    gl64_t s1_308_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_308_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_308_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_308_0; tmp3_13 = tmp3_10 + s1_308_1; tmp3_14 = tmp3_11 + s1_308_2;
    // Op 309: dim3x1 mul
    gl64_t s0_309_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_309_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_309_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_309 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp3_0 = s0_309_0 * s1_309; tmp3_1 = s0_309_1 * s1_309; tmp3_2 = s0_309_2 * s1_309;
    // Op 310: dim3x1 add
    gl64_t s1_310 = *(gl64_t*)&expressions_params[9][0];
    tmp3_6 = tmp3_0 + s1_310; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 311: dim3x3 add
    gl64_t s1_311_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_311_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_311_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_311_0; tmp3_1 = tmp3_7 + s1_311_1; tmp3_2 = tmp3_8 + s1_311_2;
    // Op 312: dim3x3 mul
    gl64_t kA312 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB312 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC312 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD312 = tmp3_12 * tmp3_0;
    gl64_t kE312 = tmp3_13 * tmp3_1;
    gl64_t kF312 = tmp3_14 * tmp3_2;
    gl64_t kG312 = kD312 - kE312;
    tmp3_0 = (kC312 + kG312) - kF312;
    tmp3_1 = ((((kA312 + kC312) - kE312) - kE312) - kD312);
    tmp3_2 = kB312 - kG312;
    // Op 313: dim3x3 mul
    gl64_t s0_313_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_313_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_313_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA313 = (s0_313_0 + s0_313_1) * (tmp3_0 + tmp3_1);
    gl64_t kB313 = (s0_313_0 + s0_313_2) * (tmp3_0 + tmp3_2);
    gl64_t kC313 = (s0_313_1 + s0_313_2) * (tmp3_1 + tmp3_2);
    gl64_t kD313 = s0_313_0 * tmp3_0;
    gl64_t kE313 = s0_313_1 * tmp3_1;
    gl64_t kF313 = s0_313_2 * tmp3_2;
    gl64_t kG313 = kD313 - kE313;
    tmp3_0 = (kC313 + kG313) - kF313;
    tmp3_1 = ((((kA313 + kC313) - kE313) - kE313) - kD313);
    tmp3_2 = kB313 - kG313;
    // Op 314: dim3x3 add
    gl64_t s1_314_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_314_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_314_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_314_0; tmp3_7 = tmp3_7 + s1_314_1; tmp3_8 = tmp3_8 + s1_314_2;
    // Op 315: dim3x1 mul
    gl64_t s1_315 = *(gl64_t*)&expressions_params[9][1];
    tmp3_6 = tmp3_6 * s1_315; tmp3_7 = tmp3_7 * s1_315; tmp3_8 = tmp3_8 * s1_315;
    // Op 316: dim3x3 add
    gl64_t s1_316_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_316_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_316_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_316_0; tmp3_10 = tmp3_10 + s1_316_1; tmp3_11 = tmp3_11 + s1_316_2;
    // Op 317: dim3x1 mul
    gl64_t s1_317 = *(gl64_t*)&expressions_params[9][1];
    tmp3_9 = tmp3_9 * s1_317; tmp3_10 = tmp3_10 * s1_317; tmp3_11 = tmp3_11 * s1_317;
    // Op 318: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 319: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 320: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 321: dim3x3 mul
    gl64_t s1_321_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_321_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_321_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA321 = (tmp3_0 + tmp3_1) * (s1_321_0 + s1_321_1);
    gl64_t kB321 = (tmp3_0 + tmp3_2) * (s1_321_0 + s1_321_2);
    gl64_t kC321 = (tmp3_1 + tmp3_2) * (s1_321_1 + s1_321_2);
    gl64_t kD321 = tmp3_0 * s1_321_0;
    gl64_t kE321 = tmp3_1 * s1_321_1;
    gl64_t kF321 = tmp3_2 * s1_321_2;
    gl64_t kG321 = kD321 - kE321;
    tmp3_12 = (kC321 + kG321) - kF321;
    tmp3_13 = ((((kA321 + kC321) - kE321) - kE321) - kD321);
    tmp3_14 = kB321 - kG321;
    // Op 322: dim3x1 mul
    gl64_t s0_322_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_322_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_322_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_322 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp3_0 = s0_322_0 * s1_322; tmp3_1 = s0_322_1 * s1_322; tmp3_2 = s0_322_2 * s1_322;
    // Op 323: dim3x1 add
    gl64_t s1_323 = *(gl64_t*)&expressions_params[9][0];
    tmp3_9 = tmp3_0 + s1_323; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 324: dim3x3 add
    gl64_t s1_324_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_324_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_324_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_324_0; tmp3_4 = tmp3_10 + s1_324_1; tmp3_5 = tmp3_11 + s1_324_2;
    // Op 325: dim3x1 mul
    gl64_t s0_325_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_325_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_325_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_325 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp3_0 = s0_325_0 * s1_325; tmp3_1 = s0_325_1 * s1_325; tmp3_2 = s0_325_2 * s1_325;
    // Op 326: dim3x1 add
    gl64_t s1_326 = *(gl64_t*)&expressions_params[9][0];
    tmp3_6 = tmp3_0 + s1_326; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 327: dim3x3 add
    gl64_t s1_327_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_327_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_327_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_327_0; tmp3_1 = tmp3_7 + s1_327_1; tmp3_2 = tmp3_8 + s1_327_2;
    // Op 328: dim3x3 mul
    gl64_t kA328 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB328 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC328 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD328 = tmp3_3 * tmp3_0;
    gl64_t kE328 = tmp3_4 * tmp3_1;
    gl64_t kF328 = tmp3_5 * tmp3_2;
    gl64_t kG328 = kD328 - kE328;
    tmp3_0 = (kC328 + kG328) - kF328;
    tmp3_1 = ((((kA328 + kC328) - kE328) - kE328) - kD328);
    tmp3_2 = kB328 - kG328;
    // Op 329: dim3x3 mul
    uint64_t s0_329_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_329_0 = *(gl64_t*)&dParams->aux_trace[s0_329_pos];
    gl64_t s0_329_1 = *(gl64_t*)&dParams->aux_trace[s0_329_pos + TILE_HEIGHT];
    gl64_t s0_329_2 = *(gl64_t*)&dParams->aux_trace[s0_329_pos + 2*TILE_HEIGHT];
    gl64_t kA329 = (s0_329_0 + s0_329_1) * (tmp3_0 + tmp3_1);
    gl64_t kB329 = (s0_329_0 + s0_329_2) * (tmp3_0 + tmp3_2);
    gl64_t kC329 = (s0_329_1 + s0_329_2) * (tmp3_1 + tmp3_2);
    gl64_t kD329 = s0_329_0 * tmp3_0;
    gl64_t kE329 = s0_329_1 * tmp3_1;
    gl64_t kF329 = s0_329_2 * tmp3_2;
    gl64_t kG329 = kD329 - kE329;
    tmp3_0 = (kC329 + kG329) - kF329;
    tmp3_1 = ((((kA329 + kC329) - kE329) - kE329) - kD329);
    tmp3_2 = kB329 - kG329;
    // Op 330: dim3x3 add
    gl64_t s1_330_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_330_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_330_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_330_0; tmp3_7 = tmp3_7 + s1_330_1; tmp3_8 = tmp3_8 + s1_330_2;
    // Op 331: dim3x1 mul
    gl64_t s1_331 = *(gl64_t*)&expressions_params[9][1];
    tmp3_6 = tmp3_6 * s1_331; tmp3_7 = tmp3_7 * s1_331; tmp3_8 = tmp3_8 * s1_331;
    // Op 332: dim3x3 add
    gl64_t s1_332_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_332_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_332_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_332_0; tmp3_10 = tmp3_10 + s1_332_1; tmp3_11 = tmp3_11 + s1_332_2;
    // Op 333: dim3x1 mul
    gl64_t s1_333 = *(gl64_t*)&expressions_params[9][1];
    tmp3_9 = tmp3_9 * s1_333; tmp3_10 = tmp3_10 * s1_333; tmp3_11 = tmp3_11 * s1_333;
    // Op 334: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 335: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 336: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 337: dim3x3 mul
    gl64_t s1_337_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_337_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_337_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA337 = (tmp3_0 + tmp3_1) * (s1_337_0 + s1_337_1);
    gl64_t kB337 = (tmp3_0 + tmp3_2) * (s1_337_0 + s1_337_2);
    gl64_t kC337 = (tmp3_1 + tmp3_2) * (s1_337_1 + s1_337_2);
    gl64_t kD337 = tmp3_0 * s1_337_0;
    gl64_t kE337 = tmp3_1 * s1_337_1;
    gl64_t kF337 = tmp3_2 * s1_337_2;
    gl64_t kG337 = kD337 - kE337;
    tmp3_3 = (kC337 + kG337) - kF337;
    tmp3_4 = ((((kA337 + kC337) - kE337) - kE337) - kD337);
    tmp3_5 = kB337 - kG337;
    // Op 338: dim3x1 mul
    gl64_t s0_338_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_338_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_338_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_338 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp3_0 = s0_338_0 * s1_338; tmp3_1 = s0_338_1 * s1_338; tmp3_2 = s0_338_2 * s1_338;
    // Op 339: dim3x1 add
    gl64_t s1_339 = *(gl64_t*)&expressions_params[9][0];
    tmp3_9 = tmp3_0 + s1_339; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 340: dim3x3 add
    gl64_t s1_340_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_340_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_340_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_340_0; tmp3_13 = tmp3_10 + s1_340_1; tmp3_14 = tmp3_11 + s1_340_2;
    // Op 341: dim1x1 mul
    gl64_t s0_341 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    gl64_t s1_341 = *(gl64_t*)&expressions_params[9][2];
    tmp1_0 = s0_341 * s1_341;
    // Op 342: dim1x1 add
    gl64_t s0_342 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp1_0 = s0_342 + tmp1_0;
    // Op 343: dim1x1 mul
    gl64_t s0_343 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    gl64_t s1_343 = *(gl64_t*)&expressions_params[9][3];
    tmp1_1 = s0_343 * s1_343;
    // Op 344: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 345: dim1x1 mul
    gl64_t s0_345 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_345 = *(gl64_t*)&expressions_params[9][4];
    tmp1_1 = s0_345 * s1_345;
    // Op 346: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 347: dim1x1 mul
    gl64_t s0_347 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_347 = *(gl64_t*)&expressions_params[9][5];
    tmp1_1 = s0_347 * s1_347;
    // Op 348: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 349: dim1x1 mul
    gl64_t s0_349 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    gl64_t s1_349 = *(gl64_t*)&expressions_params[9][6];
    tmp1_1 = s0_349 * s1_349;
    // Op 350: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 351: dim1x1 mul
    gl64_t s0_351 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_351 = *(gl64_t*)&expressions_params[9][7];
    tmp1_1 = s0_351 * s1_351;
    // Op 352: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 353: dim1x1 mul
    gl64_t s0_353 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_353 = *(gl64_t*)&expressions_params[9][8];
    tmp1_1 = s0_353 * s1_353;
    // Op 354: dim1x1 add
    tmp1_2 = tmp1_0 + tmp1_1;
    // Op 355: dim1x1 mul
    gl64_t s0_355 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_355 = *(gl64_t*)&expressions_params[9][9];
    tmp1_0 = s0_355 * s1_355;
    // Op 356: dim1x1 mul
    gl64_t s0_356 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_356 = *(gl64_t*)&expressions_params[9][10];
    tmp1_1 = s0_356 * s1_356;
    // Op 357: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 358: dim1x1 mul
    gl64_t s0_358 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_358 = *(gl64_t*)&expressions_params[9][11];
    tmp1_1 = s0_358 * s1_358;
    // Op 359: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 360: dim1x1 mul
    gl64_t s0_360 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_360 = *(gl64_t*)&expressions_params[9][12];
    tmp1_1 = s0_360 * s1_360;
    // Op 361: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 362: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 363: dim3x1 mul
    gl64_t s0_363_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_363_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_363_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_363_0 * tmp1_0; tmp3_1 = s0_363_1 * tmp1_0; tmp3_2 = s0_363_2 * tmp1_0;
    // Op 364: dim3x1 add
    gl64_t s1_364 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_364; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 365: dim3x3 mul
    gl64_t s1_365_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_365_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_365_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA365 = (tmp3_0 + tmp3_1) * (s1_365_0 + s1_365_1);
    gl64_t kB365 = (tmp3_0 + tmp3_2) * (s1_365_0 + s1_365_2);
    gl64_t kC365 = (tmp3_1 + tmp3_2) * (s1_365_1 + s1_365_2);
    gl64_t kD365 = tmp3_0 * s1_365_0;
    gl64_t kE365 = tmp3_1 * s1_365_1;
    gl64_t kF365 = tmp3_2 * s1_365_2;
    gl64_t kG365 = kD365 - kE365;
    tmp3_0 = (kC365 + kG365) - kF365;
    tmp3_1 = ((((kA365 + kC365) - kE365) - kE365) - kD365);
    tmp3_2 = kB365 - kG365;
    // Op 366: dim3x1 add
    gl64_t s1_366 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_366; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_368 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_368; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 370: dim1x1 sub
    gl64_t s0_370 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    gl64_t s1_370 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_370 - s1_370;
    // Op 371: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 372: dim3x3 mul
    gl64_t s1_372_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_372_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_372_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 373: dim3x1 add
    gl64_t s1_373 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_373; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 374: dim3x3 mul
    gl64_t s1_374_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_374_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_374_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA374 = (tmp3_0 + tmp3_1) * (s1_374_0 + s1_374_1);
    gl64_t kB374 = (tmp3_0 + tmp3_2) * (s1_374_0 + s1_374_2);
    gl64_t kC374 = (tmp3_1 + tmp3_2) * (s1_374_1 + s1_374_2);
    gl64_t kD374 = tmp3_0 * s1_374_0;
    gl64_t kE374 = tmp3_1 * s1_374_1;
    gl64_t kF374 = tmp3_2 * s1_374_2;
    gl64_t kG374 = kD374 - kE374;
    tmp3_0 = (kC374 + kG374) - kF374;
    tmp3_1 = ((((kA374 + kC374) - kE374) - kE374) - kD374);
    tmp3_2 = kB374 - kG374;
    // Op 375: dim3x1 add
    gl64_t s1_375 = *(gl64_t*)&expressions_params[9][13];
    tmp3_6 = tmp3_0 + s1_375; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 376: dim3x3 add
    gl64_t s1_376_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_376_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_376_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_376_0; tmp3_1 = tmp3_7 + s1_376_1; tmp3_2 = tmp3_8 + s1_376_2;
    // Op 377: dim3x3 mul
    gl64_t kA377 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB377 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC377 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD377 = tmp3_12 * tmp3_0;
    gl64_t kE377 = tmp3_13 * tmp3_1;
    gl64_t kF377 = tmp3_14 * tmp3_2;
    gl64_t kG377 = kD377 - kE377;
    tmp3_0 = (kC377 + kG377) - kF377;
    tmp3_1 = ((((kA377 + kC377) - kE377) - kE377) - kD377);
    tmp3_2 = kB377 - kG377;
    // Op 378: dim3x3 mul
    uint64_t s0_378_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_378_0 = *(gl64_t*)&dParams->aux_trace[s0_378_pos];
    gl64_t s0_378_1 = *(gl64_t*)&dParams->aux_trace[s0_378_pos + TILE_HEIGHT];
    gl64_t s0_378_2 = *(gl64_t*)&dParams->aux_trace[s0_378_pos + 2*TILE_HEIGHT];
    gl64_t kA378 = (s0_378_0 + s0_378_1) * (tmp3_0 + tmp3_1);
    gl64_t kB378 = (s0_378_0 + s0_378_2) * (tmp3_0 + tmp3_2);
    gl64_t kC378 = (s0_378_1 + s0_378_2) * (tmp3_1 + tmp3_2);
    gl64_t kD378 = s0_378_0 * tmp3_0;
    gl64_t kE378 = s0_378_1 * tmp3_1;
    gl64_t kF378 = s0_378_2 * tmp3_2;
    gl64_t kG378 = kD378 - kE378;
    tmp3_0 = (kC378 + kG378) - kF378;
    tmp3_1 = ((((kA378 + kC378) - kE378) - kE378) - kD378);
    tmp3_2 = kB378 - kG378;
    // Op 379: dim3x3 add
    gl64_t s1_379_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_379_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_379_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_379_0; tmp3_7 = tmp3_7 + s1_379_1; tmp3_8 = tmp3_8 + s1_379_2;
    // Op 380: dim3x1 mul
    gl64_t s1_380 = *(gl64_t*)&expressions_params[9][1];
    tmp3_6 = tmp3_6 * s1_380; tmp3_7 = tmp3_7 * s1_380; tmp3_8 = tmp3_8 * s1_380;
    // Op 381: dim3x3 add
    gl64_t s1_381_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_381_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_381_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_381_0; tmp3_10 = tmp3_10 + s1_381_1; tmp3_11 = tmp3_11 + s1_381_2;
    // Op 382: dim3x1 mul
    gl64_t s1_382 = *(gl64_t*)&expressions_params[9][1];
    tmp3_9 = tmp3_9 * s1_382; tmp3_10 = tmp3_10 * s1_382; tmp3_11 = tmp3_11 * s1_382;
    // Op 383: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 384: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 385: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 386: dim3x3 mul
    gl64_t s1_386_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_386_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_386_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA386 = (tmp3_0 + tmp3_1) * (s1_386_0 + s1_386_1);
    gl64_t kB386 = (tmp3_0 + tmp3_2) * (s1_386_0 + s1_386_2);
    gl64_t kC386 = (tmp3_1 + tmp3_2) * (s1_386_1 + s1_386_2);
    gl64_t kD386 = tmp3_0 * s1_386_0;
    gl64_t kE386 = tmp3_1 * s1_386_1;
    gl64_t kF386 = tmp3_2 * s1_386_2;
    gl64_t kG386 = kD386 - kE386;
    tmp3_3 = (kC386 + kG386) - kF386;
    tmp3_4 = ((((kA386 + kC386) - kE386) - kE386) - kD386);
    tmp3_5 = kB386 - kG386;
    // Op 387: dim3x1 mul
    gl64_t s0_387_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_387_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_387_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_387 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp3_0 = s0_387_0 * s1_387; tmp3_1 = s0_387_1 * s1_387; tmp3_2 = s0_387_2 * s1_387;
    // Op 388: dim3x1 add
    gl64_t s1_388 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_388; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 389: dim3x3 mul
    gl64_t s1_389_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_389_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_389_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA389 = (tmp3_0 + tmp3_1) * (s1_389_0 + s1_389_1);
    gl64_t kB389 = (tmp3_0 + tmp3_2) * (s1_389_0 + s1_389_2);
    gl64_t kC389 = (tmp3_1 + tmp3_2) * (s1_389_1 + s1_389_2);
    gl64_t kD389 = tmp3_0 * s1_389_0;
    gl64_t kE389 = tmp3_1 * s1_389_1;
    gl64_t kF389 = tmp3_2 * s1_389_2;
    gl64_t kG389 = kD389 - kE389;
    tmp3_0 = (kC389 + kG389) - kF389;
    tmp3_1 = ((((kA389 + kC389) - kE389) - kE389) - kD389);
    tmp3_2 = kB389 - kG389;
    // Op 390: dim3x1 add
    gl64_t s1_390 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_390; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 391: dim3x3 mul
    gl64_t s1_391_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_391_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_391_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 392: dim3x1 add
    gl64_t s1_392 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_392; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 394: dim1x1 mul
    gl64_t s0_394 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_394 = *(gl64_t*)&expressions_params[9][4];
    tmp1_0 = s0_394 * s1_394;
    // Op 395: dim1x1 add
    gl64_t s0_395 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_395 + tmp1_0;
    // Op 396: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 398: dim1x1 add
    gl64_t s0_398 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_398 = *(gl64_t*)&expressions_params[9][14];
    tmp1_0 = s0_398 + s1_398;
    // Op 399: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 401: dim3x1 add
    gl64_t s1_401 = *(gl64_t*)&expressions_params[9][15];
    tmp3_0 = tmp3_0 + s1_401; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 402: dim3x3 add
    gl64_t s1_402_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_402_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_402_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_402_0; tmp3_1 = tmp3_1 + s1_402_1; tmp3_2 = tmp3_2 + s1_402_2;
    // Op 403: dim3x3 mul
    gl64_t s0_403_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_403_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_403_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    gl64_t kA403 = (s0_403_0 + s0_403_1) * (tmp3_0 + tmp3_1);
    gl64_t kB403 = (s0_403_0 + s0_403_2) * (tmp3_0 + tmp3_2);
    gl64_t kC403 = (s0_403_1 + s0_403_2) * (tmp3_1 + tmp3_2);
    gl64_t kD403 = s0_403_0 * tmp3_0;
    gl64_t kE403 = s0_403_1 * tmp3_1;
    gl64_t kF403 = s0_403_2 * tmp3_2;
    gl64_t kG403 = kD403 - kE403;
    tmp3_0 = (kC403 + kG403) - kF403;
    tmp3_1 = ((((kA403 + kC403) - kE403) - kE403) - kD403);
    tmp3_2 = kB403 - kG403;
    // Op 404: dim1x1 sub
    gl64_t s0_404 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_3 = s0_404 - tmp1_3;
    // Op 405: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_3; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 406: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
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
    tmp3_6 = (kC407 + kG407) - kF407;
    tmp3_7 = ((((kA407 + kC407) - kE407) - kE407) - kD407);
    tmp3_8 = kB407 - kG407;
    // Op 408: dim1x1 sub_swap
    gl64_t s0_408 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_0)];
    gl64_t s1_408 = *(gl64_t*)&expressions_params[9][14];
    tmp1_3 = s1_408 - s0_408;
    // Op 409: dim3x1 mul
    uint64_t s0_409_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_409_0 = *(gl64_t*)&dParams->aux_trace[s0_409_pos];
    gl64_t s0_409_1 = *(gl64_t*)&dParams->aux_trace[s0_409_pos + TILE_HEIGHT];
    gl64_t s0_409_2 = *(gl64_t*)&dParams->aux_trace[s0_409_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_409_0 * tmp1_3; tmp3_1 = s0_409_1 * tmp1_3; tmp3_2 = s0_409_2 * tmp1_3;
    // Op 410: dim3x3 sub
    uint64_t s0_410_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_410_0 = *(gl64_t*)&dParams->aux_trace[s0_410_pos];
    gl64_t s0_410_1 = *(gl64_t*)&dParams->aux_trace[s0_410_pos + TILE_HEIGHT];
    gl64_t s0_410_2 = *(gl64_t*)&dParams->aux_trace[s0_410_pos + 2*TILE_HEIGHT];
    tmp3_3 = s0_410_0 - tmp3_0; tmp3_4 = s0_410_1 - tmp3_1; tmp3_5 = s0_410_2 - tmp3_2;
    // Op 411: dim3x3 add
    gl64_t s0_411_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_411_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_411_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_411_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_411_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_411_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_0 = s0_411_0 + s1_411_0; tmp3_1 = s0_411_1 + s1_411_1; tmp3_2 = s0_411_2 + s1_411_2;
    // Op 412: dim3x3 add
    uint64_t s0_412_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_412_0 = *(gl64_t*)&dParams->aux_trace[s0_412_pos];
    gl64_t s0_412_1 = *(gl64_t*)&dParams->aux_trace[s0_412_pos + TILE_HEIGHT];
    gl64_t s0_412_2 = *(gl64_t*)&dParams->aux_trace[s0_412_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_412_0 + tmp3_0; tmp3_1 = s0_412_1 + tmp3_1; tmp3_2 = s0_412_2 + tmp3_2;
    // Op 413: dim3x3 add
    uint64_t s0_413_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_413_0 = *(gl64_t*)&dParams->aux_trace[s0_413_pos];
    gl64_t s0_413_1 = *(gl64_t*)&dParams->aux_trace[s0_413_pos + TILE_HEIGHT];
    gl64_t s0_413_2 = *(gl64_t*)&dParams->aux_trace[s0_413_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_413_0 + tmp3_0; tmp3_1 = s0_413_1 + tmp3_1; tmp3_2 = s0_413_2 + tmp3_2;
    // Op 414: dim3x3 add
    gl64_t s0_414_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_414_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_414_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    tmp3_0 = s0_414_0 + tmp3_0; tmp3_1 = s0_414_1 + tmp3_1; tmp3_2 = s0_414_2 + tmp3_2;
    // Op 415: dim3x3 sub
    tmp3_3 = tmp3_3 - tmp3_0; tmp3_4 = tmp3_4 - tmp3_1; tmp3_5 = tmp3_5 - tmp3_2;
    // Op 416: dim3x1 mul
    gl64_t s0_416_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_416_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_416_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_416 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp3_0 = s0_416_0 * s1_416; tmp3_1 = s0_416_1 * s1_416; tmp3_2 = s0_416_2 * s1_416;
    // Op 417: dim3x1 add
    gl64_t s1_417 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_417; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 418: dim3x3 add
    gl64_t s1_418_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_418_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_418_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_418_0; tmp3_1 = tmp3_1 + s1_418_1; tmp3_2 = tmp3_2 + s1_418_2;
    // Op 419: dim3x3 mul
    gl64_t kA419 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB419 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC419 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD419 = tmp3_3 * tmp3_0;
    gl64_t kE419 = tmp3_4 * tmp3_1;
    gl64_t kF419 = tmp3_5 * tmp3_2;
    gl64_t kG419 = kD419 - kE419;
    tmp3_0 = (kC419 + kG419) - kF419;
    tmp3_1 = ((((kA419 + kC419) - kE419) - kE419) - kD419);
    tmp3_2 = kB419 - kG419;
    // Op 420: dim3x1 add
    gl64_t s1_420 = *(gl64_t*)&expressions_params[9][14];
    tmp3_0 = tmp3_0 + s1_420; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 421: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 422: dim3x3 mul
    gl64_t s1_422_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_422_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_422_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA422 = (tmp3_0 + tmp3_1) * (s1_422_0 + s1_422_1);
    gl64_t kB422 = (tmp3_0 + tmp3_2) * (s1_422_0 + s1_422_2);
    gl64_t kC422 = (tmp3_1 + tmp3_2) * (s1_422_1 + s1_422_2);
    gl64_t kD422 = tmp3_0 * s1_422_0;
    gl64_t kE422 = tmp3_1 * s1_422_1;
    gl64_t kF422 = tmp3_2 * s1_422_2;
    gl64_t kG422 = kD422 - kE422;
    tmp3_6 = (kC422 + kG422) - kF422;
    tmp3_7 = ((((kA422 + kC422) - kE422) - kE422) - kD422);
    tmp3_8 = kB422 - kG422;
    // Op 423: dim3x3 sub_swap
    uint64_t s0_423_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_423_0 = *(gl64_t*)&dParams->aux_trace[s0_423_pos];
    gl64_t s0_423_1 = *(gl64_t*)&dParams->aux_trace[s0_423_pos + TILE_HEIGHT];
    gl64_t s0_423_2 = *(gl64_t*)&dParams->aux_trace[s0_423_pos + 2*TILE_HEIGHT];
    gl64_t s1_423_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_423_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_423_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_0 = s1_423_0 - s0_423_0; tmp3_1 = s1_423_1 - s0_423_1; tmp3_2 = s1_423_2 - s0_423_2;
    // Op 424: dim3x1 mul
    gl64_t s1_424 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_424; tmp3_1 = tmp3_1 * s1_424; tmp3_2 = tmp3_2 * s1_424;
    // Op 425: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 426: dim3x1 mul
    gl64_t s1_426 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_426; tmp3_1 = tmp3_1 * s1_426; tmp3_2 = tmp3_2 * s1_426;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
