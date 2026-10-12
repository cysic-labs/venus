// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: b30857b5  nOps=523 nTemp1=4 nTemp3=5
#define GENERATED_EVAL_NOPS_b30857b5 523
#define GENERATED_EVAL_NTEMP1_b30857b5 4
#define GENERATED_EVAL_NTEMP3_b30857b5 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_b30857b5(
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
    gl64_t s1_82 = *(gl64_t*)&expressions_params[9][0];
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
    gl64_t s1_86 = *(gl64_t*)&expressions_params[9][0];
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
    gl64_t s1_90 = *(gl64_t*)&expressions_params[9][0];
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
    gl64_t s1_94 = *(gl64_t*)&expressions_params[9][0];
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
    gl64_t s1_98 = *(gl64_t*)&expressions_params[9][0];
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
    gl64_t s1_102 = *(gl64_t*)&expressions_params[9][0];
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
    gl64_t s1_106 = *(gl64_t*)&expressions_params[9][0];
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
    gl64_t s1_110 = *(gl64_t*)&expressions_params[9][0];
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
    gl64_t s1_114 = *(gl64_t*)&expressions_params[9][0];
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
    gl64_t s1_118 = *(gl64_t*)&expressions_params[9][0];
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
    gl64_t s1_122 = *(gl64_t*)&expressions_params[9][0];
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
    gl64_t s1_126 = *(gl64_t*)&expressions_params[9][0];
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
    gl64_t s1_131 = *(gl64_t*)&expressions_params[9][0];
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
    // Op 136: dim1x1 sub_swap
    gl64_t s0_136 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_136 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_136 - s0_136;
    // Op 137: dim1x1 mul
    gl64_t s0_137 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_137 * tmp1_0;
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
    // Op 140: dim1x1 add
    gl64_t s0_140 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_140 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_3 = s0_140 + s1_140;
    // Op 141: dim1x1 mul
    gl64_t s0_141 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_141 * tmp1_3;
    // Op 142: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 143: dim3x3 mul
    gl64_t s1_143_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_143_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_143_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA143 = (tmp3_0 + tmp3_1) * (s1_143_0 + s1_143_1);
    gl64_t kB143 = (tmp3_0 + tmp3_2) * (s1_143_0 + s1_143_2);
    gl64_t kC143 = (tmp3_1 + tmp3_2) * (s1_143_1 + s1_143_2);
    gl64_t kD143 = tmp3_0 * s1_143_0;
    gl64_t kE143 = tmp3_1 * s1_143_1;
    gl64_t kF143 = tmp3_2 * s1_143_2;
    gl64_t kG143 = kD143 - kE143;
    tmp3_0 = (kC143 + kG143) - kF143;
    tmp3_1 = ((((kA143 + kC143) - kE143) - kE143) - kD143);
    tmp3_2 = kB143 - kG143;
    // Op 144: dim1x1 sub
    gl64_t s0_144 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 24, domainSize, nCols_1))];
    gl64_t s1_144 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_144 - s1_144;
    // Op 145: dim1x1 sub
    gl64_t s1_145 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_145;
    // Op 146: dim1x1 mul
    gl64_t s0_146 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_2 = s0_146 * tmp1_0;
    // Op 147: dim1x1 sub_swap
    gl64_t s0_147 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    gl64_t s1_147 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_147 - s0_147;
    // Op 148: dim1x1 sub
    gl64_t s0_148 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 24, domainSize, nCols_1))];
    gl64_t s1_148 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_1 = s0_148 - s1_148;
    // Op 149: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 150: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 151: dim1x1 mul
    gl64_t s0_151 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_2))];
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
    // Op 154: dim1x1 sub
    gl64_t s0_154 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 24, domainSize, nCols_1))];
    gl64_t s1_154 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_154 - s1_154;
    // Op 155: dim1x1 add
    gl64_t s1_155 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_155;
    // Op 156: dim1x1 mul
    gl64_t s0_156 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_2))];
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
    // Op 159: dim1x1 sub
    gl64_t s0_159 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 24, domainSize, nCols_1))];
    gl64_t s1_159 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_159 - s1_159;
    // Op 160: dim1x1 sub
    gl64_t s1_160 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_160;
    // Op 161: dim1x1 mul
    gl64_t s0_161 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_1 = s0_161 * tmp1_0;
    // Op 162: dim1x1 sub_swap
    gl64_t s0_162 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    gl64_t s1_162 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_162 - s0_162;
    // Op 163: dim1x1 sub
    gl64_t s0_163 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 24, domainSize, nCols_1))];
    gl64_t s1_163 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_2 = s0_163 - s1_163;
    // Op 164: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_2;
    // Op 165: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 166: dim1x1 mul
    gl64_t s0_166 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_2))];
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
    gl64_t s0_169 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_169 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_1 = s0_169 * s1_169;
    // Op 170: dim1x1 sub
    gl64_t s0_170 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 24, domainSize, nCols_1))];
    gl64_t s1_170 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_170 - s1_170;
    // Op 171: dim1x1 add
    gl64_t s1_171 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_171;
    // Op 172: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
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
    gl64_t s0_175 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_175 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_175 - s0_175;
    // Op 176: dim1x1 mul
    gl64_t s0_176 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_176 * tmp1_0;
    // Op 177: dim1x1 mul
    gl64_t s0_177 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_2))];
    tmp1_0 = s0_177 * tmp1_0;
    // Op 178: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 179: dim3x3 mul
    gl64_t s1_179_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_179_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_179_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA179 = (tmp3_0 + tmp3_1) * (s1_179_0 + s1_179_1);
    gl64_t kB179 = (tmp3_0 + tmp3_2) * (s1_179_0 + s1_179_2);
    gl64_t kC179 = (tmp3_1 + tmp3_2) * (s1_179_1 + s1_179_2);
    gl64_t kD179 = tmp3_0 * s1_179_0;
    gl64_t kE179 = tmp3_1 * s1_179_1;
    gl64_t kF179 = tmp3_2 * s1_179_2;
    gl64_t kG179 = kD179 - kE179;
    tmp3_0 = (kC179 + kG179) - kF179;
    tmp3_1 = ((((kA179 + kC179) - kE179) - kE179) - kD179);
    tmp3_2 = kB179 - kG179;
    // Op 180: dim1x1 mul
    gl64_t s0_180 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_180 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_180 * s1_180;
    // Op 181: dim1x1 add
    gl64_t s0_181 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_181 + tmp1_0;
    // Op 182: dim1x1 mul
    gl64_t s0_182 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_182 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_182 * s1_182;
    // Op 183: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 184: dim1x1 mul
    gl64_t s0_184 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_184 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_184 * s1_184;
    // Op 185: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 186: dim1x1 mul
    gl64_t s0_186 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp1_2 = s0_186 * tmp1_0;
    // Op 187: dim1x1 mul
    gl64_t s0_187 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_187 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_187 * s1_187;
    // Op 188: dim1x1 add
    gl64_t s0_188 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_188 + tmp1_0;
    // Op 189: dim1x1 mul
    gl64_t s0_189 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_189 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_189 * s1_189;
    // Op 190: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 191: dim1x1 mul
    gl64_t s0_191 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_191 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_191 * s1_191;
    // Op 192: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 193: dim1x1 mul
    gl64_t s0_193 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_193 * tmp1_0;
    // Op 194: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 195: dim1x1 mul
    gl64_t s0_195 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_195 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_195 * s1_195;
    // Op 196: dim1x1 add
    gl64_t s0_196 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_196 + tmp1_0;
    // Op 197: dim1x1 mul
    gl64_t s0_197 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_197 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_197 * s1_197;
    // Op 198: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 199: dim1x1 mul
    gl64_t s0_199 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_199 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_199 * s1_199;
    // Op 200: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 201: dim1x1 mul
    gl64_t s0_201 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp1_0 = s0_201 * tmp1_0;
    // Op 202: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 203: dim1x1 mul
    gl64_t s0_203 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_203 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_203 * s1_203;
    // Op 204: dim1x1 add
    gl64_t s0_204 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_0 = s0_204 + tmp1_0;
    // Op 205: dim1x1 mul
    gl64_t s0_205 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_205 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_205 * s1_205;
    // Op 206: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 207: dim1x1 mul
    gl64_t s0_207 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_207 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_207 * s1_207;
    // Op 208: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 209: dim1x1 mul
    gl64_t s0_209 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_0 = s0_209 * tmp1_0;
    // Op 210: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 211: dim1x1 mul
    gl64_t s0_211 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_211 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_211 * s1_211;
    // Op 212: dim1x1 add
    gl64_t s0_212 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_212 + tmp1_0;
    // Op 213: dim1x1 mul
    gl64_t s0_213 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_213 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_213 * s1_213;
    // Op 214: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 215: dim1x1 mul
    gl64_t s0_215 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_215 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_215 * s1_215;
    // Op 216: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 217: dim1x1 mul
    gl64_t s0_217 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_0 = s0_217 * tmp1_0;
    // Op 218: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 219: dim1x1 mul
    gl64_t s0_219 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_219 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_219 * s1_219;
    // Op 220: dim1x1 add
    gl64_t s0_220 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_220 + tmp1_0;
    // Op 221: dim1x1 mul
    gl64_t s0_221 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_221 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_221 * s1_221;
    // Op 222: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 223: dim1x1 mul
    gl64_t s0_223 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_223 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_223 * s1_223;
    // Op 224: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 225: dim1x1 mul
    gl64_t s0_225 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_225 * tmp1_0;
    // Op 226: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 227: dim1x1 mul
    gl64_t s0_227 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_227 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_227 * s1_227;
    // Op 228: dim1x1 add
    gl64_t s0_228 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_228 + tmp1_0;
    // Op 229: dim1x1 mul
    gl64_t s0_229 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_229 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_229 * s1_229;
    // Op 230: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 231: dim1x1 mul
    gl64_t s0_231 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_231 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_231 * s1_231;
    // Op 232: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 233: dim1x1 mul
    gl64_t s0_233 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_233 * tmp1_0;
    // Op 234: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 235: dim1x1 mul
    gl64_t s0_235 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_235 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_235 * s1_235;
    // Op 236: dim1x1 add
    gl64_t s0_236 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_0 = s0_236 + tmp1_0;
    // Op 237: dim1x1 mul
    gl64_t s0_237 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_237 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_237 * s1_237;
    // Op 238: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 239: dim1x1 mul
    gl64_t s0_239 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_239 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_239 * s1_239;
    // Op 240: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 241: dim1x1 mul
    gl64_t s0_241 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = s0_241 * tmp1_0;
    // Op 242: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 243: dim1x1 mul
    gl64_t s0_243 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_1 = s0_243 * tmp1_0;
    // Op 244: dim1x1 mul
    gl64_t s0_244 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_244 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_244 * s1_244;
    // Op 245: dim1x1 add
    gl64_t s0_245 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_245 + tmp1_0;
    // Op 246: dim1x1 mul
    gl64_t s0_246 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_246 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_246 * s1_246;
    // Op 247: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 248: dim1x1 mul
    gl64_t s0_248 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_248 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_248 * s1_248;
    // Op 249: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 250: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 251: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 252: dim1x1 sub
    gl64_t s0_252 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp1_0 = s0_252 - tmp1_0;
    // Op 253: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 254: dim3x3 mul
    gl64_t s1_254_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_254_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_254_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 255: dim1x1 mul
    gl64_t s0_255 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_255 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_255 * s1_255;
    // Op 256: dim1x1 add
    gl64_t s0_256 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_256 + tmp1_0;
    // Op 257: dim1x1 mul
    gl64_t s0_257 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_257 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_257 * s1_257;
    // Op 258: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 259: dim1x1 mul
    gl64_t s0_259 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_259 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_259 * s1_259;
    // Op 260: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 261: dim1x1 mul
    gl64_t s0_261 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp1_2 = s0_261 * tmp1_0;
    // Op 262: dim1x1 mul
    gl64_t s0_262 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_262 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_262 * s1_262;
    // Op 263: dim1x1 add
    gl64_t s0_263 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_263 + tmp1_0;
    // Op 264: dim1x1 mul
    gl64_t s0_264 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_264 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_264 * s1_264;
    // Op 265: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 266: dim1x1 mul
    gl64_t s0_266 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_266 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_266 * s1_266;
    // Op 267: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 268: dim1x1 mul
    gl64_t s0_268 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_268 * tmp1_0;
    // Op 269: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 270: dim1x1 mul
    gl64_t s0_270 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_270 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_270 * s1_270;
    // Op 271: dim1x1 add
    gl64_t s0_271 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_271 + tmp1_0;
    // Op 272: dim1x1 mul
    gl64_t s0_272 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_272 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_272 * s1_272;
    // Op 273: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 274: dim1x1 mul
    gl64_t s0_274 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_274 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_274 * s1_274;
    // Op 275: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 276: dim1x1 mul
    gl64_t s0_276 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp1_0 = s0_276 * tmp1_0;
    // Op 277: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 278: dim1x1 mul
    gl64_t s0_278 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_278 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_278 * s1_278;
    // Op 279: dim1x1 add
    gl64_t s0_279 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_0 = s0_279 + tmp1_0;
    // Op 280: dim1x1 mul
    gl64_t s0_280 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_280 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_280 * s1_280;
    // Op 281: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 282: dim1x1 mul
    gl64_t s0_282 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_282 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_282 * s1_282;
    // Op 283: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 284: dim1x1 mul
    gl64_t s0_284 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_0 = s0_284 * tmp1_0;
    // Op 285: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 286: dim1x1 mul
    gl64_t s0_286 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_286 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_286 * s1_286;
    // Op 287: dim1x1 add
    gl64_t s0_287 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_287 + tmp1_0;
    // Op 288: dim1x1 mul
    gl64_t s0_288 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_288 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_288 * s1_288;
    // Op 289: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 290: dim1x1 mul
    gl64_t s0_290 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_290 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_290 * s1_290;
    // Op 291: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 292: dim1x1 mul
    gl64_t s0_292 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_0 = s0_292 * tmp1_0;
    // Op 293: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 294: dim1x1 mul
    gl64_t s0_294 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_294 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_294 * s1_294;
    // Op 295: dim1x1 add
    gl64_t s0_295 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_295 + tmp1_0;
    // Op 296: dim1x1 mul
    gl64_t s0_296 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_296 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_296 * s1_296;
    // Op 297: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 298: dim1x1 mul
    gl64_t s0_298 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_298 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_298 * s1_298;
    // Op 299: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 300: dim1x1 mul
    gl64_t s0_300 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_300 * tmp1_0;
    // Op 301: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 302: dim1x1 mul
    gl64_t s0_302 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_302 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_302 * s1_302;
    // Op 303: dim1x1 add
    gl64_t s0_303 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_303 + tmp1_0;
    // Op 304: dim1x1 mul
    gl64_t s0_304 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_304 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_304 * s1_304;
    // Op 305: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 306: dim1x1 mul
    gl64_t s0_306 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_306 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_306 * s1_306;
    // Op 307: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 308: dim1x1 mul
    gl64_t s0_308 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_308 * tmp1_0;
    // Op 309: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 310: dim1x1 mul
    gl64_t s0_310 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_310 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_310 * s1_310;
    // Op 311: dim1x1 add
    gl64_t s0_311 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_0 = s0_311 + tmp1_0;
    // Op 312: dim1x1 mul
    gl64_t s0_312 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_312 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_312 * s1_312;
    // Op 313: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 314: dim1x1 mul
    gl64_t s0_314 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_314 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_314 * s1_314;
    // Op 315: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 316: dim1x1 mul
    gl64_t s0_316 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = s0_316 * tmp1_0;
    // Op 317: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 318: dim1x1 mul
    gl64_t s0_318 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_1 = s0_318 * tmp1_0;
    // Op 319: dim1x1 mul
    gl64_t s0_319 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_319 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_319 * s1_319;
    // Op 320: dim1x1 add
    gl64_t s0_320 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_320 + tmp1_0;
    // Op 321: dim1x1 mul
    gl64_t s0_321 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_321 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_321 * s1_321;
    // Op 322: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 323: dim1x1 mul
    gl64_t s0_323 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_323 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_323 * s1_323;
    // Op 324: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 325: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 326: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 327: dim1x1 sub
    gl64_t s0_327 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_327 - tmp1_0;
    // Op 328: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 329: dim3x3 mul
    gl64_t s1_329_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_329_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_329_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA329 = (tmp3_0 + tmp3_1) * (s1_329_0 + s1_329_1);
    gl64_t kB329 = (tmp3_0 + tmp3_2) * (s1_329_0 + s1_329_2);
    gl64_t kC329 = (tmp3_1 + tmp3_2) * (s1_329_1 + s1_329_2);
    gl64_t kD329 = tmp3_0 * s1_329_0;
    gl64_t kE329 = tmp3_1 * s1_329_1;
    gl64_t kF329 = tmp3_2 * s1_329_2;
    gl64_t kG329 = kD329 - kE329;
    tmp3_12 = (kC329 + kG329) - kF329;
    tmp3_13 = ((((kA329 + kC329) - kE329) - kE329) - kD329);
    tmp3_14 = kB329 - kG329;
    // Op 330: dim3x1 mul
    gl64_t s0_330_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_330_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_330_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_330 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp3_0 = s0_330_0 * s1_330; tmp3_1 = s0_330_1 * s1_330; tmp3_2 = s0_330_2 * s1_330;
    // Op 331: dim3x1 add
    gl64_t s1_331 = *(gl64_t*)&expressions_params[9][1];
    tmp3_9 = tmp3_0 + s1_331; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 332: dim3x3 add
    gl64_t s1_332_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_332_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_332_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_332_0; tmp3_4 = tmp3_10 + s1_332_1; tmp3_5 = tmp3_11 + s1_332_2;
    // Op 333: dim3x1 mul
    gl64_t s0_333_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_333_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_333_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_333 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp3_0 = s0_333_0 * s1_333; tmp3_1 = s0_333_1 * s1_333; tmp3_2 = s0_333_2 * s1_333;
    // Op 334: dim3x1 add
    gl64_t s1_334 = *(gl64_t*)&expressions_params[9][1];
    tmp3_6 = tmp3_0 + s1_334; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 335: dim3x3 add
    gl64_t s1_335_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_335_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_335_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_335_0; tmp3_1 = tmp3_7 + s1_335_1; tmp3_2 = tmp3_8 + s1_335_2;
    // Op 336: dim3x3 mul
    gl64_t kA336 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB336 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC336 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD336 = tmp3_3 * tmp3_0;
    gl64_t kE336 = tmp3_4 * tmp3_1;
    gl64_t kF336 = tmp3_5 * tmp3_2;
    gl64_t kG336 = kD336 - kE336;
    tmp3_0 = (kC336 + kG336) - kF336;
    tmp3_1 = ((((kA336 + kC336) - kE336) - kE336) - kD336);
    tmp3_2 = kB336 - kG336;
    // Op 337: dim3x3 mul
    gl64_t s0_337_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_337_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_337_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA337 = (s0_337_0 + s0_337_1) * (tmp3_0 + tmp3_1);
    gl64_t kB337 = (s0_337_0 + s0_337_2) * (tmp3_0 + tmp3_2);
    gl64_t kC337 = (s0_337_1 + s0_337_2) * (tmp3_1 + tmp3_2);
    gl64_t kD337 = s0_337_0 * tmp3_0;
    gl64_t kE337 = s0_337_1 * tmp3_1;
    gl64_t kF337 = s0_337_2 * tmp3_2;
    gl64_t kG337 = kD337 - kE337;
    tmp3_0 = (kC337 + kG337) - kF337;
    tmp3_1 = ((((kA337 + kC337) - kE337) - kE337) - kD337);
    tmp3_2 = kB337 - kG337;
    // Op 338: dim3x3 add
    gl64_t s1_338_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_338_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_338_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_338_0; tmp3_7 = tmp3_7 + s1_338_1; tmp3_8 = tmp3_8 + s1_338_2;
    // Op 339: dim3x1 mul
    gl64_t s1_339 = *(gl64_t*)&expressions_params[9][2];
    tmp3_6 = tmp3_6 * s1_339; tmp3_7 = tmp3_7 * s1_339; tmp3_8 = tmp3_8 * s1_339;
    // Op 340: dim3x3 add
    gl64_t s1_340_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_340_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_340_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_340_0; tmp3_10 = tmp3_10 + s1_340_1; tmp3_11 = tmp3_11 + s1_340_2;
    // Op 341: dim3x1 mul
    gl64_t s1_341 = *(gl64_t*)&expressions_params[9][2];
    tmp3_9 = tmp3_9 * s1_341; tmp3_10 = tmp3_10 * s1_341; tmp3_11 = tmp3_11 * s1_341;
    // Op 342: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 343: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 344: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 345: dim3x3 mul
    gl64_t s1_345_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_345_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_345_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA345 = (tmp3_0 + tmp3_1) * (s1_345_0 + s1_345_1);
    gl64_t kB345 = (tmp3_0 + tmp3_2) * (s1_345_0 + s1_345_2);
    gl64_t kC345 = (tmp3_1 + tmp3_2) * (s1_345_1 + s1_345_2);
    gl64_t kD345 = tmp3_0 * s1_345_0;
    gl64_t kE345 = tmp3_1 * s1_345_1;
    gl64_t kF345 = tmp3_2 * s1_345_2;
    gl64_t kG345 = kD345 - kE345;
    tmp3_3 = (kC345 + kG345) - kF345;
    tmp3_4 = ((((kA345 + kC345) - kE345) - kE345) - kD345);
    tmp3_5 = kB345 - kG345;
    // Op 346: dim3x1 mul
    gl64_t s0_346_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_346_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_346_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_346 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp3_0 = s0_346_0 * s1_346; tmp3_1 = s0_346_1 * s1_346; tmp3_2 = s0_346_2 * s1_346;
    // Op 347: dim3x1 add
    gl64_t s1_347 = *(gl64_t*)&expressions_params[9][1];
    tmp3_9 = tmp3_0 + s1_347; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 348: dim3x3 add
    gl64_t s1_348_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_348_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_348_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_348_0; tmp3_13 = tmp3_10 + s1_348_1; tmp3_14 = tmp3_11 + s1_348_2;
    // Op 349: dim3x1 mul
    gl64_t s0_349_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_349_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_349_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_349 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp3_0 = s0_349_0 * s1_349; tmp3_1 = s0_349_1 * s1_349; tmp3_2 = s0_349_2 * s1_349;
    // Op 350: dim3x1 add
    gl64_t s1_350 = *(gl64_t*)&expressions_params[9][1];
    tmp3_6 = tmp3_0 + s1_350; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 351: dim3x3 add
    gl64_t s1_351_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_351_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_351_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_351_0; tmp3_1 = tmp3_7 + s1_351_1; tmp3_2 = tmp3_8 + s1_351_2;
    // Op 352: dim3x3 mul
    gl64_t kA352 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB352 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC352 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD352 = tmp3_12 * tmp3_0;
    gl64_t kE352 = tmp3_13 * tmp3_1;
    gl64_t kF352 = tmp3_14 * tmp3_2;
    gl64_t kG352 = kD352 - kE352;
    tmp3_0 = (kC352 + kG352) - kF352;
    tmp3_1 = ((((kA352 + kC352) - kE352) - kE352) - kD352);
    tmp3_2 = kB352 - kG352;
    // Op 353: dim3x3 mul
    gl64_t s0_353_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_353_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_353_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
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
    // Op 354: dim3x3 add
    gl64_t s1_354_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_354_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_354_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_354_0; tmp3_7 = tmp3_7 + s1_354_1; tmp3_8 = tmp3_8 + s1_354_2;
    // Op 355: dim3x1 mul
    gl64_t s1_355 = *(gl64_t*)&expressions_params[9][2];
    tmp3_6 = tmp3_6 * s1_355; tmp3_7 = tmp3_7 * s1_355; tmp3_8 = tmp3_8 * s1_355;
    // Op 356: dim3x3 add
    gl64_t s1_356_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_356_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_356_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_356_0; tmp3_10 = tmp3_10 + s1_356_1; tmp3_11 = tmp3_11 + s1_356_2;
    // Op 357: dim3x1 mul
    gl64_t s1_357 = *(gl64_t*)&expressions_params[9][2];
    tmp3_9 = tmp3_9 * s1_357; tmp3_10 = tmp3_10 * s1_357; tmp3_11 = tmp3_11 * s1_357;
    // Op 358: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 359: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 360: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 361: dim3x3 mul
    gl64_t s1_361_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_361_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_361_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA361 = (tmp3_0 + tmp3_1) * (s1_361_0 + s1_361_1);
    gl64_t kB361 = (tmp3_0 + tmp3_2) * (s1_361_0 + s1_361_2);
    gl64_t kC361 = (tmp3_1 + tmp3_2) * (s1_361_1 + s1_361_2);
    gl64_t kD361 = tmp3_0 * s1_361_0;
    gl64_t kE361 = tmp3_1 * s1_361_1;
    gl64_t kF361 = tmp3_2 * s1_361_2;
    gl64_t kG361 = kD361 - kE361;
    tmp3_12 = (kC361 + kG361) - kF361;
    tmp3_13 = ((((kA361 + kC361) - kE361) - kE361) - kD361);
    tmp3_14 = kB361 - kG361;
    // Op 362: dim3x1 mul
    gl64_t s0_362_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_362_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_362_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_362 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp3_0 = s0_362_0 * s1_362; tmp3_1 = s0_362_1 * s1_362; tmp3_2 = s0_362_2 * s1_362;
    // Op 363: dim3x1 add
    gl64_t s1_363 = *(gl64_t*)&expressions_params[9][1];
    tmp3_9 = tmp3_0 + s1_363; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 364: dim3x3 add
    gl64_t s1_364_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_364_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_364_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_364_0; tmp3_4 = tmp3_10 + s1_364_1; tmp3_5 = tmp3_11 + s1_364_2;
    // Op 365: dim3x1 mul
    gl64_t s0_365_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_365_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_365_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_365 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp3_0 = s0_365_0 * s1_365; tmp3_1 = s0_365_1 * s1_365; tmp3_2 = s0_365_2 * s1_365;
    // Op 366: dim3x1 add
    gl64_t s1_366 = *(gl64_t*)&expressions_params[9][1];
    tmp3_6 = tmp3_0 + s1_366; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 367: dim3x3 add
    gl64_t s1_367_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_367_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_367_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_367_0; tmp3_1 = tmp3_7 + s1_367_1; tmp3_2 = tmp3_8 + s1_367_2;
    // Op 368: dim3x3 mul
    gl64_t kA368 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB368 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC368 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD368 = tmp3_3 * tmp3_0;
    gl64_t kE368 = tmp3_4 * tmp3_1;
    gl64_t kF368 = tmp3_5 * tmp3_2;
    gl64_t kG368 = kD368 - kE368;
    tmp3_0 = (kC368 + kG368) - kF368;
    tmp3_1 = ((((kA368 + kC368) - kE368) - kE368) - kD368);
    tmp3_2 = kB368 - kG368;
    // Op 369: dim3x3 mul
    uint64_t s0_369_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_369_0 = *(gl64_t*)&dParams->aux_trace[s0_369_pos];
    gl64_t s0_369_1 = *(gl64_t*)&dParams->aux_trace[s0_369_pos + TILE_HEIGHT];
    gl64_t s0_369_2 = *(gl64_t*)&dParams->aux_trace[s0_369_pos + 2*TILE_HEIGHT];
    gl64_t kA369 = (s0_369_0 + s0_369_1) * (tmp3_0 + tmp3_1);
    gl64_t kB369 = (s0_369_0 + s0_369_2) * (tmp3_0 + tmp3_2);
    gl64_t kC369 = (s0_369_1 + s0_369_2) * (tmp3_1 + tmp3_2);
    gl64_t kD369 = s0_369_0 * tmp3_0;
    gl64_t kE369 = s0_369_1 * tmp3_1;
    gl64_t kF369 = s0_369_2 * tmp3_2;
    gl64_t kG369 = kD369 - kE369;
    tmp3_0 = (kC369 + kG369) - kF369;
    tmp3_1 = ((((kA369 + kC369) - kE369) - kE369) - kD369);
    tmp3_2 = kB369 - kG369;
    // Op 370: dim3x3 add
    gl64_t s1_370_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_370_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_370_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_370_0; tmp3_7 = tmp3_7 + s1_370_1; tmp3_8 = tmp3_8 + s1_370_2;
    // Op 371: dim3x1 mul
    gl64_t s1_371 = *(gl64_t*)&expressions_params[9][2];
    tmp3_6 = tmp3_6 * s1_371; tmp3_7 = tmp3_7 * s1_371; tmp3_8 = tmp3_8 * s1_371;
    // Op 372: dim3x3 add
    gl64_t s1_372_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_372_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_372_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_372_0; tmp3_10 = tmp3_10 + s1_372_1; tmp3_11 = tmp3_11 + s1_372_2;
    // Op 373: dim3x1 mul
    gl64_t s1_373 = *(gl64_t*)&expressions_params[9][2];
    tmp3_9 = tmp3_9 * s1_373; tmp3_10 = tmp3_10 * s1_373; tmp3_11 = tmp3_11 * s1_373;
    // Op 374: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 375: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 376: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 377: dim3x3 mul
    gl64_t s1_377_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_377_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_377_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA377 = (tmp3_0 + tmp3_1) * (s1_377_0 + s1_377_1);
    gl64_t kB377 = (tmp3_0 + tmp3_2) * (s1_377_0 + s1_377_2);
    gl64_t kC377 = (tmp3_1 + tmp3_2) * (s1_377_1 + s1_377_2);
    gl64_t kD377 = tmp3_0 * s1_377_0;
    gl64_t kE377 = tmp3_1 * s1_377_1;
    gl64_t kF377 = tmp3_2 * s1_377_2;
    gl64_t kG377 = kD377 - kE377;
    tmp3_3 = (kC377 + kG377) - kF377;
    tmp3_4 = ((((kA377 + kC377) - kE377) - kE377) - kD377);
    tmp3_5 = kB377 - kG377;
    // Op 378: dim3x1 mul
    gl64_t s0_378_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_378_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_378_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_378 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp3_0 = s0_378_0 * s1_378; tmp3_1 = s0_378_1 * s1_378; tmp3_2 = s0_378_2 * s1_378;
    // Op 379: dim3x1 add
    gl64_t s1_379 = *(gl64_t*)&expressions_params[9][1];
    tmp3_9 = tmp3_0 + s1_379; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 380: dim3x3 add
    gl64_t s1_380_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_380_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_380_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_380_0; tmp3_13 = tmp3_10 + s1_380_1; tmp3_14 = tmp3_11 + s1_380_2;
    // Op 381: dim1x1 mul
    gl64_t s0_381 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    gl64_t s1_381 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_381 * s1_381;
    // Op 382: dim1x1 add
    gl64_t s0_382 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp1_0 = s0_382 + tmp1_0;
    // Op 383: dim1x1 mul
    gl64_t s0_383 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    gl64_t s1_383 = *(gl64_t*)&expressions_params[9][4];
    tmp1_1 = s0_383 * s1_383;
    // Op 384: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 385: dim1x1 mul
    gl64_t s0_385 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_385 = *(gl64_t*)&expressions_params[9][5];
    tmp1_1 = s0_385 * s1_385;
    // Op 386: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 387: dim1x1 mul
    gl64_t s0_387 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_387 = *(gl64_t*)&expressions_params[9][6];
    tmp1_1 = s0_387 * s1_387;
    // Op 388: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 389: dim1x1 mul
    gl64_t s0_389 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    gl64_t s1_389 = *(gl64_t*)&expressions_params[9][7];
    tmp1_1 = s0_389 * s1_389;
    // Op 390: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 391: dim1x1 mul
    gl64_t s0_391 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_391 = *(gl64_t*)&expressions_params[9][8];
    tmp1_1 = s0_391 * s1_391;
    // Op 392: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 393: dim1x1 mul
    gl64_t s0_393 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_393 = *(gl64_t*)&expressions_params[9][9];
    tmp1_1 = s0_393 * s1_393;
    // Op 394: dim1x1 add
    tmp1_2 = tmp1_0 + tmp1_1;
    // Op 395: dim1x1 mul
    gl64_t s0_395 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_395 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_395 * s1_395;
    // Op 396: dim1x1 mul
    gl64_t s0_396 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_396 = *(gl64_t*)&expressions_params[9][11];
    tmp1_1 = s0_396 * s1_396;
    // Op 397: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 398: dim1x1 mul
    gl64_t s0_398 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_398 = *(gl64_t*)&expressions_params[9][12];
    tmp1_1 = s0_398 * s1_398;
    // Op 399: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 400: dim1x1 mul
    gl64_t s0_400 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_400 = *(gl64_t*)&expressions_params[9][13];
    tmp1_1 = s0_400 * s1_400;
    // Op 401: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 402: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 403: dim3x1 mul
    gl64_t s0_403_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_403_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_403_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_403_0 * tmp1_0; tmp3_1 = s0_403_1 * tmp1_0; tmp3_2 = s0_403_2 * tmp1_0;
    // Op 404: dim3x1 add
    gl64_t s1_404 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_404; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 405: dim3x3 mul
    gl64_t s1_405_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_405_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_405_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA405 = (tmp3_0 + tmp3_1) * (s1_405_0 + s1_405_1);
    gl64_t kB405 = (tmp3_0 + tmp3_2) * (s1_405_0 + s1_405_2);
    gl64_t kC405 = (tmp3_1 + tmp3_2) * (s1_405_1 + s1_405_2);
    gl64_t kD405 = tmp3_0 * s1_405_0;
    gl64_t kE405 = tmp3_1 * s1_405_1;
    gl64_t kF405 = tmp3_2 * s1_405_2;
    gl64_t kG405 = kD405 - kE405;
    tmp3_0 = (kC405 + kG405) - kF405;
    tmp3_1 = ((((kA405 + kC405) - kE405) - kE405) - kD405);
    tmp3_2 = kB405 - kG405;
    // Op 406: dim3x1 add
    gl64_t s1_406 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_406; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_408 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_408; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 409: dim3x3 mul
    gl64_t s1_409_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_409_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_409_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA409 = (tmp3_0 + tmp3_1) * (s1_409_0 + s1_409_1);
    gl64_t kB409 = (tmp3_0 + tmp3_2) * (s1_409_0 + s1_409_2);
    gl64_t kC409 = (tmp3_1 + tmp3_2) * (s1_409_1 + s1_409_2);
    gl64_t kD409 = tmp3_0 * s1_409_0;
    gl64_t kE409 = tmp3_1 * s1_409_1;
    gl64_t kF409 = tmp3_2 * s1_409_2;
    gl64_t kG409 = kD409 - kE409;
    tmp3_0 = (kC409 + kG409) - kF409;
    tmp3_1 = ((((kA409 + kC409) - kE409) - kE409) - kD409);
    tmp3_2 = kB409 - kG409;
    // Op 410: dim1x1 sub
    gl64_t s0_410 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    gl64_t s1_410 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_410 - s1_410;
    // Op 411: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 412: dim3x3 mul
    gl64_t s1_412_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_412_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_412_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA412 = (tmp3_0 + tmp3_1) * (s1_412_0 + s1_412_1);
    gl64_t kB412 = (tmp3_0 + tmp3_2) * (s1_412_0 + s1_412_2);
    gl64_t kC412 = (tmp3_1 + tmp3_2) * (s1_412_1 + s1_412_2);
    gl64_t kD412 = tmp3_0 * s1_412_0;
    gl64_t kE412 = tmp3_1 * s1_412_1;
    gl64_t kF412 = tmp3_2 * s1_412_2;
    gl64_t kG412 = kD412 - kE412;
    tmp3_0 = (kC412 + kG412) - kF412;
    tmp3_1 = ((((kA412 + kC412) - kE412) - kE412) - kD412);
    tmp3_2 = kB412 - kG412;
    // Op 413: dim3x1 add
    gl64_t s1_413 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_413; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 414: dim3x3 mul
    gl64_t s1_414_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_414_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_414_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA414 = (tmp3_0 + tmp3_1) * (s1_414_0 + s1_414_1);
    gl64_t kB414 = (tmp3_0 + tmp3_2) * (s1_414_0 + s1_414_2);
    gl64_t kC414 = (tmp3_1 + tmp3_2) * (s1_414_1 + s1_414_2);
    gl64_t kD414 = tmp3_0 * s1_414_0;
    gl64_t kE414 = tmp3_1 * s1_414_1;
    gl64_t kF414 = tmp3_2 * s1_414_2;
    gl64_t kG414 = kD414 - kE414;
    tmp3_0 = (kC414 + kG414) - kF414;
    tmp3_1 = ((((kA414 + kC414) - kE414) - kE414) - kD414);
    tmp3_2 = kB414 - kG414;
    // Op 415: dim3x1 add
    gl64_t s1_415 = *(gl64_t*)&expressions_params[9][14];
    tmp3_6 = tmp3_0 + s1_415; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 416: dim3x3 add
    gl64_t s1_416_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_416_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_416_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_416_0; tmp3_1 = tmp3_7 + s1_416_1; tmp3_2 = tmp3_8 + s1_416_2;
    // Op 417: dim3x3 mul
    gl64_t kA417 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB417 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC417 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD417 = tmp3_12 * tmp3_0;
    gl64_t kE417 = tmp3_13 * tmp3_1;
    gl64_t kF417 = tmp3_14 * tmp3_2;
    gl64_t kG417 = kD417 - kE417;
    tmp3_0 = (kC417 + kG417) - kF417;
    tmp3_1 = ((((kA417 + kC417) - kE417) - kE417) - kD417);
    tmp3_2 = kB417 - kG417;
    // Op 418: dim3x3 mul
    uint64_t s0_418_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_418_0 = *(gl64_t*)&dParams->aux_trace[s0_418_pos];
    gl64_t s0_418_1 = *(gl64_t*)&dParams->aux_trace[s0_418_pos + TILE_HEIGHT];
    gl64_t s0_418_2 = *(gl64_t*)&dParams->aux_trace[s0_418_pos + 2*TILE_HEIGHT];
    gl64_t kA418 = (s0_418_0 + s0_418_1) * (tmp3_0 + tmp3_1);
    gl64_t kB418 = (s0_418_0 + s0_418_2) * (tmp3_0 + tmp3_2);
    gl64_t kC418 = (s0_418_1 + s0_418_2) * (tmp3_1 + tmp3_2);
    gl64_t kD418 = s0_418_0 * tmp3_0;
    gl64_t kE418 = s0_418_1 * tmp3_1;
    gl64_t kF418 = s0_418_2 * tmp3_2;
    gl64_t kG418 = kD418 - kE418;
    tmp3_0 = (kC418 + kG418) - kF418;
    tmp3_1 = ((((kA418 + kC418) - kE418) - kE418) - kD418);
    tmp3_2 = kB418 - kG418;
    // Op 419: dim3x3 add
    gl64_t s1_419_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_419_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_419_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_419_0; tmp3_7 = tmp3_7 + s1_419_1; tmp3_8 = tmp3_8 + s1_419_2;
    // Op 420: dim3x1 mul
    gl64_t s1_420 = *(gl64_t*)&expressions_params[9][2];
    tmp3_6 = tmp3_6 * s1_420; tmp3_7 = tmp3_7 * s1_420; tmp3_8 = tmp3_8 * s1_420;
    // Op 421: dim3x3 add
    gl64_t s1_421_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_421_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_421_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_421_0; tmp3_10 = tmp3_10 + s1_421_1; tmp3_11 = tmp3_11 + s1_421_2;
    // Op 422: dim3x1 mul
    gl64_t s1_422 = *(gl64_t*)&expressions_params[9][2];
    tmp3_9 = tmp3_9 * s1_422; tmp3_10 = tmp3_10 * s1_422; tmp3_11 = tmp3_11 * s1_422;
    // Op 423: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 424: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 425: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 426: dim3x3 mul
    gl64_t s1_426_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_426_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_426_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA426 = (tmp3_0 + tmp3_1) * (s1_426_0 + s1_426_1);
    gl64_t kB426 = (tmp3_0 + tmp3_2) * (s1_426_0 + s1_426_2);
    gl64_t kC426 = (tmp3_1 + tmp3_2) * (s1_426_1 + s1_426_2);
    gl64_t kD426 = tmp3_0 * s1_426_0;
    gl64_t kE426 = tmp3_1 * s1_426_1;
    gl64_t kF426 = tmp3_2 * s1_426_2;
    gl64_t kG426 = kD426 - kE426;
    tmp3_3 = (kC426 + kG426) - kF426;
    tmp3_4 = ((((kA426 + kC426) - kE426) - kE426) - kD426);
    tmp3_5 = kB426 - kG426;
    // Op 427: dim3x1 mul
    gl64_t s0_427_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_427_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_427_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_427 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp3_0 = s0_427_0 * s1_427; tmp3_1 = s0_427_1 * s1_427; tmp3_2 = s0_427_2 * s1_427;
    // Op 428: dim3x1 add
    gl64_t s1_428 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_428; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 429: dim3x3 mul
    gl64_t s1_429_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_429_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_429_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA429 = (tmp3_0 + tmp3_1) * (s1_429_0 + s1_429_1);
    gl64_t kB429 = (tmp3_0 + tmp3_2) * (s1_429_0 + s1_429_2);
    gl64_t kC429 = (tmp3_1 + tmp3_2) * (s1_429_1 + s1_429_2);
    gl64_t kD429 = tmp3_0 * s1_429_0;
    gl64_t kE429 = tmp3_1 * s1_429_1;
    gl64_t kF429 = tmp3_2 * s1_429_2;
    gl64_t kG429 = kD429 - kE429;
    tmp3_0 = (kC429 + kG429) - kF429;
    tmp3_1 = ((((kA429 + kC429) - kE429) - kE429) - kD429);
    tmp3_2 = kB429 - kG429;
    // Op 430: dim3x1 add
    gl64_t s1_430 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_430; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_432 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
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
    // Op 434: dim1x1 mul
    gl64_t s0_434 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_434 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_434 * s1_434;
    // Op 435: dim1x1 add
    gl64_t s0_435 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_435 + tmp1_0;
    // Op 436: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 438: dim1x1 add
    gl64_t s0_438 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_438 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_438 + s1_438;
    // Op 439: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_441 = *(gl64_t*)&expressions_params[9][15];
    tmp3_0 = tmp3_0 + s1_441; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 442: dim3x3 add
    gl64_t s1_442_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_442_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_442_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_442_0; tmp3_1 = tmp3_1 + s1_442_1; tmp3_2 = tmp3_2 + s1_442_2;
    // Op 443: dim3x3 mul
    gl64_t s0_443_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_443_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_443_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    gl64_t kA443 = (s0_443_0 + s0_443_1) * (tmp3_0 + tmp3_1);
    gl64_t kB443 = (s0_443_0 + s0_443_2) * (tmp3_0 + tmp3_2);
    gl64_t kC443 = (s0_443_1 + s0_443_2) * (tmp3_1 + tmp3_2);
    gl64_t kD443 = s0_443_0 * tmp3_0;
    gl64_t kE443 = s0_443_1 * tmp3_1;
    gl64_t kF443 = s0_443_2 * tmp3_2;
    gl64_t kG443 = kD443 - kE443;
    tmp3_0 = (kC443 + kG443) - kF443;
    tmp3_1 = ((((kA443 + kC443) - kE443) - kE443) - kD443);
    tmp3_2 = kB443 - kG443;
    // Op 444: dim1x1 sub
    gl64_t s0_444 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_3 = s0_444 - tmp1_3;
    // Op 445: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_3; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 446: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 447: dim3x3 mul
    gl64_t s1_447_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_447_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_447_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA447 = (tmp3_0 + tmp3_1) * (s1_447_0 + s1_447_1);
    gl64_t kB447 = (tmp3_0 + tmp3_2) * (s1_447_0 + s1_447_2);
    gl64_t kC447 = (tmp3_1 + tmp3_2) * (s1_447_1 + s1_447_2);
    gl64_t kD447 = tmp3_0 * s1_447_0;
    gl64_t kE447 = tmp3_1 * s1_447_1;
    gl64_t kF447 = tmp3_2 * s1_447_2;
    gl64_t kG447 = kD447 - kE447;
    tmp3_6 = (kC447 + kG447) - kF447;
    tmp3_7 = ((((kA447 + kC447) - kE447) - kE447) - kD447);
    tmp3_8 = kB447 - kG447;
    // Op 448: dim1x1 sub_swap
    gl64_t s0_448 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_0)];
    gl64_t s1_448 = *(gl64_t*)&expressions_params[9][0];
    tmp1_3 = s1_448 - s0_448;
    // Op 449: dim3x1 mul
    uint64_t s0_449_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_449_0 = *(gl64_t*)&dParams->aux_trace[s0_449_pos];
    gl64_t s0_449_1 = *(gl64_t*)&dParams->aux_trace[s0_449_pos + TILE_HEIGHT];
    gl64_t s0_449_2 = *(gl64_t*)&dParams->aux_trace[s0_449_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_449_0 * tmp1_3; tmp3_1 = s0_449_1 * tmp1_3; tmp3_2 = s0_449_2 * tmp1_3;
    // Op 450: dim3x3 sub
    uint64_t s0_450_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_450_0 = *(gl64_t*)&dParams->aux_trace[s0_450_pos];
    gl64_t s0_450_1 = *(gl64_t*)&dParams->aux_trace[s0_450_pos + TILE_HEIGHT];
    gl64_t s0_450_2 = *(gl64_t*)&dParams->aux_trace[s0_450_pos + 2*TILE_HEIGHT];
    tmp3_3 = s0_450_0 - tmp3_0; tmp3_4 = s0_450_1 - tmp3_1; tmp3_5 = s0_450_2 - tmp3_2;
    // Op 451: dim3x3 add
    gl64_t s0_451_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_451_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_451_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_451_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_451_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_451_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_0 = s0_451_0 + s1_451_0; tmp3_1 = s0_451_1 + s1_451_1; tmp3_2 = s0_451_2 + s1_451_2;
    // Op 452: dim3x3 add
    uint64_t s0_452_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_452_0 = *(gl64_t*)&dParams->aux_trace[s0_452_pos];
    gl64_t s0_452_1 = *(gl64_t*)&dParams->aux_trace[s0_452_pos + TILE_HEIGHT];
    gl64_t s0_452_2 = *(gl64_t*)&dParams->aux_trace[s0_452_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_452_0 + tmp3_0; tmp3_1 = s0_452_1 + tmp3_1; tmp3_2 = s0_452_2 + tmp3_2;
    // Op 453: dim3x3 add
    uint64_t s0_453_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_453_0 = *(gl64_t*)&dParams->aux_trace[s0_453_pos];
    gl64_t s0_453_1 = *(gl64_t*)&dParams->aux_trace[s0_453_pos + TILE_HEIGHT];
    gl64_t s0_453_2 = *(gl64_t*)&dParams->aux_trace[s0_453_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_453_0 + tmp3_0; tmp3_1 = s0_453_1 + tmp3_1; tmp3_2 = s0_453_2 + tmp3_2;
    // Op 454: dim3x3 add
    gl64_t s0_454_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_454_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_454_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    tmp3_0 = s0_454_0 + tmp3_0; tmp3_1 = s0_454_1 + tmp3_1; tmp3_2 = s0_454_2 + tmp3_2;
    // Op 455: dim3x3 sub
    tmp3_3 = tmp3_3 - tmp3_0; tmp3_4 = tmp3_4 - tmp3_1; tmp3_5 = tmp3_5 - tmp3_2;
    // Op 456: dim3x1 mul
    gl64_t s0_456_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_456_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_456_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_456 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp3_0 = s0_456_0 * s1_456; tmp3_1 = s0_456_1 * s1_456; tmp3_2 = s0_456_2 * s1_456;
    // Op 457: dim3x1 add
    gl64_t s1_457 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_457; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 458: dim3x3 add
    gl64_t s1_458_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_458_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_458_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_458_0; tmp3_1 = tmp3_1 + s1_458_1; tmp3_2 = tmp3_2 + s1_458_2;
    // Op 459: dim3x3 mul
    gl64_t kA459 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB459 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC459 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD459 = tmp3_3 * tmp3_0;
    gl64_t kE459 = tmp3_4 * tmp3_1;
    gl64_t kF459 = tmp3_5 * tmp3_2;
    gl64_t kG459 = kD459 - kE459;
    tmp3_0 = (kC459 + kG459) - kF459;
    tmp3_1 = ((((kA459 + kC459) - kE459) - kE459) - kD459);
    tmp3_2 = kB459 - kG459;
    // Op 460: dim3x1 add
    gl64_t s1_460 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_460; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 461: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 462: dim3x3 mul
    gl64_t s1_462_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_462_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_462_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA462 = (tmp3_0 + tmp3_1) * (s1_462_0 + s1_462_1);
    gl64_t kB462 = (tmp3_0 + tmp3_2) * (s1_462_0 + s1_462_2);
    gl64_t kC462 = (tmp3_1 + tmp3_2) * (s1_462_1 + s1_462_2);
    gl64_t kD462 = tmp3_0 * s1_462_0;
    gl64_t kE462 = tmp3_1 * s1_462_1;
    gl64_t kF462 = tmp3_2 * s1_462_2;
    gl64_t kG462 = kD462 - kE462;
    tmp3_6 = (kC462 + kG462) - kF462;
    tmp3_7 = ((((kA462 + kC462) - kE462) - kE462) - kD462);
    tmp3_8 = kB462 - kG462;
    // Op 463: dim3x3 sub_swap
    uint64_t s0_463_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_463_0 = *(gl64_t*)&dParams->aux_trace[s0_463_pos];
    gl64_t s0_463_1 = *(gl64_t*)&dParams->aux_trace[s0_463_pos + TILE_HEIGHT];
    gl64_t s0_463_2 = *(gl64_t*)&dParams->aux_trace[s0_463_pos + 2*TILE_HEIGHT];
    gl64_t s1_463_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_463_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_463_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_0 = s1_463_0 - s0_463_0; tmp3_1 = s1_463_1 - s0_463_1; tmp3_2 = s1_463_2 - s0_463_2;
    // Op 464: dim3x1 mul
    gl64_t s1_464 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_464; tmp3_1 = tmp3_1 * s1_464; tmp3_2 = tmp3_2 * s1_464;
    // Op 465: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 466: dim3x3 mul
    gl64_t s1_466_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_466_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_466_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 467: dim1x1 mul
    gl64_t s0_467 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_467 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_3 = s0_467 * s1_467;
    // Op 468: dim1x1 sub
    gl64_t s0_468 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_2))];
    tmp1_3 = s0_468 - tmp1_3;
    // Op 469: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_3; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 470: dim3x3 mul
    gl64_t s1_470_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_470_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_470_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 471: dim1x1 mul
    gl64_t s0_471 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_471 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_3 = s0_471 * s1_471;
    // Op 472: dim1x1 sub_swap
    gl64_t s0_472 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_472 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_472 - s0_472;
    // Op 473: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 474: dim1x1 sub
    gl64_t s0_474 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_2))];
    tmp1_0 = s0_474 - tmp1_0;
    // Op 475: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC476 + kG476) - kF476;
    tmp3_1 = ((((kA476 + kC476) - kE476) - kE476) - kD476);
    tmp3_2 = kB476 - kG476;
    // Op 477: dim1x1 mul
    gl64_t s0_477 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_477 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    tmp1_0 = s0_477 * s1_477;
    // Op 478: dim1x1 sub
    gl64_t s0_478 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_2))];
    tmp1_0 = s0_478 - tmp1_0;
    // Op 479: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 480: dim3x3 mul
    gl64_t s1_480_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_480_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_480_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 481: dim1x1 sub_swap
    gl64_t s0_481 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 16, domainSize, nCols_1))];
    gl64_t s1_481 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_481 - s0_481;
    // Op 482: dim1x1 mul
    gl64_t s0_482 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    gl64_t s1_482 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_3 = s0_482 * s1_482;
    // Op 483: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_3;
    // Op 484: dim1x1 mul
    gl64_t s0_484 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_2 = s0_484 * tmp1_0;
    // Op 485: dim1x1 sub_swap
    gl64_t s0_485 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 17, domainSize, nCols_1))];
    gl64_t s1_485 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_485 - s0_485;
    // Op 486: dim1x1 mul
    gl64_t s0_486 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    gl64_t s1_486 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_3 = s0_486 * s1_486;
    // Op 487: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_3;
    // Op 488: dim1x1 mul
    gl64_t s0_488 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_488 * tmp1_0;
    // Op 489: dim1x1 add
    tmp1_3 = tmp1_2 + tmp1_0;
    // Op 490: dim1x1 sub_swap
    gl64_t s0_490 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 18, domainSize, nCols_1))];
    gl64_t s1_490 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_490 - s0_490;
    // Op 491: dim1x1 mul
    gl64_t s0_491 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    gl64_t s1_491 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 18, domainSize, nCols_1))];
    tmp1_2 = s0_491 * s1_491;
    // Op 492: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_2;
    // Op 493: dim1x1 mul
    gl64_t s0_493 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_493 * tmp1_0;
    // Op 494: dim1x1 add
    tmp1_2 = tmp1_3 + tmp1_0;
    // Op 495: dim1x1 sub_swap
    gl64_t s0_495 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 19, domainSize, nCols_1))];
    gl64_t s1_495 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_495 - s0_495;
    // Op 496: dim1x1 mul
    gl64_t s0_496 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    gl64_t s1_496 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 19, domainSize, nCols_1))];
    tmp1_3 = s0_496 * s1_496;
    // Op 497: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_3;
    // Op 498: dim1x1 mul
    gl64_t s0_498 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_0 = s0_498 * tmp1_0;
    // Op 499: dim1x1 add
    tmp1_3 = tmp1_2 + tmp1_0;
    // Op 500: dim1x1 sub_swap
    gl64_t s0_500 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 20, domainSize, nCols_1))];
    gl64_t s1_500 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_500 - s0_500;
    // Op 501: dim1x1 mul
    gl64_t s0_501 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    gl64_t s1_501 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 20, domainSize, nCols_1))];
    tmp1_2 = s0_501 * s1_501;
    // Op 502: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_2;
    // Op 503: dim1x1 mul
    gl64_t s0_503 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_503 * tmp1_0;
    // Op 504: dim1x1 add
    tmp1_2 = tmp1_3 + tmp1_0;
    // Op 505: dim1x1 sub_swap
    gl64_t s0_505 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 21, domainSize, nCols_1))];
    gl64_t s1_505 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_505 - s0_505;
    // Op 506: dim1x1 mul
    gl64_t s0_506 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    gl64_t s1_506 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 21, domainSize, nCols_1))];
    tmp1_3 = s0_506 * s1_506;
    // Op 507: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_3;
    // Op 508: dim1x1 mul
    gl64_t s0_508 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_508 * tmp1_0;
    // Op 509: dim1x1 add
    tmp1_3 = tmp1_2 + tmp1_0;
    // Op 510: dim1x1 sub_swap
    gl64_t s0_510 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 22, domainSize, nCols_1))];
    gl64_t s1_510 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_510 - s0_510;
    // Op 511: dim1x1 mul
    gl64_t s0_511 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    gl64_t s1_511 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 22, domainSize, nCols_1))];
    tmp1_2 = s0_511 * s1_511;
    // Op 512: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_2;
    // Op 513: dim1x1 mul
    gl64_t s0_513 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_513 * tmp1_0;
    // Op 514: dim1x1 add
    tmp1_2 = tmp1_3 + tmp1_0;
    // Op 515: dim1x1 sub_swap
    gl64_t s0_515 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 23, domainSize, nCols_1))];
    gl64_t s1_515 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_515 - s0_515;
    // Op 516: dim1x1 mul
    gl64_t s0_516 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    gl64_t s1_516 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 23, domainSize, nCols_1))];
    tmp1_3 = s0_516 * s1_516;
    // Op 517: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_3;
    // Op 518: dim1x1 mul
    gl64_t s0_518 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_0 = s0_518 * tmp1_0;
    // Op 519: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 520: dim1x1 sub
    gl64_t s0_520 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_2))];
    tmp1_0 = s0_520 - tmp1_0;
    // Op 521: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 522: dim3x1 mul
    gl64_t s1_522 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_522; tmp3_1 = tmp3_1 * s1_522; tmp3_2 = tmp3_2 * s1_522;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
