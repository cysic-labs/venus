// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: 95dc0ab3  nOps=522 nTemp1=4 nTemp3=5
#define GENERATED_EVAL_NOPS_95dc0ab3 522
#define GENERATED_EVAL_NTEMP1_95dc0ab3 4
#define GENERATED_EVAL_NTEMP3_95dc0ab3 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_95dc0ab3(
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
    gl64_t s0_136 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_136 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_136 - s0_136;
    // Op 137: dim1x1 add
    gl64_t s0_137 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_137 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp1_3 = s0_137 + s1_137;
    // Op 138: dim1x1 sub_swap
    gl64_t s1_138 = *(gl64_t*)&expressions_params[9][0];
    tmp1_1 = s1_138 - tmp1_3;
    // Op 139: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 140: dim1x1 sub
    gl64_t s0_140 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_140 - tmp1_0;
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
    // Op 143: dim1x1 sub
    gl64_t s0_143 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 24, domainSize, nCols_1))];
    gl64_t s1_143 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_143 - s1_143;
    // Op 144: dim1x1 sub
    gl64_t s1_144 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_144;
    // Op 145: dim1x1 mul
    gl64_t s0_145 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_2 = s0_145 * tmp1_0;
    // Op 146: dim1x1 sub_swap
    gl64_t s0_146 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    gl64_t s1_146 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_146 - s0_146;
    // Op 147: dim1x1 sub
    gl64_t s0_147 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 24, domainSize, nCols_1))];
    gl64_t s1_147 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_1 = s0_147 - s1_147;
    // Op 148: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 149: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 150: dim1x1 mul
    gl64_t s0_150 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_2))];
    tmp1_0 = s0_150 * tmp1_0;
    // Op 151: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 152: dim3x3 mul
    gl64_t s1_152_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_152_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_152_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA152 = (tmp3_0 + tmp3_1) * (s1_152_0 + s1_152_1);
    gl64_t kB152 = (tmp3_0 + tmp3_2) * (s1_152_0 + s1_152_2);
    gl64_t kC152 = (tmp3_1 + tmp3_2) * (s1_152_1 + s1_152_2);
    gl64_t kD152 = tmp3_0 * s1_152_0;
    gl64_t kE152 = tmp3_1 * s1_152_1;
    gl64_t kF152 = tmp3_2 * s1_152_2;
    gl64_t kG152 = kD152 - kE152;
    tmp3_0 = (kC152 + kG152) - kF152;
    tmp3_1 = ((((kA152 + kC152) - kE152) - kE152) - kD152);
    tmp3_2 = kB152 - kG152;
    // Op 153: dim1x1 sub
    gl64_t s0_153 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 24, domainSize, nCols_1))];
    gl64_t s1_153 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_153 - s1_153;
    // Op 154: dim1x1 add
    gl64_t s1_154 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_154;
    // Op 155: dim1x1 mul
    gl64_t s0_155 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_2))];
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
    // Op 158: dim1x1 sub
    gl64_t s0_158 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 24, domainSize, nCols_1))];
    gl64_t s1_158 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_158 - s1_158;
    // Op 159: dim1x1 sub
    gl64_t s1_159 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 - s1_159;
    // Op 160: dim1x1 mul
    gl64_t s0_160 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_1 = s0_160 * tmp1_0;
    // Op 161: dim1x1 sub_swap
    gl64_t s0_161 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    gl64_t s1_161 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_161 - s0_161;
    // Op 162: dim1x1 sub
    gl64_t s0_162 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 24, domainSize, nCols_1))];
    gl64_t s1_162 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_2 = s0_162 - s1_162;
    // Op 163: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_2;
    // Op 164: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 165: dim1x1 mul
    gl64_t s0_165 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_2))];
    tmp1_0 = s0_165 * tmp1_0;
    // Op 166: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 167: dim3x3 mul
    gl64_t s1_167_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_167_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_167_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA167 = (tmp3_0 + tmp3_1) * (s1_167_0 + s1_167_1);
    gl64_t kB167 = (tmp3_0 + tmp3_2) * (s1_167_0 + s1_167_2);
    gl64_t kC167 = (tmp3_1 + tmp3_2) * (s1_167_1 + s1_167_2);
    gl64_t kD167 = tmp3_0 * s1_167_0;
    gl64_t kE167 = tmp3_1 * s1_167_1;
    gl64_t kF167 = tmp3_2 * s1_167_2;
    gl64_t kG167 = kD167 - kE167;
    tmp3_0 = (kC167 + kG167) - kF167;
    tmp3_1 = ((((kA167 + kC167) - kE167) - kE167) - kD167);
    tmp3_2 = kB167 - kG167;
    // Op 168: dim1x1 mul
    gl64_t s0_168 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_168 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_1 = s0_168 * s1_168;
    // Op 169: dim1x1 sub
    gl64_t s0_169 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 24, domainSize, nCols_1))];
    gl64_t s1_169 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp1_0 = s0_169 - s1_169;
    // Op 170: dim1x1 add
    gl64_t s1_170 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = tmp1_0 + s1_170;
    // Op 171: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
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
    gl64_t s0_174 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_174 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_174 - s0_174;
    // Op 175: dim1x1 mul
    gl64_t s0_175 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_0 = s0_175 * tmp1_0;
    // Op 176: dim1x1 mul
    gl64_t s0_176 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_2))];
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
    // Op 179: dim1x1 mul
    gl64_t s0_179 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_179 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_179 * s1_179;
    // Op 180: dim1x1 add
    gl64_t s0_180 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_180 + tmp1_0;
    // Op 181: dim1x1 mul
    gl64_t s0_181 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_181 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_181 * s1_181;
    // Op 182: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 183: dim1x1 mul
    gl64_t s0_183 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_183 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_183 * s1_183;
    // Op 184: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 185: dim1x1 mul
    gl64_t s0_185 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp1_2 = s0_185 * tmp1_0;
    // Op 186: dim1x1 mul
    gl64_t s0_186 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_186 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_186 * s1_186;
    // Op 187: dim1x1 add
    gl64_t s0_187 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_187 + tmp1_0;
    // Op 188: dim1x1 mul
    gl64_t s0_188 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_188 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_188 * s1_188;
    // Op 189: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 190: dim1x1 mul
    gl64_t s0_190 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_190 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_190 * s1_190;
    // Op 191: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 192: dim1x1 mul
    gl64_t s0_192 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_192 * tmp1_0;
    // Op 193: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 194: dim1x1 mul
    gl64_t s0_194 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_194 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_194 * s1_194;
    // Op 195: dim1x1 add
    gl64_t s0_195 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_195 + tmp1_0;
    // Op 196: dim1x1 mul
    gl64_t s0_196 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_196 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_196 * s1_196;
    // Op 197: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 198: dim1x1 mul
    gl64_t s0_198 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_198 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_198 * s1_198;
    // Op 199: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 200: dim1x1 mul
    gl64_t s0_200 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp1_0 = s0_200 * tmp1_0;
    // Op 201: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 202: dim1x1 mul
    gl64_t s0_202 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_202 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_202 * s1_202;
    // Op 203: dim1x1 add
    gl64_t s0_203 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_0 = s0_203 + tmp1_0;
    // Op 204: dim1x1 mul
    gl64_t s0_204 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_204 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_204 * s1_204;
    // Op 205: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 206: dim1x1 mul
    gl64_t s0_206 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_206 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_206 * s1_206;
    // Op 207: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 208: dim1x1 mul
    gl64_t s0_208 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_0 = s0_208 * tmp1_0;
    // Op 209: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 210: dim1x1 mul
    gl64_t s0_210 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_210 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_210 * s1_210;
    // Op 211: dim1x1 add
    gl64_t s0_211 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_211 + tmp1_0;
    // Op 212: dim1x1 mul
    gl64_t s0_212 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_212 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_212 * s1_212;
    // Op 213: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 214: dim1x1 mul
    gl64_t s0_214 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_214 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_214 * s1_214;
    // Op 215: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 216: dim1x1 mul
    gl64_t s0_216 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_0 = s0_216 * tmp1_0;
    // Op 217: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 218: dim1x1 mul
    gl64_t s0_218 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_218 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_218 * s1_218;
    // Op 219: dim1x1 add
    gl64_t s0_219 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_219 + tmp1_0;
    // Op 220: dim1x1 mul
    gl64_t s0_220 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_220 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_220 * s1_220;
    // Op 221: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 222: dim1x1 mul
    gl64_t s0_222 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_222 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_222 * s1_222;
    // Op 223: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 224: dim1x1 mul
    gl64_t s0_224 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_224 * tmp1_0;
    // Op 225: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 226: dim1x1 mul
    gl64_t s0_226 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_226 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_226 * s1_226;
    // Op 227: dim1x1 add
    gl64_t s0_227 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_227 + tmp1_0;
    // Op 228: dim1x1 mul
    gl64_t s0_228 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_228 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_228 * s1_228;
    // Op 229: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 230: dim1x1 mul
    gl64_t s0_230 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_230 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_230 * s1_230;
    // Op 231: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 232: dim1x1 mul
    gl64_t s0_232 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_232 * tmp1_0;
    // Op 233: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 234: dim1x1 mul
    gl64_t s0_234 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_234 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_234 * s1_234;
    // Op 235: dim1x1 add
    gl64_t s0_235 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_0 = s0_235 + tmp1_0;
    // Op 236: dim1x1 mul
    gl64_t s0_236 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_236 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_236 * s1_236;
    // Op 237: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 238: dim1x1 mul
    gl64_t s0_238 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_238 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_238 * s1_238;
    // Op 239: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 240: dim1x1 mul
    gl64_t s0_240 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = s0_240 * tmp1_0;
    // Op 241: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 242: dim1x1 mul
    gl64_t s0_242 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_1 = s0_242 * tmp1_0;
    // Op 243: dim1x1 mul
    gl64_t s0_243 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_243 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_243 * s1_243;
    // Op 244: dim1x1 add
    gl64_t s0_244 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_244 + tmp1_0;
    // Op 245: dim1x1 mul
    gl64_t s0_245 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_245 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_245 * s1_245;
    // Op 246: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 247: dim1x1 mul
    gl64_t s0_247 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_247 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_247 * s1_247;
    // Op 248: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 249: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 250: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 251: dim1x1 sub
    gl64_t s0_251 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
    tmp1_0 = s0_251 - tmp1_0;
    // Op 252: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 253: dim3x3 mul
    gl64_t s1_253_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_253_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_253_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 254: dim1x1 mul
    gl64_t s0_254 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_254 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_254 * s1_254;
    // Op 255: dim1x1 add
    gl64_t s0_255 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_255 + tmp1_0;
    // Op 256: dim1x1 mul
    gl64_t s0_256 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_256 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_256 * s1_256;
    // Op 257: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 258: dim1x1 mul
    gl64_t s0_258 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_258 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_258 * s1_258;
    // Op 259: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 260: dim1x1 mul
    gl64_t s0_260 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp1_2 = s0_260 * tmp1_0;
    // Op 261: dim1x1 mul
    gl64_t s0_261 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_261 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_261 * s1_261;
    // Op 262: dim1x1 add
    gl64_t s0_262 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_262 + tmp1_0;
    // Op 263: dim1x1 mul
    gl64_t s0_263 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_263 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_263 * s1_263;
    // Op 264: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 265: dim1x1 mul
    gl64_t s0_265 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_265 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_265 * s1_265;
    // Op 266: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 267: dim1x1 mul
    gl64_t s0_267 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    tmp1_0 = s0_267 * tmp1_0;
    // Op 268: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 269: dim1x1 mul
    gl64_t s0_269 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_269 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_269 * s1_269;
    // Op 270: dim1x1 add
    gl64_t s0_270 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_270 + tmp1_0;
    // Op 271: dim1x1 mul
    gl64_t s0_271 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_271 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_271 * s1_271;
    // Op 272: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 273: dim1x1 mul
    gl64_t s0_273 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_273 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_273 * s1_273;
    // Op 274: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 275: dim1x1 mul
    gl64_t s0_275 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp1_0 = s0_275 * tmp1_0;
    // Op 276: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 277: dim1x1 mul
    gl64_t s0_277 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    gl64_t s1_277 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_277 * s1_277;
    // Op 278: dim1x1 add
    gl64_t s0_278 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_0 = s0_278 + tmp1_0;
    // Op 279: dim1x1 mul
    gl64_t s0_279 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_279 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_279 * s1_279;
    // Op 280: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 281: dim1x1 mul
    gl64_t s0_281 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_281 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_281 * s1_281;
    // Op 282: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 283: dim1x1 mul
    gl64_t s0_283 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_0 = s0_283 * tmp1_0;
    // Op 284: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 285: dim1x1 mul
    gl64_t s0_285 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    gl64_t s1_285 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_285 * s1_285;
    // Op 286: dim1x1 add
    gl64_t s0_286 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_0 = s0_286 + tmp1_0;
    // Op 287: dim1x1 mul
    gl64_t s0_287 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_287 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_287 * s1_287;
    // Op 288: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 289: dim1x1 mul
    gl64_t s0_289 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_289 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_289 * s1_289;
    // Op 290: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 291: dim1x1 mul
    gl64_t s0_291 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_0 = s0_291 * tmp1_0;
    // Op 292: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 293: dim1x1 mul
    gl64_t s0_293 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    gl64_t s1_293 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_293 * s1_293;
    // Op 294: dim1x1 add
    gl64_t s0_294 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_294 + tmp1_0;
    // Op 295: dim1x1 mul
    gl64_t s0_295 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_295 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_295 * s1_295;
    // Op 296: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 297: dim1x1 mul
    gl64_t s0_297 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_297 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_297 * s1_297;
    // Op 298: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 299: dim1x1 mul
    gl64_t s0_299 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_0 = s0_299 * tmp1_0;
    // Op 300: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 301: dim1x1 mul
    gl64_t s0_301 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    gl64_t s1_301 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_301 * s1_301;
    // Op 302: dim1x1 add
    gl64_t s0_302 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_302 + tmp1_0;
    // Op 303: dim1x1 mul
    gl64_t s0_303 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_303 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_303 * s1_303;
    // Op 304: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 305: dim1x1 mul
    gl64_t s0_305 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_305 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_305 * s1_305;
    // Op 306: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 307: dim1x1 mul
    gl64_t s0_307 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_0 = s0_307 * tmp1_0;
    // Op 308: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_0;
    // Op 309: dim1x1 mul
    gl64_t s0_309 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    gl64_t s1_309 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_309 * s1_309;
    // Op 310: dim1x1 add
    gl64_t s0_310 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_0 = s0_310 + tmp1_0;
    // Op 311: dim1x1 mul
    gl64_t s0_311 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_311 = *(gl64_t*)&expressions_params[9][16];
    tmp1_1 = s0_311 * s1_311;
    // Op 312: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 313: dim1x1 mul
    gl64_t s0_313 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_313 = *(gl64_t*)&expressions_params[9][17];
    tmp1_1 = s0_313 * s1_313;
    // Op 314: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 315: dim1x1 mul
    gl64_t s0_315 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_0 = s0_315 * tmp1_0;
    // Op 316: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 317: dim1x1 mul
    gl64_t s0_317 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_1 = s0_317 * tmp1_0;
    // Op 318: dim1x1 mul
    gl64_t s0_318 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    gl64_t s1_318 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_318 * s1_318;
    // Op 319: dim1x1 add
    gl64_t s0_319 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_319 + tmp1_0;
    // Op 320: dim1x1 mul
    gl64_t s0_320 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    gl64_t s1_320 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_320 * s1_320;
    // Op 321: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 322: dim1x1 mul
    gl64_t s0_322 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    gl64_t s1_322 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_322 * s1_322;
    // Op 323: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 324: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 325: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 326: dim1x1 sub
    gl64_t s0_326 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp1_0 = s0_326 - tmp1_0;
    // Op 327: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 328: dim3x3 mul
    gl64_t s1_328_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_328_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_328_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA328 = (tmp3_0 + tmp3_1) * (s1_328_0 + s1_328_1);
    gl64_t kB328 = (tmp3_0 + tmp3_2) * (s1_328_0 + s1_328_2);
    gl64_t kC328 = (tmp3_1 + tmp3_2) * (s1_328_1 + s1_328_2);
    gl64_t kD328 = tmp3_0 * s1_328_0;
    gl64_t kE328 = tmp3_1 * s1_328_1;
    gl64_t kF328 = tmp3_2 * s1_328_2;
    gl64_t kG328 = kD328 - kE328;
    tmp3_12 = (kC328 + kG328) - kF328;
    tmp3_13 = ((((kA328 + kC328) - kE328) - kE328) - kD328);
    tmp3_14 = kB328 - kG328;
    // Op 329: dim3x1 mul
    gl64_t s0_329_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_329_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_329_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_329 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp3_0 = s0_329_0 * s1_329; tmp3_1 = s0_329_1 * s1_329; tmp3_2 = s0_329_2 * s1_329;
    // Op 330: dim3x1 add
    gl64_t s1_330 = *(gl64_t*)&expressions_params[9][1];
    tmp3_9 = tmp3_0 + s1_330; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 331: dim3x3 add
    gl64_t s1_331_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_331_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_331_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_331_0; tmp3_4 = tmp3_10 + s1_331_1; tmp3_5 = tmp3_11 + s1_331_2;
    // Op 332: dim3x1 mul
    gl64_t s0_332_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_332_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_332_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_332 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp3_0 = s0_332_0 * s1_332; tmp3_1 = s0_332_1 * s1_332; tmp3_2 = s0_332_2 * s1_332;
    // Op 333: dim3x1 add
    gl64_t s1_333 = *(gl64_t*)&expressions_params[9][1];
    tmp3_6 = tmp3_0 + s1_333; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 334: dim3x3 add
    gl64_t s1_334_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_334_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_334_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_334_0; tmp3_1 = tmp3_7 + s1_334_1; tmp3_2 = tmp3_8 + s1_334_2;
    // Op 335: dim3x3 mul
    gl64_t kA335 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB335 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC335 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD335 = tmp3_3 * tmp3_0;
    gl64_t kE335 = tmp3_4 * tmp3_1;
    gl64_t kF335 = tmp3_5 * tmp3_2;
    gl64_t kG335 = kD335 - kE335;
    tmp3_0 = (kC335 + kG335) - kF335;
    tmp3_1 = ((((kA335 + kC335) - kE335) - kE335) - kD335);
    tmp3_2 = kB335 - kG335;
    // Op 336: dim3x3 mul
    gl64_t s0_336_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_336_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_336_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA336 = (s0_336_0 + s0_336_1) * (tmp3_0 + tmp3_1);
    gl64_t kB336 = (s0_336_0 + s0_336_2) * (tmp3_0 + tmp3_2);
    gl64_t kC336 = (s0_336_1 + s0_336_2) * (tmp3_1 + tmp3_2);
    gl64_t kD336 = s0_336_0 * tmp3_0;
    gl64_t kE336 = s0_336_1 * tmp3_1;
    gl64_t kF336 = s0_336_2 * tmp3_2;
    gl64_t kG336 = kD336 - kE336;
    tmp3_0 = (kC336 + kG336) - kF336;
    tmp3_1 = ((((kA336 + kC336) - kE336) - kE336) - kD336);
    tmp3_2 = kB336 - kG336;
    // Op 337: dim3x3 add
    gl64_t s1_337_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_337_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_337_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_337_0; tmp3_7 = tmp3_7 + s1_337_1; tmp3_8 = tmp3_8 + s1_337_2;
    // Op 338: dim3x1 mul
    gl64_t s1_338 = *(gl64_t*)&expressions_params[9][2];
    tmp3_6 = tmp3_6 * s1_338; tmp3_7 = tmp3_7 * s1_338; tmp3_8 = tmp3_8 * s1_338;
    // Op 339: dim3x3 add
    gl64_t s1_339_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_339_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_339_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_339_0; tmp3_10 = tmp3_10 + s1_339_1; tmp3_11 = tmp3_11 + s1_339_2;
    // Op 340: dim3x1 mul
    gl64_t s1_340 = *(gl64_t*)&expressions_params[9][2];
    tmp3_9 = tmp3_9 * s1_340; tmp3_10 = tmp3_10 * s1_340; tmp3_11 = tmp3_11 * s1_340;
    // Op 341: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 342: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 343: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 344: dim3x3 mul
    gl64_t s1_344_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_344_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_344_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA344 = (tmp3_0 + tmp3_1) * (s1_344_0 + s1_344_1);
    gl64_t kB344 = (tmp3_0 + tmp3_2) * (s1_344_0 + s1_344_2);
    gl64_t kC344 = (tmp3_1 + tmp3_2) * (s1_344_1 + s1_344_2);
    gl64_t kD344 = tmp3_0 * s1_344_0;
    gl64_t kE344 = tmp3_1 * s1_344_1;
    gl64_t kF344 = tmp3_2 * s1_344_2;
    gl64_t kG344 = kD344 - kE344;
    tmp3_3 = (kC344 + kG344) - kF344;
    tmp3_4 = ((((kA344 + kC344) - kE344) - kE344) - kD344);
    tmp3_5 = kB344 - kG344;
    // Op 345: dim3x1 mul
    gl64_t s0_345_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_345_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_345_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_345 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp3_0 = s0_345_0 * s1_345; tmp3_1 = s0_345_1 * s1_345; tmp3_2 = s0_345_2 * s1_345;
    // Op 346: dim3x1 add
    gl64_t s1_346 = *(gl64_t*)&expressions_params[9][1];
    tmp3_9 = tmp3_0 + s1_346; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 347: dim3x3 add
    gl64_t s1_347_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_347_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_347_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_347_0; tmp3_13 = tmp3_10 + s1_347_1; tmp3_14 = tmp3_11 + s1_347_2;
    // Op 348: dim3x1 mul
    gl64_t s0_348_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_348_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_348_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_348 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp3_0 = s0_348_0 * s1_348; tmp3_1 = s0_348_1 * s1_348; tmp3_2 = s0_348_2 * s1_348;
    // Op 349: dim3x1 add
    gl64_t s1_349 = *(gl64_t*)&expressions_params[9][1];
    tmp3_6 = tmp3_0 + s1_349; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 350: dim3x3 add
    gl64_t s1_350_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_350_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_350_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_350_0; tmp3_1 = tmp3_7 + s1_350_1; tmp3_2 = tmp3_8 + s1_350_2;
    // Op 351: dim3x3 mul
    gl64_t kA351 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB351 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC351 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD351 = tmp3_12 * tmp3_0;
    gl64_t kE351 = tmp3_13 * tmp3_1;
    gl64_t kF351 = tmp3_14 * tmp3_2;
    gl64_t kG351 = kD351 - kE351;
    tmp3_0 = (kC351 + kG351) - kF351;
    tmp3_1 = ((((kA351 + kC351) - kE351) - kE351) - kD351);
    tmp3_2 = kB351 - kG351;
    // Op 352: dim3x3 mul
    gl64_t s0_352_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_352_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_352_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA352 = (s0_352_0 + s0_352_1) * (tmp3_0 + tmp3_1);
    gl64_t kB352 = (s0_352_0 + s0_352_2) * (tmp3_0 + tmp3_2);
    gl64_t kC352 = (s0_352_1 + s0_352_2) * (tmp3_1 + tmp3_2);
    gl64_t kD352 = s0_352_0 * tmp3_0;
    gl64_t kE352 = s0_352_1 * tmp3_1;
    gl64_t kF352 = s0_352_2 * tmp3_2;
    gl64_t kG352 = kD352 - kE352;
    tmp3_0 = (kC352 + kG352) - kF352;
    tmp3_1 = ((((kA352 + kC352) - kE352) - kE352) - kD352);
    tmp3_2 = kB352 - kG352;
    // Op 353: dim3x3 add
    gl64_t s1_353_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_353_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_353_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_353_0; tmp3_7 = tmp3_7 + s1_353_1; tmp3_8 = tmp3_8 + s1_353_2;
    // Op 354: dim3x1 mul
    gl64_t s1_354 = *(gl64_t*)&expressions_params[9][2];
    tmp3_6 = tmp3_6 * s1_354; tmp3_7 = tmp3_7 * s1_354; tmp3_8 = tmp3_8 * s1_354;
    // Op 355: dim3x3 add
    gl64_t s1_355_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_355_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_355_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_355_0; tmp3_10 = tmp3_10 + s1_355_1; tmp3_11 = tmp3_11 + s1_355_2;
    // Op 356: dim3x1 mul
    gl64_t s1_356 = *(gl64_t*)&expressions_params[9][2];
    tmp3_9 = tmp3_9 * s1_356; tmp3_10 = tmp3_10 * s1_356; tmp3_11 = tmp3_11 * s1_356;
    // Op 357: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 358: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 359: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 360: dim3x3 mul
    gl64_t s1_360_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_360_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_360_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA360 = (tmp3_0 + tmp3_1) * (s1_360_0 + s1_360_1);
    gl64_t kB360 = (tmp3_0 + tmp3_2) * (s1_360_0 + s1_360_2);
    gl64_t kC360 = (tmp3_1 + tmp3_2) * (s1_360_1 + s1_360_2);
    gl64_t kD360 = tmp3_0 * s1_360_0;
    gl64_t kE360 = tmp3_1 * s1_360_1;
    gl64_t kF360 = tmp3_2 * s1_360_2;
    gl64_t kG360 = kD360 - kE360;
    tmp3_12 = (kC360 + kG360) - kF360;
    tmp3_13 = ((((kA360 + kC360) - kE360) - kE360) - kD360);
    tmp3_14 = kB360 - kG360;
    // Op 361: dim3x1 mul
    gl64_t s0_361_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_361_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_361_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_361 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp3_0 = s0_361_0 * s1_361; tmp3_1 = s0_361_1 * s1_361; tmp3_2 = s0_361_2 * s1_361;
    // Op 362: dim3x1 add
    gl64_t s1_362 = *(gl64_t*)&expressions_params[9][1];
    tmp3_9 = tmp3_0 + s1_362; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 363: dim3x3 add
    gl64_t s1_363_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_363_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_363_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_363_0; tmp3_4 = tmp3_10 + s1_363_1; tmp3_5 = tmp3_11 + s1_363_2;
    // Op 364: dim3x1 mul
    gl64_t s0_364_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_364_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_364_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_364 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp3_0 = s0_364_0 * s1_364; tmp3_1 = s0_364_1 * s1_364; tmp3_2 = s0_364_2 * s1_364;
    // Op 365: dim3x1 add
    gl64_t s1_365 = *(gl64_t*)&expressions_params[9][1];
    tmp3_6 = tmp3_0 + s1_365; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 366: dim3x3 add
    gl64_t s1_366_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_366_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_366_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_366_0; tmp3_1 = tmp3_7 + s1_366_1; tmp3_2 = tmp3_8 + s1_366_2;
    // Op 367: dim3x3 mul
    gl64_t kA367 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB367 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC367 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD367 = tmp3_3 * tmp3_0;
    gl64_t kE367 = tmp3_4 * tmp3_1;
    gl64_t kF367 = tmp3_5 * tmp3_2;
    gl64_t kG367 = kD367 - kE367;
    tmp3_0 = (kC367 + kG367) - kF367;
    tmp3_1 = ((((kA367 + kC367) - kE367) - kE367) - kD367);
    tmp3_2 = kB367 - kG367;
    // Op 368: dim3x3 mul
    uint64_t s0_368_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_368_0 = *(gl64_t*)&dParams->aux_trace[s0_368_pos];
    gl64_t s0_368_1 = *(gl64_t*)&dParams->aux_trace[s0_368_pos + TILE_HEIGHT];
    gl64_t s0_368_2 = *(gl64_t*)&dParams->aux_trace[s0_368_pos + 2*TILE_HEIGHT];
    gl64_t kA368 = (s0_368_0 + s0_368_1) * (tmp3_0 + tmp3_1);
    gl64_t kB368 = (s0_368_0 + s0_368_2) * (tmp3_0 + tmp3_2);
    gl64_t kC368 = (s0_368_1 + s0_368_2) * (tmp3_1 + tmp3_2);
    gl64_t kD368 = s0_368_0 * tmp3_0;
    gl64_t kE368 = s0_368_1 * tmp3_1;
    gl64_t kF368 = s0_368_2 * tmp3_2;
    gl64_t kG368 = kD368 - kE368;
    tmp3_0 = (kC368 + kG368) - kF368;
    tmp3_1 = ((((kA368 + kC368) - kE368) - kE368) - kD368);
    tmp3_2 = kB368 - kG368;
    // Op 369: dim3x3 add
    gl64_t s1_369_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_369_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_369_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_369_0; tmp3_7 = tmp3_7 + s1_369_1; tmp3_8 = tmp3_8 + s1_369_2;
    // Op 370: dim3x1 mul
    gl64_t s1_370 = *(gl64_t*)&expressions_params[9][2];
    tmp3_6 = tmp3_6 * s1_370; tmp3_7 = tmp3_7 * s1_370; tmp3_8 = tmp3_8 * s1_370;
    // Op 371: dim3x3 add
    gl64_t s1_371_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_371_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_371_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_371_0; tmp3_10 = tmp3_10 + s1_371_1; tmp3_11 = tmp3_11 + s1_371_2;
    // Op 372: dim3x1 mul
    gl64_t s1_372 = *(gl64_t*)&expressions_params[9][2];
    tmp3_9 = tmp3_9 * s1_372; tmp3_10 = tmp3_10 * s1_372; tmp3_11 = tmp3_11 * s1_372;
    // Op 373: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 374: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 375: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
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
    tmp3_3 = (kC376 + kG376) - kF376;
    tmp3_4 = ((((kA376 + kC376) - kE376) - kE376) - kD376);
    tmp3_5 = kB376 - kG376;
    // Op 377: dim3x1 mul
    gl64_t s0_377_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_377_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_377_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_377 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp3_0 = s0_377_0 * s1_377; tmp3_1 = s0_377_1 * s1_377; tmp3_2 = s0_377_2 * s1_377;
    // Op 378: dim3x1 add
    gl64_t s1_378 = *(gl64_t*)&expressions_params[9][1];
    tmp3_9 = tmp3_0 + s1_378; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 379: dim3x3 add
    gl64_t s1_379_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_379_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_379_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_379_0; tmp3_13 = tmp3_10 + s1_379_1; tmp3_14 = tmp3_11 + s1_379_2;
    // Op 380: dim1x1 mul
    gl64_t s0_380 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_1))];
    gl64_t s1_380 = *(gl64_t*)&expressions_params[9][3];
    tmp1_0 = s0_380 * s1_380;
    // Op 381: dim1x1 add
    gl64_t s0_381 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_1))];
    tmp1_0 = s0_381 + tmp1_0;
    // Op 382: dim1x1 mul
    gl64_t s0_382 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    gl64_t s1_382 = *(gl64_t*)&expressions_params[9][4];
    tmp1_1 = s0_382 * s1_382;
    // Op 383: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 384: dim1x1 mul
    gl64_t s0_384 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_384 = *(gl64_t*)&expressions_params[9][5];
    tmp1_1 = s0_384 * s1_384;
    // Op 385: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 386: dim1x1 mul
    gl64_t s0_386 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_386 = *(gl64_t*)&expressions_params[9][6];
    tmp1_1 = s0_386 * s1_386;
    // Op 387: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 388: dim1x1 mul
    gl64_t s0_388 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    gl64_t s1_388 = *(gl64_t*)&expressions_params[9][7];
    tmp1_1 = s0_388 * s1_388;
    // Op 389: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 390: dim1x1 mul
    gl64_t s0_390 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_390 = *(gl64_t*)&expressions_params[9][8];
    tmp1_1 = s0_390 * s1_390;
    // Op 391: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 392: dim1x1 mul
    gl64_t s0_392 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_392 = *(gl64_t*)&expressions_params[9][9];
    tmp1_1 = s0_392 * s1_392;
    // Op 393: dim1x1 add
    tmp1_2 = tmp1_0 + tmp1_1;
    // Op 394: dim1x1 mul
    gl64_t s0_394 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_394 = *(gl64_t*)&expressions_params[9][10];
    tmp1_0 = s0_394 * s1_394;
    // Op 395: dim1x1 mul
    gl64_t s0_395 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_395 = *(gl64_t*)&expressions_params[9][11];
    tmp1_1 = s0_395 * s1_395;
    // Op 396: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 397: dim1x1 mul
    gl64_t s0_397 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_397 = *(gl64_t*)&expressions_params[9][12];
    tmp1_1 = s0_397 * s1_397;
    // Op 398: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 399: dim1x1 mul
    gl64_t s0_399 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    gl64_t s1_399 = *(gl64_t*)&expressions_params[9][13];
    tmp1_1 = s0_399 * s1_399;
    // Op 400: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 401: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 402: dim3x1 mul
    gl64_t s0_402_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_402_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_402_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_402_0 * tmp1_0; tmp3_1 = s0_402_1 * tmp1_0; tmp3_2 = s0_402_2 * tmp1_0;
    // Op 403: dim3x1 add
    gl64_t s1_403 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_403; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 405: dim3x1 add
    gl64_t s1_405 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_405; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 406: dim3x3 mul
    gl64_t s1_406_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_406_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_406_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA406 = (tmp3_0 + tmp3_1) * (s1_406_0 + s1_406_1);
    gl64_t kB406 = (tmp3_0 + tmp3_2) * (s1_406_0 + s1_406_2);
    gl64_t kC406 = (tmp3_1 + tmp3_2) * (s1_406_1 + s1_406_2);
    gl64_t kD406 = tmp3_0 * s1_406_0;
    gl64_t kE406 = tmp3_1 * s1_406_1;
    gl64_t kF406 = tmp3_2 * s1_406_2;
    gl64_t kG406 = kD406 - kE406;
    tmp3_0 = (kC406 + kG406) - kF406;
    tmp3_1 = ((((kA406 + kC406) - kE406) - kE406) - kD406);
    tmp3_2 = kB406 - kG406;
    // Op 407: dim3x1 add
    gl64_t s1_407 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_407; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 408: dim3x3 mul
    gl64_t s1_408_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_408_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_408_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA408 = (tmp3_0 + tmp3_1) * (s1_408_0 + s1_408_1);
    gl64_t kB408 = (tmp3_0 + tmp3_2) * (s1_408_0 + s1_408_2);
    gl64_t kC408 = (tmp3_1 + tmp3_2) * (s1_408_1 + s1_408_2);
    gl64_t kD408 = tmp3_0 * s1_408_0;
    gl64_t kE408 = tmp3_1 * s1_408_1;
    gl64_t kF408 = tmp3_2 * s1_408_2;
    gl64_t kG408 = kD408 - kE408;
    tmp3_0 = (kC408 + kG408) - kF408;
    tmp3_1 = ((((kA408 + kC408) - kE408) - kE408) - kD408);
    tmp3_2 = kB408 - kG408;
    // Op 409: dim1x1 sub
    gl64_t s0_409 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    gl64_t s1_409 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp1_0 = s0_409 - s1_409;
    // Op 410: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 411: dim3x3 mul
    gl64_t s1_411_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_411_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_411_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 412: dim3x1 add
    gl64_t s1_412 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_412; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 413: dim3x3 mul
    gl64_t s1_413_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_413_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_413_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA413 = (tmp3_0 + tmp3_1) * (s1_413_0 + s1_413_1);
    gl64_t kB413 = (tmp3_0 + tmp3_2) * (s1_413_0 + s1_413_2);
    gl64_t kC413 = (tmp3_1 + tmp3_2) * (s1_413_1 + s1_413_2);
    gl64_t kD413 = tmp3_0 * s1_413_0;
    gl64_t kE413 = tmp3_1 * s1_413_1;
    gl64_t kF413 = tmp3_2 * s1_413_2;
    gl64_t kG413 = kD413 - kE413;
    tmp3_0 = (kC413 + kG413) - kF413;
    tmp3_1 = ((((kA413 + kC413) - kE413) - kE413) - kD413);
    tmp3_2 = kB413 - kG413;
    // Op 414: dim3x1 add
    gl64_t s1_414 = *(gl64_t*)&expressions_params[9][14];
    tmp3_6 = tmp3_0 + s1_414; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 415: dim3x3 add
    gl64_t s1_415_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_415_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_415_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_415_0; tmp3_1 = tmp3_7 + s1_415_1; tmp3_2 = tmp3_8 + s1_415_2;
    // Op 416: dim3x3 mul
    gl64_t kA416 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB416 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC416 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD416 = tmp3_12 * tmp3_0;
    gl64_t kE416 = tmp3_13 * tmp3_1;
    gl64_t kF416 = tmp3_14 * tmp3_2;
    gl64_t kG416 = kD416 - kE416;
    tmp3_0 = (kC416 + kG416) - kF416;
    tmp3_1 = ((((kA416 + kC416) - kE416) - kE416) - kD416);
    tmp3_2 = kB416 - kG416;
    // Op 417: dim3x3 mul
    uint64_t s0_417_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_417_0 = *(gl64_t*)&dParams->aux_trace[s0_417_pos];
    gl64_t s0_417_1 = *(gl64_t*)&dParams->aux_trace[s0_417_pos + TILE_HEIGHT];
    gl64_t s0_417_2 = *(gl64_t*)&dParams->aux_trace[s0_417_pos + 2*TILE_HEIGHT];
    gl64_t kA417 = (s0_417_0 + s0_417_1) * (tmp3_0 + tmp3_1);
    gl64_t kB417 = (s0_417_0 + s0_417_2) * (tmp3_0 + tmp3_2);
    gl64_t kC417 = (s0_417_1 + s0_417_2) * (tmp3_1 + tmp3_2);
    gl64_t kD417 = s0_417_0 * tmp3_0;
    gl64_t kE417 = s0_417_1 * tmp3_1;
    gl64_t kF417 = s0_417_2 * tmp3_2;
    gl64_t kG417 = kD417 - kE417;
    tmp3_0 = (kC417 + kG417) - kF417;
    tmp3_1 = ((((kA417 + kC417) - kE417) - kE417) - kD417);
    tmp3_2 = kB417 - kG417;
    // Op 418: dim3x3 add
    gl64_t s1_418_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_418_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_418_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_418_0; tmp3_7 = tmp3_7 + s1_418_1; tmp3_8 = tmp3_8 + s1_418_2;
    // Op 419: dim3x1 mul
    gl64_t s1_419 = *(gl64_t*)&expressions_params[9][2];
    tmp3_6 = tmp3_6 * s1_419; tmp3_7 = tmp3_7 * s1_419; tmp3_8 = tmp3_8 * s1_419;
    // Op 420: dim3x3 add
    gl64_t s1_420_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_420_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_420_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_420_0; tmp3_10 = tmp3_10 + s1_420_1; tmp3_11 = tmp3_11 + s1_420_2;
    // Op 421: dim3x1 mul
    gl64_t s1_421 = *(gl64_t*)&expressions_params[9][2];
    tmp3_9 = tmp3_9 * s1_421; tmp3_10 = tmp3_10 * s1_421; tmp3_11 = tmp3_11 * s1_421;
    // Op 422: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 423: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 424: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 425: dim3x3 mul
    gl64_t s1_425_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_425_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_425_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA425 = (tmp3_0 + tmp3_1) * (s1_425_0 + s1_425_1);
    gl64_t kB425 = (tmp3_0 + tmp3_2) * (s1_425_0 + s1_425_2);
    gl64_t kC425 = (tmp3_1 + tmp3_2) * (s1_425_1 + s1_425_2);
    gl64_t kD425 = tmp3_0 * s1_425_0;
    gl64_t kE425 = tmp3_1 * s1_425_1;
    gl64_t kF425 = tmp3_2 * s1_425_2;
    gl64_t kG425 = kD425 - kE425;
    tmp3_3 = (kC425 + kG425) - kF425;
    tmp3_4 = ((((kA425 + kC425) - kE425) - kE425) - kD425);
    tmp3_5 = kB425 - kG425;
    // Op 426: dim3x1 mul
    gl64_t s0_426_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_426_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_426_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_426 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_1))];
    tmp3_0 = s0_426_0 * s1_426; tmp3_1 = s0_426_1 * s1_426; tmp3_2 = s0_426_2 * s1_426;
    // Op 427: dim3x1 add
    gl64_t s1_427 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_1))];
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
    gl64_t s1_429 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
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
    // Op 431: dim3x1 add
    gl64_t s1_431 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_431; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 432: dim3x3 mul
    gl64_t s1_432_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_432_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_432_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA432 = (tmp3_0 + tmp3_1) * (s1_432_0 + s1_432_1);
    gl64_t kB432 = (tmp3_0 + tmp3_2) * (s1_432_0 + s1_432_2);
    gl64_t kC432 = (tmp3_1 + tmp3_2) * (s1_432_1 + s1_432_2);
    gl64_t kD432 = tmp3_0 * s1_432_0;
    gl64_t kE432 = tmp3_1 * s1_432_1;
    gl64_t kF432 = tmp3_2 * s1_432_2;
    gl64_t kG432 = kD432 - kE432;
    tmp3_0 = (kC432 + kG432) - kF432;
    tmp3_1 = ((((kA432 + kC432) - kE432) - kE432) - kD432);
    tmp3_2 = kB432 - kG432;
    // Op 433: dim1x1 mul
    gl64_t s0_433 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    gl64_t s1_433 = *(gl64_t*)&expressions_params[9][5];
    tmp1_0 = s0_433 * s1_433;
    // Op 434: dim1x1 add
    gl64_t s0_434 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp1_0 = s0_434 + tmp1_0;
    // Op 435: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 437: dim1x1 add
    gl64_t s0_437 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    gl64_t s1_437 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s0_437 + s1_437;
    // Op 438: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_440 = *(gl64_t*)&expressions_params[9][15];
    tmp3_0 = tmp3_0 + s1_440; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 441: dim3x3 add
    gl64_t s1_441_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_441_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_441_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_441_0; tmp3_1 = tmp3_1 + s1_441_1; tmp3_2 = tmp3_2 + s1_441_2;
    // Op 442: dim3x3 mul
    gl64_t s0_442_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_442_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_442_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    gl64_t kA442 = (s0_442_0 + s0_442_1) * (tmp3_0 + tmp3_1);
    gl64_t kB442 = (s0_442_0 + s0_442_2) * (tmp3_0 + tmp3_2);
    gl64_t kC442 = (s0_442_1 + s0_442_2) * (tmp3_1 + tmp3_2);
    gl64_t kD442 = s0_442_0 * tmp3_0;
    gl64_t kE442 = s0_442_1 * tmp3_1;
    gl64_t kF442 = s0_442_2 * tmp3_2;
    gl64_t kG442 = kD442 - kE442;
    tmp3_0 = (kC442 + kG442) - kF442;
    tmp3_1 = ((((kA442 + kC442) - kE442) - kE442) - kD442);
    tmp3_2 = kB442 - kG442;
    // Op 443: dim1x1 sub
    gl64_t s0_443 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    tmp1_3 = s0_443 - tmp1_3;
    // Op 444: dim3x1 sub
    tmp3_0 = tmp3_0 - tmp1_3; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 445: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
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
    tmp3_6 = (kC446 + kG446) - kF446;
    tmp3_7 = ((((kA446 + kC446) - kE446) - kE446) - kD446);
    tmp3_8 = kB446 - kG446;
    // Op 447: dim1x1 sub_swap
    gl64_t s0_447 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_0)];
    gl64_t s1_447 = *(gl64_t*)&expressions_params[9][0];
    tmp1_3 = s1_447 - s0_447;
    // Op 448: dim3x1 mul
    uint64_t s0_448_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_448_0 = *(gl64_t*)&dParams->aux_trace[s0_448_pos];
    gl64_t s0_448_1 = *(gl64_t*)&dParams->aux_trace[s0_448_pos + TILE_HEIGHT];
    gl64_t s0_448_2 = *(gl64_t*)&dParams->aux_trace[s0_448_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_448_0 * tmp1_3; tmp3_1 = s0_448_1 * tmp1_3; tmp3_2 = s0_448_2 * tmp1_3;
    // Op 449: dim3x3 sub
    uint64_t s0_449_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_449_0 = *(gl64_t*)&dParams->aux_trace[s0_449_pos];
    gl64_t s0_449_1 = *(gl64_t*)&dParams->aux_trace[s0_449_pos + TILE_HEIGHT];
    gl64_t s0_449_2 = *(gl64_t*)&dParams->aux_trace[s0_449_pos + 2*TILE_HEIGHT];
    tmp3_3 = s0_449_0 - tmp3_0; tmp3_4 = s0_449_1 - tmp3_1; tmp3_5 = s0_449_2 - tmp3_2;
    // Op 450: dim3x3 add
    gl64_t s0_450_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_450_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_450_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_450_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_450_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_450_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_0 = s0_450_0 + s1_450_0; tmp3_1 = s0_450_1 + s1_450_1; tmp3_2 = s0_450_2 + s1_450_2;
    // Op 451: dim3x3 add
    uint64_t s0_451_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_451_0 = *(gl64_t*)&dParams->aux_trace[s0_451_pos];
    gl64_t s0_451_1 = *(gl64_t*)&dParams->aux_trace[s0_451_pos + TILE_HEIGHT];
    gl64_t s0_451_2 = *(gl64_t*)&dParams->aux_trace[s0_451_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_451_0 + tmp3_0; tmp3_1 = s0_451_1 + tmp3_1; tmp3_2 = s0_451_2 + tmp3_2;
    // Op 452: dim3x3 add
    uint64_t s0_452_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_452_0 = *(gl64_t*)&dParams->aux_trace[s0_452_pos];
    gl64_t s0_452_1 = *(gl64_t*)&dParams->aux_trace[s0_452_pos + TILE_HEIGHT];
    gl64_t s0_452_2 = *(gl64_t*)&dParams->aux_trace[s0_452_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_452_0 + tmp3_0; tmp3_1 = s0_452_1 + tmp3_1; tmp3_2 = s0_452_2 + tmp3_2;
    // Op 453: dim3x3 add
    gl64_t s0_453_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+0, domainSize, nCols_2))];
    gl64_t s0_453_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+1, domainSize, nCols_2))];
    gl64_t s0_453_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 15+2, domainSize, nCols_2))];
    tmp3_0 = s0_453_0 + tmp3_0; tmp3_1 = s0_453_1 + tmp3_1; tmp3_2 = s0_453_2 + tmp3_2;
    // Op 454: dim3x3 sub
    tmp3_3 = tmp3_3 - tmp3_0; tmp3_4 = tmp3_4 - tmp3_1; tmp3_5 = tmp3_5 - tmp3_2;
    // Op 455: dim3x1 mul
    gl64_t s0_455_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_455_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_455_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_455 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp3_0 = s0_455_0 * s1_455; tmp3_1 = s0_455_1 * s1_455; tmp3_2 = s0_455_2 * s1_455;
    // Op 456: dim3x1 add
    gl64_t s1_456 = *(gl64_t*)&expressions_params[9][1];
    tmp3_0 = tmp3_0 + s1_456; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 457: dim3x3 add
    gl64_t s1_457_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_457_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_457_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_457_0; tmp3_1 = tmp3_1 + s1_457_1; tmp3_2 = tmp3_2 + s1_457_2;
    // Op 458: dim3x3 mul
    gl64_t kA458 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB458 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC458 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD458 = tmp3_3 * tmp3_0;
    gl64_t kE458 = tmp3_4 * tmp3_1;
    gl64_t kF458 = tmp3_5 * tmp3_2;
    gl64_t kG458 = kD458 - kE458;
    tmp3_0 = (kC458 + kG458) - kF458;
    tmp3_1 = ((((kA458 + kC458) - kE458) - kE458) - kD458);
    tmp3_2 = kB458 - kG458;
    // Op 459: dim3x1 add
    gl64_t s1_459 = *(gl64_t*)&expressions_params[9][0];
    tmp3_0 = tmp3_0 + s1_459; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 460: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 461: dim3x3 mul
    gl64_t s1_461_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_461_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_461_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA461 = (tmp3_0 + tmp3_1) * (s1_461_0 + s1_461_1);
    gl64_t kB461 = (tmp3_0 + tmp3_2) * (s1_461_0 + s1_461_2);
    gl64_t kC461 = (tmp3_1 + tmp3_2) * (s1_461_1 + s1_461_2);
    gl64_t kD461 = tmp3_0 * s1_461_0;
    gl64_t kE461 = tmp3_1 * s1_461_1;
    gl64_t kF461 = tmp3_2 * s1_461_2;
    gl64_t kG461 = kD461 - kE461;
    tmp3_6 = (kC461 + kG461) - kF461;
    tmp3_7 = ((((kA461 + kC461) - kE461) - kE461) - kD461);
    tmp3_8 = kB461 - kG461;
    // Op 462: dim3x3 sub_swap
    uint64_t s0_462_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_462_0 = *(gl64_t*)&dParams->aux_trace[s0_462_pos];
    gl64_t s0_462_1 = *(gl64_t*)&dParams->aux_trace[s0_462_pos + TILE_HEIGHT];
    gl64_t s0_462_2 = *(gl64_t*)&dParams->aux_trace[s0_462_pos + 2*TILE_HEIGHT];
    gl64_t s1_462_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_462_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_462_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_0 = s1_462_0 - s0_462_0; tmp3_1 = s1_462_1 - s0_462_1; tmp3_2 = s1_462_2 - s0_462_2;
    // Op 463: dim3x1 mul
    gl64_t s1_463 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_463; tmp3_1 = tmp3_1 * s1_463; tmp3_2 = tmp3_2 * s1_463;
    // Op 464: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 465: dim3x3 mul
    gl64_t s1_465_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_465_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_465_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 466: dim1x1 mul
    gl64_t s0_466 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_466 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp1_3 = s0_466 * s1_466;
    // Op 467: dim1x1 sub
    gl64_t s0_467 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_2))];
    tmp1_3 = s0_467 - tmp1_3;
    // Op 468: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_3; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 469: dim3x3 mul
    gl64_t s1_469_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_469_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_469_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 470: dim1x1 mul
    gl64_t s0_470 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    gl64_t s1_470 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp1_3 = s0_470 * s1_470;
    // Op 471: dim1x1 sub_swap
    gl64_t s0_471 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    gl64_t s1_471 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_471 - s0_471;
    // Op 472: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 473: dim1x1 sub
    gl64_t s0_473 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_2))];
    tmp1_0 = s0_473 - tmp1_0;
    // Op 474: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC475 + kG475) - kF475;
    tmp3_1 = ((((kA475 + kC475) - kE475) - kE475) - kD475);
    tmp3_2 = kB475 - kG475;
    // Op 476: dim1x1 mul
    gl64_t s0_476 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_1))];
    gl64_t s1_476 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    tmp1_0 = s0_476 * s1_476;
    // Op 477: dim1x1 sub
    gl64_t s0_477 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_2))];
    tmp1_0 = s0_477 - tmp1_0;
    // Op 478: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 479: dim3x3 mul
    gl64_t s1_479_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_479_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_479_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 480: dim1x1 sub_swap
    gl64_t s0_480 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 16, domainSize, nCols_1))];
    gl64_t s1_480 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_480 - s0_480;
    // Op 481: dim1x1 mul
    gl64_t s0_481 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    gl64_t s1_481 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_3 = s0_481 * s1_481;
    // Op 482: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_3;
    // Op 483: dim1x1 mul
    gl64_t s0_483 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_1))];
    tmp1_2 = s0_483 * tmp1_0;
    // Op 484: dim1x1 sub_swap
    gl64_t s0_484 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 17, domainSize, nCols_1))];
    gl64_t s1_484 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_484 - s0_484;
    // Op 485: dim1x1 mul
    gl64_t s0_485 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    gl64_t s1_485 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_3 = s0_485 * s1_485;
    // Op 486: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_3;
    // Op 487: dim1x1 mul
    gl64_t s0_487 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_1))];
    tmp1_0 = s0_487 * tmp1_0;
    // Op 488: dim1x1 add
    tmp1_3 = tmp1_2 + tmp1_0;
    // Op 489: dim1x1 sub_swap
    gl64_t s0_489 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 18, domainSize, nCols_1))];
    gl64_t s1_489 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_489 - s0_489;
    // Op 490: dim1x1 mul
    gl64_t s0_490 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    gl64_t s1_490 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 18, domainSize, nCols_1))];
    tmp1_2 = s0_490 * s1_490;
    // Op 491: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_2;
    // Op 492: dim1x1 mul
    gl64_t s0_492 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_1))];
    tmp1_0 = s0_492 * tmp1_0;
    // Op 493: dim1x1 add
    tmp1_2 = tmp1_3 + tmp1_0;
    // Op 494: dim1x1 sub_swap
    gl64_t s0_494 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 19, domainSize, nCols_1))];
    gl64_t s1_494 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_494 - s0_494;
    // Op 495: dim1x1 mul
    gl64_t s0_495 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    gl64_t s1_495 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 19, domainSize, nCols_1))];
    tmp1_3 = s0_495 * s1_495;
    // Op 496: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_3;
    // Op 497: dim1x1 mul
    gl64_t s0_497 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_1))];
    tmp1_0 = s0_497 * tmp1_0;
    // Op 498: dim1x1 add
    tmp1_3 = tmp1_2 + tmp1_0;
    // Op 499: dim1x1 sub_swap
    gl64_t s0_499 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 20, domainSize, nCols_1))];
    gl64_t s1_499 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_499 - s0_499;
    // Op 500: dim1x1 mul
    gl64_t s0_500 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    gl64_t s1_500 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 20, domainSize, nCols_1))];
    tmp1_2 = s0_500 * s1_500;
    // Op 501: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_2;
    // Op 502: dim1x1 mul
    gl64_t s0_502 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_1))];
    tmp1_0 = s0_502 * tmp1_0;
    // Op 503: dim1x1 add
    tmp1_2 = tmp1_3 + tmp1_0;
    // Op 504: dim1x1 sub_swap
    gl64_t s0_504 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 21, domainSize, nCols_1))];
    gl64_t s1_504 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_504 - s0_504;
    // Op 505: dim1x1 mul
    gl64_t s0_505 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    gl64_t s1_505 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 21, domainSize, nCols_1))];
    tmp1_3 = s0_505 * s1_505;
    // Op 506: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_3;
    // Op 507: dim1x1 mul
    gl64_t s0_507 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_1))];
    tmp1_0 = s0_507 * tmp1_0;
    // Op 508: dim1x1 add
    tmp1_3 = tmp1_2 + tmp1_0;
    // Op 509: dim1x1 sub_swap
    gl64_t s0_509 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 22, domainSize, nCols_1))];
    gl64_t s1_509 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_509 - s0_509;
    // Op 510: dim1x1 mul
    gl64_t s0_510 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    gl64_t s1_510 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 22, domainSize, nCols_1))];
    tmp1_2 = s0_510 * s1_510;
    // Op 511: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_2;
    // Op 512: dim1x1 mul
    gl64_t s0_512 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_1))];
    tmp1_0 = s0_512 * tmp1_0;
    // Op 513: dim1x1 add
    tmp1_2 = tmp1_3 + tmp1_0;
    // Op 514: dim1x1 sub_swap
    gl64_t s0_514 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_0, 23, domainSize, nCols_1))];
    gl64_t s1_514 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_514 - s0_514;
    // Op 515: dim1x1 mul
    gl64_t s0_515 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    gl64_t s1_515 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 23, domainSize, nCols_1))];
    tmp1_3 = s0_515 * s1_515;
    // Op 516: dim1x1 sub
    tmp1_0 = tmp1_0 - tmp1_3;
    // Op 517: dim1x1 mul
    gl64_t s0_517 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_1))];
    tmp1_0 = s0_517 * tmp1_0;
    // Op 518: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 519: dim1x1 sub
    gl64_t s0_519 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_2))];
    tmp1_0 = s0_519 - tmp1_0;
    // Op 520: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 521: dim3x1 mul
    gl64_t s1_521 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_521; tmp3_1 = tmp3_1 * s1_521; tmp3_2 = tmp3_2 * s1_521;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
