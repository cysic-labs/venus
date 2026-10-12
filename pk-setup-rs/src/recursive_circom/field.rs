//! Goldilocks constants and arithmetic used to precompute verifier constants.

pub(super) const GOLDILOCKS_P: u64 = 0xFFFF_FFFF_0000_0001;

pub(super) const GOLDILOCKS_SHIFT: u64 = 7;

pub(super) const GOLDILOCKS_ROOTS: [u64; 33] = [
    1,
    18446744069414584320,
    281474976710656,
    16777216,
    4096,
    64,
    8,
    2198989700608,
    4404853092538523347,
    6434636298004421797,
    4255134452441852017,
    9113133275150391358,
    4355325209153869931,
    4308460244895131701,
    7126024226993609386,
    1873558160482552414,
    8167150655112846419,
    5718075921287398682,
    3411401055030829696,
    8982441859486529725,
    1971462654193939361,
    6553637399136210105,
    8124823329697072476,
    5936499541590631774,
    2709866199236980323,
    8877499657461974390,
    3757607247483852735,
    4969973714567017225,
    2147253751702802259,
    2530564950562219707,
    1905180297017055339,
    3524815499551269279,
    7277203076849721926,
];

pub(super) const GOLDILOCKS_INV_ROOTS: [u64; 33] = [
    1,
    18446744069414584320,
    18446462594437873665,
    18446742969902956801,
    18442240469788262401,
    18158513693329981441,
    16140901060737761281,
    274873712576,
    9171943329124577373,
    5464760906092500108,
    4088309022520035137,
    6141391951880571024,
    386651765402340522,
    11575992183625933494,
    2841727033376697931,
    8892493137794983311,
    9071788333329385449,
    15139302138664925958,
    14996013474702747840,
    5708508531096855759,
    6451340039662992847,
    5102364342718059185,
    10420286214021487819,
    13945510089405579673,
    17538441494603169704,
    16784649996768716373,
    8974194941257008806,
    16194875529212099076,
    5506647088734794298,
    7731871677141058814,
    16558868196663692994,
    9896756522253134970,
    1644488454024429189,
];

pub(super) fn root_at(n_bits: u64) -> u64 {
    GOLDILOCKS_ROOTS[n_bits as usize]
}

pub(super) fn inv_root_at(n_bits: u64) -> u64 {
    GOLDILOCKS_INV_ROOTS[n_bits as usize]
}

pub(super) fn opening_root(n_bits: u64, opening: i64) -> u64 {
    if opening >= 0 {
        goldilocks_pow(root_at(n_bits), opening as u64)
    } else {
        goldilocks_pow(inv_root_at(n_bits), opening.unsigned_abs())
    }
}

pub(super) fn pow2_u64(bits: u64) -> u64 {
    1u64.checked_shl(bits as u32).expect("power of two size")
}

pub(super) fn goldilocks_pow(mut base: u64, mut exp: u64) -> u64 {
    let mut result = 1u64;
    while exp > 0 {
        if exp & 1 == 1 {
            result = goldilocks_mul(result, base);
        }
        base = goldilocks_mul(base, base);
        exp >>= 1;
    }
    result
}

pub(super) fn goldilocks_inv(value: u64) -> u64 {
    goldilocks_pow(value, GOLDILOCKS_P - 2)
}

pub(super) fn goldilocks_mul(left: u64, right: u64) -> u64 {
    ((left as u128 * right as u128) % GOLDILOCKS_P as u128) as u64
}
