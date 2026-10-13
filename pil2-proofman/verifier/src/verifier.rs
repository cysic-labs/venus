use std::borrow::Cow;

use fields::{
    intt_tiny, verify_fold, verify_mt, partial_merkle_tree, CubicExtensionField, Field, Goldilocks, Transcript,
    Poseidon2Constants, Poseidon4, Poseidon16, poseidon2_hash, PrimeField64,
};
use bytemuck::try_cast_slice;
use rayon::prelude::*;

/// Field elements in a Merkle node, and so in a root or a verification key.
const HASH_SIZE: usize = 4;

#[allow(dead_code)]
#[derive(Debug, Clone)]
pub struct Boundary {
    pub name: String,
    pub offset_min: Option<u64>,
    pub offset_max: Option<u64>,
}

pub struct VerifierInfo {
    pub n_stages: u32,
    /// Number of publics the AIR binds to its trace; a proof must carry exactly this many.
    pub n_publics: u64,
    pub n_constants: u64,
    pub n_evals: u64,
    pub n_bits: u64,
    pub n_bits_ext: u64,
    pub arity: u64,
    pub n_fri_queries: u64,
    pub n_fri_steps: u64,
    pub n_challenges: u64,
    pub n_challenges_total: u64,
    pub fri_steps: Vec<u64>,
    pub hash_commits: bool,
    pub num_vals: Vec<u64>,
    pub opening_points: Vec<i64>,
    pub boundaries: Vec<Boundary>,
    pub q_deg: u64,
    pub q_index: u64,
    pub last_level_verification: u64,
    pub pow_bits: u64,
}

/// Reads little-endian words that must all be canonical Goldilocks elements, so that a proof has a
/// single encoding. Input that is not 8-byte aligned is copied.
fn field_words(bytes: &[u8]) -> Option<Cow<'_, [u64]>> {
    let words = match try_cast_slice::<u8, u64>(bytes) {
        Ok(words) => Cow::Borrowed(words),
        Err(_) => {
            let words = bytes.chunks_exact(8);
            if !words.remainder().is_empty() {
                return None;
            }
            Cow::Owned(
                words
                    .map(|word| {
                        let mut le_bytes = [0u8; 8];
                        le_bytes.copy_from_slice(word);
                        u64::from_le_bytes(le_bytes)
                    })
                    .collect(),
            )
        }
    };
    words.iter().all(|&word| word < Goldilocks::ORDER_U64).then_some(words)
}

/// Hands out the words of a proof in the order the prover serialized them.
struct ProofReader<'a> {
    words: &'a [u64],
}

impl<'a> ProofReader<'a> {
    fn take(&mut self, n: usize) -> Option<&'a [u64]> {
        let (taken, rest) = self.words.split_at_checked(n)?;
        self.words = rest;
        Some(taken)
    }

    fn word(&mut self) -> Option<u64> {
        let (&word, rest) = self.words.split_first()?;
        self.words = rest;
        Some(word)
    }

    fn elements(&mut self, n: usize) -> Option<Vec<Goldilocks>> {
        Some(self.take(n)?.iter().map(|&word| Goldilocks::new(word)).collect())
    }

    fn cubic_elements(&mut self, n: usize) -> Option<Vec<CubicExtensionField<Goldilocks>>> {
        let words = self.take(n * 3)?;
        Some(
            words
                .chunks_exact(3)
                .map(|v| CubicExtensionField {
                    value: [Goldilocks::new(v[0]), Goldilocks::new(v[1]), Goldilocks::new(v[2])],
                })
                .collect(),
        )
    }

    fn hash(&mut self) -> Option<[Goldilocks; HASH_SIZE]> {
        Some(self.take(HASH_SIZE)?.first_chunk::<HASH_SIZE>()?.map(Goldilocks::new))
    }

    /// A Merkle path: `levels` groups of `width` sibling elements.
    fn merkle_path(&mut self, levels: usize, width: usize) -> Option<Vec<Vec<Goldilocks>>> {
        (0..levels).map(|_| self.elements(width)).collect()
    }
}

