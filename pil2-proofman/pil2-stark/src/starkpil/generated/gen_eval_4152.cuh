// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: 1dd4910a  nOps=3827 nTemp1=55 nTemp3=5
#define GENERATED_EVAL_NOPS_1dd4910a 3827
#define GENERATED_EVAL_NTEMP1_1dd4910a 55
#define GENERATED_EVAL_NTEMP3_1dd4910a 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_1dd4910a(
    const StepsParams* __restrict__ dParams,
    const DeviceArguments* __restrict__ dArgs,
    const ExpsArguments* __restrict__ dExpsArgs,
    Goldilocks::Element **expressions_params,
    uint32_t bufferCommitsSize, uint64_t row)
{
    const uint64_t domainSize = dExpsArgs->domainSize;
    const uint64_t r = row + threadIdx.x;
    const uint64_t chunkBase = row;

    // stride[0] = -8
    const int64_t stride_0 = dExpsArgs->nextStridesExps[0];
    uint64_t logicalRow_0;
    // stride[1] = -16
    const int64_t stride_1 = dExpsArgs->nextStridesExps[1];
    uint64_t logicalRow_1;
    // stride[2] = 0
    const int64_t stride_2 = dExpsArgs->nextStridesExps[2];
    uint64_t logicalRow_2;
    // stride[3] = 8
    const int64_t stride_3 = dExpsArgs->nextStridesExps[3];
    uint64_t logicalRow_3;
    if constexpr (IsCyclic) {
        logicalRow_0 = (r + stride_0) % domainSize;
        logicalRow_1 = (r + stride_1) % domainSize;
        logicalRow_2 = (r + stride_2) % domainSize;
        logicalRow_3 = (r + stride_3) % domainSize;
    } else {
        logicalRow_0 = r + stride_0;
        logicalRow_1 = r + stride_1;
        logicalRow_2 = r + stride_2;
        logicalRow_3 = r + stride_3;
    }

    const bool usePack256_0 = false; // stride=-8 != 0
    const bool usePack256_1 = false; // stride=-16 != 0
    const bool usePack256_2 = !IsCyclic && blockDim.x == TILE_HEIGHT;
    const bool usePack256_3 = false; // stride=8 != 0

    const uint64_t nCols_0 = dArgs->mapSectionsN[0];
    const uint64_t nCols_1 = dArgs->mapSectionsN[1];
    const uint64_t nCols_2 = dArgs->mapSectionsN[2];

    // Register-resident temporaries: 55 tmp1 + 15 tmp3 slots
    gl64_t tmp1_0 = gl64_t(uint64_t(0));
    gl64_t tmp1_1 = gl64_t(uint64_t(0));
    gl64_t tmp1_2 = gl64_t(uint64_t(0));
    gl64_t tmp1_3 = gl64_t(uint64_t(0));
    gl64_t tmp1_4 = gl64_t(uint64_t(0));
    gl64_t tmp1_5 = gl64_t(uint64_t(0));
    gl64_t tmp1_6 = gl64_t(uint64_t(0));
    gl64_t tmp1_7 = gl64_t(uint64_t(0));
    gl64_t tmp1_8 = gl64_t(uint64_t(0));
    gl64_t tmp1_9 = gl64_t(uint64_t(0));
    gl64_t tmp1_10 = gl64_t(uint64_t(0));
    gl64_t tmp1_11 = gl64_t(uint64_t(0));
    gl64_t tmp1_12 = gl64_t(uint64_t(0));
    gl64_t tmp1_13 = gl64_t(uint64_t(0));
    gl64_t tmp1_14 = gl64_t(uint64_t(0));
    gl64_t tmp1_15 = gl64_t(uint64_t(0));
    gl64_t tmp1_16 = gl64_t(uint64_t(0));
    gl64_t tmp1_17 = gl64_t(uint64_t(0));
    gl64_t tmp1_18 = gl64_t(uint64_t(0));
    gl64_t tmp1_19 = gl64_t(uint64_t(0));
    gl64_t tmp1_20 = gl64_t(uint64_t(0));
    gl64_t tmp1_21 = gl64_t(uint64_t(0));
    gl64_t tmp1_22 = gl64_t(uint64_t(0));
    gl64_t tmp1_23 = gl64_t(uint64_t(0));
    gl64_t tmp1_24 = gl64_t(uint64_t(0));
    gl64_t tmp1_25 = gl64_t(uint64_t(0));
    gl64_t tmp1_26 = gl64_t(uint64_t(0));
    gl64_t tmp1_27 = gl64_t(uint64_t(0));
    gl64_t tmp1_28 = gl64_t(uint64_t(0));
    gl64_t tmp1_29 = gl64_t(uint64_t(0));
    gl64_t tmp1_30 = gl64_t(uint64_t(0));
    gl64_t tmp1_31 = gl64_t(uint64_t(0));
    gl64_t tmp1_32 = gl64_t(uint64_t(0));
    gl64_t tmp1_33 = gl64_t(uint64_t(0));
    gl64_t tmp1_34 = gl64_t(uint64_t(0));
    gl64_t tmp1_35 = gl64_t(uint64_t(0));
    gl64_t tmp1_36 = gl64_t(uint64_t(0));
    gl64_t tmp1_37 = gl64_t(uint64_t(0));
    gl64_t tmp1_38 = gl64_t(uint64_t(0));
    gl64_t tmp1_39 = gl64_t(uint64_t(0));
    gl64_t tmp1_40 = gl64_t(uint64_t(0));
    gl64_t tmp1_41 = gl64_t(uint64_t(0));
    gl64_t tmp1_42 = gl64_t(uint64_t(0));
    gl64_t tmp1_43 = gl64_t(uint64_t(0));
    gl64_t tmp1_44 = gl64_t(uint64_t(0));
    gl64_t tmp1_45 = gl64_t(uint64_t(0));
    gl64_t tmp1_46 = gl64_t(uint64_t(0));
    gl64_t tmp1_47 = gl64_t(uint64_t(0));
    gl64_t tmp1_48 = gl64_t(uint64_t(0));
    gl64_t tmp1_49 = gl64_t(uint64_t(0));
    gl64_t tmp1_50 = gl64_t(uint64_t(0));
    gl64_t tmp1_51 = gl64_t(uint64_t(0));
    gl64_t tmp1_52 = gl64_t(uint64_t(0));
    gl64_t tmp1_53 = gl64_t(uint64_t(0));
    gl64_t tmp1_54 = gl64_t(uint64_t(0));
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

    // Op 0: dim1x1 add
    gl64_t s0_0 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 46, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 46, domainSize, nCols_0)];
    gl64_t s1_0 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_0 = s0_0 + s1_0;
    // Op 1: dim1x1 add
    gl64_t s0_1 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_0 = s0_1 + tmp1_0;
    // Op 2: dim1x1 add
    gl64_t s0_2 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_3 = s0_2 + tmp1_0;
    // Op 3: dim1x1 mul
    gl64_t s0_3 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_1))];
    gl64_t s1_3 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    tmp1_0 = s0_3 * s1_3;
    // Op 4: dim1x1 mul
    gl64_t s0_4 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 27, domainSize, nCols_0)];
    tmp1_0 = s0_4 * tmp1_0;
    // Op 5: dim1x1 mul
    gl64_t s0_5 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 28, domainSize, nCols_0)];
    gl64_t s1_5 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_1))];
    tmp1_1 = s0_5 * s1_5;
    // Op 6: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 7: dim1x1 mul
    gl64_t s0_7 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 29, domainSize, nCols_0)];
    gl64_t s1_7 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    tmp1_1 = s0_7 * s1_7;
    // Op 8: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 9: dim1x1 mul
    gl64_t s0_9 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 30, domainSize, nCols_0)];
    gl64_t s1_9 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_1))];
    tmp1_1 = s0_9 * s1_9;
    // Op 10: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 11: dim1x1 add
    gl64_t s0_11 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 31, domainSize, nCols_0)];
    tmp1_0 = s0_11 + tmp1_0;
    // Op 12: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 13: dim3x1 mul
    gl64_t s0_13_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s0_13_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s0_13_2 = *(gl64_t*)&expressions_params[13][6+2];
    tmp3_0 = s0_13_0 * tmp1_0; tmp3_1 = s0_13_1 * tmp1_0; tmp3_2 = s0_13_2 * tmp1_0;
    // Op 14: dim1x1 mul
    gl64_t s0_14 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    gl64_t s1_14 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    tmp1_0 = s0_14 * s1_14;
    // Op 15: dim1x1 mul
    gl64_t s0_15 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 27, domainSize, nCols_0)];
    tmp1_0 = s0_15 * tmp1_0;
    // Op 16: dim1x1 mul
    gl64_t s0_16 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 28, domainSize, nCols_0)];
    gl64_t s1_16 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_1 = s0_16 * s1_16;
    // Op 17: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 18: dim1x1 mul
    gl64_t s0_18 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 29, domainSize, nCols_0)];
    gl64_t s1_18 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    tmp1_1 = s0_18 * s1_18;
    // Op 19: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 20: dim1x1 mul
    gl64_t s0_20 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 30, domainSize, nCols_0)];
    gl64_t s1_20 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    tmp1_1 = s0_20 * s1_20;
    // Op 21: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 22: dim1x1 add
    gl64_t s0_22 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 31, domainSize, nCols_0)];
    tmp1_0 = s0_22 + tmp1_0;
    // Op 23: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
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
    // Op 26: dim1x1 mul
    gl64_t s0_26 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 6, domainSize, nCols_1))];
    gl64_t s1_26 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    tmp1_0 = s0_26 * s1_26;
    // Op 27: dim1x1 mul
    gl64_t s0_27 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 32, domainSize, nCols_0)];
    tmp1_0 = s0_27 * tmp1_0;
    // Op 28: dim1x1 mul
    gl64_t s0_28 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_0)];
    gl64_t s1_28 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 6, domainSize, nCols_1))];
    tmp1_1 = s0_28 * s1_28;
    // Op 29: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 30: dim1x1 mul
    gl64_t s0_30 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 34, domainSize, nCols_0)];
    gl64_t s1_30 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    tmp1_1 = s0_30 * s1_30;
    // Op 31: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 32: dim1x1 mul
    gl64_t s0_32 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 35, domainSize, nCols_0)];
    gl64_t s1_32 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 8, domainSize, nCols_1))];
    tmp1_1 = s0_32 * s1_32;
    // Op 33: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 34: dim1x1 add
    gl64_t s0_34 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 36, domainSize, nCols_0)];
    tmp1_0 = s0_34 + tmp1_0;
    // Op 35: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
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
    gl64_t s0_38 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    gl64_t s1_38 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 10, domainSize, nCols_1))];
    tmp1_0 = s0_38 * s1_38;
    // Op 39: dim1x1 mul
    gl64_t s0_39 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 32, domainSize, nCols_0)];
    tmp1_0 = s0_39 * tmp1_0;
    // Op 40: dim1x1 mul
    gl64_t s0_40 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_0)];
    gl64_t s1_40 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    tmp1_1 = s0_40 * s1_40;
    // Op 41: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 42: dim1x1 mul
    gl64_t s0_42 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 34, domainSize, nCols_0)];
    gl64_t s1_42 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 10, domainSize, nCols_1))];
    tmp1_1 = s0_42 * s1_42;
    // Op 43: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 44: dim1x1 mul
    gl64_t s0_44 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 35, domainSize, nCols_0)];
    gl64_t s1_44 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    tmp1_1 = s0_44 * s1_44;
    // Op 45: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 46: dim1x1 add
    gl64_t s0_46 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 36, domainSize, nCols_0)];
    tmp1_0 = s0_46 + tmp1_0;
    // Op 47: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
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
    gl64_t s0_50 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_1))];
    gl64_t s1_50 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    tmp1_0 = s0_50 * s1_50;
    // Op 51: dim1x1 mul
    gl64_t s0_51 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 32, domainSize, nCols_0)];
    tmp1_0 = s0_51 * tmp1_0;
    // Op 52: dim1x1 mul
    gl64_t s0_52 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_0)];
    gl64_t s1_52 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_1))];
    tmp1_1 = s0_52 * s1_52;
    // Op 53: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 54: dim1x1 mul
    gl64_t s0_54 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 34, domainSize, nCols_0)];
    gl64_t s1_54 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    tmp1_1 = s0_54 * s1_54;
    // Op 55: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 56: dim1x1 mul
    gl64_t s0_56 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 35, domainSize, nCols_0)];
    gl64_t s1_56 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    tmp1_1 = s0_56 * s1_56;
    // Op 57: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 58: dim1x1 add
    gl64_t s0_58 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 36, domainSize, nCols_0)];
    tmp1_0 = s0_58 + tmp1_0;
    // Op 59: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
    // Op 60: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 61: dim3x3 mul
    gl64_t s1_61_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_61_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_61_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA61 = (tmp3_0 + tmp3_1) * (s1_61_0 + s1_61_1);
    gl64_t kB61 = (tmp3_0 + tmp3_2) * (s1_61_0 + s1_61_2);
    gl64_t kC61 = (tmp3_1 + tmp3_2) * (s1_61_1 + s1_61_2);
    gl64_t kD61 = tmp3_0 * s1_61_0;
    gl64_t kE61 = tmp3_1 * s1_61_1;
    gl64_t kF61 = tmp3_2 * s1_61_2;
    gl64_t kG61 = kD61 - kE61;
    tmp3_0 = (kC61 + kG61) - kF61;
    tmp3_1 = ((((kA61 + kC61) - kE61) - kE61) - kD61);
    tmp3_2 = kB61 - kG61;
    // Op 62: dim1x1 mul
    gl64_t s0_62 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    gl64_t s1_62 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_0 = s0_62 * s1_62;
    // Op 63: dim1x1 mul
    gl64_t s0_63 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 32, domainSize, nCols_0)];
    tmp1_0 = s0_63 * tmp1_0;
    // Op 64: dim1x1 mul
    gl64_t s0_64 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_0)];
    gl64_t s1_64 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_1 = s0_64 * s1_64;
    // Op 65: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 66: dim1x1 mul
    gl64_t s0_66 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 34, domainSize, nCols_0)];
    gl64_t s1_66 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_1 = s0_66 * s1_66;
    // Op 67: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 68: dim1x1 mul
    gl64_t s0_68 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 35, domainSize, nCols_0)];
    gl64_t s1_68 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_1 = s0_68 * s1_68;
    // Op 69: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 70: dim1x1 add
    gl64_t s0_70 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 36, domainSize, nCols_0)];
    tmp1_0 = s0_70 + tmp1_0;
    // Op 71: dim1x1 mul
    tmp1_0 = tmp1_3 * tmp1_0;
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
    // Op 74: dim1x1 add
    gl64_t s0_74 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_0 = s0_74 + tmp1_3;
    // Op 75: dim1x1 add
    gl64_t s0_75 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_0)];
    tmp1_2 = s0_75 + tmp1_0;
    // Op 76: dim1x1 mul
    gl64_t s0_76 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 18, domainSize, nCols_1))];
    gl64_t s1_76 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 19, domainSize, nCols_1))];
    tmp1_0 = s0_76 * s1_76;
    // Op 77: dim1x1 mul
    gl64_t s0_77 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 32, domainSize, nCols_0)];
    tmp1_0 = s0_77 * tmp1_0;
    // Op 78: dim1x1 mul
    gl64_t s0_78 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_0)];
    gl64_t s1_78 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 18, domainSize, nCols_1))];
    tmp1_1 = s0_78 * s1_78;
    // Op 79: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 80: dim1x1 mul
    gl64_t s0_80 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 34, domainSize, nCols_0)];
    gl64_t s1_80 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 19, domainSize, nCols_1))];
    tmp1_1 = s0_80 * s1_80;
    // Op 81: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 82: dim1x1 mul
    gl64_t s0_82 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 35, domainSize, nCols_0)];
    gl64_t s1_82 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 20, domainSize, nCols_1))];
    tmp1_1 = s0_82 * s1_82;
    // Op 83: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 84: dim1x1 add
    gl64_t s0_84 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 36, domainSize, nCols_0)];
    tmp1_0 = s0_84 + tmp1_0;
    // Op 85: dim1x1 mul
    tmp1_0 = tmp1_2 * tmp1_0;
    // Op 86: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 88: dim1x1 add
    gl64_t s0_88 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_0 = s0_88 + tmp1_3;
    // Op 89: dim1x1 add
    gl64_t s0_89 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_0)];
    tmp1_0 = s0_89 + tmp1_0;
    // Op 90: dim1x1 add
    gl64_t s0_90 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 42, domainSize, nCols_0)];
    tmp1_1 = s0_90 + tmp1_0;
    // Op 91: dim1x1 mul
    gl64_t s0_91 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 21, domainSize, nCols_1))];
    gl64_t s1_91 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 22, domainSize, nCols_1))];
    tmp1_0 = s0_91 * s1_91;
    // Op 92: dim1x1 mul
    gl64_t s0_92 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 32, domainSize, nCols_0)];
    tmp1_0 = s0_92 * tmp1_0;
    // Op 93: dim1x1 mul
    gl64_t s0_93 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_0)];
    gl64_t s1_93 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 21, domainSize, nCols_1))];
    tmp1_2 = s0_93 * s1_93;
    // Op 94: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 95: dim1x1 mul
    gl64_t s0_95 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 34, domainSize, nCols_0)];
    gl64_t s1_95 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 22, domainSize, nCols_1))];
    tmp1_2 = s0_95 * s1_95;
    // Op 96: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 97: dim1x1 mul
    gl64_t s0_97 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 35, domainSize, nCols_0)];
    gl64_t s1_97 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 23, domainSize, nCols_1))];
    tmp1_2 = s0_97 * s1_97;
    // Op 98: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 99: dim1x1 add
    gl64_t s0_99 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 36, domainSize, nCols_0)];
    tmp1_0 = s0_99 + tmp1_0;
    // Op 100: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 101: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 102: dim3x3 mul
    gl64_t s1_102_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_102_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_102_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA102 = (tmp3_0 + tmp3_1) * (s1_102_0 + s1_102_1);
    gl64_t kB102 = (tmp3_0 + tmp3_2) * (s1_102_0 + s1_102_2);
    gl64_t kC102 = (tmp3_1 + tmp3_2) * (s1_102_1 + s1_102_2);
    gl64_t kD102 = tmp3_0 * s1_102_0;
    gl64_t kE102 = tmp3_1 * s1_102_1;
    gl64_t kF102 = tmp3_2 * s1_102_2;
    gl64_t kG102 = kD102 - kE102;
    tmp3_0 = (kC102 + kG102) - kF102;
    tmp3_1 = ((((kA102 + kC102) - kE102) - kE102) - kD102);
    tmp3_2 = kB102 - kG102;
    // Op 103: dim1x1 add
    gl64_t s0_103 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_3 = s0_103 + tmp1_3;
    // Op 104: dim1x1 add
    gl64_t s0_104 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_0)];
    tmp1_3 = s0_104 + tmp1_3;
    // Op 105: dim1x1 add
    gl64_t s0_105 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 42, domainSize, nCols_0)];
    tmp1_3 = s0_105 + tmp1_3;
    // Op 106: dim1x1 add
    gl64_t s0_106 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    tmp1_3 = s0_106 + tmp1_3;
    // Op 107: dim1x1 add
    gl64_t s0_107 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_3 = s0_107 + tmp1_3;
    // Op 108: dim1x1 add
    gl64_t s0_108 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_0)];
    tmp1_1 = s0_108 + tmp1_3;
    // Op 109: dim1x1 mul
    gl64_t s0_109 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 24, domainSize, nCols_1))];
    gl64_t s1_109 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 25, domainSize, nCols_1))];
    tmp1_3 = s0_109 * s1_109;
    // Op 110: dim1x1 mul
    gl64_t s0_110 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 32, domainSize, nCols_0)];
    tmp1_3 = s0_110 * tmp1_3;
    // Op 111: dim1x1 mul
    gl64_t s0_111 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_0)];
    gl64_t s1_111 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 24, domainSize, nCols_1))];
    tmp1_0 = s0_111 * s1_111;
    // Op 112: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_0;
    // Op 113: dim1x1 mul
    gl64_t s0_113 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 34, domainSize, nCols_0)];
    gl64_t s1_113 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 25, domainSize, nCols_1))];
    tmp1_3 = s0_113 * s1_113;
    // Op 114: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 115: dim1x1 mul
    gl64_t s0_115 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 35, domainSize, nCols_0)];
    gl64_t s1_115 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 26, domainSize, nCols_1))];
    tmp1_3 = s0_115 * s1_115;
    // Op 116: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 117: dim1x1 add
    gl64_t s0_117 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 36, domainSize, nCols_0)];
    tmp1_0 = s0_117 + tmp1_0;
    // Op 118: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 119: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 120: dim3x3 mul
    gl64_t s1_120_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_120_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_120_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 121: dim1x1 mul
    gl64_t s0_121 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    gl64_t s1_121 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_0 = s0_121 * s1_121;
    // Op 122: dim1x1 sub
    gl64_t s0_122 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    gl64_t s1_122 = *(gl64_t*)&expressions_params[9][26];
    tmp1_1 = s0_122 - s1_122;
    // Op 123: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
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
    // Op 126: dim1x1 mul
    gl64_t s0_126 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    gl64_t s1_126 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_0 = s0_126 * s1_126;
    // Op 127: dim1x1 sub
    gl64_t s0_127 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    gl64_t s1_127 = *(gl64_t*)&expressions_params[9][26];
    tmp1_1 = s0_127 - s1_127;
    // Op 128: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
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
    // Op 131: dim1x1 add
    gl64_t s0_131 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_131 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_11 = s0_131 + s1_131;
    // Op 132: dim1x1 sub_swap
    gl64_t s0_132 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    gl64_t s1_132 = *(gl64_t*)&expressions_params[9][26];
    tmp1_0 = s1_132 - s0_132;
    // Op 133: dim1x1 sub_swap
    gl64_t s0_133 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    gl64_t s1_133 = *(gl64_t*)&expressions_params[9][26];
    tmp1_1 = s1_133 - s0_133;
    // Op 134: dim1x1 mul
    tmp1_6 = tmp1_0 * tmp1_1;
    // Op 135: dim1x1 mul
    gl64_t s0_135 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_1 = s0_135 * tmp1_6;
    // Op 136: dim1x1 sub_swap
    gl64_t s0_136 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    gl64_t s1_136 = *(gl64_t*)&expressions_params[9][26];
    tmp1_0 = s1_136 - s0_136;
    // Op 137: dim1x1 mul
    gl64_t s0_137 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_7 = s0_137 * tmp1_0;
    // Op 138: dim1x1 sub_swap
    gl64_t s0_138 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    gl64_t s1_138 = *(gl64_t*)&expressions_params[9][26];
    tmp1_0 = s1_138 - s0_138;
    // Op 139: dim1x1 mul
    gl64_t s0_139 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_8 = s0_139 * tmp1_0;
    // Op 140: dim1x1 add
    tmp1_0 = tmp1_7 + tmp1_8;
    // Op 141: dim1x1 mul
    gl64_t s0_141 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    gl64_t s1_141 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_9 = s0_141 * s1_141;
    // Op 142: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_9;
    // Op 143: dim1x1 mul
    gl64_t s0_143 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    tmp1_0 = s0_143 * tmp1_0;
    // Op 144: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 145: dim1x1 mul
    gl64_t s0_145 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_145 * tmp1_0;
    // Op 146: dim1x1 mul
    gl64_t s0_146 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_146 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_1 = s0_146 * s1_146;
    // Op 147: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 148: dim1x1 mul
    gl64_t s1_148 = *(gl64_t*)&expressions_params[9][27];
    tmp1_2 = tmp1_0 * s1_148;
    // Op 149: dim1x1 mul
    gl64_t s0_149 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_1))];
    tmp1_1 = s0_149 * tmp1_6;
    // Op 150: dim1x1 add
    tmp1_0 = tmp1_7 + tmp1_8;
    // Op 151: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_9;
    // Op 152: dim1x1 mul
    gl64_t s0_152 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    tmp1_0 = s0_152 * tmp1_0;
    // Op 153: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 154: dim1x1 mul
    gl64_t s0_154 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_154 * tmp1_0;
    // Op 155: dim1x1 mul
    gl64_t s0_155 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_155 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_1))];
    tmp1_1 = s0_155 * s1_155;
    // Op 156: dim1x1 add
    tmp1_3 = tmp1_0 + tmp1_1;
    // Op 157: dim1x1 mul
    gl64_t s0_157 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    tmp1_1 = s0_157 * tmp1_6;
    // Op 158: dim1x1 add
    tmp1_0 = tmp1_7 + tmp1_8;
    // Op 159: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_9;
    // Op 160: dim1x1 mul
    gl64_t s0_160 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    tmp1_0 = s0_160 * tmp1_0;
    // Op 161: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 162: dim1x1 mul
    gl64_t s0_162 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_162 * tmp1_0;
    // Op 163: dim1x1 mul
    gl64_t s0_163 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_163 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    tmp1_1 = s0_163 * s1_163;
    // Op 164: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 165: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_0;
    // Op 166: dim1x1 add
    tmp1_14 = tmp1_2 + tmp1_0;
    // Op 167: dim1x1 mul
    gl64_t s1_167 = *(gl64_t*)&expressions_params[9][28];
    tmp1_4 = tmp1_0 * s1_167;
    // Op 168: dim1x1 mul
    gl64_t s0_168 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    tmp1_2 = s0_168 * tmp1_6;
    // Op 169: dim1x1 add
    tmp1_0 = tmp1_7 + tmp1_8;
    // Op 170: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_9;
    // Op 171: dim1x1 mul
    gl64_t s0_171 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    tmp1_0 = s0_171 * tmp1_0;
    // Op 172: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 173: dim1x1 mul
    gl64_t s0_173 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_173 * tmp1_0;
    // Op 174: dim1x1 mul
    gl64_t s0_174 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_174 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    tmp1_2 = s0_174 * s1_174;
    // Op 175: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 176: dim1x1 mul
    gl64_t s1_176 = *(gl64_t*)&expressions_params[9][27];
    tmp1_1 = tmp1_0 * s1_176;
    // Op 177: dim1x1 mul
    gl64_t s0_177 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_1))];
    tmp1_2 = s0_177 * tmp1_6;
    // Op 178: dim1x1 add
    tmp1_0 = tmp1_7 + tmp1_8;
    // Op 179: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_9;
    // Op 180: dim1x1 mul
    gl64_t s0_180 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 6, domainSize, nCols_1))];
    tmp1_0 = s0_180 * tmp1_0;
    // Op 181: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 182: dim1x1 mul
    gl64_t s0_182 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_182 * tmp1_0;
    // Op 183: dim1x1 mul
    gl64_t s0_183 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_183 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_1))];
    tmp1_2 = s0_183 * s1_183;
    // Op 184: dim1x1 add
    tmp1_3 = tmp1_0 + tmp1_2;
    // Op 185: dim1x1 mul
    gl64_t s0_185 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_2 = s0_185 * tmp1_6;
    // Op 186: dim1x1 add
    tmp1_0 = tmp1_7 + tmp1_8;
    // Op 187: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_9;
    // Op 188: dim1x1 mul
    gl64_t s0_188 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    tmp1_0 = s0_188 * tmp1_0;
    // Op 189: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_0;
    // Op 190: dim1x1 mul
    gl64_t s0_190 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_190 * tmp1_0;
    // Op 191: dim1x1 mul
    gl64_t s0_191 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_191 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_2 = s0_191 * s1_191;
    // Op 192: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 193: dim1x1 add
    tmp1_13 = tmp1_3 + tmp1_0;
    // Op 194: dim1x1 add
    tmp1_15 = tmp1_1 + tmp1_13;
    // Op 195: dim1x1 add
    tmp1_12 = tmp1_4 + tmp1_15;
    // Op 196: dim1x1 add
    tmp1_10 = tmp1_14 + tmp1_12;
    // Op 197: dim1x1 mul
    gl64_t s0_197 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    tmp1_4 = s0_197 * tmp1_6;
    // Op 198: dim1x1 mul
    gl64_t s0_198 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_1 = s0_198 * tmp1_7;
    // Op 199: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_1;
    // Op 200: dim1x1 add
    tmp1_1 = tmp1_8 + tmp1_9;
    // Op 201: dim1x1 mul
    gl64_t s0_201 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    tmp1_1 = s0_201 * tmp1_1;
    // Op 202: dim1x1 add
    tmp1_1 = tmp1_4 + tmp1_1;
    // Op 203: dim1x1 mul
    gl64_t s0_203 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_1 = s0_203 * tmp1_1;
    // Op 204: dim1x1 mul
    gl64_t s0_204 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_204 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    tmp1_4 = s0_204 * s1_204;
    // Op 205: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_4;
    // Op 206: dim1x1 mul
    gl64_t s1_206 = *(gl64_t*)&expressions_params[9][27];
    tmp1_3 = tmp1_1 * s1_206;
    // Op 207: dim1x1 mul
    gl64_t s0_207 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    tmp1_1 = s0_207 * tmp1_6;
    // Op 208: dim1x1 mul
    gl64_t s0_208 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_1))];
    tmp1_4 = s0_208 * tmp1_7;
    // Op 209: dim1x1 add
    tmp1_4 = tmp1_1 + tmp1_4;
    // Op 210: dim1x1 add
    tmp1_1 = tmp1_8 + tmp1_9;
    // Op 211: dim1x1 mul
    gl64_t s0_211 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 8, domainSize, nCols_1))];
    tmp1_1 = s0_211 * tmp1_1;
    // Op 212: dim1x1 add
    tmp1_1 = tmp1_4 + tmp1_1;
    // Op 213: dim1x1 mul
    gl64_t s0_213 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_1 = s0_213 * tmp1_1;
    // Op 214: dim1x1 mul
    gl64_t s0_214 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_214 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    tmp1_4 = s0_214 * s1_214;
    // Op 215: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_4;
    // Op 216: dim1x1 mul
    gl64_t s0_216 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    tmp1_1 = s0_216 * tmp1_6;
    // Op 217: dim1x1 mul
    gl64_t s0_217 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    tmp1_4 = s0_217 * tmp1_7;
    // Op 218: dim1x1 add
    tmp1_4 = tmp1_1 + tmp1_4;
    // Op 219: dim1x1 add
    tmp1_1 = tmp1_8 + tmp1_9;
    // Op 220: dim1x1 mul
    gl64_t s0_220 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    tmp1_1 = s0_220 * tmp1_1;
    // Op 221: dim1x1 add
    tmp1_1 = tmp1_4 + tmp1_1;
    // Op 222: dim1x1 mul
    gl64_t s0_222 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_1 = s0_222 * tmp1_1;
    // Op 223: dim1x1 mul
    gl64_t s0_223 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_223 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    tmp1_4 = s0_223 * s1_223;
    // Op 224: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_4;
    // Op 225: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 226: dim1x1 add
    tmp1_17 = tmp1_3 + tmp1_0;
    // Op 227: dim1x1 mul
    gl64_t s1_227 = *(gl64_t*)&expressions_params[9][28];
    tmp1_2 = tmp1_0 * s1_227;
    // Op 228: dim1x1 mul
    gl64_t s0_228 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    tmp1_0 = s0_228 * tmp1_6;
    // Op 229: dim1x1 mul
    gl64_t s0_229 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    tmp1_3 = s0_229 * tmp1_7;
    // Op 230: dim1x1 add
    tmp1_3 = tmp1_0 + tmp1_3;
    // Op 231: dim1x1 add
    tmp1_0 = tmp1_8 + tmp1_9;
    // Op 232: dim1x1 mul
    gl64_t s0_232 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    tmp1_0 = s0_232 * tmp1_0;
    // Op 233: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_0;
    // Op 234: dim1x1 mul
    gl64_t s0_234 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_234 * tmp1_0;
    // Op 235: dim1x1 mul
    gl64_t s0_235 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_235 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    tmp1_3 = s0_235 * s1_235;
    // Op 236: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 237: dim1x1 mul
    gl64_t s1_237 = *(gl64_t*)&expressions_params[9][27];
    tmp1_4 = tmp1_0 * s1_237;
    // Op 238: dim1x1 mul
    gl64_t s0_238 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 6, domainSize, nCols_1))];
    tmp1_0 = s0_238 * tmp1_6;
    // Op 239: dim1x1 mul
    gl64_t s0_239 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_1))];
    tmp1_3 = s0_239 * tmp1_7;
    // Op 240: dim1x1 add
    tmp1_3 = tmp1_0 + tmp1_3;
    // Op 241: dim1x1 add
    tmp1_0 = tmp1_8 + tmp1_9;
    // Op 242: dim1x1 mul
    gl64_t s0_242 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 10, domainSize, nCols_1))];
    tmp1_0 = s0_242 * tmp1_0;
    // Op 243: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_0;
    // Op 244: dim1x1 mul
    gl64_t s0_244 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_244 * tmp1_0;
    // Op 245: dim1x1 mul
    gl64_t s0_245 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_245 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 6, domainSize, nCols_1))];
    tmp1_3 = s0_245 * s1_245;
    // Op 246: dim1x1 add
    tmp1_1 = tmp1_0 + tmp1_3;
    // Op 247: dim1x1 mul
    gl64_t s0_247 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    tmp1_0 = s0_247 * tmp1_6;
    // Op 248: dim1x1 mul
    gl64_t s0_248 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_3 = s0_248 * tmp1_7;
    // Op 249: dim1x1 add
    tmp1_3 = tmp1_0 + tmp1_3;
    // Op 250: dim1x1 add
    tmp1_0 = tmp1_8 + tmp1_9;
    // Op 251: dim1x1 mul
    gl64_t s0_251 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    tmp1_0 = s0_251 * tmp1_0;
    // Op 252: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_0;
    // Op 253: dim1x1 mul
    gl64_t s0_253 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_253 * tmp1_0;
    // Op 254: dim1x1 mul
    gl64_t s0_254 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_254 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    tmp1_3 = s0_254 * s1_254;
    // Op 255: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 256: dim1x1 add
    tmp1_16 = tmp1_1 + tmp1_0;
    // Op 257: dim1x1 add
    tmp1_18 = tmp1_4 + tmp1_16;
    // Op 258: dim1x1 add
    tmp1_23 = tmp1_2 + tmp1_18;
    // Op 259: dim1x1 add
    tmp1_22 = tmp1_17 + tmp1_23;
    // Op 260: dim1x1 add
    tmp1_5 = tmp1_10 + tmp1_22;
    // Op 261: dim1x1 add
    tmp1_2 = tmp1_6 + tmp1_7;
    // Op 262: dim1x1 mul
    gl64_t s0_262 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    tmp1_2 = s0_262 * tmp1_2;
    // Op 263: dim1x1 mul
    gl64_t s0_263 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_4 = s0_263 * tmp1_8;
    // Op 264: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_4;
    // Op 265: dim1x1 mul
    gl64_t s0_265 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_4 = s0_265 * tmp1_9;
    // Op 266: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_4;
    // Op 267: dim1x1 mul
    gl64_t s0_267 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_2 = s0_267 * tmp1_2;
    // Op 268: dim1x1 mul
    gl64_t s0_268 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_268 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    tmp1_4 = s0_268 * s1_268;
    // Op 269: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_4;
    // Op 270: dim1x1 mul
    gl64_t s1_270 = *(gl64_t*)&expressions_params[9][27];
    tmp1_1 = tmp1_2 * s1_270;
    // Op 271: dim1x1 add
    tmp1_2 = tmp1_6 + tmp1_7;
    // Op 272: dim1x1 mul
    gl64_t s0_272 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 8, domainSize, nCols_1))];
    tmp1_2 = s0_272 * tmp1_2;
    // Op 273: dim1x1 mul
    gl64_t s0_273 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_1))];
    tmp1_4 = s0_273 * tmp1_8;
    // Op 274: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_4;
    // Op 275: dim1x1 mul
    gl64_t s0_275 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_1))];
    tmp1_4 = s0_275 * tmp1_9;
    // Op 276: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_4;
    // Op 277: dim1x1 mul
    gl64_t s0_277 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_2 = s0_277 * tmp1_2;
    // Op 278: dim1x1 mul
    gl64_t s0_278 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_278 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 8, domainSize, nCols_1))];
    tmp1_4 = s0_278 * s1_278;
    // Op 279: dim1x1 add
    tmp1_0 = tmp1_2 + tmp1_4;
    // Op 280: dim1x1 add
    tmp1_2 = tmp1_6 + tmp1_7;
    // Op 281: dim1x1 mul
    gl64_t s0_281 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    tmp1_2 = s0_281 * tmp1_2;
    // Op 282: dim1x1 mul
    gl64_t s0_282 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    tmp1_4 = s0_282 * tmp1_8;
    // Op 283: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_4;
    // Op 284: dim1x1 mul
    gl64_t s0_284 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    tmp1_4 = s0_284 * tmp1_9;
    // Op 285: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_4;
    // Op 286: dim1x1 mul
    gl64_t s0_286 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_2 = s0_286 * tmp1_2;
    // Op 287: dim1x1 mul
    gl64_t s0_287 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_287 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    tmp1_4 = s0_287 * s1_287;
    // Op 288: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_4;
    // Op 289: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_2;
    // Op 290: dim1x1 add
    tmp1_19 = tmp1_1 + tmp1_0;
    // Op 291: dim1x1 mul
    gl64_t s1_291 = *(gl64_t*)&expressions_params[9][28];
    tmp1_3 = tmp1_0 * s1_291;
    // Op 292: dim1x1 add
    tmp1_0 = tmp1_6 + tmp1_7;
    // Op 293: dim1x1 mul
    gl64_t s0_293 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    tmp1_0 = s0_293 * tmp1_0;
    // Op 294: dim1x1 mul
    gl64_t s0_294 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    tmp1_1 = s0_294 * tmp1_8;
    // Op 295: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 296: dim1x1 mul
    gl64_t s0_296 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    tmp1_1 = s0_296 * tmp1_9;
    // Op 297: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 298: dim1x1 mul
    gl64_t s0_298 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_298 * tmp1_0;
    // Op 299: dim1x1 mul
    gl64_t s0_299 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_299 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    tmp1_1 = s0_299 * s1_299;
    // Op 300: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 301: dim1x1 mul
    gl64_t s1_301 = *(gl64_t*)&expressions_params[9][27];
    tmp1_4 = tmp1_0 * s1_301;
    // Op 302: dim1x1 add
    tmp1_0 = tmp1_6 + tmp1_7;
    // Op 303: dim1x1 mul
    gl64_t s0_303 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 10, domainSize, nCols_1))];
    tmp1_0 = s0_303 * tmp1_0;
    // Op 304: dim1x1 mul
    gl64_t s0_304 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_1))];
    tmp1_1 = s0_304 * tmp1_8;
    // Op 305: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 306: dim1x1 mul
    gl64_t s0_306 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    tmp1_1 = s0_306 * tmp1_9;
    // Op 307: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 308: dim1x1 mul
    gl64_t s0_308 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_308 * tmp1_0;
    // Op 309: dim1x1 mul
    gl64_t s0_309 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_309 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 10, domainSize, nCols_1))];
    tmp1_1 = s0_309 * s1_309;
    // Op 310: dim1x1 add
    tmp1_2 = tmp1_0 + tmp1_1;
    // Op 311: dim1x1 add
    tmp1_0 = tmp1_6 + tmp1_7;
    // Op 312: dim1x1 mul
    gl64_t s0_312 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    tmp1_0 = s0_312 * tmp1_0;
    // Op 313: dim1x1 mul
    gl64_t s0_313 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_1 = s0_313 * tmp1_8;
    // Op 314: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 315: dim1x1 mul
    gl64_t s0_315 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_1 = s0_315 * tmp1_9;
    // Op 316: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 317: dim1x1 mul
    gl64_t s0_317 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_317 * tmp1_0;
    // Op 318: dim1x1 mul
    gl64_t s0_318 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_318 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    tmp1_1 = s0_318 * s1_318;
    // Op 319: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 320: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_0;
    // Op 321: dim1x1 add
    tmp1_20 = tmp1_4 + tmp1_1;
    // Op 322: dim1x1 add
    tmp1_25 = tmp1_3 + tmp1_20;
    // Op 323: dim1x1 add
    tmp1_24 = tmp1_19 + tmp1_25;
    // Op 324: dim1x1 add
    tmp1_2 = tmp1_5 + tmp1_24;
    // Op 325: dim1x1 add
    tmp1_5 = tmp1_6 + tmp1_7;
    // Op 326: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_8;
    // Op 327: dim1x1 mul
    gl64_t s0_327 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_5 = s0_327 * tmp1_5;
    // Op 328: dim1x1 mul
    gl64_t s0_328 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_3 = s0_328 * tmp1_9;
    // Op 329: dim1x1 add
    tmp1_3 = tmp1_5 + tmp1_3;
    // Op 330: dim1x1 mul
    gl64_t s0_330 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_3 = s0_330 * tmp1_3;
    // Op 331: dim1x1 mul
    gl64_t s0_331 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_331 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_5 = s0_331 * s1_331;
    // Op 332: dim1x1 add
    tmp1_3 = tmp1_3 + tmp1_5;
    // Op 333: dim1x1 mul
    gl64_t s1_333 = *(gl64_t*)&expressions_params[9][27];
    tmp1_0 = tmp1_3 * s1_333;
    // Op 334: dim1x1 add
    tmp1_3 = tmp1_6 + tmp1_7;
    // Op 335: dim1x1 add
    tmp1_3 = tmp1_3 + tmp1_8;
    // Op 336: dim1x1 mul
    gl64_t s0_336 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_1))];
    tmp1_3 = s0_336 * tmp1_3;
    // Op 337: dim1x1 mul
    gl64_t s0_337 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_1))];
    tmp1_5 = s0_337 * tmp1_9;
    // Op 338: dim1x1 add
    tmp1_3 = tmp1_3 + tmp1_5;
    // Op 339: dim1x1 mul
    gl64_t s0_339 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_3 = s0_339 * tmp1_3;
    // Op 340: dim1x1 mul
    gl64_t s0_340 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_340 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_1))];
    tmp1_5 = s0_340 * s1_340;
    // Op 341: dim1x1 add
    tmp1_4 = tmp1_3 + tmp1_5;
    // Op 342: dim1x1 add
    tmp1_3 = tmp1_6 + tmp1_7;
    // Op 343: dim1x1 add
    tmp1_3 = tmp1_3 + tmp1_8;
    // Op 344: dim1x1 mul
    gl64_t s0_344 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    tmp1_3 = s0_344 * tmp1_3;
    // Op 345: dim1x1 mul
    gl64_t s0_345 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    tmp1_5 = s0_345 * tmp1_9;
    // Op 346: dim1x1 add
    tmp1_3 = tmp1_3 + tmp1_5;
    // Op 347: dim1x1 mul
    gl64_t s0_347 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_3 = s0_347 * tmp1_3;
    // Op 348: dim1x1 mul
    gl64_t s0_348 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_348 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    tmp1_5 = s0_348 * s1_348;
    // Op 349: dim1x1 add
    tmp1_3 = tmp1_3 + tmp1_5;
    // Op 350: dim1x1 add
    tmp1_3 = tmp1_4 + tmp1_3;
    // Op 351: dim1x1 add
    tmp1_21 = tmp1_0 + tmp1_3;
    // Op 352: dim1x1 mul
    gl64_t s1_352 = *(gl64_t*)&expressions_params[9][28];
    tmp1_5 = tmp1_3 * s1_352;
    // Op 353: dim1x1 add
    tmp1_3 = tmp1_6 + tmp1_7;
    // Op 354: dim1x1 add
    tmp1_3 = tmp1_3 + tmp1_8;
    // Op 355: dim1x1 mul
    gl64_t s0_355 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    tmp1_3 = s0_355 * tmp1_3;
    // Op 356: dim1x1 mul
    gl64_t s0_356 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    tmp1_0 = s0_356 * tmp1_9;
    // Op 357: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_0;
    // Op 358: dim1x1 mul
    gl64_t s0_358 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_358 * tmp1_0;
    // Op 359: dim1x1 mul
    gl64_t s0_359 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_359 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    tmp1_3 = s0_359 * s1_359;
    // Op 360: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 361: dim1x1 mul
    gl64_t s1_361 = *(gl64_t*)&expressions_params[9][27];
    tmp1_4 = tmp1_0 * s1_361;
    // Op 362: dim1x1 add
    tmp1_0 = tmp1_6 + tmp1_7;
    // Op 363: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_8;
    // Op 364: dim1x1 mul
    gl64_t s0_364 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    tmp1_0 = s0_364 * tmp1_0;
    // Op 365: dim1x1 mul
    gl64_t s0_365 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_1))];
    tmp1_3 = s0_365 * tmp1_9;
    // Op 366: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 367: dim1x1 mul
    gl64_t s0_367 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_367 * tmp1_0;
    // Op 368: dim1x1 mul
    gl64_t s0_368 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_368 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    tmp1_3 = s0_368 * s1_368;
    // Op 369: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_3;
    // Op 370: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_7;
    // Op 371: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_8;
    // Op 372: dim1x1 mul
    gl64_t s0_372 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_6 = s0_372 * tmp1_6;
    // Op 373: dim1x1 mul
    gl64_t s0_373 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_9 = s0_373 * tmp1_9;
    // Op 374: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_9;
    // Op 375: dim1x1 mul
    gl64_t s0_375 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_6 = s0_375 * tmp1_6;
    // Op 376: dim1x1 mul
    gl64_t s0_376 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_376 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_9 = s0_376 * s1_376;
    // Op 377: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_9;
    // Op 378: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_6;
    // Op 379: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_0;
    // Op 380: dim1x1 add
    tmp1_6 = tmp1_5 + tmp1_4;
    // Op 381: dim1x1 add
    tmp1_5 = tmp1_21 + tmp1_6;
    // Op 382: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_5;
    // Op 383: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_2;
    // Op 384: dim1x1 sub
    gl64_t s0_384 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 27, domainSize, nCols_1))];
    tmp1_10 = s0_384 - tmp1_10;
    // Op 385: dim1x1 mul
    tmp1_10 = tmp1_11 * tmp1_10;
    // Op 386: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_10; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 388: dim1x1 add
    gl64_t s0_388 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_388 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_11 = s0_388 + s1_388;
    // Op 389: dim1x1 add
    tmp1_10 = tmp1_12 + tmp1_23;
    // Op 390: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_25;
    // Op 391: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_6;
    // Op 392: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_10;
    // Op 393: dim1x1 sub
    gl64_t s0_393 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 28, domainSize, nCols_1))];
    tmp1_12 = s0_393 - tmp1_12;
    // Op 394: dim1x1 mul
    tmp1_11 = tmp1_11 * tmp1_12;
    // Op 395: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_11; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 397: dim1x1 add
    gl64_t s0_397 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_397 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_11 = s0_397 + s1_397;
    // Op 398: dim1x1 mul
    gl64_t s1_398 = *(gl64_t*)&expressions_params[9][28];
    tmp1_13 = tmp1_13 * s1_398;
    // Op 399: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_14;
    // Op 400: dim1x1 add
    tmp1_15 = tmp1_15 + tmp1_13;
    // Op 401: dim1x1 mul
    gl64_t s1_401 = *(gl64_t*)&expressions_params[9][28];
    tmp1_16 = tmp1_16 * s1_401;
    // Op 402: dim1x1 add
    tmp1_17 = tmp1_16 + tmp1_17;
    // Op 403: dim1x1 add
    tmp1_16 = tmp1_18 + tmp1_17;
    // Op 404: dim1x1 add
    tmp1_18 = tmp1_15 + tmp1_16;
    // Op 405: dim1x1 mul
    gl64_t s1_405 = *(gl64_t*)&expressions_params[9][28];
    tmp1_1 = tmp1_1 * s1_405;
    // Op 406: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_19;
    // Op 407: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_1;
    // Op 408: dim1x1 add
    tmp1_18 = tmp1_18 + tmp1_20;
    // Op 409: dim1x1 mul
    gl64_t s1_409 = *(gl64_t*)&expressions_params[9][28];
    tmp1_0 = tmp1_0 * s1_409;
    // Op 410: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_21;
    // Op 411: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_0;
    // Op 412: dim1x1 add
    tmp1_18 = tmp1_18 + tmp1_4;
    // Op 413: dim1x1 add
    tmp1_15 = tmp1_15 + tmp1_18;
    // Op 414: dim1x1 sub
    gl64_t s0_414 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 29, domainSize, nCols_1))];
    tmp1_15 = s0_414 - tmp1_15;
    // Op 415: dim1x1 mul
    tmp1_11 = tmp1_11 * tmp1_15;
    // Op 416: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_11; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 417: dim3x3 mul
    gl64_t s1_417_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_417_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_417_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA417 = (tmp3_0 + tmp3_1) * (s1_417_0 + s1_417_1);
    gl64_t kB417 = (tmp3_0 + tmp3_2) * (s1_417_0 + s1_417_2);
    gl64_t kC417 = (tmp3_1 + tmp3_2) * (s1_417_1 + s1_417_2);
    gl64_t kD417 = tmp3_0 * s1_417_0;
    gl64_t kE417 = tmp3_1 * s1_417_1;
    gl64_t kF417 = tmp3_2 * s1_417_2;
    gl64_t kG417 = kD417 - kE417;
    tmp3_0 = (kC417 + kG417) - kF417;
    tmp3_1 = ((((kA417 + kC417) - kE417) - kE417) - kD417);
    tmp3_2 = kB417 - kG417;
    // Op 418: dim1x1 add
    gl64_t s0_418 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_418 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_15 = s0_418 + s1_418;
    // Op 419: dim1x1 add
    tmp1_11 = tmp1_13 + tmp1_17;
    // Op 420: dim1x1 add
    tmp1_11 = tmp1_11 + tmp1_1;
    // Op 421: dim1x1 add
    tmp1_11 = tmp1_11 + tmp1_0;
    // Op 422: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_11;
    // Op 423: dim1x1 sub
    gl64_t s0_423 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 30, domainSize, nCols_1))];
    tmp1_13 = s0_423 - tmp1_13;
    // Op 424: dim1x1 mul
    tmp1_13 = tmp1_15 * tmp1_13;
    // Op 425: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_13; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC426 + kG426) - kF426;
    tmp3_1 = ((((kA426 + kC426) - kE426) - kE426) - kD426);
    tmp3_2 = kB426 - kG426;
    // Op 427: dim1x1 add
    gl64_t s0_427 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_427 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_13 = s0_427 + s1_427;
    // Op 428: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_2;
    // Op 429: dim1x1 sub
    gl64_t s0_429 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 31, domainSize, nCols_1))];
    tmp1_22 = s0_429 - tmp1_22;
    // Op 430: dim1x1 mul
    tmp1_13 = tmp1_13 * tmp1_22;
    // Op 431: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_13; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 432: dim3x3 mul
    gl64_t s1_432_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_432_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_432_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 433: dim1x1 add
    gl64_t s0_433 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_433 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_13 = s0_433 + s1_433;
    // Op 434: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_10;
    // Op 435: dim1x1 sub
    gl64_t s0_435 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 32, domainSize, nCols_1))];
    tmp1_23 = s0_435 - tmp1_23;
    // Op 436: dim1x1 mul
    tmp1_13 = tmp1_13 * tmp1_23;
    // Op 437: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_13; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 438: dim3x3 mul
    gl64_t s1_438_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_438_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_438_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA438 = (tmp3_0 + tmp3_1) * (s1_438_0 + s1_438_1);
    gl64_t kB438 = (tmp3_0 + tmp3_2) * (s1_438_0 + s1_438_2);
    gl64_t kC438 = (tmp3_1 + tmp3_2) * (s1_438_1 + s1_438_2);
    gl64_t kD438 = tmp3_0 * s1_438_0;
    gl64_t kE438 = tmp3_1 * s1_438_1;
    gl64_t kF438 = tmp3_2 * s1_438_2;
    gl64_t kG438 = kD438 - kE438;
    tmp3_0 = (kC438 + kG438) - kF438;
    tmp3_1 = ((((kA438 + kC438) - kE438) - kE438) - kD438);
    tmp3_2 = kB438 - kG438;
    // Op 439: dim1x1 add
    gl64_t s0_439 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_439 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_13 = s0_439 + s1_439;
    // Op 440: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_18;
    // Op 441: dim1x1 sub
    gl64_t s0_441 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_1))];
    tmp1_16 = s0_441 - tmp1_16;
    // Op 442: dim1x1 mul
    tmp1_13 = tmp1_13 * tmp1_16;
    // Op 443: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_13; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 444: dim3x3 mul
    gl64_t s1_444_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_444_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_444_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 445: dim1x1 add
    gl64_t s0_445 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_445 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_13 = s0_445 + s1_445;
    // Op 446: dim1x1 add
    tmp1_17 = tmp1_17 + tmp1_11;
    // Op 447: dim1x1 sub
    gl64_t s0_447 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 34, domainSize, nCols_1))];
    tmp1_17 = s0_447 - tmp1_17;
    // Op 448: dim1x1 mul
    tmp1_13 = tmp1_13 * tmp1_17;
    // Op 449: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_13; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 450: dim3x3 mul
    gl64_t s1_450_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_450_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_450_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA450 = (tmp3_0 + tmp3_1) * (s1_450_0 + s1_450_1);
    gl64_t kB450 = (tmp3_0 + tmp3_2) * (s1_450_0 + s1_450_2);
    gl64_t kC450 = (tmp3_1 + tmp3_2) * (s1_450_1 + s1_450_2);
    gl64_t kD450 = tmp3_0 * s1_450_0;
    gl64_t kE450 = tmp3_1 * s1_450_1;
    gl64_t kF450 = tmp3_2 * s1_450_2;
    gl64_t kG450 = kD450 - kE450;
    tmp3_0 = (kC450 + kG450) - kF450;
    tmp3_1 = ((((kA450 + kC450) - kE450) - kE450) - kD450);
    tmp3_2 = kB450 - kG450;
    // Op 451: dim1x1 add
    gl64_t s0_451 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_451 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_13 = s0_451 + s1_451;
    // Op 452: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_2;
    // Op 453: dim1x1 sub
    gl64_t s0_453 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 35, domainSize, nCols_1))];
    tmp1_24 = s0_453 - tmp1_24;
    // Op 454: dim1x1 mul
    tmp1_13 = tmp1_13 * tmp1_24;
    // Op 455: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_13; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC456 + kG456) - kF456;
    tmp3_1 = ((((kA456 + kC456) - kE456) - kE456) - kD456);
    tmp3_2 = kB456 - kG456;
    // Op 457: dim1x1 add
    gl64_t s0_457 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_457 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_13 = s0_457 + s1_457;
    // Op 458: dim1x1 add
    tmp1_25 = tmp1_25 + tmp1_10;
    // Op 459: dim1x1 sub
    gl64_t s0_459 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 36, domainSize, nCols_1))];
    tmp1_25 = s0_459 - tmp1_25;
    // Op 460: dim1x1 mul
    tmp1_13 = tmp1_13 * tmp1_25;
    // Op 461: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_13; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC462 + kG462) - kF462;
    tmp3_1 = ((((kA462 + kC462) - kE462) - kE462) - kD462);
    tmp3_2 = kB462 - kG462;
    // Op 463: dim1x1 add
    gl64_t s0_463 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_463 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_13 = s0_463 + s1_463;
    // Op 464: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_18;
    // Op 465: dim1x1 sub
    gl64_t s0_465 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_1))];
    tmp1_20 = s0_465 - tmp1_20;
    // Op 466: dim1x1 mul
    tmp1_13 = tmp1_13 * tmp1_20;
    // Op 467: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_13; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 468: dim3x3 mul
    gl64_t s1_468_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_468_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_468_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 469: dim1x1 add
    gl64_t s0_469 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_469 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_13 = s0_469 + s1_469;
    // Op 470: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_11;
    // Op 471: dim1x1 sub
    gl64_t s0_471 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_1))];
    tmp1_1 = s0_471 - tmp1_1;
    // Op 472: dim1x1 mul
    tmp1_1 = tmp1_13 * tmp1_1;
    // Op 473: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 474: dim3x3 mul
    gl64_t s1_474_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_474_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_474_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 475: dim1x1 add
    gl64_t s0_475 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_475 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_1 = s0_475 + s1_475;
    // Op 476: dim1x1 add
    tmp1_2 = tmp1_5 + tmp1_2;
    // Op 477: dim1x1 sub
    gl64_t s0_477 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_1))];
    tmp1_2 = s0_477 - tmp1_2;
    // Op 478: dim1x1 mul
    tmp1_1 = tmp1_1 * tmp1_2;
    // Op 479: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 481: dim1x1 add
    gl64_t s0_481 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_481 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_1 = s0_481 + s1_481;
    // Op 482: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_10;
    // Op 483: dim1x1 sub
    gl64_t s0_483 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_1))];
    tmp1_6 = s0_483 - tmp1_6;
    // Op 484: dim1x1 mul
    tmp1_1 = tmp1_1 * tmp1_6;
    // Op 485: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 486: dim3x3 mul
    gl64_t s1_486_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_486_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_486_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 487: dim1x1 add
    gl64_t s0_487 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_487 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_1 = s0_487 + s1_487;
    // Op 488: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_18;
    // Op 489: dim1x1 sub
    gl64_t s0_489 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 41, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 41, domainSize, nCols_1))];
    tmp1_4 = s0_489 - tmp1_4;
    // Op 490: dim1x1 mul
    tmp1_1 = tmp1_1 * tmp1_4;
    // Op 491: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC492 + kG492) - kF492;
    tmp3_1 = ((((kA492 + kC492) - kE492) - kE492) - kD492);
    tmp3_2 = kB492 - kG492;
    // Op 493: dim1x1 add
    gl64_t s0_493 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_493 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_1 = s0_493 + s1_493;
    // Op 494: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_11;
    // Op 495: dim1x1 sub
    gl64_t s0_495 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 42, domainSize, nCols_1))];
    tmp1_0 = s0_495 - tmp1_0;
    // Op 496: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 497: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 498: dim3x3 mul
    gl64_t s1_498_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_498_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_498_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA498 = (tmp3_0 + tmp3_1) * (s1_498_0 + s1_498_1);
    gl64_t kB498 = (tmp3_0 + tmp3_2) * (s1_498_0 + s1_498_2);
    gl64_t kC498 = (tmp3_1 + tmp3_2) * (s1_498_1 + s1_498_2);
    gl64_t kD498 = tmp3_0 * s1_498_0;
    gl64_t kE498 = tmp3_1 * s1_498_1;
    gl64_t kF498 = tmp3_2 * s1_498_2;
    gl64_t kG498 = kD498 - kE498;
    tmp3_0 = (kC498 + kG498) - kF498;
    tmp3_1 = ((((kA498 + kC498) - kE498) - kE498) - kD498);
    tmp3_2 = kB498 - kG498;
    // Op 499: dim1x1 add
    gl64_t s0_499 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_499 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_499 + s1_499;
    // Op 500: dim1x1 add
    gl64_t s0_500 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_0 = s0_500 + tmp1_0;
    // Op 501: dim1x1 add
    gl64_t s0_501 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_0 = s0_501 + tmp1_0;
    // Op 502: dim1x1 add
    gl64_t s0_502 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_13 = s0_502 + tmp1_0;
    // Op 503: dim1x1 add
    gl64_t s0_503 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_503 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_503 + s1_503;
    // Op 504: dim1x1 mul
    gl64_t s1_504 = *(gl64_t*)&expressions_params[9][29];
    tmp1_0 = tmp1_0 * s1_504;
    // Op 505: dim1x1 mul
    gl64_t s0_505 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_505 = *(gl64_t*)&expressions_params[9][30];
    tmp1_1 = s0_505 * s1_505;
    // Op 506: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 507: dim1x1 mul
    gl64_t s0_507 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_507 = *(gl64_t*)&expressions_params[9][31];
    tmp1_1 = s0_507 * s1_507;
    // Op 508: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 509: dim1x1 mul
    gl64_t s0_509 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_509 = *(gl64_t*)&expressions_params[9][32];
    tmp1_1 = s0_509 * s1_509;
    // Op 510: dim1x1 add
    tmp1_6 = tmp1_0 + tmp1_1;
    // Op 511: dim1x1 add
    gl64_t s0_511 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 30, domainSize, nCols_1))];
    tmp1_0 = s0_511 + tmp1_6;
    // Op 512: dim1x1 add
    gl64_t s0_512 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 30, domainSize, nCols_1))];
    tmp1_1 = s0_512 + tmp1_6;
    // Op 513: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 514: dim1x1 mul
    tmp1_1 = tmp1_0 * tmp1_0;
    // Op 515: dim1x1 mul
    tmp1_10 = tmp1_1 * tmp1_0;
    // Op 516: dim1x1 add
    gl64_t s0_516 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 30, domainSize, nCols_1))];
    tmp1_0 = s0_516 + tmp1_6;
    // Op 517: dim1x1 mul
    tmp1_0 = tmp1_10 * tmp1_0;
    // Op 518: dim1x1 mul
    gl64_t s1_518 = *(gl64_t*)&expressions_params[9][27];
    tmp1_4 = tmp1_0 * s1_518;
    // Op 519: dim1x1 add
    gl64_t s0_519 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_519 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_519 + s1_519;
    // Op 520: dim1x1 mul
    gl64_t s1_520 = *(gl64_t*)&expressions_params[9][33];
    tmp1_0 = tmp1_0 * s1_520;
    // Op 521: dim1x1 mul
    gl64_t s0_521 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_521 = *(gl64_t*)&expressions_params[9][34];
    tmp1_1 = s0_521 * s1_521;
    // Op 522: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 523: dim1x1 mul
    gl64_t s0_523 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_523 = *(gl64_t*)&expressions_params[9][35];
    tmp1_1 = s0_523 * s1_523;
    // Op 524: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 525: dim1x1 mul
    gl64_t s0_525 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_525 = *(gl64_t*)&expressions_params[9][36];
    tmp1_1 = s0_525 * s1_525;
    // Op 526: dim1x1 add
    tmp1_11 = tmp1_0 + tmp1_1;
    // Op 527: dim1x1 add
    gl64_t s0_527 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 27, domainSize, nCols_1))];
    tmp1_0 = s0_527 + tmp1_11;
    // Op 528: dim1x1 add
    gl64_t s0_528 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 27, domainSize, nCols_1))];
    tmp1_1 = s0_528 + tmp1_11;
    // Op 529: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 530: dim1x1 mul
    tmp1_1 = tmp1_0 * tmp1_0;
    // Op 531: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 532: dim1x1 add
    gl64_t s0_532 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 27, domainSize, nCols_1))];
    tmp1_11 = s0_532 + tmp1_11;
    // Op 533: dim1x1 mul
    tmp1_1 = tmp1_0 * tmp1_11;
    // Op 534: dim1x1 add
    gl64_t s0_534 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_534 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_534 + s1_534;
    // Op 535: dim1x1 mul
    gl64_t s1_535 = *(gl64_t*)&expressions_params[9][37];
    tmp1_0 = tmp1_0 * s1_535;
    // Op 536: dim1x1 mul
    gl64_t s0_536 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_536 = *(gl64_t*)&expressions_params[9][38];
    tmp1_11 = s0_536 * s1_536;
    // Op 537: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_11;
    // Op 538: dim1x1 mul
    gl64_t s0_538 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_538 = *(gl64_t*)&expressions_params[9][39];
    tmp1_11 = s0_538 * s1_538;
    // Op 539: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_11;
    // Op 540: dim1x1 mul
    gl64_t s0_540 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_540 = *(gl64_t*)&expressions_params[9][40];
    tmp1_11 = s0_540 * s1_540;
    // Op 541: dim1x1 add
    tmp1_18 = tmp1_0 + tmp1_11;
    // Op 542: dim1x1 add
    gl64_t s0_542 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 28, domainSize, nCols_1))];
    tmp1_0 = s0_542 + tmp1_18;
    // Op 543: dim1x1 add
    gl64_t s0_543 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 28, domainSize, nCols_1))];
    tmp1_11 = s0_543 + tmp1_18;
    // Op 544: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_11;
    // Op 545: dim1x1 mul
    tmp1_11 = tmp1_0 * tmp1_0;
    // Op 546: dim1x1 mul
    tmp1_11 = tmp1_11 * tmp1_0;
    // Op 547: dim1x1 add
    gl64_t s0_547 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 28, domainSize, nCols_1))];
    tmp1_0 = s0_547 + tmp1_18;
    // Op 548: dim1x1 mul
    tmp1_0 = tmp1_11 * tmp1_0;
    // Op 549: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 550: dim1x1 add
    tmp1_24 = tmp1_4 + tmp1_0;
    // Op 551: dim1x1 mul
    gl64_t s1_551 = *(gl64_t*)&expressions_params[9][28];
    tmp1_1 = tmp1_0 * s1_551;
    // Op 552: dim1x1 add
    gl64_t s0_552 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 28, domainSize, nCols_1))];
    tmp1_18 = s0_552 + tmp1_18;
    // Op 553: dim1x1 mul
    tmp1_11 = tmp1_11 * tmp1_18;
    // Op 554: dim1x1 mul
    gl64_t s1_554 = *(gl64_t*)&expressions_params[9][27];
    tmp1_4 = tmp1_11 * s1_554;
    // Op 555: dim1x1 add
    gl64_t s0_555 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_555 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_11 = s0_555 + s1_555;
    // Op 556: dim1x1 mul
    gl64_t s1_556 = *(gl64_t*)&expressions_params[9][41];
    tmp1_11 = tmp1_11 * s1_556;
    // Op 557: dim1x1 mul
    gl64_t s0_557 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_557 = *(gl64_t*)&expressions_params[9][42];
    tmp1_18 = s0_557 * s1_557;
    // Op 558: dim1x1 add
    tmp1_11 = tmp1_11 + tmp1_18;
    // Op 559: dim1x1 mul
    gl64_t s0_559 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_559 = *(gl64_t*)&expressions_params[9][43];
    tmp1_18 = s0_559 * s1_559;
    // Op 560: dim1x1 add
    tmp1_11 = tmp1_11 + tmp1_18;
    // Op 561: dim1x1 mul
    gl64_t s0_561 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_561 = *(gl64_t*)&expressions_params[9][44];
    tmp1_18 = s0_561 * s1_561;
    // Op 562: dim1x1 add
    tmp1_0 = tmp1_11 + tmp1_18;
    // Op 563: dim1x1 add
    gl64_t s0_563 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 29, domainSize, nCols_1))];
    tmp1_11 = s0_563 + tmp1_0;
    // Op 564: dim1x1 add
    gl64_t s0_564 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 29, domainSize, nCols_1))];
    tmp1_18 = s0_564 + tmp1_0;
    // Op 565: dim1x1 mul
    tmp1_11 = tmp1_11 * tmp1_18;
    // Op 566: dim1x1 mul
    tmp1_18 = tmp1_11 * tmp1_11;
    // Op 567: dim1x1 mul
    tmp1_11 = tmp1_18 * tmp1_11;
    // Op 568: dim1x1 add
    gl64_t s0_568 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 29, domainSize, nCols_1))];
    tmp1_0 = s0_568 + tmp1_0;
    // Op 569: dim1x1 mul
    tmp1_0 = tmp1_11 * tmp1_0;
    // Op 570: dim1x1 add
    gl64_t s0_570 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 30, domainSize, nCols_1))];
    tmp1_6 = s0_570 + tmp1_6;
    // Op 571: dim1x1 mul
    tmp1_6 = tmp1_10 * tmp1_6;
    // Op 572: dim1x1 add
    tmp1_25 = tmp1_0 + tmp1_6;
    // Op 573: dim1x1 add
    tmp1_17 = tmp1_4 + tmp1_25;
    // Op 574: dim1x1 add
    tmp1_20 = tmp1_1 + tmp1_17;
    // Op 575: dim1x1 add
    tmp1_5 = tmp1_24 + tmp1_20;
    // Op 576: dim1x1 add
    gl64_t s0_576 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_576 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_1 = s0_576 + s1_576;
    // Op 577: dim1x1 mul
    gl64_t s1_577 = *(gl64_t*)&expressions_params[9][45];
    tmp1_1 = tmp1_1 * s1_577;
    // Op 578: dim1x1 mul
    gl64_t s0_578 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_578 = *(gl64_t*)&expressions_params[9][46];
    tmp1_4 = s0_578 * s1_578;
    // Op 579: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_4;
    // Op 580: dim1x1 mul
    gl64_t s0_580 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_580 = *(gl64_t*)&expressions_params[9][47];
    tmp1_4 = s0_580 * s1_580;
    // Op 581: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_4;
    // Op 582: dim1x1 mul
    gl64_t s0_582 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_582 = *(gl64_t*)&expressions_params[9][48];
    tmp1_4 = s0_582 * s1_582;
    // Op 583: dim1x1 add
    tmp1_11 = tmp1_1 + tmp1_4;
    // Op 584: dim1x1 add
    gl64_t s0_584 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 34, domainSize, nCols_1))];
    tmp1_1 = s0_584 + tmp1_11;
    // Op 585: dim1x1 add
    gl64_t s0_585 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 34, domainSize, nCols_1))];
    tmp1_4 = s0_585 + tmp1_11;
    // Op 586: dim1x1 mul
    tmp1_1 = tmp1_1 * tmp1_4;
    // Op 587: dim1x1 mul
    tmp1_4 = tmp1_1 * tmp1_1;
    // Op 588: dim1x1 mul
    tmp1_18 = tmp1_4 * tmp1_1;
    // Op 589: dim1x1 add
    gl64_t s0_589 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 34, domainSize, nCols_1))];
    tmp1_1 = s0_589 + tmp1_11;
    // Op 590: dim1x1 mul
    tmp1_1 = tmp1_18 * tmp1_1;
    // Op 591: dim1x1 mul
    gl64_t s1_591 = *(gl64_t*)&expressions_params[9][27];
    tmp1_6 = tmp1_1 * s1_591;
    // Op 592: dim1x1 add
    gl64_t s0_592 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_592 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_1 = s0_592 + s1_592;
    // Op 593: dim1x1 mul
    gl64_t s1_593 = *(gl64_t*)&expressions_params[9][49];
    tmp1_1 = tmp1_1 * s1_593;
    // Op 594: dim1x1 mul
    gl64_t s0_594 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_594 = *(gl64_t*)&expressions_params[9][50];
    tmp1_4 = s0_594 * s1_594;
    // Op 595: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_4;
    // Op 596: dim1x1 mul
    gl64_t s0_596 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_596 = *(gl64_t*)&expressions_params[9][51];
    tmp1_4 = s0_596 * s1_596;
    // Op 597: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_4;
    // Op 598: dim1x1 mul
    gl64_t s0_598 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_598 = *(gl64_t*)&expressions_params[9][52];
    tmp1_4 = s0_598 * s1_598;
    // Op 599: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_4;
    // Op 600: dim1x1 add
    gl64_t s0_600 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 31, domainSize, nCols_1))];
    tmp1_1 = s0_600 + tmp1_0;
    // Op 601: dim1x1 add
    gl64_t s0_601 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 31, domainSize, nCols_1))];
    tmp1_4 = s0_601 + tmp1_0;
    // Op 602: dim1x1 mul
    tmp1_1 = tmp1_1 * tmp1_4;
    // Op 603: dim1x1 mul
    tmp1_4 = tmp1_1 * tmp1_1;
    // Op 604: dim1x1 mul
    tmp1_1 = tmp1_4 * tmp1_1;
    // Op 605: dim1x1 add
    gl64_t s0_605 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 31, domainSize, nCols_1))];
    tmp1_0 = s0_605 + tmp1_0;
    // Op 606: dim1x1 mul
    tmp1_4 = tmp1_1 * tmp1_0;
    // Op 607: dim1x1 add
    gl64_t s0_607 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_607 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_607 + s1_607;
    // Op 608: dim1x1 mul
    gl64_t s1_608 = *(gl64_t*)&expressions_params[9][53];
    tmp1_0 = tmp1_0 * s1_608;
    // Op 609: dim1x1 mul
    gl64_t s0_609 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_609 = *(gl64_t*)&expressions_params[9][54];
    tmp1_1 = s0_609 * s1_609;
    // Op 610: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 611: dim1x1 mul
    gl64_t s0_611 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_611 = *(gl64_t*)&expressions_params[9][55];
    tmp1_1 = s0_611 * s1_611;
    // Op 612: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 613: dim1x1 mul
    gl64_t s0_613 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_613 = *(gl64_t*)&expressions_params[9][56];
    tmp1_1 = s0_613 * s1_613;
    // Op 614: dim1x1 add
    tmp1_10 = tmp1_0 + tmp1_1;
    // Op 615: dim1x1 add
    gl64_t s0_615 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 32, domainSize, nCols_1))];
    tmp1_0 = s0_615 + tmp1_10;
    // Op 616: dim1x1 add
    gl64_t s0_616 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 32, domainSize, nCols_1))];
    tmp1_1 = s0_616 + tmp1_10;
    // Op 617: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 618: dim1x1 mul
    tmp1_1 = tmp1_0 * tmp1_0;
    // Op 619: dim1x1 mul
    tmp1_1 = tmp1_1 * tmp1_0;
    // Op 620: dim1x1 add
    gl64_t s0_620 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 32, domainSize, nCols_1))];
    tmp1_0 = s0_620 + tmp1_10;
    // Op 621: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 622: dim1x1 add
    tmp1_0 = tmp1_4 + tmp1_0;
    // Op 623: dim1x1 add
    tmp1_23 = tmp1_6 + tmp1_0;
    // Op 624: dim1x1 mul
    gl64_t s1_624 = *(gl64_t*)&expressions_params[9][28];
    tmp1_4 = tmp1_0 * s1_624;
    // Op 625: dim1x1 add
    gl64_t s0_625 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 32, domainSize, nCols_1))];
    tmp1_10 = s0_625 + tmp1_10;
    // Op 626: dim1x1 mul
    tmp1_1 = tmp1_1 * tmp1_10;
    // Op 627: dim1x1 mul
    gl64_t s1_627 = *(gl64_t*)&expressions_params[9][27];
    tmp1_6 = tmp1_1 * s1_627;
    // Op 628: dim1x1 add
    gl64_t s0_628 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_628 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_1 = s0_628 + s1_628;
    // Op 629: dim1x1 mul
    gl64_t s1_629 = *(gl64_t*)&expressions_params[9][57];
    tmp1_1 = tmp1_1 * s1_629;
    // Op 630: dim1x1 mul
    gl64_t s0_630 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_630 = *(gl64_t*)&expressions_params[9][58];
    tmp1_10 = s0_630 * s1_630;
    // Op 631: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_10;
    // Op 632: dim1x1 mul
    gl64_t s0_632 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_632 = *(gl64_t*)&expressions_params[9][59];
    tmp1_10 = s0_632 * s1_632;
    // Op 633: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_10;
    // Op 634: dim1x1 mul
    gl64_t s0_634 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_634 = *(gl64_t*)&expressions_params[9][60];
    tmp1_10 = s0_634 * s1_634;
    // Op 635: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_10;
    // Op 636: dim1x1 add
    gl64_t s0_636 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_1))];
    tmp1_1 = s0_636 + tmp1_0;
    // Op 637: dim1x1 add
    gl64_t s0_637 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_1))];
    tmp1_10 = s0_637 + tmp1_0;
    // Op 638: dim1x1 mul
    tmp1_1 = tmp1_1 * tmp1_10;
    // Op 639: dim1x1 mul
    tmp1_10 = tmp1_1 * tmp1_1;
    // Op 640: dim1x1 mul
    tmp1_1 = tmp1_10 * tmp1_1;
    // Op 641: dim1x1 add
    gl64_t s0_641 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_1))];
    tmp1_0 = s0_641 + tmp1_0;
    // Op 642: dim1x1 mul
    tmp1_0 = tmp1_1 * tmp1_0;
    // Op 643: dim1x1 add
    gl64_t s0_643 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 34, domainSize, nCols_1))];
    tmp1_11 = s0_643 + tmp1_11;
    // Op 644: dim1x1 mul
    tmp1_11 = tmp1_18 * tmp1_11;
    // Op 645: dim1x1 add
    tmp1_16 = tmp1_0 + tmp1_11;
    // Op 646: dim1x1 add
    tmp1_22 = tmp1_6 + tmp1_16;
    // Op 647: dim1x1 add
    tmp1_9 = tmp1_4 + tmp1_22;
    // Op 648: dim1x1 add
    tmp1_12 = tmp1_23 + tmp1_9;
    // Op 649: dim1x1 add
    tmp1_2 = tmp1_5 + tmp1_12;
    // Op 650: dim1x1 add
    gl64_t s0_650 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_650 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_4 = s0_650 + s1_650;
    // Op 651: dim1x1 mul
    gl64_t s1_651 = *(gl64_t*)&expressions_params[9][61];
    tmp1_4 = tmp1_4 * s1_651;
    // Op 652: dim1x1 mul
    gl64_t s0_652 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_652 = *(gl64_t*)&expressions_params[9][62];
    tmp1_6 = s0_652 * s1_652;
    // Op 653: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_6;
    // Op 654: dim1x1 mul
    gl64_t s0_654 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_654 = *(gl64_t*)&expressions_params[9][63];
    tmp1_6 = s0_654 * s1_654;
    // Op 655: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_6;
    // Op 656: dim1x1 mul
    gl64_t s0_656 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_656 = *(gl64_t*)&expressions_params[9][64];
    tmp1_6 = s0_656 * s1_656;
    // Op 657: dim1x1 add
    tmp1_1 = tmp1_4 + tmp1_6;
    // Op 658: dim1x1 add
    gl64_t s0_658 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_1))];
    tmp1_4 = s0_658 + tmp1_1;
    // Op 659: dim1x1 add
    gl64_t s0_659 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_1))];
    tmp1_6 = s0_659 + tmp1_1;
    // Op 660: dim1x1 mul
    tmp1_4 = tmp1_4 * tmp1_6;
    // Op 661: dim1x1 mul
    tmp1_6 = tmp1_4 * tmp1_4;
    // Op 662: dim1x1 mul
    tmp1_10 = tmp1_6 * tmp1_4;
    // Op 663: dim1x1 add
    gl64_t s0_663 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_1))];
    tmp1_4 = s0_663 + tmp1_1;
    // Op 664: dim1x1 mul
    tmp1_4 = tmp1_10 * tmp1_4;
    // Op 665: dim1x1 mul
    gl64_t s1_665 = *(gl64_t*)&expressions_params[9][27];
    tmp1_11 = tmp1_4 * s1_665;
    // Op 666: dim1x1 add
    gl64_t s0_666 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_666 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_4 = s0_666 + s1_666;
    // Op 667: dim1x1 mul
    gl64_t s1_667 = *(gl64_t*)&expressions_params[9][65];
    tmp1_4 = tmp1_4 * s1_667;
    // Op 668: dim1x1 mul
    gl64_t s0_668 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_668 = *(gl64_t*)&expressions_params[9][66];
    tmp1_6 = s0_668 * s1_668;
    // Op 669: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_6;
    // Op 670: dim1x1 mul
    gl64_t s0_670 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_670 = *(gl64_t*)&expressions_params[9][67];
    tmp1_6 = s0_670 * s1_670;
    // Op 671: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_6;
    // Op 672: dim1x1 mul
    gl64_t s0_672 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_672 = *(gl64_t*)&expressions_params[9][68];
    tmp1_6 = s0_672 * s1_672;
    // Op 673: dim1x1 add
    tmp1_0 = tmp1_4 + tmp1_6;
    // Op 674: dim1x1 add
    gl64_t s0_674 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 35, domainSize, nCols_1))];
    tmp1_4 = s0_674 + tmp1_0;
    // Op 675: dim1x1 add
    gl64_t s0_675 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 35, domainSize, nCols_1))];
    tmp1_6 = s0_675 + tmp1_0;
    // Op 676: dim1x1 mul
    tmp1_4 = tmp1_4 * tmp1_6;
    // Op 677: dim1x1 mul
    tmp1_6 = tmp1_4 * tmp1_4;
    // Op 678: dim1x1 mul
    tmp1_4 = tmp1_6 * tmp1_4;
    // Op 679: dim1x1 add
    gl64_t s0_679 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 35, domainSize, nCols_1))];
    tmp1_0 = s0_679 + tmp1_0;
    // Op 680: dim1x1 mul
    tmp1_6 = tmp1_4 * tmp1_0;
    // Op 681: dim1x1 add
    gl64_t s0_681 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_681 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_681 + s1_681;
    // Op 682: dim1x1 mul
    gl64_t s1_682 = *(gl64_t*)&expressions_params[9][69];
    tmp1_0 = tmp1_0 * s1_682;
    // Op 683: dim1x1 mul
    gl64_t s0_683 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_683 = *(gl64_t*)&expressions_params[9][70];
    tmp1_4 = s0_683 * s1_683;
    // Op 684: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 685: dim1x1 mul
    gl64_t s0_685 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_685 = *(gl64_t*)&expressions_params[9][71];
    tmp1_4 = s0_685 * s1_685;
    // Op 686: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 687: dim1x1 mul
    gl64_t s0_687 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_687 = *(gl64_t*)&expressions_params[9][72];
    tmp1_4 = s0_687 * s1_687;
    // Op 688: dim1x1 add
    tmp1_18 = tmp1_0 + tmp1_4;
    // Op 689: dim1x1 add
    gl64_t s0_689 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 36, domainSize, nCols_1))];
    tmp1_0 = s0_689 + tmp1_18;
    // Op 690: dim1x1 add
    gl64_t s0_690 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 36, domainSize, nCols_1))];
    tmp1_4 = s0_690 + tmp1_18;
    // Op 691: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_4;
    // Op 692: dim1x1 mul
    tmp1_4 = tmp1_0 * tmp1_0;
    // Op 693: dim1x1 mul
    tmp1_4 = tmp1_4 * tmp1_0;
    // Op 694: dim1x1 add
    gl64_t s0_694 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 36, domainSize, nCols_1))];
    tmp1_0 = s0_694 + tmp1_18;
    // Op 695: dim1x1 mul
    tmp1_0 = tmp1_4 * tmp1_0;
    // Op 696: dim1x1 add
    tmp1_0 = tmp1_6 + tmp1_0;
    // Op 697: dim1x1 add
    tmp1_21 = tmp1_11 + tmp1_0;
    // Op 698: dim1x1 mul
    gl64_t s1_698 = *(gl64_t*)&expressions_params[9][28];
    tmp1_6 = tmp1_0 * s1_698;
    // Op 699: dim1x1 add
    gl64_t s0_699 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 36, domainSize, nCols_1))];
    tmp1_18 = s0_699 + tmp1_18;
    // Op 700: dim1x1 mul
    tmp1_4 = tmp1_4 * tmp1_18;
    // Op 701: dim1x1 mul
    gl64_t s1_701 = *(gl64_t*)&expressions_params[9][27];
    tmp1_11 = tmp1_4 * s1_701;
    // Op 702: dim1x1 add
    gl64_t s0_702 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_702 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_4 = s0_702 + s1_702;
    // Op 703: dim1x1 mul
    gl64_t s1_703 = *(gl64_t*)&expressions_params[9][73];
    tmp1_4 = tmp1_4 * s1_703;
    // Op 704: dim1x1 mul
    gl64_t s0_704 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_704 = *(gl64_t*)&expressions_params[9][74];
    tmp1_18 = s0_704 * s1_704;
    // Op 705: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_18;
    // Op 706: dim1x1 mul
    gl64_t s0_706 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_706 = *(gl64_t*)&expressions_params[9][75];
    tmp1_18 = s0_706 * s1_706;
    // Op 707: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_18;
    // Op 708: dim1x1 mul
    gl64_t s0_708 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_708 = *(gl64_t*)&expressions_params[9][76];
    tmp1_18 = s0_708 * s1_708;
    // Op 709: dim1x1 add
    tmp1_0 = tmp1_4 + tmp1_18;
    // Op 710: dim1x1 add
    gl64_t s0_710 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_1))];
    tmp1_4 = s0_710 + tmp1_0;
    // Op 711: dim1x1 add
    gl64_t s0_711 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_1))];
    tmp1_18 = s0_711 + tmp1_0;
    // Op 712: dim1x1 mul
    tmp1_4 = tmp1_4 * tmp1_18;
    // Op 713: dim1x1 mul
    tmp1_18 = tmp1_4 * tmp1_4;
    // Op 714: dim1x1 mul
    tmp1_4 = tmp1_18 * tmp1_4;
    // Op 715: dim1x1 add
    gl64_t s0_715 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_1))];
    tmp1_0 = s0_715 + tmp1_0;
    // Op 716: dim1x1 mul
    tmp1_0 = tmp1_4 * tmp1_0;
    // Op 717: dim1x1 add
    gl64_t s0_717 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_1))];
    tmp1_1 = s0_717 + tmp1_1;
    // Op 718: dim1x1 mul
    tmp1_1 = tmp1_10 * tmp1_1;
    // Op 719: dim1x1 add
    tmp1_15 = tmp1_0 + tmp1_1;
    // Op 720: dim1x1 add
    tmp1_19 = tmp1_11 + tmp1_15;
    // Op 721: dim1x1 add
    tmp1_7 = tmp1_6 + tmp1_19;
    // Op 722: dim1x1 add
    tmp1_8 = tmp1_21 + tmp1_7;
    // Op 723: dim1x1 add
    tmp1_18 = tmp1_2 + tmp1_8;
    // Op 724: dim1x1 add
    gl64_t s0_724 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_724 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_2 = s0_724 + s1_724;
    // Op 725: dim1x1 mul
    gl64_t s1_725 = *(gl64_t*)&expressions_params[9][77];
    tmp1_2 = tmp1_2 * s1_725;
    // Op 726: dim1x1 mul
    gl64_t s0_726 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_726 = *(gl64_t*)&expressions_params[9][78];
    tmp1_6 = s0_726 * s1_726;
    // Op 727: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_6;
    // Op 728: dim1x1 mul
    gl64_t s0_728 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_728 = *(gl64_t*)&expressions_params[9][79];
    tmp1_6 = s0_728 * s1_728;
    // Op 729: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_6;
    // Op 730: dim1x1 mul
    gl64_t s0_730 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_730 = *(gl64_t*)&expressions_params[9][80];
    tmp1_6 = s0_730 * s1_730;
    // Op 731: dim1x1 add
    tmp1_10 = tmp1_2 + tmp1_6;
    // Op 732: dim1x1 add
    gl64_t s0_732 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 42, domainSize, nCols_1))];
    tmp1_2 = s0_732 + tmp1_10;
    // Op 733: dim1x1 add
    gl64_t s0_733 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 42, domainSize, nCols_1))];
    tmp1_6 = s0_733 + tmp1_10;
    // Op 734: dim1x1 mul
    tmp1_2 = tmp1_2 * tmp1_6;
    // Op 735: dim1x1 mul
    tmp1_6 = tmp1_2 * tmp1_2;
    // Op 736: dim1x1 mul
    tmp1_4 = tmp1_6 * tmp1_2;
    // Op 737: dim1x1 add
    gl64_t s0_737 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 42, domainSize, nCols_1))];
    tmp1_2 = s0_737 + tmp1_10;
    // Op 738: dim1x1 mul
    tmp1_2 = tmp1_4 * tmp1_2;
    // Op 739: dim1x1 mul
    gl64_t s1_739 = *(gl64_t*)&expressions_params[9][27];
    tmp1_0 = tmp1_2 * s1_739;
    // Op 740: dim1x1 add
    gl64_t s0_740 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_740 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_2 = s0_740 + s1_740;
    // Op 741: dim1x1 mul
    gl64_t s1_741 = *(gl64_t*)&expressions_params[9][81];
    tmp1_2 = tmp1_2 * s1_741;
    // Op 742: dim1x1 mul
    gl64_t s0_742 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_742 = *(gl64_t*)&expressions_params[9][82];
    tmp1_6 = s0_742 * s1_742;
    // Op 743: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_6;
    // Op 744: dim1x1 mul
    gl64_t s0_744 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_744 = *(gl64_t*)&expressions_params[9][83];
    tmp1_6 = s0_744 * s1_744;
    // Op 745: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_6;
    // Op 746: dim1x1 mul
    gl64_t s0_746 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_746 = *(gl64_t*)&expressions_params[9][84];
    tmp1_6 = s0_746 * s1_746;
    // Op 747: dim1x1 add
    tmp1_11 = tmp1_2 + tmp1_6;
    // Op 748: dim1x1 add
    gl64_t s0_748 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_1))];
    tmp1_2 = s0_748 + tmp1_11;
    // Op 749: dim1x1 add
    gl64_t s0_749 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_1))];
    tmp1_6 = s0_749 + tmp1_11;
    // Op 750: dim1x1 mul
    tmp1_2 = tmp1_2 * tmp1_6;
    // Op 751: dim1x1 mul
    tmp1_6 = tmp1_2 * tmp1_2;
    // Op 752: dim1x1 mul
    tmp1_2 = tmp1_6 * tmp1_2;
    // Op 753: dim1x1 add
    gl64_t s0_753 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_1))];
    tmp1_11 = s0_753 + tmp1_11;
    // Op 754: dim1x1 mul
    tmp1_6 = tmp1_2 * tmp1_11;
    // Op 755: dim1x1 add
    gl64_t s0_755 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_755 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_2 = s0_755 + s1_755;
    // Op 756: dim1x1 mul
    gl64_t s1_756 = *(gl64_t*)&expressions_params[9][85];
    tmp1_2 = tmp1_2 * s1_756;
    // Op 757: dim1x1 mul
    gl64_t s0_757 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_757 = *(gl64_t*)&expressions_params[9][86];
    tmp1_11 = s0_757 * s1_757;
    // Op 758: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_11;
    // Op 759: dim1x1 mul
    gl64_t s0_759 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_759 = *(gl64_t*)&expressions_params[9][87];
    tmp1_11 = s0_759 * s1_759;
    // Op 760: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_11;
    // Op 761: dim1x1 mul
    gl64_t s0_761 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_761 = *(gl64_t*)&expressions_params[9][88];
    tmp1_11 = s0_761 * s1_761;
    // Op 762: dim1x1 add
    tmp1_1 = tmp1_2 + tmp1_11;
    // Op 763: dim1x1 add
    gl64_t s0_763 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_1))];
    tmp1_2 = s0_763 + tmp1_1;
    // Op 764: dim1x1 add
    gl64_t s0_764 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_1))];
    tmp1_11 = s0_764 + tmp1_1;
    // Op 765: dim1x1 mul
    tmp1_2 = tmp1_2 * tmp1_11;
    // Op 766: dim1x1 mul
    tmp1_11 = tmp1_2 * tmp1_2;
    // Op 767: dim1x1 mul
    tmp1_11 = tmp1_11 * tmp1_2;
    // Op 768: dim1x1 add
    gl64_t s0_768 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_1))];
    tmp1_2 = s0_768 + tmp1_1;
    // Op 769: dim1x1 mul
    tmp1_2 = tmp1_11 * tmp1_2;
    // Op 770: dim1x1 add
    tmp1_2 = tmp1_6 + tmp1_2;
    // Op 771: dim1x1 add
    tmp1_14 = tmp1_0 + tmp1_2;
    // Op 772: dim1x1 mul
    gl64_t s1_772 = *(gl64_t*)&expressions_params[9][28];
    tmp1_6 = tmp1_2 * s1_772;
    // Op 773: dim1x1 add
    gl64_t s0_773 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_1))];
    tmp1_1 = s0_773 + tmp1_1;
    // Op 774: dim1x1 mul
    tmp1_1 = tmp1_11 * tmp1_1;
    // Op 775: dim1x1 mul
    gl64_t s1_775 = *(gl64_t*)&expressions_params[9][27];
    tmp1_0 = tmp1_1 * s1_775;
    // Op 776: dim1x1 add
    gl64_t s0_776 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_776 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_1 = s0_776 + s1_776;
    // Op 777: dim1x1 mul
    gl64_t s1_777 = *(gl64_t*)&expressions_params[9][89];
    tmp1_1 = tmp1_1 * s1_777;
    // Op 778: dim1x1 mul
    gl64_t s0_778 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_778 = *(gl64_t*)&expressions_params[9][90];
    tmp1_11 = s0_778 * s1_778;
    // Op 779: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_11;
    // Op 780: dim1x1 mul
    gl64_t s0_780 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_780 = *(gl64_t*)&expressions_params[9][91];
    tmp1_11 = s0_780 * s1_780;
    // Op 781: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_11;
    // Op 782: dim1x1 mul
    gl64_t s0_782 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_782 = *(gl64_t*)&expressions_params[9][92];
    tmp1_11 = s0_782 * s1_782;
    // Op 783: dim1x1 add
    tmp1_2 = tmp1_1 + tmp1_11;
    // Op 784: dim1x1 add
    gl64_t s0_784 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 41, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 41, domainSize, nCols_1))];
    tmp1_1 = s0_784 + tmp1_2;
    // Op 785: dim1x1 add
    gl64_t s0_785 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 41, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 41, domainSize, nCols_1))];
    tmp1_11 = s0_785 + tmp1_2;
    // Op 786: dim1x1 mul
    tmp1_1 = tmp1_1 * tmp1_11;
    // Op 787: dim1x1 mul
    tmp1_11 = tmp1_1 * tmp1_1;
    // Op 788: dim1x1 mul
    tmp1_1 = tmp1_11 * tmp1_1;
    // Op 789: dim1x1 add
    gl64_t s0_789 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 41, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 41, domainSize, nCols_1))];
    tmp1_2 = s0_789 + tmp1_2;
    // Op 790: dim1x1 mul
    tmp1_1 = tmp1_1 * tmp1_2;
    // Op 791: dim1x1 add
    gl64_t s0_791 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 42, domainSize, nCols_1))];
    tmp1_10 = s0_791 + tmp1_10;
    // Op 792: dim1x1 mul
    tmp1_4 = tmp1_4 * tmp1_10;
    // Op 793: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_4;
    // Op 794: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 795: dim1x1 add
    tmp1_4 = tmp1_6 + tmp1_0;
    // Op 796: dim1x1 add
    tmp1_6 = tmp1_14 + tmp1_4;
    // Op 797: dim1x1 add
    tmp1_18 = tmp1_18 + tmp1_6;
    // Op 798: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_18;
    // Op 799: dim1x1 sub
    gl64_t s0_799 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 43, domainSize, nCols_1))];
    tmp1_5 = s0_799 - tmp1_5;
    // Op 800: dim1x1 mul
    tmp1_5 = tmp1_13 * tmp1_5;
    // Op 801: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_5; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 802: dim3x3 mul
    gl64_t s1_802_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_802_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_802_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 803: dim1x1 add
    gl64_t s0_803 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_803 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_5 = s0_803 + s1_803;
    // Op 804: dim1x1 add
    gl64_t s0_804 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_5 = s0_804 + tmp1_5;
    // Op 805: dim1x1 add
    gl64_t s0_805 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_5 = s0_805 + tmp1_5;
    // Op 806: dim1x1 add
    gl64_t s0_806 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_13 = s0_806 + tmp1_5;
    // Op 807: dim1x1 add
    tmp1_5 = tmp1_20 + tmp1_9;
    // Op 808: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_7;
    // Op 809: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_4;
    // Op 810: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_5;
    // Op 811: dim1x1 sub
    gl64_t s0_811 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_1))];
    tmp1_20 = s0_811 - tmp1_20;
    // Op 812: dim1x1 mul
    tmp1_13 = tmp1_13 * tmp1_20;
    // Op 813: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_13; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 814: dim3x3 mul
    gl64_t s1_814_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_814_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_814_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA814 = (tmp3_0 + tmp3_1) * (s1_814_0 + s1_814_1);
    gl64_t kB814 = (tmp3_0 + tmp3_2) * (s1_814_0 + s1_814_2);
    gl64_t kC814 = (tmp3_1 + tmp3_2) * (s1_814_1 + s1_814_2);
    gl64_t kD814 = tmp3_0 * s1_814_0;
    gl64_t kE814 = tmp3_1 * s1_814_1;
    gl64_t kF814 = tmp3_2 * s1_814_2;
    gl64_t kG814 = kD814 - kE814;
    tmp3_0 = (kC814 + kG814) - kF814;
    tmp3_1 = ((((kA814 + kC814) - kE814) - kE814) - kD814);
    tmp3_2 = kB814 - kG814;
    // Op 815: dim1x1 add
    gl64_t s0_815 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_815 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_13 = s0_815 + s1_815;
    // Op 816: dim1x1 add
    gl64_t s0_816 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_13 = s0_816 + tmp1_13;
    // Op 817: dim1x1 add
    gl64_t s0_817 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_13 = s0_817 + tmp1_13;
    // Op 818: dim1x1 add
    gl64_t s0_818 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_13 = s0_818 + tmp1_13;
    // Op 819: dim1x1 mul
    gl64_t s1_819 = *(gl64_t*)&expressions_params[9][28];
    tmp1_25 = tmp1_25 * s1_819;
    // Op 820: dim1x1 add
    tmp1_24 = tmp1_25 + tmp1_24;
    // Op 821: dim1x1 add
    tmp1_17 = tmp1_17 + tmp1_24;
    // Op 822: dim1x1 mul
    gl64_t s1_822 = *(gl64_t*)&expressions_params[9][28];
    tmp1_16 = tmp1_16 * s1_822;
    // Op 823: dim1x1 add
    tmp1_23 = tmp1_16 + tmp1_23;
    // Op 824: dim1x1 add
    tmp1_16 = tmp1_22 + tmp1_23;
    // Op 825: dim1x1 add
    tmp1_22 = tmp1_17 + tmp1_16;
    // Op 826: dim1x1 mul
    gl64_t s1_826 = *(gl64_t*)&expressions_params[9][28];
    tmp1_15 = tmp1_15 * s1_826;
    // Op 827: dim1x1 add
    tmp1_15 = tmp1_15 + tmp1_21;
    // Op 828: dim1x1 add
    tmp1_19 = tmp1_19 + tmp1_15;
    // Op 829: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_19;
    // Op 830: dim1x1 mul
    gl64_t s1_830 = *(gl64_t*)&expressions_params[9][28];
    tmp1_1 = tmp1_1 * s1_830;
    // Op 831: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_14;
    // Op 832: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 833: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_0;
    // Op 834: dim1x1 add
    tmp1_17 = tmp1_17 + tmp1_22;
    // Op 835: dim1x1 sub
    gl64_t s0_835 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_1))];
    tmp1_17 = s0_835 - tmp1_17;
    // Op 836: dim1x1 mul
    tmp1_13 = tmp1_13 * tmp1_17;
    // Op 837: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_13; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC838 + kG838) - kF838;
    tmp3_1 = ((((kA838 + kC838) - kE838) - kE838) - kD838);
    tmp3_2 = kB838 - kG838;
    // Op 839: dim1x1 add
    gl64_t s0_839 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_839 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_13 = s0_839 + s1_839;
    // Op 840: dim1x1 add
    gl64_t s0_840 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_13 = s0_840 + tmp1_13;
    // Op 841: dim1x1 add
    gl64_t s0_841 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_13 = s0_841 + tmp1_13;
    // Op 842: dim1x1 add
    gl64_t s0_842 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_17 = s0_842 + tmp1_13;
    // Op 843: dim1x1 add
    tmp1_13 = tmp1_24 + tmp1_23;
    // Op 844: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_15;
    // Op 845: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_1;
    // Op 846: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_13;
    // Op 847: dim1x1 sub
    gl64_t s0_847 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 46, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 46, domainSize, nCols_1))];
    tmp1_24 = s0_847 - tmp1_24;
    // Op 848: dim1x1 mul
    tmp1_17 = tmp1_17 * tmp1_24;
    // Op 849: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_17; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 850: dim3x3 mul
    gl64_t s1_850_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_850_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_850_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 851: dim1x1 add
    gl64_t s0_851 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_851 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_17 = s0_851 + s1_851;
    // Op 852: dim1x1 add
    gl64_t s0_852 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_17 = s0_852 + tmp1_17;
    // Op 853: dim1x1 add
    gl64_t s0_853 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_17 = s0_853 + tmp1_17;
    // Op 854: dim1x1 add
    gl64_t s0_854 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_17 = s0_854 + tmp1_17;
    // Op 855: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_18;
    // Op 856: dim1x1 sub
    gl64_t s0_856 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_1))];
    tmp1_12 = s0_856 - tmp1_12;
    // Op 857: dim1x1 mul
    tmp1_12 = tmp1_17 * tmp1_12;
    // Op 858: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_12; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 859: dim3x3 mul
    gl64_t s1_859_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_859_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_859_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA859 = (tmp3_0 + tmp3_1) * (s1_859_0 + s1_859_1);
    gl64_t kB859 = (tmp3_0 + tmp3_2) * (s1_859_0 + s1_859_2);
    gl64_t kC859 = (tmp3_1 + tmp3_2) * (s1_859_1 + s1_859_2);
    gl64_t kD859 = tmp3_0 * s1_859_0;
    gl64_t kE859 = tmp3_1 * s1_859_1;
    gl64_t kF859 = tmp3_2 * s1_859_2;
    gl64_t kG859 = kD859 - kE859;
    tmp3_0 = (kC859 + kG859) - kF859;
    tmp3_1 = ((((kA859 + kC859) - kE859) - kE859) - kD859);
    tmp3_2 = kB859 - kG859;
    // Op 860: dim1x1 add
    gl64_t s0_860 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_860 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_12 = s0_860 + s1_860;
    // Op 861: dim1x1 add
    gl64_t s0_861 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_12 = s0_861 + tmp1_12;
    // Op 862: dim1x1 add
    gl64_t s0_862 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_12 = s0_862 + tmp1_12;
    // Op 863: dim1x1 add
    gl64_t s0_863 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_12 = s0_863 + tmp1_12;
    // Op 864: dim1x1 add
    tmp1_9 = tmp1_9 + tmp1_5;
    // Op 865: dim1x1 sub
    gl64_t s0_865 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 48, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 48, domainSize, nCols_1))];
    tmp1_9 = s0_865 - tmp1_9;
    // Op 866: dim1x1 mul
    tmp1_9 = tmp1_12 * tmp1_9;
    // Op 867: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_9; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 868: dim3x3 mul
    gl64_t s1_868_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_868_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_868_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA868 = (tmp3_0 + tmp3_1) * (s1_868_0 + s1_868_1);
    gl64_t kB868 = (tmp3_0 + tmp3_2) * (s1_868_0 + s1_868_2);
    gl64_t kC868 = (tmp3_1 + tmp3_2) * (s1_868_1 + s1_868_2);
    gl64_t kD868 = tmp3_0 * s1_868_0;
    gl64_t kE868 = tmp3_1 * s1_868_1;
    gl64_t kF868 = tmp3_2 * s1_868_2;
    gl64_t kG868 = kD868 - kE868;
    tmp3_0 = (kC868 + kG868) - kF868;
    tmp3_1 = ((((kA868 + kC868) - kE868) - kE868) - kD868);
    tmp3_2 = kB868 - kG868;
    // Op 869: dim1x1 add
    gl64_t s0_869 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_869 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_9 = s0_869 + s1_869;
    // Op 870: dim1x1 add
    gl64_t s0_870 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_9 = s0_870 + tmp1_9;
    // Op 871: dim1x1 add
    gl64_t s0_871 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_9 = s0_871 + tmp1_9;
    // Op 872: dim1x1 add
    gl64_t s0_872 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_9 = s0_872 + tmp1_9;
    // Op 873: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_22;
    // Op 874: dim1x1 sub
    gl64_t s0_874 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 49, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 49, domainSize, nCols_1))];
    tmp1_16 = s0_874 - tmp1_16;
    // Op 875: dim1x1 mul
    tmp1_9 = tmp1_9 * tmp1_16;
    // Op 876: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_9; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC877 + kG877) - kF877;
    tmp3_1 = ((((kA877 + kC877) - kE877) - kE877) - kD877);
    tmp3_2 = kB877 - kG877;
    // Op 878: dim1x1 add
    gl64_t s0_878 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_878 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_9 = s0_878 + s1_878;
    // Op 879: dim1x1 add
    gl64_t s0_879 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_9 = s0_879 + tmp1_9;
    // Op 880: dim1x1 add
    gl64_t s0_880 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_9 = s0_880 + tmp1_9;
    // Op 881: dim1x1 add
    gl64_t s0_881 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_9 = s0_881 + tmp1_9;
    // Op 882: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_13;
    // Op 883: dim1x1 sub
    gl64_t s0_883 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 50, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 50, domainSize, nCols_1))];
    tmp1_23 = s0_883 - tmp1_23;
    // Op 884: dim1x1 mul
    tmp1_9 = tmp1_9 * tmp1_23;
    // Op 885: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_9; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC886 + kG886) - kF886;
    tmp3_1 = ((((kA886 + kC886) - kE886) - kE886) - kD886);
    tmp3_2 = kB886 - kG886;
    // Op 887: dim1x1 add
    gl64_t s0_887 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_887 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_9 = s0_887 + s1_887;
    // Op 888: dim1x1 add
    gl64_t s0_888 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_9 = s0_888 + tmp1_9;
    // Op 889: dim1x1 add
    gl64_t s0_889 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_9 = s0_889 + tmp1_9;
    // Op 890: dim1x1 add
    gl64_t s0_890 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_9 = s0_890 + tmp1_9;
    // Op 891: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_18;
    // Op 892: dim1x1 sub
    gl64_t s0_892 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 51, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 51, domainSize, nCols_1))];
    tmp1_8 = s0_892 - tmp1_8;
    // Op 893: dim1x1 mul
    tmp1_8 = tmp1_9 * tmp1_8;
    // Op 894: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_8; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 895: dim3x3 mul
    gl64_t s1_895_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_895_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_895_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 896: dim1x1 add
    gl64_t s0_896 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_896 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_8 = s0_896 + s1_896;
    // Op 897: dim1x1 add
    gl64_t s0_897 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_8 = s0_897 + tmp1_8;
    // Op 898: dim1x1 add
    gl64_t s0_898 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_8 = s0_898 + tmp1_8;
    // Op 899: dim1x1 add
    gl64_t s0_899 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_8 = s0_899 + tmp1_8;
    // Op 900: dim1x1 add
    tmp1_7 = tmp1_7 + tmp1_5;
    // Op 901: dim1x1 sub
    gl64_t s0_901 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 52, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 52, domainSize, nCols_1))];
    tmp1_7 = s0_901 - tmp1_7;
    // Op 902: dim1x1 mul
    tmp1_7 = tmp1_8 * tmp1_7;
    // Op 903: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_7; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 904: dim3x3 mul
    gl64_t s1_904_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_904_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_904_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA904 = (tmp3_0 + tmp3_1) * (s1_904_0 + s1_904_1);
    gl64_t kB904 = (tmp3_0 + tmp3_2) * (s1_904_0 + s1_904_2);
    gl64_t kC904 = (tmp3_1 + tmp3_2) * (s1_904_1 + s1_904_2);
    gl64_t kD904 = tmp3_0 * s1_904_0;
    gl64_t kE904 = tmp3_1 * s1_904_1;
    gl64_t kF904 = tmp3_2 * s1_904_2;
    gl64_t kG904 = kD904 - kE904;
    tmp3_0 = (kC904 + kG904) - kF904;
    tmp3_1 = ((((kA904 + kC904) - kE904) - kE904) - kD904);
    tmp3_2 = kB904 - kG904;
    // Op 905: dim1x1 add
    gl64_t s0_905 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_905 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_7 = s0_905 + s1_905;
    // Op 906: dim1x1 add
    gl64_t s0_906 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_7 = s0_906 + tmp1_7;
    // Op 907: dim1x1 add
    gl64_t s0_907 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_7 = s0_907 + tmp1_7;
    // Op 908: dim1x1 add
    gl64_t s0_908 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_7 = s0_908 + tmp1_7;
    // Op 909: dim1x1 add
    tmp1_19 = tmp1_19 + tmp1_22;
    // Op 910: dim1x1 sub
    gl64_t s0_910 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 53, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 53, domainSize, nCols_1))];
    tmp1_19 = s0_910 - tmp1_19;
    // Op 911: dim1x1 mul
    tmp1_7 = tmp1_7 * tmp1_19;
    // Op 912: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_7; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 913: dim3x3 mul
    gl64_t s1_913_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_913_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_913_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA913 = (tmp3_0 + tmp3_1) * (s1_913_0 + s1_913_1);
    gl64_t kB913 = (tmp3_0 + tmp3_2) * (s1_913_0 + s1_913_2);
    gl64_t kC913 = (tmp3_1 + tmp3_2) * (s1_913_1 + s1_913_2);
    gl64_t kD913 = tmp3_0 * s1_913_0;
    gl64_t kE913 = tmp3_1 * s1_913_1;
    gl64_t kF913 = tmp3_2 * s1_913_2;
    gl64_t kG913 = kD913 - kE913;
    tmp3_0 = (kC913 + kG913) - kF913;
    tmp3_1 = ((((kA913 + kC913) - kE913) - kE913) - kD913);
    tmp3_2 = kB913 - kG913;
    // Op 914: dim1x1 add
    gl64_t s0_914 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_914 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_7 = s0_914 + s1_914;
    // Op 915: dim1x1 add
    gl64_t s0_915 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_7 = s0_915 + tmp1_7;
    // Op 916: dim1x1 add
    gl64_t s0_916 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_7 = s0_916 + tmp1_7;
    // Op 917: dim1x1 add
    gl64_t s0_917 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_7 = s0_917 + tmp1_7;
    // Op 918: dim1x1 add
    tmp1_15 = tmp1_15 + tmp1_13;
    // Op 919: dim1x1 sub
    gl64_t s0_919 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 54, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 54, domainSize, nCols_1))];
    tmp1_15 = s0_919 - tmp1_15;
    // Op 920: dim1x1 mul
    tmp1_7 = tmp1_7 * tmp1_15;
    // Op 921: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_7; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC922 + kG922) - kF922;
    tmp3_1 = ((((kA922 + kC922) - kE922) - kE922) - kD922);
    tmp3_2 = kB922 - kG922;
    // Op 923: dim1x1 add
    gl64_t s0_923 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_923 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_7 = s0_923 + s1_923;
    // Op 924: dim1x1 add
    gl64_t s0_924 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_7 = s0_924 + tmp1_7;
    // Op 925: dim1x1 add
    gl64_t s0_925 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_7 = s0_925 + tmp1_7;
    // Op 926: dim1x1 add
    gl64_t s0_926 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_7 = s0_926 + tmp1_7;
    // Op 927: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_18;
    // Op 928: dim1x1 sub
    gl64_t s0_928 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 55, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 55, domainSize, nCols_1))];
    tmp1_6 = s0_928 - tmp1_6;
    // Op 929: dim1x1 mul
    tmp1_6 = tmp1_7 * tmp1_6;
    // Op 930: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_6; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC931 + kG931) - kF931;
    tmp3_1 = ((((kA931 + kC931) - kE931) - kE931) - kD931);
    tmp3_2 = kB931 - kG931;
    // Op 932: dim1x1 add
    gl64_t s0_932 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_932 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_6 = s0_932 + s1_932;
    // Op 933: dim1x1 add
    gl64_t s0_933 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_6 = s0_933 + tmp1_6;
    // Op 934: dim1x1 add
    gl64_t s0_934 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_6 = s0_934 + tmp1_6;
    // Op 935: dim1x1 add
    gl64_t s0_935 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_6 = s0_935 + tmp1_6;
    // Op 936: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_5;
    // Op 937: dim1x1 sub
    gl64_t s0_937 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 56, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 56, domainSize, nCols_1))];
    tmp1_4 = s0_937 - tmp1_4;
    // Op 938: dim1x1 mul
    tmp1_4 = tmp1_6 * tmp1_4;
    // Op 939: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 940: dim3x3 mul
    gl64_t s1_940_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_940_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_940_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 941: dim1x1 add
    gl64_t s0_941 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_941 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_4 = s0_941 + s1_941;
    // Op 942: dim1x1 add
    gl64_t s0_942 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_4 = s0_942 + tmp1_4;
    // Op 943: dim1x1 add
    gl64_t s0_943 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_4 = s0_943 + tmp1_4;
    // Op 944: dim1x1 add
    gl64_t s0_944 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_4 = s0_944 + tmp1_4;
    // Op 945: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_22;
    // Op 946: dim1x1 sub
    gl64_t s0_946 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 57, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 57, domainSize, nCols_1))];
    tmp1_0 = s0_946 - tmp1_0;
    // Op 947: dim1x1 mul
    tmp1_0 = tmp1_4 * tmp1_0;
    // Op 948: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 949: dim3x3 mul
    gl64_t s1_949_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_949_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_949_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA949 = (tmp3_0 + tmp3_1) * (s1_949_0 + s1_949_1);
    gl64_t kB949 = (tmp3_0 + tmp3_2) * (s1_949_0 + s1_949_2);
    gl64_t kC949 = (tmp3_1 + tmp3_2) * (s1_949_1 + s1_949_2);
    gl64_t kD949 = tmp3_0 * s1_949_0;
    gl64_t kE949 = tmp3_1 * s1_949_1;
    gl64_t kF949 = tmp3_2 * s1_949_2;
    gl64_t kG949 = kD949 - kE949;
    tmp3_0 = (kC949 + kG949) - kF949;
    tmp3_1 = ((((kA949 + kC949) - kE949) - kE949) - kD949);
    tmp3_2 = kB949 - kG949;
    // Op 950: dim1x1 add
    gl64_t s0_950 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_950 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_950 + s1_950;
    // Op 951: dim1x1 add
    gl64_t s0_951 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_0 = s0_951 + tmp1_0;
    // Op 952: dim1x1 add
    gl64_t s0_952 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_0 = s0_952 + tmp1_0;
    // Op 953: dim1x1 add
    gl64_t s0_953 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_0 = s0_953 + tmp1_0;
    // Op 954: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_13;
    // Op 955: dim1x1 sub
    gl64_t s0_955 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 58, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 58, domainSize, nCols_1))];
    tmp1_1 = s0_955 - tmp1_1;
    // Op 956: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 957: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 958: dim3x3 mul
    gl64_t s1_958_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_958_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_958_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA958 = (tmp3_0 + tmp3_1) * (s1_958_0 + s1_958_1);
    gl64_t kB958 = (tmp3_0 + tmp3_2) * (s1_958_0 + s1_958_2);
    gl64_t kC958 = (tmp3_1 + tmp3_2) * (s1_958_1 + s1_958_2);
    gl64_t kD958 = tmp3_0 * s1_958_0;
    gl64_t kE958 = tmp3_1 * s1_958_1;
    gl64_t kF958 = tmp3_2 * s1_958_2;
    gl64_t kG958 = kD958 - kE958;
    tmp3_0 = (kC958 + kG958) - kF958;
    tmp3_1 = ((((kA958 + kC958) - kE958) - kE958) - kD958);
    tmp3_2 = kB958 - kG958;
    // Op 959: dim1x1 add
    gl64_t s0_959 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_959 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_959 + s1_959;
    // Op 960: dim1x1 add
    gl64_t s0_960 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_0 = s0_960 + tmp1_0;
    // Op 961: dim1x1 add
    gl64_t s0_961 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_0 = s0_961 + tmp1_0;
    // Op 962: dim1x1 add
    gl64_t s0_962 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_7 = s0_962 + tmp1_0;
    // Op 963: dim1x1 mul
    gl64_t s0_963 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_963 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_1))];
    tmp1_1 = s0_963 * s1_963;
    // Op 964: dim1x1 sub_swap
    gl64_t s0_964 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_964 = *(gl64_t*)&expressions_params[9][26];
    tmp1_0 = s1_964 - s0_964;
    // Op 965: dim1x1 mul
    gl64_t s0_965 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 27, domainSize, nCols_1))];
    tmp1_0 = s0_965 * tmp1_0;
    // Op 966: dim1x1 add
    tmp1_5 = tmp1_1 + tmp1_0;
    // Op 967: dim1x1 add
    gl64_t s0_967 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_967 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_967 + s1_967;
    // Op 968: dim1x1 mul
    gl64_t s1_968 = *(gl64_t*)&expressions_params[9][93];
    tmp1_0 = tmp1_0 * s1_968;
    // Op 969: dim1x1 mul
    gl64_t s0_969 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_969 = *(gl64_t*)&expressions_params[9][94];
    tmp1_1 = s0_969 * s1_969;
    // Op 970: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 971: dim1x1 mul
    gl64_t s0_971 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_971 = *(gl64_t*)&expressions_params[9][95];
    tmp1_1 = s0_971 * s1_971;
    // Op 972: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 973: dim1x1 mul
    gl64_t s0_973 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_973 = *(gl64_t*)&expressions_params[9][96];
    tmp1_1 = s0_973 * s1_973;
    // Op 974: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 975: dim1x1 mul
    gl64_t s0_975 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    gl64_t s1_975 = *(gl64_t*)&expressions_params[9][97];
    tmp1_1 = s0_975 * s1_975;
    // Op 976: dim1x1 add
    tmp1_29 = tmp1_0 + tmp1_1;
    // Op 977: dim1x1 add
    gl64_t s0_977 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 46, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 46, domainSize, nCols_1))];
    tmp1_0 = s0_977 + tmp1_29;
    // Op 978: dim1x1 add
    gl64_t s0_978 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 46, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 46, domainSize, nCols_1))];
    tmp1_1 = s0_978 + tmp1_29;
    // Op 979: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 980: dim1x1 mul
    tmp1_1 = tmp1_0 * tmp1_0;
    // Op 981: dim1x1 mul
    tmp1_30 = tmp1_1 * tmp1_0;
    // Op 982: dim1x1 add
    gl64_t s0_982 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 46, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 46, domainSize, nCols_1))];
    tmp1_0 = s0_982 + tmp1_29;
    // Op 983: dim1x1 mul
    tmp1_0 = tmp1_30 * tmp1_0;
    // Op 984: dim1x1 mul
    gl64_t s1_984 = *(gl64_t*)&expressions_params[9][27];
    tmp1_4 = tmp1_0 * s1_984;
    // Op 985: dim1x1 add
    gl64_t s0_985 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_985 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_985 + s1_985;
    // Op 986: dim1x1 mul
    gl64_t s1_986 = *(gl64_t*)&expressions_params[9][98];
    tmp1_0 = tmp1_0 * s1_986;
    // Op 987: dim1x1 mul
    gl64_t s0_987 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_987 = *(gl64_t*)&expressions_params[9][99];
    tmp1_1 = s0_987 * s1_987;
    // Op 988: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 989: dim1x1 mul
    gl64_t s0_989 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_989 = *(gl64_t*)&expressions_params[9][100];
    tmp1_1 = s0_989 * s1_989;
    // Op 990: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 991: dim1x1 mul
    gl64_t s0_991 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_991 = *(gl64_t*)&expressions_params[9][101];
    tmp1_1 = s0_991 * s1_991;
    // Op 992: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 993: dim1x1 mul
    gl64_t s0_993 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    gl64_t s1_993 = *(gl64_t*)&expressions_params[9][102];
    tmp1_1 = s0_993 * s1_993;
    // Op 994: dim1x1 add
    tmp1_2 = tmp1_0 + tmp1_1;
    // Op 995: dim1x1 add
    gl64_t s0_995 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 43, domainSize, nCols_1))];
    tmp1_0 = s0_995 + tmp1_2;
    // Op 996: dim1x1 add
    gl64_t s0_996 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 43, domainSize, nCols_1))];
    tmp1_1 = s0_996 + tmp1_2;
    // Op 997: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 998: dim1x1 mul
    tmp1_1 = tmp1_0 * tmp1_0;
    // Op 999: dim1x1 mul
    tmp1_11 = tmp1_1 * tmp1_0;
    // Op 1000: dim1x1 add
    gl64_t s0_1000 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 43, domainSize, nCols_1))];
    tmp1_0 = s0_1000 + tmp1_2;
    // Op 1001: dim1x1 mul
    tmp1_13 = tmp1_11 * tmp1_0;
    // Op 1002: dim1x1 add
    gl64_t s0_1002 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1002 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_1002 + s1_1002;
    // Op 1003: dim1x1 mul
    gl64_t s1_1003 = *(gl64_t*)&expressions_params[9][103];
    tmp1_0 = tmp1_0 * s1_1003;
    // Op 1004: dim1x1 mul
    gl64_t s0_1004 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_1004 = *(gl64_t*)&expressions_params[9][104];
    tmp1_1 = s0_1004 * s1_1004;
    // Op 1005: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 1006: dim1x1 mul
    gl64_t s0_1006 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_1006 = *(gl64_t*)&expressions_params[9][105];
    tmp1_1 = s0_1006 * s1_1006;
    // Op 1007: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 1008: dim1x1 mul
    gl64_t s0_1008 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1008 = *(gl64_t*)&expressions_params[9][106];
    tmp1_1 = s0_1008 * s1_1008;
    // Op 1009: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 1010: dim1x1 mul
    gl64_t s0_1010 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    gl64_t s1_1010 = *(gl64_t*)&expressions_params[9][107];
    tmp1_1 = s0_1010 * s1_1010;
    // Op 1011: dim1x1 add
    tmp1_3 = tmp1_0 + tmp1_1;
    // Op 1012: dim1x1 add
    gl64_t s0_1012 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_1))];
    tmp1_0 = s0_1012 + tmp1_3;
    // Op 1013: dim1x1 add
    gl64_t s0_1013 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_1))];
    tmp1_1 = s0_1013 + tmp1_3;
    // Op 1014: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 1015: dim1x1 mul
    tmp1_1 = tmp1_0 * tmp1_0;
    // Op 1016: dim1x1 mul
    tmp1_26 = tmp1_1 * tmp1_0;
    // Op 1017: dim1x1 add
    gl64_t s0_1017 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_1))];
    tmp1_0 = s0_1017 + tmp1_3;
    // Op 1018: dim1x1 mul
    tmp1_0 = tmp1_26 * tmp1_0;
    // Op 1019: dim1x1 add
    tmp1_0 = tmp1_13 + tmp1_0;
    // Op 1020: dim1x1 add
    tmp1_19 = tmp1_4 + tmp1_0;
    // Op 1021: dim1x1 mul
    gl64_t s1_1021 = *(gl64_t*)&expressions_params[9][28];
    tmp1_1 = tmp1_0 * s1_1021;
    // Op 1022: dim1x1 add
    gl64_t s0_1022 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_1))];
    tmp1_0 = s0_1022 + tmp1_3;
    // Op 1023: dim1x1 mul
    tmp1_0 = tmp1_26 * tmp1_0;
    // Op 1024: dim1x1 mul
    gl64_t s1_1024 = *(gl64_t*)&expressions_params[9][27];
    tmp1_13 = tmp1_0 * s1_1024;
    // Op 1025: dim1x1 add
    gl64_t s0_1025 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1025 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_1025 + s1_1025;
    // Op 1026: dim1x1 mul
    gl64_t s1_1026 = *(gl64_t*)&expressions_params[9][108];
    tmp1_0 = tmp1_0 * s1_1026;
    // Op 1027: dim1x1 mul
    gl64_t s0_1027 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_1027 = *(gl64_t*)&expressions_params[9][109];
    tmp1_4 = s0_1027 * s1_1027;
    // Op 1028: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 1029: dim1x1 mul
    gl64_t s0_1029 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_1029 = *(gl64_t*)&expressions_params[9][110];
    tmp1_4 = s0_1029 * s1_1029;
    // Op 1030: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 1031: dim1x1 mul
    gl64_t s0_1031 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1031 = *(gl64_t*)&expressions_params[9][111];
    tmp1_4 = s0_1031 * s1_1031;
    // Op 1032: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 1033: dim1x1 mul
    gl64_t s0_1033 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    gl64_t s1_1033 = *(gl64_t*)&expressions_params[9][112];
    tmp1_4 = s0_1033 * s1_1033;
    // Op 1034: dim1x1 add
    tmp1_27 = tmp1_0 + tmp1_4;
    // Op 1035: dim1x1 add
    gl64_t s0_1035 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_1))];
    tmp1_0 = s0_1035 + tmp1_27;
    // Op 1036: dim1x1 add
    gl64_t s0_1036 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_1))];
    tmp1_4 = s0_1036 + tmp1_27;
    // Op 1037: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_4;
    // Op 1038: dim1x1 mul
    tmp1_4 = tmp1_0 * tmp1_0;
    // Op 1039: dim1x1 mul
    tmp1_28 = tmp1_4 * tmp1_0;
    // Op 1040: dim1x1 add
    gl64_t s0_1040 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_1))];
    tmp1_0 = s0_1040 + tmp1_27;
    // Op 1041: dim1x1 mul
    tmp1_4 = tmp1_28 * tmp1_0;
    // Op 1042: dim1x1 add
    gl64_t s0_1042 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 46, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 46, domainSize, nCols_1))];
    tmp1_0 = s0_1042 + tmp1_29;
    // Op 1043: dim1x1 mul
    tmp1_0 = tmp1_30 * tmp1_0;
    // Op 1044: dim1x1 add
    tmp1_15 = tmp1_4 + tmp1_0;
    // Op 1045: dim1x1 add
    tmp1_8 = tmp1_13 + tmp1_15;
    // Op 1046: dim1x1 add
    tmp1_18 = tmp1_1 + tmp1_8;
    // Op 1047: dim1x1 add
    tmp1_6 = tmp1_19 + tmp1_18;
    // Op 1048: dim1x1 add
    gl64_t s0_1048 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1048 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_1 = s0_1048 + s1_1048;
    // Op 1049: dim1x1 mul
    gl64_t s1_1049 = *(gl64_t*)&expressions_params[9][113];
    tmp1_1 = tmp1_1 * s1_1049;
    // Op 1050: dim1x1 mul
    gl64_t s0_1050 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_1050 = *(gl64_t*)&expressions_params[9][114];
    tmp1_13 = s0_1050 * s1_1050;
    // Op 1051: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_13;
    // Op 1052: dim1x1 mul
    gl64_t s0_1052 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_1052 = *(gl64_t*)&expressions_params[9][115];
    tmp1_13 = s0_1052 * s1_1052;
    // Op 1053: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_13;
    // Op 1054: dim1x1 mul
    gl64_t s0_1054 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1054 = *(gl64_t*)&expressions_params[9][116];
    tmp1_13 = s0_1054 * s1_1054;
    // Op 1055: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_13;
    // Op 1056: dim1x1 mul
    gl64_t s0_1056 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    gl64_t s1_1056 = *(gl64_t*)&expressions_params[9][117];
    tmp1_13 = s0_1056 * s1_1056;
    // Op 1057: dim1x1 add
    tmp1_37 = tmp1_1 + tmp1_13;
    // Op 1058: dim1x1 add
    gl64_t s0_1058 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 50, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 50, domainSize, nCols_1))];
    tmp1_1 = s0_1058 + tmp1_37;
    // Op 1059: dim1x1 add
    gl64_t s0_1059 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 50, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 50, domainSize, nCols_1))];
    tmp1_13 = s0_1059 + tmp1_37;
    // Op 1060: dim1x1 mul
    tmp1_1 = tmp1_1 * tmp1_13;
    // Op 1061: dim1x1 mul
    tmp1_13 = tmp1_1 * tmp1_1;
    // Op 1062: dim1x1 mul
    tmp1_38 = tmp1_13 * tmp1_1;
    // Op 1063: dim1x1 add
    gl64_t s0_1063 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 50, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 50, domainSize, nCols_1))];
    tmp1_1 = s0_1063 + tmp1_37;
    // Op 1064: dim1x1 mul
    tmp1_1 = tmp1_38 * tmp1_1;
    // Op 1065: dim1x1 mul
    gl64_t s1_1065 = *(gl64_t*)&expressions_params[9][27];
    tmp1_4 = tmp1_1 * s1_1065;
    // Op 1066: dim1x1 add
    gl64_t s0_1066 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1066 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_1 = s0_1066 + s1_1066;
    // Op 1067: dim1x1 mul
    gl64_t s1_1067 = *(gl64_t*)&expressions_params[9][118];
    tmp1_1 = tmp1_1 * s1_1067;
    // Op 1068: dim1x1 mul
    gl64_t s0_1068 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_1068 = *(gl64_t*)&expressions_params[9][119];
    tmp1_13 = s0_1068 * s1_1068;
    // Op 1069: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_13;
    // Op 1070: dim1x1 mul
    gl64_t s0_1070 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_1070 = *(gl64_t*)&expressions_params[9][120];
    tmp1_13 = s0_1070 * s1_1070;
    // Op 1071: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_13;
    // Op 1072: dim1x1 mul
    gl64_t s0_1072 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1072 = *(gl64_t*)&expressions_params[9][121];
    tmp1_13 = s0_1072 * s1_1072;
    // Op 1073: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_13;
    // Op 1074: dim1x1 mul
    gl64_t s0_1074 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    gl64_t s1_1074 = *(gl64_t*)&expressions_params[9][122];
    tmp1_13 = s0_1074 * s1_1074;
    // Op 1075: dim1x1 add
    tmp1_31 = tmp1_1 + tmp1_13;
    // Op 1076: dim1x1 add
    gl64_t s0_1076 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_1))];
    tmp1_1 = s0_1076 + tmp1_31;
    // Op 1077: dim1x1 add
    gl64_t s0_1077 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_1))];
    tmp1_13 = s0_1077 + tmp1_31;
    // Op 1078: dim1x1 mul
    tmp1_1 = tmp1_1 * tmp1_13;
    // Op 1079: dim1x1 mul
    tmp1_13 = tmp1_1 * tmp1_1;
    // Op 1080: dim1x1 mul
    tmp1_32 = tmp1_13 * tmp1_1;
    // Op 1081: dim1x1 add
    gl64_t s0_1081 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_1))];
    tmp1_1 = s0_1081 + tmp1_31;
    // Op 1082: dim1x1 mul
    tmp1_0 = tmp1_32 * tmp1_1;
    // Op 1083: dim1x1 add
    gl64_t s0_1083 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1083 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_1 = s0_1083 + s1_1083;
    // Op 1084: dim1x1 mul
    gl64_t s1_1084 = *(gl64_t*)&expressions_params[9][123];
    tmp1_1 = tmp1_1 * s1_1084;
    // Op 1085: dim1x1 mul
    gl64_t s0_1085 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_1085 = *(gl64_t*)&expressions_params[9][124];
    tmp1_13 = s0_1085 * s1_1085;
    // Op 1086: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_13;
    // Op 1087: dim1x1 mul
    gl64_t s0_1087 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_1087 = *(gl64_t*)&expressions_params[9][125];
    tmp1_13 = s0_1087 * s1_1087;
    // Op 1088: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_13;
    // Op 1089: dim1x1 mul
    gl64_t s0_1089 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1089 = *(gl64_t*)&expressions_params[9][126];
    tmp1_13 = s0_1089 * s1_1089;
    // Op 1090: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_13;
    // Op 1091: dim1x1 mul
    gl64_t s0_1091 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    gl64_t s1_1091 = *(gl64_t*)&expressions_params[9][127];
    tmp1_13 = s0_1091 * s1_1091;
    // Op 1092: dim1x1 add
    tmp1_33 = tmp1_1 + tmp1_13;
    // Op 1093: dim1x1 add
    gl64_t s0_1093 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 48, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 48, domainSize, nCols_1))];
    tmp1_1 = s0_1093 + tmp1_33;
    // Op 1094: dim1x1 add
    gl64_t s0_1094 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 48, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 48, domainSize, nCols_1))];
    tmp1_13 = s0_1094 + tmp1_33;
    // Op 1095: dim1x1 mul
    tmp1_1 = tmp1_1 * tmp1_13;
    // Op 1096: dim1x1 mul
    tmp1_13 = tmp1_1 * tmp1_1;
    // Op 1097: dim1x1 mul
    tmp1_34 = tmp1_13 * tmp1_1;
    // Op 1098: dim1x1 add
    gl64_t s0_1098 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 48, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 48, domainSize, nCols_1))];
    tmp1_1 = s0_1098 + tmp1_33;
    // Op 1099: dim1x1 mul
    tmp1_1 = tmp1_34 * tmp1_1;
    // Op 1100: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 1101: dim1x1 add
    tmp1_23 = tmp1_4 + tmp1_0;
    // Op 1102: dim1x1 mul
    gl64_t s1_1102 = *(gl64_t*)&expressions_params[9][28];
    tmp1_13 = tmp1_0 * s1_1102;
    // Op 1103: dim1x1 add
    gl64_t s0_1103 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 48, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 48, domainSize, nCols_1))];
    tmp1_0 = s0_1103 + tmp1_33;
    // Op 1104: dim1x1 mul
    tmp1_0 = tmp1_34 * tmp1_0;
    // Op 1105: dim1x1 mul
    gl64_t s1_1105 = *(gl64_t*)&expressions_params[9][27];
    tmp1_1 = tmp1_0 * s1_1105;
    // Op 1106: dim1x1 add
    gl64_t s0_1106 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1106 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_1106 + s1_1106;
    // Op 1107: dim1x1 mul
    gl64_t s1_1107 = *(gl64_t*)&expressions_params[9][128];
    tmp1_0 = tmp1_0 * s1_1107;
    // Op 1108: dim1x1 mul
    gl64_t s0_1108 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_1108 = *(gl64_t*)&expressions_params[9][129];
    tmp1_4 = s0_1108 * s1_1108;
    // Op 1109: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 1110: dim1x1 mul
    gl64_t s0_1110 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_1110 = *(gl64_t*)&expressions_params[9][130];
    tmp1_4 = s0_1110 * s1_1110;
    // Op 1111: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 1112: dim1x1 mul
    gl64_t s0_1112 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1112 = *(gl64_t*)&expressions_params[9][131];
    tmp1_4 = s0_1112 * s1_1112;
    // Op 1113: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 1114: dim1x1 mul
    gl64_t s0_1114 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    gl64_t s1_1114 = *(gl64_t*)&expressions_params[9][132];
    tmp1_4 = s0_1114 * s1_1114;
    // Op 1115: dim1x1 add
    tmp1_35 = tmp1_0 + tmp1_4;
    // Op 1116: dim1x1 add
    gl64_t s0_1116 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 49, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 49, domainSize, nCols_1))];
    tmp1_0 = s0_1116 + tmp1_35;
    // Op 1117: dim1x1 add
    gl64_t s0_1117 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 49, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 49, domainSize, nCols_1))];
    tmp1_4 = s0_1117 + tmp1_35;
    // Op 1118: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_4;
    // Op 1119: dim1x1 mul
    tmp1_4 = tmp1_0 * tmp1_0;
    // Op 1120: dim1x1 mul
    tmp1_36 = tmp1_4 * tmp1_0;
    // Op 1121: dim1x1 add
    gl64_t s0_1121 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 49, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 49, domainSize, nCols_1))];
    tmp1_0 = s0_1121 + tmp1_35;
    // Op 1122: dim1x1 mul
    tmp1_4 = tmp1_36 * tmp1_0;
    // Op 1123: dim1x1 add
    gl64_t s0_1123 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 50, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 50, domainSize, nCols_1))];
    tmp1_0 = s0_1123 + tmp1_37;
    // Op 1124: dim1x1 mul
    tmp1_0 = tmp1_38 * tmp1_0;
    // Op 1125: dim1x1 add
    tmp1_9 = tmp1_4 + tmp1_0;
    // Op 1126: dim1x1 add
    tmp1_16 = tmp1_1 + tmp1_9;
    // Op 1127: dim1x1 add
    tmp1_25 = tmp1_13 + tmp1_16;
    // Op 1128: dim1x1 add
    tmp1_21 = tmp1_23 + tmp1_25;
    // Op 1129: dim1x1 add
    tmp1_22 = tmp1_6 + tmp1_21;
    // Op 1130: dim1x1 add
    gl64_t s0_1130 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1130 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_13 = s0_1130 + s1_1130;
    // Op 1131: dim1x1 mul
    gl64_t s1_1131 = *(gl64_t*)&expressions_params[9][133];
    tmp1_13 = tmp1_13 * s1_1131;
    // Op 1132: dim1x1 mul
    gl64_t s0_1132 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_1132 = *(gl64_t*)&expressions_params[9][134];
    tmp1_1 = s0_1132 * s1_1132;
    // Op 1133: dim1x1 add
    tmp1_1 = tmp1_13 + tmp1_1;
    // Op 1134: dim1x1 mul
    gl64_t s0_1134 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_1134 = *(gl64_t*)&expressions_params[9][135];
    tmp1_13 = s0_1134 * s1_1134;
    // Op 1135: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_13;
    // Op 1136: dim1x1 mul
    gl64_t s0_1136 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1136 = *(gl64_t*)&expressions_params[9][136];
    tmp1_13 = s0_1136 * s1_1136;
    // Op 1137: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_13;
    // Op 1138: dim1x1 mul
    gl64_t s0_1138 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    gl64_t s1_1138 = *(gl64_t*)&expressions_params[9][137];
    tmp1_13 = s0_1138 * s1_1138;
    // Op 1139: dim1x1 add
    tmp1_45 = tmp1_1 + tmp1_13;
    // Op 1140: dim1x1 add
    gl64_t s0_1140 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 54, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 54, domainSize, nCols_1))];
    tmp1_1 = s0_1140 + tmp1_45;
    // Op 1141: dim1x1 add
    gl64_t s0_1141 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 54, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 54, domainSize, nCols_1))];
    tmp1_13 = s0_1141 + tmp1_45;
    // Op 1142: dim1x1 mul
    tmp1_1 = tmp1_1 * tmp1_13;
    // Op 1143: dim1x1 mul
    tmp1_13 = tmp1_1 * tmp1_1;
    // Op 1144: dim1x1 mul
    tmp1_46 = tmp1_13 * tmp1_1;
    // Op 1145: dim1x1 add
    gl64_t s0_1145 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 54, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 54, domainSize, nCols_1))];
    tmp1_1 = s0_1145 + tmp1_45;
    // Op 1146: dim1x1 mul
    tmp1_1 = tmp1_46 * tmp1_1;
    // Op 1147: dim1x1 mul
    gl64_t s1_1147 = *(gl64_t*)&expressions_params[9][27];
    tmp1_4 = tmp1_1 * s1_1147;
    // Op 1148: dim1x1 add
    gl64_t s0_1148 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1148 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_1 = s0_1148 + s1_1148;
    // Op 1149: dim1x1 mul
    gl64_t s1_1149 = *(gl64_t*)&expressions_params[9][138];
    tmp1_1 = tmp1_1 * s1_1149;
    // Op 1150: dim1x1 mul
    gl64_t s0_1150 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_1150 = *(gl64_t*)&expressions_params[9][139];
    tmp1_13 = s0_1150 * s1_1150;
    // Op 1151: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_13;
    // Op 1152: dim1x1 mul
    gl64_t s0_1152 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_1152 = *(gl64_t*)&expressions_params[9][140];
    tmp1_13 = s0_1152 * s1_1152;
    // Op 1153: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_13;
    // Op 1154: dim1x1 mul
    gl64_t s0_1154 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1154 = *(gl64_t*)&expressions_params[9][141];
    tmp1_13 = s0_1154 * s1_1154;
    // Op 1155: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_13;
    // Op 1156: dim1x1 mul
    gl64_t s0_1156 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    gl64_t s1_1156 = *(gl64_t*)&expressions_params[9][142];
    tmp1_13 = s0_1156 * s1_1156;
    // Op 1157: dim1x1 add
    tmp1_39 = tmp1_1 + tmp1_13;
    // Op 1158: dim1x1 add
    gl64_t s0_1158 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 51, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 51, domainSize, nCols_1))];
    tmp1_1 = s0_1158 + tmp1_39;
    // Op 1159: dim1x1 add
    gl64_t s0_1159 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 51, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 51, domainSize, nCols_1))];
    tmp1_13 = s0_1159 + tmp1_39;
    // Op 1160: dim1x1 mul
    tmp1_1 = tmp1_1 * tmp1_13;
    // Op 1161: dim1x1 mul
    tmp1_13 = tmp1_1 * tmp1_1;
    // Op 1162: dim1x1 mul
    tmp1_40 = tmp1_13 * tmp1_1;
    // Op 1163: dim1x1 add
    gl64_t s0_1163 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 51, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 51, domainSize, nCols_1))];
    tmp1_1 = s0_1163 + tmp1_39;
    // Op 1164: dim1x1 mul
    tmp1_0 = tmp1_40 * tmp1_1;
    // Op 1165: dim1x1 add
    gl64_t s0_1165 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1165 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_1 = s0_1165 + s1_1165;
    // Op 1166: dim1x1 mul
    gl64_t s1_1166 = *(gl64_t*)&expressions_params[9][143];
    tmp1_1 = tmp1_1 * s1_1166;
    // Op 1167: dim1x1 mul
    gl64_t s0_1167 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_1167 = *(gl64_t*)&expressions_params[9][144];
    tmp1_13 = s0_1167 * s1_1167;
    // Op 1168: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_13;
    // Op 1169: dim1x1 mul
    gl64_t s0_1169 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_1169 = *(gl64_t*)&expressions_params[9][145];
    tmp1_13 = s0_1169 * s1_1169;
    // Op 1170: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_13;
    // Op 1171: dim1x1 mul
    gl64_t s0_1171 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1171 = *(gl64_t*)&expressions_params[9][146];
    tmp1_13 = s0_1171 * s1_1171;
    // Op 1172: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_13;
    // Op 1173: dim1x1 mul
    gl64_t s0_1173 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    gl64_t s1_1173 = *(gl64_t*)&expressions_params[9][147];
    tmp1_13 = s0_1173 * s1_1173;
    // Op 1174: dim1x1 add
    tmp1_41 = tmp1_1 + tmp1_13;
    // Op 1175: dim1x1 add
    gl64_t s0_1175 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 52, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 52, domainSize, nCols_1))];
    tmp1_1 = s0_1175 + tmp1_41;
    // Op 1176: dim1x1 add
    gl64_t s0_1176 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 52, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 52, domainSize, nCols_1))];
    tmp1_13 = s0_1176 + tmp1_41;
    // Op 1177: dim1x1 mul
    tmp1_1 = tmp1_1 * tmp1_13;
    // Op 1178: dim1x1 mul
    tmp1_13 = tmp1_1 * tmp1_1;
    // Op 1179: dim1x1 mul
    tmp1_42 = tmp1_13 * tmp1_1;
    // Op 1180: dim1x1 add
    gl64_t s0_1180 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 52, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 52, domainSize, nCols_1))];
    tmp1_1 = s0_1180 + tmp1_41;
    // Op 1181: dim1x1 mul
    tmp1_1 = tmp1_42 * tmp1_1;
    // Op 1182: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 1183: dim1x1 add
    tmp1_17 = tmp1_4 + tmp1_0;
    // Op 1184: dim1x1 mul
    gl64_t s1_1184 = *(gl64_t*)&expressions_params[9][28];
    tmp1_13 = tmp1_0 * s1_1184;
    // Op 1185: dim1x1 add
    gl64_t s0_1185 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 52, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 52, domainSize, nCols_1))];
    tmp1_0 = s0_1185 + tmp1_41;
    // Op 1186: dim1x1 mul
    tmp1_0 = tmp1_42 * tmp1_0;
    // Op 1187: dim1x1 mul
    gl64_t s1_1187 = *(gl64_t*)&expressions_params[9][27];
    tmp1_1 = tmp1_0 * s1_1187;
    // Op 1188: dim1x1 add
    gl64_t s0_1188 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1188 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_0 = s0_1188 + s1_1188;
    // Op 1189: dim1x1 mul
    gl64_t s1_1189 = *(gl64_t*)&expressions_params[9][148];
    tmp1_0 = tmp1_0 * s1_1189;
    // Op 1190: dim1x1 mul
    gl64_t s0_1190 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_1190 = *(gl64_t*)&expressions_params[9][149];
    tmp1_4 = s0_1190 * s1_1190;
    // Op 1191: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 1192: dim1x1 mul
    gl64_t s0_1192 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_1192 = *(gl64_t*)&expressions_params[9][150];
    tmp1_4 = s0_1192 * s1_1192;
    // Op 1193: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 1194: dim1x1 mul
    gl64_t s0_1194 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1194 = *(gl64_t*)&expressions_params[9][151];
    tmp1_4 = s0_1194 * s1_1194;
    // Op 1195: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_4;
    // Op 1196: dim1x1 mul
    gl64_t s0_1196 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    gl64_t s1_1196 = *(gl64_t*)&expressions_params[9][152];
    tmp1_4 = s0_1196 * s1_1196;
    // Op 1197: dim1x1 add
    tmp1_43 = tmp1_0 + tmp1_4;
    // Op 1198: dim1x1 add
    gl64_t s0_1198 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 53, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 53, domainSize, nCols_1))];
    tmp1_0 = s0_1198 + tmp1_43;
    // Op 1199: dim1x1 add
    gl64_t s0_1199 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 53, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 53, domainSize, nCols_1))];
    tmp1_4 = s0_1199 + tmp1_43;
    // Op 1200: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_4;
    // Op 1201: dim1x1 mul
    tmp1_4 = tmp1_0 * tmp1_0;
    // Op 1202: dim1x1 mul
    tmp1_44 = tmp1_4 * tmp1_0;
    // Op 1203: dim1x1 add
    gl64_t s0_1203 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 53, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 53, domainSize, nCols_1))];
    tmp1_0 = s0_1203 + tmp1_43;
    // Op 1204: dim1x1 mul
    tmp1_4 = tmp1_44 * tmp1_0;
    // Op 1205: dim1x1 add
    gl64_t s0_1205 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 54, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 54, domainSize, nCols_1))];
    tmp1_0 = s0_1205 + tmp1_45;
    // Op 1206: dim1x1 mul
    tmp1_0 = tmp1_46 * tmp1_0;
    // Op 1207: dim1x1 add
    tmp1_12 = tmp1_4 + tmp1_0;
    // Op 1208: dim1x1 add
    tmp1_24 = tmp1_1 + tmp1_12;
    // Op 1209: dim1x1 add
    tmp1_10 = tmp1_13 + tmp1_24;
    // Op 1210: dim1x1 add
    tmp1_20 = tmp1_17 + tmp1_10;
    // Op 1211: dim1x1 add
    tmp1_4 = tmp1_22 + tmp1_20;
    // Op 1212: dim1x1 add
    gl64_t s0_1212 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1212 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_22 = s0_1212 + s1_1212;
    // Op 1213: dim1x1 mul
    gl64_t s1_1213 = *(gl64_t*)&expressions_params[9][153];
    tmp1_22 = tmp1_22 * s1_1213;
    // Op 1214: dim1x1 mul
    gl64_t s0_1214 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_1214 = *(gl64_t*)&expressions_params[9][154];
    tmp1_13 = s0_1214 * s1_1214;
    // Op 1215: dim1x1 add
    tmp1_13 = tmp1_22 + tmp1_13;
    // Op 1216: dim1x1 mul
    gl64_t s0_1216 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_1216 = *(gl64_t*)&expressions_params[9][155];
    tmp1_22 = s0_1216 * s1_1216;
    // Op 1217: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_22;
    // Op 1218: dim1x1 mul
    gl64_t s0_1218 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1218 = *(gl64_t*)&expressions_params[9][156];
    tmp1_22 = s0_1218 * s1_1218;
    // Op 1219: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_22;
    // Op 1220: dim1x1 mul
    gl64_t s0_1220 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    gl64_t s1_1220 = *(gl64_t*)&expressions_params[9][157];
    tmp1_22 = s0_1220 * s1_1220;
    // Op 1221: dim1x1 add
    tmp1_53 = tmp1_13 + tmp1_22;
    // Op 1222: dim1x1 add
    gl64_t s0_1222 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 58, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 58, domainSize, nCols_1))];
    tmp1_13 = s0_1222 + tmp1_53;
    // Op 1223: dim1x1 add
    gl64_t s0_1223 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 58, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 58, domainSize, nCols_1))];
    tmp1_22 = s0_1223 + tmp1_53;
    // Op 1224: dim1x1 mul
    tmp1_13 = tmp1_13 * tmp1_22;
    // Op 1225: dim1x1 mul
    tmp1_22 = tmp1_13 * tmp1_13;
    // Op 1226: dim1x1 mul
    tmp1_54 = tmp1_22 * tmp1_13;
    // Op 1227: dim1x1 add
    gl64_t s0_1227 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 58, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 58, domainSize, nCols_1))];
    tmp1_13 = s0_1227 + tmp1_53;
    // Op 1228: dim1x1 mul
    tmp1_13 = tmp1_54 * tmp1_13;
    // Op 1229: dim1x1 mul
    gl64_t s1_1229 = *(gl64_t*)&expressions_params[9][27];
    tmp1_0 = tmp1_13 * s1_1229;
    // Op 1230: dim1x1 add
    gl64_t s0_1230 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1230 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_13 = s0_1230 + s1_1230;
    // Op 1231: dim1x1 mul
    gl64_t s1_1231 = *(gl64_t*)&expressions_params[9][158];
    tmp1_13 = tmp1_13 * s1_1231;
    // Op 1232: dim1x1 mul
    gl64_t s0_1232 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_1232 = *(gl64_t*)&expressions_params[9][159];
    tmp1_22 = s0_1232 * s1_1232;
    // Op 1233: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_22;
    // Op 1234: dim1x1 mul
    gl64_t s0_1234 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_1234 = *(gl64_t*)&expressions_params[9][160];
    tmp1_22 = s0_1234 * s1_1234;
    // Op 1235: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_22;
    // Op 1236: dim1x1 mul
    gl64_t s0_1236 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1236 = *(gl64_t*)&expressions_params[9][161];
    tmp1_22 = s0_1236 * s1_1236;
    // Op 1237: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_22;
    // Op 1238: dim1x1 mul
    gl64_t s0_1238 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    gl64_t s1_1238 = *(gl64_t*)&expressions_params[9][162];
    tmp1_22 = s0_1238 * s1_1238;
    // Op 1239: dim1x1 add
    tmp1_47 = tmp1_13 + tmp1_22;
    // Op 1240: dim1x1 add
    gl64_t s0_1240 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 55, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 55, domainSize, nCols_1))];
    tmp1_13 = s0_1240 + tmp1_47;
    // Op 1241: dim1x1 add
    gl64_t s0_1241 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 55, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 55, domainSize, nCols_1))];
    tmp1_22 = s0_1241 + tmp1_47;
    // Op 1242: dim1x1 mul
    tmp1_13 = tmp1_13 * tmp1_22;
    // Op 1243: dim1x1 mul
    tmp1_22 = tmp1_13 * tmp1_13;
    // Op 1244: dim1x1 mul
    tmp1_48 = tmp1_22 * tmp1_13;
    // Op 1245: dim1x1 add
    gl64_t s0_1245 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 55, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 55, domainSize, nCols_1))];
    tmp1_13 = s0_1245 + tmp1_47;
    // Op 1246: dim1x1 mul
    tmp1_1 = tmp1_48 * tmp1_13;
    // Op 1247: dim1x1 add
    gl64_t s0_1247 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1247 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_13 = s0_1247 + s1_1247;
    // Op 1248: dim1x1 mul
    gl64_t s1_1248 = *(gl64_t*)&expressions_params[9][163];
    tmp1_13 = tmp1_13 * s1_1248;
    // Op 1249: dim1x1 mul
    gl64_t s0_1249 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_1249 = *(gl64_t*)&expressions_params[9][164];
    tmp1_22 = s0_1249 * s1_1249;
    // Op 1250: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_22;
    // Op 1251: dim1x1 mul
    gl64_t s0_1251 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_1251 = *(gl64_t*)&expressions_params[9][165];
    tmp1_22 = s0_1251 * s1_1251;
    // Op 1252: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_22;
    // Op 1253: dim1x1 mul
    gl64_t s0_1253 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1253 = *(gl64_t*)&expressions_params[9][166];
    tmp1_22 = s0_1253 * s1_1253;
    // Op 1254: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_22;
    // Op 1255: dim1x1 mul
    gl64_t s0_1255 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    gl64_t s1_1255 = *(gl64_t*)&expressions_params[9][167];
    tmp1_22 = s0_1255 * s1_1255;
    // Op 1256: dim1x1 add
    tmp1_49 = tmp1_13 + tmp1_22;
    // Op 1257: dim1x1 add
    gl64_t s0_1257 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 56, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 56, domainSize, nCols_1))];
    tmp1_13 = s0_1257 + tmp1_49;
    // Op 1258: dim1x1 add
    gl64_t s0_1258 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 56, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 56, domainSize, nCols_1))];
    tmp1_22 = s0_1258 + tmp1_49;
    // Op 1259: dim1x1 mul
    tmp1_13 = tmp1_13 * tmp1_22;
    // Op 1260: dim1x1 mul
    tmp1_22 = tmp1_13 * tmp1_13;
    // Op 1261: dim1x1 mul
    tmp1_50 = tmp1_22 * tmp1_13;
    // Op 1262: dim1x1 add
    gl64_t s0_1262 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 56, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 56, domainSize, nCols_1))];
    tmp1_13 = s0_1262 + tmp1_49;
    // Op 1263: dim1x1 mul
    tmp1_13 = tmp1_50 * tmp1_13;
    // Op 1264: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_13;
    // Op 1265: dim1x1 add
    tmp1_14 = tmp1_0 + tmp1_1;
    // Op 1266: dim1x1 mul
    gl64_t s1_1266 = *(gl64_t*)&expressions_params[9][28];
    tmp1_22 = tmp1_1 * s1_1266;
    // Op 1267: dim1x1 add
    gl64_t s0_1267 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 56, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 56, domainSize, nCols_1))];
    tmp1_1 = s0_1267 + tmp1_49;
    // Op 1268: dim1x1 mul
    tmp1_1 = tmp1_50 * tmp1_1;
    // Op 1269: dim1x1 mul
    gl64_t s1_1269 = *(gl64_t*)&expressions_params[9][27];
    tmp1_13 = tmp1_1 * s1_1269;
    // Op 1270: dim1x1 add
    gl64_t s0_1270 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1270 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_1 = s0_1270 + s1_1270;
    // Op 1271: dim1x1 mul
    gl64_t s1_1271 = *(gl64_t*)&expressions_params[9][168];
    tmp1_1 = tmp1_1 * s1_1271;
    // Op 1272: dim1x1 mul
    gl64_t s0_1272 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    gl64_t s1_1272 = *(gl64_t*)&expressions_params[9][169];
    tmp1_0 = s0_1272 * s1_1272;
    // Op 1273: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 1274: dim1x1 mul
    gl64_t s0_1274 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    gl64_t s1_1274 = *(gl64_t*)&expressions_params[9][170];
    tmp1_1 = s0_1274 * s1_1274;
    // Op 1275: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 1276: dim1x1 mul
    gl64_t s0_1276 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1276 = *(gl64_t*)&expressions_params[9][171];
    tmp1_1 = s0_1276 * s1_1276;
    // Op 1277: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_1;
    // Op 1278: dim1x1 mul
    gl64_t s0_1278 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    gl64_t s1_1278 = *(gl64_t*)&expressions_params[9][172];
    tmp1_1 = s0_1278 * s1_1278;
    // Op 1279: dim1x1 add
    tmp1_51 = tmp1_0 + tmp1_1;
    // Op 1280: dim1x1 add
    gl64_t s0_1280 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 57, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 57, domainSize, nCols_1))];
    tmp1_0 = s0_1280 + tmp1_51;
    // Op 1281: dim1x1 add
    gl64_t s0_1281 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 57, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 57, domainSize, nCols_1))];
    tmp1_1 = s0_1281 + tmp1_51;
    // Op 1282: dim1x1 mul
    tmp1_0 = tmp1_0 * tmp1_1;
    // Op 1283: dim1x1 mul
    tmp1_1 = tmp1_0 * tmp1_0;
    // Op 1284: dim1x1 mul
    tmp1_52 = tmp1_1 * tmp1_0;
    // Op 1285: dim1x1 add
    gl64_t s0_1285 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 57, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 57, domainSize, nCols_1))];
    tmp1_0 = s0_1285 + tmp1_51;
    // Op 1286: dim1x1 mul
    tmp1_1 = tmp1_52 * tmp1_0;
    // Op 1287: dim1x1 add
    gl64_t s0_1287 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 58, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 58, domainSize, nCols_1))];
    tmp1_0 = s0_1287 + tmp1_53;
    // Op 1288: dim1x1 mul
    tmp1_0 = tmp1_54 * tmp1_0;
    // Op 1289: dim1x1 add
    tmp1_0 = tmp1_1 + tmp1_0;
    // Op 1290: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_0;
    // Op 1291: dim1x1 add
    tmp1_1 = tmp1_22 + tmp1_13;
    // Op 1292: dim1x1 add
    tmp1_22 = tmp1_14 + tmp1_1;
    // Op 1293: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_22;
    // Op 1294: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_4;
    // Op 1295: dim1x1 sub
    tmp1_5 = tmp1_5 - tmp1_6;
    // Op 1296: dim1x1 mul
    tmp1_5 = tmp1_7 * tmp1_5;
    // Op 1297: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_5; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1298: dim3x3 mul
    gl64_t s1_1298_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1298_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1298_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 1299: dim1x1 add
    gl64_t s0_1299 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1299 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_5 = s0_1299 + s1_1299;
    // Op 1300: dim1x1 add
    gl64_t s0_1300 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_5 = s0_1300 + tmp1_5;
    // Op 1301: dim1x1 add
    gl64_t s0_1301 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_5 = s0_1301 + tmp1_5;
    // Op 1302: dim1x1 add
    gl64_t s0_1302 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_6 = s0_1302 + tmp1_5;
    // Op 1303: dim1x1 mul
    gl64_t s0_1303 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1303 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    tmp1_7 = s0_1303 * s1_1303;
    // Op 1304: dim1x1 sub_swap
    gl64_t s0_1304 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1304 = *(gl64_t*)&expressions_params[9][26];
    tmp1_5 = s1_1304 - s0_1304;
    // Op 1305: dim1x1 mul
    gl64_t s0_1305 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 28, domainSize, nCols_1))];
    tmp1_5 = s0_1305 * tmp1_5;
    // Op 1306: dim1x1 add
    tmp1_7 = tmp1_7 + tmp1_5;
    // Op 1307: dim1x1 add
    tmp1_5 = tmp1_18 + tmp1_25;
    // Op 1308: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_10;
    // Op 1309: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_1;
    // Op 1310: dim1x1 add
    tmp1_18 = tmp1_18 + tmp1_5;
    // Op 1311: dim1x1 sub
    tmp1_7 = tmp1_7 - tmp1_18;
    // Op 1312: dim1x1 mul
    tmp1_6 = tmp1_6 * tmp1_7;
    // Op 1313: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_6; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1314: dim3x3 mul
    gl64_t s1_1314_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1314_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1314_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 1315: dim1x1 add
    gl64_t s0_1315 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1315 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_6 = s0_1315 + s1_1315;
    // Op 1316: dim1x1 add
    gl64_t s0_1316 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_6 = s0_1316 + tmp1_6;
    // Op 1317: dim1x1 add
    gl64_t s0_1317 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_6 = s0_1317 + tmp1_6;
    // Op 1318: dim1x1 add
    gl64_t s0_1318 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_18 = s0_1318 + tmp1_6;
    // Op 1319: dim1x1 mul
    gl64_t s0_1319 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1319 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_1))];
    tmp1_7 = s0_1319 * s1_1319;
    // Op 1320: dim1x1 sub_swap
    gl64_t s0_1320 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1320 = *(gl64_t*)&expressions_params[9][26];
    tmp1_6 = s1_1320 - s0_1320;
    // Op 1321: dim1x1 mul
    gl64_t s0_1321 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 29, domainSize, nCols_1))];
    tmp1_6 = s0_1321 * tmp1_6;
    // Op 1322: dim1x1 add
    tmp1_6 = tmp1_7 + tmp1_6;
    // Op 1323: dim1x1 mul
    gl64_t s1_1323 = *(gl64_t*)&expressions_params[9][28];
    tmp1_15 = tmp1_15 * s1_1323;
    // Op 1324: dim1x1 add
    tmp1_15 = tmp1_15 + tmp1_19;
    // Op 1325: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_15;
    // Op 1326: dim1x1 mul
    gl64_t s1_1326 = *(gl64_t*)&expressions_params[9][28];
    tmp1_9 = tmp1_9 * s1_1326;
    // Op 1327: dim1x1 add
    tmp1_23 = tmp1_9 + tmp1_23;
    // Op 1328: dim1x1 add
    tmp1_9 = tmp1_16 + tmp1_23;
    // Op 1329: dim1x1 add
    tmp1_16 = tmp1_8 + tmp1_9;
    // Op 1330: dim1x1 mul
    gl64_t s1_1330 = *(gl64_t*)&expressions_params[9][28];
    tmp1_12 = tmp1_12 * s1_1330;
    // Op 1331: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_17;
    // Op 1332: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_12;
    // Op 1333: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_24;
    // Op 1334: dim1x1 mul
    gl64_t s1_1334 = *(gl64_t*)&expressions_params[9][28];
    tmp1_0 = tmp1_0 * s1_1334;
    // Op 1335: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_14;
    // Op 1336: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_0;
    // Op 1337: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_13;
    // Op 1338: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_16;
    // Op 1339: dim1x1 sub
    tmp1_6 = tmp1_6 - tmp1_8;
    // Op 1340: dim1x1 mul
    tmp1_6 = tmp1_18 * tmp1_6;
    // Op 1341: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_6; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1342: dim3x3 mul
    gl64_t s1_1342_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1342_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1342_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 1343: dim1x1 add
    gl64_t s0_1343 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1343 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_6 = s0_1343 + s1_1343;
    // Op 1344: dim1x1 add
    gl64_t s0_1344 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_6 = s0_1344 + tmp1_6;
    // Op 1345: dim1x1 add
    gl64_t s0_1345 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_6 = s0_1345 + tmp1_6;
    // Op 1346: dim1x1 add
    gl64_t s0_1346 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_8 = s0_1346 + tmp1_6;
    // Op 1347: dim1x1 mul
    gl64_t s0_1347 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1347 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_18 = s0_1347 * s1_1347;
    // Op 1348: dim1x1 sub_swap
    gl64_t s0_1348 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1348 = *(gl64_t*)&expressions_params[9][26];
    tmp1_6 = s1_1348 - s0_1348;
    // Op 1349: dim1x1 mul
    gl64_t s0_1349 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 30, domainSize, nCols_1))];
    tmp1_6 = s0_1349 * tmp1_6;
    // Op 1350: dim1x1 add
    tmp1_18 = tmp1_18 + tmp1_6;
    // Op 1351: dim1x1 add
    tmp1_6 = tmp1_15 + tmp1_23;
    // Op 1352: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_12;
    // Op 1353: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_0;
    // Op 1354: dim1x1 add
    tmp1_15 = tmp1_15 + tmp1_6;
    // Op 1355: dim1x1 sub
    tmp1_15 = tmp1_18 - tmp1_15;
    // Op 1356: dim1x1 mul
    tmp1_8 = tmp1_8 * tmp1_15;
    // Op 1357: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_8; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1358: dim3x3 mul
    gl64_t s1_1358_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1358_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1358_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 1359: dim1x1 add
    gl64_t s0_1359 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1359 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_8 = s0_1359 + s1_1359;
    // Op 1360: dim1x1 add
    gl64_t s0_1360 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_8 = s0_1360 + tmp1_8;
    // Op 1361: dim1x1 add
    gl64_t s0_1361 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_8 = s0_1361 + tmp1_8;
    // Op 1362: dim1x1 add
    gl64_t s0_1362 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_18 = s0_1362 + tmp1_8;
    // Op 1363: dim1x1 mul
    gl64_t s0_1363 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1363 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    tmp1_15 = s0_1363 * s1_1363;
    // Op 1364: dim1x1 sub_swap
    gl64_t s0_1364 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1364 = *(gl64_t*)&expressions_params[9][26];
    tmp1_8 = s1_1364 - s0_1364;
    // Op 1365: dim1x1 mul
    gl64_t s0_1365 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 31, domainSize, nCols_1))];
    tmp1_8 = s0_1365 * tmp1_8;
    // Op 1366: dim1x1 add
    tmp1_8 = tmp1_15 + tmp1_8;
    // Op 1367: dim1x1 add
    tmp1_21 = tmp1_21 + tmp1_4;
    // Op 1368: dim1x1 sub
    tmp1_8 = tmp1_8 - tmp1_21;
    // Op 1369: dim1x1 mul
    tmp1_8 = tmp1_18 * tmp1_8;
    // Op 1370: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_8; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1371: dim3x3 mul
    gl64_t s1_1371_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1371_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1371_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1371 = (tmp3_0 + tmp3_1) * (s1_1371_0 + s1_1371_1);
    gl64_t kB1371 = (tmp3_0 + tmp3_2) * (s1_1371_0 + s1_1371_2);
    gl64_t kC1371 = (tmp3_1 + tmp3_2) * (s1_1371_1 + s1_1371_2);
    gl64_t kD1371 = tmp3_0 * s1_1371_0;
    gl64_t kE1371 = tmp3_1 * s1_1371_1;
    gl64_t kF1371 = tmp3_2 * s1_1371_2;
    gl64_t kG1371 = kD1371 - kE1371;
    tmp3_0 = (kC1371 + kG1371) - kF1371;
    tmp3_1 = ((((kA1371 + kC1371) - kE1371) - kE1371) - kD1371);
    tmp3_2 = kB1371 - kG1371;
    // Op 1372: dim1x1 add
    gl64_t s0_1372 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1372 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_8 = s0_1372 + s1_1372;
    // Op 1373: dim1x1 add
    gl64_t s0_1373 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_8 = s0_1373 + tmp1_8;
    // Op 1374: dim1x1 add
    gl64_t s0_1374 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_8 = s0_1374 + tmp1_8;
    // Op 1375: dim1x1 add
    gl64_t s0_1375 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_21 = s0_1375 + tmp1_8;
    // Op 1376: dim1x1 mul
    gl64_t s0_1376 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1376 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    tmp1_18 = s0_1376 * s1_1376;
    // Op 1377: dim1x1 sub_swap
    gl64_t s0_1377 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1377 = *(gl64_t*)&expressions_params[9][26];
    tmp1_8 = s1_1377 - s0_1377;
    // Op 1378: dim1x1 mul
    gl64_t s0_1378 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 32, domainSize, nCols_1))];
    tmp1_8 = s0_1378 * tmp1_8;
    // Op 1379: dim1x1 add
    tmp1_8 = tmp1_18 + tmp1_8;
    // Op 1380: dim1x1 add
    tmp1_25 = tmp1_25 + tmp1_5;
    // Op 1381: dim1x1 sub
    tmp1_8 = tmp1_8 - tmp1_25;
    // Op 1382: dim1x1 mul
    tmp1_8 = tmp1_21 * tmp1_8;
    // Op 1383: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_8; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1384: dim3x3 mul
    gl64_t s1_1384_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1384_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1384_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 1385: dim1x1 add
    gl64_t s0_1385 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1385 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_8 = s0_1385 + s1_1385;
    // Op 1386: dim1x1 add
    gl64_t s0_1386 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_8 = s0_1386 + tmp1_8;
    // Op 1387: dim1x1 add
    gl64_t s0_1387 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_8 = s0_1387 + tmp1_8;
    // Op 1388: dim1x1 add
    gl64_t s0_1388 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_25 = s0_1388 + tmp1_8;
    // Op 1389: dim1x1 mul
    gl64_t s0_1389 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1389 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 6, domainSize, nCols_1))];
    tmp1_21 = s0_1389 * s1_1389;
    // Op 1390: dim1x1 sub_swap
    gl64_t s0_1390 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1390 = *(gl64_t*)&expressions_params[9][26];
    tmp1_8 = s1_1390 - s0_1390;
    // Op 1391: dim1x1 mul
    gl64_t s0_1391 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 33, domainSize, nCols_1))];
    tmp1_8 = s0_1391 * tmp1_8;
    // Op 1392: dim1x1 add
    tmp1_8 = tmp1_21 + tmp1_8;
    // Op 1393: dim1x1 add
    tmp1_9 = tmp1_9 + tmp1_16;
    // Op 1394: dim1x1 sub
    tmp1_8 = tmp1_8 - tmp1_9;
    // Op 1395: dim1x1 mul
    tmp1_8 = tmp1_25 * tmp1_8;
    // Op 1396: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_8; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1397: dim3x3 mul
    gl64_t s1_1397_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1397_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1397_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1397 = (tmp3_0 + tmp3_1) * (s1_1397_0 + s1_1397_1);
    gl64_t kB1397 = (tmp3_0 + tmp3_2) * (s1_1397_0 + s1_1397_2);
    gl64_t kC1397 = (tmp3_1 + tmp3_2) * (s1_1397_1 + s1_1397_2);
    gl64_t kD1397 = tmp3_0 * s1_1397_0;
    gl64_t kE1397 = tmp3_1 * s1_1397_1;
    gl64_t kF1397 = tmp3_2 * s1_1397_2;
    gl64_t kG1397 = kD1397 - kE1397;
    tmp3_0 = (kC1397 + kG1397) - kF1397;
    tmp3_1 = ((((kA1397 + kC1397) - kE1397) - kE1397) - kD1397);
    tmp3_2 = kB1397 - kG1397;
    // Op 1398: dim1x1 add
    gl64_t s0_1398 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1398 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_8 = s0_1398 + s1_1398;
    // Op 1399: dim1x1 add
    gl64_t s0_1399 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_8 = s0_1399 + tmp1_8;
    // Op 1400: dim1x1 add
    gl64_t s0_1400 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_8 = s0_1400 + tmp1_8;
    // Op 1401: dim1x1 add
    gl64_t s0_1401 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_9 = s0_1401 + tmp1_8;
    // Op 1402: dim1x1 mul
    gl64_t s0_1402 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1402 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    tmp1_25 = s0_1402 * s1_1402;
    // Op 1403: dim1x1 sub_swap
    gl64_t s0_1403 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1403 = *(gl64_t*)&expressions_params[9][26];
    tmp1_8 = s1_1403 - s0_1403;
    // Op 1404: dim1x1 mul
    gl64_t s0_1404 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 34, domainSize, nCols_1))];
    tmp1_8 = s0_1404 * tmp1_8;
    // Op 1405: dim1x1 add
    tmp1_8 = tmp1_25 + tmp1_8;
    // Op 1406: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_6;
    // Op 1407: dim1x1 sub
    tmp1_8 = tmp1_8 - tmp1_23;
    // Op 1408: dim1x1 mul
    tmp1_8 = tmp1_9 * tmp1_8;
    // Op 1409: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_8; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1410: dim3x3 mul
    gl64_t s1_1410_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1410_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1410_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1410 = (tmp3_0 + tmp3_1) * (s1_1410_0 + s1_1410_1);
    gl64_t kB1410 = (tmp3_0 + tmp3_2) * (s1_1410_0 + s1_1410_2);
    gl64_t kC1410 = (tmp3_1 + tmp3_2) * (s1_1410_1 + s1_1410_2);
    gl64_t kD1410 = tmp3_0 * s1_1410_0;
    gl64_t kE1410 = tmp3_1 * s1_1410_1;
    gl64_t kF1410 = tmp3_2 * s1_1410_2;
    gl64_t kG1410 = kD1410 - kE1410;
    tmp3_0 = (kC1410 + kG1410) - kF1410;
    tmp3_1 = ((((kA1410 + kC1410) - kE1410) - kE1410) - kD1410);
    tmp3_2 = kB1410 - kG1410;
    // Op 1411: dim1x1 add
    gl64_t s0_1411 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1411 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_8 = s0_1411 + s1_1411;
    // Op 1412: dim1x1 add
    gl64_t s0_1412 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_8 = s0_1412 + tmp1_8;
    // Op 1413: dim1x1 add
    gl64_t s0_1413 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_8 = s0_1413 + tmp1_8;
    // Op 1414: dim1x1 add
    gl64_t s0_1414 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_23 = s0_1414 + tmp1_8;
    // Op 1415: dim1x1 mul
    gl64_t s0_1415 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1415 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 8, domainSize, nCols_1))];
    tmp1_9 = s0_1415 * s1_1415;
    // Op 1416: dim1x1 sub_swap
    gl64_t s0_1416 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1416 = *(gl64_t*)&expressions_params[9][26];
    tmp1_8 = s1_1416 - s0_1416;
    // Op 1417: dim1x1 mul
    gl64_t s0_1417 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 35, domainSize, nCols_1))];
    tmp1_8 = s0_1417 * tmp1_8;
    // Op 1418: dim1x1 add
    tmp1_8 = tmp1_9 + tmp1_8;
    // Op 1419: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_4;
    // Op 1420: dim1x1 sub
    tmp1_8 = tmp1_8 - tmp1_20;
    // Op 1421: dim1x1 mul
    tmp1_8 = tmp1_23 * tmp1_8;
    // Op 1422: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_8; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC1423 + kG1423) - kF1423;
    tmp3_1 = ((((kA1423 + kC1423) - kE1423) - kE1423) - kD1423);
    tmp3_2 = kB1423 - kG1423;
    // Op 1424: dim1x1 add
    gl64_t s0_1424 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1424 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_8 = s0_1424 + s1_1424;
    // Op 1425: dim1x1 add
    gl64_t s0_1425 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_8 = s0_1425 + tmp1_8;
    // Op 1426: dim1x1 add
    gl64_t s0_1426 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_8 = s0_1426 + tmp1_8;
    // Op 1427: dim1x1 add
    gl64_t s0_1427 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_20 = s0_1427 + tmp1_8;
    // Op 1428: dim1x1 mul
    gl64_t s0_1428 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1428 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    tmp1_23 = s0_1428 * s1_1428;
    // Op 1429: dim1x1 sub_swap
    gl64_t s0_1429 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1429 = *(gl64_t*)&expressions_params[9][26];
    tmp1_8 = s1_1429 - s0_1429;
    // Op 1430: dim1x1 mul
    gl64_t s0_1430 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 36, domainSize, nCols_1))];
    tmp1_8 = s0_1430 * tmp1_8;
    // Op 1431: dim1x1 add
    tmp1_8 = tmp1_23 + tmp1_8;
    // Op 1432: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_5;
    // Op 1433: dim1x1 sub
    tmp1_8 = tmp1_8 - tmp1_10;
    // Op 1434: dim1x1 mul
    tmp1_8 = tmp1_20 * tmp1_8;
    // Op 1435: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_8; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1436: dim3x3 mul
    gl64_t s1_1436_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1436_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1436_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1436 = (tmp3_0 + tmp3_1) * (s1_1436_0 + s1_1436_1);
    gl64_t kB1436 = (tmp3_0 + tmp3_2) * (s1_1436_0 + s1_1436_2);
    gl64_t kC1436 = (tmp3_1 + tmp3_2) * (s1_1436_1 + s1_1436_2);
    gl64_t kD1436 = tmp3_0 * s1_1436_0;
    gl64_t kE1436 = tmp3_1 * s1_1436_1;
    gl64_t kF1436 = tmp3_2 * s1_1436_2;
    gl64_t kG1436 = kD1436 - kE1436;
    tmp3_0 = (kC1436 + kG1436) - kF1436;
    tmp3_1 = ((((kA1436 + kC1436) - kE1436) - kE1436) - kD1436);
    tmp3_2 = kB1436 - kG1436;
    // Op 1437: dim1x1 add
    gl64_t s0_1437 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1437 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_8 = s0_1437 + s1_1437;
    // Op 1438: dim1x1 add
    gl64_t s0_1438 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_8 = s0_1438 + tmp1_8;
    // Op 1439: dim1x1 add
    gl64_t s0_1439 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_8 = s0_1439 + tmp1_8;
    // Op 1440: dim1x1 add
    gl64_t s0_1440 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_10 = s0_1440 + tmp1_8;
    // Op 1441: dim1x1 mul
    gl64_t s0_1441 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1441 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 10, domainSize, nCols_1))];
    tmp1_20 = s0_1441 * s1_1441;
    // Op 1442: dim1x1 sub_swap
    gl64_t s0_1442 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1442 = *(gl64_t*)&expressions_params[9][26];
    tmp1_8 = s1_1442 - s0_1442;
    // Op 1443: dim1x1 mul
    gl64_t s0_1443 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 37, domainSize, nCols_1))];
    tmp1_8 = s0_1443 * tmp1_8;
    // Op 1444: dim1x1 add
    tmp1_8 = tmp1_20 + tmp1_8;
    // Op 1445: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_16;
    // Op 1446: dim1x1 sub
    tmp1_8 = tmp1_8 - tmp1_24;
    // Op 1447: dim1x1 mul
    tmp1_8 = tmp1_10 * tmp1_8;
    // Op 1448: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_8; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1449: dim3x3 mul
    gl64_t s1_1449_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1449_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1449_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 1450: dim1x1 add
    gl64_t s0_1450 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1450 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_8 = s0_1450 + s1_1450;
    // Op 1451: dim1x1 add
    gl64_t s0_1451 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_8 = s0_1451 + tmp1_8;
    // Op 1452: dim1x1 add
    gl64_t s0_1452 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_8 = s0_1452 + tmp1_8;
    // Op 1453: dim1x1 add
    gl64_t s0_1453 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_24 = s0_1453 + tmp1_8;
    // Op 1454: dim1x1 mul
    gl64_t s0_1454 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1454 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    tmp1_10 = s0_1454 * s1_1454;
    // Op 1455: dim1x1 sub_swap
    gl64_t s0_1455 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1455 = *(gl64_t*)&expressions_params[9][26];
    tmp1_8 = s1_1455 - s0_1455;
    // Op 1456: dim1x1 mul
    gl64_t s0_1456 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 38, domainSize, nCols_1))];
    tmp1_8 = s0_1456 * tmp1_8;
    // Op 1457: dim1x1 add
    tmp1_8 = tmp1_10 + tmp1_8;
    // Op 1458: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_6;
    // Op 1459: dim1x1 sub
    tmp1_8 = tmp1_8 - tmp1_12;
    // Op 1460: dim1x1 mul
    tmp1_8 = tmp1_24 * tmp1_8;
    // Op 1461: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_8; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC1462 + kG1462) - kF1462;
    tmp3_1 = ((((kA1462 + kC1462) - kE1462) - kE1462) - kD1462);
    tmp3_2 = kB1462 - kG1462;
    // Op 1463: dim1x1 add
    gl64_t s0_1463 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1463 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_8 = s0_1463 + s1_1463;
    // Op 1464: dim1x1 add
    gl64_t s0_1464 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_8 = s0_1464 + tmp1_8;
    // Op 1465: dim1x1 add
    gl64_t s0_1465 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_8 = s0_1465 + tmp1_8;
    // Op 1466: dim1x1 add
    gl64_t s0_1466 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_12 = s0_1466 + tmp1_8;
    // Op 1467: dim1x1 mul
    gl64_t s0_1467 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1467 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_1))];
    tmp1_24 = s0_1467 * s1_1467;
    // Op 1468: dim1x1 sub_swap
    gl64_t s0_1468 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1468 = *(gl64_t*)&expressions_params[9][26];
    tmp1_8 = s1_1468 - s0_1468;
    // Op 1469: dim1x1 mul
    gl64_t s0_1469 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_1))];
    tmp1_8 = s0_1469 * tmp1_8;
    // Op 1470: dim1x1 add
    tmp1_8 = tmp1_24 + tmp1_8;
    // Op 1471: dim1x1 add
    tmp1_4 = tmp1_22 + tmp1_4;
    // Op 1472: dim1x1 sub
    tmp1_4 = tmp1_8 - tmp1_4;
    // Op 1473: dim1x1 mul
    tmp1_4 = tmp1_12 * tmp1_4;
    // Op 1474: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1475: dim3x3 mul
    gl64_t s1_1475_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1475_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1475_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 1476: dim1x1 add
    gl64_t s0_1476 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1476 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_4 = s0_1476 + s1_1476;
    // Op 1477: dim1x1 add
    gl64_t s0_1477 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_4 = s0_1477 + tmp1_4;
    // Op 1478: dim1x1 add
    gl64_t s0_1478 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_4 = s0_1478 + tmp1_4;
    // Op 1479: dim1x1 add
    gl64_t s0_1479 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_8 = s0_1479 + tmp1_4;
    // Op 1480: dim1x1 mul
    gl64_t s0_1480 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1480 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    tmp1_12 = s0_1480 * s1_1480;
    // Op 1481: dim1x1 sub_swap
    gl64_t s0_1481 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1481 = *(gl64_t*)&expressions_params[9][26];
    tmp1_4 = s1_1481 - s0_1481;
    // Op 1482: dim1x1 mul
    gl64_t s0_1482 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_1))];
    tmp1_4 = s0_1482 * tmp1_4;
    // Op 1483: dim1x1 add
    tmp1_4 = tmp1_12 + tmp1_4;
    // Op 1484: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_5;
    // Op 1485: dim1x1 sub
    tmp1_1 = tmp1_4 - tmp1_1;
    // Op 1486: dim1x1 mul
    tmp1_1 = tmp1_8 * tmp1_1;
    // Op 1487: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC1488 + kG1488) - kF1488;
    tmp3_1 = ((((kA1488 + kC1488) - kE1488) - kE1488) - kD1488);
    tmp3_2 = kB1488 - kG1488;
    // Op 1489: dim1x1 add
    gl64_t s0_1489 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1489 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_1 = s0_1489 + s1_1489;
    // Op 1490: dim1x1 add
    gl64_t s0_1490 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_1 = s0_1490 + tmp1_1;
    // Op 1491: dim1x1 add
    gl64_t s0_1491 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_1 = s0_1491 + tmp1_1;
    // Op 1492: dim1x1 add
    gl64_t s0_1492 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_4 = s0_1492 + tmp1_1;
    // Op 1493: dim1x1 mul
    gl64_t s0_1493 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1493 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    tmp1_8 = s0_1493 * s1_1493;
    // Op 1494: dim1x1 sub_swap
    gl64_t s0_1494 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1494 = *(gl64_t*)&expressions_params[9][26];
    tmp1_1 = s1_1494 - s0_1494;
    // Op 1495: dim1x1 mul
    gl64_t s0_1495 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 41, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 41, domainSize, nCols_1))];
    tmp1_1 = s0_1495 * tmp1_1;
    // Op 1496: dim1x1 add
    tmp1_1 = tmp1_8 + tmp1_1;
    // Op 1497: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_16;
    // Op 1498: dim1x1 sub
    tmp1_1 = tmp1_1 - tmp1_13;
    // Op 1499: dim1x1 mul
    tmp1_1 = tmp1_4 * tmp1_1;
    // Op 1500: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1501: dim3x3 mul
    gl64_t s1_1501_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1501_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1501_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1501 = (tmp3_0 + tmp3_1) * (s1_1501_0 + s1_1501_1);
    gl64_t kB1501 = (tmp3_0 + tmp3_2) * (s1_1501_0 + s1_1501_2);
    gl64_t kC1501 = (tmp3_1 + tmp3_2) * (s1_1501_1 + s1_1501_2);
    gl64_t kD1501 = tmp3_0 * s1_1501_0;
    gl64_t kE1501 = tmp3_1 * s1_1501_1;
    gl64_t kF1501 = tmp3_2 * s1_1501_2;
    gl64_t kG1501 = kD1501 - kE1501;
    tmp3_0 = (kC1501 + kG1501) - kF1501;
    tmp3_1 = ((((kA1501 + kC1501) - kE1501) - kE1501) - kD1501);
    tmp3_2 = kB1501 - kG1501;
    // Op 1502: dim1x1 add
    gl64_t s0_1502 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_0)];
    gl64_t s1_1502 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_0)];
    tmp1_1 = s0_1502 + s1_1502;
    // Op 1503: dim1x1 add
    gl64_t s0_1503 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_0)];
    tmp1_1 = s0_1503 + tmp1_1;
    // Op 1504: dim1x1 add
    gl64_t s0_1504 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_0)];
    tmp1_1 = s0_1504 + tmp1_1;
    // Op 1505: dim1x1 add
    gl64_t s0_1505 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    tmp1_13 = s0_1505 + tmp1_1;
    // Op 1506: dim1x1 mul
    gl64_t s0_1506 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1506 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_4 = s0_1506 * s1_1506;
    // Op 1507: dim1x1 sub_swap
    gl64_t s0_1507 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_0)];
    gl64_t s1_1507 = *(gl64_t*)&expressions_params[9][26];
    tmp1_1 = s1_1507 - s0_1507;
    // Op 1508: dim1x1 mul
    gl64_t s0_1508 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 42, domainSize, nCols_1))];
    tmp1_1 = s0_1508 * tmp1_1;
    // Op 1509: dim1x1 add
    tmp1_1 = tmp1_4 + tmp1_1;
    // Op 1510: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_6;
    // Op 1511: dim1x1 sub
    tmp1_0 = tmp1_1 - tmp1_0;
    // Op 1512: dim1x1 mul
    tmp1_0 = tmp1_13 * tmp1_0;
    // Op 1513: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1514: dim3x3 mul
    gl64_t s1_1514_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1514_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1514_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1514 = (tmp3_0 + tmp3_1) * (s1_1514_0 + s1_1514_1);
    gl64_t kB1514 = (tmp3_0 + tmp3_2) * (s1_1514_0 + s1_1514_2);
    gl64_t kC1514 = (tmp3_1 + tmp3_2) * (s1_1514_1 + s1_1514_2);
    gl64_t kD1514 = tmp3_0 * s1_1514_0;
    gl64_t kE1514 = tmp3_1 * s1_1514_1;
    gl64_t kF1514 = tmp3_2 * s1_1514_2;
    gl64_t kG1514 = kD1514 - kE1514;
    tmp3_0 = (kC1514 + kG1514) - kF1514;
    tmp3_1 = ((((kA1514 + kC1514) - kE1514) - kE1514) - kD1514);
    tmp3_2 = kB1514 - kG1514;
    // Op 1515: dim1x1 sub
    gl64_t s0_1515 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 43, domainSize, nCols_1))];
    gl64_t s1_1515 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 27, domainSize, nCols_1))];
    tmp1_0 = s0_1515 - s1_1515;
    // Op 1516: dim1x1 mul
    gl64_t s0_1516 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_0 = s0_1516 * tmp1_0;
    // Op 1517: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1518: dim3x3 mul
    gl64_t s1_1518_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1518_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1518_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 1519: dim1x1 add
    gl64_t s0_1519 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 43, domainSize, nCols_1))];
    tmp1_2 = s0_1519 + tmp1_2;
    // Op 1520: dim1x1 mul
    tmp1_2 = tmp1_11 * tmp1_2;
    // Op 1521: dim1x1 mul
    gl64_t s1_1521 = *(gl64_t*)&expressions_params[9][173];
    tmp1_11 = tmp1_2 * s1_1521;
    // Op 1522: dim1x1 add
    gl64_t s0_1522 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 28, domainSize, nCols_1))];
    tmp1_2 = s0_1522 + tmp1_2;
    // Op 1523: dim1x1 add
    gl64_t s0_1523 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 29, domainSize, nCols_1))];
    tmp1_2 = s0_1523 + tmp1_2;
    // Op 1524: dim1x1 add
    gl64_t s0_1524 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 30, domainSize, nCols_1))];
    tmp1_2 = s0_1524 + tmp1_2;
    // Op 1525: dim1x1 add
    gl64_t s0_1525 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 31, domainSize, nCols_1))];
    tmp1_2 = s0_1525 + tmp1_2;
    // Op 1526: dim1x1 add
    gl64_t s0_1526 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 32, domainSize, nCols_1))];
    tmp1_2 = s0_1526 + tmp1_2;
    // Op 1527: dim1x1 add
    gl64_t s0_1527 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_1))];
    tmp1_2 = s0_1527 + tmp1_2;
    // Op 1528: dim1x1 add
    gl64_t s0_1528 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 34, domainSize, nCols_1))];
    tmp1_2 = s0_1528 + tmp1_2;
    // Op 1529: dim1x1 add
    gl64_t s0_1529 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 35, domainSize, nCols_1))];
    tmp1_2 = s0_1529 + tmp1_2;
    // Op 1530: dim1x1 add
    gl64_t s0_1530 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 36, domainSize, nCols_1))];
    tmp1_2 = s0_1530 + tmp1_2;
    // Op 1531: dim1x1 add
    gl64_t s0_1531 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_1))];
    tmp1_2 = s0_1531 + tmp1_2;
    // Op 1532: dim1x1 add
    gl64_t s0_1532 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_1))];
    tmp1_2 = s0_1532 + tmp1_2;
    // Op 1533: dim1x1 add
    gl64_t s0_1533 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_1))];
    tmp1_2 = s0_1533 + tmp1_2;
    // Op 1534: dim1x1 add
    gl64_t s0_1534 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_1))];
    tmp1_2 = s0_1534 + tmp1_2;
    // Op 1535: dim1x1 add
    gl64_t s0_1535 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 41, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 41, domainSize, nCols_1))];
    tmp1_2 = s0_1535 + tmp1_2;
    // Op 1536: dim1x1 add
    gl64_t s0_1536 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 42, domainSize, nCols_1))];
    tmp1_2 = s0_1536 + tmp1_2;
    // Op 1537: dim1x1 add
    tmp1_11 = tmp1_11 + tmp1_2;
    // Op 1538: dim1x1 sub
    gl64_t s0_1538 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_1))];
    tmp1_11 = s0_1538 - tmp1_11;
    // Op 1539: dim1x1 mul
    gl64_t s0_1539 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_11 = s0_1539 * tmp1_11;
    // Op 1540: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_11; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1541: dim3x3 mul
    gl64_t s1_1541_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1541_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1541_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 1542: dim1x1 add
    gl64_t s0_1542 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_1))];
    tmp1_3 = s0_1542 + tmp1_3;
    // Op 1543: dim1x1 mul
    tmp1_26 = tmp1_26 * tmp1_3;
    // Op 1544: dim1x1 mul
    gl64_t s1_1544 = *(gl64_t*)&expressions_params[9][173];
    tmp1_11 = tmp1_26 * s1_1544;
    // Op 1545: dim1x1 mul
    gl64_t s0_1545 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 28, domainSize, nCols_1))];
    gl64_t s1_1545 = *(gl64_t*)&expressions_params[9][174];
    tmp1_3 = s0_1545 * s1_1545;
    // Op 1546: dim1x1 add
    tmp1_0 = tmp1_3 + tmp1_2;
    // Op 1547: dim1x1 add
    tmp1_3 = tmp1_26 + tmp1_0;
    // Op 1548: dim1x1 mul
    gl64_t s0_1548 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 29, domainSize, nCols_1))];
    gl64_t s1_1548 = *(gl64_t*)&expressions_params[9][175];
    tmp1_26 = s0_1548 * s1_1548;
    // Op 1549: dim1x1 add
    tmp1_13 = tmp1_26 + tmp1_2;
    // Op 1550: dim1x1 add
    tmp1_26 = tmp1_3 + tmp1_13;
    // Op 1551: dim1x1 mul
    gl64_t s0_1551 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 30, domainSize, nCols_1))];
    gl64_t s1_1551 = *(gl64_t*)&expressions_params[9][176];
    tmp1_3 = s0_1551 * s1_1551;
    // Op 1552: dim1x1 add
    tmp1_1 = tmp1_3 + tmp1_2;
    // Op 1553: dim1x1 add
    tmp1_3 = tmp1_26 + tmp1_1;
    // Op 1554: dim1x1 mul
    gl64_t s0_1554 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 31, domainSize, nCols_1))];
    gl64_t s1_1554 = *(gl64_t*)&expressions_params[9][177];
    tmp1_26 = s0_1554 * s1_1554;
    // Op 1555: dim1x1 add
    tmp1_6 = tmp1_26 + tmp1_2;
    // Op 1556: dim1x1 add
    tmp1_26 = tmp1_3 + tmp1_6;
    // Op 1557: dim1x1 mul
    gl64_t s0_1557 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 32, domainSize, nCols_1))];
    gl64_t s1_1557 = *(gl64_t*)&expressions_params[9][178];
    tmp1_3 = s0_1557 * s1_1557;
    // Op 1558: dim1x1 add
    tmp1_4 = tmp1_3 + tmp1_2;
    // Op 1559: dim1x1 add
    tmp1_3 = tmp1_26 + tmp1_4;
    // Op 1560: dim1x1 mul
    gl64_t s0_1560 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_1))];
    gl64_t s1_1560 = *(gl64_t*)&expressions_params[9][179];
    tmp1_26 = s0_1560 * s1_1560;
    // Op 1561: dim1x1 add
    tmp1_16 = tmp1_26 + tmp1_2;
    // Op 1562: dim1x1 add
    tmp1_26 = tmp1_3 + tmp1_16;
    // Op 1563: dim1x1 mul
    gl64_t s0_1563 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 34, domainSize, nCols_1))];
    gl64_t s1_1563 = *(gl64_t*)&expressions_params[9][180];
    tmp1_3 = s0_1563 * s1_1563;
    // Op 1564: dim1x1 add
    tmp1_8 = tmp1_3 + tmp1_2;
    // Op 1565: dim1x1 add
    tmp1_3 = tmp1_26 + tmp1_8;
    // Op 1566: dim1x1 mul
    gl64_t s0_1566 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 35, domainSize, nCols_1))];
    gl64_t s1_1566 = *(gl64_t*)&expressions_params[9][181];
    tmp1_26 = s0_1566 * s1_1566;
    // Op 1567: dim1x1 add
    tmp1_5 = tmp1_26 + tmp1_2;
    // Op 1568: dim1x1 add
    tmp1_26 = tmp1_3 + tmp1_5;
    // Op 1569: dim1x1 mul
    gl64_t s0_1569 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 36, domainSize, nCols_1))];
    gl64_t s1_1569 = *(gl64_t*)&expressions_params[9][182];
    tmp1_3 = s0_1569 * s1_1569;
    // Op 1570: dim1x1 add
    tmp1_12 = tmp1_3 + tmp1_2;
    // Op 1571: dim1x1 add
    tmp1_3 = tmp1_26 + tmp1_12;
    // Op 1572: dim1x1 mul
    gl64_t s0_1572 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 37, domainSize, nCols_1))];
    gl64_t s1_1572 = *(gl64_t*)&expressions_params[9][183];
    tmp1_26 = s0_1572 * s1_1572;
    // Op 1573: dim1x1 add
    tmp1_22 = tmp1_26 + tmp1_2;
    // Op 1574: dim1x1 add
    tmp1_26 = tmp1_3 + tmp1_22;
    // Op 1575: dim1x1 mul
    gl64_t s0_1575 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 38, domainSize, nCols_1))];
    gl64_t s1_1575 = *(gl64_t*)&expressions_params[9][184];
    tmp1_3 = s0_1575 * s1_1575;
    // Op 1576: dim1x1 add
    tmp1_24 = tmp1_3 + tmp1_2;
    // Op 1577: dim1x1 add
    tmp1_3 = tmp1_26 + tmp1_24;
    // Op 1578: dim1x1 mul
    gl64_t s0_1578 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_1))];
    gl64_t s1_1578 = *(gl64_t*)&expressions_params[9][185];
    tmp1_26 = s0_1578 * s1_1578;
    // Op 1579: dim1x1 add
    tmp1_10 = tmp1_26 + tmp1_2;
    // Op 1580: dim1x1 add
    tmp1_26 = tmp1_3 + tmp1_10;
    // Op 1581: dim1x1 mul
    gl64_t s0_1581 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 40, domainSize, nCols_1))];
    gl64_t s1_1581 = *(gl64_t*)&expressions_params[9][186];
    tmp1_3 = s0_1581 * s1_1581;
    // Op 1582: dim1x1 add
    tmp1_20 = tmp1_3 + tmp1_2;
    // Op 1583: dim1x1 add
    tmp1_3 = tmp1_26 + tmp1_20;
    // Op 1584: dim1x1 mul
    gl64_t s0_1584 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 41, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 41, domainSize, nCols_1))];
    gl64_t s1_1584 = *(gl64_t*)&expressions_params[9][187];
    tmp1_26 = s0_1584 * s1_1584;
    // Op 1585: dim1x1 add
    tmp1_23 = tmp1_26 + tmp1_2;
    // Op 1586: dim1x1 add
    tmp1_26 = tmp1_3 + tmp1_23;
    // Op 1587: dim1x1 mul
    gl64_t s0_1587 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 42, domainSize, nCols_1))];
    gl64_t s1_1587 = *(gl64_t*)&expressions_params[9][188];
    tmp1_3 = s0_1587 * s1_1587;
    // Op 1588: dim1x1 add
    tmp1_2 = tmp1_3 + tmp1_2;
    // Op 1589: dim1x1 add
    tmp1_26 = tmp1_26 + tmp1_2;
    // Op 1590: dim1x1 add
    tmp1_11 = tmp1_11 + tmp1_26;
    // Op 1591: dim1x1 sub
    gl64_t s0_1591 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_1))];
    tmp1_11 = s0_1591 - tmp1_11;
    // Op 1592: dim1x1 mul
    gl64_t s0_1592 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_11 = s0_1592 * tmp1_11;
    // Op 1593: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_11; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC1594 + kG1594) - kF1594;
    tmp3_1 = ((((kA1594 + kC1594) - kE1594) - kE1594) - kD1594);
    tmp3_2 = kB1594 - kG1594;
    // Op 1595: dim1x1 add
    gl64_t s0_1595 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_1))];
    tmp1_27 = s0_1595 + tmp1_27;
    // Op 1596: dim1x1 mul
    tmp1_27 = tmp1_28 * tmp1_27;
    // Op 1597: dim1x1 mul
    gl64_t s1_1597 = *(gl64_t*)&expressions_params[9][173];
    tmp1_28 = tmp1_27 * s1_1597;
    // Op 1598: dim1x1 mul
    gl64_t s1_1598 = *(gl64_t*)&expressions_params[9][174];
    tmp1_0 = tmp1_0 * s1_1598;
    // Op 1599: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_26;
    // Op 1600: dim1x1 add
    tmp1_27 = tmp1_27 + tmp1_0;
    // Op 1601: dim1x1 mul
    gl64_t s1_1601 = *(gl64_t*)&expressions_params[9][175];
    tmp1_13 = tmp1_13 * s1_1601;
    // Op 1602: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_26;
    // Op 1603: dim1x1 add
    tmp1_27 = tmp1_27 + tmp1_13;
    // Op 1604: dim1x1 mul
    gl64_t s1_1604 = *(gl64_t*)&expressions_params[9][176];
    tmp1_1 = tmp1_1 * s1_1604;
    // Op 1605: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_26;
    // Op 1606: dim1x1 add
    tmp1_27 = tmp1_27 + tmp1_1;
    // Op 1607: dim1x1 mul
    gl64_t s1_1607 = *(gl64_t*)&expressions_params[9][177];
    tmp1_6 = tmp1_6 * s1_1607;
    // Op 1608: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_26;
    // Op 1609: dim1x1 add
    tmp1_27 = tmp1_27 + tmp1_6;
    // Op 1610: dim1x1 mul
    gl64_t s1_1610 = *(gl64_t*)&expressions_params[9][178];
    tmp1_4 = tmp1_4 * s1_1610;
    // Op 1611: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_26;
    // Op 1612: dim1x1 add
    tmp1_27 = tmp1_27 + tmp1_4;
    // Op 1613: dim1x1 mul
    gl64_t s1_1613 = *(gl64_t*)&expressions_params[9][179];
    tmp1_16 = tmp1_16 * s1_1613;
    // Op 1614: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_26;
    // Op 1615: dim1x1 add
    tmp1_27 = tmp1_27 + tmp1_16;
    // Op 1616: dim1x1 mul
    gl64_t s1_1616 = *(gl64_t*)&expressions_params[9][180];
    tmp1_8 = tmp1_8 * s1_1616;
    // Op 1617: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_26;
    // Op 1618: dim1x1 add
    tmp1_27 = tmp1_27 + tmp1_8;
    // Op 1619: dim1x1 mul
    gl64_t s1_1619 = *(gl64_t*)&expressions_params[9][181];
    tmp1_5 = tmp1_5 * s1_1619;
    // Op 1620: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_26;
    // Op 1621: dim1x1 add
    tmp1_27 = tmp1_27 + tmp1_5;
    // Op 1622: dim1x1 mul
    gl64_t s1_1622 = *(gl64_t*)&expressions_params[9][182];
    tmp1_12 = tmp1_12 * s1_1622;
    // Op 1623: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_26;
    // Op 1624: dim1x1 add
    tmp1_27 = tmp1_27 + tmp1_12;
    // Op 1625: dim1x1 mul
    gl64_t s1_1625 = *(gl64_t*)&expressions_params[9][183];
    tmp1_22 = tmp1_22 * s1_1625;
    // Op 1626: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_26;
    // Op 1627: dim1x1 add
    tmp1_27 = tmp1_27 + tmp1_22;
    // Op 1628: dim1x1 mul
    gl64_t s1_1628 = *(gl64_t*)&expressions_params[9][184];
    tmp1_24 = tmp1_24 * s1_1628;
    // Op 1629: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_26;
    // Op 1630: dim1x1 add
    tmp1_27 = tmp1_27 + tmp1_24;
    // Op 1631: dim1x1 mul
    gl64_t s1_1631 = *(gl64_t*)&expressions_params[9][185];
    tmp1_10 = tmp1_10 * s1_1631;
    // Op 1632: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_26;
    // Op 1633: dim1x1 add
    tmp1_27 = tmp1_27 + tmp1_10;
    // Op 1634: dim1x1 mul
    gl64_t s1_1634 = *(gl64_t*)&expressions_params[9][186];
    tmp1_20 = tmp1_20 * s1_1634;
    // Op 1635: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_26;
    // Op 1636: dim1x1 add
    tmp1_27 = tmp1_27 + tmp1_20;
    // Op 1637: dim1x1 mul
    gl64_t s1_1637 = *(gl64_t*)&expressions_params[9][187];
    tmp1_23 = tmp1_23 * s1_1637;
    // Op 1638: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_26;
    // Op 1639: dim1x1 add
    tmp1_27 = tmp1_27 + tmp1_23;
    // Op 1640: dim1x1 mul
    gl64_t s1_1640 = *(gl64_t*)&expressions_params[9][188];
    tmp1_2 = tmp1_2 * s1_1640;
    // Op 1641: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_26;
    // Op 1642: dim1x1 add
    tmp1_27 = tmp1_27 + tmp1_2;
    // Op 1643: dim1x1 add
    tmp1_28 = tmp1_28 + tmp1_27;
    // Op 1644: dim1x1 sub
    gl64_t s0_1644 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 46, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 46, domainSize, nCols_1))];
    tmp1_28 = s0_1644 - tmp1_28;
    // Op 1645: dim1x1 mul
    gl64_t s0_1645 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_28 = s0_1645 * tmp1_28;
    // Op 1646: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_28; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1647: dim3x3 mul
    gl64_t s1_1647_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1647_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1647_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1647 = (tmp3_0 + tmp3_1) * (s1_1647_0 + s1_1647_1);
    gl64_t kB1647 = (tmp3_0 + tmp3_2) * (s1_1647_0 + s1_1647_2);
    gl64_t kC1647 = (tmp3_1 + tmp3_2) * (s1_1647_1 + s1_1647_2);
    gl64_t kD1647 = tmp3_0 * s1_1647_0;
    gl64_t kE1647 = tmp3_1 * s1_1647_1;
    gl64_t kF1647 = tmp3_2 * s1_1647_2;
    gl64_t kG1647 = kD1647 - kE1647;
    tmp3_0 = (kC1647 + kG1647) - kF1647;
    tmp3_1 = ((((kA1647 + kC1647) - kE1647) - kE1647) - kD1647);
    tmp3_2 = kB1647 - kG1647;
    // Op 1648: dim1x1 add
    gl64_t s0_1648 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 46, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 46, domainSize, nCols_1))];
    tmp1_29 = s0_1648 + tmp1_29;
    // Op 1649: dim1x1 mul
    tmp1_29 = tmp1_30 * tmp1_29;
    // Op 1650: dim1x1 mul
    gl64_t s1_1650 = *(gl64_t*)&expressions_params[9][173];
    tmp1_30 = tmp1_29 * s1_1650;
    // Op 1651: dim1x1 mul
    gl64_t s1_1651 = *(gl64_t*)&expressions_params[9][174];
    tmp1_0 = tmp1_0 * s1_1651;
    // Op 1652: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_27;
    // Op 1653: dim1x1 add
    tmp1_29 = tmp1_29 + tmp1_0;
    // Op 1654: dim1x1 mul
    gl64_t s1_1654 = *(gl64_t*)&expressions_params[9][175];
    tmp1_13 = tmp1_13 * s1_1654;
    // Op 1655: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_27;
    // Op 1656: dim1x1 add
    tmp1_29 = tmp1_29 + tmp1_13;
    // Op 1657: dim1x1 mul
    gl64_t s1_1657 = *(gl64_t*)&expressions_params[9][176];
    tmp1_1 = tmp1_1 * s1_1657;
    // Op 1658: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_27;
    // Op 1659: dim1x1 add
    tmp1_29 = tmp1_29 + tmp1_1;
    // Op 1660: dim1x1 mul
    gl64_t s1_1660 = *(gl64_t*)&expressions_params[9][177];
    tmp1_6 = tmp1_6 * s1_1660;
    // Op 1661: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_27;
    // Op 1662: dim1x1 add
    tmp1_29 = tmp1_29 + tmp1_6;
    // Op 1663: dim1x1 mul
    gl64_t s1_1663 = *(gl64_t*)&expressions_params[9][178];
    tmp1_4 = tmp1_4 * s1_1663;
    // Op 1664: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_27;
    // Op 1665: dim1x1 add
    tmp1_29 = tmp1_29 + tmp1_4;
    // Op 1666: dim1x1 mul
    gl64_t s1_1666 = *(gl64_t*)&expressions_params[9][179];
    tmp1_16 = tmp1_16 * s1_1666;
    // Op 1667: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_27;
    // Op 1668: dim1x1 add
    tmp1_29 = tmp1_29 + tmp1_16;
    // Op 1669: dim1x1 mul
    gl64_t s1_1669 = *(gl64_t*)&expressions_params[9][180];
    tmp1_8 = tmp1_8 * s1_1669;
    // Op 1670: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_27;
    // Op 1671: dim1x1 add
    tmp1_29 = tmp1_29 + tmp1_8;
    // Op 1672: dim1x1 mul
    gl64_t s1_1672 = *(gl64_t*)&expressions_params[9][181];
    tmp1_5 = tmp1_5 * s1_1672;
    // Op 1673: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_27;
    // Op 1674: dim1x1 add
    tmp1_29 = tmp1_29 + tmp1_5;
    // Op 1675: dim1x1 mul
    gl64_t s1_1675 = *(gl64_t*)&expressions_params[9][182];
    tmp1_12 = tmp1_12 * s1_1675;
    // Op 1676: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_27;
    // Op 1677: dim1x1 add
    tmp1_29 = tmp1_29 + tmp1_12;
    // Op 1678: dim1x1 mul
    gl64_t s1_1678 = *(gl64_t*)&expressions_params[9][183];
    tmp1_22 = tmp1_22 * s1_1678;
    // Op 1679: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_27;
    // Op 1680: dim1x1 add
    tmp1_29 = tmp1_29 + tmp1_22;
    // Op 1681: dim1x1 mul
    gl64_t s1_1681 = *(gl64_t*)&expressions_params[9][184];
    tmp1_24 = tmp1_24 * s1_1681;
    // Op 1682: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_27;
    // Op 1683: dim1x1 add
    tmp1_29 = tmp1_29 + tmp1_24;
    // Op 1684: dim1x1 mul
    gl64_t s1_1684 = *(gl64_t*)&expressions_params[9][185];
    tmp1_10 = tmp1_10 * s1_1684;
    // Op 1685: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_27;
    // Op 1686: dim1x1 add
    tmp1_29 = tmp1_29 + tmp1_10;
    // Op 1687: dim1x1 mul
    gl64_t s1_1687 = *(gl64_t*)&expressions_params[9][186];
    tmp1_20 = tmp1_20 * s1_1687;
    // Op 1688: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_27;
    // Op 1689: dim1x1 add
    tmp1_29 = tmp1_29 + tmp1_20;
    // Op 1690: dim1x1 mul
    gl64_t s1_1690 = *(gl64_t*)&expressions_params[9][187];
    tmp1_23 = tmp1_23 * s1_1690;
    // Op 1691: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_27;
    // Op 1692: dim1x1 add
    tmp1_29 = tmp1_29 + tmp1_23;
    // Op 1693: dim1x1 mul
    gl64_t s1_1693 = *(gl64_t*)&expressions_params[9][188];
    tmp1_2 = tmp1_2 * s1_1693;
    // Op 1694: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_27;
    // Op 1695: dim1x1 add
    tmp1_29 = tmp1_29 + tmp1_2;
    // Op 1696: dim1x1 add
    tmp1_30 = tmp1_30 + tmp1_29;
    // Op 1697: dim1x1 sub
    gl64_t s0_1697 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_1))];
    tmp1_30 = s0_1697 - tmp1_30;
    // Op 1698: dim1x1 mul
    gl64_t s0_1698 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_30 = s0_1698 * tmp1_30;
    // Op 1699: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_30; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1700: dim3x3 mul
    gl64_t s1_1700_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1700_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1700_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 1701: dim1x1 add
    gl64_t s0_1701 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_1))];
    tmp1_31 = s0_1701 + tmp1_31;
    // Op 1702: dim1x1 mul
    tmp1_31 = tmp1_32 * tmp1_31;
    // Op 1703: dim1x1 mul
    gl64_t s1_1703 = *(gl64_t*)&expressions_params[9][173];
    tmp1_32 = tmp1_31 * s1_1703;
    // Op 1704: dim1x1 mul
    gl64_t s1_1704 = *(gl64_t*)&expressions_params[9][174];
    tmp1_0 = tmp1_0 * s1_1704;
    // Op 1705: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_29;
    // Op 1706: dim1x1 add
    tmp1_31 = tmp1_31 + tmp1_0;
    // Op 1707: dim1x1 mul
    gl64_t s1_1707 = *(gl64_t*)&expressions_params[9][175];
    tmp1_13 = tmp1_13 * s1_1707;
    // Op 1708: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_29;
    // Op 1709: dim1x1 add
    tmp1_31 = tmp1_31 + tmp1_13;
    // Op 1710: dim1x1 mul
    gl64_t s1_1710 = *(gl64_t*)&expressions_params[9][176];
    tmp1_1 = tmp1_1 * s1_1710;
    // Op 1711: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_29;
    // Op 1712: dim1x1 add
    tmp1_31 = tmp1_31 + tmp1_1;
    // Op 1713: dim1x1 mul
    gl64_t s1_1713 = *(gl64_t*)&expressions_params[9][177];
    tmp1_6 = tmp1_6 * s1_1713;
    // Op 1714: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_29;
    // Op 1715: dim1x1 add
    tmp1_31 = tmp1_31 + tmp1_6;
    // Op 1716: dim1x1 mul
    gl64_t s1_1716 = *(gl64_t*)&expressions_params[9][178];
    tmp1_4 = tmp1_4 * s1_1716;
    // Op 1717: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_29;
    // Op 1718: dim1x1 add
    tmp1_31 = tmp1_31 + tmp1_4;
    // Op 1719: dim1x1 mul
    gl64_t s1_1719 = *(gl64_t*)&expressions_params[9][179];
    tmp1_16 = tmp1_16 * s1_1719;
    // Op 1720: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_29;
    // Op 1721: dim1x1 add
    tmp1_31 = tmp1_31 + tmp1_16;
    // Op 1722: dim1x1 mul
    gl64_t s1_1722 = *(gl64_t*)&expressions_params[9][180];
    tmp1_8 = tmp1_8 * s1_1722;
    // Op 1723: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_29;
    // Op 1724: dim1x1 add
    tmp1_31 = tmp1_31 + tmp1_8;
    // Op 1725: dim1x1 mul
    gl64_t s1_1725 = *(gl64_t*)&expressions_params[9][181];
    tmp1_5 = tmp1_5 * s1_1725;
    // Op 1726: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_29;
    // Op 1727: dim1x1 add
    tmp1_31 = tmp1_31 + tmp1_5;
    // Op 1728: dim1x1 mul
    gl64_t s1_1728 = *(gl64_t*)&expressions_params[9][182];
    tmp1_12 = tmp1_12 * s1_1728;
    // Op 1729: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_29;
    // Op 1730: dim1x1 add
    tmp1_31 = tmp1_31 + tmp1_12;
    // Op 1731: dim1x1 mul
    gl64_t s1_1731 = *(gl64_t*)&expressions_params[9][183];
    tmp1_22 = tmp1_22 * s1_1731;
    // Op 1732: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_29;
    // Op 1733: dim1x1 add
    tmp1_31 = tmp1_31 + tmp1_22;
    // Op 1734: dim1x1 mul
    gl64_t s1_1734 = *(gl64_t*)&expressions_params[9][184];
    tmp1_24 = tmp1_24 * s1_1734;
    // Op 1735: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_29;
    // Op 1736: dim1x1 add
    tmp1_31 = tmp1_31 + tmp1_24;
    // Op 1737: dim1x1 mul
    gl64_t s1_1737 = *(gl64_t*)&expressions_params[9][185];
    tmp1_10 = tmp1_10 * s1_1737;
    // Op 1738: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_29;
    // Op 1739: dim1x1 add
    tmp1_31 = tmp1_31 + tmp1_10;
    // Op 1740: dim1x1 mul
    gl64_t s1_1740 = *(gl64_t*)&expressions_params[9][186];
    tmp1_20 = tmp1_20 * s1_1740;
    // Op 1741: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_29;
    // Op 1742: dim1x1 add
    tmp1_31 = tmp1_31 + tmp1_20;
    // Op 1743: dim1x1 mul
    gl64_t s1_1743 = *(gl64_t*)&expressions_params[9][187];
    tmp1_23 = tmp1_23 * s1_1743;
    // Op 1744: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_29;
    // Op 1745: dim1x1 add
    tmp1_31 = tmp1_31 + tmp1_23;
    // Op 1746: dim1x1 mul
    gl64_t s1_1746 = *(gl64_t*)&expressions_params[9][188];
    tmp1_2 = tmp1_2 * s1_1746;
    // Op 1747: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_29;
    // Op 1748: dim1x1 add
    tmp1_31 = tmp1_31 + tmp1_2;
    // Op 1749: dim1x1 add
    tmp1_32 = tmp1_32 + tmp1_31;
    // Op 1750: dim1x1 sub
    gl64_t s0_1750 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 48, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 48, domainSize, nCols_1))];
    tmp1_32 = s0_1750 - tmp1_32;
    // Op 1751: dim1x1 mul
    gl64_t s0_1751 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_32 = s0_1751 * tmp1_32;
    // Op 1752: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_32; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1753: dim3x3 mul
    gl64_t s1_1753_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1753_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1753_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1753 = (tmp3_0 + tmp3_1) * (s1_1753_0 + s1_1753_1);
    gl64_t kB1753 = (tmp3_0 + tmp3_2) * (s1_1753_0 + s1_1753_2);
    gl64_t kC1753 = (tmp3_1 + tmp3_2) * (s1_1753_1 + s1_1753_2);
    gl64_t kD1753 = tmp3_0 * s1_1753_0;
    gl64_t kE1753 = tmp3_1 * s1_1753_1;
    gl64_t kF1753 = tmp3_2 * s1_1753_2;
    gl64_t kG1753 = kD1753 - kE1753;
    tmp3_0 = (kC1753 + kG1753) - kF1753;
    tmp3_1 = ((((kA1753 + kC1753) - kE1753) - kE1753) - kD1753);
    tmp3_2 = kB1753 - kG1753;
    // Op 1754: dim1x1 add
    gl64_t s0_1754 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 48, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 48, domainSize, nCols_1))];
    tmp1_33 = s0_1754 + tmp1_33;
    // Op 1755: dim1x1 mul
    tmp1_33 = tmp1_34 * tmp1_33;
    // Op 1756: dim1x1 mul
    gl64_t s1_1756 = *(gl64_t*)&expressions_params[9][173];
    tmp1_34 = tmp1_33 * s1_1756;
    // Op 1757: dim1x1 mul
    gl64_t s1_1757 = *(gl64_t*)&expressions_params[9][174];
    tmp1_0 = tmp1_0 * s1_1757;
    // Op 1758: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_31;
    // Op 1759: dim1x1 add
    tmp1_33 = tmp1_33 + tmp1_0;
    // Op 1760: dim1x1 mul
    gl64_t s1_1760 = *(gl64_t*)&expressions_params[9][175];
    tmp1_13 = tmp1_13 * s1_1760;
    // Op 1761: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_31;
    // Op 1762: dim1x1 add
    tmp1_33 = tmp1_33 + tmp1_13;
    // Op 1763: dim1x1 mul
    gl64_t s1_1763 = *(gl64_t*)&expressions_params[9][176];
    tmp1_1 = tmp1_1 * s1_1763;
    // Op 1764: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_31;
    // Op 1765: dim1x1 add
    tmp1_33 = tmp1_33 + tmp1_1;
    // Op 1766: dim1x1 mul
    gl64_t s1_1766 = *(gl64_t*)&expressions_params[9][177];
    tmp1_6 = tmp1_6 * s1_1766;
    // Op 1767: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_31;
    // Op 1768: dim1x1 add
    tmp1_33 = tmp1_33 + tmp1_6;
    // Op 1769: dim1x1 mul
    gl64_t s1_1769 = *(gl64_t*)&expressions_params[9][178];
    tmp1_4 = tmp1_4 * s1_1769;
    // Op 1770: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_31;
    // Op 1771: dim1x1 add
    tmp1_33 = tmp1_33 + tmp1_4;
    // Op 1772: dim1x1 mul
    gl64_t s1_1772 = *(gl64_t*)&expressions_params[9][179];
    tmp1_16 = tmp1_16 * s1_1772;
    // Op 1773: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_31;
    // Op 1774: dim1x1 add
    tmp1_33 = tmp1_33 + tmp1_16;
    // Op 1775: dim1x1 mul
    gl64_t s1_1775 = *(gl64_t*)&expressions_params[9][180];
    tmp1_8 = tmp1_8 * s1_1775;
    // Op 1776: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_31;
    // Op 1777: dim1x1 add
    tmp1_33 = tmp1_33 + tmp1_8;
    // Op 1778: dim1x1 mul
    gl64_t s1_1778 = *(gl64_t*)&expressions_params[9][181];
    tmp1_5 = tmp1_5 * s1_1778;
    // Op 1779: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_31;
    // Op 1780: dim1x1 add
    tmp1_33 = tmp1_33 + tmp1_5;
    // Op 1781: dim1x1 mul
    gl64_t s1_1781 = *(gl64_t*)&expressions_params[9][182];
    tmp1_12 = tmp1_12 * s1_1781;
    // Op 1782: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_31;
    // Op 1783: dim1x1 add
    tmp1_33 = tmp1_33 + tmp1_12;
    // Op 1784: dim1x1 mul
    gl64_t s1_1784 = *(gl64_t*)&expressions_params[9][183];
    tmp1_22 = tmp1_22 * s1_1784;
    // Op 1785: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_31;
    // Op 1786: dim1x1 add
    tmp1_33 = tmp1_33 + tmp1_22;
    // Op 1787: dim1x1 mul
    gl64_t s1_1787 = *(gl64_t*)&expressions_params[9][184];
    tmp1_24 = tmp1_24 * s1_1787;
    // Op 1788: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_31;
    // Op 1789: dim1x1 add
    tmp1_33 = tmp1_33 + tmp1_24;
    // Op 1790: dim1x1 mul
    gl64_t s1_1790 = *(gl64_t*)&expressions_params[9][185];
    tmp1_10 = tmp1_10 * s1_1790;
    // Op 1791: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_31;
    // Op 1792: dim1x1 add
    tmp1_33 = tmp1_33 + tmp1_10;
    // Op 1793: dim1x1 mul
    gl64_t s1_1793 = *(gl64_t*)&expressions_params[9][186];
    tmp1_20 = tmp1_20 * s1_1793;
    // Op 1794: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_31;
    // Op 1795: dim1x1 add
    tmp1_33 = tmp1_33 + tmp1_20;
    // Op 1796: dim1x1 mul
    gl64_t s1_1796 = *(gl64_t*)&expressions_params[9][187];
    tmp1_23 = tmp1_23 * s1_1796;
    // Op 1797: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_31;
    // Op 1798: dim1x1 add
    tmp1_33 = tmp1_33 + tmp1_23;
    // Op 1799: dim1x1 mul
    gl64_t s1_1799 = *(gl64_t*)&expressions_params[9][188];
    tmp1_2 = tmp1_2 * s1_1799;
    // Op 1800: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_31;
    // Op 1801: dim1x1 add
    tmp1_33 = tmp1_33 + tmp1_2;
    // Op 1802: dim1x1 add
    tmp1_34 = tmp1_34 + tmp1_33;
    // Op 1803: dim1x1 sub
    gl64_t s0_1803 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 49, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 49, domainSize, nCols_1))];
    tmp1_34 = s0_1803 - tmp1_34;
    // Op 1804: dim1x1 mul
    gl64_t s0_1804 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_34 = s0_1804 * tmp1_34;
    // Op 1805: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_34; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1806: dim3x3 mul
    gl64_t s1_1806_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1806_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1806_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 1807: dim1x1 add
    gl64_t s0_1807 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 49, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 49, domainSize, nCols_1))];
    tmp1_35 = s0_1807 + tmp1_35;
    // Op 1808: dim1x1 mul
    tmp1_35 = tmp1_36 * tmp1_35;
    // Op 1809: dim1x1 mul
    gl64_t s1_1809 = *(gl64_t*)&expressions_params[9][173];
    tmp1_36 = tmp1_35 * s1_1809;
    // Op 1810: dim1x1 mul
    gl64_t s1_1810 = *(gl64_t*)&expressions_params[9][174];
    tmp1_0 = tmp1_0 * s1_1810;
    // Op 1811: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_33;
    // Op 1812: dim1x1 add
    tmp1_35 = tmp1_35 + tmp1_0;
    // Op 1813: dim1x1 mul
    gl64_t s1_1813 = *(gl64_t*)&expressions_params[9][175];
    tmp1_13 = tmp1_13 * s1_1813;
    // Op 1814: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_33;
    // Op 1815: dim1x1 add
    tmp1_35 = tmp1_35 + tmp1_13;
    // Op 1816: dim1x1 mul
    gl64_t s1_1816 = *(gl64_t*)&expressions_params[9][176];
    tmp1_1 = tmp1_1 * s1_1816;
    // Op 1817: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_33;
    // Op 1818: dim1x1 add
    tmp1_35 = tmp1_35 + tmp1_1;
    // Op 1819: dim1x1 mul
    gl64_t s1_1819 = *(gl64_t*)&expressions_params[9][177];
    tmp1_6 = tmp1_6 * s1_1819;
    // Op 1820: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_33;
    // Op 1821: dim1x1 add
    tmp1_35 = tmp1_35 + tmp1_6;
    // Op 1822: dim1x1 mul
    gl64_t s1_1822 = *(gl64_t*)&expressions_params[9][178];
    tmp1_4 = tmp1_4 * s1_1822;
    // Op 1823: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_33;
    // Op 1824: dim1x1 add
    tmp1_35 = tmp1_35 + tmp1_4;
    // Op 1825: dim1x1 mul
    gl64_t s1_1825 = *(gl64_t*)&expressions_params[9][179];
    tmp1_16 = tmp1_16 * s1_1825;
    // Op 1826: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_33;
    // Op 1827: dim1x1 add
    tmp1_35 = tmp1_35 + tmp1_16;
    // Op 1828: dim1x1 mul
    gl64_t s1_1828 = *(gl64_t*)&expressions_params[9][180];
    tmp1_8 = tmp1_8 * s1_1828;
    // Op 1829: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_33;
    // Op 1830: dim1x1 add
    tmp1_35 = tmp1_35 + tmp1_8;
    // Op 1831: dim1x1 mul
    gl64_t s1_1831 = *(gl64_t*)&expressions_params[9][181];
    tmp1_5 = tmp1_5 * s1_1831;
    // Op 1832: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_33;
    // Op 1833: dim1x1 add
    tmp1_35 = tmp1_35 + tmp1_5;
    // Op 1834: dim1x1 mul
    gl64_t s1_1834 = *(gl64_t*)&expressions_params[9][182];
    tmp1_12 = tmp1_12 * s1_1834;
    // Op 1835: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_33;
    // Op 1836: dim1x1 add
    tmp1_35 = tmp1_35 + tmp1_12;
    // Op 1837: dim1x1 mul
    gl64_t s1_1837 = *(gl64_t*)&expressions_params[9][183];
    tmp1_22 = tmp1_22 * s1_1837;
    // Op 1838: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_33;
    // Op 1839: dim1x1 add
    tmp1_35 = tmp1_35 + tmp1_22;
    // Op 1840: dim1x1 mul
    gl64_t s1_1840 = *(gl64_t*)&expressions_params[9][184];
    tmp1_24 = tmp1_24 * s1_1840;
    // Op 1841: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_33;
    // Op 1842: dim1x1 add
    tmp1_35 = tmp1_35 + tmp1_24;
    // Op 1843: dim1x1 mul
    gl64_t s1_1843 = *(gl64_t*)&expressions_params[9][185];
    tmp1_10 = tmp1_10 * s1_1843;
    // Op 1844: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_33;
    // Op 1845: dim1x1 add
    tmp1_35 = tmp1_35 + tmp1_10;
    // Op 1846: dim1x1 mul
    gl64_t s1_1846 = *(gl64_t*)&expressions_params[9][186];
    tmp1_20 = tmp1_20 * s1_1846;
    // Op 1847: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_33;
    // Op 1848: dim1x1 add
    tmp1_35 = tmp1_35 + tmp1_20;
    // Op 1849: dim1x1 mul
    gl64_t s1_1849 = *(gl64_t*)&expressions_params[9][187];
    tmp1_23 = tmp1_23 * s1_1849;
    // Op 1850: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_33;
    // Op 1851: dim1x1 add
    tmp1_35 = tmp1_35 + tmp1_23;
    // Op 1852: dim1x1 mul
    gl64_t s1_1852 = *(gl64_t*)&expressions_params[9][188];
    tmp1_2 = tmp1_2 * s1_1852;
    // Op 1853: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_33;
    // Op 1854: dim1x1 add
    tmp1_35 = tmp1_35 + tmp1_2;
    // Op 1855: dim1x1 add
    tmp1_36 = tmp1_36 + tmp1_35;
    // Op 1856: dim1x1 sub
    gl64_t s0_1856 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 50, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 50, domainSize, nCols_1))];
    tmp1_36 = s0_1856 - tmp1_36;
    // Op 1857: dim1x1 mul
    gl64_t s0_1857 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_36 = s0_1857 * tmp1_36;
    // Op 1858: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_36; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1859: dim3x3 mul
    gl64_t s1_1859_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1859_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1859_2 = *(gl64_t*)&expressions_params[13][6+2];
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
    // Op 1860: dim1x1 add
    gl64_t s0_1860 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 50, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 50, domainSize, nCols_1))];
    tmp1_37 = s0_1860 + tmp1_37;
    // Op 1861: dim1x1 mul
    tmp1_37 = tmp1_38 * tmp1_37;
    // Op 1862: dim1x1 mul
    gl64_t s1_1862 = *(gl64_t*)&expressions_params[9][173];
    tmp1_38 = tmp1_37 * s1_1862;
    // Op 1863: dim1x1 mul
    gl64_t s1_1863 = *(gl64_t*)&expressions_params[9][174];
    tmp1_0 = tmp1_0 * s1_1863;
    // Op 1864: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_35;
    // Op 1865: dim1x1 add
    tmp1_37 = tmp1_37 + tmp1_0;
    // Op 1866: dim1x1 mul
    gl64_t s1_1866 = *(gl64_t*)&expressions_params[9][175];
    tmp1_13 = tmp1_13 * s1_1866;
    // Op 1867: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_35;
    // Op 1868: dim1x1 add
    tmp1_37 = tmp1_37 + tmp1_13;
    // Op 1869: dim1x1 mul
    gl64_t s1_1869 = *(gl64_t*)&expressions_params[9][176];
    tmp1_1 = tmp1_1 * s1_1869;
    // Op 1870: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_35;
    // Op 1871: dim1x1 add
    tmp1_37 = tmp1_37 + tmp1_1;
    // Op 1872: dim1x1 mul
    gl64_t s1_1872 = *(gl64_t*)&expressions_params[9][177];
    tmp1_6 = tmp1_6 * s1_1872;
    // Op 1873: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_35;
    // Op 1874: dim1x1 add
    tmp1_37 = tmp1_37 + tmp1_6;
    // Op 1875: dim1x1 mul
    gl64_t s1_1875 = *(gl64_t*)&expressions_params[9][178];
    tmp1_4 = tmp1_4 * s1_1875;
    // Op 1876: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_35;
    // Op 1877: dim1x1 add
    tmp1_37 = tmp1_37 + tmp1_4;
    // Op 1878: dim1x1 mul
    gl64_t s1_1878 = *(gl64_t*)&expressions_params[9][179];
    tmp1_16 = tmp1_16 * s1_1878;
    // Op 1879: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_35;
    // Op 1880: dim1x1 add
    tmp1_37 = tmp1_37 + tmp1_16;
    // Op 1881: dim1x1 mul
    gl64_t s1_1881 = *(gl64_t*)&expressions_params[9][180];
    tmp1_8 = tmp1_8 * s1_1881;
    // Op 1882: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_35;
    // Op 1883: dim1x1 add
    tmp1_37 = tmp1_37 + tmp1_8;
    // Op 1884: dim1x1 mul
    gl64_t s1_1884 = *(gl64_t*)&expressions_params[9][181];
    tmp1_5 = tmp1_5 * s1_1884;
    // Op 1885: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_35;
    // Op 1886: dim1x1 add
    tmp1_37 = tmp1_37 + tmp1_5;
    // Op 1887: dim1x1 mul
    gl64_t s1_1887 = *(gl64_t*)&expressions_params[9][182];
    tmp1_12 = tmp1_12 * s1_1887;
    // Op 1888: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_35;
    // Op 1889: dim1x1 add
    tmp1_37 = tmp1_37 + tmp1_12;
    // Op 1890: dim1x1 mul
    gl64_t s1_1890 = *(gl64_t*)&expressions_params[9][183];
    tmp1_22 = tmp1_22 * s1_1890;
    // Op 1891: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_35;
    // Op 1892: dim1x1 add
    tmp1_37 = tmp1_37 + tmp1_22;
    // Op 1893: dim1x1 mul
    gl64_t s1_1893 = *(gl64_t*)&expressions_params[9][184];
    tmp1_24 = tmp1_24 * s1_1893;
    // Op 1894: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_35;
    // Op 1895: dim1x1 add
    tmp1_37 = tmp1_37 + tmp1_24;
    // Op 1896: dim1x1 mul
    gl64_t s1_1896 = *(gl64_t*)&expressions_params[9][185];
    tmp1_10 = tmp1_10 * s1_1896;
    // Op 1897: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_35;
    // Op 1898: dim1x1 add
    tmp1_37 = tmp1_37 + tmp1_10;
    // Op 1899: dim1x1 mul
    gl64_t s1_1899 = *(gl64_t*)&expressions_params[9][186];
    tmp1_20 = tmp1_20 * s1_1899;
    // Op 1900: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_35;
    // Op 1901: dim1x1 add
    tmp1_37 = tmp1_37 + tmp1_20;
    // Op 1902: dim1x1 mul
    gl64_t s1_1902 = *(gl64_t*)&expressions_params[9][187];
    tmp1_23 = tmp1_23 * s1_1902;
    // Op 1903: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_35;
    // Op 1904: dim1x1 add
    tmp1_37 = tmp1_37 + tmp1_23;
    // Op 1905: dim1x1 mul
    gl64_t s1_1905 = *(gl64_t*)&expressions_params[9][188];
    tmp1_2 = tmp1_2 * s1_1905;
    // Op 1906: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_35;
    // Op 1907: dim1x1 add
    tmp1_37 = tmp1_37 + tmp1_2;
    // Op 1908: dim1x1 add
    tmp1_38 = tmp1_38 + tmp1_37;
    // Op 1909: dim1x1 sub
    gl64_t s0_1909 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 51, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 51, domainSize, nCols_1))];
    tmp1_38 = s0_1909 - tmp1_38;
    // Op 1910: dim1x1 mul
    gl64_t s0_1910 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_38 = s0_1910 * tmp1_38;
    // Op 1911: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_38; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    tmp3_0 = (kC1912 + kG1912) - kF1912;
    tmp3_1 = ((((kA1912 + kC1912) - kE1912) - kE1912) - kD1912);
    tmp3_2 = kB1912 - kG1912;
    // Op 1913: dim1x1 add
    gl64_t s0_1913 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 51, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 51, domainSize, nCols_1))];
    tmp1_39 = s0_1913 + tmp1_39;
    // Op 1914: dim1x1 mul
    tmp1_39 = tmp1_40 * tmp1_39;
    // Op 1915: dim1x1 mul
    gl64_t s1_1915 = *(gl64_t*)&expressions_params[9][173];
    tmp1_40 = tmp1_39 * s1_1915;
    // Op 1916: dim1x1 mul
    gl64_t s1_1916 = *(gl64_t*)&expressions_params[9][174];
    tmp1_0 = tmp1_0 * s1_1916;
    // Op 1917: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_37;
    // Op 1918: dim1x1 add
    tmp1_39 = tmp1_39 + tmp1_0;
    // Op 1919: dim1x1 mul
    gl64_t s1_1919 = *(gl64_t*)&expressions_params[9][175];
    tmp1_13 = tmp1_13 * s1_1919;
    // Op 1920: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_37;
    // Op 1921: dim1x1 add
    tmp1_39 = tmp1_39 + tmp1_13;
    // Op 1922: dim1x1 mul
    gl64_t s1_1922 = *(gl64_t*)&expressions_params[9][176];
    tmp1_1 = tmp1_1 * s1_1922;
    // Op 1923: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_37;
    // Op 1924: dim1x1 add
    tmp1_39 = tmp1_39 + tmp1_1;
    // Op 1925: dim1x1 mul
    gl64_t s1_1925 = *(gl64_t*)&expressions_params[9][177];
    tmp1_6 = tmp1_6 * s1_1925;
    // Op 1926: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_37;
    // Op 1927: dim1x1 add
    tmp1_39 = tmp1_39 + tmp1_6;
    // Op 1928: dim1x1 mul
    gl64_t s1_1928 = *(gl64_t*)&expressions_params[9][178];
    tmp1_4 = tmp1_4 * s1_1928;
    // Op 1929: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_37;
    // Op 1930: dim1x1 add
    tmp1_39 = tmp1_39 + tmp1_4;
    // Op 1931: dim1x1 mul
    gl64_t s1_1931 = *(gl64_t*)&expressions_params[9][179];
    tmp1_16 = tmp1_16 * s1_1931;
    // Op 1932: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_37;
    // Op 1933: dim1x1 add
    tmp1_39 = tmp1_39 + tmp1_16;
    // Op 1934: dim1x1 mul
    gl64_t s1_1934 = *(gl64_t*)&expressions_params[9][180];
    tmp1_8 = tmp1_8 * s1_1934;
    // Op 1935: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_37;
    // Op 1936: dim1x1 add
    tmp1_39 = tmp1_39 + tmp1_8;
    // Op 1937: dim1x1 mul
    gl64_t s1_1937 = *(gl64_t*)&expressions_params[9][181];
    tmp1_5 = tmp1_5 * s1_1937;
    // Op 1938: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_37;
    // Op 1939: dim1x1 add
    tmp1_39 = tmp1_39 + tmp1_5;
    // Op 1940: dim1x1 mul
    gl64_t s1_1940 = *(gl64_t*)&expressions_params[9][182];
    tmp1_12 = tmp1_12 * s1_1940;
    // Op 1941: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_37;
    // Op 1942: dim1x1 add
    tmp1_39 = tmp1_39 + tmp1_12;
    // Op 1943: dim1x1 mul
    gl64_t s1_1943 = *(gl64_t*)&expressions_params[9][183];
    tmp1_22 = tmp1_22 * s1_1943;
    // Op 1944: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_37;
    // Op 1945: dim1x1 add
    tmp1_39 = tmp1_39 + tmp1_22;
    // Op 1946: dim1x1 mul
    gl64_t s1_1946 = *(gl64_t*)&expressions_params[9][184];
    tmp1_24 = tmp1_24 * s1_1946;
    // Op 1947: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_37;
    // Op 1948: dim1x1 add
    tmp1_39 = tmp1_39 + tmp1_24;
    // Op 1949: dim1x1 mul
    gl64_t s1_1949 = *(gl64_t*)&expressions_params[9][185];
    tmp1_10 = tmp1_10 * s1_1949;
    // Op 1950: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_37;
    // Op 1951: dim1x1 add
    tmp1_39 = tmp1_39 + tmp1_10;
    // Op 1952: dim1x1 mul
    gl64_t s1_1952 = *(gl64_t*)&expressions_params[9][186];
    tmp1_20 = tmp1_20 * s1_1952;
    // Op 1953: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_37;
    // Op 1954: dim1x1 add
    tmp1_39 = tmp1_39 + tmp1_20;
    // Op 1955: dim1x1 mul
    gl64_t s1_1955 = *(gl64_t*)&expressions_params[9][187];
    tmp1_23 = tmp1_23 * s1_1955;
    // Op 1956: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_37;
    // Op 1957: dim1x1 add
    tmp1_39 = tmp1_39 + tmp1_23;
    // Op 1958: dim1x1 mul
    gl64_t s1_1958 = *(gl64_t*)&expressions_params[9][188];
    tmp1_2 = tmp1_2 * s1_1958;
    // Op 1959: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_37;
    // Op 1960: dim1x1 add
    tmp1_39 = tmp1_39 + tmp1_2;
    // Op 1961: dim1x1 add
    tmp1_40 = tmp1_40 + tmp1_39;
    // Op 1962: dim1x1 sub
    gl64_t s0_1962 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 52, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 52, domainSize, nCols_1))];
    tmp1_40 = s0_1962 - tmp1_40;
    // Op 1963: dim1x1 mul
    gl64_t s0_1963 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_40 = s0_1963 * tmp1_40;
    // Op 1964: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_40; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 1965: dim3x3 mul
    gl64_t s1_1965_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_1965_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_1965_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA1965 = (tmp3_0 + tmp3_1) * (s1_1965_0 + s1_1965_1);
    gl64_t kB1965 = (tmp3_0 + tmp3_2) * (s1_1965_0 + s1_1965_2);
    gl64_t kC1965 = (tmp3_1 + tmp3_2) * (s1_1965_1 + s1_1965_2);
    gl64_t kD1965 = tmp3_0 * s1_1965_0;
    gl64_t kE1965 = tmp3_1 * s1_1965_1;
    gl64_t kF1965 = tmp3_2 * s1_1965_2;
    gl64_t kG1965 = kD1965 - kE1965;
    tmp3_0 = (kC1965 + kG1965) - kF1965;
    tmp3_1 = ((((kA1965 + kC1965) - kE1965) - kE1965) - kD1965);
    tmp3_2 = kB1965 - kG1965;
    // Op 1966: dim1x1 add
    gl64_t s0_1966 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 52, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 52, domainSize, nCols_1))];
    tmp1_41 = s0_1966 + tmp1_41;
    // Op 1967: dim1x1 mul
    tmp1_41 = tmp1_42 * tmp1_41;
    // Op 1968: dim1x1 mul
    gl64_t s1_1968 = *(gl64_t*)&expressions_params[9][173];
    tmp1_42 = tmp1_41 * s1_1968;
    // Op 1969: dim1x1 mul
    gl64_t s1_1969 = *(gl64_t*)&expressions_params[9][174];
    tmp1_0 = tmp1_0 * s1_1969;
    // Op 1970: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_39;
    // Op 1971: dim1x1 add
    tmp1_41 = tmp1_41 + tmp1_0;
    // Op 1972: dim1x1 mul
    gl64_t s1_1972 = *(gl64_t*)&expressions_params[9][175];
    tmp1_13 = tmp1_13 * s1_1972;
    // Op 1973: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_39;
    // Op 1974: dim1x1 add
    tmp1_41 = tmp1_41 + tmp1_13;
    // Op 1975: dim1x1 mul
    gl64_t s1_1975 = *(gl64_t*)&expressions_params[9][176];
    tmp1_1 = tmp1_1 * s1_1975;
    // Op 1976: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_39;
    // Op 1977: dim1x1 add
    tmp1_41 = tmp1_41 + tmp1_1;
    // Op 1978: dim1x1 mul
    gl64_t s1_1978 = *(gl64_t*)&expressions_params[9][177];
    tmp1_6 = tmp1_6 * s1_1978;
    // Op 1979: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_39;
    // Op 1980: dim1x1 add
    tmp1_41 = tmp1_41 + tmp1_6;
    // Op 1981: dim1x1 mul
    gl64_t s1_1981 = *(gl64_t*)&expressions_params[9][178];
    tmp1_4 = tmp1_4 * s1_1981;
    // Op 1982: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_39;
    // Op 1983: dim1x1 add
    tmp1_41 = tmp1_41 + tmp1_4;
    // Op 1984: dim1x1 mul
    gl64_t s1_1984 = *(gl64_t*)&expressions_params[9][179];
    tmp1_16 = tmp1_16 * s1_1984;
    // Op 1985: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_39;
    // Op 1986: dim1x1 add
    tmp1_41 = tmp1_41 + tmp1_16;
    // Op 1987: dim1x1 mul
    gl64_t s1_1987 = *(gl64_t*)&expressions_params[9][180];
    tmp1_8 = tmp1_8 * s1_1987;
    // Op 1988: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_39;
    // Op 1989: dim1x1 add
    tmp1_41 = tmp1_41 + tmp1_8;
    // Op 1990: dim1x1 mul
    gl64_t s1_1990 = *(gl64_t*)&expressions_params[9][181];
    tmp1_5 = tmp1_5 * s1_1990;
    // Op 1991: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_39;
    // Op 1992: dim1x1 add
    tmp1_41 = tmp1_41 + tmp1_5;
    // Op 1993: dim1x1 mul
    gl64_t s1_1993 = *(gl64_t*)&expressions_params[9][182];
    tmp1_12 = tmp1_12 * s1_1993;
    // Op 1994: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_39;
    // Op 1995: dim1x1 add
    tmp1_41 = tmp1_41 + tmp1_12;
    // Op 1996: dim1x1 mul
    gl64_t s1_1996 = *(gl64_t*)&expressions_params[9][183];
    tmp1_22 = tmp1_22 * s1_1996;
    // Op 1997: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_39;
    // Op 1998: dim1x1 add
    tmp1_41 = tmp1_41 + tmp1_22;
    // Op 1999: dim1x1 mul
    gl64_t s1_1999 = *(gl64_t*)&expressions_params[9][184];
    tmp1_24 = tmp1_24 * s1_1999;
    // Op 2000: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_39;
    // Op 2001: dim1x1 add
    tmp1_41 = tmp1_41 + tmp1_24;
    // Op 2002: dim1x1 mul
    gl64_t s1_2002 = *(gl64_t*)&expressions_params[9][185];
    tmp1_10 = tmp1_10 * s1_2002;
    // Op 2003: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_39;
    // Op 2004: dim1x1 add
    tmp1_41 = tmp1_41 + tmp1_10;
    // Op 2005: dim1x1 mul
    gl64_t s1_2005 = *(gl64_t*)&expressions_params[9][186];
    tmp1_20 = tmp1_20 * s1_2005;
    // Op 2006: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_39;
    // Op 2007: dim1x1 add
    tmp1_41 = tmp1_41 + tmp1_20;
    // Op 2008: dim1x1 mul
    gl64_t s1_2008 = *(gl64_t*)&expressions_params[9][187];
    tmp1_23 = tmp1_23 * s1_2008;
    // Op 2009: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_39;
    // Op 2010: dim1x1 add
    tmp1_41 = tmp1_41 + tmp1_23;
    // Op 2011: dim1x1 mul
    gl64_t s1_2011 = *(gl64_t*)&expressions_params[9][188];
    tmp1_2 = tmp1_2 * s1_2011;
    // Op 2012: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_39;
    // Op 2013: dim1x1 add
    tmp1_41 = tmp1_41 + tmp1_2;
    // Op 2014: dim1x1 add
    tmp1_42 = tmp1_42 + tmp1_41;
    // Op 2015: dim1x1 sub
    gl64_t s0_2015 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 53, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 53, domainSize, nCols_1))];
    tmp1_42 = s0_2015 - tmp1_42;
    // Op 2016: dim1x1 mul
    gl64_t s0_2016 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_42 = s0_2016 * tmp1_42;
    // Op 2017: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_42; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2018: dim3x3 mul
    gl64_t s1_2018_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2018_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2018_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2018 = (tmp3_0 + tmp3_1) * (s1_2018_0 + s1_2018_1);
    gl64_t kB2018 = (tmp3_0 + tmp3_2) * (s1_2018_0 + s1_2018_2);
    gl64_t kC2018 = (tmp3_1 + tmp3_2) * (s1_2018_1 + s1_2018_2);
    gl64_t kD2018 = tmp3_0 * s1_2018_0;
    gl64_t kE2018 = tmp3_1 * s1_2018_1;
    gl64_t kF2018 = tmp3_2 * s1_2018_2;
    gl64_t kG2018 = kD2018 - kE2018;
    tmp3_0 = (kC2018 + kG2018) - kF2018;
    tmp3_1 = ((((kA2018 + kC2018) - kE2018) - kE2018) - kD2018);
    tmp3_2 = kB2018 - kG2018;
    // Op 2019: dim1x1 add
    gl64_t s0_2019 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 53, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 53, domainSize, nCols_1))];
    tmp1_43 = s0_2019 + tmp1_43;
    // Op 2020: dim1x1 mul
    tmp1_43 = tmp1_44 * tmp1_43;
    // Op 2021: dim1x1 mul
    gl64_t s1_2021 = *(gl64_t*)&expressions_params[9][173];
    tmp1_44 = tmp1_43 * s1_2021;
    // Op 2022: dim1x1 mul
    gl64_t s1_2022 = *(gl64_t*)&expressions_params[9][174];
    tmp1_0 = tmp1_0 * s1_2022;
    // Op 2023: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_41;
    // Op 2024: dim1x1 add
    tmp1_43 = tmp1_43 + tmp1_0;
    // Op 2025: dim1x1 mul
    gl64_t s1_2025 = *(gl64_t*)&expressions_params[9][175];
    tmp1_13 = tmp1_13 * s1_2025;
    // Op 2026: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_41;
    // Op 2027: dim1x1 add
    tmp1_43 = tmp1_43 + tmp1_13;
    // Op 2028: dim1x1 mul
    gl64_t s1_2028 = *(gl64_t*)&expressions_params[9][176];
    tmp1_1 = tmp1_1 * s1_2028;
    // Op 2029: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_41;
    // Op 2030: dim1x1 add
    tmp1_43 = tmp1_43 + tmp1_1;
    // Op 2031: dim1x1 mul
    gl64_t s1_2031 = *(gl64_t*)&expressions_params[9][177];
    tmp1_6 = tmp1_6 * s1_2031;
    // Op 2032: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_41;
    // Op 2033: dim1x1 add
    tmp1_43 = tmp1_43 + tmp1_6;
    // Op 2034: dim1x1 mul
    gl64_t s1_2034 = *(gl64_t*)&expressions_params[9][178];
    tmp1_4 = tmp1_4 * s1_2034;
    // Op 2035: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_41;
    // Op 2036: dim1x1 add
    tmp1_43 = tmp1_43 + tmp1_4;
    // Op 2037: dim1x1 mul
    gl64_t s1_2037 = *(gl64_t*)&expressions_params[9][179];
    tmp1_16 = tmp1_16 * s1_2037;
    // Op 2038: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_41;
    // Op 2039: dim1x1 add
    tmp1_43 = tmp1_43 + tmp1_16;
    // Op 2040: dim1x1 mul
    gl64_t s1_2040 = *(gl64_t*)&expressions_params[9][180];
    tmp1_8 = tmp1_8 * s1_2040;
    // Op 2041: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_41;
    // Op 2042: dim1x1 add
    tmp1_43 = tmp1_43 + tmp1_8;
    // Op 2043: dim1x1 mul
    gl64_t s1_2043 = *(gl64_t*)&expressions_params[9][181];
    tmp1_5 = tmp1_5 * s1_2043;
    // Op 2044: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_41;
    // Op 2045: dim1x1 add
    tmp1_43 = tmp1_43 + tmp1_5;
    // Op 2046: dim1x1 mul
    gl64_t s1_2046 = *(gl64_t*)&expressions_params[9][182];
    tmp1_12 = tmp1_12 * s1_2046;
    // Op 2047: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_41;
    // Op 2048: dim1x1 add
    tmp1_43 = tmp1_43 + tmp1_12;
    // Op 2049: dim1x1 mul
    gl64_t s1_2049 = *(gl64_t*)&expressions_params[9][183];
    tmp1_22 = tmp1_22 * s1_2049;
    // Op 2050: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_41;
    // Op 2051: dim1x1 add
    tmp1_43 = tmp1_43 + tmp1_22;
    // Op 2052: dim1x1 mul
    gl64_t s1_2052 = *(gl64_t*)&expressions_params[9][184];
    tmp1_24 = tmp1_24 * s1_2052;
    // Op 2053: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_41;
    // Op 2054: dim1x1 add
    tmp1_43 = tmp1_43 + tmp1_24;
    // Op 2055: dim1x1 mul
    gl64_t s1_2055 = *(gl64_t*)&expressions_params[9][185];
    tmp1_10 = tmp1_10 * s1_2055;
    // Op 2056: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_41;
    // Op 2057: dim1x1 add
    tmp1_43 = tmp1_43 + tmp1_10;
    // Op 2058: dim1x1 mul
    gl64_t s1_2058 = *(gl64_t*)&expressions_params[9][186];
    tmp1_20 = tmp1_20 * s1_2058;
    // Op 2059: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_41;
    // Op 2060: dim1x1 add
    tmp1_43 = tmp1_43 + tmp1_20;
    // Op 2061: dim1x1 mul
    gl64_t s1_2061 = *(gl64_t*)&expressions_params[9][187];
    tmp1_23 = tmp1_23 * s1_2061;
    // Op 2062: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_41;
    // Op 2063: dim1x1 add
    tmp1_43 = tmp1_43 + tmp1_23;
    // Op 2064: dim1x1 mul
    gl64_t s1_2064 = *(gl64_t*)&expressions_params[9][188];
    tmp1_2 = tmp1_2 * s1_2064;
    // Op 2065: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_41;
    // Op 2066: dim1x1 add
    tmp1_43 = tmp1_43 + tmp1_2;
    // Op 2067: dim1x1 add
    tmp1_44 = tmp1_44 + tmp1_43;
    // Op 2068: dim1x1 sub
    gl64_t s0_2068 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 54, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 54, domainSize, nCols_1))];
    tmp1_44 = s0_2068 - tmp1_44;
    // Op 2069: dim1x1 mul
    gl64_t s0_2069 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_44 = s0_2069 * tmp1_44;
    // Op 2070: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_44; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2071: dim3x3 mul
    gl64_t s1_2071_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2071_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2071_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2071 = (tmp3_0 + tmp3_1) * (s1_2071_0 + s1_2071_1);
    gl64_t kB2071 = (tmp3_0 + tmp3_2) * (s1_2071_0 + s1_2071_2);
    gl64_t kC2071 = (tmp3_1 + tmp3_2) * (s1_2071_1 + s1_2071_2);
    gl64_t kD2071 = tmp3_0 * s1_2071_0;
    gl64_t kE2071 = tmp3_1 * s1_2071_1;
    gl64_t kF2071 = tmp3_2 * s1_2071_2;
    gl64_t kG2071 = kD2071 - kE2071;
    tmp3_0 = (kC2071 + kG2071) - kF2071;
    tmp3_1 = ((((kA2071 + kC2071) - kE2071) - kE2071) - kD2071);
    tmp3_2 = kB2071 - kG2071;
    // Op 2072: dim1x1 add
    gl64_t s0_2072 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 54, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 54, domainSize, nCols_1))];
    tmp1_45 = s0_2072 + tmp1_45;
    // Op 2073: dim1x1 mul
    tmp1_45 = tmp1_46 * tmp1_45;
    // Op 2074: dim1x1 mul
    gl64_t s1_2074 = *(gl64_t*)&expressions_params[9][173];
    tmp1_46 = tmp1_45 * s1_2074;
    // Op 2075: dim1x1 mul
    gl64_t s1_2075 = *(gl64_t*)&expressions_params[9][174];
    tmp1_0 = tmp1_0 * s1_2075;
    // Op 2076: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_43;
    // Op 2077: dim1x1 add
    tmp1_45 = tmp1_45 + tmp1_0;
    // Op 2078: dim1x1 mul
    gl64_t s1_2078 = *(gl64_t*)&expressions_params[9][175];
    tmp1_13 = tmp1_13 * s1_2078;
    // Op 2079: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_43;
    // Op 2080: dim1x1 add
    tmp1_45 = tmp1_45 + tmp1_13;
    // Op 2081: dim1x1 mul
    gl64_t s1_2081 = *(gl64_t*)&expressions_params[9][176];
    tmp1_1 = tmp1_1 * s1_2081;
    // Op 2082: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_43;
    // Op 2083: dim1x1 add
    tmp1_45 = tmp1_45 + tmp1_1;
    // Op 2084: dim1x1 mul
    gl64_t s1_2084 = *(gl64_t*)&expressions_params[9][177];
    tmp1_6 = tmp1_6 * s1_2084;
    // Op 2085: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_43;
    // Op 2086: dim1x1 add
    tmp1_45 = tmp1_45 + tmp1_6;
    // Op 2087: dim1x1 mul
    gl64_t s1_2087 = *(gl64_t*)&expressions_params[9][178];
    tmp1_4 = tmp1_4 * s1_2087;
    // Op 2088: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_43;
    // Op 2089: dim1x1 add
    tmp1_45 = tmp1_45 + tmp1_4;
    // Op 2090: dim1x1 mul
    gl64_t s1_2090 = *(gl64_t*)&expressions_params[9][179];
    tmp1_16 = tmp1_16 * s1_2090;
    // Op 2091: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_43;
    // Op 2092: dim1x1 add
    tmp1_45 = tmp1_45 + tmp1_16;
    // Op 2093: dim1x1 mul
    gl64_t s1_2093 = *(gl64_t*)&expressions_params[9][180];
    tmp1_8 = tmp1_8 * s1_2093;
    // Op 2094: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_43;
    // Op 2095: dim1x1 add
    tmp1_45 = tmp1_45 + tmp1_8;
    // Op 2096: dim1x1 mul
    gl64_t s1_2096 = *(gl64_t*)&expressions_params[9][181];
    tmp1_5 = tmp1_5 * s1_2096;
    // Op 2097: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_43;
    // Op 2098: dim1x1 add
    tmp1_45 = tmp1_45 + tmp1_5;
    // Op 2099: dim1x1 mul
    gl64_t s1_2099 = *(gl64_t*)&expressions_params[9][182];
    tmp1_12 = tmp1_12 * s1_2099;
    // Op 2100: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_43;
    // Op 2101: dim1x1 add
    tmp1_45 = tmp1_45 + tmp1_12;
    // Op 2102: dim1x1 mul
    gl64_t s1_2102 = *(gl64_t*)&expressions_params[9][183];
    tmp1_22 = tmp1_22 * s1_2102;
    // Op 2103: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_43;
    // Op 2104: dim1x1 add
    tmp1_45 = tmp1_45 + tmp1_22;
    // Op 2105: dim1x1 mul
    gl64_t s1_2105 = *(gl64_t*)&expressions_params[9][184];
    tmp1_24 = tmp1_24 * s1_2105;
    // Op 2106: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_43;
    // Op 2107: dim1x1 add
    tmp1_45 = tmp1_45 + tmp1_24;
    // Op 2108: dim1x1 mul
    gl64_t s1_2108 = *(gl64_t*)&expressions_params[9][185];
    tmp1_10 = tmp1_10 * s1_2108;
    // Op 2109: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_43;
    // Op 2110: dim1x1 add
    tmp1_45 = tmp1_45 + tmp1_10;
    // Op 2111: dim1x1 mul
    gl64_t s1_2111 = *(gl64_t*)&expressions_params[9][186];
    tmp1_20 = tmp1_20 * s1_2111;
    // Op 2112: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_43;
    // Op 2113: dim1x1 add
    tmp1_45 = tmp1_45 + tmp1_20;
    // Op 2114: dim1x1 mul
    gl64_t s1_2114 = *(gl64_t*)&expressions_params[9][187];
    tmp1_23 = tmp1_23 * s1_2114;
    // Op 2115: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_43;
    // Op 2116: dim1x1 add
    tmp1_45 = tmp1_45 + tmp1_23;
    // Op 2117: dim1x1 mul
    gl64_t s1_2117 = *(gl64_t*)&expressions_params[9][188];
    tmp1_2 = tmp1_2 * s1_2117;
    // Op 2118: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_43;
    // Op 2119: dim1x1 add
    tmp1_45 = tmp1_45 + tmp1_2;
    // Op 2120: dim1x1 add
    tmp1_46 = tmp1_46 + tmp1_45;
    // Op 2121: dim1x1 sub
    gl64_t s0_2121 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 55, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 55, domainSize, nCols_1))];
    tmp1_46 = s0_2121 - tmp1_46;
    // Op 2122: dim1x1 mul
    gl64_t s0_2122 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_46 = s0_2122 * tmp1_46;
    // Op 2123: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_46; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2124: dim3x3 mul
    gl64_t s1_2124_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2124_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2124_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2124 = (tmp3_0 + tmp3_1) * (s1_2124_0 + s1_2124_1);
    gl64_t kB2124 = (tmp3_0 + tmp3_2) * (s1_2124_0 + s1_2124_2);
    gl64_t kC2124 = (tmp3_1 + tmp3_2) * (s1_2124_1 + s1_2124_2);
    gl64_t kD2124 = tmp3_0 * s1_2124_0;
    gl64_t kE2124 = tmp3_1 * s1_2124_1;
    gl64_t kF2124 = tmp3_2 * s1_2124_2;
    gl64_t kG2124 = kD2124 - kE2124;
    tmp3_0 = (kC2124 + kG2124) - kF2124;
    tmp3_1 = ((((kA2124 + kC2124) - kE2124) - kE2124) - kD2124);
    tmp3_2 = kB2124 - kG2124;
    // Op 2125: dim1x1 add
    gl64_t s0_2125 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 55, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 55, domainSize, nCols_1))];
    tmp1_47 = s0_2125 + tmp1_47;
    // Op 2126: dim1x1 mul
    tmp1_47 = tmp1_48 * tmp1_47;
    // Op 2127: dim1x1 mul
    gl64_t s1_2127 = *(gl64_t*)&expressions_params[9][173];
    tmp1_48 = tmp1_47 * s1_2127;
    // Op 2128: dim1x1 mul
    gl64_t s1_2128 = *(gl64_t*)&expressions_params[9][174];
    tmp1_0 = tmp1_0 * s1_2128;
    // Op 2129: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_45;
    // Op 2130: dim1x1 add
    tmp1_47 = tmp1_47 + tmp1_0;
    // Op 2131: dim1x1 mul
    gl64_t s1_2131 = *(gl64_t*)&expressions_params[9][175];
    tmp1_13 = tmp1_13 * s1_2131;
    // Op 2132: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_45;
    // Op 2133: dim1x1 add
    tmp1_47 = tmp1_47 + tmp1_13;
    // Op 2134: dim1x1 mul
    gl64_t s1_2134 = *(gl64_t*)&expressions_params[9][176];
    tmp1_1 = tmp1_1 * s1_2134;
    // Op 2135: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_45;
    // Op 2136: dim1x1 add
    tmp1_47 = tmp1_47 + tmp1_1;
    // Op 2137: dim1x1 mul
    gl64_t s1_2137 = *(gl64_t*)&expressions_params[9][177];
    tmp1_6 = tmp1_6 * s1_2137;
    // Op 2138: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_45;
    // Op 2139: dim1x1 add
    tmp1_47 = tmp1_47 + tmp1_6;
    // Op 2140: dim1x1 mul
    gl64_t s1_2140 = *(gl64_t*)&expressions_params[9][178];
    tmp1_4 = tmp1_4 * s1_2140;
    // Op 2141: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_45;
    // Op 2142: dim1x1 add
    tmp1_47 = tmp1_47 + tmp1_4;
    // Op 2143: dim1x1 mul
    gl64_t s1_2143 = *(gl64_t*)&expressions_params[9][179];
    tmp1_16 = tmp1_16 * s1_2143;
    // Op 2144: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_45;
    // Op 2145: dim1x1 add
    tmp1_47 = tmp1_47 + tmp1_16;
    // Op 2146: dim1x1 mul
    gl64_t s1_2146 = *(gl64_t*)&expressions_params[9][180];
    tmp1_8 = tmp1_8 * s1_2146;
    // Op 2147: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_45;
    // Op 2148: dim1x1 add
    tmp1_47 = tmp1_47 + tmp1_8;
    // Op 2149: dim1x1 mul
    gl64_t s1_2149 = *(gl64_t*)&expressions_params[9][181];
    tmp1_5 = tmp1_5 * s1_2149;
    // Op 2150: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_45;
    // Op 2151: dim1x1 add
    tmp1_47 = tmp1_47 + tmp1_5;
    // Op 2152: dim1x1 mul
    gl64_t s1_2152 = *(gl64_t*)&expressions_params[9][182];
    tmp1_12 = tmp1_12 * s1_2152;
    // Op 2153: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_45;
    // Op 2154: dim1x1 add
    tmp1_47 = tmp1_47 + tmp1_12;
    // Op 2155: dim1x1 mul
    gl64_t s1_2155 = *(gl64_t*)&expressions_params[9][183];
    tmp1_22 = tmp1_22 * s1_2155;
    // Op 2156: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_45;
    // Op 2157: dim1x1 add
    tmp1_47 = tmp1_47 + tmp1_22;
    // Op 2158: dim1x1 mul
    gl64_t s1_2158 = *(gl64_t*)&expressions_params[9][184];
    tmp1_24 = tmp1_24 * s1_2158;
    // Op 2159: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_45;
    // Op 2160: dim1x1 add
    tmp1_47 = tmp1_47 + tmp1_24;
    // Op 2161: dim1x1 mul
    gl64_t s1_2161 = *(gl64_t*)&expressions_params[9][185];
    tmp1_10 = tmp1_10 * s1_2161;
    // Op 2162: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_45;
    // Op 2163: dim1x1 add
    tmp1_47 = tmp1_47 + tmp1_10;
    // Op 2164: dim1x1 mul
    gl64_t s1_2164 = *(gl64_t*)&expressions_params[9][186];
    tmp1_20 = tmp1_20 * s1_2164;
    // Op 2165: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_45;
    // Op 2166: dim1x1 add
    tmp1_47 = tmp1_47 + tmp1_20;
    // Op 2167: dim1x1 mul
    gl64_t s1_2167 = *(gl64_t*)&expressions_params[9][187];
    tmp1_23 = tmp1_23 * s1_2167;
    // Op 2168: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_45;
    // Op 2169: dim1x1 add
    tmp1_47 = tmp1_47 + tmp1_23;
    // Op 2170: dim1x1 mul
    gl64_t s1_2170 = *(gl64_t*)&expressions_params[9][188];
    tmp1_2 = tmp1_2 * s1_2170;
    // Op 2171: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_45;
    // Op 2172: dim1x1 add
    tmp1_47 = tmp1_47 + tmp1_2;
    // Op 2173: dim1x1 add
    tmp1_48 = tmp1_48 + tmp1_47;
    // Op 2174: dim1x1 sub
    gl64_t s0_2174 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 56, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 56, domainSize, nCols_1))];
    tmp1_48 = s0_2174 - tmp1_48;
    // Op 2175: dim1x1 mul
    gl64_t s0_2175 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_48 = s0_2175 * tmp1_48;
    // Op 2176: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_48; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2177: dim3x3 mul
    gl64_t s1_2177_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2177_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2177_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2177 = (tmp3_0 + tmp3_1) * (s1_2177_0 + s1_2177_1);
    gl64_t kB2177 = (tmp3_0 + tmp3_2) * (s1_2177_0 + s1_2177_2);
    gl64_t kC2177 = (tmp3_1 + tmp3_2) * (s1_2177_1 + s1_2177_2);
    gl64_t kD2177 = tmp3_0 * s1_2177_0;
    gl64_t kE2177 = tmp3_1 * s1_2177_1;
    gl64_t kF2177 = tmp3_2 * s1_2177_2;
    gl64_t kG2177 = kD2177 - kE2177;
    tmp3_0 = (kC2177 + kG2177) - kF2177;
    tmp3_1 = ((((kA2177 + kC2177) - kE2177) - kE2177) - kD2177);
    tmp3_2 = kB2177 - kG2177;
    // Op 2178: dim1x1 add
    gl64_t s0_2178 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 56, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 56, domainSize, nCols_1))];
    tmp1_49 = s0_2178 + tmp1_49;
    // Op 2179: dim1x1 mul
    tmp1_49 = tmp1_50 * tmp1_49;
    // Op 2180: dim1x1 mul
    gl64_t s1_2180 = *(gl64_t*)&expressions_params[9][173];
    tmp1_50 = tmp1_49 * s1_2180;
    // Op 2181: dim1x1 mul
    gl64_t s1_2181 = *(gl64_t*)&expressions_params[9][174];
    tmp1_0 = tmp1_0 * s1_2181;
    // Op 2182: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_47;
    // Op 2183: dim1x1 add
    tmp1_49 = tmp1_49 + tmp1_0;
    // Op 2184: dim1x1 mul
    gl64_t s1_2184 = *(gl64_t*)&expressions_params[9][175];
    tmp1_13 = tmp1_13 * s1_2184;
    // Op 2185: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_47;
    // Op 2186: dim1x1 add
    tmp1_49 = tmp1_49 + tmp1_13;
    // Op 2187: dim1x1 mul
    gl64_t s1_2187 = *(gl64_t*)&expressions_params[9][176];
    tmp1_1 = tmp1_1 * s1_2187;
    // Op 2188: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_47;
    // Op 2189: dim1x1 add
    tmp1_49 = tmp1_49 + tmp1_1;
    // Op 2190: dim1x1 mul
    gl64_t s1_2190 = *(gl64_t*)&expressions_params[9][177];
    tmp1_6 = tmp1_6 * s1_2190;
    // Op 2191: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_47;
    // Op 2192: dim1x1 add
    tmp1_49 = tmp1_49 + tmp1_6;
    // Op 2193: dim1x1 mul
    gl64_t s1_2193 = *(gl64_t*)&expressions_params[9][178];
    tmp1_4 = tmp1_4 * s1_2193;
    // Op 2194: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_47;
    // Op 2195: dim1x1 add
    tmp1_49 = tmp1_49 + tmp1_4;
    // Op 2196: dim1x1 mul
    gl64_t s1_2196 = *(gl64_t*)&expressions_params[9][179];
    tmp1_16 = tmp1_16 * s1_2196;
    // Op 2197: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_47;
    // Op 2198: dim1x1 add
    tmp1_49 = tmp1_49 + tmp1_16;
    // Op 2199: dim1x1 mul
    gl64_t s1_2199 = *(gl64_t*)&expressions_params[9][180];
    tmp1_8 = tmp1_8 * s1_2199;
    // Op 2200: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_47;
    // Op 2201: dim1x1 add
    tmp1_49 = tmp1_49 + tmp1_8;
    // Op 2202: dim1x1 mul
    gl64_t s1_2202 = *(gl64_t*)&expressions_params[9][181];
    tmp1_5 = tmp1_5 * s1_2202;
    // Op 2203: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_47;
    // Op 2204: dim1x1 add
    tmp1_49 = tmp1_49 + tmp1_5;
    // Op 2205: dim1x1 mul
    gl64_t s1_2205 = *(gl64_t*)&expressions_params[9][182];
    tmp1_12 = tmp1_12 * s1_2205;
    // Op 2206: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_47;
    // Op 2207: dim1x1 add
    tmp1_49 = tmp1_49 + tmp1_12;
    // Op 2208: dim1x1 mul
    gl64_t s1_2208 = *(gl64_t*)&expressions_params[9][183];
    tmp1_22 = tmp1_22 * s1_2208;
    // Op 2209: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_47;
    // Op 2210: dim1x1 add
    tmp1_49 = tmp1_49 + tmp1_22;
    // Op 2211: dim1x1 mul
    gl64_t s1_2211 = *(gl64_t*)&expressions_params[9][184];
    tmp1_24 = tmp1_24 * s1_2211;
    // Op 2212: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_47;
    // Op 2213: dim1x1 add
    tmp1_49 = tmp1_49 + tmp1_24;
    // Op 2214: dim1x1 mul
    gl64_t s1_2214 = *(gl64_t*)&expressions_params[9][185];
    tmp1_10 = tmp1_10 * s1_2214;
    // Op 2215: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_47;
    // Op 2216: dim1x1 add
    tmp1_49 = tmp1_49 + tmp1_10;
    // Op 2217: dim1x1 mul
    gl64_t s1_2217 = *(gl64_t*)&expressions_params[9][186];
    tmp1_20 = tmp1_20 * s1_2217;
    // Op 2218: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_47;
    // Op 2219: dim1x1 add
    tmp1_49 = tmp1_49 + tmp1_20;
    // Op 2220: dim1x1 mul
    gl64_t s1_2220 = *(gl64_t*)&expressions_params[9][187];
    tmp1_23 = tmp1_23 * s1_2220;
    // Op 2221: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_47;
    // Op 2222: dim1x1 add
    tmp1_49 = tmp1_49 + tmp1_23;
    // Op 2223: dim1x1 mul
    gl64_t s1_2223 = *(gl64_t*)&expressions_params[9][188];
    tmp1_2 = tmp1_2 * s1_2223;
    // Op 2224: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_47;
    // Op 2225: dim1x1 add
    tmp1_49 = tmp1_49 + tmp1_2;
    // Op 2226: dim1x1 add
    tmp1_50 = tmp1_50 + tmp1_49;
    // Op 2227: dim1x1 sub
    gl64_t s0_2227 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 57, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 57, domainSize, nCols_1))];
    tmp1_50 = s0_2227 - tmp1_50;
    // Op 2228: dim1x1 mul
    gl64_t s0_2228 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_50 = s0_2228 * tmp1_50;
    // Op 2229: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_50; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2230: dim3x3 mul
    gl64_t s1_2230_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2230_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2230_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2230 = (tmp3_0 + tmp3_1) * (s1_2230_0 + s1_2230_1);
    gl64_t kB2230 = (tmp3_0 + tmp3_2) * (s1_2230_0 + s1_2230_2);
    gl64_t kC2230 = (tmp3_1 + tmp3_2) * (s1_2230_1 + s1_2230_2);
    gl64_t kD2230 = tmp3_0 * s1_2230_0;
    gl64_t kE2230 = tmp3_1 * s1_2230_1;
    gl64_t kF2230 = tmp3_2 * s1_2230_2;
    gl64_t kG2230 = kD2230 - kE2230;
    tmp3_0 = (kC2230 + kG2230) - kF2230;
    tmp3_1 = ((((kA2230 + kC2230) - kE2230) - kE2230) - kD2230);
    tmp3_2 = kB2230 - kG2230;
    // Op 2231: dim1x1 add
    gl64_t s0_2231 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 57, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 57, domainSize, nCols_1))];
    tmp1_51 = s0_2231 + tmp1_51;
    // Op 2232: dim1x1 mul
    tmp1_51 = tmp1_52 * tmp1_51;
    // Op 2233: dim1x1 mul
    gl64_t s1_2233 = *(gl64_t*)&expressions_params[9][173];
    tmp1_52 = tmp1_51 * s1_2233;
    // Op 2234: dim1x1 mul
    gl64_t s1_2234 = *(gl64_t*)&expressions_params[9][174];
    tmp1_0 = tmp1_0 * s1_2234;
    // Op 2235: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_49;
    // Op 2236: dim1x1 add
    tmp1_51 = tmp1_51 + tmp1_0;
    // Op 2237: dim1x1 mul
    gl64_t s1_2237 = *(gl64_t*)&expressions_params[9][175];
    tmp1_13 = tmp1_13 * s1_2237;
    // Op 2238: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_49;
    // Op 2239: dim1x1 add
    tmp1_51 = tmp1_51 + tmp1_13;
    // Op 2240: dim1x1 mul
    gl64_t s1_2240 = *(gl64_t*)&expressions_params[9][176];
    tmp1_1 = tmp1_1 * s1_2240;
    // Op 2241: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_49;
    // Op 2242: dim1x1 add
    tmp1_51 = tmp1_51 + tmp1_1;
    // Op 2243: dim1x1 mul
    gl64_t s1_2243 = *(gl64_t*)&expressions_params[9][177];
    tmp1_6 = tmp1_6 * s1_2243;
    // Op 2244: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_49;
    // Op 2245: dim1x1 add
    tmp1_51 = tmp1_51 + tmp1_6;
    // Op 2246: dim1x1 mul
    gl64_t s1_2246 = *(gl64_t*)&expressions_params[9][178];
    tmp1_4 = tmp1_4 * s1_2246;
    // Op 2247: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_49;
    // Op 2248: dim1x1 add
    tmp1_51 = tmp1_51 + tmp1_4;
    // Op 2249: dim1x1 mul
    gl64_t s1_2249 = *(gl64_t*)&expressions_params[9][179];
    tmp1_16 = tmp1_16 * s1_2249;
    // Op 2250: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_49;
    // Op 2251: dim1x1 add
    tmp1_51 = tmp1_51 + tmp1_16;
    // Op 2252: dim1x1 mul
    gl64_t s1_2252 = *(gl64_t*)&expressions_params[9][180];
    tmp1_8 = tmp1_8 * s1_2252;
    // Op 2253: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_49;
    // Op 2254: dim1x1 add
    tmp1_51 = tmp1_51 + tmp1_8;
    // Op 2255: dim1x1 mul
    gl64_t s1_2255 = *(gl64_t*)&expressions_params[9][181];
    tmp1_5 = tmp1_5 * s1_2255;
    // Op 2256: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_49;
    // Op 2257: dim1x1 add
    tmp1_51 = tmp1_51 + tmp1_5;
    // Op 2258: dim1x1 mul
    gl64_t s1_2258 = *(gl64_t*)&expressions_params[9][182];
    tmp1_12 = tmp1_12 * s1_2258;
    // Op 2259: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_49;
    // Op 2260: dim1x1 add
    tmp1_51 = tmp1_51 + tmp1_12;
    // Op 2261: dim1x1 mul
    gl64_t s1_2261 = *(gl64_t*)&expressions_params[9][183];
    tmp1_22 = tmp1_22 * s1_2261;
    // Op 2262: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_49;
    // Op 2263: dim1x1 add
    tmp1_51 = tmp1_51 + tmp1_22;
    // Op 2264: dim1x1 mul
    gl64_t s1_2264 = *(gl64_t*)&expressions_params[9][184];
    tmp1_24 = tmp1_24 * s1_2264;
    // Op 2265: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_49;
    // Op 2266: dim1x1 add
    tmp1_51 = tmp1_51 + tmp1_24;
    // Op 2267: dim1x1 mul
    gl64_t s1_2267 = *(gl64_t*)&expressions_params[9][185];
    tmp1_10 = tmp1_10 * s1_2267;
    // Op 2268: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_49;
    // Op 2269: dim1x1 add
    tmp1_51 = tmp1_51 + tmp1_10;
    // Op 2270: dim1x1 mul
    gl64_t s1_2270 = *(gl64_t*)&expressions_params[9][186];
    tmp1_20 = tmp1_20 * s1_2270;
    // Op 2271: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_49;
    // Op 2272: dim1x1 add
    tmp1_51 = tmp1_51 + tmp1_20;
    // Op 2273: dim1x1 mul
    gl64_t s1_2273 = *(gl64_t*)&expressions_params[9][187];
    tmp1_23 = tmp1_23 * s1_2273;
    // Op 2274: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_49;
    // Op 2275: dim1x1 add
    tmp1_51 = tmp1_51 + tmp1_23;
    // Op 2276: dim1x1 mul
    gl64_t s1_2276 = *(gl64_t*)&expressions_params[9][188];
    tmp1_2 = tmp1_2 * s1_2276;
    // Op 2277: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_49;
    // Op 2278: dim1x1 add
    tmp1_51 = tmp1_51 + tmp1_2;
    // Op 2279: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_51;
    // Op 2280: dim1x1 sub
    gl64_t s0_2280 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 58, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 58, domainSize, nCols_1))];
    tmp1_52 = s0_2280 - tmp1_52;
    // Op 2281: dim1x1 mul
    gl64_t s0_2281 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_52 = s0_2281 * tmp1_52;
    // Op 2282: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_52; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2283: dim3x3 mul
    gl64_t s1_2283_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2283_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2283_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2283 = (tmp3_0 + tmp3_1) * (s1_2283_0 + s1_2283_1);
    gl64_t kB2283 = (tmp3_0 + tmp3_2) * (s1_2283_0 + s1_2283_2);
    gl64_t kC2283 = (tmp3_1 + tmp3_2) * (s1_2283_1 + s1_2283_2);
    gl64_t kD2283 = tmp3_0 * s1_2283_0;
    gl64_t kE2283 = tmp3_1 * s1_2283_1;
    gl64_t kF2283 = tmp3_2 * s1_2283_2;
    gl64_t kG2283 = kD2283 - kE2283;
    tmp3_0 = (kC2283 + kG2283) - kF2283;
    tmp3_1 = ((((kA2283 + kC2283) - kE2283) - kE2283) - kD2283);
    tmp3_2 = kB2283 - kG2283;
    // Op 2284: dim1x1 add
    gl64_t s0_2284 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 58, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 58, domainSize, nCols_1))];
    tmp1_53 = s0_2284 + tmp1_53;
    // Op 2285: dim1x1 mul
    tmp1_53 = tmp1_54 * tmp1_53;
    // Op 2286: dim1x1 mul
    gl64_t s1_2286 = *(gl64_t*)&expressions_params[9][173];
    tmp1_54 = tmp1_53 * s1_2286;
    // Op 2287: dim1x1 mul
    gl64_t s1_2287 = *(gl64_t*)&expressions_params[9][174];
    tmp1_0 = tmp1_0 * s1_2287;
    // Op 2288: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_51;
    // Op 2289: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_0;
    // Op 2290: dim1x1 mul
    gl64_t s1_2290 = *(gl64_t*)&expressions_params[9][175];
    tmp1_13 = tmp1_13 * s1_2290;
    // Op 2291: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_51;
    // Op 2292: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_13;
    // Op 2293: dim1x1 mul
    gl64_t s1_2293 = *(gl64_t*)&expressions_params[9][176];
    tmp1_1 = tmp1_1 * s1_2293;
    // Op 2294: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_51;
    // Op 2295: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_1;
    // Op 2296: dim1x1 mul
    gl64_t s1_2296 = *(gl64_t*)&expressions_params[9][177];
    tmp1_6 = tmp1_6 * s1_2296;
    // Op 2297: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_51;
    // Op 2298: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_6;
    // Op 2299: dim1x1 mul
    gl64_t s1_2299 = *(gl64_t*)&expressions_params[9][178];
    tmp1_4 = tmp1_4 * s1_2299;
    // Op 2300: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_51;
    // Op 2301: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_4;
    // Op 2302: dim1x1 mul
    gl64_t s1_2302 = *(gl64_t*)&expressions_params[9][179];
    tmp1_16 = tmp1_16 * s1_2302;
    // Op 2303: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_51;
    // Op 2304: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_16;
    // Op 2305: dim1x1 mul
    gl64_t s1_2305 = *(gl64_t*)&expressions_params[9][180];
    tmp1_8 = tmp1_8 * s1_2305;
    // Op 2306: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_51;
    // Op 2307: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_8;
    // Op 2308: dim1x1 mul
    gl64_t s1_2308 = *(gl64_t*)&expressions_params[9][181];
    tmp1_5 = tmp1_5 * s1_2308;
    // Op 2309: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_51;
    // Op 2310: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_5;
    // Op 2311: dim1x1 mul
    gl64_t s1_2311 = *(gl64_t*)&expressions_params[9][182];
    tmp1_12 = tmp1_12 * s1_2311;
    // Op 2312: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_51;
    // Op 2313: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_12;
    // Op 2314: dim1x1 mul
    gl64_t s1_2314 = *(gl64_t*)&expressions_params[9][183];
    tmp1_22 = tmp1_22 * s1_2314;
    // Op 2315: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_51;
    // Op 2316: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_22;
    // Op 2317: dim1x1 mul
    gl64_t s1_2317 = *(gl64_t*)&expressions_params[9][184];
    tmp1_24 = tmp1_24 * s1_2317;
    // Op 2318: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_51;
    // Op 2319: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_24;
    // Op 2320: dim1x1 mul
    gl64_t s1_2320 = *(gl64_t*)&expressions_params[9][185];
    tmp1_10 = tmp1_10 * s1_2320;
    // Op 2321: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_51;
    // Op 2322: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_10;
    // Op 2323: dim1x1 mul
    gl64_t s1_2323 = *(gl64_t*)&expressions_params[9][186];
    tmp1_20 = tmp1_20 * s1_2323;
    // Op 2324: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_51;
    // Op 2325: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_20;
    // Op 2326: dim1x1 mul
    gl64_t s1_2326 = *(gl64_t*)&expressions_params[9][187];
    tmp1_23 = tmp1_23 * s1_2326;
    // Op 2327: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_51;
    // Op 2328: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_23;
    // Op 2329: dim1x1 mul
    gl64_t s1_2329 = *(gl64_t*)&expressions_params[9][188];
    tmp1_2 = tmp1_2 * s1_2329;
    // Op 2330: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_51;
    // Op 2331: dim1x1 add
    tmp1_51 = tmp1_53 + tmp1_2;
    // Op 2332: dim1x1 add
    tmp1_54 = tmp1_54 + tmp1_51;
    // Op 2333: dim1x1 sub
    gl64_t s0_2333 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    tmp1_54 = s0_2333 - tmp1_54;
    // Op 2334: dim1x1 mul
    gl64_t s0_2334 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_54 = s0_2334 * tmp1_54;
    // Op 2335: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_54; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2336: dim3x3 mul
    gl64_t s1_2336_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2336_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2336_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2336 = (tmp3_0 + tmp3_1) * (s1_2336_0 + s1_2336_1);
    gl64_t kB2336 = (tmp3_0 + tmp3_2) * (s1_2336_0 + s1_2336_2);
    gl64_t kC2336 = (tmp3_1 + tmp3_2) * (s1_2336_1 + s1_2336_2);
    gl64_t kD2336 = tmp3_0 * s1_2336_0;
    gl64_t kE2336 = tmp3_1 * s1_2336_1;
    gl64_t kF2336 = tmp3_2 * s1_2336_2;
    gl64_t kG2336 = kD2336 - kE2336;
    tmp3_0 = (kC2336 + kG2336) - kF2336;
    tmp3_1 = ((((kA2336 + kC2336) - kE2336) - kE2336) - kD2336);
    tmp3_2 = kB2336 - kG2336;
    // Op 2337: dim1x1 add
    gl64_t s0_2337 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    gl64_t s1_2337 = *(gl64_t*)&expressions_params[9][189];
    tmp1_54 = s0_2337 + s1_2337;
    // Op 2338: dim1x1 add
    gl64_t s0_2338 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    gl64_t s1_2338 = *(gl64_t*)&expressions_params[9][189];
    tmp1_53 = s0_2338 + s1_2338;
    // Op 2339: dim1x1 mul
    tmp1_53 = tmp1_54 * tmp1_53;
    // Op 2340: dim1x1 mul
    tmp1_54 = tmp1_53 * tmp1_53;
    // Op 2341: dim1x1 mul
    tmp1_54 = tmp1_54 * tmp1_53;
    // Op 2342: dim1x1 add
    gl64_t s0_2342 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    gl64_t s1_2342 = *(gl64_t*)&expressions_params[9][189];
    tmp1_53 = s0_2342 + s1_2342;
    // Op 2343: dim1x1 mul
    tmp1_53 = tmp1_54 * tmp1_53;
    // Op 2344: dim1x1 mul
    gl64_t s1_2344 = *(gl64_t*)&expressions_params[9][173];
    tmp1_52 = tmp1_53 * s1_2344;
    // Op 2345: dim1x1 add
    gl64_t s0_2345 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_1))];
    gl64_t s1_2345 = *(gl64_t*)&expressions_params[9][189];
    tmp1_53 = s0_2345 + s1_2345;
    // Op 2346: dim1x1 mul
    tmp1_53 = tmp1_54 * tmp1_53;
    // Op 2347: dim1x1 mul
    gl64_t s1_2347 = *(gl64_t*)&expressions_params[9][174];
    tmp1_0 = tmp1_0 * s1_2347;
    // Op 2348: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_51;
    // Op 2349: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_0;
    // Op 2350: dim1x1 mul
    gl64_t s1_2350 = *(gl64_t*)&expressions_params[9][175];
    tmp1_13 = tmp1_13 * s1_2350;
    // Op 2351: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_51;
    // Op 2352: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_13;
    // Op 2353: dim1x1 mul
    gl64_t s1_2353 = *(gl64_t*)&expressions_params[9][176];
    tmp1_1 = tmp1_1 * s1_2353;
    // Op 2354: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_51;
    // Op 2355: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_1;
    // Op 2356: dim1x1 mul
    gl64_t s1_2356 = *(gl64_t*)&expressions_params[9][177];
    tmp1_6 = tmp1_6 * s1_2356;
    // Op 2357: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_51;
    // Op 2358: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_6;
    // Op 2359: dim1x1 mul
    gl64_t s1_2359 = *(gl64_t*)&expressions_params[9][178];
    tmp1_4 = tmp1_4 * s1_2359;
    // Op 2360: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_51;
    // Op 2361: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_4;
    // Op 2362: dim1x1 mul
    gl64_t s1_2362 = *(gl64_t*)&expressions_params[9][179];
    tmp1_16 = tmp1_16 * s1_2362;
    // Op 2363: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_51;
    // Op 2364: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_16;
    // Op 2365: dim1x1 mul
    gl64_t s1_2365 = *(gl64_t*)&expressions_params[9][180];
    tmp1_8 = tmp1_8 * s1_2365;
    // Op 2366: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_51;
    // Op 2367: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_8;
    // Op 2368: dim1x1 mul
    gl64_t s1_2368 = *(gl64_t*)&expressions_params[9][181];
    tmp1_5 = tmp1_5 * s1_2368;
    // Op 2369: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_51;
    // Op 2370: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_5;
    // Op 2371: dim1x1 mul
    gl64_t s1_2371 = *(gl64_t*)&expressions_params[9][182];
    tmp1_12 = tmp1_12 * s1_2371;
    // Op 2372: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_51;
    // Op 2373: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_12;
    // Op 2374: dim1x1 mul
    gl64_t s1_2374 = *(gl64_t*)&expressions_params[9][183];
    tmp1_22 = tmp1_22 * s1_2374;
    // Op 2375: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_51;
    // Op 2376: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_22;
    // Op 2377: dim1x1 mul
    gl64_t s1_2377 = *(gl64_t*)&expressions_params[9][184];
    tmp1_24 = tmp1_24 * s1_2377;
    // Op 2378: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_51;
    // Op 2379: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_24;
    // Op 2380: dim1x1 mul
    gl64_t s1_2380 = *(gl64_t*)&expressions_params[9][185];
    tmp1_10 = tmp1_10 * s1_2380;
    // Op 2381: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_51;
    // Op 2382: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_10;
    // Op 2383: dim1x1 mul
    gl64_t s1_2383 = *(gl64_t*)&expressions_params[9][186];
    tmp1_20 = tmp1_20 * s1_2383;
    // Op 2384: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_51;
    // Op 2385: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_20;
    // Op 2386: dim1x1 mul
    gl64_t s1_2386 = *(gl64_t*)&expressions_params[9][187];
    tmp1_23 = tmp1_23 * s1_2386;
    // Op 2387: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_51;
    // Op 2388: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_23;
    // Op 2389: dim1x1 mul
    gl64_t s1_2389 = *(gl64_t*)&expressions_params[9][188];
    tmp1_2 = tmp1_2 * s1_2389;
    // Op 2390: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_51;
    // Op 2391: dim1x1 add
    tmp1_51 = tmp1_53 + tmp1_2;
    // Op 2392: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_51;
    // Op 2393: dim1x1 sub
    gl64_t s0_2393 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    tmp1_52 = s0_2393 - tmp1_52;
    // Op 2394: dim1x1 mul
    gl64_t s0_2394 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_52 = s0_2394 * tmp1_52;
    // Op 2395: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_52; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2396: dim3x3 mul
    gl64_t s1_2396_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2396_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2396_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2396 = (tmp3_0 + tmp3_1) * (s1_2396_0 + s1_2396_1);
    gl64_t kB2396 = (tmp3_0 + tmp3_2) * (s1_2396_0 + s1_2396_2);
    gl64_t kC2396 = (tmp3_1 + tmp3_2) * (s1_2396_1 + s1_2396_2);
    gl64_t kD2396 = tmp3_0 * s1_2396_0;
    gl64_t kE2396 = tmp3_1 * s1_2396_1;
    gl64_t kF2396 = tmp3_2 * s1_2396_2;
    gl64_t kG2396 = kD2396 - kE2396;
    tmp3_0 = (kC2396 + kG2396) - kF2396;
    tmp3_1 = ((((kA2396 + kC2396) - kE2396) - kE2396) - kD2396);
    tmp3_2 = kB2396 - kG2396;
    // Op 2397: dim1x1 add
    gl64_t s0_2397 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_2397 = *(gl64_t*)&expressions_params[9][190];
    tmp1_52 = s0_2397 + s1_2397;
    // Op 2398: dim1x1 add
    gl64_t s0_2398 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_2398 = *(gl64_t*)&expressions_params[9][190];
    tmp1_53 = s0_2398 + s1_2398;
    // Op 2399: dim1x1 mul
    tmp1_52 = tmp1_52 * tmp1_53;
    // Op 2400: dim1x1 mul
    tmp1_53 = tmp1_52 * tmp1_52;
    // Op 2401: dim1x1 mul
    tmp1_53 = tmp1_53 * tmp1_52;
    // Op 2402: dim1x1 add
    gl64_t s0_2402 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_2402 = *(gl64_t*)&expressions_params[9][190];
    tmp1_52 = s0_2402 + s1_2402;
    // Op 2403: dim1x1 mul
    tmp1_52 = tmp1_53 * tmp1_52;
    // Op 2404: dim1x1 mul
    gl64_t s1_2404 = *(gl64_t*)&expressions_params[9][173];
    tmp1_54 = tmp1_52 * s1_2404;
    // Op 2405: dim1x1 add
    gl64_t s0_2405 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_1))];
    gl64_t s1_2405 = *(gl64_t*)&expressions_params[9][190];
    tmp1_52 = s0_2405 + s1_2405;
    // Op 2406: dim1x1 mul
    tmp1_52 = tmp1_53 * tmp1_52;
    // Op 2407: dim1x1 mul
    gl64_t s1_2407 = *(gl64_t*)&expressions_params[9][174];
    tmp1_0 = tmp1_0 * s1_2407;
    // Op 2408: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_51;
    // Op 2409: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_0;
    // Op 2410: dim1x1 mul
    gl64_t s1_2410 = *(gl64_t*)&expressions_params[9][175];
    tmp1_13 = tmp1_13 * s1_2410;
    // Op 2411: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_51;
    // Op 2412: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_13;
    // Op 2413: dim1x1 mul
    gl64_t s1_2413 = *(gl64_t*)&expressions_params[9][176];
    tmp1_1 = tmp1_1 * s1_2413;
    // Op 2414: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_51;
    // Op 2415: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_1;
    // Op 2416: dim1x1 mul
    gl64_t s1_2416 = *(gl64_t*)&expressions_params[9][177];
    tmp1_6 = tmp1_6 * s1_2416;
    // Op 2417: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_51;
    // Op 2418: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_6;
    // Op 2419: dim1x1 mul
    gl64_t s1_2419 = *(gl64_t*)&expressions_params[9][178];
    tmp1_4 = tmp1_4 * s1_2419;
    // Op 2420: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_51;
    // Op 2421: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_4;
    // Op 2422: dim1x1 mul
    gl64_t s1_2422 = *(gl64_t*)&expressions_params[9][179];
    tmp1_16 = tmp1_16 * s1_2422;
    // Op 2423: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_51;
    // Op 2424: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_16;
    // Op 2425: dim1x1 mul
    gl64_t s1_2425 = *(gl64_t*)&expressions_params[9][180];
    tmp1_8 = tmp1_8 * s1_2425;
    // Op 2426: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_51;
    // Op 2427: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_8;
    // Op 2428: dim1x1 mul
    gl64_t s1_2428 = *(gl64_t*)&expressions_params[9][181];
    tmp1_5 = tmp1_5 * s1_2428;
    // Op 2429: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_51;
    // Op 2430: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_5;
    // Op 2431: dim1x1 mul
    gl64_t s1_2431 = *(gl64_t*)&expressions_params[9][182];
    tmp1_12 = tmp1_12 * s1_2431;
    // Op 2432: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_51;
    // Op 2433: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_12;
    // Op 2434: dim1x1 mul
    gl64_t s1_2434 = *(gl64_t*)&expressions_params[9][183];
    tmp1_22 = tmp1_22 * s1_2434;
    // Op 2435: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_51;
    // Op 2436: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_22;
    // Op 2437: dim1x1 mul
    gl64_t s1_2437 = *(gl64_t*)&expressions_params[9][184];
    tmp1_24 = tmp1_24 * s1_2437;
    // Op 2438: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_51;
    // Op 2439: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_24;
    // Op 2440: dim1x1 mul
    gl64_t s1_2440 = *(gl64_t*)&expressions_params[9][185];
    tmp1_10 = tmp1_10 * s1_2440;
    // Op 2441: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_51;
    // Op 2442: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_10;
    // Op 2443: dim1x1 mul
    gl64_t s1_2443 = *(gl64_t*)&expressions_params[9][186];
    tmp1_20 = tmp1_20 * s1_2443;
    // Op 2444: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_51;
    // Op 2445: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_20;
    // Op 2446: dim1x1 mul
    gl64_t s1_2446 = *(gl64_t*)&expressions_params[9][187];
    tmp1_23 = tmp1_23 * s1_2446;
    // Op 2447: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_51;
    // Op 2448: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_23;
    // Op 2449: dim1x1 mul
    gl64_t s1_2449 = *(gl64_t*)&expressions_params[9][188];
    tmp1_2 = tmp1_2 * s1_2449;
    // Op 2450: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_51;
    // Op 2451: dim1x1 add
    tmp1_51 = tmp1_52 + tmp1_2;
    // Op 2452: dim1x1 add
    tmp1_54 = tmp1_54 + tmp1_51;
    // Op 2453: dim1x1 sub
    gl64_t s0_2453 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    tmp1_54 = s0_2453 - tmp1_54;
    // Op 2454: dim1x1 mul
    gl64_t s0_2454 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_54 = s0_2454 * tmp1_54;
    // Op 2455: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_54; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2456: dim3x3 mul
    gl64_t s1_2456_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2456_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2456_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2456 = (tmp3_0 + tmp3_1) * (s1_2456_0 + s1_2456_1);
    gl64_t kB2456 = (tmp3_0 + tmp3_2) * (s1_2456_0 + s1_2456_2);
    gl64_t kC2456 = (tmp3_1 + tmp3_2) * (s1_2456_1 + s1_2456_2);
    gl64_t kD2456 = tmp3_0 * s1_2456_0;
    gl64_t kE2456 = tmp3_1 * s1_2456_1;
    gl64_t kF2456 = tmp3_2 * s1_2456_2;
    gl64_t kG2456 = kD2456 - kE2456;
    tmp3_0 = (kC2456 + kG2456) - kF2456;
    tmp3_1 = ((((kA2456 + kC2456) - kE2456) - kE2456) - kD2456);
    tmp3_2 = kB2456 - kG2456;
    // Op 2457: dim1x1 add
    gl64_t s0_2457 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_2457 = *(gl64_t*)&expressions_params[9][191];
    tmp1_54 = s0_2457 + s1_2457;
    // Op 2458: dim1x1 add
    gl64_t s0_2458 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_2458 = *(gl64_t*)&expressions_params[9][191];
    tmp1_52 = s0_2458 + s1_2458;
    // Op 2459: dim1x1 mul
    tmp1_52 = tmp1_54 * tmp1_52;
    // Op 2460: dim1x1 mul
    tmp1_54 = tmp1_52 * tmp1_52;
    // Op 2461: dim1x1 mul
    tmp1_54 = tmp1_54 * tmp1_52;
    // Op 2462: dim1x1 add
    gl64_t s0_2462 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_2462 = *(gl64_t*)&expressions_params[9][191];
    tmp1_52 = s0_2462 + s1_2462;
    // Op 2463: dim1x1 mul
    tmp1_52 = tmp1_54 * tmp1_52;
    // Op 2464: dim1x1 mul
    gl64_t s1_2464 = *(gl64_t*)&expressions_params[9][173];
    tmp1_53 = tmp1_52 * s1_2464;
    // Op 2465: dim1x1 add
    gl64_t s0_2465 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_1))];
    gl64_t s1_2465 = *(gl64_t*)&expressions_params[9][191];
    tmp1_52 = s0_2465 + s1_2465;
    // Op 2466: dim1x1 mul
    tmp1_52 = tmp1_54 * tmp1_52;
    // Op 2467: dim1x1 mul
    gl64_t s1_2467 = *(gl64_t*)&expressions_params[9][174];
    tmp1_0 = tmp1_0 * s1_2467;
    // Op 2468: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_51;
    // Op 2469: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_0;
    // Op 2470: dim1x1 mul
    gl64_t s1_2470 = *(gl64_t*)&expressions_params[9][175];
    tmp1_13 = tmp1_13 * s1_2470;
    // Op 2471: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_51;
    // Op 2472: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_13;
    // Op 2473: dim1x1 mul
    gl64_t s1_2473 = *(gl64_t*)&expressions_params[9][176];
    tmp1_1 = tmp1_1 * s1_2473;
    // Op 2474: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_51;
    // Op 2475: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_1;
    // Op 2476: dim1x1 mul
    gl64_t s1_2476 = *(gl64_t*)&expressions_params[9][177];
    tmp1_6 = tmp1_6 * s1_2476;
    // Op 2477: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_51;
    // Op 2478: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_6;
    // Op 2479: dim1x1 mul
    gl64_t s1_2479 = *(gl64_t*)&expressions_params[9][178];
    tmp1_4 = tmp1_4 * s1_2479;
    // Op 2480: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_51;
    // Op 2481: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_4;
    // Op 2482: dim1x1 mul
    gl64_t s1_2482 = *(gl64_t*)&expressions_params[9][179];
    tmp1_16 = tmp1_16 * s1_2482;
    // Op 2483: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_51;
    // Op 2484: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_16;
    // Op 2485: dim1x1 mul
    gl64_t s1_2485 = *(gl64_t*)&expressions_params[9][180];
    tmp1_8 = tmp1_8 * s1_2485;
    // Op 2486: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_51;
    // Op 2487: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_8;
    // Op 2488: dim1x1 mul
    gl64_t s1_2488 = *(gl64_t*)&expressions_params[9][181];
    tmp1_5 = tmp1_5 * s1_2488;
    // Op 2489: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_51;
    // Op 2490: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_5;
    // Op 2491: dim1x1 mul
    gl64_t s1_2491 = *(gl64_t*)&expressions_params[9][182];
    tmp1_12 = tmp1_12 * s1_2491;
    // Op 2492: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_51;
    // Op 2493: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_12;
    // Op 2494: dim1x1 mul
    gl64_t s1_2494 = *(gl64_t*)&expressions_params[9][183];
    tmp1_22 = tmp1_22 * s1_2494;
    // Op 2495: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_51;
    // Op 2496: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_22;
    // Op 2497: dim1x1 mul
    gl64_t s1_2497 = *(gl64_t*)&expressions_params[9][184];
    tmp1_24 = tmp1_24 * s1_2497;
    // Op 2498: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_51;
    // Op 2499: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_24;
    // Op 2500: dim1x1 mul
    gl64_t s1_2500 = *(gl64_t*)&expressions_params[9][185];
    tmp1_10 = tmp1_10 * s1_2500;
    // Op 2501: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_51;
    // Op 2502: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_10;
    // Op 2503: dim1x1 mul
    gl64_t s1_2503 = *(gl64_t*)&expressions_params[9][186];
    tmp1_20 = tmp1_20 * s1_2503;
    // Op 2504: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_51;
    // Op 2505: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_20;
    // Op 2506: dim1x1 mul
    gl64_t s1_2506 = *(gl64_t*)&expressions_params[9][187];
    tmp1_23 = tmp1_23 * s1_2506;
    // Op 2507: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_51;
    // Op 2508: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_23;
    // Op 2509: dim1x1 mul
    gl64_t s1_2509 = *(gl64_t*)&expressions_params[9][188];
    tmp1_2 = tmp1_2 * s1_2509;
    // Op 2510: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_51;
    // Op 2511: dim1x1 add
    tmp1_51 = tmp1_52 + tmp1_2;
    // Op 2512: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_51;
    // Op 2513: dim1x1 sub
    gl64_t s0_2513 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    tmp1_53 = s0_2513 - tmp1_53;
    // Op 2514: dim1x1 mul
    gl64_t s0_2514 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_53 = s0_2514 * tmp1_53;
    // Op 2515: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_53; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2516: dim3x3 mul
    gl64_t s1_2516_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2516_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2516_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2516 = (tmp3_0 + tmp3_1) * (s1_2516_0 + s1_2516_1);
    gl64_t kB2516 = (tmp3_0 + tmp3_2) * (s1_2516_0 + s1_2516_2);
    gl64_t kC2516 = (tmp3_1 + tmp3_2) * (s1_2516_1 + s1_2516_2);
    gl64_t kD2516 = tmp3_0 * s1_2516_0;
    gl64_t kE2516 = tmp3_1 * s1_2516_1;
    gl64_t kF2516 = tmp3_2 * s1_2516_2;
    gl64_t kG2516 = kD2516 - kE2516;
    tmp3_0 = (kC2516 + kG2516) - kF2516;
    tmp3_1 = ((((kA2516 + kC2516) - kE2516) - kE2516) - kD2516);
    tmp3_2 = kB2516 - kG2516;
    // Op 2517: dim1x1 add
    gl64_t s0_2517 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    gl64_t s1_2517 = *(gl64_t*)&expressions_params[9][192];
    tmp1_53 = s0_2517 + s1_2517;
    // Op 2518: dim1x1 add
    gl64_t s0_2518 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    gl64_t s1_2518 = *(gl64_t*)&expressions_params[9][192];
    tmp1_52 = s0_2518 + s1_2518;
    // Op 2519: dim1x1 mul
    tmp1_52 = tmp1_53 * tmp1_52;
    // Op 2520: dim1x1 mul
    tmp1_53 = tmp1_52 * tmp1_52;
    // Op 2521: dim1x1 mul
    tmp1_53 = tmp1_53 * tmp1_52;
    // Op 2522: dim1x1 add
    gl64_t s0_2522 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    gl64_t s1_2522 = *(gl64_t*)&expressions_params[9][192];
    tmp1_52 = s0_2522 + s1_2522;
    // Op 2523: dim1x1 mul
    tmp1_52 = tmp1_53 * tmp1_52;
    // Op 2524: dim1x1 mul
    gl64_t s1_2524 = *(gl64_t*)&expressions_params[9][173];
    tmp1_54 = tmp1_52 * s1_2524;
    // Op 2525: dim1x1 add
    gl64_t s0_2525 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_1))];
    gl64_t s1_2525 = *(gl64_t*)&expressions_params[9][192];
    tmp1_52 = s0_2525 + s1_2525;
    // Op 2526: dim1x1 mul
    tmp1_52 = tmp1_53 * tmp1_52;
    // Op 2527: dim1x1 mul
    gl64_t s1_2527 = *(gl64_t*)&expressions_params[9][174];
    tmp1_0 = tmp1_0 * s1_2527;
    // Op 2528: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_51;
    // Op 2529: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_0;
    // Op 2530: dim1x1 mul
    gl64_t s1_2530 = *(gl64_t*)&expressions_params[9][175];
    tmp1_13 = tmp1_13 * s1_2530;
    // Op 2531: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_51;
    // Op 2532: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_13;
    // Op 2533: dim1x1 mul
    gl64_t s1_2533 = *(gl64_t*)&expressions_params[9][176];
    tmp1_1 = tmp1_1 * s1_2533;
    // Op 2534: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_51;
    // Op 2535: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_1;
    // Op 2536: dim1x1 mul
    gl64_t s1_2536 = *(gl64_t*)&expressions_params[9][177];
    tmp1_6 = tmp1_6 * s1_2536;
    // Op 2537: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_51;
    // Op 2538: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_6;
    // Op 2539: dim1x1 mul
    gl64_t s1_2539 = *(gl64_t*)&expressions_params[9][178];
    tmp1_4 = tmp1_4 * s1_2539;
    // Op 2540: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_51;
    // Op 2541: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_4;
    // Op 2542: dim1x1 mul
    gl64_t s1_2542 = *(gl64_t*)&expressions_params[9][179];
    tmp1_16 = tmp1_16 * s1_2542;
    // Op 2543: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_51;
    // Op 2544: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_16;
    // Op 2545: dim1x1 mul
    gl64_t s1_2545 = *(gl64_t*)&expressions_params[9][180];
    tmp1_8 = tmp1_8 * s1_2545;
    // Op 2546: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_51;
    // Op 2547: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_8;
    // Op 2548: dim1x1 mul
    gl64_t s1_2548 = *(gl64_t*)&expressions_params[9][181];
    tmp1_5 = tmp1_5 * s1_2548;
    // Op 2549: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_51;
    // Op 2550: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_5;
    // Op 2551: dim1x1 mul
    gl64_t s1_2551 = *(gl64_t*)&expressions_params[9][182];
    tmp1_12 = tmp1_12 * s1_2551;
    // Op 2552: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_51;
    // Op 2553: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_12;
    // Op 2554: dim1x1 mul
    gl64_t s1_2554 = *(gl64_t*)&expressions_params[9][183];
    tmp1_22 = tmp1_22 * s1_2554;
    // Op 2555: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_51;
    // Op 2556: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_22;
    // Op 2557: dim1x1 mul
    gl64_t s1_2557 = *(gl64_t*)&expressions_params[9][184];
    tmp1_24 = tmp1_24 * s1_2557;
    // Op 2558: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_51;
    // Op 2559: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_24;
    // Op 2560: dim1x1 mul
    gl64_t s1_2560 = *(gl64_t*)&expressions_params[9][185];
    tmp1_10 = tmp1_10 * s1_2560;
    // Op 2561: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_51;
    // Op 2562: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_10;
    // Op 2563: dim1x1 mul
    gl64_t s1_2563 = *(gl64_t*)&expressions_params[9][186];
    tmp1_20 = tmp1_20 * s1_2563;
    // Op 2564: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_51;
    // Op 2565: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_20;
    // Op 2566: dim1x1 mul
    gl64_t s1_2566 = *(gl64_t*)&expressions_params[9][187];
    tmp1_23 = tmp1_23 * s1_2566;
    // Op 2567: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_51;
    // Op 2568: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_23;
    // Op 2569: dim1x1 mul
    gl64_t s1_2569 = *(gl64_t*)&expressions_params[9][188];
    tmp1_2 = tmp1_2 * s1_2569;
    // Op 2570: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_51;
    // Op 2571: dim1x1 add
    tmp1_51 = tmp1_52 + tmp1_2;
    // Op 2572: dim1x1 add
    tmp1_54 = tmp1_54 + tmp1_51;
    // Op 2573: dim1x1 sub
    gl64_t s0_2573 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    tmp1_54 = s0_2573 - tmp1_54;
    // Op 2574: dim1x1 mul
    gl64_t s0_2574 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_54 = s0_2574 * tmp1_54;
    // Op 2575: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_54; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2576: dim3x3 mul
    gl64_t s1_2576_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2576_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2576_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2576 = (tmp3_0 + tmp3_1) * (s1_2576_0 + s1_2576_1);
    gl64_t kB2576 = (tmp3_0 + tmp3_2) * (s1_2576_0 + s1_2576_2);
    gl64_t kC2576 = (tmp3_1 + tmp3_2) * (s1_2576_1 + s1_2576_2);
    gl64_t kD2576 = tmp3_0 * s1_2576_0;
    gl64_t kE2576 = tmp3_1 * s1_2576_1;
    gl64_t kF2576 = tmp3_2 * s1_2576_2;
    gl64_t kG2576 = kD2576 - kE2576;
    tmp3_0 = (kC2576 + kG2576) - kF2576;
    tmp3_1 = ((((kA2576 + kC2576) - kE2576) - kE2576) - kD2576);
    tmp3_2 = kB2576 - kG2576;
    // Op 2577: dim1x1 add
    gl64_t s0_2577 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_2577 = *(gl64_t*)&expressions_params[9][193];
    tmp1_54 = s0_2577 + s1_2577;
    // Op 2578: dim1x1 add
    gl64_t s0_2578 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_2578 = *(gl64_t*)&expressions_params[9][193];
    tmp1_52 = s0_2578 + s1_2578;
    // Op 2579: dim1x1 mul
    tmp1_52 = tmp1_54 * tmp1_52;
    // Op 2580: dim1x1 mul
    tmp1_54 = tmp1_52 * tmp1_52;
    // Op 2581: dim1x1 mul
    tmp1_54 = tmp1_54 * tmp1_52;
    // Op 2582: dim1x1 add
    gl64_t s0_2582 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_2582 = *(gl64_t*)&expressions_params[9][193];
    tmp1_52 = s0_2582 + s1_2582;
    // Op 2583: dim1x1 mul
    tmp1_52 = tmp1_54 * tmp1_52;
    // Op 2584: dim1x1 mul
    gl64_t s1_2584 = *(gl64_t*)&expressions_params[9][173];
    tmp1_53 = tmp1_52 * s1_2584;
    // Op 2585: dim1x1 add
    gl64_t s0_2585 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_1))];
    gl64_t s1_2585 = *(gl64_t*)&expressions_params[9][193];
    tmp1_52 = s0_2585 + s1_2585;
    // Op 2586: dim1x1 mul
    tmp1_52 = tmp1_54 * tmp1_52;
    // Op 2587: dim1x1 mul
    gl64_t s1_2587 = *(gl64_t*)&expressions_params[9][174];
    tmp1_0 = tmp1_0 * s1_2587;
    // Op 2588: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_51;
    // Op 2589: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_0;
    // Op 2590: dim1x1 mul
    gl64_t s1_2590 = *(gl64_t*)&expressions_params[9][175];
    tmp1_13 = tmp1_13 * s1_2590;
    // Op 2591: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_51;
    // Op 2592: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_13;
    // Op 2593: dim1x1 mul
    gl64_t s1_2593 = *(gl64_t*)&expressions_params[9][176];
    tmp1_1 = tmp1_1 * s1_2593;
    // Op 2594: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_51;
    // Op 2595: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_1;
    // Op 2596: dim1x1 mul
    gl64_t s1_2596 = *(gl64_t*)&expressions_params[9][177];
    tmp1_6 = tmp1_6 * s1_2596;
    // Op 2597: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_51;
    // Op 2598: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_6;
    // Op 2599: dim1x1 mul
    gl64_t s1_2599 = *(gl64_t*)&expressions_params[9][178];
    tmp1_4 = tmp1_4 * s1_2599;
    // Op 2600: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_51;
    // Op 2601: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_4;
    // Op 2602: dim1x1 mul
    gl64_t s1_2602 = *(gl64_t*)&expressions_params[9][179];
    tmp1_16 = tmp1_16 * s1_2602;
    // Op 2603: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_51;
    // Op 2604: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_16;
    // Op 2605: dim1x1 mul
    gl64_t s1_2605 = *(gl64_t*)&expressions_params[9][180];
    tmp1_8 = tmp1_8 * s1_2605;
    // Op 2606: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_51;
    // Op 2607: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_8;
    // Op 2608: dim1x1 mul
    gl64_t s1_2608 = *(gl64_t*)&expressions_params[9][181];
    tmp1_5 = tmp1_5 * s1_2608;
    // Op 2609: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_51;
    // Op 2610: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_5;
    // Op 2611: dim1x1 mul
    gl64_t s1_2611 = *(gl64_t*)&expressions_params[9][182];
    tmp1_12 = tmp1_12 * s1_2611;
    // Op 2612: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_51;
    // Op 2613: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_12;
    // Op 2614: dim1x1 mul
    gl64_t s1_2614 = *(gl64_t*)&expressions_params[9][183];
    tmp1_22 = tmp1_22 * s1_2614;
    // Op 2615: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_51;
    // Op 2616: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_22;
    // Op 2617: dim1x1 mul
    gl64_t s1_2617 = *(gl64_t*)&expressions_params[9][184];
    tmp1_24 = tmp1_24 * s1_2617;
    // Op 2618: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_51;
    // Op 2619: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_24;
    // Op 2620: dim1x1 mul
    gl64_t s1_2620 = *(gl64_t*)&expressions_params[9][185];
    tmp1_10 = tmp1_10 * s1_2620;
    // Op 2621: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_51;
    // Op 2622: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_10;
    // Op 2623: dim1x1 mul
    gl64_t s1_2623 = *(gl64_t*)&expressions_params[9][186];
    tmp1_20 = tmp1_20 * s1_2623;
    // Op 2624: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_51;
    // Op 2625: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_20;
    // Op 2626: dim1x1 mul
    gl64_t s1_2626 = *(gl64_t*)&expressions_params[9][187];
    tmp1_23 = tmp1_23 * s1_2626;
    // Op 2627: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_51;
    // Op 2628: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_23;
    // Op 2629: dim1x1 mul
    gl64_t s1_2629 = *(gl64_t*)&expressions_params[9][188];
    tmp1_2 = tmp1_2 * s1_2629;
    // Op 2630: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_51;
    // Op 2631: dim1x1 add
    tmp1_51 = tmp1_52 + tmp1_2;
    // Op 2632: dim1x1 add
    tmp1_53 = tmp1_53 + tmp1_51;
    // Op 2633: dim1x1 sub
    gl64_t s0_2633 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    tmp1_53 = s0_2633 - tmp1_53;
    // Op 2634: dim1x1 mul
    gl64_t s0_2634 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_53 = s0_2634 * tmp1_53;
    // Op 2635: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_53; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2636: dim3x3 mul
    gl64_t s1_2636_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2636_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2636_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2636 = (tmp3_0 + tmp3_1) * (s1_2636_0 + s1_2636_1);
    gl64_t kB2636 = (tmp3_0 + tmp3_2) * (s1_2636_0 + s1_2636_2);
    gl64_t kC2636 = (tmp3_1 + tmp3_2) * (s1_2636_1 + s1_2636_2);
    gl64_t kD2636 = tmp3_0 * s1_2636_0;
    gl64_t kE2636 = tmp3_1 * s1_2636_1;
    gl64_t kF2636 = tmp3_2 * s1_2636_2;
    gl64_t kG2636 = kD2636 - kE2636;
    tmp3_0 = (kC2636 + kG2636) - kF2636;
    tmp3_1 = ((((kA2636 + kC2636) - kE2636) - kE2636) - kD2636);
    tmp3_2 = kB2636 - kG2636;
    // Op 2637: dim1x1 add
    gl64_t s0_2637 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_2637 = *(gl64_t*)&expressions_params[9][194];
    tmp1_53 = s0_2637 + s1_2637;
    // Op 2638: dim1x1 add
    gl64_t s0_2638 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_2638 = *(gl64_t*)&expressions_params[9][194];
    tmp1_52 = s0_2638 + s1_2638;
    // Op 2639: dim1x1 mul
    tmp1_52 = tmp1_53 * tmp1_52;
    // Op 2640: dim1x1 mul
    tmp1_53 = tmp1_52 * tmp1_52;
    // Op 2641: dim1x1 mul
    tmp1_53 = tmp1_53 * tmp1_52;
    // Op 2642: dim1x1 add
    gl64_t s0_2642 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_2642 = *(gl64_t*)&expressions_params[9][194];
    tmp1_52 = s0_2642 + s1_2642;
    // Op 2643: dim1x1 mul
    tmp1_52 = tmp1_53 * tmp1_52;
    // Op 2644: dim1x1 mul
    gl64_t s1_2644 = *(gl64_t*)&expressions_params[9][173];
    tmp1_54 = tmp1_52 * s1_2644;
    // Op 2645: dim1x1 add
    gl64_t s0_2645 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_1))];
    gl64_t s1_2645 = *(gl64_t*)&expressions_params[9][194];
    tmp1_52 = s0_2645 + s1_2645;
    // Op 2646: dim1x1 mul
    tmp1_52 = tmp1_53 * tmp1_52;
    // Op 2647: dim1x1 mul
    gl64_t s1_2647 = *(gl64_t*)&expressions_params[9][174];
    tmp1_0 = tmp1_0 * s1_2647;
    // Op 2648: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_51;
    // Op 2649: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_0;
    // Op 2650: dim1x1 mul
    gl64_t s1_2650 = *(gl64_t*)&expressions_params[9][175];
    tmp1_13 = tmp1_13 * s1_2650;
    // Op 2651: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_51;
    // Op 2652: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_13;
    // Op 2653: dim1x1 mul
    gl64_t s1_2653 = *(gl64_t*)&expressions_params[9][176];
    tmp1_1 = tmp1_1 * s1_2653;
    // Op 2654: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_51;
    // Op 2655: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_1;
    // Op 2656: dim1x1 mul
    gl64_t s1_2656 = *(gl64_t*)&expressions_params[9][177];
    tmp1_6 = tmp1_6 * s1_2656;
    // Op 2657: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_51;
    // Op 2658: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_6;
    // Op 2659: dim1x1 mul
    gl64_t s1_2659 = *(gl64_t*)&expressions_params[9][178];
    tmp1_4 = tmp1_4 * s1_2659;
    // Op 2660: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_51;
    // Op 2661: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_4;
    // Op 2662: dim1x1 mul
    gl64_t s1_2662 = *(gl64_t*)&expressions_params[9][179];
    tmp1_16 = tmp1_16 * s1_2662;
    // Op 2663: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_51;
    // Op 2664: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_16;
    // Op 2665: dim1x1 mul
    gl64_t s1_2665 = *(gl64_t*)&expressions_params[9][180];
    tmp1_8 = tmp1_8 * s1_2665;
    // Op 2666: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_51;
    // Op 2667: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_8;
    // Op 2668: dim1x1 mul
    gl64_t s1_2668 = *(gl64_t*)&expressions_params[9][181];
    tmp1_5 = tmp1_5 * s1_2668;
    // Op 2669: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_51;
    // Op 2670: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_5;
    // Op 2671: dim1x1 mul
    gl64_t s1_2671 = *(gl64_t*)&expressions_params[9][182];
    tmp1_12 = tmp1_12 * s1_2671;
    // Op 2672: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_51;
    // Op 2673: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_12;
    // Op 2674: dim1x1 mul
    gl64_t s1_2674 = *(gl64_t*)&expressions_params[9][183];
    tmp1_22 = tmp1_22 * s1_2674;
    // Op 2675: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_51;
    // Op 2676: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_22;
    // Op 2677: dim1x1 mul
    gl64_t s1_2677 = *(gl64_t*)&expressions_params[9][184];
    tmp1_24 = tmp1_24 * s1_2677;
    // Op 2678: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_51;
    // Op 2679: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_24;
    // Op 2680: dim1x1 mul
    gl64_t s1_2680 = *(gl64_t*)&expressions_params[9][185];
    tmp1_10 = tmp1_10 * s1_2680;
    // Op 2681: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_51;
    // Op 2682: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_10;
    // Op 2683: dim1x1 mul
    gl64_t s1_2683 = *(gl64_t*)&expressions_params[9][186];
    tmp1_20 = tmp1_20 * s1_2683;
    // Op 2684: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_51;
    // Op 2685: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_20;
    // Op 2686: dim1x1 mul
    gl64_t s1_2686 = *(gl64_t*)&expressions_params[9][187];
    tmp1_23 = tmp1_23 * s1_2686;
    // Op 2687: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_51;
    // Op 2688: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_23;
    // Op 2689: dim1x1 mul
    gl64_t s1_2689 = *(gl64_t*)&expressions_params[9][188];
    tmp1_2 = tmp1_2 * s1_2689;
    // Op 2690: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_51;
    // Op 2691: dim1x1 add
    tmp1_52 = tmp1_52 + tmp1_2;
    // Op 2692: dim1x1 add
    tmp1_54 = tmp1_54 + tmp1_52;
    // Op 2693: dim1x1 sub
    gl64_t s0_2693 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 27, domainSize, nCols_1))];
    tmp1_54 = s0_2693 - tmp1_54;
    // Op 2694: dim1x1 mul
    gl64_t s0_2694 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_54 = s0_2694 * tmp1_54;
    // Op 2695: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_54; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2696: dim3x3 mul
    gl64_t s1_2696_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2696_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2696_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2696 = (tmp3_0 + tmp3_1) * (s1_2696_0 + s1_2696_1);
    gl64_t kB2696 = (tmp3_0 + tmp3_2) * (s1_2696_0 + s1_2696_2);
    gl64_t kC2696 = (tmp3_1 + tmp3_2) * (s1_2696_1 + s1_2696_2);
    gl64_t kD2696 = tmp3_0 * s1_2696_0;
    gl64_t kE2696 = tmp3_1 * s1_2696_1;
    gl64_t kF2696 = tmp3_2 * s1_2696_2;
    gl64_t kG2696 = kD2696 - kE2696;
    tmp3_0 = (kC2696 + kG2696) - kF2696;
    tmp3_1 = ((((kA2696 + kC2696) - kE2696) - kE2696) - kD2696);
    tmp3_2 = kB2696 - kG2696;
    // Op 2697: dim1x1 mul
    gl64_t s1_2697 = *(gl64_t*)&expressions_params[9][174];
    tmp1_0 = tmp1_0 * s1_2697;
    // Op 2698: dim1x1 add
    tmp1_0 = tmp1_0 + tmp1_52;
    // Op 2699: dim1x1 sub
    gl64_t s0_2699 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 28, domainSize, nCols_1))];
    tmp1_0 = s0_2699 - tmp1_0;
    // Op 2700: dim1x1 mul
    gl64_t s0_2700 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_0 = s0_2700 * tmp1_0;
    // Op 2701: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_0; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2702: dim3x3 mul
    gl64_t s1_2702_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2702_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2702_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2702 = (tmp3_0 + tmp3_1) * (s1_2702_0 + s1_2702_1);
    gl64_t kB2702 = (tmp3_0 + tmp3_2) * (s1_2702_0 + s1_2702_2);
    gl64_t kC2702 = (tmp3_1 + tmp3_2) * (s1_2702_1 + s1_2702_2);
    gl64_t kD2702 = tmp3_0 * s1_2702_0;
    gl64_t kE2702 = tmp3_1 * s1_2702_1;
    gl64_t kF2702 = tmp3_2 * s1_2702_2;
    gl64_t kG2702 = kD2702 - kE2702;
    tmp3_0 = (kC2702 + kG2702) - kF2702;
    tmp3_1 = ((((kA2702 + kC2702) - kE2702) - kE2702) - kD2702);
    tmp3_2 = kB2702 - kG2702;
    // Op 2703: dim1x1 mul
    gl64_t s1_2703 = *(gl64_t*)&expressions_params[9][175];
    tmp1_13 = tmp1_13 * s1_2703;
    // Op 2704: dim1x1 add
    tmp1_13 = tmp1_13 + tmp1_52;
    // Op 2705: dim1x1 sub
    gl64_t s0_2705 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 29, domainSize, nCols_1))];
    tmp1_13 = s0_2705 - tmp1_13;
    // Op 2706: dim1x1 mul
    gl64_t s0_2706 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_13 = s0_2706 * tmp1_13;
    // Op 2707: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_13; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2708: dim3x3 mul
    gl64_t s1_2708_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2708_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2708_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2708 = (tmp3_0 + tmp3_1) * (s1_2708_0 + s1_2708_1);
    gl64_t kB2708 = (tmp3_0 + tmp3_2) * (s1_2708_0 + s1_2708_2);
    gl64_t kC2708 = (tmp3_1 + tmp3_2) * (s1_2708_1 + s1_2708_2);
    gl64_t kD2708 = tmp3_0 * s1_2708_0;
    gl64_t kE2708 = tmp3_1 * s1_2708_1;
    gl64_t kF2708 = tmp3_2 * s1_2708_2;
    gl64_t kG2708 = kD2708 - kE2708;
    tmp3_0 = (kC2708 + kG2708) - kF2708;
    tmp3_1 = ((((kA2708 + kC2708) - kE2708) - kE2708) - kD2708);
    tmp3_2 = kB2708 - kG2708;
    // Op 2709: dim1x1 mul
    gl64_t s1_2709 = *(gl64_t*)&expressions_params[9][176];
    tmp1_1 = tmp1_1 * s1_2709;
    // Op 2710: dim1x1 add
    tmp1_1 = tmp1_1 + tmp1_52;
    // Op 2711: dim1x1 sub
    gl64_t s0_2711 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 30, domainSize, nCols_1))];
    tmp1_1 = s0_2711 - tmp1_1;
    // Op 2712: dim1x1 mul
    gl64_t s0_2712 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_1 = s0_2712 * tmp1_1;
    // Op 2713: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2714: dim3x3 mul
    gl64_t s1_2714_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2714_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2714_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2714 = (tmp3_0 + tmp3_1) * (s1_2714_0 + s1_2714_1);
    gl64_t kB2714 = (tmp3_0 + tmp3_2) * (s1_2714_0 + s1_2714_2);
    gl64_t kC2714 = (tmp3_1 + tmp3_2) * (s1_2714_1 + s1_2714_2);
    gl64_t kD2714 = tmp3_0 * s1_2714_0;
    gl64_t kE2714 = tmp3_1 * s1_2714_1;
    gl64_t kF2714 = tmp3_2 * s1_2714_2;
    gl64_t kG2714 = kD2714 - kE2714;
    tmp3_0 = (kC2714 + kG2714) - kF2714;
    tmp3_1 = ((((kA2714 + kC2714) - kE2714) - kE2714) - kD2714);
    tmp3_2 = kB2714 - kG2714;
    // Op 2715: dim1x1 mul
    gl64_t s1_2715 = *(gl64_t*)&expressions_params[9][177];
    tmp1_6 = tmp1_6 * s1_2715;
    // Op 2716: dim1x1 add
    tmp1_6 = tmp1_6 + tmp1_52;
    // Op 2717: dim1x1 sub
    gl64_t s0_2717 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 31, domainSize, nCols_1))];
    tmp1_6 = s0_2717 - tmp1_6;
    // Op 2718: dim1x1 mul
    gl64_t s0_2718 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_6 = s0_2718 * tmp1_6;
    // Op 2719: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_6; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2720: dim3x3 mul
    gl64_t s1_2720_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2720_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2720_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2720 = (tmp3_0 + tmp3_1) * (s1_2720_0 + s1_2720_1);
    gl64_t kB2720 = (tmp3_0 + tmp3_2) * (s1_2720_0 + s1_2720_2);
    gl64_t kC2720 = (tmp3_1 + tmp3_2) * (s1_2720_1 + s1_2720_2);
    gl64_t kD2720 = tmp3_0 * s1_2720_0;
    gl64_t kE2720 = tmp3_1 * s1_2720_1;
    gl64_t kF2720 = tmp3_2 * s1_2720_2;
    gl64_t kG2720 = kD2720 - kE2720;
    tmp3_0 = (kC2720 + kG2720) - kF2720;
    tmp3_1 = ((((kA2720 + kC2720) - kE2720) - kE2720) - kD2720);
    tmp3_2 = kB2720 - kG2720;
    // Op 2721: dim1x1 mul
    gl64_t s1_2721 = *(gl64_t*)&expressions_params[9][178];
    tmp1_4 = tmp1_4 * s1_2721;
    // Op 2722: dim1x1 add
    tmp1_4 = tmp1_4 + tmp1_52;
    // Op 2723: dim1x1 sub
    gl64_t s0_2723 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 32, domainSize, nCols_1))];
    tmp1_4 = s0_2723 - tmp1_4;
    // Op 2724: dim1x1 mul
    gl64_t s0_2724 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_4 = s0_2724 * tmp1_4;
    // Op 2725: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_4; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2726: dim3x3 mul
    gl64_t s1_2726_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2726_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2726_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2726 = (tmp3_0 + tmp3_1) * (s1_2726_0 + s1_2726_1);
    gl64_t kB2726 = (tmp3_0 + tmp3_2) * (s1_2726_0 + s1_2726_2);
    gl64_t kC2726 = (tmp3_1 + tmp3_2) * (s1_2726_1 + s1_2726_2);
    gl64_t kD2726 = tmp3_0 * s1_2726_0;
    gl64_t kE2726 = tmp3_1 * s1_2726_1;
    gl64_t kF2726 = tmp3_2 * s1_2726_2;
    gl64_t kG2726 = kD2726 - kE2726;
    tmp3_0 = (kC2726 + kG2726) - kF2726;
    tmp3_1 = ((((kA2726 + kC2726) - kE2726) - kE2726) - kD2726);
    tmp3_2 = kB2726 - kG2726;
    // Op 2727: dim1x1 mul
    gl64_t s1_2727 = *(gl64_t*)&expressions_params[9][179];
    tmp1_16 = tmp1_16 * s1_2727;
    // Op 2728: dim1x1 add
    tmp1_16 = tmp1_16 + tmp1_52;
    // Op 2729: dim1x1 sub
    gl64_t s0_2729 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 33, domainSize, nCols_1))];
    tmp1_16 = s0_2729 - tmp1_16;
    // Op 2730: dim1x1 mul
    gl64_t s0_2730 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_16 = s0_2730 * tmp1_16;
    // Op 2731: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_16; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2732: dim3x3 mul
    gl64_t s1_2732_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2732_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2732_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2732 = (tmp3_0 + tmp3_1) * (s1_2732_0 + s1_2732_1);
    gl64_t kB2732 = (tmp3_0 + tmp3_2) * (s1_2732_0 + s1_2732_2);
    gl64_t kC2732 = (tmp3_1 + tmp3_2) * (s1_2732_1 + s1_2732_2);
    gl64_t kD2732 = tmp3_0 * s1_2732_0;
    gl64_t kE2732 = tmp3_1 * s1_2732_1;
    gl64_t kF2732 = tmp3_2 * s1_2732_2;
    gl64_t kG2732 = kD2732 - kE2732;
    tmp3_0 = (kC2732 + kG2732) - kF2732;
    tmp3_1 = ((((kA2732 + kC2732) - kE2732) - kE2732) - kD2732);
    tmp3_2 = kB2732 - kG2732;
    // Op 2733: dim1x1 mul
    gl64_t s1_2733 = *(gl64_t*)&expressions_params[9][180];
    tmp1_8 = tmp1_8 * s1_2733;
    // Op 2734: dim1x1 add
    tmp1_8 = tmp1_8 + tmp1_52;
    // Op 2735: dim1x1 sub
    gl64_t s0_2735 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 34, domainSize, nCols_1))];
    tmp1_8 = s0_2735 - tmp1_8;
    // Op 2736: dim1x1 mul
    gl64_t s0_2736 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_8 = s0_2736 * tmp1_8;
    // Op 2737: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_8; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2738: dim3x3 mul
    gl64_t s1_2738_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2738_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2738_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2738 = (tmp3_0 + tmp3_1) * (s1_2738_0 + s1_2738_1);
    gl64_t kB2738 = (tmp3_0 + tmp3_2) * (s1_2738_0 + s1_2738_2);
    gl64_t kC2738 = (tmp3_1 + tmp3_2) * (s1_2738_1 + s1_2738_2);
    gl64_t kD2738 = tmp3_0 * s1_2738_0;
    gl64_t kE2738 = tmp3_1 * s1_2738_1;
    gl64_t kF2738 = tmp3_2 * s1_2738_2;
    gl64_t kG2738 = kD2738 - kE2738;
    tmp3_0 = (kC2738 + kG2738) - kF2738;
    tmp3_1 = ((((kA2738 + kC2738) - kE2738) - kE2738) - kD2738);
    tmp3_2 = kB2738 - kG2738;
    // Op 2739: dim1x1 mul
    gl64_t s1_2739 = *(gl64_t*)&expressions_params[9][181];
    tmp1_5 = tmp1_5 * s1_2739;
    // Op 2740: dim1x1 add
    tmp1_5 = tmp1_5 + tmp1_52;
    // Op 2741: dim1x1 sub
    gl64_t s0_2741 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 35, domainSize, nCols_1))];
    tmp1_5 = s0_2741 - tmp1_5;
    // Op 2742: dim1x1 mul
    gl64_t s0_2742 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_5 = s0_2742 * tmp1_5;
    // Op 2743: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_5; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2744: dim3x3 mul
    gl64_t s1_2744_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2744_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2744_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2744 = (tmp3_0 + tmp3_1) * (s1_2744_0 + s1_2744_1);
    gl64_t kB2744 = (tmp3_0 + tmp3_2) * (s1_2744_0 + s1_2744_2);
    gl64_t kC2744 = (tmp3_1 + tmp3_2) * (s1_2744_1 + s1_2744_2);
    gl64_t kD2744 = tmp3_0 * s1_2744_0;
    gl64_t kE2744 = tmp3_1 * s1_2744_1;
    gl64_t kF2744 = tmp3_2 * s1_2744_2;
    gl64_t kG2744 = kD2744 - kE2744;
    tmp3_0 = (kC2744 + kG2744) - kF2744;
    tmp3_1 = ((((kA2744 + kC2744) - kE2744) - kE2744) - kD2744);
    tmp3_2 = kB2744 - kG2744;
    // Op 2745: dim1x1 mul
    gl64_t s1_2745 = *(gl64_t*)&expressions_params[9][182];
    tmp1_12 = tmp1_12 * s1_2745;
    // Op 2746: dim1x1 add
    tmp1_12 = tmp1_12 + tmp1_52;
    // Op 2747: dim1x1 sub
    gl64_t s0_2747 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 36, domainSize, nCols_1))];
    tmp1_12 = s0_2747 - tmp1_12;
    // Op 2748: dim1x1 mul
    gl64_t s0_2748 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_12 = s0_2748 * tmp1_12;
    // Op 2749: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_12; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2750: dim3x3 mul
    gl64_t s1_2750_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2750_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2750_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2750 = (tmp3_0 + tmp3_1) * (s1_2750_0 + s1_2750_1);
    gl64_t kB2750 = (tmp3_0 + tmp3_2) * (s1_2750_0 + s1_2750_2);
    gl64_t kC2750 = (tmp3_1 + tmp3_2) * (s1_2750_1 + s1_2750_2);
    gl64_t kD2750 = tmp3_0 * s1_2750_0;
    gl64_t kE2750 = tmp3_1 * s1_2750_1;
    gl64_t kF2750 = tmp3_2 * s1_2750_2;
    gl64_t kG2750 = kD2750 - kE2750;
    tmp3_0 = (kC2750 + kG2750) - kF2750;
    tmp3_1 = ((((kA2750 + kC2750) - kE2750) - kE2750) - kD2750);
    tmp3_2 = kB2750 - kG2750;
    // Op 2751: dim1x1 mul
    gl64_t s1_2751 = *(gl64_t*)&expressions_params[9][183];
    tmp1_22 = tmp1_22 * s1_2751;
    // Op 2752: dim1x1 add
    tmp1_22 = tmp1_22 + tmp1_52;
    // Op 2753: dim1x1 sub
    gl64_t s0_2753 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 37, domainSize, nCols_1))];
    tmp1_22 = s0_2753 - tmp1_22;
    // Op 2754: dim1x1 mul
    gl64_t s0_2754 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_22 = s0_2754 * tmp1_22;
    // Op 2755: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_22; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2756: dim3x3 mul
    gl64_t s1_2756_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2756_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2756_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2756 = (tmp3_0 + tmp3_1) * (s1_2756_0 + s1_2756_1);
    gl64_t kB2756 = (tmp3_0 + tmp3_2) * (s1_2756_0 + s1_2756_2);
    gl64_t kC2756 = (tmp3_1 + tmp3_2) * (s1_2756_1 + s1_2756_2);
    gl64_t kD2756 = tmp3_0 * s1_2756_0;
    gl64_t kE2756 = tmp3_1 * s1_2756_1;
    gl64_t kF2756 = tmp3_2 * s1_2756_2;
    gl64_t kG2756 = kD2756 - kE2756;
    tmp3_0 = (kC2756 + kG2756) - kF2756;
    tmp3_1 = ((((kA2756 + kC2756) - kE2756) - kE2756) - kD2756);
    tmp3_2 = kB2756 - kG2756;
    // Op 2757: dim1x1 mul
    gl64_t s1_2757 = *(gl64_t*)&expressions_params[9][184];
    tmp1_24 = tmp1_24 * s1_2757;
    // Op 2758: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_52;
    // Op 2759: dim1x1 sub
    gl64_t s0_2759 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 38, domainSize, nCols_1))];
    tmp1_24 = s0_2759 - tmp1_24;
    // Op 2760: dim1x1 mul
    gl64_t s0_2760 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_24 = s0_2760 * tmp1_24;
    // Op 2761: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_24; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2762: dim3x3 mul
    gl64_t s1_2762_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2762_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2762_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2762 = (tmp3_0 + tmp3_1) * (s1_2762_0 + s1_2762_1);
    gl64_t kB2762 = (tmp3_0 + tmp3_2) * (s1_2762_0 + s1_2762_2);
    gl64_t kC2762 = (tmp3_1 + tmp3_2) * (s1_2762_1 + s1_2762_2);
    gl64_t kD2762 = tmp3_0 * s1_2762_0;
    gl64_t kE2762 = tmp3_1 * s1_2762_1;
    gl64_t kF2762 = tmp3_2 * s1_2762_2;
    gl64_t kG2762 = kD2762 - kE2762;
    tmp3_0 = (kC2762 + kG2762) - kF2762;
    tmp3_1 = ((((kA2762 + kC2762) - kE2762) - kE2762) - kD2762);
    tmp3_2 = kB2762 - kG2762;
    // Op 2763: dim1x1 mul
    gl64_t s1_2763 = *(gl64_t*)&expressions_params[9][185];
    tmp1_10 = tmp1_10 * s1_2763;
    // Op 2764: dim1x1 add
    tmp1_10 = tmp1_10 + tmp1_52;
    // Op 2765: dim1x1 sub
    gl64_t s0_2765 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 39, domainSize, nCols_1))];
    tmp1_10 = s0_2765 - tmp1_10;
    // Op 2766: dim1x1 mul
    gl64_t s0_2766 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_10 = s0_2766 * tmp1_10;
    // Op 2767: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_10; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2768: dim3x3 mul
    gl64_t s1_2768_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2768_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2768_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2768 = (tmp3_0 + tmp3_1) * (s1_2768_0 + s1_2768_1);
    gl64_t kB2768 = (tmp3_0 + tmp3_2) * (s1_2768_0 + s1_2768_2);
    gl64_t kC2768 = (tmp3_1 + tmp3_2) * (s1_2768_1 + s1_2768_2);
    gl64_t kD2768 = tmp3_0 * s1_2768_0;
    gl64_t kE2768 = tmp3_1 * s1_2768_1;
    gl64_t kF2768 = tmp3_2 * s1_2768_2;
    gl64_t kG2768 = kD2768 - kE2768;
    tmp3_0 = (kC2768 + kG2768) - kF2768;
    tmp3_1 = ((((kA2768 + kC2768) - kE2768) - kE2768) - kD2768);
    tmp3_2 = kB2768 - kG2768;
    // Op 2769: dim1x1 mul
    gl64_t s1_2769 = *(gl64_t*)&expressions_params[9][186];
    tmp1_20 = tmp1_20 * s1_2769;
    // Op 2770: dim1x1 add
    tmp1_20 = tmp1_20 + tmp1_52;
    // Op 2771: dim1x1 sub
    gl64_t s0_2771 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 40, domainSize, nCols_1))];
    tmp1_20 = s0_2771 - tmp1_20;
    // Op 2772: dim1x1 mul
    gl64_t s0_2772 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_20 = s0_2772 * tmp1_20;
    // Op 2773: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_20; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2774: dim3x3 mul
    gl64_t s1_2774_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2774_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2774_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2774 = (tmp3_0 + tmp3_1) * (s1_2774_0 + s1_2774_1);
    gl64_t kB2774 = (tmp3_0 + tmp3_2) * (s1_2774_0 + s1_2774_2);
    gl64_t kC2774 = (tmp3_1 + tmp3_2) * (s1_2774_1 + s1_2774_2);
    gl64_t kD2774 = tmp3_0 * s1_2774_0;
    gl64_t kE2774 = tmp3_1 * s1_2774_1;
    gl64_t kF2774 = tmp3_2 * s1_2774_2;
    gl64_t kG2774 = kD2774 - kE2774;
    tmp3_0 = (kC2774 + kG2774) - kF2774;
    tmp3_1 = ((((kA2774 + kC2774) - kE2774) - kE2774) - kD2774);
    tmp3_2 = kB2774 - kG2774;
    // Op 2775: dim1x1 mul
    gl64_t s1_2775 = *(gl64_t*)&expressions_params[9][187];
    tmp1_23 = tmp1_23 * s1_2775;
    // Op 2776: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_52;
    // Op 2777: dim1x1 sub
    gl64_t s0_2777 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 41, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 41, domainSize, nCols_1))];
    tmp1_23 = s0_2777 - tmp1_23;
    // Op 2778: dim1x1 mul
    gl64_t s0_2778 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_23 = s0_2778 * tmp1_23;
    // Op 2779: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_23; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2780: dim3x3 mul
    gl64_t s1_2780_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2780_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2780_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2780 = (tmp3_0 + tmp3_1) * (s1_2780_0 + s1_2780_1);
    gl64_t kB2780 = (tmp3_0 + tmp3_2) * (s1_2780_0 + s1_2780_2);
    gl64_t kC2780 = (tmp3_1 + tmp3_2) * (s1_2780_1 + s1_2780_2);
    gl64_t kD2780 = tmp3_0 * s1_2780_0;
    gl64_t kE2780 = tmp3_1 * s1_2780_1;
    gl64_t kF2780 = tmp3_2 * s1_2780_2;
    gl64_t kG2780 = kD2780 - kE2780;
    tmp3_0 = (kC2780 + kG2780) - kF2780;
    tmp3_1 = ((((kA2780 + kC2780) - kE2780) - kE2780) - kD2780);
    tmp3_2 = kB2780 - kG2780;
    // Op 2781: dim1x1 mul
    gl64_t s1_2781 = *(gl64_t*)&expressions_params[9][188];
    tmp1_2 = tmp1_2 * s1_2781;
    // Op 2782: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2783: dim1x1 sub
    gl64_t s0_2783 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (false ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_1) : getBufferOffset(logicalRow_3, 42, domainSize, nCols_1))];
    tmp1_2 = s0_2783 - tmp1_2;
    // Op 2784: dim1x1 mul
    gl64_t s0_2784 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 39, domainSize, nCols_0)];
    tmp1_2 = s0_2784 * tmp1_2;
    // Op 2785: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2786: dim3x3 mul
    gl64_t s1_2786_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2786_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2786_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2786 = (tmp3_0 + tmp3_1) * (s1_2786_0 + s1_2786_1);
    gl64_t kB2786 = (tmp3_0 + tmp3_2) * (s1_2786_0 + s1_2786_2);
    gl64_t kC2786 = (tmp3_1 + tmp3_2) * (s1_2786_1 + s1_2786_2);
    gl64_t kD2786 = tmp3_0 * s1_2786_0;
    gl64_t kE2786 = tmp3_1 * s1_2786_1;
    gl64_t kF2786 = tmp3_2 * s1_2786_2;
    gl64_t kG2786 = kD2786 - kE2786;
    tmp3_0 = (kC2786 + kG2786) - kF2786;
    tmp3_1 = ((((kA2786 + kC2786) - kE2786) - kE2786) - kD2786);
    tmp3_2 = kB2786 - kG2786;
    // Op 2787: dim1x1 mul
    gl64_t s0_2787 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_1))];
    gl64_t s1_2787 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_2 = s0_2787 * s1_2787;
    // Op 2788: dim1x1 mul
    gl64_t s0_2788 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    gl64_t s1_2788 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    tmp1_52 = s0_2788 * s1_2788;
    // Op 2789: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2790: dim1x1 mul
    gl64_t s0_2790 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_1))];
    gl64_t s1_2790 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    tmp1_52 = s0_2790 * s1_2790;
    // Op 2791: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2792: dim1x1 sub
    gl64_t s0_2792 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 6, domainSize, nCols_1))];
    tmp1_2 = s0_2792 - tmp1_2;
    // Op 2793: dim1x1 mul
    gl64_t s0_2793 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 41, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 41, domainSize, nCols_0)];
    tmp1_2 = s0_2793 * tmp1_2;
    // Op 2794: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2795: dim3x3 mul
    gl64_t s1_2795_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2795_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2795_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2795 = (tmp3_0 + tmp3_1) * (s1_2795_0 + s1_2795_1);
    gl64_t kB2795 = (tmp3_0 + tmp3_2) * (s1_2795_0 + s1_2795_2);
    gl64_t kC2795 = (tmp3_1 + tmp3_2) * (s1_2795_1 + s1_2795_2);
    gl64_t kD2795 = tmp3_0 * s1_2795_0;
    gl64_t kE2795 = tmp3_1 * s1_2795_1;
    gl64_t kF2795 = tmp3_2 * s1_2795_2;
    gl64_t kG2795 = kD2795 - kE2795;
    tmp3_0 = (kC2795 + kG2795) - kF2795;
    tmp3_1 = ((((kA2795 + kC2795) - kE2795) - kE2795) - kD2795);
    tmp3_2 = kB2795 - kG2795;
    // Op 2796: dim1x1 mul
    gl64_t s0_2796 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_1))];
    gl64_t s1_2796 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    tmp1_2 = s0_2796 * s1_2796;
    // Op 2797: dim1x1 mul
    gl64_t s0_2797 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    gl64_t s1_2797 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_52 = s0_2797 * s1_2797;
    // Op 2798: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2799: dim1x1 mul
    gl64_t s0_2799 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    gl64_t s1_2799 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    tmp1_52 = s0_2799 * s1_2799;
    // Op 2800: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2801: dim1x1 mul
    gl64_t s0_2801 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_1))];
    gl64_t s1_2801 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    tmp1_52 = s0_2801 * s1_2801;
    // Op 2802: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2803: dim1x1 mul
    gl64_t s0_2803 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_1))];
    gl64_t s1_2803 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    tmp1_52 = s0_2803 * s1_2803;
    // Op 2804: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2805: dim1x1 sub
    gl64_t s0_2805 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    tmp1_2 = s0_2805 - tmp1_2;
    // Op 2806: dim1x1 mul
    gl64_t s0_2806 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 41, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 41, domainSize, nCols_0)];
    tmp1_2 = s0_2806 * tmp1_2;
    // Op 2807: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2808: dim3x3 mul
    gl64_t s1_2808_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2808_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2808_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2808 = (tmp3_0 + tmp3_1) * (s1_2808_0 + s1_2808_1);
    gl64_t kB2808 = (tmp3_0 + tmp3_2) * (s1_2808_0 + s1_2808_2);
    gl64_t kC2808 = (tmp3_1 + tmp3_2) * (s1_2808_1 + s1_2808_2);
    gl64_t kD2808 = tmp3_0 * s1_2808_0;
    gl64_t kE2808 = tmp3_1 * s1_2808_1;
    gl64_t kF2808 = tmp3_2 * s1_2808_2;
    gl64_t kG2808 = kD2808 - kE2808;
    tmp3_0 = (kC2808 + kG2808) - kF2808;
    tmp3_1 = ((((kA2808 + kC2808) - kE2808) - kE2808) - kD2808);
    tmp3_2 = kB2808 - kG2808;
    // Op 2809: dim1x1 mul
    gl64_t s0_2809 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_1))];
    gl64_t s1_2809 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    tmp1_2 = s0_2809 * s1_2809;
    // Op 2810: dim1x1 mul
    gl64_t s0_2810 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_1))];
    gl64_t s1_2810 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    tmp1_52 = s0_2810 * s1_2810;
    // Op 2811: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2812: dim1x1 mul
    gl64_t s0_2812 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_1))];
    gl64_t s1_2812 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_52 = s0_2812 * s1_2812;
    // Op 2813: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2814: dim1x1 mul
    gl64_t s0_2814 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    gl64_t s1_2814 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    tmp1_52 = s0_2814 * s1_2814;
    // Op 2815: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2816: dim1x1 sub
    gl64_t s0_2816 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 8, domainSize, nCols_1))];
    tmp1_2 = s0_2816 - tmp1_2;
    // Op 2817: dim1x1 mul
    gl64_t s0_2817 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 41, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 41, domainSize, nCols_0)];
    tmp1_2 = s0_2817 * tmp1_2;
    // Op 2818: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2819: dim3x3 mul
    gl64_t s1_2819_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2819_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2819_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2819 = (tmp3_0 + tmp3_1) * (s1_2819_0 + s1_2819_1);
    gl64_t kB2819 = (tmp3_0 + tmp3_2) * (s1_2819_0 + s1_2819_2);
    gl64_t kC2819 = (tmp3_1 + tmp3_2) * (s1_2819_1 + s1_2819_2);
    gl64_t kD2819 = tmp3_0 * s1_2819_0;
    gl64_t kE2819 = tmp3_1 * s1_2819_1;
    gl64_t kF2819 = tmp3_2 * s1_2819_2;
    gl64_t kG2819 = kD2819 - kE2819;
    tmp3_0 = (kC2819 + kG2819) - kF2819;
    tmp3_1 = ((((kA2819 + kC2819) - kE2819) - kE2819) - kD2819);
    tmp3_2 = kB2819 - kG2819;
    // Op 2820: dim1x1 mul
    gl64_t s0_2820 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    gl64_t s1_2820 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_1))];
    tmp1_2 = s0_2820 * s1_2820;
    // Op 2821: dim1x1 mul
    gl64_t s0_2821 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 10, domainSize, nCols_1))];
    gl64_t s1_2821 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    tmp1_52 = s0_2821 * s1_2821;
    // Op 2822: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2823: dim1x1 mul
    gl64_t s0_2823 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    gl64_t s1_2823 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    tmp1_52 = s0_2823 * s1_2823;
    // Op 2824: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2825: dim1x1 sub
    gl64_t s0_2825 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_2 = s0_2825 - tmp1_2;
    // Op 2826: dim1x1 mul
    gl64_t s0_2826 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 41, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 41, domainSize, nCols_0)];
    tmp1_2 = s0_2826 * tmp1_2;
    // Op 2827: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2828: dim3x3 mul
    gl64_t s1_2828_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2828_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2828_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2828 = (tmp3_0 + tmp3_1) * (s1_2828_0 + s1_2828_1);
    gl64_t kB2828 = (tmp3_0 + tmp3_2) * (s1_2828_0 + s1_2828_2);
    gl64_t kC2828 = (tmp3_1 + tmp3_2) * (s1_2828_1 + s1_2828_2);
    gl64_t kD2828 = tmp3_0 * s1_2828_0;
    gl64_t kE2828 = tmp3_1 * s1_2828_1;
    gl64_t kF2828 = tmp3_2 * s1_2828_2;
    gl64_t kG2828 = kD2828 - kE2828;
    tmp3_0 = (kC2828 + kG2828) - kF2828;
    tmp3_1 = ((((kA2828 + kC2828) - kE2828) - kE2828) - kD2828);
    tmp3_2 = kB2828 - kG2828;
    // Op 2829: dim1x1 mul
    gl64_t s0_2829 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    gl64_t s1_2829 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    tmp1_2 = s0_2829 * s1_2829;
    // Op 2830: dim1x1 mul
    gl64_t s0_2830 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 10, domainSize, nCols_1))];
    gl64_t s1_2830 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_1))];
    tmp1_52 = s0_2830 * s1_2830;
    // Op 2831: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2832: dim1x1 mul
    gl64_t s0_2832 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 10, domainSize, nCols_1))];
    gl64_t s1_2832 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    tmp1_52 = s0_2832 * s1_2832;
    // Op 2833: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2834: dim1x1 mul
    gl64_t s0_2834 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    gl64_t s1_2834 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    tmp1_52 = s0_2834 * s1_2834;
    // Op 2835: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2836: dim1x1 mul
    gl64_t s0_2836 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    gl64_t s1_2836 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    tmp1_52 = s0_2836 * s1_2836;
    // Op 2837: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2838: dim1x1 sub
    gl64_t s0_2838 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_2 = s0_2838 - tmp1_2;
    // Op 2839: dim1x1 mul
    gl64_t s0_2839 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 41, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 41, domainSize, nCols_0)];
    tmp1_2 = s0_2839 * tmp1_2;
    // Op 2840: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2841: dim3x3 mul
    gl64_t s1_2841_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2841_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2841_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2841 = (tmp3_0 + tmp3_1) * (s1_2841_0 + s1_2841_1);
    gl64_t kB2841 = (tmp3_0 + tmp3_2) * (s1_2841_0 + s1_2841_2);
    gl64_t kC2841 = (tmp3_1 + tmp3_2) * (s1_2841_1 + s1_2841_2);
    gl64_t kD2841 = tmp3_0 * s1_2841_0;
    gl64_t kE2841 = tmp3_1 * s1_2841_1;
    gl64_t kF2841 = tmp3_2 * s1_2841_2;
    gl64_t kG2841 = kD2841 - kE2841;
    tmp3_0 = (kC2841 + kG2841) - kF2841;
    tmp3_1 = ((((kA2841 + kC2841) - kE2841) - kE2841) - kD2841);
    tmp3_2 = kB2841 - kG2841;
    // Op 2842: dim1x1 mul
    gl64_t s0_2842 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    gl64_t s1_2842 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    tmp1_2 = s0_2842 * s1_2842;
    // Op 2843: dim1x1 mul
    gl64_t s0_2843 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    gl64_t s1_2843 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    tmp1_52 = s0_2843 * s1_2843;
    // Op 2844: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2845: dim1x1 mul
    gl64_t s0_2845 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    gl64_t s1_2845 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_1))];
    tmp1_52 = s0_2845 * s1_2845;
    // Op 2846: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2847: dim1x1 mul
    gl64_t s0_2847 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 10, domainSize, nCols_1))];
    gl64_t s1_2847 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    tmp1_52 = s0_2847 * s1_2847;
    // Op 2848: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2849: dim1x1 sub
    gl64_t s0_2849 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_2 = s0_2849 - tmp1_2;
    // Op 2850: dim1x1 mul
    gl64_t s0_2850 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 41, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 41, domainSize, nCols_0)];
    tmp1_2 = s0_2850 * tmp1_2;
    // Op 2851: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2852: dim3x3 mul
    gl64_t s1_2852_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2852_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2852_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2852 = (tmp3_0 + tmp3_1) * (s1_2852_0 + s1_2852_1);
    gl64_t kB2852 = (tmp3_0 + tmp3_2) * (s1_2852_0 + s1_2852_2);
    gl64_t kC2852 = (tmp3_1 + tmp3_2) * (s1_2852_1 + s1_2852_2);
    gl64_t kD2852 = tmp3_0 * s1_2852_0;
    gl64_t kE2852 = tmp3_1 * s1_2852_1;
    gl64_t kF2852 = tmp3_2 * s1_2852_2;
    gl64_t kG2852 = kD2852 - kE2852;
    tmp3_0 = (kC2852 + kG2852) - kF2852;
    tmp3_1 = ((((kA2852 + kC2852) - kE2852) - kE2852) - kD2852);
    tmp3_2 = kB2852 - kG2852;
    // Op 2853: dim1x1 mul
    gl64_t s0_2853 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 18, domainSize, nCols_1))];
    gl64_t s1_2853 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 21, domainSize, nCols_1))];
    tmp1_2 = s0_2853 * s1_2853;
    // Op 2854: dim1x1 mul
    gl64_t s0_2854 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 19, domainSize, nCols_1))];
    gl64_t s1_2854 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 23, domainSize, nCols_1))];
    tmp1_52 = s0_2854 * s1_2854;
    // Op 2855: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2856: dim1x1 mul
    gl64_t s0_2856 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 20, domainSize, nCols_1))];
    gl64_t s1_2856 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 22, domainSize, nCols_1))];
    tmp1_52 = s0_2856 * s1_2856;
    // Op 2857: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2858: dim1x1 sub
    gl64_t s0_2858 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 24, domainSize, nCols_1))];
    tmp1_2 = s0_2858 - tmp1_2;
    // Op 2859: dim1x1 mul
    gl64_t s0_2859 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 41, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 41, domainSize, nCols_0)];
    tmp1_2 = s0_2859 * tmp1_2;
    // Op 2860: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2861: dim3x3 mul
    gl64_t s1_2861_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2861_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2861_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2861 = (tmp3_0 + tmp3_1) * (s1_2861_0 + s1_2861_1);
    gl64_t kB2861 = (tmp3_0 + tmp3_2) * (s1_2861_0 + s1_2861_2);
    gl64_t kC2861 = (tmp3_1 + tmp3_2) * (s1_2861_1 + s1_2861_2);
    gl64_t kD2861 = tmp3_0 * s1_2861_0;
    gl64_t kE2861 = tmp3_1 * s1_2861_1;
    gl64_t kF2861 = tmp3_2 * s1_2861_2;
    gl64_t kG2861 = kD2861 - kE2861;
    tmp3_0 = (kC2861 + kG2861) - kF2861;
    tmp3_1 = ((((kA2861 + kC2861) - kE2861) - kE2861) - kD2861);
    tmp3_2 = kB2861 - kG2861;
    // Op 2862: dim1x1 mul
    gl64_t s0_2862 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 18, domainSize, nCols_1))];
    gl64_t s1_2862 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 22, domainSize, nCols_1))];
    tmp1_2 = s0_2862 * s1_2862;
    // Op 2863: dim1x1 mul
    gl64_t s0_2863 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 19, domainSize, nCols_1))];
    gl64_t s1_2863 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 21, domainSize, nCols_1))];
    tmp1_52 = s0_2863 * s1_2863;
    // Op 2864: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2865: dim1x1 mul
    gl64_t s0_2865 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 19, domainSize, nCols_1))];
    gl64_t s1_2865 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 23, domainSize, nCols_1))];
    tmp1_52 = s0_2865 * s1_2865;
    // Op 2866: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2867: dim1x1 mul
    gl64_t s0_2867 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 20, domainSize, nCols_1))];
    gl64_t s1_2867 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 22, domainSize, nCols_1))];
    tmp1_52 = s0_2867 * s1_2867;
    // Op 2868: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2869: dim1x1 mul
    gl64_t s0_2869 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 20, domainSize, nCols_1))];
    gl64_t s1_2869 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 23, domainSize, nCols_1))];
    tmp1_52 = s0_2869 * s1_2869;
    // Op 2870: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2871: dim1x1 sub
    gl64_t s0_2871 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 25, domainSize, nCols_1))];
    tmp1_2 = s0_2871 - tmp1_2;
    // Op 2872: dim1x1 mul
    gl64_t s0_2872 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 41, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 41, domainSize, nCols_0)];
    tmp1_2 = s0_2872 * tmp1_2;
    // Op 2873: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2874: dim3x3 mul
    gl64_t s1_2874_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2874_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2874_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2874 = (tmp3_0 + tmp3_1) * (s1_2874_0 + s1_2874_1);
    gl64_t kB2874 = (tmp3_0 + tmp3_2) * (s1_2874_0 + s1_2874_2);
    gl64_t kC2874 = (tmp3_1 + tmp3_2) * (s1_2874_1 + s1_2874_2);
    gl64_t kD2874 = tmp3_0 * s1_2874_0;
    gl64_t kE2874 = tmp3_1 * s1_2874_1;
    gl64_t kF2874 = tmp3_2 * s1_2874_2;
    gl64_t kG2874 = kD2874 - kE2874;
    tmp3_0 = (kC2874 + kG2874) - kF2874;
    tmp3_1 = ((((kA2874 + kC2874) - kE2874) - kE2874) - kD2874);
    tmp3_2 = kB2874 - kG2874;
    // Op 2875: dim1x1 mul
    gl64_t s0_2875 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 18, domainSize, nCols_1))];
    gl64_t s1_2875 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 23, domainSize, nCols_1))];
    tmp1_2 = s0_2875 * s1_2875;
    // Op 2876: dim1x1 mul
    gl64_t s0_2876 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 20, domainSize, nCols_1))];
    gl64_t s1_2876 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 23, domainSize, nCols_1))];
    tmp1_52 = s0_2876 * s1_2876;
    // Op 2877: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2878: dim1x1 mul
    gl64_t s0_2878 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 20, domainSize, nCols_1))];
    gl64_t s1_2878 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 21, domainSize, nCols_1))];
    tmp1_52 = s0_2878 * s1_2878;
    // Op 2879: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2880: dim1x1 mul
    gl64_t s0_2880 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 19, domainSize, nCols_1))];
    gl64_t s1_2880 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 22, domainSize, nCols_1))];
    tmp1_52 = s0_2880 * s1_2880;
    // Op 2881: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2882: dim1x1 sub
    gl64_t s0_2882 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 26, domainSize, nCols_1))];
    tmp1_2 = s0_2882 - tmp1_2;
    // Op 2883: dim1x1 mul
    gl64_t s0_2883 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 41, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 41, domainSize, nCols_0)];
    tmp1_2 = s0_2883 * tmp1_2;
    // Op 2884: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2885: dim3x3 mul
    gl64_t s1_2885_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2885_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2885_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2885 = (tmp3_0 + tmp3_1) * (s1_2885_0 + s1_2885_1);
    gl64_t kB2885 = (tmp3_0 + tmp3_2) * (s1_2885_0 + s1_2885_2);
    gl64_t kC2885 = (tmp3_1 + tmp3_2) * (s1_2885_1 + s1_2885_2);
    gl64_t kD2885 = tmp3_0 * s1_2885_0;
    gl64_t kE2885 = tmp3_1 * s1_2885_1;
    gl64_t kF2885 = tmp3_2 * s1_2885_2;
    gl64_t kG2885 = kD2885 - kE2885;
    tmp3_0 = (kC2885 + kG2885) - kF2885;
    tmp3_1 = ((((kA2885 + kC2885) - kE2885) - kE2885) - kD2885);
    tmp3_2 = kB2885 - kG2885;
    // Op 2886: dim1x1 mul
    gl64_t s0_2886 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 27, domainSize, nCols_0)];
    gl64_t s1_2886 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_1))];
    tmp1_2 = s0_2886 * s1_2886;
    // Op 2887: dim1x1 mul
    gl64_t s0_2887 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 28, domainSize, nCols_0)];
    gl64_t s1_2887 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_52 = s0_2887 * s1_2887;
    // Op 2888: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2889: dim1x1 mul
    gl64_t s0_2889 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 29, domainSize, nCols_0)];
    gl64_t s1_2889 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 6, domainSize, nCols_1))];
    tmp1_52 = s0_2889 * s1_2889;
    // Op 2890: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2891: dim1x1 mul
    gl64_t s0_2891 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 30, domainSize, nCols_0)];
    gl64_t s1_2891 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    tmp1_52 = s0_2891 * s1_2891;
    // Op 2892: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2893: dim1x1 mul
    gl64_t s0_2893 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_0)];
    gl64_t s1_2893 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_1))];
    tmp1_52 = s0_2893 * s1_2893;
    // Op 2894: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2895: dim1x1 mul
    gl64_t s0_2895 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 34, domainSize, nCols_0)];
    gl64_t s1_2895 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_52 = s0_2895 * s1_2895;
    // Op 2896: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2897: dim1x1 sub
    gl64_t s0_2897 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_1))];
    tmp1_2 = s0_2897 - tmp1_2;
    // Op 2898: dim1x1 mul
    gl64_t s0_2898 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 43, domainSize, nCols_0)];
    tmp1_2 = s0_2898 * tmp1_2;
    // Op 2899: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2900: dim3x3 mul
    gl64_t s1_2900_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2900_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2900_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2900 = (tmp3_0 + tmp3_1) * (s1_2900_0 + s1_2900_1);
    gl64_t kB2900 = (tmp3_0 + tmp3_2) * (s1_2900_0 + s1_2900_2);
    gl64_t kC2900 = (tmp3_1 + tmp3_2) * (s1_2900_1 + s1_2900_2);
    gl64_t kD2900 = tmp3_0 * s1_2900_0;
    gl64_t kE2900 = tmp3_1 * s1_2900_1;
    gl64_t kF2900 = tmp3_2 * s1_2900_2;
    gl64_t kG2900 = kD2900 - kE2900;
    tmp3_0 = (kC2900 + kG2900) - kF2900;
    tmp3_1 = ((((kA2900 + kC2900) - kE2900) - kE2900) - kD2900);
    tmp3_2 = kB2900 - kG2900;
    // Op 2901: dim1x1 mul
    gl64_t s0_2901 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 27, domainSize, nCols_0)];
    gl64_t s1_2901 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    tmp1_2 = s0_2901 * s1_2901;
    // Op 2902: dim1x1 mul
    gl64_t s0_2902 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 28, domainSize, nCols_0)];
    gl64_t s1_2902 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    tmp1_52 = s0_2902 * s1_2902;
    // Op 2903: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2904: dim1x1 mul
    gl64_t s0_2904 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 29, domainSize, nCols_0)];
    gl64_t s1_2904 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    tmp1_52 = s0_2904 * s1_2904;
    // Op 2905: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2906: dim1x1 mul
    gl64_t s0_2906 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 30, domainSize, nCols_0)];
    gl64_t s1_2906 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 10, domainSize, nCols_1))];
    tmp1_52 = s0_2906 * s1_2906;
    // Op 2907: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2908: dim1x1 mul
    gl64_t s0_2908 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_0)];
    gl64_t s1_2908 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    tmp1_52 = s0_2908 * s1_2908;
    // Op 2909: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2910: dim1x1 mul
    gl64_t s0_2910 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 34, domainSize, nCols_0)];
    gl64_t s1_2910 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    tmp1_52 = s0_2910 * s1_2910;
    // Op 2911: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2912: dim1x1 sub
    gl64_t s0_2912 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    tmp1_2 = s0_2912 - tmp1_2;
    // Op 2913: dim1x1 mul
    gl64_t s0_2913 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 43, domainSize, nCols_0)];
    tmp1_2 = s0_2913 * tmp1_2;
    // Op 2914: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2915: dim3x3 mul
    gl64_t s1_2915_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2915_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2915_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2915 = (tmp3_0 + tmp3_1) * (s1_2915_0 + s1_2915_1);
    gl64_t kB2915 = (tmp3_0 + tmp3_2) * (s1_2915_0 + s1_2915_2);
    gl64_t kC2915 = (tmp3_1 + tmp3_2) * (s1_2915_1 + s1_2915_2);
    gl64_t kD2915 = tmp3_0 * s1_2915_0;
    gl64_t kE2915 = tmp3_1 * s1_2915_1;
    gl64_t kF2915 = tmp3_2 * s1_2915_2;
    gl64_t kG2915 = kD2915 - kE2915;
    tmp3_0 = (kC2915 + kG2915) - kF2915;
    tmp3_1 = ((((kA2915 + kC2915) - kE2915) - kE2915) - kD2915);
    tmp3_2 = kB2915 - kG2915;
    // Op 2916: dim1x1 mul
    gl64_t s0_2916 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 27, domainSize, nCols_0)];
    gl64_t s1_2916 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_1))];
    tmp1_2 = s0_2916 * s1_2916;
    // Op 2917: dim1x1 mul
    gl64_t s0_2917 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 28, domainSize, nCols_0)];
    gl64_t s1_2917 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    tmp1_52 = s0_2917 * s1_2917;
    // Op 2918: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2919: dim1x1 mul
    gl64_t s0_2919 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 29, domainSize, nCols_0)];
    gl64_t s1_2919 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 8, domainSize, nCols_1))];
    tmp1_52 = s0_2919 * s1_2919;
    // Op 2920: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2921: dim1x1 mul
    gl64_t s0_2921 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 30, domainSize, nCols_0)];
    gl64_t s1_2921 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    tmp1_52 = s0_2921 * s1_2921;
    // Op 2922: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2923: dim1x1 mul
    gl64_t s0_2923 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_0)];
    gl64_t s1_2923 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_1))];
    tmp1_52 = s0_2923 * s1_2923;
    // Op 2924: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2925: dim1x1 mul
    gl64_t s0_2925 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 34, domainSize, nCols_0)];
    gl64_t s1_2925 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    tmp1_52 = s0_2925 * s1_2925;
    // Op 2926: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2927: dim1x1 sub
    gl64_t s0_2927 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    tmp1_2 = s0_2927 - tmp1_2;
    // Op 2928: dim1x1 mul
    gl64_t s0_2928 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 43, domainSize, nCols_0)];
    tmp1_2 = s0_2928 * tmp1_2;
    // Op 2929: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2930: dim3x3 mul
    gl64_t s1_2930_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2930_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2930_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2930 = (tmp3_0 + tmp3_1) * (s1_2930_0 + s1_2930_1);
    gl64_t kB2930 = (tmp3_0 + tmp3_2) * (s1_2930_0 + s1_2930_2);
    gl64_t kC2930 = (tmp3_1 + tmp3_2) * (s1_2930_1 + s1_2930_2);
    gl64_t kD2930 = tmp3_0 * s1_2930_0;
    gl64_t kE2930 = tmp3_1 * s1_2930_1;
    gl64_t kF2930 = tmp3_2 * s1_2930_2;
    gl64_t kG2930 = kD2930 - kE2930;
    tmp3_0 = (kC2930 + kG2930) - kF2930;
    tmp3_1 = ((((kA2930 + kC2930) - kE2930) - kE2930) - kD2930);
    tmp3_2 = kB2930 - kG2930;
    // Op 2931: dim1x1 mul
    gl64_t s0_2931 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 27, domainSize, nCols_0)];
    gl64_t s1_2931 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_1))];
    tmp1_2 = s0_2931 * s1_2931;
    // Op 2932: dim1x1 mul
    gl64_t s0_2932 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 28, domainSize, nCols_0)];
    gl64_t s1_2932 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_52 = s0_2932 * s1_2932;
    // Op 2933: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 2934: dim1x1 mul
    gl64_t s0_2934 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 31, domainSize, nCols_0)];
    gl64_t s1_2934 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 6, domainSize, nCols_1))];
    tmp1_52 = s0_2934 * s1_2934;
    // Op 2935: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2936: dim1x1 mul
    gl64_t s0_2936 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 32, domainSize, nCols_0)];
    gl64_t s1_2936 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    tmp1_52 = s0_2936 * s1_2936;
    // Op 2937: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 2938: dim1x1 mul
    gl64_t s0_2938 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_0)];
    gl64_t s1_2938 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_1))];
    tmp1_52 = s0_2938 * s1_2938;
    // Op 2939: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2940: dim1x1 mul
    gl64_t s0_2940 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 34, domainSize, nCols_0)];
    gl64_t s1_2940 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_52 = s0_2940 * s1_2940;
    // Op 2941: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 2942: dim1x1 sub
    gl64_t s0_2942 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_2 = s0_2942 - tmp1_2;
    // Op 2943: dim1x1 mul
    gl64_t s0_2943 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 43, domainSize, nCols_0)];
    tmp1_2 = s0_2943 * tmp1_2;
    // Op 2944: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2945: dim3x3 mul
    gl64_t s1_2945_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2945_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2945_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2945 = (tmp3_0 + tmp3_1) * (s1_2945_0 + s1_2945_1);
    gl64_t kB2945 = (tmp3_0 + tmp3_2) * (s1_2945_0 + s1_2945_2);
    gl64_t kC2945 = (tmp3_1 + tmp3_2) * (s1_2945_1 + s1_2945_2);
    gl64_t kD2945 = tmp3_0 * s1_2945_0;
    gl64_t kE2945 = tmp3_1 * s1_2945_1;
    gl64_t kF2945 = tmp3_2 * s1_2945_2;
    gl64_t kG2945 = kD2945 - kE2945;
    tmp3_0 = (kC2945 + kG2945) - kF2945;
    tmp3_1 = ((((kA2945 + kC2945) - kE2945) - kE2945) - kD2945);
    tmp3_2 = kB2945 - kG2945;
    // Op 2946: dim1x1 mul
    gl64_t s0_2946 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 27, domainSize, nCols_0)];
    gl64_t s1_2946 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    tmp1_2 = s0_2946 * s1_2946;
    // Op 2947: dim1x1 mul
    gl64_t s0_2947 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 28, domainSize, nCols_0)];
    gl64_t s1_2947 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    tmp1_52 = s0_2947 * s1_2947;
    // Op 2948: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 2949: dim1x1 mul
    gl64_t s0_2949 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 31, domainSize, nCols_0)];
    gl64_t s1_2949 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    tmp1_52 = s0_2949 * s1_2949;
    // Op 2950: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2951: dim1x1 mul
    gl64_t s0_2951 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 32, domainSize, nCols_0)];
    gl64_t s1_2951 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 10, domainSize, nCols_1))];
    tmp1_52 = s0_2951 * s1_2951;
    // Op 2952: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 2953: dim1x1 mul
    gl64_t s0_2953 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_0)];
    gl64_t s1_2953 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    tmp1_52 = s0_2953 * s1_2953;
    // Op 2954: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2955: dim1x1 mul
    gl64_t s0_2955 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 34, domainSize, nCols_0)];
    gl64_t s1_2955 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    tmp1_52 = s0_2955 * s1_2955;
    // Op 2956: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 2957: dim1x1 sub
    gl64_t s0_2957 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_2 = s0_2957 - tmp1_2;
    // Op 2958: dim1x1 mul
    gl64_t s0_2958 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 43, domainSize, nCols_0)];
    tmp1_2 = s0_2958 * tmp1_2;
    // Op 2959: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2960: dim3x3 mul
    gl64_t s1_2960_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2960_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2960_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2960 = (tmp3_0 + tmp3_1) * (s1_2960_0 + s1_2960_1);
    gl64_t kB2960 = (tmp3_0 + tmp3_2) * (s1_2960_0 + s1_2960_2);
    gl64_t kC2960 = (tmp3_1 + tmp3_2) * (s1_2960_1 + s1_2960_2);
    gl64_t kD2960 = tmp3_0 * s1_2960_0;
    gl64_t kE2960 = tmp3_1 * s1_2960_1;
    gl64_t kF2960 = tmp3_2 * s1_2960_2;
    gl64_t kG2960 = kD2960 - kE2960;
    tmp3_0 = (kC2960 + kG2960) - kF2960;
    tmp3_1 = ((((kA2960 + kC2960) - kE2960) - kE2960) - kD2960);
    tmp3_2 = kB2960 - kG2960;
    // Op 2961: dim1x1 mul
    gl64_t s0_2961 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 27, domainSize, nCols_0)];
    gl64_t s1_2961 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_1))];
    tmp1_2 = s0_2961 * s1_2961;
    // Op 2962: dim1x1 mul
    gl64_t s0_2962 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 28, domainSize, nCols_0)];
    gl64_t s1_2962 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    tmp1_52 = s0_2962 * s1_2962;
    // Op 2963: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 2964: dim1x1 mul
    gl64_t s0_2964 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 31, domainSize, nCols_0)];
    gl64_t s1_2964 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 8, domainSize, nCols_1))];
    tmp1_52 = s0_2964 * s1_2964;
    // Op 2965: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2966: dim1x1 mul
    gl64_t s0_2966 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 32, domainSize, nCols_0)];
    gl64_t s1_2966 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    tmp1_52 = s0_2966 * s1_2966;
    // Op 2967: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 2968: dim1x1 mul
    gl64_t s0_2968 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_0)];
    gl64_t s1_2968 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_1))];
    tmp1_52 = s0_2968 * s1_2968;
    // Op 2969: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2970: dim1x1 mul
    gl64_t s0_2970 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 34, domainSize, nCols_0)];
    gl64_t s1_2970 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    tmp1_52 = s0_2970 * s1_2970;
    // Op 2971: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 2972: dim1x1 sub
    gl64_t s0_2972 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_2 = s0_2972 - tmp1_2;
    // Op 2973: dim1x1 mul
    gl64_t s0_2973 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 43, domainSize, nCols_0)];
    tmp1_2 = s0_2973 * tmp1_2;
    // Op 2974: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2975: dim3x3 mul
    gl64_t s1_2975_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2975_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2975_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2975 = (tmp3_0 + tmp3_1) * (s1_2975_0 + s1_2975_1);
    gl64_t kB2975 = (tmp3_0 + tmp3_2) * (s1_2975_0 + s1_2975_2);
    gl64_t kC2975 = (tmp3_1 + tmp3_2) * (s1_2975_1 + s1_2975_2);
    gl64_t kD2975 = tmp3_0 * s1_2975_0;
    gl64_t kE2975 = tmp3_1 * s1_2975_1;
    gl64_t kF2975 = tmp3_2 * s1_2975_2;
    gl64_t kG2975 = kD2975 - kE2975;
    tmp3_0 = (kC2975 + kG2975) - kF2975;
    tmp3_1 = ((((kA2975 + kC2975) - kE2975) - kE2975) - kD2975);
    tmp3_2 = kB2975 - kG2975;
    // Op 2976: dim1x1 mul
    gl64_t s0_2976 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 27, domainSize, nCols_0)];
    gl64_t s1_2976 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_1))];
    tmp1_2 = s0_2976 * s1_2976;
    // Op 2977: dim1x1 mul
    gl64_t s0_2977 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 28, domainSize, nCols_0)];
    gl64_t s1_2977 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_52 = s0_2977 * s1_2977;
    // Op 2978: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2979: dim1x1 mul
    gl64_t s0_2979 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 29, domainSize, nCols_0)];
    gl64_t s1_2979 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 6, domainSize, nCols_1))];
    tmp1_52 = s0_2979 * s1_2979;
    // Op 2980: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 2981: dim1x1 mul
    gl64_t s0_2981 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 30, domainSize, nCols_0)];
    gl64_t s1_2981 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    tmp1_52 = s0_2981 * s1_2981;
    // Op 2982: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 2983: dim1x1 mul
    gl64_t s0_2983 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_0)];
    gl64_t s1_2983 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 6, domainSize, nCols_1))];
    tmp1_52 = s0_2983 * s1_2983;
    // Op 2984: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2985: dim1x1 mul
    gl64_t s0_2985 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 35, domainSize, nCols_0)];
    gl64_t s1_2985 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    tmp1_52 = s0_2985 * s1_2985;
    // Op 2986: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2987: dim1x1 sub
    gl64_t s0_2987 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 18, domainSize, nCols_1))];
    tmp1_2 = s0_2987 - tmp1_2;
    // Op 2988: dim1x1 mul
    gl64_t s0_2988 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 43, domainSize, nCols_0)];
    tmp1_2 = s0_2988 * tmp1_2;
    // Op 2989: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2990: dim3x3 mul
    gl64_t s1_2990_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_2990_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_2990_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA2990 = (tmp3_0 + tmp3_1) * (s1_2990_0 + s1_2990_1);
    gl64_t kB2990 = (tmp3_0 + tmp3_2) * (s1_2990_0 + s1_2990_2);
    gl64_t kC2990 = (tmp3_1 + tmp3_2) * (s1_2990_1 + s1_2990_2);
    gl64_t kD2990 = tmp3_0 * s1_2990_0;
    gl64_t kE2990 = tmp3_1 * s1_2990_1;
    gl64_t kF2990 = tmp3_2 * s1_2990_2;
    gl64_t kG2990 = kD2990 - kE2990;
    tmp3_0 = (kC2990 + kG2990) - kF2990;
    tmp3_1 = ((((kA2990 + kC2990) - kE2990) - kE2990) - kD2990);
    tmp3_2 = kB2990 - kG2990;
    // Op 2991: dim1x1 mul
    gl64_t s0_2991 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 27, domainSize, nCols_0)];
    gl64_t s1_2991 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    tmp1_2 = s0_2991 * s1_2991;
    // Op 2992: dim1x1 mul
    gl64_t s0_2992 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 28, domainSize, nCols_0)];
    gl64_t s1_2992 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    tmp1_52 = s0_2992 * s1_2992;
    // Op 2993: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 2994: dim1x1 mul
    gl64_t s0_2994 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 29, domainSize, nCols_0)];
    gl64_t s1_2994 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    tmp1_52 = s0_2994 * s1_2994;
    // Op 2995: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 2996: dim1x1 mul
    gl64_t s0_2996 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 30, domainSize, nCols_0)];
    gl64_t s1_2996 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 10, domainSize, nCols_1))];
    tmp1_52 = s0_2996 * s1_2996;
    // Op 2997: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 2998: dim1x1 mul
    gl64_t s0_2998 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_0)];
    gl64_t s1_2998 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    tmp1_52 = s0_2998 * s1_2998;
    // Op 2999: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 3000: dim1x1 mul
    gl64_t s0_3000 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 35, domainSize, nCols_0)];
    gl64_t s1_3000 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 10, domainSize, nCols_1))];
    tmp1_52 = s0_3000 * s1_3000;
    // Op 3001: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 3002: dim1x1 sub
    gl64_t s0_3002 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 19, domainSize, nCols_1))];
    tmp1_2 = s0_3002 - tmp1_2;
    // Op 3003: dim1x1 mul
    gl64_t s0_3003 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 43, domainSize, nCols_0)];
    tmp1_2 = s0_3003 * tmp1_2;
    // Op 3004: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3005: dim3x3 mul
    gl64_t s1_3005_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3005_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3005_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3005 = (tmp3_0 + tmp3_1) * (s1_3005_0 + s1_3005_1);
    gl64_t kB3005 = (tmp3_0 + tmp3_2) * (s1_3005_0 + s1_3005_2);
    gl64_t kC3005 = (tmp3_1 + tmp3_2) * (s1_3005_1 + s1_3005_2);
    gl64_t kD3005 = tmp3_0 * s1_3005_0;
    gl64_t kE3005 = tmp3_1 * s1_3005_1;
    gl64_t kF3005 = tmp3_2 * s1_3005_2;
    gl64_t kG3005 = kD3005 - kE3005;
    tmp3_0 = (kC3005 + kG3005) - kF3005;
    tmp3_1 = ((((kA3005 + kC3005) - kE3005) - kE3005) - kD3005);
    tmp3_2 = kB3005 - kG3005;
    // Op 3006: dim1x1 mul
    gl64_t s0_3006 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 27, domainSize, nCols_0)];
    gl64_t s1_3006 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_1))];
    tmp1_2 = s0_3006 * s1_3006;
    // Op 3007: dim1x1 mul
    gl64_t s0_3007 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 28, domainSize, nCols_0)];
    gl64_t s1_3007 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    tmp1_52 = s0_3007 * s1_3007;
    // Op 3008: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 3009: dim1x1 mul
    gl64_t s0_3009 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 29, domainSize, nCols_0)];
    gl64_t s1_3009 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 8, domainSize, nCols_1))];
    tmp1_52 = s0_3009 * s1_3009;
    // Op 3010: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 3011: dim1x1 mul
    gl64_t s0_3011 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 30, domainSize, nCols_0)];
    gl64_t s1_3011 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    tmp1_52 = s0_3011 * s1_3011;
    // Op 3012: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 3013: dim1x1 mul
    gl64_t s0_3013 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_0)];
    gl64_t s1_3013 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 8, domainSize, nCols_1))];
    tmp1_52 = s0_3013 * s1_3013;
    // Op 3014: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 3015: dim1x1 mul
    gl64_t s0_3015 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 35, domainSize, nCols_0)];
    gl64_t s1_3015 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    tmp1_52 = s0_3015 * s1_3015;
    // Op 3016: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 3017: dim1x1 sub
    gl64_t s0_3017 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 20, domainSize, nCols_1))];
    tmp1_2 = s0_3017 - tmp1_2;
    // Op 3018: dim1x1 mul
    gl64_t s0_3018 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 43, domainSize, nCols_0)];
    tmp1_2 = s0_3018 * tmp1_2;
    // Op 3019: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3020: dim3x3 mul
    gl64_t s1_3020_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3020_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3020_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3020 = (tmp3_0 + tmp3_1) * (s1_3020_0 + s1_3020_1);
    gl64_t kB3020 = (tmp3_0 + tmp3_2) * (s1_3020_0 + s1_3020_2);
    gl64_t kC3020 = (tmp3_1 + tmp3_2) * (s1_3020_1 + s1_3020_2);
    gl64_t kD3020 = tmp3_0 * s1_3020_0;
    gl64_t kE3020 = tmp3_1 * s1_3020_1;
    gl64_t kF3020 = tmp3_2 * s1_3020_2;
    gl64_t kG3020 = kD3020 - kE3020;
    tmp3_0 = (kC3020 + kG3020) - kF3020;
    tmp3_1 = ((((kA3020 + kC3020) - kE3020) - kE3020) - kD3020);
    tmp3_2 = kB3020 - kG3020;
    // Op 3021: dim1x1 mul
    gl64_t s0_3021 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 27, domainSize, nCols_0)];
    gl64_t s1_3021 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_1))];
    tmp1_2 = s0_3021 * s1_3021;
    // Op 3022: dim1x1 mul
    gl64_t s0_3022 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 28, domainSize, nCols_0)];
    gl64_t s1_3022 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_52 = s0_3022 * s1_3022;
    // Op 3023: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 3024: dim1x1 mul
    gl64_t s0_3024 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 31, domainSize, nCols_0)];
    gl64_t s1_3024 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 6, domainSize, nCols_1))];
    tmp1_52 = s0_3024 * s1_3024;
    // Op 3025: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 3026: dim1x1 mul
    gl64_t s0_3026 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 32, domainSize, nCols_0)];
    gl64_t s1_3026 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    tmp1_52 = s0_3026 * s1_3026;
    // Op 3027: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 3028: dim1x1 mul
    gl64_t s0_3028 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_0)];
    gl64_t s1_3028 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 6, domainSize, nCols_1))];
    tmp1_52 = s0_3028 * s1_3028;
    // Op 3029: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 3030: dim1x1 mul
    gl64_t s0_3030 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 35, domainSize, nCols_0)];
    gl64_t s1_3030 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    tmp1_52 = s0_3030 * s1_3030;
    // Op 3031: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 3032: dim1x1 sub
    gl64_t s0_3032 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 21, domainSize, nCols_1))];
    tmp1_2 = s0_3032 - tmp1_2;
    // Op 3033: dim1x1 mul
    gl64_t s0_3033 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 43, domainSize, nCols_0)];
    tmp1_2 = s0_3033 * tmp1_2;
    // Op 3034: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3035: dim3x3 mul
    gl64_t s1_3035_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3035_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3035_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3035 = (tmp3_0 + tmp3_1) * (s1_3035_0 + s1_3035_1);
    gl64_t kB3035 = (tmp3_0 + tmp3_2) * (s1_3035_0 + s1_3035_2);
    gl64_t kC3035 = (tmp3_1 + tmp3_2) * (s1_3035_1 + s1_3035_2);
    gl64_t kD3035 = tmp3_0 * s1_3035_0;
    gl64_t kE3035 = tmp3_1 * s1_3035_1;
    gl64_t kF3035 = tmp3_2 * s1_3035_2;
    gl64_t kG3035 = kD3035 - kE3035;
    tmp3_0 = (kC3035 + kG3035) - kF3035;
    tmp3_1 = ((((kA3035 + kC3035) - kE3035) - kE3035) - kD3035);
    tmp3_2 = kB3035 - kG3035;
    // Op 3036: dim1x1 mul
    gl64_t s0_3036 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 27, domainSize, nCols_0)];
    gl64_t s1_3036 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    tmp1_2 = s0_3036 * s1_3036;
    // Op 3037: dim1x1 mul
    gl64_t s0_3037 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 28, domainSize, nCols_0)];
    gl64_t s1_3037 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    tmp1_52 = s0_3037 * s1_3037;
    // Op 3038: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 3039: dim1x1 mul
    gl64_t s0_3039 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 31, domainSize, nCols_0)];
    gl64_t s1_3039 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    tmp1_52 = s0_3039 * s1_3039;
    // Op 3040: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 3041: dim1x1 mul
    gl64_t s0_3041 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 32, domainSize, nCols_0)];
    gl64_t s1_3041 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 10, domainSize, nCols_1))];
    tmp1_52 = s0_3041 * s1_3041;
    // Op 3042: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 3043: dim1x1 mul
    gl64_t s0_3043 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_0)];
    gl64_t s1_3043 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    tmp1_52 = s0_3043 * s1_3043;
    // Op 3044: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 3045: dim1x1 mul
    gl64_t s0_3045 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 35, domainSize, nCols_0)];
    gl64_t s1_3045 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 10, domainSize, nCols_1))];
    tmp1_52 = s0_3045 * s1_3045;
    // Op 3046: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 3047: dim1x1 sub
    gl64_t s0_3047 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 22, domainSize, nCols_1))];
    tmp1_2 = s0_3047 - tmp1_2;
    // Op 3048: dim1x1 mul
    gl64_t s0_3048 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 43, domainSize, nCols_0)];
    tmp1_2 = s0_3048 * tmp1_2;
    // Op 3049: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3050: dim3x3 mul
    gl64_t s1_3050_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3050_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3050_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3050 = (tmp3_0 + tmp3_1) * (s1_3050_0 + s1_3050_1);
    gl64_t kB3050 = (tmp3_0 + tmp3_2) * (s1_3050_0 + s1_3050_2);
    gl64_t kC3050 = (tmp3_1 + tmp3_2) * (s1_3050_1 + s1_3050_2);
    gl64_t kD3050 = tmp3_0 * s1_3050_0;
    gl64_t kE3050 = tmp3_1 * s1_3050_1;
    gl64_t kF3050 = tmp3_2 * s1_3050_2;
    gl64_t kG3050 = kD3050 - kE3050;
    tmp3_0 = (kC3050 + kG3050) - kF3050;
    tmp3_1 = ((((kA3050 + kC3050) - kE3050) - kE3050) - kD3050);
    tmp3_2 = kB3050 - kG3050;
    // Op 3051: dim1x1 mul
    gl64_t s0_3051 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 27, domainSize, nCols_0)];
    gl64_t s1_3051 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_1))];
    tmp1_2 = s0_3051 * s1_3051;
    // Op 3052: dim1x1 mul
    gl64_t s0_3052 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 28, domainSize, nCols_0)];
    gl64_t s1_3052 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    tmp1_52 = s0_3052 * s1_3052;
    // Op 3053: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 3054: dim1x1 mul
    gl64_t s0_3054 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 31, domainSize, nCols_0)];
    gl64_t s1_3054 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 8, domainSize, nCols_1))];
    tmp1_52 = s0_3054 * s1_3054;
    // Op 3055: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 3056: dim1x1 mul
    gl64_t s0_3056 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 32, domainSize, nCols_0)];
    gl64_t s1_3056 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    tmp1_52 = s0_3056 * s1_3056;
    // Op 3057: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 3058: dim1x1 mul
    gl64_t s0_3058 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 33, domainSize, nCols_0)];
    gl64_t s1_3058 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 8, domainSize, nCols_1))];
    tmp1_52 = s0_3058 * s1_3058;
    // Op 3059: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 3060: dim1x1 mul
    gl64_t s0_3060 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 35, domainSize, nCols_0)];
    gl64_t s1_3060 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    tmp1_52 = s0_3060 * s1_3060;
    // Op 3061: dim1x1 sub
    tmp1_2 = tmp1_2 - tmp1_52;
    // Op 3062: dim1x1 sub
    gl64_t s0_3062 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 23, domainSize, nCols_1))];
    tmp1_2 = s0_3062 - tmp1_2;
    // Op 3063: dim1x1 mul
    gl64_t s0_3063 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 43, domainSize, nCols_0)];
    tmp1_2 = s0_3063 * tmp1_2;
    // Op 3064: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3065: dim3x3 mul
    gl64_t s1_3065_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3065_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3065_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3065 = (tmp3_0 + tmp3_1) * (s1_3065_0 + s1_3065_1);
    gl64_t kB3065 = (tmp3_0 + tmp3_2) * (s1_3065_0 + s1_3065_2);
    gl64_t kC3065 = (tmp3_1 + tmp3_2) * (s1_3065_1 + s1_3065_2);
    gl64_t kD3065 = tmp3_0 * s1_3065_0;
    gl64_t kE3065 = tmp3_1 * s1_3065_1;
    gl64_t kF3065 = tmp3_2 * s1_3065_2;
    gl64_t kG3065 = kD3065 - kE3065;
    tmp3_0 = (kC3065 + kG3065) - kF3065;
    tmp3_1 = ((((kA3065 + kC3065) - kE3065) - kE3065) - kD3065);
    tmp3_2 = kB3065 - kG3065;
    // Op 3066: dim1x1 mul
    gl64_t s0_3066 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_1))];
    gl64_t s1_3066 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_2 = s0_3066 * s1_3066;
    // Op 3067: dim1x1 mul
    gl64_t s0_3067 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    gl64_t s1_3067 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_52 = s0_3067 * s1_3067;
    // Op 3068: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 3069: dim1x1 mul
    gl64_t s0_3069 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    gl64_t s1_3069 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_52 = s0_3069 * s1_3069;
    // Op 3070: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 3071: dim1x1 add
    gl64_t s0_3071 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    tmp1_20 = s0_3071 + tmp1_2;
    // Op 3072: dim1x1 mul
    gl64_t s0_3072 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_23 = s0_3072 * tmp1_20;
    // Op 3073: dim1x1 mul
    gl64_t s0_3073 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_1))];
    gl64_t s1_3073 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_2 = s0_3073 * s1_3073;
    // Op 3074: dim1x1 mul
    gl64_t s0_3074 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    gl64_t s1_3074 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_52 = s0_3074 * s1_3074;
    // Op 3075: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 3076: dim1x1 mul
    gl64_t s0_3076 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    gl64_t s1_3076 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_52 = s0_3076 * s1_3076;
    // Op 3077: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 3078: dim1x1 mul
    gl64_t s0_3078 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    gl64_t s1_3078 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_52 = s0_3078 * s1_3078;
    // Op 3079: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 3080: dim1x1 mul
    gl64_t s0_3080 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    gl64_t s1_3080 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_52 = s0_3080 * s1_3080;
    // Op 3081: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 3082: dim1x1 add
    gl64_t s0_3082 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 10, domainSize, nCols_1))];
    tmp1_24 = s0_3082 + tmp1_2;
    // Op 3083: dim1x1 mul
    gl64_t s0_3083 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_2 = s0_3083 * tmp1_24;
    // Op 3084: dim1x1 add
    tmp1_52 = tmp1_23 + tmp1_2;
    // Op 3085: dim1x1 mul
    gl64_t s0_3085 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_1))];
    gl64_t s1_3085 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_2 = s0_3085 * s1_3085;
    // Op 3086: dim1x1 mul
    gl64_t s0_3086 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    gl64_t s1_3086 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_23 = s0_3086 * s1_3086;
    // Op 3087: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_23;
    // Op 3088: dim1x1 mul
    gl64_t s0_3088 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    gl64_t s1_3088 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_23 = s0_3088 * s1_3088;
    // Op 3089: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_23;
    // Op 3090: dim1x1 mul
    gl64_t s0_3090 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    gl64_t s1_3090 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_23 = s0_3090 * s1_3090;
    // Op 3091: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_23;
    // Op 3092: dim1x1 add
    gl64_t s0_3092 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    tmp1_10 = s0_3092 + tmp1_2;
    // Op 3093: dim1x1 mul
    gl64_t s0_3093 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_2 = s0_3093 * tmp1_10;
    // Op 3094: dim1x1 add
    tmp1_2 = tmp1_52 + tmp1_2;
    // Op 3095: dim1x1 add
    gl64_t s0_3095 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 6, domainSize, nCols_1))];
    tmp1_22 = s0_3095 + tmp1_2;
    // Op 3096: dim1x1 mul
    gl64_t s0_3096 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_23 = s0_3096 * tmp1_22;
    // Op 3097: dim1x1 mul
    gl64_t s0_3097 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_2 = s0_3097 * tmp1_20;
    // Op 3098: dim1x1 mul
    gl64_t s0_3098 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_52 = s0_3098 * tmp1_24;
    // Op 3099: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 3100: dim1x1 mul
    gl64_t s0_3100 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_52 = s0_3100 * tmp1_24;
    // Op 3101: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 3102: dim1x1 mul
    gl64_t s0_3102 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_52 = s0_3102 * tmp1_10;
    // Op 3103: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 3104: dim1x1 mul
    gl64_t s0_3104 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_52 = s0_3104 * tmp1_10;
    // Op 3105: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 3106: dim1x1 add
    gl64_t s0_3106 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    tmp1_52 = s0_3106 + tmp1_2;
    // Op 3107: dim1x1 mul
    gl64_t s0_3107 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_2 = s0_3107 * tmp1_52;
    // Op 3108: dim1x1 add
    tmp1_23 = tmp1_23 + tmp1_2;
    // Op 3109: dim1x1 mul
    gl64_t s0_3109 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_20 = s0_3109 * tmp1_20;
    // Op 3110: dim1x1 mul
    gl64_t s0_3110 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_2 = s0_3110 * tmp1_10;
    // Op 3111: dim1x1 add
    tmp1_2 = tmp1_20 + tmp1_2;
    // Op 3112: dim1x1 mul
    gl64_t s0_3112 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_10 = s0_3112 * tmp1_10;
    // Op 3113: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_10;
    // Op 3114: dim1x1 mul
    gl64_t s0_3114 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_24 = s0_3114 * tmp1_24;
    // Op 3115: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_24;
    // Op 3116: dim1x1 add
    gl64_t s0_3116 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 8, domainSize, nCols_1))];
    tmp1_10 = s0_3116 + tmp1_2;
    // Op 3117: dim1x1 mul
    gl64_t s0_3117 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_2 = s0_3117 * tmp1_10;
    // Op 3118: dim1x1 add
    tmp1_2 = tmp1_23 + tmp1_2;
    // Op 3119: dim1x1 add
    gl64_t s0_3119 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp1_20 = s0_3119 + tmp1_2;
    // Op 3120: dim1x1 mul
    gl64_t s0_3120 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_24 = s0_3120 * tmp1_20;
    // Op 3121: dim1x1 mul
    gl64_t s0_3121 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_2 = s0_3121 * tmp1_22;
    // Op 3122: dim1x1 mul
    gl64_t s0_3122 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_23 = s0_3122 * tmp1_52;
    // Op 3123: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_23;
    // Op 3124: dim1x1 mul
    gl64_t s0_3124 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_23 = s0_3124 * tmp1_52;
    // Op 3125: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_23;
    // Op 3126: dim1x1 mul
    gl64_t s0_3126 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_23 = s0_3126 * tmp1_10;
    // Op 3127: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_23;
    // Op 3128: dim1x1 mul
    gl64_t s0_3128 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_23 = s0_3128 * tmp1_10;
    // Op 3129: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_23;
    // Op 3130: dim1x1 add
    gl64_t s0_3130 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    tmp1_23 = s0_3130 + tmp1_2;
    // Op 3131: dim1x1 mul
    gl64_t s0_3131 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_2 = s0_3131 * tmp1_23;
    // Op 3132: dim1x1 add
    tmp1_24 = tmp1_24 + tmp1_2;
    // Op 3133: dim1x1 mul
    gl64_t s0_3133 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_22 = s0_3133 * tmp1_22;
    // Op 3134: dim1x1 mul
    gl64_t s0_3134 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_2 = s0_3134 * tmp1_10;
    // Op 3135: dim1x1 add
    tmp1_2 = tmp1_22 + tmp1_2;
    // Op 3136: dim1x1 mul
    gl64_t s0_3136 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_10 = s0_3136 * tmp1_10;
    // Op 3137: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_10;
    // Op 3138: dim1x1 mul
    gl64_t s0_3138 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_52 = s0_3138 * tmp1_52;
    // Op 3139: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 3140: dim1x1 add
    gl64_t s0_3140 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    tmp1_52 = s0_3140 + tmp1_2;
    // Op 3141: dim1x1 mul
    gl64_t s0_3141 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_2 = s0_3141 * tmp1_52;
    // Op 3142: dim1x1 add
    tmp1_2 = tmp1_24 + tmp1_2;
    // Op 3143: dim1x1 add
    gl64_t s0_3143 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_1))];
    tmp1_2 = s0_3143 + tmp1_2;
    // Op 3144: dim1x1 sub_swap
    gl64_t s0_3144 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 18, domainSize, nCols_1))];
    tmp1_2 = tmp1_2 - s0_3144;
    // Op 3145: dim1x1 mul
    gl64_t s0_3145 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 42, domainSize, nCols_0)];
    tmp1_2 = s0_3145 * tmp1_2;
    // Op 3146: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3147: dim3x3 mul
    gl64_t s1_3147_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3147_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3147_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3147 = (tmp3_0 + tmp3_1) * (s1_3147_0 + s1_3147_1);
    gl64_t kB3147 = (tmp3_0 + tmp3_2) * (s1_3147_0 + s1_3147_2);
    gl64_t kC3147 = (tmp3_1 + tmp3_2) * (s1_3147_1 + s1_3147_2);
    gl64_t kD3147 = tmp3_0 * s1_3147_0;
    gl64_t kE3147 = tmp3_1 * s1_3147_1;
    gl64_t kF3147 = tmp3_2 * s1_3147_2;
    gl64_t kG3147 = kD3147 - kE3147;
    tmp3_0 = (kC3147 + kG3147) - kF3147;
    tmp3_1 = ((((kA3147 + kC3147) - kE3147) - kE3147) - kD3147);
    tmp3_2 = kB3147 - kG3147;
    // Op 3148: dim1x1 mul
    gl64_t s0_3148 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_2 = s0_3148 * tmp1_20;
    // Op 3149: dim1x1 mul
    gl64_t s0_3149 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_24 = s0_3149 * tmp1_23;
    // Op 3150: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_24;
    // Op 3151: dim1x1 mul
    gl64_t s0_3151 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_24 = s0_3151 * tmp1_23;
    // Op 3152: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_24;
    // Op 3153: dim1x1 mul
    gl64_t s0_3153 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_24 = s0_3153 * tmp1_52;
    // Op 3154: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_24;
    // Op 3155: dim1x1 mul
    gl64_t s0_3155 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_24 = s0_3155 * tmp1_52;
    // Op 3156: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_24;
    // Op 3157: dim1x1 add
    gl64_t s0_3157 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    tmp1_2 = s0_3157 + tmp1_2;
    // Op 3158: dim1x1 sub_swap
    gl64_t s0_3158 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 19, domainSize, nCols_1))];
    tmp1_2 = tmp1_2 - s0_3158;
    // Op 3159: dim1x1 mul
    gl64_t s0_3159 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 42, domainSize, nCols_0)];
    tmp1_2 = s0_3159 * tmp1_2;
    // Op 3160: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3161: dim3x3 mul
    gl64_t s1_3161_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3161_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3161_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3161 = (tmp3_0 + tmp3_1) * (s1_3161_0 + s1_3161_1);
    gl64_t kB3161 = (tmp3_0 + tmp3_2) * (s1_3161_0 + s1_3161_2);
    gl64_t kC3161 = (tmp3_1 + tmp3_2) * (s1_3161_1 + s1_3161_2);
    gl64_t kD3161 = tmp3_0 * s1_3161_0;
    gl64_t kE3161 = tmp3_1 * s1_3161_1;
    gl64_t kF3161 = tmp3_2 * s1_3161_2;
    gl64_t kG3161 = kD3161 - kE3161;
    tmp3_0 = (kC3161 + kG3161) - kF3161;
    tmp3_1 = ((((kA3161 + kC3161) - kE3161) - kE3161) - kD3161);
    tmp3_2 = kB3161 - kG3161;
    // Op 3162: dim1x1 mul
    gl64_t s0_3162 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_20 = s0_3162 * tmp1_20;
    // Op 3163: dim1x1 mul
    gl64_t s0_3163 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_2 = s0_3163 * tmp1_52;
    // Op 3164: dim1x1 add
    tmp1_2 = tmp1_20 + tmp1_2;
    // Op 3165: dim1x1 mul
    gl64_t s0_3165 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_52 = s0_3165 * tmp1_52;
    // Op 3166: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_52;
    // Op 3167: dim1x1 mul
    gl64_t s0_3167 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_23 = s0_3167 * tmp1_23;
    // Op 3168: dim1x1 add
    tmp1_2 = tmp1_2 + tmp1_23;
    // Op 3169: dim1x1 add
    gl64_t s0_3169 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_1))];
    tmp1_2 = s0_3169 + tmp1_2;
    // Op 3170: dim1x1 sub_swap
    gl64_t s0_3170 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 20, domainSize, nCols_1))];
    tmp1_2 = tmp1_2 - s0_3170;
    // Op 3171: dim1x1 mul
    gl64_t s0_3171 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 42, domainSize, nCols_0)];
    tmp1_2 = s0_3171 * tmp1_2;
    // Op 3172: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3173: dim3x3 mul
    gl64_t s1_3173_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3173_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3173_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3173 = (tmp3_0 + tmp3_1) * (s1_3173_0 + s1_3173_1);
    gl64_t kB3173 = (tmp3_0 + tmp3_2) * (s1_3173_0 + s1_3173_2);
    gl64_t kC3173 = (tmp3_1 + tmp3_2) * (s1_3173_1 + s1_3173_2);
    gl64_t kD3173 = tmp3_0 * s1_3173_0;
    gl64_t kE3173 = tmp3_1 * s1_3173_1;
    gl64_t kF3173 = tmp3_2 * s1_3173_2;
    gl64_t kG3173 = kD3173 - kE3173;
    tmp3_0 = (kC3173 + kG3173) - kF3173;
    tmp3_1 = ((((kA3173 + kC3173) - kE3173) - kE3173) - kD3173);
    tmp3_2 = kB3173 - kG3173;
    // Op 3174: dim1x1 sub_swap
    gl64_t s0_3174 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_1))];
    gl64_t s1_3174 = *(gl64_t*)&expressions_params[9][26];
    tmp1_2 = s1_3174 - s0_3174;
    // Op 3175: dim1x1 sub_swap
    gl64_t s0_3175 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    gl64_t s1_3175 = *(gl64_t*)&expressions_params[9][26];
    tmp1_23 = s1_3175 - s0_3175;
    // Op 3176: dim1x1 mul
    tmp1_52 = tmp1_2 * tmp1_23;
    // Op 3177: dim1x1 mul
    gl64_t s0_3177 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_0)];
    tmp1_2 = s0_3177 * tmp1_52;
    // Op 3178: dim1x1 sub
    gl64_t s0_3178 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_1))];
    gl64_t s1_3178 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    tmp1_23 = s0_3178 - s1_3178;
    // Op 3179: dim1x1 mul
    tmp1_2 = tmp1_2 * tmp1_23;
    // Op 3180: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3181: dim3x3 mul
    gl64_t s1_3181_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3181_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3181_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3181 = (tmp3_0 + tmp3_1) * (s1_3181_0 + s1_3181_1);
    gl64_t kB3181 = (tmp3_0 + tmp3_2) * (s1_3181_0 + s1_3181_2);
    gl64_t kC3181 = (tmp3_1 + tmp3_2) * (s1_3181_1 + s1_3181_2);
    gl64_t kD3181 = tmp3_0 * s1_3181_0;
    gl64_t kE3181 = tmp3_1 * s1_3181_1;
    gl64_t kF3181 = tmp3_2 * s1_3181_2;
    gl64_t kG3181 = kD3181 - kE3181;
    tmp3_0 = (kC3181 + kG3181) - kF3181;
    tmp3_1 = ((((kA3181 + kC3181) - kE3181) - kE3181) - kD3181);
    tmp3_2 = kB3181 - kG3181;
    // Op 3182: dim1x1 mul
    gl64_t s0_3182 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_0)];
    tmp1_2 = s0_3182 * tmp1_52;
    // Op 3183: dim1x1 sub
    gl64_t s0_3183 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    gl64_t s1_3183 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_23 = s0_3183 - s1_3183;
    // Op 3184: dim1x1 mul
    tmp1_2 = tmp1_2 * tmp1_23;
    // Op 3185: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3186: dim3x3 mul
    gl64_t s1_3186_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3186_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3186_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3186 = (tmp3_0 + tmp3_1) * (s1_3186_0 + s1_3186_1);
    gl64_t kB3186 = (tmp3_0 + tmp3_2) * (s1_3186_0 + s1_3186_2);
    gl64_t kC3186 = (tmp3_1 + tmp3_2) * (s1_3186_1 + s1_3186_2);
    gl64_t kD3186 = tmp3_0 * s1_3186_0;
    gl64_t kE3186 = tmp3_1 * s1_3186_1;
    gl64_t kF3186 = tmp3_2 * s1_3186_2;
    gl64_t kG3186 = kD3186 - kE3186;
    tmp3_0 = (kC3186 + kG3186) - kF3186;
    tmp3_1 = ((((kA3186 + kC3186) - kE3186) - kE3186) - kD3186);
    tmp3_2 = kB3186 - kG3186;
    // Op 3187: dim1x1 mul
    gl64_t s0_3187 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_0)];
    tmp1_52 = s0_3187 * tmp1_52;
    // Op 3188: dim1x1 sub
    gl64_t s0_3188 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_1))];
    gl64_t s1_3188 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_2 = s0_3188 - s1_3188;
    // Op 3189: dim1x1 mul
    tmp1_2 = tmp1_52 * tmp1_2;
    // Op 3190: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3191: dim3x3 mul
    gl64_t s1_3191_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3191_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3191_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3191 = (tmp3_0 + tmp3_1) * (s1_3191_0 + s1_3191_1);
    gl64_t kB3191 = (tmp3_0 + tmp3_2) * (s1_3191_0 + s1_3191_2);
    gl64_t kC3191 = (tmp3_1 + tmp3_2) * (s1_3191_1 + s1_3191_2);
    gl64_t kD3191 = tmp3_0 * s1_3191_0;
    gl64_t kE3191 = tmp3_1 * s1_3191_1;
    gl64_t kF3191 = tmp3_2 * s1_3191_2;
    gl64_t kG3191 = kD3191 - kE3191;
    tmp3_0 = (kC3191 + kG3191) - kF3191;
    tmp3_1 = ((((kA3191 + kC3191) - kE3191) - kE3191) - kD3191);
    tmp3_2 = kB3191 - kG3191;
    // Op 3192: dim1x1 sub_swap
    gl64_t s0_3192 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    gl64_t s1_3192 = *(gl64_t*)&expressions_params[9][26];
    tmp1_2 = s1_3192 - s0_3192;
    // Op 3193: dim1x1 mul
    gl64_t s0_3193 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_1))];
    tmp1_23 = s0_3193 * tmp1_2;
    // Op 3194: dim1x1 mul
    gl64_t s0_3194 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_0)];
    tmp1_2 = s0_3194 * tmp1_23;
    // Op 3195: dim1x1 sub
    gl64_t s0_3195 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    gl64_t s1_3195 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    tmp1_52 = s0_3195 - s1_3195;
    // Op 3196: dim1x1 mul
    tmp1_2 = tmp1_2 * tmp1_52;
    // Op 3197: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3198: dim3x3 mul
    gl64_t s1_3198_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3198_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3198_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3198 = (tmp3_0 + tmp3_1) * (s1_3198_0 + s1_3198_1);
    gl64_t kB3198 = (tmp3_0 + tmp3_2) * (s1_3198_0 + s1_3198_2);
    gl64_t kC3198 = (tmp3_1 + tmp3_2) * (s1_3198_1 + s1_3198_2);
    gl64_t kD3198 = tmp3_0 * s1_3198_0;
    gl64_t kE3198 = tmp3_1 * s1_3198_1;
    gl64_t kF3198 = tmp3_2 * s1_3198_2;
    gl64_t kG3198 = kD3198 - kE3198;
    tmp3_0 = (kC3198 + kG3198) - kF3198;
    tmp3_1 = ((((kA3198 + kC3198) - kE3198) - kE3198) - kD3198);
    tmp3_2 = kB3198 - kG3198;
    // Op 3199: dim1x1 mul
    gl64_t s0_3199 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_0)];
    tmp1_2 = s0_3199 * tmp1_23;
    // Op 3200: dim1x1 sub
    gl64_t s0_3200 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    gl64_t s1_3200 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_52 = s0_3200 - s1_3200;
    // Op 3201: dim1x1 mul
    tmp1_2 = tmp1_2 * tmp1_52;
    // Op 3202: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3203: dim3x3 mul
    gl64_t s1_3203_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3203_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3203_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3203 = (tmp3_0 + tmp3_1) * (s1_3203_0 + s1_3203_1);
    gl64_t kB3203 = (tmp3_0 + tmp3_2) * (s1_3203_0 + s1_3203_2);
    gl64_t kC3203 = (tmp3_1 + tmp3_2) * (s1_3203_1 + s1_3203_2);
    gl64_t kD3203 = tmp3_0 * s1_3203_0;
    gl64_t kE3203 = tmp3_1 * s1_3203_1;
    gl64_t kF3203 = tmp3_2 * s1_3203_2;
    gl64_t kG3203 = kD3203 - kE3203;
    tmp3_0 = (kC3203 + kG3203) - kF3203;
    tmp3_1 = ((((kA3203 + kC3203) - kE3203) - kE3203) - kD3203);
    tmp3_2 = kB3203 - kG3203;
    // Op 3204: dim1x1 mul
    gl64_t s0_3204 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_0)];
    tmp1_23 = s0_3204 * tmp1_23;
    // Op 3205: dim1x1 sub
    gl64_t s0_3205 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    gl64_t s1_3205 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_2 = s0_3205 - s1_3205;
    // Op 3206: dim1x1 mul
    tmp1_2 = tmp1_23 * tmp1_2;
    // Op 3207: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3208: dim3x3 mul
    gl64_t s1_3208_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3208_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3208_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3208 = (tmp3_0 + tmp3_1) * (s1_3208_0 + s1_3208_1);
    gl64_t kB3208 = (tmp3_0 + tmp3_2) * (s1_3208_0 + s1_3208_2);
    gl64_t kC3208 = (tmp3_1 + tmp3_2) * (s1_3208_1 + s1_3208_2);
    gl64_t kD3208 = tmp3_0 * s1_3208_0;
    gl64_t kE3208 = tmp3_1 * s1_3208_1;
    gl64_t kF3208 = tmp3_2 * s1_3208_2;
    gl64_t kG3208 = kD3208 - kE3208;
    tmp3_0 = (kC3208 + kG3208) - kF3208;
    tmp3_1 = ((((kA3208 + kC3208) - kE3208) - kE3208) - kD3208);
    tmp3_2 = kB3208 - kG3208;
    // Op 3209: dim1x1 sub_swap
    gl64_t s0_3209 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_1))];
    gl64_t s1_3209 = *(gl64_t*)&expressions_params[9][26];
    tmp1_2 = s1_3209 - s0_3209;
    // Op 3210: dim1x1 mul
    gl64_t s0_3210 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    tmp1_52 = s0_3210 * tmp1_2;
    // Op 3211: dim1x1 mul
    gl64_t s0_3211 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_0)];
    tmp1_2 = s0_3211 * tmp1_52;
    // Op 3212: dim1x1 sub
    gl64_t s0_3212 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 6, domainSize, nCols_1))];
    gl64_t s1_3212 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    tmp1_23 = s0_3212 - s1_3212;
    // Op 3213: dim1x1 mul
    tmp1_2 = tmp1_2 * tmp1_23;
    // Op 3214: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3215: dim3x3 mul
    gl64_t s1_3215_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3215_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3215_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3215 = (tmp3_0 + tmp3_1) * (s1_3215_0 + s1_3215_1);
    gl64_t kB3215 = (tmp3_0 + tmp3_2) * (s1_3215_0 + s1_3215_2);
    gl64_t kC3215 = (tmp3_1 + tmp3_2) * (s1_3215_1 + s1_3215_2);
    gl64_t kD3215 = tmp3_0 * s1_3215_0;
    gl64_t kE3215 = tmp3_1 * s1_3215_1;
    gl64_t kF3215 = tmp3_2 * s1_3215_2;
    gl64_t kG3215 = kD3215 - kE3215;
    tmp3_0 = (kC3215 + kG3215) - kF3215;
    tmp3_1 = ((((kA3215 + kC3215) - kE3215) - kE3215) - kD3215);
    tmp3_2 = kB3215 - kG3215;
    // Op 3216: dim1x1 mul
    gl64_t s0_3216 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_0)];
    tmp1_2 = s0_3216 * tmp1_52;
    // Op 3217: dim1x1 sub
    gl64_t s0_3217 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    gl64_t s1_3217 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_23 = s0_3217 - s1_3217;
    // Op 3218: dim1x1 mul
    tmp1_2 = tmp1_2 * tmp1_23;
    // Op 3219: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3220: dim3x3 mul
    gl64_t s1_3220_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3220_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3220_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3220 = (tmp3_0 + tmp3_1) * (s1_3220_0 + s1_3220_1);
    gl64_t kB3220 = (tmp3_0 + tmp3_2) * (s1_3220_0 + s1_3220_2);
    gl64_t kC3220 = (tmp3_1 + tmp3_2) * (s1_3220_1 + s1_3220_2);
    gl64_t kD3220 = tmp3_0 * s1_3220_0;
    gl64_t kE3220 = tmp3_1 * s1_3220_1;
    gl64_t kF3220 = tmp3_2 * s1_3220_2;
    gl64_t kG3220 = kD3220 - kE3220;
    tmp3_0 = (kC3220 + kG3220) - kF3220;
    tmp3_1 = ((((kA3220 + kC3220) - kE3220) - kE3220) - kD3220);
    tmp3_2 = kB3220 - kG3220;
    // Op 3221: dim1x1 mul
    gl64_t s0_3221 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_0)];
    tmp1_52 = s0_3221 * tmp1_52;
    // Op 3222: dim1x1 sub
    gl64_t s0_3222 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 8, domainSize, nCols_1))];
    gl64_t s1_3222 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_2 = s0_3222 - s1_3222;
    // Op 3223: dim1x1 mul
    tmp1_2 = tmp1_52 * tmp1_2;
    // Op 3224: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3225: dim3x3 mul
    gl64_t s1_3225_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3225_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3225_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3225 = (tmp3_0 + tmp3_1) * (s1_3225_0 + s1_3225_1);
    gl64_t kB3225 = (tmp3_0 + tmp3_2) * (s1_3225_0 + s1_3225_2);
    gl64_t kC3225 = (tmp3_1 + tmp3_2) * (s1_3225_1 + s1_3225_2);
    gl64_t kD3225 = tmp3_0 * s1_3225_0;
    gl64_t kE3225 = tmp3_1 * s1_3225_1;
    gl64_t kF3225 = tmp3_2 * s1_3225_2;
    gl64_t kG3225 = kD3225 - kE3225;
    tmp3_0 = (kC3225 + kG3225) - kF3225;
    tmp3_1 = ((((kA3225 + kC3225) - kE3225) - kE3225) - kD3225);
    tmp3_2 = kB3225 - kG3225;
    // Op 3226: dim1x1 mul
    gl64_t s0_3226 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_1))];
    gl64_t s1_3226 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    tmp1_23 = s0_3226 * s1_3226;
    // Op 3227: dim1x1 mul
    gl64_t s0_3227 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_0)];
    tmp1_2 = s0_3227 * tmp1_23;
    // Op 3228: dim1x1 sub
    gl64_t s0_3228 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    gl64_t s1_3228 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    tmp1_52 = s0_3228 - s1_3228;
    // Op 3229: dim1x1 mul
    tmp1_2 = tmp1_2 * tmp1_52;
    // Op 3230: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3231: dim3x3 mul
    gl64_t s1_3231_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3231_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3231_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3231 = (tmp3_0 + tmp3_1) * (s1_3231_0 + s1_3231_1);
    gl64_t kB3231 = (tmp3_0 + tmp3_2) * (s1_3231_0 + s1_3231_2);
    gl64_t kC3231 = (tmp3_1 + tmp3_2) * (s1_3231_1 + s1_3231_2);
    gl64_t kD3231 = tmp3_0 * s1_3231_0;
    gl64_t kE3231 = tmp3_1 * s1_3231_1;
    gl64_t kF3231 = tmp3_2 * s1_3231_2;
    gl64_t kG3231 = kD3231 - kE3231;
    tmp3_0 = (kC3231 + kG3231) - kF3231;
    tmp3_1 = ((((kA3231 + kC3231) - kE3231) - kE3231) - kD3231);
    tmp3_2 = kB3231 - kG3231;
    // Op 3232: dim1x1 mul
    gl64_t s0_3232 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_0)];
    tmp1_2 = s0_3232 * tmp1_23;
    // Op 3233: dim1x1 sub
    gl64_t s0_3233 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 10, domainSize, nCols_1))];
    gl64_t s1_3233 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp1_52 = s0_3233 - s1_3233;
    // Op 3234: dim1x1 mul
    tmp1_2 = tmp1_2 * tmp1_52;
    // Op 3235: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3236: dim3x3 mul
    gl64_t s1_3236_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3236_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3236_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3236 = (tmp3_0 + tmp3_1) * (s1_3236_0 + s1_3236_1);
    gl64_t kB3236 = (tmp3_0 + tmp3_2) * (s1_3236_0 + s1_3236_2);
    gl64_t kC3236 = (tmp3_1 + tmp3_2) * (s1_3236_1 + s1_3236_2);
    gl64_t kD3236 = tmp3_0 * s1_3236_0;
    gl64_t kE3236 = tmp3_1 * s1_3236_1;
    gl64_t kF3236 = tmp3_2 * s1_3236_2;
    gl64_t kG3236 = kD3236 - kE3236;
    tmp3_0 = (kC3236 + kG3236) - kF3236;
    tmp3_1 = ((((kA3236 + kC3236) - kE3236) - kE3236) - kD3236);
    tmp3_2 = kB3236 - kG3236;
    // Op 3237: dim1x1 mul
    gl64_t s0_3237 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_0)];
    tmp1_23 = s0_3237 * tmp1_23;
    // Op 3238: dim1x1 sub
    gl64_t s0_3238 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    gl64_t s1_3238 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_2 = s0_3238 - s1_3238;
    // Op 3239: dim1x1 mul
    tmp1_2 = tmp1_23 * tmp1_2;
    // Op 3240: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3241: dim3x3 mul
    gl64_t s1_3241_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3241_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3241_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3241 = (tmp3_0 + tmp3_1) * (s1_3241_0 + s1_3241_1);
    gl64_t kB3241 = (tmp3_0 + tmp3_2) * (s1_3241_0 + s1_3241_2);
    gl64_t kC3241 = (tmp3_1 + tmp3_2) * (s1_3241_1 + s1_3241_2);
    gl64_t kD3241 = tmp3_0 * s1_3241_0;
    gl64_t kE3241 = tmp3_1 * s1_3241_1;
    gl64_t kF3241 = tmp3_2 * s1_3241_2;
    gl64_t kG3241 = kD3241 - kE3241;
    tmp3_0 = (kC3241 + kG3241) - kF3241;
    tmp3_1 = ((((kA3241 + kC3241) - kE3241) - kE3241) - kD3241);
    tmp3_2 = kB3241 - kG3241;
    // Op 3242: dim1x1 sub_swap
    gl64_t s0_3242 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_1))];
    gl64_t s1_3242 = *(gl64_t*)&expressions_params[9][26];
    tmp1_2 = s1_3242 - s0_3242;
    // Op 3243: dim1x1 mul
    gl64_t s0_3243 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_1))];
    tmp1_2 = s0_3243 * tmp1_2;
    // Op 3244: dim1x1 mul
    gl64_t s0_3244 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_0)];
    tmp1_2 = s0_3244 * tmp1_2;
    // Op 3245: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3246: dim3x3 mul
    gl64_t s1_3246_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3246_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3246_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3246 = (tmp3_0 + tmp3_1) * (s1_3246_0 + s1_3246_1);
    gl64_t kB3246 = (tmp3_0 + tmp3_2) * (s1_3246_0 + s1_3246_2);
    gl64_t kC3246 = (tmp3_1 + tmp3_2) * (s1_3246_1 + s1_3246_2);
    gl64_t kD3246 = tmp3_0 * s1_3246_0;
    gl64_t kE3246 = tmp3_1 * s1_3246_1;
    gl64_t kF3246 = tmp3_2 * s1_3246_2;
    gl64_t kG3246 = kD3246 - kE3246;
    tmp3_0 = (kC3246 + kG3246) - kF3246;
    tmp3_1 = ((((kA3246 + kC3246) - kE3246) - kE3246) - kD3246);
    tmp3_2 = kB3246 - kG3246;
    // Op 3247: dim1x1 sub_swap
    gl64_t s0_3247 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    gl64_t s1_3247 = *(gl64_t*)&expressions_params[9][26];
    tmp1_2 = s1_3247 - s0_3247;
    // Op 3248: dim1x1 mul
    gl64_t s0_3248 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    tmp1_2 = s0_3248 * tmp1_2;
    // Op 3249: dim1x1 mul
    gl64_t s0_3249 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 44, domainSize, nCols_0)];
    tmp1_2 = s0_3249 * tmp1_2;
    // Op 3250: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3251: dim3x3 mul
    gl64_t s1_3251_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3251_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3251_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3251 = (tmp3_0 + tmp3_1) * (s1_3251_0 + s1_3251_1);
    gl64_t kB3251 = (tmp3_0 + tmp3_2) * (s1_3251_0 + s1_3251_2);
    gl64_t kC3251 = (tmp3_1 + tmp3_2) * (s1_3251_1 + s1_3251_2);
    gl64_t kD3251 = tmp3_0 * s1_3251_0;
    gl64_t kE3251 = tmp3_1 * s1_3251_1;
    gl64_t kF3251 = tmp3_2 * s1_3251_2;
    gl64_t kG3251 = kD3251 - kE3251;
    tmp3_0 = (kC3251 + kG3251) - kF3251;
    tmp3_1 = ((((kA3251 + kC3251) - kE3251) - kE3251) - kD3251);
    tmp3_2 = kB3251 - kG3251;
    // Op 3252: dim1x1 sub_swap
    gl64_t s0_3252 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    gl64_t s1_3252 = *(gl64_t*)&expressions_params[9][26];
    tmp1_2 = s1_3252 - s0_3252;
    // Op 3253: dim1x1 sub_swap
    gl64_t s0_3253 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    gl64_t s1_3253 = *(gl64_t*)&expressions_params[9][26];
    tmp1_23 = s1_3253 - s0_3253;
    // Op 3254: dim1x1 mul
    tmp1_52 = tmp1_2 * tmp1_23;
    // Op 3255: dim1x1 mul
    gl64_t s0_3255 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_0)];
    tmp1_2 = s0_3255 * tmp1_52;
    // Op 3256: dim1x1 sub
    gl64_t s0_3256 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_1))];
    gl64_t s1_3256 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 18, domainSize, nCols_1))];
    tmp1_23 = s0_3256 - s1_3256;
    // Op 3257: dim1x1 mul
    tmp1_2 = tmp1_2 * tmp1_23;
    // Op 3258: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3259: dim3x3 mul
    gl64_t s1_3259_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3259_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3259_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3259 = (tmp3_0 + tmp3_1) * (s1_3259_0 + s1_3259_1);
    gl64_t kB3259 = (tmp3_0 + tmp3_2) * (s1_3259_0 + s1_3259_2);
    gl64_t kC3259 = (tmp3_1 + tmp3_2) * (s1_3259_1 + s1_3259_2);
    gl64_t kD3259 = tmp3_0 * s1_3259_0;
    gl64_t kE3259 = tmp3_1 * s1_3259_1;
    gl64_t kF3259 = tmp3_2 * s1_3259_2;
    gl64_t kG3259 = kD3259 - kE3259;
    tmp3_0 = (kC3259 + kG3259) - kF3259;
    tmp3_1 = ((((kA3259 + kC3259) - kE3259) - kE3259) - kD3259);
    tmp3_2 = kB3259 - kG3259;
    // Op 3260: dim1x1 mul
    gl64_t s0_3260 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_0)];
    tmp1_2 = s0_3260 * tmp1_52;
    // Op 3261: dim1x1 sub
    gl64_t s0_3261 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    gl64_t s1_3261 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 19, domainSize, nCols_1))];
    tmp1_23 = s0_3261 - s1_3261;
    // Op 3262: dim1x1 mul
    tmp1_2 = tmp1_2 * tmp1_23;
    // Op 3263: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3264: dim3x3 mul
    gl64_t s1_3264_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3264_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3264_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3264 = (tmp3_0 + tmp3_1) * (s1_3264_0 + s1_3264_1);
    gl64_t kB3264 = (tmp3_0 + tmp3_2) * (s1_3264_0 + s1_3264_2);
    gl64_t kC3264 = (tmp3_1 + tmp3_2) * (s1_3264_1 + s1_3264_2);
    gl64_t kD3264 = tmp3_0 * s1_3264_0;
    gl64_t kE3264 = tmp3_1 * s1_3264_1;
    gl64_t kF3264 = tmp3_2 * s1_3264_2;
    gl64_t kG3264 = kD3264 - kE3264;
    tmp3_0 = (kC3264 + kG3264) - kF3264;
    tmp3_1 = ((((kA3264 + kC3264) - kE3264) - kE3264) - kD3264);
    tmp3_2 = kB3264 - kG3264;
    // Op 3265: dim1x1 mul
    gl64_t s0_3265 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_0)];
    tmp1_2 = s0_3265 * tmp1_52;
    // Op 3266: dim1x1 sub
    gl64_t s0_3266 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_1))];
    gl64_t s1_3266 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 20, domainSize, nCols_1))];
    tmp1_23 = s0_3266 - s1_3266;
    // Op 3267: dim1x1 mul
    tmp1_2 = tmp1_2 * tmp1_23;
    // Op 3268: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3269: dim3x3 mul
    gl64_t s1_3269_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3269_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3269_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3269 = (tmp3_0 + tmp3_1) * (s1_3269_0 + s1_3269_1);
    gl64_t kB3269 = (tmp3_0 + tmp3_2) * (s1_3269_0 + s1_3269_2);
    gl64_t kC3269 = (tmp3_1 + tmp3_2) * (s1_3269_1 + s1_3269_2);
    gl64_t kD3269 = tmp3_0 * s1_3269_0;
    gl64_t kE3269 = tmp3_1 * s1_3269_1;
    gl64_t kF3269 = tmp3_2 * s1_3269_2;
    gl64_t kG3269 = kD3269 - kE3269;
    tmp3_0 = (kC3269 + kG3269) - kF3269;
    tmp3_1 = ((((kA3269 + kC3269) - kE3269) - kE3269) - kD3269);
    tmp3_2 = kB3269 - kG3269;
    // Op 3270: dim1x1 mul
    gl64_t s0_3270 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_0)];
    tmp1_52 = s0_3270 * tmp1_52;
    // Op 3271: dim1x1 sub
    gl64_t s0_3271 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    gl64_t s1_3271 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 21, domainSize, nCols_1))];
    tmp1_2 = s0_3271 - s1_3271;
    // Op 3272: dim1x1 mul
    tmp1_2 = tmp1_52 * tmp1_2;
    // Op 3273: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3274: dim3x3 mul
    gl64_t s1_3274_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3274_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3274_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3274 = (tmp3_0 + tmp3_1) * (s1_3274_0 + s1_3274_1);
    gl64_t kB3274 = (tmp3_0 + tmp3_2) * (s1_3274_0 + s1_3274_2);
    gl64_t kC3274 = (tmp3_1 + tmp3_2) * (s1_3274_1 + s1_3274_2);
    gl64_t kD3274 = tmp3_0 * s1_3274_0;
    gl64_t kE3274 = tmp3_1 * s1_3274_1;
    gl64_t kF3274 = tmp3_2 * s1_3274_2;
    gl64_t kG3274 = kD3274 - kE3274;
    tmp3_0 = (kC3274 + kG3274) - kF3274;
    tmp3_1 = ((((kA3274 + kC3274) - kE3274) - kE3274) - kD3274);
    tmp3_2 = kB3274 - kG3274;
    // Op 3275: dim1x1 sub_swap
    gl64_t s0_3275 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    gl64_t s1_3275 = *(gl64_t*)&expressions_params[9][26];
    tmp1_2 = s1_3275 - s0_3275;
    // Op 3276: dim1x1 mul
    gl64_t s0_3276 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_23 = s0_3276 * tmp1_2;
    // Op 3277: dim1x1 mul
    gl64_t s0_3277 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_0)];
    tmp1_2 = s0_3277 * tmp1_23;
    // Op 3278: dim1x1 sub
    gl64_t s0_3278 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    gl64_t s1_3278 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 18, domainSize, nCols_1))];
    tmp1_52 = s0_3278 - s1_3278;
    // Op 3279: dim1x1 mul
    tmp1_2 = tmp1_2 * tmp1_52;
    // Op 3280: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3281: dim3x3 mul
    gl64_t s1_3281_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3281_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3281_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3281 = (tmp3_0 + tmp3_1) * (s1_3281_0 + s1_3281_1);
    gl64_t kB3281 = (tmp3_0 + tmp3_2) * (s1_3281_0 + s1_3281_2);
    gl64_t kC3281 = (tmp3_1 + tmp3_2) * (s1_3281_1 + s1_3281_2);
    gl64_t kD3281 = tmp3_0 * s1_3281_0;
    gl64_t kE3281 = tmp3_1 * s1_3281_1;
    gl64_t kF3281 = tmp3_2 * s1_3281_2;
    gl64_t kG3281 = kD3281 - kE3281;
    tmp3_0 = (kC3281 + kG3281) - kF3281;
    tmp3_1 = ((((kA3281 + kC3281) - kE3281) - kE3281) - kD3281);
    tmp3_2 = kB3281 - kG3281;
    // Op 3282: dim1x1 mul
    gl64_t s0_3282 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_0)];
    tmp1_2 = s0_3282 * tmp1_23;
    // Op 3283: dim1x1 sub
    gl64_t s0_3283 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    gl64_t s1_3283 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 19, domainSize, nCols_1))];
    tmp1_52 = s0_3283 - s1_3283;
    // Op 3284: dim1x1 mul
    tmp1_2 = tmp1_2 * tmp1_52;
    // Op 3285: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3286: dim3x3 mul
    gl64_t s1_3286_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3286_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3286_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3286 = (tmp3_0 + tmp3_1) * (s1_3286_0 + s1_3286_1);
    gl64_t kB3286 = (tmp3_0 + tmp3_2) * (s1_3286_0 + s1_3286_2);
    gl64_t kC3286 = (tmp3_1 + tmp3_2) * (s1_3286_1 + s1_3286_2);
    gl64_t kD3286 = tmp3_0 * s1_3286_0;
    gl64_t kE3286 = tmp3_1 * s1_3286_1;
    gl64_t kF3286 = tmp3_2 * s1_3286_2;
    gl64_t kG3286 = kD3286 - kE3286;
    tmp3_0 = (kC3286 + kG3286) - kF3286;
    tmp3_1 = ((((kA3286 + kC3286) - kE3286) - kE3286) - kD3286);
    tmp3_2 = kB3286 - kG3286;
    // Op 3287: dim1x1 mul
    gl64_t s0_3287 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_0)];
    tmp1_2 = s0_3287 * tmp1_23;
    // Op 3288: dim1x1 sub
    gl64_t s0_3288 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 6, domainSize, nCols_1))];
    gl64_t s1_3288 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 20, domainSize, nCols_1))];
    tmp1_52 = s0_3288 - s1_3288;
    // Op 3289: dim1x1 mul
    tmp1_2 = tmp1_2 * tmp1_52;
    // Op 3290: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3291: dim3x3 mul
    gl64_t s1_3291_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3291_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3291_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3291 = (tmp3_0 + tmp3_1) * (s1_3291_0 + s1_3291_1);
    gl64_t kB3291 = (tmp3_0 + tmp3_2) * (s1_3291_0 + s1_3291_2);
    gl64_t kC3291 = (tmp3_1 + tmp3_2) * (s1_3291_1 + s1_3291_2);
    gl64_t kD3291 = tmp3_0 * s1_3291_0;
    gl64_t kE3291 = tmp3_1 * s1_3291_1;
    gl64_t kF3291 = tmp3_2 * s1_3291_2;
    gl64_t kG3291 = kD3291 - kE3291;
    tmp3_0 = (kC3291 + kG3291) - kF3291;
    tmp3_1 = ((((kA3291 + kC3291) - kE3291) - kE3291) - kD3291);
    tmp3_2 = kB3291 - kG3291;
    // Op 3292: dim1x1 mul
    gl64_t s0_3292 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_0)];
    tmp1_23 = s0_3292 * tmp1_23;
    // Op 3293: dim1x1 sub
    gl64_t s0_3293 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    gl64_t s1_3293 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 21, domainSize, nCols_1))];
    tmp1_2 = s0_3293 - s1_3293;
    // Op 3294: dim1x1 mul
    tmp1_2 = tmp1_23 * tmp1_2;
    // Op 3295: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3296: dim3x3 mul
    gl64_t s1_3296_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3296_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3296_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3296 = (tmp3_0 + tmp3_1) * (s1_3296_0 + s1_3296_1);
    gl64_t kB3296 = (tmp3_0 + tmp3_2) * (s1_3296_0 + s1_3296_2);
    gl64_t kC3296 = (tmp3_1 + tmp3_2) * (s1_3296_1 + s1_3296_2);
    gl64_t kD3296 = tmp3_0 * s1_3296_0;
    gl64_t kE3296 = tmp3_1 * s1_3296_1;
    gl64_t kF3296 = tmp3_2 * s1_3296_2;
    gl64_t kG3296 = kD3296 - kE3296;
    tmp3_0 = (kC3296 + kG3296) - kF3296;
    tmp3_1 = ((((kA3296 + kC3296) - kE3296) - kE3296) - kD3296);
    tmp3_2 = kB3296 - kG3296;
    // Op 3297: dim1x1 sub_swap
    gl64_t s0_3297 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    gl64_t s1_3297 = *(gl64_t*)&expressions_params[9][26];
    tmp1_2 = s1_3297 - s0_3297;
    // Op 3298: dim1x1 mul
    gl64_t s0_3298 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_52 = s0_3298 * tmp1_2;
    // Op 3299: dim1x1 mul
    gl64_t s0_3299 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_0)];
    tmp1_2 = s0_3299 * tmp1_52;
    // Op 3300: dim1x1 sub
    gl64_t s0_3300 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 8, domainSize, nCols_1))];
    gl64_t s1_3300 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 18, domainSize, nCols_1))];
    tmp1_23 = s0_3300 - s1_3300;
    // Op 3301: dim1x1 mul
    tmp1_2 = tmp1_2 * tmp1_23;
    // Op 3302: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3303: dim3x3 mul
    gl64_t s1_3303_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3303_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3303_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3303 = (tmp3_0 + tmp3_1) * (s1_3303_0 + s1_3303_1);
    gl64_t kB3303 = (tmp3_0 + tmp3_2) * (s1_3303_0 + s1_3303_2);
    gl64_t kC3303 = (tmp3_1 + tmp3_2) * (s1_3303_1 + s1_3303_2);
    gl64_t kD3303 = tmp3_0 * s1_3303_0;
    gl64_t kE3303 = tmp3_1 * s1_3303_1;
    gl64_t kF3303 = tmp3_2 * s1_3303_2;
    gl64_t kG3303 = kD3303 - kE3303;
    tmp3_0 = (kC3303 + kG3303) - kF3303;
    tmp3_1 = ((((kA3303 + kC3303) - kE3303) - kE3303) - kD3303);
    tmp3_2 = kB3303 - kG3303;
    // Op 3304: dim1x1 mul
    gl64_t s0_3304 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_0)];
    tmp1_2 = s0_3304 * tmp1_52;
    // Op 3305: dim1x1 sub
    gl64_t s0_3305 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    gl64_t s1_3305 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 19, domainSize, nCols_1))];
    tmp1_23 = s0_3305 - s1_3305;
    // Op 3306: dim1x1 mul
    tmp1_2 = tmp1_2 * tmp1_23;
    // Op 3307: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3308: dim3x3 mul
    gl64_t s1_3308_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3308_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3308_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3308 = (tmp3_0 + tmp3_1) * (s1_3308_0 + s1_3308_1);
    gl64_t kB3308 = (tmp3_0 + tmp3_2) * (s1_3308_0 + s1_3308_2);
    gl64_t kC3308 = (tmp3_1 + tmp3_2) * (s1_3308_1 + s1_3308_2);
    gl64_t kD3308 = tmp3_0 * s1_3308_0;
    gl64_t kE3308 = tmp3_1 * s1_3308_1;
    gl64_t kF3308 = tmp3_2 * s1_3308_2;
    gl64_t kG3308 = kD3308 - kE3308;
    tmp3_0 = (kC3308 + kG3308) - kF3308;
    tmp3_1 = ((((kA3308 + kC3308) - kE3308) - kE3308) - kD3308);
    tmp3_2 = kB3308 - kG3308;
    // Op 3309: dim1x1 mul
    gl64_t s0_3309 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_0)];
    tmp1_2 = s0_3309 * tmp1_52;
    // Op 3310: dim1x1 sub
    gl64_t s0_3310 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 10, domainSize, nCols_1))];
    gl64_t s1_3310 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 20, domainSize, nCols_1))];
    tmp1_23 = s0_3310 - s1_3310;
    // Op 3311: dim1x1 mul
    tmp1_2 = tmp1_2 * tmp1_23;
    // Op 3312: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3313: dim3x3 mul
    gl64_t s1_3313_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3313_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3313_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3313 = (tmp3_0 + tmp3_1) * (s1_3313_0 + s1_3313_1);
    gl64_t kB3313 = (tmp3_0 + tmp3_2) * (s1_3313_0 + s1_3313_2);
    gl64_t kC3313 = (tmp3_1 + tmp3_2) * (s1_3313_1 + s1_3313_2);
    gl64_t kD3313 = tmp3_0 * s1_3313_0;
    gl64_t kE3313 = tmp3_1 * s1_3313_1;
    gl64_t kF3313 = tmp3_2 * s1_3313_2;
    gl64_t kG3313 = kD3313 - kE3313;
    tmp3_0 = (kC3313 + kG3313) - kF3313;
    tmp3_1 = ((((kA3313 + kC3313) - kE3313) - kE3313) - kD3313);
    tmp3_2 = kB3313 - kG3313;
    // Op 3314: dim1x1 mul
    gl64_t s0_3314 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_0)];
    tmp1_52 = s0_3314 * tmp1_52;
    // Op 3315: dim1x1 sub
    gl64_t s0_3315 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    gl64_t s1_3315 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 21, domainSize, nCols_1))];
    tmp1_2 = s0_3315 - s1_3315;
    // Op 3316: dim1x1 mul
    tmp1_2 = tmp1_52 * tmp1_2;
    // Op 3317: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3318: dim3x3 mul
    gl64_t s1_3318_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3318_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3318_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3318 = (tmp3_0 + tmp3_1) * (s1_3318_0 + s1_3318_1);
    gl64_t kB3318 = (tmp3_0 + tmp3_2) * (s1_3318_0 + s1_3318_2);
    gl64_t kC3318 = (tmp3_1 + tmp3_2) * (s1_3318_1 + s1_3318_2);
    gl64_t kD3318 = tmp3_0 * s1_3318_0;
    gl64_t kE3318 = tmp3_1 * s1_3318_1;
    gl64_t kF3318 = tmp3_2 * s1_3318_2;
    gl64_t kG3318 = kD3318 - kE3318;
    tmp3_0 = (kC3318 + kG3318) - kF3318;
    tmp3_1 = ((((kA3318 + kC3318) - kE3318) - kE3318) - kD3318);
    tmp3_2 = kB3318 - kG3318;
    // Op 3319: dim1x1 mul
    gl64_t s0_3319 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    gl64_t s1_3319 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_23 = s0_3319 * s1_3319;
    // Op 3320: dim1x1 mul
    gl64_t s0_3320 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_0)];
    tmp1_2 = s0_3320 * tmp1_23;
    // Op 3321: dim1x1 sub
    gl64_t s0_3321 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_1))];
    gl64_t s1_3321 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 18, domainSize, nCols_1))];
    tmp1_52 = s0_3321 - s1_3321;
    // Op 3322: dim1x1 mul
    tmp1_2 = tmp1_2 * tmp1_52;
    // Op 3323: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3324: dim3x3 mul
    gl64_t s1_3324_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3324_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3324_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3324 = (tmp3_0 + tmp3_1) * (s1_3324_0 + s1_3324_1);
    gl64_t kB3324 = (tmp3_0 + tmp3_2) * (s1_3324_0 + s1_3324_2);
    gl64_t kC3324 = (tmp3_1 + tmp3_2) * (s1_3324_1 + s1_3324_2);
    gl64_t kD3324 = tmp3_0 * s1_3324_0;
    gl64_t kE3324 = tmp3_1 * s1_3324_1;
    gl64_t kF3324 = tmp3_2 * s1_3324_2;
    gl64_t kG3324 = kD3324 - kE3324;
    tmp3_0 = (kC3324 + kG3324) - kF3324;
    tmp3_1 = ((((kA3324 + kC3324) - kE3324) - kE3324) - kD3324);
    tmp3_2 = kB3324 - kG3324;
    // Op 3325: dim1x1 mul
    gl64_t s0_3325 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_0)];
    tmp1_2 = s0_3325 * tmp1_23;
    // Op 3326: dim1x1 sub
    gl64_t s0_3326 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    gl64_t s1_3326 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 19, domainSize, nCols_1))];
    tmp1_52 = s0_3326 - s1_3326;
    // Op 3327: dim1x1 mul
    tmp1_2 = tmp1_2 * tmp1_52;
    // Op 3328: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3329: dim3x3 mul
    gl64_t s1_3329_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3329_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3329_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3329 = (tmp3_0 + tmp3_1) * (s1_3329_0 + s1_3329_1);
    gl64_t kB3329 = (tmp3_0 + tmp3_2) * (s1_3329_0 + s1_3329_2);
    gl64_t kC3329 = (tmp3_1 + tmp3_2) * (s1_3329_1 + s1_3329_2);
    gl64_t kD3329 = tmp3_0 * s1_3329_0;
    gl64_t kE3329 = tmp3_1 * s1_3329_1;
    gl64_t kF3329 = tmp3_2 * s1_3329_2;
    gl64_t kG3329 = kD3329 - kE3329;
    tmp3_0 = (kC3329 + kG3329) - kF3329;
    tmp3_1 = ((((kA3329 + kC3329) - kE3329) - kE3329) - kD3329);
    tmp3_2 = kB3329 - kG3329;
    // Op 3330: dim1x1 mul
    gl64_t s0_3330 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_0)];
    tmp1_2 = s0_3330 * tmp1_23;
    // Op 3331: dim1x1 sub
    gl64_t s0_3331 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    gl64_t s1_3331 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 20, domainSize, nCols_1))];
    tmp1_52 = s0_3331 - s1_3331;
    // Op 3332: dim1x1 mul
    tmp1_2 = tmp1_2 * tmp1_52;
    // Op 3333: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3334: dim3x3 mul
    gl64_t s1_3334_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3334_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3334_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3334 = (tmp3_0 + tmp3_1) * (s1_3334_0 + s1_3334_1);
    gl64_t kB3334 = (tmp3_0 + tmp3_2) * (s1_3334_0 + s1_3334_2);
    gl64_t kC3334 = (tmp3_1 + tmp3_2) * (s1_3334_1 + s1_3334_2);
    gl64_t kD3334 = tmp3_0 * s1_3334_0;
    gl64_t kE3334 = tmp3_1 * s1_3334_1;
    gl64_t kF3334 = tmp3_2 * s1_3334_2;
    gl64_t kG3334 = kD3334 - kE3334;
    tmp3_0 = (kC3334 + kG3334) - kF3334;
    tmp3_1 = ((((kA3334 + kC3334) - kE3334) - kE3334) - kD3334);
    tmp3_2 = kB3334 - kG3334;
    // Op 3335: dim1x1 mul
    gl64_t s0_3335 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_0)];
    tmp1_23 = s0_3335 * tmp1_23;
    // Op 3336: dim1x1 sub
    gl64_t s0_3336 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    gl64_t s1_3336 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 21, domainSize, nCols_1))];
    tmp1_2 = s0_3336 - s1_3336;
    // Op 3337: dim1x1 mul
    tmp1_2 = tmp1_23 * tmp1_2;
    // Op 3338: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3339: dim3x3 mul
    gl64_t s1_3339_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3339_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3339_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3339 = (tmp3_0 + tmp3_1) * (s1_3339_0 + s1_3339_1);
    gl64_t kB3339 = (tmp3_0 + tmp3_2) * (s1_3339_0 + s1_3339_2);
    gl64_t kC3339 = (tmp3_1 + tmp3_2) * (s1_3339_1 + s1_3339_2);
    gl64_t kD3339 = tmp3_0 * s1_3339_0;
    gl64_t kE3339 = tmp3_1 * s1_3339_1;
    gl64_t kF3339 = tmp3_2 * s1_3339_2;
    gl64_t kG3339 = kD3339 - kE3339;
    tmp3_0 = (kC3339 + kG3339) - kF3339;
    tmp3_1 = ((((kA3339 + kC3339) - kE3339) - kE3339) - kD3339);
    tmp3_2 = kB3339 - kG3339;
    // Op 3340: dim1x1 sub_swap
    gl64_t s0_3340 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    gl64_t s1_3340 = *(gl64_t*)&expressions_params[9][26];
    tmp1_2 = s1_3340 - s0_3340;
    // Op 3341: dim1x1 mul
    gl64_t s0_3341 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp1_2 = s0_3341 * tmp1_2;
    // Op 3342: dim1x1 mul
    gl64_t s0_3342 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_0)];
    tmp1_2 = s0_3342 * tmp1_2;
    // Op 3343: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3344: dim3x3 mul
    gl64_t s1_3344_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3344_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3344_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3344 = (tmp3_0 + tmp3_1) * (s1_3344_0 + s1_3344_1);
    gl64_t kB3344 = (tmp3_0 + tmp3_2) * (s1_3344_0 + s1_3344_2);
    gl64_t kC3344 = (tmp3_1 + tmp3_2) * (s1_3344_1 + s1_3344_2);
    gl64_t kD3344 = tmp3_0 * s1_3344_0;
    gl64_t kE3344 = tmp3_1 * s1_3344_1;
    gl64_t kF3344 = tmp3_2 * s1_3344_2;
    gl64_t kG3344 = kD3344 - kE3344;
    tmp3_0 = (kC3344 + kG3344) - kF3344;
    tmp3_1 = ((((kA3344 + kC3344) - kE3344) - kE3344) - kD3344);
    tmp3_2 = kB3344 - kG3344;
    // Op 3345: dim1x1 sub_swap
    gl64_t s0_3345 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    gl64_t s1_3345 = *(gl64_t*)&expressions_params[9][26];
    tmp1_2 = s1_3345 - s0_3345;
    // Op 3346: dim1x1 mul
    gl64_t s0_3346 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp1_2 = s0_3346 * tmp1_2;
    // Op 3347: dim1x1 mul
    gl64_t s0_3347 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 45, domainSize, nCols_0)];
    tmp1_2 = s0_3347 * tmp1_2;
    // Op 3348: dim3x1 add
    tmp3_0 = tmp3_0 + tmp1_2; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3349: dim3x3 mul
    gl64_t s1_3349_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3349_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3349_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3349 = (tmp3_0 + tmp3_1) * (s1_3349_0 + s1_3349_1);
    gl64_t kB3349 = (tmp3_0 + tmp3_2) * (s1_3349_0 + s1_3349_2);
    gl64_t kC3349 = (tmp3_1 + tmp3_2) * (s1_3349_1 + s1_3349_2);
    gl64_t kD3349 = tmp3_0 * s1_3349_0;
    gl64_t kE3349 = tmp3_1 * s1_3349_1;
    gl64_t kF3349 = tmp3_2 * s1_3349_2;
    gl64_t kG3349 = kD3349 - kE3349;
    tmp3_9 = (kC3349 + kG3349) - kF3349;
    tmp3_10 = ((((kA3349 + kC3349) - kE3349) - kE3349) - kD3349);
    tmp3_11 = kB3349 - kG3349;
    // Op 3350: dim3x1 mul
    gl64_t s0_3350_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3350_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3350_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3350 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    tmp3_0 = s0_3350_0 * s1_3350; tmp3_1 = s0_3350_1 * s1_3350; tmp3_2 = s0_3350_2 * s1_3350;
    // Op 3351: dim3x1 add
    gl64_t s1_3351 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3351; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3352: dim3x3 mul
    gl64_t s1_3352_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3352_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3352_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3352 = (tmp3_0 + tmp3_1) * (s1_3352_0 + s1_3352_1);
    gl64_t kB3352 = (tmp3_0 + tmp3_2) * (s1_3352_0 + s1_3352_2);
    gl64_t kC3352 = (tmp3_1 + tmp3_2) * (s1_3352_1 + s1_3352_2);
    gl64_t kD3352 = tmp3_0 * s1_3352_0;
    gl64_t kE3352 = tmp3_1 * s1_3352_1;
    gl64_t kF3352 = tmp3_2 * s1_3352_2;
    gl64_t kG3352 = kD3352 - kE3352;
    tmp3_0 = (kC3352 + kG3352) - kF3352;
    tmp3_1 = ((((kA3352 + kC3352) - kE3352) - kE3352) - kD3352);
    tmp3_2 = kB3352 - kG3352;
    // Op 3353: dim3x1 add
    gl64_t s1_3353 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3353; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3354: dim3x3 add
    gl64_t s1_3354_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3354_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3354_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3354_0; tmp3_1 = tmp3_1 + s1_3354_1; tmp3_2 = tmp3_2 + s1_3354_2;
    // Op 3355: dim3x1 sub
    gl64_t s1_3355 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3355; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3356: dim3x1 add
    gl64_t s1_3356 = *(gl64_t*)&expressions_params[9][26];
    tmp3_3 = tmp3_0 + s1_3356; tmp3_4 = tmp3_1; tmp3_5 = tmp3_2;
    // Op 3357: dim1x1 mul
    gl64_t s0_3357 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3357 = *(gl64_t*)&expressions_params[9][0];
    tmp1_2 = s0_3357 * s1_3357;
    // Op 3358: dim3x1 mul
    gl64_t s0_3358_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3358_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3358_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3358_0 * tmp1_2; tmp3_1 = s0_3358_1 * tmp1_2; tmp3_2 = s0_3358_2 * tmp1_2;
    // Op 3359: dim3x1 add
    gl64_t s1_3359 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3359; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3360: dim3x3 mul
    gl64_t s1_3360_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3360_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3360_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3360 = (tmp3_0 + tmp3_1) * (s1_3360_0 + s1_3360_1);
    gl64_t kB3360 = (tmp3_0 + tmp3_2) * (s1_3360_0 + s1_3360_2);
    gl64_t kC3360 = (tmp3_1 + tmp3_2) * (s1_3360_1 + s1_3360_2);
    gl64_t kD3360 = tmp3_0 * s1_3360_0;
    gl64_t kE3360 = tmp3_1 * s1_3360_1;
    gl64_t kF3360 = tmp3_2 * s1_3360_2;
    gl64_t kG3360 = kD3360 - kE3360;
    tmp3_0 = (kC3360 + kG3360) - kF3360;
    tmp3_1 = ((((kA3360 + kC3360) - kE3360) - kE3360) - kD3360);
    tmp3_2 = kB3360 - kG3360;
    // Op 3361: dim3x1 add
    gl64_t s1_3361 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3361; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3362: dim3x3 add
    gl64_t s1_3362_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3362_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3362_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3362_0; tmp3_1 = tmp3_1 + s1_3362_1; tmp3_2 = tmp3_2 + s1_3362_2;
    // Op 3363: dim3x1 sub
    gl64_t s1_3363 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3363; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3364: dim3x1 add
    gl64_t s1_3364 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3364; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3365: dim3x3 mul
    gl64_t kA3365 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3365 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3365 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3365 = tmp3_3 * tmp3_0;
    gl64_t kE3365 = tmp3_4 * tmp3_1;
    gl64_t kF3365 = tmp3_5 * tmp3_2;
    gl64_t kG3365 = kD3365 - kE3365;
    tmp3_3 = (kC3365 + kG3365) - kF3365;
    tmp3_4 = ((((kA3365 + kC3365) - kE3365) - kE3365) - kD3365);
    tmp3_5 = kB3365 - kG3365;
    // Op 3366: dim1x1 mul
    gl64_t s0_3366 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3366 = *(gl64_t*)&expressions_params[9][1];
    tmp1_2 = s0_3366 * s1_3366;
    // Op 3367: dim3x1 mul
    gl64_t s0_3367_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3367_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3367_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3367_0 * tmp1_2; tmp3_1 = s0_3367_1 * tmp1_2; tmp3_2 = s0_3367_2 * tmp1_2;
    // Op 3368: dim3x1 add
    gl64_t s1_3368 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3368; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3369: dim3x3 mul
    gl64_t s1_3369_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3369_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3369_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3369 = (tmp3_0 + tmp3_1) * (s1_3369_0 + s1_3369_1);
    gl64_t kB3369 = (tmp3_0 + tmp3_2) * (s1_3369_0 + s1_3369_2);
    gl64_t kC3369 = (tmp3_1 + tmp3_2) * (s1_3369_1 + s1_3369_2);
    gl64_t kD3369 = tmp3_0 * s1_3369_0;
    gl64_t kE3369 = tmp3_1 * s1_3369_1;
    gl64_t kF3369 = tmp3_2 * s1_3369_2;
    gl64_t kG3369 = kD3369 - kE3369;
    tmp3_0 = (kC3369 + kG3369) - kF3369;
    tmp3_1 = ((((kA3369 + kC3369) - kE3369) - kE3369) - kD3369);
    tmp3_2 = kB3369 - kG3369;
    // Op 3370: dim3x1 add
    gl64_t s1_3370 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3370; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3371: dim3x3 add
    gl64_t s1_3371_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3371_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3371_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3371_0; tmp3_1 = tmp3_1 + s1_3371_1; tmp3_2 = tmp3_2 + s1_3371_2;
    // Op 3372: dim3x1 sub
    gl64_t s1_3372 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3372; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3373: dim3x1 add
    gl64_t s1_3373 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3373; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3374: dim3x3 mul
    gl64_t kA3374 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3374 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3374 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3374 = tmp3_3 * tmp3_0;
    gl64_t kE3374 = tmp3_4 * tmp3_1;
    gl64_t kF3374 = tmp3_5 * tmp3_2;
    gl64_t kG3374 = kD3374 - kE3374;
    tmp3_3 = (kC3374 + kG3374) - kF3374;
    tmp3_4 = ((((kA3374 + kC3374) - kE3374) - kE3374) - kD3374);
    tmp3_5 = kB3374 - kG3374;
    // Op 3375: dim1x1 mul
    gl64_t s0_3375 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3375 = *(gl64_t*)&expressions_params[9][2];
    tmp1_2 = s0_3375 * s1_3375;
    // Op 3376: dim3x1 mul
    gl64_t s0_3376_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3376_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3376_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3376_0 * tmp1_2; tmp3_1 = s0_3376_1 * tmp1_2; tmp3_2 = s0_3376_2 * tmp1_2;
    // Op 3377: dim3x1 add
    gl64_t s1_3377 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3377; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3378: dim3x3 mul
    gl64_t s1_3378_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3378_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3378_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3378 = (tmp3_0 + tmp3_1) * (s1_3378_0 + s1_3378_1);
    gl64_t kB3378 = (tmp3_0 + tmp3_2) * (s1_3378_0 + s1_3378_2);
    gl64_t kC3378 = (tmp3_1 + tmp3_2) * (s1_3378_1 + s1_3378_2);
    gl64_t kD3378 = tmp3_0 * s1_3378_0;
    gl64_t kE3378 = tmp3_1 * s1_3378_1;
    gl64_t kF3378 = tmp3_2 * s1_3378_2;
    gl64_t kG3378 = kD3378 - kE3378;
    tmp3_0 = (kC3378 + kG3378) - kF3378;
    tmp3_1 = ((((kA3378 + kC3378) - kE3378) - kE3378) - kD3378);
    tmp3_2 = kB3378 - kG3378;
    // Op 3379: dim3x1 add
    gl64_t s1_3379 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3379; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3380: dim3x3 add
    gl64_t s1_3380_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3380_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3380_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3380_0; tmp3_1 = tmp3_1 + s1_3380_1; tmp3_2 = tmp3_2 + s1_3380_2;
    // Op 3381: dim3x1 sub
    gl64_t s1_3381 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3381; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3382: dim3x1 add
    gl64_t s1_3382 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3382; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3383: dim3x3 mul
    gl64_t kA3383 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3383 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3383 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3383 = tmp3_3 * tmp3_0;
    gl64_t kE3383 = tmp3_4 * tmp3_1;
    gl64_t kF3383 = tmp3_5 * tmp3_2;
    gl64_t kG3383 = kD3383 - kE3383;
    tmp3_3 = (kC3383 + kG3383) - kF3383;
    tmp3_4 = ((((kA3383 + kC3383) - kE3383) - kE3383) - kD3383);
    tmp3_5 = kB3383 - kG3383;
    // Op 3384: dim1x1 mul
    gl64_t s0_3384 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3384 = *(gl64_t*)&expressions_params[9][3];
    tmp1_2 = s0_3384 * s1_3384;
    // Op 3385: dim3x1 mul
    gl64_t s0_3385_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3385_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3385_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3385_0 * tmp1_2; tmp3_1 = s0_3385_1 * tmp1_2; tmp3_2 = s0_3385_2 * tmp1_2;
    // Op 3386: dim3x1 add
    gl64_t s1_3386 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3386; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3387: dim3x3 mul
    gl64_t s1_3387_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3387_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3387_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3387 = (tmp3_0 + tmp3_1) * (s1_3387_0 + s1_3387_1);
    gl64_t kB3387 = (tmp3_0 + tmp3_2) * (s1_3387_0 + s1_3387_2);
    gl64_t kC3387 = (tmp3_1 + tmp3_2) * (s1_3387_1 + s1_3387_2);
    gl64_t kD3387 = tmp3_0 * s1_3387_0;
    gl64_t kE3387 = tmp3_1 * s1_3387_1;
    gl64_t kF3387 = tmp3_2 * s1_3387_2;
    gl64_t kG3387 = kD3387 - kE3387;
    tmp3_0 = (kC3387 + kG3387) - kF3387;
    tmp3_1 = ((((kA3387 + kC3387) - kE3387) - kE3387) - kD3387);
    tmp3_2 = kB3387 - kG3387;
    // Op 3388: dim3x1 add
    gl64_t s1_3388 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3388; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3389: dim3x3 add
    gl64_t s1_3389_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3389_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3389_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3389_0; tmp3_1 = tmp3_1 + s1_3389_1; tmp3_2 = tmp3_2 + s1_3389_2;
    // Op 3390: dim3x1 sub
    gl64_t s1_3390 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3390; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3391: dim3x1 add
    gl64_t s1_3391 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3391; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3392: dim3x3 mul
    gl64_t kA3392 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3392 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3392 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3392 = tmp3_3 * tmp3_0;
    gl64_t kE3392 = tmp3_4 * tmp3_1;
    gl64_t kF3392 = tmp3_5 * tmp3_2;
    gl64_t kG3392 = kD3392 - kE3392;
    tmp3_3 = (kC3392 + kG3392) - kF3392;
    tmp3_4 = ((((kA3392 + kC3392) - kE3392) - kE3392) - kD3392);
    tmp3_5 = kB3392 - kG3392;
    // Op 3393: dim1x1 mul
    gl64_t s0_3393 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3393 = *(gl64_t*)&expressions_params[9][4];
    tmp1_2 = s0_3393 * s1_3393;
    // Op 3394: dim3x1 mul
    gl64_t s0_3394_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3394_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3394_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3394_0 * tmp1_2; tmp3_1 = s0_3394_1 * tmp1_2; tmp3_2 = s0_3394_2 * tmp1_2;
    // Op 3395: dim3x1 add
    gl64_t s1_3395 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3395; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3396: dim3x3 mul
    gl64_t s1_3396_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3396_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3396_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3396 = (tmp3_0 + tmp3_1) * (s1_3396_0 + s1_3396_1);
    gl64_t kB3396 = (tmp3_0 + tmp3_2) * (s1_3396_0 + s1_3396_2);
    gl64_t kC3396 = (tmp3_1 + tmp3_2) * (s1_3396_1 + s1_3396_2);
    gl64_t kD3396 = tmp3_0 * s1_3396_0;
    gl64_t kE3396 = tmp3_1 * s1_3396_1;
    gl64_t kF3396 = tmp3_2 * s1_3396_2;
    gl64_t kG3396 = kD3396 - kE3396;
    tmp3_0 = (kC3396 + kG3396) - kF3396;
    tmp3_1 = ((((kA3396 + kC3396) - kE3396) - kE3396) - kD3396);
    tmp3_2 = kB3396 - kG3396;
    // Op 3397: dim3x1 add
    gl64_t s1_3397 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3397; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3398: dim3x3 add
    gl64_t s1_3398_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3398_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3398_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3398_0; tmp3_1 = tmp3_1 + s1_3398_1; tmp3_2 = tmp3_2 + s1_3398_2;
    // Op 3399: dim3x1 sub
    gl64_t s1_3399 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3399; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3400: dim3x1 add
    gl64_t s1_3400 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3400; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3401: dim3x3 mul
    gl64_t kA3401 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3401 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3401 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3401 = tmp3_3 * tmp3_0;
    gl64_t kE3401 = tmp3_4 * tmp3_1;
    gl64_t kF3401 = tmp3_5 * tmp3_2;
    gl64_t kG3401 = kD3401 - kE3401;
    tmp3_3 = (kC3401 + kG3401) - kF3401;
    tmp3_4 = ((((kA3401 + kC3401) - kE3401) - kE3401) - kD3401);
    tmp3_5 = kB3401 - kG3401;
    // Op 3402: dim1x1 mul
    gl64_t s0_3402 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3402 = *(gl64_t*)&expressions_params[9][5];
    tmp1_2 = s0_3402 * s1_3402;
    // Op 3403: dim3x1 mul
    gl64_t s0_3403_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3403_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3403_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3403_0 * tmp1_2; tmp3_1 = s0_3403_1 * tmp1_2; tmp3_2 = s0_3403_2 * tmp1_2;
    // Op 3404: dim3x1 add
    gl64_t s1_3404 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 6, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3404; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3405: dim3x3 mul
    gl64_t s1_3405_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3405_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3405_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3405 = (tmp3_0 + tmp3_1) * (s1_3405_0 + s1_3405_1);
    gl64_t kB3405 = (tmp3_0 + tmp3_2) * (s1_3405_0 + s1_3405_2);
    gl64_t kC3405 = (tmp3_1 + tmp3_2) * (s1_3405_1 + s1_3405_2);
    gl64_t kD3405 = tmp3_0 * s1_3405_0;
    gl64_t kE3405 = tmp3_1 * s1_3405_1;
    gl64_t kF3405 = tmp3_2 * s1_3405_2;
    gl64_t kG3405 = kD3405 - kE3405;
    tmp3_0 = (kC3405 + kG3405) - kF3405;
    tmp3_1 = ((((kA3405 + kC3405) - kE3405) - kE3405) - kD3405);
    tmp3_2 = kB3405 - kG3405;
    // Op 3406: dim3x1 add
    gl64_t s1_3406 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3406; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3407: dim3x3 add
    gl64_t s1_3407_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3407_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3407_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3407_0; tmp3_1 = tmp3_1 + s1_3407_1; tmp3_2 = tmp3_2 + s1_3407_2;
    // Op 3408: dim3x1 sub
    gl64_t s1_3408 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3408; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3409: dim3x1 add
    gl64_t s1_3409 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3409; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3410: dim3x3 mul
    gl64_t kA3410 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3410 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3410 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3410 = tmp3_3 * tmp3_0;
    gl64_t kE3410 = tmp3_4 * tmp3_1;
    gl64_t kF3410 = tmp3_5 * tmp3_2;
    gl64_t kG3410 = kD3410 - kE3410;
    tmp3_0 = (kC3410 + kG3410) - kF3410;
    tmp3_1 = ((((kA3410 + kC3410) - kE3410) - kE3410) - kD3410);
    tmp3_2 = kB3410 - kG3410;
    // Op 3411: dim3x3 mul
    gl64_t s0_3411_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_2, 3+0, domainSize, nCols_2))];
    gl64_t s0_3411_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_2, 3+1, domainSize, nCols_2))];
    gl64_t s0_3411_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_2, 3+2, domainSize, nCols_2))];
    gl64_t kA3411 = (s0_3411_0 + s0_3411_1) * (tmp3_0 + tmp3_1);
    gl64_t kB3411 = (s0_3411_0 + s0_3411_2) * (tmp3_0 + tmp3_2);
    gl64_t kC3411 = (s0_3411_1 + s0_3411_2) * (tmp3_1 + tmp3_2);
    gl64_t kD3411 = s0_3411_0 * tmp3_0;
    gl64_t kE3411 = s0_3411_1 * tmp3_1;
    gl64_t kF3411 = s0_3411_2 * tmp3_2;
    gl64_t kG3411 = kD3411 - kE3411;
    tmp3_6 = (kC3411 + kG3411) - kF3411;
    tmp3_7 = ((((kA3411 + kC3411) - kE3411) - kE3411) - kD3411);
    tmp3_8 = kB3411 - kG3411;
    // Op 3412: dim3x1 mul
    gl64_t s0_3412_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3412_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3412_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3412 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_0)];
    tmp3_0 = s0_3412_0 * s1_3412; tmp3_1 = s0_3412_1 * s1_3412; tmp3_2 = s0_3412_2 * s1_3412;
    // Op 3413: dim3x1 add
    gl64_t s1_3413 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3413; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3414: dim3x3 mul
    gl64_t s1_3414_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3414_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3414_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3414 = (tmp3_0 + tmp3_1) * (s1_3414_0 + s1_3414_1);
    gl64_t kB3414 = (tmp3_0 + tmp3_2) * (s1_3414_0 + s1_3414_2);
    gl64_t kC3414 = (tmp3_1 + tmp3_2) * (s1_3414_1 + s1_3414_2);
    gl64_t kD3414 = tmp3_0 * s1_3414_0;
    gl64_t kE3414 = tmp3_1 * s1_3414_1;
    gl64_t kF3414 = tmp3_2 * s1_3414_2;
    gl64_t kG3414 = kD3414 - kE3414;
    tmp3_0 = (kC3414 + kG3414) - kF3414;
    tmp3_1 = ((((kA3414 + kC3414) - kE3414) - kE3414) - kD3414);
    tmp3_2 = kB3414 - kG3414;
    // Op 3415: dim3x1 add
    gl64_t s1_3415 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3415; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3416: dim3x3 add
    gl64_t s1_3416_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3416_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3416_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3416_0; tmp3_1 = tmp3_1 + s1_3416_1; tmp3_2 = tmp3_2 + s1_3416_2;
    // Op 3417: dim3x1 sub
    gl64_t s1_3417 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3417; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3418: dim3x1 add
    gl64_t s1_3418 = *(gl64_t*)&expressions_params[9][26];
    tmp3_3 = tmp3_0 + s1_3418; tmp3_4 = tmp3_1; tmp3_5 = tmp3_2;
    // Op 3419: dim3x1 mul
    gl64_t s0_3419_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3419_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3419_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3419 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_0)];
    tmp3_0 = s0_3419_0 * s1_3419; tmp3_1 = s0_3419_1 * s1_3419; tmp3_2 = s0_3419_2 * s1_3419;
    // Op 3420: dim3x1 add
    gl64_t s1_3420 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 1, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3420; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3421: dim3x3 mul
    gl64_t s1_3421_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3421_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3421_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3421 = (tmp3_0 + tmp3_1) * (s1_3421_0 + s1_3421_1);
    gl64_t kB3421 = (tmp3_0 + tmp3_2) * (s1_3421_0 + s1_3421_2);
    gl64_t kC3421 = (tmp3_1 + tmp3_2) * (s1_3421_1 + s1_3421_2);
    gl64_t kD3421 = tmp3_0 * s1_3421_0;
    gl64_t kE3421 = tmp3_1 * s1_3421_1;
    gl64_t kF3421 = tmp3_2 * s1_3421_2;
    gl64_t kG3421 = kD3421 - kE3421;
    tmp3_0 = (kC3421 + kG3421) - kF3421;
    tmp3_1 = ((((kA3421 + kC3421) - kE3421) - kE3421) - kD3421);
    tmp3_2 = kB3421 - kG3421;
    // Op 3422: dim3x1 add
    gl64_t s1_3422 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3422; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3423: dim3x3 add
    gl64_t s1_3423_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3423_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3423_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3423_0; tmp3_1 = tmp3_1 + s1_3423_1; tmp3_2 = tmp3_2 + s1_3423_2;
    // Op 3424: dim3x1 sub
    gl64_t s1_3424 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3424; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3425: dim3x1 add
    gl64_t s1_3425 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3425; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3426: dim3x3 mul
    gl64_t kA3426 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3426 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3426 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3426 = tmp3_3 * tmp3_0;
    gl64_t kE3426 = tmp3_4 * tmp3_1;
    gl64_t kF3426 = tmp3_5 * tmp3_2;
    gl64_t kG3426 = kD3426 - kE3426;
    tmp3_3 = (kC3426 + kG3426) - kF3426;
    tmp3_4 = ((((kA3426 + kC3426) - kE3426) - kE3426) - kD3426);
    tmp3_5 = kB3426 - kG3426;
    // Op 3427: dim3x1 mul
    gl64_t s0_3427_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3427_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3427_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3427 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_0)];
    tmp3_0 = s0_3427_0 * s1_3427; tmp3_1 = s0_3427_1 * s1_3427; tmp3_2 = s0_3427_2 * s1_3427;
    // Op 3428: dim3x1 add
    gl64_t s1_3428 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 2, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3428; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3429: dim3x3 mul
    gl64_t s1_3429_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3429_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3429_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3429 = (tmp3_0 + tmp3_1) * (s1_3429_0 + s1_3429_1);
    gl64_t kB3429 = (tmp3_0 + tmp3_2) * (s1_3429_0 + s1_3429_2);
    gl64_t kC3429 = (tmp3_1 + tmp3_2) * (s1_3429_1 + s1_3429_2);
    gl64_t kD3429 = tmp3_0 * s1_3429_0;
    gl64_t kE3429 = tmp3_1 * s1_3429_1;
    gl64_t kF3429 = tmp3_2 * s1_3429_2;
    gl64_t kG3429 = kD3429 - kE3429;
    tmp3_0 = (kC3429 + kG3429) - kF3429;
    tmp3_1 = ((((kA3429 + kC3429) - kE3429) - kE3429) - kD3429);
    tmp3_2 = kB3429 - kG3429;
    // Op 3430: dim3x1 add
    gl64_t s1_3430 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3430; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3431: dim3x3 add
    gl64_t s1_3431_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3431_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3431_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3431_0; tmp3_1 = tmp3_1 + s1_3431_1; tmp3_2 = tmp3_2 + s1_3431_2;
    // Op 3432: dim3x1 sub
    gl64_t s1_3432 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3432; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3433: dim3x1 add
    gl64_t s1_3433 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3433; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3434: dim3x3 mul
    gl64_t kA3434 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3434 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3434 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3434 = tmp3_3 * tmp3_0;
    gl64_t kE3434 = tmp3_4 * tmp3_1;
    gl64_t kF3434 = tmp3_5 * tmp3_2;
    gl64_t kG3434 = kD3434 - kE3434;
    tmp3_3 = (kC3434 + kG3434) - kF3434;
    tmp3_4 = ((((kA3434 + kC3434) - kE3434) - kE3434) - kD3434);
    tmp3_5 = kB3434 - kG3434;
    // Op 3435: dim3x1 mul
    gl64_t s0_3435_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3435_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3435_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3435 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_0)];
    tmp3_0 = s0_3435_0 * s1_3435; tmp3_1 = s0_3435_1 * s1_3435; tmp3_2 = s0_3435_2 * s1_3435;
    // Op 3436: dim3x1 add
    gl64_t s1_3436 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 3, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3436; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3437: dim3x3 mul
    gl64_t s1_3437_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3437_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3437_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3437 = (tmp3_0 + tmp3_1) * (s1_3437_0 + s1_3437_1);
    gl64_t kB3437 = (tmp3_0 + tmp3_2) * (s1_3437_0 + s1_3437_2);
    gl64_t kC3437 = (tmp3_1 + tmp3_2) * (s1_3437_1 + s1_3437_2);
    gl64_t kD3437 = tmp3_0 * s1_3437_0;
    gl64_t kE3437 = tmp3_1 * s1_3437_1;
    gl64_t kF3437 = tmp3_2 * s1_3437_2;
    gl64_t kG3437 = kD3437 - kE3437;
    tmp3_0 = (kC3437 + kG3437) - kF3437;
    tmp3_1 = ((((kA3437 + kC3437) - kE3437) - kE3437) - kD3437);
    tmp3_2 = kB3437 - kG3437;
    // Op 3438: dim3x1 add
    gl64_t s1_3438 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3438; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3439: dim3x3 add
    gl64_t s1_3439_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3439_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3439_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3439_0; tmp3_1 = tmp3_1 + s1_3439_1; tmp3_2 = tmp3_2 + s1_3439_2;
    // Op 3440: dim3x1 sub
    gl64_t s1_3440 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3440; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3441: dim3x1 add
    gl64_t s1_3441 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3441; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3442: dim3x3 mul
    gl64_t kA3442 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3442 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3442 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3442 = tmp3_3 * tmp3_0;
    gl64_t kE3442 = tmp3_4 * tmp3_1;
    gl64_t kF3442 = tmp3_5 * tmp3_2;
    gl64_t kG3442 = kD3442 - kE3442;
    tmp3_3 = (kC3442 + kG3442) - kF3442;
    tmp3_4 = ((((kA3442 + kC3442) - kE3442) - kE3442) - kD3442);
    tmp3_5 = kB3442 - kG3442;
    // Op 3443: dim3x1 mul
    gl64_t s0_3443_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3443_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3443_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3443 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_0)];
    tmp3_0 = s0_3443_0 * s1_3443; tmp3_1 = s0_3443_1 * s1_3443; tmp3_2 = s0_3443_2 * s1_3443;
    // Op 3444: dim3x1 add
    gl64_t s1_3444 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 4, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3444; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3445: dim3x3 mul
    gl64_t s1_3445_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3445_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3445_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3445 = (tmp3_0 + tmp3_1) * (s1_3445_0 + s1_3445_1);
    gl64_t kB3445 = (tmp3_0 + tmp3_2) * (s1_3445_0 + s1_3445_2);
    gl64_t kC3445 = (tmp3_1 + tmp3_2) * (s1_3445_1 + s1_3445_2);
    gl64_t kD3445 = tmp3_0 * s1_3445_0;
    gl64_t kE3445 = tmp3_1 * s1_3445_1;
    gl64_t kF3445 = tmp3_2 * s1_3445_2;
    gl64_t kG3445 = kD3445 - kE3445;
    tmp3_0 = (kC3445 + kG3445) - kF3445;
    tmp3_1 = ((((kA3445 + kC3445) - kE3445) - kE3445) - kD3445);
    tmp3_2 = kB3445 - kG3445;
    // Op 3446: dim3x1 add
    gl64_t s1_3446 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3446; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3447: dim3x3 add
    gl64_t s1_3447_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3447_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3447_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3447_0; tmp3_1 = tmp3_1 + s1_3447_1; tmp3_2 = tmp3_2 + s1_3447_2;
    // Op 3448: dim3x1 sub
    gl64_t s1_3448 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3448; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3449: dim3x1 add
    gl64_t s1_3449 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3449; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3450: dim3x3 mul
    gl64_t kA3450 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3450 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3450 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3450 = tmp3_3 * tmp3_0;
    gl64_t kE3450 = tmp3_4 * tmp3_1;
    gl64_t kF3450 = tmp3_5 * tmp3_2;
    gl64_t kG3450 = kD3450 - kE3450;
    tmp3_3 = (kC3450 + kG3450) - kF3450;
    tmp3_4 = ((((kA3450 + kC3450) - kE3450) - kE3450) - kD3450);
    tmp3_5 = kB3450 - kG3450;
    // Op 3451: dim3x1 mul
    gl64_t s0_3451_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3451_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3451_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3451 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_0)];
    tmp3_0 = s0_3451_0 * s1_3451; tmp3_1 = s0_3451_1 * s1_3451; tmp3_2 = s0_3451_2 * s1_3451;
    // Op 3452: dim3x1 add
    gl64_t s1_3452 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 5, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3452; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3453: dim3x3 mul
    gl64_t s1_3453_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3453_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3453_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3453 = (tmp3_0 + tmp3_1) * (s1_3453_0 + s1_3453_1);
    gl64_t kB3453 = (tmp3_0 + tmp3_2) * (s1_3453_0 + s1_3453_2);
    gl64_t kC3453 = (tmp3_1 + tmp3_2) * (s1_3453_1 + s1_3453_2);
    gl64_t kD3453 = tmp3_0 * s1_3453_0;
    gl64_t kE3453 = tmp3_1 * s1_3453_1;
    gl64_t kF3453 = tmp3_2 * s1_3453_2;
    gl64_t kG3453 = kD3453 - kE3453;
    tmp3_0 = (kC3453 + kG3453) - kF3453;
    tmp3_1 = ((((kA3453 + kC3453) - kE3453) - kE3453) - kD3453);
    tmp3_2 = kB3453 - kG3453;
    // Op 3454: dim3x1 add
    gl64_t s1_3454 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3454; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3455: dim3x3 add
    gl64_t s1_3455_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3455_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3455_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3455_0; tmp3_1 = tmp3_1 + s1_3455_1; tmp3_2 = tmp3_2 + s1_3455_2;
    // Op 3456: dim3x1 sub
    gl64_t s1_3456 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3456; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3457: dim3x1 add
    gl64_t s1_3457 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3457; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3458: dim3x3 mul
    gl64_t kA3458 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3458 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3458 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3458 = tmp3_3 * tmp3_0;
    gl64_t kE3458 = tmp3_4 * tmp3_1;
    gl64_t kF3458 = tmp3_5 * tmp3_2;
    gl64_t kG3458 = kD3458 - kE3458;
    tmp3_3 = (kC3458 + kG3458) - kF3458;
    tmp3_4 = ((((kA3458 + kC3458) - kE3458) - kE3458) - kD3458);
    tmp3_5 = kB3458 - kG3458;
    // Op 3459: dim3x1 mul
    gl64_t s0_3459_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3459_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3459_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3459 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 6, domainSize, nCols_0)];
    tmp3_0 = s0_3459_0 * s1_3459; tmp3_1 = s0_3459_1 * s1_3459; tmp3_2 = s0_3459_2 * s1_3459;
    // Op 3460: dim3x1 add
    gl64_t s1_3460 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 6, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3460; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3461: dim3x3 mul
    gl64_t s1_3461_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3461_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3461_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3461 = (tmp3_0 + tmp3_1) * (s1_3461_0 + s1_3461_1);
    gl64_t kB3461 = (tmp3_0 + tmp3_2) * (s1_3461_0 + s1_3461_2);
    gl64_t kC3461 = (tmp3_1 + tmp3_2) * (s1_3461_1 + s1_3461_2);
    gl64_t kD3461 = tmp3_0 * s1_3461_0;
    gl64_t kE3461 = tmp3_1 * s1_3461_1;
    gl64_t kF3461 = tmp3_2 * s1_3461_2;
    gl64_t kG3461 = kD3461 - kE3461;
    tmp3_0 = (kC3461 + kG3461) - kF3461;
    tmp3_1 = ((((kA3461 + kC3461) - kE3461) - kE3461) - kD3461);
    tmp3_2 = kB3461 - kG3461;
    // Op 3462: dim3x1 add
    gl64_t s1_3462 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3462; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3463: dim3x3 add
    gl64_t s1_3463_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3463_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3463_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3463_0; tmp3_1 = tmp3_1 + s1_3463_1; tmp3_2 = tmp3_2 + s1_3463_2;
    // Op 3464: dim3x1 sub
    gl64_t s1_3464 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3464; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3465: dim3x1 add
    gl64_t s1_3465 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3465; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3466: dim3x3 mul
    gl64_t kA3466 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3466 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3466 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3466 = tmp3_3 * tmp3_0;
    gl64_t kE3466 = tmp3_4 * tmp3_1;
    gl64_t kF3466 = tmp3_5 * tmp3_2;
    gl64_t kG3466 = kD3466 - kE3466;
    tmp3_3 = (kC3466 + kG3466) - kF3466;
    tmp3_4 = ((((kA3466 + kC3466) - kE3466) - kE3466) - kD3466);
    tmp3_5 = kB3466 - kG3466;
    // Op 3467: dim3x1 mul
    gl64_t s0_3467_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3467_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3467_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3467 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_0)];
    tmp3_0 = s0_3467_0 * s1_3467; tmp3_1 = s0_3467_1 * s1_3467; tmp3_2 = s0_3467_2 * s1_3467;
    // Op 3468: dim3x1 add
    gl64_t s1_3468 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3468; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3469: dim3x3 mul
    gl64_t s1_3469_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3469_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3469_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3469 = (tmp3_0 + tmp3_1) * (s1_3469_0 + s1_3469_1);
    gl64_t kB3469 = (tmp3_0 + tmp3_2) * (s1_3469_0 + s1_3469_2);
    gl64_t kC3469 = (tmp3_1 + tmp3_2) * (s1_3469_1 + s1_3469_2);
    gl64_t kD3469 = tmp3_0 * s1_3469_0;
    gl64_t kE3469 = tmp3_1 * s1_3469_1;
    gl64_t kF3469 = tmp3_2 * s1_3469_2;
    gl64_t kG3469 = kD3469 - kE3469;
    tmp3_0 = (kC3469 + kG3469) - kF3469;
    tmp3_1 = ((((kA3469 + kC3469) - kE3469) - kE3469) - kD3469);
    tmp3_2 = kB3469 - kG3469;
    // Op 3470: dim3x1 add
    gl64_t s1_3470 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3470; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3471: dim3x3 add
    gl64_t s1_3471_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3471_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3471_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3471_0; tmp3_1 = tmp3_1 + s1_3471_1; tmp3_2 = tmp3_2 + s1_3471_2;
    // Op 3472: dim3x1 sub
    gl64_t s1_3472 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3472; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3473: dim3x1 add
    gl64_t s1_3473 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3473; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3474: dim3x3 mul
    gl64_t kA3474 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3474 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3474 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3474 = tmp3_3 * tmp3_0;
    gl64_t kE3474 = tmp3_4 * tmp3_1;
    gl64_t kF3474 = tmp3_5 * tmp3_2;
    gl64_t kG3474 = kD3474 - kE3474;
    tmp3_0 = (kC3474 + kG3474) - kF3474;
    tmp3_1 = ((((kA3474 + kC3474) - kE3474) - kE3474) - kD3474);
    tmp3_2 = kB3474 - kG3474;
    // Op 3475: dim3x3 sub
    tmp3_0 = tmp3_6 - tmp3_0; tmp3_1 = tmp3_7 - tmp3_1; tmp3_2 = tmp3_8 - tmp3_2;
    // Op 3476: dim3x3 add
    tmp3_0 = tmp3_9 + tmp3_0; tmp3_1 = tmp3_10 + tmp3_1; tmp3_2 = tmp3_11 + tmp3_2;
    // Op 3477: dim3x3 mul
    gl64_t s1_3477_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3477_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3477_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3477 = (tmp3_0 + tmp3_1) * (s1_3477_0 + s1_3477_1);
    gl64_t kB3477 = (tmp3_0 + tmp3_2) * (s1_3477_0 + s1_3477_2);
    gl64_t kC3477 = (tmp3_1 + tmp3_2) * (s1_3477_1 + s1_3477_2);
    gl64_t kD3477 = tmp3_0 * s1_3477_0;
    gl64_t kE3477 = tmp3_1 * s1_3477_1;
    gl64_t kF3477 = tmp3_2 * s1_3477_2;
    gl64_t kG3477 = kD3477 - kE3477;
    tmp3_3 = (kC3477 + kG3477) - kF3477;
    tmp3_4 = ((((kA3477 + kC3477) - kE3477) - kE3477) - kD3477);
    tmp3_5 = kB3477 - kG3477;
    // Op 3478: dim1x1 mul
    gl64_t s0_3478 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3478 = *(gl64_t*)&expressions_params[9][6];
    tmp1_2 = s0_3478 * s1_3478;
    // Op 3479: dim3x1 mul
    gl64_t s0_3479_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3479_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3479_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3479_0 * tmp1_2; tmp3_1 = s0_3479_1 * tmp1_2; tmp3_2 = s0_3479_2 * tmp1_2;
    // Op 3480: dim3x1 add
    gl64_t s1_3480 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 7, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3480; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3481: dim3x3 mul
    gl64_t s1_3481_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3481_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3481_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3481 = (tmp3_0 + tmp3_1) * (s1_3481_0 + s1_3481_1);
    gl64_t kB3481 = (tmp3_0 + tmp3_2) * (s1_3481_0 + s1_3481_2);
    gl64_t kC3481 = (tmp3_1 + tmp3_2) * (s1_3481_1 + s1_3481_2);
    gl64_t kD3481 = tmp3_0 * s1_3481_0;
    gl64_t kE3481 = tmp3_1 * s1_3481_1;
    gl64_t kF3481 = tmp3_2 * s1_3481_2;
    gl64_t kG3481 = kD3481 - kE3481;
    tmp3_0 = (kC3481 + kG3481) - kF3481;
    tmp3_1 = ((((kA3481 + kC3481) - kE3481) - kE3481) - kD3481);
    tmp3_2 = kB3481 - kG3481;
    // Op 3482: dim3x1 add
    gl64_t s1_3482 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3482; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3483: dim3x3 add
    gl64_t s1_3483_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3483_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3483_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3483_0; tmp3_1 = tmp3_1 + s1_3483_1; tmp3_2 = tmp3_2 + s1_3483_2;
    // Op 3484: dim3x1 sub
    gl64_t s1_3484 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3484; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3485: dim3x1 add
    gl64_t s1_3485 = *(gl64_t*)&expressions_params[9][26];
    tmp3_9 = tmp3_0 + s1_3485; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 3486: dim1x1 mul
    gl64_t s0_3486 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3486 = *(gl64_t*)&expressions_params[9][7];
    tmp1_2 = s0_3486 * s1_3486;
    // Op 3487: dim3x1 mul
    gl64_t s0_3487_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3487_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3487_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3487_0 * tmp1_2; tmp3_1 = s0_3487_1 * tmp1_2; tmp3_2 = s0_3487_2 * tmp1_2;
    // Op 3488: dim3x1 add
    gl64_t s1_3488 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 8, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3488; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3489: dim3x3 mul
    gl64_t s1_3489_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3489_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3489_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3489 = (tmp3_0 + tmp3_1) * (s1_3489_0 + s1_3489_1);
    gl64_t kB3489 = (tmp3_0 + tmp3_2) * (s1_3489_0 + s1_3489_2);
    gl64_t kC3489 = (tmp3_1 + tmp3_2) * (s1_3489_1 + s1_3489_2);
    gl64_t kD3489 = tmp3_0 * s1_3489_0;
    gl64_t kE3489 = tmp3_1 * s1_3489_1;
    gl64_t kF3489 = tmp3_2 * s1_3489_2;
    gl64_t kG3489 = kD3489 - kE3489;
    tmp3_0 = (kC3489 + kG3489) - kF3489;
    tmp3_1 = ((((kA3489 + kC3489) - kE3489) - kE3489) - kD3489);
    tmp3_2 = kB3489 - kG3489;
    // Op 3490: dim3x1 add
    gl64_t s1_3490 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3490; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3491: dim3x3 add
    gl64_t s1_3491_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3491_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3491_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3491_0; tmp3_1 = tmp3_1 + s1_3491_1; tmp3_2 = tmp3_2 + s1_3491_2;
    // Op 3492: dim3x1 sub
    gl64_t s1_3492 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3492; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3493: dim3x1 add
    gl64_t s1_3493 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3493; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3494: dim3x3 mul
    gl64_t kA3494 = (tmp3_9 + tmp3_10) * (tmp3_0 + tmp3_1);
    gl64_t kB3494 = (tmp3_9 + tmp3_11) * (tmp3_0 + tmp3_2);
    gl64_t kC3494 = (tmp3_10 + tmp3_11) * (tmp3_1 + tmp3_2);
    gl64_t kD3494 = tmp3_9 * tmp3_0;
    gl64_t kE3494 = tmp3_10 * tmp3_1;
    gl64_t kF3494 = tmp3_11 * tmp3_2;
    gl64_t kG3494 = kD3494 - kE3494;
    tmp3_9 = (kC3494 + kG3494) - kF3494;
    tmp3_10 = ((((kA3494 + kC3494) - kE3494) - kE3494) - kD3494);
    tmp3_11 = kB3494 - kG3494;
    // Op 3495: dim1x1 mul
    gl64_t s0_3495 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3495 = *(gl64_t*)&expressions_params[9][8];
    tmp1_2 = s0_3495 * s1_3495;
    // Op 3496: dim3x1 mul
    gl64_t s0_3496_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3496_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3496_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3496_0 * tmp1_2; tmp3_1 = s0_3496_1 * tmp1_2; tmp3_2 = s0_3496_2 * tmp1_2;
    // Op 3497: dim3x1 add
    gl64_t s1_3497 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3497; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3498: dim3x3 mul
    gl64_t s1_3498_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3498_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3498_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3498 = (tmp3_0 + tmp3_1) * (s1_3498_0 + s1_3498_1);
    gl64_t kB3498 = (tmp3_0 + tmp3_2) * (s1_3498_0 + s1_3498_2);
    gl64_t kC3498 = (tmp3_1 + tmp3_2) * (s1_3498_1 + s1_3498_2);
    gl64_t kD3498 = tmp3_0 * s1_3498_0;
    gl64_t kE3498 = tmp3_1 * s1_3498_1;
    gl64_t kF3498 = tmp3_2 * s1_3498_2;
    gl64_t kG3498 = kD3498 - kE3498;
    tmp3_0 = (kC3498 + kG3498) - kF3498;
    tmp3_1 = ((((kA3498 + kC3498) - kE3498) - kE3498) - kD3498);
    tmp3_2 = kB3498 - kG3498;
    // Op 3499: dim3x1 add
    gl64_t s1_3499 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3499; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3500: dim3x3 add
    gl64_t s1_3500_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3500_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3500_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3500_0; tmp3_1 = tmp3_1 + s1_3500_1; tmp3_2 = tmp3_2 + s1_3500_2;
    // Op 3501: dim3x1 sub
    gl64_t s1_3501 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3501; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3502: dim3x1 add
    gl64_t s1_3502 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3502; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3503: dim3x3 mul
    gl64_t kA3503 = (tmp3_9 + tmp3_10) * (tmp3_0 + tmp3_1);
    gl64_t kB3503 = (tmp3_9 + tmp3_11) * (tmp3_0 + tmp3_2);
    gl64_t kC3503 = (tmp3_10 + tmp3_11) * (tmp3_1 + tmp3_2);
    gl64_t kD3503 = tmp3_9 * tmp3_0;
    gl64_t kE3503 = tmp3_10 * tmp3_1;
    gl64_t kF3503 = tmp3_11 * tmp3_2;
    gl64_t kG3503 = kD3503 - kE3503;
    tmp3_9 = (kC3503 + kG3503) - kF3503;
    tmp3_10 = ((((kA3503 + kC3503) - kE3503) - kE3503) - kD3503);
    tmp3_11 = kB3503 - kG3503;
    // Op 3504: dim1x1 mul
    gl64_t s0_3504 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3504 = *(gl64_t*)&expressions_params[9][9];
    tmp1_2 = s0_3504 * s1_3504;
    // Op 3505: dim3x1 mul
    gl64_t s0_3505_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3505_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3505_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3505_0 * tmp1_2; tmp3_1 = s0_3505_1 * tmp1_2; tmp3_2 = s0_3505_2 * tmp1_2;
    // Op 3506: dim3x1 add
    gl64_t s1_3506 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 10, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3506; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3507: dim3x3 mul
    gl64_t s1_3507_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3507_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3507_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3507 = (tmp3_0 + tmp3_1) * (s1_3507_0 + s1_3507_1);
    gl64_t kB3507 = (tmp3_0 + tmp3_2) * (s1_3507_0 + s1_3507_2);
    gl64_t kC3507 = (tmp3_1 + tmp3_2) * (s1_3507_1 + s1_3507_2);
    gl64_t kD3507 = tmp3_0 * s1_3507_0;
    gl64_t kE3507 = tmp3_1 * s1_3507_1;
    gl64_t kF3507 = tmp3_2 * s1_3507_2;
    gl64_t kG3507 = kD3507 - kE3507;
    tmp3_0 = (kC3507 + kG3507) - kF3507;
    tmp3_1 = ((((kA3507 + kC3507) - kE3507) - kE3507) - kD3507);
    tmp3_2 = kB3507 - kG3507;
    // Op 3508: dim3x1 add
    gl64_t s1_3508 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3508; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3509: dim3x3 add
    gl64_t s1_3509_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3509_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3509_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3509_0; tmp3_1 = tmp3_1 + s1_3509_1; tmp3_2 = tmp3_2 + s1_3509_2;
    // Op 3510: dim3x1 sub
    gl64_t s1_3510 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3510; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3511: dim3x1 add
    gl64_t s1_3511 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3511; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3512: dim3x3 mul
    gl64_t kA3512 = (tmp3_9 + tmp3_10) * (tmp3_0 + tmp3_1);
    gl64_t kB3512 = (tmp3_9 + tmp3_11) * (tmp3_0 + tmp3_2);
    gl64_t kC3512 = (tmp3_10 + tmp3_11) * (tmp3_1 + tmp3_2);
    gl64_t kD3512 = tmp3_9 * tmp3_0;
    gl64_t kE3512 = tmp3_10 * tmp3_1;
    gl64_t kF3512 = tmp3_11 * tmp3_2;
    gl64_t kG3512 = kD3512 - kE3512;
    tmp3_9 = (kC3512 + kG3512) - kF3512;
    tmp3_10 = ((((kA3512 + kC3512) - kE3512) - kE3512) - kD3512);
    tmp3_11 = kB3512 - kG3512;
    // Op 3513: dim1x1 mul
    gl64_t s0_3513 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3513 = *(gl64_t*)&expressions_params[9][10];
    tmp1_2 = s0_3513 * s1_3513;
    // Op 3514: dim3x1 mul
    gl64_t s0_3514_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3514_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3514_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3514_0 * tmp1_2; tmp3_1 = s0_3514_1 * tmp1_2; tmp3_2 = s0_3514_2 * tmp1_2;
    // Op 3515: dim3x1 add
    gl64_t s1_3515 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3515; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3516: dim3x3 mul
    gl64_t s1_3516_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3516_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3516_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3516 = (tmp3_0 + tmp3_1) * (s1_3516_0 + s1_3516_1);
    gl64_t kB3516 = (tmp3_0 + tmp3_2) * (s1_3516_0 + s1_3516_2);
    gl64_t kC3516 = (tmp3_1 + tmp3_2) * (s1_3516_1 + s1_3516_2);
    gl64_t kD3516 = tmp3_0 * s1_3516_0;
    gl64_t kE3516 = tmp3_1 * s1_3516_1;
    gl64_t kF3516 = tmp3_2 * s1_3516_2;
    gl64_t kG3516 = kD3516 - kE3516;
    tmp3_0 = (kC3516 + kG3516) - kF3516;
    tmp3_1 = ((((kA3516 + kC3516) - kE3516) - kE3516) - kD3516);
    tmp3_2 = kB3516 - kG3516;
    // Op 3517: dim3x1 add
    gl64_t s1_3517 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3517; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3518: dim3x3 add
    gl64_t s1_3518_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3518_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3518_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3518_0; tmp3_1 = tmp3_1 + s1_3518_1; tmp3_2 = tmp3_2 + s1_3518_2;
    // Op 3519: dim3x1 sub
    gl64_t s1_3519 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3519; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3520: dim3x1 add
    gl64_t s1_3520 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3520; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3521: dim3x3 mul
    gl64_t kA3521 = (tmp3_9 + tmp3_10) * (tmp3_0 + tmp3_1);
    gl64_t kB3521 = (tmp3_9 + tmp3_11) * (tmp3_0 + tmp3_2);
    gl64_t kC3521 = (tmp3_10 + tmp3_11) * (tmp3_1 + tmp3_2);
    gl64_t kD3521 = tmp3_9 * tmp3_0;
    gl64_t kE3521 = tmp3_10 * tmp3_1;
    gl64_t kF3521 = tmp3_11 * tmp3_2;
    gl64_t kG3521 = kD3521 - kE3521;
    tmp3_9 = (kC3521 + kG3521) - kF3521;
    tmp3_10 = ((((kA3521 + kC3521) - kE3521) - kE3521) - kD3521);
    tmp3_11 = kB3521 - kG3521;
    // Op 3522: dim1x1 mul
    gl64_t s0_3522 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3522 = *(gl64_t*)&expressions_params[9][11];
    tmp1_2 = s0_3522 * s1_3522;
    // Op 3523: dim3x1 mul
    gl64_t s0_3523_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3523_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3523_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3523_0 * tmp1_2; tmp3_1 = s0_3523_1 * tmp1_2; tmp3_2 = s0_3523_2 * tmp1_2;
    // Op 3524: dim3x1 add
    gl64_t s1_3524 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3524; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3525: dim3x3 mul
    gl64_t s1_3525_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3525_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3525_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3525 = (tmp3_0 + tmp3_1) * (s1_3525_0 + s1_3525_1);
    gl64_t kB3525 = (tmp3_0 + tmp3_2) * (s1_3525_0 + s1_3525_2);
    gl64_t kC3525 = (tmp3_1 + tmp3_2) * (s1_3525_1 + s1_3525_2);
    gl64_t kD3525 = tmp3_0 * s1_3525_0;
    gl64_t kE3525 = tmp3_1 * s1_3525_1;
    gl64_t kF3525 = tmp3_2 * s1_3525_2;
    gl64_t kG3525 = kD3525 - kE3525;
    tmp3_0 = (kC3525 + kG3525) - kF3525;
    tmp3_1 = ((((kA3525 + kC3525) - kE3525) - kE3525) - kD3525);
    tmp3_2 = kB3525 - kG3525;
    // Op 3526: dim3x1 add
    gl64_t s1_3526 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3526; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3527: dim3x3 add
    gl64_t s1_3527_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3527_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3527_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3527_0; tmp3_1 = tmp3_1 + s1_3527_1; tmp3_2 = tmp3_2 + s1_3527_2;
    // Op 3528: dim3x1 sub
    gl64_t s1_3528 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3528; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3529: dim3x1 add
    gl64_t s1_3529 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3529; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3530: dim3x3 mul
    gl64_t kA3530 = (tmp3_9 + tmp3_10) * (tmp3_0 + tmp3_1);
    gl64_t kB3530 = (tmp3_9 + tmp3_11) * (tmp3_0 + tmp3_2);
    gl64_t kC3530 = (tmp3_10 + tmp3_11) * (tmp3_1 + tmp3_2);
    gl64_t kD3530 = tmp3_9 * tmp3_0;
    gl64_t kE3530 = tmp3_10 * tmp3_1;
    gl64_t kF3530 = tmp3_11 * tmp3_2;
    gl64_t kG3530 = kD3530 - kE3530;
    tmp3_9 = (kC3530 + kG3530) - kF3530;
    tmp3_10 = ((((kA3530 + kC3530) - kE3530) - kE3530) - kD3530);
    tmp3_11 = kB3530 - kG3530;
    // Op 3531: dim1x1 mul
    gl64_t s0_3531 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3531 = *(gl64_t*)&expressions_params[9][12];
    tmp1_2 = s0_3531 * s1_3531;
    // Op 3532: dim3x1 mul
    gl64_t s0_3532_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3532_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3532_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3532_0 * tmp1_2; tmp3_1 = s0_3532_1 * tmp1_2; tmp3_2 = s0_3532_2 * tmp1_2;
    // Op 3533: dim3x1 add
    gl64_t s1_3533 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3533; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3534: dim3x3 mul
    gl64_t s1_3534_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3534_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3534_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3534 = (tmp3_0 + tmp3_1) * (s1_3534_0 + s1_3534_1);
    gl64_t kB3534 = (tmp3_0 + tmp3_2) * (s1_3534_0 + s1_3534_2);
    gl64_t kC3534 = (tmp3_1 + tmp3_2) * (s1_3534_1 + s1_3534_2);
    gl64_t kD3534 = tmp3_0 * s1_3534_0;
    gl64_t kE3534 = tmp3_1 * s1_3534_1;
    gl64_t kF3534 = tmp3_2 * s1_3534_2;
    gl64_t kG3534 = kD3534 - kE3534;
    tmp3_0 = (kC3534 + kG3534) - kF3534;
    tmp3_1 = ((((kA3534 + kC3534) - kE3534) - kE3534) - kD3534);
    tmp3_2 = kB3534 - kG3534;
    // Op 3535: dim3x1 add
    gl64_t s1_3535 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3535; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3536: dim3x3 add
    gl64_t s1_3536_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3536_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3536_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3536_0; tmp3_1 = tmp3_1 + s1_3536_1; tmp3_2 = tmp3_2 + s1_3536_2;
    // Op 3537: dim3x1 sub
    gl64_t s1_3537 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3537; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3538: dim3x1 add
    gl64_t s1_3538 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3538; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3539: dim3x3 mul
    gl64_t kA3539 = (tmp3_9 + tmp3_10) * (tmp3_0 + tmp3_1);
    gl64_t kB3539 = (tmp3_9 + tmp3_11) * (tmp3_0 + tmp3_2);
    gl64_t kC3539 = (tmp3_10 + tmp3_11) * (tmp3_1 + tmp3_2);
    gl64_t kD3539 = tmp3_9 * tmp3_0;
    gl64_t kE3539 = tmp3_10 * tmp3_1;
    gl64_t kF3539 = tmp3_11 * tmp3_2;
    gl64_t kG3539 = kD3539 - kE3539;
    tmp3_0 = (kC3539 + kG3539) - kF3539;
    tmp3_1 = ((((kA3539 + kC3539) - kE3539) - kE3539) - kD3539);
    tmp3_2 = kB3539 - kG3539;
    // Op 3540: dim3x3 mul
    gl64_t s0_3540_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_2, 6+0, domainSize, nCols_2))];
    gl64_t s0_3540_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_2, 6+1, domainSize, nCols_2))];
    gl64_t s0_3540_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_2, 6+2, domainSize, nCols_2))];
    gl64_t kA3540 = (s0_3540_0 + s0_3540_1) * (tmp3_0 + tmp3_1);
    gl64_t kB3540 = (s0_3540_0 + s0_3540_2) * (tmp3_0 + tmp3_2);
    gl64_t kC3540 = (s0_3540_1 + s0_3540_2) * (tmp3_1 + tmp3_2);
    gl64_t kD3540 = s0_3540_0 * tmp3_0;
    gl64_t kE3540 = s0_3540_1 * tmp3_1;
    gl64_t kF3540 = s0_3540_2 * tmp3_2;
    gl64_t kG3540 = kD3540 - kE3540;
    tmp3_6 = (kC3540 + kG3540) - kF3540;
    tmp3_7 = ((((kA3540 + kC3540) - kE3540) - kE3540) - kD3540);
    tmp3_8 = kB3540 - kG3540;
    // Op 3541: dim3x1 mul
    gl64_t s0_3541_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3541_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3541_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3541 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 8, domainSize, nCols_0)];
    tmp3_0 = s0_3541_0 * s1_3541; tmp3_1 = s0_3541_1 * s1_3541; tmp3_2 = s0_3541_2 * s1_3541;
    // Op 3542: dim3x1 add
    gl64_t s1_3542 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 8, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3542; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3543: dim3x3 mul
    gl64_t s1_3543_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3543_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3543_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3543 = (tmp3_0 + tmp3_1) * (s1_3543_0 + s1_3543_1);
    gl64_t kB3543 = (tmp3_0 + tmp3_2) * (s1_3543_0 + s1_3543_2);
    gl64_t kC3543 = (tmp3_1 + tmp3_2) * (s1_3543_1 + s1_3543_2);
    gl64_t kD3543 = tmp3_0 * s1_3543_0;
    gl64_t kE3543 = tmp3_1 * s1_3543_1;
    gl64_t kF3543 = tmp3_2 * s1_3543_2;
    gl64_t kG3543 = kD3543 - kE3543;
    tmp3_0 = (kC3543 + kG3543) - kF3543;
    tmp3_1 = ((((kA3543 + kC3543) - kE3543) - kE3543) - kD3543);
    tmp3_2 = kB3543 - kG3543;
    // Op 3544: dim3x1 add
    gl64_t s1_3544 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3544; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3545: dim3x3 add
    gl64_t s1_3545_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3545_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3545_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3545_0; tmp3_1 = tmp3_1 + s1_3545_1; tmp3_2 = tmp3_2 + s1_3545_2;
    // Op 3546: dim3x1 sub
    gl64_t s1_3546 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3546; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3547: dim3x1 add
    gl64_t s1_3547 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3547; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3548: dim3x3 mul
    gl64_t s0_3548_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_2, 3+0, domainSize, nCols_2))];
    gl64_t s0_3548_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_2, 3+1, domainSize, nCols_2))];
    gl64_t s0_3548_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_2, 3+2, domainSize, nCols_2))];
    gl64_t kA3548 = (s0_3548_0 + s0_3548_1) * (tmp3_0 + tmp3_1);
    gl64_t kB3548 = (s0_3548_0 + s0_3548_2) * (tmp3_0 + tmp3_2);
    gl64_t kC3548 = (s0_3548_1 + s0_3548_2) * (tmp3_1 + tmp3_2);
    gl64_t kD3548 = s0_3548_0 * tmp3_0;
    gl64_t kE3548 = s0_3548_1 * tmp3_1;
    gl64_t kF3548 = s0_3548_2 * tmp3_2;
    gl64_t kG3548 = kD3548 - kE3548;
    tmp3_9 = (kC3548 + kG3548) - kF3548;
    tmp3_10 = ((((kA3548 + kC3548) - kE3548) - kE3548) - kD3548);
    tmp3_11 = kB3548 - kG3548;
    // Op 3549: dim3x1 mul
    gl64_t s0_3549_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3549_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3549_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3549 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_0)];
    tmp3_0 = s0_3549_0 * s1_3549; tmp3_1 = s0_3549_1 * s1_3549; tmp3_2 = s0_3549_2 * s1_3549;
    // Op 3550: dim3x1 add
    gl64_t s1_3550 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3550; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3551: dim3x3 mul
    gl64_t s1_3551_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3551_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3551_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3551 = (tmp3_0 + tmp3_1) * (s1_3551_0 + s1_3551_1);
    gl64_t kB3551 = (tmp3_0 + tmp3_2) * (s1_3551_0 + s1_3551_2);
    gl64_t kC3551 = (tmp3_1 + tmp3_2) * (s1_3551_1 + s1_3551_2);
    gl64_t kD3551 = tmp3_0 * s1_3551_0;
    gl64_t kE3551 = tmp3_1 * s1_3551_1;
    gl64_t kF3551 = tmp3_2 * s1_3551_2;
    gl64_t kG3551 = kD3551 - kE3551;
    tmp3_0 = (kC3551 + kG3551) - kF3551;
    tmp3_1 = ((((kA3551 + kC3551) - kE3551) - kE3551) - kD3551);
    tmp3_2 = kB3551 - kG3551;
    // Op 3552: dim3x1 add
    gl64_t s1_3552 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3552; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3553: dim3x3 add
    gl64_t s1_3553_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3553_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3553_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3553_0; tmp3_1 = tmp3_1 + s1_3553_1; tmp3_2 = tmp3_2 + s1_3553_2;
    // Op 3554: dim3x1 sub
    gl64_t s1_3554 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3554; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3555: dim3x1 add
    gl64_t s1_3555 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3555; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3556: dim3x3 mul
    gl64_t kA3556 = (tmp3_9 + tmp3_10) * (tmp3_0 + tmp3_1);
    gl64_t kB3556 = (tmp3_9 + tmp3_11) * (tmp3_0 + tmp3_2);
    gl64_t kC3556 = (tmp3_10 + tmp3_11) * (tmp3_1 + tmp3_2);
    gl64_t kD3556 = tmp3_9 * tmp3_0;
    gl64_t kE3556 = tmp3_10 * tmp3_1;
    gl64_t kF3556 = tmp3_11 * tmp3_2;
    gl64_t kG3556 = kD3556 - kE3556;
    tmp3_9 = (kC3556 + kG3556) - kF3556;
    tmp3_10 = ((((kA3556 + kC3556) - kE3556) - kE3556) - kD3556);
    tmp3_11 = kB3556 - kG3556;
    // Op 3557: dim3x1 mul
    gl64_t s0_3557_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3557_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3557_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3557 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 10, domainSize, nCols_0)];
    tmp3_0 = s0_3557_0 * s1_3557; tmp3_1 = s0_3557_1 * s1_3557; tmp3_2 = s0_3557_2 * s1_3557;
    // Op 3558: dim3x1 add
    gl64_t s1_3558 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 10, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3558; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3559: dim3x3 mul
    gl64_t s1_3559_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3559_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3559_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3559 = (tmp3_0 + tmp3_1) * (s1_3559_0 + s1_3559_1);
    gl64_t kB3559 = (tmp3_0 + tmp3_2) * (s1_3559_0 + s1_3559_2);
    gl64_t kC3559 = (tmp3_1 + tmp3_2) * (s1_3559_1 + s1_3559_2);
    gl64_t kD3559 = tmp3_0 * s1_3559_0;
    gl64_t kE3559 = tmp3_1 * s1_3559_1;
    gl64_t kF3559 = tmp3_2 * s1_3559_2;
    gl64_t kG3559 = kD3559 - kE3559;
    tmp3_0 = (kC3559 + kG3559) - kF3559;
    tmp3_1 = ((((kA3559 + kC3559) - kE3559) - kE3559) - kD3559);
    tmp3_2 = kB3559 - kG3559;
    // Op 3560: dim3x1 add
    gl64_t s1_3560 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3560; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3561: dim3x3 add
    gl64_t s1_3561_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3561_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3561_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3561_0; tmp3_1 = tmp3_1 + s1_3561_1; tmp3_2 = tmp3_2 + s1_3561_2;
    // Op 3562: dim3x1 sub
    gl64_t s1_3562 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3562; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3563: dim3x1 add
    gl64_t s1_3563 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3563; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3564: dim3x3 mul
    gl64_t kA3564 = (tmp3_9 + tmp3_10) * (tmp3_0 + tmp3_1);
    gl64_t kB3564 = (tmp3_9 + tmp3_11) * (tmp3_0 + tmp3_2);
    gl64_t kC3564 = (tmp3_10 + tmp3_11) * (tmp3_1 + tmp3_2);
    gl64_t kD3564 = tmp3_9 * tmp3_0;
    gl64_t kE3564 = tmp3_10 * tmp3_1;
    gl64_t kF3564 = tmp3_11 * tmp3_2;
    gl64_t kG3564 = kD3564 - kE3564;
    tmp3_9 = (kC3564 + kG3564) - kF3564;
    tmp3_10 = ((((kA3564 + kC3564) - kE3564) - kE3564) - kD3564);
    tmp3_11 = kB3564 - kG3564;
    // Op 3565: dim3x1 mul
    gl64_t s0_3565_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3565_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3565_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3565 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_0)];
    tmp3_0 = s0_3565_0 * s1_3565; tmp3_1 = s0_3565_1 * s1_3565; tmp3_2 = s0_3565_2 * s1_3565;
    // Op 3566: dim3x1 add
    gl64_t s1_3566 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 11, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3566; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3567: dim3x3 mul
    gl64_t s1_3567_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3567_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3567_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3567 = (tmp3_0 + tmp3_1) * (s1_3567_0 + s1_3567_1);
    gl64_t kB3567 = (tmp3_0 + tmp3_2) * (s1_3567_0 + s1_3567_2);
    gl64_t kC3567 = (tmp3_1 + tmp3_2) * (s1_3567_1 + s1_3567_2);
    gl64_t kD3567 = tmp3_0 * s1_3567_0;
    gl64_t kE3567 = tmp3_1 * s1_3567_1;
    gl64_t kF3567 = tmp3_2 * s1_3567_2;
    gl64_t kG3567 = kD3567 - kE3567;
    tmp3_0 = (kC3567 + kG3567) - kF3567;
    tmp3_1 = ((((kA3567 + kC3567) - kE3567) - kE3567) - kD3567);
    tmp3_2 = kB3567 - kG3567;
    // Op 3568: dim3x1 add
    gl64_t s1_3568 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3568; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3569: dim3x3 add
    gl64_t s1_3569_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3569_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3569_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3569_0; tmp3_1 = tmp3_1 + s1_3569_1; tmp3_2 = tmp3_2 + s1_3569_2;
    // Op 3570: dim3x1 sub
    gl64_t s1_3570 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3570; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3571: dim3x1 add
    gl64_t s1_3571 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3571; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3572: dim3x3 mul
    gl64_t kA3572 = (tmp3_9 + tmp3_10) * (tmp3_0 + tmp3_1);
    gl64_t kB3572 = (tmp3_9 + tmp3_11) * (tmp3_0 + tmp3_2);
    gl64_t kC3572 = (tmp3_10 + tmp3_11) * (tmp3_1 + tmp3_2);
    gl64_t kD3572 = tmp3_9 * tmp3_0;
    gl64_t kE3572 = tmp3_10 * tmp3_1;
    gl64_t kF3572 = tmp3_11 * tmp3_2;
    gl64_t kG3572 = kD3572 - kE3572;
    tmp3_9 = (kC3572 + kG3572) - kF3572;
    tmp3_10 = ((((kA3572 + kC3572) - kE3572) - kE3572) - kD3572);
    tmp3_11 = kB3572 - kG3572;
    // Op 3573: dim3x1 mul
    gl64_t s0_3573_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3573_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3573_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3573 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_0)];
    tmp3_0 = s0_3573_0 * s1_3573; tmp3_1 = s0_3573_1 * s1_3573; tmp3_2 = s0_3573_2 * s1_3573;
    // Op 3574: dim3x1 add
    gl64_t s1_3574 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 12, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3574; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3575: dim3x3 mul
    gl64_t s1_3575_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3575_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3575_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3575 = (tmp3_0 + tmp3_1) * (s1_3575_0 + s1_3575_1);
    gl64_t kB3575 = (tmp3_0 + tmp3_2) * (s1_3575_0 + s1_3575_2);
    gl64_t kC3575 = (tmp3_1 + tmp3_2) * (s1_3575_1 + s1_3575_2);
    gl64_t kD3575 = tmp3_0 * s1_3575_0;
    gl64_t kE3575 = tmp3_1 * s1_3575_1;
    gl64_t kF3575 = tmp3_2 * s1_3575_2;
    gl64_t kG3575 = kD3575 - kE3575;
    tmp3_0 = (kC3575 + kG3575) - kF3575;
    tmp3_1 = ((((kA3575 + kC3575) - kE3575) - kE3575) - kD3575);
    tmp3_2 = kB3575 - kG3575;
    // Op 3576: dim3x1 add
    gl64_t s1_3576 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3576; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3577: dim3x3 add
    gl64_t s1_3577_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3577_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3577_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3577_0; tmp3_1 = tmp3_1 + s1_3577_1; tmp3_2 = tmp3_2 + s1_3577_2;
    // Op 3578: dim3x1 sub
    gl64_t s1_3578 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3578; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3579: dim3x1 add
    gl64_t s1_3579 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3579; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3580: dim3x3 mul
    gl64_t kA3580 = (tmp3_9 + tmp3_10) * (tmp3_0 + tmp3_1);
    gl64_t kB3580 = (tmp3_9 + tmp3_11) * (tmp3_0 + tmp3_2);
    gl64_t kC3580 = (tmp3_10 + tmp3_11) * (tmp3_1 + tmp3_2);
    gl64_t kD3580 = tmp3_9 * tmp3_0;
    gl64_t kE3580 = tmp3_10 * tmp3_1;
    gl64_t kF3580 = tmp3_11 * tmp3_2;
    gl64_t kG3580 = kD3580 - kE3580;
    tmp3_9 = (kC3580 + kG3580) - kF3580;
    tmp3_10 = ((((kA3580 + kC3580) - kE3580) - kE3580) - kD3580);
    tmp3_11 = kB3580 - kG3580;
    // Op 3581: dim3x1 mul
    gl64_t s0_3581_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3581_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3581_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3581 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_0)];
    tmp3_0 = s0_3581_0 * s1_3581; tmp3_1 = s0_3581_1 * s1_3581; tmp3_2 = s0_3581_2 * s1_3581;
    // Op 3582: dim3x1 add
    gl64_t s1_3582 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 13, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3582; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3583: dim3x3 mul
    gl64_t s1_3583_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3583_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3583_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3583 = (tmp3_0 + tmp3_1) * (s1_3583_0 + s1_3583_1);
    gl64_t kB3583 = (tmp3_0 + tmp3_2) * (s1_3583_0 + s1_3583_2);
    gl64_t kC3583 = (tmp3_1 + tmp3_2) * (s1_3583_1 + s1_3583_2);
    gl64_t kD3583 = tmp3_0 * s1_3583_0;
    gl64_t kE3583 = tmp3_1 * s1_3583_1;
    gl64_t kF3583 = tmp3_2 * s1_3583_2;
    gl64_t kG3583 = kD3583 - kE3583;
    tmp3_0 = (kC3583 + kG3583) - kF3583;
    tmp3_1 = ((((kA3583 + kC3583) - kE3583) - kE3583) - kD3583);
    tmp3_2 = kB3583 - kG3583;
    // Op 3584: dim3x1 add
    gl64_t s1_3584 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3584; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3585: dim3x3 add
    gl64_t s1_3585_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3585_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3585_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3585_0; tmp3_1 = tmp3_1 + s1_3585_1; tmp3_2 = tmp3_2 + s1_3585_2;
    // Op 3586: dim3x1 sub
    gl64_t s1_3586 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3586; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3587: dim3x1 add
    gl64_t s1_3587 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3587; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3588: dim3x3 mul
    gl64_t kA3588 = (tmp3_9 + tmp3_10) * (tmp3_0 + tmp3_1);
    gl64_t kB3588 = (tmp3_9 + tmp3_11) * (tmp3_0 + tmp3_2);
    gl64_t kC3588 = (tmp3_10 + tmp3_11) * (tmp3_1 + tmp3_2);
    gl64_t kD3588 = tmp3_9 * tmp3_0;
    gl64_t kE3588 = tmp3_10 * tmp3_1;
    gl64_t kF3588 = tmp3_11 * tmp3_2;
    gl64_t kG3588 = kD3588 - kE3588;
    tmp3_9 = (kC3588 + kG3588) - kF3588;
    tmp3_10 = ((((kA3588 + kC3588) - kE3588) - kE3588) - kD3588);
    tmp3_11 = kB3588 - kG3588;
    // Op 3589: dim3x1 mul
    gl64_t s0_3589_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3589_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3589_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3589 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_0)];
    tmp3_0 = s0_3589_0 * s1_3589; tmp3_1 = s0_3589_1 * s1_3589; tmp3_2 = s0_3589_2 * s1_3589;
    // Op 3590: dim3x1 add
    gl64_t s1_3590 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3590; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3591: dim3x3 mul
    gl64_t s1_3591_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3591_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3591_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3591 = (tmp3_0 + tmp3_1) * (s1_3591_0 + s1_3591_1);
    gl64_t kB3591 = (tmp3_0 + tmp3_2) * (s1_3591_0 + s1_3591_2);
    gl64_t kC3591 = (tmp3_1 + tmp3_2) * (s1_3591_1 + s1_3591_2);
    gl64_t kD3591 = tmp3_0 * s1_3591_0;
    gl64_t kE3591 = tmp3_1 * s1_3591_1;
    gl64_t kF3591 = tmp3_2 * s1_3591_2;
    gl64_t kG3591 = kD3591 - kE3591;
    tmp3_0 = (kC3591 + kG3591) - kF3591;
    tmp3_1 = ((((kA3591 + kC3591) - kE3591) - kE3591) - kD3591);
    tmp3_2 = kB3591 - kG3591;
    // Op 3592: dim3x1 add
    gl64_t s1_3592 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3592; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3593: dim3x3 add
    gl64_t s1_3593_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3593_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3593_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3593_0; tmp3_1 = tmp3_1 + s1_3593_1; tmp3_2 = tmp3_2 + s1_3593_2;
    // Op 3594: dim3x1 sub
    gl64_t s1_3594 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3594; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3595: dim3x1 add
    gl64_t s1_3595 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3595; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3596: dim3x3 mul
    gl64_t kA3596 = (tmp3_9 + tmp3_10) * (tmp3_0 + tmp3_1);
    gl64_t kB3596 = (tmp3_9 + tmp3_11) * (tmp3_0 + tmp3_2);
    gl64_t kC3596 = (tmp3_10 + tmp3_11) * (tmp3_1 + tmp3_2);
    gl64_t kD3596 = tmp3_9 * tmp3_0;
    gl64_t kE3596 = tmp3_10 * tmp3_1;
    gl64_t kF3596 = tmp3_11 * tmp3_2;
    gl64_t kG3596 = kD3596 - kE3596;
    tmp3_0 = (kC3596 + kG3596) - kF3596;
    tmp3_1 = ((((kA3596 + kC3596) - kE3596) - kE3596) - kD3596);
    tmp3_2 = kB3596 - kG3596;
    // Op 3597: dim3x3 sub
    tmp3_0 = tmp3_6 - tmp3_0; tmp3_1 = tmp3_7 - tmp3_1; tmp3_2 = tmp3_8 - tmp3_2;
    // Op 3598: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 3599: dim3x3 mul
    gl64_t s1_3599_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3599_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3599_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3599 = (tmp3_0 + tmp3_1) * (s1_3599_0 + s1_3599_1);
    gl64_t kB3599 = (tmp3_0 + tmp3_2) * (s1_3599_0 + s1_3599_2);
    gl64_t kC3599 = (tmp3_1 + tmp3_2) * (s1_3599_1 + s1_3599_2);
    gl64_t kD3599 = tmp3_0 * s1_3599_0;
    gl64_t kE3599 = tmp3_1 * s1_3599_1;
    gl64_t kF3599 = tmp3_2 * s1_3599_2;
    gl64_t kG3599 = kD3599 - kE3599;
    tmp3_9 = (kC3599 + kG3599) - kF3599;
    tmp3_10 = ((((kA3599 + kC3599) - kE3599) - kE3599) - kD3599);
    tmp3_11 = kB3599 - kG3599;
    // Op 3600: dim1x1 mul
    gl64_t s0_3600 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3600 = *(gl64_t*)&expressions_params[9][13];
    tmp1_2 = s0_3600 * s1_3600;
    // Op 3601: dim3x1 mul
    gl64_t s0_3601_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3601_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3601_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3601_0 * tmp1_2; tmp3_1 = s0_3601_1 * tmp1_2; tmp3_2 = s0_3601_2 * tmp1_2;
    // Op 3602: dim3x1 add
    gl64_t s1_3602 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 14, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3602; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3603: dim3x3 mul
    gl64_t s1_3603_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3603_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3603_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3603 = (tmp3_0 + tmp3_1) * (s1_3603_0 + s1_3603_1);
    gl64_t kB3603 = (tmp3_0 + tmp3_2) * (s1_3603_0 + s1_3603_2);
    gl64_t kC3603 = (tmp3_1 + tmp3_2) * (s1_3603_1 + s1_3603_2);
    gl64_t kD3603 = tmp3_0 * s1_3603_0;
    gl64_t kE3603 = tmp3_1 * s1_3603_1;
    gl64_t kF3603 = tmp3_2 * s1_3603_2;
    gl64_t kG3603 = kD3603 - kE3603;
    tmp3_0 = (kC3603 + kG3603) - kF3603;
    tmp3_1 = ((((kA3603 + kC3603) - kE3603) - kE3603) - kD3603);
    tmp3_2 = kB3603 - kG3603;
    // Op 3604: dim3x1 add
    gl64_t s1_3604 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3604; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3605: dim3x3 add
    gl64_t s1_3605_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3605_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3605_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3605_0; tmp3_1 = tmp3_1 + s1_3605_1; tmp3_2 = tmp3_2 + s1_3605_2;
    // Op 3606: dim3x1 sub
    gl64_t s1_3606 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3606; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3607: dim3x1 add
    gl64_t s1_3607 = *(gl64_t*)&expressions_params[9][26];
    tmp3_3 = tmp3_0 + s1_3607; tmp3_4 = tmp3_1; tmp3_5 = tmp3_2;
    // Op 3608: dim1x1 mul
    gl64_t s0_3608 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3608 = *(gl64_t*)&expressions_params[9][14];
    tmp1_2 = s0_3608 * s1_3608;
    // Op 3609: dim3x1 mul
    gl64_t s0_3609_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3609_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3609_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3609_0 * tmp1_2; tmp3_1 = s0_3609_1 * tmp1_2; tmp3_2 = s0_3609_2 * tmp1_2;
    // Op 3610: dim3x1 add
    gl64_t s1_3610 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3610; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3611: dim3x3 mul
    gl64_t s1_3611_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3611_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3611_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3611 = (tmp3_0 + tmp3_1) * (s1_3611_0 + s1_3611_1);
    gl64_t kB3611 = (tmp3_0 + tmp3_2) * (s1_3611_0 + s1_3611_2);
    gl64_t kC3611 = (tmp3_1 + tmp3_2) * (s1_3611_1 + s1_3611_2);
    gl64_t kD3611 = tmp3_0 * s1_3611_0;
    gl64_t kE3611 = tmp3_1 * s1_3611_1;
    gl64_t kF3611 = tmp3_2 * s1_3611_2;
    gl64_t kG3611 = kD3611 - kE3611;
    tmp3_0 = (kC3611 + kG3611) - kF3611;
    tmp3_1 = ((((kA3611 + kC3611) - kE3611) - kE3611) - kD3611);
    tmp3_2 = kB3611 - kG3611;
    // Op 3612: dim3x1 add
    gl64_t s1_3612 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3612; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3613: dim3x3 add
    gl64_t s1_3613_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3613_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3613_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3613_0; tmp3_1 = tmp3_1 + s1_3613_1; tmp3_2 = tmp3_2 + s1_3613_2;
    // Op 3614: dim3x1 sub
    gl64_t s1_3614 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3614; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3615: dim3x1 add
    gl64_t s1_3615 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3615; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3616: dim3x3 mul
    gl64_t kA3616 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3616 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3616 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3616 = tmp3_3 * tmp3_0;
    gl64_t kE3616 = tmp3_4 * tmp3_1;
    gl64_t kF3616 = tmp3_5 * tmp3_2;
    gl64_t kG3616 = kD3616 - kE3616;
    tmp3_3 = (kC3616 + kG3616) - kF3616;
    tmp3_4 = ((((kA3616 + kC3616) - kE3616) - kE3616) - kD3616);
    tmp3_5 = kB3616 - kG3616;
    // Op 3617: dim1x1 mul
    gl64_t s0_3617 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3617 = *(gl64_t*)&expressions_params[9][15];
    tmp1_2 = s0_3617 * s1_3617;
    // Op 3618: dim3x1 mul
    gl64_t s0_3618_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3618_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3618_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3618_0 * tmp1_2; tmp3_1 = s0_3618_1 * tmp1_2; tmp3_2 = s0_3618_2 * tmp1_2;
    // Op 3619: dim3x1 add
    gl64_t s1_3619 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3619; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3620: dim3x3 mul
    gl64_t s1_3620_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3620_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3620_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3620 = (tmp3_0 + tmp3_1) * (s1_3620_0 + s1_3620_1);
    gl64_t kB3620 = (tmp3_0 + tmp3_2) * (s1_3620_0 + s1_3620_2);
    gl64_t kC3620 = (tmp3_1 + tmp3_2) * (s1_3620_1 + s1_3620_2);
    gl64_t kD3620 = tmp3_0 * s1_3620_0;
    gl64_t kE3620 = tmp3_1 * s1_3620_1;
    gl64_t kF3620 = tmp3_2 * s1_3620_2;
    gl64_t kG3620 = kD3620 - kE3620;
    tmp3_0 = (kC3620 + kG3620) - kF3620;
    tmp3_1 = ((((kA3620 + kC3620) - kE3620) - kE3620) - kD3620);
    tmp3_2 = kB3620 - kG3620;
    // Op 3621: dim3x1 add
    gl64_t s1_3621 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3621; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3622: dim3x3 add
    gl64_t s1_3622_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3622_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3622_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3622_0; tmp3_1 = tmp3_1 + s1_3622_1; tmp3_2 = tmp3_2 + s1_3622_2;
    // Op 3623: dim3x1 sub
    gl64_t s1_3623 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3623; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3624: dim3x1 add
    gl64_t s1_3624 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3624; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3625: dim3x3 mul
    gl64_t kA3625 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3625 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3625 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3625 = tmp3_3 * tmp3_0;
    gl64_t kE3625 = tmp3_4 * tmp3_1;
    gl64_t kF3625 = tmp3_5 * tmp3_2;
    gl64_t kG3625 = kD3625 - kE3625;
    tmp3_3 = (kC3625 + kG3625) - kF3625;
    tmp3_4 = ((((kA3625 + kC3625) - kE3625) - kE3625) - kD3625);
    tmp3_5 = kB3625 - kG3625;
    // Op 3626: dim1x1 mul
    gl64_t s0_3626 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3626 = *(gl64_t*)&expressions_params[9][16];
    tmp1_2 = s0_3626 * s1_3626;
    // Op 3627: dim3x1 mul
    gl64_t s0_3627_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3627_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3627_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3627_0 * tmp1_2; tmp3_1 = s0_3627_1 * tmp1_2; tmp3_2 = s0_3627_2 * tmp1_2;
    // Op 3628: dim3x1 add
    gl64_t s1_3628 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3628; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3629: dim3x3 mul
    gl64_t s1_3629_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3629_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3629_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3629 = (tmp3_0 + tmp3_1) * (s1_3629_0 + s1_3629_1);
    gl64_t kB3629 = (tmp3_0 + tmp3_2) * (s1_3629_0 + s1_3629_2);
    gl64_t kC3629 = (tmp3_1 + tmp3_2) * (s1_3629_1 + s1_3629_2);
    gl64_t kD3629 = tmp3_0 * s1_3629_0;
    gl64_t kE3629 = tmp3_1 * s1_3629_1;
    gl64_t kF3629 = tmp3_2 * s1_3629_2;
    gl64_t kG3629 = kD3629 - kE3629;
    tmp3_0 = (kC3629 + kG3629) - kF3629;
    tmp3_1 = ((((kA3629 + kC3629) - kE3629) - kE3629) - kD3629);
    tmp3_2 = kB3629 - kG3629;
    // Op 3630: dim3x1 add
    gl64_t s1_3630 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3630; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3631: dim3x3 add
    gl64_t s1_3631_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3631_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3631_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3631_0; tmp3_1 = tmp3_1 + s1_3631_1; tmp3_2 = tmp3_2 + s1_3631_2;
    // Op 3632: dim3x1 sub
    gl64_t s1_3632 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3632; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3633: dim3x1 add
    gl64_t s1_3633 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3633; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3634: dim3x3 mul
    gl64_t kA3634 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3634 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3634 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3634 = tmp3_3 * tmp3_0;
    gl64_t kE3634 = tmp3_4 * tmp3_1;
    gl64_t kF3634 = tmp3_5 * tmp3_2;
    gl64_t kG3634 = kD3634 - kE3634;
    tmp3_3 = (kC3634 + kG3634) - kF3634;
    tmp3_4 = ((((kA3634 + kC3634) - kE3634) - kE3634) - kD3634);
    tmp3_5 = kB3634 - kG3634;
    // Op 3635: dim1x1 mul
    gl64_t s0_3635 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3635 = *(gl64_t*)&expressions_params[9][17];
    tmp1_2 = s0_3635 * s1_3635;
    // Op 3636: dim3x1 mul
    gl64_t s0_3636_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3636_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3636_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3636_0 * tmp1_2; tmp3_1 = s0_3636_1 * tmp1_2; tmp3_2 = s0_3636_2 * tmp1_2;
    // Op 3637: dim3x1 add
    gl64_t s1_3637 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 18, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3637; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3638: dim3x3 mul
    gl64_t s1_3638_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3638_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3638_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3638 = (tmp3_0 + tmp3_1) * (s1_3638_0 + s1_3638_1);
    gl64_t kB3638 = (tmp3_0 + tmp3_2) * (s1_3638_0 + s1_3638_2);
    gl64_t kC3638 = (tmp3_1 + tmp3_2) * (s1_3638_1 + s1_3638_2);
    gl64_t kD3638 = tmp3_0 * s1_3638_0;
    gl64_t kE3638 = tmp3_1 * s1_3638_1;
    gl64_t kF3638 = tmp3_2 * s1_3638_2;
    gl64_t kG3638 = kD3638 - kE3638;
    tmp3_0 = (kC3638 + kG3638) - kF3638;
    tmp3_1 = ((((kA3638 + kC3638) - kE3638) - kE3638) - kD3638);
    tmp3_2 = kB3638 - kG3638;
    // Op 3639: dim3x1 add
    gl64_t s1_3639 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3639; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3640: dim3x3 add
    gl64_t s1_3640_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3640_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3640_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3640_0; tmp3_1 = tmp3_1 + s1_3640_1; tmp3_2 = tmp3_2 + s1_3640_2;
    // Op 3641: dim3x1 sub
    gl64_t s1_3641 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3641; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3642: dim3x1 add
    gl64_t s1_3642 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3642; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3643: dim3x3 mul
    gl64_t kA3643 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3643 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3643 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3643 = tmp3_3 * tmp3_0;
    gl64_t kE3643 = tmp3_4 * tmp3_1;
    gl64_t kF3643 = tmp3_5 * tmp3_2;
    gl64_t kG3643 = kD3643 - kE3643;
    tmp3_3 = (kC3643 + kG3643) - kF3643;
    tmp3_4 = ((((kA3643 + kC3643) - kE3643) - kE3643) - kD3643);
    tmp3_5 = kB3643 - kG3643;
    // Op 3644: dim1x1 mul
    gl64_t s0_3644 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3644 = *(gl64_t*)&expressions_params[9][18];
    tmp1_2 = s0_3644 * s1_3644;
    // Op 3645: dim3x1 mul
    gl64_t s0_3645_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3645_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3645_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3645_0 * tmp1_2; tmp3_1 = s0_3645_1 * tmp1_2; tmp3_2 = s0_3645_2 * tmp1_2;
    // Op 3646: dim3x1 add
    gl64_t s1_3646 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 19, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3646; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3647: dim3x3 mul
    gl64_t s1_3647_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3647_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3647_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3647 = (tmp3_0 + tmp3_1) * (s1_3647_0 + s1_3647_1);
    gl64_t kB3647 = (tmp3_0 + tmp3_2) * (s1_3647_0 + s1_3647_2);
    gl64_t kC3647 = (tmp3_1 + tmp3_2) * (s1_3647_1 + s1_3647_2);
    gl64_t kD3647 = tmp3_0 * s1_3647_0;
    gl64_t kE3647 = tmp3_1 * s1_3647_1;
    gl64_t kF3647 = tmp3_2 * s1_3647_2;
    gl64_t kG3647 = kD3647 - kE3647;
    tmp3_0 = (kC3647 + kG3647) - kF3647;
    tmp3_1 = ((((kA3647 + kC3647) - kE3647) - kE3647) - kD3647);
    tmp3_2 = kB3647 - kG3647;
    // Op 3648: dim3x1 add
    gl64_t s1_3648 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3648; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3649: dim3x3 add
    gl64_t s1_3649_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3649_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3649_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3649_0; tmp3_1 = tmp3_1 + s1_3649_1; tmp3_2 = tmp3_2 + s1_3649_2;
    // Op 3650: dim3x1 sub
    gl64_t s1_3650 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3650; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3651: dim3x1 add
    gl64_t s1_3651 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3651; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3652: dim3x3 mul
    gl64_t kA3652 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3652 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3652 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3652 = tmp3_3 * tmp3_0;
    gl64_t kE3652 = tmp3_4 * tmp3_1;
    gl64_t kF3652 = tmp3_5 * tmp3_2;
    gl64_t kG3652 = kD3652 - kE3652;
    tmp3_3 = (kC3652 + kG3652) - kF3652;
    tmp3_4 = ((((kA3652 + kC3652) - kE3652) - kE3652) - kD3652);
    tmp3_5 = kB3652 - kG3652;
    // Op 3653: dim1x1 mul
    gl64_t s0_3653 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3653 = *(gl64_t*)&expressions_params[9][19];
    tmp1_2 = s0_3653 * s1_3653;
    // Op 3654: dim3x1 mul
    gl64_t s0_3654_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3654_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3654_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3654_0 * tmp1_2; tmp3_1 = s0_3654_1 * tmp1_2; tmp3_2 = s0_3654_2 * tmp1_2;
    // Op 3655: dim3x1 add
    gl64_t s1_3655 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 20, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3655; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3656: dim3x3 mul
    gl64_t s1_3656_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3656_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3656_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3656 = (tmp3_0 + tmp3_1) * (s1_3656_0 + s1_3656_1);
    gl64_t kB3656 = (tmp3_0 + tmp3_2) * (s1_3656_0 + s1_3656_2);
    gl64_t kC3656 = (tmp3_1 + tmp3_2) * (s1_3656_1 + s1_3656_2);
    gl64_t kD3656 = tmp3_0 * s1_3656_0;
    gl64_t kE3656 = tmp3_1 * s1_3656_1;
    gl64_t kF3656 = tmp3_2 * s1_3656_2;
    gl64_t kG3656 = kD3656 - kE3656;
    tmp3_0 = (kC3656 + kG3656) - kF3656;
    tmp3_1 = ((((kA3656 + kC3656) - kE3656) - kE3656) - kD3656);
    tmp3_2 = kB3656 - kG3656;
    // Op 3657: dim3x1 add
    gl64_t s1_3657 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3657; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3658: dim3x3 add
    gl64_t s1_3658_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3658_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3658_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3658_0; tmp3_1 = tmp3_1 + s1_3658_1; tmp3_2 = tmp3_2 + s1_3658_2;
    // Op 3659: dim3x1 sub
    gl64_t s1_3659 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3659; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3660: dim3x1 add
    gl64_t s1_3660 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3660; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3661: dim3x3 mul
    gl64_t kA3661 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3661 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3661 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3661 = tmp3_3 * tmp3_0;
    gl64_t kE3661 = tmp3_4 * tmp3_1;
    gl64_t kF3661 = tmp3_5 * tmp3_2;
    gl64_t kG3661 = kD3661 - kE3661;
    tmp3_0 = (kC3661 + kG3661) - kF3661;
    tmp3_1 = ((((kA3661 + kC3661) - kE3661) - kE3661) - kD3661);
    tmp3_2 = kB3661 - kG3661;
    // Op 3662: dim3x3 mul
    uint64_t s0_3662_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_2));
    gl64_t s0_3662_0 = *(gl64_t*)&dParams->aux_trace[s0_3662_pos];
    gl64_t s0_3662_1 = *(gl64_t*)&dParams->aux_trace[s0_3662_pos + TILE_HEIGHT];
    gl64_t s0_3662_2 = *(gl64_t*)&dParams->aux_trace[s0_3662_pos + 2*TILE_HEIGHT];
    gl64_t kA3662 = (s0_3662_0 + s0_3662_1) * (tmp3_0 + tmp3_1);
    gl64_t kB3662 = (s0_3662_0 + s0_3662_2) * (tmp3_0 + tmp3_2);
    gl64_t kC3662 = (s0_3662_1 + s0_3662_2) * (tmp3_1 + tmp3_2);
    gl64_t kD3662 = s0_3662_0 * tmp3_0;
    gl64_t kE3662 = s0_3662_1 * tmp3_1;
    gl64_t kF3662 = s0_3662_2 * tmp3_2;
    gl64_t kG3662 = kD3662 - kE3662;
    tmp3_6 = (kC3662 + kG3662) - kF3662;
    tmp3_7 = ((((kA3662 + kC3662) - kE3662) - kE3662) - kD3662);
    tmp3_8 = kB3662 - kG3662;
    // Op 3663: dim3x1 mul
    gl64_t s0_3663_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3663_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3663_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3663 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_0)];
    tmp3_0 = s0_3663_0 * s1_3663; tmp3_1 = s0_3663_1 * s1_3663; tmp3_2 = s0_3663_2 * s1_3663;
    // Op 3664: dim3x1 add
    gl64_t s1_3664 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 15, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3664; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3665: dim3x3 mul
    gl64_t s1_3665_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3665_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3665_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3665 = (tmp3_0 + tmp3_1) * (s1_3665_0 + s1_3665_1);
    gl64_t kB3665 = (tmp3_0 + tmp3_2) * (s1_3665_0 + s1_3665_2);
    gl64_t kC3665 = (tmp3_1 + tmp3_2) * (s1_3665_1 + s1_3665_2);
    gl64_t kD3665 = tmp3_0 * s1_3665_0;
    gl64_t kE3665 = tmp3_1 * s1_3665_1;
    gl64_t kF3665 = tmp3_2 * s1_3665_2;
    gl64_t kG3665 = kD3665 - kE3665;
    tmp3_0 = (kC3665 + kG3665) - kF3665;
    tmp3_1 = ((((kA3665 + kC3665) - kE3665) - kE3665) - kD3665);
    tmp3_2 = kB3665 - kG3665;
    // Op 3666: dim3x1 add
    gl64_t s1_3666 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3666; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3667: dim3x3 add
    gl64_t s1_3667_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3667_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3667_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3667_0; tmp3_1 = tmp3_1 + s1_3667_1; tmp3_2 = tmp3_2 + s1_3667_2;
    // Op 3668: dim3x1 sub
    gl64_t s1_3668 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3668; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3669: dim3x1 add
    gl64_t s1_3669 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3669; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3670: dim3x3 mul
    gl64_t s0_3670_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_2, 6+0, domainSize, nCols_2))];
    gl64_t s0_3670_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_2, 6+1, domainSize, nCols_2))];
    gl64_t s0_3670_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_2, 6+2, domainSize, nCols_2))];
    gl64_t kA3670 = (s0_3670_0 + s0_3670_1) * (tmp3_0 + tmp3_1);
    gl64_t kB3670 = (s0_3670_0 + s0_3670_2) * (tmp3_0 + tmp3_2);
    gl64_t kC3670 = (s0_3670_1 + s0_3670_2) * (tmp3_1 + tmp3_2);
    gl64_t kD3670 = s0_3670_0 * tmp3_0;
    gl64_t kE3670 = s0_3670_1 * tmp3_1;
    gl64_t kF3670 = s0_3670_2 * tmp3_2;
    gl64_t kG3670 = kD3670 - kE3670;
    tmp3_3 = (kC3670 + kG3670) - kF3670;
    tmp3_4 = ((((kA3670 + kC3670) - kE3670) - kE3670) - kD3670);
    tmp3_5 = kB3670 - kG3670;
    // Op 3671: dim3x1 mul
    gl64_t s0_3671_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3671_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3671_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3671 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_0)];
    tmp3_0 = s0_3671_0 * s1_3671; tmp3_1 = s0_3671_1 * s1_3671; tmp3_2 = s0_3671_2 * s1_3671;
    // Op 3672: dim3x1 add
    gl64_t s1_3672 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 16, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3672; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3673: dim3x3 mul
    gl64_t s1_3673_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3673_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3673_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3673 = (tmp3_0 + tmp3_1) * (s1_3673_0 + s1_3673_1);
    gl64_t kB3673 = (tmp3_0 + tmp3_2) * (s1_3673_0 + s1_3673_2);
    gl64_t kC3673 = (tmp3_1 + tmp3_2) * (s1_3673_1 + s1_3673_2);
    gl64_t kD3673 = tmp3_0 * s1_3673_0;
    gl64_t kE3673 = tmp3_1 * s1_3673_1;
    gl64_t kF3673 = tmp3_2 * s1_3673_2;
    gl64_t kG3673 = kD3673 - kE3673;
    tmp3_0 = (kC3673 + kG3673) - kF3673;
    tmp3_1 = ((((kA3673 + kC3673) - kE3673) - kE3673) - kD3673);
    tmp3_2 = kB3673 - kG3673;
    // Op 3674: dim3x1 add
    gl64_t s1_3674 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3674; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3675: dim3x3 add
    gl64_t s1_3675_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3675_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3675_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3675_0; tmp3_1 = tmp3_1 + s1_3675_1; tmp3_2 = tmp3_2 + s1_3675_2;
    // Op 3676: dim3x1 sub
    gl64_t s1_3676 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3676; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3677: dim3x1 add
    gl64_t s1_3677 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3677; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3678: dim3x3 mul
    gl64_t kA3678 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3678 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3678 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3678 = tmp3_3 * tmp3_0;
    gl64_t kE3678 = tmp3_4 * tmp3_1;
    gl64_t kF3678 = tmp3_5 * tmp3_2;
    gl64_t kG3678 = kD3678 - kE3678;
    tmp3_3 = (kC3678 + kG3678) - kF3678;
    tmp3_4 = ((((kA3678 + kC3678) - kE3678) - kE3678) - kD3678);
    tmp3_5 = kB3678 - kG3678;
    // Op 3679: dim3x1 mul
    gl64_t s0_3679_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3679_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3679_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3679 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_0)];
    tmp3_0 = s0_3679_0 * s1_3679; tmp3_1 = s0_3679_1 * s1_3679; tmp3_2 = s0_3679_2 * s1_3679;
    // Op 3680: dim3x1 add
    gl64_t s1_3680 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 17, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3680; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3681: dim3x3 mul
    gl64_t s1_3681_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3681_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3681_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3681 = (tmp3_0 + tmp3_1) * (s1_3681_0 + s1_3681_1);
    gl64_t kB3681 = (tmp3_0 + tmp3_2) * (s1_3681_0 + s1_3681_2);
    gl64_t kC3681 = (tmp3_1 + tmp3_2) * (s1_3681_1 + s1_3681_2);
    gl64_t kD3681 = tmp3_0 * s1_3681_0;
    gl64_t kE3681 = tmp3_1 * s1_3681_1;
    gl64_t kF3681 = tmp3_2 * s1_3681_2;
    gl64_t kG3681 = kD3681 - kE3681;
    tmp3_0 = (kC3681 + kG3681) - kF3681;
    tmp3_1 = ((((kA3681 + kC3681) - kE3681) - kE3681) - kD3681);
    tmp3_2 = kB3681 - kG3681;
    // Op 3682: dim3x1 add
    gl64_t s1_3682 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3682; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3683: dim3x3 add
    gl64_t s1_3683_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3683_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3683_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3683_0; tmp3_1 = tmp3_1 + s1_3683_1; tmp3_2 = tmp3_2 + s1_3683_2;
    // Op 3684: dim3x1 sub
    gl64_t s1_3684 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3684; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3685: dim3x1 add
    gl64_t s1_3685 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3685; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3686: dim3x3 mul
    gl64_t kA3686 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3686 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3686 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3686 = tmp3_3 * tmp3_0;
    gl64_t kE3686 = tmp3_4 * tmp3_1;
    gl64_t kF3686 = tmp3_5 * tmp3_2;
    gl64_t kG3686 = kD3686 - kE3686;
    tmp3_3 = (kC3686 + kG3686) - kF3686;
    tmp3_4 = ((((kA3686 + kC3686) - kE3686) - kE3686) - kD3686);
    tmp3_5 = kB3686 - kG3686;
    // Op 3687: dim3x1 mul
    gl64_t s0_3687_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3687_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3687_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3687 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 18, domainSize, nCols_0)];
    tmp3_0 = s0_3687_0 * s1_3687; tmp3_1 = s0_3687_1 * s1_3687; tmp3_2 = s0_3687_2 * s1_3687;
    // Op 3688: dim3x1 add
    gl64_t s1_3688 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 18, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3688; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3689: dim3x3 mul
    gl64_t s1_3689_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3689_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3689_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3689 = (tmp3_0 + tmp3_1) * (s1_3689_0 + s1_3689_1);
    gl64_t kB3689 = (tmp3_0 + tmp3_2) * (s1_3689_0 + s1_3689_2);
    gl64_t kC3689 = (tmp3_1 + tmp3_2) * (s1_3689_1 + s1_3689_2);
    gl64_t kD3689 = tmp3_0 * s1_3689_0;
    gl64_t kE3689 = tmp3_1 * s1_3689_1;
    gl64_t kF3689 = tmp3_2 * s1_3689_2;
    gl64_t kG3689 = kD3689 - kE3689;
    tmp3_0 = (kC3689 + kG3689) - kF3689;
    tmp3_1 = ((((kA3689 + kC3689) - kE3689) - kE3689) - kD3689);
    tmp3_2 = kB3689 - kG3689;
    // Op 3690: dim3x1 add
    gl64_t s1_3690 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3690; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3691: dim3x3 add
    gl64_t s1_3691_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3691_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3691_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3691_0; tmp3_1 = tmp3_1 + s1_3691_1; tmp3_2 = tmp3_2 + s1_3691_2;
    // Op 3692: dim3x1 sub
    gl64_t s1_3692 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3692; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3693: dim3x1 add
    gl64_t s1_3693 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3693; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3694: dim3x3 mul
    gl64_t kA3694 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3694 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3694 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3694 = tmp3_3 * tmp3_0;
    gl64_t kE3694 = tmp3_4 * tmp3_1;
    gl64_t kF3694 = tmp3_5 * tmp3_2;
    gl64_t kG3694 = kD3694 - kE3694;
    tmp3_3 = (kC3694 + kG3694) - kF3694;
    tmp3_4 = ((((kA3694 + kC3694) - kE3694) - kE3694) - kD3694);
    tmp3_5 = kB3694 - kG3694;
    // Op 3695: dim3x1 mul
    gl64_t s0_3695_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3695_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3695_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3695 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 19, domainSize, nCols_0)];
    tmp3_0 = s0_3695_0 * s1_3695; tmp3_1 = s0_3695_1 * s1_3695; tmp3_2 = s0_3695_2 * s1_3695;
    // Op 3696: dim3x1 add
    gl64_t s1_3696 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 19, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3696; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3697: dim3x3 mul
    gl64_t s1_3697_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3697_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3697_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3697 = (tmp3_0 + tmp3_1) * (s1_3697_0 + s1_3697_1);
    gl64_t kB3697 = (tmp3_0 + tmp3_2) * (s1_3697_0 + s1_3697_2);
    gl64_t kC3697 = (tmp3_1 + tmp3_2) * (s1_3697_1 + s1_3697_2);
    gl64_t kD3697 = tmp3_0 * s1_3697_0;
    gl64_t kE3697 = tmp3_1 * s1_3697_1;
    gl64_t kF3697 = tmp3_2 * s1_3697_2;
    gl64_t kG3697 = kD3697 - kE3697;
    tmp3_0 = (kC3697 + kG3697) - kF3697;
    tmp3_1 = ((((kA3697 + kC3697) - kE3697) - kE3697) - kD3697);
    tmp3_2 = kB3697 - kG3697;
    // Op 3698: dim3x1 add
    gl64_t s1_3698 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3698; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3699: dim3x3 add
    gl64_t s1_3699_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3699_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3699_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3699_0; tmp3_1 = tmp3_1 + s1_3699_1; tmp3_2 = tmp3_2 + s1_3699_2;
    // Op 3700: dim3x1 sub
    gl64_t s1_3700 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3700; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3701: dim3x1 add
    gl64_t s1_3701 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3701; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3702: dim3x3 mul
    gl64_t kA3702 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3702 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3702 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3702 = tmp3_3 * tmp3_0;
    gl64_t kE3702 = tmp3_4 * tmp3_1;
    gl64_t kF3702 = tmp3_5 * tmp3_2;
    gl64_t kG3702 = kD3702 - kE3702;
    tmp3_3 = (kC3702 + kG3702) - kF3702;
    tmp3_4 = ((((kA3702 + kC3702) - kE3702) - kE3702) - kD3702);
    tmp3_5 = kB3702 - kG3702;
    // Op 3703: dim3x1 mul
    gl64_t s0_3703_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3703_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3703_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3703 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 20, domainSize, nCols_0)];
    tmp3_0 = s0_3703_0 * s1_3703; tmp3_1 = s0_3703_1 * s1_3703; tmp3_2 = s0_3703_2 * s1_3703;
    // Op 3704: dim3x1 add
    gl64_t s1_3704 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 20, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3704; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3705: dim3x3 mul
    gl64_t s1_3705_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3705_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3705_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3705 = (tmp3_0 + tmp3_1) * (s1_3705_0 + s1_3705_1);
    gl64_t kB3705 = (tmp3_0 + tmp3_2) * (s1_3705_0 + s1_3705_2);
    gl64_t kC3705 = (tmp3_1 + tmp3_2) * (s1_3705_1 + s1_3705_2);
    gl64_t kD3705 = tmp3_0 * s1_3705_0;
    gl64_t kE3705 = tmp3_1 * s1_3705_1;
    gl64_t kF3705 = tmp3_2 * s1_3705_2;
    gl64_t kG3705 = kD3705 - kE3705;
    tmp3_0 = (kC3705 + kG3705) - kF3705;
    tmp3_1 = ((((kA3705 + kC3705) - kE3705) - kE3705) - kD3705);
    tmp3_2 = kB3705 - kG3705;
    // Op 3706: dim3x1 add
    gl64_t s1_3706 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3706; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3707: dim3x3 add
    gl64_t s1_3707_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3707_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3707_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3707_0; tmp3_1 = tmp3_1 + s1_3707_1; tmp3_2 = tmp3_2 + s1_3707_2;
    // Op 3708: dim3x1 sub
    gl64_t s1_3708 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3708; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3709: dim3x1 add
    gl64_t s1_3709 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3709; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3710: dim3x3 mul
    gl64_t kA3710 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3710 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3710 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3710 = tmp3_3 * tmp3_0;
    gl64_t kE3710 = tmp3_4 * tmp3_1;
    gl64_t kF3710 = tmp3_5 * tmp3_2;
    gl64_t kG3710 = kD3710 - kE3710;
    tmp3_3 = (kC3710 + kG3710) - kF3710;
    tmp3_4 = ((((kA3710 + kC3710) - kE3710) - kE3710) - kD3710);
    tmp3_5 = kB3710 - kG3710;
    // Op 3711: dim3x1 mul
    gl64_t s0_3711_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3711_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3711_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3711 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 21, domainSize, nCols_0)];
    tmp3_0 = s0_3711_0 * s1_3711; tmp3_1 = s0_3711_1 * s1_3711; tmp3_2 = s0_3711_2 * s1_3711;
    // Op 3712: dim3x1 add
    gl64_t s1_3712 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 21, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3712; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3713: dim3x3 mul
    gl64_t s1_3713_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3713_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3713_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3713 = (tmp3_0 + tmp3_1) * (s1_3713_0 + s1_3713_1);
    gl64_t kB3713 = (tmp3_0 + tmp3_2) * (s1_3713_0 + s1_3713_2);
    gl64_t kC3713 = (tmp3_1 + tmp3_2) * (s1_3713_1 + s1_3713_2);
    gl64_t kD3713 = tmp3_0 * s1_3713_0;
    gl64_t kE3713 = tmp3_1 * s1_3713_1;
    gl64_t kF3713 = tmp3_2 * s1_3713_2;
    gl64_t kG3713 = kD3713 - kE3713;
    tmp3_0 = (kC3713 + kG3713) - kF3713;
    tmp3_1 = ((((kA3713 + kC3713) - kE3713) - kE3713) - kD3713);
    tmp3_2 = kB3713 - kG3713;
    // Op 3714: dim3x1 add
    gl64_t s1_3714 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3714; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3715: dim3x3 add
    gl64_t s1_3715_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3715_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3715_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3715_0; tmp3_1 = tmp3_1 + s1_3715_1; tmp3_2 = tmp3_2 + s1_3715_2;
    // Op 3716: dim3x1 sub
    gl64_t s1_3716 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3716; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3717: dim3x1 add
    gl64_t s1_3717 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3717; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3718: dim3x3 mul
    gl64_t kA3718 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB3718 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC3718 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD3718 = tmp3_3 * tmp3_0;
    gl64_t kE3718 = tmp3_4 * tmp3_1;
    gl64_t kF3718 = tmp3_5 * tmp3_2;
    gl64_t kG3718 = kD3718 - kE3718;
    tmp3_0 = (kC3718 + kG3718) - kF3718;
    tmp3_1 = ((((kA3718 + kC3718) - kE3718) - kE3718) - kD3718);
    tmp3_2 = kB3718 - kG3718;
    // Op 3719: dim3x3 sub
    tmp3_0 = tmp3_6 - tmp3_0; tmp3_1 = tmp3_7 - tmp3_1; tmp3_2 = tmp3_8 - tmp3_2;
    // Op 3720: dim3x3 add
    tmp3_0 = tmp3_9 + tmp3_0; tmp3_1 = tmp3_10 + tmp3_1; tmp3_2 = tmp3_11 + tmp3_2;
    // Op 3721: dim3x3 mul
    gl64_t s1_3721_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3721_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3721_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3721 = (tmp3_0 + tmp3_1) * (s1_3721_0 + s1_3721_1);
    gl64_t kB3721 = (tmp3_0 + tmp3_2) * (s1_3721_0 + s1_3721_2);
    gl64_t kC3721 = (tmp3_1 + tmp3_2) * (s1_3721_1 + s1_3721_2);
    gl64_t kD3721 = tmp3_0 * s1_3721_0;
    gl64_t kE3721 = tmp3_1 * s1_3721_1;
    gl64_t kF3721 = tmp3_2 * s1_3721_2;
    gl64_t kG3721 = kD3721 - kE3721;
    tmp3_12 = (kC3721 + kG3721) - kF3721;
    tmp3_13 = ((((kA3721 + kC3721) - kE3721) - kE3721) - kD3721);
    tmp3_14 = kB3721 - kG3721;
    // Op 3722: dim1x1 mul
    gl64_t s0_3722 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3722 = *(gl64_t*)&expressions_params[9][20];
    tmp1_2 = s0_3722 * s1_3722;
    // Op 3723: dim3x1 mul
    gl64_t s0_3723_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3723_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3723_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3723_0 * tmp1_2; tmp3_1 = s0_3723_1 * tmp1_2; tmp3_2 = s0_3723_2 * tmp1_2;
    // Op 3724: dim3x1 add
    gl64_t s1_3724 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 21, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3724; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3725: dim3x3 mul
    gl64_t s1_3725_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3725_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3725_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3725 = (tmp3_0 + tmp3_1) * (s1_3725_0 + s1_3725_1);
    gl64_t kB3725 = (tmp3_0 + tmp3_2) * (s1_3725_0 + s1_3725_2);
    gl64_t kC3725 = (tmp3_1 + tmp3_2) * (s1_3725_1 + s1_3725_2);
    gl64_t kD3725 = tmp3_0 * s1_3725_0;
    gl64_t kE3725 = tmp3_1 * s1_3725_1;
    gl64_t kF3725 = tmp3_2 * s1_3725_2;
    gl64_t kG3725 = kD3725 - kE3725;
    tmp3_0 = (kC3725 + kG3725) - kF3725;
    tmp3_1 = ((((kA3725 + kC3725) - kE3725) - kE3725) - kD3725);
    tmp3_2 = kB3725 - kG3725;
    // Op 3726: dim3x1 add
    gl64_t s1_3726 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3726; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3727: dim3x3 add
    gl64_t s1_3727_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3727_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3727_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3727_0; tmp3_1 = tmp3_1 + s1_3727_1; tmp3_2 = tmp3_2 + s1_3727_2;
    // Op 3728: dim3x1 sub
    gl64_t s1_3728 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3728; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3729: dim3x1 add
    gl64_t s1_3729 = *(gl64_t*)&expressions_params[9][26];
    tmp3_9 = tmp3_0 + s1_3729; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 3730: dim1x1 mul
    gl64_t s0_3730 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3730 = *(gl64_t*)&expressions_params[9][21];
    tmp1_2 = s0_3730 * s1_3730;
    // Op 3731: dim3x1 mul
    gl64_t s0_3731_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3731_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3731_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3731_0 * tmp1_2; tmp3_1 = s0_3731_1 * tmp1_2; tmp3_2 = s0_3731_2 * tmp1_2;
    // Op 3732: dim3x1 add
    gl64_t s1_3732 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 22, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3732; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3733: dim3x3 mul
    gl64_t s1_3733_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3733_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3733_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3733 = (tmp3_0 + tmp3_1) * (s1_3733_0 + s1_3733_1);
    gl64_t kB3733 = (tmp3_0 + tmp3_2) * (s1_3733_0 + s1_3733_2);
    gl64_t kC3733 = (tmp3_1 + tmp3_2) * (s1_3733_1 + s1_3733_2);
    gl64_t kD3733 = tmp3_0 * s1_3733_0;
    gl64_t kE3733 = tmp3_1 * s1_3733_1;
    gl64_t kF3733 = tmp3_2 * s1_3733_2;
    gl64_t kG3733 = kD3733 - kE3733;
    tmp3_0 = (kC3733 + kG3733) - kF3733;
    tmp3_1 = ((((kA3733 + kC3733) - kE3733) - kE3733) - kD3733);
    tmp3_2 = kB3733 - kG3733;
    // Op 3734: dim3x1 add
    gl64_t s1_3734 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3734; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3735: dim3x3 add
    gl64_t s1_3735_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3735_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3735_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3735_0; tmp3_1 = tmp3_1 + s1_3735_1; tmp3_2 = tmp3_2 + s1_3735_2;
    // Op 3736: dim3x1 sub
    gl64_t s1_3736 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3736; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3737: dim3x1 add
    gl64_t s1_3737 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3737; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3738: dim3x3 mul
    gl64_t kA3738 = (tmp3_9 + tmp3_10) * (tmp3_0 + tmp3_1);
    gl64_t kB3738 = (tmp3_9 + tmp3_11) * (tmp3_0 + tmp3_2);
    gl64_t kC3738 = (tmp3_10 + tmp3_11) * (tmp3_1 + tmp3_2);
    gl64_t kD3738 = tmp3_9 * tmp3_0;
    gl64_t kE3738 = tmp3_10 * tmp3_1;
    gl64_t kF3738 = tmp3_11 * tmp3_2;
    gl64_t kG3738 = kD3738 - kE3738;
    tmp3_9 = (kC3738 + kG3738) - kF3738;
    tmp3_10 = ((((kA3738 + kC3738) - kE3738) - kE3738) - kD3738);
    tmp3_11 = kB3738 - kG3738;
    // Op 3739: dim1x1 mul
    gl64_t s0_3739 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3739 = *(gl64_t*)&expressions_params[9][22];
    tmp1_2 = s0_3739 * s1_3739;
    // Op 3740: dim3x1 mul
    gl64_t s0_3740_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3740_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3740_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3740_0 * tmp1_2; tmp3_1 = s0_3740_1 * tmp1_2; tmp3_2 = s0_3740_2 * tmp1_2;
    // Op 3741: dim3x1 add
    gl64_t s1_3741 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 23, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3741; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3742: dim3x3 mul
    gl64_t s1_3742_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3742_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3742_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3742 = (tmp3_0 + tmp3_1) * (s1_3742_0 + s1_3742_1);
    gl64_t kB3742 = (tmp3_0 + tmp3_2) * (s1_3742_0 + s1_3742_2);
    gl64_t kC3742 = (tmp3_1 + tmp3_2) * (s1_3742_1 + s1_3742_2);
    gl64_t kD3742 = tmp3_0 * s1_3742_0;
    gl64_t kE3742 = tmp3_1 * s1_3742_1;
    gl64_t kF3742 = tmp3_2 * s1_3742_2;
    gl64_t kG3742 = kD3742 - kE3742;
    tmp3_0 = (kC3742 + kG3742) - kF3742;
    tmp3_1 = ((((kA3742 + kC3742) - kE3742) - kE3742) - kD3742);
    tmp3_2 = kB3742 - kG3742;
    // Op 3743: dim3x1 add
    gl64_t s1_3743 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3743; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3744: dim3x3 add
    gl64_t s1_3744_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3744_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3744_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3744_0; tmp3_1 = tmp3_1 + s1_3744_1; tmp3_2 = tmp3_2 + s1_3744_2;
    // Op 3745: dim3x1 sub
    gl64_t s1_3745 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3745; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3746: dim3x1 add
    gl64_t s1_3746 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3746; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3747: dim3x3 mul
    gl64_t kA3747 = (tmp3_9 + tmp3_10) * (tmp3_0 + tmp3_1);
    gl64_t kB3747 = (tmp3_9 + tmp3_11) * (tmp3_0 + tmp3_2);
    gl64_t kC3747 = (tmp3_10 + tmp3_11) * (tmp3_1 + tmp3_2);
    gl64_t kD3747 = tmp3_9 * tmp3_0;
    gl64_t kE3747 = tmp3_10 * tmp3_1;
    gl64_t kF3747 = tmp3_11 * tmp3_2;
    gl64_t kG3747 = kD3747 - kE3747;
    tmp3_9 = (kC3747 + kG3747) - kF3747;
    tmp3_10 = ((((kA3747 + kC3747) - kE3747) - kE3747) - kD3747);
    tmp3_11 = kB3747 - kG3747;
    // Op 3748: dim1x1 mul
    gl64_t s0_3748 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3748 = *(gl64_t*)&expressions_params[9][23];
    tmp1_2 = s0_3748 * s1_3748;
    // Op 3749: dim3x1 mul
    gl64_t s0_3749_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3749_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3749_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3749_0 * tmp1_2; tmp3_1 = s0_3749_1 * tmp1_2; tmp3_2 = s0_3749_2 * tmp1_2;
    // Op 3750: dim3x1 add
    gl64_t s1_3750 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 24, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3750; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3751: dim3x3 mul
    gl64_t s1_3751_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3751_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3751_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3751 = (tmp3_0 + tmp3_1) * (s1_3751_0 + s1_3751_1);
    gl64_t kB3751 = (tmp3_0 + tmp3_2) * (s1_3751_0 + s1_3751_2);
    gl64_t kC3751 = (tmp3_1 + tmp3_2) * (s1_3751_1 + s1_3751_2);
    gl64_t kD3751 = tmp3_0 * s1_3751_0;
    gl64_t kE3751 = tmp3_1 * s1_3751_1;
    gl64_t kF3751 = tmp3_2 * s1_3751_2;
    gl64_t kG3751 = kD3751 - kE3751;
    tmp3_0 = (kC3751 + kG3751) - kF3751;
    tmp3_1 = ((((kA3751 + kC3751) - kE3751) - kE3751) - kD3751);
    tmp3_2 = kB3751 - kG3751;
    // Op 3752: dim3x1 add
    gl64_t s1_3752 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3752; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3753: dim3x3 add
    gl64_t s1_3753_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3753_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3753_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3753_0; tmp3_1 = tmp3_1 + s1_3753_1; tmp3_2 = tmp3_2 + s1_3753_2;
    // Op 3754: dim3x1 sub
    gl64_t s1_3754 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3754; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3755: dim3x1 add
    gl64_t s1_3755 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3755; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3756: dim3x3 mul
    gl64_t kA3756 = (tmp3_9 + tmp3_10) * (tmp3_0 + tmp3_1);
    gl64_t kB3756 = (tmp3_9 + tmp3_11) * (tmp3_0 + tmp3_2);
    gl64_t kC3756 = (tmp3_10 + tmp3_11) * (tmp3_1 + tmp3_2);
    gl64_t kD3756 = tmp3_9 * tmp3_0;
    gl64_t kE3756 = tmp3_10 * tmp3_1;
    gl64_t kF3756 = tmp3_11 * tmp3_2;
    gl64_t kG3756 = kD3756 - kE3756;
    tmp3_9 = (kC3756 + kG3756) - kF3756;
    tmp3_10 = ((((kA3756 + kC3756) - kE3756) - kE3756) - kD3756);
    tmp3_11 = kB3756 - kG3756;
    // Op 3757: dim1x1 mul
    gl64_t s0_3757 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3757 = *(gl64_t*)&expressions_params[9][24];
    tmp1_2 = s0_3757 * s1_3757;
    // Op 3758: dim3x1 mul
    gl64_t s0_3758_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3758_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3758_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3758_0 * tmp1_2; tmp3_1 = s0_3758_1 * tmp1_2; tmp3_2 = s0_3758_2 * tmp1_2;
    // Op 3759: dim3x1 add
    gl64_t s1_3759 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 25, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3759; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3760: dim3x3 mul
    gl64_t s1_3760_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3760_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3760_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3760 = (tmp3_0 + tmp3_1) * (s1_3760_0 + s1_3760_1);
    gl64_t kB3760 = (tmp3_0 + tmp3_2) * (s1_3760_0 + s1_3760_2);
    gl64_t kC3760 = (tmp3_1 + tmp3_2) * (s1_3760_1 + s1_3760_2);
    gl64_t kD3760 = tmp3_0 * s1_3760_0;
    gl64_t kE3760 = tmp3_1 * s1_3760_1;
    gl64_t kF3760 = tmp3_2 * s1_3760_2;
    gl64_t kG3760 = kD3760 - kE3760;
    tmp3_0 = (kC3760 + kG3760) - kF3760;
    tmp3_1 = ((((kA3760 + kC3760) - kE3760) - kE3760) - kD3760);
    tmp3_2 = kB3760 - kG3760;
    // Op 3761: dim3x1 add
    gl64_t s1_3761 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3761; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3762: dim3x3 add
    gl64_t s1_3762_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3762_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3762_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3762_0; tmp3_1 = tmp3_1 + s1_3762_1; tmp3_2 = tmp3_2 + s1_3762_2;
    // Op 3763: dim3x1 sub
    gl64_t s1_3763 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3763; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3764: dim3x1 add
    gl64_t s1_3764 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3764; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3765: dim3x3 mul
    gl64_t kA3765 = (tmp3_9 + tmp3_10) * (tmp3_0 + tmp3_1);
    gl64_t kB3765 = (tmp3_9 + tmp3_11) * (tmp3_0 + tmp3_2);
    gl64_t kC3765 = (tmp3_10 + tmp3_11) * (tmp3_1 + tmp3_2);
    gl64_t kD3765 = tmp3_9 * tmp3_0;
    gl64_t kE3765 = tmp3_10 * tmp3_1;
    gl64_t kF3765 = tmp3_11 * tmp3_2;
    gl64_t kG3765 = kD3765 - kE3765;
    tmp3_9 = (kC3765 + kG3765) - kF3765;
    tmp3_10 = ((((kA3765 + kC3765) - kE3765) - kE3765) - kD3765);
    tmp3_11 = kB3765 - kG3765;
    // Op 3766: dim1x1 mul
    gl64_t s0_3766 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 47, domainSize, nCols_0)];
    gl64_t s1_3766 = *(gl64_t*)&expressions_params[9][25];
    tmp1_2 = s0_3766 * s1_3766;
    // Op 3767: dim3x1 mul
    gl64_t s0_3767_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3767_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3767_2 = *(gl64_t*)&expressions_params[13][0+2];
    tmp3_0 = s0_3767_0 * tmp1_2; tmp3_1 = s0_3767_1 * tmp1_2; tmp3_2 = s0_3767_2 * tmp1_2;
    // Op 3768: dim3x1 add
    gl64_t s1_3768 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 26, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3768; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3769: dim3x3 mul
    gl64_t s1_3769_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3769_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3769_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3769 = (tmp3_0 + tmp3_1) * (s1_3769_0 + s1_3769_1);
    gl64_t kB3769 = (tmp3_0 + tmp3_2) * (s1_3769_0 + s1_3769_2);
    gl64_t kC3769 = (tmp3_1 + tmp3_2) * (s1_3769_1 + s1_3769_2);
    gl64_t kD3769 = tmp3_0 * s1_3769_0;
    gl64_t kE3769 = tmp3_1 * s1_3769_1;
    gl64_t kF3769 = tmp3_2 * s1_3769_2;
    gl64_t kG3769 = kD3769 - kE3769;
    tmp3_0 = (kC3769 + kG3769) - kF3769;
    tmp3_1 = ((((kA3769 + kC3769) - kE3769) - kE3769) - kD3769);
    tmp3_2 = kB3769 - kG3769;
    // Op 3770: dim3x1 add
    gl64_t s1_3770 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3770; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3771: dim3x3 add
    gl64_t s1_3771_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3771_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3771_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3771_0; tmp3_1 = tmp3_1 + s1_3771_1; tmp3_2 = tmp3_2 + s1_3771_2;
    // Op 3772: dim3x1 sub
    gl64_t s1_3772 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3772; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3773: dim3x1 add
    gl64_t s1_3773 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3773; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3774: dim3x3 mul
    gl64_t kA3774 = (tmp3_9 + tmp3_10) * (tmp3_0 + tmp3_1);
    gl64_t kB3774 = (tmp3_9 + tmp3_11) * (tmp3_0 + tmp3_2);
    gl64_t kC3774 = (tmp3_10 + tmp3_11) * (tmp3_1 + tmp3_2);
    gl64_t kD3774 = tmp3_9 * tmp3_0;
    gl64_t kE3774 = tmp3_10 * tmp3_1;
    gl64_t kF3774 = tmp3_11 * tmp3_2;
    gl64_t kG3774 = kD3774 - kE3774;
    tmp3_0 = (kC3774 + kG3774) - kF3774;
    tmp3_1 = ((((kA3774 + kC3774) - kE3774) - kE3774) - kD3774);
    tmp3_2 = kB3774 - kG3774;
    // Op 3775: dim3x3 mul
    uint64_t s0_3775_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_2));
    gl64_t s0_3775_0 = *(gl64_t*)&dParams->aux_trace[s0_3775_pos];
    gl64_t s0_3775_1 = *(gl64_t*)&dParams->aux_trace[s0_3775_pos + TILE_HEIGHT];
    gl64_t s0_3775_2 = *(gl64_t*)&dParams->aux_trace[s0_3775_pos + 2*TILE_HEIGHT];
    gl64_t kA3775 = (s0_3775_0 + s0_3775_1) * (tmp3_0 + tmp3_1);
    gl64_t kB3775 = (s0_3775_0 + s0_3775_2) * (tmp3_0 + tmp3_2);
    gl64_t kC3775 = (s0_3775_1 + s0_3775_2) * (tmp3_1 + tmp3_2);
    gl64_t kD3775 = s0_3775_0 * tmp3_0;
    gl64_t kE3775 = s0_3775_1 * tmp3_1;
    gl64_t kF3775 = s0_3775_2 * tmp3_2;
    gl64_t kG3775 = kD3775 - kE3775;
    tmp3_3 = (kC3775 + kG3775) - kF3775;
    tmp3_4 = ((((kA3775 + kC3775) - kE3775) - kE3775) - kD3775);
    tmp3_5 = kB3775 - kG3775;
    // Op 3776: dim1x1 sub_swap
    gl64_t s0_3776 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 48, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 48, domainSize, nCols_0)];
    gl64_t s1_3776 = *(gl64_t*)&expressions_params[9][26];
    tmp1_2 = s1_3776 - s0_3776;
    // Op 3777: dim3x1 mul
    uint64_t s0_3777_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_3777_0 = *(gl64_t*)&dParams->aux_trace[s0_3777_pos];
    gl64_t s0_3777_1 = *(gl64_t*)&dParams->aux_trace[s0_3777_pos + TILE_HEIGHT];
    gl64_t s0_3777_2 = *(gl64_t*)&dParams->aux_trace[s0_3777_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_3777_0 * tmp1_2; tmp3_1 = s0_3777_1 * tmp1_2; tmp3_2 = s0_3777_2 * tmp1_2;
    // Op 3778: dim3x1 add
    gl64_t s1_3778 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 48, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 48, domainSize, nCols_0)];
    tmp3_6 = tmp3_0 + s1_3778; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 3779: dim3x1 mul
    gl64_t s0_3779_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3779_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3779_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3779 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 22, domainSize, nCols_0)];
    tmp3_0 = s0_3779_0 * s1_3779; tmp3_1 = s0_3779_1 * s1_3779; tmp3_2 = s0_3779_2 * s1_3779;
    // Op 3780: dim3x1 add
    gl64_t s1_3780 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 22, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3780; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3781: dim3x3 mul
    gl64_t s1_3781_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3781_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3781_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3781 = (tmp3_0 + tmp3_1) * (s1_3781_0 + s1_3781_1);
    gl64_t kB3781 = (tmp3_0 + tmp3_2) * (s1_3781_0 + s1_3781_2);
    gl64_t kC3781 = (tmp3_1 + tmp3_2) * (s1_3781_1 + s1_3781_2);
    gl64_t kD3781 = tmp3_0 * s1_3781_0;
    gl64_t kE3781 = tmp3_1 * s1_3781_1;
    gl64_t kF3781 = tmp3_2 * s1_3781_2;
    gl64_t kG3781 = kD3781 - kE3781;
    tmp3_0 = (kC3781 + kG3781) - kF3781;
    tmp3_1 = ((((kA3781 + kC3781) - kE3781) - kE3781) - kD3781);
    tmp3_2 = kB3781 - kG3781;
    // Op 3782: dim3x1 add
    gl64_t s1_3782 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3782; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3783: dim3x3 add
    gl64_t s1_3783_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3783_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3783_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3783_0; tmp3_1 = tmp3_1 + s1_3783_1; tmp3_2 = tmp3_2 + s1_3783_2;
    // Op 3784: dim3x1 sub
    gl64_t s1_3784 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3784; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3785: dim3x1 add
    gl64_t s1_3785 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3785; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3786: dim3x3 mul
    uint64_t s0_3786_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_2, 9, domainSize, nCols_2));
    gl64_t s0_3786_0 = *(gl64_t*)&dParams->aux_trace[s0_3786_pos];
    gl64_t s0_3786_1 = *(gl64_t*)&dParams->aux_trace[s0_3786_pos + TILE_HEIGHT];
    gl64_t s0_3786_2 = *(gl64_t*)&dParams->aux_trace[s0_3786_pos + 2*TILE_HEIGHT];
    gl64_t kA3786 = (s0_3786_0 + s0_3786_1) * (tmp3_0 + tmp3_1);
    gl64_t kB3786 = (s0_3786_0 + s0_3786_2) * (tmp3_0 + tmp3_2);
    gl64_t kC3786 = (s0_3786_1 + s0_3786_2) * (tmp3_1 + tmp3_2);
    gl64_t kD3786 = s0_3786_0 * tmp3_0;
    gl64_t kE3786 = s0_3786_1 * tmp3_1;
    gl64_t kF3786 = s0_3786_2 * tmp3_2;
    gl64_t kG3786 = kD3786 - kE3786;
    tmp3_9 = (kC3786 + kG3786) - kF3786;
    tmp3_10 = ((((kA3786 + kC3786) - kE3786) - kE3786) - kD3786);
    tmp3_11 = kB3786 - kG3786;
    // Op 3787: dim3x1 mul
    gl64_t s0_3787_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3787_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3787_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3787 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 23, domainSize, nCols_0)];
    tmp3_0 = s0_3787_0 * s1_3787; tmp3_1 = s0_3787_1 * s1_3787; tmp3_2 = s0_3787_2 * s1_3787;
    // Op 3788: dim3x1 add
    gl64_t s1_3788 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 23, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3788; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3789: dim3x3 mul
    gl64_t s1_3789_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3789_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3789_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3789 = (tmp3_0 + tmp3_1) * (s1_3789_0 + s1_3789_1);
    gl64_t kB3789 = (tmp3_0 + tmp3_2) * (s1_3789_0 + s1_3789_2);
    gl64_t kC3789 = (tmp3_1 + tmp3_2) * (s1_3789_1 + s1_3789_2);
    gl64_t kD3789 = tmp3_0 * s1_3789_0;
    gl64_t kE3789 = tmp3_1 * s1_3789_1;
    gl64_t kF3789 = tmp3_2 * s1_3789_2;
    gl64_t kG3789 = kD3789 - kE3789;
    tmp3_0 = (kC3789 + kG3789) - kF3789;
    tmp3_1 = ((((kA3789 + kC3789) - kE3789) - kE3789) - kD3789);
    tmp3_2 = kB3789 - kG3789;
    // Op 3790: dim3x1 add
    gl64_t s1_3790 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3790; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3791: dim3x3 add
    gl64_t s1_3791_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3791_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3791_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3791_0; tmp3_1 = tmp3_1 + s1_3791_1; tmp3_2 = tmp3_2 + s1_3791_2;
    // Op 3792: dim3x1 sub
    gl64_t s1_3792 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3792; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3793: dim3x1 add
    gl64_t s1_3793 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3793; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3794: dim3x3 mul
    gl64_t kA3794 = (tmp3_9 + tmp3_10) * (tmp3_0 + tmp3_1);
    gl64_t kB3794 = (tmp3_9 + tmp3_11) * (tmp3_0 + tmp3_2);
    gl64_t kC3794 = (tmp3_10 + tmp3_11) * (tmp3_1 + tmp3_2);
    gl64_t kD3794 = tmp3_9 * tmp3_0;
    gl64_t kE3794 = tmp3_10 * tmp3_1;
    gl64_t kF3794 = tmp3_11 * tmp3_2;
    gl64_t kG3794 = kD3794 - kE3794;
    tmp3_9 = (kC3794 + kG3794) - kF3794;
    tmp3_10 = ((((kA3794 + kC3794) - kE3794) - kE3794) - kD3794);
    tmp3_11 = kB3794 - kG3794;
    // Op 3795: dim3x1 mul
    gl64_t s0_3795_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3795_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3795_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3795 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 24, domainSize, nCols_0)];
    tmp3_0 = s0_3795_0 * s1_3795; tmp3_1 = s0_3795_1 * s1_3795; tmp3_2 = s0_3795_2 * s1_3795;
    // Op 3796: dim3x1 add
    gl64_t s1_3796 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 24, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3796; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3797: dim3x3 mul
    gl64_t s1_3797_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3797_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3797_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3797 = (tmp3_0 + tmp3_1) * (s1_3797_0 + s1_3797_1);
    gl64_t kB3797 = (tmp3_0 + tmp3_2) * (s1_3797_0 + s1_3797_2);
    gl64_t kC3797 = (tmp3_1 + tmp3_2) * (s1_3797_1 + s1_3797_2);
    gl64_t kD3797 = tmp3_0 * s1_3797_0;
    gl64_t kE3797 = tmp3_1 * s1_3797_1;
    gl64_t kF3797 = tmp3_2 * s1_3797_2;
    gl64_t kG3797 = kD3797 - kE3797;
    tmp3_0 = (kC3797 + kG3797) - kF3797;
    tmp3_1 = ((((kA3797 + kC3797) - kE3797) - kE3797) - kD3797);
    tmp3_2 = kB3797 - kG3797;
    // Op 3798: dim3x1 add
    gl64_t s1_3798 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3798; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3799: dim3x3 add
    gl64_t s1_3799_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3799_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3799_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3799_0; tmp3_1 = tmp3_1 + s1_3799_1; tmp3_2 = tmp3_2 + s1_3799_2;
    // Op 3800: dim3x1 sub
    gl64_t s1_3800 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3800; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3801: dim3x1 add
    gl64_t s1_3801 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3801; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3802: dim3x3 mul
    gl64_t kA3802 = (tmp3_9 + tmp3_10) * (tmp3_0 + tmp3_1);
    gl64_t kB3802 = (tmp3_9 + tmp3_11) * (tmp3_0 + tmp3_2);
    gl64_t kC3802 = (tmp3_10 + tmp3_11) * (tmp3_1 + tmp3_2);
    gl64_t kD3802 = tmp3_9 * tmp3_0;
    gl64_t kE3802 = tmp3_10 * tmp3_1;
    gl64_t kF3802 = tmp3_11 * tmp3_2;
    gl64_t kG3802 = kD3802 - kE3802;
    tmp3_9 = (kC3802 + kG3802) - kF3802;
    tmp3_10 = ((((kA3802 + kC3802) - kE3802) - kE3802) - kD3802);
    tmp3_11 = kB3802 - kG3802;
    // Op 3803: dim3x1 mul
    gl64_t s0_3803_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3803_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3803_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3803 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 25, domainSize, nCols_0)];
    tmp3_0 = s0_3803_0 * s1_3803; tmp3_1 = s0_3803_1 * s1_3803; tmp3_2 = s0_3803_2 * s1_3803;
    // Op 3804: dim3x1 add
    gl64_t s1_3804 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 25, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3804; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3805: dim3x3 mul
    gl64_t s1_3805_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3805_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3805_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3805 = (tmp3_0 + tmp3_1) * (s1_3805_0 + s1_3805_1);
    gl64_t kB3805 = (tmp3_0 + tmp3_2) * (s1_3805_0 + s1_3805_2);
    gl64_t kC3805 = (tmp3_1 + tmp3_2) * (s1_3805_1 + s1_3805_2);
    gl64_t kD3805 = tmp3_0 * s1_3805_0;
    gl64_t kE3805 = tmp3_1 * s1_3805_1;
    gl64_t kF3805 = tmp3_2 * s1_3805_2;
    gl64_t kG3805 = kD3805 - kE3805;
    tmp3_0 = (kC3805 + kG3805) - kF3805;
    tmp3_1 = ((((kA3805 + kC3805) - kE3805) - kE3805) - kD3805);
    tmp3_2 = kB3805 - kG3805;
    // Op 3806: dim3x1 add
    gl64_t s1_3806 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3806; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3807: dim3x3 add
    gl64_t s1_3807_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3807_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3807_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3807_0; tmp3_1 = tmp3_1 + s1_3807_1; tmp3_2 = tmp3_2 + s1_3807_2;
    // Op 3808: dim3x1 sub
    gl64_t s1_3808 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3808; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3809: dim3x1 add
    gl64_t s1_3809 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3809; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3810: dim3x3 mul
    gl64_t kA3810 = (tmp3_9 + tmp3_10) * (tmp3_0 + tmp3_1);
    gl64_t kB3810 = (tmp3_9 + tmp3_11) * (tmp3_0 + tmp3_2);
    gl64_t kC3810 = (tmp3_10 + tmp3_11) * (tmp3_1 + tmp3_2);
    gl64_t kD3810 = tmp3_9 * tmp3_0;
    gl64_t kE3810 = tmp3_10 * tmp3_1;
    gl64_t kF3810 = tmp3_11 * tmp3_2;
    gl64_t kG3810 = kD3810 - kE3810;
    tmp3_9 = (kC3810 + kG3810) - kF3810;
    tmp3_10 = ((((kA3810 + kC3810) - kE3810) - kE3810) - kD3810);
    tmp3_11 = kB3810 - kG3810;
    // Op 3811: dim3x1 mul
    gl64_t s0_3811_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_3811_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_3811_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_3811 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_2 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 26, domainSize, nCols_0)];
    tmp3_0 = s0_3811_0 * s1_3811; tmp3_1 = s0_3811_1 * s1_3811; tmp3_2 = s0_3811_2 * s1_3811;
    // Op 3812: dim3x1 add
    gl64_t s1_3812 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_1) : getBufferOffset(logicalRow_2, 26, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 + s1_3812; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3813: dim3x3 mul
    gl64_t s1_3813_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_3813_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_3813_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA3813 = (tmp3_0 + tmp3_1) * (s1_3813_0 + s1_3813_1);
    gl64_t kB3813 = (tmp3_0 + tmp3_2) * (s1_3813_0 + s1_3813_2);
    gl64_t kC3813 = (tmp3_1 + tmp3_2) * (s1_3813_1 + s1_3813_2);
    gl64_t kD3813 = tmp3_0 * s1_3813_0;
    gl64_t kE3813 = tmp3_1 * s1_3813_1;
    gl64_t kF3813 = tmp3_2 * s1_3813_2;
    gl64_t kG3813 = kD3813 - kE3813;
    tmp3_0 = (kC3813 + kG3813) - kF3813;
    tmp3_1 = ((((kA3813 + kC3813) - kE3813) - kE3813) - kD3813);
    tmp3_2 = kB3813 - kG3813;
    // Op 3814: dim3x1 add
    gl64_t s1_3814 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3814; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3815: dim3x3 add
    gl64_t s1_3815_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_3815_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_3815_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_3815_0; tmp3_1 = tmp3_1 + s1_3815_1; tmp3_2 = tmp3_2 + s1_3815_2;
    // Op 3816: dim3x1 sub
    gl64_t s1_3816 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 - s1_3816; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3817: dim3x1 add
    gl64_t s1_3817 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = tmp3_0 + s1_3817; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 3818: dim3x3 mul
    gl64_t kA3818 = (tmp3_9 + tmp3_10) * (tmp3_0 + tmp3_1);
    gl64_t kB3818 = (tmp3_9 + tmp3_11) * (tmp3_0 + tmp3_2);
    gl64_t kC3818 = (tmp3_10 + tmp3_11) * (tmp3_1 + tmp3_2);
    gl64_t kD3818 = tmp3_9 * tmp3_0;
    gl64_t kE3818 = tmp3_10 * tmp3_1;
    gl64_t kF3818 = tmp3_11 * tmp3_2;
    gl64_t kG3818 = kD3818 - kE3818;
    tmp3_0 = (kC3818 + kG3818) - kF3818;
    tmp3_1 = ((((kA3818 + kC3818) - kE3818) - kE3818) - kD3818);
    tmp3_2 = kB3818 - kG3818;
    // Op 3819: dim3x3 mul
    gl64_t kA3819 = (tmp3_6 + tmp3_7) * (tmp3_0 + tmp3_1);
    gl64_t kB3819 = (tmp3_6 + tmp3_8) * (tmp3_0 + tmp3_2);
    gl64_t kC3819 = (tmp3_7 + tmp3_8) * (tmp3_1 + tmp3_2);
    gl64_t kD3819 = tmp3_6 * tmp3_0;
    gl64_t kE3819 = tmp3_7 * tmp3_1;
    gl64_t kF3819 = tmp3_8 * tmp3_2;
    gl64_t kG3819 = kD3819 - kE3819;
    tmp3_0 = (kC3819 + kG3819) - kF3819;
    tmp3_1 = ((((kA3819 + kC3819) - kE3819) - kE3819) - kD3819);
    tmp3_2 = kB3819 - kG3819;
    // Op 3820: dim3x3 sub
    tmp3_0 = tmp3_3 - tmp3_0; tmp3_1 = tmp3_4 - tmp3_1; tmp3_2 = tmp3_5 - tmp3_2;
    // Op 3821: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 3822: dim3x3 mul
    gl64_t s1_3822_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_3822_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_3822_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA3822 = (tmp3_0 + tmp3_1) * (s1_3822_0 + s1_3822_1);
    gl64_t kB3822 = (tmp3_0 + tmp3_2) * (s1_3822_0 + s1_3822_2);
    gl64_t kC3822 = (tmp3_1 + tmp3_2) * (s1_3822_1 + s1_3822_2);
    gl64_t kD3822 = tmp3_0 * s1_3822_0;
    gl64_t kE3822 = tmp3_1 * s1_3822_1;
    gl64_t kF3822 = tmp3_2 * s1_3822_2;
    gl64_t kG3822 = kD3822 - kE3822;
    tmp3_12 = (kC3822 + kG3822) - kF3822;
    tmp3_13 = ((((kA3822 + kC3822) - kE3822) - kE3822) - kD3822);
    tmp3_14 = kB3822 - kG3822;
    // Op 3823: dim3x1 sub_swap
    uint64_t s0_3823_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_2 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_2, 0, domainSize, nCols_2));
    gl64_t s0_3823_0 = *(gl64_t*)&dParams->aux_trace[s0_3823_pos];
    gl64_t s0_3823_1 = *(gl64_t*)&dParams->aux_trace[s0_3823_pos + TILE_HEIGHT];
    gl64_t s0_3823_2 = *(gl64_t*)&dParams->aux_trace[s0_3823_pos + 2*TILE_HEIGHT];
    gl64_t s1_3823 = *(gl64_t*)&expressions_params[9][26];
    tmp3_0 = s1_3823 - s0_3823_0; tmp3_1 = -(s0_3823_1); tmp3_2 = -(s0_3823_2);
    // Op 3824: dim3x1 mul
    gl64_t s1_3824 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 48, domainSize, nCols_0) : getBufferOffset(logicalRow_3, 48, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_3824; tmp3_1 = tmp3_1 * s1_3824; tmp3_2 = tmp3_2 * s1_3824;
    // Op 3825: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 3826: dim3x1 mul
    gl64_t s1_3826 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_3826; tmp3_1 = tmp3_1 * s1_3826; tmp3_2 = tmp3_2 * s1_3826;

    storePolynomial3__((ExpsArguments*)dExpsArgs, tmp3_0, tmp3_1, tmp3_2, row);
}
