// Auto-generated expression evaluator - matches load__() semantics exactly
// Q expressions: domainExtended=true always, type 1 goes through aux_trace

// Fingerprint: 0703bbda  nOps=184 nTemp1=1 nTemp3=5
#define GENERATED_EVAL_NOPS_0703bbda 184
#define GENERATED_EVAL_NTEMP1_0703bbda 1
#define GENERATED_EVAL_NTEMP3_0703bbda 5

template<bool IsCyclic>
__device__ __forceinline__ void eval_expr_0703bbda(
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

    // Register-resident temporaries: 1 tmp1 + 15 tmp3 slots
    gl64_t tmp1_0 = gl64_t(uint64_t(0));
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

    // Op 0: dim3x1 mul
    gl64_t s0_0_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_0_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_0_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_0 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 23, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 23, domainSize, nCols_0)];
    tmp3_0 = s0_0_0 * s1_0; tmp3_1 = s0_0_1 * s1_0; tmp3_2 = s0_0_2 * s1_0;
    // Op 1: dim3x1 add
    gl64_t s1_1 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 22, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 22, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_1; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 2: dim3x3 mul
    gl64_t s1_2_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_2_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_2_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA2 = (tmp3_0 + tmp3_1) * (s1_2_0 + s1_2_1);
    gl64_t kB2 = (tmp3_0 + tmp3_2) * (s1_2_0 + s1_2_2);
    gl64_t kC2 = (tmp3_1 + tmp3_2) * (s1_2_1 + s1_2_2);
    gl64_t kD2 = tmp3_0 * s1_2_0;
    gl64_t kE2 = tmp3_1 * s1_2_1;
    gl64_t kF2 = tmp3_2 * s1_2_2;
    gl64_t kG2 = kD2 - kE2;
    tmp3_0 = (kC2 + kG2) - kF2;
    tmp3_1 = ((((kA2 + kC2) - kE2) - kE2) - kD2);
    tmp3_2 = kB2 - kG2;
    // Op 3: dim3x1 add
    gl64_t s1_3 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 21, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 21, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_3; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 4: dim3x3 mul
    gl64_t s1_4_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_4_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_4_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA4 = (tmp3_0 + tmp3_1) * (s1_4_0 + s1_4_1);
    gl64_t kB4 = (tmp3_0 + tmp3_2) * (s1_4_0 + s1_4_2);
    gl64_t kC4 = (tmp3_1 + tmp3_2) * (s1_4_1 + s1_4_2);
    gl64_t kD4 = tmp3_0 * s1_4_0;
    gl64_t kE4 = tmp3_1 * s1_4_1;
    gl64_t kF4 = tmp3_2 * s1_4_2;
    gl64_t kG4 = kD4 - kE4;
    tmp3_0 = (kC4 + kG4) - kF4;
    tmp3_1 = ((((kA4 + kC4) - kE4) - kE4) - kD4);
    tmp3_2 = kB4 - kG4;
    // Op 5: dim3x1 add
    gl64_t s1_5 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 20, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 20, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_5; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 6: dim3x3 mul
    gl64_t s1_6_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_6_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_6_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 7: dim3x1 add
    gl64_t s1_7 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 19, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 19, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_7; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 8: dim3x3 mul
    gl64_t s1_8_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_8_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_8_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 9: dim3x1 add
    gl64_t s1_9 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 18, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 18, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_9; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 10: dim3x3 mul
    gl64_t s1_10_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_10_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_10_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 11: dim3x1 add
    gl64_t s1_11 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 17, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 17, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_11; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 12: dim3x3 mul
    gl64_t s1_12_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_12_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_12_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA12 = (tmp3_0 + tmp3_1) * (s1_12_0 + s1_12_1);
    gl64_t kB12 = (tmp3_0 + tmp3_2) * (s1_12_0 + s1_12_2);
    gl64_t kC12 = (tmp3_1 + tmp3_2) * (s1_12_1 + s1_12_2);
    gl64_t kD12 = tmp3_0 * s1_12_0;
    gl64_t kE12 = tmp3_1 * s1_12_1;
    gl64_t kF12 = tmp3_2 * s1_12_2;
    gl64_t kG12 = kD12 - kE12;
    tmp3_0 = (kC12 + kG12) - kF12;
    tmp3_1 = ((((kA12 + kC12) - kE12) - kE12) - kD12);
    tmp3_2 = kB12 - kG12;
    // Op 13: dim3x1 add
    gl64_t s1_13 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 16, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 16, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_13; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 14: dim3x3 mul
    gl64_t s1_14_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_14_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_14_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA14 = (tmp3_0 + tmp3_1) * (s1_14_0 + s1_14_1);
    gl64_t kB14 = (tmp3_0 + tmp3_2) * (s1_14_0 + s1_14_2);
    gl64_t kC14 = (tmp3_1 + tmp3_2) * (s1_14_1 + s1_14_2);
    gl64_t kD14 = tmp3_0 * s1_14_0;
    gl64_t kE14 = tmp3_1 * s1_14_1;
    gl64_t kF14 = tmp3_2 * s1_14_2;
    gl64_t kG14 = kD14 - kE14;
    tmp3_0 = (kC14 + kG14) - kF14;
    tmp3_1 = ((((kA14 + kC14) - kE14) - kE14) - kD14);
    tmp3_2 = kB14 - kG14;
    // Op 15: dim3x1 add
    gl64_t s1_15 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_0)];
    tmp3_9 = tmp3_0 + s1_15; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 16: dim3x3 add
    gl64_t s1_16_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_16_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_16_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_9 + s1_16_0; tmp3_4 = tmp3_10 + s1_16_1; tmp3_5 = tmp3_11 + s1_16_2;
    // Op 17: dim3x1 mul
    gl64_t s0_17_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_17_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_17_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_17 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 31, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 31, domainSize, nCols_0)];
    tmp3_0 = s0_17_0 * s1_17; tmp3_1 = s0_17_1 * s1_17; tmp3_2 = s0_17_2 * s1_17;
    // Op 18: dim3x1 add
    gl64_t s1_18 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 30, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 30, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_18; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 19: dim3x3 mul
    gl64_t s1_19_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_19_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_19_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA19 = (tmp3_0 + tmp3_1) * (s1_19_0 + s1_19_1);
    gl64_t kB19 = (tmp3_0 + tmp3_2) * (s1_19_0 + s1_19_2);
    gl64_t kC19 = (tmp3_1 + tmp3_2) * (s1_19_1 + s1_19_2);
    gl64_t kD19 = tmp3_0 * s1_19_0;
    gl64_t kE19 = tmp3_1 * s1_19_1;
    gl64_t kF19 = tmp3_2 * s1_19_2;
    gl64_t kG19 = kD19 - kE19;
    tmp3_0 = (kC19 + kG19) - kF19;
    tmp3_1 = ((((kA19 + kC19) - kE19) - kE19) - kD19);
    tmp3_2 = kB19 - kG19;
    // Op 20: dim3x1 add
    gl64_t s1_20 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 29, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 29, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_20; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 21: dim3x3 mul
    gl64_t s1_21_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_21_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_21_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 22: dim3x1 add
    gl64_t s1_22 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 28, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 28, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_22; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 23: dim3x3 mul
    gl64_t s1_23_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_23_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_23_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 24: dim3x1 add
    gl64_t s1_24 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 27, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 27, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_24; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 25: dim3x3 mul
    gl64_t s1_25_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_25_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_25_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 26: dim3x1 add
    gl64_t s1_26 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 26, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 26, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_26; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 27: dim3x3 mul
    gl64_t s1_27_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_27_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_27_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 28: dim3x1 add
    gl64_t s1_28 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 25, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 25, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_28; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 29: dim3x3 mul
    gl64_t s1_29_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_29_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_29_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 30: dim3x1 add
    gl64_t s1_30 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 24, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 24, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_30; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 31: dim3x3 mul
    gl64_t s1_31_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_31_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_31_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 32: dim3x1 add
    gl64_t s1_32 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_0)];
    tmp3_6 = tmp3_0 + s1_32; tmp3_7 = tmp3_1; tmp3_8 = tmp3_2;
    // Op 33: dim3x3 add
    gl64_t s1_33_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_33_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_33_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_6 + s1_33_0; tmp3_1 = tmp3_7 + s1_33_1; tmp3_2 = tmp3_8 + s1_33_2;
    // Op 34: dim3x3 mul
    gl64_t kA34 = (tmp3_3 + tmp3_4) * (tmp3_0 + tmp3_1);
    gl64_t kB34 = (tmp3_3 + tmp3_5) * (tmp3_0 + tmp3_2);
    gl64_t kC34 = (tmp3_4 + tmp3_5) * (tmp3_1 + tmp3_2);
    gl64_t kD34 = tmp3_3 * tmp3_0;
    gl64_t kE34 = tmp3_4 * tmp3_1;
    gl64_t kF34 = tmp3_5 * tmp3_2;
    gl64_t kG34 = kD34 - kE34;
    tmp3_0 = (kC34 + kG34) - kF34;
    tmp3_1 = ((((kA34 + kC34) - kE34) - kE34) - kD34);
    tmp3_2 = kB34 - kG34;
    // Op 35: dim3x3 mul
    gl64_t s0_35_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_35_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_35_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t kA35 = (s0_35_0 + s0_35_1) * (tmp3_0 + tmp3_1);
    gl64_t kB35 = (s0_35_0 + s0_35_2) * (tmp3_0 + tmp3_2);
    gl64_t kC35 = (s0_35_1 + s0_35_2) * (tmp3_1 + tmp3_2);
    gl64_t kD35 = s0_35_0 * tmp3_0;
    gl64_t kE35 = s0_35_1 * tmp3_1;
    gl64_t kF35 = s0_35_2 * tmp3_2;
    gl64_t kG35 = kD35 - kE35;
    tmp3_0 = (kC35 + kG35) - kF35;
    tmp3_1 = ((((kA35 + kC35) - kE35) - kE35) - kD35);
    tmp3_2 = kB35 - kG35;
    // Op 36: dim3x3 add
    gl64_t s1_36_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_36_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_36_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_6 + s1_36_0; tmp3_7 = tmp3_7 + s1_36_1; tmp3_8 = tmp3_8 + s1_36_2;
    // Op 37: dim3x1 mul
    gl64_t s1_37 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 1, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 1, domainSize, nCols_1))];
    tmp3_6 = tmp3_6 * s1_37; tmp3_7 = tmp3_7 * s1_37; tmp3_8 = tmp3_8 * s1_37;
    // Op 38: dim3x3 add
    gl64_t s1_38_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_38_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_38_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_38_0; tmp3_10 = tmp3_10 + s1_38_1; tmp3_11 = tmp3_11 + s1_38_2;
    // Op 39: dim3x1 mul
    gl64_t s1_39 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 2, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 2, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_39; tmp3_10 = tmp3_10 * s1_39; tmp3_11 = tmp3_11 * s1_39;
    // Op 40: dim3x3 add
    tmp3_6 = tmp3_6 + tmp3_9; tmp3_7 = tmp3_7 + tmp3_10; tmp3_8 = tmp3_8 + tmp3_11;
    // Op 41: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_6; tmp3_1 = tmp3_1 - tmp3_7; tmp3_2 = tmp3_2 - tmp3_8;
    // Op 42: dim3x3 mul
    gl64_t s1_42_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_42_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_42_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA42 = (tmp3_0 + tmp3_1) * (s1_42_0 + s1_42_1);
    gl64_t kB42 = (tmp3_0 + tmp3_2) * (s1_42_0 + s1_42_2);
    gl64_t kC42 = (tmp3_1 + tmp3_2) * (s1_42_1 + s1_42_2);
    gl64_t kD42 = tmp3_0 * s1_42_0;
    gl64_t kE42 = tmp3_1 * s1_42_1;
    gl64_t kF42 = tmp3_2 * s1_42_2;
    gl64_t kG42 = kD42 - kE42;
    tmp3_12 = (kC42 + kG42) - kF42;
    tmp3_13 = ((((kA42 + kC42) - kE42) - kE42) - kD42);
    tmp3_14 = kB42 - kG42;
    // Op 43: dim3x1 mul
    gl64_t s0_43_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_43_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_43_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_43 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 39, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 39, domainSize, nCols_0)];
    tmp3_0 = s0_43_0 * s1_43; tmp3_1 = s0_43_1 * s1_43; tmp3_2 = s0_43_2 * s1_43;
    // Op 44: dim3x1 add
    gl64_t s1_44 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 38, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 38, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_44; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 45: dim3x3 mul
    gl64_t s1_45_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_45_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_45_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA45 = (tmp3_0 + tmp3_1) * (s1_45_0 + s1_45_1);
    gl64_t kB45 = (tmp3_0 + tmp3_2) * (s1_45_0 + s1_45_2);
    gl64_t kC45 = (tmp3_1 + tmp3_2) * (s1_45_1 + s1_45_2);
    gl64_t kD45 = tmp3_0 * s1_45_0;
    gl64_t kE45 = tmp3_1 * s1_45_1;
    gl64_t kF45 = tmp3_2 * s1_45_2;
    gl64_t kG45 = kD45 - kE45;
    tmp3_0 = (kC45 + kG45) - kF45;
    tmp3_1 = ((((kA45 + kC45) - kE45) - kE45) - kD45);
    tmp3_2 = kB45 - kG45;
    // Op 46: dim3x1 add
    gl64_t s1_46 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 37, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 37, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_46; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 47: dim3x3 mul
    gl64_t s1_47_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_47_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_47_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA47 = (tmp3_0 + tmp3_1) * (s1_47_0 + s1_47_1);
    gl64_t kB47 = (tmp3_0 + tmp3_2) * (s1_47_0 + s1_47_2);
    gl64_t kC47 = (tmp3_1 + tmp3_2) * (s1_47_1 + s1_47_2);
    gl64_t kD47 = tmp3_0 * s1_47_0;
    gl64_t kE47 = tmp3_1 * s1_47_1;
    gl64_t kF47 = tmp3_2 * s1_47_2;
    gl64_t kG47 = kD47 - kE47;
    tmp3_0 = (kC47 + kG47) - kF47;
    tmp3_1 = ((((kA47 + kC47) - kE47) - kE47) - kD47);
    tmp3_2 = kB47 - kG47;
    // Op 48: dim3x1 add
    gl64_t s1_48 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 36, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 36, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_48; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 49: dim3x3 mul
    gl64_t s1_49_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_49_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_49_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 50: dim3x1 add
    gl64_t s1_50 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 35, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 35, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_50; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 51: dim3x3 mul
    gl64_t s1_51_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_51_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_51_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA51 = (tmp3_0 + tmp3_1) * (s1_51_0 + s1_51_1);
    gl64_t kB51 = (tmp3_0 + tmp3_2) * (s1_51_0 + s1_51_2);
    gl64_t kC51 = (tmp3_1 + tmp3_2) * (s1_51_1 + s1_51_2);
    gl64_t kD51 = tmp3_0 * s1_51_0;
    gl64_t kE51 = tmp3_1 * s1_51_1;
    gl64_t kF51 = tmp3_2 * s1_51_2;
    gl64_t kG51 = kD51 - kE51;
    tmp3_0 = (kC51 + kG51) - kF51;
    tmp3_1 = ((((kA51 + kC51) - kE51) - kE51) - kD51);
    tmp3_2 = kB51 - kG51;
    // Op 52: dim3x1 add
    gl64_t s1_52 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 34, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 34, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_52; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 53: dim3x3 mul
    gl64_t s1_53_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_53_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_53_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 54: dim3x1 add
    gl64_t s1_54 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 33, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 33, domainSize, nCols_0)];
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
    gl64_t s1_56 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 32, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 32, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_56; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 57: dim3x3 mul
    gl64_t s1_57_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_57_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_57_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 58: dim3x1 add
    gl64_t s1_58 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_0)];
    tmp3_3 = tmp3_0 + s1_58; tmp3_4 = tmp3_1; tmp3_5 = tmp3_2;
    // Op 59: dim3x3 add
    gl64_t s1_59_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_59_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_59_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_6 = tmp3_3 + s1_59_0; tmp3_7 = tmp3_4 + s1_59_1; tmp3_8 = tmp3_5 + s1_59_2;
    // Op 60: dim3x1 mul
    gl64_t s0_60_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_60_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_60_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_60 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 47, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 47, domainSize, nCols_0)];
    tmp3_0 = s0_60_0 * s1_60; tmp3_1 = s0_60_1 * s1_60; tmp3_2 = s0_60_2 * s1_60;
    // Op 61: dim3x1 add
    gl64_t s1_61 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 46, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 46, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_61; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 62: dim3x3 mul
    gl64_t s1_62_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_62_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_62_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA62 = (tmp3_0 + tmp3_1) * (s1_62_0 + s1_62_1);
    gl64_t kB62 = (tmp3_0 + tmp3_2) * (s1_62_0 + s1_62_2);
    gl64_t kC62 = (tmp3_1 + tmp3_2) * (s1_62_1 + s1_62_2);
    gl64_t kD62 = tmp3_0 * s1_62_0;
    gl64_t kE62 = tmp3_1 * s1_62_1;
    gl64_t kF62 = tmp3_2 * s1_62_2;
    gl64_t kG62 = kD62 - kE62;
    tmp3_0 = (kC62 + kG62) - kF62;
    tmp3_1 = ((((kA62 + kC62) - kE62) - kE62) - kD62);
    tmp3_2 = kB62 - kG62;
    // Op 63: dim3x1 add
    gl64_t s1_63 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 45, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 45, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_63; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 64: dim3x3 mul
    gl64_t s1_64_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_64_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_64_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 65: dim3x1 add
    gl64_t s1_65 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 44, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 44, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_65; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 66: dim3x3 mul
    gl64_t s1_66_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_66_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_66_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA66 = (tmp3_0 + tmp3_1) * (s1_66_0 + s1_66_1);
    gl64_t kB66 = (tmp3_0 + tmp3_2) * (s1_66_0 + s1_66_2);
    gl64_t kC66 = (tmp3_1 + tmp3_2) * (s1_66_1 + s1_66_2);
    gl64_t kD66 = tmp3_0 * s1_66_0;
    gl64_t kE66 = tmp3_1 * s1_66_1;
    gl64_t kF66 = tmp3_2 * s1_66_2;
    gl64_t kG66 = kD66 - kE66;
    tmp3_0 = (kC66 + kG66) - kF66;
    tmp3_1 = ((((kA66 + kC66) - kE66) - kE66) - kD66);
    tmp3_2 = kB66 - kG66;
    // Op 67: dim3x1 add
    gl64_t s1_67 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 43, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 43, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_67; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 68: dim3x3 mul
    gl64_t s1_68_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_68_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_68_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 69: dim3x1 add
    gl64_t s1_69 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 42, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 42, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_69; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 70: dim3x3 mul
    gl64_t s1_70_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_70_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_70_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA70 = (tmp3_0 + tmp3_1) * (s1_70_0 + s1_70_1);
    gl64_t kB70 = (tmp3_0 + tmp3_2) * (s1_70_0 + s1_70_2);
    gl64_t kC70 = (tmp3_1 + tmp3_2) * (s1_70_1 + s1_70_2);
    gl64_t kD70 = tmp3_0 * s1_70_0;
    gl64_t kE70 = tmp3_1 * s1_70_1;
    gl64_t kF70 = tmp3_2 * s1_70_2;
    gl64_t kG70 = kD70 - kE70;
    tmp3_0 = (kC70 + kG70) - kF70;
    tmp3_1 = ((((kA70 + kC70) - kE70) - kE70) - kD70);
    tmp3_2 = kB70 - kG70;
    // Op 71: dim3x1 add
    gl64_t s1_71 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 41, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 41, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_71; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 72: dim3x3 mul
    gl64_t s1_72_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_72_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_72_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA72 = (tmp3_0 + tmp3_1) * (s1_72_0 + s1_72_1);
    gl64_t kB72 = (tmp3_0 + tmp3_2) * (s1_72_0 + s1_72_2);
    gl64_t kC72 = (tmp3_1 + tmp3_2) * (s1_72_1 + s1_72_2);
    gl64_t kD72 = tmp3_0 * s1_72_0;
    gl64_t kE72 = tmp3_1 * s1_72_1;
    gl64_t kF72 = tmp3_2 * s1_72_2;
    gl64_t kG72 = kD72 - kE72;
    tmp3_0 = (kC72 + kG72) - kF72;
    tmp3_1 = ((((kA72 + kC72) - kE72) - kE72) - kD72);
    tmp3_2 = kB72 - kG72;
    // Op 73: dim3x1 add
    gl64_t s1_73 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 40, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 40, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_73; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 74: dim3x3 mul
    gl64_t s1_74_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_74_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_74_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 75: dim3x1 add
    gl64_t s1_75 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_0)];
    tmp3_9 = tmp3_0 + s1_75; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 76: dim3x3 add
    gl64_t s1_76_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_76_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_76_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_9 + s1_76_0; tmp3_1 = tmp3_10 + s1_76_1; tmp3_2 = tmp3_11 + s1_76_2;
    // Op 77: dim3x3 mul
    gl64_t kA77 = (tmp3_6 + tmp3_7) * (tmp3_0 + tmp3_1);
    gl64_t kB77 = (tmp3_6 + tmp3_8) * (tmp3_0 + tmp3_2);
    gl64_t kC77 = (tmp3_7 + tmp3_8) * (tmp3_1 + tmp3_2);
    gl64_t kD77 = tmp3_6 * tmp3_0;
    gl64_t kE77 = tmp3_7 * tmp3_1;
    gl64_t kF77 = tmp3_8 * tmp3_2;
    gl64_t kG77 = kD77 - kE77;
    tmp3_0 = (kC77 + kG77) - kF77;
    tmp3_1 = ((((kA77 + kC77) - kE77) - kE77) - kD77);
    tmp3_2 = kB77 - kG77;
    // Op 78: dim3x3 mul
    gl64_t s0_78_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s0_78_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s0_78_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    gl64_t kA78 = (s0_78_0 + s0_78_1) * (tmp3_0 + tmp3_1);
    gl64_t kB78 = (s0_78_0 + s0_78_2) * (tmp3_0 + tmp3_2);
    gl64_t kC78 = (s0_78_1 + s0_78_2) * (tmp3_1 + tmp3_2);
    gl64_t kD78 = s0_78_0 * tmp3_0;
    gl64_t kE78 = s0_78_1 * tmp3_1;
    gl64_t kF78 = s0_78_2 * tmp3_2;
    gl64_t kG78 = kD78 - kE78;
    tmp3_0 = (kC78 + kG78) - kF78;
    tmp3_1 = ((((kA78 + kC78) - kE78) - kE78) - kD78);
    tmp3_2 = kB78 - kG78;
    // Op 79: dim3x3 add
    gl64_t s1_79_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_79_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_79_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_79_0; tmp3_10 = tmp3_10 + s1_79_1; tmp3_11 = tmp3_11 + s1_79_2;
    // Op 80: dim3x1 mul
    gl64_t s1_80 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 3, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_80; tmp3_10 = tmp3_10 * s1_80; tmp3_11 = tmp3_11 * s1_80;
    // Op 81: dim3x3 add
    gl64_t s1_81_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_81_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_81_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_3 + s1_81_0; tmp3_4 = tmp3_4 + s1_81_1; tmp3_5 = tmp3_5 + s1_81_2;
    // Op 82: dim3x1 mul
    gl64_t s1_82 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 4, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 4, domainSize, nCols_1))];
    tmp3_3 = tmp3_3 * s1_82; tmp3_4 = tmp3_4 * s1_82; tmp3_5 = tmp3_5 * s1_82;
    // Op 83: dim3x3 add
    tmp3_3 = tmp3_9 + tmp3_3; tmp3_4 = tmp3_10 + tmp3_4; tmp3_5 = tmp3_11 + tmp3_5;
    // Op 84: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_3; tmp3_1 = tmp3_1 - tmp3_4; tmp3_2 = tmp3_2 - tmp3_5;
    // Op 85: dim3x3 add
    tmp3_0 = tmp3_12 + tmp3_0; tmp3_1 = tmp3_13 + tmp3_1; tmp3_2 = tmp3_14 + tmp3_2;
    // Op 86: dim3x3 mul
    gl64_t s1_86_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_86_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_86_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA86 = (tmp3_0 + tmp3_1) * (s1_86_0 + s1_86_1);
    gl64_t kB86 = (tmp3_0 + tmp3_2) * (s1_86_0 + s1_86_2);
    gl64_t kC86 = (tmp3_1 + tmp3_2) * (s1_86_1 + s1_86_2);
    gl64_t kD86 = tmp3_0 * s1_86_0;
    gl64_t kE86 = tmp3_1 * s1_86_1;
    gl64_t kF86 = tmp3_2 * s1_86_2;
    gl64_t kG86 = kD86 - kE86;
    tmp3_6 = (kC86 + kG86) - kF86;
    tmp3_7 = ((((kA86 + kC86) - kE86) - kE86) - kD86);
    tmp3_8 = kB86 - kG86;
    // Op 87: dim3x1 mul
    gl64_t s0_87_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_87_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_87_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_87 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 55, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 55, domainSize, nCols_0)];
    tmp3_0 = s0_87_0 * s1_87; tmp3_1 = s0_87_1 * s1_87; tmp3_2 = s0_87_2 * s1_87;
    // Op 88: dim3x1 add
    gl64_t s1_88 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 54, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 54, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_88; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 89: dim3x3 mul
    gl64_t s1_89_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_89_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_89_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 90: dim3x1 add
    gl64_t s1_90 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 53, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 53, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_90; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 91: dim3x3 mul
    gl64_t s1_91_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_91_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_91_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA91 = (tmp3_0 + tmp3_1) * (s1_91_0 + s1_91_1);
    gl64_t kB91 = (tmp3_0 + tmp3_2) * (s1_91_0 + s1_91_2);
    gl64_t kC91 = (tmp3_1 + tmp3_2) * (s1_91_1 + s1_91_2);
    gl64_t kD91 = tmp3_0 * s1_91_0;
    gl64_t kE91 = tmp3_1 * s1_91_1;
    gl64_t kF91 = tmp3_2 * s1_91_2;
    gl64_t kG91 = kD91 - kE91;
    tmp3_0 = (kC91 + kG91) - kF91;
    tmp3_1 = ((((kA91 + kC91) - kE91) - kE91) - kD91);
    tmp3_2 = kB91 - kG91;
    // Op 92: dim3x1 add
    gl64_t s1_92 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 52, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 52, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_92; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    // Op 94: dim3x1 add
    gl64_t s1_94 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 51, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 51, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_94; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 95: dim3x3 mul
    gl64_t s1_95_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_95_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_95_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 96: dim3x1 add
    gl64_t s1_96 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 50, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 50, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_96; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_98 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 49, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 49, domainSize, nCols_0)];
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
    gl64_t s1_100 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 48, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 48, domainSize, nCols_0)];
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
    // Op 102: dim3x1 add
    gl64_t s1_102 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_0)];
    tmp3_9 = tmp3_0 + s1_102; tmp3_10 = tmp3_1; tmp3_11 = tmp3_2;
    // Op 103: dim3x3 add
    gl64_t s1_103_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_103_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_103_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_12 = tmp3_9 + s1_103_0; tmp3_13 = tmp3_10 + s1_103_1; tmp3_14 = tmp3_11 + s1_103_2;
    // Op 104: dim3x1 mul
    gl64_t s0_104_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_104_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_104_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_104 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 63, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 63, domainSize, nCols_0)];
    tmp3_0 = s0_104_0 * s1_104; tmp3_1 = s0_104_1 * s1_104; tmp3_2 = s0_104_2 * s1_104;
    // Op 105: dim3x1 add
    gl64_t s1_105 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 62, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 62, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_105; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 106: dim3x3 mul
    gl64_t s1_106_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_106_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_106_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 107: dim3x1 add
    gl64_t s1_107 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 61, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 61, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_107; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 108: dim3x3 mul
    gl64_t s1_108_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_108_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_108_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA108 = (tmp3_0 + tmp3_1) * (s1_108_0 + s1_108_1);
    gl64_t kB108 = (tmp3_0 + tmp3_2) * (s1_108_0 + s1_108_2);
    gl64_t kC108 = (tmp3_1 + tmp3_2) * (s1_108_1 + s1_108_2);
    gl64_t kD108 = tmp3_0 * s1_108_0;
    gl64_t kE108 = tmp3_1 * s1_108_1;
    gl64_t kF108 = tmp3_2 * s1_108_2;
    gl64_t kG108 = kD108 - kE108;
    tmp3_0 = (kC108 + kG108) - kF108;
    tmp3_1 = ((((kA108 + kC108) - kE108) - kE108) - kD108);
    tmp3_2 = kB108 - kG108;
    // Op 109: dim3x1 add
    gl64_t s1_109 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 60, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 60, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_109; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 110: dim3x3 mul
    gl64_t s1_110_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_110_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_110_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA110 = (tmp3_0 + tmp3_1) * (s1_110_0 + s1_110_1);
    gl64_t kB110 = (tmp3_0 + tmp3_2) * (s1_110_0 + s1_110_2);
    gl64_t kC110 = (tmp3_1 + tmp3_2) * (s1_110_1 + s1_110_2);
    gl64_t kD110 = tmp3_0 * s1_110_0;
    gl64_t kE110 = tmp3_1 * s1_110_1;
    gl64_t kF110 = tmp3_2 * s1_110_2;
    gl64_t kG110 = kD110 - kE110;
    tmp3_0 = (kC110 + kG110) - kF110;
    tmp3_1 = ((((kA110 + kC110) - kE110) - kE110) - kD110);
    tmp3_2 = kB110 - kG110;
    // Op 111: dim3x1 add
    gl64_t s1_111 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 59, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 59, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_111; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 112: dim3x3 mul
    gl64_t s1_112_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_112_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_112_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 113: dim3x1 add
    gl64_t s1_113 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 58, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 58, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_113; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 114: dim3x3 mul
    gl64_t s1_114_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_114_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_114_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA114 = (tmp3_0 + tmp3_1) * (s1_114_0 + s1_114_1);
    gl64_t kB114 = (tmp3_0 + tmp3_2) * (s1_114_0 + s1_114_2);
    gl64_t kC114 = (tmp3_1 + tmp3_2) * (s1_114_1 + s1_114_2);
    gl64_t kD114 = tmp3_0 * s1_114_0;
    gl64_t kE114 = tmp3_1 * s1_114_1;
    gl64_t kF114 = tmp3_2 * s1_114_2;
    gl64_t kG114 = kD114 - kE114;
    tmp3_0 = (kC114 + kG114) - kF114;
    tmp3_1 = ((((kA114 + kC114) - kE114) - kE114) - kD114);
    tmp3_2 = kB114 - kG114;
    // Op 115: dim3x1 add
    gl64_t s1_115 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 57, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 57, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_115; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 116: dim3x3 mul
    gl64_t s1_116_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_116_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_116_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA116 = (tmp3_0 + tmp3_1) * (s1_116_0 + s1_116_1);
    gl64_t kB116 = (tmp3_0 + tmp3_2) * (s1_116_0 + s1_116_2);
    gl64_t kC116 = (tmp3_1 + tmp3_2) * (s1_116_1 + s1_116_2);
    gl64_t kD116 = tmp3_0 * s1_116_0;
    gl64_t kE116 = tmp3_1 * s1_116_1;
    gl64_t kF116 = tmp3_2 * s1_116_2;
    gl64_t kG116 = kD116 - kE116;
    tmp3_0 = (kC116 + kG116) - kF116;
    tmp3_1 = ((((kA116 + kC116) - kE116) - kE116) - kD116);
    tmp3_2 = kB116 - kG116;
    // Op 117: dim3x1 add
    gl64_t s1_117 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 56, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 56, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_117; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 118: dim3x3 mul
    gl64_t s1_118_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_118_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_118_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA118 = (tmp3_0 + tmp3_1) * (s1_118_0 + s1_118_1);
    gl64_t kB118 = (tmp3_0 + tmp3_2) * (s1_118_0 + s1_118_2);
    gl64_t kC118 = (tmp3_1 + tmp3_2) * (s1_118_1 + s1_118_2);
    gl64_t kD118 = tmp3_0 * s1_118_0;
    gl64_t kE118 = tmp3_1 * s1_118_1;
    gl64_t kF118 = tmp3_2 * s1_118_2;
    gl64_t kG118 = kD118 - kE118;
    tmp3_0 = (kC118 + kG118) - kF118;
    tmp3_1 = ((((kA118 + kC118) - kE118) - kE118) - kD118);
    tmp3_2 = kB118 - kG118;
    // Op 119: dim3x1 add
    gl64_t s1_119 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_0)];
    tmp3_3 = tmp3_0 + s1_119; tmp3_4 = tmp3_1; tmp3_5 = tmp3_2;
    // Op 120: dim3x3 add
    gl64_t s1_120_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_120_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_120_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_3 + s1_120_0; tmp3_1 = tmp3_4 + s1_120_1; tmp3_2 = tmp3_5 + s1_120_2;
    // Op 121: dim3x3 mul
    gl64_t kA121 = (tmp3_12 + tmp3_13) * (tmp3_0 + tmp3_1);
    gl64_t kB121 = (tmp3_12 + tmp3_14) * (tmp3_0 + tmp3_2);
    gl64_t kC121 = (tmp3_13 + tmp3_14) * (tmp3_1 + tmp3_2);
    gl64_t kD121 = tmp3_12 * tmp3_0;
    gl64_t kE121 = tmp3_13 * tmp3_1;
    gl64_t kF121 = tmp3_14 * tmp3_2;
    gl64_t kG121 = kD121 - kE121;
    tmp3_0 = (kC121 + kG121) - kF121;
    tmp3_1 = ((((kA121 + kC121) - kE121) - kE121) - kD121);
    tmp3_2 = kB121 - kG121;
    // Op 122: dim3x3 mul
    uint64_t s0_122_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_122_0 = *(gl64_t*)&dParams->aux_trace[s0_122_pos];
    gl64_t s0_122_1 = *(gl64_t*)&dParams->aux_trace[s0_122_pos + TILE_HEIGHT];
    gl64_t s0_122_2 = *(gl64_t*)&dParams->aux_trace[s0_122_pos + 2*TILE_HEIGHT];
    gl64_t kA122 = (s0_122_0 + s0_122_1) * (tmp3_0 + tmp3_1);
    gl64_t kB122 = (s0_122_0 + s0_122_2) * (tmp3_0 + tmp3_2);
    gl64_t kC122 = (s0_122_1 + s0_122_2) * (tmp3_1 + tmp3_2);
    gl64_t kD122 = s0_122_0 * tmp3_0;
    gl64_t kE122 = s0_122_1 * tmp3_1;
    gl64_t kF122 = s0_122_2 * tmp3_2;
    gl64_t kG122 = kD122 - kE122;
    tmp3_0 = (kC122 + kG122) - kF122;
    tmp3_1 = ((((kA122 + kC122) - kE122) - kE122) - kD122);
    tmp3_2 = kB122 - kG122;
    // Op 123: dim3x3 add
    gl64_t s1_123_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_123_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_123_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_3 = tmp3_3 + s1_123_0; tmp3_4 = tmp3_4 + s1_123_1; tmp3_5 = tmp3_5 + s1_123_2;
    // Op 124: dim3x1 mul
    gl64_t s1_124 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 5, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 5, domainSize, nCols_1))];
    tmp3_3 = tmp3_3 * s1_124; tmp3_4 = tmp3_4 * s1_124; tmp3_5 = tmp3_5 * s1_124;
    // Op 125: dim3x3 add
    gl64_t s1_125_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_125_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_125_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_9 = tmp3_9 + s1_125_0; tmp3_10 = tmp3_10 + s1_125_1; tmp3_11 = tmp3_11 + s1_125_2;
    // Op 126: dim3x1 mul
    gl64_t s1_126 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 6, domainSize, nCols_1))];
    tmp3_9 = tmp3_9 * s1_126; tmp3_10 = tmp3_10 * s1_126; tmp3_11 = tmp3_11 * s1_126;
    // Op 127: dim3x3 add
    tmp3_3 = tmp3_3 + tmp3_9; tmp3_4 = tmp3_4 + tmp3_10; tmp3_5 = tmp3_5 + tmp3_11;
    // Op 128: dim3x3 sub
    tmp3_0 = tmp3_0 - tmp3_3; tmp3_1 = tmp3_1 - tmp3_4; tmp3_2 = tmp3_2 - tmp3_5;
    // Op 129: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
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
    tmp3_6 = (kC130 + kG130) - kF130;
    tmp3_7 = ((((kA130 + kC130) - kE130) - kE130) - kD130);
    tmp3_8 = kB130 - kG130;
    // Op 131: dim3x1 mul
    gl64_t s0_131_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_131_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_131_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_131 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 71, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 71, domainSize, nCols_0)];
    tmp3_0 = s0_131_0 * s1_131; tmp3_1 = s0_131_1 * s1_131; tmp3_2 = s0_131_2 * s1_131;
    // Op 132: dim3x1 add
    gl64_t s1_132 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 70, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 70, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_132; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 133: dim3x3 mul
    gl64_t s1_133_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_133_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_133_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 134: dim3x1 add
    gl64_t s1_134 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 69, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 69, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_134; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 135: dim3x3 mul
    gl64_t s1_135_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_135_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_135_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 136: dim3x1 add
    gl64_t s1_136 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 68, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 68, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_136; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
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
    gl64_t s1_138 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 67, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 67, domainSize, nCols_0)];
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
    gl64_t s1_140 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 66, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 66, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_140; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 141: dim3x3 mul
    gl64_t s1_141_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_141_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_141_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 142: dim3x1 add
    gl64_t s1_142 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 65, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 65, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_142; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 143: dim3x3 mul
    gl64_t s1_143_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_143_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_143_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 144: dim3x1 add
    gl64_t s1_144 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 64, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 64, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_144; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 145: dim3x3 mul
    gl64_t s1_145_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_145_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_145_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 146: dim3x1 add
    gl64_t s1_146 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_146; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 147: dim3x3 add
    gl64_t s1_147_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_147_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_147_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_147_0; tmp3_1 = tmp3_1 + s1_147_1; tmp3_2 = tmp3_2 + s1_147_2;
    // Op 148: dim3x3 mul
    uint64_t s0_148_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_148_0 = *(gl64_t*)&dParams->aux_trace[s0_148_pos];
    gl64_t s0_148_1 = *(gl64_t*)&dParams->aux_trace[s0_148_pos + TILE_HEIGHT];
    gl64_t s0_148_2 = *(gl64_t*)&dParams->aux_trace[s0_148_pos + 2*TILE_HEIGHT];
    gl64_t kA148 = (s0_148_0 + s0_148_1) * (tmp3_0 + tmp3_1);
    gl64_t kB148 = (s0_148_0 + s0_148_2) * (tmp3_0 + tmp3_2);
    gl64_t kC148 = (s0_148_1 + s0_148_2) * (tmp3_1 + tmp3_2);
    gl64_t kD148 = s0_148_0 * tmp3_0;
    gl64_t kE148 = s0_148_1 * tmp3_1;
    gl64_t kF148 = s0_148_2 * tmp3_2;
    gl64_t kG148 = kD148 - kE148;
    tmp3_0 = (kC148 + kG148) - kF148;
    tmp3_1 = ((((kA148 + kC148) - kE148) - kE148) - kD148);
    tmp3_2 = kB148 - kG148;
    // Op 149: dim3x1 sub
    gl64_t s1_149 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 7, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 7, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 - s1_149; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 150: dim3x3 add
    tmp3_0 = tmp3_6 + tmp3_0; tmp3_1 = tmp3_7 + tmp3_1; tmp3_2 = tmp3_8 + tmp3_2;
    // Op 151: dim3x3 mul
    gl64_t s1_151_0 = *(gl64_t*)&expressions_params[13][6];
    gl64_t s1_151_1 = *(gl64_t*)&expressions_params[13][6+1];
    gl64_t s1_151_2 = *(gl64_t*)&expressions_params[13][6+2];
    gl64_t kA151 = (tmp3_0 + tmp3_1) * (s1_151_0 + s1_151_1);
    gl64_t kB151 = (tmp3_0 + tmp3_2) * (s1_151_0 + s1_151_2);
    gl64_t kC151 = (tmp3_1 + tmp3_2) * (s1_151_1 + s1_151_2);
    gl64_t kD151 = tmp3_0 * s1_151_0;
    gl64_t kE151 = tmp3_1 * s1_151_1;
    gl64_t kF151 = tmp3_2 * s1_151_2;
    gl64_t kG151 = kD151 - kE151;
    tmp3_3 = (kC151 + kG151) - kF151;
    tmp3_4 = ((((kA151 + kC151) - kE151) - kE151) - kD151);
    tmp3_5 = kB151 - kG151;
    // Op 152: dim1x1 sub_swap
    gl64_t s0_152 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 72, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 72, domainSize, nCols_0)];
    gl64_t s1_152 = *(gl64_t*)&expressions_params[9][0];
    tmp1_0 = s1_152 - s0_152;
    // Op 153: dim3x1 mul
    uint64_t s0_153_pos = dExpsArgs->mapOffsetsExps[2] + (false ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_0, 0, domainSize, nCols_2));
    gl64_t s0_153_0 = *(gl64_t*)&dParams->aux_trace[s0_153_pos];
    gl64_t s0_153_1 = *(gl64_t*)&dParams->aux_trace[s0_153_pos + TILE_HEIGHT];
    gl64_t s0_153_2 = *(gl64_t*)&dParams->aux_trace[s0_153_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_153_0 * tmp1_0; tmp3_1 = s0_153_1 * tmp1_0; tmp3_2 = s0_153_2 * tmp1_0;
    // Op 154: dim3x3 sub
    uint64_t s0_154_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_154_0 = *(gl64_t*)&dParams->aux_trace[s0_154_pos];
    gl64_t s0_154_1 = *(gl64_t*)&dParams->aux_trace[s0_154_pos + TILE_HEIGHT];
    gl64_t s0_154_2 = *(gl64_t*)&dParams->aux_trace[s0_154_pos + 2*TILE_HEIGHT];
    tmp3_6 = s0_154_0 - tmp3_0; tmp3_7 = s0_154_1 - tmp3_1; tmp3_8 = s0_154_2 - tmp3_2;
    // Op 155: dim3x3 add
    gl64_t s0_155_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+0, domainSize, nCols_2))];
    gl64_t s0_155_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+1, domainSize, nCols_2))];
    gl64_t s0_155_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 3+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 3+2, domainSize, nCols_2))];
    gl64_t s1_155_0 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+0, domainSize, nCols_2))];
    gl64_t s1_155_1 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+1, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+1, domainSize, nCols_2))];
    gl64_t s1_155_2 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 6+2, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 6+2, domainSize, nCols_2))];
    tmp3_0 = s0_155_0 + s1_155_0; tmp3_1 = s0_155_1 + s1_155_1; tmp3_2 = s0_155_2 + s1_155_2;
    // Op 156: dim3x3 add
    uint64_t s0_156_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_2));
    gl64_t s0_156_0 = *(gl64_t*)&dParams->aux_trace[s0_156_pos];
    gl64_t s0_156_1 = *(gl64_t*)&dParams->aux_trace[s0_156_pos + TILE_HEIGHT];
    gl64_t s0_156_2 = *(gl64_t*)&dParams->aux_trace[s0_156_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_156_0 + tmp3_0; tmp3_1 = s0_156_1 + tmp3_1; tmp3_2 = s0_156_2 + tmp3_2;
    // Op 157: dim3x3 add
    uint64_t s0_157_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_2));
    gl64_t s0_157_0 = *(gl64_t*)&dParams->aux_trace[s0_157_pos];
    gl64_t s0_157_1 = *(gl64_t*)&dParams->aux_trace[s0_157_pos + TILE_HEIGHT];
    gl64_t s0_157_2 = *(gl64_t*)&dParams->aux_trace[s0_157_pos + 2*TILE_HEIGHT];
    tmp3_0 = s0_157_0 + tmp3_0; tmp3_1 = s0_157_1 + tmp3_1; tmp3_2 = s0_157_2 + tmp3_2;
    // Op 158: dim3x3 sub
    tmp3_6 = tmp3_6 - tmp3_0; tmp3_7 = tmp3_7 - tmp3_1; tmp3_8 = tmp3_8 - tmp3_2;
    // Op 159: dim3x1 mul
    gl64_t s0_159_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s0_159_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s0_159_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t s1_159 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 15, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 15, domainSize, nCols_0)];
    tmp3_0 = s0_159_0 * s1_159; tmp3_1 = s0_159_1 * s1_159; tmp3_2 = s0_159_2 * s1_159;
    // Op 160: dim3x1 add
    gl64_t s1_160 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 14, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 14, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_160; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 161: dim3x3 mul
    gl64_t s1_161_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_161_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_161_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 162: dim3x1 add
    gl64_t s1_162 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 13, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 13, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_162; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 163: dim3x3 mul
    gl64_t s1_163_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_163_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_163_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA163 = (tmp3_0 + tmp3_1) * (s1_163_0 + s1_163_1);
    gl64_t kB163 = (tmp3_0 + tmp3_2) * (s1_163_0 + s1_163_2);
    gl64_t kC163 = (tmp3_1 + tmp3_2) * (s1_163_1 + s1_163_2);
    gl64_t kD163 = tmp3_0 * s1_163_0;
    gl64_t kE163 = tmp3_1 * s1_163_1;
    gl64_t kF163 = tmp3_2 * s1_163_2;
    gl64_t kG163 = kD163 - kE163;
    tmp3_0 = (kC163 + kG163) - kF163;
    tmp3_1 = ((((kA163 + kC163) - kE163) - kE163) - kD163);
    tmp3_2 = kB163 - kG163;
    // Op 164: dim3x1 add
    gl64_t s1_164 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 12, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 12, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_164; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 165: dim3x3 mul
    gl64_t s1_165_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_165_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_165_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 166: dim3x1 add
    gl64_t s1_166 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 11, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 11, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_166; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 167: dim3x3 mul
    gl64_t s1_167_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_167_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_167_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 168: dim3x1 add
    gl64_t s1_168 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 10, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 10, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_168; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 169: dim3x3 mul
    gl64_t s1_169_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_169_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_169_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 170: dim3x1 add
    gl64_t s1_170 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 9, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 9, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_170; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 171: dim3x3 mul
    gl64_t s1_171_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_171_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_171_2 = *(gl64_t*)&expressions_params[13][0+2];
    gl64_t kA171 = (tmp3_0 + tmp3_1) * (s1_171_0 + s1_171_1);
    gl64_t kB171 = (tmp3_0 + tmp3_2) * (s1_171_0 + s1_171_2);
    gl64_t kC171 = (tmp3_1 + tmp3_2) * (s1_171_1 + s1_171_2);
    gl64_t kD171 = tmp3_0 * s1_171_0;
    gl64_t kE171 = tmp3_1 * s1_171_1;
    gl64_t kF171 = tmp3_2 * s1_171_2;
    gl64_t kG171 = kD171 - kE171;
    tmp3_0 = (kC171 + kG171) - kF171;
    tmp3_1 = ((((kA171 + kC171) - kE171) - kE171) - kD171);
    tmp3_2 = kB171 - kG171;
    // Op 172: dim3x1 add
    gl64_t s1_172 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 8, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 8, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_172; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 173: dim3x3 mul
    gl64_t s1_173_0 = *(gl64_t*)&expressions_params[13][0];
    gl64_t s1_173_1 = *(gl64_t*)&expressions_params[13][0+1];
    gl64_t s1_173_2 = *(gl64_t*)&expressions_params[13][0+2];
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
    // Op 174: dim3x1 add
    gl64_t s1_174 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_0) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 + s1_174; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 175: dim3x3 add
    gl64_t s1_175_0 = *(gl64_t*)&expressions_params[13][3];
    gl64_t s1_175_1 = *(gl64_t*)&expressions_params[13][3+1];
    gl64_t s1_175_2 = *(gl64_t*)&expressions_params[13][3+2];
    tmp3_0 = tmp3_0 + s1_175_0; tmp3_1 = tmp3_1 + s1_175_1; tmp3_2 = tmp3_2 + s1_175_2;
    // Op 176: dim3x3 mul
    gl64_t kA176 = (tmp3_6 + tmp3_7) * (tmp3_0 + tmp3_1);
    gl64_t kB176 = (tmp3_6 + tmp3_8) * (tmp3_0 + tmp3_2);
    gl64_t kC176 = (tmp3_7 + tmp3_8) * (tmp3_1 + tmp3_2);
    gl64_t kD176 = tmp3_6 * tmp3_0;
    gl64_t kE176 = tmp3_7 * tmp3_1;
    gl64_t kF176 = tmp3_8 * tmp3_2;
    gl64_t kG176 = kD176 - kE176;
    tmp3_0 = (kC176 + kG176) - kF176;
    tmp3_1 = ((((kA176 + kC176) - kE176) - kE176) - kD176);
    tmp3_2 = kB176 - kG176;
    // Op 177: dim3x1 sub
    gl64_t s1_177 = *(gl64_t*)&dParams->aux_trace[dExpsArgs->mapOffsetsExps[1] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_1) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_1))];
    tmp3_0 = tmp3_0 - s1_177; tmp3_1 = tmp3_1; tmp3_2 = tmp3_2;
    // Op 178: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
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
    tmp3_3 = (kC179 + kG179) - kF179;
    tmp3_4 = ((((kA179 + kC179) - kE179) - kE179) - kD179);
    tmp3_5 = kB179 - kG179;
    // Op 180: dim3x3 sub_swap
    uint64_t s0_180_pos = dExpsArgs->mapOffsetsExps[2] + (usePack256_1 ? getBufferOffset_pack256(chunkBase, 0, domainSize, nCols_2) : getBufferOffset(logicalRow_1, 0, domainSize, nCols_2));
    gl64_t s0_180_0 = *(gl64_t*)&dParams->aux_trace[s0_180_pos];
    gl64_t s0_180_1 = *(gl64_t*)&dParams->aux_trace[s0_180_pos + TILE_HEIGHT];
    gl64_t s0_180_2 = *(gl64_t*)&dParams->aux_trace[s0_180_pos + 2*TILE_HEIGHT];
    gl64_t s1_180_0 = *(gl64_t*)&expressions_params[12][0];
    gl64_t s1_180_1 = *(gl64_t*)&expressions_params[12][0+1];
    gl64_t s1_180_2 = *(gl64_t*)&expressions_params[12][0+2];
    tmp3_0 = s1_180_0 - s0_180_0; tmp3_1 = s1_180_1 - s0_180_1; tmp3_2 = s1_180_2 - s0_180_2;
    // Op 181: dim3x1 mul
    gl64_t s1_181 = *(gl64_t*)&dParams->pConstPolsExtendedTreeAddress[false ? getBufferOffset_pack256(chunkBase, 72, domainSize, nCols_0) : getBufferOffset(logicalRow_2, 72, domainSize, nCols_0)];
    tmp3_0 = tmp3_0 * s1_181; tmp3_1 = tmp3_1 * s1_181; tmp3_2 = tmp3_2 * s1_181;
    // Op 182: dim3x3 add
    tmp3_0 = tmp3_3 + tmp3_0; tmp3_1 = tmp3_4 + tmp3_1; tmp3_2 = tmp3_5 + tmp3_2;
    // Op 183: dim3x1 mul
    gl64_t s1_183 = *(gl64_t*)&dParams->aux_trace[dArgs->zi_offset + (1 - 1) * domainSize + row + threadIdx.x];
    tmp3_0 = tmp3_0 * s1_183; tmp3_1 = tmp3_1 * s1_183; tmp3_2 = tmp3_2 * s1_183;

    // Write final result to shared memory and store to output
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x + threadIdx.x] = tmp3_0;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][1 * blockDim.x + threadIdx.x] = tmp3_1;
    *(gl64_t*)&expressions_params[bufferCommitsSize + 1][2 * blockDim.x + threadIdx.x] = tmp3_2;
    storePolynomial__((ExpsArguments*)dExpsArgs, (Goldilocks::Element*)&expressions_params[bufferCommitsSize + 1][0 * blockDim.x], row);
}