/// The contents of a STARK proof, indexed the way the verifier consumes them.
struct StarkProof {
    publics: Vec<Goldilocks>,
    roots: Vec<[Goldilocks; HASH_SIZE]>,
    evals: Vec<CubicExtensionField<Goldilocks>>,
    /// Per query, the values opened from the fixed tree and then from each stage tree.
    s0_vals: Vec<Vec<Vec<Goldilocks>>>,
    /// Per query, the Merkle paths of those openings.
    s0_siblings: Vec<Vec<Vec<Vec<Goldilocks>>>>,
    /// The last-level nodes of the fixed tree and then of each stage tree.
    s0_last_levels: Vec<Vec<Goldilocks>>,
    roots_fri: Vec<[Goldilocks; HASH_SIZE]>,
    /// Per query, the values opened from each FRI folding tree.
    vals_fri: Vec<Vec<Vec<Goldilocks>>>,
    siblings_fri: Vec<Vec<Vec<Vec<Goldilocks>>>>,
    last_levels_fri: Vec<Vec<Goldilocks>>,
    final_pol: Vec<CubicExtensionField<Goldilocks>>,
    nonce: Goldilocks,
}

impl StarkProof {
    /// Splits `words` into the elements of a proof shaped by `verifier_info`. Fails unless the
    /// words are exactly a proof with the number of publics the AIR binds.
    fn parse(words: &[u64], verifier_info: &VerifierInfo) -> Option<Self> {
        fn per_query<T>(n_queries: usize, n_trees: usize) -> Vec<Vec<T>> {
            (0..n_queries).map(|_| Vec::with_capacity(n_trees)).collect()
        }

        let mut reader = ProofReader { words };

        let n_publics = reader.word()?;
        if n_publics != verifier_info.n_publics {
            return None;
        }
        let publics = reader.elements(n_publics as usize)?;

        let n_stage_trees = verifier_info.n_stages as usize + 1;
        let roots = (0..n_stage_trees).map(|_| reader.hash()).collect::<Option<Vec<_>>>()?;
        let evals = reader.cubic_elements(verifier_info.n_evals as usize)?;

        let n_queries = verifier_info.n_fri_queries as usize;
        let log_arity = (verifier_info.arity as f64).log2();
        let llv = verifier_info.last_level_verification;
        let path_levels = |bits: u64| ((bits as f64 / log_arity).ceil() as usize).checked_sub(llv as usize);
        let sibling_width = (verifier_info.arity as usize - 1) * HASH_SIZE;
        let last_level_len = verifier_info.arity.pow(llv as u32) as usize * HASH_SIZE;

        // The fixed tree, then one tree per stage: the values opened by every query, their paths
        // and the tree's last level.
        let s0_levels = path_levels(verifier_info.n_bits_ext)?;
        let mut s0_vals = per_query(n_queries, n_stage_trees + 1);
        let mut s0_siblings = per_query(n_queries, n_stage_trees + 1);
        let mut s0_last_levels = Vec::with_capacity(n_stage_trees + 1);
        let stage_widths = verifier_info.num_vals.get(..n_stage_trees)?;
        for &width in std::iter::once(&verifier_info.n_constants).chain(stage_widths) {
            for vals in &mut s0_vals {
                vals.push(reader.elements(width as usize)?);
            }
            for siblings in &mut s0_siblings {
                siblings.push(reader.merkle_path(s0_levels, sibling_width)?);
            }
            if llv > 0 {
                s0_last_levels.push(reader.elements(last_level_len)?);
            }
        }

        // One tree per folding step, laid out the same way.
        let fri_steps = verifier_info.fri_steps.get(..verifier_info.n_fri_steps as usize)?;
        let n_fri_trees = fri_steps.len().saturating_sub(1);
        let roots_fri = (0..n_fri_trees).map(|_| reader.hash()).collect::<Option<Vec<_>>>()?;
        let mut vals_fri = per_query(n_queries, n_fri_trees);
        let mut siblings_fri = per_query(n_queries, n_fri_trees);
        let mut last_levels_fri = Vec::with_capacity(n_fri_trees);
        for step in fri_steps.windows(2) {
            let group_size = (1usize << (step[0] - step[1])) * 3;
            for vals in &mut vals_fri {
                vals.push(reader.elements(group_size)?);
            }
            let levels = path_levels(step[1])?;
            for siblings in &mut siblings_fri {
                siblings.push(reader.merkle_path(levels, sibling_width)?);
            }
            if llv > 0 {
                last_levels_fri.push(reader.elements(last_level_len)?);
            }
        }

        let final_pol = reader.cubic_elements(1usize << fri_steps.last()?)?;
        let nonce = Goldilocks::new(reader.word()?);

        reader.words.is_empty().then_some(Self {
            publics,
            roots,
            evals,
            s0_vals,
            s0_siblings,
            s0_last_levels,
            roots_fri,
            vals_fri,
            siblings_fri,
            last_levels_fri,
            final_pol,
            nonce,
        })
    }
}

