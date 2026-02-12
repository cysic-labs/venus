// Poseidon2 Round Constants for Goldilocks Field (AMD FPGA HLS)
//
// Extracted from: pil2-proofman/pil2-stark/src/goldilocks/src/
//                 poseidon2_goldilocks_constants.hpp
//
// SPONGE_WIDTH=12 configuration:
//   C12[118]: Round constants (4*12 + 22 + 4*12)
//   D12[12]:  Internal diffusion diagonal

#ifndef VENUS_POSEIDON2_CONSTANTS_HPP
#define VENUS_POSEIDON2_CONSTANTS_HPP

#include "../goldilocks/gl64_t.hpp"
#include "poseidon2_config.hpp"

// C12: Round constants for SPONGE_WIDTH=12
// Layout: C12[0..47]   = first 4 full rounds (4 rounds * 12 elements)
//         C12[48..69]  = 22 partial rounds (1 constant each)
//         C12[70..117] = last 4 full rounds (4 rounds * 12 elements)
static const gl64_t P2_C12[P2_NUM_C] = {
    // First half full rounds (4 rounds * 12 = 48 constants)
    gl64_t(0x13dcf33aba214f46ULL), gl64_t(0x30b3b654a1da6d83ULL),
    gl64_t(0x1fc634ada6159b56ULL), gl64_t(0x937459964dc03466ULL),
    gl64_t(0xedd2ef2ca7949924ULL), gl64_t(0xede9affde0e22f68ULL),
    gl64_t(0x8515b9d6bac9282dULL), gl64_t(0x6b5c07b4e9e900d8ULL),
    gl64_t(0x1ec66368838c8a08ULL), gl64_t(0x9042367d80d1fbabULL),
    gl64_t(0x400283564a3c3799ULL), gl64_t(0x4a00be0466bca75eULL),
    gl64_t(0x7913beee58e3817fULL), gl64_t(0xf545e88532237d90ULL),
    gl64_t(0x22f8cb8736042005ULL), gl64_t(0x6f04990e247a2623ULL),
    gl64_t(0xfe22e87ba37c38cdULL), gl64_t(0xd20e32c85ffe2815ULL),
    gl64_t(0x117227674048fe73ULL), gl64_t(0x4e9fb7ea98a6b145ULL),
    gl64_t(0xe0866c232b8af08bULL), gl64_t(0x00bbc77916884964ULL),
    gl64_t(0x7031c0fb990d7116ULL), gl64_t(0x240a9e87cf35108fULL),
    gl64_t(0x2e6363a5a12244b3ULL), gl64_t(0x5e1c3787d1b5011cULL),
    gl64_t(0x4132660e2a196e8bULL), gl64_t(0x3a013b648d3d4327ULL),
    gl64_t(0xf79839f49888ea43ULL), gl64_t(0xfe85658ebafe1439ULL),
    gl64_t(0xb6889825a14240bdULL), gl64_t(0x578453605541382bULL),
    gl64_t(0x4508cda8f6b63ce9ULL), gl64_t(0x9c3ef35848684c91ULL),
    gl64_t(0x0812bde23c87178cULL), gl64_t(0xfe49638f7f722c14ULL),
    gl64_t(0x8e3f688ce885cbf5ULL), gl64_t(0xb8e110acf746a87dULL),
    gl64_t(0xb4b2e8973a6dabefULL), gl64_t(0x9e714c5da3d462ecULL),
    gl64_t(0x6438f9033d3d0c15ULL), gl64_t(0x24312f7cf1a27199ULL),
    gl64_t(0x23f843bb47acbf71ULL), gl64_t(0x9183f11a34be9f01ULL),
    gl64_t(0x839062fbb9d45dbfULL), gl64_t(0x24b56e7e6c2e43faULL),
    gl64_t(0xe1683da61c962a72ULL), gl64_t(0xa95c63971a19bfa7ULL),
    // Partial rounds (22 constants)
    gl64_t(0x4adf842aa75d4316ULL), gl64_t(0xf8fbb871aa4ab4ebULL),
    gl64_t(0x68e85b6eb2dd6aebULL), gl64_t(0x07a0b06b2d270380ULL),
    gl64_t(0xd94e0228bd282de4ULL), gl64_t(0x8bdd91d3250c5278ULL),
    gl64_t(0x209c68b88bba778fULL), gl64_t(0xb5e18cdab77f3877ULL),
    gl64_t(0xb296a3e808da93faULL), gl64_t(0x8370ecbda11a327eULL),
    gl64_t(0x3f9075283775dad8ULL), gl64_t(0xb78095bb23c6aa84ULL),
    gl64_t(0x3f36b9fe72ad4e5fULL), gl64_t(0x69bc96780b10b553ULL),
    gl64_t(0x3f1d341f2eb7b881ULL), gl64_t(0x4e939e9815838818ULL),
    gl64_t(0xda366b3ae2a31604ULL), gl64_t(0xbc89db1e7287d509ULL),
    gl64_t(0x6102f411f9ef5659ULL), gl64_t(0x58725c5e7ac1f0abULL),
    gl64_t(0x0df5856c798883e7ULL), gl64_t(0xf7bb62a8da4c961bULL),
    // Second half full rounds (4 rounds * 12 = 48 constants)
    gl64_t(0xc68be7c94882a24dULL), gl64_t(0xaf996d5d5cdaedd9ULL),
    gl64_t(0x9717f025e7daf6a5ULL), gl64_t(0x6436679e6e7216f4ULL),
    gl64_t(0x8a223d99047af267ULL), gl64_t(0xbb512e35a133ba9aULL),
    gl64_t(0xfbbf44097671aa03ULL), gl64_t(0xf04058ebf6811e61ULL),
    gl64_t(0x5cca84703fac7ffbULL), gl64_t(0x9b55c7945de6469fULL),
    gl64_t(0x8e05bf09808e934fULL), gl64_t(0x2ea900de876307d7ULL),
    gl64_t(0x7748fff2b38dfb89ULL), gl64_t(0x6b99a676dd3b5d81ULL),
    gl64_t(0xac4bb7c627cf7c13ULL), gl64_t(0xadb6ebe5e9e2f5baULL),
    gl64_t(0x2d33378cafa24ae3ULL), gl64_t(0x1e5b73807543f8c2ULL),
    gl64_t(0x09208814bfebb10fULL), gl64_t(0x782e64b6bb5b93ddULL),
    gl64_t(0xadd5a48eac90b50fULL), gl64_t(0xadd4c54c736ea4b1ULL),
    gl64_t(0xd58dbb86ed817fd8ULL), gl64_t(0x6d5ed1a533f34dddULL),
    gl64_t(0x28686aa3e36b7cb9ULL), gl64_t(0x591abd3476689f36ULL),
    gl64_t(0x047d766678f13875ULL), gl64_t(0xa2a11112625f5b49ULL),
    gl64_t(0x21fd10a3f8304958ULL), gl64_t(0xf9b40711443b0280ULL),
    gl64_t(0xd2697eb8b2bde88eULL), gl64_t(0x3493790b51731b3fULL),
    gl64_t(0x11caf9dd73764023ULL), gl64_t(0x7acfb8f72878164eULL),
    gl64_t(0x744ec4db23cefc26ULL), gl64_t(0x1e00e58f422c6340ULL),
    gl64_t(0x21dd28d906a62ddaULL), gl64_t(0xf32a46ab5f465b5fULL),
    gl64_t(0xbfce13201f3f7e6bULL), gl64_t(0xf30d2e7adb5304e2ULL),
    gl64_t(0xecdf4ee4abad48e9ULL), gl64_t(0xf94e82182d395019ULL),
    gl64_t(0x4ee52e3744d887c5ULL), gl64_t(0xa1341c7cac0083b2ULL),
    gl64_t(0x2302fb26c30c834aULL), gl64_t(0xaea3c587273bf7d3ULL),
    gl64_t(0xf798e24961823ec7ULL), gl64_t(0x962deba3e9a2cd94ULL)
};

// D12: Internal diffusion diagonal for SPONGE_WIDTH=12
static const gl64_t P2_D12[P2_SPONGE_WIDTH] = {
    gl64_t(0xc3b6c08e23ba9300ULL), gl64_t(0xd84b5de94a324fb6ULL),
    gl64_t(0x0d0c371c5b35b84fULL), gl64_t(0x7964f570e7188037ULL),
    gl64_t(0x5daf18bbd996604bULL), gl64_t(0x6743bc47b9595257ULL),
    gl64_t(0x5528b9362c59bb70ULL), gl64_t(0xac45e25b7127b68bULL),
    gl64_t(0xa2077d7dfbb606b5ULL), gl64_t(0xf3faac6faee378aeULL),
    gl64_t(0x0c6388b51545e883ULL), gl64_t(0xd27dbb6944917b60ULL)
};

#endif // VENUS_POSEIDON2_CONSTANTS_HPP