/// Recomputes the root of a tree with `n_leaves` leaves from its last-level nodes. A proof reserves
/// `arity^last_level_verification` node slots, and the ones the tree does not fill must be zero so
/// that the proof has a single encoding.
fn last_level_root<C: Poseidon2Constants<W>, const W: usize>(
    last_level: &[Goldilocks],
    n_leaves: u64,
    verifier_info: &VerifierInfo,
) -> Option<[Goldilocks; HASH_SIZE]> {
    let max_nodes = verifier_info.arity.pow(verifier_info.last_level_verification as u32);
    let mut n_nodes = n_leaves;
    while n_nodes > max_nodes {
        n_nodes = n_nodes.div_ceil(verifier_info.arity);
    }
    let (nodes, unused) = last_level.split_at(n_nodes as usize * HASH_SIZE);
    if unused.iter().any(|value| *value != Goldilocks::ZERO) {
        return None;
    }
    Some(partial_merkle_tree::<Goldilocks, C, W>(nodes, n_nodes, verifier_info.arity))
}

#[allow(clippy::type_complexity)]
pub fn stark_verify<C: Poseidon2Constants<W>, const W: usize>(
    proof: &[u8],
    vk: &[u8],
    verifier_info: &VerifierInfo,
    q_verify: fn(
        &[CubicExtensionField<Goldilocks>],
        &[CubicExtensionField<Goldilocks>],
        &[Goldilocks],
        &[CubicExtensionField<Goldilocks>],
    ) -> CubicExtensionField<Goldilocks>,
    queries_fri_verify: fn(
        &[CubicExtensionField<Goldilocks>],
        &[CubicExtensionField<Goldilocks>],
        &[Vec<Goldilocks>],
        &[CubicExtensionField<Goldilocks>],
    ) -> CubicExtensionField<Goldilocks>,
) -> bool {
    let Some(root_c) = field_words(vk).and_then(|vk| <[u64; HASH_SIZE]>::try_from(&*vk).ok()) else {
        tracing::error!("Verification key is not {} canonical field elements", HASH_SIZE);
        return false;
    };
    let root_c = root_c.map(Goldilocks::new);

    let Some(StarkProof {
        publics,
        roots,
        evals,
        s0_vals,
        s0_siblings,
        s0_last_levels,
        roots_fri,
        vals_fri,
        siblings_fri,
        last_levels_fri,
        final_pol,
        nonce,
    }) = field_words(proof).and_then(|words| StarkProof::parse(&words, verifier_info))
    else {
        tracing::error!("Proof is not a canonical encoding of a proof for this verifier");
        return false;
    };

    let n_queries = verifier_info.n_fri_queries as usize;

    let mut challenges = vec![
        CubicExtensionField { value: [Goldilocks::ZERO, Goldilocks::ZERO, Goldilocks::ZERO] };
        verifier_info.n_challenges_total as usize
    ];

    let mut xdivxsub: Vec<Vec<CubicExtensionField<Goldilocks>>> = Vec::with_capacity(n_queries);

    let mut transcript: Transcript<Goldilocks, Poseidon16, 16> = Transcript::new();
    transcript.put(&root_c);
    if !publics.is_empty() {
        if !verifier_info.hash_commits {
            transcript.put(&publics);
        } else {
            let mut transcript_publics: Transcript<Goldilocks, Poseidon16, 16> = Transcript::new();
            transcript_publics.put(&publics);
            let hash = transcript_publics.get_state();
            transcript.put(&hash[0..4]);
        }
    }
    transcript.put(&roots[0]);
    transcript.get_field(&mut challenges[0].value);
    transcript.get_field(&mut challenges[1].value);

    transcript.put(&roots[1]);
    transcript.get_field(&mut challenges[2].value);
    transcript.put(&roots[2]);

    transcript.get_field(&mut challenges[3].value);

    if !verifier_info.hash_commits {
        for i in 0..verifier_info.n_evals {
            transcript.put(&evals[i as usize].value);
        }
    } else {
        let mut transcript_evals: Transcript<Goldilocks, Poseidon16, 16> = Transcript::new();
        for i in 0..verifier_info.n_evals {
            transcript_evals.put(&evals[i as usize].value);
        }
        let hash = transcript_evals.get_state();
        transcript.put(&hash[0..4]);
    }

    transcript.get_field(&mut challenges[4].value);
    transcript.get_field(&mut challenges[5].value);

    let mut c = 6;
    for i in 0..verifier_info.n_fri_steps {
        if i > 0 {
            transcript.get_field(&mut challenges[c].value);
        }
        c += 1;
        if i < verifier_info.n_fri_steps - 1 {
            transcript.put(&roots_fri[i as usize]);
        } else {
            let final_pol_size = 1 << verifier_info.fri_steps[i as usize];
            if !verifier_info.hash_commits {
                for j in 0..final_pol_size {
                    transcript.put(&final_pol[j as usize].value);
                }
            } else {
                let mut transcript_final_pol: Transcript<Goldilocks, Poseidon16, 16> = Transcript::new();
                for j in 0..final_pol_size {
                    transcript_final_pol.put(&final_pol[j as usize].value);
                }
                let hash = transcript_final_pol.get_state();
                transcript.put(&hash[0..4]);
            }
        }
    }

    // The grinding hash and the query indices are read from the last challenge slot, which must be
    // the slot the transcript writes next: otherwise the queries would come from a zero challenge
    // the prover can predict.
    let last_challenge_index = challenges.len() - 1;
    if c != last_challenge_index {
        tracing::error!(
            "verifier_info is inconsistent: the transcript writes {} challenges but {} are declared",
            c + 1,
            challenges.len()
        );
        return false;
    }
    transcript.get_field(&mut challenges[c].value);
    let pow_hash = poseidon2_hash::<Goldilocks, Poseidon4, 4>(&[
        challenges[last_challenge_index].value[0],
        challenges[last_challenge_index].value[1],
        challenges[last_challenge_index].value[2],
        nonce,
    ]);
    if pow_hash[0].as_canonical_u64() >= 1 << (64 - verifier_info.pow_bits) {
        tracing::error!("Proof of work verification failed");
        return false;
    }
    let mut transcript_permutation: Transcript<Goldilocks, Poseidon16, 16> = Transcript::new();
    transcript_permutation.put(&challenges[last_challenge_index].value);
    transcript_permutation.put(&[nonce]);
    let fri_queries = transcript_permutation.get_permutations(verifier_info.n_fri_queries, verifier_info.fri_steps[0]);

    let xi_challenge = challenges[verifier_info.n_challenges as usize - 3];

    let w_ext = Goldilocks::new(Goldilocks::W[verifier_info.n_bits_ext as usize]);
    let w_bits = Goldilocks::new(Goldilocks::W[verifier_info.n_bits as usize]);
    let n_opening_points = verifier_info.opening_points.len();

    for &fri_query in fri_queries.iter().take(n_queries) {
        let mut query_xdivxsub = Vec::with_capacity(n_opening_points);
        let x = CubicExtensionField {
            value: [Goldilocks::new(Goldilocks::SHIFT) * w_ext.exp_u64(fri_query), Goldilocks::ZERO, Goldilocks::ZERO],
        };
        for o in 0..n_opening_points {
            let mut wi = Goldilocks::ONE;
            let abs_opening = verifier_info.opening_points[o].unsigned_abs();
            for _ in 0..abs_opening {
                wi *= w_bits;
            }

            if verifier_info.opening_points[o] < 0 {
                wi = wi.inverse();
            }

            query_xdivxsub.push((x - (xi_challenge * wi)).inverse());
        }
        xdivxsub.push(query_xdivxsub);
    }

    let x_n = xi_challenge.pow(1 << verifier_info.n_bits);

    // Only the everyRow zerofier is computed.
    if verifier_info.boundaries.iter().any(|boundary| boundary.name != "everyRow") {
        tracing::error!("verifier_info declares a boundary other than everyRow");
        return false;
    }
    let z_n = x_n - Goldilocks::ONE;
    let zi = [z_n.inverse()];

    let mut final_pol_vals: Vec<Goldilocks> = Vec::with_capacity(final_pol.len() * 3);
    for pol in &final_pol {
        final_pol_vals.extend_from_slice(&pol.value);
    }

    tracing::debug!("Verifying proof");

    let all_valid = (0..n_queries).into_par_iter().all(|q| {
        // 1) Fixed MT
        if !verify_mt::<Goldilocks, C, W>(
            &root_c,
            &s0_last_levels[0],
            &s0_siblings[q][0],
            fri_queries[q],
            &s0_vals[q][0],
            verifier_info.arity,
            verifier_info.last_level_verification,
        ) {
            tracing::error!("Fixed MT verification failed for query {}", q);
            return false;
        }

        // 2) stage MTs
        for (s, root) in roots.iter().enumerate().take(verifier_info.n_stages as usize + 1) {
            if !verify_mt::<Goldilocks, C, W>(
                root,
                &s0_last_levels[s + 1],
                &s0_siblings[q][s + 1],
                fri_queries[q],
                &s0_vals[q][s + 1],
                verifier_info.arity,
                verifier_info.last_level_verification,
            ) {
                tracing::error!("Stage MT verification failed for query {}", q);
                return false;
            }
        }

        // 3) FRI Query
        let idx = fri_queries[q] % (1 << verifier_info.fri_steps[0]);
        let query_fri = queries_fri_verify(&challenges, &evals, &s0_vals[q], &xdivxsub[q]);

        let valid_query = if verifier_info.n_fri_steps > 1 {
            let group_idx = (idx / (1 << verifier_info.fri_steps[1])) as usize;
            query_fri[0] == vals_fri[q][0][group_idx * 3]
                && query_fri[1] == vals_fri[q][0][group_idx * 3 + 1]
                && query_fri[2] == vals_fri[q][0][group_idx * 3 + 2]
        } else {
            query_fri == final_pol[idx as usize]
        };
        if !valid_query {
            tracing::error!("FRI query verification failed for query {}", q);
            return false;
        }

        // 4) FRI folding && MT
        for s in 0..verifier_info.n_fri_steps - 1 {
            let idx = fri_queries[q] % (1 << verifier_info.fri_steps[s as usize + 1]);
            if !verify_mt::<Goldilocks, C, W>(
                &roots_fri[s as usize],
                &last_levels_fri[s as usize],
                &siblings_fri[q][s as usize],
                idx,
                &vals_fri[q][s as usize],
                verifier_info.arity,
                verifier_info.last_level_verification,
            ) {
                tracing::error!("FRI step MT verification failed for query {}", q);
                return false;
            }

            let value = verify_fold(
                verifier_info.n_bits_ext,
                verifier_info.fri_steps[s as usize + 1],
                verifier_info.fri_steps[s as usize],
                challenges[verifier_info.n_challenges as usize + s as usize + 1],
                idx,
                &vals_fri[q][s as usize],
            );

            if s as usize + 1 < verifier_info.n_fri_steps as usize - 1 {
                let group_idx = (idx / (1 << verifier_info.fri_steps[s as usize + 2])) as usize;
                for (i, val) in value.iter().enumerate().take(3usize) {
                    if vals_fri[q][s as usize + 1][group_idx * 3 + i] != *val {
                        tracing::error!("FRI foldings verification failed at step {} for query {}", s as usize + 1, q,);
                        return false;
                    }
                }
            } else {
                for (i, val) in value.iter().enumerate().take(3usize) {
                    if final_pol[idx as usize][i] != *val {
                        tracing::error!("Final polynomial verification failed at index {} for query {}", idx, q,);
                        return false;
                    }
                }
            }
        }

        true
    });

    if !all_valid {
        return false;
    }

    if verifier_info.last_level_verification > 0 {
        let n_leaves = 1 << verifier_info.n_bits_ext;
        if last_level_root::<C, W>(&s0_last_levels[0], n_leaves, verifier_info) != Some(root_c) {
            tracing::error!("Stage fixed Merkle tree root recomputation failed");
            return false;
        }
        for (s, root) in roots.iter().enumerate() {
            if last_level_root::<C, W>(&s0_last_levels[s + 1], n_leaves, verifier_info).as_ref() != Some(root) {
                tracing::error!("Stage {} Merkle tree root recomputation failed", s + 1);
                return false;
            }
        }
        for (s, root) in roots_fri.iter().enumerate() {
            let n_leaves = 1 << verifier_info.fri_steps[s + 1];
            if last_level_root::<C, W>(&last_levels_fri[s], n_leaves, verifier_info).as_ref() != Some(root) {
                tracing::error!("Stage {} FRI Merkle tree root recomputation failed", s + 1);
                return false;
            }
        }
    }

    tracing::debug!("Verifying Quotient polynomial");
    let mut x_acc = CubicExtensionField { value: [Goldilocks::ONE, Goldilocks::ZERO, Goldilocks::ZERO] };
    let mut q = CubicExtensionField { value: [Goldilocks::ZERO, Goldilocks::ZERO, Goldilocks::ZERO] };
    for i in 0..verifier_info.q_deg {
        q += x_acc * evals[(verifier_info.q_index + i) as usize];
        x_acc *= x_n;
    }

    let q_val = q_verify(&challenges, &evals, &publics, &zi);
    if q_val != q {
        tracing::error!("Quotient polynomial verification failed");
        return false;
    }
    tracing::debug!("Quotient polynomial verification passed");

    tracing::debug!("Verifying final polynomial");
    let terminal_bits = verifier_info.fri_steps[(verifier_info.n_fri_steps - 1) as usize];
    intt_tiny(&mut final_pol_vals, terminal_bits as usize, 3);
    // The terminal layer holds 2^terminal_bits evaluations at the committed rate, so the polynomial
    // must have degree below 2^(terminal_bits - blowup bits). This check is what bounds the degree
    // FRI proves, so a terminal layer smaller than the blowup is refused rather than skipped.
    let Some(degree_bits) = terminal_bits.checked_sub(verifier_info.n_bits_ext - verifier_info.n_bits) else {
        tracing::error!(
            "FRI terminal layer 2^{} is smaller than the blowup 2^{}",
            terminal_bits,
            verifier_info.n_bits_ext - verifier_info.n_bits
        );
        return false;
    };
    for i in (1usize << degree_bits)..final_pol.len() {
        for j in 0..3usize {
            if final_pol_vals[i * 3 + j] != Goldilocks::ZERO {
                tracing::error!("Final polynomial has non-zero value at index {}: {:?}", i, final_pol_vals[i * 3 + j]);
                return false;
            }
        }
    }
    tracing::debug!("Final polynomial verification passed");
    tracing::debug!("Proof verification succeeded");

    true
}

#[cfg(test)]
mod tests {
    use super::*;
    use fields::Poseidon8;

    fn zero_q_verify(
        _challenges: &[CubicExtensionField<Goldilocks>],
        _evals: &[CubicExtensionField<Goldilocks>],
        _publics: &[Goldilocks],
        _zi: &[CubicExtensionField<Goldilocks>],
    ) -> CubicExtensionField<Goldilocks> {
        CubicExtensionField { value: [Goldilocks::ZERO; 3] }
    }

    fn zero_query_verify(
        _challenges: &[CubicExtensionField<Goldilocks>],
        _evals: &[CubicExtensionField<Goldilocks>],
        _vals: &[Vec<Goldilocks>],
        _xdivxsub: &[CubicExtensionField<Goldilocks>],
    ) -> CubicExtensionField<Goldilocks> {
        CubicExtensionField { value: [Goldilocks::ZERO; 3] }
    }

    /// A shape small enough to lay out its proof by hand. The proof is 94 words: the public count
    /// and 1 public, 3 stage roots (12), 1 evaluation (3), 4 query trees of 1 value, a 1-level
    /// path (4) and a last level (8) each (52), 1 FRI root (4), 1 FRI tree of a 6-value group and a
    /// last level (14), the final polynomial (6) and the nonce.
    fn tiny_info() -> VerifierInfo {
        VerifierInfo {
            n_stages: 2,
            n_publics: 1,
            n_constants: 1,
            n_evals: 1,
            n_bits: 1,
            n_bits_ext: 2,
            arity: 2,
            n_fri_queries: 1,
            n_fri_steps: 2,
            n_challenges: 6,
            n_challenges_total: 9,
            fri_steps: vec![2, 1],
            hash_commits: false,
            num_vals: vec![1, 1, 1],
            opening_points: vec![0],
            boundaries: vec![Boundary { name: "everyRow".to_string(), offset_min: None, offset_max: None }],
            q_deg: 1,
            q_index: 0,
            last_level_verification: 1,
            pow_bits: 1,
        }
    }

    const TINY_PROOF_WORDS: usize = 94;

    fn verify(proof: &[u8], vk: &[u8], info: &VerifierInfo) -> bool {
        stark_verify::<Poseidon8, 8>(proof, vk, info, zero_q_verify, zero_query_verify)
    }

    fn to_bytes(words: &[u64]) -> Vec<u8> {
        words.iter().flat_map(|word| word.to_le_bytes()).collect()
    }

    #[test]
    fn malformed_proofs_are_rejected_without_panicking() {
        let info = tiny_info();
        let mut words = vec![0u64; TINY_PROOF_WORDS];
        words[0] = info.n_publics;
        let vk = to_bytes(&[0; HASH_SIZE]);

        // Only a proof of exactly the shape's length, with the AIR's public count, parses.
        assert!(StarkProof::parse(&words, &info).is_some());
        assert!(StarkProof::parse(&words[..TINY_PROOF_WORDS - 1], &info).is_none());
        assert!(StarkProof::parse(&[words.as_slice(), &[0]].concat(), &info).is_none());
        let mut wrong_count = words.clone();
        wrong_count[0] += 1;
        assert!(StarkProof::parse(&wrong_count, &info).is_none());

        // Words decode at any alignment, but only whole and canonical ones.
        let bytes = to_bytes(&words);
        let mut shifted = vec![0u8; bytes.len() + 1];
        shifted[1..].copy_from_slice(&bytes);
        assert_eq!(field_words(&shifted[1..]).as_deref(), Some(words.as_slice()));
        assert!(field_words(&shifted[1..bytes.len()]).is_none());
        let mut non_canonical = words.clone();
        non_canonical[TINY_PROOF_WORDS - 1] = Goldilocks::ORDER_U64;
        assert!(field_words(&to_bytes(&non_canonical)).is_none());

        // Neither any prefix nor an extension of a proof, at any alignment, nor a malformed key
        // makes verification panic.
        for len in 0..=bytes.len() {
            assert!(!verify(&bytes[..len], &vk, &info));
            assert!(!verify(&shifted[1..len + 1], &vk, &info));
        }
        assert!(!verify(&[bytes.as_slice(), &[0; 8]].concat(), &vk, &info));
        assert!(!verify(&bytes, &vk[..HASH_SIZE * 8 - 1], &info));
        assert!(!verify(&bytes, &[vk.as_slice(), &[0; 8]].concat(), &info));
    }
}
